-- UI frame for the addon
UIConfig = CreateFrame('Frame', 'BCP_UI', UIParent, 'BackdropTemplate')
UIConfig:SetSize(300, 62)
UIConfig:SetPoint('RIGHT', -100, 100)
UIConfig:RegisterForDrag('LeftButton')
UIConfig:SetBackdrop(BACKDROP_TUTORIAL_16_16)
UIConfig:Hide()

UIConfig:SetMovable(true)
UIConfig:EnableMouse(true)
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
    GameTooltip:SetOwner(itemFrame, 'ANCHOR_RIGHT')
    GameTooltip:SetHyperlink(select(2, C_Item.GetItemInfo(RollInfo.item)))
    GameTooltip:Show()
end)

itemFrame:HookScript('OnLeave', function()
    GameTooltip:Hide()
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

betButton:RegisterForClicks('LeftButtonUp')
betButton:SetNormalTexture('Interface\\Minimap\\MiniMap-QuestArrow.PNG')
betButton:SetScript('OnClick', function()
    local rounded = math.floor(RollInfo.bet / 10) * 10
    SendChatMessage(tostring(rounded + 10), 'RAID')
end)

-- Pass button
local passButton = CreateFrame('BUTTON', nil, UIConfig, 'SecureHandlerClickTemplate');
passButton:SetSize(22, 22)
passButton:SetPoint('RIGHT', UIConfig, 'RIGHT', -20, 0)

passButton:RegisterForClicks('LeftButtonUp')
passButton:SetNormalTexture('Interface\\Buttons\\UI-GroupLoot-Pass-Up.PNG')
passButton:SetScript('OnClick', function()
    if RollInfo.bets[CharacterFullName] == RollInfo.bet and RollInfo.bet ~= 0 then
        print('Can\'t pass when you are the highest bit')
        return
    end

    if RollInfo.bets[CharacterFullName] then
        SendChatMessage('pass', 'RAID')
    end

    RollingEnded(false)
end)

UITooltipScanner = CreateFrame('GameTooltip', 'UITooltipScanner', nil, 'GameTooltipTemplate')
UITooltipScanner:Hide()
