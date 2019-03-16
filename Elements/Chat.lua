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
    }
  }

  function obj:Refresh()
    local sC = db.container
    container:ClearAllPoints()
    container:SetSize(sC.width,sC.height)
    container:SetPoint(sC.point, sC.x, sC.y)


    for i, chatFrame in ipairs(CHAT_FRAMES) do
      local f = _G[chatFrame]
      f:ClearAllPoints()
      f:SetPoint("BOTTOMLEFT",container,0, db.tabPos == 'BOTTOM' and 21 or 0)
      f:SetPoint("TOPRIGHT",container, -23, db.tabPos == 'TOP' and -28 or 0)

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
      local fontName, size, flag = tab.Text:GetFont()
      tab.Text:SetFont(fontName, 12, flag)
      tab.Text:SetTextColor(1,1,1,1)
      tab.Text.SetTextColor = function() end

    end

    for _, frame in ipairs(chatFrames) do
      frame:setter()
    end



  end
  C_Timer.After(0.3, function() obj:Refresh() end)

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
        name = L['Hide Side Buttons'],
        type = 'toggle',
        get = function() return db.hideSideButtons end,
        set = function(self, value)
          db.hideSideButtons = value
          obj:Refresh()
        end
      },
      hideSocialButton = {
        order = 20,
        name = L['Hide Side Buttons'],
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
    }
  }

  opt.RegisterListItem(parentId, id, text, sortOrder, options)
end



