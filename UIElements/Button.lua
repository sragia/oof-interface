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
    SetTextColor = function(this,r,g,b,a)
      if this.options.animTextColor then
        this.text.progress = 0
        this.text.endProgress = this.options.animTextDur
        local r1,g1,b1,a1 = this.text:GetTextColor()
        this:SetScript("OnUpdate",function(self, elapsed)
          self.text.progress = self.text.progress + elapsed
          if self.text.progress < self.text.endProgress then
            self.text:SetTextColor(ns.ColorTransformAnimation(self.text.progress/self.text.endProgress, r1, g1, b1, a1, r, g, b, a))
          else
            self:SetScript('OnUpdate', nil)
          end
        end)
      else
        this.text:SetTextColor(r,g,b,a)
      end
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
    end,
    SetTextureColor = function(self, r, g, b, a)
      if self.texture then
        self.texture:SetVertexColor(r,g,b,a)
      end
    end,
  }

  local function constructor(name,parent,options,frame)

    local btn = frame or CreateFrame("Button",name,parent)
    -- Styling
    btn.options = ns.MergeTables({
        disabledBackdrop = {0.1, 0.1, 0.1, 1},
        disabledTextColor = {.9, .9, .9, 1},
        disabledTextureColor = {1, 1, 1, 0.4},
        animTextColor = false,
        animTextDur = 0.2
      },
      options or {}
    )
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
    buttonText:SetShadowColor(0,0,0,1)
    buttonText:SetShadowOffset(0,-1)
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

    function btn.SetStatus(self, status)
      if status then
        -- enabled
        self:SetTextColor(1,1,1,1)
        self.currentColor = self.defaultColor
        self:SetTextureColor(1,1,1,1)
      else
        -- disabled
        self:SetTextureColor(unpack(self.options.disabledTextureColor))
        self:SetTextColor(unpack(self.options.disabledTextColor))
        self.currentColor = self.options.disabledBackdrop
      end
      self:SetBackdropColor(unpack(self.currentColor))
    end

    btn:SetStatus(btn:IsEnabled())

    btn:SetScript("OnEnable", function(self)
      self:SetStatus(true)
    end)
    btn:SetScript("OnDisable", function(self)
      self:SetStatus(false)
    end)

    return btn
  end

  local funcs = {
    'ApplyBackdrop'
  }


  UIElements.RegisterFrameType('Button',constructor,funcs)
end