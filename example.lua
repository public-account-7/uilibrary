local UiLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/public-account-7/uilibrary/refs/heads/main/ui.lua"))()

UiLibrary:SetFolder("UiLibrary_Example")

local Window = UiLibrary:CreateWindow({
	Name = "UiLibrary",
	Title = "UiLibrary Example",
	Width = 720,
	Height = 460,
	ToggleKey = Enum.KeyCode.RightShift
})

local Main = Window:CreateTab("Main")

local Combat = Main:CreateSubtab("Combat")
local Visuals = Main:CreateSubtab("Visuals")
local Misc = Main:CreateSubtab("Misc")

local Aim = Combat:CreateSection("Aim Assist", "left")

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

local Checks = Combat:CreateSection("Checks", "right")

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

local ESP = Visuals:CreateSection("ESP", "left")

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

local World = Visuals:CreateSection("World", "right")

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

local Player = Misc:CreateSection("Player", "left")

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

local Other = Misc:CreateSection("Other", "right")

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
	end
}):AddButton({
	Name = "Rejoin",
	Callback = function()
		print("Rejoin requested")
	end
})

Other:AddButton({
	Name = "Server Hop",
	Callback = function()
		print("Server hop")
	end
})

Other:AddLabel("Tip: RightShift toggles the UI")
Other:AddLabel("Right-click keybind boxes to switch Hold / Toggle")

local PlayersTab = Window:CreateTab("Players")
local ListSub = PlayersTab:CreateSubtab("List")
local ActionsSub = PlayersTab:CreateSubtab("Actions")

local TargetSec = ListSub:CreateSection("Target", "left")
local InfoSec = ListSub:CreateSection("Info", "right")

TargetSec:AddDropdown({
	Name = "Player",
	Flag = "Target_Player",
	Options = { "None", "Player1", "Player2", "Player3" },
	Default = "None",
	Callback = function(Value)
		print("Target:", Value)
	end
})

TargetSec:AddButton({
	Name = "Refresh Players",
	Callback = function()
		print("Refreshing player list")
	end
}):AddButton({
	Name = "Spectate",
	Callback = function()
		print("Spectate target")
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

local ActLeft = ActionsSub:CreateSection("Actions", "left")
local ActRight = ActionsSub:CreateSection("Teleport", "right")

ActLeft:AddButton({
	Name = "Focus Camera",
	Callback = function()
		print("Focus camera")
	end
}):AddButton({
	Name = "Unfocus",
	Callback = function()
		print("Unfocus")
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
		print("Teleport")
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

local SettingsTab = Window:CreateTab("Settings")
UiLibrary:SetConfigTab(SettingsTab, {
	AutoLoad = true,
	AutoLoadTheme = true
})

print("UiLibrary example loaded")
