SLASH_QDKP2ROLL1 = '/qdkp2roll'

local loaded = false

local function onAddonMessage(addonName, msg, _, sender)
    if addonName ~= 'QDKP2SRUI' then
        return
    end

    if (msg == 'version') then
        C_ChatInfo.SendAddonMessage('QDKP2SRUI', sender .. ' ' .. AddonVersion, 'RAID')
    elseif (msg:match('^.+ [0-9.]+$')) then
        local spaceIndex = string.find(msg, ' ')
        local fullCharName = string.sub(msg, 1, spaceIndex - 1)
        local version = string.sub(msg, spaceIndex + 1)

        if fullCharName == CharacterFullName then
            local index = string.find(sender, '-')
            local char = string.sub(sender, 1, index - 1)
            print(char .. ' has version ' .. version)
        end
    end
end

local function onItemLoad(msg)
    if WaitingForItem then
        WaitingForItem = false
        RecievedItemInfo(msg)
    end
end

local function onGroupRoasterUpdate()
    if UnitInRaid() and not UIConfig:IsShown() then
        UIConfig:Show()
    elseif not UnitInRaid() and UIConfig:IsShown() then
        UIConfig:Hide()
    end
end

local function onAddonLoaded(addonName)
    if addonName == 'QDKP2-Simple-Rolling-UI' then
        QDKP2SimpleRollingUIDB = QDKP2SimpleRollingUIDB or {
            wins = 0,
            losses = 0,
            passes = 0,
            rollForRegex = RegexDefaults.rollFor,
            cancelRegex = RegexDefaults.cancel,
            winRegex = RegexDefaults.win,
            betRecievedRegex = RegexDefaults.betRecieved,
            increaseBy = 10
        }

        if not QDKP2SimpleRollingUIDB.rollForRegex then
            QDKP2SimpleRollingUIDB.rollForRegex = RegexDefaults.rollFor
        end
        if not QDKP2SimpleRollingUIDB.cancelRegex then
            QDKP2SimpleRollingUIDB.cancelRegex = RegexDefaults.cancel
        end
        if not QDKP2SimpleRollingUIDB.winRegex then
            QDKP2SimpleRollingUIDB.winRegex = RegexDefaults.win
        end
        if not QDKP2SimpleRollingUIDB.betRecievedRegex then
            QDKP2SimpleRollingUIDB.betRecievedRegex = RegexDefaults.betRecieved
        end
        if not QDKP2SimpleRollingUIDB.increaseBy then
            QDKP2SimpleRollingUIDB.increaseBy = 10
        end

        UIRollForEditBox:SetText(QDKP2SimpleRollingUIDB.rollForRegex)
        UICancelEditBox:SetText(QDKP2SimpleRollingUIDB.cancelRegex)
        UIWinEditBox:SetText(QDKP2SimpleRollingUIDB.winRegex)
        UIBetRecievedEditBox:SetText(QDKP2SimpleRollingUIDB.betRecievedRegex)
        UIIncreaseByEditBox:SetText(QDKP2SimpleRollingUIDB.increaseBy)

        C_ChatInfo.RegisterAddonMessagePrefix('QDKP2SRUI')

        if UnitInRaid() and not UIConfig:IsShown() then
            UIConfig:Show()
        end

        loaded = true
    end
end

local function onRaidChatMessage(msg, sender)
    if not loaded then
        return
    elseif string.match(msg, QDKP2SimpleRollingUIDB.rollForRegex) then
        RollingStarted(msg, sender)
    elseif RollInfo.isRolling then
        if string.match(msg, '^[0-9]+$') then
            BetPlaced(msg, sender)
        elseif string.lower(msg) == 'pass' and sender == CharacterFullName then
            RollingEnded(false)
        elseif RollInfo.user == sender then
            if string.match(msg, QDKP2SimpleRollingUIDB.winRegex) then
                RollingEnded(true)
            elseif string.match(msg, QDKP2SimpleRollingUIDB.cancelRegex) then
                RollingEnded(false)
            elseif string.match(msg, QDKP2SimpleRollingUIDB.betRecievedRegex) then
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
    elseif event == 'GROUP_ROSTER_UPDATE' then
        onGroupRoasterUpdate()
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
            passes = 0,
            rollForRegex = QDKP2SimpleRollingUIDB.rollForRegex,
            cancelRegex = QDKP2SimpleRollingUIDB.cancelRegex,
            winRegex = QDKP2SimpleRollingUIDB.winRegex,
            betRecievedRegex = QDKP2SimpleRollingUIDB.betRecievedRegex,
            increaseBy = QDKP2SimpleRollingUIDB.increaseBy
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
f:RegisterEvent('PLAYER_REGEN_ENABLED')
f:RegisterEvent('GROUP_ROSTER_UPDATE')
f:SetScript('OnEvent', OnEvent)

SlashCmdList['QDKP2ROLL'] = SlashCmdHandler
