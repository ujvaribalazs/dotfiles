return {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
        "MunifTanjim/nui.nvim",
        "rcarriga/nvim-notify", -- opcionális: szebb értesítések
    },
    opts = {
        cmdline = {
            view = "cmdline_popup", -- középen felugró ablak
        },
        presets = {
            long_message_to_split = true, -- hosszú üzenetek splitbe kerülnek
        },
    },
}
