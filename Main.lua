local waitingForItem = false
local currentUser = GetCharacterFullName()

local function recievedItemInfo(item)
    local itemClass = select(6, C_Item.GetItemInfo(item))
    local itemSubclass = select(7, C_Item.GetItemInfo(item))

    local class = string.gsub(select(1, UnitClass('player')), ' ', '')

    if HasValue(Wearables, itemSubclass) and ClassWearables[class] ~= itemSubclass then
        return
    elseif HasValue(SupportedEquipables, itemSubclass) and HasValue(ClassEquipables[class], itemSubclass) then
        return
    end

    local color = select(3, C_Item.GetItemInfo(item))
    local r, g, b = C_Item.GetItemQualityColor(color)

    UIItemName:SetText(select(1, C_Item.GetItemInfo(item)))
    UIItemName:SetTextColor(r, g, b, 1)
    UIItemIcon:SetTexture(C_Item.GetItemIconByID(item))

    UIItemInfo:SetText(itemClass .. ' - ' .. itemSubclass)

    UIConfig:Show()
end

local function rollingStarted(msg, character)
    local item = string.sub(msg, 13)
    local index = string.find(item, ' started.')
    item = string.sub(item, 1, index - 1)
    RollInfo.item = item
    RollInfo.user = character
    RollInfo.isRolling = true

    if not C_Item.IsItemDataCachedByID(item) then
        waitingForItem = true
        C_Item.RequestLoadItemDataByID(item)
    else
        recievedItemInfo(item)
    end
end

function RollingEnded()
    if (UIConfig.IsShown(UIConfig)) then
        UIConfig:Hide()
    end
    RollInfo = {
        isRolling = false,
        user = nil,
        item = nil,
        bets = {},
        bet = 0
    }
    UICurrentBet:SetText('No bets yet')
end

local function betPlaced(msg, character)
    RollInfo.bets[character] = tonumber(msg)
end

local function betConfirmed(msg)
    local index = string.find(msg, '-', string.find(msg, '-') + 1)
    local char = string.sub(msg, 1, index - 2)

    local bet = RollInfo.bets[char]

    if bet > RollInfo.bet then
        RollInfo.bet = bet
        UICurrentBet:SetText(bet .. ' by ' .. string.sub(char, 1, string.find(char, '-') - 1))
    end
end

local function OnEvent(self, event, msg, character, ...)
    if event == 'ITEM_DATA_LOAD_RESULT' and waitingForItem then
        waitingForItem = false
        recievedItemInfo(msg)
    elseif event == 'CHAT_MSG_RAID_WARNING' and string.match(msg, '^Rolling for') then
        rollingStarted(msg, character)
    elseif RollInfo.isRolling then
        if string.match(msg, '^[0-9]+$') then
            betPlaced(msg, character)
        elseif string.lower(msg) == 'pass' and character == currentUser then
            RollingEnded()
        elseif RollInfo.user == character then
            if string.match(msg, '^QDKP2> .+ Purchases .+ for [0-9]+ BCP$') or string.match(msg, '^Rolling for .+ cancelled.$') then
                RollingEnded()
            elseif string.match(msg, '^.+ - OK, bet received.$') then
                betConfirmed(msg)
            end
        end
    end
end

local f = CreateFrame('Frame')
f:RegisterEvent('ITEM_DATA_LOAD_RESULT')
f:RegisterEvent('CHAT_MSG_RAID_LEADER')
f:RegisterEvent('CHAT_MSG_RAID_WARNING')
f:RegisterEvent('CHAT_MSG_RAID')
f:SetScript('OnEvent', OnEvent)
