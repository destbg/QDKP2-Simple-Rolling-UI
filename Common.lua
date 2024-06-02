function RecievedItemInfo(item)
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

function RollingStarted(msg, character)
    local item = string.sub(msg, 13)
    local index = string.find(item, ' started.')
    item = string.sub(item, 1, index - 1)
    RollInfo.item = item
    RollInfo.user = character
    RollInfo.isRolling = true

    if not C_Item.IsItemDataCachedByID(item) then
        WaitingForItem = true
        C_Item.RequestLoadItemDataByID(item)
    else
        RecievedItemInfo(item)
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

function BetPlaced(msg, character)
    RollInfo.bets[character] = tonumber(msg)
end

function BetConfirmed(msg)
    local index = string.find(msg, '-', string.find(msg, '-') + 1)
    local char = string.sub(msg, 1, index - 2)

    local bet = RollInfo.bets[char]

    if bet > RollInfo.bet then
        RollInfo.bet = bet
        UICurrentBet:SetText(bet .. ' by ' .. string.sub(char, 1, string.find(char, '-') - 1))
    end
end
