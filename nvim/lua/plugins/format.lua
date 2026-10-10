return {
    {
        "stevearc/conform.nvim",
        event = { "BufWritePre" },
        cmd = { "ConformInfo" },

        opts = {
            formatters_by_ft = {
                python = { "isort", "black" },
                lua = { "stylua" },
                sql = { "sql_formatter" },
            },
            format_on_save = {
                timeout_ms = 1000,
                lsp_format = "fallback",
            },
            formatters = {
                sql_formatter = {
                    prepend_args = { "--language", "sqlite" },
                },
            },
        },

        keys = {
            {
                "<leader>cf",
                function()
                    require("conform").format({ async = true, lsp_format = "fallback" })
                end,
                desc = "Formázás",
            },
        },
    },
}
