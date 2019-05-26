local addon, ns = ...
local L = ns.L
local key = 'communities'
local name = 'Communities'
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
    CommunitiesList = {
      'Bg',
      'BottomFiligree',
      'FiligreeOverlay',
      'TopFiligree',
      InsetFrame = {
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
      },
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
      },
    },
    PortraitOverlay = {
      'Portrait',
      'CircleMask',
      'TabardBackground',
      'TabardBorder',
      'TabardEmblem'
    },
    Chat = {
      InsetFrame = {
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
      }
    },
    MemberList = {
      InsetFrame = {
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
      },
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

  local function SkinFrame()
    local mainFrame = _G['CommunitiesFrame']

    StripTextures(texLoc, mainFrame)

    mainFrame.NineSlice:Hide()
    mainFrame.PortraitOverlay:SetAlpha(0)
    mainFrame.portrait:SetAlpha(0)

    skins.AddBackdrop(mainFrame)

    skins.SkinPanelText(mainFrame.TitleText)
    skins.SkinMinMaxButton(mainFrame.MaximizeMinimizeFrame,mainFrame.CloseButton)
    skins.SkinClose(mainFrame.CloseButton)
    skins.SkinButton(mainFrame.InviteButton)
    ns.Offset(mainFrame.InviteButton, 0, -2)

    skins.SkinScrollBar(mainFrame.Chat.MessageFrame)
    mainFrame.Chat.MessageFrame.ScrollBar:SetWidth(14)
    ns.Offset(mainFrame.Chat.MessageFrame.ScrollBar, -3, 1)

    skins.SkinInput(mainFrame.ChatEditBox)
    mainFrame.ChatEditBox:SetHeight(25)

    local communitiesList = mainFrame.CommunitiesList
    skins.SkinScrollBar(communitiesList.ListScrollFrame)
    communitiesList.ListScrollFrame.ScrollBar:SetWidth(14)
    ns.Offset(communitiesList.ListScrollFrame.ScrollBar, 4, 0)
    skins.FindAndSkinBlueMenu(communitiesList)
    skins.AddBackdrop(communitiesList)

    communitiesList.OofBackdrop:SetPoint("TOPLEFT", 0, -1)
    communitiesList.OofBackdrop:SetPoint("BOTTOMRIGHT", 0, -3)
    communitiesList:ClearAllPoints()
    communitiesList:SetPoint("TOPLEFT", 5, -23)
    communitiesList:SetPoint('BOTTOMRIGHT', mainFrame, 'BOTTOMLEFT', 180, 25)


    skins.SkinDropdown(mainFrame.StreamDropDownMenu)
    mainFrame.StreamDropDownMenu:SetPoint("TOPLEFT", 195, -23)
    ns.ReplaceFunctions(mainFrame.StreamDropDownMenu, {'SetPoint'})
    mainFrame.StreamDropDownMenu.SetPoint = function(self, p, rt, rp, x, y)
      self:OofSetPoint('TOPLEFT', 200, -21)
    end

    local memberList = mainFrame.MemberList
    skins.AddBackdrop(memberList)
    skins.SkinScrollBar(memberList.ListScrollFrame)
    memberList.ListScrollFrame.scrollBar:SetWidth(14)
    ns.Offset(memberList.ListScrollFrame.scrollBar, 3, 1)

  end

  if db then

  local frame = CreateFrame("Frame")
  frame:RegisterEvent("ADDON_LOADED")
  frame:SetScript("OnEvent", function(self, event, addonName)
    if addonName == 'Blizzard_Communities' then
      SkinFrame()
      frame:UnregisterEvent("ADDON_LOADED")
    end
  end)
  end
  function obj:Refresh()
    ns.ReloadPopup()
  end

end



