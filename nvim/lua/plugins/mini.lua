return {
    { 
        'echasnovski/mini.nvim', 
        version = false,
        config = function() 
            require("mini.pairs").setup({})
            require("mini.comment").setup({})
            require("mini.surround").setup({})
            require("mini.splitjoin").setup({})
            require("mini.icons").setup({})
        end
    }
}
