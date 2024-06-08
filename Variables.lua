AddonVersion = '1.7'

RegexDefaults = {
    rollFor = '^Rolling for (.+) started.',
    cancel = '^Rolling for .+ cancelled.$',
    win = '^QDKP2> .+ Purchases .+$',
    betRecieved = '^(.+) - OK, bet received.$'
}

WaitingForItem = false

local other = C_Item.GetItemSubClassInfo(0, 8)
local junk = C_Item.GetItemSubClassInfo(15, 0)

NonSpecialSubclasses = {
    other,
    junk
}

InventoryTypeClasses = {
    INVTYPE_TRINKET = INVTYPE_TRINKET,
    INVTYPE_NECK = INVTYPE_NECK,
    INVTYPE_CLOAK = INVTYPE_CLOAK,
    INVTYPE_FINGER = INVTYPE_FINGER
}

RollInfo = {
    isRolling = false,
    user = nil,
    item = nil,
    bets = {},
    bet = 0
}

local cloth = C_Item.GetItemSubClassInfo(4, 1)
local leather = C_Item.GetItemSubClassInfo(4, 2)
local mail = C_Item.GetItemSubClassInfo(4, 3)
local plate = C_Item.GetItemSubClassInfo(4, 4)

local shields = C_Item.GetItemSubClassInfo(4, 6)
local relic = C_Item.GetItemSubClassInfo(4, 11)

local oneHandedAxes = C_Item.GetItemSubClassInfo(2, 0)
local twoHandedAxes = C_Item.GetItemSubClassInfo(2, 1)
local bows = C_Item.GetItemSubClassInfo(2, 2)
local guns = C_Item.GetItemSubClassInfo(2, 3)
local oneHandedMaces = C_Item.GetItemSubClassInfo(2, 4)
local twoHandedMaces = C_Item.GetItemSubClassInfo(2, 5)
local polearms = C_Item.GetItemSubClassInfo(2, 6)
local oneHandedSwords = C_Item.GetItemSubClassInfo(2, 7)
local twoHandedSwords = C_Item.GetItemSubClassInfo(2, 8)
local staves = C_Item.GetItemSubClassInfo(2, 10)
local fist = C_Item.GetItemSubClassInfo(2, 13)
local daggers = C_Item.GetItemSubClassInfo(2, 15)
local thrown = C_Item.GetItemSubClassInfo(2, 16)
local crossbows = C_Item.GetItemSubClassInfo(2, 18)
local wands = C_Item.GetItemSubClassInfo(2, 19)

Wearables = {
    plate,
    mail,
    leather,
    cloth
}

ClassWearables = {
    DeathKnight = plate,
    Druid = leather,
    Hunter = mail,
    Mage = cloth,
    Paladin = plate,
    Priest = cloth,
    Rogue = leather,
    Shaman = mail,
    Warlock = cloth,
    Warrior = plate
}

SupportedEquipables = {
    oneHandedMaces,
    twoHandedMaces,
    oneHandedSwords,
    twoHandedSwords,
    oneHandedAxes,
    twoHandedAxes,
    polearms,
    daggers,
    shields,
    fist,
    bows,
    guns,
    crossbows,
    thrown,
    staves,
    wands,
    relic,
}

ClassEquipables = {
    DeathKnight = {
        oneHandedAxes,
        twoHandedAxes,
        oneHandedSwords,
        twoHandedSwords,
        oneHandedMaces,
        twoHandedMaces,
        polearms,
        relic,
    },
    Druid = {
        oneHandedMaces,
        twoHandedMaces,
        polearms,
        staves,
        daggers,
        fist,
        relic,
    },
    Hunter = {
        oneHandedAxes,
        twoHandedAxes,
        oneHandedSwords,
        twoHandedSwords,
        polearms,
        staves,
        daggers,
        fist,
        bows,
        crossbows,
        guns,
    },
    Mage = {
        oneHandedSwords,
        twoHandedSwords,
        staves,
        daggers,
        wands,
    },
    Paladin = {
        oneHandedAxes,
        twoHandedAxes,
        oneHandedSwords,
        twoHandedSwords,
        oneHandedMaces,
        twoHandedMaces,
        polearms,
        relic,
        shields,
    },
    Priest = {
        oneHandedMaces,
        staves,
        daggers,
        wands,
    },
    Rogue = {
        oneHandedAxes,
        oneHandedSwords,
        oneHandedMaces,
        daggers,
        fist,
        bows,
        crossbows,
        guns,
        thrown,
    },
    Shaman = {
        oneHandedAxes,
        twoHandedAxes,
        oneHandedMaces,
        twoHandedMaces,
        polearms,
        staves,
        daggers,
        fist,
        relic,
        shields,
    },
    Warlock = {
        oneHandedSwords,
        twoHandedSwords,
        staves,
        daggers,
        wands,
    },
    Warrior = {
        oneHandedMaces,
        twoHandedMaces,
        oneHandedSwords,
        twoHandedSwords,
        oneHandedAxes,
        twoHandedAxes,
        polearms,
        staves,
        daggers,
        fist,
        bows,
        crossbows,
        guns,
        thrown,
        shields,
    },
}
