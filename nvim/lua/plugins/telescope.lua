return {
    { 'nvim-telescope/telescope-ui-select.nvim' },
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.8',
        dependencies = {
            { 'nvim-lua/plenary.nvim' },
            {
                'nvim-telescope/telescope-fzf-native.nvim',
                build = "make"
            },
            {
                'nvim-treesitter/nvim-treesitter',
                lazy = false,
                branch = "master",
                version = false
            },
        },
        config = function()
            require("telescope").setup({
                defaults = {
                    -- Default configuration for telescope goes here:
                    -- config_key = value,
                    mappings = {
                        i = {
                            -- map actions.which_key to <C-h> (default: <C-/>)
                            -- actions.which_key shows the mappings for your picker,
                            -- e.g. git_{create, delete, ...}_branch for the git_branches picker
                            ["<C-h>"] = "which_key"
                        }
                    }
                },
                pickers = {
                    -- Default configuration for builtin pickers goes here:
                    -- picker_name = {
                    --   picker_config_key = value,
                    --   ...
                    -- }
                    -- Now the picker_config_key will be applied every time you call this
                    -- builtin picker
                },
                extensions = {
                    fzf = {
                        fuzzy = true,                   -- false will only do exact matching
                        override_generic_sorter = true, -- override the generic sorter
                        override_file_sorter = true,    -- override the file sorter
                        case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
                        -- the default case_mode is "smart_case"
                    },
                    ["ui-select"] = {
                        require("telescope.themes").get_dropdown {
                            -- even more opts
                        }
                    }

                }
            })

            require('telescope').load_extension('fzf')
            require("telescope").load_extension("ui-select")

            local builtin = require("telescope.builtin")
            vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
            vim.keymap.set('n', '<C-p>', builtin.git_files, {})
            vim.keymap.set('n', '<leader>ps', function()
                builtin.grep_string({ search = vim.fn.input("Grep > ") })
            end)

            local pickers = require("telescope.pickers")
            local finders = require("telescope.finders")
            local entry_display = require("telescope.pickers.entry_display")
            local conf = require("telescope.config").values
            local make_entry = require("telescope.make_entry")

            local function telescope_workspace_symbols(query)
                vim.lsp.buf_request(0, "workspace/symbol", { query = query }, function(err, result, _, _)
                    if err or not result or vim.tbl_isempty(result) then
                        vim.notify("No results from LSP", vim.log.levels.WARN)
                        return
                    end

                    -- Filter out any nil or invalid entries
                    local valid_results = {}
                    for _, item in ipairs(result) do
                        if item and item.name and item.location and item.location.uri then
                            table.insert(valid_results, item)
                        end
                    end

                    if vim.tbl_isempty(valid_results) then
                        vim.notify("No valid symbols found", vim.log.levels.WARN)
                        return
                    end

                    pickers.new({}, {
                        prompt_title = "LSP Workspace Symbols",
                        finder = finders.new_table {
                            results = valid_results,
                            entry_maker = make_entry.gen_from_lsp_symbols(),
                        },
                        sorter = conf.generic_sorter({}),
                    }):find()
                end)
            end

        end,
    }
}
