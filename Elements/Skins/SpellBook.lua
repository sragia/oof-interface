local addon, ns = ...
local L = ns.L
local key = 'spellbook'
local name = 'Spell Book'
local obj = ns.CreateNewModule("Skins_"..key, 2)

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
    local mainFrame = _G['SpellBookFrame']

    StripTextures(texLoc, mainFrame)

    skins.AddBackdrop(mainFrame)
    -- Portrait
    mainFrame.portrait:SetAlpha(0)

    skins.SkinPanelText(mainFrame.TitleText)

    skins.SkinClose(mainFrame.CloseButton)

    skins.SkinHelpButton(mainFrame.MainHelpButton)

    local prevBtn = _G['SpellBookPrevPageButton']
    local nextBtn = _G['SpellBookNextPageButton']
    skins.SkinPrevNextButton(prevBtn,true)
    skins.SkinPrevNextButton(nextBtn,false)

    skins.SkinPanelTabs('SpellBookFrameTabButton%i', mainFrame.OofBackdrop, 0, 1)


  end

  if db then
    C_Timer.After(0.2,SkinFrame)

  -- local frame = CreateFrame("Frame")
  -- frame:RegisterEvent("ADDON_LOADED")
  -- frame:SetScript("OnEvent", function(self, event, addonName)
  --   if addonName == 'Blizzard_EncounterJournal' then
  --     SkinFrame()
  --     frame:UnregisterEvent("ADDON_LOADED")
  --   end
  -- end)
  end
  function obj:Refresh()
    ns.ReloadPopup()
  end

end



