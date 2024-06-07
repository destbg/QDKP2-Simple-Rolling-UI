-- Function created by the LootReserve addon team
local function isItemUsable(itemID)
    local itemLink              = select(2, C_Item.GetItemInfo(itemID))
    local numOwned              = C_Item.GetItemCount(itemID, true)

    local classesText           = format('^(%s)$', ITEM_CLASSES_ALLOWED:gsub('%%s', '.+'))
    local alreadyKnownText      = format('^(%s)$', ITEM_SPELL_KNOWN)
    local uniqueText            = format('^(%s)$', ITEM_UNIQUE_EQUIPPABLE)
    local professionAllowedText = format('^%s$',
        ITEM_MIN_SKILL:gsub('%d+%$', ''):gsub('%%s ', '([%%u%%l%%s]+) '):gsub('%(%%d%)', '%%((%%d+)%%)'))

    UITooltipScanner:SetOwner(WorldFrame, 'ANCHOR_NONE')
    UITooltipScanner:SetHyperlink(itemLink)

    for i = 1, UITooltipScanner:NumLines() do
        local line = _G[UITooltipScanner:GetName() .. 'TextLeft' .. i]
        if line and line:GetText() then
            local text = line:GetText()
            local problem = false

            if text:match(alreadyKnownText) then
                local r, g, b = line:GetTextColor()
                r, g, b = r * 255, g * 255, b * 255
                if r > 254 and r <= 255 and g > 31 and g <= 32 and b > 31 and b <= 32 then
                    problem = true
                end
            elseif text:match(uniqueText) then
                if numOwned > 0 then
                    problem = true
                end
            elseif text:match(professionAllowedText) then
                if numOwned > 0 then
                    problem = true
                else
                    local r, g, b = line:GetTextColor()
                    r, g, b = r * 255, g * 255, b * 255
                    if r > 254 and r <= 255 and g > 31 and g <= 33 and b > 31 and b <= 33 then
                        problem = true
                    end
                end
            elseif text:match(classesText) then
                local r, g, b = line:GetTextColor()
                r, g, b = r * 255, g * 255, b * 255
                if r > 254 and r <= 255 and g > 31 and g <= 33 and b > 31 and b <= 33 then
                    problem = true
                end
            end
            if problem then
                UITooltipScanner:Hide()
                return false
            end
        end
    end
    UITooltipScanner:Hide()

    return true
end

function RecievedItemInfo(item)
    local itemClass = select(6, C_Item.GetItemInfo(item))
    local itemSubclass = select(7, C_Item.GetItemInfo(item))
    local class = string.gsub(select(1, UnitClass('player')), ' ', '')

    if HasValue(Wearables, itemSubclass) and ClassWearables[class] ~= itemSubclass then
        return
    elseif HasValue(SupportedEquipables, itemSubclass) and not HasValue(ClassEquipables[class], itemSubclass) then
        return
    elseif not isItemUsable(item) then
        return
    end

    local color = select(3, C_Item.GetItemInfo(item))
    local r, g, b = C_Item.GetItemQualityColor(color)

    UIItemName:SetText(select(1, C_Item.GetItemInfo(item)))
    UIItemName:SetTextColor(r, g, b, 1)
    UIItemIcon:SetTexture(C_Item.GetItemIconByID(item))

    local inventoryType = select(9, C_Item.GetItemInfo(item))
    local foundType = InventoryTypeClasses[inventoryType]

    if foundType ~= nil then
        UIItemInfo:SetText(foundType)
    elseif HasValue(NonSpecialSubclasses, itemSubclass) then
        UIItemInfo:SetText(itemClass)
    else
        UIItemInfo:SetText(itemClass .. ' - ' .. itemSubclass)
    end

    ChangeInteractable(true)
end

function RollingStarted(msg, character)
    local item = string.match(msg, QDKP2SimpleRollingUIDB.rollForRegex)

    if (item == nil or not C_Item.DoesItemExistByID(item)) then
        print('The regex provided for starting rolls didn\'t have a valid link group.')
        return
    end

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

function RollingEnded(isWin)
    if UIConfig:GetAlpha() == 1 then
        ChangeInteractable(false)
    end

    if isWin then
        QDKP2SimpleRollingUIDB.wins = (QDKP2SimpleRollingUIDB.wins or 0) + 1
    else
        if RollInfo.bets[CharacterFullName] == nil then
            QDKP2SimpleRollingUIDB.passes = (QDKP2SimpleRollingUIDB.passes or 0) + 1
        else
            QDKP2SimpleRollingUIDB.losses = (QDKP2SimpleRollingUIDB.losses or 0) + 1
        end
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
    local char = string.match(msg, QDKP2SimpleRollingUIDB.betRecievedRegex)

    if (char == nil) then
        print('The regex provided for confirming bets didn\'t have a valid link group.')
        return
    end

    local index = string.find(char, ' ')
    char = string.sub(char, 1, index - 1)

    if (RollInfo.bets[char] == nil) then
        print('The regex provided for confirming bets didn\'t have a valid link group.')
        return
    end

    local bet = RollInfo.bets[char]

    if bet > RollInfo.bet then
        RollInfo.bet = bet
        UICurrentBet:SetText(bet .. ' by ' .. string.sub(char, 1, string.find(char, '-') - 1))
    end
end
