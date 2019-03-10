local addon, ns = ...
local obj = ns.CreateNewModule("Options_SwitchBoard")

function obj:Initialize()
  local UIElements = ns.UIElements
  local opt = ns.options
  local switchContainer = opt.container.buttonContainer

  local switchBtns = {
    { -- 1
      text = "Elements",
      id = 'elements'
    },
    { -- 4
      text = "Profiles",
      id = "profile",
      removeList = true,
      optionsTable = LibStub("AceDBOptions-3.0"):GetOptionsTable(ns.DB),
    }
  }

  local i = 1
  local maxWidth = switchContainer:GetWidth() - 5
  local btnWidth = ( maxWidth / #switchBtns ) - 5
  local btnHeight = switchContainer:GetHeight() - 10
  for _, data in ipairs(switchBtns) do
    local btn = UIElements.CreateFrame("Button",nil, switchContainer)
    btn:ApplyBackdrop(0.129, 0.129, 0.129, 1)
    btn.text:SetText(data.text)
    btn.text:ClearAllPoints()
    btn.text:SetPoint("CENTER")
    btn:SetFontSize(15)
    btn:SetWidth(btnWidth)
    btn:SetHeight(btnHeight)
    local xOffset = 5 * i + (i - 1) * btnWidth
    btn:SetPoint("LEFT", xOffset, 0)
    btn:SetScript("OnClick", function() opt.SwitchLists(data.id, data.removeList,data.optionsTable) end)
    i = i + 1
  end
end