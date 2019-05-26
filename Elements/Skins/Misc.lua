local addon, ns = ...
local L = ns.L
local key = 'misc'
local name = 'Miscellaneous'
local obj = ns.CreateNewModule("Skins_"..key, 2)

ns.skins.RegisterSkin(key, name)

function obj:Initialize()
  local opt = ns.options
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

  local function SkinPopups()
    for i=1,5 do
      local popup = _G['StaticPopup'..i]

      if popup then
        SF.ApplyBackdrop(popup)
        for j = 1, 5 do
          local btn = popup['button'..j]
          if btn then
            skins.SkinButton(btn)
          end
        end
        ns.StripTextures(_G['StaticPopup' .. i .. 'EditBoxLeft'])
        ns.StripTextures(_G['StaticPopup' .. i .. 'EditBoxRight'])
        ns.StripTextures(_G['StaticPopup' .. i .. 'EditBoxMid'])
        SF.ApplyBackdrop(popup.editBox)
        popup.editBox:SetTextInsets(5,5,0,0)
      end
    end
  end

  local function SkinDropdowns()
    -- Skin Dropdown Menu
    for i= 1, 5 do
      local dropdownList = _G['DropDownList' .. i]
      if dropdownList then
        local dropdownListBackdrop = _G['DropDownList' .. i .. 'Backdrop']
        ns.UIElements.defaultFunc.ApplyBackdrop(dropdownListBackdrop)
        ns.StripTextures(dropdownList)
        ns.UIElements.defaultFunc.ApplyBackdrop(_G['DropDownList' .. i .. 'MenuBackdrop'])
      end
    end
  end

  local function SkinFrames()
    SkinPopups()
    SkinDropdowns()


  end

  if db then
    C_Timer.After(0.2, SkinFrames)

  -- local frame = CreateFrame("Frame")
  -- frame:RegisterEvent("ADDON_LOADED")
  -- frame:SetScript("OnEvent", function(self, event, addonName)
  --   if addonName == 'Blizzard_EncounterJournal' then
  --     SkinFrame()
  --     frame:UnregisterEvent("ADDON_LOADED")
  --   end
  -- end)
  end
  function obj:Refresh()
    ns.ReloadPopup()
  end

end



