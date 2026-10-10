return {
    {
        "kdheepak/lazygit.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        cmd = {
            "LazyGit",
            "LazyGitCurrentFile",
            "LazyGitFilterCurrentFile",
        },
        keys = {
            { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
            { "<leader>gf", "<cmd>LazyGitFilterCurrentFile<cr>", desc = "Aktuális fájl története" },
        },
    },
}
