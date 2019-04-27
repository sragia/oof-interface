local addon, ns = ...
local L = ns.L
local obj = ns.CreateNewModule("Elements_Chat")
local registeredSkins = {}
local UI = ns.UIElements


function obj:Initialize()
  local opt = ns.options
  local parentId = "elements"
  local id = "chat"
  local text = L['Chat']
  local sortOrder = 30
  local db = ns.DB.profile.chat
  local mover = ns.mover

  local container = CreateFrame('Frame','Oof_ChatContainer',UIParent)
  local iconDock = CreateFrame('Frame','Oof_ChatIconDock',container)
  iconDock:SetPoint("BOTTOMLEFT",container,"TOPLEFT")
  iconDock:SetPoint("BOTTOMRIGHT",container,"TOPRIGHT")
  iconDock:SetHeight(10)
  local dockIcons = {}

  local function RefreshIconDock()
    table.sort(dockIcons, function(a,b) return a.order < b.order end)

    local lastFrame
    for i = 1, #dockIcons do
      if lastFrame then
        dockIcons[i].frame:SetPoint("BOTTOMLEFT", lastFrame, "BOTTOMRIGHT", 3, 0)
      else
        dockIcons[i].frame:SetPoint("BOTTOMLEFT",iconDock);
      end
      lastFrame = dockIcons[i].frame
    end
  end

  local function AddIconToDock(name, frame, order)
    local found = false
    for i = #dockIcons, 1, -1 do
      dockIcons[i].frame:ClearAllPoints()
      if dockIcons[i].name == name then
        found = true
      end
    end
    if not found then
      frame:ClearAllPoints()
      table.insert(dockIcons, {name = name, frame = frame, order = order})
    end
    RefreshIconDock()
  end

  local function RemoveIconFromDock(name)
    for index, icon in ipairs(dockIcons) do
      if icon.name == name then
        table.remove(dockIcons, index)
        RefreshIconDock()
        return
      end
    end
  end


  _G['CHAT_FONT_HEIGHTS'] = { 6, 8, 10, 11, 12, 13, 14, 15, 16, 18, 20, 22, 24, 28}

  local chatFrames = {
    {
      frame = 'GeneralDockManager',
      hide = false,
      setter = function(self)
        local f = self.frameSaved or _G[self.frame]
        self.frameSaved = f
        f:ClearAllPoints()
        local pos = db.tabPos
        f:SetPoint(pos .. "LEFT",container)
        f:SetPoint(pos .. "RIGHT", container)
        f:SetHeight(25)
      end,
    },
    {
      frame = {'ChatFrameChannelButton','ChatFrameToggleVoiceDeafenButton', 'ChatFrameToggleVoiceMuteButton'},
      textures = {
        ['ChatFrameChannelButton'] = 'volume',
        ['ChatFrameToggleVoiceDeafenButton'] = 'headphones',
        ['ChatFrameToggleVoiceMuteButton'] = 'mic'
      },
      hide = false,
      ['ChatFrameChannelButton'] = function()
        local f = _G['ChatFrameChannelButton']
        ns.StripTextures(f)
        if not f.hooked then
          f:HookScript("OnEvent",function(self, event, value)
            if event == 'VOICE_CHAT_CHANNEL_DEACTIVATED' then
              f.Icon:OofSetTexture(ns.GetTexture('volume'))
              f.Icon:SetVertexColor(1,1,1,1)
            elseif event == 'VOICE_CHAT_CHANNEL_ACTIVATED' then
              f.Icon:OofSetTexture(ns.GetTexture('invoice'))
              f.Icon:SetVertexColor(0.65,0.88,0,1)
            end
          end)
          f:HookScript("OnLoad",function(self) self:OofRefresh() end)
          f.hooked = true
        end
        f.Icon:OofSetTexture(ns.GetTexture(C_VoiceChat.GetActiveChannelID() and 'invoice' or 'volume'))
        if C_VoiceChat.GetActiveChannelID() then
          f.Icon:SetVertexColor(0.65,0.88,0,1)
        end
      end,
      ['ChatFrameToggleVoiceDeafenButton'] = function()
        local f = _G['ChatFrameToggleVoiceDeafenButton']
        ns.StripTextures(f)
        if not f.hooked then
          f:HookScript("OnEvent",function(self, event, value)
            if event == 'VOICE_CHAT_DEAFENED_CHANGED' then
              f.Icon:OofSetTexture(ns.GetTexture(value and 'deafened' or 'headphones'))
            end
          end)
          f:HookScript("OnLoad",function(self) self:OofRefresh() end)
          f.hooked = true
        end
        f.Icon:OofSetTexture(ns.GetTexture(C_VoiceChat.IsDeafened() and 'deafened' or 'headphones'))
      end,
      ['ChatFrameToggleVoiceMuteButton'] = function()
        local f = _G['ChatFrameToggleVoiceMuteButton']
        ns.StripTextures(f)
        if not f.hooked then
          f:HookScript("OnEvent",function(self, event, value)
            if event == 'VOICE_CHAT_MUTED_CHANGED' then
              f.Icon:OofSetTexture(ns.GetTexture(value and 'muted' or 'mic'))
            end
          end)
          f:HookScript("OnLoad",function(self) self:OofRefresh() end)
          f.hooked = true
        end
        f.Icon:OofSetTexture(ns.GetTexture(C_VoiceChat.IsMuted() and 'muted' or 'mic'))
      end,
      setter = function(self)
        local hide = db.hideChatChannelButton
        local voiceContainer = self.container or CreateFrame('Frame',"VoiceContainer",UIParent)
        self.container = voiceContainer

        voiceContainer:Show()
        local prevFrame
        local width = 0
        for _, frameName in ipairs(self.frame) do
          local f = _G[frameName]
          ns.StripTextures(f)
          ns.ReplaceFunctions(f,{'SetHighlight'})
          ns.ReplaceFunctions(f.Icon,{'SetTexture'})
          f.SetAtlas = function() end
          f.Icon:OofSetTexture(ns.GetTexture(self.textures[frameName]))
          f.Icon:SetAlpha(0.95)
          f.Icon:ClearAllPoints()
          ns.InsetFrame(f.Icon,f,3)
          self[frameName]()
          f.OofRefresh = self[frameName]()
          f:ClearAllPoints()
          f:SetParent(voiceContainer)
          f:SetPoint("BOTTOMLEFT", prevFrame or voiceContainer,prevFrame and "BOTTOMRIGHT" or "BOTTOMLEFT",0, 1)
          prevFrame = f
          width = width + f:GetWidth()
        end
        voiceContainer:SetSize(width, 1)
        if hide then
          RemoveIconFromDock('VoiceContainer')
          voiceContainer:Hide()
          return
        end
        AddIconToDock('VoiceContainer', voiceContainer, 10)
      end
    },
    {
      frame = 'QuickJoinToastButton',
      hide = false,
      setter = function(self)
        local f = _G[self.frame]
        if db.hideSocialButton then
          RemoveIconFromDock(self.frame)
          f:Hide()
        else
          f:Show()
          AddIconToDock(self.frame, f, 0)
          local btnTex = f.FriendsButton
          ns.ReplaceFunctions(btnTex,{'SetTexture','SetAtlas'})
          btnTex:OofSetTexture(ns.GetTexture('person'))
          f:SetHighlightTexture(nil)
          local frndCount = f.FriendCount

          btnTex:ClearAllPoints()
          btnTex:SetPoint('TOPLEFT',2,-2)
          btnTex:SetPoint("BOTTOMRIGHT",-2,2)
          frndCount:ClearAllPoints()
          frndCount:SetPoint("BOTTOM",1,3)

        end
      end
    }
  }

  function obj:Refresh()
    local sC = db.container
    container:ClearAllPoints()
    container:SetSize(sC.width,sC.height)
    container:SetPoint(sC.point, sC.x, sC.y)


    for i, chatFrame in ipairs(CHAT_FRAMES) do
      local f = _G[chatFrame]
      local isCombat = f.CombatLogQuickButtonFrame
      f:ClearAllPoints()
      if not f.SetCustomPoint then
        f.SetCustomPoint = f.SetPoint
        f.SetPoint = function() end
      end
      f:SetCustomPoint("BOTTOMLEFT",container,0, db.tabPos == 'BOTTOM' and 21 or 0)
      f:SetCustomPoint("TOPRIGHT",container, -23, db.tabPos == 'TOP' and (isCombat and -52 or -28) or (isCombat and -24 or 0) )

      f.Background:ClearAllPoints()
      f.Background:SetAllPoints()

      f.FontStringContainer:ClearAllPoints()
      f.FontStringContainer:SetAllPoints()

      f.ScrollToBottomButton:ClearAllPoints()
      f.ScrollToBottomButton:SetPoint("BOTTOMLEFT",f, "BOTTOMRIGHT", 1, -2)
      f.ScrollBar:ClearAllPoints();
      f.ScrollBar:SetPoint("TOPLEFT",f, "TOPRIGHT", 2, 0)
      f.ScrollBar:SetPoint("BOTTOM",f.ScrollToBottomButton,"TOP")

      f:SetClampRectInsets(0,0,0,0)

      local id = f:GetID();
      local _, fontSize = FCF_GetChatWindowInfo(id);

      f:SetFont(ns.LSM:Fetch('font',db.font),fontSize,db.flag)

      -- tab
      local tab = _G[chatFrame .. 'Tab']
      for _, tex in ipairs({'left','middle','right'}) do
        tab[tex..'HighlightTexture']:SetTexture(nil)
        tab[tex..'SelectedTexture']:SetTexture(nil)
        tab[tex..'Texture']:SetTexture(nil)
      end
      local fontName = ns.LSM:Fetch('font',db.tabFont)
      tab.Text:SetFont(fontName, db.tabFontSize, db.tabFontFlag)
      if not tab.Text.SetCustomTextColor then
        local originalTextColor = tab.Text.SetTextColor
        tab.Text.SetCustomTextColor = originalTextColor
        tab.Text.SetTextColor = function() end
      end
      tab.Text:SetCustomTextColor(unpack(db.tabFontColor))

    end

    for _, frame in ipairs(chatFrames) do
      frame:setter()
    end



  end
  C_Timer.After(0.3, function() obj:Refresh() end)

  hooksecurefunc("FCF_Tab_OnClick",function() obj:Refresh() end)
  hooksecurefunc("FCF_DockUpdate", function() obj:Refresh() end)

  local function Move(left, bottom)
    db.container.x = left
    db.container.y = bottom
    db.container.point = "BOTTOMLEFT"
    obj:Refresh()
  end

  mover.CreateMovableElement(L['Chat'], container, Move)

  -- OPTIONS CONFIG --
  local options = {
    type = "group",
    name = addon,
    args = {
      Chat ={
        order = 1,
        name = L['Chat'],
        type = "description",
        width = "full",
        fontSize = "large"
      },
      chatWidth = {
        type = 'range',
        name = L['Width'],
        order = 2,
        max = 1000,
        min = 200,
        step = 1,
        get = function() return db.container.width end,
        set = function(self, width)
          db.container.width = width
          obj:Refresh()
        end,
      },
      chatHeight = {
        type = 'range',
        name = L['Height'],
        order = 3,
        max = 1000,
        min = 100,
        step = 1,
        get = function() return db.container.height end,
        set = function(self, height)
          db.container.height = height
          obj:Refresh()
        end,
      },
      hideSideButtons = {
        order = 10,
        name = L['Hide Voice Buttons'],
        type = 'toggle',
        get = function() return db.hideChatChannelButton end,
        set = function(self, value)
          db.hideChatChannelButton = value
          obj:Refresh()
        end
      },
      hideSocialButton = {
        order = 20,
        name = L['Hide Social Button'],
        type = 'toggle',
        get = function() return db.hideSocialButton end,
        set = function(self, value)
          db.hideSocialButton = value
          obj:Refresh()
        end
      },
      tabPos = {
        order = 30,
        name = L['Tabs position'],
        type = 'select',
        values = {
          TOP = L['Top'],
          BOTTOM = L['Bottom']
        },
        get = function() return db.tabPos end,
        set = function(self, value)
          db.tabPos = value
          obj:Refresh()
        end
      },
      editPos = {
        order = 40,
        name = L['Edit Position'],
        type = 'select',
        values = {
          TOP = L['Top'],
          BOTTOM = L['Bottom']
        },
        get = function() return db.editPos end,
        set = function(self, value)
          db.editPos = value
          obj:Refresh()
        end
      },
      font = {
        type = 'select',
        order = 50,
        dialogControl = 'LSM30_Font',
        name = L['Font'],
        values = ns.LSM:HashTable('font'),
        get = function()
          return db.font
        end,
        set = function(self, key)
          db.font = key
          obj:Refresh()
        end
      },
      fontFlag = {
        type = 'select',
        order = 60,
        name = L['Font Outline'],
        values = {
          NONE = L['None'],
          OUTLINE = L['Outline'],
          THICKOUTLINE = L['Thick'],
          MONOCHROME = L['Monochrome']
        },
        get = function() return db.flag end,
        set = function(self, key)
          db.flag = key
          obj:Refresh()
        end,
      },
      tabfont = {
        type = 'select',
        order = 70,
        dialogControl = 'LSM30_Font',
        name = L['Tab Font'],
        values = ns.LSM:HashTable('font'),
        get = function()
          return db.tabFont
        end,
        set = function(self, key)
          db.tabFont = key
          obj:Refresh()
        end
      },
      tabFontSize = {
        type = 'range',
        min = 6,
        max = 30,
        step = 1,
        minStep = 1,
        order = 80,
        name = L['Tab Font Size'],
        get = function() return db.tabFontSize end,
        set = function(self, value)
          db.tabFontSize = value
          obj:Refresh();
        end
      },
      tabfontFlag = {
        type = 'select',
        order = 90,
        name = L['Tab Font Outline'],
        values = {
          NONE = L['None'],
          OUTLINE = L['Outline'],
          THICKOUTLINE = L['Thick'],
          MONOCHROME = L['Monochrome']
        },
        get = function() return db.tabFontFlag end,
        set = function(self, key)
          db.tabFontFlag = key
          obj:Refresh()
        end,
      },
      tabFontColor = {
        type = 'color',
        order = 100,
        name = L['Tab Font Color'],
        hasAlpha = true,
        get = function() return unpack(db.tabFontColor) end,
        set = function(self,r,g,b,a)
          db.tabFontColor = {r,g,b,a}
          obj:Refresh()
        end
      },
    }
  }

  opt.RegisterListItem(parentId, id, text, sortOrder, options)
end



