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
}
ns.L = {}
ns.UIElements = {}
ns.options = {}
local initFiles = {}
function ns.Initialize(func)
    initFiles[#initFiles + 1] = func
end
local function InitializeFiles()
    for _,func in ipairs(initFiles) do
        func()
    end
end

local defaults = {
    profile = {
        hello = 'hello',
        minimap = {
            width = 200,
            height = 300,
            scale = 1,
            shape = "rectangle"
        }
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

