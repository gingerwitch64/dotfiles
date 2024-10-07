-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
  spec = { -- plugins here
    {
      "neovim/nvim-lspconfig",
      lazy = false,
    },
    {
      "nvim-lualine/lualine.nvim",
      dependencies = { "nvim-tree/nvim-web-devicons" }
    },
    {
      "folke/tokyonight.nvim",
      lazy = false,
      priority = 1000,
      opts = {},
    },
    {
      "nvim-treesitter/nvim-treesitter",
      lazy = false,
    },
    {
      "L3MON4D3/LuaSnip",
      version = "v2.*",
      build = "make install_jsregexp",
      dependencies = { "rafamadriz/friendly-snippets" },
    },
    {
      "hrsh7th/nvim-cmp",
      event = { "InsertEnter", "CmdlineEnter" },
      dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
      },
    },
    {
      "saadparwaiz1/cmp_luasnip",
    },
    {
      "m4xshen/autoclose.nvim",
    },
  },
  install = { colorscheme = { "tokyonight" } }, -- colorscheme for the plugin interface
  checker = { enabled = false }, -- auto-check for updates?
})

require("lualine").setup({
  options = { theme = "tokyonight" },
})

vim.cmd[[colorscheme tokyonight-night]]

local autoclose = require("autoclose")
local lspconfig = require("lspconfig")
local luasnip = require("luasnip")
local cmp = require("cmp")

cmp.setup({
  snippet = { expand = function(args) luasnip.lsp_expand(args.body) end, },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = {
    -- "Super Tab" mappings from
    -- https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#luasnip
    ['<CR>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        if luasnip.expandable() then
          luasnip.expand()
        else
          cmp.confirm({
            select = true,
          })
        end
      else
        fallback()
      end
    end),

    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.locally_jumpable(1) then
        luasnip.jump(1)
      else
        fallback()
      end
    end, { "i", "s" }),

    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
    -- end "Super Tab" mappings
  },
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
  },
  {
    { name = "buffer" },
  }),
})

cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {{ name = "buffer" }}
})

cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = "path" }
  }, {
    { name = "cmdline" }
  }),
  matching = { disallow_symbol_nonprefix_matching = false }
})

autoclose.setup()

require("luasnip.loaders.from_vscode").lazy_load()

local capabilities = require('cmp_nvim_lsp').default_capabilities()

lspconfig.clangd.setup        { capabilities = capabilities }
lspconfig.ruff.setup          { capabilities = capabilities }
lspconfig.rust_analyzer.setup { capabilities = capabilities }

require("nvim-treesitter.configs").setup {
  ensure_installed = {
    "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline",
    "rust", "python",
  },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
}

-- vim-derived settings

vim.opt.number      = true -- numbered lines
vim.opt.linebreak   = true -- break lines at words
vim.opt.showmatch   = true -- highlight matching brackets

vim.opt.ignorecase  = true -- search is not case sensitive, except:
vim.opt.smartcase   = true -- when uppercase letters are present
vim.opt.incsearch   = true -- dynamically show search results 

vim.opt.expandtab   = true -- use spaces, NOT tabs
vim.opt.smartindent = true -- contextual indenting
vim.opt.softtabstop = 2
vim.opt.shiftwidth  = 2
