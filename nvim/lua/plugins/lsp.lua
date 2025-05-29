return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            {
                "mason-org/mason.nvim",
                version = "^1.0.0",
            },
            {
                "mason-org/mason-lspconfig.nvim",
                version = "^1.0.0",
            },
        },
        config = function()
            require('java').setup()
            require('lspconfig').jdtls.setup({})

            require("mason").setup({})
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "gopls",
                    "lua_ls",
                    "jdtls"
                }
            })

            local function set_default_keybinds(bufnr)
                local opts = { buffer = bufnr, remap = false }

                vim.keymap.set("n", "gD", function() vim.lsp.buf.declaration() end, opts)
                vim.keymap.set("n", "gi", function() vim.lsp.buf.implementation() end, opts)
                vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
                vim.keymap.set("n", "<leader>wl", function()
                    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                end, opts)
                vim.keymap.set("n", "<leader>D", function() vim.lsp.buf.type_definition() end, opts)
                vim.keymap.set("n", "<leader>rn", function() vim.lsp.buf.rename() end, opts, "Rename")
                vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
                vim.keymap.set("v", "<leader>ca", "<ESC><CMD>lua vim.lsp.buf.range_code_action()<CR>",
                    { noremap = true, silent = true, buffer = bufnr, desc = "Code actions" })
                vim.keymap.set("n", "==", function() vim.lsp.buf.format { async = true } end, opts)
                vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
                vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
                vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
                vim.keymap.set("n", "<leader>vd", function() vim.lsp.buf.open_float() end, opts)
                vim.keymap.set("n", "[d", function() vim.lsp.buf.goto_next() end, opts)
                vim.keymap.set("n", "]d", function() vim.lsp.buf.goto_prev() end, opts)
                --vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
                vim.keymap.set("n", "<leader>vrr", function() require('telescope.builtin').lsp_references() end,
                    { noremap = true, silent = true })
                vim.keymap.set("n", "<C-s>", function() vim.lsp.buf.signature_help() end, opts)
                vim.keymap.set("n", "gn", function() vim.diagnostic.goto_next() end, opts)
                vim.keymap.set("n", "gp", function() vim.diagnostic.goto_prev() end, opts)
                vim.keymap.set('n', '<space>?', '<cmd>lua vim.diagnostic.open_float()<CR>',
                    { buffer = bufnr, noremap = true, silent = true })

                -- dap
                vim.keymap.set("n", "<leader>dp", "<cmd>lua require'dap'.toggle_breakpoint()<cr>", opts)
                vim.keymap.set("n", "<leader>dc", "<cmd>lua require'dap'.continue()<cr>", opts)
                vim.keymap.set("n", "<leader>drt", "<cmd>lua require'dapui'.toggle()<cr>", opts)
                vim.keymap.set("n", "<leader>dre", "<Cmd>lua require('dapui').eval()<CR>", opts)
                vim.keymap.set("v", "<leader>dre", "<M-k> <Cmd>lua require('dapui').eval()<CR>", opts)
                vim.keymap.set("n", "<leader>dd", "<cmd>lua require'dap'.disconnect({ terminateDebuggee = true })<cr>",
                    opts)

                vim.keymap.set("n", "<leader>sw", function()
                    local query = vim.fn.input("Symbol > ")
                    vim.lsp.buf_request(0, "workspace/symbol", { query = query })
                end, { desc = "LSP Symbols" })
            end

            local function on_attach(_, bufnr)
                set_default_keybinds(bufnr)
                vim.api.nvim_set_hl(0, "IlluminatedWordText", { underline = true })
                vim.api.nvim_set_hl(0, "IlluminatedWordRead", { underline = true })
                vim.api.nvim_set_hl(0, "IlluminatedWordWrite", { underline = true })
            end

            require("mason-lspconfig").setup_handlers({
                function(server_name)
                    require("lspconfig")[server_name].setup({
                        on_attach = on_attach,
                        --capabilities = require("cmp_nvim_lsp").default_capabilities(), -- optional
                    })
                end,
            })
        end
    },
}
