local addon, ns = ...

local obj = ns.CreateNewModule("Elements_BuffsDebuffs", 100)
local L = ns.L
local DIRECTION_TO_POINT = {
  DOWN_RIGHT = "TOPLEFT",
  DOWN_LEFT = "TOPRIGHT",
  UP_RIGHT = "BOTTOMLEFT",
  UP_LEFT = "BOTTOMRIGHT",
  RIGHT_DOWN = "TOPLEFT",
  RIGHT_UP = "BOTTOMLEFT",
  LEFT_DOWN = "TOPRIGHT",
  LEFT_UP = "BOTTOMRIGHT",
}

local DIRECTION_TO_HORIZONTAL_SPACING_MULTIPLIER = {
  DOWN_RIGHT = 1,
  DOWN_LEFT = -1,
  UP_RIGHT = 1,
  UP_LEFT = -1,
  RIGHT_DOWN = 1,
  RIGHT_UP = 1,
  LEFT_DOWN = -1,
  LEFT_UP = -1,
}

local DIRECTION_TO_VERTICAL_SPACING_MULTIPLIER = {
  DOWN_RIGHT = -1,
  DOWN_LEFT = -1,
  UP_RIGHT = 1,
  UP_LEFT = 1,
  RIGHT_DOWN = -1,
  RIGHT_UP = 1,
  LEFT_DOWN = -1,
  LEFT_UP = 1,
}

local IS_HORIZONTAL_GROWTH = {
  RIGHT_DOWN = true,
  RIGHT_UP = true,
  LEFT_DOWN = true,
  LEFT_UP = true,
}

local previewFonts = false

function obj:RefreshHeader(header)
  local auraType = 'debuffs'
  local DB = self.db.debuffs
  if header:GetAttribute('filter') == 'HELPFUL' then
    auraType = 'buffs'
    DB = self.db.buffs
    header:SetAttribute("consolidateTo", 0)
    header:SetAttribute('weaponTemplate', ("OofAuraTemplate%d"):format(DB.size))
  end

  header:SetAttribute("separateOwn", DB.seperateOwn)
  header:SetAttribute("sortMethod", DB.sortMethod)
  header:SetAttribute("sortDirection", DB.sortDir)
  header:SetAttribute("maxWraps", DB.maxWraps)
  header:SetAttribute("wrapAfter", DB.wrapAfter)

  header:SetAttribute("point", DIRECTION_TO_POINT[self.db.growthDirection])

  if IS_HORIZONTAL_GROWTH[DB.growthDirection] then
    header:SetAttribute("minWidth", ((DB.wrapAfter == 1 and 0 or DB.horizontalSpacing) + DB.size) * DB.wrapAfter)
    header:SetAttribute("minHeight", (DB.verticalSpacing + DB.size) * DB.maxWraps)
    header:SetAttribute("xOffset", DIRECTION_TO_HORIZONTAL_SPACING_MULTIPLIER[DB.growthDirection] * (DB.horizontalSpacing + DB.size))
    header:SetAttribute("yOffset", 0)
    header:SetAttribute("wrapXOffset", 0)
    header:SetAttribute("wrapYOffset", DIRECTION_TO_VERTICAL_SPACING_MULTIPLIER[DB.growthDirection] * (DB.verticalSpacing + DB.size))
  else
    header:SetAttribute("minWidth", (DB.horizontalSpacing + DB.size) * DB.maxWraps)
    header:SetAttribute("minHeight", ((DB.wrapAfter == 1 and 0 or DB.verticalSpacing) + DB.size) * DB.wrapAfter)
    header:SetAttribute("xOffset", 0)
    header:SetAttribute("yOffset", DIRECTION_TO_VERTICAL_SPACING_MULTIPLIER[DB.growthDirection] * (DB.verticalSpacing + DB.size))
    header:SetAttribute("wrapXOffset", DIRECTION_TO_HORIZONTAL_SPACING_MULTIPLIER[DB.growthDirection] * (DB.horizontalSpacing + DB.size))
    header:SetAttribute("wrapYOffset", 0)
  end

  header:SetAttribute("template", string.format("OofAuraTemplate%d",DB.size))

  local index = 1
  local child = select(index, header:GetChildren())
  while child do
    if (floor(child:GetWidth() * 100 + 0.5) / 100) ~= DB.size then
      child:SetSize(DB.size, DB.size)
    end

    child.auraType = auraType -- used to update cooldown text

    if child.time then
      child.time:ClearAllPoints()
      child.time:SetPoint("TOP", child, 'BOTTOM', 1 + DB.timeXOffset, 0 + DB.timeYOffset)
      ns.SetupFont(child.time, self.db.font, DB.durationFontSize, self.db.fontOutline)

      child.count:ClearAllPoints()
      child.count:SetPoint("BOTTOMRIGHT", -1 + DB.countXOffset, 0 + DB.countYOffset)
      ns.SetupFont(child.count, self.db.font, DB.countFontSize, self.db.fontOutline)
    end

    --Blizzard bug fix, icons arent being hidden when you reduce the amount of maximum buttons
    if (index > (DB.maxWraps * DB.wrapAfter)) and child:IsShown() then
      child:Hide()
    end

    index = index + 1
    child = select(index, header:GetChildren())
  end

end

local function UpdateTime(self,elapsed)
  self.timeLeft = self.timeLeft - elapsed
  if self.nextUpdate > 0 then
    self.nextUpdate = self.nextUpdate - elapsed
    return
  end

  self.nextUpdate = 0.05
  self.time:SetText(ns.FormatTime(previewFonts and 4.723 or self.timeLeft))

end

function obj:RefreshAura(icon, index)
  local filter = icon:GetParent():GetAttribute('filter')
  local unit = icon:GetParent():GetAttribute('unit')
  local name, texture, count, dtype, duration, expirationTime = UnitAura(unit, index, filter)

  if name then
    if ((duration > 0) and expirationTime) or previewFonts  then
      local timeLeft = previewFonts and 4.23 or expirationTime - GetTime()
      if not icon.timeLeft then
        icon.timeLeft = timeLeft
        icon:SetScript("OnUpdate", UpdateTime)
      else
        icon.timeLeft = timeLeft
      end

      icon.nextUpdate = -1
      UpdateTime(icon, 0)
    else
      icon.timeLeft = nil
      icon.time:SetText('')
      icon:SetScript("OnUpdate", nil)
    end

    if previewFonts or (count and (count > 1)) then
      icon.count:SetText(previewFonts and 11 or count)
    else
      icon.count:SetText('')
    end

    if filter == "HARMFUL" then
      local color = _G.DebuffTypeColor[dtype or ""]
      icon:SetBackdropBorderColor(color.r, color.g, color.b)
    else
      icon:SetBackdropBorderColor(0,0,0,1)
    end
    icon.texture:SetTexture(texture)
    icon.offset = nil
  end
end


function obj:OnAttributeChanged(attribute, value)
  if attribute == "index" then
    obj:RefreshAura(self,value)
  elseif attribute == "target-slot" then
    obj:RefreshTempEnchant(self, value)
  end
end


function obj:InitIcon(icon)
  local font = ns.LSM:Fetch("font", self.db.font)
  local header = icon:GetParent()
  local auraType = header:GetAttribute("filter")

  ns.UIElements.ApplyBackdrop(icon,0,0,0,1)

  local DB = self.db.debuffs
  icon.auraType = 'debuffs' -- used to update cooldown text
  if auraType == 'HELPFUL' then
    DB = self.db.buffs
    icon.auraType = 'buffs'
  end

  -- icon:SetFrameLevel(4)
  icon.texture = icon:CreateTexture(nil, "BORDER")
  icon.texture:SetPoint("TOPLEFT",1,-1)
  icon.texture:SetPoint("BOTTOMRIGHT",-1,1)
  icon.texture:SetTexCoord(unpack(ns.defaults.zoomedTexCoords))

  icon.count = icon:CreateFontString(nil, "ARTWORK")
  icon.count:SetPoint("BOTTOMRIGHT", -1 + DB.countXOffset, 1 + DB.countYOffset)
  ns.SetupFont(icon.count ,DB.font, DB.countFontSize, self.db.fontOutline)

  icon.time = icon:CreateFontString(nil, "ARTWORK")
  icon.time:SetPoint("TOP", icon, 'BOTTOM', 1 + DB.timeXOffset, 0 + DB.timeYOffset)
  ns.SetupFont(icon.time ,DB.font, DB.durationFontSize, self.db.fontOutline)

  icon.highlight = icon:CreateTexture(nil, "HIGHLIGHT")
  icon.highlight:SetColorTexture(1, 1, 1, 0.45)
  icon.highlight:SetPoint("TOPLEFT")
  icon.highlight:SetPoint("BOTTOMRIGHT")

  icon:SetScript("OnAttributeChanged", obj.OnAttributeChanged)

end


function obj:Initialize()
  local opt = ns.options
  local parentId = "elements"
  local id = "buffsdebuffs"
  local text = L['Buffs and Debuffs']
  local sortOrder = 60
  local db = ns.DB.profile.buffsdebuffs
  obj.db = db
  local mover = ns.mover

  -- Aura Headers
  local function CreateAuraHeader(filter)
    local name = filter == "HELPFUL" and "OofBuffs" or "OofDebuffs"
    local header = CreateFrame("Frame", name, UIParent, "SecureAuraHeaderTemplate")

    header:SetClampedToScreen(true)
    header:SetAttribute("unit", "player")
    header:SetAttribute("filter", filter)
    RegisterStateDriver(header, "visibility", "[petbattle] hide; show")
    RegisterAttributeDriver(header, "unit", "[vehicleui] vehicle; player")

    if filter == "HELPFUL" then
      header:SetAttribute('consolidateDuration', -1)
      header:SetAttribute("includeWeapons", 1)
    end

    obj:RefreshHeader(header)

    header:Show()

    return header
  end

  local function RemoveDefaultBuffFrame()
    local f = _G['BuffFrame']
    f:UnregisterAllEvents()
    f.Show = function() end
    f:Hide()
    f = _G['TemporaryEnchantFrame']
    f:UnregisterAllEvents()
    f.Show = function() end
    f:Hide()
  end

  RemoveDefaultBuffFrame()


  local function RefreshHeaderLocation(header,left,bottom)
    local key = header.key
    self.db[key].x = left
    self.db[key].y = bottom
    self.db[key].point = 'BOTTOMLEFT'
    header:SetPoint(self.db[key].point,self.db[key].x,self.db[key].y)
  end

  obj.Buffs = CreateAuraHeader('HELPFUL')
  obj.Buffs:SetPoint(self.db.buffs.point, self.db.buffs.x, self.db.buffs.y)
  obj.Buffs.key = 'buffs'
  local BuffMover = function(left,bottom) RefreshHeaderLocation(obj.Buffs,left,bottom) end
  mover.CreateMovableElement(L['Buffs'],obj.Buffs,BuffMover)

  obj.Debuffs = CreateAuraHeader('HARMFUL')
  obj.Debuffs:SetPoint(self.db.debuffs.point, self.db.debuffs.x, self.db.debuffs.y)
  obj.Debuffs.key = 'debuffs'
  local DebuffsMover = function(left,bottom) RefreshHeaderLocation(obj.Debuffs,left,bottom) end
  mover.CreateMovableElement(L['Debuffs'],obj.Debuffs,DebuffsMover)

-- OPTIONS CONFIG --
  local function CreateOptions(header)
    local key = header.key
    return {
      sortMethod = {
        type = "select",
        order = 1,
        name = L['Sort Method'],
        values = {
          INDEX = L["Index"],
          TIME = L["Time"],
          NAME = L["Name"],
        },
        get = function() return db[key].sortMethod end,
        set = function(self, value)
          db[key].sortMethod = value
          obj:RefreshHeader(header)
        end
      },
      seperateOwn = {
        type = "select",
        order = 2,
        name = L['Seperate'],
        values = {
          [-1] = L["Other's First"],
          [0] = L["No Sorting"],
          [1] = L["Your Auras First"],
        },
        get = function() return db[key].seperateOwn end,
        set = function(self, value)
          db[key].seperateOwn = value
          obj:RefreshHeader(header)
        end
      },
      sortDir = {
        type = "select",
        order = 3,
        name = L['Sort Direction'],
        values = {
          ['+'] = L["Ascending"],
          ['-'] = L["Descending"],
        },
        get = function() return db[key].sortDir end,
        set = function(self, value)
          db[key].sortDir = value
          obj:RefreshHeader(header)
        end
      },
      growthDirection = {
        type = "select",
        order = 4,
        name = L['Growth Direction'],
        values = {
          DOWN_RIGHT = format(L["%s and then %s"], L["Down"], L["Right"]),
          DOWN_LEFT = format(L["%s and then %s"], L["Down"], L["Left"]),
          UP_RIGHT = format(L["%s and then %s"], L["Up"], L["Right"]),
          UP_LEFT = format(L["%s and then %s"], L["Up"], L["Left"]),
          RIGHT_DOWN = format(L["%s and then %s"], L["Right"], L["Down"]),
          RIGHT_UP = format(L["%s and then %s"], L["Right"], L["Up"]),
          LEFT_DOWN = format(L["%s and then %s"], L["Left"], L["Down"]),
          LEFT_UP = format(L["%s and then %s"], L["Left"], L["Up"]),
        },
        get = function() return db[key].growthDirection end,
        set = function(self, value)
          db[key].growthDirection = value
          obj:RefreshHeader(header)
        end
      },
      maxWraps = {
        type = "range",
        order = 5,
        name = L['Max Wraps'],
        min = 1,
        max = 12,
        step = 1,
        get = function() return db[key].maxWraps end,
        set = function(self, value)
          db[key].maxWraps = value
          obj:RefreshHeader(header)
        end
      },
      wrapAfter = {
        type = "range",
        order = 6,
        name = L['Wrap After'],
        min = 1,
        max = 32,
        step = 1,
        get = function() return db[key].wrapAfter end,
        set = function(self, value)
          db[key].wrapAfter = value
          obj:RefreshHeader(header)
        end
      },
      horizontalSpacing = {
        type = "range",
        order = 7,
        name = L['Horizontal Spacing'],
        min = 0,
        max = 50,
        step = 1,
        get = function() return db[key].horizontalSpacing end,
        set = function(self, value)
          db[key].horizontalSpacing = value
          obj:RefreshHeader(header)
        end
      },
      size = {
        type = "range",
        order = 8,
        name = L['Icon Size'],
        min = 14,
        max = 60,
        step = 2,
        get = function() return db[key].size end,
        set = function(self, value)
          db[key].size = value
          obj:RefreshHeader(header)
        end
      },
      wrapAfter = {
        type = "range",
        order = 9,
        name = L['Wrap After'],
        min = 1,
        max = 32,
        step = 1,
        get = function() return db[key].wrapAfter end,
        set = function(self, value)
          db[key].wrapAfter = value
          obj:RefreshHeader(header)
        end
      },
      verticalSpacing = {
        type = "range",
        order = 10,
        name = L['Vertical Spacing'],
        min = 0,
        max = 50,
        step = 1,
        get = function() return db[key].verticalSpacing end,
        set = function(self, value)
          db[key].verticalSpacing = value
          obj:RefreshHeader(header)
        end
      },
      fontLabel = {
        type = "description",
        fontSize = "large",
        name = L["Fonts"],
        order = 10.9,
        width = "full"
      },
      durationFontSize = {
        type = "range",
        order = 11,
        name = L['Time Font Size'],
        min = 4,
        max = 60,
        step = 1,
        get = function() return db[key].durationFontSize end,
        set = function(self, value)
          db[key].durationFontSize = value
          obj:RefreshHeader(header)
        end
      },
      countFontSize = {
        type = "range",
        order = 12,
        name = L['Count Font Size'],
        min = 4,
        max = 60,
        step = 1,
        get = function() return db[key].countFontSize end,
        set = function(self, value)
          db[key].countFontSize = value
          obj:RefreshHeader(header)
        end
      },
      countXOffset = {
        type = "range",
        order = 20,
        name = L['Count X Offset'],
        min = -80,
        max = 80,
        step = 1,
        get = function() return db[key].countXOffset end,
        set = function(self, value)
          db[key].countXOffset = value
          obj:RefreshHeader(header)
        end
      },
      countYOffset = {
        type = "range",
        order = 21,
        name = L['Count Y Offset'],
        min = -80,
        max = 80,
        step = 1,
        get = function() return db[key].countYOffset end,
        set = function(self, value)
          db[key].countYOffset = value
          obj:RefreshHeader(header)
        end
      },
      timeXOffset = {
        type = "range",
        order = 15,
        name = L['Time X Offset'],
        min = -80,
        max = 80,
        step = 1,
        get = function() return db[key].timeXOffset end,
        set = function(self, value)
          db[key].timeXOffset = value
          obj:RefreshHeader(header)
        end
      },
      timeYOffset = {
        type = "range",
        order = 16,
        name = L['Time Y Offset'],
        min = -80,
        max = 80,
        step = 1,
        get = function() return db[key].timeYOffset end,
        set = function(self, value)
          db[key].timeYOffset = value
          obj:RefreshHeader(header)
        end
      },
    }
  end

  local options = {
    type = "group",
    name = L['Buffs and Debuffs'],
    args = {
      font = {
        type = 'select',
        order = 1,
        dialogControl = 'LSM30_Font',
        name = L['Font'],
        values = ns.LSM:HashTable('font'),
        get = function()
          return db.font
        end,
        set = function(self, key)
          db.font = key
          obj:RefreshHeader(obj.Buffs)
          obj:RefreshHeader(obj.Debuffs)
        end
      },
      fontOutline = {
        type = "select",
        order = 6,
        name = L["Font Outline"],
        values = {
          NONE = L['None'],
          OUTLINE = L['Outline'],
          THICKOUTLINE = L['Thick'],
          MONOCHROME = L['Monochrome']
        },
        get = function()  return db.fontOutline end,
        set = function(self,value)
          db.fontOutline = value
          obj:RefreshHeader(obj.Buffs)
          obj:RefreshHeader(obj.Debuffs)
        end,
      },
      previewFonts = {
        type = "execute",
        order = 7,
        name = L["Toggle preview (Fonts)"],
        func = function() previewFonts = not previewFonts end
      },
      buffs = {
        type = "group",
        name = L["Buffs"],
        order = 10,
        args = {}
      },
      debuffs = {
        type = "group",
        name = L["Debuffs"],
        order = 20,
        args = {}
      }
    }
  }

  options.args.buffs.args = CreateOptions(obj.Buffs)
  options.args.debuffs.args = CreateOptions(obj.Debuffs)

  opt.RegisterListItem(parentId, id, text, sortOrder, options)
end