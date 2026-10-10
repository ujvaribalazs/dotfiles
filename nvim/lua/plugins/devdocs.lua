return {
    "ayoisaiah/nvim-devdocs",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
        "nvim-treesitter/nvim-treesitter",
    },
    opts = {
        filetypes = { python = "python-3.12" },
        ensure_installed = { "python-3.12" },
    },
}
