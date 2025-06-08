-- Basic options
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.termguicolors = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.smartindent = true
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true
vim.opt.clipboard = "unnamedplus"

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
  "neovim/nvim-lspconfig",
  "hrsh7th/nvim-cmp",
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",
  "L3MON4D3/LuaSnip",
  "saadparwaiz1/cmp_luasnip",

  -- Null-ls for formatters and linters
  "jose-elias-alvarez/null-ls.nvim",

  -- Status line
  "nvim-lualine/lualine.nvim",

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
  },

  -- Icons
  "nvim-tree/nvim-web-devicons",

  -- File Explorer
  "nvim-tree/nvim-tree.lua",

  -- Fuzzy Finder
  "nvim-telescope/telescope.nvim",
  "nvim-lua/plenary.nvim",

  -- Terminal Toggle Plugin
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = true,
  },
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

-- Basic LSP config for Lua
local lspconfig = require("lspconfig")
lspconfig.lua_ls.setup({})

-- === Python LSP and formatting setup ===

-- null-ls setup for formatters and linters
local null_ls = require("null-ls")
null_ls.setup({
  sources = {
    null_ls.builtins.formatting.black,   -- Python formatter
    null_ls.builtins.diagnostics.flake8, -- Python linter
  },
})

-- Pyright LSP for Python
lspconfig.pyright.setup({
  on_attach = function(client, bufnr)
    -- Enable formatting with null-ls if available
    if client.supports_method("textDocument/formatting") then
      vim.api.nvim_clear_autocmds({ group = 0, buffer = bufnr })
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({ bufnr = bufnr })
        end,
      })
    end
  end,
})

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

vim.opt.shell = "pwsh"
vim.opt.shellcmdflag = '-NoLogo -NoExit -Command "& { . \"$PROFILE\" }"'
vim.opt.shellquote = ""
vim.opt.shellxquote = ""

-- ToggleTerm config (VSCode-style terminal)
require("toggleterm").setup({
  open_mapping = [[<C-j>]],
  direction = "horizontal",
  size = 15,
  shade_terminals = true,
  start_in_insert = true,
  insert_mappings = true,
  terminal_mappings = true,
  persist_size = true,
  close_on_exit = true,
  shell = vim.o.shell,
})

vim.api.nvim_set_keymap("t", "<Esc>", [[<C-\><C-n>]], { noremap = true, silent = true })
