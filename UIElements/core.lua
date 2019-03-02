local addon, ns = ...
ns.Initialize(
    function()
        local UIElements = ns.UIElements

        local elementTypes = {}

        local function ApplyBackdrop(self, r, g, b, a)
            r = r or 0
            g = g or 0
            b = b or 0
            a = a or 0.7

            self:SetBackdrop(ns.defaults.backdrop)
            self:SetBackdropColor(r, g, b, a)
            self:SetBackdropBorderColor(r, g, b, a + 0.3)
            self.defaultColor = {r,g,b,a}
            self.currentColor = {r,g,b,a}
        end

        local function RegisterFrameType(type,const,funcs)
            elementTypes[type] = {
                constructor = const,
                funcs = funcs
            }
        end

        local function CreateFrame(type,name,parent)
            if elementTypes[type] then
                local element = elementTypes[type].constructor(name,parent)

                if elementTypes[type].funcs then
                    for _, funcName in ipairs(elementTypes[type].funcs) do
                        if UIElements.defaultFunc[funcName] then
                            element[funcName] = UIElements.defaultFunc[funcName]
                        end
                    end
                end
                return element
            else
                print("Tried to use unknown frame type - ",type)
            end
        end

        UIElements.RegisterFrameType = RegisterFrameType
        UIElements.CreateFrame = CreateFrame
        UIElements.defaultFunc = {
            ApplyBackdrop = ApplyBackdrop
        }
    end
);
