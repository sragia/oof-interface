local addon, ns = ...
local obj = ns.CreateNewModule("Options_SwitchBoard")

function obj:Initialize()
  local UIElements = ns.UIElements
  local opt = ns.options
  local switchContainer = opt.container.buttonContainer
  local L = ns.L
  ns.switchBoard = {}
  local switchBtns = {
    { -- 1
      text = "Elements",
      id = 'elements'
    },
    { -- 2
      text = L['Media'],
      id = 'media',
      removeList = true,
      optionsTable = {
        type = "group",
        name = L["Media"],
        args = {
        }
      },
      order = 0
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

  local function AddToOptionsTable(id, selfId,  options)
    local optionsTable
    local order = 0
    for _, data in ipairs(switchBtns) do
      if data.id == id then
        optionsTable = data.optionsTable
        order = data.order
        data.order = data.order + 100
        break
      end
    end

    for i, v in pairs(options) do
      v.order = v.order + order
      optionsTable.args[selfId .. i] = v
    end

  end
  ns.switchBoard.AddToOptionsTable = AddToOptionsTable

end