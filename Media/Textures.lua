local addon, ns = ...
local L = ns.L
local obj = ns.CreateNewModule("Media_Fonts")
local dir = [[Interface/Addons/Oof/Media/]]

local statusBarTextures = {
  "Textures/Oof_Blank",
  "Textures/Oof_Darkened",
  "Textures/Oof_Noisy",
  "Textures/Oof_SlightGradient"
}
function obj:Initialize()
  for _, tex in ipairs(statusBarTextures) do
    ns.LSM:Register("statusbar",tex, dir .. tex)
  end
end

local textureMap = {
  checkmark = 'Icons/check.tga',
  close = 'Icons/close.tga',
  logolarge = 'Icons/logo-large.tga',
  logosmall = 'Icons/logo-small.tga',
  person = 'Icons/person.tga',
  speech = 'Icons/speech.tga',
  volume = 'Icons/volume.tga',
  headphones = 'Icons/headphones.tga',
  deafened = 'Icons/headphones-deafened.tga',
  mic = 'Icons/mic.tga',
  muted = 'Icons/mic-muted.tga',
  invoice = 'Icons/invoice.tga',
  copy = 'Icons/copy.tga',
  EJ_Portrait = 'Skins/EJ_Portrait.tga'
}

function ns.GetTexture(texture)
  if textureMap[texture] then
    return dir .. textureMap[texture]
  end
end