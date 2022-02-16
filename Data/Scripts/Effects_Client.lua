local ROOT = script.parent.parent
local TRIGGER = ROOT:GetCustomProperty("Trigger"):WaitForObject()
local ITEM_ASSET = ROOT:GetCustomProperty("ItemAsset")

TRIGGER.beginOverlapEvent:Connect(function(trigger, other)
	if not other:IsA("Player") then
		return
	end

	if #other:GetInventories() > 0 then
		print(other:GetInventories()[1]:CanAddItem(ITEM_ASSET))
		print("Add")
	end
end)