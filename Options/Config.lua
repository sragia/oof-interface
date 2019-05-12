local addon, ns = ...
local obj = ns.CreateNewModule("Options_Config")

function obj:Initialize()
  local AceConfig = LibStub("AceConfig-3.0")
  local AceConfigDialog = LibStub("AceConfigDialog-3.0")
  local opt = ns.options
  local buttonCache = {}
  local UIElements = ns.UIElements
  local listContainer = opt.container.configContainer.containerList
  local configContainer = opt.container.configContainer
  local containerOptions = configContainer.containerOptions
  local currentListItem
  local highlight = {0.21, 0.16, 0, 1}

  local listItems = {
      --[[
          [parentId] = {
              [id] = {
                  text = "",
                  sortOrder = 0,
                  optionsTable = "",
              }
          }
      ]]
  }

  --[[
  "global" functions:
      RegisterListItem(parentId, id, text, sortOrder, optionsTable)
      SwitchLists(parentId)
  ]]

  local function spairs(t, order)
    -- collect the keys
    local keys = {}
    for k in pairs(t) do keys[#keys + 1] = k end

    -- if order function given, sort by it by passing the table and keys a, b,
    -- otherwise just sort the keys
    if order then
    table.sort(keys, function(a, b) return order(t, a, b) end)
    else
    table.sort(keys)
    end

    -- return the iterator function
    local i = 0
    return function()
    i = i + 1
    if keys[i] then
        return keys[i], t[keys[i]]
    end
    end
  end


  local function SwitchConfig(options)
    if options then
      AceConfig:RegisterOptionsTable("Oof_List", options);
      AceConfigDialog:Open("Oof_List", configContainer.containerOptions)

      -- Highlight button
      if buttonCache[currentListItem] then
        buttonCache[currentListItem]:Highlight(unpack(highlight))
      end

    end
  end

  local function RemoveHighlight()
    if buttonCache[currentListItem] then
      buttonCache[currentListItem]:ResetColor()
    end
  end

  local function AddButtonToList(parentId, id,optionsTable)
    local uid = parentId .. id
    local button = buttonCache[uid]
    local r, g, b, a = 0, 0, 0, 1
    if not button then
      button = UIElements.CreateFrame("Button",nil, listContainer)
      buttonCache[uid] = button
      button:ApplyBackdrop(r,g,b,a);
    end

    -- setup button --
    local data = listItems[parentId][id]
    if data then
      button:SetText(data.text)
      button.sortOrder = data.sortOrder
      button.optionsTable = optionsTable or data.optionsTable
      button:SetHeight(20)
      button.id = id
      button:SetScript("OnClick",function(self)
        RemoveHighlight()
        currentListItem = uid
        SwitchConfig(optionsTable or data.optionsTable)
      end)
      button.shown = true
    end

  end

  local function RefreshList()
    local i = 0
    for id, btn in spairs(buttonCache, function(t,a,b) return t[a].sortOrder < t[b].sortOrder end) do
      if btn.shown then
        i = i + 1
        btn:ClearAllPoints()
        local yOffset = 5 + (i-1)  + (i-1) * 20
        btn:SetPoint("TOPLEFT", listContainer, 5, -yOffset)
        btn:SetPoint("TOPRIGHT", listContainer, -5, -yOffset)
        if i == 1 then
          RemoveHighlight()
          currentListItem = id
          SwitchConfig(btn.optionsTable)
        end
      end
    end
  end

  local function RegisterListItem(parentId, id, text, sortOrder, optionsTable)
    listItems[parentId] = listItems[parentId] or {}
    listItems[parentId][id] = listItems[parentId][id] or {
      text = text,
      sortOrder = sortOrder,
      optionsTable = optionsTable
    }

  end
  opt.RegisterListItem = RegisterListItem


  function opt.RefreshListOptions(parentId, id, optionsTable, justUpdate)
    if listItems[parentId] and listItems[parentId][id] then
      listItems[parentId][id].optionsTable = optionsTable
      -- SwitchConfig(optionsTable)
      if not justUpdate then
        AceConfig:RegisterOptionsTable("Oof_List", optionsTable);
      end
    end
  end

  local function ClearList()
    for id, btn in pairs(buttonCache) do
      if btn.shown then
        btn:ClearAllPoints()
        btn.shown = false
      end
    end
  end

  local function SwitchLists(parentId, removeList, optionsTable)
    local list = listItems[parentId]
    if not list and not optionsTable then print('Unknown list',parentId) return end

    if removeList then
      containerOptions:FillContainer()
      SwitchConfig(optionsTable)
      return
    else
      containerOptions:ResetPosition()
    end

    ClearList()
    for id, data in pairs(list) do
      AddButtonToList(parentId, id, optionsTable)
    end
    RefreshList()
  end

  opt.SwitchLists = SwitchLists
  opt.frameStrataValues = {
    [1] = "BACKGROUND",
    [2] = "LOW",
    [3] = "MEDIUM",
    [4] = "HIGH",
    [5] = "DIALOG",
    [6] = "FULLSCREEN",
    [7] = "FULLSCREEN_DIALOG",
    [8] = "TOOLTIP"
  }
end