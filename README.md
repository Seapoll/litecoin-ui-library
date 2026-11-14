# Litecoin UI Library

A reusable Roblox client UI library based on the supplied design. Includes FC Minimal Bold, two columns, pages and sections, pink checkboxes, sliders, dropdowns, text inputs, buttons, and configurable Hold/Toggle keybinds.

## เปิด UI ตัวอย่าง

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Seapoll/litecoin-ui-library/main/litecoin_example.luau"))()
```

## โหลด Library ไปสร้าง UI เอง

```lua
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Seapoll/litecoin-ui-library/main/litecoin_library.luau"))()
local Window = Library:CreateWindow({Name = "My UI"})
local Main = Window:Page({Name = "Main"})
local Section = Main:Section({Name = "General", Side = "Left"})
Section:Toggle({
    Name = "Enable", Default = false,
    Keybind = Enum.KeyCode.F6, Mode = "Toggle",
    Callback = function(enabled)
        print("Enabled:", enabled)
    end,
})
```

Click a toggle's key box to bind a keyboard key. Right-click the box or checkbox to choose Hold, Toggle, or Unbind. Click outside the menu to close it. Right Shift hides/shows the window.

[คู่มือ API ภาษาไทย](GUIDE.md) · [ตัวอย่างที่แก้ไขได้](litecoin_example.luau)

The client must provide loadstring, HTTP access, writefile, getcustomasset, and base64_decode. This is not a standard Roblox Studio ModuleScript. The library contains UI behavior; add your own application functions through callbacks.

## Font

FC Minimal faces are embedded to match the requested design. Fontcraft's original usage information is retained in [FC-Minimal-Memo.txt](FC-Minimal-Memo.txt). Font rights remain with the font author.

