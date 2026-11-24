local UiLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/public-account-7/uilibrary/refs/heads/main/ui.lua"))()

print("Icons ready:", UiLibrary.IconsReady)

UiLibrary:SetFolder("UiLibrary_Example")

local Window = UiLibrary:CreateWindow({
	Name = "UiLibrary",
	Title = "UiLibrary Example",
	Width = 720,
	Height = 460,
	ToggleKey = Enum.KeyCode.RightShift,
	MobileButton = true
})

local Main = Window:CreateTab("Main", "house")

local Combat = Main:CreateSubtab("Combat", "sword")
local Visuals = Main:CreateSubtab("Visuals", "eye")
local Misc = Main:CreateSubtab("Misc", "wrench")

local Aim = Combat:CreateSection("Aim Assist", "left", "crosshair")

Aim:AddToggle({
	Name = "Enabled",
	Flag = "Aim_Enabled",
	Default = false,
	Callback = function(Value)
		print("Aim Enabled:", Value)
	end
}):AddKeybind({
	Flag = "Aim_Key",
	Default = Enum.KeyCode.E,
	Mode = "Hold",
	SyncState = true
})

Aim:AddSlider({
	Name = "FOV",
	Flag = "Aim_FOV",
	Min = 10,
	Max = 400,
	Step = 1,
	Rounding = 0,
	Default = 120,
	Callback = function(Value)
		print("FOV:", Value)
	end
})

Aim:AddSlider({
	Name = "Smoothness",
	Flag = "Aim_Smooth",
	Min = 0,
	Max = 1,
	Step = 0.05,
	Rounding = 2,
	Default = 0.35,
	Callback = function(Value)
		print("Smoothness:", Value)
	end
})

local TargetPart = Aim:AddDropdown({
	Name = "Target Part",
	Flag = "Aim_Part",
	Values = function()
		return { "Head", "HumanoidRootPart", "UpperTorso", "LowerTorso" }
	end,
	Default = "Head",
	Callback = function(Value)
		print("Target Part:", Value)
	end
})

Aim:AddDropdown({
	Name = "Priority",
	Flag = "Aim_Priority",
	Options = { "Closest", "Lowest HP", "Highest HP", "Threat" },
	Default = "Closest",
	Callback = function(Value)
		print("Priority:", Value)
	end
})

Aim:AddDropdown({
	Name = "Hit Parts",
	Flag = "Aim_HitParts",
	Multi = true,
	Values = { "Head", "Torso", "Arms", "Legs" },
	Default = { "Head", "Torso" },
	Callback = function(Values)
		print("Hit Parts:", table.concat(Values, ", "))
	end
})

local Checks = Combat:CreateSection("Checks", "right", "shield-check")

Checks:AddToggle({
	Name = "Team Check",
	Flag = "Aim_TeamCheck",
	Default = true,
	Callback = function(Value)
		print("Team Check:", Value)
	end
})

Checks:AddToggle({
	Name = "Wall Check",
	Flag = "Aim_WallCheck",
	Default = true,
	Callback = function(Value)
		print("Wall Check:", Value)
	end
})

Checks:AddToggle({
	Name = "Visible Only",
	Flag = "Aim_Visible",
	Default = false,
	Callback = function(Value)
		print("Visible Only:", Value)
	end
}):AddKeybind({
	Flag = "Aim_VisibleKey",
	Default = "None",
	Mode = "Toggle"
})

Checks:AddSlider({
	Name = "Max Distance",
	Flag = "Aim_Distance",
	Min = 50,
	Max = 2000,
	Step = 10,
	Rounding = 0,
	Default = 500
})

Checks:AddColorpicker({
	Name = "FOV Color",
	Flag = "Aim_FOVColor",
	Default = Color3.fromRGB(183, 156, 255),
	Transparency = 0.3,
	Callback = function(Color, Transparency)
		print("FOV Color:", Color, Transparency)
	end
})

local ESP = Visuals:CreateSection("ESP", "left", "scan-eye")

ESP:AddToggle({
	Name = "Box ESP",
	Flag = "ESP_Box",
	Default = true,
	Callback = function(Value)
		print("Box ESP:", Value)
	end
}):AddKeybind({
	Flag = "ESP_BoxKey",
	Default = Enum.KeyCode.B,
	Mode = "Toggle",
	SyncState = true
})

ESP:AddToggle({
	Name = "Name ESP",
	Flag = "ESP_Name",
	Default = true
})

ESP:AddToggle({
	Name = "Health Bar",
	Flag = "ESP_Health",
	Default = true
})

ESP:AddToggle({
	Name = "Tracers",
	Flag = "ESP_Tracers",
	Default = false
})

ESP:AddSlider({
	Name = "Render Distance",
	Flag = "ESP_Distance",
	Min = 100,
	Max = 5000,
	Step = 50,
	Rounding = 0,
	Default = 1500
})

ESP:AddColorpicker({
	Name = "Enemy Color",
	Flag = "ESP_EnemyColor",
	Default = Color3.fromRGB(255, 107, 117)
})

ESP:AddColorpicker({
	Name = "Team Color",
	Flag = "ESP_TeamColor",
	Default = Color3.fromRGB(110, 224, 150)
})

local World = Visuals:CreateSection("World", "right", "globe")

World:AddToggle({
	Name = "Fullbright",
	Flag = "World_Fullbright",
	Default = false
})

World:AddToggle({
	Name = "No Fog",
	Flag = "World_NoFog",
	Default = false
})

World:AddSlider({
	Name = "Brightness",
	Flag = "World_Brightness",
	Min = 0,
	Max = 5,
	Step = 0.1,
	Rounding = 1,
	Default = 1
})

World:AddDropdown({
	Name = "Time of Day",
	Flag = "World_Time",
	Options = { "Morning", "Noon", "Evening", "Night", "Custom" },
	Default = "Noon"
})

World:AddColorpicker({
	Name = "Ambient",
	Flag = "World_Ambient",
	Default = Color3.fromRGB(140, 140, 160)
})

local Player = Misc:CreateSection("Player", "left", "user")

Player:AddToggle({
	Name = "Speed",
	Flag = "Player_Speed",
	Default = false
}):AddKeybind({
	Flag = "Player_SpeedKey",
	Default = Enum.KeyCode.V,
	Mode = "Toggle",
	SyncState = true
})

Player:AddSlider({
	Name = "Speed Amount",
	Flag = "Player_SpeedAmount",
	Min = 16,
	Max = 200,
	Step = 1,
	Rounding = 0,
	Default = 32
})

Player:AddToggle({
	Name = "Fly",
	Flag = "Player_Fly",
	Default = false
}):AddKeybind({
	Flag = "Player_FlyKey",
	Default = Enum.KeyCode.F,
	Mode = "Hold",
	SyncState = true
})

Player:AddSlider({
	Name = "Fly Speed",
	Flag = "Player_FlySpeed",
	Min = 10,
	Max = 150,
	Step = 5,
	Rounding = 0,
	Default = 50
})

Player:AddKeybind({
	Name = "Panic Key",
	Flag = "Player_Panic",
	Default = Enum.KeyCode.Backspace,
	NoMode = true,
	ChangedCallback = function(Key)
		print("Panic Key:", Key and Key.Name or "None")
	end
})

local Other = Misc:CreateSection("Other", "right", "settings-2")

Other:AddTextbox({
	Name = "Webhook",
	Flag = "Misc_Webhook",
	Placeholder = "https://...",
	Default = "",
	Callback = function(Text)
		print("Webhook:", Text)
	end
})

Other:AddTextbox({
	Name = "Prefix",
	Flag = "Misc_Prefix",
	Placeholder = "!",
	Default = "!"
})

Other:AddButton({
	Name = "Copy JobId",
	Callback = function()
		print("JobId:", game.JobId)
		UiLibrary:Notify("JobId", game.JobId, 3)
	end
}):AddButton({
	Name = "Rejoin",
	Callback = function()
		UiLibrary:Notify("Rejoin", "Rejoin requested", 3)
	end
})

Other:AddButton({
	Name = "Server Hop",
	Callback = function()
		UiLibrary:Notify("Server Hop", "Searching for a server...", 3)
	end
})

Other:AddLabel("Tip: RightShift toggles the UI")
Other:AddLabel("Right-click keybind boxes to switch Hold / Toggle")

local PlayersTab = Window:CreateTab("Players", "users")
local ListSub = PlayersTab:CreateSubtab("List", "list")
local ActionsSub = PlayersTab:CreateSubtab("Actions", "zap")

local TargetSec = ListSub:CreateSection("Target", "left", "target")
local InfoSec = ListSub:CreateSection("Info", "right", "info")

local function PlayerNames()
	local names = { "None" }

	for _, plr in ipairs(game:GetService("Players"):GetPlayers()) do
		table.insert(names, plr.Name)
	end

	return names
end

local PlayerDropdown = TargetSec:AddDropdown({
	Name = "Player",
	Flag = "Target_Player",
	Values = PlayerNames,
	Default = "None",
	Callback = function(Value)
		print("Target:", Value)
	end
})

TargetSec:AddButton({
	Name = "Refresh Players",
	Callback = function()
		PlayerDropdown.Refresh()
		UiLibrary:Notify("Players", "List refreshed", 2)
	end
}):AddButton({
	Name = "Spectate",
	Callback = function()
		UiLibrary:Notify("Spectate", "Spectating " .. tostring(PlayerDropdown.Get()), 3)
	end
})

TargetSec:AddToggle({
	Name = "Lock Target",
	Flag = "Target_Lock",
	Default = false
})

InfoSec:AddLabel("Select a player to view info")
InfoSec:AddLabel("Health: --")
InfoSec:AddLabel("Distance: --")
InfoSec:AddColorpicker({
	Name = "Highlight",
	Flag = "Target_Highlight",
	Default = Color3.fromRGB(255, 170, 90)
})

local ActLeft = ActionsSub:CreateSection("Actions", "left", "mouse-pointer-click")
local ActRight = ActionsSub:CreateSection("Teleport", "right", "map-pin")

ActLeft:AddButton({
	Name = "Focus Camera",
	Callback = function()
		UiLibrary:Notify("Camera", "Focus camera", 2)
	end
}):AddButton({
	Name = "Unfocus",
	Callback = function()
		UiLibrary:Notify("Camera", "Unfocus", 2)
	end
})

ActLeft:AddToggle({
	Name = "Auto Track",
	Flag = "Target_AutoTrack",
	Default = false
}):AddKeybind({
	Flag = "Target_AutoTrackKey",
	Default = Enum.KeyCode.T,
	Mode = "Toggle",
	SyncState = true
})

ActRight:AddButton({
	Name = "Teleport to Target",
	Callback = function()
		UiLibrary:Notify("Teleport", "Teleporting...", 2)
	end
})

ActRight:AddSlider({
	Name = "Offset",
	Flag = "Target_Offset",
	Min = 0,
	Max = 20,
	Step = 0.5,
	Rounding = 1,
	Default = 3
})

local TestsTab = Window:CreateTab("Tests", "flask-conical")

local NotifySub = TestsTab:CreateSubtab("Notify", "bell")
local ApiSub = TestsTab:CreateSubtab("API", "code")
local IconSub = TestsTab:CreateSubtab("Icons", "image")
local PlainSub = TestsTab:CreateSubtab("No Icon")
local LongSub = TestsTab:CreateSubtab("Long Subtab Name", "scroll-text")

local NotifyLeft = NotifySub:CreateSection("Notifications", "left", "bell-ring")
local NotifyRight = NotifySub:CreateSection("Position", "right", "move")

NotifyLeft:AddButton({
	Name = "Short (2s)",
	Callback = function()
		UiLibrary:Notify("Short", "Disappears in 2 seconds", 2)
	end
}):AddButton({
	Name = "Default",
	Callback = function()
		UiLibrary:Notify("Default", "Uses the default timer")
	end
})

NotifyLeft:AddButton({
	Name = "Title only",
	Callback = function()
		UiLibrary:Notify("Only a title", nil, 3)
	end
}):AddButton({
	Name = "Text only",
	Callback = function()
		UiLibrary:Notify(nil, "Only body text, no title", 3)
	end
})

NotifyLeft:AddButton({
	Name = "Long text",
	Callback = function()
		UiLibrary:Notify(
			"Long message",
			"This notification has a lot of text so it has to wrap over several lines and the card must grow to fit all of it without cutting anything off.",
			5
		)
	end
})

NotifyLeft:AddButton({
	Name = "Persistent (click to close)",
	Callback = function()
		UiLibrary:Notify("Persistent", "Click this card to dismiss it", math.huge)
	end
})

NotifyLeft:AddButton({
	Name = "Spam x8 (stack limit)",
	Callback = function()
		for i = 1, 8 do
			UiLibrary:Notify("Spam " .. i, "Stack test", 4)
			task.wait(0.15)
		end
	end
})

NotifyLeft:AddButton({
	Name = "Save 'example' config",
	Callback = function()
		local Ok, Message = UiLibrary:SaveConfig("example")
		UiLibrary:Notify(Ok and "Config" or "Config error", Message, 3)
	end
}):AddButton({
	Name = "Load 'example' config",
	Callback = function()
		local Ok, Message = UiLibrary:LoadConfig("example")
		UiLibrary:Notify(Ok and "Config" or "Config error", Message, 3)
	end
})

local function PickPosition(Name)
	local Setter = UiLibrary.Setters["UI_NotifyPosition"]

	if Setter then
		Setter(Name, true)
	else
		UiLibrary:SetNotifyPosition(Name)
		UiLibrary:Notify("Notifications", "Position set to " .. Name, 2)
	end
end

NotifyRight:AddLabel("Each button changes the position and syncs the Interface dropdown")

for _, Name in ipairs(UiLibrary.NotifyPositions) do
	NotifyRight:AddButton({
		Name = Name,
		Callback = function()
			PickPosition(Name)
		end
	})
end

NotifyRight:AddButton({
	Name = "Cycle",
	Callback = function()
		local Index = table.find(UiLibrary.NotifyPositions, UiLibrary.NotifyPosition) or 0
		PickPosition(UiLibrary.NotifyPositions[(Index % #UiLibrary.NotifyPositions) + 1])
	end
})

local ApiLeft = ApiSub:CreateSection("Controls", "left", "sliders-horizontal")
local ApiRight = ApiSub:CreateSection("Window & Theme", "right", "palette")

local TestToggle = ApiLeft:AddToggle({
	Name = "Test Toggle",
	Flag = "Test_Toggle",
	Default = false,
	Callback = function(Value)
		print("Test Toggle:", Value)
	end
})

ApiLeft:AddButton({
	Name = "Toggle On",
	Callback = function()
		TestToggle.Set(true)
	end
}):AddButton({
	Name = "Toggle Off",
	Callback = function()
		TestToggle.Set(false)
	end
})

local TestSlider = ApiLeft:AddSlider({
	Name = "Test Slider",
	Flag = "Test_Slider",
	Min = 0,
	Max = 100,
	Step = 5,
	Default = 25
})

ApiLeft:AddButton({
	Name = "Slider = 75",
	Callback = function()
		TestSlider.Set(75)
	end
}):AddButton({
	Name = "Slider = 0",
	Callback = function()
		TestSlider.Set(0)
	end
})

local TestDropdown = ApiLeft:AddDropdown({
	Name = "Test Dropdown",
	Flag = "Test_Dropdown",
	Options = { "One", "Two", "Three" },
	Default = "One"
})

ApiLeft:AddButton({
	Name = "New options",
	Callback = function()
		TestDropdown.Refresh({ "Alpha", "Beta", "Gamma", "Delta", "Epsilon", "Zeta", "Eta", "Theta" })
	end
}):AddButton({
	Name = "Select Beta",
	Callback = function()
		TestDropdown.Set("Beta")
	end
})

local TestPicker = ApiLeft:AddColorpicker({
	Name = "Test Color",
	Flag = "Test_Color",
	Default = Color3.fromRGB(255, 255, 255)
})

ApiLeft:AddButton({
	Name = "Random color",
	Callback = function()
		TestPicker.Set(Color3.fromHSV(math.random(), 0.7, 1))
	end
})

ApiLeft:AddTextbox({
	Name = "Test Textbox",
	Flag = "Test_Textbox",
	Placeholder = "type here",
	Callback = function(Text)
		UiLibrary:Notify("Textbox", "Value: " .. Text, 2)
	end
})

ApiLeft:AddKeybind({
	Name = "Test Keybind",
	Flag = "Test_Keybind",
	Default = Enum.KeyCode.G,
	Mode = "Toggle",
	Callback = function(State)
		UiLibrary:Notify("Keybind", "State: " .. tostring(State), 2)
	end
})

ApiRight:AddButton({
	Name = "Accent Red",
	Callback = function()
		Window:SetAccent(Color3.fromRGB(255, 107, 117))
	end
}):AddButton({
	Name = "Accent Purple",
	Callback = function()
		Window:SetAccent(Color3.fromRGB(183, 156, 255))
	end
})

ApiRight:AddButton({
	Name = "Animations Off",
	Callback = function()
		UiLibrary:SetAnimations(false)
	end
}):AddButton({
	Name = "Animations On",
	Callback = function()
		UiLibrary:SetAnimations(true)
	end
})

ApiRight:AddButton({
	Name = "Speed 2x",
	Callback = function()
		UiLibrary:SetAnimationSpeed(2)
	end
}):AddButton({
	Name = "Speed 1x",
	Callback = function()
		UiLibrary:SetAnimationSpeed(1)
	end
})

ApiRight:AddButton({
	Name = "Transparency 0.3",
	Callback = function()
		Window:SetTransparency(0.3)
	end
}):AddButton({
	Name = "Transparency 0",
	Callback = function()
		Window:SetTransparency(0)
	end
})

ApiRight:AddButton({
	Name = "Hide UI for 2s",
	Callback = function()
		Window:SetVisible(false)

		task.delay(2, function()
			Window:SetVisible(true)
		end)
	end
})

ApiRight:AddButton({
	Name = "Count flags",
	Callback = function()
		local Count = 0

		for _ in pairs(UiLibrary.Flags) do
			Count += 1
		end

		UiLibrary:Notify("Flags", Count .. " flags registered", 3)
	end
})

local IconNames = IconSub:CreateSection("Name formats", "left", "type")
local IconAssets = IconSub:CreateSection("Asset formats", "right", "box")

IconNames:AddLabel("Plain lucide name")
IconNames:AddLabel("Section below uses \"lucide:heart\"")

IconSub:CreateSection("lucide: prefix", "left", "lucide:heart")
IconSub:CreateSection("Spaced / capitalised", "left", "Arrow Up")
IconSub:CreateSection("Missing icon (text only)", "left", "not-a-real-icon")

IconAssets:AddLabel("Replace the ids below with your own to test them")

IconSub:CreateSection("rbxassetid string", "right", "rbxassetid://6031094678")
IconSub:CreateSection("Numeric id", "right", 6031094678)

local PlainSec = PlainSub:CreateSection("Text only")

PlainSec:AddLabel("This subtab has no icon and still sizes correctly")
PlainSec:AddToggle({
	Name = "Plain toggle",
	Flag = "Plain_Toggle"
})
local LongSec = LongSub:CreateSection("Wide subtab", "left", "ruler")

LongSec:AddLabel("The subtab bar scrolls when the tabs do not fit: drag it or use the mouse wheel")

for i = 1, 14 do
	LongSec:AddToggle({
		Name = "Scroll test " .. i,
		Flag = "Scroll_" .. i
	})
end

local SettingsTab = Window:CreateTab("Settings", "settings")

UiLibrary:SetConfigTab(SettingsTab, {
	AutoLoad = true,
	AutoLoadTheme = true,
	ConfigIcon = "save",
	InterfaceIcon = "layout-grid"
})
Window:SetWatermarkVisibility(true)
local FrameTimer = tick()
local FrameCounter = 0;
local FPS = 60;
local GetPing = (function() return math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()) end)
local CanDoPing = pcall(function() return GetPing(); end)

local WatermarkConnection = game:GetService("RunService").RenderStepped:Connect(function()
	FrameCounter += 1;

	if (tick() - FrameTimer) >= 1 then
		FPS = FrameCounter;
		FrameTimer = tick();
		FrameCounter = 0;
	end;

	if CanDoPing then
		Window:SetWatermark(("tung tung lib demo | %d fps | %d ms"):format(
			math.floor(FPS),
			GetPing()
		));
	else
		Window:SetWatermark(("tung tung lib demo | %d fps"):format(
			math.floor(FPS)
		));
	end
end);
Window:OnUnload(function()
    print("Window closing")
end)
UiLibrary:Notify("UiLibrary", "Example loaded", 3)
