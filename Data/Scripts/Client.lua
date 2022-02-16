local SLOTS = script:GetCustomProperty("Slots"):WaitForObject()

local localPlayer = Game.GetLocalPlayer()
local inv = nil

-- When the inventory has changed for the player, update the slots to show
-- the item count.
local function InventoryChanged(inv, slot)
	local item = inv:GetItem(slot)
	local childIcon = SLOTS:GetChildren()[slot]:FindChildByName("Icon")
	local childCount = SLOTS:GetChildren()[slot]:FindChildByName("Count")

	if item ~= nil then
		local icon = item:GetCustomProperty("icon")

		childIcon:SetImage(icon)
		childIcon.visibility = Visibility.FORCE_ON
		childCount.text = tostring(item.count)
	else
		childIcon.visibility = Visibility.FORCE_OFF
		childCount.text = ""
	end
end

-- Make sure the inventory is intialized.
while inv == nil do
	inv = localPlayer:GetInventories()[1]
	Task.Wait()
end

for i, item in pairs(inv:GetItems()) do
	InventoryChanged(inv, item)
end

inv.changedEvent:Connect(InventoryChanged)