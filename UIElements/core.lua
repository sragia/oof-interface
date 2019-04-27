local addon, ns = ...
local obj = ns.CreateNewModule("UI_Core")

function obj:Initialize()
  local UIElements = ns.UIElements

  local elementTypes = {}

  local function ApplyBackdrop(self, r, g, b, a)
    r = r or 0
    g = g or 0
    b = b or 0
    a = a or 0.7

    self:SetBackdrop(ns.defaults.backdrop)
    self:SetBackdropColor(r, g, b, a)
    self:SetBackdropBorderColor(r, g, b, a + 0.3)
    self.defaultColor = {r,g,b,a}
    self.currentColor = {r,g,b,a}
  end

  UIElements.ApplyBackdrop = ApplyBackdrop

  local function RegisterFrameType(type,const,funcs)
    elementTypes[type] = {
      constructor = const,
      funcs = funcs
    }
  end

  local framePool = {}

  local function Release(self)
    self:Clear()
    self:ClearAllPoints()
    self.free = true
  end

  local function CreateFrame(type,name,parent,options)
    if framePool[type] then
      for _, f in ipairs(framePool[type]) do
        if f.free then
          f:Clear()
          f.free = false
          f = elementTypes[type].constructor(name,parent,options,f)
          return f
        end
      end
    else
      framePool[type] = {}
    end

    if elementTypes[type] then
      local element = elementTypes[type].constructor(name,parent,options)
      table.insert(framePool[type],element)
      element.free = false
      element.Release = Release

      if elementTypes[type].funcs then
        for _, funcName in ipairs(elementTypes[type].funcs) do
          if UIElements.defaultFunc[funcName] then
            element[funcName] = UIElements.defaultFunc[funcName]
          end
        end
      end
      return element
    end
  end

  local function UpgradeExistingFrame(type,frame,parent,options)
    if elementTypes[type] then
      local element = elementTypes[type].constructor(nil, parent, options, frame)
      if elementTypes[type].funcs then
        for _, funcName in ipairs(elementTypes[type].funcs) do
          if UIElements.defaultFunc[funcName] then
            element[funcName] = UIElements.defaultFunc[funcName]
          end
        end
      end
      return element
    end
    return frame
  end

  UIElements.RegisterFrameType = RegisterFrameType
  UIElements.CreateFrame = CreateFrame
  UIElements.UpgradeExistingFrame = UpgradeExistingFrame
  UIElements.defaultFunc = {
    ApplyBackdrop = ApplyBackdrop
  }
end
