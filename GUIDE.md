# Litecoin UI Library

แยกเป็น 2 ไฟล์หลัก:

- `litecoin_library.luau`: ตัว Library พร้อม FC Minimal Bold และระบบ UI
- `litecoin_example.luau`: ตัวอย่างสร้างหน้าต่างและกำหนดฟังก์ชัน แก้ไฟล์นี้ได้เลย

วางทั้งสองไฟล์ใน workspace ของ executor แล้วรัน:

```lua
loadstring(readfile("litecoin_example.luau"))()
```

ตัวอย่างใน repo นี้โหลด Library จาก GitHub หากใช้งานแบบออฟไลน์ให้เปลี่ยนบรรทัดโหลด Library ในตัวอย่างเป็น readfile ตามด้านล่าง

## เริ่มต้น

```lua
local Library = loadstring(readfile("litecoin_library.luau"))()
local Window = Library:CreateWindow({
    Name = "My UI",
    Id = "MyWindow",
    ToggleKey = Enum.KeyCode.RightShift,
})
local Main = Window:Page({Name = "Main"})
local Section = Main:Section({Name = "General", Side = "Left"})

local Enabled = Section:Toggle({
    Name = "Enable", Default = false,
    Keybind = Enum.KeyCode.F6, Mode = "Toggle",
    Callback = function(value)
        print("Enabled:", value)
    end,
})
```

`Library:Window(...)` ใช้แทน `Library:CreateWindow(...)` ได้

ถ้าไม่ต้องการแยก Section เพิ่ม ใช้ `Main:Toggle(...)`, `Main:Slider(...)` หรือ `Main:Button(...)` ได้ ระบบสร้าง Section เริ่มต้นให้

## สร้างหน้าและ Section

- `Window:Page({Name="Main"})`
- `Window:Page({Name="Visuals"})`
- ปุ่มแท็บแสดงข้อความล้วน และขยายความกว้างตามข้อความพร้อมระยะขอบด้านละ 14 px
- `Page:Section({Name="General", Side="Left", Description="Optional"})`
- `Page:Section({Name="Other", Side="Right"})`
- `Page:Select()` สลับไปหน้านั้น

ชื่อ Page ห้ามซ้ำใน Window เดียวกัน ส่วน Section สร้างได้หลายกล่องในแต่ละคอลัมน์และเลื่อนได้อัตโนมัติ ไม่มีเส้นขอบล้อม Section

## Controls

| Method | Options |
|---|---|
| `Section:Toggle` | `Name`, `Default`, `Keybind`, `Mode`, `Callback(value)` |
| `Section:Slider` | `Name`, `Min`, `Max`, `Step`, `Default`, `Callback(value)` |
| `Section:Dropdown` | `Name`, `Options={"A","B"}`, `Default`, `Callback(value)` |
| `Section:Textbox` หรือ `TextBox` | `Name`, `Default`, `Placeholder`, `Callback(text, enterPressed)` |
| `Section:Button` | `Name`, `Callback()` |
| `Section:Label` | `Text`, `Height`, `Size` หรือส่งข้อความอย่างเดียว |

ตัวควบคุมแต่ละตัวใส่ `Id` เองได้ ถ้าไม่ใส่ ระบบสร้างให้ ห้าม Id ซ้ำในหน้าต่างเดียวกัน และสงวน `Tab` กับ `Animations` ไว้ใช้ภายใน

Callback ไม่ทำงานตอนสร้าง control เริ่มต้น จะทำงานเมื่อค่าเปลี่ยนจากการกดหรือ `:Set()` ส่วน Button ทำงานเมื่อกด ส่วน Textbox ทำงานเมื่อเลิกพิมพ์หรือเรียก `:Set()`

Callback ถูกเรียกแยกงานและดัก error เพื่อให้ error ในฟังก์ชันหนึ่งไม่ทำให้ UI หยุด ตรวจ error ล่าสุดที่ `Window.LastError`

```lua
Enabled:Set(true)        -- เปลี่ยนค่าและเรียก Callback เมื่อค่าเปลี่ยน
Enabled:Set(false, true) -- เปลี่ยนค่าโดยไม่เรียก Callback
print(Enabled:Get())
Enabled:SetKey(Enum.KeyCode.F8)
Enabled:SetMode("Hold")
Enabled:SetKey(nil)      -- ยกเลิกคีย์
```

Label ใช้ `Label:Set("New text")`; Button ใช้ `Button:Fire()` เพื่อเรียก Callback เอง

คีย์ลัดตั้งได้ผ่านกล่องข้าง toggle เช่นเดิม คลิกขวาเลือก Hold / Toggle / Unbind และคลิกนอกกรอบเพื่อปิดแบบเฟด

## Window

สร้างหน้าตั้งค่าธีมและปุ่มซ่อน/แสดง UI ด้วย:

```lua
Window:AddSettingsPage() -- Theme: White / Dark / Transparent และปุ่มตั้ง UI key
Window:SetTheme("Dark")
Window:SetToggleKey(Enum.KeyCode.F10)
print(Window:GetToggleKey())
```

ในหน้า Settings มีแถว `Ui keybind` ด้านล่างของแผงขวา ให้คลิกช่องสีขาวแล้วกดปุ่มใหม่ คีย์ UI มีสิทธิเหนือ keybind ของ toggle ที่ใช้ปุ่มเดียวกัน ขณะพิมพ์ใน TextBox จะไม่ซ่อน UI

Transparent ใช้แผงกระจกสีเทาโปร่งใส ขอบบาง และข้อความสีขาว

```lua
Window:SetScale(0.9)
Window:SetVisible(false)
Window:SetVisible(true)
Window:Destroy()
```

รันซ้ำด้วย `Id` เดิมจะล้างหน้าต่างเก่าก่อนสร้างใหม่ รวม event connections, tweens, งาน Callback ที่ Library เรียก และงานที่สร้างด้วย `Window:Spawn` / `Window:Delay`

ถ้าฟังก์ชันของคุณสร้าง resource เพิ่มเอง ให้ลงทะเบียนกับ Window เพื่อให้ล้างเมื่อรันซ้ำด้วย:

```lua
Window:Track(connection) -- RBXScriptConnection
Window:Track(instance)   -- Instance ที่สร้างเพิ่มนอก UI
Window:Track(thread)     -- thread ที่สร้างเอง
Window:Track(function()
    -- คืนค่า/หยุดฟังก์ชันเพิ่มเติมของคุณตรงนี้ (ไม่ควรรอหรือ yield)
end)
Window:Spawn(function()
    -- งานนี้จะถูกยกเลิกเมื่อ Window ถูกลบ
end)
Window:Delay(2, function()
    -- งานนี้จะไม่ทำงานถ้า Window ถูกลบก่อนครบเวลา
end)
```

งานที่คุณสร้างเองด้วย `task.spawn` หรือการเปลี่ยนค่าภายนอก UI ต้องลงทะเบียน `Track` หรือเพิ่ม cleanup function เพื่อให้คืนค่าครบ Library ไม่ล้าง script อื่นที่ไม่ได้เป็นเจ้าของ

`CreateWindow` รองรับ `Name`, `Id`, `ToggleKey`, `Transition` (วินาที), `Accent` (Color3)
ขนาดพื้นฐาน 780 × 510 ปรับย่ออัตโนมัติให้พอดีหน้าจอ สร้าง Window ด้วย Id เดิมจะปิดตัวเก่าก่อน

## โหลดผ่าน URL

หากนำ `litecoin_library.luau` ไปโฮสต์ที่ URL ซึ่งเปิดแล้วได้โค้ดดิบ สามารถโหลดด้วย `loadstring(game:HttpGet(rawUrl))()` แทน `readfile` ได้ โดย rawUrl ต้องเป็นลิงก์จริงที่คุณอัปโหลดไว้ Raw URL ของ Library: https://raw.githubusercontent.com/Seapoll/litecoin-ui-library/main/litecoin_library.luau

Library นี้ใช้ API ของ client ที่เชื่อมอยู่ (`loadstring`, `readfile`, `writefile`, `getcustomasset`, `base64_decode`) ไม่ใช่ ModuleScript สำหรับ Roblox Studio โดยตรง

ฟอนต์ FC Minimal ที่ส่งมาฝังใน Library แล้ว ดูบันทึกต้นฉบับที่ `FC-Minimal-Memo.txt`

