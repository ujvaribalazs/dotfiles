return {
    {
        "stevearc/oil.nvim",
        
        lazy = false,

        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },

        opts = {
            view_options = {
                show_hidden = true,
            },

            float = {
                border = "rounded",
            },
        },

        keys = {
            {
                "-",
                "<cmd>Oil<cr>",
                desc = "Fájlkezelő",
            },
        },
    },

    {
        "ibhagwan/fzf-lua",

        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },

        opts = {
            winopts = {
                border = "rounded",

                preview = {
                    border = "rounded",
                },
            },
        },

        keys = {
            {
                "<leader>ff",
                "<cmd>FzfLua files<cr>",
                desc = "Fájl keresése",
            },

            {
                "<leader>fg",
                "<cmd>FzfLua live_grep<cr>",
                desc = "Szöveg keresése",
            },

            {
                "<leader>fb",
                "<cmd>FzfLua buffers<cr>",
                desc = "Buffer keresése",
            },

            {
                "<leader>fh",
                "<cmd>FzfLua help_tags<cr>",
                desc = "Help keresése",
            },
        },
    },

    {
        "lewis6991/gitsigns.nvim",

        opts = {
            current_line_blame = true,

            on_attach = function(bufnr)
                local gs = require("gitsigns")
                local function map(mode, lhs, rhs, desc)
                    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
                end

                -- Navigálás a módosítások között
                map("n", "]c", function() gs.nav_hunk("next") end, "Következő módosítás")
                map("n", "[c", function() gs.nav_hunk("prev") end, "Előző módosítás")

                -- Műveletek
                map("n", "<leader>hp", gs.preview_hunk, "Módosítás előnézete")
                map("n", "<leader>hs", gs.stage_hunk, "Módosítás stage-elése")
                map("n", "<leader>hr", gs.reset_hunk, "Módosítás visszavonása")
                map("n", "<leader>hS", gs.stage_buffer, "Egész fájl stage-elése")
                map("n", "<leader>hb", function() gs.blame_line({ full = true }) end, "Blame részletesen")
                map("n", "<leader>hd", gs.diffthis, "Diff az utolsó commithoz")
                map("n", "<leader>tb", gs.toggle_current_line_blame, "Sor végi blame ki/be")
            end,
        },
    },
    {
        "folke/which-key.nvim",

        event = "VeryLazy",

        opts = {
            preset = "modern",
        },
    },
}
