# Files Viewer

## **📜 Script**

```lua
--[[
--      I'm editing the script.
--      Maybe things does not work.
--]]

local Link = 'https://raw.githubusercontent.com/AltLexon/Files-Viewer/master/dist/main-dev.lua'
local success, err = loadstring(game:HttpGetAsync(Link))()

if not success then
    return print('Error:', err)
end
```

<br>

Script made by [altlexon](https://discordapp.com/users/923286783691718676)