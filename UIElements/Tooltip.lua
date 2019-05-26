local addon, ns = ...

-- Uses LibQTip-1.0

local L = ns.L
local obj = ns.CreateNewModule("UI_Tooltip", -90)

function obj:Initialize()
  local QTip = LibStub('LibQTip-1.0');
  local UIElements = ns.UIElements

  local methods = {
    SetBodyFont = function(self, font, size, flag)
      if not font then return end
      self.bodyFont:SetFont(font,size or 12, flag or "NONE")
    end,
    SetHeadFont = function(self, font, size, flag)
      if not font then return end
      self.headFont:SetFont(font,size or 12, flag or "NONE")
    end,
    ReleaseTooltip = function(self)
      QTip:Release(self)
    end
  }

  local i = 0

  local function constructor(name,parent,options,frame)
    -- required options:
    -- options.columns
    local tooltipName = name or "Oof_Tooltip_" .. i
    local tooltip = QTip:Acquire(tooltipName, options.columns)
    i = i + 1
    -- ergghhh

    if not tooltip.headFont then
      tooltip.headFont = CreateFont(tooltipName .. 'Head')
      tooltip.headFont:SetTextColor(1,1,1)
      tooltip.bodyFont = CreateFont(tooltipName .. 'Body')
      tooltip.bodyFont:SetTextColor(1,1,1)
    end
    tooltip:SetFont(tooltip.bodyFont)
    tooltip:SetHeaderFont(tooltip.headFont)

    for name, func in pairs(methods) do
      tooltip[name] = func
    end

    return tooltip
  end

  local funcs = {
    'ApplyBackdrop'
  }

  UIElements.RegisterFrameType('Tooltip',constructor,funcs, true)

end