function HasValue(tab, val)
    for _, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

function GetCharacterFullName()
    local realmName = GetNormalizedRealmName();
    return GetUnitName('player', true) .. '-' .. realmName
end
