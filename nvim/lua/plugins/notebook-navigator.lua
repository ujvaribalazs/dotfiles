-- ~/.config/nvim/lua/plugins/notebook-navigator.lua
-- Saját cellaugrás: a kurzor mindig a "# %%" jelölő ALATTI sorra kerül (a cellába),
-- mert maga a jelölősor nem része a molten-cellának, és ott nem jelenne meg a popup.
-- Visszafelé előbb megkeressük a saját cella jelölőjét, és az ELŐTTI jelölőre ugrunk,
-- így a cella tetején álló saját "# %%" nem fogja meg az ugrást.
local CELL = "^# %%"

local function jump_cell(dir)
    local cur = vim.api.nvim_win_get_cursor(0)
    local target
    if dir == "d" then
        target = vim.fn.search(CELL, "nW")
    else
        local own = vim.fn.search(CELL, "bcnW")
        if own == 0 then return end
        vim.api.nvim_win_set_cursor(0, { own, 0 })
        target = vim.fn.search(CELL, "bnW")
        vim.api.nvim_win_set_cursor(0, cur)
    end
    if target == 0 then return end
    vim.api.nvim_win_set_cursor(0, { target, 0 })
    vim.cmd("normal! zt")
    if target < vim.api.nvim_buf_line_count(0) then
        vim.api.nvim_win_set_cursor(0, { target + 1, 0 })
    end
end

return {
    {
        "GCBallesteros/NotebookNavigator.nvim",

        keys = {
            -- ő / ú = ugyanott, ahol angol billentyűzeten a [ és ]
            -- zt: a cella a képernyő tetejére kerül, alatta látszik az output
            {
                "ú",
                function()
                    jump_cell("d")
                end,
                desc = "Next notebook cell"
            },
            {
                "ő",
                function()
                    jump_cell("u")
                end,
                desc = "Previous notebook cell"
            },
            { "<leader>x",  function() require("notebook-navigator").run_cell() end,        desc = "Run notebook cell" },
            {
                "<leader>X",
                function()
                    -- ha még nincs kernel, csak futtat (a molten ilyenkor felajánlja az initet),
                    -- popupot csak futó kernel mellett nyitunk
                    local ready = #vim.fn.MoltenRunningKernels(true) > 0
                    require("notebook-navigator").run_cell()
                    if ready then
                        vim.schedule(function() pcall(vim.cmd, "MoltenShowOutput") end)
                    end
                end,
                desc = "Run cell, show output popup",
            },
            { "<leader>mm", function() require("notebook-navigator").run_and_move() end,    desc = "Run cell and move" },

            -- új
            { "<leader>ma", function() require("notebook-navigator").run_all_cells() end,   desc = "Run all cells" },
            { "<leader>mj", function() require("notebook-navigator").run_cells_below() end, desc = "Run this and cells below" },
            { "<leader>mn", function() require("notebook-navigator").add_cell_below() end,  desc = "Add cell below" },
            { "<leader>mN", function() require("notebook-navigator").add_cell_above() end,  desc = "Add cell above" },
            { "<leader>mS", function() require("notebook-navigator").split_cell() end,      desc = "Split cell" },
            { "<leader>mk", function() require("notebook-navigator").swap_cell("u") end,    desc = "Move cell up" },
            { "<leader>mJ", function() require("notebook-navigator").swap_cell("d") end,    desc = "Move cell down" },
        },

        dependencies = {
            "benlubas/molten-nvim",
        },

        config = function()
            require("notebook-navigator").setup({
                repl_provider = "molten",
                syntax_highlight = true,
            })
        end,
    },
}
