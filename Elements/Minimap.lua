local addon, ns = ...
local L = ns.L
ns.Initialize(
  function()
    local opt = ns.options
    local parentId = "elements"
    local id = "minimap"
    local text = "Minimap"
    local sortOrder = 10
    local db = ns.DB.profile.minimap
    local M = _G.Minimap

    local function Resize()
      M:SetWidth(db.width)
      M:SetHeight(db.height)
    end

    local shapeMasks = {
      rectangle = [[Interface\AddOns\Oof\Media\Textures\Square_White]],
      round = [[Interface\AddOns\Oof\Media\Textures\circle_white]],
      hexagon = [[Interface\AddOns\Oof\Media\Textures\hexagon_white]],
      diamond = [[Interface\AddOns\Oof\Media\Textures\diamond_white]],
    }
    local function Reshape()
      M:SetMaskTexture(shapeMasks[db.shape] or shapeMasks.rectangle)
    end

    M:ClearAllPoints()
    M:SetPoint("CENTER",UIParent)

    local function SkinMinimap()
      local bg = CreateFrame("Frame",nil, UIParent)
      bg:SetBackdrop(ns.defaults.backdrop)
      bg:SetBackdropColor(0,0,0,1)
      bg:SetBackdropBorderColor(0,0,0,1)
      bg:SetPoint("TOPLEFT",M,-1,1)
      bg:SetPoint("BOTTOMRIGHT",M, 1, -1)
      local frameStrata, frameLevel = M:GetFrameStrata(), M:GetFrameLevel()
      bg:SetFrameStrata(frameStrata)
      bg:SetFrameLevel(frameLevel-1)
    end

    Reshape()
    Resize()
    SkinMinimap()



    -- OPTIONS CONFIG --
    local options = {
      type = "group",
      name = "Minimap",
      args = {
        shape = {
          order = 0,
          name = L["Shape"],
          type = "select",
          values = {
            rectangle = L['Rectangle'],
            round = L['Round'],
            hexagon = L['Hexagon'],
            diamond = L['Diamond'],
          },
          get = function() return db.shape end,
          set = function(self, value)
            db.shape = value
            Reshape()
          end,
        },
        width = {
          order = 10,
          name = L["Width"],
          type = "range",
          min = 0,
          max = 700,
          step = 1,
          get = function() return db.width end,
          set = function(self, width)
            db.width = width
            Resize()
          end,
        },
        height = {
          order = 20,
          name = L["Height"],
          type = "range",
          min = 0,
          max = 700,
          step = 1,
          get = function() return db.height end,
          set = function(self, height)
            db.height = height
            Resize()
          end,
        }
      }
    }
    opt.RegisterListItem(parentId, id, text, sortOrder, options)
  end
)



