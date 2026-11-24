# UiLibrary

This documentation is for the current UiLibrary release. Examples use the library's actual API and are kept short so you can copy and edit them.

## Booting the Library

```lua
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/public-account-7/uilibrary/refs/heads/main/ui.lua"))()
```

## Creating a Window

```lua
local Window = Library:CreateWindow({
    Name = "My UI",
    Width = 600,
    Height = 450,
    ToggleKey = Enum.KeyCode.RightShift,
    AutoResize = true,
    MobileButton = true
})

--[[
Name = <string> - ScreenGui name.
Width = <number> - Window width.
Height = <number> - Window height.
ToggleKey = <keycode> - Key used to show or hide the UI.
AutoResize = <bool> - Automatically fit the window to the screen size.
MobileButton = <bool> - Show a draggable open/hide button on touch-enabled devices. Default is false.
]]
```

`Name`, `Width`, `Height`, and `ToggleKey` are optional. The default toggle key is RightShift.

## Creating a Tab

```lua
local Tab = Window:CreateTab("Main", "house")
```

The first argument is the tab name. The second argument is an optional Lucide icon name.

## Creating a Subtab

```lua
local Subtab = Tab:CreateSubtab("Player", "user")
```

A tab can contain multiple subtabs. Add sections and controls to a subtab.

## Creating a Section

```lua
local Section = Subtab:CreateSection("Movement", "left")
local RightSection = Subtab:CreateSection("Other", "right")
```

```lua
--[[
Name = <string> - Section title.
Side = <string> - "left" or "right".
Icon = <string> - Optional Lucide icon name (third argument).
]]
```

The side defaults to `"left"`. Sections stay in their chosen half-width column, even when the other column is empty; they never span both columns.

## Creating a Button

```lua
Section:AddButton({
    Name = "Click me",
    Callback = function()
        print("Button pressed")
    end
})
```

`Callback` runs when the button is clicked. You can place multiple buttons in the same row by chaining `AddButton`:

```lua
Section:AddButton({Name = "First", Callback = function() print("First") end})
    :AddButton({Name = "Second", Callback = function() print("Second") end})
```

## Creating a Toggle

```lua
local MyToggle = Section:AddToggle({
    Name = "Auto Farm",
    Default = false,
    Flag = "auto_farm",
    Callback = function(Value)
        print("Enabled:", Value)
    end
})
```

```lua
--[[
Name = <string> - Toggle name.
Default = <bool> - Starting value.
Flag = <string> - Optional ID used for flags and configs.
Callback = <function> - Runs with the new boolean value.
]]
```

### Changing a Toggle

```lua
MyToggle:Set(true)
MyToggle:Set(false)

print(MyToggle:Get())
```

## Creating a Dropdown

```lua
local MyDropdown = Section:AddDropdown({
    Name = "Weapon",
    Options = {"Combat", "Knife", "Bat"},
    Default = "Combat",
    Flag = "weapon",
    Callback = function(Value)
        print("Selected:", Value)
    end
})
```

```lua
--[[
Name = <string> - Dropdown name.
Options = <table> - List of available options.
Values = <table> - Alternative to Options. Can also be a function that returns a table.
Default = <string> - Starting option. It must match an item in Options.
Multi = <bool> - Allows selecting multiple options. Default is false.
Search = <bool> - Shows the search box. Default is true.
Flag = <string> - Optional ID used for flags and configs.
Callback = <function> - Runs with the selected value. Multi dropdowns return a table.
]]
```

### Changing a Dropdown Value

```lua
MyDropdown:Set("Knife")
print(MyDropdown:Get())
```

### Refreshing Dropdown Options

```lua
MyDropdown:Refresh({"Combat", "Knife", "Bat", "Katana"})
```

`Refresh` replaces the available options. The current selection is cleared if it is no longer in the list.

For a multi dropdown:

```lua
local Selected = Section:AddDropdown({
    Name = "Targets",
    Options = {"Player1", "Player2", "Player3"},
    Multi = true,
    Default = {"Player1"},
    Callback = function(Values)
        print(table.concat(Values, ", "))
    end
})

Selected:Set({"Player1", "Player3"})
Selected:Refresh({"Player1", "Player3", "Player4"})
```

## Creating a Slider

```lua
local MySlider = Section:AddSlider({
    Name = "WalkSpeed",
    Min = 16,
    Max = 100,
    Default = 16,
    Step = 1,
    Rounding = 0,
    Flag = "walk_speed",
    Callback = function(Value)
        print("WalkSpeed:", Value)
    end
})
```

```lua
--[[
Name = <string> - Slider name.
Min = <number> - Minimum value.
Max = <number> - Maximum value.
Default = <number> - Starting value.
Step = <number> - Amount to move per step. Default is 1.
Rounding = <number> - Decimal places shown. Default is 0.
Flag = <string> - Optional ID used for flags and configs.
Callback = <function> - Runs with the new number value.
]]
```

### Changing a Slider Value

```lua
MySlider:Set(50)
print(MySlider:Get())
```

## Creating a Textbox

```lua
local MyTextbox = Section:AddTextbox({
    Name = "Player Name",
    Default = "",
    Placeholder = "Enter a name...",
    Flag = "player_name",
    Callback = function(Value)
        print("Input:", Value)
    end
})
```

```lua
--[[
Name = <string> - Textbox name.
Default = <string> - Starting text.
Placeholder = <string> - Placeholder shown when empty.
Flag = <string> - Optional ID used for flags and configs.
Callback = <function> - Runs when the textbox loses focus, with its text.
]]
```

### Changing or Reading a Textbox

```lua
MyTextbox:Set("Some text")
print(MyTextbox:Get())
```

## Creating a Label

```lua
local MyLabel = Section:AddLabel("Status: Waiting")
```

### Changing a Label

`AddLabel` returns the actual TextLabel instance, so change its `Text` property:

```lua
MyLabel.Text = "Status: Running"
```

## Creating a Keybind

```lua
local MyKeybind = Section:AddKeybind({
    Name = "Test key",
    Default = Enum.KeyCode.E,
    Mode = "Toggle",
    Callback = function(Active)
        print("Keybind active:", Active)
    end,
    OnPress = function()
        print("Key pressed")
    end
})
```

```lua
--[[
Name = <string> - Keybind name.
Default = <keycode> - Starting key.
Mode = <string> - "Toggle", "Hold", or "Always". Default is "Toggle".
Callback = <function> - Runs when the active state changes.
OnPress = <function> - Runs when the key is pressed.
ChangedCallback = <function> - Runs when the key or mode is changed. Receives key and mode.
Flag = <string> - Optional ID used for flags and configs.
NoMode = <bool> - Hides the mode selection menu.
]]
```

### Changing a Keybind

```lua
MyKeybind:Set(Enum.KeyCode.F)
MyKeybind:Set({Key = Enum.KeyCode.G, Mode = "Hold"})

print(MyKeybind:Get())
print(MyKeybind:GetMode())
```

## Creating a Colorpicker

```lua
local MyColor = Section:AddColorpicker({
    Name = "Accent",
    Default = Color3.fromRGB(255, 0, 0),
    Transparency = 0,
    Flag = "accent_color",
    Callback = function(Color, Transparency)
        print(Color, Transparency)
    end
})
```

```lua
--[[
Name = <string> - Colorpicker name.
Default = <Color3> - Starting color.
Transparency = <number> - Starting transparency, from 0 to 1.
Flag = <string> - Optional ID used for flags and configs.
Callback = <function> - Runs with the Color3 and transparency values.
]]
```

### Changing or Reading a Colorpicker

```lua
MyColor:Set(Color3.fromRGB(255, 255, 255))

local Color = MyColor:GetColor()
local Transparency = MyColor:GetTransparency()
```

## Adding a Colorpicker or Keybind to a Toggle

You can attach extra controls directly to a toggle:

```lua
local AimToggle = Section:AddToggle({
    Name = "Aimbot",
    Default = false,
    Callback = function(Value)
        print("Aimbot:", Value)
    end
})

AimToggle:AddKeybind({
    Name = "Aimbot key",
    Default = Enum.KeyCode.Q,
    Mode = "Hold"
})

AimToggle:AddColorpicker({
    Name = "Target color",
    Default = Color3.fromRGB(255, 0, 0)
})
```

## Notifications

```lua
Library:Notify("Hello", "This is a notification.", 5)
```

The arguments are title, content, and duration in seconds.

## Flags

Flags let you read or change a control from anywhere in your script. Add a unique `Flag` to the control.

```lua
local Speed = Section:AddSlider({
    Name = "Speed",
    Min = 0,
    Max = 100,
    Default = 16,
    Flag = "speed"
})

print(Library.Flags["speed"])
Library.Setters["speed"](50)
```

`Library.Flags["speed"]` contains the current value. `Library.Setters["speed"]` is the setter function. You can also use the control variable, such as `Speed:Get()` or `Speed:Set(50)`.

Controls that support `Flag`: Toggle, Dropdown, Slider, Textbox, Keybind, and Colorpicker.

## Configs

Set a folder before creating your window. Configs are saved as JSON files inside that folder.

```lua
Library:SetFolder("MyScript")

local Window = Library:CreateWindow({Name = "My UI"})
local Tab = Window:CreateTab("Main")
local Subtab = Tab:CreateSubtab("Settings")
local Section = Subtab:CreateSection("Player")

Section:AddToggle({Name = "Enabled", Default = false, Flag = "enabled"})
Section:AddSlider({Name = "Speed", Min = 0, Max = 100, Default = 16, Flag = "speed"})

local Success, Message = Library:SaveConfig("default")
print(Success, Message)

local Loaded, LoadMessage = Library:LoadConfig("default")
print(Loaded, LoadMessage)
```

Useful config functions:

```lua
local Configs = Library:GetConfigs()
Library:SaveConfig("default")
Library:LoadConfig("default")
Library:DeleteConfig("default")
Library:SetAutoload("default")
Library:GetAutoload()
Library:LoadAutoload()
```

Config saving requires the executor's file functions (`writefile`, `readfile`, and `listfiles` or `listfile`).

### Adding Config and Interface Settings

Pass a tab created by `Window:CreateTab()` as the first argument. The second argument is an optional settings table.

```lua
local SettingsTab = Window:CreateTab("Settings", "settings")

Library:SetConfigTab(SettingsTab, {
    AutoLoad = true,
    AutoLoadTheme = true
})
```

- `AutoLoad` = Automatically load the saved config when the config tab is created. Defaults to `true`.
- `AutoLoadTheme` = Automatically load the saved theme when the config tab is created. Defaults to `true`.

## Themes

```lua
local Themes = Library:GetThemes()
Library:SaveTheme("my_theme")
Library:LoadTheme("my_theme")
Library:DeleteTheme("my_theme")
Library:SetThemeAutoload("my_theme")
Library:GetThemeAutoload()
Library:LoadThemeAutoload()
```

You can also change the accent color directly:

```lua
Window:SetAccent(Color3.fromRGB(150, 100, 255))
```

## Window Functions

```lua
Window:SetToggleKey(Enum.KeyCode.RightControl)
Window:SetTransparency(0.2)
Window:SetAccent(Color3.fromRGB(255, 0, 0))
Window:SetFont("Gotham")
Window:RefreshTheme()
Window:Close()
```

Use the `-` button beside `X` to hide the window without destroying it. Clicking `X` opens a confirmation dialog; confirming closes and destroys the UI, while `Window:Close()` closes it directly. The mobile menu toggle animates out with the close transition. Use `Window:Destroy()` to destroy it immediately.

### Watermark

The watermark starts hidden. Set its text, then enable it:

```lua
Window:SetWatermark("My Script")
Window:SetWatermarkVisibility(true)
```

Call `Window:SetWatermarkVisibility(false)` to hide it. The watermark stays visible when the main window is toggled or hidden, and can be dragged while the main window is open. Its background and gradient follow the window background color; change its text color in **Interface > Controls > Watermark Text**.

### Unload Callback

Register a callback to run when the close button is clicked or `Window:Close()` is called:

```lua
Window:OnUnload(function()
    print("Window closing")
end)
```

Callbacks run once when closing starts, before the close animation. Callback errors are warned and do not interrupt closing.

### Search

The sidebar search matches tab, subtab, section, control names, and control flags. Search selects a subtab with matching content and hides empty or nonmatching tabs. Tab and subtab buttons disappear immediately when they do not match; controls and sections keep their hide animation. Clearing the search restores the current valid subtab or selects the first populated one.

## Global UI Settings

```lua
Library:SetAnimations(false)
Library:SetAnimations(true)
Library:SetAnimationSpeed(1.5)
Library:SetFont("Gotham")
print(Library:GetFont())
```

Available fonts include `BuilderSans`, `Gotham`, `RobotoMono`, `SourceSans`, `Fredoka`, `Arimo`, `Roboto`, `RobotoCondensed`, `Ubuntu`, `Nunito`, `Oswald`, `JosefinSans`, `TitilliumWeb`, `Merriweather`, `Code`, `Jura`, `Michroma`, `Sarpanch`, `Kalam`, `IndieFlower`, `PatrickHand`, `Bangers`, `LuckiestGuy`, `Highway`, and `SciFi`.

## Full Example

```lua
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/public-account-7/uilibrary/refs/heads/main/ui.lua"))()

local Window = Library:CreateWindow({Name = "My UI"})
local Tab = Window:CreateTab("Main", "house")
local Subtab = Tab:CreateSubtab("Home")
local Section = Subtab:CreateSection("Example", "left")

local Toggle = Section:AddToggle({
    Name = "Enabled",
    Default = false,
    Callback = function(Value)
        print(Value)
    end
})

local Dropdown = Section:AddDropdown({
    Name = "Mode",
    Options = {"A", "B", "C"},
    Default = "A",
    Callback = function(Value)
        print(Value)
    end
})

local Slider = Section:AddSlider({
    Name = "Speed",
    Min = 0,
    Max = 100,
    Default = 25,
    Callback = function(Value)
        print(Value)
    end
})

Toggle:Set(true)
Dropdown:Refresh({"A", "B", "C", "D"})
Slider:Set(50)
```
