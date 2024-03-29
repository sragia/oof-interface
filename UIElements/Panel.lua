local addon, ns = ...

local L = ns.L
local obj = ns.CreateNewModule("UI_Frame", -98)

function obj:Initialize()

  local UIElements = ns.UIElements

  local methods = {
    Clear = function(self)
      self:SetScript("OnEnter",nil)
      self:SetScript("OnLeave",nil)
      self:SetScript("OnDragStart", nil)
      self:SetScript("OnDragStop", nil)
      self:SetText("")
    end,
    SetText = function(self,text)
      self.text:SetText(text)
    end,
    SetFontSize = function(self, size)
      self.text:SetFont(ns.defaults.font, size)
    end
  }

  local function constructor(name,parent,options,frame)

    local panel = frame or CreateFrame("Frame",name,parent)
    panel:SetParent(parent)
    panel:SetBackdrop(ns.defaults.backdrop)
    panel:SetBackdropColor(0, 0, 0, 0.8)
    panel:SetBackdropBorderColor(0, 0, 0, 1)

    -- Text
    local panelText = panel.text or UIElements.CreateFrame("Text",nil,panel)
    panelText:SetFont(ns.defaults.font,11)
    panelText:SetPoint("CENTER")
    panelText:SetWidth(100)
    panelText:SetHeight(20)
    panel.text = panelText

    for name, func in pairs(methods) do
      panel[name] = func
    end


    return panel
  end

  local funcs = {
    'ApplyBackdrop'
  }


  UIElements.RegisterFrameType('Panel',constructor,funcs)

end