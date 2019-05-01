local addon, ns = ...
local L = ns.L
local key = 'talents'
local name = 'Talents'
local obj = ns.CreateNewModule("Skins_"..key)

ns.skins.RegisterSkin(key, name)

function obj:Initialize()
  local opt = ns.options
  local SF = ns.UIElements.defaultFunc
  local db = ns.DB.profile.skins[key]
  local skins = ns.skins

  local texLoc = {
    'TitleBg',
    'TopTileStreaks',
    'Bg',
    NineSlice = {
      'TopRightCorner',
      'TopEdge',
      'TopLeftCorner',
      'RightEdge',
      'BottomEdge',
      'LeftEdge',
      'BottomEdge',
      'BottomRightCorner',
      'BottomLeftCorner'
    },
    Inset = {
      'Bg',
      NineSlice = {
        'TopRightCorner',
        'TopEdge',
        'TopLeftCorner',
        'RightEdge',
        'BottomEdge',
        'LeftEdge',
        'BottomEdge',
        'BottomRightCorner',
        'BottomLeftCorner'
      }
    },
  }


  local function StripTextures(t, mainFrame)
    for k,v in pairs(t) do
      if (mainFrame[k] and type(v) == 'table') then
        StripTextures(v,mainFrame[k])
      elseif mainFrame[v] then
        ns.StripTextures(mainFrame[v])
      end
    end
  end

  local function SkinFrame()
    local mainFrame = _G['PlayerTalentFrame']
    StripTextures(texLoc, mainFrame)

    mainFrame.portrait:SetAlpha(0)

    skins.SkinClose(mainFrame.CloseButton)
    skins.SkinPanelText(mainFrame.TitleText)
    skins.AddBackdrop(mainFrame)

    local specFrame = _G['PlayerTalentFrameSpecialization']

    skins.SkinHelpButton(specFrame.MainHelpButton)
    skins.SkinButton(specFrame.learnButton)
    ns.Offset(specFrame.MainHelpButton, 0, 26)

    for _, f in ipairs({specFrame:GetRegions()}) do
      if (f:GetObjectType() == 'Texture') then
        ns.StripTextures(f)
      end
    end

    for _, f in ipairs({specFrame:GetChildren()}) do
      if (f:GetObjectType() == 'Frame') then
        f:Hide()
      end
    end

    local talentTexLoc = {
      'scrollwork_topright',
      'scrollwork_topleft',
      'scrollwork_bottomright',
      'scrollwork_bottomleft',
      'gradient'
    }

    StripTextures(talentTexLoc, specFrame.spellsScroll.child)

    skins.SkinPanelTabs('PlayerTalentFrameTab%i',0,1)

    local talentsFrame = _G['PlayerTalentFrameTalents']

    skins.SkinHelpButton(talentsFrame.MainHelpButton)
    ns.Offset(talentsFrame.MainHelpButton,0, 60)
  end

  if db then

    local frame = CreateFrame("Frame")
    frame:RegisterEvent("ADDON_LOADED")
    frame:SetScript("OnEvent", function(self, event, addonName)
      if addonName == 'Blizzard_TalentUI' then
        SkinFrame()
        frame:UnregisterEvent("ADDON_LOADED")
      end
    end)
  end
  function obj:Refresh()
    ns.ReloadPopup()
  end

end



