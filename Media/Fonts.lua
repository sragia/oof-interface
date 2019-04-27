local addon, ns = ...
local L = ns.L
local obj = ns.CreateNewModule("Media_Fonts")
ns.LSM:Register('font','CharlesWright',[[Interface\Addons\Oof\Media\Font\CharlesWright.ttf]])
function obj:Initialize()
  local db = ns.DB.profile.media.fonts

  local blizzardFonts = {
    {
      ["flag"] = "OUTLINE",
      ["name"] = "GameFontNormalLeft",
      ["size"] = 10,
    }, -- [1]
    {
      ["flag"] = "OUTLINE",
      ["name"] = "GameFontNormalLeftBottom",
      ["size"] = 10,
    }, -- [2]
    {
      ["flag"] = "OUTLINE",
      ["name"] = "GameFontNormalLeftGreen",
      ["size"] = 10,
    }, -- [3]
    {
      ["flag"] = "OUTLINE",
      ["name"] = "GameFontNormalLeftYellow",
      ["size"] = 10,
    }, -- [4]
    {
      ["flag"] = "OUTLINE",
      ["name"] = "GameFontNormalLeftOrange",
      ["size"] = 10,
    }, -- [5]
    {
      ["flag"] = "OUTLINE",
      ["name"] = "GameFontNormalLeftLightGreen",
      ["size"] = 10,
    }, -- [6]
    {
      ["flag"] = "OUTLINE",
      ["name"] = "GameFontNormalLeftGrey",
      ["size"] = 10,
    }, -- [7]
    {
      ["flag"] = "OUTLINE",
      ["name"] = "GameFontNormalLeftRed",
      ["size"] = 10,
    }, -- [8]
    {
      ["flag"] = "",
      ["name"] = "GameFontDisableMed3",
      ["size"] = 13.9999990463257,
    }, -- [9]
    {
      ["flag"] = "",
      ["name"] = "GameFontHighlightRight",
      ["size"] = 12,
    }, -- [10]
    {
      ["flag"] = "",
      ["name"] = "GameFontHighlightLarge2",
      ["size"] = 18,
    }, -- [11]
    {
      ["flag"] = "",
      ["name"] = "GameFontDisableLeft",
      ["size"] = 12,
    }, -- [12]
    {
      ["flag"] = "",
      ["name"] = "GameFontGreen",
      ["size"] = 12,
    }, -- [13]
    {
      ["flag"] = "",
      ["name"] = "GameFontWhiteSmall",
      ["size"] = 10,
    }, -- [14]
    {
      ["flag"] = "OUTLINE",
      ["name"] = "GameFontNormalSmallLeft",
      ["size"] = 10,
    }, -- [15]
    {
      ["flag"] = "OUTLINE",
      ["name"] = "GameFontHighlightSmallLeftTop",
      ["size"] = 10,
    }, -- [16]
    {
      ["flag"] = "OUTLINE",
      ["name"] = "GameFontHighlightSmallRight",
      ["size"] = 10,
    }, -- [17]
    {
      ["flag"] = "OUTLINE",
      ["name"] = "GameFontHighlightExtraSmall",
      ["size"] = 10,
    }, -- [18]
    {
      ["flag"] = "OUTLINE",
      ["name"] = "GameFontHighlightExtraSmallLeft",
      ["size"] = 10,
    }, -- [19]
    {
      ["flag"] = "OUTLINE",
      ["name"] = "GameFontHighlightExtraSmallLeftTop",
      ["size"] = 10,
    }, -- [20]
    {
      ["flag"] = "OUTLINE",
      ["name"] = "GameFontNormalGraySmall",
      ["size"] = 10,
    }, -- [21]
    {
      ["flag"] = "OUTLINE",
      ["name"] = "GameFontGreenSmall",
      ["size"] = 10,
    }, -- [22]
    {
      ["flag"] = "OUTLINE",
      ["name"] = "GameFontRedSmall",
      ["size"] = 10,
    }, -- [23]
    {
      ["flag"] = "OUTLINE",
      ["name"] = "GameFontHighlightSmallOutline",
      ["size"] = 10,
    }, -- [24]
    {
      ["flag"] = "",
      ["name"] = "GameFontNormalLargeLeft",
      ["size"] = 16,
    }, -- [25]
    {
      ["flag"] = "",
      ["name"] = "GameFontNormalLargeLeftTop",
      ["size"] = 16,
    }, -- [26]
    {
      ["flag"] = "",
      ["name"] = "GameFontGreenLarge",
      ["size"] = 16,
    }, -- [27]
    {
      ["flag"] = "",
      ["name"] = "GameFontNormalHugeBlack",
      ["size"] = 20,
    }, -- [28]
    {
      ["flag"] = "",
      ["name"] = "BossEmoteNormalHuge",
      ["size"] = 25,
    }, -- [29]
    {
      ["flag"] = "OUTLINE",
      ["name"] = "NumberFontNormal",
      ["size"] = 13.9999990463257,
    }, -- [30]
    {
      ["flag"] = "OUTLINE",
      ["name"] = "NumberFontNormalRight",
      ["size"] = 13.9999990463257,
    }, -- [31]
    {
      ["flag"] = "OUTLINE",
      ["name"] = "NumberFontNormalRightRed",
      ["size"] = 13.9999990463257,
    }, -- [32]
    {
      ["flag"] = "OUTLINE",
      ["name"] = "NumberFontNormalRightYellow",
      ["size"] = 13.9999990463257,
    }, -- [33]
    {
      ["flag"] = "OUTLINE",
      ["name"] = "NumberFontNormalRightGray",
      ["size"] = 13.9999990463257,
    }, -- [34]
    {
      ["flag"] = "OUTLINE",
      ["name"] = "NumberFontNormalYellow",
      ["size"] = 13.9999990463257,
    }, -- [35]
    {
      ["flag"] = "OUTLINE, THICKOUTLINE, MONOCHROME",
      ["name"] = "NumberFontNormalSmall",
      ["size"] = 12,
    }, -- [36]
    {
      ["flag"] = "OUTLINE, THICKOUTLINE, MONOCHROME",
      ["name"] = "NumberFontNormalSmallGray",
      ["size"] = 12,
    }, -- [37]
    {
      ["flag"] = "OUTLINE",
      ["name"] = "NumberFontNormalLarge",
      ["size"] = 16,
    }, -- [38]
    {
      ["flag"] = "OUTLINE",
      ["name"] = "NumberFontNormalLargeRight",
      ["size"] = 16,
    }, -- [39]
    {
      ["flag"] = "OUTLINE",
      ["name"] = "NumberFontNormalLargeRightRed",
      ["size"] = 16,
    }, -- [40]
    {
      ["flag"] = "OUTLINE",
      ["name"] = "NumberFontNormalLargeRightYellow",
      ["size"] = 16,
    }, -- [41]
    {
      ["flag"] = "OUTLINE",
      ["name"] = "NumberFontNormalLargeRightGray",
      ["size"] = 16,
    }, -- [42]
    {
      ["flag"] = "OUTLINE",
      ["name"] = "NumberFontNormalLargeYellow",
      ["size"] = 16,
    }, -- [43]
    {
      ["flag"] = "OUTLINE",
      ["name"] = "NumberFontNormalHuge",
      ["size"] = 30,
    }, -- [44]
    {
      ["flag"] = "",
      ["name"] = "QuestTitleFont",
      ["size"] = 18,
    }, -- [45]
    {
      ["flag"] = "",
      ["name"] = "QuestTitleFontBlackShadow",
      ["size"] = 18,
    }, -- [46]
    {
      ["flag"] = "",
      ["name"] = "QuestFont",
      ["size"] = 13.0000009536743,
    }, -- [47]
    {
      ["flag"] = "",
      ["name"] = "QuestFontLeft",
      ["size"] = 13.0000009536743,
    }, -- [48]
    {
      ["flag"] = "",
      ["name"] = "QuestFontNormalSmall",
      ["size"] = 12,
    }, -- [49]
    {
      ["flag"] = "OUTLINE",
      ["name"] = "QuestDifficulty_Impossible",
      ["size"] = 10,
    }, -- [50]
    {
      ["flag"] = "OUTLINE",
      ["name"] = "QuestDifficulty_VeryDifficult",
      ["size"] = 10,
    }, -- [51]
    {
      ["flag"] = "OUTLINE",
      ["name"] = "QuestDifficulty_Difficult",
      ["size"] = 10,
    }, -- [52]
    {
      ["flag"] = "OUTLINE",
      ["name"] = "QuestDifficulty_Standard",
      ["size"] = 10,
    }, -- [53]
    {
      ["flag"] = "OUTLINE",
      ["name"] = "QuestDifficulty_Trivial",
      ["size"] = 10,
    }, -- [54]
    {
      ["flag"] = "OUTLINE",
      ["name"] = "QuestDifficulty_Header",
      ["size"] = 10,
    }, -- [55]
    {
      ["flag"] = "",
      ["name"] = "ItemTextFontNormal",
      ["size"] = 15,
    }, -- [56]
    {
      ["flag"] = "",
      ["name"] = "MailTextFontNormal",
      ["size"] = 15,
    }, -- [57]
    {
      ["flag"] = "",
      ["name"] = "SubSpellFont",
      ["size"] = 10,
    }, -- [58]
    {
      ["flag"] = "",
      ["name"] = "DialogButtonNormalText",
      ["size"] = 16,
    }, -- [59]
    {
      ["flag"] = "",
      ["name"] = "DialogButtonHighlightText",
      ["size"] = 16,
    }, -- [60]
    {
      ["flag"] = "OUTLINE, THICKOUTLINE",
      ["name"] = "ZoneTextFont",
      ["size"] = 32,
    }, -- [61]
    {
      ["flag"] = "OUTLINE, THICKOUTLINE",
      ["name"] = "SubZoneTextFont",
      ["size"] = 26.0000019073486,
    }, -- [62]
    {
      ["flag"] = "OUTLINE, THICKOUTLINE",
      ["name"] = "PVPInfoTextFont",
      ["size"] = 22.0000019073486,
    }, -- [63]
    {
      ["flag"] = "",
      ["name"] = "ErrorFont",
      ["size"] = 16,
    }, -- [64]
    {
      ["flag"] = "OUTLINE",
      ["name"] = "TextStatusBarText",
      ["size"] = 10,
    }, -- [65]
    {
      ["flag"] = "",
      ["name"] = "GameNormalNumberFont",
      ["size"] = 10,
    }, -- [66]
    {
      ["flag"] = "",
      ["name"] = "WhiteNormalNumberFont",
      ["size"] = 10,
    }, -- [67]
    {
      ["flag"] = "OUTLINE",
      ["name"] = "TextStatusBarTextLarge",
      ["size"] = 13.0000009536743,
    }, -- [68]
    {
      ["flag"] = "",
      ["name"] = "CombatLogFont",
      ["size"] = 12,
    }, -- [69]
    {
      ["flag"] = "OUTLINE, THICKOUTLINE",
      ["name"] = "WorldMapTextFont",
      ["size"] = 32,
    }, -- [70]
    {
      ["flag"] = "",
      ["name"] = "InvoiceTextFontNormal",
      ["size"] = 12,
    }, -- [71]
    {
      ["flag"] = "",
      ["name"] = "InvoiceTextFontSmall",
      ["size"] = 10,
    }, -- [72]
    {
      ["flag"] = "",
      ["name"] = "CombatTextFont",
      ["size"] = 100256.7578125,
    }, -- [73]
    {
      ["flag"] = "OUTLINE, THICKOUTLINE",
      ["name"] = "CombatTextFontOutline",
      ["size"] = 100256.7578125,
    }, -- [74]
    {
      ["flag"] = "OUTLINE",
      ["name"] = "MovieSubtitleFont",
      ["size"] = 22.0000019073486,
    }, -- [75]
    {
      ["flag"] = "",
      ["name"] = "AchievementPointsFont",
      ["size"] = 16,
    }, -- [76]
    {
      ["flag"] = "",
      ["name"] = "AchievementPointsFontSmall",
      ["size"] = 12,
    }, -- [77]
    {
      ["flag"] = "",
      ["name"] = "AchievementDescriptionFont",
      ["size"] = 10,
    }, -- [78]
    {
      ["flag"] = "",
      ["name"] = "AchievementCriteriaFont",
      ["size"] = 10,
    }, -- [79]
    {
      ["flag"] = "",
      ["name"] = "AchievementDateFont",
      ["size"] = 10,
    }, -- [80]
    {
      ["flag"] = "",
      ["name"] = "VehicleMenuBarStatusBarText",
      ["size"] = 12,
    }, -- [81]
    {
      ["flag"] = "",
      ["name"] = "FocusFontSmall",
      ["size"] = 13.9999990463257,
    }, -- [82]
    {
      ["flag"] = "",
      ["name"] = "ObjectiveFont",
      ["size"] = 12,
    }, -- [83]
    {
      ["flag"] = "",
      ["name"] = "ArtifactAppearanceSetNormalFont",
      ["size"] = 24,
    }, -- [84]
    {
      ["flag"] = "",
      ["name"] = "ArtifactAppearanceSetHighlightFont",
      ["size"] = 24,
    }, -- [85]
    {
      ["flag"] = "",
      ["name"] = "CommentatorTeamScoreFont",
      ["size"] = 24,
    }, -- [86]
    {
      ["flag"] = "",
      ["name"] = "CommentatorDampeningFont",
      ["size"] = 24,
    }, -- [87]
    {
      ["flag"] = "",
      ["name"] = "CommentatorTeamNameFont",
      ["size"] = 16,
    }, -- [88]
    {
      ["flag"] = "OUTLINE, THICKOUTLINE",
      ["name"] = "CommentatorCCFont",
      ["size"] = 32,
    }, -- [89]
    {
      ["flag"] = "",
      ["name"] = "CommentatorDeadFontSmall",
      ["size"] = 12,
    }, -- [90]
    {
      ["flag"] = "",
      ["name"] = "CommentatorDeadFontMedium",
      ["size"] = 16,
    }, -- [91]
    {
      ["flag"] = "",
      ["name"] = "CommentatorDeadFontDefault",
      ["size"] = 24,
    }, -- [92]
    {
      ["flag"] = "OUTLINE, THICKOUTLINE",
      ["name"] = "CommentatorDeadFontLarge",
      ["size"] = 32,
    }, -- [93]
    {
      ["flag"] = "",
      ["name"] = "CommentatorVictoryFanfare",
      ["size"] = 120,
    }, -- [94]
    {
      ["flag"] = "",
      ["name"] = "CommentatorVictoryFanfareTeam",
      ["size"] = 72,
    }, -- [95]
    {
      ['flag'] = 'OUTLINE',
      ['name'] = 'GameFontNormalSmall',
      ['size'] = 10
    },
    {
      ['flag'] = 'OUTLINE',
      ['name'] = 'GameFontHighlightLarge',
      ['size'] = 16
    },
    {
      ['flag'] = 'OUTLINE',
      ['name'] = 'GameFontNormalMed2',
      ['size'] = 14
    },
    {
      ['flag'] = 'OUTLINE',
      ['name'] = 'GameFontNormal',
      ['size'] = 12
    },
    {
      ['flag'] = 'OUTLINE',
      ['name'] = 'GameFontNormalLarge',
      ['size'] = 16
    },
    {
      ["flag"] = "",
      ["name"] = "SystemFont_Shadow_Large",
      ["size"] = 16,
    }, -- [1]
    {
      ["flag"] = "",
      ["name"] = "SystemFont_Med2",
      ["size"] = 13.0000009536743,
    }, -- [2]
    {
      ["flag"] = "OUTLINE",
      ["name"] = "SystemFont_Shadow_Outline_Huge2",
      ["size"] = 22.0000019073486,
    }, -- [3]
    {
      ["flag"] = "",
      ["name"] = "SystemFont_LargeNamePlate",
      ["size"] = 12,
    }, -- [4]
    {
      ["flag"] = "",
      ["name"] = "SystemFont_Med1",
      ["size"] = 12,
    }, -- [5]
    {
      ["flag"] = "",
      ["name"] = "SystemFont_LargeNamePlateFixed",
      ["size"] = 20,
    }, -- [6]
    {
      ["flag"] = "",
      ["name"] = "SystemFont_Tiny2",
      ["size"] = 8,
    }, -- [7]
    {
      ["flag"] = "",
      ["name"] = "SystemFont_Tiny",
      ["size"] = 9,
    }, -- [8]
    {
      ["flag"] = "OUTLINE",
      ["name"] = "SystemFont_Shadow_Large_Outline",
      ["size"] = 16,
    }, -- [9]
    {
      ["flag"] = "OUTLINE",
      ["name"] = "SystemFont_NamePlateCastBar",
      ["size"] = 15665.1181640625,
    }, -- [10]
    {
      ["flag"] = "",
      ["name"] = "SystemFont_Shadow_Med3",
      ["size"] = 13.9999990463257,
    }, -- [11]
    {
      ["flag"] = "OUTLINE",
      ["name"] = "SystemFont_Outline_WTF2",
      ["size"] = 36,
    }, -- [12]
    {
      ["flag"] = "OUTLINE, THICKOUTLINE",
      ["name"] = "SystemFont_OutlineThick_Huge2",
      ["size"] = 22.0000019073486,
    }, -- [13]
    {
      ["flag"] = "",
      ["name"] = "SystemFont_Shadow_Huge1",
      ["size"] = 20,
    }, -- [14]
    {
      ["flag"] = "OUTLINE",
      ["name"] = "SystemFont_Outline_Small",
      ["size"] = 10,
    }, -- [15]
    {
      ["flag"] = "",
      ["name"] = "SystemFont_Shadow_Small2",
      ["size"] = 11.0000009536743,
    }, -- [16]
    {
      ["flag"] = "",
      ["name"] = "SystemFont_Med3",
      ["size"] = 13.9999990463257,
    }, -- [17]
    {
      ["flag"] = "OUTLINE",
      ["name"] = "SystemFont_Huge1_Outline",
      ["size"] = 20,
    }, -- [18]
    {
      ["flag"] = "",
      ["name"] = "SystemFont_WTF2",
      ["size"] = 36,
    }, -- [19]
    {
      ["flag"] = "",
      ["name"] = "SystemFont_World",
      ["size"] = 100256.7578125,
    }, -- [20]
    {
      ["flag"] = "",
      ["name"] = "SystemFont_InverseShadow_Small",
      ["size"] = 10,
    }, -- [21]
    {
      ["flag"] = "",
      ["name"] = "SystemFont_Shadow_Med2",
      ["size"] = 13.9999990463257,
    }, -- [22]
    {
      ["flag"] = "",
      ["name"] = "SystemFont_NamePlateFixed",
      ["size"] = 14,
    }, -- [23]
    {
      ["flag"] = "OUTLINE, THICKOUTLINE",
      ["name"] = "SystemFont_World_ThickOutline",
      ["size"] = 100256.7578125,
    }, -- [24]
    {
      ["flag"] = "OUTLINE, THICKOUTLINE",
      ["name"] = "SystemFont_OutlineThick_Huge4",
      ["size"] = 26.0000019073486,
    }, -- [25]
    {
      ["flag"] = "",
      ["name"] = "SystemFont_Shadow_Large2",
      ["size"] = 18,
    }, -- [26]
    {
      ["flag"] = "",
      ["name"] = "SystemFont_Shadow_Small",
      ["size"] = 10,
    }, -- [27]
    {
      ["flag"] = "OUTLINE, THICKOUTLINE",
      ["name"] = "SystemFont_OutlineThick_WTF",
      ["size"] = 32,
    }, -- [28]
    {
      ["flag"] = "",
      ["name"] = "SystemFont_Huge2",
      ["size"] = 24,
    }, -- [29]
    {
      ["flag"] = "",
      ["name"] = "SystemFont_Huge1",
      ["size"] = 20,
    }, -- [30]
    {
      ["flag"] = "",
      ["name"] = "SystemFont_Shadow_Med1",
      ["size"] = 12,
    }, -- [31]
    {
      ["flag"] = "",
      ["name"] = "SystemFont_NamePlate",
      ["size"] = 9,
    }, -- [32]
    {
      ["flag"] = "",
      ["name"] = "SystemFont_Small2",
      ["size"] = 11.0000009536743,
    }, -- [33]
    {
      ["flag"] = "",
      ["name"] = "SystemFont_Large",
      ["size"] = 16,
    }, -- [34]
    {
      ["flag"] = "OUTLINE",
      ["name"] = "SystemFont_Shadow_Med1_Outline",
      ["size"] = 12,
    }, -- [35]
    {
      ["flag"] = "",
      ["name"] = "SystemFont_Small",
      ["size"] = 10,
    }, -- [36]
    {
      ["flag"] = "OUTLINE",
      ["name"] = "SystemFont_Shadow_Huge2",
      ["size"] = 24,
    }, -- [37]
    {
      ["flag"] = "OUTLINE",
      ["name"] = "SystemFont_Outline",
      ["size"] = 13.0000009536743,
    }, -- [38]
    {
      ["flag"] = "",
      ["name"] = "SystemFont_Shadow_Huge3",
      ["size"] = 25,
    }, -- [39]
    {
      ["flag"] = "OUTLINE",
      ["name"] = "SystemFont_Shadow_Outline_Huge3",
      ["size"] = 25,
    }, -- [40]
    {
      ["flag"] = "",
      ["name"] = "ChatFontNormal",
      ["size"] = 14,
    }, -- [39]
    {
      ["flag"] = "OUTLINE",
      ["name"] = "ChatFontSmall",
      ["size"] = 12,
    }, -- [40]

  }

  function obj:Refresh()
    if db.replaceBlizz then
      local defaultFont = ns.LSM:Fetch('font',db.defaultFont)
      for _, font in ipairs(blizzardFonts) do
        _G[font.name]:SetFont(defaultFont, font.size*db.modifier, font.flag)
      end

    end
  end
  C_Timer.After(0.3,function() obj:Refresh() end)


  local options = {
    title = {
      name = L['Fonts'],
      type = 'description',
      order = 0,
      width = "full",
      fontSize = 'large'
    },
    replaceBlizz = {
      type = 'toggle',
      order = 10,
      name = L['Replace Blizzard Fonts'],
      get = function() return db.replaceBlizz end,
      set = function(self, value)
        db.replaceBlizz = value

        if not value then
         ns.ReloadPopup()
        else
          obj:Refresh()
        end
      end,
    },
    font = {
      type = 'select',
      order = 20,
      dialogControl = 'LSM30_Font',
      name = L['Font'],
      values = ns.LSM:HashTable('font'),
      get = function()
        return db.defaultFont
      end,
      set = function(self, key)
        db.defaultFont = key
        obj:Refresh()
      end
    },
    modifier = {
      type = 'range',
      order = 30,
      min = 0,
      max = 2,
      step = 0.05,
      name = L['Modifier'],
      get = function() return db.modifier end,
      set = function(self,value)
        db.modifier = value
        obj:Refresh()
      end,
    }
  }
  ns.switchBoard.AddToOptionsTable('media', 'fonts', options)

end
