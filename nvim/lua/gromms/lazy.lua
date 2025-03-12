local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    --{ import = "lazyvim.plugins.extras.dap.core" },
    "folke/tokyonight.nvim",
    {
        "rose-pine/neovim",
        name = 'rose-pine',
        config = function()
            vim.cmd("colorscheme rose-pine")
        end
    },
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.6',
        -- or                              , branch = '0.1.x',
        dependencies = { 'nvim-lua/plenary.nvim' }
    },
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
    },
    { "nvim-treesitter/nvim-treesitter" },
    "ThePrimeagen/harpoon",
    "mbbill/undotree",
    { 'williamboman/mason.nvim' },
    { 'williamboman/mason-lspconfig.nvim' },
    --{ "rcarriga/nvim-dap-ui",             dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" } },
    { 'VonHeikemen/lsp-zero.nvim',        branch = 'v3.x' },
    { 'neovim/nvim-lspconfig' },
    { 'hrsh7th/cmp-nvim-lsp' },
    { 'hrsh7th/nvim-cmp' },
    { 'L3MON4D3/LuaSnip' },
    {
        "nvim-java/nvim-java",
        config = false,
        dependencies = {
            {
                "neovim/nvim-lspconfig",
            }
        }
    },
    "tpope/vim-fugitive",
    "nvim-telescope/telescope-ui-select.nvim",
    { "nvim-lualine/lualine.nvim", dependencies = { "nvim-tree/nvim-web-devicons" } }
})
