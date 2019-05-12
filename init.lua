local addon, ns = ...
Oof = {}
ns.defaults = {
    -- Default Stuff
    font = [[Interface/Addons/Oof/Media/font/CharlesWright.ttf]],
    fontSize = 12,
    fontFlag = "OUTLINE",
    logoLarge = [[Interface/Addons/Oof/Media/icons/logo-large]],
    logoSmall = [[Interface/Addons/Oof/Media/icons/logo-small]],
    backdrop = {
        bgFile = "Interface\\BUTTONS\\WHITE8X8.blp",
        edgeFile = "Interface\\BUTTONS\\WHITE8X8.blp",
        tile = false,
        tileSize = 0,
        edgeSize = 1,
        insets = {
            left = 0,
            right = 0,
            top = 0,
            bottom = 0
        }
    },
    points = {
        TOPLEFT = 'Top Left',
        TOP = 'Top',
        TOPRIGHT = 'Top Right',
        RIGHT = 'Right',
        BOTTOMRIGHT = 'Bottom Right',
        BOTTOM = 'Bottom',
        BOTTOMLEFT = 'Bottom Left',
        LEFT = 'Left',
        CENTER = 'Center',
    },
    zoomedTexCoords = {
        0.08,
        0.92,
        0.08,
        0.92
    }
}
ns.L = {}
ns.UIElements = {}
ns.options = {}
ns.mover = {}
local initFiles = {}

local modules = {}

function ns.CreateNewModule(name)
    local object = {}
    modules[#modules + 1] = {
        name = name,
        object = object
    }
    return object
end

function ns.GetModule(self,name)
    for _, module in ipairs(modules) do
        if module.name == name then
            return module.object
        end
    end
    print('nothing')
end

Oof.GetModule = ns.GetModule

function ns.Initialize(func)
    initFiles[#initFiles + 1] = func
end
local function InitializeFiles()
    for _, m in ipairs(modules) do
        m.object:Initialize()
    end
end

local defaults = {
    profile = {
        hello = 'hello',
        minimap = {
            size = 400,
            scale = 1,
            shape = "rectangle",
            aspect = "1x1",
            left = 0,
            bottom = 0,
            elements = {
                GameTimeFrame = {
                    point = "TOPRIGHT",
                    x = 20,
                    y = -2
                },
                OofMinimapClock = {
                    point = "BOTTOM",
                    x = 0,
                    y = 0,
                    fontSize = 13,
                },
                MiniMapInstanceDifficulty = {
                    point = "TOPLEFT",
                    x = 0,
                    y = 0,
                },
                OofMinimapZoneText = {
                    point = "TOP",
                    x = 0,
                    y = 0,
                    fontSize = 12
                }
            }
        },
        skins = {
            AdventureGuide = true,
            groupfinder = true,
            gamemenu = true,
            spellbook = true,
            achievements = true,
            character = true,
            collections = true,
            communities = true,
            interface = true,
            keybindings = true,
            macros = true,
            map = true,
            misc = true,
            shop = true,
            system = true,
            talents = true
        },
        chat = {
            container = {
                width = 400,
                height = 200,
                point = "BOTTOMLEFT",
                x = 0,
                y = 0,
            },
            hideChatChannelButton = false,
            hideChatMenuButton = false,
            hideSocialButton = false,
            tabPos = 'TOP',
            editPos = 'BOTTOM',
            font = 'CharlesWright',
            flag = 'NONE',
            tabFontFlag = 'NONE',
            tabFontSize = 14,
            tabFont = 'CharlesWright',
            tabFontColor = {1,1,1,1}
        },
        media = {
            fonts = {
                defaultFont = 'CharlesWright',
                replaceBlizz = true,
                modifier = 1,
            }
        },
        objectiveTracker = {
            point = "TOPRIGHT",
            x = 0,
            y = -200,
            height = 400,
            scale = 1,
        },
        buffsdebuffs = {
            font = "CharlesWright",
            countXOffset = 0,
            countYOffset = 0,
            timeXOffset = 0,
            timeYOffset = 0,
            fontOutline = "NONE",
            buffs = {
                point = "TOPRIGHT",
                x = -200,
                y = -10,
                sortMethod = "TIME",
                seperateOwn = 1,
                sortDir = '-',
                maxWraps = 3,
                wrapAfter = 12,
                growthDirection = 'LEFT_DOWN',
                horizontalSpacing = 1,
                size = 28,
                verticalSpacing = 11,
                durationFontSize = 12,
                countFontSize = 14,
                countXOffset = 0,
                countYOffset = 0,
                timeXOffset = 0,
                timeYOffset = 0,
            },
            debuffs = {
                point = "TOPRIGHT",
                x = -200,
                y = -100,
                sortMethod = "TIME",
                seperateOwn = 1,
                sortDir = '-',
                maxWraps = 3,
                wrapAfter = 12,
                growthDirection = 'LEFT_DOWN',
                horizontalSpacing = 1,
                size = 36,
                verticalSpacing = 11,
                durationFontSize = 12,
                countFontSize = 14,
                countXOffset = 0,
                countYOffset = 0,
                timeXOffset = 0,
                timeYOffset = 0,
            },
        },
        panels = {
            --[[
                [panelID] = {
                    panelName = ""
                    bgColor = {},
                    borderColor = {},
                    borderSize = 1,
                }
            ]]
        },
        databrokers = {},
        CUSTOMSAVE = {}
    },
    global = {
        olaa = 'olaa'
    }
}



local f = CreateFrame("Frame")
f:RegisterEvent("VARIABLES_LOADED")
f:SetScript("OnEvent", function(self,event,addonName)
    ns.DB = LibStub("AceDB-3.0"):New("OOF_DB", defaults)
    OOF_DBs = ns.DB
    InitializeFiles()
    self:UnregisterEvent("ADDON_LOADED")
    SAVE_VARS = ns.DB.profile.CUSTOMSAVE
end)

ns.LSM = LibStub('LibSharedMedia-3.0');
