vim.api.nvim_create_user_command("Pydoc", function(opts)
    local output = vim.fn.systemlist({ "python", "-m", "pydoc", opts.args })

    vim.cmd("rightbelow vnew")
    vim.cmd("vertical resize 60")
    local buf = vim.api.nvim_get_current_buf()

    vim.bo[buf].buftype = "nofile"
    vim.bo[buf].bufhidden = "wipe"
    vim.bo[buf].swapfile = false
    vim.bo[buf].modifiable = true

    vim.api.nvim_buf_set_lines(buf, 0, -1, false, output)

    vim.bo[buf].modifiable = false
    vim.bo[buf].filetype = "pydoc"

    vim.api.nvim_buf_set_name(buf, "Pydoc: " .. opts.args)

    vim.cmd("normal! gg")
end, {
    nargs = 1,
})
