local map = vim.keymap.set

-- Alap
map("n", "<leader>w", "<cmd>write<cr>", { desc = "Mentés" })
map("n", "<leader>q", "<cmd>quit<cr>", { desc = "Kilépés" })
map("n", "<Esc>", "<cmd>nohlsearch<cr>")

-- Ablakok közötti mozgás
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

-- Bufferek
map("n", "<S-l>", "<cmd>BufferLineCycleNext<cr>", { desc = "Következő buffer" })
map("n", "<S-h>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Előző buffer" })
map("n", "<leader>bp", "<cmd>BufferLinePick<cr>", { desc = "Buffer választás" })
map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Buffer bezárása" })
map("n", "<leader>bo", "<cmd>BufferLineCloseOthers<cr>", { desc = "Többi bezárása" })

-- Sorok mozgatása Visual módban
map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")

-- Diagnosztika
map("n", "[d", function() vim.diagnostic.jump({ count = -1 }) end, { desc = "Előző diagnosztika" })
map("n", "]d", function() vim.diagnostic.jump({ count = 1 }) end, { desc = "Következő diagnosztika" })

-- Kilépés a terminál módból dupla Esc-kel
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Kilépés a terminál módból" })

-- Kilépés a insert módból dupla dupla jj-vel vagy jk-val
map("i", "jj", "<Esc>", { desc = "Kilépés insert módból" })
map("i", "jk", "<Esc>", { desc = "Kilépés insert módból" })

-- Markdown cella beszúrása jupytext szerkesztésekor
map("n", "<leader>mM", "o# %% [markdown]<CR># ", { desc = "Markdown cella" })
-- LSP (csak ha egy language server csatlakozott a bufferhez)

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local function lmap(lhs, rhs, desc)
            map("n", lhs, rhs, { buffer = args.buf, desc = desc })
        end
        lmap("gd", vim.lsp.buf.definition, "Definíció")
        lmap("gD", vim.lsp.buf.declaration, "Deklaráció")
        lmap("<leader>rn", vim.lsp.buf.rename, "Átnevezés")
        lmap("<leader>ca", vim.lsp.buf.code_action, "Code action")
    end,
})
