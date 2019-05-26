local addon, ns = ...

local obj = ns.CreateNewModule("Broker_Guild")
local L = ns.L

function obj:Initialize()
  local UIElements = ns.UIElements
  local eventFrame = CreateFrame("Frame")
  local ldb = LibStub:GetLibrary('LibDataBroker-1.1')
  local fontDB = ns.DB.profile.media.fonts
  local classIconPath = "Interface\\ICONS\\ClassIcon_"
  eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
  eventFrame:RegisterEvent("GUILD_ROSTER_UPDATE")
  eventFrame:RegisterEvent("PLAYER_GUILD_UPDATE")

  local onlinePlayers = {
    --[[
      { playerName,
        zone,
        level,
        rank (int),
        class
        }
    ]]
  }


  local totalMembers, onlineMembers = 0, 0

  local function UpdateGuildRoster()
    totalMembers, onlineMembers = GetNumGuildMembers()
    wipe(onlinePlayers)
    for i = 1 , totalMembers do
      local name, rank, rankIndex, level, class, zone, note,
      officernote, online, status, classFileName,
      achievementPoints, achievementRank, isMobile, isSoREligible, standingID = GetGuildRosterInfo(i)
      if online then
        table.insert(onlinePlayers, {
          playerName = Ambiguate(name, 'short'),
          zone = zone,
          class = class,
          classFileName = classFileName,
          level = level,
          rank = rank,
        })
      end
   end
   obj:UpdateText()
  end
  eventFrame:SetScript('OnEvent', UpdateGuildRoster)

  local function PopulateTooltip(tooltip)

    -- Header
    local lineNum = tooltip:AddLine()
    tooltip:SetCell(lineNum, 1, L['Guild'], "LEFT", 3)
    tooltip:SetCell(lineNum, 4, string.format("%i/%i", onlineMembers, totalMembers), "RIGHT")
    tooltip:AddLine()
    tooltip:AddLine()
    tooltip:AddLine()
    for _, player in ipairs(onlinePlayers) do
      local classColor =  C_ClassColor.GetClassColor(player.classFileName)
      local lineNum = tooltip:AddLine(player.level, string.format("\124T%s%s:15:15:0:0:20:20:2:18:2:18\124t %s", classIconPath, player.classFileName, classColor:WrapTextInColorCode(player.playerName)))
      tooltip:SetCell(lineNum, 4, string.format("|cffaaaaaa%s|r", player.zone), "RIGHT")
    end

  end

  local function GetTooltip()
    local tooltip = UIElements.CreateFrame('Tooltip','Oof_Guild_Broker', nil, {columns = 4})
    ViragDevTool_AddData(tooltip)
    tooltip:ApplyBackdrop()
    tooltip:Show()

    tooltip:SetBodyFont(ns.GetFont(fontDB.defaultFont), 12)

    return tooltip
  end

  local function MouseOverCheck(broker)
    broker.time = 0
    broker.elapsed = 0
    broker:SetScript("OnUpdate",function(self, elapsed)
      self.time = self.time + elapsed
      if self.time > 0.1 then
        if self:IsMouseOver() or self.tooltip:IsMouseOver() then
          self.elapsed = 0
        else
          self.tooltipActive = false
          self.tooltip:ReleaseTooltip()
          self:SetScript("OnUpdate", nil)
        end
        self.time = 0
      end
    end)
  end

  local function OnShow(self)
    if self.tooltipActive then return end

    local tooltip = GetTooltip()
    self.tooltipActive = true
    self.tooltip = tooltip
    tooltip:SmartAnchorTo(self)
    PopulateTooltip(tooltip)
    MouseOverCheck(self)
  end

  LDB_Oof_Guild = ldb:NewDataObject("Oof Guild",{
    type = "data source",
    text = "Oof Guild",
    icon = ns.GetTexture('guild'),
    OnEnter = OnShow,
    OnClick = function() ToggleGuildFrame() end
  })

  function obj:UpdateText()
    LDB_Oof_Guild.text = string.format("%s: %i", L['Guild'], onlineMembers)
  end

end