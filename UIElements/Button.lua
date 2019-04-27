local addon, ns = ...
local obj = ns.CreateNewModule("UI_Button")

function obj:Initialize()
  local UIElements = ns.UIElements

  local methods = {
    Clear = function(self)
      self:SetText("")
      self:ResetColor()
      self.texture:SetTexture(nil)
    end,
    SetFontSize = function(self,size)
      self.text:SetFont(ns.defaults.font,size)
    end,
    SetTextColor = function(self,r,g,b,a)
      self.text:SetTextColor(r,g,b,a)
    end,
    Highlight = function(self,r,g,b,a)
      self.currentColor = {r,g,b,a}
      self:SetBackdropColor(r,g,b,a)
    end,

    ResetColor = function(self)
      self.currentColor = self.defaultColor
      self:SetBackdropColor(unpack(self.defaultColor))
    end,
    SetText = function(self,text)
      self.text:SetText(text)
    end
  }

  local function constructor(name,parent,options,frame)
    local btn = frame or CreateFrame("Button",name,parent)
    -- Styling
    btn:SetParent(parent)
    UIElements.ApplyBackdrop(btn,0,0,0,1)
    if options and options.color then
      local r,g,b,a = unpack(options.color)
      btn:SetBackdropColor(r,g,b,a)
      btn.defaultColor = {r,g,b,a}
      btn.currentColor = {r,g,b,a}
    end
    if options and options.borderColor then
      btn:SetBackdropBorderColor(unpack(options.borderColor))
    end
    -- Text
    local buttonText = btn.text or btn:CreateFontString(nil, "OVERLAY")
    buttonText:SetFont(ns.defaults.font,11)
    local just = options and options.justification or "LEFT"
    local xOffset = 3
    if just == "CENTER" then
      xOffset = 0
    else
      xOffset = just == "LEFT" and 3 or -3
    end
    buttonText:SetPoint(just,xOffset,0)
    btn.text = buttonText
    -- Texture
    if options and options.texture then
      local tex = btn.texture or btn:CreateTexture(nil,"OVERLAY")
      btn.texture = tex
      tex:SetTexture(options.texture)
      tex:SetAllPoints()
    end
    -- Hover
    btn:SetScript("OnEnter",function(self)
      local r, g, b, a = unpack(self.currentColor)
      self:SetBackdropColor(r + 0.1, g + 0.1, b + 0.1, a)
    end)
    btn:SetScript("OnLeave", function(self)
      local r, g, b, a =  unpack(self.currentColor)
      self:SetBackdropColor(r, g, b, a)
    end)

    for name, func in pairs(methods) do
      btn[name] = func
    end


    return btn
  end

  local funcs = {
    'ApplyBackdrop'
  }


  UIElements.RegisterFrameType('Button',constructor,funcs)
end