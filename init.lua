local addon, ns = ...
ns.defaults = {
    -- Default Stuff
    font = [[Interface/Addons/Oof/Media/font/CharlesWright.ttf]],
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

function ns.GetModule(name)
    for _, module in ipairs(modules) do
        if module.name == name then
            return module.object
        end
    end
end

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
            AdventureGuide = true
        },
    },
    global = {
        olaa = 'olaa'
    }
}

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self,event,addonName)
    if addonName == addon then
        ns.DB = LibStub("AceDB-3.0"):New("OOF_DB", defaults)
        OOF_DBs = ns.DB
        InitializeFiles()
        self:UnregisterEvent("ADDON_LOADED")
    end
end)

ns.LSM = LibStub('LibSharedMedia-3.0');
