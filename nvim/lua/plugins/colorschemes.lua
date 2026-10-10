-- ~/.config/nvim/lua/plugins/colorschemes.lua
-- Kipróbálható színsémák. lazy = true: csak akkor töltődnek be,
-- amikor kiválasztod őket (:colorscheme ...), így nem lassítják az indulást.

-- Notebookban (.ipynb, vagy "# %%" cellás .py) tokyonight-storm,
-- minden más fájlban a DEFAULT_SCHEME. Mindkettőt fixen megadjuk, így egy
-- visszaállított session (nvim -S) sem tudja összekeverni.
local NOTEBOOK_SCHEME = "tokyonight-storm"
local DEFAULT_SCHEME = "catppuccin"

local function is_notebook(buf)
    if vim.bo[buf].buftype ~= "" then return false end
    local name = vim.api.nvim_buf_get_name(buf)
    if name:match("%.ipynb$") then return true end
    if vim.bo[buf].filetype ~= "python" then return false end
    for _, line in ipairs(vim.api.nvim_buf_get_lines(buf, 0, -1, false)) do
        if line:match("^# %%%%") then return true end
    end
    return false
end

local function apply_scheme(buf)
    if not vim.api.nvim_buf_is_valid(buf) or vim.bo[buf].buftype ~= "" then return end -- popupok, fájlkezelő stb.
    local want = is_notebook(buf) and NOTEBOOK_SCHEME or DEFAULT_SCHEME
    if vim.g.colors_name ~= want then
        pcall(vim.cmd.colorscheme, want)
    end
end

local group = vim.api.nvim_create_augroup("NotebookColorscheme", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "FileType" }, {
    group = group,
    -- vim.schedule: a session-visszaállítás és a többi plugin után fusson le
    callback = function(ev) vim.schedule(function() apply_scheme(ev.buf) end) end,
})
vim.api.nvim_create_autocmd({ "VimEnter", "SessionLoadPost" }, {
    group = group,
    callback = function() vim.schedule(function() apply_scheme(vim.api.nvim_get_current_buf()) end) end,
})

return {
    { "folke/tokyonight.nvim",    lazy = true },
    { "rebelot/kanagawa.nvim",    lazy = true },
    { "rose-pine/neovim",         name = "rose-pine", lazy = true },
    { "EdenEast/nightfox.nvim",   lazy = true },
    { "ellisonleao/gruvbox.nvim", lazy = true },
}
