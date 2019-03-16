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