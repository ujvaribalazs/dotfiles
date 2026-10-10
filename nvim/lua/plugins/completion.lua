
return {
    {
        "saghen/blink.cmp",
        version = "1.*",

        dependencies = {
            "rafamadriz/friendly-snippets",
        },

        opts = {
            keymap = {
                preset = "super-tab",
            },

            completion = {
                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 300,
                },

                menu = {
                    border = "rounded",
                },
            },

            signature = {
                enabled = true,
            },

            sources = {
                default = {
                    "lsp",
                    "path",
                    "snippets",
                    "buffer",
                },
            },
        },
    },
}
