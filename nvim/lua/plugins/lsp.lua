return {
    {
        "mason-org/mason.nvim",
        opts = {
            ui = {
                border = "rounded",
            },
        },
    },

    {
        "neovim/nvim-lspconfig",
    },

    {
        "mason-org/mason-lspconfig.nvim",

        dependencies = {
            "mason-org/mason.nvim",
            "neovim/nvim-lspconfig",
        },

        opts = {
            ensure_installed = {
                "pyright",
                "jdtls",
                "lua_ls",
            },
        },
    },
}
