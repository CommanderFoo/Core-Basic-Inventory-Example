-- Networked inventory template
local BACKPACK = script:GetCustomProperty("Backpack")
local players = {}

-- Drop an item when the "Drop Item" action is performed.
-- This can be added to your binding set.
local function DropItem(player, action)

	-- Check the player is in the players table and the input action is Drop Item.
	if players[player.id] ~= nil and action == "Drop Item" then

		-- Loop based on the total slots the inventory has.
		for i = 1, players[player.id].slotCount do

			-- Get the item based on the slot index.
			local item = players[player.id]:GetItem(i)

			-- Check the item is valid and has a count > 0.
			if item and item.count > 0 then
				local templateId = item.itemTemplateId
				local forward = player:GetViewWorldRotation() * Vector3.FORWARD
				local ray_start = player:GetViewWorldPosition() + forward
				local ray_end = ray_start + forward * 2000
				local hit = World.Raycast(ray_start, ray_end)

				if hit ~= nil then

					-- Remove 1 from slot based on the index.
					if players[player.id]:RemoveFromSlot(i, { count = 1 }) then
						item = World.SpawnAsset(templateId, { networkContext = NetworkContextType.NETWORKED, position = hit:GetImpactPosition() })
					end
				end

				break
			end
		end
	end
end

-- When a player joins the server spawn an inventory object and assign it to the player.
local function OnPlayerJoined(player)
	local backpack = World.SpawnAsset(BACKPACK, { networkContext = NetworkContextType.NETWORKED })

	backpack:Assign(player)
	backpack.name = player.name
	players[player.id] = backpack
end

local function OnPlayerLeft(player)
	players[player.id]:Destroy()
end

Game.playerJoinedEvent:Connect(OnPlayerJoined)
Game.playerLeftEvent:Connect(OnPlayerLeft)

Input.actionPressedEvent:Connect(DropItem)