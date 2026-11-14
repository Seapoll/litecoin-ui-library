-- Load the shared library from GitHub; edit the callbacks below.
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Seapoll/litecoin-ui-library/main/litecoin_library.luau"))()

local Window = Library:CreateWindow({
    Name = "Litecoin.gg",
    Id = "MyLitecoinWindow",
    ToggleKey = Enum.KeyCode.RightShift,
})

local Main = Window:Page({Name = "Main"})
local General = Main:Section({Name = "General", Side = "Left"})
local Preview = Main:Section({Name = "Preview", Side = "Right"})
local Status = Preview:Label({Text = "Ready", Height = 48})

local Enabled = General:Toggle({
    Id = "Enabled", Name = "Enable demo", Default = false,
    Keybind = Enum.KeyCode.F6, Mode = "Toggle",
    Callback = function(value)
        Status:Set(value and "Demo enabled" or "Demo disabled")
        -- Add your own function here.
    end,
})

local Strength = General:Slider({
    Id = "Strength", Name = "Strength", Min = 0, Max = 100,
    Step = 1, Default = 35,
    Callback = function(value)
        Status:Set("Strength: " .. value)
    end,
})

local Mode = General:Dropdown({
    Id = "Mode", Name = "Mode",
    Options = {"Balanced", "Smooth", "Instant"}, Default = "Balanced",
    Callback = function(value) Status:Set("Mode: " .. value) end,
})

local Message = Preview:Textbox({
    Id = "Message", Name = "Message", Placeholder = "Write a message…",
    Callback = function(value, enterPressed)
        Status:Set(value ~= "" and value or "Ready")
    end,
})

Preview:Button({Name = "Run demo", Callback = function()
    Status:Set(string.format("Enabled: %s | Strength: %d | %s", tostring(Enabled:Get()), Strength:Get(), Mode:Get()))
end})

Preview:Button({Name = "Reset", Callback = function()
    Enabled:Set(false, true)
    Strength:Set(35, true)
    Mode:Set("Balanced", true)
    Message:Set("", true)
    Status:Set("Ready")
end})

local Visuals = Window:Page({Name = "Visuals"})
local Appearance = Visuals:Section({Name = "Appearance", Side = "Left"})
Appearance:Dropdown({Name = "Interface size", Options = {"85%", "100%", "115%"}, Default = "100%",
    Callback = function(value) Window:SetScale(tonumber(value:sub(1, -2)) / 100) end})
local Help = Visuals:Section({Name = "Keybind help", Side = "Right"})
Help:Label({Text = "Click the key box to bind a key. Right-click it for Hold / Toggle / Unbind.", Height = 70})

-- Direct page controls also work: a default section is created automatically.
local Extra = Window:Page({Name = "Custom"})
Extra:Toggle({Name = "My function", Keybind = Enum.KeyCode.F7, Mode = "Hold",
    Callback = function(held) print("Custom function:", held) end})

getgenv().LitecoinDemo = {
    Window = Window, Main = Main, General = General,
    Enabled = Enabled, Strength = Strength, Mode = Mode,
    Message = Message, Status = Status,
}
return Window
