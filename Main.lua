SLASH_QDKP2ROLL1 = '/qdkp2roll'

local function onAddonMessage(addonName, msg, _, sender)
    if addonName ~= 'QDKP2SRUI' then
        return
    end

    if (msg == 'version') then
        C_ChatInfo.SendAddonMessage('QDKP2SRUI', AddonVersion, 'RAID')
    elseif (msg:match('^[0-9.]+$')) then
        local index = string.find(sender, '-')
        local char = string.sub(sender, 1, index - 1)
        print(char .. ' has version ' .. msg)
    end
end

local function onItemLoad(msg)
    if WaitingForItem then
        WaitingForItem = false
        RecievedItemInfo(msg)
    end
end

local function onAddonLoaded(addonName)
    if addonName == 'QDKP2-Simple-Rolling-UI' then
        QDKP2SimpleRollingUIDB = QDKP2SimpleRollingUIDB or {
            wins = 0,
            losses = 0,
            passes = 0
        }
    end
end

local function onRaidChatMessage(msg, sender)
    if string.match(msg, '^Rolling for .+ started.') then
        RollingStarted(msg, sender)
    elseif RollInfo.isRolling then
        if string.match(msg, '^[0-9]+$') then
            BetPlaced(msg, sender)
        elseif string.lower(msg) == 'pass' and sender == CharacterFullName then
            RollingEnded(false)
        elseif RollInfo.user == sender then
            if string.match(msg, '^QDKP2> .+ Purchases .+ for [0-9]+ BCP$') then
                RollingEnded(true)
            elseif string.match(msg, '^Rolling for .+ cancelled.$') then
                RollingEnded(false)
            elseif string.match(msg, '^.+ - OK, bet received.$') then
                BetConfirmed(msg)
            end
        end
    end
end

local function OnEvent(_, event, ...)
    if event == 'CHAT_MSG_ADDON' then
        onAddonMessage(...)
    elseif event == 'ITEM_DATA_LOAD_RESULT' then
        onItemLoad(...)
    elseif event == 'ADDON_LOADED' then
        onAddonLoaded(...)
    else
        onRaidChatMessage(...)
    end
end

local function SlashCmdHandler(msg, ...)
    if (string.len(msg) == 0) then
        print('Commands available:')
        print('/qdkp2roll version (checks the addon version of all raid or party members)')
        print('/qdkp2roll record (prints out all of your wins, losses and passes)')
        print('/qdkp2roll reset data (resets all of your wins, losses and passes)')
        print('/qdkp2roll reset position (resets the position of the UI frame)')
        return
    elseif msg == 'version' then
        print('Versions:')
        C_ChatInfo.SendAddonMessage('QDKP2SRUI', 'version', 'RAID')
    elseif msg == 'record' then
        print('Wins: ' .. (QDKP2SimpleRollingUIDB.wins or 0))
        print('Losses: ' .. (QDKP2SimpleRollingUIDB.losses or 0))
        print('Passes: ' .. (QDKP2SimpleRollingUIDB.passes or 0))
    elseif msg == 'reset data' then
        QDKP2SimpleRollingUIDB = {
            wins = 0,
            losses = 0,
            passes = 0
        }
    elseif msg == 'reset position' then
        UIConfig:SetPoint('RIGHT', -100, 100)
    end
end

local f = CreateFrame('Frame')
f:RegisterEvent('ITEM_DATA_LOAD_RESULT')
f:RegisterEvent('CHAT_MSG_RAID_LEADER')
f:RegisterEvent('CHAT_MSG_RAID_WARNING')
f:RegisterEvent('CHAT_MSG_RAID')
f:RegisterEvent('CHAT_MSG_ADDON')
f:RegisterEvent('ADDON_LOADED')
f:SetScript('OnEvent', OnEvent)

SlashCmdList['QDKP2ROLL'] = SlashCmdHandler
