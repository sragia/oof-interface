local addon, ns = ...
local L = ns.L
local key = 'groupfinder'
local name = 'Group Finder'
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
    local mainFrame = _G['PVEFrame']

    -- Portrait
    mainFrame.portrait:SetAlpha(0)

    -- Strip Textures
    StripTextures(texLoc, mainFrame)

    local textures = {
      'PVEFrameTopFiligree',
      'PVEFrameBottomFiligree',
      'PVEFrameBlueBg',
      'PVEFrameBLCorner',
      'PVEFrameBRCorner',
      'PVEFrameLLVert',
      'PVEFrameRLVert',
      'PVEFrameTLCorner',
      'PVEFrameTRCorner',
      'PVEFrameTopLine',
      'PVEFrameBottomLine',
    }
    for i=1, #textures do ns.StripTextures(_G[textures[i]]) end

    ns.StripTextures(_G['PVEFrameLeftInset'].Bg)

    ns.StripTextures(_G['PVEFrameBlueBg'])

    for _, tex in pairs({mainFrame.shadows:GetRegions()}) do
      ns.StripTextures(tex)
    end



    -- Background
    ns.skins.AddBackdrop(mainFrame)

    -- Close Btn
    ns.skins.SkinClose(mainFrame.CloseButton)

    -- Title Text
    ns.skins.SkinPanelText(mainFrame.TitleText)

    -- LFR
    ns.skins.SkinButton(_G['RaidFinderFrameFindRaidButton'])

    -- LFD
    ns.skins.SkinButton(_G['LFDQueueFrameFindGroupButton'])
    local lfdParent = _G['LFDParentFrame']
    local lfdTexs = {
      Inset = {
        NineSlice = {
          'BottomEdge',
          'BottomLeftCorner',
          'BottomRightCorner',
          'LeftEdge',
          'RightEdge',
          'TopEdge',
          'TopLeftCorner',
          'TopRightCorner'
        },
        'Bg'
      }
    }
    StripTextures(lfdTexs, lfdParent)
    ns.StripTextures(_G['LFDQueueFrameBackground'])
    ns.ReplaceFunctions(_G['LFDQueueFrameBackground'], {'SetTexture'})

    ns.skins.SkinScrollBar(_G['LFDQueueFrameSpecificListScrollFrame'])

    for i = 1, _G.NUM_LFD_CHOICE_BUTTONS do
      ns.skins.SkinCheckbox(_G["LFDQueueFrameSpecificListButton"..i].enableButton)
    end

    hooksecurefunc("LFGDungeonListButton_SetDungeon", function(button)
      if button and button.expandOrCollapseButton:IsShown() then
        if button.isCollapsed then
          button.expandOrCollapseButton:SetNormalTexture(ns.GetTexture('expand'));
        else
          button.expandOrCollapseButton:SetNormalTexture(ns.GetTexture('collapse'));
        end
      end
    end)

    ns.StripTextures(_G['LFDParentFrameRoleBackground'])

    -- Role Checkmarks
    local roleButtons = {
      'DPS',
      'Healer',
      'Tank',
      'Leader'
    }
    for i=1, #roleButtons do
      ns.skins.SkinCheckbox(_G['LFDQueueFrameRoleButton' .. roleButtons[i]].checkButton)
      ns.skins.SkinCheckbox(_G['RaidFinderQueueFrameRoleButton' .. roleButtons[i]].checkButton)
    end

    ns.skins.SkinDropdown(_G['LFDQueueFrameTypeDropDown'])

    -- Raid Finder
    ns.StripTextures(_G['RaidFinderFrameRoleBackground'])
    _G['RaidFinderFrame'].Inset:Hide()

    ns.skins.SkinDropdown(_G['RaidFinderQueueFrameSelectionDropDown'])

    ns.StripTextures(_G['RaidFinderQueueFrameBackground'])
    ns.ReplaceFunctions(_G['RaidFinderQueueFrameBackground'], {'SetTexture'})
    local lfrTexs = {
      NineSlice = {
        'BottomEdge',
        'BottomLeftCorner',
        'BottomRightCorner',
        'LeftEdge',
        'RightEdge',
        'TopEdge',
        'TopLeftCorner',
        'TopRightCorner'
      },
      'Bg'
    }
    StripTextures(lfrTexs, _G['RaidFinderFrameBottomInset'])

    -- LFG List
    local lfgList = _G['LFGListFrame']
    ns.skins.SkinButton(lfgList.CategorySelection.FindGroupButton)
    ns.skins.SkinButton(lfgList.CategorySelection.StartGroupButton)
    local lfgListTexs = {
      CategorySelection = {
        Inset = {
          'Bg',
          'CustomBG',
          NineSlice = {
            'BottomEdge',
            'BottomLeftCorner',
            'BottomRightCorner',
            'LeftEdge',
            'RightEdge',
            'TopEdge',
            'TopLeftCorner',
            'TopRightCorner'
          },
        }
      },
      EntryCreation = {
        Inset = {
          'Bg',
          'CustomBG',
          NineSlice = {
            'BottomEdge',
            'BottomLeftCorner',
            'BottomRightCorner',
            'LeftEdge',
            'RightEdge',
            'TopEdge',
            'TopLeftCorner',
            'TopRightCorner'
          },
        }
      },
      SearchPanel = {
        ResultsInset = {
          'Bg',
          NineSlice = {
            'BottomEdge',
            'BottomLeftCorner',
            'BottomRightCorner',
            'LeftEdge',
            'RightEdge',
            'TopEdge',
            'TopLeftCorner',
            'TopRightCorner'
          },
        }
      }
    }
    StripTextures(lfgListTexs, lfgList)

    -- Create Group Frame
    local entryCreation = lfgList.EntryCreation
    ns.skins.SkinDropdown(entryCreation.ActivityDropDown)
    ns.skins.SkinDropdown(entryCreation.CategoryDropDown)
    ns.skins.SkinDropdown(entryCreation.GroupDropDown)

    ns.skins.SkinCheckbox(entryCreation.ItemLevel.CheckButton)
    ns.skins.SkinCheckbox(entryCreation.VoiceChat.CheckButton)
    ns.skins.SkinCheckbox(entryCreation.PrivateGroup.CheckButton)

    ns.skins.SkinInput(entryCreation.Name)
    ns.skins.SkinInput(entryCreation.ItemLevel.EditBox)
    ns.skins.SkinInput(entryCreation.VoiceChat.EditBox)

    ns.skins.SkinDescription(entryCreation.Description)


    local p, rt, rp, x, y = entryCreation.Description:GetPoint()

    entryCreation.Description:ClearAllPoints()
    entryCreation.Description:SetPoint(p, rt, rp, x - 5, -185)
    entryCreation.Description:SetWidth(290)

    p, rt, rp, x, y = entryCreation.Name:GetPoint()

    entryCreation.Name:ClearAllPoints()
    entryCreation.Name:SetPoint(p, rt, rp, x - 5, y)
    entryCreation.Name:SetWidth(290)


    ns.skins.SkinButton(entryCreation.CancelButton)
    ns.skins.SkinButton(entryCreation.ListGroupButton)


    -- Search List
    local searchPanel = lfgList.SearchPanel

    ns.skins.SkinSearch(searchPanel.SearchBox)

    searchPanel.SearchBox:SetHeight(22)


    ns.skins.SkinButton(searchPanel.SignUpButton)
    ns.skins.SkinButton(searchPanel.BackButton)

    ns.skins.SkinMenuButton(searchPanel.FilterButton)
    searchPanel.FilterButton.Icon:SetTexture(ns.GetTexture('arrow_right'))

    ns.skins.SkinButton(searchPanel.RefreshButton)
    searchPanel.RefreshButton.Icon:SetTexture(ns.GetTexture('refresh'))
    ns.ReplaceFunctions(searchPanel.RefreshButton.Icon,{"SetTexture"})

    ns.skins.SkinScrollBar(searchPanel.ScrollFrame)

    -- Tabs
    ns.skins.SkinPanelTabs('PVEFrameTab%i',mainFrame.OofBackdrop)

  end

  local function SkinHonorFrame()
     -- PvP Frame
     local honorFrame = _G['HonorFrame']
     ns.skins.SkinButton(honorFrame.QueueButton)
     ns.skins.SkinCheckbox(honorFrame.TankIcon.checkButton)
     ns.skins.SkinCheckbox(honorFrame.HealerIcon.checkButton)
     ns.skins.SkinCheckbox(honorFrame.DPSIcon.checkButton)

     local dropdown = _G['HonorFrameTypeDropDown']
     ns.skins.SkinDropdown(dropdown)

     local conquestFrame = _G['ConquestFrame']
     ns.skins.SkinButton(conquestFrame.JoinButton)
     ns.skins.SkinCheckbox(conquestFrame.TankIcon.checkButton)
     ns.skins.SkinCheckbox(conquestFrame.HealerIcon.checkButton)
     ns.skins.SkinCheckbox(conquestFrame.DPSIcon.checkButton)


  end
  if db then
    C_Timer.After(0.5,SkinFrame)

    local frame = CreateFrame("Frame")
    frame:RegisterEvent("ADDON_LOADED")
    frame:SetScript("OnEvent", function(self, event, addonName)
      print(addonName)
      if addonName == 'Blizzard_PVPUI' then
        SkinHonorFrame()
      end
      -- if addonName == 'Blizzard_EncounterJournal' then
      --   SkinFrame()
      --   frame:UnregisterEvent("ADDON_LOADED")
      -- end
    end)
  end
  function obj:Refresh()
    ns.ReloadPopup()
  end

end



