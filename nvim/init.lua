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
      'nvim-lualine/lualine.nvim',
      dependencies = { 'nvim-tree/nvim-web-devicons' }
    },
  },
  install = { colorscheme = { "habamax" } }, -- colorscheme for the plugin interface
  checker = { enabled = false }, -- auto-check for updates?
})

require('lualine').setup({
  options = { theme = 'powerline' },
})

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
