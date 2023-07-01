local ENV = os.getenv("ENV")

local DARKLUA_CONFIG = "ci/darklua.json"
local MODEL_PATH = "dist/main.rbxm"
local SOURCE_PATH = ENV == "production" and "dist/main.lua" or "dist/main-dev.lua"
local TEMP_FILE = "dist/temp.lua"

local declarations = ""

---Minifies the given text by processing it through darklua.
---@param text string
---@return string
local function minify(text)
	remodel.writeFile(TEMP_FILE, text)
	os.execute("darklua process " .. TEMP_FILE .. " " .. TEMP_FILE .. " --config " .. DARKLUA_CONFIG)
	local value = remodel.readFile(TEMP_FILE)
	os.remove(TEMP_FILE)
	return value
end

---Declare a script in the source output.
---@param instance LocalScript | ModuleScript
local function declareScript(instance)
	local context = string.format("%q", instance:GetFullName())
	local source = remodel.getRawProperty(instance, "Source")

	declarations = declarations .. string.format(
		"__lua(%s, %s, %s, %s, function()\n\t",
		string.format("%q", instance.Name),
		string.format("%q", instance.ClassName),
		context,
		instance.Parent and string.format("%q", instance.Parent:GetFullName()) or "nil"
	)

	if ENV == "production" then
		declarations = declarations .. string.format("local _=__env(%s)local script,require=_.script,_.require %s", context, source)
	else
		-- pass local '__env' through vararg, format as Lua string, escape newlines
		source = string.format("local _=(...)(%s)local script,require=_.script,_.require %s", context, source)
		source = string.gsub(string.format("%q", source), "\\\n", "\\n")

		declarations = declarations .. string.format("return assert(loadstring(%s, %s))(__env)", source, context)
	end

	declarations = declarations .. "\nend)\n"
end

---Declare a single Roblox instance in the source output. Does not set properties.
---@param instance Instance
local function declareInstance(instance)
	declarations = declarations .. string.format(
		"__rbx(%s, %s, %s, %s)\n",
		string.format("%q", instance.Name),
		string.format("%q", instance.ClassName),
		string.format("%q", instance:GetFullName()),
		instance.Parent and string.format("%q", instance.Parent:GetFullName()) or "nil"
	)
end

---Declare a Roblox instance and its descendants in the source output.
---@param instance Instance
local function declareDescendants(instance)
	if instance.ClassName == "LocalScript" or instance.ClassName == "ModuleScript" then
		declareScript(instance)
	else
		declareInstance(instance)
	end

	for _, child in ipairs(instance:GetChildren()) do
		declareDescendants(child)
	end
end

---Bundles the contents of the model file and appends it to the runtime library.
---Minifies the source if `ENV` is "production".
local function bundle()
	declareDescendants(remodel.readModelFile(MODEL_PATH)[1])

	local header = remodel.readFile("ci/include/header.lua")
	local runtime = remodel.readFile("ci/include/runtime.lua")

	local source = "\n" .. runtime .. "\n\n" .. declarations .. "__start()\n"

	if ENV == "production" then
		source = minify(source)
	end

	remodel.writeFile(SOURCE_PATH, header .. "\n" .. source)
end

bundle()