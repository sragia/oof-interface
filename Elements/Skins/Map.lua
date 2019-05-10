local addon, ns = ...
local L = ns.L
local key = 'map'
local name = 'Map'
local obj = ns.CreateNewModule("Skins_"..key)

ns.skins.RegisterSkin(key, name)

function obj:Initialize()
  local opt = ns.options
  local SF = ns.UIElements.defaultFunc
  local db = ns.DB.profile.skins[key]
  local skins = ns.skins

  local texLoc = {
    BlackoutFrame = {
      'Blackout'
    },
    BorderFrame = {
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
      'InsetBorderTop',
      'Underlay'
    },
    NavBar = {
      'InsetBorderBottom',
      'InsetBorderBottomLeft',
      'InsetBorderBottomRight',
      'InsetBorderRight',
      'InsetBorderLeft'
    },
    QuestLog = {
      'VerticalSeparator',
      QuestsFrame = {
        DetailFrame = {
          'TopDetail',
          'BottomDetail'
        }
      }
    }

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

  local function HideRegions(frame,upTo)
    local regions = {frame:GetRegions()}

    for i=1, upTo or #regions do
      regions[i]:Hide()
    end

  end

  local function SkinFrame()
    local mainFrame = _G['WorldMapFrame']


    if mainFrame:IsMaximized() then
      local width, height = GetScreenWidth(), GetScreenHeight()
      local calcHeight = height * 0.95
      local calcWidth = ( calcHeight - 67) * 1.497
      mainFrame:SetSize(calcWidth, calcHeight)
      mainFrame:ClearAllPoints()
      mainFrame:SetPoint('CENTER')
      mainFrame.ScrollContainer.Child.TiledBackground:Hide()
      mainFrame.BlackoutFrame:Hide()
    end

    mainFrame:SynchronizeDisplayState()

    mainFrame:OnFrameSizeChanged()

    StripTextures(texLoc, mainFrame)


    local borderFrame = mainFrame.BorderFrame

    borderFrame.portrait:SetAlpha(0)

    skins.SkinClose(borderFrame.CloseButton)
    skins.SkinPanelText(borderFrame.TitleText)
    skins.SkinHelpButton(borderFrame.Tutorial)

    skins.SkinMinMaxButton(borderFrame.MaximizeMinimizeFrame,borderFrame.CloseButton)
    ns.Offset(borderFrame.Tutorial, -20, 0)
    skins.AddBackdrop(mainFrame)

    -- NavBar
    local navBar = mainFrame.navBar
    HideRegions(navBar.overlay)
    HideRegions(navBar, 1)
    SF.ApplyBackdrop(navBar)

    navBar:ClearAllPoints()
    navBar:SetPoint("TOPLEFT", 5, -25)
    navBar:SetWidth(690)
    navBar.homeButton:ClearAllPoints()
    navBar.homeButton:SetPoint("LEFT", 2, 0)

    -- Quest Log
    local questLog = mainFrame.QuestLog

    skins.SkinScrollBar(questLog.QuestsFrame)


  end

  if db then
    -- C_Timer.After(0.3, SkinFrame)
    local frame = _G['WorldMapFrame']
    frame.OofSetPoint = frame.SetPoint
    frame.SetPoint = function(self,...)
      if frame:IsMaximized() then
        frame:OofSetPoint("CENTER")
      else
        frame:OofSetPoint(...)
      end
    end
    ns.ReplaceFunctions(frame.BlackoutFrame,{'Show'})
    UIPanelWindows['WorldMapFrame'].maximizePoint =  "CENTER" ;
    hooksecurefunc(frame,'HandleUserActionMinimizeSelf', SkinFrame)
    hooksecurefunc(frame,'HandleUserActionMaximizeSelf', SkinFrame)
    frame:HookScript('OnShow',SkinFrame)

    -- hooksecurefunc(_G['WorldMapFrame'],'OnShow', SkinFrame)
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



