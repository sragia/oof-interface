local addon, ns = ...
local L = ns.L
local obj = ns.CreateNewModule("Elements_Skins")
local registeredSkins = {}
local UI = ns.UIElements
local SF = UI.defaultFunc

local buttonTexs = {
  'Left', 'Middle', 'Right','BottomLeft','MiddleMiddle','MiddleRight','MiddleLeft','BottomMiddle','BottomRight','TopLeft','TopMiddle','TopRight',
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
  ScrollDown = {
    Disabled = 'scroll_down_disabled',
    Highlight = 'btn_highlight',
    Normal = 'scroll_down',
    Pushed = 'scroll_down'
  },
  ScrollUp = {
    Disabled = 'scroll_up_disabled',
    Highlight = 'btn_highlight',
    Normal = 'scroll_up',
    Pushed = 'scroll_up'
  },
  ThumbTexture = 'scroll_thumb',
  DownButton = {
    Disabled = 'scroll_down_disabled',
    Highlight = 'btn_highlight',
    Normal = 'scroll_down',
    Pushed = 'scroll_down'
  },
  UpButton = {
    Disabled = 'scroll_up_disabled',
    Highlight = 'btn_highlight',
    Normal = 'scroll_up',
    Pushed = 'scroll_up'
  },
  thumbTexture = 'scroll_thumb',
}
local alternativeScrollBarTexLoc = {
  scrollDown = {
    Disabled = 'scroll_down_disabled',
    Highlight = 'btn_highlight',
    Normal = 'scroll_down',
    Pushed = 'scroll_down'
  },
  scrollUp = {
    Disabled = 'scroll_up_disabled',
    Highlight = 'btn_highlight',
    Normal = 'scroll_up',
    Pushed = 'scroll_up'
  },
}
local function SkinScrollBarButtons(t,frame)
  for k,v in pairs(t) do
    if (frame[k] and type(v) == 'table') then
      SkinScrollBarButtons(v,frame[k])
    elseif frame[k] then
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
    if (frame[k] and type(v) == 'table') then
      StripDropdownTex(v,frame[k])
    elseif frame[v] then
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

local tabTexturesLoc = {
  'LeftDisabled','Left','MiddleDisabled','Middle','RightDisabled','Right','HighlightTexture'
}

local inputTexLoc = {
  'Left', 'Middle', 'Right', 'Mid'
}

local descriptionTexLoc = {
  'BottomLeftTex',
  'BottomTex',
  'BottomRightTex',
  'LeftTex',
  'MiddleTex',
  'RightTex',
  'TopLeftTex',
  'TopTex',
  'TopRightTex',
}

local searchTexLoc = {
    'Left',
    'Middle',
    'Right'

}

local blueMenuTexLoc = {
  'BLCorner',
  'BRCorner',
  'BottomBar',
  'LeftBar',
  'RightBar',
  'TLCorner',
  'TRCorner',
  'TopBar'
}

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
  AddBackdrop = function(frame)
    local bg = frame.OofBackdrop or CreateFrame('Frame', nil, frame)
    UI.defaultFunc.ApplyBackdrop(bg)
    bg:SetAllPoints(frame)
    bg:SetFrameStrata("LOW")
    frame.OofBackdrop = bg
  end,
  SkinPanelText = function(text)
    text:ClearAllPoints()
    text:SetPoint("TOPLEFT", 10, 10)
    text:SetPoint("TOPRIGHT",-30, 10)
    text:SetJustifyH("LEFT")
    local font, size, flag = text:GetFont()
    text:SetFont(font, 32, flag)
  end,
  SkinButton = function(button,options)
    ns.StripTextures(button)
    local opt = {justification = "CENTER"}
    ns.MergeTables(opt, options or {})
    button = UI.UpgradeExistingFrame('Button',button,button:GetParent(),opt)
    for _, tex in ipairs(buttonTexs) do
      if button[tex] then
        ns.StripTextures(button[tex])
        ns.ReplaceFunctions(button[tex],{'SetTexture'})
      end
    end
    if button.Text then
      button.Text:Hide()
      button:SetText(button.Text:GetText())
    elseif button:GetFontString() then
      button:GetFontString():Hide()
      button:SetText(button:GetFontString():GetText())
    end
    button:ApplyBackdrop()
  end,
  SkinScrollBar = function(scrollbar)
    local bar = scrollbar.ScrollBar or scrollbar.scrollBar
    for _, tex in ipairs({scrollbar:GetRegions()}) do
      ns.StripTextures(tex)
    end
    for _, tex in ipairs({bar:GetRegions()}) do
      ns.StripTextures(tex)
    end

    SkinScrollBarButtons(scrollbarTex, bar)
    SkinScrollBarButtons(alternativeScrollBarTexLoc, scrollbar)
    UI.defaultFunc.ApplyBackdrop(bar)

    for _, texLoc in ipairs({
      'Bottom','Middle','Top','ScrollBarBottom','ScrollBarMiddle','ScrollBarTop'
    }) do
      if bar[texLoc] then
        ns.StripTextures(bar[texLoc])
      end
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
  SkinSearch = function(searchBox)
    UI.defaultFunc.ApplyBackdrop(searchBox)

    searchBox:SetTextInsets(22,22,0,0)
    -- Search icon
    local searchIcon = searchBox.searchIcon
    searchIcon:ClearAllPoints()
    searchIcon:SetPoint("LEFT",5,-2)
    searchIcon:SetSize(16,16)
    -- Search Instructions
    local searchInstructions = searchBox.Instructions
    searchInstructions:ClearAllPoints()
    searchInstructions:SetPoint("TOPLEFT", 22, 0)
    searchInstructions:SetPoint("BOTTOMRIGHT",-22, 0)

    for _, tex in ipairs(searchTexLoc) do
      if searchBox[tex] then
        ns.StripTextures(searchBox[tex])
      end
    end
  end,
  SkinDropdown = function(dropdown)
    if not (dropdown.skinned) then

      StripDropdownTex(dropdownTexLoc, dropdown)

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
      text.OofSetPoint = text.SetPoint
      text.SetPoint = function(self, point, relativeTo, relativePoint, x, y)
        text:ClearAllPoints()
        if point:find("LEFT") then
          text:OofSetPoint(point,relativeTo,relativePoint,x - 10,0)
        else
          text:OofSetPoint("RIGHT",-39, 1)
        end
      end
      text:SetPoint(text:GetPoint())


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
  SkinTab = function(tab, parent, options)
    ns.StripTextures(tab)
    for _, texLoc in ipairs(tabTexturesLoc) do
      ns.StripTextures(_G[tab:GetName() .. texLoc])
    end
    ns.skins.SkinButton(tab, options)
    local point, relativeTo, relativePoint, x, y = tab:GetPoint()

    tab:ClearAllPoints()
    if point == "LEFT" then
      -- n-th button
      tab:SetPoint(point, relativeTo, relativePoint, 1, 0)
    else
      -- first
      tab:SetPoint(point, parent or relativeTo, relativePoint, x, y - 1)
    end
  end,
  SkinInput = function(input)
    for _, tex in ipairs(inputTexLoc) do
      if input[tex] then
        ns.StripTextures(input[tex])
      end
    end
    input:SetTextInsets(5,5,0,0)
    UI.defaultFunc.ApplyBackdrop(input)
    if input.Instructions then
      input.Instructions:ClearAllPoints()
      input.Instructions:SetPoint("TOPLEFT", 5, 0)
      input.Instructions:SetPoint("BOTTOMRIGHT", -5, 0)
    end
  end,
  SkinDescription = function(desc)
    for _, tex in ipairs(descriptionTexLoc) do
      if desc[tex] then
        ns.StripTextures(desc[tex])
      end
    end

    local bd = CreateFrame("Frame",nil, desc)
    UI.defaultFunc.ApplyBackdrop(bd)
    bd:SetAllPoints()
    bd:SetFrameLevel(desc:GetFrameLevel() - 1)
    desc.backdrop = bd

    local input = desc.EditBox
    input:SetTextInsets(5,5,5,5)
    input.Instructions:ClearAllPoints()
    input.Instructions:SetPoint("TOPLEFT", 5, -5)
    input.Instructions:SetPoint("BOTTOMRIGHT", -5, 5)

    ns.skins.SkinScrollBar(desc)
  end,
  SkinMenuButton = function(menuBtn)
    ns.skins.SkinButton(menuBtn)
  end,
  SkinHelpButton = function(helpBtn)
    helpBtn:ClearAllPoints()
    helpBtn:SetPoint("TOPRIGHT", -13, 25)
  end,
  SkinPrevNextButton = function(btn, isPrev)
    local tex = isPrev and 'icon_left' or 'icon_right'
    ns.skins.SkinButton(btn,{texture = ns.GetTexture(tex)})
    btn.texture:SetVertexColor(1,1,1,0.9)
    ns.InsetFrame(btn.texture, btn, 6)
  end,
  SkinStatusBar = function(statusbar)
    for _, f in ipairs({statusbar:GetRegions()}) do
      if (f:GetObjectType() == 'Texture') then
        ns.StripTextures(f)
      end
    end

    ns.skins.AddBackdrop(statusbar)
    ns.InsetFrame(statusbar.OofBackdrop, statusbar, -1)
    statusbar:SetStatusBarTexture(ns.LSM:Fetch('statusbar','Oof_SlightGradient'))
  end,
  SkinPanelTabs = function(pattern, parent, offX, offY)
    for i = 1, 5 do
      local f = _G[pattern:format(i)]
      if f then
        ns.skins.SkinTab(f, parent, {disabledTextColor = { 1, 0.73, 0.07, 1}, animTextColor = true})
        f:SetParent(parent)
        if i == 1 then
          offX = offX or 0
          offY = offY or 0
          ns.Offset(f, offX, offY)
        end
        ns.ReplaceFunctions(f, {'SetPoint', 'ClearAllPoints'})
      else
        break
      end
    end
  end,
  SkinMinMaxButton = function(minmaxframe, closebtn)
    minmaxframe.MaximizeButton:ClearAllPoints()
    minmaxframe.MaximizeButton:SetPoint('RIGHT',closebtn,'LEFT',-3,0)
    minmaxframe.MinimizeButton:ClearAllPoints()
    minmaxframe.MinimizeButton:SetPoint('RIGHT',closebtn,'LEFT',-3,0)
    ns.skins.SkinButton(minmaxframe.MaximizeButton,{texture = ns.GetTexture('maximize'), width = 20, height = 20, textureInset = 3})
    ns.skins.SkinButton(minmaxframe.MinimizeButton,{texture = ns.GetTexture('minimize'), width = 20, height = 20, textureInset = 3})
  end,
  FindAndSkinBlueMenu = function(frame)
    for _, f in ipairs({frame:GetChildren()}) do
      if ( f.BLCorner ) then
        for _, tex in ipairs(blueMenuTexLoc) do
          if f[tex] then
            ns.StripTextures(f[tex])
          end
        end
      end
    end
  end
}


function obj:Initialize()
  local opt = ns.options
  local parentId = "elements"
  local id = "skins"
  local text = L['Skins']
  local sortOrder = 100
  local db = ns.DB.profile.skins



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



