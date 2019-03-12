local addon, ns = ...
local L = ns.L
local obj = ns.CreateNewModule("Elements_Skins")
local registeredSkins = {}

ns.skins = {
  RegisterSkin = function(key, displayName)
    table.insert(registeredSkins, { displayName = displayName, key = key })
  end,
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
        local skinModule = ns.GetModule('Skins_'..skin.key)
        if skinModule then
          skinModule:Refresh()
        end
      end
    }
  end
  opt.RegisterListItem(parentId, id, text, sortOrder, options)
end



