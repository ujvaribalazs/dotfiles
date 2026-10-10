-- ~/.config/nvim/lua/plugins/molten.lua
-- Molten (Jupyter kernel) + image.nvim (inline ábrák) + jupytext (.ipynb <-> # %%)
-- A cellák futtatása/navigálása a notebook-navigator.lua-ban van.

return {
    {
        "benlubas/molten-nvim",
        version = "^1.0.0",
        lazy = false,
        build = ":UpdateRemotePlugins",
        dependencies = { "3rd/image.nvim" },

        init = function()
            vim.g.molten_output_win_max_height = 30
            vim.g.molten_auto_open_output = true
            -- A kimenet virtuális szövegként a cella alatt marad
            vim.g.molten_virt_text_output = true
            -- "# %%" cellákhoz false: különben az output a KÖVETKEZŐ cella jelölője alá csúszik
            vim.g.molten_virt_lines_off_by_1 = false
            vim.g.molten_virt_text_max_lines = 20

            -- új: megjelenés
            vim.g.molten_image_provider = "none"
            vim.g.molten_image_location = "virt" -- ábrák a cella alatt
            vim.g.molten_wrap_output = false     -- táblázatnál ne tördeljen
            vim.g.molten_output_win_border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }
            vim.g.molten_output_win_style = "minimal"
            vim.g.molten_output_win_cover_gutter = false
            vim.g.molten_output_show_more = true
            vim.g.molten_use_border_highlights = true -- zöld/piros keret
            vim.g.molten_tick_rate = 150
            vim.g.molten_open_cmd = "xdg-open"        -- alapértelmezett böngésző megnyitása

            -- új: színek (a virtuális output alapból dőlt szürke Comment)
            local function set_hl()
                vim.api.nvim_set_hl(0, "MoltenVirtualText", { link = "Normal" })
                vim.api.nvim_set_hl(0, "MoltenCell", { bg = "NONE" })
                vim.api.nvim_set_hl(0, "MoltenOutputBorderSuccess", { fg = "#7fbf7f" })
                vim.api.nvim_set_hl(0, "MoltenOutputBorderFail", { fg = "#e06c75" })
                vim.api.nvim_set_hl(0, "MoltenOutputWin", { bg = "#1e2233" })
            end
            set_hl()
            vim.api.nvim_create_autocmd("ColorScheme", { callback = set_hl })

            -- kilépés az output popupból: q vagy Esc
            vim.api.nvim_create_autocmd("FileType", {
                pattern = "molten_output",
                callback = function(ev)
                    for _, key in ipairs({ "q", "<Esc>" }) do
                        vim.keymap.set("n", key, "<cmd>close<CR>", { buffer = ev.buf, silent = true })
                    end
                end,
            })
        end,

        keys = {
            -- a meglévők
            { "<leader>mi", ":MoltenInit<CR>",             desc = "Molten: init kernel" },
            { "<leader>me", ":MoltenEvaluateOperator<CR>", desc = "Molten: evaluate" },
            { "<leader>ml", ":MoltenEvaluateLine<CR>",     desc = "Molten: evaluate line" },
            { "<leader>mc", ":MoltenReevaluateCell<CR>",   desc = "Molten: rerun cell" },

            -- új
            {
                "<leader>o",
                function()
                    if not pcall(vim.cmd, "MoltenShowOutput") then return end -- előbb megnyitja
                    vim.schedule(function()
                        pcall(vim.cmd, "noautocmd MoltenEnterOutput")         -- utána belép
                    end)
                end,
                desc = "Molten: enter output",
            },
            { "<leader><CR>", ":<C-u>MoltenEvaluateVisual<CR>gv", mode = "v",                                   desc = "Molten: run selection" },
            -- Shift+ú / Shift+ő: lapozás a lefuttatott cellák outputjai között
            {
                "Ú",
                function()
                    pcall(vim.cmd, "MoltenNext"); vim.cmd("normal! zt"); pcall(vim.cmd, "MoltenShowOutput")
                end,
                desc = "Molten: next output"
            },
            {
                "Ő",
                function()
                    pcall(vim.cmd, "MoltenPrev"); vim.cmd("normal! zt"); pcall(vim.cmd, "MoltenShowOutput")
                end,
                desc = "Molten: previous output"
            },
            { "<leader>mh",   ":MoltenHideOutput<CR>",            desc = "Molten: hide output" },
            { "<leader>mb",   ":MoltenOpenInBrowser<CR>",         desc = "Molten: output in browser" },
            { "<leader>my",   ":MoltenYankOutput!<CR>",           desc = "Molten: yank output" },
            { "<leader>md",   ":MoltenDelete<CR>",                desc = "Molten: delete cell output" },
            { "<leader>mD",   ":MoltenDelete!<CR>",               desc = "Molten: delete ALL outputs in buffer" },
            { "<leader>mx",   ":MoltenInterrupt<CR>",             desc = "Molten: interrupt" },
            { "<leader>mR",   ":MoltenRestart!<CR>",              desc = "Molten: restart kernel" },
            { "<leader>ms",   ":MoltenSave<CR>",                  desc = "Molten: save outputs" },
            { "<leader>mL",   ":MoltenLoad<CR>",                  desc = "Molten: load outputs" },
            { "<leader>mE",   ":MoltenExportOutput!<CR>",         desc = "Molten: export to ipynb" },
            { "<leader>mI",   ":MoltenImportOutput<CR>",          desc = "Molten: import from ipynb" },
        },
    },

    {
        "3rd/image.nvim",
        build = false, -- ne építsen luarocks-ot (magick_cli-hez nem kell)
        opts = {
            backend = "kitty",
            processor = "magick_cli", -- nem kell luarocks
            max_width = 100,
            max_height = 15,
            max_width_window_percentage = 100,
            max_height_window_percentage = 100,
            window_overlap_clear_enabled = true,
            window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
        },
    },

    -- jupytext: a lua/plugins/jupytext.lua-ban (goerz/jupytext.nvim), itt nem kell másodszor
}
