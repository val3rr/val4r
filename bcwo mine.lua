--[[local players = game:GetService("Players")

local player = players.LocalPlayer
local character = player.Character or player.CharacterAdded
local humanoidrootpart = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

local controls = require(player.PlayerScripts.PlayerModule):GetControls()

local filters = {
	blacklist = getgenv.blacklist;
	whitelist = getgenv.whitelist
}

if #filters.blacklist ~= 0 and #filters.whitelist ~= 0 then return error("you cant blacklist & whtielist at the same time!") end

local GC = getconnections or get_signal_cons
if GC then
	for i,v in pairs(GC(player.Idled)) do
		if v["Disable"] then
			v["Disable"](v)
		elseif v["Disconnect"] then
			v["Disconnect"](v)
		end
	end
end

local function checkpickaxe(a)
	for _,v in pairs(a:GetChildren()) do
		if v:IsA("Tool") and v.Name:match("Pickaxe") then
			return v
		end
	end
end

local function filter(a)
	local b = nil
	for _,v in pairs(workspace.Map.Ores:GetChildren()) do
		local n = v.Name:lower()
		if n == a.Name:lower() then
			if table.find(filters.whitelist,n) then
				b=n
				--print(n.."a",filters.whitelist,#filters.whitelist)
			elseif #filters.blacklist ~= 0 and not table.find(filters.blacklist,n) then
				b=n
				--print(n.."b",filters.blacklist,#filters.blacklist)
			else
				b=n
				--print(n.."c")
			end
		end
	end
	return b
end

local function getpickaxe()
	local p = checkpickaxe(player.Backpack)
	local pi = checkpickaxe(character)
	if p then
		p.Parent = character
		return p
	elseif pi then
		return pi
	end
end

local function mine(a,b)
	local cf = humanoidrootpart.CFrame
	humanoidrootpart.Anchored = true
	humanoidrootpart.CFrame = a.CFrame*CFrame.new(-2,0,0)
	repeat task.wait()
		b:FindFirstChild("RemoteFunction"):InvokeServer("mine")
	until a.Mineral.Broken.Played
	humanoidrootpart.Anchored = false
	humanoidrootpart.CFrame = cf
end

while true do task.wait()
	for _,v in pairs(workspace.Map.Ores:GetChildren()) do
		if filter(v) and getpickaxe() then
			mine(v,getpickaxe())
		end
	end
end]]
