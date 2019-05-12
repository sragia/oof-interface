local addon, ns = ...
local L = ns.L
local obj = ns.CreateNewModule("Elements_Panels")

function obj:Initialize()
  local opt = ns.options
  local mover = ns.mover
  local parentId = "elements"
  local id = "panels"
  local text = "Panels"
  local sortOrder = 30
  local UI = ns.UIElements
  local db = ns.DB.profile.panels


  function obj:Refresh()

  end

  local defaultOptions = {
    bgColor = { 0, 0, 0, 0.8},
    borderColor = {0, 0, 0, 1},
    borderSize = 1,
    width = 100,
    height = 60,
    x = 450,
    y = 300,
    frameStrata = 1
  }

  local function GeneratePanelId()
    for i=1, 100000 do
      local id = 'Panel'..i
      if not db[id] then
        return id
      end
    end
  end

  function obj:RefreshPanel(panel, options)
    local backdrop = panel:GetBackdrop()
    backdrop.edgeSize = options.borderSize
    panel:SetBackdrop(backdrop)
    panel:SetBackdropColor(unpack(options.bgColor))
    panel:SetBackdropBorderColor(unpack(options.borderColor))
    panel:SetSize(options.width, options.height)
    panel:SetPoint("BOTTOMLEFT", options.x, options.y)
    panel:SetFrameStrata(opt.frameStrataValues[options.frameStrata] or "LOW")

  end

  function obj:CreatePanel(options)
    local panel = UI.CreateFrame('Panel', nil, UIParent)
    obj:RefreshPanel(panel, options)

    return panel
  end

  function obj:ConfigurePanel(panel)

  end


  local panelMovers = {}

  function obj:AddRefreshMovers()
    for id, panelData in pairs(db) do
      local f = panelData.frame
      if f and not panelMovers[id]  then
        panelMovers[id] = true
        mover.CreateMovableElement(id, f, function(left, bottom)
          db[id].x = left
          db[id].y = bottom
          f:ClearAllPoints()
          f:SetPoint("BOTTOMLEFT", left, bottom)
          obj:RefreshPanel(f, db[id])
        end, panelData.frameName)
      end
    end
  end

  function obj:InitPanels()
    for id, panelOptions in pairs(db) do
      local panel = obj:CreatePanel(panelOptions)
      panelOptions.frame = panel
    end
  end


  function obj:AddNewPanel()
    local id = GeneratePanelId()
    db[id] = ns.CopyTable(defaultOptions)
    local panel = obj:CreatePanel(db[id])
    db[id].frame = panel
    obj:AddRefreshMovers()
    obj:RefreshPanelOptions(true)
    self:SendCall('PANEL_ADD', id)
  end

  function obj:DeletePanel(data, id)
    local f = data.frame
    f:Release()
    db[id] = nil
    obj:RefreshPanelOptions(true)
    mover.RemoveElement(id)
    panelMovers[id] = nil
    self:SendCall('PANEL_DELETE', id)
  end

  obj:InitPanels()
  obj:AddRefreshMovers()


  function obj:GetAvailablePanels()
    local panels = {}
    for id, panel in pairs(db) do
      panels[id] = panel.frameName or id
    end
    return panels
  end

  function obj:GetPanelFrame(id)
    return db[id].frame
  end

  local callbacks = {}

  function obj:RegisterCallback(func)
    table.insert(callbacks, func)
  end

  function obj:SendCall(event, value)
    for _, func in ipairs(callbacks) do
      func(event, value)
    end
  end


  -- OPTIONS CONFIG --
  local options

  function obj:RefreshPanelOptions(refresh)
    options = {
      type = "group",
      name = addon,
      args = {
        addpanel ={
          order = 0.1,
          name = L["Add New Panel"],
          type = "execute",
          width = "full",
          func = function()
            obj:AddNewPanel()
          end
        },
        panelDesc = {
          order = 1,
          name = L["Panels"],
          type = "description",
          width = "full",
          fontSize = "large",
        },
      }
    }

    local o = options.args

    local order = 10
    for id, panelData in pairs(db) do
        --[[
          bgColor = { 0, 0, 0, 0.8},
      borderColor = {0, 0, 0, 1},
      borderSize = 1,
      width = 100,
      height = 60,
        ]]


      o[id] = {
        type = "group",
        name = panelData.frameName or id,
        order = order,
        args = {
          frameName = {
            type = 'input',
            name = L['Frame Name'],
            order = 0,
            get = function() return db[id].frameName end,
            set = function(self, value)
              db[id].frameName = value
              obj:RefreshPanel(db[id].frame, db[id])
              obj:RefreshPanelOptions(true)
              mover.RefreshDisplayName(id, value)
            end,
          },
          width = {
            type = 'range',
            name = L['Width'],
            order = 1,
            softMax = 1500,
            softMin = 0,
            step = 1,
            get = function() return db[id].width end,
            set = function(self, width)
              db[id].width = width
              obj:RefreshPanel(db[id].frame, db[id])
            end,
          },
          height = {
            type = 'range',
            name = L['Height'],
            order = 2,
            softMax = 1500,
            softMin = 0,
            step = 1,
            get = function() return db[id].height end,
            set = function(self, height)
              db[id].height = height
              obj:RefreshPanel(db[id].frame, db[id])
            end,
          },
          bgColor = {
            order = 3,
            name = L["Background Color"],
            type = "color",
            hasAlpha = true,
            get = function() return unpack(db[id].bgColor) end,
            set = function(self, r, g, b, a)
              db[id].bgColor = {r,g,b,a}
              obj:RefreshPanel(panelData.frame, db[id])
            end
          },
          borderColor = {
            order = 4,
            name = L["Border Color"],
            type = "color",
            hasAlpha = true,
            get = function() return unpack(db[id].borderColor) end,
            set = function(self, r, g, b, a)
              db[id].borderColor = {r,g,b,a}
              obj:RefreshPanel(panelData.frame, db[id])
            end
          },
          borderSize = {
            type = 'range',
            name = L['Border Size'],
            order = 5,
            softMax = 20,
            softMin = 1,
            step = 1,
            get = function() return db[id].borderSize end,
            set = function(self, borderSize)
              db[id].borderSize = borderSize
              obj:RefreshPanel(db[id].frame, db[id])
            end,
          },
          frameStrata = {
            type = 'select',
            name = L['Frame Strata'],
            values = opt.frameStrataValues,
            get = function() return db[id].frameStrata end,
            set = function(self, value)
              db[id].frameStrata = value
              obj:RefreshPanel(db[id].frame, db[id])
            end
          },
          deletePanel = {
            order = 2000,
            name = L["Delete Panel"],
            type = "execute",
            width = "full",
            func = function()
              obj:DeletePanel(db[id],id)
            end
          }
        }
      }
      order = order + 10
    end
    if refresh then
      opt.RefreshListOptions(parentId, id, options)
    end
  end

  obj:RefreshPanelOptions()
  opt.RegisterListItem(parentId, id, text, sortOrder, options)
end



