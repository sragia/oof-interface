local addon, ns = ...
ns.Initialize(
    function()
        local UIElements = ns.UIElements

        local methods = {
            SetFontSize = function(self,size)
                self:SetFont(ns.defaults.font,size)
            end,

            Highlight = function(self,r,g,b,a)
                self.currentColor = {r,g,b,a}
                self:SetBackdropColor(r,g,b,a)
            end,

            ResetColor = function(self)
                self.currentColor = self.defaultColor
                self:SetBackdropColor(unpack(self.defaultColor))
            end
        }

        local function SetFontSize(self,size)
            self:SetFont(ns.defaults.font,size)
        end

        local function Highlight(self,r,g,b,a)
            self.currentColor = {r,g,b,a}
            self:SetBackdropColor(r,g,b,a)
        end

        local function ResetColor(self)
            self:SetBackdropColor(unpack(self.defaultColor))
        end

        local function constructor(name,parent)
            local btn = CreateFrame("Button",name,parent)

            local buttonText = btn:CreateFontString(nil, "OVERLAY")
            buttonText:SetFont(ns.defaults.font,11)
            buttonText:SetPoint("LEFT",3,0)
            buttonText.SetFontSize = SetFontSize
            btn.text = buttonText
            -- Hover
            btn:SetScript("OnEnter",function(self)
                local r, g, b, a = unpack(self.currentColor)
                self:SetBackdropColor(r + 0.1, g + 0.1, b + 0.1, a)
            end)
            btn:SetScript("OnLeave", function(self)
                local r, g, b, a =  unpack(self.currentColor)
                self:SetBackdropColor(r, g, b, a)
            end)

            for name, func in pairs(methods) do
                btn[name] = func
            end


            return btn
        end

        local funcs = {
            'ApplyBackdrop'
        }


        UIElements.RegisterFrameType('Button',constructor,funcs)
    end
);