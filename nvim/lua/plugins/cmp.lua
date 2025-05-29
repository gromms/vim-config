return {
    { 'hrsh7th/cmp-nvim-lsp' },
    {
        'hrsh7th/nvim-cmp',
        config = function()
            local cmp = require('cmp')
            local cmp_select = { behavior = cmp.SelectBehavior.Select }

            cmp.setup({
                sources = {
                    { name = 'path' },
                    { name = 'nvim_lsp' },
                    { name = 'nvim_lua' },
                },
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

        end
    },
}
