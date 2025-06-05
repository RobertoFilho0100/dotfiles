-- Basic options
vim.opt.number = true           -- Show line numbers
vim.opt.relativenumber = true   -- Relative line numbers for easier navigation
vim.opt.hlsearch = true         -- Highlight search matches
vim.opt.incsearch = true        -- Incremental search
vim.opt.termguicolors = true    -- True color support
vim.opt.expandtab = true        -- Use spaces instead of tabs
vim.opt.shiftwidth = 2          -- Indentation width
vim.opt.tabstop = 2             -- Tab width
vim.opt.smartindent = true      -- Smart indentation
vim.opt.swapfile = false        -- Disable swap files
vim.opt.backup = false          -- Disable backup files
vim.opt.undofile = true         -- Enable persistent undo
vim.opt.clipboard = "unnamedplus" -- Use system clipboard

-- Plugin manager installation (lazy.nvim)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Plugin setup
require("lazy").setup({
  -- Theme
  { "catppuccin/nvim", name = "catppuccin" },

  -- LSP and Autocomplete
  "neovim/nvim-lspconfig",     -- Language Server Protocol configurations
  "hrsh7th/nvim-cmp",          -- Autocomplete plugin
  "hrsh7th/cmp-nvim-lsp",      -- LSP source for nvim-cmp
  "hrsh7th/cmp-buffer",        -- Buffer source for nvim-cmp
  "hrsh7th/cmp-path",          -- Path source for nvim-cmp
  "L3MON4D3/LuaSnip",          -- Snippets engine
  "saadparwaiz1/cmp_luasnip",  -- Snippet completions for nvim-cmp

  -- Status line
  "nvim-lualine/lualine.nvim",

  -- Treesitter (advanced syntax highlighting)
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
  },

  -- Icons
  "nvim-tree/nvim-web-devicons",

  -- File Explorer sidebar
  "nvim-tree/nvim-tree.lua",

  -- Fuzzy Finder
  "nvim-telescope/telescope.nvim",
  "nvim-lua/plenary.nvim",
})

-- Set colorscheme
vim.cmd([[colorscheme catppuccin]])

-- Lualine status line setup
require("lualine").setup({
  options = {
    theme = "catppuccin",
    section_separators = "",
    component_separators = "",
  }
})

-- Treesitter setup
require("nvim-treesitter.configs").setup({
  ensure_installed = { "lua", "python", "javascript", "typescript", "html", "css", "json" },
  highlight = { enable = true },
  indent = { enable = true },
})

-- Autocomplete (nvim-cmp) setup
local cmp = require("cmp")
local luasnip = require("luasnip")

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  }),
  sources = {
    { name = "nvim_lsp" },
    { name = "buffer" },
    { name = "path" },
    { name = "luasnip" },
  },
})

-- Basic LSP config (example for Lua)
local lspconfig = require("lspconfig")
lspconfig.lua_ls.setup({})

-- Nvim-tree file explorer setup
require("nvim-tree").setup({
  view = {
    width = 30,
    side = "left",
  },
  renderer = {
    highlight_git = true,
    icons = {
      show = {
        git = true,
        folder = true,
        file = true,
        folder_arrow = true,
      },
    },
  },
})

-- Toggle nvim-tree with Ctrl+n
vim.api.nvim_set_keymap("n", "<C-n>", ":NvimTreeToggle<CR>", { noremap = true, silent = true })

-- Auto open nvim-tree when opening a directory
vim.cmd([[
  autocmd StdinReadPre * let s:std_in=1
  autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists('s:std_in') | execute 'NvimTreeOpen' | endif
]])

-- Telescope setup
require("telescope").setup{}

-- Keymap for telescope file finder
vim.api.nvim_set_keymap("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { noremap = true, silent = true })
