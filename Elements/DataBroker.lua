local addon, ns = ...
local L = ns.L
local obj = ns.CreateNewModule("Elements_DataBroker")

function obj:Initialize()
  local opt = ns.options
  local parentId = "elements"
  local mover = ns.mover
  local id = "databroker"
  local text = L["Data Brokers"]
  local sortOrder = 1000
  local ldb = LibStub:GetLibrary('LibDataBroker-1.1')
  local db = ns.DB.profile.databrokers
  local UI = ns.UIElements

  local panels = ns:GetModule('Elements_Panels')

  local databrokers = {
    --[[
      [someId] = {
        text =
        icon =
        x =
        y =
        textSize = 12,
        anchored = panelFrame|nil
        frame =
        show = true|false
        showText = true|false
        iconSize = 15,
        iconLoc = "LEFT",
      }
    ]]
  }
  local optionsDefaults = {
    x = 500,
    y = 500,
    textSize = 12,
    show = true,
    showIcon = true,
    showText = true,
    iconSize = 15,
    iconLoc = "LEFT",
    alpha = 0.8,
    hoverAlpha = 1,
    hoverDuration = 0.3,
    font = 'CharlesWright'
  }

  function obj:RefreshDataBroker(frame, options)
    if not frame then return end

    if not options.show then
      frame:Hide()
      return
    else
      frame:Show()
    end
    frame.icon:SetSize(options.iconSize,options.iconSize)
    frame:ClearAllPoints()
    local parent = UIParent
    if options.anchored and options.anchored ~= 'NONE' then
      local panel = panels:GetPanelFrame(options.anchored)
      if panel then
        parent = panel
      end
    end
    frame:SetParent(parent)
    frame:SetPoint("BOTTOMLEFT", options.x, options.y)
    frame.icon:SetTexture(options.icon)
    frame:SetText(options.showText and options.text or "")
    frame:SetFont(ns.LSM:Fetch('font',options.font),options.textSize,"OUTLINE")
    frame:SetFontSize(options.textSize)

    if options.showIcon then
      frame.icon:Show()
    else
      frame.icon:Hide()
    end

    local width = frame.text:GetWidth() + (options.showIcon and options.iconSize or 0) + 5
    local height = (options.showIcon and frame.text:GetHeight() < options.iconSize and options.iconSize or frame.text:GetHeight()) + 5

    frame.text:ClearAllPoints()
    frame.icon:ClearAllPoints()
    if options.iconLoc == "LEFT" then
      frame.text:SetPoint("RIGHT")
      frame.icon:SetPoint("RIGHT", frame.text, "LEFT", -5, 0)
    else
      frame.text:SetPoint("LEFT")
      frame.icon:SetPoint("LEFT", frame.text, "RIGHT", 5, 0)
    end

    frame:SetSize(width, height)

    ns.AlphaAnimation(frame, 'onHover', options.alpha, options.hoverAlpha , options.hoverDuration)
    ns.AlphaAnimation(frame, 'onLeave', options.hoverAlpha, options.alpha, options.hoverDuration)
    frame:SetAlpha(options.alpha)

  end

  function obj:CreateDataBrokerFrame(name, obj)
    local options
    if db[name] then
      db[name] = ns.AddMissingTableEntries(db[name], optionsDefaults)
    else
      db[name] = ns.CopyTable(optionsDefaults)
    end
    options = db[name]

    db[name].text = obj.text
    db[name].icon = obj.icon

    local frame = UI.CreateFrame('Text', nil, UIParent, { justification = "LEFT" }) -- TODO: Panel Attachment
    local icon = UI.CreateFrame('Texture', nil, frame, { texture = obj.icon })
    frame.icon = icon
    self:RefreshDataBroker(frame, db[name])

    if obj.OnClick then
      frame:SetScript('OnMouseDown', obj.OnClick)
    end

    frame:SetScript('OnEnter', function(self)
      self.animations.onHover.group:Play()
      if obj.OnEnter then obj.OnEnter(self) end
    end)

    frame:SetScript('OnLeave', function(self)
      self.animations.onLeave.group:Play()
      if obj.OnLeave then obj.OnLeave(self) end
    end)

    db[name].frame = frame

    return frame
  end

  local enabledBrokers = {}
  local dataMovers = {}

  function obj:AddRefreshMovers()
    for name, options  in pairs(db) do
      local f = options.frame
      if options.show and
        f and
        not dataMovers[name] and
        not (options.anchored and options.anchored ~= 'NONE') and
        enabledBrokers[name] then

        dataMovers[name] = true
        mover.CreateMovableElement(name, f, function(left, bottom)
          db[name].x = left
          db[name].y = bottom
          obj:RefreshDataBroker(f, db[name])
        end, name,  true)
      end
    end
  end

  function obj:AddInitialDataBrokers()
    for name, obj in ldb:DataObjectIterator() do
      enabledBrokers[name] = true
      local f = self:CreateDataBrokerFrame(name, obj)
      self:AddRefreshMovers()
    end
  end
  obj:AddInitialDataBrokers()

  function obj:UpdateText(event, name, key, value, dataobj)
    db[name].text = value
    self:RefreshDataBroker(db[name].frame, db[name])
  end

  function obj:UpdateIcon(event, name, key, value, dataobj)
    db[name].icon = value
    self:RefreshDataBroker(db[name].frame, db[name])
  end

  function obj:AddNewBroker(event, name, dataobj)
    print(name);
    if not enabledBrokers[name] then
      enabledBrokers[name] = true
      local f = self:CreateDataBrokerFrame(name, dataobj)
      self:AddRefreshMovers()
      self:RefreshOptions(true, true)
    end
  end

  ldb.RegisterCallback(self, "LibDataBroker_AttributeChanged__text", "UpdateText")

  ldb.RegisterCallback(self, "LibDataBroker_AttributeChanged__icon", "UpdateIcon")

  ldb.RegisterCallback(self, "LibDataBroker_DataObjectCreated", "AddNewBroker")




  local options

  local function GenericSetter(name, key)
    return function(self, value)
      db[name][key] = value
      obj:RefreshDataBroker(db[name].frame, db[name])
    end
  end


  local function OnPanelUpdate(event, value)
    if event == "PANEL_DELETE" then
      for name, data in pairs(db) do
        if data.anchored and data.anchored == value then
          data.anchored = nil
          db[name].anchored = nil
          obj:RefreshDataBroker(data.frame, data)
        end
      end
    elseif event == "PANEL_ADD" then

    end
    obj:RefreshOptions(true, true)
  end

  panels:RegisterCallback(OnPanelUpdate)

  function obj:RefreshOptions(refresh, justUpdate)
    options = {
      type = "group",
      name = addon,
      args = {
        dataBrokers = {
          order = 1,
          name = L["Data Brokers"],
          type = "description",
          width = "full",
          fontSize = "large",
        },
      }
    }


    local order = 10
    local o = options.args
    for name, data in pairs(db) do
      if enabledBrokers[name] then
        o[name] = {
          type = "group",
          name = name,
          order = order,
          args = {
            show = {
              order = 0,
              type = 'toggle',
              name = L['Show'],
              get = function() return data.show end,
              set = function(self, value)
                db[name].show = value
                if not value then
                  dataMovers[name] = nil
                  mover.RemoveElement(name)
                end
                db[name].show = value
                obj:RefreshDataBroker(db[name].frame, db[name])
                obj:AddRefreshMovers()
              end,
              width = 'full',
            },
            showIcon = {
              order = 1,
              type = 'toggle',
              name = L['Show Icon'],
              get = function() return data.showIcon end,
              set = function(self, value)
                db[name].showIcon = value
                obj:RefreshDataBroker(db[name].frame, db[name])
              end,
              width = 'normal',
            },
            showText = {
              order = 1.01,
              type = 'toggle',
              name = L['Show Text'],
              get = function() return data.showText end,
              set = function(self, value)
                db[name].showText = value
                obj:RefreshDataBroker(db[name].frame, db[name])
              end,
              width = 'normal',
            },
            iconSize = {
              order = 1.2,
              name = L['Icon Size'],
              type = 'range',
              softMin = 0,
              softMax = 100,
              step = 1,
              get = function() return data.iconSize end,
              set = GenericSetter(name, 'iconSize'),
            },
            iconLoc = {
              order = 1.4,
              name = L['Icon Location'],
              type = 'select',
              values = {
                LEFT = L["Left"],
                RIGHT = L["Right"]
              },
              get = function() return data.iconLoc end,
              set = GenericSetter(name, 'iconLoc')
            },
            x = {
              order = 2,
              name = L['X Offset'],
              type = 'range',
              min = 0,
              max = 2000,
              step = 1,
              get = function() return data.x end,
              set = GenericSetter(name, 'x')
            },
            y = {
              order = 3,
              name = L['Y Offset'],
              type = 'range',
              min = 0,
              max = 2000,
              step = 1,
              get = function() return data.y end,
              set = GenericSetter(name, 'y')
            },
            font = {
              type = 'select',
              order = 3.5,
              dialogControl = 'LSM30_Font',
              name = L['Font'],
              values = ns.LSM:HashTable('font'),
              get = function()
                return data.font
              end,
              set = GenericSetter(name, 'font')
            },
            textSize = {
              order = 4,
              name = L['Font Size'],
              type = 'range',
              softMin = 5,
              softMax = 30,
              step = 1,
              get = function() return data.textSize end,
              set = GenericSetter(name, 'textSize')
            },
            alpha = {
              order = 5,
              name = L['Alpha'],
              type = 'range',
              min = 0,
              max = 1,
              step = 0.05,
              get = function() return data.alpha end,
              set = GenericSetter(name, 'alpha')
            },
            hoverAlpha = {
              order = 6,
              name = L['Hover Alpha'],
              type = 'range',
              min = 0,
              max = 1,
              step = 0.05,
              get = function() return data.hoverAlpha end,
              set = GenericSetter(name, 'hoverAlpha')
            },
            hoverDuration = {
              order = 7,
              name = L['Fade Duration (s)'],
              type = 'range',
              softMin = 0,
              softMax = 3,
              step = 0.1,
              get = function() return data.hoverDuration end,
              set = GenericSetter(name, 'hoverDuration')
            }
          },
        }

        -- Panel Anchor

        local availablePanels = panels:GetAvailablePanels()
        availablePanels['NONE'] = L["None"]

        o[name].args.panelAnchor = {
          type = 'select',
          order = 10,
          name = L['Anchor to Panel'],
          values = availablePanels,
          get = function() return data.anchored or 'NONE' end,
          set = function(self, value)
            if not db[name].anchored or db[name].anchored == 'NONE' then
              db[name].x = 0
              db[name].y = 0
              dataMovers[name] = nil
              mover.RemoveElement(name)
            end
            db[name].anchored = value
            obj:RefreshDataBroker(db[name].frame, db[name])
            obj:AddRefreshMovers()
          end,
        }
        order = order + 10
      end
    end



    if refresh then
      opt.RefreshListOptions(parentId, id, options, justUpdate)
    end
  end
  obj:RefreshOptions()

  opt.RegisterListItem(parentId, id, text, sortOrder, options)
end



