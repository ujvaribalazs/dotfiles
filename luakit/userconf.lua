local modes = require "modes"

-- billentyű → oldal; <Mod1-…> = Alt, <Control-…> = Ctrl
local sites = {
    ["<Mod1-c>"] = "https://chatgpt.com",
    ["<Mod1-l>"] = "https://claude.ai",
    ["<Mod1-t>"] = "https://mail.tutanota.com",
}

local binds = {}
for key, url in pairs(sites) do
    table.insert(binds, { key, "Megnyitás új fülön: " .. url,
        function(w) w:new_tab(url) end })
end

-- normal és insert módban is működjön (szövegmezőben gépelés közben is)
modes.add_binds({ "normal", "insert" }, binds)
