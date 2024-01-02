local jdtls = require('jdtls')

function nnoremap(rhs, lhs, bufopts, desc)
    bufopts.desc = desc
    vim.keymap.set("n", rhs, lhs, bufopts)
end

local config = {
    cmd = {
        '/home/grom/jdtls/bin/jdtls',
        '-javaagent:/User/grom/.config/nvim/jar/lombok.jar'
    },
    root_dir = vim.fs.dirname(vim.fs.find({ 'gradlew', '.git', 'mvnw' }, { upward = true })[1]),

    on_attach = function(client, bufnr)
        local bufopts = { noremap = true, silent = true, buffer = bufnr }

        -- Java extensions provided by jdtls
        nnoremap("<leader>ev", jdtls.extract_variable, bufopts, "Extract variable")
        nnoremap("<leader>ec", jdtls.extract_constant, bufopts, "Extract constant")
        vim.keymap.set('v', "<space>em", [[<ESC><CMD>lua require('jdtls').extract_method(true)<CR>]],
            { noremap = true, silent = true, buffer = bufnr, desc = "Extract method" })
    end
}

require('jdtls').start_or_attach(config)
