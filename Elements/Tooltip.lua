local addon, ns = ...
local L = ns.L
local obj = ns.CreateNewModule("Elements_Tooltip")

function obj:Initialize()
  local opt = ns.options
  local parentId = "elements"
  local id = "tooltip"
  local text = "Tooltip"
  local sortOrder = 20


  -- OPTIONS CONFIG --
  local options = {
    type = "group",
    name = addon,
    args = {
      version ={
        order = 0.1,
        name = "|cfff4bf42"..L["Version"]..":|r " .. "2131231232",
        type = "description",
        width = "full"
      },
      author ={
        order = 0.2,
        name = "|cfff4bf42"..L["Author"]..":|r Exality - Silvermoon EU 123\n\n",
        type = "description",
        width = "full"
      },
    }
  }
  print('run231')
  opt.RegisterListItem(parentId, id, text, sortOrder, options)
end



