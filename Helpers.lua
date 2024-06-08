function HasValue(tab, val)
    for _, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

local realmName = GetNormalizedRealmName()
CharacterFullName = GetUnitName('player', true) .. '-' .. realmName
