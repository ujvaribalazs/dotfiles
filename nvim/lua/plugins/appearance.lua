return {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,

        config = function()
            require("catppuccin").setup({
                flavour = "mocha",
                transparent_background = false,
            })

            vim.cmd.colorscheme("catppuccin")
        end,
    },

    {
        "nvim-tree/nvim-web-devicons",
    },

    {
        "nvim-lualine/lualine.nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },

        opts = {
            options = {
                theme = "auto",
                globalstatus = true,
                component_separators = {
                    left = "│",
                    right = "│",
                },
                section_separators = {
                    left = "",
                    right = "",
                },
            },
        },
    },

    {
        "akinsho/bufferline.nvim",
        version = "*",

        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },

        opts = {
            options = {
                diagnostics = "nvim_lsp",
                separator_style = "slant",
            },
        },
    },
}
