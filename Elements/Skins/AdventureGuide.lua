local addon, ns = ...
local L = ns.L
local key = 'AdventureGuide'
local name = 'Adventure Guide'
local obj = ns.CreateNewModule("Skins_"..key)
local registeredSkins = {}

ns.skins.RegisterSkin(key, name)

function obj:Initialize()
  local opt = ns.options
  local SF = ns.UIElements.defaultFunc
  local db = ns.DB.profile.skins[key]

  local function SkinFrame()
    LoadAddOn('Blizzard_EncounterJournal')
    local mainFrame = _G['EncounterJournal']
    SF.ApplyBackdrop(mainFrame)
    ns.skins.SkinClose(mainFrame.CloseButton)
    -- SF.ApplyBackdrop(mainFrame.TitleBg)
  end
  if db then
    C_Timer.After(0.4,SkinFrame)
  end

  function obj:Refresh()
    print('Prompt Reload')
  end

end



