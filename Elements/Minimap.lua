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

  local function Resize()
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
      Minimap:SetClampRectInsets(db.size, db.size, db.size, db.size)
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
      }
    }
    return t
  end

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
      hide = false,
    },
    {
      frame = "MiniMapMailBorder",
      hide = true,
    },
    {
      frame = "MiniMapInstanceDifficulty",
      hide = false,
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
      setter = function(self)
        local f = _G[self.frame]
        local saved = db.elements[self.frame]
        local shape = db.shape
        local aspect = db.aspect
        local X, Y = saved.x, saved.y
        if shape == "rectangle" then
          local w,h = strsplit('x',aspect)
          local top = w > h and  (db.size - (db.size / (w / h))) / 2 or 0
          local left = w < h and (db.size - (db.size / (h / w))) / 2 or 0
          local x, y = 0, 0
          if saved.point:find('TOP') then
            y = y - top
          elseif saved.point:find('BOTTOM') then
            y = y + top
          end
          if saved.point:find('LEFT') then
            x = x + left
          elseif saved.point:find('RIGHT') then
            x = x - left
          end
          X = X + x
          Y = Y + y
        end
        f:ClearAllPoints()
        f:SetPoint(saved.point,X, Y)
      end,
      hasXY = true,
      options = {
        {
          type = 'description',
          name = L['Calendar'],
          width = 'full',
        },
        {
          type = 'select',
          values = ns.defaults.points,
          name = L['Anchor Point'],
          set = function(_, value)
            db.elements['GameTimeFrame'].point = value
            obj:SkinMinimap()
          end,
          get = function() return db.elements['GameTimeFrame'].point end,
          order = 1,
        },
      }
    },
    {
      frame = "GuildInstanceDifficulty",
      hide = false,
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


  }



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
      if f.hide then
        _G[f.frame]:Hide()
      elseif f.setter then
        f:setter()
      end
    end
    obj:Reshape()
  end

  obj:SkinMinimap()
  Resize()




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
          obj:Reshape()
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
          obj:Reshape()
          Resize()
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
          Resize()
          obj:Reshape()
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
      local i = 0
      for _, o in ipairs(info.options) do
        o.order = elementOrder + i
        options.args[info.frame .. i] = o
        i = i + 1
      end
      if info.hasXY then
        local xyOptions = GetXYOffsetOptions(info.frame)
        TEST1 = xyOptions
        for _, t in ipairs(xyOptions) do
          t.order = elementOrder + i
          options.args[info.frame..i] = t
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



