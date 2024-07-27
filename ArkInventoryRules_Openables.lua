if not ArkInventory then return end
if not ArkInventoryRules then return end

local isDebug = false

local rule = ArkInventoryRules:NewModule( "ArkInventoryRules_Openables" )
local ITEM_OPENABLE = _G.ITEM_OPENABLE

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

local function debugPrint(text)
	SELECTED_DOCK_FRAME:AddMessage(string.format("|cff0080ff"..addon..": |r%s", text))
end

local function isCustomOpenable(bag, slot)
	local itemInfo = {C_Container.GetContainerItemInfo(bag, slot)}
	return itemInfo and itemInfo.itemID and tableContains(openableItems, itemInfo.itemID)
end

local function ruleOpenable()

	local fn = "openable"
	local obj = ArkInventoryRules.Object
	if not (obj and obj.loc_id and obj.bag_id and obj.slot_id and obj.class == "item") then
    return false
end

	local bag = ArkInventory.API.getBlizzardBagIdFromWindowId( obj.loc_id, obj.bag_id )
	return ArkInventory.TooltipContains(ArkInventoryRules.Tooltip, nil, ITEM_OPENABLE) or isCustomOpenable(bag, obj.slot_id) or false
end

function rule:OnEnable( )
  ArkInventoryRules.Register(self, "openable", ruleOpenable)
end