-- Catppuccin Mocha - Luakit

local theme = {}

local c = {
    base     = "#1e1e2e",
    mantle   = "#181825",
    crust    = "#11111b",
    surface0 = "#313244",
    surface1 = "#45475a",
    overlay0 = "#6c7086",
    subtext0 = "#a6adc8",
    text     = "#cdd6f4",
    lavender = "#b4befe",
    blue     = "#89b4fa",
    green    = "#a6e3a1",
    yellow   = "#f9e2af",
    red      = "#f38ba8",
    mauve    = "#cba6f7",
}

-- Alapbeállítások
theme.font = "12px ComicShannsMono Nerd Font Mono"
theme.fg = c.text
theme.bg = c.base

-- Állapotjelzések
theme.success_fg = c.green
theme.loaded_fg = c.blue
theme.error_fg = c.red
theme.error_bg = c.surface0
theme.warning_fg = c.yellow
theme.warning_bg = c.surface0
theme.notif_fg = c.text
theme.notif_bg = c.surface0

-- Menük
theme.menu_fg = c.text
theme.menu_bg = c.mantle
theme.menu_selected_fg = c.base
theme.menu_selected_bg = c.lavender
theme.menu_title_bg = c.surface0
theme.menu_primary_title_fg = c.mauve
theme.menu_secondary_title_fg = c.subtext0
theme.menu_disabled_fg = c.overlay0
theme.menu_disabled_bg = c.mantle
theme.menu_enabled_fg = c.text
theme.menu_enabled_bg = c.mantle
theme.menu_active_fg = c.green
theme.menu_active_bg = c.mantle

-- Proxy
theme.proxy_active_menu_fg = c.green
theme.proxy_active_menu_bg = c.mantle
theme.proxy_inactive_menu_fg = c.overlay0
theme.proxy_inactive_menu_bg = c.mantle

-- Státuszsor
theme.sbar_fg = c.text
theme.sbar_bg = c.crust

-- Letöltések
theme.dbar_fg = c.text
theme.dbar_bg = c.mantle
theme.dbar_error_fg = c.red

-- Parancssor
theme.ibar_fg = c.text
theme.ibar_bg = c.mantle

-- Tabok
theme.tab_fg = c.subtext0
theme.tab_bg = c.surface0
theme.tab_hover_bg = c.surface1
theme.tab_ntheme = c.text

-- Aktív tab
theme.selected_fg = c.base
theme.selected_bg = c.lavender
theme.selected_ntheme = c.base

-- Betöltés
theme.loading_fg = c.blue
theme.loading_bg = c.surface0

-- Privát tabok
theme.selected_private_tab_bg = c.mauve
theme.private_tab_bg = c.surface1

-- HTTPS jelzés
theme.trust_fg = c.green
theme.notrust_fg = c.red

-- Linkek kiválasztása (f)
theme.hint_font = "bold 11px monospace"
theme.hint_fg = c.base
theme.hint_bg = c.yellow
theme.hint_border = "1px solid " .. c.lavender
theme.hint_opacity = "0.9"
theme.hint_overlay_bg = "rgba(180,190,254,0.2)"
theme.hint_overlay_border = "1px dotted " .. c.lavender
theme.hint_overlay_selected_bg = "rgba(166,227,161,0.4)"
theme.hint_overlay_selected_border = theme.hint_overlay_border

-- Általános színpárok
theme.ok = { fg = c.base, bg = c.green }
theme.warn = { fg = c.base, bg = c.yellow }
theme.error = { fg = c.base, bg = c.red }

-- Gopher
theme.gopher_light = {
    bg = c.base, fg = c.text, link = c.blue
}
theme.gopher_dark = {
    bg = c.base, fg = c.text, link = c.lavender
}

return theme
