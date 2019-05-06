local addon, ns = ...
local L = ns.L
local key = 'character'
local name = 'Character'
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

  local function SkinReputationBars()
    local factionOffset = FauxScrollFrame_GetOffset(_G.ReputationListScrollFrame)
    local numFactions = GetNumFactions()

    for i = 1, _G.NUM_FACTIONS_DISPLAYED, 1 do
      local statusbar = _G["ReputationBar" .. i .. "ReputationBar"]
      local button = _G["ReputationBar" .. i .. "ExpandOrCollapseButton"]
      local bar = _G["ReputationBar" .. i]
      local factionIndex = factionOffset + i
      local _, _, _, _, _, _, _, _, _, isCollapsed = GetFactionInfo(factionIndex)
      if factionIndex <= numFactions then
        if button then
          if isCollapsed then
            button:SetNormalTexture(ns.GetTexture('expand'))
          else
            button:SetNormalTexture(ns.GetTexture('collapse'))
          end
        end
      end

      ns.Offset(statusbar,-3, 0)


    end
  end
  hooksecurefunc("ExpandFactionHeader", SkinReputationBars)
	hooksecurefunc("CollapseFactionHeader", SkinReputationBars)
	hooksecurefunc("ReputationFrame_Update", SkinReputationBars)

  local currencyHeaderTexLoc = {
    'categoryLeft', 'categoryMiddle', 'categoryRight', 'stripe'
  }


  local function SkinCurrencyButtons()
    local TokenFrameContainer = _G.TokenFrameContainer
    if not TokenFrameContainer.buttons then return end

    local buttons = TokenFrameContainer.buttons
    local numButtons = #buttons
    for i = 1, numButtons do
      local btn = buttons[i]

      for _, tex in ipairs(currencyHeaderTexLoc) do
        if btn[tex] then
          ns.StripTextures(btn[tex])
        end
      end

      if not btn.OofBackdrop then
        skins.AddBackdrop(btn)
        ns.Offset(btn.name, 0, -1)
      end

      if btn.check then
        btn.check:SetTexture(ns.GetTexture('checkmark'))
      end


      if btn.isHeader then
        btn.expandIcon:SetTexture(btn.isExpanded and ns.GetTexture('collapse') or ns.GetTexture('expand'))
        btn.expandIcon:SetTexCoord(.15,.85,.15,.85)
        btn.expandIcon:SetSize(12,12)
      end

    end
  end
  hooksecurefunc("TokenFrame_Update", SkinCurrencyButtons)
	hooksecurefunc(_G.TokenFrameContainer, "update", SkinCurrencyButtons)

  local function SkinFrame()
    local mainFrame = _G['CharacterFrame']
    StripTextures(texLoc, mainFrame)

    skins.AddBackdrop(mainFrame)
    skins.SkinPanelText(mainFrame.TitleText)
    ns.Offset(mainFrame.TitleText, 0, -5)
    mainFrame.portrait:SetAlpha(0)
    skins.SkinClose(mainFrame.CloseButton)

    local levelText = _G['CharacterLevelText']
    levelText:ClearAllPoints()
    levelText:SetPoint("TOPLEFT", -22, -17)

    skins.SkinPanelTabs('CharacterFrameTab%i', mainFrame.OofBackdrop,0,0)

    skins.SkinScrollBar(_G['ReputationListScrollFrame'])
    skins.SkinScrollBar(_G['TokenFrameContainer'])
    local factionOffset = FauxScrollFrame_GetOffset(_G.ReputationListScrollFrame)
    local numFactions = GetNumFactions()

    for i = 1, _G.NUM_FACTIONS_DISPLAYED, 1 do
      local statusbar = _G["ReputationBar" .. i .. "ReputationBar"]
      local button = _G["ReputationBar" .. i .. "ExpandOrCollapseButton"]
      local bar = _G["ReputationBar" .. i]
      local factionIndex = factionOffset + i
      local _, _, _, _, _, _, _, _, _, isCollapsed = GetFactionInfo(factionIndex)
      if factionIndex <= numFactions then
        if button then
          if isCollapsed then
            button:SetNormalTexture(ns.GetTexture('expand'))
          else
            button:SetNormalTexture(ns.GetTexture('collapse'))
          end
        end
      end

      skins.SkinStatusBar(statusbar)
      ns.StripTextures(_G['ReputationBar' .. i .. 'Background'])
      skins.AddBackdrop(bar)

      ns.Offset(statusbar,-3, 0)


    end

    -- Equipment

    local equipmentPane = _G['PaperDollEquipmentManagerPane']
    skins.SkinScrollBar(equipmentPane)

    skins.SkinButton(equipmentPane.EquipSet)
    skins.SkinButton(equipmentPane.SaveSet)

    SkinReputationBars()
    SkinCurrencyButtons()
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



