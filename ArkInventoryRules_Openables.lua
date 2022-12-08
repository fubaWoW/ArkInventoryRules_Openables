local rule = ArkInventoryRules:NewModule( "ArkInventoryRules_Openables" )
local ITEM_OPENABLE = _G.ITEM_OPENABLE
local debug = false

local GetContainerItemLink = GetContainerItemLink or (C_Container and C_Container.GetContainerItemLink)
local GetContainerItemInfo = GetContainerItemInfo or (C_Container and C_Container.GetContainerItemInfo)

function rule:OnEnable( )

  -- register your rule function(s)
  local registered
  --  registered = ArkInventoryRules.Register( self, "rulefunctionname", rule.function_to_call )

  registered = ArkInventoryRules.Register( self, "OPENABLE", rule.Openable )

  -- note: if you require another mod to be loaded you will need to add it in the .toc file
  -- in which case make sure you check that that mod actually got loaded (it might not be installed)

end

function rule.Openable( ... )

  local fn = "OPENABLE" -- your rule function name, needs to be set so that error messages are readable

  -- always check for the hyperlink and that it's an actual item, not a spell (pet/mount)
	if not ArkInventoryRules.Object.h or ArkInventoryRules.Object.bag_id == nil or ArkInventoryRules.Object.slot_id == nil or ArkInventoryRules.Object.class ~= "item" then
		return false
	end
	
	local blizzard_id = ArkInventory.InternalIdToBlizzardBagId( ArkInventoryRules.Object.loc_id, ArkInventoryRules.Object.bag_id )
	
	local isOpenable =  ArkInventory.TooltipContains( ArkInventoryRules.Tooltip, nil, ITEM_OPENABLE )

	if debug then
		if isOpenable then
			local link = GetContainerItemLink(blizzard_id, ArkInventoryRules.Object.slot_id)
			if link then
				local icon, itemCount, locked, quality, readable, lootable, itemLink, isFiltered, noValue, itemID = GetContainerItemInfo(blizzard_id, ArkInventoryRules.Object.slot_id);
				local name = GetItemInfo(link)
				print("|cff0080ffARK: |r"..link.." |cffffff00isOpenable: |r".."|cff00ff00"..tostring(isOpenable).."|r")
			end
		end
	end
	
	if isOpenable then
		return true
	end
	
  -- always return false at the end
  return false
end