local addon, ns = ...
local L = ns.L
local obj = ns.CreateNewModule("Elements_Skins")
local registeredSkins = {}
local UI = ns.UIElements
local SF = UI.defaultFunc

local buttonTexs = {
  'Left', 'Middle', 'Right'
}

local scrollbarTex = {
  ScrollDownButton = {
    Disabled = 'scroll_down_disabled',
    Highlight = 'btn_highlight',
    Normal = 'scroll_down',
    Pushed = 'scroll_down'
  },
  ScrollUpButton = {
    Disabled = 'scroll_up_disabled',
    Highlight = 'btn_highlight',
    Normal = 'scroll_up',
    Pushed = 'scroll_up'
  },
  ThumbTexture = 'scroll_thumb'
}
local function SkinScrollBarButtons(t,frame)
  for k,v in pairs(t) do
    if (type(v) == 'table') then
      SkinScrollBarButtons(v,frame[k])
    else
      frame[k]:SetTexture(ns.GetTexture(v))
      -- (ULx,ULy,LLx,LLy,URx,URy,LRx,LRy)
      frame[k]:SetTexCoord(.15,.20,.15,.80,.85,.20,.85,.80)
    end
  end
end


local dropdownTexLoc = {
  'Left','Middle','Right'
}

local function StripDropdownTex(t,frame)
  for k,v in pairs(t) do
    if (type(v) == 'table') then
      StripDropdownTex(v,frame[k])
    else
      ns.StripTextures(frame[v])
    end
  end
end

local dropdownButton = {
  DisabledTexture = 'dropdown_down_disabled',
  HighlightTexture = 'btn_highlight',
  NormalTexture = 'dropdown_down',
  PushedTexture = 'dropdown_down'
}

local function SkinButton(t, frame)
  for texLoc, tex  in pairs(t) do
    ns.StripTextures(frame[texLoc])
    frame[texLoc]:SetTexture(ns.GetTexture(tex))
    frame[texLoc]:ClearAllPoints()
    frame[texLoc]:SetAllPoints()
  end
end


ns.skins = {
  RegisterSkin = function(key, displayName)
    table.insert(registeredSkins, { displayName = displayName, key = key })
  end,
  SkinClose = function(frame)
    frame = UI.UpgradeExistingFrame('Button',frame,frame:GetParent())
    frame:ApplyBackdrop()
    ns.StripTextures(frame)

    local tex = ns.InitTexture(frame)
    tex:SetTexture(ns.GetTexture('close'))

    frame:ClearAllPoints()
    frame:SetPoint("TOPRIGHT", -1, -1)
    frame:SetSize(20,20)
    ns.InsetFrame(tex, frame, 2)

  end,
  SkinPanelText = function(text)
    text:ClearAllPoints()
    text:SetPoint("TOPLEFT", 10, 10)
    local font, size, flag = text:GetFont()
    text:SetFont(font, 32, flag)
  end,
  SkinButton = function(button)
    ns.StripTextures(button)
    button = UI.UpgradeExistingFrame('Button',button,button:GetParent(),{justification = 'CENTER'})
    for _, tex in ipairs(buttonTexs) do
      if button[tex] then
        ns.StripTextures(button[tex])
        ns.ReplaceFunctions(button[tex],{'SetTexture'})
      end
    end
    button.Text:Hide()
    button:ApplyBackdrop()
  end,
  SkinScrollBar = function(scrollbar)
    SkinScrollBarButtons(scrollbarTex, scrollbar.ScrollBar)
    UI.defaultFunc.ApplyBackdrop(scrollbar.ScrollBar)
    for _, tex in ipairs({scrollbar:GetRegions()}) do
      ns.StripTextures(tex)
    end
  end,
  SkinCheckbox = function(checkbox)
    if not (checkbox.skinned) then
      ns.StripTextures(checkbox)
      local w, h = checkbox:GetSize()
      checkbox.backdrop = CreateFrame('Frame',nil,checkbox)
      checkbox.backdrop:SetFrameLevel(checkbox:GetFrameLevel())
      UI.defaultFunc.ApplyBackdrop(checkbox.backdrop)
      ns.InsetFrame(checkbox.backdrop, checkbox, 3)

      if checkbox.SetCheckedTexture then
        checkbox:SetCheckedTexture(ns.GetTexture('checkmark'))
        local check = checkbox:GetCheckedTexture()
        check:ClearAllPoints()
        check:SetSize(w * 0.9, h * 0.9)
        check:SetPoint('LEFT',(w - (w * 0.9) + 1),1)
        check:SetVertexColor(1, 0.8, 0, 1)
      end
      ns.ReplaceFunctions(checkbox,{'SetCheckedTexture'})
      checkbox.skinned = true
    end
  end,
  SkinDropdown = function(dropdown)
    if not (dropdown.skinned) then

      StripDropdownTex(dropdownTexLoc, dropdown)
      -- UI.defaultFunc.ApplyBackdrop(dropdown)

      -- Backdrop
      local bd = CreateFrame("Frame",nil, dropdown)
      UI.defaultFunc.ApplyBackdrop(bd)
      bd:SetPoint("TOPLEFT", 8, -3)
      bd:SetPoint("BOTTOMRIGHT", -16, 6)
      dropdown.backdrop = bd
      local h = bd:GetHeight()

      dropdown:SetFrameLevel(bd:GetFrameLevel() + 1)
      bd:SetFrameLevel(dropdown:GetFrameLevel() - 1)
      -- Text
      local text = dropdown.Text
      text:ClearAllPoints()
      text:SetPoint("RIGHT",-39, 1)


      -- Button
      local btn = dropdown.Button
      SkinButton(dropdownButton, btn)
      btn:SetSize(h, h)
      btn:ClearAllPoints()
      btn:SetPoint("TOPRIGHT", -16, -3)
      btn:SetBackdrop(nil)


      dropdown.skinned = true
    end
  end,
}


function obj:Initialize()
  local opt = ns.options
  local parentId = "elements"
  local id = "skins"
  local text = L['Skins']
  local sortOrder = 100
  local db = ns.DB.profile.skins

  -- Skin Dropdown Menu
  local dropdownListBackdrop = _G['DropDownList1Backdrop']
  ns.UIElements.defaultFunc.ApplyBackdrop(dropdownListBackdrop)
  local dropdownList = _G['DropDownList1']
  ns.StripTextures(dropdownList)


  -- OPTIONS CONFIG --
  local options = {
    type = "group",
    name = addon,
    args = {
      Skins ={
        order = 1,
        name = L['Skins'],
        type = "description",
        width = "full",
        fontSize = "large"
      },
    }
  }
  local order = 10
  for _, skin in ipairs(registeredSkins) do
    options.args[skin.key] = {
      type = 'toggle',
      name = skin.displayName,
      order = order + 1,
      get = function() return db[skin.key] end,
      set = function(self,value)
        db[skin.key] = value
        local skinModule = ns:GetModule('Skins_'..skin.key)
        if skinModule then
          skinModule:Refresh()
        end
      end
    }
  end
  opt.RegisterListItem(parentId, id, text, sortOrder, options)
end



