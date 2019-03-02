local addon, ns = ...
local L = ns.L
ns.Initialize(
    function()
        local AceGUI = LibStub("AceGUI-3.0")
        local opt = ns.options

        local BACKDROP = {
            bgFile = "Interface\\BUTTONS\\WHITE8X8.blp",
            edgeFile = "Interface\\BUTTONS\\WHITE8X8.blp",
            tile = false,
            tileSize = 0,
            edgeSize = 1,
            insets = {
                left = 0,
                right = 0,
                top = 0,
                bottom = 0
            }
        }

        local ICONS = {
            CLOSE = [[Interface\Addons\Oof\Media\Icons\close]],
            CHECK = [[Interface\Addons\Oof\Media\Icons\check]],
        }

        local function ApplyBackdrop(frame, r, g, b, a)
            r = r or 0
            g = g or 0
            b = b or 0
            a = a or 0.7

            frame:SetBackdrop(BACKDROP)
            frame:SetBackdropColor(r, g, b, a)
            frame:SetBackdropBorderColor(r, g, b, a + 0.3)
        end

        local frame = CreateFrame("Frame","OOF_OptionsFrame",UIParent)
        frame:SetPoint("CENTER",0,0)
        frame:SetSize(900,600)
        ApplyBackdrop(frame)
        frame:SetMovable(true)
        frame:EnableMouse(true)
        frame:RegisterForDrag("LeftButton")
        frame:SetScript("OnDragStart", frame.StartMoving)
        frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
        opt.container = frame

        local function CreatePanel()
            local f = CreateFrame("Frame",nil,frame)
            ApplyBackdrop(f,0,0,0,0.4)
            return f
        end

        -- frame:Hide()
        frame.shown = true

        local function ToggleOptions()
            frame.shown = not frame.shown
            if frame.shown then
                frame:Show()
            else
                frame:Hide()
            end
        end
        ns.ToggleOptions = ToggleOptions

        -- LDB and Minimap Icon setup
        local LDB = LibStub:GetLibrary("LibDataBroker-1.1")
        local LDBI = LibStub("LibDBIcon-1.0")


        local LDB_Oof = LDB:NewDataObject("OOF",{
        type = "launcher",
        text = "OOF",
        icon = ns.defaults.logoSmall,
        OnClick = ns.ToggleOptions,
        })
        if not LDBI:IsRegistered("OOF") then
            LDBI:Register("OOF",LDB_Oof,{})
        end

        local closeBtn = CreateFrame("BUTTON",nil,frame)
        frame.closeBtn = closeBtn
        closeBtn:SetSize(20,20)
        closeBtn:SetPoint("TOPRIGHT",-5,-5)
        local closeTex = closeBtn:CreateTexture(nil,"OVERLAY")
        closeTex:SetTexture(ICONS.CLOSE)
        closeTex:SetPoint("CENTER")
        closeTex:SetSize(15,15)

        closeBtn:SetScript("OnClick",ToggleOptions)
        ApplyBackdrop(closeBtn)

        -- TITLE BAR --
        local titleBar = CreatePanel()
        frame.titleBar = titleBar
        titleBar:SetPoint("TOPLEFT", 5, -5)
        titleBar:SetPoint("BOTTOMRIGHT", closeBtn, "BOTTOMLEFT", -3, 0)

        local addonLogo = titleBar:CreateTexture(nil, "OVERLAY")
        addonLogo:SetSize(32,32)
        addonLogo:SetTexture(ns.defaults.logoSmall)
        addonLogo:SetPoint("LEFT",0,0)

        local addonTitle = titleBar:CreateFontString(nil, "OVERLAY")
        addonTitle:SetPoint("LEFT",addonLogo, "RIGHT", 5, 0)
        addonTitle:SetFont(ns.defaults.font,11)
        local addonVersion = GetAddOnMetadata(addon, "version")
        local titleString = string.format("%s v%s", WrapTextInColorCode(addon, "ffC49D49"), addonVersion)
        addonTitle:SetText(titleString)

        -- SWITCH BOARD --
        local buttonContainer = CreatePanel()
        frame.buttonContainer = buttonContainer
        buttonContainer:SetPoint("TOPLEFT", titleBar, "BOTTOMLEFT", 0, -5)
        buttonContainer:SetPoint("TOPRIGHT", closeBtn, "BOTTOMRIGHT", 0, -5)
        buttonContainer:SetHeight(40)

        -- CONFIG --
        local configContainer = CreatePanel()
        frame.configContainer = configContainer
        configContainer:SetPoint("TOPLEFT", buttonContainer, "BOTTOMLEFT", 0, -5)
        configContainer:SetPoint("BOTTOMRIGHT", -5, 5)

        local containerList = CreatePanel()
        containerList:SetPoint('TOPLEFT', configContainer, 5, -5)
        containerList:SetPoint('BOTTOMLEFT', configContainer, 5, 5)
        containerList:SetWidth(200)
        frame.configContainer.containerList = containerList

        local containerOptions = AceGUI:Create("InlineGroup");
        containerOptions.frame:SetParent(frame)
        containerOptions.frame:SetPoint('TOPLEFT', containerList, "TOPRIGHT", 5, 17)
        containerOptions.frame:SetPoint('BOTTOMRIGHT',configContainer,  -5, 2)
        containerOptions.titletext:Hide()
        ApplyBackdrop(containerOptions.content:GetParent(), 0, 0, 0, 0.4)
        frame.configContainer.containerOptions = containerOptions
        function containerOptions:FillContainer()
            containerList:Hide()
            self.frame:ClearAllPoints()
            containerOptions.frame:SetPoint('TOPLEFT', configContainer, 5, 17)
            containerOptions.frame:SetPoint('BOTTOMRIGHT',configContainer,  -5, 2)
        end
        function containerOptions:ResetPosition()
            containerList:Show()
            self.frame:ClearAllPoints()
            containerOptions.frame:SetPoint('TOPLEFT', containerList, "TOPRIGHT", 5, 17)
            containerOptions.frame:SetPoint('BOTTOMRIGHT',configContainer,  -5, 2)
        end
    end
)
