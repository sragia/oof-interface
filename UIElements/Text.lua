local addon, ns = ...

local L = ns.L
local obj = ns.CreateNewModule("UI_Text")

function obj:Initialize()

  local UIElements = ns.UIElements

  local methods = {
    Clear = function(self)

    end,
    SetText = function(self, text)
      self.text:SetText(text)
    end,
    SetFontSize = function(self, size)
      self.text:SetFont(ns.defaults.font, size)
    end,
    SetFont = function(self,font,size,flags)
      self.text:SetFont(font,size,flags)
    end
  }

  local function constructor(name,parent,options,frame)
    local textFrame = frame or CreateFrame("Frame",name,parent)
    textFrame:SetParent(parent)
    -- Text
    local text = textFrame.text or textFrame:CreateFontString(nil, "OVERLAY")
    text:SetFont(ns.defaults.font,11)
    text:SetPoint("CENTER")
    textFrame.text = text

    for name, func in pairs(methods) do
      textFrame[name] = func
    end


    return textFrame
  end

  local funcs = {
  }


  UIElements.RegisterFrameType('Text',constructor,funcs)

end