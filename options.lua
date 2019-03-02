local addon, ns = ...
local L = ns.L
local AceGUI = LibStub("AceGUI-3.0")
local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local options = {}
local currentParent
local UIElem = ns.UIElements

local function spairs(t, order)
  -- collect the keys
  local keys = {}
  for k in pairs(t) do keys[#keys + 1] = k end

  -- if order function given, sort by it by passing the table and keys a, b,
  -- otherwise just sort the keys
  if order then
    table.sort(keys, function(a, b) return order(t, a, b) end)
  else
    table.sort(keys)
  end

  -- return the iterator function
  local i = 0
  return function()
    i = i + 1
    if keys[i] then
      return keys[i], t[keys[i]]
    end
  end
end

local BACKDROP = {
    bgFile = "Interface\\BUTTONS\\WHITE8X8.blp",
    edgeFile = "Interface\\BUTTONS\\WHITE8X8.blp",
    tile = false,
    tileSize = 0,
    edgeSize = 1,
    insets = {
        left = 0,
        right = 0,
        top = 0,
        bottom = 0
    }
}

local ICONS = {
    CLOSE = [[Interface\Addons\Oof\Media\Icons\close]],
    CHECK = [[Interface\Addons\Oof\Media\Icons\check]],
}

local function ApplyBackdrop(frame, r, g, b, a)
    r = r or 0
    g = g or 0
    b = b or 0
    a = a or 0.7

    frame:SetBackdrop(BACKDROP)
    frame:SetBackdropColor(r, g, b, a)
    frame:SetBackdropBorderColor(r, g, b, a + 0.3)
end



local frame = CreateFrame("Frame","OOF_OptionsFrame",UIParent)
frame:SetPoint("CENTER",0,0)
frame:SetSize(900,600)
ApplyBackdrop(frame)
frame:SetMovable(true)
frame:EnableMouse(true)
frame:RegisterForDrag("LeftButton")
frame:SetScript("OnDragStart", frame.StartMoving)
frame:SetScript("OnDragStop", frame.StopMovingOrSizing)

-- frame:Hide()
frame.shown = true

local function ToggleOptions()
    frame.shown = not frame.shown
    if frame.shown then
        frame:Show()
    else
        frame:Hide()
    end
end
ns.ToggleOptions = ToggleOptions
OOF_ToggleOptions = ToggleOptions


local closeBtn = CreateFrame("BUTTON",nil,frame)
frame.closeBtn = closeBtn
closeBtn:SetSize(20,20)
closeBtn:SetPoint("TOPRIGHT",-5,-5)
local closeTex = closeBtn:CreateTexture(nil,"OVERLAY")
closeTex:SetTexture(ICONS.CLOSE)
closeTex:SetPoint("CENTER")
closeTex:SetSize(15,15)

closeBtn:SetScript("OnClick",ToggleOptions)
ApplyBackdrop(closeBtn)

local titleBar = CreateFrame("Frame",nil,frame)
frame.titleBar = titleBar
titleBar:SetPoint("TOPLEFT", 5, -5)
titleBar:SetPoint("BOTTOMRIGHT", closeBtn, "BOTTOMLEFT", -3, 0)
ApplyBackdrop(titleBar,0,0,0,0.4)

local addonLogo = titleBar:CreateTexture(nil, "OVERLAY")
addonLogo:SetSize(32,32)
addonLogo:SetTexture(ns.defaults.logoSmall)
addonLogo:SetPoint("LEFT",0,0)

local addonTitle = titleBar:CreateFontString(nil, "OVERLAY")
addonTitle:SetPoint("LEFT",addonLogo, "RIGHT", 5, 0)
addonTitle:SetFont(ns.defaults.font,11)
local addonVersion = GetAddOnMetadata(addon, "version")
local titleString = string.format("%s v%s", WrapTextInColorCode(addon, "ffC49D49"), addonVersion)
addonTitle:SetText(titleString)

-- PARENT BUTTONS --

local buttonContainer = CreateFrame("Frame", nil, frame)
frame.buttonContainer = buttonContainer
buttonContainer:SetPoint("TOPLEFT", titleBar, "BOTTOMLEFT", 0, -5)
buttonContainer:SetPoint("TOPRIGHT", closeBtn, "BOTTOMRIGHT", 0, -5)
buttonContainer:SetHeight(40)
ApplyBackdrop(buttonContainer, 0, 0, 0, 0.4)

local configContainer = CreateFrame("Frame", nil, frame)
frame.configContainer = configContainer
configContainer:SetPoint("TOPLEFT", buttonContainer, "BOTTOMLEFT", 0, -5)
configContainer:SetPoint("BOTTOMRIGHT", -5, 5)
ApplyBackdrop(configContainer, 0, 0, 0, 0.4)


-- BUTTON LIST --

local containerList = CreateFrame("Frame",nil, frame);
containerList:SetPoint('TOPLEFT', configContainer, 5, -5)
containerList:SetPoint('BOTTOMLEFT', configContainer, 5, 5)
containerList:SetWidth(200)
ApplyBackdrop(containerList, 0, 0, 0, 0.4)

local function SwitchConfig(id)
    local opt = options[id]
    if opt then
        AceConfig:RegisterOptionsTable("Oof_List", opt);
        AceConfigDialog:Open("Oof_List", frame.containerOptions)
    end
end

buttonCache = {}

local btnH = 20
local btnMargin = 5

local function CreateButton(id,text,sortOrder)
    local button = UIElem.CreateFrame('Button', nil, frame)
    local r, g, b, a = 0, 0, 0, 1
    button:ApplyBackdrop(r,g,b,a);
    button:SetHeight(btnH)
    button.sortOrder = sortOrder
    button.id = id

    local buttonText = button:CreateFontString(nil, "OVERLAY")
    buttonText:SetFont(ns.defaults.font,11)
    buttonText:SetPoint("LEFT",2,0)
    buttonText:SetText(text)

    button:SetScript("OnEnter",function() button:SetBackdropColor(r + 0.2, g + 0.2, b + 0.2, a) end)
    button:SetScript("OnLeave",function() button:SetBackdropColor(r, g, b, a) end)
    button:SetScript("OnClick",function(self) SwitchConfig(self.id) end)

    return button
end

local function AddButtonToList(id, text, sortOrder)
    if not buttonCache[id] then
        local button = CreateButton(id,text,sortOrder)
        buttonCache[id] = button
    end

    local i = 0
    for id, btn in spairs(buttonCache, function(t,a,b) return t[a].sortOrder < t[b].sortOrder end) do
        i = i + 1
        btn:ClearAllPoints()
        local yOffset = (i * btnMargin) + (i-1) * btnH
        btn:SetPoint("TOPLEFT", containerList, btnMargin, -yOffset)
        btn:SetPoint("TOPRIGHT", containerList, -btnMargin, -yOffset)
    end
end
local containerOptions = AceGUI:Create("InlineGroup");
containerOptions.frame:SetParent(frame)
containerOptions.frame:SetPoint('TOPLEFT', containerList, "TOPRIGHT", 5, 17)
containerOptions.frame:SetPoint('BOTTOMRIGHT',configContainer,  -5, 2)
containerOptions.titletext:Hide()
ApplyBackdrop(containerOptions.content:GetParent(), 0, 0, 0, 0.4)
frame.containerOptions = containerOptions

options['123'] = {
    type = "group",
    name = addon,
    args = {
      version ={
        order = 0.1,
        name = "|cfff4bf42"..L["Version"]..":|r " .. addonVersion,
        type = "description",
        width = "full"
      },
      author ={
        order = 0.2,
        name = "|cfff4bf42"..L["Author"]..":|r Exality - Silvermoon EU 123\n\n",
        type = "description",
        width = "full"
      },
    }
}

options['321'] = {
    type = "group",
    name = addon,
    args = {
      version ={
        order = 0.1,
        name = "|cfff4bf42"..L["Version"]..":|r " .. addonVersion,
        type = "description",
        width = "full"
      },
      author ={
        order = 0.2,
        name = "|cfff4bf42"..L["Author"]..":|r Exality - Silvermoon EU 321\n\n",
        type = "description",
        width = "full"
      },
    }
}


function TestButtons()
    local text = string.format("2TEST")
    AddButtonToList('123',text,12)
    AddButtonToList('321',"123OOOO",23)
end
TestButtons()


