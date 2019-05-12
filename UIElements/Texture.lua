local addon, ns = ...

local L = ns.L
local obj = ns.CreateNewModule("UI_Texture")

function obj:Initialize()

  local UIElements = ns.UIElements

  local methods = {
    Clear = function(self)
      self:SetTexture(nil)
    end,
    SetTexture = function(self, texture)
      self.texture:SetTexture(texture)
    end
  }

  local function constructor(name,parent,options,frame)

    local textureFrame = frame or CreateFrame("Frame",name,parent)
    textureFrame:SetParent(parent)
    textureFrame:SetBackdrop(ns.defaults.backdrop)
    textureFrame:SetBackdropColor(0, 0, 0, 0.8)
    textureFrame:SetBackdropBorderColor(0, 0, 0, 1)


    -- Texture
    local texture = textureFrame.texture or textureFrame:CreateTexture(nil, 'OVERLAY')
    ns.InsetFrame(texture, textureFrame, 1)
    if options.texture then
      texture:SetTexture(options.texture)
    end
    textureFrame.texture = texture

    for name, func in pairs(methods) do
      textureFrame[name] = func
    end


    return textureFrame
  end

  local funcs = {
    'ApplyBackdrop'
  }


  UIElements.RegisterFrameType('Texture',constructor,funcs)

end