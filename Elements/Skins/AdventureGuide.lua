local addon, ns = ...
local L = ns.L
local key = 'AdventureGuide'
local name = 'Adventure Guide'
local obj = ns.CreateNewModule("Skins_"..key)

ns.skins.RegisterSkin(key, name)

function obj:Initialize()
  local opt = ns.options
  local SF = ns.UIElements.defaultFunc
  local db = ns.DB.profile.skins[key]

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
    inset = {
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
    navBar = {
      'InsetBorderBottom',
      'InsetBorderBottomLeft',
      'InsetBorderBottomRight',
      'InsetBorderLeft',
      'InsetBorderRight',
    },
    searchBox = {
      'Left',
      'Middle',
      'Right'
    }
  }

  local function StripTextures(t, mainFrame)
    for k,v in pairs(t) do
      if type(v) == 'table' then
        StripTextures(v,mainFrame[k])
      else
        ns.StripTextures(mainFrame[v])
      end
    end
  end

  local function HideRegions(frame,upTo)
    local regions = {frame:GetRegions()}

    for i=1, upTo or #regions do
      regions[i]:Hide()
    end

  end


  local function SkinFrame()
    local mainFrame = _G['EncounterJournal']

    -- Strip Textures
    StripTextures(texLoc, mainFrame)

    ns.skins.AddBackdrop(mainFrame)

    ns.skins.SkinClose(mainFrame.CloseButton)
    mainFrame.inset:SetFrameLevel(2)
    mainFrame.inset.NineSlice:SetFrameLevel(2)
    mainFrame.encounter:SetFrameLevel(2)
    -- Portrait
    mainFrame.portrait:SetAlpha(0)
    -- Title Bar
    local titleText = mainFrame.TitleText
    ns.skins.SkinPanelText(titleText)

    -- Search
    local searchBox = mainFrame.searchBox
    SF.ApplyBackdrop(searchBox)
    searchBox:SetSize(230, 28)
    searchBox:ClearAllPoints()
    searchBox:SetPoint("TOPRIGHT", -5, -28)
    local font, size, flag = searchBox:GetFont()
    searchBox:SetFont(font, 12, flag)
    searchBox:SetTextInsets(22, 22, 2, 0)
    -- Search icon
    local searchIcon = searchBox.searchIcon
    searchIcon:ClearAllPoints()
    searchIcon:SetPoint("LEFT",5,-2)
    searchIcon:SetSize(16,16)
    -- Search Instructions
    local searchInstructions = searchBox.Instructions
    searchInstructions:ClearAllPoints()
    searchInstructions:SetPoint("TOPLEFT", 22, 0)
    searchInstructions:SetPoint("BOTTOMRIGHT",-22, 0)

    -- NavBar
    local navBar = mainFrame.navBar
    HideRegions(navBar.overlay)
    HideRegions(navBar, 1)
    SF.ApplyBackdrop(navBar)
    navBar:SetWidth(555)
    navBar:ClearAllPoints()
    navBar:SetPoint("TOPLEFT", 5, -22)
    navBar.homeButton:ClearAllPoints()
    navBar.homeButton:SetPoint("LEFT", 2, 0)


    -- DropDown
    local dropdown = _G['EncounterJournalInstanceSelectTierDropDown']
    ns.skins.SkinDropdown(dropdown)

  end

  local frame = CreateFrame("Frame")
  frame:RegisterEvent("ADDON_LOADED")
  frame:SetScript("OnEvent", function(self, event, addonName)
    if addonName == 'Blizzard_EncounterJournal' then
      SkinFrame()
      frame:UnregisterEvent("ADDON_LOADED")
    end
  end)

  function obj:Refresh()
    ns.ReloadPopup()
  end

end



