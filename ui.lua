local UiLibrary = {}
UiLibrary.__index = UiLibrary
UiLibrary.Flags = {}
UiLibrary.Setters = {}
UiLibrary.Folder = "UiLibrary"
UiLibrary.Window = nil

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

local FS = {
	Write = writefile,
	Read = readfile,
	List = listfiles or listfile,
	IsFile = isfile,
	IsFolder = isfolder,
	MakeFolder = makefolder,
	Delete = delfile
}

UiLibrary.ConfigSupported = type(FS.Write) == "function"
	and type(FS.Read) == "function"
	and type(FS.List) == "function"

local Colors = {
	Window     = Color3.fromHex("#0b0b0f"),
	Card       = Color3.fromHex("#17171d"),
	Bar        = Color3.fromHex("#1e1e26"),
	Row        = Color3.fromHex("#2a2a33"),
	Hover      = Color3.fromHex("#34343f"),
	Pill       = Color3.fromHex("#262630"),
	Popup      = Color3.fromHex("#16161c"),
	Text       = Color3.fromHex("#f0f0f5"),
	Label      = Color3.fromHex("#a4a4b0"),
	Dim        = Color3.fromHex("#53535f"),
	Accent     = Color3.fromHex("#b79cff"),
	AccentDeep = Color3.fromHex("#7b5cf0"),
	ToggleOff  = Color3.fromHex("#363642"),
	ToggleOn   = Color3.fromHex("#ffffff"),
	SliderTrack = Color3.fromHex("#363642"),
	Knob       = Color3.fromHex("#ffffff"),
	Danger     = Color3.fromHex("#ff6b75"),
	White      = Color3.fromHex("#ffffff")
}

local Alpha = {
	Window = 0.1,
	Card = 0.5,
	Bar = 0.4,
	Row = 0.4,
	Pill = 0.2
}

local Fonts = {
	Regular = Enum.Font.BuilderSans,
	Medium = Enum.Font.BuilderSansMedium,
	Bold = Enum.Font.BuilderSansBold
}

local TextSize = 15

local Anim = {
	Fast = TweenInfo.new(0.12, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
	Normal = TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
	Slow = TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
	Drag = TweenInfo.new(0.09, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
}

local Settings = {
	Animations = true,
	Speed = 1
}

local ScaledInfo = {}

local function GetInfo(info)
	if Settings.Speed == 1 then
		return info
	end

	local scaled = ScaledInfo[info]

	if not scaled then
		scaled = TweenInfo.new(info.Time / Settings.Speed, info.EasingStyle, info.EasingDirection)
		ScaledInfo[info] = scaled
	end

	return scaled
end

local function Duration(info)
	if not Settings.Animations then
		return 0
	end

	return info.Time / Settings.Speed
end

function UiLibrary:SetAnimations(enabled)
	Settings.Animations = enabled == true
end

function UiLibrary:SetAnimationSpeed(speed)
	Settings.Speed = math.clamp(tonumber(speed) or 1, 0.1, 5)
	table.clear(ScaledInfo)
end

local function Tween(object, info, properties)
	if not Settings.Animations then
		for property, value in pairs(properties) do
			object[property] = value
		end

		return
	end

	TweenService:Create(object, GetInfo(info), properties):Play()
end

local function Create(class, properties, parent)
	local object = Instance.new(class)

	if properties then
		for property, value in pairs(properties) do
			object[property] = value
		end
	end

	object.Parent = parent
	return object
end

local function Corner(parent, radius)
	Create("UICorner", { CornerRadius = UDim.new(0, radius or 6) }, parent)
end

local function Round(parent)
	Create("UICorner", { CornerRadius = UDim.new(1, 0) }, parent)
end

local function Padding(parent, left, top, right, bottom)
	Create("UIPadding", {
		PaddingLeft = UDim.new(0, left or 0),
		PaddingTop = UDim.new(0, top or 0),
		PaddingRight = UDim.new(0, right or 0),
		PaddingBottom = UDim.new(0, bottom or 0)
	}, parent)
end

local function ShowGroup(group, basePosition, rise)
	group.Visible = true
	group.GroupTransparency = 1
	group.Position = basePosition + UDim2.fromOffset(0, rise or 10)

	Tween(group, Anim.Slow, {
		GroupTransparency = 0,
		Position = basePosition
	})
end

local function Label(parent, text, size, color, font)
	return Create("TextLabel", {
		BackgroundTransparency = 1,
		Text = text or "",
		Font = font or Fonts.Regular,
		TextSize = size or 13,
		TextColor3 = color or Colors.Label,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Center
	}, parent)
end

local function Layout(parent, padding, direction)
	return Create("UIListLayout", {
		Padding = UDim.new(0, padding or 6),
		FillDirection = direction or Enum.FillDirection.Vertical,
		SortOrder = Enum.SortOrder.LayoutOrder
	}, parent)
end

local function Hover(object, property, off, on, condition)
	object.MouseEnter:Connect(function()
		if not condition or condition() then
			Tween(object, Anim.Fast, { [property] = on })
		end
	end)

	object.MouseLeave:Connect(function()
		if not condition or condition() then
			Tween(object, Anim.Fast, { [property] = off })
		end
	end)
end

local function Button(parent, text)
	local button = Create("TextButton", {
		BackgroundColor3 = Colors.Row,
		BackgroundTransparency = Alpha.Row,
		BorderSizePixel = 0,
		Text = text or "",
		Font = Fonts.Regular,
		TextSize = 15,
		TextColor3 = Colors.Text,
		AutoButtonColor = false
	}, parent)

	Corner(button, 7)
	Hover(button, "BackgroundColor3", Colors.Row, Colors.Hover)

	button.MouseButton1Down:Connect(function()
		Tween(button, Anim.Fast, { BackgroundColor3 = Colors.Bar })
	end)

	button.MouseButton1Up:Connect(function()
		Tween(button, Anim.Fast, { BackgroundColor3 = Colors.Hover })
	end)

	return button
end

local function Stroke(parent)
	Create("UIStroke", {
		Color = Colors.White,
		Transparency = 0.9,
		Thickness = 1,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	}, parent)
end

local function Chevron(parent, position)
	local arrow = Create("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		Position = position,
		Size = UDim2.fromOffset(14, 12)
	}, parent)

	local parts = {}

	for _, side in ipairs({ -1, 1 }) do
		local part = Create("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, side * 2, 0.5, 0),
			Size = UDim2.fromOffset(6, 2),
			Rotation = -side * 45,
			BackgroundColor3 = Colors.Text,
			BorderSizePixel = 0
		}, arrow)

		Corner(part, 1)
		table.insert(parts, part)
	end

	return function(color, open)
		Tween(arrow, Anim.Normal, { Rotation = open and 180 or 0 })

		for _, part in ipairs(parts) do
			Tween(part, Anim.Fast, { BackgroundColor3 = color })
		end
	end
end

local function IsPointer(input)
	return input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch
end

local function IsMove(input)
	return input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch
end

local function ResolveKey(value)
	if typeof(value) == "EnumItem" then
		return value
	end

	if type(value) ~= "string" or value == "" or value == "None" then
		return nil
	end

	local ok, key = pcall(function()
		return Enum.KeyCode[value]
	end)

	return ok and key or nil
end

local function DeriveDeep(accent)
	local h, s, v = accent:ToHSV()
	return Color3.fromHSV(h, math.clamp(s * 1.6, 0, 1), v * 0.94)
end

local function KnobColor(onAccent)
	return Colors.Knob
end

local ShortKeys = {
	LeftShift = "LShift", RightShift = "RShift", LeftControl = "LCtrl", RightControl = "RCtrl",
	LeftAlt = "LAlt", RightAlt = "RAlt", Return = "Enter", Backquote = "`", Backspace = "Bksp",
	CapsLock = "Caps", Escape = "Esc", Minus = "-", Equals = "=", LeftBracket = "[",
	RightBracket = "]", Semicolon = ";", Quote = "'", Comma = ",", Period = ".", Slash = "/",
	BackSlash = "\\", Zero = "0", One = "1", Two = "2", Three = "3", Four = "4",
	Five = "5", Six = "6", Seven = "7", Eight = "8", Nine = "9"
}

local function KeyText(key)
	if not key then
		return "None"
	end

	return ShortKeys[key.Name] or key.Name
end

local function Method(object, fn)
	return function(first, ...)
		if first == object then
			return fn(...)
		end

		return fn(first, ...)
	end
end

local function CloneList(List)
	local Copy = {}

	if type(List) ~= "table" then
		return Copy
	end

	for i, Value in ipairs(List) do
		Copy[i] = Value
	end

	return Copy
end

local function Bind(flag, setter, initial)
	if type(flag) == "string" and flag ~= "" then
		UiLibrary.Flags[flag] = initial
		UiLibrary.Setters[flag] = setter
	end
end

local function Store(flag, value)
	if type(flag) == "string" and flag ~= "" then
		UiLibrary.Flags[flag] = value
	end
end

local function Clean(name)
	name = (tostring(name or ""):gsub("[^%w%s_%-]", ""))
	return name:match("^%s*(.-)%s*$") or ""
end

function UiLibrary:SetFolder(name)
	self.Folder = Clean(name) ~= "" and Clean(name) or "UiLibrary"
end

local function ConfigFolder(self)
	return self.Folder .. "/configs"
end

local function ConfigPath(self, name)
	return ConfigFolder(self) .. "/" .. name .. ".json"
end

local function ThemeFolder(self)
	return self.Folder .. "/themes"
end

local function ThemePath(self, name)
	return ThemeFolder(self) .. "/" .. name .. ".json"
end

local function AutoloadPath(self)
	return self.Folder .. "/autoload.txt"
end

local function ThemeAutoloadPath(self)
	return self.Folder .. "/theme_autoload.txt"
end

local function EnsureFolders(self)
	if type(FS.MakeFolder) ~= "function" then
		return
	end

	for _, path in ipairs({ self.Folder, ConfigFolder(self), ThemeFolder(self) }) do
		local exists = false

		if type(FS.IsFolder) == "function" then
			local ok, result = pcall(FS.IsFolder, path)
			exists = ok and result
		end

		if not exists then
			pcall(FS.MakeFolder, path)
		end
	end
end

local function ColorToTable(c)
	return { R = c.R, G = c.G, B = c.B }
end

local function TableToColor(t)
	if typeof(t) == "Color3" then
		return t
	end
	if type(t) == "table" and t.R and t.G and t.B then
		return Color3.new(tonumber(t.R) or 1, tonumber(t.G) or 1, tonumber(t.B) or 1)
	end
	return nil
end

local ThemeColorKeys = {
	"Window", "Card", "Bar", "Row", "Hover", "Pill", "Popup",
	"Text", "Label", "Dim", "Accent", "AccentDeep",
	"ToggleOff", "ToggleOn", "SliderTrack", "Knob", "Danger", "White"
}

local ThemeFlagMap = {
	Window = "UI_WindowColor",
	Card = "UI_CardColor",
	Bar = "UI_BarColor",
	Row = "UI_RowColor",
	Hover = "UI_HoverColor",
	Pill = "UI_PillColor",
	Popup = "UI_PopupColor",
	Text = "UI_TextColor",
	Label = "UI_LabelColor",
	Dim = "UI_DimColor",
	Accent = "UI_AccentColor",
	Danger = "UI_DangerColor",
	ToggleOff = "UI_ToggleOffColor",
	ToggleOn = "UI_ToggleOnColor",
	SliderTrack = "UI_SliderTrackColor",
	Knob = "UI_KnobColor"
}

local function ExportTheme()
	local data = {}
	for _, key in ipairs(ThemeColorKeys) do
		if Colors[key] then
			data[key] = ColorToTable(Colors[key])
		end
	end
	return data
end

local function ApplyThemeData(data)
	if type(data) ~= "table" then
		return 0
	end

	local applied = 0
	for key, value in pairs(data) do
		local color = TableToColor(value)
		if color and Colors[key] ~= nil then
			Colors[key] = color
			applied += 1
		end
	end

	if data.Accent and not data.AccentDeep then
		Colors.AccentDeep = DeriveDeep(Colors.Accent)
	end

	return applied
end

local function SyncThemePickers(library, invoke)
	if not library then
		return
	end

	for key, flag in pairs(ThemeFlagMap) do
		local color = Colors[key]
		local setter = library.Setters[flag]

		if color and setter then
			local payload = {
				R = color.R,
				G = color.G,
				B = color.B,
				Transparency = 0
			}

			pcall(setter, payload, invoke == true)
			library.Flags[flag] = payload
		end
	end
end

function UiLibrary:GetConfigs()
	local names = {}

	if not self.ConfigSupported then
		return names
	end

	EnsureFolders(self)

	local ok, files = pcall(FS.List, ConfigFolder(self))

	if ok and type(files) == "table" then
		for _, file in ipairs(files) do
			local name = tostring(file):match("([^/\\]+)%.json$")

			if name then
				table.insert(names, name)
			end
		end
	end

	table.sort(names)
	return names
end

function UiLibrary:SaveConfig(name)
	if not self.ConfigSupported then
		return false, "Not supported"
	end

	name = Clean(name)

	if name == "" then
		return false, "Invalid config name"
	end

	EnsureFolders(self)

	local encoded, json = pcall(HttpService.JSONEncode, HttpService, self.Flags)

	if not encoded then
		return false, "Failed to encode flags"
	end

	local written = pcall(FS.Write, ConfigPath(self, name), json)

	if not written then
		return false, "Failed to write file"
	end

	return true, "Saved " .. name
end

function UiLibrary:LoadConfig(name)
	if not self.ConfigSupported then
		return false, "Not supported"
	end

	name = Clean(name)

	if name == "" then
		return false, "Invalid config name"
	end

	local read, raw = pcall(FS.Read, ConfigPath(self, name))

	if not read or type(raw) ~= "string" then
		return false, "Config not found"
	end

	local decoded, data = pcall(HttpService.JSONDecode, HttpService, raw)

	if not decoded or type(data) ~= "table" then
		return false, "Config is corrupted"
	end

	local applied = 0

	for flag, value in pairs(data) do
		local setter = self.Setters[flag]

		if setter and pcall(setter, value, true) then
			applied += 1
		end
	end

	if self.Window and self.Window.RefreshTheme then
		self.Window:RefreshTheme()
	end

	return true, ("Loaded %s (%d flags)"):format(name, applied)
end

function UiLibrary:DeleteConfig(name)
	if type(FS.Delete) ~= "function" then
		return false, "Delete not supported"
	end

	name = Clean(name)

	if name == "" then
		return false, "Invalid config name"
	end

	local ok = pcall(FS.Delete, ConfigPath(self, name))
	return ok, ok and ("Deleted " .. name) or "Failed to delete"
end

function UiLibrary:GetAutoload()
	if not self.ConfigSupported then
		return ""
	end

	local path = AutoloadPath(self)

	if type(FS.IsFile) == "function" then
		local ok, exists = pcall(FS.IsFile, path)

		if not ok or not exists then
			return ""
		end
	end

	local ok, name = pcall(FS.Read, path)
	return ok and Clean(name) or ""
end

function UiLibrary:SetAutoload(name)
	if not self.ConfigSupported then
		return false, "Not supported"
	end

	name = Clean(name)
	EnsureFolders(self)

	local ok = pcall(FS.Write, AutoloadPath(self), name)

	if not ok then
		return false, "Failed to write file"
	end

	return true, name == "" and "Autoload cleared" or ("Autoload set to " .. name)
end

function UiLibrary:LoadAutoload()
	local name = self:GetAutoload()

	if name == "" then
		return false, "No autoload set"
	end

	return self:LoadConfig(name)
end

function UiLibrary:GetThemes()
	local names = {}

	if not self.ConfigSupported then
		return names
	end

	EnsureFolders(self)

	local ok, files = pcall(FS.List, ThemeFolder(self))

	if ok and type(files) == "table" then
		for _, file in ipairs(files) do
			local name = tostring(file):match("([^/\\]+)%.json$")

			if name then
				table.insert(names, name)
			end
		end
	end

	table.sort(names)
	return names
end

function UiLibrary:SaveTheme(name)
	if not self.ConfigSupported then
		return false, "Not supported"
	end

	name = Clean(name)

	if name == "" then
		return false, "Invalid theme name"
	end

	EnsureFolders(self)

	local encoded, json = pcall(HttpService.JSONEncode, HttpService, ExportTheme())

	if not encoded then
		return false, "Failed to encode theme"
	end

	local written = pcall(FS.Write, ThemePath(self, name), json)

	if not written then
		return false, "Failed to write file"
	end

	return true, "Saved theme " .. name
end

function UiLibrary:LoadTheme(name)
	if not self.ConfigSupported then
		return false, "Not supported"
	end

	name = Clean(name)

	if name == "" then
		return false, "Invalid theme name"
	end

	local read, raw = pcall(FS.Read, ThemePath(self, name))

	if not read or type(raw) ~= "string" then
		return false, "Theme not found"
	end

	local decoded, data = pcall(HttpService.JSONDecode, HttpService, raw)

	if not decoded or type(data) ~= "table" then
		return false, "Theme is corrupted"
	end

	local applied = ApplyThemeData(data)

	SyncThemePickers(self, false)

	if self.Window and self.Window.RefreshTheme then
		self.Window:RefreshTheme()
	end

	return true, ("Loaded theme %s (%d colors)"):format(name, applied)
end

function UiLibrary:DeleteTheme(name)
	if type(FS.Delete) ~= "function" then
		return false, "Delete not supported"
	end

	name = Clean(name)

	if name == "" then
		return false, "Invalid theme name"
	end

	local ok = pcall(FS.Delete, ThemePath(self, name))
	return ok, ok and ("Deleted theme " .. name) or "Failed to delete"
end

function UiLibrary:GetThemeAutoload()
	if not self.ConfigSupported then
		return ""
	end

	local path = ThemeAutoloadPath(self)

	if type(FS.IsFile) == "function" then
		local ok, exists = pcall(FS.IsFile, path)

		if not ok or not exists then
			return ""
		end
	end

	local ok, name = pcall(FS.Read, path)
	return ok and Clean(name) or ""
end

function UiLibrary:SetThemeAutoload(name)
	if not self.ConfigSupported then
		return false, "Not supported"
	end

	name = Clean(name)
	EnsureFolders(self)

	local ok = pcall(FS.Write, ThemeAutoloadPath(self), name)

	if not ok then
		return false, "Failed to write file"
	end

	return true, name == "" and "Theme autoload cleared" or ("Theme autoload set to " .. name)
end

function UiLibrary:LoadThemeAutoload()
	local name = self:GetThemeAutoload()

	if name == "" then
		return false, "No theme autoload set"
	end

	return self:LoadTheme(name)
end

function UiLibrary:CreateWindow(config)
	config = config or {}

	if self.Window then
		self.Window:Destroy()
	end

	local Window = {
		Tabs = {},
		CurrentTab = nil,
		OpenDropdown = nil,
		Visible = true,
		ToggleKey = config.ToggleKey or Enum.KeyCode.RightShift,
		Themed = {},
		Keybinds = {},
		Connections = {},
		Drag = nil,
		DragEnd = nil,
		Listening = nil,
		CancelListen = nil
	}

	local Library = self
	local Player = Players.LocalPlayer

	local function Connect(signal, callback)
		local connection = signal:Connect(callback)
		table.insert(Window.Connections, connection)
		return connection
	end

	local function Theme(apply)
		apply()
		table.insert(Window.Themed, apply)
	end

	local GuiParent

	if type(gethui) == "function" then
		local ok, result = pcall(gethui)
		GuiParent = ok and result or nil
	end

	local Gui = Create("ScreenGui", {
		Name = config.Name or "UiLibrary",
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	}, GuiParent or Player:WaitForChild("PlayerGui"))

	Window.Gui = Gui

	local Width = config.Width or 700
	local Height = config.Height or 430
	local FullSize = UDim2.fromOffset(Width, Height)
	local SmallSize = UDim2.fromOffset(Width * 0.95, Height * 0.95)

	local Main = Create("CanvasGroup", {
		Name = "Main",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = SmallSize,
		GroupTransparency = 1,
		BackgroundColor3 = Colors.Window,
		BackgroundTransparency = Alpha.Window,
		BorderSizePixel = 0
	}, Gui)

	Corner(Main, 12)

	Window.Main = Main

	local Sheen = Create("Frame", {
		Name = "Sheen",
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = Colors.White,
		BorderSizePixel = 0
	}, Main)

	Create("UIGradient", {
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0.92),
			NumberSequenceKeypoint.new(0.45, 0.985),
			NumberSequenceKeypoint.new(1, 1)
		}),
		Rotation = 45
	}, Sheen)

	local Topbar = Create("Frame", {
		Size = UDim2.new(1, 0, 0, 48),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ZIndex = 2
	}, Main)

	Create("Frame", {
		Position = UDim2.new(0, 0, 1, -1),
		Size = UDim2.new(1, 0, 0, 1),
		BackgroundColor3 = Colors.White,
		BackgroundTransparency = 0.94,
		BorderSizePixel = 0,
		ZIndex = 2
	}, Topbar)

	local Title = Label(Topbar, config.Title or "visualise", 16, Colors.Text, Fonts.Medium)
	Title.Position = UDim2.fromOffset(16, 0)
	Title.Size = UDim2.new(1, -60, 1, 0)
	Title.ZIndex = 3

	Theme(function()
		Title.TextColor3 = Colors.Text
	end)

	local Close = Create("TextButton", {
		Position = UDim2.new(1, -38, 0, 10),
		Size = UDim2.fromOffset(28, 28),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Text = "×",
		TextColor3 = Colors.Dim,
		Font = Fonts.Regular,
		TextSize = 24,
		AutoButtonColor = false,
		ZIndex = 4
	}, Topbar)

	Theme(function()
		Close.TextColor3 = Colors.Dim
	end)

	Hover(Close, "TextColor3", Colors.Dim, Colors.Danger)

	local Sidebar = Create("Frame", {
		Position = UDim2.fromOffset(0, 48),
		Size = UDim2.new(0, 150, 1, -48),
		BackgroundTransparency = 1,
		BorderSizePixel = 0
	}, Main)

	Layout(Sidebar, 5)
	Padding(Sidebar, 10, 12, 10, 0)

	local Content = Create("Frame", {
		Position = UDim2.fromOffset(150, 56),
		Size = UDim2.new(1, -160, 1, -66),
		BackgroundColor3 = Colors.Card,
		BackgroundTransparency = Alpha.Card,
		BorderSizePixel = 0,
		ClipsDescendants = true
	}, Main)

	Corner(Content, 10)

	Window.Content = Content

	function Window:SetVisible(visible)
		visible = visible == true

		if Window.Visible == visible then
			return
		end

		Window.Visible = visible

		if Window.OpenDropdown then
			Window.OpenDropdown()
		end

		if visible then
			Gui.Enabled = true
			Tween(Main, Anim.Slow, { Size = FullSize, GroupTransparency = 0 })
		else
			Tween(Main, Anim.Normal, { Size = SmallSize, GroupTransparency = 1 })

			task.delay(Duration(Anim.Normal) + 0.02, function()
				if not Window.Visible and Gui.Parent then
					Gui.Enabled = false
				end
			end)
		end
	end

	function Window:Toggle()
		Window:SetVisible(not Window.Visible)
	end

	function Window:SetToggleKey(key)
		Window.ToggleKey = ResolveKey(key)
	end

	function Window:SetTransparency(value)
		Alpha.Window = math.clamp(value, 0, 1)
		Main.BackgroundTransparency = Alpha.Window
	end

	function Window:SetAccent(color)
		Colors.Accent = color
		Colors.AccentDeep = DeriveDeep(color)
		Window:RefreshTheme()
	end

	function Window:RefreshTheme()
		Main.BackgroundColor3 = Colors.Window
		Content.BackgroundColor3 = Colors.Card

		for _, apply in ipairs(Window.Themed) do
			apply()
		end
	end

	function Window:Destroy()
		for _, connection in ipairs(Window.Connections) do
			connection:Disconnect()
		end

		table.clear(Window.Connections)
		table.clear(Window.Themed)
		table.clear(Window.Keybinds)

		if Gui.Parent then
			Gui:Destroy()
		end

		if Library.Window == Window then
			Library.Window = nil
			table.clear(Library.Flags)
			table.clear(Library.Setters)
		end
	end

	function Window:Close()
		if Window.OpenDropdown then
			Window.OpenDropdown()
		end

		Tween(Main, Anim.Normal, { Size = SmallSize, GroupTransparency = 1 })

		task.delay(Duration(Anim.Normal) + 0.02, function()
			Window:Destroy()
		end)
	end

	Close.MouseButton1Click:Connect(function()
		Window:Close()
	end)

	Tween(Main, Anim.Slow, { Size = FullSize, GroupTransparency = 0 })

	Topbar.InputBegan:Connect(function(input)
		if not IsPointer(input) then
			return
		end

		if Window.OpenDropdown then
			Window.OpenDropdown()
		end

		local start = input.Position
		local origin = Main.Position

		Window.Drag = function(moved)
			local delta = moved.Position - start

			Main.Position = UDim2.new(
				origin.X.Scale,
				origin.X.Offset + delta.X,
				origin.Y.Scale,
				origin.Y.Offset + delta.Y
			)
		end
	end)

	Connect(UserInputService.InputChanged, function(input)
		if Window.Drag and IsMove(input) then
			Window.Drag(input)
		end
	end)

	Connect(UserInputService.InputEnded, function(input)
		if IsPointer(input) and Window.Drag then
			Window.Drag = nil

			if Window.DragEnd then
				local release = Window.DragEnd
				Window.DragEnd = nil
				release()
			end
		end

		if input.UserInputType == Enum.UserInputType.Keyboard then
			for _, entry in ipairs(Window.Keybinds) do
				if entry.Key and entry.Release and input.KeyCode == entry.Key then
					task.spawn(entry.Release)
				end
			end
		end
	end)

	Connect(UserInputService.WindowFocusReleased, function()
		for _, entry in ipairs(Window.Keybinds) do
			if entry.Release then
				task.spawn(entry.Release)
			end
		end
	end)

	Connect(UserInputService.InputBegan, function(input, processed)

		if Window.Listening then
			Window.Listening(input)
			return
		end

		if processed or input.UserInputType ~= Enum.UserInputType.Keyboard then
			return
		end

		if Window.ToggleKey and input.KeyCode == Window.ToggleKey then
			Window:Toggle()
			return
		end

		for _, entry in ipairs(Window.Keybinds) do
			if entry.Key and entry.Press and input.KeyCode == entry.Key then
				task.spawn(entry.Press)
			end
		end
	end)

	local function ShowPopup(Anchor, Choices, Selected, OnPick, OnClose, PopupOptions)
		PopupOptions = PopupOptions or {}

		if Window.OpenDropdown then
			Window.OpenDropdown()
		end

		local Compact = PopupOptions.Compact == true
		local Multi = PopupOptions.Multi == true

		local Overlay = Create("Frame", {
			Name = "DropdownOverlay",
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			ZIndex = 50
		}, Gui)

		local Outside = Create("TextButton", {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			Text = "",
			ZIndex = 50,
			AutoButtonColor = false
		}, Overlay)

		local PopupWidth = PopupOptions.Width or Anchor.AbsoluteSize.X
		local Shown = {}

		local function IsSelected(Choice)
			if Multi then
				return type(Selected) == "table" and table.find(Selected, Choice) ~= nil
			end

			return Choice == Selected
		end

		for _, Choice in ipairs(Choices) do
			if not Compact or not IsSelected(Choice) then
				table.insert(Shown, Choice)
			end
		end

		local ListTop = Compact and 34 or 4
		local Overflow = #Shown * 29 - 2 > 137
		local ListHeight = math.clamp(#Shown * 29 - 2, 0, 137)
		local FullHeight = ListTop + ListHeight + 4
		local ShownHeight = Compact and 32 or FullHeight
		local PosX = Anchor.AbsolutePosition.X

		if PopupOptions.AlignRight then
			PosX = PosX + Anchor.AbsoluteSize.X - PopupWidth
		end

		local PopupFrame = Create("Frame", {
			Name = "PopupFrame",
			Position = UDim2.fromOffset(PosX, Anchor.AbsolutePosition.Y + Anchor.AbsoluteSize.Y + 3),
			Size = UDim2.fromOffset(PopupWidth, 0),
			BackgroundColor3 = Colors.Popup,
			BackgroundTransparency = 0.04,
			BorderSizePixel = 0,
			ClipsDescendants = true,
			ZIndex = 51
		}, Overlay)

		Corner(PopupFrame, 7)

		if Compact then
			local Expanded = false

			local Header = Create("TextButton", {
				Position = UDim2.fromOffset(4, 4),
				Size = UDim2.new(1, -8, 0, 24),
				BackgroundColor3 = Colors.Pill,
				BorderSizePixel = 0,
				Text = "",
				Font = Fonts.Regular,
				TextSize = 14,
				TextColor3 = Colors.Text,
				TextXAlignment = Enum.TextXAlignment.Left,
				AutoButtonColor = false,
				ZIndex = 53
			}, PopupFrame)

			Corner(Header, 5)
			local HeaderText = Label(Header, tostring(Selected or ""), 14, Colors.Text)
			HeaderText.Position = UDim2.fromOffset(8, 0)
			HeaderText.Size = UDim2.new(1, -30, 1, 0)
			Hover(Header, "BackgroundColor3", Colors.Pill, Colors.Hover)

			local SetChevron = Chevron(Header, UDim2.new(1, -12, 0.5, 0))

			Header.MouseButton1Click:Connect(function()
				Expanded = not Expanded
				SetChevron(Expanded and Colors.Accent or Colors.Text, Expanded)

				Tween(PopupFrame, Anim.Normal, {
					Size = UDim2.fromOffset(PopupWidth, Expanded and FullHeight or ShownHeight)
				})
			end)
		end

		local ListFrame = Create("ScrollingFrame", {
			Position = UDim2.fromOffset(4, ListTop),
			Size = UDim2.new(1, -8, 0, ListHeight),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ScrollBarThickness = Overflow and 2 or 0,
			ScrollBarImageColor3 = Colors.Accent,
			CanvasSize = UDim2.new(0, 0, 0, 0),
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			ZIndex = 52
		}, PopupFrame)

		Layout(ListFrame, 2)

		local Closed = false

		local function Close()
			if Closed then
				return
			end

			Closed = true

			if Window.OpenDropdown == Close then
				Window.OpenDropdown = nil
			end

			Tween(PopupFrame, Anim.Fast, { Size = UDim2.fromOffset(PopupWidth, 0) })

			task.delay(Duration(Anim.Fast) + 0.02, function()
				Overlay:Destroy()
			end)

			if OnClose then
				OnClose()
			end
		end

		for _, Choice in ipairs(Shown) do
			local Active = IsSelected(Choice)

			local Item = Create("TextButton", {
				Size = UDim2.new(1, -2, 0, 27),
				BackgroundColor3 = Active and Colors.Pill or Colors.Popup,
				BorderSizePixel = 0,
				Text = tostring(Choice),
				Font = Fonts.Regular,
				TextSize = 14,
				TextColor3 = Active and Colors.Accent or Colors.Text,
				TextXAlignment = Enum.TextXAlignment.Left,
				AutoButtonColor = false,
				ZIndex = 53
			}, ListFrame)

			Corner(Item, 5)
			Padding(Item, 8)

			local function Paint()
				Item.BackgroundColor3 = Active and Colors.Pill or Colors.Popup
				Item.TextColor3 = Active and Colors.Accent or Colors.Text
			end

			Item.MouseEnter:Connect(function()
				Tween(Item, Anim.Fast, { BackgroundColor3 = Colors.Hover })
			end)

			Item.MouseLeave:Connect(function()
				Tween(Item, Anim.Fast, { BackgroundColor3 = Active and Colors.Pill or Colors.Popup })
			end)

			Item.MouseButton1Click:Connect(function()
				if Multi then
					Active = not Active
					Paint()
					OnPick(Choice, Active)
				else
					Close()
					OnPick(Choice)
				end
			end)
		end

		Outside.MouseButton1Click:Connect(Close)
		Outside.MouseButton2Click:Connect(Close)

		Window.OpenDropdown = Close

		Tween(PopupFrame, Anim.Normal, { Size = UDim2.fromOffset(PopupWidth, ShownHeight) })

		return Close
	end

	local function MakeKeyPicker(Parent, Options, Host, Place)
		Options = Options or {}

		local Flag = Options.Flag

		if not Flag and Host and Host.Flag then
			Flag = Host.Flag .. "_KeyPicker"
		end

		local Key = ResolveKey(Options.Default)
		local Mode = Options.Mode == "Hold" and "Hold" or "Toggle"
		local Sync = Options.SyncState == true or Options.SyncToggleState == true
		local State = false
		local Picker = { Flag = Flag }
		local Entry = { Key = Key }

		table.insert(Window.Keybinds, Entry)

		local Box = Create("TextButton", {
			AnchorPoint = Place.AnchorPoint,
			Position = Place.Position,
			Size = Place.Size,
			BackgroundColor3 = Colors.Pill,
			BackgroundTransparency = Alpha.Pill,
			BorderSizePixel = 0,
			Text = KeyText(Key),
			Font = Fonts.Medium,
			TextSize = 13,
			TextColor3 = Colors.Label,
			TextTruncate = Enum.TextTruncate.AtEnd,
			AutoButtonColor = false
		}, Parent)

		Corner(Box, 6)
		Stroke(Box)
		Padding(Box, 4, 0, 4, 0)
		Hover(Box, "BackgroundColor3", Colors.Pill, Colors.Hover)

		local function Display()
			Box.Text = KeyText(Key)
			Tween(Box, Anim.Fast, { TextColor3 = Colors.Label })
		end

		local function Save()
			Store(Flag, { Key = Key and Key.Name or "None", Mode = Mode })
		end

		local function SetState(NewState)
			if State == NewState then
				return
			end

			State = NewState

			if not Window.Listening then
				Display()
			end

			if Sync and Host then
				Host.Set(State)
			end

			if Options.Callback then
				Options.Callback(State)
			end
		end

		function Entry.Press()
			if Sync and Host then
				local current = Host.Get()
				State = current
				SetState(not current)
			elseif Mode == "Hold" then
				SetState(true)
			else
				SetState(not State)
			end

			if Options.OnPress then
				Options.OnPress()
			end
		end

		function Entry.Release()
			if Mode == "Hold" then
				if Sync and Host then
					local current = Host.Get()
					State = current
					SetState(not current)
				else
					SetState(false)
				end
			end
		end

		function Picker.SyncFromHost(Value)
			if Sync then
				State = Value == true
			end
		end

		local function Apply(NewKey, NewMode, Invoke)
			if Mode == "Hold" and State and (NewKey ~= Key or NewMode ~= Mode) then
				SetState(false)
			end

			Key = NewKey
			Mode = NewMode
			Entry.Key = NewKey

			Display()
			Save()

			if Invoke ~= false and Options.ChangedCallback then
				Options.ChangedCallback(Key, Mode)
			end
		end

		local function Set(Value, Invoke)
			if type(Value) == "table" then
				Apply(ResolveKey(Value.Key), Value.Mode == "Hold" and "Hold" or "Toggle", Invoke)
			else
				Apply(ResolveKey(Value), Mode, Invoke)
			end
		end

		Bind(Flag, Set, { Key = Key and Key.Name or "None", Mode = Mode })

		Box.MouseButton1Click:Connect(function()
			if Window.CancelListen then
				Window.CancelListen()
			end

			Box.Text = "..."
			Tween(Box, Anim.Fast, { TextColor3 = Colors.Accent })

			Window.CancelListen = function()
				Window.Listening = nil
				Window.CancelListen = nil
				Display()
			end

			Window.Listening = function(Input)
				if Input.UserInputType ~= Enum.UserInputType.Keyboard then
					return
				end

				Window.Listening = nil
				Window.CancelListen = nil

				if Input.KeyCode == Enum.KeyCode.Escape then
					Display()
				elseif Input.KeyCode == Enum.KeyCode.Backspace then
					Apply(nil, Mode)
				else
					Apply(Input.KeyCode, Mode)
				end
			end
		end)

		if not Options.NoMode then
			Box.MouseButton2Click:Connect(function()
				ShowPopup(Box, { "Hold", "Toggle" }, Mode, function(Choice)
					Apply(Key, Choice)
				end, nil, { Width = 84, AlignRight = true, Compact = true })
			end)
		end

		Picker.Set = Method(Picker, Set)
		Picker.SetValue = Picker.Set
		Picker.Get = Method(Picker, function() return Key end)
		Picker.GetValue = Picker.Get
		Picker.GetMode = Method(Picker, function() return Mode end)
		Picker.GetState = Method(Picker, function() return State end)
		Picker.SetMode = Method(Picker, function(NewMode)
			Apply(Key, NewMode == "Hold" and "Hold" or "Toggle")
		end)

		return Picker
	end

	function Window:CreateTab(Name)
		local Tab = {
			Window = Window,
			Subtabs = {},
			CurrentSub = nil
		}

		local TabButton = Create("TextButton", {
			Size = UDim2.new(1, 0, 0, 34),
			BackgroundColor3 = Colors.Pill,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Text = Name,
			Font = Fonts.Regular,
			TextSize = 16,
			TextColor3 = Colors.Dim,
			TextXAlignment = Enum.TextXAlignment.Left,
			AutoButtonColor = false
		}, Sidebar)

		Corner(TabButton, 7)
		Padding(TabButton, 12)

		local Indicator = Create("Frame", {
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, -3, 0.5, 0),
			Size = UDim2.new(0, 2, 0.2, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0
		}, TabButton)

		Corner(Indicator, 3)

		Theme(function()
			Indicator.BackgroundColor3 = Colors.Accent
			local active = Window.CurrentTab == Tab
			TabButton.TextColor3 = active and Colors.Text or Colors.Dim
			TabButton.BackgroundColor3 = Colors.Pill
		end)

		local TabContent = Create("CanvasGroup", {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			Visible = false
		}, Content)

		Tab.Button = TabButton
		Tab.Content = TabContent
		Tab.Indicator = Indicator

		local function SetTabState(Target, Active)
			Tween(Target.Button, Anim.Normal, {
				TextColor3 = Active and Colors.Text or Colors.Dim,
				BackgroundTransparency = Active and Alpha.Pill or 1
			})

			Tween(Target.Indicator, Anim.Normal, {
				Size = Active and UDim2.new(0, 2, 0.64, 0) or UDim2.new(0, 2, 0.2, 0),
				BackgroundTransparency = Active and 0 or 1
			})
		end

		local function SelectTab()
			if Window.OpenDropdown then
				Window.OpenDropdown()
			end

			if Window.CurrentTab == Tab then
				return
			end

			for _, Other in ipairs(Window.Tabs) do
				if Other ~= Tab then
					Other.Content.Visible = false
					SetTabState(Other, false)
				end
			end

			SetTabState(Tab, true)
			ShowGroup(TabContent, UDim2.fromScale(0, 0), 12)

			Window.CurrentTab = Tab
		end

		TabButton.MouseEnter:Connect(function()
			if Window.CurrentTab ~= Tab then
				Tween(TabButton, Anim.Fast, { TextColor3 = Colors.Label })
			end
		end)

		TabButton.MouseLeave:Connect(function()
			if Window.CurrentTab ~= Tab then
				Tween(TabButton, Anim.Fast, { TextColor3 = Colors.Dim })
			end
		end)

		TabButton.MouseButton1Click:Connect(SelectTab)

		local Subbar = Create("ScrollingFrame", {
			Position = UDim2.fromOffset(12, 12),
			Size = UDim2.new(1, -24, 0, 42),
			BackgroundColor3 = Colors.Bar,
			BackgroundTransparency = Alpha.Bar,
			BorderSizePixel = 0,
			ClipsDescendants = true,
			ScrollBarThickness = 0,
			ScrollingDirection = Enum.ScrollingDirection.X,
			CanvasSize = UDim2.new(0, 0, 0, 0),
			AutomaticCanvasSize = Enum.AutomaticSize.X,
			ElasticBehavior = Enum.ElasticBehavior.WhenScrollable,
			ScrollingEnabled = true
		}, TabContent)

		Theme(function()
			Subbar.BackgroundColor3 = Colors.Bar
		end)

		Corner(Subbar, 8)
		Layout(Subbar, 5, Enum.FillDirection.Horizontal)
		Padding(Subbar, 7, 6, 7, 6)

		local SubbarLayout = Subbar:FindFirstChildOfClass("UIListLayout")

		local Dragging = false
		local DragStart = nil
		local CanvasStart = 0

		Subbar.InputBegan:Connect(function(Input)
			if not IsPointer(Input) then
				return
			end

			Dragging = true
			DragStart = Input.Position
			CanvasStart = Subbar.CanvasPosition.X
		end)

		Subbar.InputEnded:Connect(function(Input)
			if IsPointer(Input) then
				Dragging = false
			end
		end)

		Connect(UserInputService.InputChanged, function(Input)
			if Dragging and IsMove(Input) then
				local Delta = Input.Position.X - DragStart.X
				local MaxCanvas = math.max(0, Subbar.AbsoluteCanvasSize.X - Subbar.AbsoluteSize.X)

				Subbar.CanvasPosition = Vector2.new(
					math.clamp(CanvasStart - Delta, 0, MaxCanvas),
					0
				)
			end
		end)

		Connect(UserInputService.InputEnded, function(Input)
			if IsPointer(Input) then
				Dragging = false
			end
		end)

		Subbar.InputChanged:Connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseWheel then
				local MaxCanvas = math.max(0, Subbar.AbsoluteCanvasSize.X - Subbar.AbsoluteSize.X)

				Subbar.CanvasPosition = Vector2.new(
					math.clamp(
						Subbar.CanvasPosition.X - Input.Position.Z * 45,
						0,
						MaxCanvas
					),
					0
				)
			end
		end)

		function Tab:CreateSubtab(SubName)
			local Subtab = {
				Sections = {}
			}

			local SubButton = Create("TextButton", {
				Size = UDim2.fromOffset(92, 28),
				BackgroundColor3 = Colors.Pill,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Text = SubName,
				Font = Fonts.Medium,
				TextSize = 15,
				TextColor3 = Colors.Label,
				AutoButtonColor = false
			}, Subbar)

			Corner(SubButton, 7)

			local SubIndicator = Create("Frame", {
				AnchorPoint = Vector2.new(0.5, 1),
				Position = UDim2.new(0.5, 0, 1, -2),
				Size = UDim2.new(0, 0, 0, 2),
				BackgroundTransparency = 1,
				BorderSizePixel = 0
			}, SubButton)

			Corner(SubIndicator, 2)

			Theme(function()
				SubIndicator.BackgroundColor3 = Colors.Accent
				local active = Tab.CurrentSub == Subtab
				SubButton.TextColor3 = active and Colors.Text or Colors.Label
				SubButton.BackgroundColor3 = Colors.Pill
			end)

			local Page = Create("CanvasGroup", {
				Position = UDim2.fromOffset(12, 62),
				Size = UDim2.new(1, -24, 1, -74),
				BackgroundTransparency = 1,
				Visible = false
			}, TabContent)

			local Scroll = Create("ScrollingFrame", {
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ScrollBarThickness = 0,
				CanvasSize = UDim2.new(0, 0, 0, 0),
				AutomaticCanvasSize = Enum.AutomaticSize.Y
			}, Page)

			local Columns = Create("Frame", {
				Size = UDim2.new(1, -4, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1
			}, Scroll)

			Layout(Columns, 8, Enum.FillDirection.Horizontal)

			local function Column(name)
				local frame = Create("Frame", {
					Name = name,
					Size = UDim2.new(0.5, -4, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundTransparency = 1
				}, Columns)

				Layout(frame, 8)
				return frame
			end

			local Left = Column("Left")
			local Right = Column("Right")

			Subtab.Page = Page
			Subtab.Scroll = Scroll
			Subtab.Button = SubButton
			Subtab.Indicator = SubIndicator
			Subtab.Left = Left
			Subtab.Right = Right

			local function SetSubState(Target, Active)
				Tween(Target.Button, Anim.Normal, {
					TextColor3 = Active and Colors.Text or Colors.Label,
					BackgroundTransparency = Active and Alpha.Pill or 1
				})

				Tween(Target.Indicator, Anim.Normal, {
					Size = Active and UDim2.new(0.7, 0, 0, 2) or UDim2.new(0, 0, 0, 2),
					BackgroundTransparency = Active and 0 or 1
				})
			end

			local function SelectSubtab()
				if Window.OpenDropdown then
					Window.OpenDropdown()
				end

				if Tab.CurrentSub == Subtab then
					return
				end

				for _, Other in ipairs(Tab.Subtabs) do
					if Other ~= Subtab then
						Other.Page.Visible = false
						SetSubState(Other, false)
					end
				end

				SetSubState(Subtab, true)
				ShowGroup(Page, UDim2.fromOffset(12, 62), 10)

				Tab.CurrentSub = Subtab
			end

			SubButton.MouseEnter:Connect(function()
				if Tab.CurrentSub ~= Subtab then
					Tween(SubButton, Anim.Fast, { TextColor3 = Colors.Text })
				end
			end)

			SubButton.MouseLeave:Connect(function()
				if Tab.CurrentSub ~= Subtab then
					Tween(SubButton, Anim.Fast, { TextColor3 = Colors.Label })
				end
			end)

			SubButton.MouseButton1Click:Connect(SelectSubtab)

			function Subtab:CreateSection(SectionName, Side)
				local Section = {}
				local Parent = string.lower(Side or "left") == "right" and Right or Left

				local SectionFrame = Create("Frame", {
					Name = SectionName,
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundTransparency = 1,
					BorderSizePixel = 0
				}, Parent)

				local SectionTitle = Label(SectionFrame, SectionName, 15, Colors.Text, Fonts.Medium)
				SectionTitle.Position = UDim2.fromOffset(2, 0)
				SectionTitle.Size = UDim2.new(1, -4, 0, 20)

				Theme(function()
					SectionTitle.TextColor3 = Colors.Text
				end)

				local SectionContent = Create("Frame", {
					Position = UDim2.fromOffset(0, 24),
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundTransparency = 1
				}, SectionFrame)

				Layout(SectionContent, 5)
				Padding(SectionContent, 0, 0, 0, 6)

				Section.Frame = SectionFrame
				Section.Content = SectionContent

				local function Row(height, class)
					local row = Create(class or "Frame", {
						Size = UDim2.new(1, 0, 0, height),
						BackgroundColor3 = Colors.Row,
						BackgroundTransparency = Alpha.Row,
						BorderSizePixel = 0,
						Text = class == "TextButton" and "" or nil,
						AutoButtonColor = class == "TextButton" and false or nil
					}, SectionContent)

					Corner(row, 7)

					Theme(function()
						row.BackgroundColor3 = Colors.Row
					end)

					return row
				end

				function Section:AddLabel(Text)
					local Object = Label(SectionContent, Text, 15, Colors.Label)
					Object.TextWrapped = true
					Object.AutomaticSize = Enum.AutomaticSize.Y
					Object.Size = UDim2.new(1, 0, 0, 24)

					Theme(function()
						Object.TextColor3 = Colors.Label
					end)

					return Object
				end

				function Section:AddButton(Options)
					Options = Options or {}

					local RowFrame = Create("Frame", {
						Size = UDim2.new(1, 0, 0, 34),
						BackgroundTransparency = 1,
						BorderSizePixel = 0
					}, SectionContent)

					local ListLayout = Create("UIListLayout", {
						FillDirection = Enum.FillDirection.Horizontal,
						Padding = UDim.new(0, 6),
						SortOrder = Enum.SortOrder.LayoutOrder
					}, RowFrame)

					local Buttons = {}
					local Chain = {}

					local function LayoutButtons()
						local count = #Buttons
						if count == 0 then
							return
						end

						local gap = 6
						local offset = -((count - 1) * gap) / count

						for _, btn in ipairs(Buttons) do
							btn.Size = UDim2.new(1 / count, offset, 1, 0)
						end
					end

					local function Add(opts)
						opts = opts or {}

						local Object = Button(RowFrame, opts.Name or "Button")
						Object.Size = UDim2.new(1, 0, 1, 0)
						Object.LayoutOrder = #Buttons + 1

						Object.MouseButton1Click:Connect(function()
							if opts.Callback then
								opts.Callback()
							end
						end)

						table.insert(Buttons, Object)
						LayoutButtons()

						return Chain
					end

					function Chain:AddButton(opts)
						return Add(opts)
					end

					Add(Options)

					return Chain
				end

				function Section:AddToggle(Options)
					Options = Options or {}

					local Enabled = Options.Default == true
					local Flag = Options.Flag
					local Toggle = { Flag = Flag, Pickers = {} }

					local Frame = Row(36)

					local Text = Label(Frame, Options.Name or "Toggle", TextSize, Enabled and Colors.Text or Colors.Label)
					Text.Position = UDim2.fromOffset(12, 1)
					Text.Size = UDim2.new(1, -60, 1, 0)
					Text.TextTruncate = Enum.TextTruncate.AtEnd

					local Switch = Create("TextButton", {
						Position = UDim2.new(1, -44, 0.5, -9),
						Size = UDim2.fromOffset(34, 18),
						BackgroundColor3 = Enabled and Colors.ToggleOn or Colors.ToggleOff,
						BorderSizePixel = 0,
						Text = "",
						AutoButtonColor = false
					}, Frame)

					Corner(Switch, 9)

					local SwitchGradient = Create("UIGradient", {
						Rotation = 0,
						Enabled = Enabled
					}, Switch)

					local Knob = Create("Frame", {
						Position = Enabled and UDim2.new(1, -16, 0, 2) or UDim2.fromOffset(2, 2),
						Size = UDim2.fromOffset(14, 14),
						BackgroundColor3 = KnobColor(Enabled),
						BorderSizePixel = 0
					}, Switch)

					Round(Knob)

					Theme(function()
						SwitchGradient.Color = ColorSequence.new(Colors.AccentDeep, Colors.Accent)
						Knob.BackgroundColor3 = KnobColor(Enabled)
						if not Enabled then
							Switch.BackgroundColor3 = Colors.ToggleOff
						else
							Switch.BackgroundColor3 = Colors.ToggleOn
						end
					end)

					local function Set(Value, Invoke)
						Enabled = Value == true
						Store(Flag, Enabled)

						SwitchGradient.Enabled = Enabled

						Tween(Switch, Anim.Normal, {
							BackgroundColor3 = Enabled and Colors.ToggleOn or Colors.ToggleOff
						})

						Tween(Knob, Anim.Normal, {
							Position = Enabled and UDim2.new(1, -16, 0, 2) or UDim2.fromOffset(2, 2),
							BackgroundColor3 = KnobColor(Enabled)
						})

						Tween(Text, Anim.Normal, {
							TextColor3 = Enabled and Colors.Text or Colors.Label
						})

						for _, Picker in ipairs(Toggle.Pickers) do
							Picker.SyncFromHost(Enabled)
						end

						if Invoke ~= false and Options.Callback then
							Options.Callback(Enabled)
						end
					end

					Bind(Flag, Set, Enabled)

					Switch.MouseButton1Click:Connect(function()
						Set(not Enabled)
					end)

					Toggle.Set = Method(Toggle, Set)
					Toggle.SetValue = Toggle.Set
					Toggle.Get = Method(Toggle, function() return Enabled end)
					Toggle.GetValue = Toggle.Get

					function Toggle:AddKeybind(KeyOptions)
						Text.Size = UDim2.new(1, -120, 1, 0)

						local Picker = MakeKeyPicker(Frame, KeyOptions, Toggle, {
							AnchorPoint = Vector2.new(1, 0.5),
							Position = UDim2.new(1, -54, 0.5, 0),
							Size = UDim2.fromOffset(48, 22)
						})

						table.insert(Toggle.Pickers, Picker)
						Toggle.KeyPicker = Picker

						return Toggle
					end

					return Toggle
				end

				function Section:AddDropdown(Options)
					Options = Options or {}

					local Multi = Options.Multi == true
					local Flag = Options.Flag
					local CloseHandle

					local function ResolveChoices(Source)
						if type(Source) == "function" then
							local ok, result = pcall(Source)
							if ok and type(result) == "table" then
								return result
							end
							return {}
						end

						if type(Source) == "table" then
							return Source
						end

						return {}
					end

					local Choices = ResolveChoices(Options.Values or Options.Options)

					local Selected

					if Multi then
						Selected = {}

						if type(Options.Default) == "table" then
							for _, Value in ipairs(Options.Default) do
								if table.find(Choices, Value) then
									table.insert(Selected, Value)
								end
							end
						elseif Options.Default ~= nil and table.find(Choices, Options.Default) then
							table.insert(Selected, Options.Default)
						end
					else
						Selected = Options.Default

						if Selected ~= nil and not table.find(Choices, Selected) then
							Selected = nil
						end
					end

					local Frame = Row(36, "TextButton")

					local Text = Label(Frame, Options.Name or "Dropdown", TextSize, Colors.Label)
					Text.Position = UDim2.fromOffset(12, 0)
					Text.Size = UDim2.new(0.5, 0, 1, 0)
					Text.TextTruncate = Enum.TextTruncate.AtEnd

					local function DisplayText()
						if Multi then
							if #Selected == 0 then
								return "Select"
							end

							return table.concat(Selected, ", ")
						end

						return Selected ~= nil and tostring(Selected) or "Select"
					end

					local ValueLabel = Label(Frame, DisplayText(), TextSize, Colors.Text)
					ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
					ValueLabel.TextTruncate = Enum.TextTruncate.AtEnd
					ValueLabel.Position = UDim2.new(0.4, 0, 0, 0)
					ValueLabel.Size = UDim2.new(0.6, -34, 1, 0)

					local SetArrow = Chevron(Frame, UDim2.new(1, -19, 0.5, 0))

					Hover(Frame, "BackgroundColor3", Colors.Row, Colors.Hover)

					local function Emit(Invoke)
						ValueLabel.Text = DisplayText()

						local Payload

						if Multi then
							Payload = CloneList(Selected)
						else
							Payload = Selected
						end

						Store(Flag, Payload)

						if Invoke ~= false and Options.Callback then
							Options.Callback(Payload)
						end
					end

					local function ChooseSingle(Value, Invoke)
						Selected = Value
						Emit(Invoke)
					end

					local function ToggleMulti(Value, Active, Invoke)
						local Index = table.find(Selected, Value)

						if Active then
							if not Index then
								table.insert(Selected, Value)
							end
						elseif Index then
							table.remove(Selected, Index)
						end

						Emit(Invoke)
					end

					local function CloseDropdown()
						if CloseHandle then
							CloseHandle()
						end
					end

					Frame.MouseButton1Click:Connect(function()
						if CloseHandle then
							CloseDropdown()
							return
						end

						CloseHandle = ShowPopup(Frame, Choices, Selected, function(Choice, Active)
							if Multi then
								ToggleMulti(Choice, Active, true)
							else
								ChooseSingle(Choice, true)
							end
						end, function()
							CloseHandle = nil
							SetArrow(Colors.Text, false)
						end, {
							Multi = Multi
						})

						SetArrow(Colors.Accent, true)
					end)

					local function Set(Value, Invoke)
						if Multi then
							Selected = {}

							if type(Value) == "table" then
								for _, Entry in ipairs(Value) do
									if table.find(Choices, Entry) then
										table.insert(Selected, Entry)
									end
								end
							elseif Value ~= nil and table.find(Choices, Value) then
								table.insert(Selected, Value)
							end

							Emit(Invoke)
						elseif Value == nil then
							Selected = nil
							Emit(Invoke)
						elseif table.find(Choices, Value) then
							ChooseSingle(Value, Invoke)
						end
					end

					local function Refresh(NewChoices)
						if type(NewChoices) == "function" or type(NewChoices) == "table" then
							Choices = ResolveChoices(NewChoices)
						elseif NewChoices == nil and type(Options.Values) == "function" then
							Choices = ResolveChoices(Options.Values)
						end

						CloseDropdown()

						if Multi then
							local Filtered = {}

							for _, Entry in ipairs(Selected) do
								if table.find(Choices, Entry) then
									table.insert(Filtered, Entry)
								end
							end

							Selected = Filtered
						elseif Selected ~= nil and not table.find(Choices, Selected) then
							Selected = nil
						end

						Emit(false)
					end

					local Dropdown = {
						Set = Set,
						SetValue = Set,
						Get = function()
							if Multi then
								return CloneList(Selected)
							end

							return Selected
						end,
						GetValue = function()
							if Multi then
								return CloneList(Selected)
							end

							return Selected
						end,
						Refresh = Refresh
					}

					Bind(Flag, Set, Multi and CloneList(Selected) or Selected)

					return Dropdown
				end

				function Section:AddSlider(Options)
					Options = Options or {}

					local Min = Options.Min or 0
					local Max = Options.Max or 100
					local Step = Options.Step or 1
					local Rounding = math.clamp(math.floor(tonumber(Options.Rounding) or 0), 0, 8)
					local Flag = Options.Flag

					local function FormatValue(Number)
						if Rounding <= 0 then
							return tostring(math.floor(Number + 0.5))
						end

						return string.format("%." .. Rounding .. "f", Number)
					end

					local function Snap(Number)
						Number = math.clamp(Number, Min, Max)
						Number = Min + math.round((Number - Min) / Step) * Step
						Number = math.clamp(Number, Min, Max)

						local mult = 10 ^ Rounding
						return math.floor(Number * mult + 0.5) / mult
					end

					local Value = Snap(Options.Default or Min)
					local Range = math.max(Max - Min, 1e-6)
					local Percent0 = (Value - Min) / Range

					local Frame = Row(52)

					local Text = Label(Frame, Options.Name or "Slider", TextSize, Colors.Label)
					Text.Position = UDim2.fromOffset(12, 6)
					Text.Size = UDim2.new(0.7, 0, 0, 22)
					Text.TextTruncate = Enum.TextTruncate.AtEnd

					local ValueLabel = Label(Frame, FormatValue(Value), TextSize, Colors.Text)
					ValueLabel.Position = UDim2.new(1, -58, 0, 6)
					ValueLabel.Size = UDim2.fromOffset(46, 22)
					ValueLabel.TextXAlignment = Enum.TextXAlignment.Right

					local Track = Create("Frame", {
						Position = UDim2.new(0, 12, 0, 35),
						Size = UDim2.new(1, -24, 0, 6),
						BackgroundColor3 = Colors.SliderTrack,
						BorderSizePixel = 0
					}, Frame)

					Round(Track)

					local Fill = Create("Frame", {
						Size = UDim2.new(Percent0, 0, 1, 0),
						BackgroundColor3 = Colors.White,
						BorderSizePixel = 0,
						ZIndex = 1
					}, Track)

					Round(Fill)

					local FillGradient = Create("UIGradient", { Rotation = 0 }, Fill)

					local Knob = Create("Frame", {
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.new(Percent0, 0, 0.5, 0),
						Size = UDim2.fromOffset(12, 12),
						BackgroundColor3 = KnobColor(true),
						BorderSizePixel = 0,
						ZIndex = 3
					}, Track)

					Round(Knob)

					Theme(function()
						FillGradient.Color = ColorSequence.new(Colors.AccentDeep, Colors.Accent)
						Knob.BackgroundColor3 = KnobColor(true)
						Track.BackgroundColor3 = Colors.SliderTrack
					end)

					local function Set(NewValue, Invoke, Instant)
						Value = Snap(NewValue)
						Store(Flag, Value)

						local Percent = (Value - Min) / Range
						local Info = Instant and Anim.Drag or Anim.Normal

						Tween(Knob, Info, { Position = UDim2.new(Percent, 0, 0.5, 0) })
						Tween(Fill, Info, { Size = UDim2.new(Percent, 0, 1, 0) })

						ValueLabel.Text = FormatValue(Value)

						if Invoke ~= false and Options.Callback then
							Options.Callback(Value)
						end
					end

					Bind(Flag, Set, Value)

					local function Update(Input)
						local Percent = math.clamp(
							(Input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X,
							0, 1
						)

						local Snapped = Snap(Min + (Max - Min) * Percent)

						if Snapped ~= Value then
							Set(Snapped, true, true)
						end
					end

					Track.InputBegan:Connect(function(Input)
						if not IsPointer(Input) then
							return
						end

						Window.Drag = Update
						Window.DragEnd = function() end

						Update(Input)
					end)

					local Slider = {
						Set = Set,
						SetValue = Set,
						Get = function()
							return Value
						end,
						GetValue = function()
							return Value
						end
					}

					return Slider
				end

				local function KeyRow(Options)
					local Frame = Row(36)

					local Text = Label(Frame, Options.Name or "Keybind", TextSize, Colors.Label)
					Text.Position = UDim2.fromOffset(12, 1)
					Text.Size = UDim2.new(1, -112, 1, 0)
					Text.TextTruncate = Enum.TextTruncate.AtEnd

					return MakeKeyPicker(Frame, Options, nil, {
						AnchorPoint = Vector2.new(1, 0.5),
						Position = UDim2.new(1, -8, 0.5, 0),
						Size = UDim2.fromOffset(90, 24)
					})
				end

				function Section:AddKeybind(Options)
					return KeyRow(Options or {})
				end

				function Section:AddTextbox(Options)
					Options = Options or {}

					local Flag = Options.Flag
					local Frame = Row(36)

					local Text = Label(Frame, Options.Name or "Textbox", TextSize, Colors.Label)
					Text.Position = UDim2.fromOffset(12, 1)
					Text.Size = UDim2.new(0.4, 0, 1, 0)
					Text.TextTruncate = Enum.TextTruncate.AtEnd

					local Box = Create("TextBox", {
						AnchorPoint = Vector2.new(1, 0.5),
						Position = UDim2.new(1, -8, 0.5, 0),
						Size = UDim2.new(0.6, -14, 0, 24),
						BackgroundColor3 = Colors.Pill,
						BackgroundTransparency = Alpha.Pill,
						BorderSizePixel = 0,
						Text = tostring(Options.Default or ""),
						PlaceholderText = Options.Placeholder or "",
						PlaceholderColor3 = Colors.Dim,
						TextColor3 = Colors.Text,
						Font = Fonts.Regular,
						TextSize = 14,
						TextXAlignment = Enum.TextXAlignment.Left,
						ClearTextOnFocus = false,
						ClipsDescendants = true
					}, Frame)

					Corner(Box, 6)
					Stroke(Box)
					Padding(Box, 8, 0, 8, 0)

					local function Set(Value, Invoke)
						Box.Text = tostring(Value or "")
						Store(Flag, Box.Text)

						if Invoke ~= false and Options.Callback then
							Options.Callback(Box.Text)
						end
					end

					Bind(Flag, Set, Box.Text)

					Box.FocusLost:Connect(function()
						Set(Box.Text)
					end)

					return {
						Set = Set,
						SetValue = Set,
						Get = function()
							return Box.Text
						end,
						GetValue = function()
							return Box.Text
						end
					}
				end

				function Section:AddColorpicker(Options)
					Options = Options or {}

					local Flag = Options.Flag
					local Color = typeof(Options.Default) == "Color3" and Options.Default or Color3.fromRGB(255, 255, 255)
					local Transparency = math.clamp(tonumber(Options.Transparency or Options.DefaultTransparency) or 0, 0, 1)
					local Hue, Sat, Val = Color:ToHSV()
					local CloseHandle = nil

					local Frame = Row(36, "TextButton")

					local Text = Label(Frame, Options.Name or "Color", TextSize, Colors.Label)
					Text.Position = UDim2.fromOffset(12, 0)
					Text.Size = UDim2.new(1, -52, 1, 0)
					Text.TextTruncate = Enum.TextTruncate.AtEnd

					local Swatch = Create("Frame", {
						AnchorPoint = Vector2.new(1, 0.5),
						Position = UDim2.new(1, -10, 0.5, 0),
						Size = UDim2.fromOffset(28, 20),
						BackgroundColor3 = Color,
						BackgroundTransparency = Transparency,
						BorderSizePixel = 0
					}, Frame)

					Corner(Swatch, 5)
					Stroke(Swatch)
					Hover(Frame, "BackgroundColor3", Colors.Row, Colors.Hover)

					local function ApplyVisual()
						Swatch.BackgroundColor3 = Color
						Swatch.BackgroundTransparency = Transparency
					end

					local function Save()
						Store(Flag, {
							R = Color.R,
							G = Color.G,
							B = Color.B,
							Transparency = Transparency
						})
					end

					local function Fire(Invoke)
						if Invoke ~= false and Options.Callback then
							Options.Callback(Color, Transparency)
						end
					end

					local function SetFromHSV(h, s, v, t, Invoke)
						Hue = h
						Sat = s
						Val = v
						Transparency = math.clamp(t or Transparency, 0, 1)
						Color = Color3.fromHSV(Hue, Sat, Val)
						ApplyVisual()
						Save()
						Fire(Invoke)
					end

					local function Set(Value, Invoke)
						if typeof(Value) == "Color3" then
							Color = Value
							Hue, Sat, Val = Color:ToHSV()
						elseif type(Value) == "table" then
							local r = Value.R or Value.r or Value[1]
							local g = Value.G or Value.g or Value[2]
							local b = Value.B or Value.b or Value[3]

							if r ~= nil and g ~= nil and b ~= nil then
								Color = Color3.new(
									tonumber(r) or 1,
									tonumber(g) or 1,
									tonumber(b) or 1
								)
								Hue, Sat, Val = Color:ToHSV()
							end

							local t = Value.Transparency or Value.transparency or Value.A or Value.a or Value[4]
							if t ~= nil then
								Transparency = math.clamp(tonumber(t) or 0, 0, 1)
							end
						elseif type(Value) == "string" then
							local ok, parsed = pcall(Color3.fromHex, Value)
							if ok and typeof(parsed) == "Color3" then
								Color = parsed
								Hue, Sat, Val = Color:ToHSV()
							end
						end

						ApplyVisual()
						Save()
						Fire(Invoke)
					end

					Bind(Flag, Set, {
						R = Color.R,
						G = Color.G,
						B = Color.B,
						Transparency = Transparency
					})

					local function OpenPicker()
						if Window.OpenDropdown then
							Window.OpenDropdown()
						end

						local Overlay = Create("Frame", {
							Name = "ColorpickerOverlay",
							Size = UDim2.fromScale(1, 1),
							BackgroundTransparency = 1,
							ZIndex = 50
						}, Gui)

						local Pad = 14
						local SVSize = 170
						local HueWidth = 20
						local Gap = 12
						local PickerWidth = Pad + SVSize + Gap + HueWidth + Pad
						local PickerHeight = Pad + SVSize + 12 + 18 + 10 + 14 + Pad
						local PosX = math.clamp(
							Swatch.AbsolutePosition.X + Swatch.AbsoluteSize.X - PickerWidth,
							8,
							Gui.AbsoluteSize.X - PickerWidth - 8
						)
						local PosY = Swatch.AbsolutePosition.Y + Swatch.AbsoluteSize.Y + 6

						if PosY + PickerHeight > Gui.AbsoluteSize.Y - 8 then
							PosY = Swatch.AbsolutePosition.Y - PickerHeight - 6
						end

						local Popup = Create("Frame", {
							Name = "ColorpickerPopup",
							Position = UDim2.fromOffset(PosX, PosY),
							Size = UDim2.fromOffset(PickerWidth, 0),
							BackgroundColor3 = Colors.Popup,
							BackgroundTransparency = 0.04,
							BorderSizePixel = 0,
							ClipsDescendants = true,
							ZIndex = 51
						}, Overlay)

						Corner(Popup, 8)

						local SV = Create("Frame", {
							Position = UDim2.fromOffset(Pad, Pad),
							Size = UDim2.fromOffset(SVSize, SVSize),
							BackgroundColor3 = Color3.fromHSV(Hue, 1, 1),
							BorderSizePixel = 0,
							ClipsDescendants = true,
							ZIndex = 52
						}, Popup)

						Corner(SV, 6)

						local SVWhite = Create("Frame", {
							Size = UDim2.fromScale(1, 1),
							BackgroundColor3 = Colors.White,
							BorderSizePixel = 0,
							ZIndex = 52
						}, SV)

						Corner(SVWhite, 6)

						Create("UIGradient", {
							Transparency = NumberSequence.new({
								NumberSequenceKeypoint.new(0, 0),
								NumberSequenceKeypoint.new(1, 1)
							})
						}, SVWhite)

						local SVBlack = Create("Frame", {
							Size = UDim2.fromScale(1, 1),
							BackgroundColor3 = Color3.new(0, 0, 0),
							BorderSizePixel = 0,
							ZIndex = 53
						}, SV)

						Corner(SVBlack, 6)

						Create("UIGradient", {
							Rotation = 90,
							Transparency = NumberSequence.new({
								NumberSequenceKeypoint.new(0, 1),
								NumberSequenceKeypoint.new(1, 0)
							})
						}, SVBlack)

						local SVCursor = Create("Frame", {
							AnchorPoint = Vector2.new(0.5, 0.5),
							Position = UDim2.new(Sat, 0, 1 - Val, 0),
							Size = UDim2.fromOffset(12, 12),
							BackgroundColor3 = Colors.White,
							BorderSizePixel = 0,
							ZIndex = 54
						}, SV)

						Round(SVCursor)
						Create("UIStroke", {
							Color = Color3.new(0, 0, 0),
							Thickness = 1.5,
							Transparency = 0.35
						}, SVCursor)

						local HueBar = Create("Frame", {
							Position = UDim2.fromOffset(Pad + SVSize + Gap, Pad),
							Size = UDim2.fromOffset(HueWidth, SVSize),
							BackgroundColor3 = Colors.White,
							BorderSizePixel = 0,
							ClipsDescendants = true,
							ZIndex = 52
						}, Popup)

						Corner(HueBar, 6)

						Create("UIGradient", {
							Rotation = 90,
							Color = ColorSequence.new({
								ColorSequenceKeypoint.new(0, Color3.fromHSV(0, 1, 1)),
								ColorSequenceKeypoint.new(0.16, Color3.fromHSV(0.16, 1, 1)),
								ColorSequenceKeypoint.new(0.33, Color3.fromHSV(0.33, 1, 1)),
								ColorSequenceKeypoint.new(0.5, Color3.fromHSV(0.5, 1, 1)),
								ColorSequenceKeypoint.new(0.66, Color3.fromHSV(0.66, 1, 1)),
								ColorSequenceKeypoint.new(0.83, Color3.fromHSV(0.83, 1, 1)),
								ColorSequenceKeypoint.new(1, Color3.fromHSV(1, 1, 1))
							})
						}, HueBar)

						local HueCursor = Create("Frame", {
							AnchorPoint = Vector2.new(0.5, 0.5),
							Position = UDim2.new(0.5, 0, Hue, 0),
							Size = UDim2.new(1, 4, 0, 4),
							BackgroundColor3 = Colors.White,
							BorderSizePixel = 0,
							ZIndex = 54
						}, HueBar)

						Corner(HueCursor, 2)
						Create("UIStroke", {
							Color = Color3.new(0, 0, 0),
							Thickness = 1,
							Transparency = 0.35
						}, HueCursor)

						local TransLabel = Label(Popup, "Transparency", 12, Colors.Label)
						TransLabel.Position = UDim2.fromOffset(Pad, Pad + SVSize + 12)
						TransLabel.Size = UDim2.new(1, -Pad * 2, 0, 16)
						TransLabel.ZIndex = 52

						local TransTrack = Create("Frame", {
							Position = UDim2.fromOffset(Pad, Pad + SVSize + 12 + 18),
							Size = UDim2.new(1, -Pad * 2, 0, 12),
							BackgroundColor3 = Colors.ToggleOff,
							BorderSizePixel = 0,
							ClipsDescendants = false,
							ZIndex = 52
						}, Popup)

						Round(TransTrack)

						local TransFill = Create("Frame", {
							Size = UDim2.new(1 - Transparency, 0, 1, 0),
							BackgroundColor3 = Color,
							BorderSizePixel = 0,
							ZIndex = 53
						}, TransTrack)

						Round(TransFill)

						local TransKnob = Create("Frame", {
							AnchorPoint = Vector2.new(0.5, 0.5),
							Position = UDim2.new(1 - Transparency, 0, 0.5, 0),
							Size = UDim2.fromOffset(14, 14),
							BackgroundColor3 = Colors.White,
							BorderSizePixel = 0,
							ZIndex = 54
						}, TransTrack)

						Round(TransKnob)
						Create("UIStroke", {
							Color = Color3.new(0, 0, 0),
							Thickness = 1,
							Transparency = 0.4
						}, TransKnob)

						local function RefreshSV()
							SV.BackgroundColor3 = Color3.fromHSV(Hue, 1, 1)
							TransFill.BackgroundColor3 = Color
						end

						local function UpdateFromSV(Input)
							local x = math.clamp((Input.Position.X - SV.AbsolutePosition.X) / SV.AbsoluteSize.X, 0, 1)
							local y = math.clamp((Input.Position.Y - SV.AbsolutePosition.Y) / SV.AbsoluteSize.Y, 0, 1)
							Sat = x
							Val = 1 - y
							SVCursor.Position = UDim2.new(Sat, 0, 1 - Val, 0)
							SetFromHSV(Hue, Sat, Val, Transparency, true)
							RefreshSV()
						end

						local function UpdateFromHue(Input)
							local y = math.clamp((Input.Position.Y - HueBar.AbsolutePosition.Y) / HueBar.AbsoluteSize.Y, 0, 1)
							Hue = y
							HueCursor.Position = UDim2.new(0.5, 0, Hue, 0)
							SetFromHSV(Hue, Sat, Val, Transparency, true)
							RefreshSV()
						end

						local function UpdateFromTrans(Input)
							local x = math.clamp((Input.Position.X - TransTrack.AbsolutePosition.X) / TransTrack.AbsoluteSize.X, 0, 1)
							Transparency = 1 - x
							TransFill.Size = UDim2.new(1 - Transparency, 0, 1, 0)
							TransKnob.Position = UDim2.new(1 - Transparency, 0, 0.5, 0)
							SetFromHSV(Hue, Sat, Val, Transparency, true)
						end

						local function BindDrag(Target, Handler)
							Target.InputBegan:Connect(function(Input)
								if not IsPointer(Input) then
									return
								end

								Handler(Input)
								Window.Drag = Handler
								Window.DragEnd = function() end
							end)
						end

						BindDrag(SV, UpdateFromSV)
						BindDrag(HueBar, UpdateFromHue)
						BindDrag(TransTrack, UpdateFromTrans)

						local Closed = false
						local OutsideConnection

						local function IsInside(Object, Position)
							local P = Object.AbsolutePosition
							local S = Object.AbsoluteSize
							return Position.X >= P.X and Position.X <= P.X + S.X
								and Position.Y >= P.Y and Position.Y <= P.Y + S.Y
						end

						local function Close()
							if Closed then
								return
							end

							Closed = true

							if OutsideConnection then
								OutsideConnection:Disconnect()
								OutsideConnection = nil
							end

							if Window.OpenDropdown then
								Window.OpenDropdown = nil
							end

							CloseHandle = nil
							Tween(Popup, Anim.Fast, { Size = UDim2.fromOffset(PickerWidth, 0) })

							task.delay(Duration(Anim.Fast) + 0.02, function()
								if Overlay.Parent then
									Overlay:Destroy()
								end
							end)
						end

						OutsideConnection = UserInputService.InputBegan:Connect(function(Input)
							if not IsPointer(Input) then
								return
							end

							local Position = Input.Position
							if not IsInside(Popup, Position) and not IsInside(Frame, Position) then
								Close()
							end
						end)

						Window.OpenDropdown = function()
							Close()
						end

						CloseHandle = Close

						Tween(Popup, Anim.Normal, { Size = UDim2.fromOffset(PickerWidth, PickerHeight) })
					end

					Frame.MouseButton1Click:Connect(function()
						if CloseHandle then
							return
						end

						OpenPicker()
					end)

					return {
						Set = Set,
						SetValue = Set,
						Get = function()
							return Color, Transparency
						end,
						GetValue = function()
							return Color, Transparency
						end,
						GetColor = function()
							return Color
						end,
						GetTransparency = function()
							return Transparency
						end
					}
				end

				table.insert(Subtab.Sections, Section)

				return Section
			end

			table.insert(Tab.Subtabs, Subtab)

			if #Tab.Subtabs == 1 then
				SelectSubtab()
			end

			return Subtab
		end

		table.insert(Window.Tabs, Tab)

		if #Window.Tabs == 1 then
			SelectTab()
		end

		return Tab
	end

	self.Window = Window
	return Window
end

local AccentPresets = {
	Purple = Color3.fromRGB(183, 156, 255),
	Blue   = Color3.fromRGB(110, 168, 255),
	Cyan   = Color3.fromRGB(100, 220, 235),
	Green  = Color3.fromRGB(110, 224, 150),
	Orange = Color3.fromRGB(255, 170, 90),
	Red    = Color3.fromRGB(255, 107, 117),
	Pink   = Color3.fromRGB(255, 140, 200)
}

local AccentOrder = { "Purple", "Blue", "Cyan", "Green", "Orange", "Red", "Pink" }

function UiLibrary:SetConfigTab(Tab, Options)
	Options = Options or {}

	local Library = self
	local Window = Tab.Window

	local ConfigSub = Tab:CreateSubtab("Config")

	if not Library.ConfigSupported then
		ConfigSub:CreateSection("Config", "left"):AddLabel("Not Supported")
	else
		local Configs = ConfigSub:CreateSection("Configs", "left")
		local Themes = ConfigSub:CreateSection("Themes", "right")

		local AutoLabel = Configs:AddLabel("Autoload: none")

		local function RefreshAutoLabel()
			local Name = Library:GetAutoload()
			AutoLabel.Text = "Autoload: " .. (Name ~= "" and Name or "none")
		end

		local NameBox = Configs:AddTextbox({
			Name = "Config name",
			Placeholder = "new config"
		})

		local List = Configs:AddDropdown({
			Name = "Config",
			Options = Library:GetConfigs()
		})

		local function Refresh()
			List.Refresh(Library:GetConfigs())
		end

		local function WithSelected(Action)
			local Name = List.Get()

			if not Name then
				return
			end

			Action(Name)
		end

		Configs:AddButton({
			Name = "Create / Overwrite",
			Callback = function()
				local Name = Clean(NameBox.Get())

				if Name == "" then
					return
				end

				local Ok = Library:SaveConfig(Name)

				if Ok then
					Refresh()
					List.Set(Name, false)
					NameBox.Set("", false)
				end
			end
		})

		Configs:AddButton({
			Name = "Save",
			Callback = function()
				WithSelected(function(Name)
					Library:SaveConfig(Name)
				end)
			end
		}):AddButton({
			Name = "Load",
			Callback = function()
				WithSelected(function(Name)
					Library:LoadConfig(Name)
				end)
			end
		})

		Configs:AddButton({
			Name = "Refresh",
			Callback = function()
				Refresh()
			end
		}):AddButton({
			Name = "Delete",
			Callback = function()
				if type(FS.Delete) ~= "function" then
					return
				end

				WithSelected(function(Name)
					local Ok = Library:DeleteConfig(Name)

					if Ok then
						Refresh()
					end
				end)
			end
		})

		Configs:AddButton({
			Name = "Set Autoload",
			Callback = function()
				WithSelected(function(Name)
					Library:SetAutoload(Name)
					RefreshAutoLabel()
				end)
			end
		}):AddButton({
			Name = "Clear Autoload",
			Callback = function()
				Library:SetAutoload("")
				RefreshAutoLabel()
			end
		})

		RefreshAutoLabel()

		if Options.AutoLoad ~= false then
			task.defer(function()
				Library:LoadAutoload()
			end)
		end

		local ThemeAutoLabel = Themes:AddLabel("Autoload: none")

		local function RefreshThemeAutoLabel()
			local Name = Library:GetThemeAutoload()
			ThemeAutoLabel.Text = "Autoload: " .. (Name ~= "" and Name or "none")
		end

		local ThemeNameBox = Themes:AddTextbox({
			Name = "Theme name",
			Placeholder = "new theme"
		})

		local ThemeList = Themes:AddDropdown({
			Name = "Theme",
			Options = Library:GetThemes()
		})

		local function RefreshThemes()
			ThemeList.Refresh(Library:GetThemes())
		end

		local function WithSelectedTheme(Action)
			local Name = ThemeList.Get()

			if not Name then
				return
			end

			Action(Name)
		end

		Themes:AddButton({
			Name = "Create / Overwrite",
			Callback = function()
				local Name = Clean(ThemeNameBox.Get())

				if Name == "" then
					return
				end

				local Ok = Library:SaveTheme(Name)

				if Ok then
					RefreshThemes()
					ThemeList.Set(Name, false)
					ThemeNameBox.Set("", false)
				end
			end
		})

		Themes:AddButton({
			Name = "Save",
			Callback = function()
				WithSelectedTheme(function(Name)
					Library:SaveTheme(Name)
				end)
			end
		}):AddButton({
			Name = "Load",
			Callback = function()
				WithSelectedTheme(function(Name)
					Library:LoadTheme(Name)
				end)
			end
		})

		Themes:AddButton({
			Name = "Refresh",
			Callback = function()
				RefreshThemes()
			end
		}):AddButton({
			Name = "Delete",
			Callback = function()
				if type(FS.Delete) ~= "function" then
					return
				end

				WithSelectedTheme(function(Name)
					local Ok = Library:DeleteTheme(Name)

					if Ok then
						RefreshThemes()
					end
				end)
			end
		})

		Themes:AddButton({
			Name = "Set Autoload",
			Callback = function()
				WithSelectedTheme(function(Name)
					Library:SetThemeAutoload(Name)
					RefreshThemeAutoLabel()
				end)
			end
		}):AddButton({
			Name = "Clear Autoload",
			Callback = function()
				Library:SetThemeAutoload("")
				RefreshThemeAutoLabel()
			end
		})

		RefreshThemeAutoLabel()

		if Options.AutoLoadTheme ~= false then
			task.defer(function()
				Library:LoadThemeAutoload()
			end)
		end
	end

	local Interface = Tab:CreateSubtab("Interface")
	local General = Interface:CreateSection("Interface", "left")
	local Accent = Interface:CreateSection("Accent", "right")
	local Surfaces = Interface:CreateSection("Surfaces", "left")
	local Controls = Interface:CreateSection("Controls", "right")

	local function RefreshTheme()
		if Window.RefreshTheme then
			Window:RefreshTheme()
		else
			for _, apply in ipairs(Window.Themed) do
				apply()
			end
		end
	end

	local function BindColor(key, flag, callback)
		return function(Color)
			Colors[key] = Color
			if callback then
				callback(Color)
			end
			RefreshTheme()
		end
	end

	General:AddKeybind({
		Name = "Toggle UI",
		NoMode = true,
		Flag = "UI_ToggleKey",
		Default = Window.ToggleKey,
		ChangedCallback = function(Key)
			Window:SetToggleKey(Key)
		end
	})

	General:AddToggle({
		Name = "Animations",
		Flag = "UI_Animations",
		Default = Settings.Animations,
		Callback = function(Value)
			Library:SetAnimations(Value)
		end
	})

	General:AddSlider({
		Name = "Animation Speed",
		Flag = "UI_AnimationSpeed",
		Min = 0.5,
		Max = 2,
		Step = 0.1,
		Rounding = 1,
		Default = Settings.Speed,
		Callback = function(Value)
			Library:SetAnimationSpeed(Value)
		end
	})

	General:AddSlider({
		Name = "Window Transparency",
		Flag = "UI_WindowTransparency",
		Min = 0,
		Max = 0.6,
		Step = 0.05,
		Rounding = 2,
		Default = Alpha.Window,
		Callback = function(Value)
			Window:SetTransparency(Value)
		end
	})

	General:AddButton({
		Name = "Unload UI",
		Callback = function()
			Window:Close()
		end
	})

	local AccentPicker = Accent:AddColorpicker({
		Name = "Accent",
		Flag = "UI_AccentColor",
		Default = Colors.Accent,
		Transparency = 0,
		Callback = function(Color)
			Window:SetAccent(Color)
		end
	})

	Accent:AddDropdown({
		Name = "Preset",
		Options = AccentOrder,
		Callback = function(Name)
			local Color = AccentPresets[Name]

			if Color then
				AccentPicker.Set(Color, false)
				Window:SetAccent(Color)
			end
		end
	})

	Accent:AddColorpicker({
		Name = "Danger",
		Flag = "UI_DangerColor",
		Default = Colors.Danger,
		Transparency = 0,
		Callback = BindColor("Danger", "UI_DangerColor")
	})

	Surfaces:AddColorpicker({
		Name = "Window Background",
		Flag = "UI_WindowColor",
		Default = Colors.Window,
		Transparency = 0,
		Callback = BindColor("Window", "UI_WindowColor")
	})

	Surfaces:AddColorpicker({
		Name = "Content Card",
		Flag = "UI_CardColor",
		Default = Colors.Card,
		Transparency = 0,
		Callback = BindColor("Card", "UI_CardColor")
	})

	Surfaces:AddColorpicker({
		Name = "Subtab Bar",
		Flag = "UI_BarColor",
		Default = Colors.Bar,
		Transparency = 0,
		Callback = BindColor("Bar", "UI_BarColor")
	})

	Surfaces:AddColorpicker({
		Name = "Row / Control BG",
		Flag = "UI_RowColor",
		Default = Colors.Row,
		Transparency = 0,
		Callback = BindColor("Row", "UI_RowColor")
	})

	Surfaces:AddColorpicker({
		Name = "Hover Highlight",
		Flag = "UI_HoverColor",
		Default = Colors.Hover,
		Transparency = 0,
		Callback = BindColor("Hover", "UI_HoverColor")
	})

	Surfaces:AddColorpicker({
		Name = "Pill / Chip",
		Flag = "UI_PillColor",
		Default = Colors.Pill,
		Transparency = 0,
		Callback = BindColor("Pill", "UI_PillColor")
	})

	Surfaces:AddColorpicker({
		Name = "Popup / Dropdown",
		Flag = "UI_PopupColor",
		Default = Colors.Popup,
		Transparency = 0,
		Callback = BindColor("Popup", "UI_PopupColor")
	})

	Controls:AddColorpicker({
		Name = "Primary Text",
		Flag = "UI_TextColor",
		Default = Colors.Text,
		Transparency = 0,
		Callback = BindColor("Text", "UI_TextColor")
	})

	Controls:AddColorpicker({
		Name = "Secondary Text",
		Flag = "UI_LabelColor",
		Default = Colors.Label,
		Transparency = 0,
		Callback = BindColor("Label", "UI_LabelColor")
	})

	Controls:AddColorpicker({
		Name = "Muted Text",
		Flag = "UI_DimColor",
		Default = Colors.Dim,
		Transparency = 0,
		Callback = BindColor("Dim", "UI_DimColor")
	})

	Controls:AddColorpicker({
		Name = "Slider Circle",
		Flag = "UI_KnobColor",
		Default = Colors.Knob,
		Transparency = 0,
		Callback = BindColor("Knob", "UI_KnobColor")
	})

	Controls:AddColorpicker({
		Name = "Slider Background",
		Flag = "UI_SliderTrackColor",
		Default = Colors.SliderTrack,
		Transparency = 0,
		Callback = BindColor("SliderTrack", "UI_SliderTrackColor")
	})

	Controls:AddColorpicker({
		Name = "Toggle Enabled",
		Flag = "UI_ToggleOnColor",
		Default = Colors.ToggleOn,
		Transparency = 0,
		Callback = BindColor("ToggleOn", "UI_ToggleOnColor")
	})

	Controls:AddColorpicker({
		Name = "Toggle Disabled",
		Flag = "UI_ToggleOffColor",
		Default = Colors.ToggleOff,
		Transparency = 0,
		Callback = BindColor("ToggleOff", "UI_ToggleOffColor")
	})

	return Tab
end

return UiLibrary
