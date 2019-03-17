local addon, ns = ...
local L = ns.L
local obj = ns.CreateNewModule("Elements_Minimap")

function obj:Initialize()
  local opt = ns.options
  local mover = ns.mover
  local parentId = "elements"
  local id = "minimap"
  local text = "Minimap"
  local sortOrder = 10
  local db = ns.DB.profile.minimap
  local M = _G.Minimap
  local UIElements = ns.UIElements

  function obj:Resize()
    M:SetSize(db.size, db.size)
    if db.shape == "rectangle" then
      local w, h = strsplit("x",db.aspect or "1x1")
      w = tonumber(w)
      h = tonumber(h)
      local left, right, top, bottom = 0,0,0,0
      if w > h then
        top = (db.size - (db.size / (w / h))) / 2
        bottom = top
      elseif w < h then
        left = (db.size - (db.size / (h / w))) / 2
        right = left
      end
      Minimap:SetHitRectInsets(left, right, top, bottom)
      Minimap:SetClampRectInsets(-left, -right, -top, -bottom)
    end
  end

  local shapeMasks = {
    rectangle = [[Interface\AddOns\Oof\Media\Textures\Square_White]],
    round = [[Interface\AddOns\Oof\Media\Textures\circle_white]],
    hexagon = [[Interface\AddOns\Oof\Media\Textures\hexagon_white]],
    diamond = [[Interface\AddOns\Oof\Media\Textures\diamond_white]],
  }
  local aspects = {
    ["1x1"] = [[Interface\AddOns\Oof\Media\Minimap\aspect1x1]],
    ["3x1"] = [[Interface\AddOns\Oof\Media\Minimap\aspect3x1]],
    ["2x1"] = [[Interface\AddOns\Oof\Media\Minimap\aspect2x1]],
    ["4x3"] = [[Interface\AddOns\Oof\Media\Minimap\aspect4x3]],
    ["1x3"] = [[Interface\AddOns\Oof\Media\Minimap\aspect1x3]],
    ["1x2"] = [[Interface\AddOns\Oof\Media\Minimap\aspect1x2]],
    ["3x4"] = [[Interface\AddOns\Oof\Media\Minimap\aspect3x4]],
  }
  function obj:Reshape()
    if db.shape == "rectangle" then
      local aspect = db.aspect or "1x1"
      M:SetMaskTexture(aspects[aspect])
      M.bg:SetAspectRatio(aspect)
    else
      M:SetMaskTexture(shapeMasks[db.shape])
      M.bg:SetScaledTexture(shapeMasks[db.shape])
    end
  end

  local function Move(left,bottom)
    db.left = left or db.left
    db.bottom = bottom or db.bottom
    M:ClearAllPoints()
    M:SetPoint("TOPLEFT",UIParent,"BOTTOMLEFT",db.left,db.bottom + db.size)
  end
  local left, bottom = M:GetRect()
  db.left = db.left or left
  db.bottom = db.bottom or bottom
  Move()

  mover.CreateMovableElement(L['Minimap'], M, Move)

  local function GetMinimapLeftBottom(point)
    local left, bottom = 0, 0

    if db.shape == 'rectangle' then
      local aspect = db.aspect
      local w,h = strsplit('x',aspect)
      local calcLeft = w < h and  (db.size - (db.size / (h / w))) / 2 or 0
      local calcBottom = w > h and (db.size - (db.size / (w / h))) / 2 or 0
      if point and point:find('TOP') then
        bottom = -calcBottom
      elseif point and point:find('BOTTOM') then
        bottom = calcBottom
      end
      if point and point:find('RIGHT') then
        left = -calcLeft
      elseif point and point:find('LEFT') then
        left = calcLeft
      end
    end
    return left, bottom
  end

  local function GetXYOffsetOptions(frameName)
    local t = {
      {
        order = 19,
        name = L["X Offset"],
        type = "range",
        min = -400,
        max = 400,
        step = 1,
        get = function()
          return db.elements[frameName].x
        end,
        set = function(self, x)
          db.elements[frameName].x = x
          obj:SkinMinimap()
        end,
      },
      {
        order = 20,
        name = L["Y Offset"],
        type = "range",
        min = -400,
        max = 400,
        step = 1,
        get = function() return db.elements[frameName].y end,
        set = function(self, y)
          db.elements[frameName].y = y
          obj:SkinMinimap()
        end,
      },
      {
        type = 'select',
        values = ns.defaults.points,
        name = L['Anchor Point'],
        set = function(_, value)
          db.elements[frameName].point = value
          obj:Refresh()
        end,
        get = function() return db.elements[frameName].point end,
        order = 1,
      },
    }
    return t
  end

  local function GetFontOptions(frameName)
    local t = {
      {
        type = 'select',
        order = 17,
        dialogControl = 'LSM30_Font',
        name = L['Font'],
        values = ns.LSM:HashTable('font'),
        get = function()
          return db.elements[frameName].font
        end,
        set = function(self, key)
          db.elements[frameName].font = key
          obj:Refresh()
        end
      },
      {
        name = L['Font Size'],
        order = '18',
        type = 'range',
        min = 5,
        max = 60,
        step = 1,
        get = function()
          return db.elements[frameName].fontSize
        end,
        set = function(self, x)
          db.elements[frameName].fontSize = x
          obj:Refresh()
        end,
      },
    }
    return t
  end

  local function BasicSetter(self)
    local f = _G[self.frame]
    local saved = db.elements[self.frame]
    local shape = db.shape
    local aspect = db.aspect
    local X, Y = saved.x, saved.y
    local left, top = GetMinimapLeftBottom(saved.point)
    X = X + left
    Y = Y + top
    f:ClearAllPoints()
    f:SetPoint(saved.point,X, Y)
  end

  local onHoverFunctions = {}
  local onLeaveFunction = {}
  M:SetScript('OnEnter',function()
    for _, func in ipairs(onHoverFunctions) do func() end
  end)
  M:SetScript('OnLeave',function()
    for _, func in ipairs(onLeaveFunction) do func() end
  end)

  local minimapFrames = {
    {
      frame = "MinimapZoomOut",
      hide = true,
    },
	  {
      frame = "MinimapZoomIn",
      hide = true,
    },
    {
      frame = "MiniMapWorldMapButton",
      hide = true,
    },
    {
      frame = "MinimapZoneTextButton",
      hide = true,
    },
    {
      frame = "MiniMapMailBorder",
      hide = true,
    },
    {
      frame = "MiniMapInstanceDifficulty",
      hide = false,
      setter = BasicSetter,
      hasXY = true,
      init = function(self)
        _G[self.frame]:SetParent(M)
      end,
      optionsName = L['Instance Difficulty'],
      options = {
      }
    },
    {
      frame = "MinimapNorthTag",
      hide = false,
      point = "TOP"
    },
    {
      frame = "MinimapBackdrop",
      hide = true,
    },
    {
      frame = "GameTimeFrame",
      hide = false,
      setter = BasicSetter,
      hasXY = true,
      optionsName = L['Calendar'],
      options = {
      }
    },
    {
      frame = "GuildInstanceDifficulty",
      hide = false,
      setter = function() end,
    },
    {
      frame = "MiniMapChallengeMode",
      hide = true,
    },
    {
      frame = "MinimapBorderTop",
      hide = true,
    },
    {
      frame = "MinimapBorder",
      hide = true,
    },
    {
      frame = "MiniMapTracking",
      hide = false,
    },
    {
      frame = "TimeManagerClockButton",
      hide = true,
    },
    {
      frame = 'OofMinimapClock',
      init = function(self)
        local f = UIElements.CreateFrame('Text',self.frame,M)
        f:SetScript("OnMouseDown",function()
          TimeManager_Toggle()
        end)
        local lastCheck = 0
        f:SetScript("OnUpdate",function(self)
          local t = time()
          if (t - lastCheck >= 30) then
            lastCheck = t
            local isLocal = GetCVar('timeMgrUseLocalTime') == "1"
            local is24h = GetCVar('timeMgrUseMilitaryTime') == "1"
            local formatedString = ""
            t = isLocal and t or GetServerTime()
            local hour = is24h and date('%H',t) or date('%I', t)
            local minute = date('%M',t)
            formatedString = string.format("%02d:%02d",hour,minute)
            self:SetText(formatedString)
          end
        end)
        M.clock = f
      end,
      setter = function(self)
        local f = M.clock
        local saved = db.elements[self.frame]
        f:ClearAllPoints()
        local left, bottom = GetMinimapLeftBottom(saved.point)
        f:SetPoint(saved.point,left + saved.x,bottom + saved.y)
        f:SetSize(50,25);
        f:SetFont(ns.LSM:Fetch('font',saved.font),saved.fontSize,'OUTLINE')
      end,
      hide = false,
      optionsName = L['Clock'],
      options = {
      },
      hasXY = true,
      hasFontOptions = true,
    },
    {
      frame = 'OofMinimapZoneText',
      init = function(self)
        local f = UIElements.CreateFrame("Text", self.frame, M)
        table.insert(onHoverFunctions, function()
          f:Show()
          f:SetText('Zone')
        end)
        table.insert(onLeaveFunction, function()
          f:Hide()
        end)
        M.zoneText = f
        f:Hide()
      end,
      setter = function(self)
        BasicSetter(self)
        local saved = db.elements[self.frame]
        local f = _G[self.frame]
        f:SetFont(ns.LSM:Fetch('font',saved.font),saved.fontSize,'OUTLINE')
        f:SetSize(80, 25)
      end,
      hasXY = true,
      hasFontOptions = true,
      optionsName = L['Zone Text'],
      options = {
      },
    }
  }

  for _, info in ipairs(minimapFrames) do
    if info.init then
      info:init()
    end
  end

  if not IsAddOnLoaded("Blizzard_TimeManager") then
    LoadAddOn('Blizzard_TimeManager')
  end

  function obj:SkinMinimap()
    local bg = M.bg or CreateFrame("Frame",nil, UIParent)
    local tex = bg.texture or bg:CreateTexture(nil, "OVERLAY")
    bg.texture = tex
    tex:SetAllPoints()
    tex:SetTexture([[Interface\AddOns\Oof\Media\Minimap\aspect1x1]])
    tex:SetSnapToPixelGrid(false)
    tex:SetTexelSnappingBias(0)
    function bg:SetScaledTexture(tex,aspect)
      self.texture:SetTexture(tex)
      self.texture:ClearAllPoints()
      self.texture:SetVertexColor(0,0,0,1)
      self.texture:SetAllPoints()
      self:SetBackdrop(nil)
    end
    function bg:SetAspectRatio(aspect)
      self.texture:SetTexture(nil)
      local w, h = strsplit('x',aspect)
      local size = db.size
      local width = w > h and size or size / (h / w)
      local height = h > w and size or size / (w / h)
      self:ClearAllPoints()
      self:SetPoint("TOPLEFT",M,(size - width ) / 2 - 1,-1 * (size - height) / 2 + 1)
      self:SetPoint("BOTTOMRIGHT",M,Round( -1 * (size - width) / 2 + 1),(size - height) / 2 )
      self:SetBackdrop(ns.defaults.backdrop)
      self:SetBackdropColor(0,0,0,1)
      self:SetBackdropBorderColor(0,0,0,1)
    end
    bg:SetPoint("TOPLEFT",M,-1,1)
    bg:SetPoint("BOTTOMRIGHT",M, 1, -1)
    local frameStrata, frameLevel = M:GetFrameStrata(), M:GetFrameLevel()
    bg:SetFrameStrata(frameStrata)
    bg:SetFrameLevel(0)
    M.bg = bg

    -- Zoom
    M:SetScript('OnMouseWheel', function(self, delta)
      if delta > 0 then
        MinimapZoomIn:Click()
      elseif delta < 0 then
        MinimapZoomOut:Click()
      end
    end)

    -- frames
    for _, f in ipairs(minimapFrames) do
      if f.hide and _G[f.frame] then
        _G[f.frame]:Hide()
      elseif f.setter then
        f:setter()
      end
    end

    -- my frames

    obj:Reshape()
  end

  function obj:Refresh()
    self:SkinMinimap()
    self:Resize()
  end
  obj:Refresh()
  C_Timer.After(0.2,function() obj:Refresh() end)


  -- OPTIONS CONFIG --
  local options = {
    type = "group",
    name = "Minimap",
    args = {
      shape = {
        order = 0,
        name = L["Shape"],
        type = "select",
        values = {
          rectangle = L['Rectangle'],
          round = L['Round'],
          hexagon = L['Hexagon'],
          diamond = L['Diamond'],
        },
        get = function() return db.shape end,
        set = function(self, value)
          db.shape = value
          obj:Refresh()
        end,
      },
      aspect = {
        order = 5,
        name = L["Aspect Ration"],
        type = "select",
        values = {
          ["1x1"] = [[1x1]],
          ["3x1"] = [[3x1]],
          ["2x1"] = [[2x1]],
          ["4x3"] = [[4x3]],
          ["1x3"] = [[1x3]],
          ["1x2"] = [[1x2]],
          ["3x4"] = [[3x4]],
        },
        disabled = function() return db.shape ~= 'rectangle' end,
        get = function() return db.aspect end,
        set = function(self, value)
          db.aspect = value
          obj:Refresh()
        end,
      },
      size = {
        order = 10,
        name = L["Size"],
        type = "range",
        min = 0,
        max = 1200,
        step = 1,
        get = function() return db.size end,
        set = function(self, size)
          db.size = size
          obj:Refresh()
        end,
      },
      elements = {
        order = 100,
        name = L["Elements"],
        type = "description",
        width = "full",
        fontSize = "large",
      }
    }
  }
  local elementOrder = 101
  for _, info in ipairs(minimapFrames) do

    if info.options then
      options.args[info.frame] = {
        type = "group",
        name = info.optionsName or info.frame,
        order = elementOrder,
        args = {

        }
      }
      local frameOptions = options.args[info.frame].args
      local i = 0
      for _, o in ipairs(info.options) do
        o.order = elementOrder + i
        frameOptions[info.frame .. i] = o
        i = i + 1
      end
      if info.hasFontOptions then
        local fontOptions = GetFontOptions(info.frame)
        for _, t in ipairs(fontOptions) do
          t.order = elementOrder + i
          frameOptions[info.frame..i] = t
          i = i + 1
        end
        i = i + 1
      end
      if info.hasXY then
        local xyOptions = GetXYOffsetOptions(info.frame)
        for _, t in ipairs(xyOptions) do
          t.order = elementOrder + i
          frameOptions[info.frame..i] = t
          i = i + 1
        end
        i = i + 1
      end
      elementOrder = elementOrder + 50
    end
  end
  TEST = options
  opt.RegisterListItem(parentId, id, text, sortOrder, options)
end



