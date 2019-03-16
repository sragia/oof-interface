local addon, ns = ...

local L = ns.L
local obj = ns.CreateNewModule("Options_Frame")

function obj:Initialize()
  local UIElements = ns.UIElements
  local options = ns.options
  local containers = {}
  -- Create Mover Frame
  local moverContainer = UIElements.CreateFrame("Panel",nil,UIParent)
  moverContainer:SetAllPoints()
  moverContainer:Hide()
  moverContainer.shown = false
  moverContainer:SetFrameStrata("DIALOG")
  moverContainer:SetFrameLevel(30)

  local moverToolBoxContainer = UIElements.CreateFrame("Panel",nil,moverContainer)
  moverToolBoxContainer:SetSize(135, 30)
  moverToolBoxContainer:SetPoint("TOP")
  moverToolBoxContainer:SetFrameStrata("TOOLTIP")
  moverToolBoxContainer:SetMovable(true)
  moverToolBoxContainer:EnableMouse(true)
  moverToolBoxContainer:RegisterForDrag("LeftButton")
  moverToolBoxContainer:SetScript("OnDragStart", moverToolBoxContainer.StartMoving)
  moverToolBoxContainer:SetScript("OnDragStop", moverToolBoxContainer.StopMovingOrSizing)

  local nudgeBtns = {
    {
      texture = [[Interface\AddOns\Oof\Media\Textures\nudge_left]],
      inc = false,
      axis = 'x',
      point = "BOTTOM",
      offsetY = 10,
      offsetX = -9,
    },
    {
      texture = [[Interface\AddOns\Oof\Media\Textures\nudge_right]],
      inc = true,
      axis = 'x',
      point = "BOTTOM",
      offsetY = 10,
      offsetX = 9,
    },
    {
      texture = [[Interface\AddOns\Oof\Media\Textures\nudge_down]],
      inc = false,
      axis = 'y',
      point = "RIGHT",
      offsetY = -9,
      offsetX = -10,
    },
    {
      texture = [[Interface\AddOns\Oof\Media\Textures\nudge_up]],
      inc = true,
      axis = 'y',
      point = "RIGHT",
      offsetY = 9,
      offsetX = -10,
    },
  }
  local function AddNudgeButton(container)
    container.nudge = {}
    local nudgeContainer = container.nudgeContainer or CreateFrame("Frame",nil,container)
    container.nudgeContainer = nudgeContainer
    nudgeContainer:ClearAllPoints()
    nudgeContainer:SetAllPoints(container)
    nudgeContainer:SetAlpha(0)
    local strata, level = container:GetFrameStrata(), container:GetFrameLevel()
    nudgeContainer:SetFrameStrata(strata)
    nudgeContainer:SetFrameLevel(level + 1)
    -- Texts
    local x,y = container:GetRect()
    local xOffsFrame = UIElements.CreateFrame('Text',nil, nudgeContainer)
    nudgeContainer.xText = xOffsFrame
    xOffsFrame:SetText(string.format("%i",x))
    xOffsFrame:SetPoint("BOTTOM",0, 30)
    xOffsFrame:SetSize(20,10)
    table.insert(container.nudge,xOffsFrame)
    local yOffsFrame = UIElements.CreateFrame('Text',nil, nudgeContainer)
    nudgeContainer.yText = yOffsFrame
    yOffsFrame:SetText(string.format("%i",y))
    yOffsFrame:SetPoint("RIGHT",-30, 0)
    yOffsFrame:SetSize(20,10)
    table.insert(container.nudge,yOffsFrame)
    -- Buttons
    for _, btnData in ipairs(nudgeBtns) do
      local btn = UIElements.CreateFrame("Button", nil, nudgeContainer,{color = {0,0,0,1}, texture = btnData.texture})
      table.insert(container.nudge,btn)
      btn:SetSize(16,16)
      btn:SetPoint(btnData.point,btnData.offsetX,btnData.offsetY)
      btn:SetScript("OnClick", function()
        container:ClearAllPoints()
        local xOffs, yOffs = container:GetRect()
        xOffs = btnData.axis == 'x' and (btnData.inc and xOffs + 1 or xOffs - 1) or xOffs
        yOffs = btnData.axis == 'y' and (btnData.inc and yOffs + 1 or yOffs - 1) or yOffs
        container:SetPoint(
          "BOTTOMLEFT",
          xOffs,
          yOffs
        )
        xOffsFrame:SetText(string.format("%i",xOffs))
        yOffsFrame:SetText(string.format("%i",yOffs))
        container.setter(xOffs,yOffs)
      end)
    end
    container:SetScript("OnEnter", function(self)
      self.nudgeContainer:SetAlpha(1)
    end)
    container:SetScript("OnLeave",function(self)
      if not MouseIsOver(self) then
        self.nudgeContainer:SetAlpha(0)
      end
    end)
  end

  local movers = {}

  local function SetupMovers()
    for _, container in ipairs(containers) do
      local f = UIElements.CreateFrame("Panel", nil, moverContainer)
      f:SetClampedToScreen(true)
      f:SetText(container.name)
      f:SetFontSize(20)
      f.setter = container.setter
      table.insert(movers, f)
      local left,bottom,width,height = container.frame:GetRect()
      container.values = {left,bottom}
      f:SetFrameStrata("FULLSCREEN")
      f:SetFrameLevel(99)
      f:SetPoint("BOTTOMLEFT",UIParent,left,bottom)
      f:SetSize(width, height)
      f:SetAlpha(0.9)
      f:SetBackdropBorderColor(.5,.5,.5,1)
      AddNudgeButton(f)
      -- Draggable
      f:SetMovable(true)
      f:EnableMouse(true)
      f:RegisterForDrag("LeftButton")
      f:SetScript("OnDragStart", f.StartMoving)

      local function stopMoving(self)
        self:StopMovingOrSizing();
        self.isMoving = false;
        local left,bottom,width,height = self:GetRect()
        container.setter(left,bottom)
        self.nudgeContainer.xText:SetText(string.format("%i",left))
        self.nudgeContainer.yText:SetText(string.format("%i",bottom))
      end
      f:SetScript("OnDragStop", stopMoving)
    end
  end


  local function ToggleMover()
    moverContainer.shown = not moverContainer.shown
    if moverContainer.shown then
      moverContainer:Show()
      options.container:Hide()
      SetupMovers()
    else
      for id, mover in ipairs(movers) do
        movers[id] = nil
        -- nudgeBtns
        for _, nudge in ipairs(mover.nudge) do
          nudge:Release()
        end
        mover.nudge = nil
        mover:Release()
      end
      moverContainer:Hide()
      options.container:Show()
    end
  end

  local function CancelValues()
    for _, container in ipairs(containers) do
      container.setter(unpack(container.values))
    end
    ToggleMover()
  end

  local applyBtn = UIElements.CreateFrame("Button",nil, moverToolBoxContainer,{ justification = "CENTER", color = {0.08,0.08,0.08,1}, borderColor = {0,0,0,1}})
  applyBtn.text:SetText(L["Apply"])
  applyBtn:SetPoint("TOPLEFT",5, -5)
  applyBtn:SetPoint("BOTTOMLEFT",5, 5)
  applyBtn:SetWidth(60)
  applyBtn:SetScript("OnClick",ToggleMover)

  local cancelBtn = UIElements.CreateFrame("Button",nil, moverToolBoxContainer,{ justification = "CENTER", color = {0.08,0.08,0.08,1}, borderColor = {0,0,0,1}})
  cancelBtn.text:SetText(L["Cancel"])
  cancelBtn:SetPoint("TOPLEFT",70, -5)
  cancelBtn:SetPoint("BOTTOMLEFT",70, 5)
  cancelBtn:SetWidth(60)
  cancelBtn:SetScript("OnClick",CancelValues)


  -- Open Button
  local openBtn = UIElements.CreateFrame("Button", nil, options.container.titleBar,{ justification = "CENTER"})
  openBtn:SetPoint("TOPRIGHT",-2,-2)
  openBtn:SetPoint("BOTTOMRIGHT", -2, 2)
  openBtn:SetWidth(60)
  openBtn:SetText(L["Unlock"])
  openBtn:ApplyBackdrop()
  openBtn:SetScript("OnClick",ToggleMover)


  -- TEMP
  local fstack = UIElements.CreateFrame("Button", nil, options.container.titleBar,{ justification = "CENTER"})
  fstack:SetPoint("TOPRIGHT", openBtn, "TOPLEFT", -2,0)
  fstack:SetPoint("BOTTOMRIGHT", openBtn, "BOTTOMLEFT", -2, 0)
  fstack:SetWidth(80)
  fstack:SetText(L["/fstack"])
  fstack:ApplyBackdrop()
  fstack:SetScript("OnClick",function()
    LoadAddOn("Blizzard_DebugTools");
		FrameStackTooltip_ToggleDefaults();
  end )

  local reload = UIElements.CreateFrame("Button", nil, options.container.titleBar,{ justification = "CENTER"})
  reload:SetPoint("TOPRIGHT", fstack, "TOPLEFT", -2,0)
  reload:SetPoint("BOTTOMRIGHT", fstack, "BOTTOMLEFT", -2, 0)
  reload:SetWidth(80)
  reload:SetText(L["Reload"])
  reload:ApplyBackdrop()
  reload:SetScript("OnClick",function()
    ReloadUI();
  end )

  -- TEMP



  function ns.mover.CreateMovableElement(name, targetContainer, setter)
    containers[#containers + 1] = {
      name = name,
      frame = targetContainer,
      setter = setter,
      values = {}, -- Holds starting ("TRUE") values left,bottom,width,height
    }
  end

  local fun

end