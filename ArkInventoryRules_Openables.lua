if not ArkInventory then return end
if not ArkInventoryRules then return end

local rule = ArkInventoryRules:NewModule( "ArkInventoryRules_Openables" )
local ITEM_OPENABLE = _G.ITEM_OPENABLE
local debug = false

local openableItems = {
	178040,	-- Condensed Stygia
	198395,	-- Dull Spined Clam
	204339, -- Satchel of Coalescing Chaos
	205423,	-- Shadowflame Residue Sack
	205682	-- Large Shadowflame Residue Sack
}

-- check if "value {v}" already exists in "table {t}"
local function tableContains(t, v)
    for _, item in ipairs(t) do
        if item == v then
            return true
        end
    end
    return false
end

-- ItemLink = GetContainerItemLink(bagID, slotID)
local GetContainerItemLink = GetContainerItemLink or (C_Container and C_Container.GetContainerItemLink)

-- icon, itemCount, locked, quality, readable, lootable, itemLink, isFiltered, noValue, itemID, isBound = GetContainerItemInfo(bagID, slot)
local GetContainerItemInfo = GetContainerItemInfo or (C_Container and C_Container.GetContainerItemInfo)



local function debugInfo(blizzard_id, slot_id)
    if not (blizzard_id and slot_id) then return end

    local link = GetContainerItemLink(blizzard_id, slot_id)
    if not link then return end

    local itemInfo = {GetContainerItemInfo(blizzard_id, slot_id)}
    --local name = GetItemInfo(link)

    SELECTED_DOCK_FRAME:AddMessage(
        string.format("|cff0080ffARK: |r%s |cffffff00isOpenable: |r|cff00ff00%s|r", link, tostring(isOpenable))
    )
end

function rule:OnEnable( )

  -- register your rule function(s)
  local registered
  --  registered = ArkInventoryRules.Register( self, "rulefunctionname", rule.function_to_call )

  registered = ArkInventoryRules.Register( self, "OPENABLE", rule.Openable )

  -- note: if you require another mod to be loaded you will need to add it in the .toc file
  -- in which case make sure you check that that mod actually got loaded (it might not be installed)

end

function rule.Openable( ... )

    local fn = "OPENABLE"
    local obj = ArkInventoryRules.Object

    if not (obj.h and obj.loc_id and obj.bag_id and obj.slot_id and obj.class == "item") then
        return false
    end

    local blizzard_id = ArkInventory.Util.getBlizzardBagIdFromStorageId(obj.loc_id, obj.bag_id)
    local isOpenable = ArkInventory.TooltipContains(ArkInventoryRules.Tooltip, nil, ITEM_OPENABLE)

    if isOpenable then
        if debug then debugInfo(blizzard_id, obj.slot_id) end
        return true
    end

    local itemInfo = ArkInventory.CrossClient.GetContainerItemInfo(blizzard_id, obj.slot_id)
		
		-- itemInfo.iconFileID
		-- itemInfo.stackCount
		-- itemInfo.isLocked
		-- itemInfo.quality
		-- itemInfo.isReadable
		-- itemInfo.hasLoot
		-- itemInfo.hyperlink
		-- itemInfo.isFiltered
		-- itemInfo.hasNoValue
		-- itemInfo.itemID
		-- itemInfo.isBound

    if itemInfo and itemInfo.itemID and tableContains(openableItems, itemInfo.itemID) then
        if debug then debugInfo(blizzard_id, obj.slot_id) end
        return true
    end

    return false
end