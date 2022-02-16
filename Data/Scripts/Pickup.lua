local ROOT = script.parent
local TRIGGER = ROOT:GetCustomProperty("Trigger"):WaitForObject()
local ITEM_ASSET = ROOT:GetCustomProperty("ItemAsset")
local EFFECTS = script:GetCustomProperty("Effects")

TRIGGER.beginOverlapEvent:Connect(function(trigger, other)
	if not other:IsA("Player") then
		return
	end

	if #other:GetInventories() > 0 and other:GetInventories()[1]:CanAddItem(ITEM_ASSET, { count = 1 }) then
		if other:GetInventories()[1]:AddItem(ITEM_ASSET, { count = 1 }) then
			World.SpawnAsset(EFFECTS, { position = TRIGGER:GetWorldPosition() })
			script.parent:Destroy()
		end
	end
end)