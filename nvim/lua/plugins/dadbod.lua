return {
  {
    "tpope/vim-dadbod",
    cmd = "DB",
  },

  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      "tpope/vim-dadbod",
    },

    cmd = {
      "DBUI",
      "DBUIToggle",
      "DBUIAddConnection",
      "DBUIFindBuffer",
    },

    keys = {
      {
        "<leader>dt",
        "<cmd>DBUIToggle<CR>",
        desc = "Database UI",
      },
      {
        "<leader>da",
        "<cmd>DBUIAddConnection<CR>",
        desc = "Add database connection",
      },
      {
        "<leader>df",
        "<cmd>DBUIFindBuffer<CR>",
        desc = "Find database buffer",
      },
    },
    init = function()
        vim.g.db_ui_use_nerd_fonts = 1
        vim.g.db_ui_auto_execute_table_helpers = 1
        vim.g.db_ui_execute_on_save = false
    end,

},

  {
    "kristijanhusak/vim-dadbod-completion",
    dependencies = {
      "tpope/vim-dadbod",
    },
    ft = { "sql", "mysql", "plsql" },
  },
}
