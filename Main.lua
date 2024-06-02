SLASH_QDKP2ROLL1 = '/qdkp2roll'

local function OnEvent(self, event, msg, character, ...)
    if event == 'ITEM_DATA_LOAD_RESULT' and WaitingForItem then
        WaitingForItem = false
        RecievedItemInfo(msg)
    elseif event == 'CHAT_MSG_RAID_WARNING' and string.match(msg, '^Rolling for') then
        RollingStarted(msg, character)
    elseif RollInfo.isRolling then
        if string.match(msg, '^[0-9]+$') then
            BetPlaced(msg, character)
        elseif string.lower(msg) == 'pass' and character == CharacterFullName then
            RollingEnded()
        elseif RollInfo.user == character then
            if string.match(msg, '^QDKP2> .+ Purchases .+ for [0-9]+ BCP$') or string.match(msg, '^Rolling for .+ cancelled.$') then
                RollingEnded()
            elseif string.match(msg, '^.+ - OK, bet received.$') then
                BetConfirmed(msg)
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
