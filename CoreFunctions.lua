local addon, ns = ...
local L = ns.L
local obj = ns.CreateNewModule("core_functions")

function obj:Initialize()
end

StaticPopupDialogs["Oof_Reload"] = {
  text = L["To see selected changes you have to reload UI.\n Reload now?"],
  button1 = "Reload",
  button3 = "Cancel",
  hasEditBox = false,
  OnAccept = function(self)
    ReloadUI()
  end,
  timeout = 0,
  cancels = "Oof_Reload",
  whileDead = true,
  hideOnEscape = 1,
  preferredIndex = 4,
  showAlert = 0,
  enterClicksFirstButton = 1
}

function ns.ReloadPopup()
  StaticPopup_Show("Oof_Reload")
end

function ns.SetupFont(fontString, font, size, flag)
  font = font and ns.LSM:Fetch('font',font) or ns.defaults.font
  size = size or ns.defaults.fontSize
  flag = flag or ns.defaults.fontFlag
  fontString:SetFont(font, size, flag)
	fontString:SetShadowColor(0, 0, 0, (flag and flag ~= 'NONE' and 0.2) or 1)
	fontString:SetShadowOffset(1, -1)
end

function ns.FormatTime(timeLeft)
  local days = math.floor(timeLeft / 86400)
  timeLeft = timeLeft - (days * 86400)
  local hours = math.floor(timeLeft / 3600)
  timeLeft = timeLeft - (hours * 3600)
  local minutes = math.floor(timeLeft / 60)
  timeLeft = timeLeft - (minutes * 60)
  local seconds = timeLeft

  if days > 0 then
    return string.format("%dd",days)
  elseif hours > 0 then
    return string.format("%dh",hours)
  elseif minutes > 0 then
    return string.format("%dm",minutes)
  elseif seconds > 5 then
    return string.format("%is",seconds)
  else
    return string.format("%.1f",seconds)
  end

end

local textureFunctions = {
  'SetTexture','SetPushedTexture','SetNormalTexture','SetHighlightTexture','SetHighlight',"SetDisabledTexture"
}

function ns.StripTextures(frame)
  for _, func in ipairs(textureFunctions) do
    if frame[func] then frame[func](frame,nil) end
  end
end

local prefix = 'Oof'
function ns.ReplaceFunctions(frame,funcs)
  for _, funcName in pairs(funcs) do
    local customName = prefix .. funcName
    if not frame[customName] then
      frame[customName] = frame[funcName]
      frame[funcName] = function() end
    end
  end
  return prefix
end


function ns.InsetFrame(frame,parent,padding)
  frame:ClearAllPoints()
  frame:SetPoint("TOPLEFT",parent,padding, -padding)
  frame:SetPoint("BOTTOMRIGHT",parent,-padding, padding)
end

function ns.InitTexture(frame)
  local tex = frame:CreateTexture(nil,'OVERLAY')
  tex:SetAllPoints()
  return tex
end

function ns.MergeTables(target, additional)
  for k,v in pairs(additional) do
    target[k] = v
  end
  return target
end

function ns.Offset(frame, xOff, yOff)
  local numPoints = frame:GetNumPoints()

  for i = 1, numPoints do
    local p, rt, rp, x, y = frame:GetPoint(i)
    frame:SetPoint(p, rt, rp, x + xOff, y + yOff)
  end
end


local hsvFrame = CreateFrame("Colorselect")

-- HSV transition, for a much prettier color transition in many cases
-- see http://www.wowinterface.com/forums/showthread.php?t=48236
local function GetHSVTransition(perc, r1, g1, b1, a1, r2, g2, b2, a2)
  --get hsv color for colorA
  hsvFrame:SetColorRGB(r1, g1, b1)
  local h1, s1, v1 = hsvFrame:GetColorHSV() -- hue, saturation, value
  --get hsv color for colorB
  hsvFrame:SetColorRGB(r2, g2, b2)
  local h2, s2, v2 = hsvFrame:GetColorHSV() -- hue, saturation, value
  local h3 = floor(h1 - (h1 - h2) * perc)
  -- find the shortest arc through the color circle, then interpolate
  local diff = h2 - h1
  if diff < -180 then
    diff = diff + 360
  elseif diff > 180 then
    diff = diff - 360
  end

  h3 = (h1 + perc * diff) % 360
  local s3 = s1 - ( s1 - s2 ) * perc
  local v3 = v1 - ( v1 - v2 ) * perc
  --get the RGB values of the new color
  hsvFrame:SetColorHSV(h3, s3, v3)
  local r, g, b = hsvFrame:GetColorRGB()
  --interpolate alpha
  local a = a1 - ( a1 - a2 ) * perc
  --return the new color
  return r, g, b, a
end


function ns.ColorTransformAnimation(progress, r, g, b, a, r1, g1, b1, a1)
  return GetHSVTransition(progress, r, g, b, a, r1, g1, b1, a1)
end