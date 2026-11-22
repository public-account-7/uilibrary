# UiLibrary Documentation

Roblox UI library with tabs, subtabs, sections, theming, configs, and themes.

```lua
local UiLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/public-account-7/uilibrary/refs/heads/main/ui.lua"))()
```

---

## Library

### `UiLibrary:SetFolder(name)`
Sets the root folder used for configs and themes.  
Default: `"UiLibrary"`

### `UiLibrary:SetAnimations(enabled)`
Enables or disables UI animations globally.

### `UiLibrary:SetAnimationSpeed(speed)`
Animation speed multiplier. Clamped to `0.1` – `5`. Default `1`.

### `UiLibrary:CreateWindow(config)`
Creates the main window. Destroys any existing window on the same library instance.

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `Name` | string | `"UiLibrary"` | ScreenGui name |
| `Title` | string | `"visualise"` | Topbar title |
| `Width` | number | `700` | Window width |
| `Height` | number | `430` | Window height |
| `ToggleKey` | KeyCode / string | `RightShift` | Key to toggle visibility |

Returns: **Window**

### `UiLibrary:SetConfigTab(Tab, Options)`
Builds the Config + Interface subtabs on an existing tab (configs, themes, accent, colors).

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `AutoLoad` | boolean | `true` | Load autoload config on open |
| `AutoLoadTheme` | boolean | `true` | Load autoload theme on open |

---

## Configs

Requires executor filesystem (`writefile`, `readfile`, `listfiles`).

| Method | Returns | Description |
|--------|---------|-------------|
| `GetConfigs()` | `{string}` | Sorted config names |
| `SaveConfig(name)` | `ok, message` | Save current flags |
| `LoadConfig(name)` | `ok, message` | Load flags into UI |
| `DeleteConfig(name)` | `ok, message` | Delete config file |
| `GetAutoload()` | string | Autoload config name or `""` |
| `SetAutoload(name)` | `ok, message` | Set autoload (`""` clears) |
| `LoadAutoload()` | `ok, message` | Load the autoload config |

Flags are registered via control `Flag` options and stored as JSON under `Folder/configs/`.

---

## Themes

| Method | Returns | Description |
|--------|---------|-------------|
| `GetThemes()` | `{string}` | Sorted theme names |
| `SaveTheme(name)` | `ok, message` | Save current colors |
| `LoadTheme(name)` | `ok, message` | Load theme + sync colorpickers |
| `DeleteTheme(name)` | `ok, message` | Delete theme file |
| `GetThemeAutoload()` | string | Autoload theme name or `""` |
| `SetThemeAutoload(name)` | `ok, message` | Set theme autoload (`""` clears) |
| `LoadThemeAutoload()` | `ok, message` | Load the autoload theme |

Themes are stored under `Folder/themes/`.

---

## Window

| Method | Description |
|--------|-------------|
| `CreateTab(Name)` | Creates a sidebar tab. Returns **Tab** |
| `SetVisible(visible)` | Show / hide with animation |
| `Toggle()` | Toggle visibility |
| `SetToggleKey(key)` | KeyCode, name string, or `nil` |
| `SetTransparency(value)` | Window background transparency `0`–`1` |
| `SetAccent(color)` | Accent Color3 + derived deep accent |
| `RefreshTheme()` | Re-apply all theme hooks |
| `Close()` | Animate out and destroy |
| `Destroy()` | Immediate cleanup |

---

## Tab

| Method | Description |
|--------|-------------|
| `CreateSubtab(Name)` | Creates a subtab under the tab. Returns **Subtab** |

---

## Subtab

| Method | Description |
|--------|-------------|
| `CreateSection(Name, Side)` | `Side`: `"left"` (default) or `"right"`. Returns **Section** |

---

## Section

### `AddLabel(Text)`
Adds a wrapped text label. Returns the `TextLabel`.

### `AddButton(Options)`
| Option | Type | Description |
|--------|------|-------------|
| `Name` | string | Button text |
| `Callback` | function | Called on click |

Returns a **chain** object:

```lua
Section:AddButton({
	Name = "Save",
	Callback = function() end
}):AddButton({
	Name = "Load",
	Callback = function() end
})
```

Chained buttons share one row and split width evenly.

### `AddToggle(Options)`
| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `Name` | string | `"Toggle"` | Label |
| `Flag` | string | | Config flag |
| `Default` | boolean | `false` | Initial state |
| `Callback` | `function(enabled)` | | On change |

Returns **Toggle**:

| Method | Description |
|--------|-------------|
| `Set` / `SetValue(value, invoke?)` | Set state (`invoke ~= false` fires callback) |
| `Get` / `GetValue()` | Current boolean |
| `AddKeybind(KeyOptions)` | Attaches a keybind; returns Toggle |

### `AddDropdown(Options)`
| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `Name` | string | `"Dropdown"` | Label |
| `Flag` | string | | Config flag |
| `Options` | `{any}` | | Static choices |
| `Values` | `{any}` or `function` | | Choices (function called once at create) |
| `Default` | any or `{any}` | | Single value, or list when `Multi` |
| `Multi` | boolean | `false` | Multi-select |
| `Callback` | function | | Single: value; Multi: array of values |

Returns **Dropdown**:

| Method | Description |
|--------|-------------|
| `Set` / `SetValue(value, invoke?)` | Single value or array when Multi |
| `Get` / `GetValue()` | Current value or array copy |
| `Refresh(newChoices?)` | Replace options (table/function). Omit to re-run `Values` function |

### `AddSlider(Options)`
| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `Name` | string | `"Slider"` | Label |
| `Flag` | string | | Config flag |
| `Min` | number | `0` | Minimum |
| `Max` | number | `100` | Maximum |
| `Step` | number | `1` | Snap step |
| `Rounding` | number | `0` | Decimal places shown/stored |
| `Default` | number | `Min` | Initial value |
| `Callback` | `function(value)` | | On change |

Returns **Slider**:

| Method | Description |
|--------|-------------|
| `Set` / `SetValue(value, invoke?, instant?)` | Set value |
| `Get` / `GetValue()` | Current number |

### `AddKeybind(Options)`
| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `Name` | string | `"Keybind"` | Label |
| `Flag` | string | | Config flag |
| `Default` | KeyCode / string | | Initial key |
| `Mode` | `"Toggle"` / `"Hold"` / `"Always"` | `"Toggle"` | Activation mode |
| `NoMode` | boolean | `false` | Hide mode menu (right-click) |
| `SyncState` / `SyncToggleState` | boolean | `false` | Sync with host toggle |
| `Callback` | `function(state)` | | On press state change |
| `OnPress` | function | | Extra press hook |
| `ChangedCallback` | `function(key, mode)` | | When key/mode changes |

**Modes**
- `Toggle` — press to turn on/off
- `Hold` — active while key is held
- `Always` — always on (`GetState()` is always `true`)

Left-click: listen for key (`Esc` cancel, `Backspace` clear).  
Right-click: Always / Hold / Toggle (unless `NoMode`).

Returns **KeyPicker**:

| Method | Description |
|--------|-------------|
| `Set` / `SetValue(value, invoke?)` | KeyCode, name, or `{Key, Mode}` |
| `Get` / `GetValue()` | Current KeyCode or nil |
| `GetMode()` | `"Always"`, `"Hold"`, or `"Toggle"` |
| `SetMode(mode)` | Set mode |
| `GetState()` | Current state (`true` when Always) |

### `AddTextbox(Options)`
| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `Name` | string | `"Textbox"` | Label |
| `Flag` | string | | Config flag |
| `Default` | string | `""` | Initial text |
| `Placeholder` | string | `""` | Placeholder |
| `Callback` | `function(text)` | | On focus lost |

Returns:

| Method | Description |
|--------|-------------|
| `Set` / `SetValue(value, invoke?)` | Set text |
| `Get` / `GetValue()` | Current text |

### `AddColorpicker(Options)`
| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `Name` | string | `"Color"` | Label |
| `Flag` | string | | Config flag |
| `Default` | Color3 | White | Initial color |
| `Transparency` / `DefaultTransparency` | number | `0` | 0–1 |
| `Callback` | `function(color, transparency)` | | On change |

Returns:

| Method | Description |
|--------|-------------|
| `Set` / `SetValue(value, invoke?)` | Color3, hex string, or `{R,G,B,Transparency}` |
| `Get` / `GetValue()` | `color, transparency` |
| `GetColor()` | Color3 |
| `GetTransparency()` | number |

---

## Flags & config load

Controls with a `Flag` string register into `UiLibrary.Flags` and `UiLibrary.Setters`.

- `SaveConfig` writes all flags as JSON.
- `LoadConfig` calls each setter with `(value, true)` so UI and callbacks update, then refreshes the theme.

Second argument on setters: `invoke ~= false` fires the control callback.

---

## Hierarchy example

```lua
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/public-account-7/uilibrary/refs/heads/main/ui.lua"))()
Library:SetFolder("MyScript")

local Window = Library:CreateWindow({
	Title = "My Script",
	ToggleKey = Enum.KeyCode.RightShift
})

local Tab = Window:CreateTab("Main")
local Sub = Tab:CreateSubtab("General")
local Left = Sub:CreateSection("Combat", "left")
local Right = Sub:CreateSection("Visuals", "right")

Left:AddToggle({
	Name = "Aimbot",
	Flag = "Aimbot",
	Default = false,
	Callback = function(v) end
}):AddKeybind({
	Flag = "Aimbot_Key",
	Default = Enum.KeyCode.E,
	Mode = "Hold",
	SyncState = true
})

local Settings = Window:CreateTab("Settings")
Library:SetConfigTab(Settings)
```

---

## Notes

- Toggle UI default key: **RightShift** (configurable).
- Keybind boxes: left-click to bind, right-click for Hold/Toggle.
- Multi dropdown: click options to toggle; click outside to close. Callback receives a list.
- `Values` on dropdown may be a function; it runs once at creation. Call `:Refresh()` to run it again.
- Theme colorpickers live under **Settings → Interface** when using `SetConfigTab`.
