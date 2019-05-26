local addon, ns = ...
local L = ns.L
local key = 'gamemenu'
local name = 'Game Menu'
local obj = ns.CreateNewModule("Skins_"..key, 2)

ns.skins.RegisterSkin(key, name)

function obj:Initialize()
  local opt = ns.options
  local UI = ns.UIElements
  local SF = ns.UIElements.defaultFunc
  local db = ns.DB.profile.skins[key]
  local skins = ns.skins


  local function StripTextures(t, mainFrame)
    for k,v in pairs(t) do
      if (mainFrame[k] and type(v) == 'table') then
        StripTextures(v,mainFrame[k])
      elseif mainFrame[v] then
        ns.StripTextures(mainFrame[v])
      end
    end
  end

  local function SkinFrame()
    if not db then return end
    local mainFrame = _G['GameMenuFrame']

    for i,v in ipairs({mainFrame:GetChildren()}) do
      if (v:GetObjectType() == 'Button') then
        skins.SkinButton(v)
      end
    end
    for _, f in ipairs({mainFrame:GetRegions()}) do
      if (f:GetObjectType() == 'Texture') then
        ns.StripTextures(f)
      else
        f:Hide()
      end
    end

    SF.ApplyBackdrop(mainFrame)

    local header = UI.CreateFrame('Panel', nil, mainFrame)
    header:SetSize(100,26)
    header:SetPoint('TOP', 0, 13)
    header:SetText(L["Game Menu"])


  end

  SkinFrame()
  -- local frame = CreateFrame("Frame")
  -- frame:RegisterEvent("ADDON_LOADED")
  -- frame:SetScript("OnEvent", function(self, event, addonName)
  --   if addonName == 'Blizzard_EncounterJournal' then
  --     SkinFrame()
  --     frame:UnregisterEvent("ADDON_LOADED")
  --   end
  -- end)

  function obj:Refresh()
    ns.ReloadPopup()
  end

end



