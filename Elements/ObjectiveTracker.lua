local addon, ns = ...
local L = ns.L
local obj = ns.CreateNewModule("Elements_ObjectiveTracker")

function obj:Initialize()
  local opt = ns.options
  local parentId = "elements"
  local id = "objectivetracker"
  local text = L['Objective Tracker']
  local sortOrder = 60
  local db = ns.DB.profile.objectiveTracker
  local mover = ns.mover
  local f = _G['ObjectiveTrackerFrame']

  local oldSetPoint = f.SetPoint
  f.OofSetPoint = oldSetPoint
  f.SetPoint = function() end

  function obj:Refresh()
    f:ClearAllPoints()
    f:OofSetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", db.x, db.y + db.height)
    f:SetSize(235, db.height)
    f:SetScale(db.scale)
  end
  C_Timer.After(0.3,function() obj:Refresh() end)

  local function Move(left,bottom)
    db.x = left
    db.y = bottom
    obj:Refresh()
  end

  mover.CreateMovableElement(L['Objective Tracker'], f, Move)


  -- OPTIONS CONFIG --
  local options = {
    type = "group",
    name = L['Objective Tracker'],
    args = {
      heightss = {
        type = 'range',
        name = L['Max Height'],
        min = 50,
        max = 1000,
        order = 1,
        get = function() return db.height end,
        set = function(self,value)
          db.height = value
          obj:Refresh()
        end,
      },
      scale = {
        type = 'range',
        name = L['Scale'],
        min = 0,
        max = 2,
        order = 2,
        get = function() return db.scale end,
        set = function(self,value)
          db.scale = value
          obj:Refresh()
        end,
      }
    }
  }


  opt.RegisterListItem(parentId, id, text, sortOrder, options)
end



