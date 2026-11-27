local _, addon = ...

local clientLocale = GetLocale()

addon.L = setmetatable({}, {
    __index = function(_, key)
        return key
    end,
})

function addon:RegisterLocale(locale, strings)
    if locale == "enUS" or locale == clientLocale then
        for key, value in pairs(strings) do
            self.L[key] = value
        end
    end
end
