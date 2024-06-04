local optionsPanel = CreateFrame("Frame")
optionsPanel:Hide()
optionsPanel:SetAllPoints()

---@diagnostic disable-next-line: inject-field
optionsPanel.name = "QDKP2 Simple Rolling UI"

local title = optionsPanel:CreateFontString(nil, 'ARTWORK', 'GameFontNormalLarge')
title:SetJustifyV('TOP')
title:SetJustifyH('LEFT')
title:SetPoint('TOPLEFT', 16, -16)
title:SetText(optionsPanel.name)

local subText = optionsPanel:CreateFontString(nil, 'ARTWORK', 'GameFontHighlightSmall')
subText:SetMaxLines(3)
subText:SetNonSpaceWrap(true)
subText:SetJustifyV('TOP')
subText:SetJustifyH('LEFT')
subText:SetPoint('TOPLEFT', title, 'BOTTOMLEFT', 0, -8)
subText:SetPoint('RIGHT', -32, 0)
subText:SetText('These options allow you to modify various things about this addon.')

InterfaceOptions_AddCategory(optionsPanel)

local function createEditBox(label, i, textChanged)
    local editBoxLabel = optionsPanel:CreateFontString(nil, 'ARTWORK', 'GameFontNormalMed1')
    editBoxLabel:SetJustifyV('TOP')
    editBoxLabel:SetJustifyH('LEFT')
    editBoxLabel:SetPoint('TOPLEFT', 16, -((i - 1) * 50 + 60))
    editBoxLabel:SetText(label)

    local editbox = CreateFrame("EditBox", label, optionsPanel)
    editbox:SetPoint("TOPLEFT", optionsPanel, "TOPLEFT", 16, -((i - 1) * 50 + 70))
    editbox:SetSize(200, 32)
    editbox:SetAutoFocus(false)
    editbox:SetFontObject('GameFontHighlightSmall')
    editbox.type = "editbox"

    editbox:SetScript("OnTextChanged", textChanged)

    local left = editbox:CreateTexture(nil, "BACKGROUND")
    left:SetWidth(8)
    left:SetHeight(20)
    left:SetPoint("LEFT", -5, 0)
    left:SetTexture("Interface\\Common\\Common-Input-Border")
    left:SetTexCoord(0, 0.0625, 0, 0.625)

    local right = editbox:CreateTexture(nil, "BACKGROUND")
    right:SetWidth(8)
    right:SetHeight(20)
    right:SetPoint("RIGHT", 0, 0)
    right:SetTexture("Interface\\Common\\Common-Input-Border")
    right:SetTexCoord(0.9375, 1, 0, 0.625)

    local center = editbox:CreateTexture(nil, "BACKGROUND")
    center:SetHeight(20)
    center:SetPoint("RIGHT", right, "LEFT", 0, 0)
    center:SetPoint("LEFT", left, "RIGHT", 0, 0)
    center:SetTexture("Interface\\Common\\Common-Input-Border")
    center:SetTexCoord(0.0625, 0.9375, 0, 0.625)

    editbox:SetScript("OnEscapePressed", editbox.ClearFocus)
    editbox:SetScript("OnEnterPressed", editbox.ClearFocus)
    editbox:SetScript("OnEditFocusGained", function()
        editbox:HighlightText(0, 99999999)
    end)

    return editbox
end

UIRollForEditBox = createEditBox('Roll start regex', 1, function(self)
    QDKP2SimpleRollingUIDB.rollForRegex = self:GetText()
end)

UICancelEditBox = createEditBox('Roll cancel regex', 2, function(self)
    QDKP2SimpleRollingUIDB.cancelRegex = self:GetText()
end)

UIWinEditBox = createEditBox('Roll win regex', 3, function(self)
    QDKP2SimpleRollingUIDB.winRegex = self:GetText()
end)

UIBetRecievedEditBox = createEditBox('Roll bet recieved regex', 4, function(self)
    QDKP2SimpleRollingUIDB.betRecievedRegex = self:GetText()
end)

UIIncreaseByEditBox = createEditBox('Increase your roll by', 5, function(self)
    if (string.match(self:GetText(), '^[0-9]+$')) then
        QDKP2SimpleRollingUIDB.betRecievedRegex = self:GetText()
    else
        self:SetText('10')
    end
end)
