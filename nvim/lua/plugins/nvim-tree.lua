return {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
        { "nvim-tree/nvim-web-devicons", opts = {} }
    },
    config = function()
        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1

        local api = require "nvim-tree.api"

        local function opts(desc)
            return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end

        require("nvim-tree").setup({

            view = {
                adaptive_size = true
            },
            renderer = {
                group_empty = true,
            },
            actions = {
                open_file = {
                    quit_on_open = true,  -- Automatically closes nvim-tree when a file is opened
                },
            },
        })

        vim.keymap.set('n', '<leader>pv', function() require('nvim-tree.api').tree.open({find_file = true}) end, opts('Open tree'))
    end
}
