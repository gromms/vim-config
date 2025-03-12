local lsp_zero = require('lsp-zero')

vim.filetype.add({ extension = { templ = "templ" } })

lsp_zero.on_attach(function(client, bufnr)
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
end)

require('mason').setup({})
require('mason-lspconfig').setup({
    ensure_installed = {
        'eslint',
        'rust_analyzer',
        'kotlin_language_server',
        'jsonls',
        'html',
        'pylsp',
        'graphql',
        'groovyls',
        'gradle_ls',
        'gopls',
        'templ',
        'lua_ls',
        'jdtls'
    },
    handlers = {
        lsp_zero.default_setup,
    --    lua_ls = function()
    --        local lua_opts = lsp_zero.nvim_lua_ls()
    --        local lspc = require('lspconfig')
    --        lspc.lua_ls.setup(lua_opts)
    --    end,
    }
})

lspconfig = require('lspconfig')

require("java").setup()
lspconfig.jdtls.setup({
    settings = {
        java = {
            configuration = {
                runtimes = {
                    {
                        name = "OpenJDK-21",
                        path = "/opt/homebrew/opt/openjdk@21"
                    }
                }
            }
        }
    }
})

lspconfig.gopls.setup({
    on_attach = lsp_zero.on_attach,
    capabilities = lsp_zero.capabilities,
    settings = {
        gopls = {
            analyses = {
                unusedparams = true,
                shadow = true
            },
            staticcheck = true,
        },
    },
})

lspconfig.ruby_lsp.setup({
  init_options = {
    formatter = 'standard',
    linters = { 'standard' },
  },
})

local configs = require('lspconfig.configs')
configs.templ = {
  default_config = {
    cmd = { "templ", "lsp", "-http=localhost:7474", "-log=/Users/grom/templ.log" },
    filetypes = { 'templ' },
    root_dir = lspconfig.util.root_pattern("go.mod", ".git"),
    settings = {},
  },
}

local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }

cmp.setup({
    sources = {
        { name = 'path' },
        { name = 'nvim_lsp' },
        { name = 'nvim_lua' },
    },
    formatting = lsp_zero.cmp_format(),
    mapping = cmp.mapping.preset.insert({
        ['C-p'] = cmp.mapping.select_prev_item(cmp_select),
        ['C-n'] = cmp.mapping.select_next_item(cmp_select),
        ["<C-o>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Insert,
            select = true,
        }),
        ["<C-Space>"] = cmp.mapping.complete(),
    }),

})

lsp_zero.setup()
