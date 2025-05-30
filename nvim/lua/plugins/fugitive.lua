return {
    {
        "tpope/vim-fugitive",
        config = function() 
            vim.keymap.set("n", "<leader>gs", vim.cmd.Git)
            vim.keymap.set("n", "<leader>gb", '<cmd>Git blame<CR>')
        end
    }
}
