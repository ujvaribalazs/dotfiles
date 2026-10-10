return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        lazy = false,
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter").install({
                -- Neovim alapok (a rendszercsomagból hiányoznak)
                "c", "lua", "vim", "vimdoc", "query",
                "markdown", "markdown_inline",
                -- saját nyelvek
                "java", "python", "sql", "bash", "json", "yaml",
            })

            -- Kiemelés bekapcsolása minden fájltípusra, amihez van parser
            vim.api.nvim_create_autocmd("FileType", {
                callback = function(args)
                    pcall(vim.treesitter.start, args.buf)
                end,
            })
        end,
    },
}
