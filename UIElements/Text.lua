local addon, ns = ...

local L = ns.L
local obj = ns.CreateNewModule("UI_Text", -99)

function obj:Initialize()

  local UIElements = ns.UIElements

  local methods = {
    Clear = function(self)
      self.text:SetText("")
    end,
    SetText = function(self, text)
      self.text:SetText(text)
    end,
    SetFontSize = function(self, size)
      local font, _, flag = self.text:GetFont()
      self.text:SetFont(font or ns.defaults.font, size, flag or "OUTLINE")
    end,
    SetFont = function(self,font,size,flags)
      self.text:SetFont(font,size,flags)
    end,
    SetTextColor = function(self,r,g,b,a)
      self.text:SetTextColor(r,g,b,a)
    end,
  }

  local function constructor(name,parent,options,frame)
    local textFrame = frame or CreateFrame("Frame",name,parent)
    textFrame:SetParent(parent)
    -- Text
    local text = textFrame.text or textFrame:CreateFontString(nil, "OVERLAY")
    text:SetFont(ns.defaults.font,11,'OUTLINE')
    text:SetPoint("CENTER")
    text:SetWidth(0)
    textFrame.text = text
    textFrame:SetSize(0,0)

    if options.justification then
      text:SetJustifyH(options.justification);
    end

    for name, func in pairs(methods) do
      textFrame[name] = func
    end


    return textFrame
  end

  local funcs = {
  }


  UIElements.RegisterFrameType('Text',constructor,funcs)

end