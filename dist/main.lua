--[[
-- Script Viewer.
--
--
-- By AltLexon
--]]

local instances = {}
local modules = {}
local currentlyLoading = {}

local function runModule(object, context)
	currentlyLoading[context] = object

	local currentObject = object
	local depth = 0

	while currentObject do
		depth = depth + 1
		currentObject = currentlyLoading[currentObject]

		if currentObject == object then
			local str = currentObject.Name

			for _ = 1, depth do
				currentObject = currentlyLoading[currentObject]
				str = str .. "  ⇒ " .. currentObject.Name
			end

			error("Failed to load '" .. object.Name .. "'; Detected a circular dependency chain: " .. str, 2)
		end
	end

	local module = modules[object]
	local data = module.callback()

	if currentlyLoading[context] == object then
		currentlyLoading[context] = nil
	end

	return data
end

local function requireModule(object, context)
	local module = modules[object]

	if module.loaded then
		return module.result
	else
		module.result = runModule(object, context)
		module.loaded = true
		return module.result
	end
end

local function __rbx(name, className, path, parentPath)
	local rbx = Instance.new(className)
	rbx.Name = name
	rbx.Parent = instances[parentPath]
	instances[path] = rbx
	return rbx
end

local function __lua(name, className, path, parentPath, callback)
	local rbx = __rbx(name, className, path, parentPath)

	modules[rbx] = {
		callback = callback,
		result = nil,
		loaded = false,
		globals = {
			script = rbx,
			require = function(object)
				if modules[object] then
					return requireModule(object, rbx)
				else
					return require(object)
				end
			end,
		},
	}
end

local function __env(path)
	return modules[instances[path]].globals
end

local function __start()
	for rbx, module in pairs(modules) do
		if rbx.ClassName == "LocalScript" and not rbx.Disabled then
			task.spawn(module.callback)
		end
	end
end

__lua("roblox-ts-game", "LocalScript", "roblox-ts-game", nil, function()
	local _=__env("roblox-ts-game")local script,require=_.script,_.require -- Compiled with roblox-ts v2.1.0
local TS = require(script.rbxts_include.RuntimeLib)
local _services = TS.import(script, script, "rbxts_include", "node_modules", "@rbxts", "services")
local Players = _services.Players
local TweenService = _services.TweenService
local _roact = TS.import(script, script, "rbxts_include", "node_modules", "@rbxts", "roact", "src")
local mount = _roact.mount
local unmount = _roact.unmount
local refresh = TS.import(script, script, "shared", "stuff").refresh
local mainUI = TS.import(script, script, "shared", "GUI", "main").default
local UI_Name = "Files-Viewer"
getgenv()["Files-Viewer"] = {}
local Files_Viewer_Table = getgenv()["Files-Viewer"]
Files_Viewer_Table["_ Selected"] = nil
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
local RoactTree = mount(mainUI, PlayerGui, UI_Name)
local RoactInstance = PlayerGui:WaitForChild(UI_Name)
local Main = RoactInstance:WaitForChild("Main")
local List = Main:WaitForChild("Files")
TweenService:Create(Main, TweenInfo.new(1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
	Position = UDim2.fromScale(0.5, 0.5),
}):Play()
LocalPlayer.CharacterRemoving:Connect(function()
	unmount(RoactTree)
end)
while List ~= nil do
	refresh(List)
	task.wait(30)
end

end)
__rbx("shared", "Folder", "roblox-ts-game.shared", "roblox-ts-game")
__rbx("GUI", "Folder", "roblox-ts-game.shared.GUI", "roblox-ts-game.shared")
__lua("button", "ModuleScript", "roblox-ts-game.shared.GUI.button", "roblox-ts-game.shared.GUI", function()
	local _=__env("roblox-ts-game.shared.GUI.button")local script,require=_.script,_.require -- Compiled with roblox-ts v2.1.0
local TS = require(script.Parent.Parent.Parent.rbxts_include.RuntimeLib)
local Roact = TS.import(script, script.Parent.Parent.Parent, "rbxts_include", "node_modules", "@rbxts", "roact", "src")
local templateButton = Roact.createElement("TextButton", {
	Size = UDim2.new(0.95, 0, 0, 40),
	BackgroundColor3 = Color3.fromRGB(16, 16, 16),
	AnchorPoint = Vector2.new(0.5, 0.5),
	Text = "",
	AutoButtonColor = false,
	[Roact.Event.Activated] = function(rbx)
		local Files_Viewer_Table = (getgenv()["Files-Viewer"])
		local oldButton = Files_Viewer_Table["_ Selected"]
		if oldButton ~= nil and (oldButton:IsA("TextButton") and oldButton:FindFirstChildOfClass("TextLabel")) then
			local Label = oldButton:FindFirstChildOfClass("TextLabel")
			Label.Text = string.split(Label.Text, " -")[1]
		end
		local _rbx = rbx
		Files_Viewer_Table["_ Selected"] = _rbx;
		(rbx:FindFirstChildOfClass("TextLabel")).Text ..= " - Selected"
	end,
}, {
	Roact.createElement("UICorner", {
		CornerRadius = UDim.new(0, 8),
	}),
	Roact.createElement("TextLabel", {
		Size = UDim2.new(0.8, 0, 0.8, 0),
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Text = "📁 ",
		TextScaled = true,
		BackgroundTransparency = 1,
		Font = "Ubuntu",
	}),
})
local default = templateButton
return {
	default = default,
}

end)
__lua("main", "ModuleScript", "roblox-ts-game.shared.GUI.main", "roblox-ts-game.shared.GUI", function()
	local _=__env("roblox-ts-game.shared.GUI.main")local script,require=_.script,_.require -- Compiled with roblox-ts v2.1.0
local TS = require(script.Parent.Parent.Parent.rbxts_include.RuntimeLib)
local Roact = TS.import(script, script.Parent.Parent.Parent, "rbxts_include", "node_modules", "@rbxts", "roact", "src")
local _stuff = TS.import(script, script.Parent.Parent, "stuff")
local getClass = _stuff.getClass
local refresh = _stuff.refresh
local mainUI = Roact.createElement("ScreenGui", {}, {
	Main = Roact.createElement("Frame", {
		BackgroundColor3 = Color3.fromRGB(24, 24, 24),
		Size = UDim2.fromScale(0.3, 0.5),
		Position = UDim2.fromScale(0.5, 1.5),
		AnchorPoint = Vector2.new(0.5, 0.5),
	}, {
		Roact.createElement("UICorner", {
			CornerRadius = UDim.new(0, 10),
		}),
		Files = Roact.createElement("ScrollingFrame", {
			Size = UDim2.fromScale(1, 0.87),
			Position = UDim2.fromScale(0, 0.105),
			BackgroundTransparency = 1,
			ScrollBarThickness = 1,
			BorderSizePixel = 0,
			CanvasSize = UDim2.new(),
		}, {
			Roact.createElement("UIListLayout", {
				Padding = UDim.new(0, 5),
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = "Custom",
			}),
		}),
		Top = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0.1, 0),
		}, {
			Delete = Roact.createElement("TextButton", {
				BackgroundColor3 = Color3.fromRGB(150, 0, 0),
				Size = UDim2.fromScale(0.25, 0.75),
				Position = UDim2.fromScale(0.15, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Text = "",
				[Roact.Event.Activated] = function(rbx)
					local Files_Viewer_Table = (getgenv()["Files-Viewer"])
					local Button = Files_Viewer_Table["_ Selected"]
					local FileName = Button.Name
					local Type = getClass(FileName)
					if Type == "Folder" then
						delfolder(FileName)
					elseif Type == "File" then
						delfile(FileName)
					end
					refresh(Button.Parent)
				end,
			}, {
				Roact.createElement("UICorner", {
					CornerRadius = UDim.new(0, 13),
				}),
				[""] = Roact.createElement("TextLabel", {
					Text = "✖ Delete",
					AnchorPoint = Vector2.new(0.5, 0.5),
					Size = UDim2.fromScale(0.8, 0.8),
					Position = UDim2.fromScale(0.5, 0.5),
					BackgroundTransparency = 1,
					TextScaled = true,
					Font = "Ubuntu",
					TextColor3 = Color3.fromRGB(255, 255, 255),
				}),
			}),
		}),
	}),
})
local default = mainUI
return {
	default = default,
}

end)
__lua("stuff", "ModuleScript", "roblox-ts-game.shared.stuff", "roblox-ts-game.shared", function()
	local _=__env("roblox-ts-game.shared.stuff")local script,require=_.script,_.require -- Compiled with roblox-ts v2.1.0
local TS = require(script.Parent.Parent.rbxts_include.RuntimeLib)
local mount = TS.import(script, script.Parent.Parent, "rbxts_include", "node_modules", "@rbxts", "roact", "src").mount
local templateButton = TS.import(script, script.Parent, "GUI", "button").default
local function getClass(file_name)
	local Type = "Unknown"
	if isfolder(file_name) then
		Type = "Folder"
	elseif isfile(file_name) then
		Type = "File"
	end
	return Type
end
local function getFiles(WorkspaceFiles)
	local Folders = {}
	local Files = {}
	local Unknown = {}
	for _, v in pairs(WorkspaceFiles) do
		local FileName = string.gsub(v, "\\", "")
		local FileType = getClass(FileName)
		if FileType == "Folder" then
			local _arg0 = #Folders
			table.insert(Folders, _arg0 + 1, FileName)
		elseif FileType == "File" then
			local _arg0 = #Files
			table.insert(Files, _arg0 + 1, FileName)
		elseif FileType == "Unknown" then
			local _arg0 = #Unknown
			table.insert(Unknown, _arg0 + 1, FileName)
		end
	end
	return { Folders, Files, Unknown }
end
local function setUpButton(_button, _type, _filename)
	local StartByType = {
		Folder = { Color3.fromRGB(255, 139, 48), "📂 " },
		File = { Color3.fromRGB(255, 255, 255), "📜 " },
		Unknown = { Color3.fromRGB(230, 230, 230), "❓ " },
	}
	local Label = _button:FindFirstChildOfClass("TextLabel")
	if _type == "Folder" then
		Label.Text = (StartByType.Folder)[2]
		Label.TextColor3 = (StartByType.Folder)[1]
	elseif _type == "File" then
		Label.Text = (StartByType.File)[2]
		Label.TextColor3 = (StartByType.File)[1]
	elseif _type == "Unknown" then
		Label.Text = (StartByType.Unknown)[2]
		Label.TextColor3 = (StartByType.Unknown)[1]
	end
	Label.Text ..= _filename
end
local function convertData(list, _table, _type)
	local ButtonName
	for _, v in pairs(_table) do
		ButtonName = v
		if list:FindFirstChild(ButtonName) then
			do
				local i = 1
				local _shouldIncrement = false
				while true do
					if _shouldIncrement then
						i += 1
					else
						_shouldIncrement = true
					end
					if not (i < 5) then
						break
					end
					if not list:FindFirstChild(ButtonName .. tostring(i)) then
						ButtonName = ButtonName .. tostring(i)
						break
					end
				end
			end
		end
		list.CanvasSize = UDim2.new(0, 0, 0, list.CanvasSize.Y.Offset + 45)
		mount(templateButton, list, ButtonName)
		setUpButton(list:WaitForChild(ButtonName), _type, v)
	end
end
local function refresh(List)
	for _, v in pairs(List:GetChildren()) do
		if v:IsA("UIListLayout") then
			continue
		end
		v:Destroy()
	end
	List.CanvasSize = UDim2.new(0, 0, 0, 0)
	local WorkspaceFiles = listfiles("")
	local _binding = getFiles(WorkspaceFiles)
	local Folders = _binding[1]
	local Files = _binding[2]
	local Unknown = _binding[3]
	convertData(List, Folders, "Folder")
	convertData(List, Files, "File")
	convertData(List, Unknown, "Unknown")
end
return {
	getClass = getClass,
	refresh = refresh,
}

end)
__rbx("rbxts_include", "Folder", "roblox-ts-game.rbxts_include", "roblox-ts-game")
__lua("Promise", "ModuleScript", "roblox-ts-game.rbxts_include.Promise", "roblox-ts-game.rbxts_include", function()
	local _=__env("roblox-ts-game.rbxts_include.Promise")local script,require=_.script,_.require --[[
	An implementation of Promises similar to Promise/A+.
]]

local ERROR_NON_PROMISE_IN_LIST = "Non-promise value passed into %s at index %s"
local ERROR_NON_LIST = "Please pass a list of promises to %s"
local ERROR_NON_FUNCTION = "Please pass a handler function to %s!"
local MODE_KEY_METATABLE = { __mode = "k" }

local function isCallable(value)
	if type(value) == "function" then
		return true
	end

	if type(value) == "table" then
		local metatable = getmetatable(value)
		if metatable and type(rawget(metatable, "__call")) == "function" then
			return true
		end
	end

	return false
end

--[[
	Creates an enum dictionary with some metamethods to prevent common mistakes.
]]
local function makeEnum(enumName, members)
	local enum = {}

	for _, memberName in ipairs(members) do
		enum[memberName] = memberName
	end

	return setmetatable(enum, {
		__index = function(_, k)
			error(string.format("%s is not in %s!", k, enumName), 2)
		end,
		__newindex = function()
			error(string.format("Creating new members in %s is not allowed!", enumName), 2)
		end,
	})
end

--[=[
	An object to represent runtime errors that occur during execution.
	Promises that experience an error like this will be rejected with
	an instance of this object.

	@class Error
]=]
local Error
do
	Error = {
		Kind = makeEnum("Promise.Error.Kind", {
			"ExecutionError",
			"AlreadyCancelled",
			"NotResolvedInTime",
			"TimedOut",
		}),
	}
	Error.__index = Error

	function Error.new(options, parent)
		options = options or {}
		return setmetatable({
			error = tostring(options.error) or "[This error has no error text.]",
			trace = options.trace,
			context = options.context,
			kind = options.kind,
			parent = parent,
			createdTick = os.clock(),
			createdTrace = debug.traceback(),
		}, Error)
	end

	function Error.is(anything)
		if type(anything) == "table" then
			local metatable = getmetatable(anything)

			if type(metatable) == "table" then
				return rawget(anything, "error") ~= nil and type(rawget(metatable, "extend")) == "function"
			end
		end

		return false
	end

	function Error.isKind(anything, kind)
		assert(kind ~= nil, "Argument #2 to Promise.Error.isKind must not be nil")

		return Error.is(anything) and anything.kind == kind
	end

	function Error:extend(options)
		options = options or {}

		options.kind = options.kind or self.kind

		return Error.new(options, self)
	end

	function Error:getErrorChain()
		local runtimeErrors = { self }

		while runtimeErrors[#runtimeErrors].parent do
			table.insert(runtimeErrors, runtimeErrors[#runtimeErrors].parent)
		end

		return runtimeErrors
	end

	function Error:__tostring()
		local errorStrings = {
			string.format("-- Promise.Error(%s) --", self.kind or "?"),
		}

		for _, runtimeError in ipairs(self:getErrorChain()) do
			table.insert(
				errorStrings,
				table.concat({
					runtimeError.trace or runtimeError.error,
					runtimeError.context,
				}, "\n")
			)
		end

		return table.concat(errorStrings, "\n")
	end
end

--[[
	Packs a number of arguments into a table and returns its length.

	Used to cajole varargs without dropping sparse values.
]]
local function pack(...)
	return select("#", ...), { ... }
end

--[[
	Returns first value (success), and packs all following values.
]]
local function packResult(success, ...)
	return success, select("#", ...), { ... }
end

local function makeErrorHandler(traceback)
	assert(traceback ~= nil, "traceback is nil")

	return function(err)
		-- If the error object is already a table, forward it directly.
		-- Should we extend the error here and add our own trace?

		if type(err) == "table" then
			return err
		end

		return Error.new({
			error = err,
			kind = Error.Kind.ExecutionError,
			trace = debug.traceback(tostring(err), 2),
			context = "Promise created at:\n\n" .. traceback,
		})
	end
end

--[[
	Calls a Promise executor with error handling.
]]
local function runExecutor(traceback, callback, ...)
	return packResult(xpcall(callback, makeErrorHandler(traceback), ...))
end

--[[
	Creates a function that invokes a callback with correct error handling and
	resolution mechanisms.
]]
local function createAdvancer(traceback, callback, resolve, reject)
	return function(...)
		local ok, resultLength, result = runExecutor(traceback, callback, ...)

		if ok then
			resolve(unpack(result, 1, resultLength))
		else
			reject(result[1])
		end
	end
end

local function isEmpty(t)
	return next(t) == nil
end

--[=[
	An enum value used to represent the Promise's status.
	@interface Status
	@tag enum
	@within Promise
	.Started "Started" -- The Promise is executing, and not settled yet.
	.Resolved "Resolved" -- The Promise finished successfully.
	.Rejected "Rejected" -- The Promise was rejected.
	.Cancelled "Cancelled" -- The Promise was cancelled before it finished.
]=]
--[=[
	@prop Status Status
	@within Promise
	@readonly
	@tag enums
	A table containing all members of the `Status` enum, e.g., `Promise.Status.Resolved`.
]=]
--[=[
	A Promise is an object that represents a value that will exist in the future, but doesn't right now.
	Promises allow you to then attach callbacks that can run once the value becomes available (known as *resolving*),
	or if an error has occurred (known as *rejecting*).

	@class Promise
	@__index prototype
]=]
local Promise = {
	Error = Error,
	Status = makeEnum("Promise.Status", { "Started", "Resolved", "Rejected", "Cancelled" }),
	_getTime = os.clock,
	_timeEvent = game:GetService("RunService").Heartbeat,
	_unhandledRejectionCallbacks = {},
}
Promise.prototype = {}
Promise.__index = Promise.prototype

function Promise._new(traceback, callback, parent)
	if parent ~= nil and not Promise.is(parent) then
		error("Argument #2 to Promise.new must be a promise or nil", 2)
	end

	local self = {
		-- Used to locate where a promise was created
		_source = traceback,

		_status = Promise.Status.Started,

		-- A table containing a list of all results, whether success or failure.
		-- Only valid if _status is set to something besides Started
		_values = nil,

		-- Lua doesn't like sparse arrays very much, so we explicitly store the
		-- length of _values to handle middle nils.
		_valuesLength = -1,

		-- Tracks if this Promise has no error observers..
		_unhandledRejection = true,

		-- Queues representing functions we should invoke when we update!
		_queuedResolve = {},
		_queuedReject = {},
		_queuedFinally = {},

		-- The function to run when/if this promise is cancelled.
		_cancellationHook = nil,

		-- The "parent" of this promise in a promise chain. Required for
		-- cancellation propagation upstream.
		_parent = parent,

		-- Consumers are Promises that have chained onto this one.
		-- We track them for cancellation propagation downstream.
		_consumers = setmetatable({}, MODE_KEY_METATABLE),
	}

	if parent and parent._status == Promise.Status.Started then
		parent._consumers[self] = true
	end

	setmetatable(self, Promise)

	local function resolve(...)
		self:_resolve(...)
	end

	local function reject(...)
		self:_reject(...)
	end

	local function onCancel(cancellationHook)
		if cancellationHook then
			if self._status == Promise.Status.Cancelled then
				cancellationHook()
			else
				self._cancellationHook = cancellationHook
			end
		end

		return self._status == Promise.Status.Cancelled
	end

	coroutine.wrap(function()
		local ok, _, result = runExecutor(self._source, callback, resolve, reject, onCancel)

		if not ok then
			reject(result[1])
		end
	end)()

	return self
end

--[=[
	Construct a new Promise that will be resolved or rejected with the given callbacks.

	If you `resolve` with a Promise, it will be chained onto.

	You can safely yield within the executor function and it will not block the creating thread.

	```lua
	local myFunction()
		return Promise.new(function(resolve, reject, onCancel)
			wait(1)
			resolve("Hello world!")
		end)
	end

	myFunction():andThen(print)
	```

	You do not need to use `pcall` within a Promise. Errors that occur during execution will be caught and turned into a rejection automatically. If `error()` is called with a table, that table will be the rejection value. Otherwise, string errors will be converted into `Promise.Error(Promise.Error.Kind.ExecutionError)` objects for tracking debug information.

	You may register an optional cancellation hook by using the `onCancel` argument:

	* This should be used to abort any ongoing operations leading up to the promise being settled.
	* Call the `onCancel` function with a function callback as its only argument to set a hook which will in turn be called when/if the promise is cancelled.
	* `onCancel` returns `true` if the Promise was already cancelled when you called `onCancel`.
	* Calling `onCancel` with no argument will not override a previously set cancellation hook, but it will still return `true` if the Promise is currently cancelled.
	* You can set the cancellation hook at any time before resolving.
	* When a promise is cancelled, calls to `resolve` or `reject` will be ignored, regardless of if you set a cancellation hook or not.

	@param executor (resolve: (...: any) -> (), reject: (...: any) -> (), onCancel: (abortHandler?: () -> ()) -> boolean) -> ()
	@return Promise
]=]
function Promise.new(executor)
	return Promise._new(debug.traceback(nil, 2), executor)
end

function Promise:__tostring()
	return string.format("Promise(%s)", self._status)
end

--[=[
	The same as [Promise.new](/api/Promise#new), except execution begins after the next `Heartbeat` event.

	This is a spiritual replacement for `spawn`, but it does not suffer from the same [issues](https://eryn.io/gist/3db84579866c099cdd5bb2ff37947cec) as `spawn`.

	```lua
	local function waitForChild(instance, childName, timeout)
	  return Promise.defer(function(resolve, reject)
		local child = instance:WaitForChild(childName, timeout)

		;(child and resolve or reject)(child)
	  end)
	end
	```

	@param executor (resolve: (...: any) -> (), reject: (...: any) -> (), onCancel: (abortHandler?: () -> ()) -> boolean) -> ()
	@return Promise
]=]
function Promise.defer(executor)
	local traceback = debug.traceback(nil, 2)
	local promise
	promise = Promise._new(traceback, function(resolve, reject, onCancel)
		local connection
		connection = Promise._timeEvent:Connect(function()
			connection:Disconnect()
			local ok, _, result = runExecutor(traceback, executor, resolve, reject, onCancel)

			if not ok then
				reject(result[1])
			end
		end)
	end)

	return promise
end

-- Backwards compatibility
Promise.async = Promise.defer

--[=[
	Creates an immediately resolved Promise with the given value.

	```lua
	-- Example using Promise.resolve to deliver cached values:
	function getSomething(name)
		if cache[name] then
			return Promise.resolve(cache[name])
		else
			return Promise.new(function(resolve, reject)
				local thing = getTheThing()
				cache[name] = thing

				resolve(thing)
			end)
		end
	end
	```

	@param ... any
	@return Promise<...any>
]=]
function Promise.resolve(...)
	local length, values = pack(...)
	return Promise._new(debug.traceback(nil, 2), function(resolve)
		resolve(unpack(values, 1, length))
	end)
end

--[=[
	Creates an immediately rejected Promise with the given value.

	:::caution
	Something needs to consume this rejection (i.e. `:catch()` it), otherwise it will emit an unhandled Promise rejection warning on the next frame. Thus, you should not create and store rejected Promises for later use. Only create them on-demand as needed.
	:::

	@param ... any
	@return Promise<...any>
]=]
function Promise.reject(...)
	local length, values = pack(...)
	return Promise._new(debug.traceback(nil, 2), function(_, reject)
		reject(unpack(values, 1, length))
	end)
end

--[[
	Runs a non-promise-returning function as a Promise with the
  given arguments.
]]
function Promise._try(traceback, callback, ...)
	local valuesLength, values = pack(...)

	return Promise._new(traceback, function(resolve)
		resolve(callback(unpack(values, 1, valuesLength)))
	end)
end

--[=[
	Begins a Promise chain, calling a function and returning a Promise resolving with its return value. If the function errors, the returned Promise will be rejected with the error. You can safely yield within the Promise.try callback.

	:::info
	`Promise.try` is similar to [Promise.promisify](#promisify), except the callback is invoked immediately instead of returning a new function.
	:::

	```lua
	Promise.try(function()
		return math.random(1, 2) == 1 and "ok" or error("Oh an error!")
	end)
		:andThen(function(text)
			print(text)
		end)
		:catch(function(err)
			warn("Something went wrong")
		end)
	```

	@param callback (...: T...) -> ...any
	@param ... T... -- Additional arguments passed to `callback`
	@return Promise
]=]
function Promise.try(callback, ...)
	return Promise._try(debug.traceback(nil, 2), callback, ...)
end

--[[
	Returns a new promise that:
		* is resolved when all input promises resolve
		* is rejected if ANY input promises reject
]]
function Promise._all(traceback, promises, amount)
	if type(promises) ~= "table" then
		error(string.format(ERROR_NON_LIST, "Promise.all"), 3)
	end

	-- We need to check that each value is a promise here so that we can produce
	-- a proper error rather than a rejected promise with our error.
	for i, promise in pairs(promises) do
		if not Promise.is(promise) then
			error(string.format(ERROR_NON_PROMISE_IN_LIST, "Promise.all", tostring(i)), 3)
		end
	end

	-- If there are no values then return an already resolved promise.
	if #promises == 0 or amount == 0 then
		return Promise.resolve({})
	end

	return Promise._new(traceback, function(resolve, reject, onCancel)
		-- An array to contain our resolved values from the given promises.
		local resolvedValues = {}
		local newPromises = {}

		-- Keep a count of resolved promises because just checking the resolved
		-- values length wouldn't account for promises that resolve with nil.
		local resolvedCount = 0
		local rejectedCount = 0
		local done = false

		local function cancel()
			for _, promise in ipairs(newPromises) do
				promise:cancel()
			end
		end

		-- Called when a single value is resolved and resolves if all are done.
		local function resolveOne(i, ...)
			if done then
				return
			end

			resolvedCount = resolvedCount + 1

			if amount == nil then
				resolvedValues[i] = ...
			else
				resolvedValues[resolvedCount] = ...
			end

			if resolvedCount >= (amount or #promises) then
				done = true
				resolve(resolvedValues)
				cancel()
			end
		end

		onCancel(cancel)

		-- We can assume the values inside `promises` are all promises since we
		-- checked above.
		for i, promise in ipairs(promises) do
			newPromises[i] = promise:andThen(function(...)
				resolveOne(i, ...)
			end, function(...)
				rejectedCount = rejectedCount + 1

				if amount == nil or #promises - rejectedCount < amount then
					cancel()
					done = true

					reject(...)
				end
			end)
		end

		if done then
			cancel()
		end
	end)
end

--[=[
	Accepts an array of Promises and returns a new promise that:
	* is resolved after all input promises resolve.
	* is rejected if *any* input promises reject.

	:::info
	Only the first return value from each promise will be present in the resulting array.
	:::

	After any input Promise rejects, all other input Promises that are still pending will be cancelled if they have no other consumers.

	```lua
	local promises = {
		returnsAPromise("example 1"),
		returnsAPromise("example 2"),
		returnsAPromise("example 3"),
	}

	return Promise.all(promises)
	```

	@param promises {Promise<T>}
	@return Promise<{T}>
]=]
function Promise.all(promises)
	return Promise._all(debug.traceback(nil, 2), promises)
end

--[=[
	Folds an array of values or promises into a single value. The array is traversed sequentially.

	The reducer function can return a promise or value directly. Each iteration receives the resolved value from the previous, and the first receives your defined initial value.

	The folding will stop at the first rejection encountered.
	```lua
	local basket = {"blueberry", "melon", "pear", "melon"}
	Promise.fold(basket, function(cost, fruit)
		if fruit == "blueberry" then
			return cost -- blueberries are free!
		else
			-- call a function that returns a promise with the fruit price
			return fetchPrice(fruit):andThen(function(fruitCost)
				return cost + fruitCost
			end)
		end
	end, 0)
	```

	@since v3.1.0
	@param list {T | Promise<T>}
	@param reducer (accumulator: U, value: T, index: number) -> U | Promise<U>
	@param initialValue U
]=]
function Promise.fold(list, reducer, initialValue)
	assert(type(list) == "table", "Bad argument #1 to Promise.fold: must be a table")
	assert(isCallable(reducer), "Bad argument #2 to Promise.fold: must be a function")

	local accumulator = Promise.resolve(initialValue)
	return Promise.each(list, function(resolvedElement, i)
		accumulator = accumulator:andThen(function(previousValueResolved)
			return reducer(previousValueResolved, resolvedElement, i)
		end)
	end):andThen(function()
		return accumulator
	end)
end

--[=[
	Accepts an array of Promises and returns a Promise that is resolved as soon as `count` Promises are resolved from the input array. The resolved array values are in the order that the Promises resolved in. When this Promise resolves, all other pending Promises are cancelled if they have no other consumers.

	`count` 0 results in an empty array. The resultant array will never have more than `count` elements.

	```lua
	local promises = {
		returnsAPromise("example 1"),
		returnsAPromise("example 2"),
		returnsAPromise("example 3"),
	}

	return Promise.some(promises, 2) -- Only resolves with first 2 promises to resolve
	```

	@param promises {Promise<T>}
	@param count number
	@return Promise<{T}>
]=]
function Promise.some(promises, count)
	assert(type(count) == "number", "Bad argument #2 to Promise.some: must be a number")

	return Promise._all(debug.traceback(nil, 2), promises, count)
end

--[=[
	Accepts an array of Promises and returns a Promise that is resolved as soon as *any* of the input Promises resolves. It will reject only if *all* input Promises reject. As soon as one Promises resolves, all other pending Promises are cancelled if they have no other consumers.

	Resolves directly with the value of the first resolved Promise. This is essentially [[Promise.some]] with `1` count, except the Promise resolves with the value directly instead of an array with one element.

	```lua
	local promises = {
		returnsAPromise("example 1"),
		returnsAPromise("example 2"),
		returnsAPromise("example 3"),
	}

	return Promise.any(promises) -- Resolves with first value to resolve (only rejects if all 3 rejected)
	```

	@param promises {Promise<T>}
	@return Promise<T>
]=]
function Promise.any(promises)
	return Promise._all(debug.traceback(nil, 2), promises, 1):andThen(function(values)
		return values[1]
	end)
end

--[=[
	Accepts an array of Promises and returns a new Promise that resolves with an array of in-place Statuses when all input Promises have settled. This is equivalent to mapping `promise:finally` over the array of Promises.

	```lua
	local promises = {
		returnsAPromise("example 1"),
		returnsAPromise("example 2"),
		returnsAPromise("example 3"),
	}

	return Promise.allSettled(promises)
	```

	@param promises {Promise<T>}
	@return Promise<{Status}>
]=]
function Promise.allSettled(promises)
	if type(promises) ~= "table" then
		error(string.format(ERROR_NON_LIST, "Promise.allSettled"), 2)
	end

	-- We need to check that each value is a promise here so that we can produce
	-- a proper error rather than a rejected promise with our error.
	for i, promise in pairs(promises) do
		if not Promise.is(promise) then
			error(string.format(ERROR_NON_PROMISE_IN_LIST, "Promise.allSettled", tostring(i)), 2)
		end
	end

	-- If there are no values then return an already resolved promise.
	if #promises == 0 then
		return Promise.resolve({})
	end

	return Promise._new(debug.traceback(nil, 2), function(resolve, _, onCancel)
		-- An array to contain our resolved values from the given promises.
		local fates = {}
		local newPromises = {}

		-- Keep a count of resolved promises because just checking the resolved
		-- values length wouldn't account for promises that resolve with nil.
		local finishedCount = 0

		-- Called when a single value is resolved and resolves if all are done.
		local function resolveOne(i, ...)
			finishedCount = finishedCount + 1

			fates[i] = ...

			if finishedCount >= #promises then
				resolve(fates)
			end
		end

		onCancel(function()
			for _, promise in ipairs(newPromises) do
				promise:cancel()
			end
		end)

		-- We can assume the values inside `promises` are all promises since we
		-- checked above.
		for i, promise in ipairs(promises) do
			newPromises[i] = promise:finally(function(...)
				resolveOne(i, ...)
			end)
		end
	end)
end

--[=[
	Accepts an array of Promises and returns a new promise that is resolved or rejected as soon as any Promise in the array resolves or rejects.

	:::warning
	If the first Promise to settle from the array settles with a rejection, the resulting Promise from `race` will reject.

	If you instead want to tolerate rejections, and only care about at least one Promise resolving, you should use [Promise.any](#any) or [Promise.some](#some) instead.
	:::

	All other Promises that don't win the race will be cancelled if they have no other consumers.

	```lua
	local promises = {
		returnsAPromise("example 1"),
		returnsAPromise("example 2"),
		returnsAPromise("example 3"),
	}

	return Promise.race(promises) -- Only returns 1st value to resolve or reject
	```

	@param promises {Promise<T>}
	@return Promise<T>
]=]
function Promise.race(promises)
	assert(type(promises) == "table", string.format(ERROR_NON_LIST, "Promise.race"))

	for i, promise in pairs(promises) do
		assert(Promise.is(promise), string.format(ERROR_NON_PROMISE_IN_LIST, "Promise.race", tostring(i)))
	end

	return Promise._new(debug.traceback(nil, 2), function(resolve, reject, onCancel)
		local newPromises = {}
		local finished = false

		local function cancel()
			for _, promise in ipairs(newPromises) do
				promise:cancel()
			end
		end

		local function finalize(callback)
			return function(...)
				cancel()
				finished = true
				return callback(...)
			end
		end

		if onCancel(finalize(reject)) then
			return
		end

		for i, promise in ipairs(promises) do
			newPromises[i] = promise:andThen(finalize(resolve), finalize(reject))
		end

		if finished then
			cancel()
		end
	end)
end

--[=[
	Iterates serially over the given an array of values, calling the predicate callback on each value before continuing.

	If the predicate returns a Promise, we wait for that Promise to resolve before moving on to the next item
	in the array.

	:::info
	`Promise.each` is similar to `Promise.all`, except the Promises are ran in order instead of all at once.

	But because Promises are eager, by the time they are created, they're already running. Thus, we need a way to defer creation of each Promise until a later time.

	The predicate function exists as a way for us to operate on our data instead of creating a new closure for each Promise. If you would prefer, you can pass in an array of functions, and in the predicate, call the function and return its return value.
	:::

	```lua
	Promise.each({
		"foo",
		"bar",
		"baz",
		"qux"
	}, function(value, index)
		return Promise.delay(1):andThen(function()
		print(("%d) Got %s!"):format(index, value))
		end)
	end)

	--[[
		(1 second passes)
		> 1) Got foo!
		(1 second passes)
		> 2) Got bar!
		(1 second passes)
		> 3) Got baz!
		(1 second passes)
		> 4) Got qux!
	]]
	```

	If the Promise a predicate returns rejects, the Promise from `Promise.each` is also rejected with the same value.

	If the array of values contains a Promise, when we get to that point in the list, we wait for the Promise to resolve before calling the predicate with the value.

	If a Promise in the array of values is already Rejected when `Promise.each` is called, `Promise.each` rejects with that value immediately (the predicate callback will never be called even once). If a Promise in the list is already Cancelled when `Promise.each` is called, `Promise.each` rejects with `Promise.Error(Promise.Error.Kind.AlreadyCancelled`). If a Promise in the array of values is Started at first, but later rejects, `Promise.each` will reject with that value and iteration will not continue once iteration encounters that value.

	Returns a Promise containing an array of the returned/resolved values from the predicate for each item in the array of values.

	If this Promise returned from `Promise.each` rejects or is cancelled for any reason, the following are true:
	- Iteration will not continue.
	- Any Promises within the array of values will now be cancelled if they have no other consumers.
	- The Promise returned from the currently active predicate will be cancelled if it hasn't resolved yet.

	@since 3.0.0
	@param list {T | Promise<T>}
	@param predicate (value: T, index: number) -> U | Promise<U>
	@return Promise<{U}>
]=]
function Promise.each(list, predicate)
	assert(type(list) == "table", string.format(ERROR_NON_LIST, "Promise.each"))
	assert(isCallable(predicate), string.format(ERROR_NON_FUNCTION, "Promise.each"))

	return Promise._new(debug.traceback(nil, 2), function(resolve, reject, onCancel)
		local results = {}
		local promisesToCancel = {}

		local cancelled = false

		local function cancel()
			for _, promiseToCancel in ipairs(promisesToCancel) do
				promiseToCancel:cancel()
			end
		end

		onCancel(function()
			cancelled = true

			cancel()
		end)

		-- We need to preprocess the list of values and look for Promises.
		-- If we find some, we must register our andThen calls now, so that those Promises have a consumer
		-- from us registered. If we don't do this, those Promises might get cancelled by something else
		-- before we get to them in the series because it's not possible to tell that we plan to use it
		-- unless we indicate it here.

		local preprocessedList = {}

		for index, value in ipairs(list) do
			if Promise.is(value) then
				if value:getStatus() == Promise.Status.Cancelled then
					cancel()
					return reject(Error.new({
						error = "Promise is cancelled",
						kind = Error.Kind.AlreadyCancelled,
						context = string.format(
							"The Promise that was part of the array at index %d passed into Promise.each was already cancelled when Promise.each began.\n\nThat Promise was created at:\n\n%s",
							index,
							value._source
						),
					}))
				elseif value:getStatus() == Promise.Status.Rejected then
					cancel()
					return reject(select(2, value:await()))
				end

				-- Chain a new Promise from this one so we only cancel ours
				local ourPromise = value:andThen(function(...)
					return ...
				end)

				table.insert(promisesToCancel, ourPromise)
				preprocessedList[index] = ourPromise
			else
				preprocessedList[index] = value
			end
		end

		for index, value in ipairs(preprocessedList) do
			if Promise.is(value) then
				local success
				success, value = value:await()

				if not success then
					cancel()
					return reject(value)
				end
			end

			if cancelled then
				return
			end

			local predicatePromise = Promise.resolve(predicate(value, index))

			table.insert(promisesToCancel, predicatePromise)

			local success, result = predicatePromise:await()

			if not success then
				cancel()
				return reject(result)
			end

			results[index] = result
		end

		resolve(results)
	end)
end

--[=[
	Checks whether the given object is a Promise via duck typing. This only checks if the object is a table and has an `andThen` method.

	@param object any
	@return boolean -- `true` if the given `object` is a Promise.
]=]
function Promise.is(object)
	if type(object) ~= "table" then
		return false
	end

	local objectMetatable = getmetatable(object)

	if objectMetatable == Promise then
		-- The Promise came from this library.
		return true
	elseif objectMetatable == nil then
		-- No metatable, but we should still chain onto tables with andThen methods
		return isCallable(object.andThen)
	elseif
		type(objectMetatable) == "table"
		and type(rawget(objectMetatable, "__index")) == "table"
		and isCallable(rawget(rawget(objectMetatable, "__index"), "andThen"))
	then
		-- Maybe this came from a different or older Promise library.
		return true
	end

	return false
end

--[=[
	Wraps a function that yields into one that returns a Promise.

	Any errors that occur while executing the function will be turned into rejections.

	:::info
	`Promise.promisify` is similar to [Promise.try](#try), except the callback is returned as a callable function instead of being invoked immediately.
	:::

	```lua
	local sleep = Promise.promisify(wait)

	sleep(1):andThen(print)
	```

	```lua
	local isPlayerInGroup = Promise.promisify(function(player, groupId)
		return player:IsInGroup(groupId)
	end)
	```

	@param callback (...: any) -> ...any
	@return (...: any) -> Promise
]=]
function Promise.promisify(callback)
	return function(...)
		return Promise._try(debug.traceback(nil, 2), callback, ...)
	end
end

--[=[
	Returns a Promise that resolves after `seconds` seconds have passed. The Promise resolves with the actual amount of time that was waited.

	This function is **not** a wrapper around `wait`. `Promise.delay` uses a custom scheduler which provides more accurate timing. As an optimization, cancelling this Promise instantly removes the task from the scheduler.

	:::warning
	Passing `NaN`, infinity, or a number less than 1/60 is equivalent to passing 1/60.
	:::

	```lua
		Promise.delay(5):andThenCall(print, "This prints after 5 seconds")
	```

	@function delay
	@within Promise
	@param seconds number
	@return Promise<number>
]=]
do
	-- uses a sorted doubly linked list (queue) to achieve O(1) remove operations and O(n) for insert

	-- the initial node in the linked list
	local first
	local connection

	function Promise.delay(seconds)
		assert(type(seconds) == "number", "Bad argument #1 to Promise.delay, must be a number.")
		-- If seconds is -INF, INF, NaN, or less than 1 / 60, assume seconds is 1 / 60.
		-- This mirrors the behavior of wait()
		if not (seconds >= 1 / 60) or seconds == math.huge then
			seconds = 1 / 60
		end

		return Promise._new(debug.traceback(nil, 2), function(resolve, _, onCancel)
			local startTime = Promise._getTime()
			local endTime = startTime + seconds

			local node = {
				resolve = resolve,
				startTime = startTime,
				endTime = endTime,
			}

			if connection == nil then -- first is nil when connection is nil
				first = node
				connection = Promise._timeEvent:Connect(function()
					local threadStart = Promise._getTime()

					while first ~= nil and first.endTime < threadStart do
						local current = first
						first = current.next

						if first == nil then
							connection:Disconnect()
							connection = nil
						else
							first.previous = nil
						end

						current.resolve(Promise._getTime() - current.startTime)
					end
				end)
			else -- first is non-nil
				if first.endTime < endTime then -- if `node` should be placed after `first`
					-- we will insert `node` between `current` and `next`
					-- (i.e. after `current` if `next` is nil)
					local current = first
					local next = current.next

					while next ~= nil and next.endTime < endTime do
						current = next
						next = current.next
					end

					-- `current` must be non-nil, but `next` could be `nil` (i.e. last item in list)
					current.next = node
					node.previous = current

					if next ~= nil then
						node.next = next
						next.previous = node
					end
				else
					-- set `node` to `first`
					node.next = first
					first.previous = node
					first = node
				end
			end

			onCancel(function()
				-- remove node from queue
				local next = node.next

				if first == node then
					if next == nil then -- if `node` is the first and last
						connection:Disconnect()
						connection = nil
					else -- if `node` is `first` and not the last
						next.previous = nil
					end
					first = next
				else
					local previous = node.previous
					-- since `node` is not `first`, then we know `previous` is non-nil
					previous.next = next

					if next ~= nil then
						next.previous = previous
					end
				end
			end)
		end)
	end
end

--[=[
	Returns a new Promise that resolves if the chained Promise resolves within `seconds` seconds, or rejects if execution time exceeds `seconds`. The chained Promise will be cancelled if the timeout is reached.

	Rejects with `rejectionValue` if it is non-nil. If a `rejectionValue` is not given, it will reject with a `Promise.Error(Promise.Error.Kind.TimedOut)`. This can be checked with [[Error.isKind]].

	```lua
	getSomething():timeout(5):andThen(function(something)
		-- got something and it only took at max 5 seconds
	end):catch(function(e)
		-- Either getting something failed or the time was exceeded.

		if Promise.Error.isKind(e, Promise.Error.Kind.TimedOut) then
			warn("Operation timed out!")
		else
			warn("Operation encountered an error!")
		end
	end)
	```

	Sugar for:

	```lua
	Promise.race({
		Promise.delay(seconds):andThen(function()
			return Promise.reject(
				rejectionValue == nil
				and Promise.Error.new({ kind = Promise.Error.Kind.TimedOut })
				or rejectionValue
			)
		end),
		promise
	})
	```

	@param seconds number
	@param rejectionValue? any -- The value to reject with if the timeout is reached
	@return Promise
]=]
function Promise.prototype:timeout(seconds, rejectionValue)
	local traceback = debug.traceback(nil, 2)

	return Promise.race({
		Promise.delay(seconds):andThen(function()
			return Promise.reject(rejectionValue == nil and Error.new({
				kind = Error.Kind.TimedOut,
				error = "Timed out",
				context = string.format(
					"Timeout of %d seconds exceeded.\n:timeout() called at:\n\n%s",
					seconds,
					traceback
				),
			}) or rejectionValue)
		end),
		self,
	})
end

--[=[
	Returns the current Promise status.

	@return Status
]=]
function Promise.prototype:getStatus()
	return self._status
end

--[[
	Creates a new promise that receives the result of this promise.

	The given callbacks are invoked depending on that result.
]]
function Promise.prototype:_andThen(traceback, successHandler, failureHandler)
	self._unhandledRejection = false

	-- Create a new promise to follow this part of the chain
	return Promise._new(traceback, function(resolve, reject)
		-- Our default callbacks just pass values onto the next promise.
		-- This lets success and failure cascade correctly!

		local successCallback = resolve
		if successHandler then
			successCallback = createAdvancer(traceback, successHandler, resolve, reject)
		end

		local failureCallback = reject
		if failureHandler then
			failureCallback = createAdvancer(traceback, failureHandler, resolve, reject)
		end

		if self._status == Promise.Status.Started then
			-- If we haven't resolved yet, put ourselves into the queue
			table.insert(self._queuedResolve, successCallback)
			table.insert(self._queuedReject, failureCallback)
		elseif self._status == Promise.Status.Resolved then
			-- This promise has already resolved! Trigger success immediately.
			successCallback(unpack(self._values, 1, self._valuesLength))
		elseif self._status == Promise.Status.Rejected then
			-- This promise died a terrible death! Trigger failure immediately.
			failureCallback(unpack(self._values, 1, self._valuesLength))
		elseif self._status == Promise.Status.Cancelled then
			-- We don't want to call the success handler or the failure handler,
			-- we just reject this promise outright.
			reject(Error.new({
				error = "Promise is cancelled",
				kind = Error.Kind.AlreadyCancelled,
				context = "Promise created at\n\n" .. traceback,
			}))
		end
	end, self)
end

--[=[
	Chains onto an existing Promise and returns a new Promise.

	:::warning
	Within the failure handler, you should never assume that the rejection value is a string. Some rejections within the Promise library are represented by [[Error]] objects. If you want to treat it as a string for debugging, you should call `tostring` on it first.
	:::

	Return a Promise from the success or failure handler and it will be chained onto.

	@param successHandler (...: any) -> ...any
	@param failureHandler? (...: any) -> ...any
	@return Promise<...any>
]=]
function Promise.prototype:andThen(successHandler, failureHandler)
	assert(successHandler == nil or isCallable(successHandler), string.format(ERROR_NON_FUNCTION, "Promise:andThen"))
	assert(failureHandler == nil or isCallable(failureHandler), string.format(ERROR_NON_FUNCTION, "Promise:andThen"))

	return self:_andThen(debug.traceback(nil, 2), successHandler, failureHandler)
end

--[=[
	Shorthand for `Promise:andThen(nil, failureHandler)`.

	Returns a Promise that resolves if the `failureHandler` worked without encountering an additional error.

	:::warning
	Within the failure handler, you should never assume that the rejection value is a string. Some rejections within the Promise library are represented by [[Error]] objects. If you want to treat it as a string for debugging, you should call `tostring` on it first.
	:::


	@param failureHandler (...: any) -> ...any
	@return Promise<...any>
]=]
function Promise.prototype:catch(failureHandler)
	assert(failureHandler == nil or isCallable(failureHandler), string.format(ERROR_NON_FUNCTION, "Promise:catch"))
	return self:_andThen(debug.traceback(nil, 2), nil, failureHandler)
end

--[=[
	Similar to [Promise.andThen](#andThen), except the return value is the same as the value passed to the handler. In other words, you can insert a `:tap` into a Promise chain without affecting the value that downstream Promises receive.

	```lua
		getTheValue()
		:tap(print)
		:andThen(function(theValue)
			print("Got", theValue, "even though print returns nil!")
		end)
	```

	If you return a Promise from the tap handler callback, its value will be discarded but `tap` will still wait until it resolves before passing the original value through.

	@param tapHandler (...: any) -> ...any
	@return Promise<...any>
]=]
function Promise.prototype:tap(tapHandler)
	assert(isCallable(tapHandler), string.format(ERROR_NON_FUNCTION, "Promise:tap"))
	return self:_andThen(debug.traceback(nil, 2), function(...)
		local callbackReturn = tapHandler(...)

		if Promise.is(callbackReturn) then
			local length, values = pack(...)
			return callbackReturn:andThen(function()
				return unpack(values, 1, length)
			end)
		end

		return ...
	end)
end

--[=[
	Attaches an `andThen` handler to this Promise that calls the given callback with the predefined arguments. The resolved value is discarded.

	```lua
		promise:andThenCall(someFunction, "some", "arguments")
	```

	This is sugar for

	```lua
		promise:andThen(function()
		return someFunction("some", "arguments")
		end)
	```

	@param callback (...: any) -> any
	@param ...? any -- Additional arguments which will be passed to `callback`
	@return Promise
]=]
function Promise.prototype:andThenCall(callback, ...)
	assert(isCallable(callback), string.format(ERROR_NON_FUNCTION, "Promise:andThenCall"))
	local length, values = pack(...)
	return self:_andThen(debug.traceback(nil, 2), function()
		return callback(unpack(values, 1, length))
	end)
end

--[=[
	Attaches an `andThen` handler to this Promise that discards the resolved value and returns the given value from it.

	```lua
		promise:andThenReturn("some", "values")
	```

	This is sugar for

	```lua
		promise:andThen(function()
			return "some", "values"
		end)
	```

	:::caution
	Promises are eager, so if you pass a Promise to `andThenReturn`, it will begin executing before `andThenReturn` is reached in the chain. Likewise, if you pass a Promise created from [[Promise.reject]] into `andThenReturn`, it's possible that this will trigger the unhandled rejection warning. If you need to return a Promise, it's usually best practice to use [[Promise.andThen]].
	:::

	@param ... any -- Values to return from the function
	@return Promise
]=]
function Promise.prototype:andThenReturn(...)
	local length, values = pack(...)
	return self:_andThen(debug.traceback(nil, 2), function()
		return unpack(values, 1, length)
	end)
end

--[=[
	Cancels this promise, preventing the promise from resolving or rejecting. Does not do anything if the promise is already settled.

	Cancellations will propagate upwards and downwards through chained promises.

	Promises will only be cancelled if all of their consumers are also cancelled. This is to say that if you call `andThen` twice on the same promise, and you cancel only one of the child promises, it will not cancel the parent promise until the other child promise is also cancelled.

	```lua
		promise:cancel()
	```
]=]
function Promise.prototype:cancel()
	if self._status ~= Promise.Status.Started then
		return
	end

	self._status = Promise.Status.Cancelled

	if self._cancellationHook then
		self._cancellationHook()
	end

	if self._parent then
		self._parent:_consumerCancelled(self)
	end

	for child in pairs(self._consumers) do
		child:cancel()
	end

	self:_finalize()
end

--[[
	Used to decrease the number of consumers by 1, and if there are no more,
	cancel this promise.
]]
function Promise.prototype:_consumerCancelled(consumer)
	if self._status ~= Promise.Status.Started then
		return
	end

	self._consumers[consumer] = nil

	if next(self._consumers) == nil then
		self:cancel()
	end
end

--[[
	Used to set a handler for when the promise resolves, rejects, or is
	cancelled. Returns a new promise chained from this promise.
]]
function Promise.prototype:_finally(traceback, finallyHandler, onlyOk)
	if not onlyOk then
		self._unhandledRejection = false
	end

	-- Return a promise chained off of this promise
	return Promise._new(traceback, function(resolve, reject)
		local finallyCallback = resolve
		if finallyHandler then
			finallyCallback = createAdvancer(traceback, finallyHandler, resolve, reject)
		end

		if onlyOk then
			local callback = finallyCallback
			finallyCallback = function(...)
				if self._status == Promise.Status.Rejected then
					return resolve(self)
				end

				return callback(...)
			end
		end

		if self._status == Promise.Status.Started then
			-- The promise is not settled, so queue this.
			table.insert(self._queuedFinally, finallyCallback)
		else
			-- The promise already settled or was cancelled, run the callback now.
			finallyCallback(self._status)
		end
	end, self)
end

--[=[
	Set a handler that will be called regardless of the promise's fate. The handler is called when the promise is resolved, rejected, *or* cancelled.

	Returns a new promise chained from this promise.

	:::caution
	If the Promise is cancelled, any Promises chained off of it with `andThen` won't run. Only Promises chained with `finally` or `done` will run in the case of cancellation.
	:::

	```lua
	local thing = createSomething()

	doSomethingWith(thing)
		:andThen(function()
			print("It worked!")
			-- do something..
		end)
		:catch(function()
			warn("Oh no it failed!")
		end)
		:finally(function()
			-- either way, destroy thing

			thing:Destroy()
		end)

	```

	@param finallyHandler (status: Status) -> ...any
	@return Promise<...any>
]=]
function Promise.prototype:finally(finallyHandler)
	assert(finallyHandler == nil or isCallable(finallyHandler), string.format(ERROR_NON_FUNCTION, "Promise:finally"))
	return self:_finally(debug.traceback(nil, 2), finallyHandler)
end

--[=[
	Same as `andThenCall`, except for `finally`.

	Attaches a `finally` handler to this Promise that calls the given callback with the predefined arguments.

	@param callback (...: any) -> any
	@param ...? any -- Additional arguments which will be passed to `callback`
	@return Promise
]=]
function Promise.prototype:finallyCall(callback, ...)
	assert(isCallable(callback), string.format(ERROR_NON_FUNCTION, "Promise:finallyCall"))
	local length, values = pack(...)
	return self:_finally(debug.traceback(nil, 2), function()
		return callback(unpack(values, 1, length))
	end)
end

--[=[
	Attaches a `finally` handler to this Promise that discards the resolved value and returns the given value from it.

	```lua
		promise:finallyReturn("some", "values")
	```

	This is sugar for

	```lua
		promise:finally(function()
			return "some", "values"
		end)
	```

	@param ... any -- Values to return from the function
	@return Promise
]=]
function Promise.prototype:finallyReturn(...)
	local length, values = pack(...)
	return self:_finally(debug.traceback(nil, 2), function()
		return unpack(values, 1, length)
	end)
end

--[=[
	Set a handler that will be called only if the Promise resolves or is cancelled. This method is similar to `finally`, except it doesn't catch rejections.

	:::caution
	`done` should be reserved specifically when you want to perform some operation after the Promise is finished (like `finally`), but you don't want to consume rejections (like in <a href="/roblox-lua-promise/lib/Examples.html#cancellable-animation-sequence">this example</a>). You should use `andThen` instead if you only care about the Resolved case.
	:::

	:::warning
	Like `finally`, if the Promise is cancelled, any Promises chained off of it with `andThen` won't run. Only Promises chained with `done` and `finally` will run in the case of cancellation.
	:::

	Returns a new promise chained from this promise.

	@param doneHandler (status: Status) -> ...any
	@return Promise<...any>
]=]
function Promise.prototype:done(doneHandler)
	assert(doneHandler == nil or isCallable(doneHandler), string.format(ERROR_NON_FUNCTION, "Promise:done"))
	return self:_finally(debug.traceback(nil, 2), doneHandler, true)
end

--[=[
	Same as `andThenCall`, except for `done`.

	Attaches a `done` handler to this Promise that calls the given callback with the predefined arguments.

	@param callback (...: any) -> any
	@param ...? any -- Additional arguments which will be passed to `callback`
	@return Promise
]=]
function Promise.prototype:doneCall(callback, ...)
	assert(isCallable(callback), string.format(ERROR_NON_FUNCTION, "Promise:doneCall"))
	local length, values = pack(...)
	return self:_finally(debug.traceback(nil, 2), function()
		return callback(unpack(values, 1, length))
	end, true)
end

--[=[
	Attaches a `done` handler to this Promise that discards the resolved value and returns the given value from it.

	```lua
		promise:doneReturn("some", "values")
	```

	This is sugar for

	```lua
		promise:done(function()
			return "some", "values"
		end)
	```

	@param ... any -- Values to return from the function
	@return Promise
]=]
function Promise.prototype:doneReturn(...)
	local length, values = pack(...)
	return self:_finally(debug.traceback(nil, 2), function()
		return unpack(values, 1, length)
	end, true)
end

--[=[
	Yields the current thread until the given Promise completes. Returns the Promise's status, followed by the values that the promise resolved or rejected with.

	@yields
	@return Status -- The Status representing the fate of the Promise
	@return ...any -- The values the Promise resolved or rejected with.
]=]
function Promise.prototype:awaitStatus()
	self._unhandledRejection = false

	if self._status == Promise.Status.Started then
		local bindable = Instance.new("BindableEvent")

		self:finally(function()
			bindable:Fire()
		end)

		bindable.Event:Wait()
		bindable:Destroy()
	end

	if self._status == Promise.Status.Resolved then
		return self._status, unpack(self._values, 1, self._valuesLength)
	elseif self._status == Promise.Status.Rejected then
		return self._status, unpack(self._values, 1, self._valuesLength)
	end

	return self._status
end

local function awaitHelper(status, ...)
	return status == Promise.Status.Resolved, ...
end

--[=[
	Yields the current thread until the given Promise completes. Returns true if the Promise resolved, followed by the values that the promise resolved or rejected with.

	:::caution
	If the Promise gets cancelled, this function will return `false`, which is indistinguishable from a rejection. If you need to differentiate, you should use [[Promise.awaitStatus]] instead.
	:::

	```lua
		local worked, value = getTheValue():await()

	if worked then
		print("got", value)
	else
		warn("it failed")
	end
	```

	@yields
	@return boolean -- `true` if the Promise successfully resolved
	@return ...any -- The values the Promise resolved or rejected with.
]=]
function Promise.prototype:await()
	return awaitHelper(self:awaitStatus())
end

local function expectHelper(status, ...)
	if status ~= Promise.Status.Resolved then
		error((...) == nil and "Expected Promise rejected with no value." or (...), 3)
	end

	return ...
end

--[=[
	Yields the current thread until the given Promise completes. Returns the values that the promise resolved with.

	```lua
	local worked = pcall(function()
		print("got", getTheValue():expect())
	end)

	if not worked then
		warn("it failed")
	end
	```

	This is essentially sugar for:

	```lua
	select(2, assert(promise:await()))
	```

	**Errors** if the Promise rejects or gets cancelled.

	@error any -- Errors with the rejection value if this Promise rejects or gets cancelled.
	@yields
	@return ...any -- The values the Promise resolved with.
]=]
function Promise.prototype:expect()
	return expectHelper(self:awaitStatus())
end

-- Backwards compatibility
Promise.prototype.awaitValue = Promise.prototype.expect

--[[
	Intended for use in tests.

	Similar to await(), but instead of yielding if the promise is unresolved,
	_unwrap will throw. This indicates an assumption that a promise has
	resolved.
]]
function Promise.prototype:_unwrap()
	if self._status == Promise.Status.Started then
		error("Promise has not resolved or rejected.", 2)
	end

	local success = self._status == Promise.Status.Resolved

	return success, unpack(self._values, 1, self._valuesLength)
end

function Promise.prototype:_resolve(...)
	if self._status ~= Promise.Status.Started then
		if Promise.is((...)) then
			(...):_consumerCancelled(self)
		end
		return
	end

	-- If the resolved value was a Promise, we chain onto it!
	if Promise.is((...)) then
		-- Without this warning, arguments sometimes mysteriously disappear
		if select("#", ...) > 1 then
			local message = string.format(
				"When returning a Promise from andThen, extra arguments are " .. "discarded! See:\n\n%s",
				self._source
			)
			warn(message)
		end

		local chainedPromise = ...

		local promise = chainedPromise:andThen(function(...)
			self:_resolve(...)
		end, function(...)
			local maybeRuntimeError = chainedPromise._values[1]

			-- Backwards compatibility < v2
			if chainedPromise._error then
				maybeRuntimeError = Error.new({
					error = chainedPromise._error,
					kind = Error.Kind.ExecutionError,
					context = "[No stack trace available as this Promise originated from an older version of the Promise library (< v2)]",
				})
			end

			if Error.isKind(maybeRuntimeError, Error.Kind.ExecutionError) then
				return self:_reject(maybeRuntimeError:extend({
					error = "This Promise was chained to a Promise that errored.",
					trace = "",
					context = string.format(
						"The Promise at:\n\n%s\n...Rejected because it was chained to the following Promise, which encountered an error:\n",
						self._source
					),
				}))
			end

			self:_reject(...)
		end)

		if promise._status == Promise.Status.Cancelled then
			self:cancel()
		elseif promise._status == Promise.Status.Started then
			-- Adopt ourselves into promise for cancellation propagation.
			self._parent = promise
			promise._consumers[self] = true
		end

		return
	end

	self._status = Promise.Status.Resolved
	self._valuesLength, self._values = pack(...)

	-- We assume that these callbacks will not throw errors.
	for _, callback in ipairs(self._queuedResolve) do
		coroutine.wrap(callback)(...)
	end

	self:_finalize()
end

function Promise.prototype:_reject(...)
	if self._status ~= Promise.Status.Started then
		return
	end

	self._status = Promise.Status.Rejected
	self._valuesLength, self._values = pack(...)

	-- If there are any rejection handlers, call those!
	if not isEmpty(self._queuedReject) then
		-- We assume that these callbacks will not throw errors.
		for _, callback in ipairs(self._queuedReject) do
			coroutine.wrap(callback)(...)
		end
	else
		-- At this point, no one was able to observe the error.
		-- An error handler might still be attached if the error occurred
		-- synchronously. We'll wait one tick, and if there are still no
		-- observers, then we should put a message in the console.

		local err = tostring((...))

		coroutine.wrap(function()
			Promise._timeEvent:Wait()

			-- Someone observed the error, hooray!
			if not self._unhandledRejection then
				return
			end

			-- Build a reasonable message
			local message = string.format("Unhandled Promise rejection:\n\n%s\n\n%s", err, self._source)

			for _, callback in ipairs(Promise._unhandledRejectionCallbacks) do
				task.spawn(callback, self, unpack(self._values, 1, self._valuesLength))
			end

			if Promise.TEST then
				-- Don't spam output when we're running tests.
				return
			end

			warn(message)
		end)()
	end

	self:_finalize()
end

--[[
	Calls any :finally handlers. We need this to be a separate method and
	queue because we must call all of the finally callbacks upon a success,
	failure, *and* cancellation.
]]
function Promise.prototype:_finalize()
	for _, callback in ipairs(self._queuedFinally) do
		-- Purposefully not passing values to callbacks here, as it could be the
		-- resolved values, or rejected errors. If the developer needs the values,
		-- they should use :andThen or :catch explicitly.
		coroutine.wrap(callback)(self._status)
	end

	self._queuedFinally = nil
	self._queuedReject = nil
	self._queuedResolve = nil

	-- Clear references to other Promises to allow gc
	if not Promise.TEST then
		self._parent = nil
		self._consumers = nil
	end
end

--[=[
	Chains a Promise from this one that is resolved if this Promise is already resolved, and rejected if it is not resolved at the time of calling `:now()`. This can be used to ensure your `andThen` handler occurs on the same frame as the root Promise execution.

	```lua
	doSomething()
		:now()
		:andThen(function(value)
			print("Got", value, "synchronously.")
		end)
	```

	If this Promise is still running, Rejected, or Cancelled, the Promise returned from `:now()` will reject with the `rejectionValue` if passed, otherwise with a `Promise.Error(Promise.Error.Kind.NotResolvedInTime)`. This can be checked with [[Error.isKind]].

	@param rejectionValue? any -- The value to reject with if the Promise isn't resolved
	@return Promise
]=]
function Promise.prototype:now(rejectionValue)
	local traceback = debug.traceback(nil, 2)
	if self._status == Promise.Status.Resolved then
		return self:_andThen(traceback, function(...)
			return ...
		end)
	else
		return Promise.reject(rejectionValue == nil and Error.new({
			kind = Error.Kind.NotResolvedInTime,
			error = "This Promise was not resolved in time for :now()",
			context = ":now() was called at:\n\n" .. traceback,
		}) or rejectionValue)
	end
end

--[=[
	Repeatedly calls a Promise-returning function up to `times` number of times, until the returned Promise resolves.

	If the amount of retries is exceeded, the function will return the latest rejected Promise.

	```lua
	local function canFail(a, b, c)
		return Promise.new(function(resolve, reject)
			-- do something that can fail

			local failed, thing = doSomethingThatCanFail(a, b, c)

			if failed then
				reject("it failed")
			else
				resolve(thing)
			end
		end)
	end

	local MAX_RETRIES = 10
	local value = Promise.retry(canFail, MAX_RETRIES, "foo", "bar", "baz") -- args to send to canFail
	```

	@since 3.0.0
	@param callback (...: P) -> Promise<T>
	@param times number
	@param ...? P
]=]
function Promise.retry(callback, times, ...)
	assert(isCallable(callback), "Parameter #1 to Promise.retry must be a function")
	assert(type(times) == "number", "Parameter #2 to Promise.retry must be a number")

	local args, length = { ... }, select("#", ...)

	return Promise.resolve(callback(...)):catch(function(...)
		if times > 0 then
			return Promise.retry(callback, times - 1, unpack(args, 1, length))
		else
			return Promise.reject(...)
		end
	end)
end

--[=[
	Repeatedly calls a Promise-returning function up to `times` number of times, waiting `seconds` seconds between each
	retry, until the returned Promise resolves.

	If the amount of retries is exceeded, the function will return the latest rejected Promise.

	@since v3.2.0
	@param callback (...: P) -> Promise<T>
	@param times number
	@param seconds number
	@param ...? P
]=]
function Promise.retryWithDelay(callback, times, seconds, ...)
	assert(isCallable(callback), "Parameter #1 to Promise.retry must be a function")
	assert(type(times) == "number", "Parameter #2 (times) to Promise.retry must be a number")
	assert(type(seconds) == "number", "Parameter #3 (seconds) to Promise.retry must be a number")

	local args, length = { ... }, select("#", ...)

	return Promise.resolve(callback(...)):catch(function(...)
		if times > 0 then
			Promise.delay(seconds):await()

			return Promise.retryWithDelay(callback, times - 1, seconds, unpack(args, 1, length))
		else
			return Promise.reject(...)
		end
	end)
end

--[=[
	Converts an event into a Promise which resolves the next time the event fires.

	The optional `predicate` callback, if passed, will receive the event arguments and should return `true` or `false`, based on if this fired event should resolve the Promise or not. If `true`, the Promise resolves. If `false`, nothing happens and the predicate will be rerun the next time the event fires.

	The Promise will resolve with the event arguments.

	:::tip
	This function will work given any object with a `Connect` method. This includes all Roblox events.
	:::

	```lua
	-- Creates a Promise which only resolves when `somePart` is touched
	-- by a part named `"Something specific"`.
	return Promise.fromEvent(somePart.Touched, function(part)
		return part.Name == "Something specific"
	end)
	```

	@since 3.0.0
	@param event Event -- Any object with a `Connect` method. This includes all Roblox events.
	@param predicate? (...: P) -> boolean -- A function which determines if the Promise should resolve with the given value, or wait for the next event to check again.
	@return Promise<P>
]=]
function Promise.fromEvent(event, predicate)
	predicate = predicate or function()
		return true
	end

	return Promise._new(debug.traceback(nil, 2), function(resolve, _, onCancel)
		local connection
		local shouldDisconnect = false

		local function disconnect()
			connection:Disconnect()
			connection = nil
		end

		-- We use shouldDisconnect because if the callback given to Connect is called before
		-- Connect returns, connection will still be nil. This happens with events that queue up
		-- events when there's nothing connected, such as RemoteEvents

		connection = event:Connect(function(...)
			local callbackValue = predicate(...)

			if callbackValue == true then
				resolve(...)

				if connection then
					disconnect()
				else
					shouldDisconnect = true
				end
			elseif type(callbackValue) ~= "boolean" then
				error("Promise.fromEvent predicate should always return a boolean")
			end
		end)

		if shouldDisconnect and connection then
			return disconnect()
		end

		onCancel(disconnect)
	end)
end

--[=[
	Registers a callback that runs when an unhandled rejection happens. An unhandled rejection happens when a Promise
	is rejected, and the rejection is not observed with `:catch`.

	The callback is called with the actual promise that rejected, followed by the rejection values.

	@since v3.2.0
	@param callback (promise: Promise, ...: any) -- A callback that runs when an unhandled rejection happens.
	@return () -> () -- Function that unregisters the `callback` when called
]=]
function Promise.onUnhandledRejection(callback)
	table.insert(Promise._unhandledRejectionCallbacks, callback)

	return function()
		local index = table.find(Promise._unhandledRejectionCallbacks, callback)

		if index then
			table.remove(Promise._unhandledRejectionCallbacks, index)
		end
	end
end

return Promise

end)
__lua("RuntimeLib", "ModuleScript", "roblox-ts-game.rbxts_include.RuntimeLib", "roblox-ts-game.rbxts_include", function()
	local _=__env("roblox-ts-game.rbxts_include.RuntimeLib")local script,require=_.script,_.require local Promise = require(script.Parent.Promise)

local RunService = game:GetService("RunService")

local OUTPUT_PREFIX = "roblox-ts: "
local NODE_MODULES = "node_modules"
local DEFAULT_SCOPE = "@rbxts"

local TS = {}

TS.Promise = Promise

local function isPlugin(context)
	return RunService:IsStudio() and context:FindFirstAncestorWhichIsA("Plugin") ~= nil
end

function TS.getModule(context, scope, moduleName)
	-- legacy call signature
	if moduleName == nil then
		moduleName = scope
		scope = DEFAULT_SCOPE
	end

	-- ensure modules have fully replicated
	if RunService:IsRunning() and RunService:IsClient() and not isPlugin(context) and not game:IsLoaded() then
		game.Loaded:Wait()
	end

	local object = context
	repeat
		local nodeModulesFolder = object:FindFirstChild(NODE_MODULES)
		if nodeModulesFolder then
			local scopeFolder = nodeModulesFolder:FindFirstChild(scope)
			if scopeFolder then
				local module = scopeFolder:FindFirstChild(moduleName)
				if module then
					return module
				end
			end
		end
		object = object.Parent
	until object == nil

	error(OUTPUT_PREFIX .. "Could not find module: " .. moduleName, 2)
end

-- This is a hash which TS.import uses as a kind of linked-list-like history of [Script who Loaded] -> Library
local currentlyLoading = {}
local registeredLibraries = {}

function TS.import(context, module, ...)
	for i = 1, select("#", ...) do
		module = module:WaitForChild((select(i, ...)))
	end

	if module.ClassName ~= "ModuleScript" then
		error(OUTPUT_PREFIX .. "Failed to import! Expected ModuleScript, got " .. module.ClassName, 2)
	end

	currentlyLoading[context] = module

	-- Check to see if a case like this occurs:
	-- module -> Module1 -> Module2 -> module

	-- WHERE currentlyLoading[module] is Module1
	-- and currentlyLoading[Module1] is Module2
	-- and currentlyLoading[Module2] is module

	local currentModule = module
	local depth = 0

	while currentModule do
		depth = depth + 1
		currentModule = currentlyLoading[currentModule]

		if currentModule == module then
			local str = currentModule.Name -- Get the string traceback

			for _ = 1, depth do
				currentModule = currentlyLoading[currentModule]
				str = str .. "  ⇒ " .. currentModule.Name
			end

			error(OUTPUT_PREFIX .. "Failed to import! Detected a circular dependency chain: " .. str, 2)
		end
	end

	if not registeredLibraries[module] then
		if _G[module] then
			error(
				OUTPUT_PREFIX
				.. "Invalid module access! Do you have multiple TS runtimes trying to import this? "
				.. module:GetFullName(),
				2
			)
		end

		_G[module] = TS
		registeredLibraries[module] = true -- register as already loaded for subsequent calls
	end

	local data = require(module)

	if currentlyLoading[context] == module then -- Thread-safe cleanup!
		currentlyLoading[context] = nil
	end

	return data
end

function TS.instanceof(obj, class)
	-- custom Class.instanceof() check
	if type(class) == "table" and type(class.instanceof) == "function" then
		return class.instanceof(obj)
	end

	-- metatable check
	if type(obj) == "table" then
		obj = getmetatable(obj)
		while obj ~= nil do
			if obj == class then
				return true
			end
			local mt = getmetatable(obj)
			if mt then
				obj = mt.__index
			else
				obj = nil
			end
		end
	end

	return false
end

function TS.async(callback)
	return function(...)
		local n = select("#", ...)
		local args = { ... }
		return Promise.new(function(resolve, reject)
			coroutine.wrap(function()
				local ok, result = pcall(callback, unpack(args, 1, n))
				if ok then
					resolve(result)
				else
					reject(result)
				end
			end)()
		end)
	end
end

function TS.await(promise)
	if not Promise.is(promise) then
		return promise
	end

	local status, value = promise:awaitStatus()
	if status == Promise.Status.Resolved then
		return value
	elseif status == Promise.Status.Rejected then
		error(value, 2)
	else
		error("The awaited Promise was cancelled", 2)
	end
end

local SIGN = 2 ^ 31
local COMPLEMENT = 2 ^ 32
local function bit_sign(num)
	-- Restores the sign after an unsigned conversion according to 2s complement.
	if bit32.btest(num, SIGN) then
		return num - COMPLEMENT
	else
		return num
	end
end

function TS.bit_lrsh(a, b)
	return bit_sign(bit32.arshift(a, b))
end

TS.TRY_RETURN = 1
TS.TRY_BREAK = 2
TS.TRY_CONTINUE = 3

function TS.try(func, catch, finally)
	local err, traceback
	local success, exitType, returns = xpcall(
		func,
		function(errInner)
			err = errInner
			traceback = debug.traceback()
		end
	)
	if not success and catch then
		local newExitType, newReturns = catch(err, traceback)
		if newExitType then
			exitType, returns = newExitType, newReturns
		end
	end
	if finally then
		local newExitType, newReturns = finally()
		if newExitType then
			exitType, returns = newExitType, newReturns
		end
	end
	return exitType, returns
end

function TS.generator(callback)
	local co = coroutine.create(callback)
	return {
		next = function(...)
			if coroutine.status(co) == "dead" then
				return { done = true }
			else
				local success, value = coroutine.resume(co, ...)
				if success == false then
					error(value, 2)
				end
				return {
					value = value,
					done = coroutine.status(co) == "dead",
				}
			end
		end,
	}
end

return TS

end)
__rbx("node_modules", "Folder", "roblox-ts-game.rbxts_include.node_modules", "roblox-ts-game.rbxts_include")
__rbx("@rbxts", "Folder", "roblox-ts-game.rbxts_include.node_modules.@rbxts", "roblox-ts-game.rbxts_include.node_modules")
__rbx("compiler-types", "Folder", "roblox-ts-game.rbxts_include.node_modules.@rbxts.compiler-types", "roblox-ts-game.rbxts_include.node_modules.@rbxts")
__rbx("types", "Folder", "roblox-ts-game.rbxts_include.node_modules.@rbxts.compiler-types.types", "roblox-ts-game.rbxts_include.node_modules.@rbxts.compiler-types")
__rbx("flipper", "Folder", "roblox-ts-game.rbxts_include.node_modules.@rbxts.flipper", "roblox-ts-game.rbxts_include.node_modules.@rbxts")
__lua("src", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.flipper.src", "roblox-ts-game.rbxts_include.node_modules.@rbxts.flipper", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.flipper.src")local script,require=_.script,_.require local Flipper = {
	SingleMotor = require(script.SingleMotor),
	GroupMotor = require(script.GroupMotor),

	Instant = require(script.Instant),
	Linear = require(script.Linear),
	Spring = require(script.Spring),
	
	isMotor = require(script.isMotor),
}

return Flipper
end)
__lua("BaseMotor", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.flipper.src.BaseMotor", "roblox-ts-game.rbxts_include.node_modules.@rbxts.flipper.src", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.flipper.src.BaseMotor")local script,require=_.script,_.require local RunService = game:GetService("RunService")

local Signal = require(script.Parent.Signal)

local noop = function() end

local BaseMotor = {}
BaseMotor.__index = BaseMotor

function BaseMotor.new()
	return setmetatable({
		_onStep = Signal.new(),
		_onStart = Signal.new(),
		_onComplete = Signal.new(),
	}, BaseMotor)
end

function BaseMotor:onStep(handler)
	return self._onStep:connect(handler)
end

function BaseMotor:onStart(handler)
	return self._onStart:connect(handler)
end

function BaseMotor:onComplete(handler)
	return self._onComplete:connect(handler)
end

function BaseMotor:start()
	if not self._connection then
		self._connection = RunService.RenderStepped:Connect(function(deltaTime)
			self:step(deltaTime)
		end)
	end
end

function BaseMotor:stop()
	if self._connection then
		self._connection:Disconnect()
		self._connection = nil
	end
end

BaseMotor.destroy = BaseMotor.stop

BaseMotor.step = noop
BaseMotor.getValue = noop
BaseMotor.setGoal = noop

function BaseMotor:__tostring()
	return "Motor"
end

return BaseMotor

end)
__lua("GroupMotor", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.flipper.src.GroupMotor", "roblox-ts-game.rbxts_include.node_modules.@rbxts.flipper.src", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.flipper.src.GroupMotor")local script,require=_.script,_.require local BaseMotor = require(script.Parent.BaseMotor)
local SingleMotor = require(script.Parent.SingleMotor)

local isMotor = require(script.Parent.isMotor)

local GroupMotor = setmetatable({}, BaseMotor)
GroupMotor.__index = GroupMotor

local function toMotor(value)
	if isMotor(value) then
		return value
	end

	local valueType = typeof(value)

	if valueType == "number" then
		return SingleMotor.new(value, false)
	elseif valueType == "table" then
		return GroupMotor.new(value, false)
	end

	error(("Unable to convert %q to motor; type %s is unsupported"):format(value, valueType), 2)
end

function GroupMotor.new(initialValues, useImplicitConnections)
	assert(initialValues, "Missing argument #1: initialValues")
	assert(typeof(initialValues) == "table", "initialValues must be a table!")
	assert(not initialValues.step, "initialValues contains disallowed property \"step\". Did you mean to put a table of values here?")

	local self = setmetatable(BaseMotor.new(), GroupMotor)

	if useImplicitConnections ~= nil then
		self._useImplicitConnections = useImplicitConnections
	else
		self._useImplicitConnections = true
	end

	self._complete = true
	self._motors = {}

	for key, value in pairs(initialValues) do
		self._motors[key] = toMotor(value)
	end

	return self
end

function GroupMotor:step(deltaTime)
	if self._complete then
		return true
	end

	local allMotorsComplete = true

	for _, motor in pairs(self._motors) do
		local complete = motor:step(deltaTime)
		if not complete then
			-- If any of the sub-motors are incomplete, the group motor will not be complete either
			allMotorsComplete = false
		end
	end

	self._onStep:fire(self:getValue())

	if allMotorsComplete then
		if self._useImplicitConnections then
			self:stop()
		end

		self._complete = true
		self._onComplete:fire()
	end

	return allMotorsComplete
end

function GroupMotor:setGoal(goals)
	assert(not goals.step, "goals contains disallowed property \"step\". Did you mean to put a table of goals here?")

	self._complete = false
	self._onStart:fire()

	for key, goal in pairs(goals) do
		local motor = assert(self._motors[key], ("Unknown motor for key %s"):format(key))
		motor:setGoal(goal)
	end

	if self._useImplicitConnections then
		self:start()
	end
end

function GroupMotor:getValue()
	local values = {}

	for key, motor in pairs(self._motors) do
		values[key] = motor:getValue()
	end

	return values
end

function GroupMotor:__tostring()
	return "Motor(Group)"
end

return GroupMotor

end)
__lua("Instant", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.flipper.src.Instant", "roblox-ts-game.rbxts_include.node_modules.@rbxts.flipper.src", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.flipper.src.Instant")local script,require=_.script,_.require local Instant = {}
Instant.__index = Instant

function Instant.new(targetValue)
	return setmetatable({
		_targetValue = targetValue,
	}, Instant)
end

function Instant:step()
	return {
		complete = true,
		value = self._targetValue,
	}
end

return Instant
end)
__lua("Linear", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.flipper.src.Linear", "roblox-ts-game.rbxts_include.node_modules.@rbxts.flipper.src", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.flipper.src.Linear")local script,require=_.script,_.require local Linear = {}
Linear.__index = Linear

function Linear.new(targetValue, options)
	assert(targetValue, "Missing argument #1: targetValue")
	
	options = options or {}

	return setmetatable({
		_targetValue = targetValue,
		_velocity = options.velocity or 1,
	}, Linear)
end

function Linear:step(state, dt)
	local position = state.value
	local velocity = self._velocity -- Linear motion ignores the state's velocity
	local goal = self._targetValue

	local dPos = dt * velocity

	local complete = dPos >= math.abs(goal - position)
	position = position + dPos * (goal > position and 1 or -1)
	if complete then
		position = self._targetValue
		velocity = 0
	end
	
	return {
		complete = complete,
		value = position,
		velocity = velocity,
	}
end

return Linear
end)
__lua("Signal", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.flipper.src.Signal", "roblox-ts-game.rbxts_include.node_modules.@rbxts.flipper.src", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.flipper.src.Signal")local script,require=_.script,_.require local Connection = {}
Connection.__index = Connection

function Connection.new(signal, handler)
	return setmetatable({
		signal = signal,
		connected = true,
		_handler = handler,
	}, Connection)
end

function Connection:disconnect()
	if self.connected then
		self.connected = false

		for index, connection in pairs(self.signal._connections) do
			if connection == self then
				table.remove(self.signal._connections, index)
				return
			end
		end
	end
end

local Signal = {}
Signal.__index = Signal

function Signal.new()
	return setmetatable({
		_connections = {},
		_threads = {},
	}, Signal)
end

function Signal:fire(...)
	for _, connection in pairs(self._connections) do
		connection._handler(...)
	end

	for _, thread in pairs(self._threads) do
		coroutine.resume(thread, ...)
	end
	
	self._threads = {}
end

function Signal:connect(handler)
	local connection = Connection.new(self, handler)
	table.insert(self._connections, connection)
	return connection
end

function Signal:wait()
	table.insert(self._threads, coroutine.running())
	return coroutine.yield()
end

return Signal
end)
__lua("SingleMotor", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.flipper.src.SingleMotor", "roblox-ts-game.rbxts_include.node_modules.@rbxts.flipper.src", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.flipper.src.SingleMotor")local script,require=_.script,_.require local BaseMotor = require(script.Parent.BaseMotor)

local SingleMotor = setmetatable({}, BaseMotor)
SingleMotor.__index = SingleMotor

function SingleMotor.new(initialValue, useImplicitConnections)
	assert(initialValue, "Missing argument #1: initialValue")
	assert(typeof(initialValue) == "number", "initialValue must be a number!")

	local self = setmetatable(BaseMotor.new(), SingleMotor)

	if useImplicitConnections ~= nil then
		self._useImplicitConnections = useImplicitConnections
	else
		self._useImplicitConnections = true
	end

	self._goal = nil
	self._state = {
		complete = true,
		value = initialValue,
	}

	return self
end

function SingleMotor:step(deltaTime)
	if self._state.complete then
		return true
	end

	local newState = self._goal:step(self._state, deltaTime)

	self._state = newState
	self._onStep:fire(newState.value)

	if newState.complete then
		if self._useImplicitConnections then
			self:stop()
		end

		self._onComplete:fire()
	end

	return newState.complete
end

function SingleMotor:getValue()
	return self._state.value
end

function SingleMotor:setGoal(goal)
	self._state.complete = false
	self._goal = goal

	self._onStart:fire()

	if self._useImplicitConnections then
		self:start()
	end
end

function SingleMotor:__tostring()
	return "Motor(Single)"
end

return SingleMotor

end)
__lua("Spring", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.flipper.src.Spring", "roblox-ts-game.rbxts_include.node_modules.@rbxts.flipper.src", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.flipper.src.Spring")local script,require=_.script,_.require local VELOCITY_THRESHOLD = 0.001
local POSITION_THRESHOLD = 0.001

local EPS = 0.0001

local Spring = {}
Spring.__index = Spring

function Spring.new(targetValue, options)
	assert(targetValue, "Missing argument #1: targetValue")
	options = options or {}

	return setmetatable({
		_targetValue = targetValue,
		_frequency = options.frequency or 4,
		_dampingRatio = options.dampingRatio or 1,
	}, Spring)
end

function Spring:step(state, dt)
	-- Copyright 2018 Parker Stebbins (parker@fractality.io)
	-- github.com/Fraktality/Spring
	-- Distributed under the MIT license

	local d = self._dampingRatio
	local f = self._frequency*2*math.pi
	local g = self._targetValue
	local p0 = state.value
	local v0 = state.velocity or 0

	local offset = p0 - g
	local decay = math.exp(-d*f*dt)

	local p1, v1

	if d == 1 then -- Critically damped
		p1 = (offset*(1 + f*dt) + v0*dt)*decay + g
		v1 = (v0*(1 - f*dt) - offset*(f*f*dt))*decay
	elseif d < 1 then -- Underdamped
		local c = math.sqrt(1 - d*d)

		local i = math.cos(f*c*dt)
		local j = math.sin(f*c*dt)

		-- Damping ratios approaching 1 can cause division by small numbers.
		-- To fix that, group terms around z=j/c and find an approximation for z.
		-- Start with the definition of z:
		--    z = sin(dt*f*c)/c
		-- Substitute a=dt*f:
		--    z = sin(a*c)/c
		-- Take the Maclaurin expansion of z with respect to c:
		--    z = a - (a^3*c^2)/6 + (a^5*c^4)/120 + O(c^6)
		--    z ≈ a - (a^3*c^2)/6 + (a^5*c^4)/120
		-- Rewrite in Horner form:
		--    z ≈ a + ((a*a)*(c*c)*(c*c)/20 - c*c)*(a*a*a)/6

		local z
		if c > EPS then
			z = j/c
		else
			local a = dt*f
			z = a + ((a*a)*(c*c)*(c*c)/20 - c*c)*(a*a*a)/6
		end

		-- Frequencies approaching 0 present a similar problem.
		-- We want an approximation for y as f approaches 0, where:
		--    y = sin(dt*f*c)/(f*c)
		-- Substitute b=dt*c:
		--    y = sin(b*c)/b
		-- Now reapply the process from z.

		local y
		if f*c > EPS then
			y = j/(f*c)
		else
			local b = f*c
			y = dt + ((dt*dt)*(b*b)*(b*b)/20 - b*b)*(dt*dt*dt)/6
		end

		p1 = (offset*(i + d*z) + v0*y)*decay + g
		v1 = (v0*(i - z*d) - offset*(z*f))*decay

	else -- Overdamped
		local c = math.sqrt(d*d - 1)

		local r1 = -f*(d - c)
		local r2 = -f*(d + c)

		local co2 = (v0 - offset*r1)/(2*f*c)
		local co1 = offset - co2

		local e1 = co1*math.exp(r1*dt)
		local e2 = co2*math.exp(r2*dt)

		p1 = e1 + e2 + g
		v1 = e1*r1 + e2*r2
	end

	local complete = math.abs(v1) < VELOCITY_THRESHOLD and math.abs(p1 - g) < POSITION_THRESHOLD
	
	return {
		complete = complete,
		value = complete and g or p1,
		velocity = v1,
	}
end

return Spring
end)
__lua("isMotor", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.flipper.src.isMotor", "roblox-ts-game.rbxts_include.node_modules.@rbxts.flipper.src", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.flipper.src.isMotor")local script,require=_.script,_.require local function isMotor(value)
	local motorType = tostring(value):match("^Motor%((.+)%)$")

	if motorType then
		return true, motorType
	else
		return false
	end
end

return isMotor
end)
__rbx("typings", "Folder", "roblox-ts-game.rbxts_include.node_modules.@rbxts.flipper.typings", "roblox-ts-game.rbxts_include.node_modules.@rbxts.flipper")
__rbx("hax", "Folder", "roblox-ts-game.rbxts_include.node_modules.@rbxts.hax", "roblox-ts-game.rbxts_include.node_modules.@rbxts")
__rbx("types", "Folder", "roblox-ts-game.rbxts_include.node_modules.@rbxts.hax.types", "roblox-ts-game.rbxts_include.node_modules.@rbxts.hax")
__rbx("immut", "Folder", "roblox-ts-game.rbxts_include.node_modules.@rbxts.immut", "roblox-ts-game.rbxts_include.node_modules.@rbxts")
__lua("src", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.immut.src", "roblox-ts-game.rbxts_include.node_modules.@rbxts.immut", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.immut.src")local script,require=_.script,_.require --[=[
	@class Immut

	An immutable data library based on Immer.js
]=]

local Draft = require(script.Draft)
local finishDraft = require(script.finishDraft)
local isDraft = require(script.isDraft)
local isDraftable = require(script.isDraftable)
local original = require(script.original)
local produce = require(script.produce)
local table = require(script.table)
local None = require(script.None)

return {
	createDraft = Draft.new,
	current = finishDraft,
	finishDraft = finishDraft,
	isDraft = isDraft,
	isDraftable = isDraftable,
	original = original,
	produce = produce,
	table = table,
	None = None,
	nothing = None,
}

end)
__lua("Draft", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.immut.src.Draft", "roblox-ts-game.rbxts_include.node_modules.@rbxts.immut.src", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.immut.src.Draft")local script,require=_.script,_.require --!strict
local constants = require(script.Parent.constants)
local getClone = require(script.Parent.getClone)

local BASE = constants.BASE
local CLONE = constants.CLONE

--[=[
	@class Draft

	Drafts are the backbone of Immut. They allow you to interact with a table
	in a way which would normally mutate it, but immutably. Internally, a draft
	stores a reference to the original table and then clones that table as soon
	as you modify it in any way.
]=]
local Draft = {}

--[=[
	@within Immut
	@function createDraft
	@param base table
	@return Draft

	:::tip
	It's unlikely you'll need to use this unless you have a very specific use
	case. Try using `produce` instead!
	:::

	Create a new draft from the given table.
]=]
function Draft.new<T>(base: T)
	assert(typeof(base) == "table", `Drafts can only be based off of tables. Got {typeof(base)}`)
	assert(getmetatable(base :: any) == nil, "Cannot create a draft from a table with an existing metatable.")
	return setmetatable({ [BASE] = base }, Draft) :: any
end

function Draft:__index(key: any)
	local target = rawget(self, CLONE) or rawget(self, BASE)

	local value = target[key] :: any

	if typeof(value) == "table" and getmetatable(value) ~= Draft then
		local nested = Draft.new(value)
		self[key] = nested
		return nested
	end

	return value
end

function Draft:__newindex(key: any, value: any)
	local clone = getClone(self)
	clone[key] = value
end

function Draft:__len()
	return #(rawget(self, CLONE) or rawget(self, BASE))
end

function _next(self, last)
	local target = rawget(self, CLONE) or rawget(self, BASE)

	local key: any? = next(target, last)

	if key == nil then
		return nil
	end

	return key, self[key]
end

function Draft:__iter()
	return _next, self
end

return Draft

end)
__lua("Draft.spec", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.immut.src.Draft.spec", "roblox-ts-game.rbxts_include.node_modules.@rbxts.immut.src", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.immut.src.Draft.spec")local script,require=_.script,_.require --!nocheck
return function()
	local Draft = require(script.Parent.Draft)
	local isDraft = require(script.Parent.isDraft)
	local constants = require(script.Parent.constants)

	local function getClone(t)
		return rawget(t, constants.CLONE)
	end

	local function getBase(t)
		return rawget(t, constants.BASE)
	end

	describe("newindex", function()
		it("should not mutate the original table", function()
			local base = { a = "foo" } :: { a: any, b: any }

			local draft = Draft.new(base)
			draft.a = "bar"
			draft.b = "baz"

			expect(base.a).to.equal("foo")
			expect(base.b).to.equal(nil)
		end)

		it("should mutate the cloned table", function()
			local base = { a = "foo" }

			local draft = Draft.new(base)
			draft.a = "bar"
			draft.b = "baz"

			expect(base.a).to.equal("foo")

			local clone = getClone(draft)

			expect(clone.a).to.equal("bar")
			expect(clone.b).to.equal("baz")
		end)

		it("should clone the table when it has first been modified", function()
			local draft = Draft.new({ a = "foo" })
			expect(getClone(draft)).to.equal(nil)

			draft.b = "bar"

			local clone = getClone(draft)

			expect(clone).to.be.ok()
			expect(clone.a).to.equal("foo")
			expect(clone.b).to.equal("bar")
		end)

		it("should respect setting nil values", function()
			local original = { a = true }

			local draft = Draft.new(original)
			draft.a = nil

			expect(draft.a).to.never.be.ok()
			expect(original.a).to.be.ok()
		end)
	end)

	describe("index", function()
		it("should return new values from the cloned table", function()
			local draft = Draft.new({ a = "foo" })
			draft.a = "bar"
			draft.b = "baz"

			local clone = getClone(draft)

			expect(draft.a).to.equal(clone.a)
			expect(draft.b).to.equal(clone.b)
		end)

		it("should return unmodified values from the original table", function()
			local base = { a = "foo" }

			local draft = Draft.new(base)
			draft.b = "baz"

			expect(draft.a).to.equal(base.a)
		end)

		it("should turn nested tables into drafts when indexed", function()
			local draft = Draft.new({
				nested = {
					doubleNested = {},
				},
			})

			expect(isDraft(draft)).to.equal(true)
			expect(isDraft(draft.nested)).to.equal(true)
			expect(isDraft(draft.nested.doubleNested)).to.equal(true)
		end)

		it("should return the same nested draft when indexed more than once", function()
			local draft = Draft.new({
				nested = {
					doubleNested = {},
				},
			})

			local nested1 = draft.nested
			local nested2 = draft.nested

			expect(nested1).to.equal(nested2)
			expect(nested2).to.equal(nested1)
		end)
	end)

	describe("iter", function()
		it("should iterate through base table when unmodified and cloned table when modified", function()
			local base = {}

			for i = 1, 10 do
				base[i] = "original"
			end

			local draft = Draft.new(base)

			for i, v in draft do
				expect(v).to.equal("original")
				draft[i] = "modified"
			end

			local clone = getClone(draft)

			for i, v in draft do
				expect(v).to.equal("modified")
				expect(clone[i]).to.equal("modified")
				expect(base[i]).to.equal("original")
			end
		end)

		it("should return drafts for any nested tables", function()
			local base = {
				a = {},
				b = {},
				c = {},
			}

			local draft = Draft.new(base)

			for k, v in draft do
				expect(isDraft(v)).to.equal(true)
				expect(getBase(v)).to.equal(base[k])
			end
		end)
	end)

	describe("len", function()
		it("should return the correct number of values", function()
			local original = { "foo", "bar", "baz" }

			local draft = Draft.new(original)

			expect(#original).to.equal(3)
			expect(#draft).to.equal(3)

			draft[4] = "qux"

			expect(#draft).to.equal(4)
		end)
	end)
end

end)
__lua("None", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.immut.src.None", "roblox-ts-game.rbxts_include.node_modules.@rbxts.immut.src", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.immut.src.None")local script,require=_.script,_.require --[=[
	@within Immut
	@prop None None

	When returned from a recipe, the next value will be nil.

	```lua
	local new = produce(state, function(draft)
		return None
	end)

	print(new) -- nil
	```
]=]

--[=[
	@within Immut
	@prop nothing None

	Alias for [`None`](/api/Immut#None)
]=]

local None = setmetatable({}, {
	__tostring = function()
		return "<Immut.None>"
	end,
})

return None

end)
__lua("constants", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.immut.src.constants", "roblox-ts-game.rbxts_include.node_modules.@rbxts.immut.src", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.immut.src.constants")local script,require=_.script,_.require return {
	CLONE = "_clone",
	BASE = "_base",
}

end)
__lua("finishDraft", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.immut.src.finishDraft", "roblox-ts-game.rbxts_include.node_modules.@rbxts.immut.src", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.immut.src.finishDraft")local script,require=_.script,_.require local isDraft = require(script.Parent.isDraft)
local constants = require(script.Parent.constants)

local BASE = constants.BASE
local CLONE = constants.CLONE

--[=[
	@within Immut
	@function current
	@param draft Draft
	@return table

	Returns a snapshot of the current state of a draft. This can be expensive,
	so use it sparingly.
]=]

--[=[
	@within Immut
	@param draft T
	@return T?

	:::tip
	It's unlikely you'll need to use this unless you have a very specific use
	case. Try using `produce` instead!
	:::

	Finalize a draft. When given [`None`](/api/Immut#None), returns `nil`. When
	given a non-draft value, returns that value.
]=]
local function finishDraft<T>(draft: T): T
	if typeof(draft) ~= "table" then
		return draft
	end

	local final = draft

	if isDraft(draft) then
		final = rawget(draft, CLONE)

		if final == nil then
			return rawget(draft, BASE)
		end
	end

	for key, value in final do
		final[key] = finishDraft(value)
	end

	return final
end

return finishDraft

end)
__lua("finishDraft.spec", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.immut.src.finishDraft.spec", "roblox-ts-game.rbxts_include.node_modules.@rbxts.immut.src", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.immut.src.finishDraft.spec")local script,require=_.script,_.require return function()
	local Draft = require(script.Parent.Draft)
	local finishDraft = require(script.Parent.finishDraft)

	it("should return the given value when it is not a draft", function()
		local base = {}
		expect(finishDraft(base)).to.equal(base)
		expect(finishDraft(1)).to.equal(1)
		expect(finishDraft("foo")).to.equal("foo")
		expect(finishDraft(false)).to.equal(false)
		expect(finishDraft(nil)).to.equal(nil)
	end)

	it("should return the original table when the given draft was not modified", function()
		local original = { foo = true }

		local draft = Draft.new(original)

		local finished = finishDraft(draft)

		expect(finished).to.equal(original)
	end)

	it("should return a new table when the given draft was modified", function()
		local original = { foo = true }

		local draft = Draft.new(original)
		draft.bar = true

		local finished = finishDraft(draft)
		expect(finished).to.never.equal(original)
		expect(finished.foo).to.equal(true)
		expect(finished.bar).to.equal(true)
	end)
end

end)
__lua("getClone", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.immut.src.getClone", "roblox-ts-game.rbxts_include.node_modules.@rbxts.immut.src", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.immut.src.getClone")local script,require=_.script,_.require local constants = require(script.Parent.constants)

local CLONE = constants.CLONE
local BASE = constants.BASE

local function getClone(draft)
	local clone = rawget(draft, CLONE)

	if clone == nil then
		clone = table.clone(rawget(draft, BASE))
		rawset(draft, CLONE, clone)
	end

	return clone
end

return getClone

end)
__lua("getClone.spec", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.immut.src.getClone.spec", "roblox-ts-game.rbxts_include.node_modules.@rbxts.immut.src", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.immut.src.getClone.spec")local script,require=_.script,_.require return function()
	local CLONE = require(script.Parent.constants).CLONE

	local Draft = require(script.Parent.Draft)
	local getClone = require(script.Parent.getClone)

	it("should return a draft's cloned table if it exists", function()
		local draft = Draft.new({})
		draft.foo = true

		expect(rawget(draft, CLONE)).to.be.ok()

		local clone = getClone(draft)

		expect(rawget(draft, CLONE)).to.equal(clone)
	end)

	it("should create a clone if a draft does not have one", function()
		local draft = Draft.new({})

		expect(rawget(draft, CLONE)).to.never.be.ok()

		local clone = getClone(draft)

		expect(rawget(draft, CLONE)).to.be.ok()
		expect(rawget(draft, CLONE)).to.equal(clone)
	end)
end

end)
__lua("init.spec", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.immut.src.init.spec", "roblox-ts-game.rbxts_include.node_modules.@rbxts.immut.src", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.immut.src.init.spec")local script,require=_.script,_.require return function()
	local immut = require(script.Parent)

	it("should load", function()
		expect(immut).to.be.ok()
	end)
end

end)
__lua("isDraft", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.immut.src.isDraft", "roblox-ts-game.rbxts_include.node_modules.@rbxts.immut.src", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.immut.src.isDraft")local script,require=_.script,_.require local Draft = require(script.Parent.Draft)

--[=[
	@within Immut

	Checks if the given value is a draft.
]=]
local function isDraft(value: any): boolean
	if typeof(value) ~= "table" then
		return false
	end

	if getmetatable(value) ~= Draft then
		return false
	end

	return true
end

return isDraft

end)
__lua("isDraft.spec", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.immut.src.isDraft.spec", "roblox-ts-game.rbxts_include.node_modules.@rbxts.immut.src", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.immut.src.isDraft.spec")local script,require=_.script,_.require --!nocheck
return function()
	local isDraft = require(script.Parent.isDraft)
	local Draft = require(script.Parent.Draft)

	it("should return false when given a value that isn't a draft", function()
		expect(isDraft(true)).to.equal(false)
		expect(isDraft({})).to.equal(false)
		expect(isDraft(setmetatable({}, {}))).to.equal(false)
	end)

	it("should return true when given a draft", function()
		expect(isDraft(Draft.new({}))).to.equal(true)
	end)
end

end)
__lua("isDraftable", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.immut.src.isDraftable", "roblox-ts-game.rbxts_include.node_modules.@rbxts.immut.src", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.immut.src.isDraftable")local script,require=_.script,_.require --[=[
	@within Immut

	Checks if a value can be wrapped with a draft. Tables without metatables
	are the only draftable values.
]=]
local function isDraftable(value: any): boolean
	if typeof(value) == "table" and getmetatable(value) == nil then
		return true
	end

	return false
end

return isDraftable

end)
__lua("isDraftable.spec", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.immut.src.isDraftable.spec", "roblox-ts-game.rbxts_include.node_modules.@rbxts.immut.src", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.immut.src.isDraftable.spec")local script,require=_.script,_.require return function()
	local isDraftable = require(script.Parent.isDraftable)

	it("should return false when given a value that is not a table", function()
		expect(isDraftable(1)).to.equal(false)
		expect(isDraftable(true)).to.equal(false)
		expect(isDraftable("string")).to.equal(false)
		expect(isDraftable(nil)).to.equal(false)
	end)

	it("should return false when given a table that has a metatable", function()
		expect(isDraftable(setmetatable({}, {}))).to.equal(false)
	end)

	it("should return true when given a table with no metatable", function()
		expect(isDraftable({})).to.equal(true)
	end)
end

end)
__lua("makeDraftSafe", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.immut.src.makeDraftSafe", "roblox-ts-game.rbxts_include.node_modules.@rbxts.immut.src", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.immut.src.makeDraftSafe")local script,require=_.script,_.require --!strict
local isDraft = require(script.Parent.isDraft)
local getClone = require(script.Parent.getClone)

type Draft<K, V> = { [K]: V }
type Mutator<K, V, Args..., Return...> = (draft: Draft<K, V>, Args...) -> Return...

--[=[
	@within Immut
	@function makeDraftSafe
	@param fn T
	@return T

	A wrapper for functions that bypass metatables (like using rawset) that will
	make them draft-safe. `makeDraftSafe` is only necessary if the function will 
	mutate the table. If the unsafe function is only reading from the table
	(using rawget), consider using [`original`](/api/Immut#original) or 
	[`current`](/api/Immut#current) instead.

	This is used internally to wrap functions within Luau's table library, and
	is exposed for your convenience.

	```lua
	local remove = makeDraftSafe(table.remove)
	local insert = makeDraftSafe(table.insert)

	local nextState = produce(state, function(draft)
		local value = remove(draft.a, 1)
		insert(draft.b, 1, value)
	end)
	```
]=]
local function makeDraftSafe<K, V, Args..., Return...>(fn: Mutator<K, V, Args..., Return...>): Mutator<K, V, Args..., Return...>
	return function(draft, ...)
		local t = draft

		if isDraft(t) then
			t = getClone(t :: any) :: any
		end

		return fn(t, ...)
	end
end

return makeDraftSafe

end)
__lua("makeDraftSafe.spec", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.immut.src.makeDraftSafe.spec", "roblox-ts-game.rbxts_include.node_modules.@rbxts.immut.src", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.immut.src.makeDraftSafe.spec")local script,require=_.script,_.require return function()
	local Draft = require(script.Parent.Draft)
	local makeDraftSafe = require(script.Parent.makeDraftSafe)

	it("should return a draft-safe version of the given function", function()
		local function unsafe(t, k, v)
			rawset(t, k, v)
		end

		local draft = Draft.new({})

		local safe = makeDraftSafe(unsafe)
		safe(draft, "foo", "bar")

		expect(rawget(draft, "foo")).to.never.be.ok()
		expect(draft.foo).to.equal("bar")
	end)
end

end)
__lua("original", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.immut.src.original", "roblox-ts-game.rbxts_include.node_modules.@rbxts.immut.src", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.immut.src.original")local script,require=_.script,_.require local isDraft = require(script.Parent.isDraft)
local constants = require(script.Parent.constants)

local BASE = constants.BASE

--[=[
	@within Immut

	Returns the original table. You can use this to opt out of Immut for any
	table, like in cases where it may be more performant to use another method.
]=]
local function original<T>(draft: T)
	assert(isDraft(draft), "Immut.original can only be called on drafts")
	return rawget(draft :: any, BASE) :: T
end

return original

end)
__lua("original.spec", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.immut.src.original.spec", "roblox-ts-game.rbxts_include.node_modules.@rbxts.immut.src", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.immut.src.original.spec")local script,require=_.script,_.require --!nocheck
return function()
	local isDraft = require(script.Parent.isDraft)
	local Draft = require(script.Parent.Draft)

	it("should return false when given a value that isn't a draft", function()
		expect(isDraft(true)).to.equal(false)
		expect(isDraft({})).to.equal(false)
		expect(isDraft(setmetatable({}, {}))).to.equal(false)
	end)

	it("should return true when given a draft", function()
		expect(isDraft(Draft.new({}))).to.equal(true)
	end)
end

end)
__lua("produce", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.immut.src.produce", "roblox-ts-game.rbxts_include.node_modules.@rbxts.immut.src", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.immut.src.produce")local script,require=_.script,_.require --!strict
local Draft = require(script.Parent.Draft)
local None = require(script.Parent.None)
local finishDraft = require(script.Parent.finishDraft)
local isDraftable = require(script.Parent.isDraftable)

-- i've tried two type definitions for recipes, neither of which are that great.

-- when using this type, autocompletion for `draft` stops working
-- type Recipe<T> = ((draft: T) -> ()) | ((draft: T) -> T) | ((draft: T) -> nil)

-- when using this type, recipes will always need to explicitly return something.
-- `draft` autocompletion works though, so i think this is better, but not ideal.
type Recipe<T> = ((draft: T) -> (T? | typeof(None)))

--[=[
	@within Immut
	@param base any -- any value is acceptable, so long as it isn't a table with a metatable
	@param recipe (draft: Draft) -> any?

	The primary way to use Immut. Takes a value and a recipe function which is
	passed a draft that can be mutated, producing a new table with those changes
	made to it.

	### Examples

	```lua
	local state = {
		pets = {
			mittens = {
				type = "cat",
				mood = "lonely",
			},
		}
	}

	-- mittens is lonely. let's get her a friend
	local newState = produce(state, function(draft)
		draft.pets.spot = {
			type = "dog",
			mood = "curious",
		}

		draft.pets.mittens.mood = "happy"
	end)
	```

	Recipe functions do not need to return anything. When they do, the returned
	value will be used instead of the draft.

	:::tip
	When in strict mode, recipes do need an explicit return. You can simply
	return the draft or nil to avoid type errors.
	:::

	```lua
	local newState = produce(state, function(draft)
		return {} -- newState becomes an empty table
	end)
	```
]=]
local function produce<T>(base: T, recipe: Recipe<T>): T?
	local proxy = isDraftable(base) and Draft.new(base) or base :: T

	local nextValue = recipe(proxy) or proxy

	if nextValue == None then
		return nil
	end

	return finishDraft(nextValue)
end

return produce

end)
__lua("produce.spec", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.immut.src.produce.spec", "roblox-ts-game.rbxts_include.node_modules.@rbxts.immut.src", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.immut.src.produce.spec")local script,require=_.script,_.require --!nocheck
return function()
	local None = require(script.Parent.None)
	local produce = require(script.Parent.produce)

	it("should not mutate the original table", function()
		local original = { number = 2 }

		local new = produce(original, function(draft)
			draft.foo = true
			draft.number += 2
		end)

		expect(new.foo).to.equal(true)
		expect(new.number).to.equal(4)
		expect(original.foo).to.equal(nil)
		expect(original.number).to.equal(2)
		expect(original).to.never.equal(new)
	end)

	it("should not mutate nested tables", function()
		local original = {
			modified = nil,
			nested = {
				modified = nil,
				nestedDeep = { modified = nil },
			},
		}

		local new = produce(original, function(draft)
			draft.nested.modified = true
			draft.nested.nestedDeep.modified = true
		end)

		expect(new.nested.modified).to.be.ok()
		expect(new.nested.nestedDeep.modified).to.be.ok()
		expect(original.nested.modified).to.never.be.ok()
		expect(original.nested.nestedDeep.modified).to.never.be.ok()
	end)

	it("should return the return value of the recipe when not nil or None", function()
		local override = { foo = true }

		local new = produce({}, function(_draft)
			return override
		end)

		expect(new.foo).to.equal(true)
		expect(new).to.equal(override)
	end)

	it("should return nil when the return value of the recipe is None", function()
		local new = produce({}, function(_draft)
			return None
		end)

		expect(new).to.equal(nil)
	end)

	it("should accept non-table non-draftable base", function()
		expect(function()
			produce(1, function() end)
		end).to.never.throw()

		expect(function()
			produce(true, function() end)
		end).to.never.throw()

		expect(function()
			produce("string", function() end)
		end).to.never.throw()

		expect(function()
			produce(nil, function() end)
		end).to.never.throw()
	end)

	it("should be able to return non-table non-draftable values", function()
		do
			local new = produce(nil, function() end)
			expect(new).to.equal(nil)
		end

		do
			local new = produce(1, function() end)
			expect(new).to.equal(1)
		end

		do
			local new = produce("string", function() end)
			expect(new).to.equal("string")
		end

		do
			local new = produce(true, function() end)
			expect(new).to.equal(true)
		end
	end)
end

end)
__lua("table", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.immut.src.table", "roblox-ts-game.rbxts_include.node_modules.@rbxts.immut.src", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.immut.src.table")local script,require=_.script,_.require local makeDraftSafe = require(script.Parent.makeDraftSafe)

--[=[
	@class table

	Draft-safe table library replacement.
]=]

--[=[
	@within table
	@function insert
	@param t { V }
	@param pos number
	@param value V

	https://create.roblox.com/docs/reference/engine/libraries/table#insert
]=]

--[=[
	@within table
	@function remove
	@param t { V }
	@param pos number?
	@return V?

	https://create.roblox.com/docs/reference/engine/libraries/table#remove
]=]

--[=[
	@within table
	@function sort
	@param t { V }
	@param comp function

	https://create.roblox.com/docs/reference/engine/libraries/table#sort
]=]

--[=[
	@within table
	@function clear
	@param t { [K]: V }

	https://create.roblox.com/docs/reference/engine/libraries/table#clear
]=]

return {
	remove = makeDraftSafe(table.remove),
	sort = makeDraftSafe(table.sort),
	clear = makeDraftSafe(table.clear),

	-- we cannot preserve the type of table.insert when passing it through
	-- makeDraftSafe because it is an overloaded function. this workaround
	-- will fix that (for now)
	insert = (makeDraftSafe(table.insert) :: any) :: typeof(table.insert),

	makeDraftSafe = makeDraftSafe,
}

end)
__rbx("roact", "Folder", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roact", "roblox-ts-game.rbxts_include.node_modules.@rbxts")
__lua("src", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roact", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src")local script,require=_.script,_.require --~strict
--[[
	Packages up the internals of Roact and exposes a public API for it.
]]

local GlobalConfig = require(script.GlobalConfig)
local createReconciler = require(script.createReconciler)
local createReconcilerCompat = require(script.createReconcilerCompat)
local RobloxRenderer = require(script.RobloxRenderer)
local strict = require(script.strict)
local Binding = require(script.Binding)

local robloxReconciler = createReconciler(RobloxRenderer)
local reconcilerCompat = createReconcilerCompat(robloxReconciler)

local Roact = strict({
	Component = require(script.Component),
	createElement = require(script.createElement),
	createFragment = require(script.createFragment),
	oneChild = require(script.oneChild),
	PureComponent = require(script.PureComponent),
	None = require(script.None),
	Portal = require(script.Portal),
	createRef = require(script.createRef),
	forwardRef = require(script.forwardRef),
	createBinding = Binding.create,
	joinBindings = Binding.join,
	createContext = require(script.createContext),

	Change = require(script.PropMarkers.Change),
	Children = require(script.PropMarkers.Children),
	Event = require(script.PropMarkers.Event),
	Ref = require(script.PropMarkers.Ref),

	mount = robloxReconciler.mountVirtualTree,
	unmount = robloxReconciler.unmountVirtualTree,
	update = robloxReconciler.updateVirtualTree,

	reify = reconcilerCompat.reify,
	teardown = reconcilerCompat.teardown,
	reconcile = reconcilerCompat.reconcile,

	setGlobalConfig = GlobalConfig.set,

	-- APIs that may change in the future without warning
	UNSTABLE = {},
})

return Roact

end)
__lua("Binding", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src.Binding", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src.Binding")local script,require=_.script,_.require local createSignal = require(script.Parent.createSignal)
local Symbol = require(script.Parent.Symbol)
local Type = require(script.Parent.Type)

local config = require(script.Parent.GlobalConfig).get()

local BindingImpl = Symbol.named("BindingImpl")

local BindingInternalApi = {}

local bindingPrototype = {}

function bindingPrototype:getValue()
	return BindingInternalApi.getValue(self)
end

function bindingPrototype:map(predicate)
	return BindingInternalApi.map(self, predicate)
end

local BindingPublicMeta = {
	__index = bindingPrototype,
	__tostring = function(self)
		return string.format("RoactBinding(%s)", tostring(self:getValue()))
	end,
}

function BindingInternalApi.update(binding, newValue)
	return binding[BindingImpl].update(newValue)
end

function BindingInternalApi.subscribe(binding, callback)
	return binding[BindingImpl].subscribe(callback)
end

function BindingInternalApi.getValue(binding)
	return binding[BindingImpl].getValue()
end

function BindingInternalApi.create(initialValue)
	local impl = {
		value = initialValue,
		changeSignal = createSignal(),
	}

	function impl.subscribe(callback)
		return impl.changeSignal:subscribe(callback)
	end

	function impl.update(newValue)
		impl.value = newValue
		impl.changeSignal:fire(newValue)
	end

	function impl.getValue()
		return impl.value
	end

	return setmetatable({
		[Type] = Type.Binding,
		[BindingImpl] = impl,
	}, BindingPublicMeta), impl.update
end

function BindingInternalApi.map(upstreamBinding, predicate)
	if config.typeChecks then
		assert(Type.of(upstreamBinding) == Type.Binding, "Expected arg #1 to be a binding")
		assert(typeof(predicate) == "function", "Expected arg #1 to be a function")
	end

	local impl = {}

	function impl.subscribe(callback)
		return BindingInternalApi.subscribe(upstreamBinding, function(newValue)
			callback(predicate(newValue))
		end)
	end

	function impl.update(_newValue)
		error("Bindings created by Binding:map(fn) cannot be updated directly", 2)
	end

	function impl.getValue()
		return predicate(upstreamBinding:getValue())
	end

	return setmetatable({
		[Type] = Type.Binding,
		[BindingImpl] = impl,
	}, BindingPublicMeta)
end

function BindingInternalApi.join(upstreamBindings)
	if config.typeChecks then
		assert(typeof(upstreamBindings) == "table", "Expected arg #1 to be of type table")

		for key, value in pairs(upstreamBindings) do
			if Type.of(value) ~= Type.Binding then
				local message = ("Expected arg #1 to contain only bindings, but key %q had a non-binding value"):format(
					tostring(key)
				)
				error(message, 2)
			end
		end
	end

	local impl = {}

	local function getValue()
		local value = {}

		for key, upstream in pairs(upstreamBindings) do
			value[key] = upstream:getValue()
		end

		return value
	end

	function impl.subscribe(callback)
		local disconnects = {}

		for key, upstream in pairs(upstreamBindings) do
			disconnects[key] = BindingInternalApi.subscribe(upstream, function(_newValue)
				callback(getValue())
			end)
		end

		return function()
			if disconnects == nil then
				return
			end

			for _, disconnect in pairs(disconnects) do
				disconnect()
			end

			disconnects = nil :: any
		end
	end

	function impl.update(_newValue)
		error("Bindings created by joinBindings(...) cannot be updated directly", 2)
	end

	function impl.getValue()
		return getValue()
	end

	return setmetatable({
		[Type] = Type.Binding,
		[BindingImpl] = impl,
	}, BindingPublicMeta)
end

return BindingInternalApi

end)
__lua("Component", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src.Component", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src.Component")local script,require=_.script,_.require local assign = require(script.Parent.assign)
local ComponentLifecyclePhase = require(script.Parent.ComponentLifecyclePhase)
local Type = require(script.Parent.Type)
local Symbol = require(script.Parent.Symbol)
local invalidSetStateMessages = require(script.Parent.invalidSetStateMessages)
local internalAssert = require(script.Parent.internalAssert)

local config = require(script.Parent.GlobalConfig).get()

--[[
	Calling setState during certain lifecycle allowed methods has the potential
	to create an infinitely updating component. Rather than time out, we exit
	with an error if an unreasonable number of self-triggering updates occur
]]
local MAX_PENDING_UPDATES = 100

local InternalData = Symbol.named("InternalData")

local componentMissingRenderMessage = [[
The component %q is missing the `render` method.
`render` must be defined when creating a Roact component!]]

local tooManyUpdatesMessage = [[
The component %q has reached the setState update recursion limit.
When using `setState` in `didUpdate`, make sure that it won't repeat infinitely!]]

local componentClassMetatable = {}

function componentClassMetatable:__tostring()
	return self.__componentName
end

local Component = {}
setmetatable(Component, componentClassMetatable)

Component[Type] = Type.StatefulComponentClass
Component.__index = Component
Component.__componentName = "Component"

--[[
	A method called by consumers of Roact to create a new component class.
	Components can not be extended beyond this point, with the exception of
	PureComponent.
]]
function Component:extend(name)
	if config.typeChecks then
		assert(Type.of(self) == Type.StatefulComponentClass, "Invalid `self` argument to `extend`.")
		assert(typeof(name) == "string", "Component class name must be a string")
	end

	local class = {}

	for key, value in pairs(self) do
		-- Roact opts to make consumers use composition over inheritance, which
		-- lines up with React.
		-- https://reactjs.org/docs/composition-vs-inheritance.html
		if key ~= "extend" then
			class[key] = value
		end
	end

	class[Type] = Type.StatefulComponentClass
	class.__index = class
	class.__componentName = name

	setmetatable(class, componentClassMetatable)

	return class
end

function Component:__getDerivedState(incomingProps, incomingState)
	if config.internalTypeChecks then
		internalAssert(Type.of(self) == Type.StatefulComponentInstance, "Invalid use of `__getDerivedState`")
	end

	local internalData = self[InternalData]
	local componentClass = internalData.componentClass

	if componentClass.getDerivedStateFromProps ~= nil then
		local derivedState = componentClass.getDerivedStateFromProps(incomingProps, incomingState)

		if derivedState ~= nil then
			if config.typeChecks then
				assert(typeof(derivedState) == "table", "getDerivedStateFromProps must return a table!")
			end

			return derivedState
		end
	end

	return nil
end

function Component:setState(mapState)
	if config.typeChecks then
		assert(Type.of(self) == Type.StatefulComponentInstance, "Invalid `self` argument to `extend`.")
	end

	local internalData = self[InternalData]
	local lifecyclePhase = internalData.lifecyclePhase

	--[[
		When preparing to update, render, or unmount, it is not safe
		to call `setState` as it will interfere with in-flight updates. It's
		also disallowed during unmounting
	]]
	if
		lifecyclePhase == ComponentLifecyclePhase.ShouldUpdate
		or lifecyclePhase == ComponentLifecyclePhase.WillUpdate
		or lifecyclePhase == ComponentLifecyclePhase.Render
	then
		local messageTemplate = invalidSetStateMessages[internalData.lifecyclePhase]

		local message = messageTemplate:format(tostring(internalData.componentClass))
		error(message, 2)
	elseif lifecyclePhase == ComponentLifecyclePhase.WillUnmount then
		-- Should not print error message. See https://github.com/facebook/react/pull/22114
		return
	end

	local pendingState = internalData.pendingState

	local partialState
	if typeof(mapState) == "function" then
		partialState = mapState(pendingState or self.state, self.props)

		-- Abort the state update if the given state updater function returns nil
		if partialState == nil then
			return
		end
	elseif typeof(mapState) == "table" then
		partialState = mapState
	else
		error("Invalid argument to setState, expected function or table", 2)
	end

	local newState
	if pendingState ~= nil then
		newState = assign(pendingState, partialState)
	else
		newState = assign({}, self.state, partialState)
	end

	if lifecyclePhase == ComponentLifecyclePhase.Init then
		-- If `setState` is called in `init`, we can skip triggering an update!
		local derivedState = self:__getDerivedState(self.props, newState)
		self.state = assign(newState, derivedState)
	elseif
		lifecyclePhase == ComponentLifecyclePhase.DidMount
		or lifecyclePhase == ComponentLifecyclePhase.DidUpdate
		or lifecyclePhase == ComponentLifecyclePhase.ReconcileChildren
	then
		--[[
			During certain phases of the component lifecycle, it's acceptable to
			allow `setState` but defer the update until we're done with ones in flight.
			We do this by collapsing it into any pending updates we have.
		]]
		local derivedState = self:__getDerivedState(self.props, newState)
		internalData.pendingState = assign(newState, derivedState)
	elseif lifecyclePhase == ComponentLifecyclePhase.Idle then
		-- Outside of our lifecycle, the state update is safe to make immediately
		self:__update(nil, newState)
	else
		local messageTemplate = invalidSetStateMessages.default

		local message = messageTemplate:format(tostring(internalData.componentClass))

		error(message, 2)
	end
end

--[[
	Returns the stack trace of where the element was created that this component
	instance's properties are based on.

	Intended to be used primarily by diagnostic tools.
]]
function Component:getElementTraceback()
	return self[InternalData].virtualNode.currentElement.source
end

--[[
	Returns a snapshot of this component given the current props and state. Must
	be overridden by consumers of Roact and should be a pure function with
	regards to props and state.

	TODO (#199): Accept props and state as arguments.
]]
function Component:render()
	local internalData = self[InternalData]

	local message = componentMissingRenderMessage:format(tostring(internalData.componentClass))

	error(message, 0)
end

--[[
	Retrieves the context value corresponding to the given key. Can return nil
	if a requested context key is not present
]]
function Component:__getContext(key)
	if config.internalTypeChecks then
		internalAssert(Type.of(self) == Type.StatefulComponentInstance, "Invalid use of `__getContext`")
		internalAssert(key ~= nil, "Context key cannot be nil")
	end

	local virtualNode = self[InternalData].virtualNode
	local context = virtualNode.context

	return context[key]
end

--[[
	Adds a new context entry to this component's context table (which will be
	passed down to child components).
]]
function Component:__addContext(key, value)
	if config.internalTypeChecks then
		internalAssert(Type.of(self) == Type.StatefulComponentInstance, "Invalid use of `__addContext`")
	end
	local virtualNode = self[InternalData].virtualNode

	-- Make sure we store a reference to the component's original, unmodified
	-- context the virtual node. In the reconciler, we'll restore the original
	-- context if we need to replace the node (this happens when a node gets
	-- re-rendered as a different component)
	if virtualNode.originalContext == nil then
		virtualNode.originalContext = virtualNode.context
	end

	-- Build a new context table on top of the existing one, then apply it to
	-- our virtualNode
	local existing = virtualNode.context
	virtualNode.context = assign({}, existing, { [key] = value })
end

--[[
	Performs property validation if the static method validateProps is declared.
	validateProps should follow assert's expected arguments:
	(false, message: string) | true. The function may return a message in the
	true case; it will be ignored. If this fails, the function will throw the
	error.
]]
function Component:__validateProps(props)
	if not config.propValidation then
		return
	end

	local validator = self[InternalData].componentClass.validateProps

	if validator == nil then
		return
	end

	if typeof(validator) ~= "function" then
		error(
			("validateProps must be a function, but it is a %s.\nCheck the definition of the component %q."):format(
				typeof(validator),
				self.__componentName
			)
		)
	end

	local success, failureReason = validator(props)

	if not success then
		failureReason = failureReason or "<Validator function did not supply a message>"
		error(
			("Property validation failed in %s: %s\n\n%s"):format(
				self.__componentName,
				tostring(failureReason),
				self:getElementTraceback() or "<enable element tracebacks>"
			),
			0
		)
	end
end

--[[
	An internal method used by the reconciler to construct a new component
	instance and attach it to the given virtualNode.
]]
function Component:__mount(reconciler, virtualNode)
	if config.internalTypeChecks then
		internalAssert(Type.of(self) == Type.StatefulComponentClass, "Invalid use of `__mount`")
		internalAssert(Type.of(virtualNode) == Type.VirtualNode, "Expected arg #2 to be of type VirtualNode")
	end

	local currentElement = virtualNode.currentElement
	local hostParent = virtualNode.hostParent

	-- Contains all the information that we want to keep from consumers of
	-- Roact, or even other parts of the codebase like the reconciler.
	local internalData = {
		reconciler = reconciler,
		virtualNode = virtualNode,
		componentClass = self,
		lifecyclePhase = ComponentLifecyclePhase.Init,
		pendingState = nil,
	}

	local instance = {
		[Type] = Type.StatefulComponentInstance,
		[InternalData] = internalData,
	}

	setmetatable(instance, self)

	virtualNode.instance = instance

	local props = currentElement.props

	if self.defaultProps ~= nil then
		props = assign({}, self.defaultProps, props)
	end

	instance:__validateProps(props)

	instance.props = props

	local newContext = assign({}, virtualNode.legacyContext)
	instance._context = newContext

	instance.state = assign({}, instance:__getDerivedState(instance.props, {}))

	if instance.init ~= nil then
		instance:init(instance.props)
		assign(instance.state, instance:__getDerivedState(instance.props, instance.state))
	end

	-- It's possible for init() to redefine _context!
	virtualNode.legacyContext = instance._context

	internalData.lifecyclePhase = ComponentLifecyclePhase.Render
	local renderResult = instance:render()

	internalData.lifecyclePhase = ComponentLifecyclePhase.ReconcileChildren
	reconciler.updateVirtualNodeWithRenderResult(virtualNode, hostParent, renderResult)

	if instance.didMount ~= nil then
		internalData.lifecyclePhase = ComponentLifecyclePhase.DidMount
		instance:didMount()
	end

	if internalData.pendingState ~= nil then
		-- __update will handle pendingState, so we don't pass any new element or state
		instance:__update(nil, nil)
	end

	internalData.lifecyclePhase = ComponentLifecyclePhase.Idle
end

--[[
	Internal method used by the reconciler to clean up any resources held by
	this component instance.
]]
function Component:__unmount()
	if config.internalTypeChecks then
		internalAssert(Type.of(self) == Type.StatefulComponentInstance, "Invalid use of `__unmount`")
	end

	local internalData = self[InternalData]
	local virtualNode = internalData.virtualNode
	local reconciler = internalData.reconciler

	if self.willUnmount ~= nil then
		internalData.lifecyclePhase = ComponentLifecyclePhase.WillUnmount
		self:willUnmount()
	end

	for _, childNode in pairs(virtualNode.children) do
		reconciler.unmountVirtualNode(childNode)
	end
end

--[[
	Internal method used by setState (to trigger updates based on state) and by
	the reconciler (to trigger updates based on props)

	Returns true if the update was completed, false if it was cancelled by shouldUpdate
]]
function Component:__update(updatedElement, updatedState)
	if config.internalTypeChecks then
		internalAssert(Type.of(self) == Type.StatefulComponentInstance, "Invalid use of `__update`")
		internalAssert(
			Type.of(updatedElement) == Type.Element or updatedElement == nil,
			"Expected arg #1 to be of type Element or nil"
		)
		internalAssert(
			typeof(updatedState) == "table" or updatedState == nil,
			"Expected arg #2 to be of type table or nil"
		)
	end

	local internalData = self[InternalData]
	local componentClass = internalData.componentClass

	local newProps = self.props
	if updatedElement ~= nil then
		newProps = updatedElement.props

		if componentClass.defaultProps ~= nil then
			newProps = assign({}, componentClass.defaultProps, newProps)
		end

		self:__validateProps(newProps)
	end

	local updateCount = 0
	repeat
		local finalState
		local pendingState = nil

		-- Consume any pending state we might have
		if internalData.pendingState ~= nil then
			pendingState = internalData.pendingState
			internalData.pendingState = nil
		end

		-- Consume a standard update to state or props
		if updatedState ~= nil or newProps ~= self.props then
			if pendingState == nil then
				finalState = updatedState or self.state
			else
				finalState = assign(pendingState, updatedState)
			end

			local derivedState = self:__getDerivedState(newProps, finalState)

			if derivedState ~= nil then
				finalState = assign({}, finalState, derivedState)
			end

			updatedState = nil
		else
			finalState = pendingState
		end

		if not self:__resolveUpdate(newProps, finalState) then
			-- If the update was short-circuited, bubble the result up to the caller
			return false
		end

		updateCount = updateCount + 1

		if updateCount > MAX_PENDING_UPDATES then
			error(tooManyUpdatesMessage:format(tostring(internalData.componentClass)), 3)
		end
	until internalData.pendingState == nil

	return true
end

--[[
	Internal method used by __update to apply new props and state

	Returns true if the update was completed, false if it was cancelled by shouldUpdate
]]
function Component:__resolveUpdate(incomingProps, incomingState)
	if config.internalTypeChecks then
		internalAssert(Type.of(self) == Type.StatefulComponentInstance, "Invalid use of `__resolveUpdate`")
	end

	local internalData = self[InternalData]
	local virtualNode = internalData.virtualNode
	local reconciler = internalData.reconciler

	local oldProps = self.props
	local oldState = self.state

	if incomingProps == nil then
		incomingProps = oldProps
	end
	if incomingState == nil then
		incomingState = oldState
	end

	if self.shouldUpdate ~= nil then
		internalData.lifecyclePhase = ComponentLifecyclePhase.ShouldUpdate
		local continueWithUpdate = self:shouldUpdate(incomingProps, incomingState)

		if not continueWithUpdate then
			internalData.lifecyclePhase = ComponentLifecyclePhase.Idle
			return false
		end
	end

	if self.willUpdate ~= nil then
		internalData.lifecyclePhase = ComponentLifecyclePhase.WillUpdate
		self:willUpdate(incomingProps, incomingState)
	end

	internalData.lifecyclePhase = ComponentLifecyclePhase.Render

	self.props = incomingProps
	self.state = incomingState

	local renderResult = virtualNode.instance:render()

	internalData.lifecyclePhase = ComponentLifecyclePhase.ReconcileChildren
	reconciler.updateVirtualNodeWithRenderResult(virtualNode, virtualNode.hostParent, renderResult)

	if self.didUpdate ~= nil then
		internalData.lifecyclePhase = ComponentLifecyclePhase.DidUpdate
		self:didUpdate(oldProps, oldState)
	end

	internalData.lifecyclePhase = ComponentLifecyclePhase.Idle
	return true
end

return Component

end)
__lua("ComponentLifecyclePhase", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src.ComponentLifecyclePhase", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src.ComponentLifecyclePhase")local script,require=_.script,_.require local Symbol = require(script.Parent.Symbol)
local strict = require(script.Parent.strict)

local ComponentLifecyclePhase = strict({
	-- Component methods
	Init = Symbol.named("init"),
	Render = Symbol.named("render"),
	ShouldUpdate = Symbol.named("shouldUpdate"),
	WillUpdate = Symbol.named("willUpdate"),
	DidMount = Symbol.named("didMount"),
	DidUpdate = Symbol.named("didUpdate"),
	WillUnmount = Symbol.named("willUnmount"),

	-- Phases describing reconciliation status
	ReconcileChildren = Symbol.named("reconcileChildren"),
	Idle = Symbol.named("idle"),
}, "ComponentLifecyclePhase")

return ComponentLifecyclePhase

end)
__lua("Config", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src.Config", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src.Config")local script,require=_.script,_.require --[[
	Exposes an interface to set global configuration values for Roact.

	Configuration can only occur once, and should only be done by an application
	using Roact, not a library.

	Any keys that aren't recognized will cause errors. Configuration is only
	intended for configuring Roact itself, not extensions or libraries.

	Configuration is expected to be set immediately after loading Roact. Setting
	configuration values after an application starts may produce unpredictable
	behavior.
]]

-- Every valid configuration value should be non-nil in this table.
local defaultConfig = {
	-- Enables asserts for internal Roact APIs. Useful for debugging Roact itself.
	["internalTypeChecks"] = false,
	-- Enables stricter type asserts for Roact's public API.
	["typeChecks"] = false,
	-- Enables storage of `debug.traceback()` values on elements for debugging.
	["elementTracing"] = false,
	-- Enables validation of component props in stateful components.
	["propValidation"] = false,
}

-- Build a list of valid configuration values up for debug messages.
local defaultConfigKeys = {}
for key in pairs(defaultConfig) do
	table.insert(defaultConfigKeys, key)
end

local Config = {}

function Config.new()
	local self = {}

	self._currentConfig = setmetatable({}, {
		__index = function(_, key)
			local message = ("Invalid global configuration key %q. Valid configuration keys are: %s"):format(
				tostring(key),
				table.concat(defaultConfigKeys, ", ")
			)

			error(message, 3)
		end,
	})

	-- We manually bind these methods here so that the Config's methods can be
	-- used without passing in self, since they eventually get exposed on the
	-- root Roact object.
	self.set = function(...)
		return Config.set(self, ...)
	end

	self.get = function(...)
		return Config.get(self, ...)
	end

	self.scoped = function(...)
		return Config.scoped(self, ...)
	end

	self.set(defaultConfig)

	return self
end

function Config:set(configValues)
	-- Validate values without changing any configuration.
	-- We only want to apply this configuration if it's valid!
	for key, value in pairs(configValues) do
		if defaultConfig[key] == nil then
			local message = ("Invalid global configuration key %q (type %s). Valid configuration keys are: %s"):format(
				tostring(key),
				typeof(key),
				table.concat(defaultConfigKeys, ", ")
			)

			error(message, 3)
		end

		-- Right now, all configuration values must be boolean.
		if typeof(value) ~= "boolean" then
			local message = (
				"Invalid value %q (type %s) for global configuration key %q. Valid values are: true, false"
			):format(tostring(value), typeof(value), tostring(key))

			error(message, 3)
		end

		self._currentConfig[key] = value
	end
end

function Config:get()
	return self._currentConfig
end

function Config:scoped(configValues, callback)
	local previousValues = {}
	for key, value in pairs(self._currentConfig) do
		previousValues[key] = value
	end

	self.set(configValues)

	local success, result = pcall(callback)

	self.set(previousValues)

	assert(success, result)
end

return Config

end)
__lua("ElementKind", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src.ElementKind", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src.ElementKind")local script,require=_.script,_.require --[[
	Contains markers for annotating the type of an element.

	Use `ElementKind` as a key, and values from it as the value.

		local element = {
			[ElementKind] = ElementKind.Host,
		}
]]

local Symbol = require(script.Parent.Symbol)
local strict = require(script.Parent.strict)
local Portal = require(script.Parent.Portal)

local ElementKind = newproxy(true)

local ElementKindInternal = {
	Portal = Symbol.named("Portal"),
	Host = Symbol.named("Host"),
	Function = Symbol.named("Function"),
	Stateful = Symbol.named("Stateful"),
	Fragment = Symbol.named("Fragment"),
}

function ElementKindInternal.of(value)
	if typeof(value) ~= "table" then
		return nil
	end

	return value[ElementKind]
end

local componentTypesToKinds = {
	["string"] = ElementKindInternal.Host,
	["function"] = ElementKindInternal.Function,
	["table"] = ElementKindInternal.Stateful,
}

function ElementKindInternal.fromComponent(component)
	if component == Portal then
		return ElementKind.Portal
	else
		return componentTypesToKinds[typeof(component)]
	end
end

getmetatable(ElementKind).__index = ElementKindInternal

strict(ElementKindInternal, "ElementKind")

return ElementKind

end)
__lua("ElementUtils", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src.ElementUtils", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src.ElementUtils")local script,require=_.script,_.require --!strict
local Type = require(script.Parent.Type)
local Symbol = require(script.Parent.Symbol)

local function noop()
	return nil
end

local ElementUtils = {}

--[[
	A signal value indicating that a child should use its parent's key, because
	it has no key of its own.

	This occurs when you return only one element from a function component or
	stateful render function.
]]
ElementUtils.UseParentKey = Symbol.named("UseParentKey")

type Iterator<K, V> = ({ [K]: V }, K?) -> (K?, V?)
type Element = { [any]: any }
--[[
	Returns an iterator over the children of an element.
	`elementOrElements` may be one of:
	* a boolean
	* nil
	* a single element
	* a fragment
	* a table of elements

	If `elementOrElements` is a boolean or nil, this will return an iterator with
	zero elements.

	If `elementOrElements` is a single element, this will return an iterator with
	one element: a tuple where the first value is ElementUtils.UseParentKey, and
	the second is the value of `elementOrElements`.

	If `elementOrElements` is a fragment or a table, this will return an iterator
	over all the elements of the array.

	If `elementOrElements` is none of the above, this function will throw.
]]
function ElementUtils.iterateElements<K>(elementOrElements): (Iterator<K, Element>, any, nil)
	local richType = Type.of(elementOrElements)

	-- Single child
	if richType == Type.Element then
		local called = false

		return function(_, _)
			if called then
				return nil
			else
				called = true
				return ElementUtils.UseParentKey, elementOrElements
			end
		end
	end

	local regularType = typeof(elementOrElements)

	if elementOrElements == nil or regularType == "boolean" then
		return (noop :: any) :: Iterator<K, Element>
	end

	if regularType == "table" then
		return pairs(elementOrElements)
	end

	error("Invalid elements")
end

--[[
	Gets the child corresponding to a given key, respecting Roact's rules for
	children. Specifically:
	* If `elements` is nil or a boolean, this will return `nil`, regardless of
		the key given.
	* If `elements` is a single element, this will return `nil`, unless the key
		is ElementUtils.UseParentKey.
	* If `elements` is a table of elements, this will return `elements[key]`.
]]
function ElementUtils.getElementByKey(elements, hostKey)
	if elements == nil or typeof(elements) == "boolean" then
		return nil
	end

	if Type.of(elements) == Type.Element then
		if hostKey == ElementUtils.UseParentKey then
			return elements
		end

		return nil
	end

	if typeof(elements) == "table" then
		return elements[hostKey]
	end

	error("Invalid elements")
end

return ElementUtils

end)
__lua("GlobalConfig", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src.GlobalConfig", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src.GlobalConfig")local script,require=_.script,_.require --[[
	Exposes a single instance of a configuration as Roact's GlobalConfig.
]]

local Config = require(script.Parent.Config)

return Config.new()

end)
__lua("Logging", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src.Logging", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src.Logging")local script,require=_.script,_.require --[[
	Centralized place to handle logging. Lets us:
	- Unit test log output via `Logging.capture`
	- Disable verbose log messages when not debugging Roact

	This should be broken out into a separate library with the addition of
	scoping and logging configuration.
]]

-- Determines whether log messages will go to stdout/stderr
local outputEnabled = true

-- A set of LogInfo objects that should have messages inserted into them.
-- This is a set so that nested calls to Logging.capture will behave.
local collectors = {}

-- A set of all stack traces that have called warnOnce.
local onceUsedLocations = {}

--[[
	Indent a potentially multi-line string with the given number of tabs, in
	addition to any indentation the string already has.
]]
local function indent(source, indentLevel)
	local indentString = ("\t"):rep(indentLevel)

	return indentString .. source:gsub("\n", "\n" .. indentString)
end

--[[
	Indents a list of strings and then concatenates them together with newlines
	into a single string.
]]
local function indentLines(lines, indentLevel)
	local outputBuffer = {}

	for _, line in ipairs(lines) do
		table.insert(outputBuffer, indent(line, indentLevel))
	end

	return table.concat(outputBuffer, "\n")
end

local logInfoMetatable = {}

--[[
	Automatic coercion to strings for LogInfo objects to enable debugging them
	more easily.
]]
function logInfoMetatable:__tostring()
	local outputBuffer = { "LogInfo {" }

	local errorCount = #self.errors
	local warningCount = #self.warnings
	local infosCount = #self.infos

	if errorCount + warningCount + infosCount == 0 then
		table.insert(outputBuffer, "\t(no messages)")
	end

	if errorCount > 0 then
		table.insert(outputBuffer, ("\tErrors (%d) {"):format(errorCount))
		table.insert(outputBuffer, indentLines(self.errors, 2))
		table.insert(outputBuffer, "\t}")
	end

	if warningCount > 0 then
		table.insert(outputBuffer, ("\tWarnings (%d) {"):format(warningCount))
		table.insert(outputBuffer, indentLines(self.warnings, 2))
		table.insert(outputBuffer, "\t}")
	end

	if infosCount > 0 then
		table.insert(outputBuffer, ("\tInfos (%d) {"):format(infosCount))
		table.insert(outputBuffer, indentLines(self.infos, 2))
		table.insert(outputBuffer, "\t}")
	end

	table.insert(outputBuffer, "}")

	return table.concat(outputBuffer, "\n")
end

local function createLogInfo()
	local logInfo = {
		errors = {},
		warnings = {},
		infos = {},
	}

	setmetatable(logInfo, logInfoMetatable)

	return logInfo
end

local Logging = {}

--[[
	Invokes `callback`, capturing all output that happens during its execution.

	Output will not go to stdout or stderr and will instead be put into a
	LogInfo object that is returned. If `callback` throws, the error will be
	bubbled up to the caller of `Logging.capture`.
]]
function Logging.capture(callback)
	local collector = createLogInfo()

	local wasOutputEnabled = outputEnabled
	outputEnabled = false
	collectors[collector] = true

	local success, result = pcall(callback)

	collectors[collector] = nil
	outputEnabled = wasOutputEnabled

	assert(success, result)

	return collector
end

--[[
	Issues a warning with an automatically attached stack trace.
]]
function Logging.warn(messageTemplate, ...)
	local message = messageTemplate:format(...)

	for collector in pairs(collectors) do
		table.insert(collector.warnings, message)
	end

	-- debug.traceback inserts a leading newline, so we trim it here
	local trace = debug.traceback("", 2):sub(2)
	local fullMessage = ("%s\n%s"):format(message, indent(trace, 1))

	if outputEnabled then
		warn(fullMessage)
	end
end

--[[
	Issues a warning like `Logging.warn`, but only outputs once per call site.

	This is useful for marking deprecated functions that might be called a lot;
	using `warnOnce` instead of `warn` will reduce output noise while still
	correctly marking all call sites.
]]
function Logging.warnOnce(messageTemplate, ...)
	local trace = debug.traceback()

	if onceUsedLocations[trace] then
		return
	end

	onceUsedLocations[trace] = true
	Logging.warn(messageTemplate, ...)
end

return Logging

end)
__lua("None", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src.None", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src.None")local script,require=_.script,_.require local Symbol = require(script.Parent.Symbol)

-- Marker used to specify that the value is nothing, because nil cannot be
-- stored in tables.
local None = Symbol.named("None")

return None

end)
__lua("NoopRenderer", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src.NoopRenderer", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src.NoopRenderer")local script,require=_.script,_.require --[[
	Reference renderer intended for use in tests as well as for documenting the
	minimum required interface for a Roact renderer.
]]

local NoopRenderer = {}

function NoopRenderer.isHostObject(target)
	-- Attempting to use NoopRenderer to target a Roblox instance is almost
	-- certainly a mistake.
	return target == nil
end

function NoopRenderer.mountHostNode(_reconciler, _node) end

function NoopRenderer.unmountHostNode(_reconciler, _node) end

function NoopRenderer.updateHostNode(_reconciler, node, _newElement)
	return node
end

return NoopRenderer

end)
__lua("Portal", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src.Portal", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src.Portal")local script,require=_.script,_.require local Symbol = require(script.Parent.Symbol)

local Portal = Symbol.named("Portal")

return Portal

end)
__rbx("PropMarkers", "Folder", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src.PropMarkers", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src")
__lua("Change", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src.PropMarkers.Change", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src.PropMarkers", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src.PropMarkers.Change")local script,require=_.script,_.require --[[
	Change is used to generate special prop keys that can be used to connect to
	GetPropertyChangedSignal.

	Generally, Change is indexed by a Roblox property name:

		Roact.createElement("TextBox", {
			[Roact.Change.Text] = function(rbx)
				print("The TextBox", rbx, "changed text to", rbx.Text)
			end,
		})
]]

local Type = require(script.Parent.Parent.Type)

local Change = {}

local changeMetatable = {
	__tostring = function(self)
		return ("RoactHostChangeEvent(%s)"):format(self.name)
	end,
}

setmetatable(Change, {
	__index = function(_self, propertyName)
		local changeListener = {
			[Type] = Type.HostChangeEvent,
			name = propertyName,
		}

		setmetatable(changeListener, changeMetatable)
		Change[propertyName] = changeListener

		return changeListener
	end,
})

return Change

end)
__lua("Children", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src.PropMarkers.Children", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src.PropMarkers", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src.PropMarkers.Children")local script,require=_.script,_.require local Symbol = require(script.Parent.Parent.Symbol)

local Children = Symbol.named("Children")

return Children

end)
__lua("Event", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src.PropMarkers.Event", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src.PropMarkers", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src.PropMarkers.Event")local script,require=_.script,_.require --[[
	Index into `Event` to get a prop key for attaching to an event on a Roblox
	Instance.

	Example:

		Roact.createElement("TextButton", {
			Text = "Hello, world!",

			[Roact.Event.MouseButton1Click] = function(rbx)
				print("Clicked", rbx)
			end
		})
]]

local Type = require(script.Parent.Parent.Type)

local Event = {}

local eventMetatable = {
	__tostring = function(self)
		return ("RoactHostEvent(%s)"):format(self.name)
	end,
}

setmetatable(Event, {
	__index = function(_self, eventName)
		local event = {
			[Type] = Type.HostEvent,
			name = eventName,
		}

		setmetatable(event, eventMetatable)

		Event[eventName] = event

		return event
	end,
})

return Event

end)
__lua("Ref", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src.PropMarkers.Ref", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src.PropMarkers", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src.PropMarkers.Ref")local script,require=_.script,_.require local Symbol = require(script.Parent.Parent.Symbol)

local Ref = Symbol.named("Ref")

return Ref

end)
__lua("PureComponent", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src.PureComponent", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src.PureComponent")local script,require=_.script,_.require --[[
	A version of Component with a `shouldUpdate` method that forces the
	resulting component to be pure.
]]

local Component = require(script.Parent.Component)

local PureComponent = Component:extend("PureComponent")

-- When extend()ing a component, you don't get an extend method.
-- This is to promote composition over inheritance.
-- PureComponent is an exception to this rule.
PureComponent.extend = Component.extend

function PureComponent:shouldUpdate(newProps, newState)
	-- In a vast majority of cases, if state updated, something has updated.
	-- We don't bother checking in this case.
	if newState ~= self.state then
		return true
	end

	if newProps == self.props then
		return false
	end

	for key, value in pairs(newProps) do
		if self.props[key] ~= value then
			return true
		end
	end

	for key, value in pairs(self.props) do
		if newProps[key] ~= value then
			return true
		end
	end

	return false
end

return PureComponent

end)
__lua("RobloxRenderer", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src.RobloxRenderer", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src.RobloxRenderer")local script,require=_.script,_.require --[[
	Renderer that deals in terms of Roblox Instances. This is the most
	well-supported renderer after NoopRenderer and is currently the only
	renderer that does anything.
]]

local Binding = require(script.Parent.Binding)
local Children = require(script.Parent.PropMarkers.Children)
local ElementKind = require(script.Parent.ElementKind)
local SingleEventManager = require(script.Parent.SingleEventManager)
local getDefaultInstanceProperty = require(script.Parent.getDefaultInstanceProperty)
local Ref = require(script.Parent.PropMarkers.Ref)
local Type = require(script.Parent.Type)
local internalAssert = require(script.Parent.internalAssert)

local config = require(script.Parent.GlobalConfig).get()

local applyPropsError = [[
Error applying props:
	%s
In element:
%s
]]

local updatePropsError = [[
Error updating props:
	%s
In element:
%s
]]

local function identity(...)
	return ...
end

local function applyRef(ref, newHostObject)
	if ref == nil then
		return
	end

	if typeof(ref) == "function" then
		ref(newHostObject)
	elseif Type.of(ref) == Type.Binding then
		Binding.update(ref, newHostObject)
	else
		-- TODO (#197): Better error message
		error(("Invalid ref: Expected type Binding but got %s"):format(typeof(ref)))
	end
end

local function setRobloxInstanceProperty(hostObject, key, newValue)
	if newValue == nil then
		local hostClass = hostObject.ClassName
		local _, defaultValue = getDefaultInstanceProperty(hostClass, key)
		newValue = defaultValue
	end

	-- Assign the new value to the object
	hostObject[key] = newValue

	return
end

local function removeBinding(virtualNode, key)
	local disconnect = virtualNode.bindings[key]
	disconnect()
	virtualNode.bindings[key] = nil
end

local function attachBinding(virtualNode, key, newBinding)
	local function updateBoundProperty(newValue)
		local success, errorMessage = xpcall(function()
			setRobloxInstanceProperty(virtualNode.hostObject, key, newValue)
		end, identity)

		if not success then
			local source = virtualNode.currentElement.source

			if source == nil then
				source = "<enable element tracebacks>"
			end

			local fullMessage = updatePropsError:format(errorMessage, source)
			error(fullMessage, 0)
		end
	end

	if virtualNode.bindings == nil then
		virtualNode.bindings = {}
	end

	virtualNode.bindings[key] = Binding.subscribe(newBinding, updateBoundProperty)

	updateBoundProperty(newBinding:getValue())
end

local function detachAllBindings(virtualNode)
	if virtualNode.bindings ~= nil then
		for _, disconnect in pairs(virtualNode.bindings) do
			disconnect()
		end
		virtualNode.bindings = nil
	end
end

local function applyProp(virtualNode, key, newValue, oldValue)
	if newValue == oldValue then
		return
	end

	if key == Ref or key == Children then
		-- Refs and children are handled in a separate pass
		return
	end

	local internalKeyType = Type.of(key)

	if internalKeyType == Type.HostEvent or internalKeyType == Type.HostChangeEvent then
		if virtualNode.eventManager == nil then
			virtualNode.eventManager = SingleEventManager.new(virtualNode.hostObject)
		end

		local eventName = key.name

		if internalKeyType == Type.HostChangeEvent then
			virtualNode.eventManager:connectPropertyChange(eventName, newValue)
		else
			virtualNode.eventManager:connectEvent(eventName, newValue)
		end

		return
	end

	local newIsBinding = Type.of(newValue) == Type.Binding
	local oldIsBinding = Type.of(oldValue) == Type.Binding

	if oldIsBinding then
		removeBinding(virtualNode, key)
	end

	if newIsBinding then
		attachBinding(virtualNode, key, newValue)
	else
		setRobloxInstanceProperty(virtualNode.hostObject, key, newValue)
	end
end

local function applyProps(virtualNode, props)
	for propKey, value in pairs(props) do
		applyProp(virtualNode, propKey, value, nil)
	end
end

local function updateProps(virtualNode, oldProps, newProps)
	-- Apply props that were added or updated
	for propKey, newValue in pairs(newProps) do
		local oldValue = oldProps[propKey]

		applyProp(virtualNode, propKey, newValue, oldValue)
	end

	-- Clean up props that were removed
	for propKey, oldValue in pairs(oldProps) do
		local newValue = newProps[propKey]

		if newValue == nil then
			applyProp(virtualNode, propKey, nil, oldValue)
		end
	end
end

local RobloxRenderer = {}

function RobloxRenderer.isHostObject(target)
	return typeof(target) == "Instance"
end

function RobloxRenderer.mountHostNode(reconciler, virtualNode)
	local element = virtualNode.currentElement
	local hostParent = virtualNode.hostParent
	local hostKey = virtualNode.hostKey

	if config.internalTypeChecks then
		internalAssert(ElementKind.of(element) == ElementKind.Host, "Element at given node is not a host Element")
	end
	if config.typeChecks then
		assert(element.props.Name == nil, "Name can not be specified as a prop to a host component in Roact.")
		assert(element.props.Parent == nil, "Parent can not be specified as a prop to a host component in Roact.")
	end

	local instance = Instance.new(element.component)
	virtualNode.hostObject = instance

	local success, errorMessage = xpcall(function()
		applyProps(virtualNode, element.props)
	end, identity)

	if not success then
		local source = element.source

		if source == nil then
			source = "<enable element tracebacks>"
		end

		local fullMessage = applyPropsError:format(errorMessage, source)
		error(fullMessage, 0)
	end

	instance.Name = tostring(hostKey)

	local children = element.props[Children]

	if children ~= nil then
		reconciler.updateVirtualNodeWithChildren(virtualNode, virtualNode.hostObject, children)
	end

	instance.Parent = hostParent
	virtualNode.hostObject = instance

	applyRef(element.props[Ref], instance)

	if virtualNode.eventManager ~= nil then
		virtualNode.eventManager:resume()
	end
end

function RobloxRenderer.unmountHostNode(reconciler, virtualNode)
	local element = virtualNode.currentElement

	applyRef(element.props[Ref], nil)

	for _, childNode in pairs(virtualNode.children) do
		reconciler.unmountVirtualNode(childNode)
	end

	detachAllBindings(virtualNode)

	virtualNode.hostObject:Destroy()
end

function RobloxRenderer.updateHostNode(reconciler, virtualNode, newElement)
	local oldProps = virtualNode.currentElement.props
	local newProps = newElement.props

	if virtualNode.eventManager ~= nil then
		virtualNode.eventManager:suspend()
	end

	-- If refs changed, detach the old ref and attach the new one
	if oldProps[Ref] ~= newProps[Ref] then
		applyRef(oldProps[Ref], nil)
		applyRef(newProps[Ref], virtualNode.hostObject)
	end

	local success, errorMessage = xpcall(function()
		updateProps(virtualNode, oldProps, newProps)
	end, identity)

	if not success then
		local source = newElement.source

		if source == nil then
			source = "<enable element tracebacks>"
		end

		local fullMessage = updatePropsError:format(errorMessage, source)
		error(fullMessage, 0)
	end

	local children = newElement.props[Children]
	if children ~= nil or oldProps[Children] ~= nil then
		reconciler.updateVirtualNodeWithChildren(virtualNode, virtualNode.hostObject, children)
	end

	if virtualNode.eventManager ~= nil then
		virtualNode.eventManager:resume()
	end

	return virtualNode
end

return RobloxRenderer

end)
__lua("SingleEventManager", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src.SingleEventManager", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src.SingleEventManager")local script,require=_.script,_.require --[[
	A manager for a single host virtual node's connected events.
]]

local Logging = require(script.Parent.Logging)

local CHANGE_PREFIX = "Change."

local EventStatus = {
	-- No events are processed at all; they're silently discarded
	Disabled = "Disabled",

	-- Events are stored in a queue; listeners are invoked when the manager is resumed
	Suspended = "Suspended",

	-- Event listeners are invoked as the events fire
	Enabled = "Enabled",
}

local SingleEventManager = {}
SingleEventManager.__index = SingleEventManager

function SingleEventManager.new(instance)
	local self = setmetatable({
		-- The queue of suspended events
		_suspendedEventQueue = {},

		-- All the event connections being managed
		-- Events are indexed by a string key
		_connections = {},

		-- All the listeners being managed
		-- These are stored distinctly from the connections
		-- Connections can have their listeners replaced at runtime
		_listeners = {},

		-- The suspension status of the manager
		-- Managers start disabled and are "resumed" after the initial render
		_status = EventStatus.Disabled,

		-- If true, the manager is processing queued events right now.
		_isResuming = false,

		-- The Roblox instance the manager is managing
		_instance = instance,
	}, SingleEventManager)

	return self
end

function SingleEventManager:connectEvent(key, listener)
	self:_connect(key, self._instance[key], listener)
end

function SingleEventManager:connectPropertyChange(key, listener)
	local success, event = pcall(function()
		return self._instance:GetPropertyChangedSignal(key)
	end)

	if not success then
		error(("Cannot get changed signal on property %q: %s"):format(tostring(key), event), 0)
	end

	self:_connect(CHANGE_PREFIX .. key, event, listener)
end

function SingleEventManager:_connect(eventKey, event, listener)
	-- If the listener doesn't exist we can just disconnect the existing connection
	if listener == nil then
		if self._connections[eventKey] ~= nil then
			self._connections[eventKey]:Disconnect()
			self._connections[eventKey] = nil
		end

		self._listeners[eventKey] = nil
	else
		if self._connections[eventKey] == nil then
			self._connections[eventKey] = event:Connect(function(...)
				if self._status == EventStatus.Enabled then
					self._listeners[eventKey](self._instance, ...)
				elseif self._status == EventStatus.Suspended then
					-- Store this event invocation to be fired when resume is
					-- called.

					local argumentCount = select("#", ...)
					table.insert(self._suspendedEventQueue, { eventKey, argumentCount, ... })
				end
			end)
		end

		self._listeners[eventKey] = listener
	end
end

function SingleEventManager:suspend()
	self._status = EventStatus.Suspended
end

function SingleEventManager:resume()
	-- If we're already resuming events for this instance, trying to resume
	-- again would cause a disaster.
	if self._isResuming then
		return
	end

	self._isResuming = true

	local index = 1

	-- More events might be added to the queue when evaluating events, so we
	-- need to be careful in order to preserve correct evaluation order.
	while index <= #self._suspendedEventQueue do
		local eventInvocation = self._suspendedEventQueue[index]
		local listener = self._listeners[eventInvocation[1]]
		local argumentCount = eventInvocation[2]

		-- The event might have been disconnected since suspension started; in
		-- this case, we drop the event.
		if listener ~= nil then
			-- Wrap the listener in a coroutine to catch errors and handle
			-- yielding correctly.
			local listenerCo = coroutine.create(listener)
			local success, result = coroutine.resume(
				listenerCo,
				self._instance,
				unpack(eventInvocation, 3, 2 + argumentCount)
			)

			-- If the listener threw an error, we log it as a warning, since
			-- there's no way to write error text in Roblox Lua without killing
			-- our thread!
			if not success then
				Logging.warn("%s", result)
			end
		end

		index = index + 1
	end

	self._isResuming = false
	self._status = EventStatus.Enabled
	self._suspendedEventQueue = {}
end

return SingleEventManager

end)
__lua("Symbol", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src.Symbol", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src.Symbol")local script,require=_.script,_.require --!strict
--[[
	A 'Symbol' is an opaque marker type.

	Symbols have the type 'userdata', but when printed to the console, the name
	of the symbol is shown.
]]

local Symbol = {}

--[[
	Creates a Symbol with the given name.

	When printed or coerced to a string, the symbol will turn into the string
	given as its name.
]]
function Symbol.named(name)
	assert(type(name) == "string", "Symbols must be created using a string name!")

	local self = newproxy(true)

	local wrappedName = ("Symbol(%s)"):format(name)

	getmetatable(self).__tostring = function()
		return wrappedName
	end

	return self
end

return Symbol

end)
__lua("Type", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src.Type", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src.Type")local script,require=_.script,_.require --[[
	Contains markers for annotating objects with types.

	To set the type of an object, use `Type` as a key and the actual marker as
	the value:

		local foo = {
			[Type] = Type.Foo,
		}
]]

local Symbol = require(script.Parent.Symbol)
local strict = require(script.Parent.strict)

local Type = newproxy(true)

local TypeInternal = {}

local function addType(name)
	TypeInternal[name] = Symbol.named("Roact" .. name)
end

addType("Binding")
addType("Element")
addType("HostChangeEvent")
addType("HostEvent")
addType("StatefulComponentClass")
addType("StatefulComponentInstance")
addType("VirtualNode")
addType("VirtualTree")

function TypeInternal.of(value)
	if typeof(value) ~= "table" then
		return nil
	end

	return value[Type]
end

getmetatable(Type).__index = TypeInternal

getmetatable(Type).__tostring = function()
	return "RoactType"
end

strict(TypeInternal, "Type")

return Type

end)
__lua("assertDeepEqual", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src.assertDeepEqual", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src.assertDeepEqual")local script,require=_.script,_.require --!strict
--[[
	A utility used to assert that two objects are value-equal recursively. It
	outputs fairly nicely formatted messages to help diagnose why two objects
	would be different.

	This should only be used in tests.
]]

local function deepEqual(a: any, b: any): (boolean, string?)
	if typeof(a) ~= typeof(b) then
		local message = ("{1} is of type %s, but {2} is of type %s"):format(typeof(a), typeof(b))
		return false, message
	end

	if typeof(a) == "table" then
		local visitedKeys = {}

		for key, value in pairs(a) do
			visitedKeys[key] = true

			local success, innerMessage = deepEqual(value, b[key])
			if not success and innerMessage then
				local message = innerMessage
					:gsub("{1}", ("{1}[%s]"):format(tostring(key)))
					:gsub("{2}", ("{2}[%s]"):format(tostring(key)))

				return false, message
			end
		end

		for key, value in pairs(b) do
			if not visitedKeys[key] then
				local success, innerMessage = deepEqual(value, a[key])

				if not success and innerMessage then
					local message = innerMessage
						:gsub("{1}", ("{1}[%s]"):format(tostring(key)))
						:gsub("{2}", ("{2}[%s]"):format(tostring(key)))

					return false, message
				end
			end
		end

		return true, nil
	end

	if a == b then
		return true, nil
	end

	local message = "{1} ~= {2}"
	return false, message
end

local function assertDeepEqual(a, b)
	local success, innerMessageTemplate = deepEqual(a, b)

	if not success and innerMessageTemplate then
		local innerMessage = innerMessageTemplate:gsub("{1}", "first"):gsub("{2}", "second")

		local message = ("Values were not deep-equal.\n%s"):format(innerMessage)

		error(message, 2)
	end
end

return assertDeepEqual

end)
__lua("assign", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src.assign", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src.assign")local script,require=_.script,_.require local None = require(script.Parent.None)

--[[
	Merges values from zero or more tables onto a target table. If a value is
	set to None, it will instead be removed from the table.

	This function is identical in functionality to JavaScript's Object.assign.
]]
local function assign(target, ...)
	for index = 1, select("#", ...) do
		local source = select(index, ...)

		if source ~= nil then
			for key, value in pairs(source) do
				if value == None then
					target[key] = nil
				else
					target[key] = value
				end
			end
		end
	end

	return target
end

return assign

end)
__lua("createContext", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src.createContext", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src.createContext")local script,require=_.script,_.require local Symbol = require(script.Parent.Symbol)
local createFragment = require(script.Parent.createFragment)
local createSignal = require(script.Parent.createSignal)
local Children = require(script.Parent.PropMarkers.Children)
local Component = require(script.Parent.Component)

--[[
	Construct the value that is assigned to Roact's context storage.
]]
local function createContextEntry(currentValue)
	return {
		value = currentValue,
		onUpdate = createSignal(),
	}
end

local function createProvider(context)
	local Provider = Component:extend("Provider")

	function Provider:init(props)
		self.contextEntry = createContextEntry(props.value)
		self:__addContext(context.key, self.contextEntry)
	end

	function Provider:willUpdate(nextProps)
		-- If the provided value changed, immediately update the context entry.
		--
		-- During this update, any components that are reachable will receive
		-- this updated value at the same time as any props and state updates
		-- that are being applied.
		if nextProps.value ~= self.props.value then
			self.contextEntry.value = nextProps.value
		end
	end

	function Provider:didUpdate(prevProps)
		-- If the provided value changed, after we've updated every reachable
		-- component, fire a signal to update the rest.
		--
		-- This signal will notify all context consumers. It's expected that
		-- they will compare the last context value they updated with and only
		-- trigger an update on themselves if this value is different.
		--
		-- This codepath will generally only update consumer components that has
		-- a component implementing shouldUpdate between them and the provider.
		if prevProps.value ~= self.props.value then
			self.contextEntry.onUpdate:fire(self.props.value)
		end
	end

	function Provider:render()
		return createFragment(self.props[Children])
	end

	return Provider
end

local function createConsumer(context)
	local Consumer = Component:extend("Consumer")

	function Consumer.validateProps(props)
		if type(props.render) ~= "function" then
			return false, "Consumer expects a `render` function"
		else
			return true
		end
	end

	function Consumer:init(_props)
		-- This value may be nil, which indicates that our consumer is not a
		-- descendant of a provider for this context item.
		self.contextEntry = self:__getContext(context.key)
	end

	function Consumer:render()
		-- Render using the latest available for this context item.
		--
		-- We don't store this value in state in order to have more fine-grained
		-- control over our update behavior.
		local value
		if self.contextEntry ~= nil then
			value = self.contextEntry.value
		else
			value = context.defaultValue
		end

		return self.props.render(value)
	end

	function Consumer:didUpdate()
		-- Store the value that we most recently updated with.
		--
		-- This value is compared in the contextEntry onUpdate hook below.
		if self.contextEntry ~= nil then
			self.lastValue = self.contextEntry.value
		end
	end

	function Consumer:didMount()
		if self.contextEntry ~= nil then
			-- When onUpdate is fired, a new value has been made available in
			-- this context entry, but we may have already updated in the same
			-- update cycle.
			--
			-- To avoid sending a redundant update, we compare the new value
			-- with the last value that we updated with (set in didUpdate) and
			-- only update if they differ. This may happen when an update from a
			-- provider was blocked by an intermediate component that returned
			-- false from shouldUpdate.
			self.disconnect = self.contextEntry.onUpdate:subscribe(function(newValue)
				if newValue ~= self.lastValue then
					-- Trigger a dummy state update.
					self:setState({})
				end
			end)
		end
	end

	function Consumer:willUnmount()
		if self.disconnect ~= nil then
			self.disconnect()
			self.disconnect = nil
		end
	end

	return Consumer
end

local Context = {}
Context.__index = Context

function Context.new(defaultValue)
	return setmetatable({
		defaultValue = defaultValue,
		key = Symbol.named("ContextKey"),
	}, Context)
end

function Context:__tostring()
	return "RoactContext"
end

local function createContext(defaultValue)
	local context = Context.new(defaultValue)

	return {
		Provider = createProvider(context),
		Consumer = createConsumer(context),
	}
end

return createContext

end)
__lua("createElement", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src.createElement", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src.createElement")local script,require=_.script,_.require local Children = require(script.Parent.PropMarkers.Children)
local ElementKind = require(script.Parent.ElementKind)
local Logging = require(script.Parent.Logging)
local Type = require(script.Parent.Type)

local config = require(script.Parent.GlobalConfig).get()

local multipleChildrenMessage = [[
The prop `Roact.Children` was defined but was overridden by the third parameter to createElement!
This can happen when a component passes props through to a child element but also uses the `children` argument:

	Roact.createElement("Frame", passedProps, {
		child = ...
	})

Instead, consider using a utility function to merge tables of children together:

	local children = mergeTables(passedProps[Roact.Children], {
		child = ...
	})

	local fullProps = mergeTables(passedProps, {
		[Roact.Children] = children
	})

	Roact.createElement("Frame", fullProps)]]

--[[
	Creates a new element representing the given component.

	Elements are lightweight representations of what a component instance should
	look like.

	Children is a shorthand for specifying `Roact.Children` as a key inside
	props. If specified, the passed `props` table is mutated!
]]
local function createElement(component, props, children)
	if config.typeChecks then
		assert(component ~= nil, "`component` is required")
		assert(typeof(props) == "table" or props == nil, "`props` must be a table or nil")
		assert(typeof(children) == "table" or children == nil, "`children` must be a table or nil")
	end

	if props == nil then
		props = {}
	end

	if children ~= nil then
		if props[Children] ~= nil then
			Logging.warnOnce(multipleChildrenMessage)
		end

		props[Children] = children
	end

	local elementKind = ElementKind.fromComponent(component)

	local element = {
		[Type] = Type.Element,
		[ElementKind] = elementKind,
		component = component,
		props = props,
	}

	if config.elementTracing then
		-- We trim out the leading newline since there's no way to specify the
		-- trace level without also specifying a message.
		element.source = debug.traceback("", 2):sub(2)
	end

	return element
end

return createElement

end)
__lua("createFragment", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src.createFragment", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src.createFragment")local script,require=_.script,_.require local ElementKind = require(script.Parent.ElementKind)
local Type = require(script.Parent.Type)

local function createFragment(elements)
	return {
		[Type] = Type.Element,
		[ElementKind] = ElementKind.Fragment,
		elements = elements,
	}
end

return createFragment

end)
__lua("createReconciler", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src.createReconciler", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src.createReconciler")local script,require=_.script,_.require --!nonstrict
local Type = require(script.Parent.Type)
local ElementKind = require(script.Parent.ElementKind)
local ElementUtils = require(script.Parent.ElementUtils)
local Children = require(script.Parent.PropMarkers.Children)
local Symbol = require(script.Parent.Symbol)
local internalAssert = require(script.Parent.internalAssert)

local config = require(script.Parent.GlobalConfig).get()

local InternalData = Symbol.named("InternalData")

--[[
	The reconciler is the mechanism in Roact that constructs the virtual tree
	that later gets turned into concrete objects by the renderer.

	Roact's reconciler is constructed with the renderer as an argument, which
	enables switching to different renderers for different platforms or
	scenarios.

	When testing the reconciler itself, it's common to use `NoopRenderer` with
	spies replacing some methods. The default (and only) reconciler interface
	exposed by Roact right now uses `RobloxRenderer`.
]]
local function createReconciler(renderer)
	local reconciler
	local mountVirtualNode
	local updateVirtualNode
	local unmountVirtualNode

	--[[
		Unmount the given virtualNode, replacing it with a new node described by
		the given element.

		Preserves host properties, depth, and legacyContext from parent.
	]]
	local function replaceVirtualNode(virtualNode, newElement)
		local hostParent = virtualNode.hostParent
		local hostKey = virtualNode.hostKey
		local depth = virtualNode.depth
		local parent = virtualNode.parent

		-- If the node that is being replaced has modified context, we need to
		-- use the original *unmodified* context for the new node
		-- The `originalContext` field will be nil if the context was unchanged
		local context = virtualNode.originalContext or virtualNode.context
		local parentLegacyContext = virtualNode.parentLegacyContext

		-- If updating this node has caused a component higher up the tree to re-render
		-- and updateChildren to be re-entered then this node could already have been
		-- unmounted in the previous updateChildren pass.
		if not virtualNode.wasUnmounted then
			unmountVirtualNode(virtualNode)
		end
		local newNode = mountVirtualNode(newElement, hostParent, hostKey, context, parentLegacyContext)

		-- mountVirtualNode can return nil if the element is a boolean
		if newNode ~= nil then
			newNode.depth = depth
			newNode.parent = parent
		end

		return newNode
	end

	--[[
		Utility to update the children of a virtual node based on zero or more
		updated children given as elements.
	]]
	local function updateChildren(virtualNode, hostParent, newChildElements)
		if config.internalTypeChecks then
			internalAssert(Type.of(virtualNode) == Type.VirtualNode, "Expected arg #1 to be of type VirtualNode")
		end

		virtualNode.updateChildrenCount = virtualNode.updateChildrenCount + 1

		local currentUpdateChildrenCount = virtualNode.updateChildrenCount

		local removeKeys = {}

		-- Changed or removed children
		for childKey, childNode in pairs(virtualNode.children) do
			local newElement = ElementUtils.getElementByKey(newChildElements, childKey)
			local newNode = updateVirtualNode(childNode, newElement)

			-- If updating this node has caused a component higher up the tree to re-render
			-- and updateChildren to be re-entered for this virtualNode then
			-- this result is invalid and needs to be disgarded.
			if virtualNode.updateChildrenCount ~= currentUpdateChildrenCount then
				if newNode and newNode ~= virtualNode.children[childKey] then
					unmountVirtualNode(newNode)
				end
				return
			end

			if newNode ~= nil then
				virtualNode.children[childKey] = newNode
			else
				removeKeys[childKey] = true
			end
		end

		for childKey in pairs(removeKeys) do
			virtualNode.children[childKey] = nil
		end

		-- Added children
		for childKey, newElement in ElementUtils.iterateElements(newChildElements) do
			local concreteKey = childKey
			if childKey == ElementUtils.UseParentKey then
				concreteKey = virtualNode.hostKey
			end

			if virtualNode.children[childKey] == nil then
				local childNode = mountVirtualNode(
					newElement,
					hostParent,
					concreteKey,
					virtualNode.context,
					virtualNode.legacyContext
				)

				-- If updating this node has caused a component higher up the tree to re-render
				-- and updateChildren to be re-entered for this virtualNode then
				-- this result is invalid and needs to be discarded.
				if virtualNode.updateChildrenCount ~= currentUpdateChildrenCount then
					if childNode then
						unmountVirtualNode(childNode)
					end
					return
				end

				-- mountVirtualNode can return nil if the element is a boolean
				if childNode ~= nil then
					childNode.depth = virtualNode.depth + 1
					childNode.parent = virtualNode
					virtualNode.children[childKey] = childNode
				end
			end
		end
	end

	local function updateVirtualNodeWithChildren(virtualNode, hostParent, newChildElements)
		updateChildren(virtualNode, hostParent, newChildElements)
	end

	local function updateVirtualNodeWithRenderResult(virtualNode, hostParent, renderResult)
		if Type.of(renderResult) == Type.Element or renderResult == nil or typeof(renderResult) == "boolean" then
			updateChildren(virtualNode, hostParent, renderResult)
		else
			error(
				("%s\n%s"):format(
					"Component returned invalid children:",
					virtualNode.currentElement.source or "<enable element tracebacks>"
				),
				0
			)
		end
	end

	--[[
		Unmounts the given virtual node and releases any held resources.
	]]
	function unmountVirtualNode(virtualNode)
		if config.internalTypeChecks then
			internalAssert(Type.of(virtualNode) == Type.VirtualNode, "Expected arg #1 to be of type VirtualNode")
		end

		virtualNode.wasUnmounted = true

		local kind = ElementKind.of(virtualNode.currentElement)

		-- selene: allow(if_same_then_else)
		if kind == ElementKind.Host then
			renderer.unmountHostNode(reconciler, virtualNode)
		elseif kind == ElementKind.Function then
			for _, childNode in pairs(virtualNode.children) do
				unmountVirtualNode(childNode)
			end
		elseif kind == ElementKind.Stateful then
			virtualNode.instance:__unmount()
		elseif kind == ElementKind.Portal then
			for _, childNode in pairs(virtualNode.children) do
				unmountVirtualNode(childNode)
			end
		elseif kind == ElementKind.Fragment then
			for _, childNode in pairs(virtualNode.children) do
				unmountVirtualNode(childNode)
			end
		else
			error(("Unknown ElementKind %q"):format(tostring(kind)), 2)
		end
	end

	local function updateFunctionVirtualNode(virtualNode, newElement)
		local children = newElement.component(newElement.props)

		updateVirtualNodeWithRenderResult(virtualNode, virtualNode.hostParent, children)

		return virtualNode
	end

	local function updatePortalVirtualNode(virtualNode, newElement)
		local oldElement = virtualNode.currentElement
		local oldTargetHostParent = oldElement.props.target

		local targetHostParent = newElement.props.target

		assert(renderer.isHostObject(targetHostParent), "Expected target to be host object")

		if targetHostParent ~= oldTargetHostParent then
			return replaceVirtualNode(virtualNode, newElement)
		end

		local children = newElement.props[Children]

		updateVirtualNodeWithChildren(virtualNode, targetHostParent, children)

		return virtualNode
	end

	local function updateFragmentVirtualNode(virtualNode, newElement)
		updateVirtualNodeWithChildren(virtualNode, virtualNode.hostParent, newElement.elements)

		return virtualNode
	end

	--[[
		Update the given virtual node using a new element describing what it
		should transform into.

		`updateVirtualNode` will return a new virtual node that should replace
		the passed in virtual node. This is because a virtual node can be
		updated with an element referencing a different component!

		In that case, `updateVirtualNode` will unmount the input virtual node,
		mount a new virtual node, and return it in this case, while also issuing
		a warning to the user.
	]]
	function updateVirtualNode(virtualNode, newElement, newState: { [any]: any }?): { [any]: any }?
		if config.internalTypeChecks then
			internalAssert(Type.of(virtualNode) == Type.VirtualNode, "Expected arg #1 to be of type VirtualNode")
		end
		if config.typeChecks then
			assert(
				Type.of(newElement) == Type.Element or typeof(newElement) == "boolean" or newElement == nil,
				"Expected arg #2 to be of type Element, boolean, or nil"
			)
		end

		-- If nothing changed, we can skip this update
		if virtualNode.currentElement == newElement and newState == nil then
			return virtualNode
		end

		if typeof(newElement) == "boolean" or newElement == nil then
			unmountVirtualNode(virtualNode)
			return nil
		end

		if virtualNode.currentElement.component ~= newElement.component then
			return replaceVirtualNode(virtualNode, newElement)
		end

		local kind = ElementKind.of(newElement)

		local shouldContinueUpdate = true

		if kind == ElementKind.Host then
			virtualNode = renderer.updateHostNode(reconciler, virtualNode, newElement)
		elseif kind == ElementKind.Function then
			virtualNode = updateFunctionVirtualNode(virtualNode, newElement)
		elseif kind == ElementKind.Stateful then
			shouldContinueUpdate = virtualNode.instance:__update(newElement, newState)
		elseif kind == ElementKind.Portal then
			virtualNode = updatePortalVirtualNode(virtualNode, newElement)
		elseif kind == ElementKind.Fragment then
			virtualNode = updateFragmentVirtualNode(virtualNode, newElement)
		else
			error(("Unknown ElementKind %q"):format(tostring(kind)), 2)
		end

		-- Stateful components can abort updates via shouldUpdate. If that
		-- happens, we should stop doing stuff at this point.
		if not shouldContinueUpdate then
			return virtualNode
		end

		virtualNode.currentElement = newElement

		return virtualNode
	end

	--[[
		Constructs a new virtual node but not does mount it.
	]]
	local function createVirtualNode(element, hostParent, hostKey, context, legacyContext)
		if config.internalTypeChecks then
			internalAssert(
				renderer.isHostObject(hostParent) or hostParent == nil,
				"Expected arg #2 to be a host object"
			)
			internalAssert(typeof(context) == "table" or context == nil, "Expected arg #4 to be of type table or nil")
			internalAssert(
				typeof(legacyContext) == "table" or legacyContext == nil,
				"Expected arg #5 to be of type table or nil"
			)
		end
		if config.typeChecks then
			assert(hostKey ~= nil, "Expected arg #3 to be non-nil")
			assert(
				Type.of(element) == Type.Element or typeof(element) == "boolean",
				"Expected arg #1 to be of type Element or boolean"
			)
		end

		return {
			[Type] = Type.VirtualNode,
			currentElement = element,
			depth = 1,
			parent = nil,
			children = {},
			hostParent = hostParent,
			hostKey = hostKey,
			updateChildrenCount = 0,
			wasUnmounted = false,

			-- Legacy Context API
			-- A table of context values inherited from the parent node
			legacyContext = legacyContext,

			-- A saved copy of the parent context, used when replacing a node
			parentLegacyContext = legacyContext,

			-- Context API
			-- A table of context values inherited from the parent node
			context = context or {},

			-- A saved copy of the unmodified context; this will be updated when
			-- a component adds new context and used when a node is replaced
			originalContext = nil,
		}
	end

	local function mountFunctionVirtualNode(virtualNode)
		local element = virtualNode.currentElement

		local children = element.component(element.props)

		updateVirtualNodeWithRenderResult(virtualNode, virtualNode.hostParent, children)
	end

	local function mountPortalVirtualNode(virtualNode)
		local element = virtualNode.currentElement

		local targetHostParent = element.props.target
		local children = element.props[Children]

		assert(renderer.isHostObject(targetHostParent), "Expected target to be host object")

		updateVirtualNodeWithChildren(virtualNode, targetHostParent, children)
	end

	local function mountFragmentVirtualNode(virtualNode)
		local element = virtualNode.currentElement
		local children = element.elements

		updateVirtualNodeWithChildren(virtualNode, virtualNode.hostParent, children)
	end

	--[[
		Constructs a new virtual node and mounts it, but does not place it into
		the tree.
	]]
	function mountVirtualNode(element, hostParent, hostKey, context, legacyContext)
		if config.internalTypeChecks then
			internalAssert(
				renderer.isHostObject(hostParent) or hostParent == nil,
				"Expected arg #2 to be a host object"
			)
			internalAssert(
				typeof(legacyContext) == "table" or legacyContext == nil,
				"Expected arg #5 to be of type table or nil"
			)
		end
		if config.typeChecks then
			assert(hostKey ~= nil, "Expected arg #3 to be non-nil")
			assert(
				Type.of(element) == Type.Element or typeof(element) == "boolean",
				"Expected arg #1 to be of type Element or boolean"
			)
		end

		-- Boolean values render as nil to enable terse conditional rendering.
		if typeof(element) == "boolean" then
			return nil
		end

		local kind = ElementKind.of(element)

		local virtualNode = createVirtualNode(element, hostParent, hostKey, context, legacyContext)

		if kind == ElementKind.Host then
			renderer.mountHostNode(reconciler, virtualNode)
		elseif kind == ElementKind.Function then
			mountFunctionVirtualNode(virtualNode)
		elseif kind == ElementKind.Stateful then
			element.component:__mount(reconciler, virtualNode)
		elseif kind == ElementKind.Portal then
			mountPortalVirtualNode(virtualNode)
		elseif kind == ElementKind.Fragment then
			mountFragmentVirtualNode(virtualNode)
		else
			error(("Unknown ElementKind %q"):format(tostring(kind)), 2)
		end

		return virtualNode
	end

	--[[
		Constructs a new Roact virtual tree, constructs a root node for
		it, and mounts it.
	]]
	local function mountVirtualTree(element, hostParent, hostKey)
		if config.typeChecks then
			assert(Type.of(element) == Type.Element, "Expected arg #1 to be of type Element")
			assert(renderer.isHostObject(hostParent) or hostParent == nil, "Expected arg #2 to be a host object")
		end

		if hostKey == nil then
			hostKey = "RoactTree"
		end

		local tree = {
			[Type] = Type.VirtualTree,
			[InternalData] = {
				-- The root node of the tree, which starts into the hierarchy of
				-- Roact component instances.
				rootNode = nil,
				mounted = true,
			},
		}

		tree[InternalData].rootNode = mountVirtualNode(element, hostParent, hostKey)

		return tree
	end

	--[[
		Unmounts the virtual tree, freeing all of its resources.

		No further operations should be done on the tree after it's been
		unmounted, as indicated by its the `mounted` field.
	]]
	local function unmountVirtualTree(tree)
		local internalData = tree[InternalData]
		if config.typeChecks then
			assert(Type.of(tree) == Type.VirtualTree, "Expected arg #1 to be a Roact handle")
			assert(internalData.mounted, "Cannot unmounted a Roact tree that has already been unmounted")
		end

		internalData.mounted = false

		if internalData.rootNode ~= nil then
			unmountVirtualNode(internalData.rootNode)
		end
	end

	--[[
		Utility method for updating the root node of a virtual tree given a new
		element.
	]]
	local function updateVirtualTree(tree, newElement)
		local internalData = tree[InternalData]
		if config.typeChecks then
			assert(Type.of(tree) == Type.VirtualTree, "Expected arg #1 to be a Roact handle")
			assert(Type.of(newElement) == Type.Element, "Expected arg #2 to be a Roact Element")
		end

		internalData.rootNode = updateVirtualNode(internalData.rootNode, newElement)

		return tree
	end

	reconciler = {
		mountVirtualTree = mountVirtualTree,
		unmountVirtualTree = unmountVirtualTree,
		updateVirtualTree = updateVirtualTree,

		createVirtualNode = createVirtualNode,
		mountVirtualNode = mountVirtualNode,
		unmountVirtualNode = unmountVirtualNode,
		updateVirtualNode = updateVirtualNode,
		updateVirtualNodeWithChildren = updateVirtualNodeWithChildren,
		updateVirtualNodeWithRenderResult = updateVirtualNodeWithRenderResult,
	}

	return reconciler
end

return createReconciler

end)
__lua("createReconcilerCompat", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src.createReconcilerCompat", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src.createReconcilerCompat")local script,require=_.script,_.require --[[
	Contains deprecated methods from Reconciler. Broken out so that removing
	this shim is easy -- just delete this file and remove it from init.
]]

local Logging = require(script.Parent.Logging)

local reifyMessage = [[
Roact.reify has been renamed to Roact.mount and will be removed in a future release.
Check the call to Roact.reify at:
]]

local teardownMessage = [[
Roact.teardown has been renamed to Roact.unmount and will be removed in a future release.
Check the call to Roact.teardown at:
]]

local reconcileMessage = [[
Roact.reconcile has been renamed to Roact.update and will be removed in a future release.
Check the call to Roact.reconcile at:
]]

local function createReconcilerCompat(reconciler)
	local compat = {}

	function compat.reify(...)
		Logging.warnOnce(reifyMessage)

		return reconciler.mountVirtualTree(...)
	end

	function compat.teardown(...)
		Logging.warnOnce(teardownMessage)

		return reconciler.unmountVirtualTree(...)
	end

	function compat.reconcile(...)
		Logging.warnOnce(reconcileMessage)

		return reconciler.updateVirtualTree(...)
	end

	return compat
end

return createReconcilerCompat

end)
__lua("createRef", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src.createRef", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src.createRef")local script,require=_.script,_.require --[[
	A ref is nothing more than a binding with a special field 'current'
	that maps to the getValue method of the binding
]]
local Binding = require(script.Parent.Binding)

local function createRef()
	local binding, _ = Binding.create(nil)

	local ref = {}

	--[[
		A ref is just redirected to a binding via its metatable
	]]
	setmetatable(ref, {
		__index = function(_self, key)
			if key == "current" then
				return binding:getValue()
			else
				return binding[key]
			end
		end,
		__newindex = function(_self, key, value)
			if key == "current" then
				error("Cannot assign to the 'current' property of refs", 2)
			end

			binding[key] = value
		end,
		__tostring = function(_self)
			return ("RoactRef(%s)"):format(tostring(binding:getValue()))
		end,
	})

	return ref
end

return createRef

end)
__lua("createSignal", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src.createSignal", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src.createSignal")local script,require=_.script,_.require --[[
	This is a simple signal implementation that has a dead-simple API.

		local signal = createSignal()

		local disconnect = signal:subscribe(function(foo)
			print("Cool foo:", foo)
		end)

		signal:fire("something")

		disconnect()
]]

local function createSignal()
	local connections = {}
	local suspendedConnections = {}
	local firing = false

	local function subscribe(_self, callback)
		assert(typeof(callback) == "function", "Can only subscribe to signals with a function.")

		local connection = {
			callback = callback,
			disconnected = false,
		}

		-- If the callback is already registered, don't add to the suspendedConnection. Otherwise, this will disable
		-- the existing one.
		if firing and not connections[callback] then
			suspendedConnections[callback] = connection
		end

		connections[callback] = connection

		local function disconnect()
			assert(not connection.disconnected, "Listeners can only be disconnected once.")

			connection.disconnected = true
			connections[callback] = nil
			suspendedConnections[callback] = nil
		end

		return disconnect
	end

	local function fire(_self, ...)
		firing = true
		for callback, connection in pairs(connections) do
			if not connection.disconnected and not suspendedConnections[callback] then
				callback(...)
			end
		end

		firing = false

		for callback, _ in pairs(suspendedConnections) do
			suspendedConnections[callback] = nil
		end
	end

	return {
		subscribe = subscribe,
		fire = fire,
	}
end

return createSignal

end)
__lua("createSpy", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src.createSpy", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src.createSpy")local script,require=_.script,_.require --[[
	A utility used to create a function spy that can be used to robustly test
	that functions are invoked the correct number of times and with the correct
	number of arguments.

	This should only be used in tests.
]]

local assertDeepEqual = require(script.Parent.assertDeepEqual)

local function createSpy(inner)
	local self = {}
	self.callCount = 0
	self.values = {}
	self.valuesLength = 0
	self.value = function(...)
		self.callCount = self.callCount + 1
		self.values = { ... }
		self.valuesLength = select("#", ...)

		if inner ~= nil then
			return inner(...)
		end
		return nil
	end

	self.assertCalledWith = function(_, ...)
		local len = select("#", ...)

		if self.valuesLength ~= len then
			error(("Expected %d arguments, but was called with %d arguments"):format(self.valuesLength, len), 2)
		end

		for i = 1, len do
			local expected = select(i, ...)

			assert(self.values[i] == expected, "value differs")
		end
	end

	self.assertCalledWithDeepEqual = function(_, ...)
		local len = select("#", ...)

		if self.valuesLength ~= len then
			error(("Expected %d arguments, but was called with %d arguments"):format(self.valuesLength, len), 2)
		end

		for i = 1, len do
			local expected = select(i, ...)

			assertDeepEqual(self.values[i], expected)
		end
	end

	self.captureValues = function(_, ...)
		local len = select("#", ...)
		local result = {}

		assert(self.valuesLength == len, "length of expected values differs from stored values")

		for i = 1, len do
			local key = select(i, ...)
			result[key] = self.values[i]
		end

		return result
	end

	setmetatable(self, {
		__index = function(_, key)
			error(("%q is not a valid member of spy"):format(key))
		end,
	})

	return self
end

return createSpy

end)
__lua("forwardRef", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src.forwardRef", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src.forwardRef")local script,require=_.script,_.require local assign = require(script.Parent.assign)
local None = require(script.Parent.None)
local Ref = require(script.Parent.PropMarkers.Ref)

local config = require(script.Parent.GlobalConfig).get()

local excludeRef = {
	[Ref] = None,
}

--[[
	Allows forwarding of refs to underlying host components. Accepts a render
	callback which accepts props and a ref, and returns an element.
]]
local function forwardRef(render)
	if config.typeChecks then
		assert(typeof(render) == "function", "Expected arg #1 to be a function")
	end

	return function(props)
		local ref = props[Ref]
		local propsWithoutRef = assign({}, props, excludeRef)

		return render(propsWithoutRef, ref)
	end
end

return forwardRef

end)
__lua("getDefaultInstanceProperty", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src.getDefaultInstanceProperty", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src.getDefaultInstanceProperty")local script,require=_.script,_.require --[[
	Attempts to get the default value of a given property on a Roblox instance.

	This is used by the reconciler in cases where a prop was previously set on a
	primitive component, but is no longer present in a component's new props.

	Eventually, Roblox might provide a nicer API to query the default property
	of an object without constructing an instance of it.
]]

local Symbol = require(script.Parent.Symbol)

local Nil = Symbol.named("Nil")
local _cachedPropertyValues = {}

local function getDefaultInstanceProperty(className, propertyName)
	local classCache = _cachedPropertyValues[className]

	if classCache then
		local propValue = classCache[propertyName]

		-- We have to use a marker here, because Lua doesn't distinguish
		-- between 'nil' and 'not in a table'
		if propValue == Nil then
			return true, nil
		end

		if propValue ~= nil then
			return true, propValue
		end
	else
		classCache = {}
		_cachedPropertyValues[className] = classCache
	end

	local created = Instance.new(className)
	local ok, defaultValue = pcall(function()
		return created[propertyName]
	end)

	created:Destroy()

	if ok then
		if defaultValue == nil then
			classCache[propertyName] = Nil
		else
			classCache[propertyName] = defaultValue
		end
	end

	return ok, defaultValue
end

return getDefaultInstanceProperty

end)
__lua("internalAssert", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src.internalAssert", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src.internalAssert")local script,require=_.script,_.require local function internalAssert(condition, message)
	if not condition then
		error(message .. " (This is probably a bug in Roact!)", 3)
	end
end

return internalAssert

end)
__lua("invalidSetStateMessages", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src.invalidSetStateMessages", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src.invalidSetStateMessages")local script,require=_.script,_.require --[[
	These messages are used by Component to help users diagnose when they're
	calling setState in inappropriate places.

	The indentation may seem odd, but it's necessary to avoid introducing extra
	whitespace into the error messages themselves.
]]
local ComponentLifecyclePhase = require(script.Parent.ComponentLifecyclePhase)

local invalidSetStateMessages = {}

invalidSetStateMessages[ComponentLifecyclePhase.WillUpdate] = [[
setState cannot be used in the willUpdate lifecycle method.
Consider using the didUpdate method instead, or using getDerivedStateFromProps.

Check the definition of willUpdate in the component %q.]]

invalidSetStateMessages[ComponentLifecyclePhase.ShouldUpdate] = [[
setState cannot be used in the shouldUpdate lifecycle method.
shouldUpdate must be a pure function that only depends on props and state.

Check the definition of shouldUpdate in the component %q.]]

invalidSetStateMessages[ComponentLifecyclePhase.Render] = [[
setState cannot be used in the render method.
render must be a pure function that only depends on props and state.

Check the definition of render in the component %q.]]

invalidSetStateMessages["default"] = [[
setState can not be used in the current situation, because Roact doesn't know
which part of the lifecycle this component is in.

This is a bug in Roact.
It was triggered by the component %q.
]]

return invalidSetStateMessages

end)
__lua("oneChild", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src.oneChild", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src.oneChild")local script,require=_.script,_.require --[[
	Retrieves at most one child from the children passed to a component.

	If passed nil or an empty table, will return nil.

	Throws an error if passed more than one child.
]]
local function oneChild(children)
	if not children then
		return nil
	end

	local key, child = next(children)

	if not child then
		return nil
	end

	local after = next(children, key)

	if after then
		error("Expected at most child, had more than one child.", 2)
	end

	return child
end

return oneChild

end)
__lua("strict", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src.strict", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.roact.src.strict")local script,require=_.script,_.require --!strict
local function strict(t: { [any]: any }, name: string?)
	-- FIXME Luau: Need to define a new variable since reassigning `name = ...`
	-- doesn't narrow the type
	local newName = name or tostring(t)

	return setmetatable(t, {
		__index = function(_self, key)
			local message = ("%q (%s) is not a valid member of %s"):format(tostring(key), typeof(key), newName)

			error(message, 2)
		end,

		__newindex = function(_self, key, _value)
			local message = ("%q (%s) is not a valid member of %s"):format(tostring(key), typeof(key), newName)

			error(message, 2)
		end,
	})
end

return strict

end)
__rbx("rodux", "Folder", "roblox-ts-game.rbxts_include.node_modules.@rbxts.rodux", "roblox-ts-game.rbxts_include.node_modules.@rbxts")
__lua("src", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.rodux.src", "roblox-ts-game.rbxts_include.node_modules.@rbxts.rodux", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.rodux.src")local script,require=_.script,_.require local Store = require(script.Store)
local createReducer = require(script.createReducer)
local combineReducers = require(script.combineReducers)
local makeActionCreator = require(script.makeActionCreator)
local loggerMiddleware = require(script.loggerMiddleware)
local thunkMiddleware = require(script.thunkMiddleware)

return {
	Store = Store,
	createReducer = createReducer,
	combineReducers = combineReducers,
	makeActionCreator = makeActionCreator,
	loggerMiddleware = loggerMiddleware.middleware,
	thunkMiddleware = thunkMiddleware,
}

end)
__lua("NoYield", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.rodux.src.NoYield", "roblox-ts-game.rbxts_include.node_modules.@rbxts.rodux.src", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.rodux.src.NoYield")local script,require=_.script,_.require --!nocheck

--[[
	Calls a function and throws an error if it attempts to yield.

	Pass any number of arguments to the function after the callback.

	This function supports multiple return; all results returned from the
	given function will be returned.
]]

local function resultHandler(co, ok, ...)
	if not ok then
		local message = (...)
		error(debug.traceback(co, message), 2)
	end

	if coroutine.status(co) ~= "dead" then
		error(debug.traceback(co, "Attempted to yield inside changed event!"), 2)
	end

	return ...
end

local function NoYield(callback, ...)
	local co = coroutine.create(callback)

	return resultHandler(co, coroutine.resume(co, ...))
end

return NoYield

end)
__lua("Signal", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.rodux.src.Signal", "roblox-ts-game.rbxts_include.node_modules.@rbxts.rodux.src", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.rodux.src.Signal")local script,require=_.script,_.require --[[
	A limited, simple implementation of a Signal.

	Handlers are fired in order, and (dis)connections are properly handled when
	executing an event.
]]
local function immutableAppend(list, ...)
	local new = {}
	local len = #list

	for key = 1, len do
		new[key] = list[key]
	end

	for i = 1, select("#", ...) do
		new[len + i] = select(i, ...)
	end

	return new
end

local function immutableRemoveValue(list, removeValue)
	local new = {}

	for i = 1, #list do
		if list[i] ~= removeValue then
			table.insert(new, list[i])
		end
	end

	return new
end

local Signal = {}

Signal.__index = Signal

function Signal.new(store)
	local self = {
		_listeners = {},
		_store = store
	}

	setmetatable(self, Signal)

	return self
end

function Signal:connect(callback)
	if typeof(callback) ~= "function" then
		error("Expected the listener to be a function.")
	end

	if self._store and self._store._isDispatching then
		error(
			'You may not call store.changed:connect() while the reducer is executing. ' ..
				'If you would like to be notified after the store has been updated, subscribe from a ' ..
				'component and invoke store:getState() in the callback to access the latest state. '
		)
	end

	local listener = {
		callback = callback,
		disconnected = false,
		connectTraceback = debug.traceback(),
		disconnectTraceback = nil
	}

	self._listeners = immutableAppend(self._listeners, listener)

	local function disconnect()
		if listener.disconnected then
			error((
				"Listener connected at: \n%s\n" ..
				"was already disconnected at: \n%s\n"
			):format(
				tostring(listener.connectTraceback),
				tostring(listener.disconnectTraceback)
			))
		end

		if self._store and self._store._isDispatching then
			error("You may not unsubscribe from a store listener while the reducer is executing.")
		end

		listener.disconnected = true
		listener.disconnectTraceback = debug.traceback()
		self._listeners = immutableRemoveValue(self._listeners, listener)
	end

	return {
		disconnect = disconnect
	}
end

function Signal:fire(...)
	for _, listener in ipairs(self._listeners) do
		if not listener.disconnected then
			listener.callback(...)
		end
	end
end

return Signal
end)
__lua("Store", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.rodux.src.Store", "roblox-ts-game.rbxts_include.node_modules.@rbxts.rodux.src", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.rodux.src.Store")local script,require=_.script,_.require local RunService = game:GetService("RunService")

local Signal = require(script.Parent.Signal)
local NoYield = require(script.Parent.NoYield)

local ACTION_LOG_LENGTH = 3

local rethrowErrorReporter = {
	reportReducerError = function(prevState, action, errorResult)
		error(string.format("Received error: %s\n\n%s", errorResult.message, errorResult.thrownValue))
	end,
	reportUpdateError = function(prevState, currentState, lastActions, errorResult)
		error(string.format("Received error: %s\n\n%s", errorResult.message, errorResult.thrownValue))
	end,
}

local function tracebackReporter(message)
	return debug.traceback(tostring(message))
end

local Store = {}

-- This value is exposed as a private value so that the test code can stay in
-- sync with what event we listen to for dispatching the Changed event.
-- It may not be Heartbeat in the future.
Store._flushEvent = RunService.Heartbeat

Store.__index = Store

--[[
	Create a new Store whose state is transformed by the given reducer function.

	Each time an action is dispatched to the store, the new state of the store
	is given by:

		state = reducer(state, action)

	Reducers do not mutate the state object, so the original state is still
	valid.
]]
function Store.new(reducer, initialState, middlewares, errorReporter)
	assert(typeof(reducer) == "function", "Bad argument #1 to Store.new, expected function.")
	assert(middlewares == nil or typeof(middlewares) == "table", "Bad argument #3 to Store.new, expected nil or table.")
	if middlewares ~= nil then
		for i=1, #middlewares, 1 do
			assert(
				typeof(middlewares[i]) == "function",
				("Expected the middleware ('%s') at index %d to be a function."):format(tostring(middlewares[i]), i)
			)
		end
	end

	local self = {}

	self._errorReporter = errorReporter or rethrowErrorReporter
	self._isDispatching = false
	self._reducer = reducer
	local initAction = {
		type = "@@INIT",
	}
	self._actionLog = { initAction }
	local ok, result = xpcall(function()
		self._state = reducer(initialState, initAction)
	end, tracebackReporter)
	if not ok then
		self._errorReporter.reportReducerError(initialState, initAction, {
			message = "Caught error in reducer with init",
			thrownValue = result,
		})
		self._state = initialState
	end
	self._lastState = self._state

	self._mutatedSinceFlush = false
	self._connections = {}

	self.changed = Signal.new(self)

	setmetatable(self, Store)

	local connection = self._flushEvent:Connect(function()
		self:flush()
	end)
	table.insert(self._connections, connection)

	if middlewares then
		local unboundDispatch = self.dispatch
		local dispatch = function(...)
			return unboundDispatch(self, ...)
		end

		for i = #middlewares, 1, -1 do
			local middleware = middlewares[i]
			dispatch = middleware(dispatch, self)
		end

		self.dispatch = function(_self, ...)
			return dispatch(...)
		end
	end

	return self
end

--[[
	Get the current state of the Store. Do not mutate this!
]]
function Store:getState()
	if self._isDispatching then
		error(("You may not call store:getState() while the reducer is executing. " ..
			"The reducer (%s) has already received the state as an argument. " ..
			"Pass it down from the top reducer instead of reading it from the store."):format(tostring(self._reducer)))
	end

	return self._state
end

--[[
	Dispatch an action to the store. This allows the store's reducer to mutate
	the state of the application by creating a new copy of the state.

	Listeners on the changed event of the store are notified when the state
	changes, but not necessarily on every Dispatch.
]]
function Store:dispatch(action)
	if typeof(action) ~= "table" then
		error(("Actions must be tables. " ..
			"Use custom middleware for %q actions."):format(typeof(action)),
			2
		)
	end

	if action.type == nil then
		error("Actions may not have an undefined 'type' property. " ..
			"Have you misspelled a constant? \n" ..
			tostring(action), 2)
	end

	if self._isDispatching then
		error("Reducers may not dispatch actions.")
	end

	local ok, result = pcall(function()
		self._isDispatching = true
		self._state = self._reducer(self._state, action)
		self._mutatedSinceFlush = true
	end)

	self._isDispatching = false

	if not ok then
		self._errorReporter.reportReducerError(
			self._state,
			action,
			{
				message = "Caught error in reducer",
				thrownValue = result,
			}
		)
	end

	if #self._actionLog == ACTION_LOG_LENGTH then
		table.remove(self._actionLog, 1)
	end
	table.insert(self._actionLog, action)
end

--[[
	Marks the store as deleted, disconnecting any outstanding connections.
]]
function Store:destruct()
	for _, connection in ipairs(self._connections) do
		connection:Disconnect()
	end

	self._connections = nil
end

--[[
	Flush all pending actions since the last change event was dispatched.
]]
function Store:flush()
	if not self._mutatedSinceFlush then
		return
	end

	self._mutatedSinceFlush = false

	-- On self.changed:fire(), further actions may be immediately dispatched, in
	-- which case self._lastState will be set to the most recent self._state,
	-- unless we cache this value first
	local state = self._state

	local ok, errorResult = xpcall(function()
		-- If a changed listener yields, *very* surprising bugs can ensue.
		-- Because of that, changed listeners cannot yield.
		NoYield(function()
			self.changed:fire(state, self._lastState)
		end)
	end, tracebackReporter)

	if not ok then
		self._errorReporter.reportUpdateError(
			self._lastState,
			state,
			self._actionLog,
			{
				message = "Caught error flushing store updates",
				thrownValue = errorResult,
			}
		)
	end

	self._lastState = state
end

return Store

end)
__lua("combineReducers", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.rodux.src.combineReducers", "roblox-ts-game.rbxts_include.node_modules.@rbxts.rodux.src", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.rodux.src.combineReducers")local script,require=_.script,_.require --[[
	Create a composite reducer from a map of keys and sub-reducers.
]]
local function combineReducers(map)
	return function(state, action)
		-- If state is nil, substitute it with a blank table.
		if state == nil then
			state = {}
		end

		local newState = {}

		for key, reducer in pairs(map) do
			-- Each reducer gets its own state, not the entire state table
			newState[key] = reducer(state[key], action)
		end

		return newState
	end
end

return combineReducers

end)
__lua("createReducer", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.rodux.src.createReducer", "roblox-ts-game.rbxts_include.node_modules.@rbxts.rodux.src", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.rodux.src.createReducer")local script,require=_.script,_.require return function(initialState, handlers)
	return function(state, action)
		if state == nil then
			state = initialState
		end

		local handler = handlers[action.type]

		if handler then
			return handler(state, action)
		end

		return state
	end
end

end)
__lua("loggerMiddleware", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.rodux.src.loggerMiddleware", "roblox-ts-game.rbxts_include.node_modules.@rbxts.rodux.src", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.rodux.src.loggerMiddleware")local script,require=_.script,_.require -- We want to be able to override outputFunction in tests, so the shape of this
-- module is kind of unconventional.
--
-- We fix it this weird shape in init.lua.
local prettyPrint = require(script.Parent.prettyPrint)
local loggerMiddleware = {
	outputFunction = print,
}

function loggerMiddleware.middleware(nextDispatch, store)
	return function(action)
		local result = nextDispatch(action)

		loggerMiddleware.outputFunction(("Action dispatched: %s\nState changed to: %s"):format(
			prettyPrint(action),
			prettyPrint(store:getState())
		))

		return result
	end
end

return loggerMiddleware

end)
__lua("makeActionCreator", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.rodux.src.makeActionCreator", "roblox-ts-game.rbxts_include.node_modules.@rbxts.rodux.src", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.rodux.src.makeActionCreator")local script,require=_.script,_.require --[[
	A helper function to define a Rodux action creator with an associated name.
]]
local function makeActionCreator(name, fn)
	assert(type(name) == "string", "Bad argument #1: Expected a string name for the action creator")

	assert(type(fn) == "function", "Bad argument #2: Expected a function that creates action objects")

	return setmetatable({
		name = name,
	}, {
		__call = function(self, ...)
			local result = fn(...)

			assert(type(result) == "table", "Invalid action: An action creator must return a table")

			result.type = name

			return result
		end
	})
end

return makeActionCreator

end)
__lua("prettyPrint", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.rodux.src.prettyPrint", "roblox-ts-game.rbxts_include.node_modules.@rbxts.rodux.src", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.rodux.src.prettyPrint")local script,require=_.script,_.require local indent = "    "

local function prettyPrint(value, indentLevel)
	indentLevel = indentLevel or 0
	local output = {}

	if typeof(value) == "table" then
		table.insert(output, "{\n")

		for tableKey, tableValue in pairs(value) do
			table.insert(output, indent:rep(indentLevel + 1))
			table.insert(output, tostring(tableKey))
			table.insert(output, " = ")

			table.insert(output, prettyPrint(tableValue, indentLevel + 1))
			table.insert(output, "\n")
		end

		table.insert(output, indent:rep(indentLevel))
		table.insert(output, "}")
	elseif typeof(value) == "string" then
		table.insert(output, string.format("%q", value))
		table.insert(output, " (string)")
	else
		table.insert(output, tostring(value))
		table.insert(output, " (")
		table.insert(output, typeof(value))
		table.insert(output, ")")
	end

	return table.concat(output, "")
end

return prettyPrint
end)
__lua("thunkMiddleware", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.rodux.src.thunkMiddleware", "roblox-ts-game.rbxts_include.node_modules.@rbxts.rodux.src", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.rodux.src.thunkMiddleware")local script,require=_.script,_.require --[[
	A middleware that allows for functions to be dispatched.
	Functions will receive a single argument, the store itself.
	This middleware consumes the function; middleware further down the chain
	will not receive it.
]]
local function tracebackReporter(message)
	return debug.traceback(message)
end

local function thunkMiddleware(nextDispatch, store)
	return function(action)
		if typeof(action) == "function" then
			local ok, result = xpcall(function()
				return action(store)
			end, tracebackReporter)

			if not ok then
				-- report the error and move on so it's non-fatal app
				store._errorReporter.reportReducerError(store:getState(), action, {
					message = "Caught error in thunk",
					thrownValue = result,
				})
				return nil
			end

			return result
		end

		return nextDispatch(action)
	end
end

return thunkMiddleware

end)
__rbx("roduxutils", "Folder", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils", "roblox-ts-game.rbxts_include.node_modules.@rbxts")
__lua("out", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out")local script,require=_.script,_.require --[=[
	@class RoduxUtils

	A collection of useful functions for projects that use Rodux.
]=]

local createAction = require(script.createAction)
local createReducer = require(script.createReducer)
local createSelector = require(script.createSelector)
local createSelectorCreator = require(script.createSelectorCreator)
local createSlice = require(script.createSlice)
local Draft = require(script.Draft)
local types = require(script.types)

export type Action = types.Action
export type ActionCreator = types.ActionCreator
export type Reducer = types.Reducer
export type Slice<State> = createSlice.Slice<State>

return {
	createAction = createAction,
	createReducer = createReducer,
	createSelector = createSelector,
	createSelectorCreator = createSelectorCreator,
	createSlice = createSlice,
	Draft = Draft,
}

end)
__lua("Draft", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.Draft", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.Draft")local script,require=_.script,_.require local Immut = require(script.Parent.Immut)

--[=[
	@class Draft

	Helper functions for use with Drafts. These are reexported from
	[Immut](https://github.com/solarhorizon/immut).
]=]

--[=[
	@within Draft
	@function current
	@param draft Draft<State>
	@return State

	Returns a snapshot of the current state of a draft. This can be expensive!
	Use it sparingly.
]=]

--[=[
	@within Draft
	@function original
	@param draft Draft<State>
	@return State

	Get the original table from a draft.
]=]

--[=[
	@within Draft
	@function insert
	@param t { V }
	@param pos number
	@param value V

	Draft-safe replacement for `table.insert`.

	https://create.roblox.com/docs/reference/engine/libraries/table#insert
]=]

--[=[
	@within Draft
	@function remove
	@param t { V }
	@param pos number?
	@return V?

	Draft-safe replacement for `table.remove`.

	https://create.roblox.com/docs/reference/engine/libraries/table#remove
]=]

--[=[
	@within Draft
	@function sort
	@param t { V }
	@param comp function

	Draft-safe replacement for `table.sort`.

	https://create.roblox.com/docs/reference/engine/libraries/table#sort
]=]

--[=[
	@within Draft
	@function clear
	@param t { [K]: V }

	Draft-safe replacement for `table.clear`.

	https://create.roblox.com/docs/reference/engine/libraries/table#clear
]=]

--[=[
	@within Draft
	@function find
	@param haystack { [K]: V }
	@param needle V
	@param init number
	@return number?

	Draft-safe replacement for `table.find`.

	https://create.roblox.com/docs/reference/engine/libraries/table#find
]=]

--[=[
	@within Draft
	@function concat
	@param t { V }
	@param sep string?
	@param i number?
	@param j number?
	@return string

	Draft-safe replacement for `table.find`.

	https://create.roblox.com/docs/reference/engine/libraries/table#concat
]=]

--[=[
	@within Draft
	@prop None None

	When returned from a recipe, the next value will be nil.

	```lua
	local new = produce(state, function(draft)
		return None
	end)

	print(new) -- nil
	```
]=]

--[=[
	@within Draft
	@prop nothing None

	Alias for [`None`](/api/Draft#None)
]=]

return {
	current = Immut.current,
	original = Immut.original,
	nothing = Immut.nothing,
	None = Immut.None,

	clear = Immut.table.clear,
	concat = Immut.table.concat,
	find = Immut.table.find,
	insert = Immut.table.insert,
	remove = Immut.table.remove,
	sort = Immut.table.sort,
}

end)
__lua("Immut", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.Immut", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.Immut")local script,require=_.script,_.require --[=[
	@class Immut

	An immutable data library based on Immer.js
]=]

local Draft = require(script.Draft)
local finishDraft = require(script.finishDraft)
local isDraft = require(script.isDraft)
local isDraftable = require(script.isDraftable)
local original = require(script.original)
local produce = require(script.produce)
local table = require(script.table)
local None = require(script.None)

return {
	createDraft = Draft.new,
	current = finishDraft,
	finishDraft = finishDraft,
	isDraft = isDraft,
	isDraftable = isDraftable,
	original = original,
	produce = produce,
	table = table,
	None = None,
	nothing = None,
}

end)
__lua("Draft", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.Immut.Draft", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.Immut", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.Immut.Draft")local script,require=_.script,_.require --!strict
local constants = require(script.Parent.constants)
local getClone = require(script.Parent.getClone)

local BASE = constants.BASE
local CLONE = constants.CLONE

--[=[
	@class Draft

	Drafts are the backbone of Immut. They allow you to interact with a table
	in a way which would normally mutate it, but immutably. Internally, a draft
	stores a reference to the original table and then clones that table as soon
	as you modify it in any way.
]=]
local Draft = {}

--[=[
	@within Immut
	@function createDraft
	@param base table
	@return Draft

	:::tip
	It's unlikely you'll need to use this unless you have a very specific use
	case. Try using `produce` instead!
	:::

	Create a new draft from the given table.
]=]
function Draft.new<T>(base: T)
	assert(typeof(base) == "table", `Drafts can only be based off of tables. Got {typeof(base)}`)
	assert(getmetatable(base :: any) == nil, "Cannot create a draft from a table with an existing metatable.")
	return setmetatable({ [BASE] = base }, Draft) :: any
end

function Draft:__index(key: any)
	local target = rawget(self, CLONE) or rawget(self, BASE)

	local value = target[key] :: any

	if typeof(value) == "table" and getmetatable(value) ~= Draft then
		local nested = Draft.new(value)
		self[key] = nested
		return nested
	end

	return value
end

function Draft:__newindex(key: any, value: any)
	local clone = getClone(self)
	clone[key] = value
end

function Draft:__len()
	return #(rawget(self, CLONE) or rawget(self, BASE))
end

function _next(self, last)
	local target = rawget(self, CLONE) or rawget(self, BASE)

	local key: any? = next(target, last)

	if key == nil then
		return nil
	end

	return key, self[key]
end

function Draft:__iter()
	return _next, self
end

return Draft

end)
__lua("Draft.spec", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.Immut.Draft.spec", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.Immut", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.Immut.Draft.spec")local script,require=_.script,_.require --!nocheck
return function()
	local Draft = require(script.Parent.Draft)
	local isDraft = require(script.Parent.isDraft)
	local constants = require(script.Parent.constants)

	local function getClone(t)
		return rawget(t, constants.CLONE)
	end

	local function getBase(t)
		return rawget(t, constants.BASE)
	end

	describe("newindex", function()
		it("should not mutate the original table", function()
			local base = { a = "foo" } :: { a: any, b: any }

			local draft = Draft.new(base)
			draft.a = "bar"
			draft.b = "baz"

			expect(base.a).to.equal("foo")
			expect(base.b).to.equal(nil)
		end)

		it("should mutate the cloned table", function()
			local base = { a = "foo" }

			local draft = Draft.new(base)
			draft.a = "bar"
			draft.b = "baz"

			expect(base.a).to.equal("foo")

			local clone = getClone(draft)

			expect(clone.a).to.equal("bar")
			expect(clone.b).to.equal("baz")
		end)

		it("should clone the table when it has first been modified", function()
			local draft = Draft.new({ a = "foo" })
			expect(getClone(draft)).to.equal(nil)

			draft.b = "bar"

			local clone = getClone(draft)

			expect(clone).to.be.ok()
			expect(clone.a).to.equal("foo")
			expect(clone.b).to.equal("bar")
		end)

		it("should respect setting nil values", function()
			local original = { a = true }

			local draft = Draft.new(original)
			draft.a = nil

			expect(draft.a).to.never.be.ok()
			expect(original.a).to.be.ok()
		end)
	end)

	describe("index", function()
		it("should return new values from the cloned table", function()
			local draft = Draft.new({ a = "foo" })
			draft.a = "bar"
			draft.b = "baz"

			local clone = getClone(draft)

			expect(draft.a).to.equal(clone.a)
			expect(draft.b).to.equal(clone.b)
		end)

		it("should return unmodified values from the original table", function()
			local base = { a = "foo" }

			local draft = Draft.new(base)
			draft.b = "baz"

			expect(draft.a).to.equal(base.a)
		end)

		it("should turn nested tables into drafts when indexed", function()
			local draft = Draft.new({
				nested = {
					doubleNested = {},
				},
			})

			expect(isDraft(draft)).to.equal(true)
			expect(isDraft(draft.nested)).to.equal(true)
			expect(isDraft(draft.nested.doubleNested)).to.equal(true)
		end)

		it("should return the same nested draft when indexed more than once", function()
			local draft = Draft.new({
				nested = {
					doubleNested = {},
				},
			})

			local nested1 = draft.nested
			local nested2 = draft.nested

			expect(nested1).to.equal(nested2)
			expect(nested2).to.equal(nested1)
		end)
	end)

	describe("iter", function()
		it("should iterate through base table when unmodified and cloned table when modified", function()
			local base = {}

			for i = 1, 10 do
				base[i] = "original"
			end

			local draft = Draft.new(base)

			for i, v in draft do
				expect(v).to.equal("original")
				draft[i] = "modified"
			end

			local clone = getClone(draft)

			for i, v in draft do
				expect(v).to.equal("modified")
				expect(clone[i]).to.equal("modified")
				expect(base[i]).to.equal("original")
			end
		end)

		it("should return drafts for any nested tables", function()
			local base = {
				a = {},
				b = {},
				c = {},
			}

			local draft = Draft.new(base)

			for k, v in draft do
				expect(isDraft(v)).to.equal(true)
				expect(getBase(v)).to.equal(base[k])
			end
		end)
	end)

	describe("len", function()
		it("should return the correct number of values", function()
			local original = { "foo", "bar", "baz" }

			local draft = Draft.new(original)

			expect(#original).to.equal(3)
			expect(#draft).to.equal(3)

			draft[4] = "qux"

			expect(#draft).to.equal(4)
		end)
	end)
end

end)
__lua("None", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.Immut.None", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.Immut", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.Immut.None")local script,require=_.script,_.require --[=[
	@within Immut
	@prop None None

	When returned from a recipe, the next value will be nil.

	```lua
	local new = produce(state, function(draft)
		return None
	end)

	print(new) -- nil
	```
]=]

--[=[
	@within Immut
	@prop nothing None

	Alias for [`None`](/api/Immut#None)
]=]

local None = setmetatable({}, {
	__tostring = function()
		return "<Immut.None>"
	end,
})

return None

end)
__lua("constants", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.Immut.constants", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.Immut", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.Immut.constants")local script,require=_.script,_.require return {
	CLONE = "_clone",
	BASE = "_base",
}

end)
__lua("finishDraft", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.Immut.finishDraft", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.Immut", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.Immut.finishDraft")local script,require=_.script,_.require local isDraft = require(script.Parent.isDraft)
local constants = require(script.Parent.constants)

local BASE = constants.BASE
local CLONE = constants.CLONE

--[=[
	@within Immut
	@function current
	@param draft Draft
	@return table

	Returns a snapshot of the current state of a draft. This can be expensive,
	so use it sparingly.
]=]

--[=[
	@within Immut
	@param draft T
	@return T?

	:::tip
	It's unlikely you'll need to use this unless you have a very specific use
	case. Try using `produce` instead!
	:::

	Finalize a draft. When given [`None`](/api/Immut#None), returns `nil`. When
	given a non-draft value, returns that value.
]=]
local function finishDraft<T>(draft: T): T
	if typeof(draft) ~= "table" then
		return draft
	end

	local final = draft

	if isDraft(draft) then
		final = rawget(draft, CLONE)

		if final == nil then
			return rawget(draft, BASE)
		end
	end

	for key, value in final do
		final[key] = finishDraft(value)
	end

	return final
end

return finishDraft

end)
__lua("finishDraft.spec", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.Immut.finishDraft.spec", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.Immut", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.Immut.finishDraft.spec")local script,require=_.script,_.require return function()
	local Draft = require(script.Parent.Draft)
	local finishDraft = require(script.Parent.finishDraft)

	it("should return the given value when it is not a draft", function()
		local base = {}
		expect(finishDraft(base)).to.equal(base)
		expect(finishDraft(1)).to.equal(1)
		expect(finishDraft("foo")).to.equal("foo")
		expect(finishDraft(false)).to.equal(false)
		expect(finishDraft(nil)).to.equal(nil)
	end)

	it("should return the original table when the given draft was not modified", function()
		local original = { foo = true }

		local draft = Draft.new(original)

		local finished = finishDraft(draft)

		expect(finished).to.equal(original)
	end)

	it("should return a new table when the given draft was modified", function()
		local original = { foo = true }

		local draft = Draft.new(original)
		draft.bar = true

		local finished = finishDraft(draft)
		expect(finished).to.never.equal(original)
		expect(finished.foo).to.equal(true)
		expect(finished.bar).to.equal(true)
	end)
end

end)
__lua("getClone", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.Immut.getClone", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.Immut", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.Immut.getClone")local script,require=_.script,_.require local constants = require(script.Parent.constants)

local CLONE = constants.CLONE
local BASE = constants.BASE

local function getClone(draft)
	local clone = rawget(draft, CLONE)

	if clone == nil then
		clone = table.clone(rawget(draft, BASE))
		rawset(draft, CLONE, clone)
	end

	return clone
end

return getClone

end)
__lua("getClone.spec", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.Immut.getClone.spec", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.Immut", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.Immut.getClone.spec")local script,require=_.script,_.require return function()
	local CLONE = require(script.Parent.constants).CLONE

	local Draft = require(script.Parent.Draft)
	local getClone = require(script.Parent.getClone)

	it("should return a draft's cloned table if it exists", function()
		local draft = Draft.new({})
		draft.foo = true

		expect(rawget(draft, CLONE)).to.be.ok()

		local clone = getClone(draft)

		expect(rawget(draft, CLONE)).to.equal(clone)
	end)

	it("should create a clone if a draft does not have one", function()
		local draft = Draft.new({})

		expect(rawget(draft, CLONE)).to.never.be.ok()

		local clone = getClone(draft)

		expect(rawget(draft, CLONE)).to.be.ok()
		expect(rawget(draft, CLONE)).to.equal(clone)
	end)
end

end)
__lua("init.spec", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.Immut.init.spec", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.Immut", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.Immut.init.spec")local script,require=_.script,_.require return function()
	local immut = require(script.Parent)

	it("should load", function()
		expect(immut).to.be.ok()
	end)
end

end)
__lua("isDraft", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.Immut.isDraft", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.Immut", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.Immut.isDraft")local script,require=_.script,_.require local Draft = require(script.Parent.Draft)

--[=[
	@within Immut

	Checks if the given value is a draft.
]=]
local function isDraft(value: any): boolean
	if typeof(value) ~= "table" then
		return false
	end

	if getmetatable(value) ~= Draft then
		return false
	end

	return true
end

return isDraft

end)
__lua("isDraft.spec", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.Immut.isDraft.spec", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.Immut", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.Immut.isDraft.spec")local script,require=_.script,_.require --!nocheck
return function()
	local isDraft = require(script.Parent.isDraft)
	local Draft = require(script.Parent.Draft)

	it("should return false when given a value that isn't a draft", function()
		expect(isDraft(true)).to.equal(false)
		expect(isDraft({})).to.equal(false)
		expect(isDraft(setmetatable({}, {}))).to.equal(false)
	end)

	it("should return true when given a draft", function()
		expect(isDraft(Draft.new({}))).to.equal(true)
	end)
end

end)
__lua("isDraftable", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.Immut.isDraftable", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.Immut", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.Immut.isDraftable")local script,require=_.script,_.require --[=[
	@within Immut

	Checks if a value can be wrapped with a draft. Tables without metatables
	are the only draftable values.
]=]
local function isDraftable(value: any): boolean
	if typeof(value) == "table" and getmetatable(value) == nil then
		return true
	end

	return false
end

return isDraftable

end)
__lua("isDraftable.spec", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.Immut.isDraftable.spec", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.Immut", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.Immut.isDraftable.spec")local script,require=_.script,_.require return function()
	local isDraftable = require(script.Parent.isDraftable)

	it("should return false when given a value that is not a table", function()
		expect(isDraftable(1)).to.equal(false)
		expect(isDraftable(true)).to.equal(false)
		expect(isDraftable("string")).to.equal(false)
		expect(isDraftable(nil)).to.equal(false)
	end)

	it("should return false when given a table that has a metatable", function()
		expect(isDraftable(setmetatable({}, {}))).to.equal(false)
	end)

	it("should return true when given a table with no metatable", function()
		expect(isDraftable({})).to.equal(true)
	end)
end

end)
__lua("makeDraftSafe", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.Immut.makeDraftSafe", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.Immut", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.Immut.makeDraftSafe")local script,require=_.script,_.require --!strict
local isDraft = require(script.Parent.isDraft)
local getClone = require(script.Parent.getClone)

type Draft<K, V> = { [K]: V }
type Mutator<K, V, Args..., Return...> = (draft: Draft<K, V>, Args...) -> Return...

--[=[
	@within Immut
	@function makeDraftSafe
	@param fn T
	@return T

	A wrapper for functions that bypass metatables (like using rawset) that will
	make them draft-safe. `makeDraftSafe` is only necessary if the function will 
	mutate the table. If the unsafe function is only reading from the table
	(using rawget), consider using [`original`](/api/Immut#original) or 
	[`current`](/api/Immut#current) instead.

	This is used internally to wrap functions within Luau's table library, and
	is exposed for your convenience.

	```lua
	local remove = makeDraftSafe(table.remove)
	local insert = makeDraftSafe(table.insert)

	local nextState = produce(state, function(draft)
		local value = remove(draft.a, 1)
		insert(draft.b, 1, value)
	end)
	```
]=]
local function makeDraftSafe<K, V, Args..., Return...>(fn: Mutator<K, V, Args..., Return...>): Mutator<K, V, Args..., Return...>
	return function(draft, ...)
		local t = draft

		if isDraft(t) then
			t = getClone(t :: any) :: any
		end

		return fn(t, ...)
	end
end

return makeDraftSafe

end)
__lua("makeDraftSafe.spec", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.Immut.makeDraftSafe.spec", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.Immut", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.Immut.makeDraftSafe.spec")local script,require=_.script,_.require return function()
	local Draft = require(script.Parent.Draft)
	local makeDraftSafe = require(script.Parent.makeDraftSafe)

	it("should return a draft-safe version of the given function", function()
		local function unsafe(t, k, v)
			rawset(t, k, v)
		end

		local draft = Draft.new({})

		local safe = makeDraftSafe(unsafe)
		safe(draft, "foo", "bar")

		expect(rawget(draft, "foo")).to.never.be.ok()
		expect(draft.foo).to.equal("bar")
	end)
end

end)
__lua("original", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.Immut.original", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.Immut", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.Immut.original")local script,require=_.script,_.require local isDraft = require(script.Parent.isDraft)
local constants = require(script.Parent.constants)

local BASE = constants.BASE

--[=[
	@within Immut

	Returns the original table. You can use this to opt out of Immut for any
	table, like in cases where it may be more performant to use another method.
]=]
local function original<T>(draft: T)
	assert(isDraft(draft), "Immut.original can only be called on drafts")
	return rawget(draft :: any, BASE) :: T
end

return original

end)
__lua("original.spec", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.Immut.original.spec", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.Immut", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.Immut.original.spec")local script,require=_.script,_.require --!nocheck
return function()
	local isDraft = require(script.Parent.isDraft)
	local Draft = require(script.Parent.Draft)

	it("should return false when given a value that isn't a draft", function()
		expect(isDraft(true)).to.equal(false)
		expect(isDraft({})).to.equal(false)
		expect(isDraft(setmetatable({}, {}))).to.equal(false)
	end)

	it("should return true when given a draft", function()
		expect(isDraft(Draft.new({}))).to.equal(true)
	end)
end

end)
__lua("produce", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.Immut.produce", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.Immut", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.Immut.produce")local script,require=_.script,_.require --!strict
local Draft = require(script.Parent.Draft)
local None = require(script.Parent.None)
local finishDraft = require(script.Parent.finishDraft)
local isDraftable = require(script.Parent.isDraftable)

-- i've tried two type definitions for recipes, neither of which are that great.

-- when using this type, autocompletion for `draft` stops working
-- type Recipe<T> = ((draft: T) -> ()) | ((draft: T) -> T) | ((draft: T) -> nil)

-- when using this type, recipes will always need to explicitly return something.
-- `draft` autocompletion works though, so i think this is better, but not ideal.
type Recipe<T> = ((draft: T) -> (T? | typeof(None)))

--[=[
	@within Immut
	@param base any -- any value is acceptable, so long as it isn't a table with a metatable
	@param recipe (draft: Draft) -> any?

	The primary way to use Immut. Takes a value and a recipe function which is
	passed a draft that can be mutated, producing a new table with those changes
	made to it.

	### Examples

	```lua
	local state = {
		pets = {
			mittens = {
				type = "cat",
				mood = "lonely",
			},
		}
	}

	-- mittens is lonely. let's get her a friend
	local newState = produce(state, function(draft)
		draft.pets.spot = {
			type = "dog",
			mood = "curious",
		}

		draft.pets.mittens.mood = "happy"
	end)
	```

	Recipe functions do not need to return anything. When they do, the returned
	value will be used instead of the draft.

	:::tip
	When in strict mode, recipes do need an explicit return. You can simply
	return the draft or nil to avoid type errors.
	:::

	```lua
	local newState = produce(state, function(draft)
		return {} -- newState becomes an empty table
	end)
	```
]=]
local function produce<T>(base: T, recipe: Recipe<T>): T?
	local proxy = isDraftable(base) and Draft.new(base) or base :: T

	local nextValue = recipe(proxy) or proxy

	if nextValue == None then
		return nil
	end

	return finishDraft(nextValue)
end

return produce

end)
__lua("produce.spec", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.Immut.produce.spec", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.Immut", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.Immut.produce.spec")local script,require=_.script,_.require --!nocheck
return function()
	local None = require(script.Parent.None)
	local produce = require(script.Parent.produce)

	it("should not mutate the original table", function()
		local original = { number = 2 }

		local new = produce(original, function(draft)
			draft.foo = true
			draft.number += 2
		end)

		expect(new.foo).to.equal(true)
		expect(new.number).to.equal(4)
		expect(original.foo).to.equal(nil)
		expect(original.number).to.equal(2)
		expect(original).to.never.equal(new)
	end)

	it("should not mutate nested tables", function()
		local original = {
			modified = nil,
			nested = {
				modified = nil,
				nestedDeep = { modified = nil },
			},
		}

		local new = produce(original, function(draft)
			draft.nested.modified = true
			draft.nested.nestedDeep.modified = true
		end)

		expect(new.nested.modified).to.be.ok()
		expect(new.nested.nestedDeep.modified).to.be.ok()
		expect(original.nested.modified).to.never.be.ok()
		expect(original.nested.nestedDeep.modified).to.never.be.ok()
	end)

	it("should return the return value of the recipe when not nil or None", function()
		local override = { foo = true }

		local new = produce({}, function(_draft)
			return override
		end)

		expect(new.foo).to.equal(true)
		expect(new).to.equal(override)
	end)

	it("should return nil when the return value of the recipe is None", function()
		local new = produce({}, function(_draft)
			return None
		end)

		expect(new).to.equal(nil)
	end)

	it("should accept non-table non-draftable base", function()
		expect(function()
			produce(1, function() end)
		end).to.never.throw()

		expect(function()
			produce(true, function() end)
		end).to.never.throw()

		expect(function()
			produce("string", function() end)
		end).to.never.throw()

		expect(function()
			produce(nil, function() end)
		end).to.never.throw()
	end)

	it("should be able to return non-table non-draftable values", function()
		do
			local new = produce(nil, function() end)
			expect(new).to.equal(nil)
		end

		do
			local new = produce(1, function() end)
			expect(new).to.equal(1)
		end

		do
			local new = produce("string", function() end)
			expect(new).to.equal("string")
		end

		do
			local new = produce(true, function() end)
			expect(new).to.equal(true)
		end
	end)
end

end)
__lua("table", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.Immut.table", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.Immut", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.Immut.table")local script,require=_.script,_.require local makeDraftSafe = require(script.Parent.makeDraftSafe)

--[=[
	@class table

	Draft-safe table library replacement.
]=]

--[=[
	@within table
	@function insert
	@param t { V }
	@param pos number
	@param value V

	https://create.roblox.com/docs/reference/engine/libraries/table#insert
]=]

--[=[
	@within table
	@function remove
	@param t { V }
	@param pos number?
	@return V?

	https://create.roblox.com/docs/reference/engine/libraries/table#remove
]=]

--[=[
	@within table
	@function sort
	@param t { V }
	@param comp function

	https://create.roblox.com/docs/reference/engine/libraries/table#sort
]=]

--[=[
	@within table
	@function clear
	@param t { [K]: V }

	https://create.roblox.com/docs/reference/engine/libraries/table#clear
]=]

return {
	remove = makeDraftSafe(table.remove),
	sort = makeDraftSafe(table.sort),
	clear = makeDraftSafe(table.clear),

	-- we cannot preserve the type of table.insert when passing it through
	-- makeDraftSafe because it is an overloaded function. this workaround
	-- will fix that (for now)
	insert = (makeDraftSafe(table.insert) :: any) :: typeof(table.insert),

	makeDraftSafe = makeDraftSafe,
}

end)
__lua("ReducerBuilder", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.ReducerBuilder", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.ReducerBuilder")local script,require=_.script,_.require --!strict
local types = require(script.Parent.types)

type Action = types.Action
type ActionCreator = types.ActionCreator
type Reducer = types.Reducer

--[=[
	@within ReducerBuilder
	@type Cases { [string]: Reducer }
]=]
export type Cases = {
	[string]: Reducer,
}

--[=[
	@within ReducerBuilder
	@type Matchers { { matcher: (Action) -> boolean, reducer: Reducer } }
]=]
export type Matchers = {
	{
		matcher: (Action) -> boolean,
		reducer: Reducer,
	}
}

-- make it stop
type ReducerBuilderImpl = {
	__index: ReducerBuilderImpl,
	new: <T>(initialState: T?) -> ReducerBuilder,
	fromMap: <T>(
		initialState: T?,
		cases: Cases?,
		matchers: Matchers?,
		defaultCase: Reducer?
	) -> ReducerBuilder,
	addCase: (
		self: ReducerBuilder,
		action: string | ActionCreator,
		handler: Reducer
	) -> ReducerBuilder,
	addMatcher: (
		self: ReducerBuilder,
		matcher: (Action) -> boolean,
		handler: Reducer
	) -> ReducerBuilder,
	addDefaultCase: (
		self: ReducerBuilder,
		handler: Reducer
	) -> ReducerBuilder,
	_finish: (self: ReducerBuilder) -> Reducer,
}

export type ReducerBuilder = typeof(setmetatable(
	{} :: {
		_cases: Cases,
		_matchers: Matchers,
		_initialState: any?,
		_defaultCase: Reducer,
	},
	{} :: ReducerBuilderImpl
))

--[=[
	@class ReducerBuilder
]=]
local ReducerBuilder = {} :: ReducerBuilderImpl
ReducerBuilder.__index = ReducerBuilder

local function freeze(t: {})
	if not table.isfrozen(t) then
		table.freeze(t)
	end
end

local function defaultReducer(state: any?, _action: any)
	return state
end

function ReducerBuilder.new(initialState)
	if typeof(initialState) == "table" then
		freeze(initialState)
	end

	local self = {
		_cases = {},
		_matchers = {},
		_initialState = initialState,
		_defaultCase = defaultReducer,
	}

	return setmetatable(self, ReducerBuilder)
end

function ReducerBuilder.fromMap(initialState, cases, matchers, defaultCase)
	local self = ReducerBuilder.new(initialState :: any)
	self._cases = cases or self._cases :: any
	self._matchers = matchers or self._matchers :: any
	self._defaultCase = defaultCase or defaultReducer :: any

	return self
end

function ReducerBuilder:_finish()
	return function(state, action)
		state = state or self._initialState

		local case = self._cases[action.type]
		local newState

		if case then
			newState = case(state, action)
		end

		for _, match in self._matchers do
			if match.matcher(action) then
				newState = match.reducer(newState or state, action)
			end
		end

		if newState == nil then
			newState = self._defaultCase(state, action)
		end

		return newState
	end
end

--[=[
	@param action ActionCreator | string -- The action creator or type name
	@param reducer Reducer

	Adds a case reducer. Can only be called before `addMatcher` and
	`addDefaultCase`.

	Case reducers are reducers that handle one type of action. They are the
	standard way of writing reducers in Rodux.
]=]
function ReducerBuilder:addCase(action, reducer)
	assert(
		table.isfrozen(self._cases) == false,
		"addCase cannot be called after addMatcher or addDefaultCase"
	)

	local type = if typeof(action) == "table" then action.name else action
	self._cases[type] = reducer
	return self
end

--[=[
	@param matcher (action: Action) -> boolean
	@param reducer Reducer

	Adds a matcher. Cannot be called after `addDefaultCase`.

	Matchers can be used to handle actions based on your own custom logic
	rather than only matching the type.
]=]
function ReducerBuilder:addMatcher(matcher, reducer)
	assert(
		table.isfrozen(self._matchers) == false,
		"addMatcher cannot be called after addDefaultCase"
	)

	freeze(self._cases)

	self._matchers[#self._matchers + 1] = {
		matcher = matcher,
		reducer = reducer,
	}

	return self
end

--[=[
	@param reducer Reducer

	Adds a fallback reducer. This will be invoked if no case reducers or
	matchers were executed for an action.

	After adding a default case you cannot modify the reducer anymore, so this
	should be reserved for the very last part of the chain.
]=]
function ReducerBuilder:addDefaultCase(reducer)
	assert(
		self._defaultCase == defaultReducer,
		"addDefaultCase cannot be called more than once"
	)

	self._defaultCase = reducer

	freeze(self._cases)
	freeze(self._matchers)
	freeze(self :: any)

	return self
end

return ReducerBuilder

end)
__lua("createAction", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.createAction", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.createAction")local script,require=_.script,_.require local types = require(script.Parent.types)

type ActionCreator<T> = types.ActionCreator<T>
export type PrepareFn = (...any) -> { [any]: any }

local default: PrepareFn = function(payload: any?)
	return {
		payload = payload,
	}
end

--[=[
	@within RoduxUtils

	Similar to Rodux's `makeActionCreator`, except any additional data is put
	inside of a `payload` property by default. This can be overriden with a
	custom prepareFn.

	## Examples

	#### Using the default structure

	```lua
	local todoAdded = createAction("todoAdded")

	
	print(todoAdded("Buy groceries")) -- { type = "todoAdded", payload = "Buy groceries" }
	```

	#### Using a custom structure

	```lua
	local playerJoined = createAction("playerJoined", function(userId)
		return {
			payload = userId,
			isRoblox = userId == 1,
		}
	end)

	print(playerJoined(1)) -- { type = "playerJoined", payload = 1, isRoblox = true }
	```
]=]
local function createAction<Type>(
	name: Type,
	prepareFn: PrepareFn?
): ActionCreator<Type>
	return setmetatable({
		name = name,
	}, {
		__call = function(_self: any, ...)
			local body = (prepareFn or default)(...)
			assert(typeof(body) == "table", "prepareFn should return a table")

			body.type = name

			return body
		end,
	})
end

return createAction

end)
__lua("createReducer", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.createReducer", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.createReducer")local script,require=_.script,_.require local Immut = require(script.Parent.Immut)

local types = require(script.Parent.types)
local ReducerBuilder = require(script.Parent.ReducerBuilder)

type Reducer = types.Reducer
type BuilderCallback = (builder: typeof(ReducerBuilder.new({} :: any))) -> ()

type Cases = ReducerBuilder.Cases
type Matchers = ReducerBuilder.Matchers

--[=[
	@within RoduxUtils
	@param initialState any?
	@param callbackOrHandlers BuilderCallback | Cases?
	@param matchers Matchers? -- not used with BuilderCallback
	@param defaultHandler Reducer? -- not used with BuilderCallback
	@return Reducer

	A simpler way to write a reducer function. Each reducer made with
	`createReducer` is wrapped in an Immut producer, meaning that you can mutate
	the `state` value passed into your handlers. You can add cases for specific
	action types just like you can with Rodux's `createReducer`, but you can
	also add Matcher handlers that will run when a condition that you define is
	met. 

	Multiple matchers can run for the same action. They are run sequentially in 
	the order you defined them.

	### Examples

	#### Callback notation

	The recommended way to use `createReducer` is by using a ReducerBuilder with
	the callback notation. It is more readable than using the map notation.

	```lua
	local reducer = createReducer(initialState, function(builder)
		builder
			:addCase("itemAdded", function(state, action)
				-- you can mutate `state` here, it's fine!
				state.items[action.itemId] = action.item
			end)
			:addCase("itemRemoved", function(state, action)
				state.items[action.itemId] = nil
			end)
			-- run this handler if the action contains a `shouldLog` property
			:addMatcher(function(action)
				return action.shouldLog == true
			end, function(state, action)
				-- remember: we can't use table.insert on a draft
				Draft.insert(state.loggedActions, action)
			end)
			-- set a fallback for any time an action is dispatched that isn't
			-- handled by a matcher or case reducer
			:addDefaultCase(function(state, action)
				state.unhandledActions += 1
			end)
	end)
	```

	#### Map notation

	You can also use the map notation if you prefer. It should feel similar to 
	the `createReducer` function that comes with Rodux. You cannot add a default
	case when using the map notation.

	This is primarily meant for internal use.

	```lua
	local reducer = createReducer(initialState, {
		-- case reducers
		itemAdded = function(state, action)
			state.items[action.itemId] = action.item
		end,
		itemRemoved = function(state, action)
			state.items[action.itemId] = nil
		end,
	}, {
		-- matchers
		{
			matcher = function(action)
				return action.shouldLog == true
			end,
			reducer = function(state, action)
				Draft.insert(state.loggedActions, action)
			end,
		}
	})
	-- we can't add a default case with the map notation
	```
]=]
local function createReducer<T>(
	initialState: T?,
	callbackOrHandlers: BuilderCallback | Cases?,
	matchers: Matchers?,
	defaultHandler: Reducer?
): Reducer
	local reducer

	if typeof(callbackOrHandlers) == "function" then
		local builder = ReducerBuilder.new(initialState)
		callbackOrHandlers(builder :: any)
		reducer = builder:_finish()
	end

	if typeof(callbackOrHandlers) == "table" then
		local builder = ReducerBuilder.fromMap(
			initialState,
			callbackOrHandlers,
			matchers,
			defaultHandler
		)

		reducer = builder:_finish()
	end

	assert(
		reducer ~= nil,
		`callbackOrHandlers should be a table or function. Got a {typeof(
			callbackOrHandlers
		)}`
	)

	return function(state, action)
		if Immut.isDraft(state) or not Immut.isDraftable(state) then
			return reducer(state, action)
		end

		return Immut.produce(state, function(draft)
			return reducer(draft, action)
		end)
	end
end

return createReducer

end)
__lua("createSelector", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.createSelector", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.createSelector")local script,require=_.script,_.require local defaultMemoize = require(script.Parent.defaultMemoize)
local createSelectorCreator = require(script.Parent.createSelectorCreator)

local createSelector = createSelectorCreator(defaultMemoize)

return createSelector

end)
__lua("createSelectorCreator", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.createSelectorCreator", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.createSelectorCreator")local script,require=_.script,_.require local defaultMemoize = require(script.Parent.defaultMemoize)

type Selector<State = any> = (state: State, ...any) -> any?
type ResultFn = (...any) -> any?
type MemoizeOptions = defaultMemoize.MemoizeOptions

--[=[
	@within RoduxUtils
	@type MemoizeFn (fn: function, ...any?) -> function
]=]
type MemoizeFn<F = (...any?) -> any?> = (fn: F, ...any?) -> F

--[=[
	@within RoduxUtils
	@param memoizeFn -- your custom memoization function
	@param ... any? -- any additional arguments to pass to `memoizeFn`
	@return createSelector

	Used to create a custom version of `createSelector`.

	```lua
	local customSelectorCreator = createSelectorCreator(
		customMemoize, -- function to be used to memoize `fn`
		option1, -- option1 will be passed as the second argument to `customMemoize`
		option2 -- option2 will be passed as the third argument to `customMemoize`
	)

	local customSelector = customSelectorCreator(
		{
			selectFoo,
			selectBar,
		},
		resultFunc -- resultFunc will be passed as the first argument to `customMemoize`
	)
	```

	You can find more examples of this in action [here](https://github.com/reduxjs/reselect#createselectorcreatormemoize-memoizeoptions).
]=]
local function createSelectorCreator(memoizeFn: MemoizeFn, ...: any?)
	local defaultMemoizeOptions = { ... }

	--[=[
		@within RoduxUtils
		@param inputSelectors
		@param resultFn
		@param memoizeOptions -- options for `defaultMemoize`, or the first argument to a custom memoization function
		@param ... -- additional arguments for a custom memoize function

		Create a memoized selector.

		```lua
		local selectTotal = createSelector({
			function(state)
				return state.values.value1
			end,
			function(state)
				return state.values.value2
			end,
		}, function(value1, value2)
			return value1 + value2
		end)
		```
	]=]
	local function createSelector(
		inputSelectors: { Selector },
		resultFn: ResultFn,
		memoizeOptions: MemoizeOptions? | any?,
		...: any?
	)
		local finalOptions = if memoizeOptions
			then { memoizeOptions, ... }
			else defaultMemoizeOptions

		local memoizedResultFn = memoizeFn(function(...)
			return resultFn(...)
		end, table.unpack(finalOptions))

		local selector = memoizeFn(function(...)
			local params = {}

			for i, input in inputSelectors do
				params[i] = input(...)
			end

			return memoizedResultFn(table.unpack(params))
		end)

		return selector
	end

	return createSelector
end

return createSelectorCreator

end)
__lua("createSlice", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.createSlice", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.createSlice")local script,require=_.script,_.require local ReducerBuilder = require(script.Parent.ReducerBuilder)
local createAction = require(script.Parent.createAction)
local createReducer = require(script.Parent.createReducer)
local types = require(script.Parent.types)

type ActionCreator = types.ActionCreator
type Reducer = types.Reducer
type PrepareFn = createAction.PrepareFn
type ReducerBuilder = ReducerBuilder.ReducerBuilder
type Cases = ReducerBuilder.Cases
type ExtraReducers = (builder: ReducerBuilder) -> () | Cases

--[=[
	@within RoduxUtils
	@type ReducerMap { [string]: Reducer | ReducerAndPrepareFn }
]=]
type ReducerMap = { [string]: Reducer | ReducerAndPrepareFn }

--[=[
	@within RoduxUtils
	@interface ReducerAndPrepareFn
	.reducer Reducer
	.prepare PrepareFn
]=]
type ReducerAndPrepareFn = { reducer: Reducer, prepare: PrepareFn }

--[=[
	@within RoduxUtils
	@interface SliceOptions
	.name string
	.initialState State?
	.reducers ReducerMap
	.extraReducers ((builder: ReducerBuilder) -> () | Cases)?
]=]
type SliceOptions<State> = {
	name: string,
	initialState: State?,
	reducers: ReducerMap,
	extraReducers: ExtraReducers?,
}

--[=[
	@within RoduxUtils
	@interface Slice
	.name string
	.reducer Reducer
	.actions { [string]: ActionCreator },
	.initialState State?
]=]
export type Slice<State> = {
	name: string,
	reducer: Reducer,
	actions: { [string]: ActionCreator },
	initialState: State?,
}

local function makeActionsAndReducerMap(map: ReducerMap)
	local actions = {}
	local reducers = {}

	for type, reducer in map do
		if typeof(reducer) == "function" then
			actions[type] = createAction(type)
			reducers[type] = reducer
		else
			assert(
				typeof(reducer) == "table",
				"reducers passed to createSlice must either be a function or a table with a reducer & a prepare function"
			)

			actions[type] = createAction(type, reducer.prepare)
			reducers[type] = reducer.reducer
		end
	end

	return actions, reducers
end

--[=[
	@within RoduxUtils

	Automatically generates a reducer and action creators for you. Uses
	`createAction` and `createReducer` internally, so you're able to customize
	each generated action creator and use drafts in the reducers.

	### Example

	Let's create a slice for a todo list. We'll make actions for adding &
	removing todos from the list, but not for marking a todo as complete.
	We'll assume our project already has an action for completing tasks, and
	reuse it in our todo slice.

	```lua
	local todoSlice = createSlice({
		name = "todo", 
		initialState = {},
		reducers = {
			-- uses createReducer, so you can mutate state because it's a draft
			todoRemoved = function(state, action)
				state[action.payload] = nil
			end,
			todoAdded = {
				reducer = function(state, action)
					state[action.payload.name] = { done = action.payload.done }
				end,
				-- customize the generated action creator
				prepare = function(name, done)
					return {
						payload = {
							name = name,
							done = done,
						}
					}
				end,
			},
		},
		-- add additional cases that might be relevant to this slice, but have
		-- an action creator generated elsewhere (like in another slice)
		extraReducers = function(builder)
			builder:addCase("taskCompleted", function(state, action)
				local todo = state[action.payload.name]

				if todo then
					todo.done = true
				end
			end)
		end,
	)
	```

	Now, let's set up the store and use our slice.

	```lua
	local todosSlice = require(ReplicatedStorage.Todos.slice)
	local tasksSlice = require(ReplicatedStorage.Tasks.slice)

	local todos = todosSlice.actions
	local tasks = tasksSlice.actions

	local reducer = Rodux.combineReducers({
		todos = todosSlice.reducer,
		tasks = tasksSlice.reducer,
	})

	local store = Store.new(reducer)

	-- add a new todo, mark it as not done
	store:dispatch(todos.todoAdded("Buy groceries", false))

	-- complete a task, and mark the todo as done
	store:dispatch(tasks.taskCompleted("Buy groceries")

	-- remove the todo entirely
	store:dispatch(todos.todoRemoved("Buy groceries"))
	```
]=]
local function createSlice<State>(options: SliceOptions<State>): Slice<State>
	local actions, reducerMap = makeActionsAndReducerMap(options.reducers)

	if typeof(options.extraReducers) == "table" then
		for type, handler in reducerMap do
			reducerMap[type] = handler
		end
	end

	local reducer = createReducer(options.initialState, function(builder)
		builder._cases = reducerMap

		if typeof(options.extraReducers) == "function" then
			options.extraReducers(builder)
		end
	end)

	return {
		name = options.name,
		reducer = reducer,
		actions = actions,
		initialState = options.initialState,
	}
end

return createSlice

end)
__lua("defaultEquals", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.defaultEquals", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.defaultEquals")local script,require=_.script,_.require local function defaultEquals(a: any?, b: any?)
	return a == b
end

return defaultEquals

end)
__lua("defaultMemoize", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.defaultMemoize", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.defaultMemoize")local script,require=_.script,_.require local caches = require(script.cache)
local defaultEquals = require(script.Parent.defaultEquals)
local getOptions = require(script.getOptions)
local types = require(script.types)

export type MemoizeOptions = getOptions.MemoizeOptions
type EqualityFn = types.EqualityFn

--[=[
	@within RoduxUtils

	Memoizes a function. This is the default memoization function for
	`createSelector`.

	@param fn -- The function you want to memoize
	@param equalityFnOrOptions
]=]
local function defaultMemoize<Args...>(
	fn: (Args...) -> any?,
	equalityFnOrOptions: (EqualityFn | MemoizeOptions)?
)
	local options = getOptions(equalityFnOrOptions)

	local comparator =
		caches.createCacheKeyComparator(options.equalityCheck or defaultEquals)

	local cache = caches.getCache(options.maxSize or 1, comparator)

	return function(...: Args...)
		local arguments = table.pack(...)

		local value = cache:get(arguments)

		if value == caches.None then
			value = fn(...)

			if options.resultEqualityCheck then
				local entries = cache:getEntries()

				for _, entry in entries do
					if options.resultEqualityCheck(entry.value, value) then
						value = entry.value
					end
				end
			end

			cache:put(arguments, value)
		end

		return value
	end
end

return defaultMemoize

end)
__lua("cache", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.defaultMemoize.cache", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.defaultMemoize", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.defaultMemoize.cache")local script,require=_.script,_.require local None = require(script.None)
local getCache = require(script.getCache)
local createCacheKeyComparator = require(script.createCacheKeyComparator)

return {
	None = None,
	getCache = getCache,
	createCacheKeyComparator = createCacheKeyComparator,
}

end)
__lua("Lru", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.defaultMemoize.cache.Lru", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.defaultMemoize.cache", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.defaultMemoize.cache.Lru")local script,require=_.script,_.require local None = require(script.Parent.None)
local types = require(script.Parent.types)

type Comparator = types.Comparator

-- could not get this to work properly
--type LruCacheImpl =
--	types.CacheImpl<LruCache>
--	& { new: (size: number, equals: Comparator) -> LruCache }

type LruCacheImpl = {
	__index: LruCacheImpl,
	new: (size: number, equals: Comparator) -> LruCache,
	get: (self: LruCache, key: any) -> any?,
	put: (self: LruCache, key: any, value: any?) -> (),
	getEntries: (self: LruCache) -> { [any]: any },
	clear: (self: LruCache) -> (),
}

type LruCache = typeof(setmetatable(
	{} :: {
		_entries: { { key: any, value: any } },
		_comparator: Comparator,
		_maxSize: number,
	},
	{} :: LruCacheImpl
))

local lru = {} :: LruCacheImpl
lru.__index = lru

function lru.new(size, comparator)
	local self = {
		_entries = table.create(size),
		_comparator = comparator,
		_maxSize = size,
	}

	return setmetatable(self, lru)
end

function lru:get(key)
	local index

	for i, entry in self._entries do
		if self._comparator(entry.key, key) then
			index = i
			break
		end
	end

	if index == nil then
		return None
	end

	local entry = self._entries[index]

	if index > 1 then
		table.remove(self._entries, index)
		table.insert(self._entries, 1, entry)
	end

	return entry.value
end

function lru:put(key, value)
	if self:get(key) == None then
		if #self._entries == self._maxSize then
			table.remove(self._entries, self._maxSize)
		end

		table.insert(self._entries, 1, {
			key = key,
			value = value,
		})
	end
end

function lru:getEntries()
	return self._entries
end

function lru:clear()
	self._entries = table.create(self._maxSize)
end

return lru

end)
__lua("None", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.defaultMemoize.cache.None", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.defaultMemoize.cache", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.defaultMemoize.cache.None")local script,require=_.script,_.require local None = newproxy(true)

getmetatable(None).__tostring = function()
	return "<none>"
end

return None

end)
__lua("Singleton", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.defaultMemoize.cache.Singleton", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.defaultMemoize.cache", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.defaultMemoize.cache.Singleton")local script,require=_.script,_.require local None = require(script.Parent.None)
local types = require(script.Parent.types)

type Comparator = types.Comparator

type SingletonCacheImpl = {
	__index: SingletonCacheImpl,
	new: (equals: Comparator) -> SingletonCache,
	get: (self: SingletonCache, key: any) -> any?,
	put: (self: SingletonCache, key: any, value: any?) -> (),
	getEntries: (self: SingletonCache) -> { [any]: any },
	clear: (self: SingletonCache) -> (),
}

type SingletonCache = typeof(setmetatable(
	{} :: {
		_entry: { key: any, value: any }?,
		_comparator: Comparator,
	},
	{} :: SingletonCacheImpl
))

local singleton = {} :: SingletonCacheImpl
singleton.__index = singleton

function singleton.new(comparator)
	local self = {
		_entry = nil,
		_comparator = comparator,
	}

	return setmetatable(self, singleton)
end

function singleton:get(key)
	if self._entry and self._comparator(self._entry.key, key) then
		return self._entry.value
	end

	return None
end

function singleton:put(key, value)
	self._entry = {
		key = key,
		value = value,
	}
end

function singleton:getEntries()
	return { self._entry }
end

function singleton:clear()
	self._entry = nil
end

return singleton

end)
__lua("createCacheKeyComparator", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.defaultMemoize.cache.createCacheKeyComparator", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.defaultMemoize.cache", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.defaultMemoize.cache.createCacheKeyComparator")local script,require=_.script,_.require local types = require(script.Parent.types)

local function createKeyComparator(equalityFn: types.EqualityFn)
	return function(old: types.ArgsList, new: types.ArgsList)
		--if #old ~= #new then
		--	return false
		--end

		for key, value in old do
			if not equalityFn(new[key], value) then
				return false
			end
		end

		for key, value in new do
			if not equalityFn(old[key], value) then
				return false
			end
		end

		return true
	end
end

return createKeyComparator

end)
__lua("getCache", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.defaultMemoize.cache.getCache", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.defaultMemoize.cache", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.defaultMemoize.cache.getCache")local script,require=_.script,_.require local Lru = require(script.Parent.Lru)
local Singleton = require(script.Parent.Singleton)

type Cache = {
	get: (self: any, key: any) -> any?,
	put: (self: any, key: any, value: any?) -> (),
	getEntries: (self: any) -> { [any]: any },
	clear: (self: any) -> (),
}

local function getCache(maxSize, comparator): Cache
	assert(
		maxSize > 0,
		"The maximum size for a cache must be a number greater than 0"
	)

	if maxSize > 1 then
		return Lru.new(maxSize, comparator) :: any
	end

	return Singleton.new(comparator) :: any
end

return getCache

end)
__lua("types", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.defaultMemoize.cache.types", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.defaultMemoize.cache", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.defaultMemoize.cache.types")local script,require=_.script,_.require local types = require(script.Parent.Parent.types)

export type ArgsList = typeof(table.pack({} :: any))
export type Comparator = (old: ArgsList, new: ArgsList) -> boolean
export type EqualityFn = types.EqualityFn

-- doesn't work
--export type CacheImpl<Cache> = {
--	__index: CacheImpl<Cache>,
--	get: (self: Cache, key: any) -> any?,
--	put: (self: Cache, key: any, value: any?) -> (),
--	getEntries: (self: Cache) -> { [any]: any },
--	clear: (self: Cache) -> (),
--}

return nil

end)
__lua("getOptions", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.defaultMemoize.getOptions", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.defaultMemoize", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.defaultMemoize.getOptions")local script,require=_.script,_.require --[=[
	@within RoduxUtils
	@interface MemoizeOptions
	.equalityCheck EqualityFn?
	.resultEqualityCheck EqualityFn?
	.maxSize number?

	MemoizeOptions can be used to customize the Memoize instance
	returned from `defaultMemoize`.
]=]
export type MemoizeOptions = {
	equalityCheck: EqualityFn?,
	resultEqualityCheck: EqualityFn?,
	maxSize: number?,
}

type EqualityFn = (a: any?, b: any?) -> boolean

local function getOptions(
	equalityFnOrOptions: (MemoizeOptions | EqualityFn)?
): MemoizeOptions
	if typeof(equalityFnOrOptions) == "table" then
		return equalityFnOrOptions
	end

	return {
		equalityCheck = equalityFnOrOptions,
		maxSize = 1,
	}
end

return getOptions

end)
__lua("types", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.defaultMemoize.types", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.defaultMemoize", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.defaultMemoize.types")local script,require=_.script,_.require --[=[
	@within RoduxUtils
	@type EqualityFn (a: any?, b: any?) -> boolean
	
	Any type of function that compares two values and returns a boolean.
]=]
export type EqualityFn = (a: any?, b: any?) -> boolean

return nil

end)
__lua("types", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.types", "roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.roduxutils.out.types")local script,require=_.script,_.require export type Action<T = any> = {
	type: T,
	[string]: any,
}

export type ActionCreator<T = string> = typeof(setmetatable(
	{} :: { name: T },
	{} :: {
		__call: (any, ...any?) -> Action<T>,
	}
))

export type Reducer<T = any> =
	((state: T, action: Action) -> T?)
	& ((state: T, action: Action) -> ())

return nil

end)
__lua("services", "ModuleScript", "roblox-ts-game.rbxts_include.node_modules.@rbxts.services", "roblox-ts-game.rbxts_include.node_modules.@rbxts", function()
	local _=__env("roblox-ts-game.rbxts_include.node_modules.@rbxts.services")local script,require=_.script,_.require return setmetatable({}, {
	__index = function(self, serviceName)
		local service = game:GetService(serviceName)
		self[serviceName] = service
		return service
	end,
})

end)
__rbx("types", "Folder", "roblox-ts-game.rbxts_include.node_modules.@rbxts.types", "roblox-ts-game.rbxts_include.node_modules.@rbxts")
__rbx("include", "Folder", "roblox-ts-game.rbxts_include.node_modules.@rbxts.types.include", "roblox-ts-game.rbxts_include.node_modules.@rbxts.types")
__rbx("generated", "Folder", "roblox-ts-game.rbxts_include.node_modules.@rbxts.types.include.generated", "roblox-ts-game.rbxts_include.node_modules.@rbxts.types.include")
__start()
