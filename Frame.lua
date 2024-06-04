-- UI frame for the addon
UIConfig = CreateFrame('Frame', nil, UIParent, 'BackdropTemplate')
UIConfig:SetSize(300, 62)
UIConfig:SetPoint('RIGHT', -100, 100)
UIConfig:RegisterForDrag('LeftButton')
UIConfig:SetBackdrop(BACKDROP_TUTORIAL_16_16)
UIConfig:SetToplevel(true)
UIConfig:SetClampedToScreen(true)
UIConfig:SetAlpha(0)
UIConfig:EnableMouse(false)
UIConfig:SetMovable(true)
UIConfig:RegisterForDrag('LeftButton')

UIConfig:SetScript('OnDragStart', function(self)
    self:StartMoving()
end)

UIConfig:SetScript('OnDragStop', function(self)
    self:StopMovingOrSizing()
end)

-- Item link
local itemFrame = CreateFrame('Frame', nil, UIConfig)
itemFrame:SetSize(42, 42)
itemFrame:SetPoint('TOPLEFT', UIConfig, 'TOPLEFT', 10, -10)

UIItemIcon = UIConfig:CreateTexture(nil, 'OVERLAY')
UIItemIcon:SetSize(42, 42)
UIItemIcon:SetPoint('TOPLEFT', itemFrame, 'TOPLEFT', 0, 0)

itemFrame:HookScript('OnEnter', function()
    if (RollInfo.isRolling) then
        GameTooltip:SetOwner(itemFrame, 'ANCHOR_RIGHT')
        GameTooltip:SetHyperlink(select(2, C_Item.GetItemInfo(RollInfo.item)))
        GameTooltip:Show()
    end
end)

itemFrame:HookScript('OnLeave', function()
    if (GameTooltip:IsShown()) then
        GameTooltip:Hide()
    end
end)

-- Details about the item and bets
local betFrame = CreateFrame('Frame', nil, UIConfig)
betFrame:SetSize(100, 20)
betFrame:SetPoint('TOPLEFT', itemFrame, 'TOPRIGHT', 10, 0)

UIItemName = UIConfig:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
UIItemName:SetPoint('TOPLEFT', betFrame, 'LEFT', 0, 9)
UIItemName:SetText('No item name')

UICurrentBet = UIConfig:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
UICurrentBet:SetPoint('TOPLEFT', betFrame, 'LEFT', 0, -7)
UICurrentBet:SetText('No bets yet')

UIItemInfo = UIConfig:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
UIItemInfo:SetPoint('TOPLEFT', betFrame, 'LEFT', 0, -22)
UIItemInfo:SetText('Armor')
UIItemInfo:SetFont('Fonts\\FRIZQT__.TTF', 10)
UIItemInfo:SetTextColor(0.5, 0.5, 0.5, 1)

-- Bet button
local betButton = CreateFrame('BUTTON', nil, UIConfig, 'SecureHandlerClickTemplate');
betButton:SetSize(28, 28)
betButton:SetPoint('RIGHT', UIConfig, 'RIGHT', -50, 0)
betButton:EnableMouse(false)

betButton:RegisterForClicks('LeftButtonUp')
betButton:SetNormalTexture('Interface\\Minimap\\MiniMap-QuestArrow.PNG')
betButton:SetScript('OnClick', function()
    if RollInfo.isRolling then
        local by = QDKP2SimpleRollingUIDB.increaseBy
        local rounded = (math.floor(RollInfo.bet / by) * by) + by

        if (RollInfo.bets[CharacterFullName] ~= rounded) then
            RollInfo.bets[CharacterFullName] = rounded
            SendChatMessage(tostring(rounded), 'RAID')
        end
    end
end)

-- Pass button
local passButton = CreateFrame('BUTTON', nil, UIConfig, 'SecureHandlerClickTemplate');
passButton:SetSize(22, 22)
passButton:SetPoint('RIGHT', UIConfig, 'RIGHT', -20, 0)
passButton:EnableMouse(false)

passButton:RegisterForClicks('LeftButtonUp')
passButton:SetNormalTexture('Interface\\Buttons\\UI-GroupLoot-Pass-Up.PNG')
passButton:SetScript('OnClick', function()
    if RollInfo.isRolling then
        if RollInfo.bets[CharacterFullName] == RollInfo.bet and RollInfo.bet ~= 0 then
            print('Can\'t pass when you are the highest bit')
            return
        end

        if RollInfo.bets[CharacterFullName] then
            SendChatMessage('pass', 'RAID')
        end

        RollingEnded(false)
    end
end)

UITooltipScanner = CreateFrame('GameTooltip', 'UITooltipScanner', nil, 'GameTooltipTemplate')
UITooltipScanner:Hide()

function ChangeInteractable(enable)
    UIConfig:SetAlpha(enable and 1 or 0)
    UIConfig:EnableMouse(enable)
    local children = { UIConfig:GetChildren() }
    for _, child in ipairs(children) do
        ---@diagnostic disable-next-line: undefined-field
        child:EnableMouse(enable)
    end
end
