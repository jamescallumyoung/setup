-- Basic settings
vim.o.number = true         -- Enable line numbers
vim.o.relativenumber = true -- Enable relative line numbers

vim.o.tabstop = 4           -- Number of spaces a tab represents
vim.o.shiftwidth = 4        -- Number of spaces for each indentation
vim.o.expandtab = true      -- Convert tabs to spaces
vim.o.autoindent = true     -- Apply current line indentation to next line
vim.o.smartindent = true    -- Indents next line based on the current line's code content
vim.o.smarttab = true
vim.o.softtabstop = 4

vim.g.mouse = a             -- Allow clicking to place the cursor (as in modern GUIs)
vim.o.wrap = true           -- Line wrapping
vim.o.cursorline = false    -- Highlight the current line
vim.o.termguicolors = true  -- Enable 24-bit RGB colors
vim.o.showcmd = true

-- vim.g.coc_node_path = vim.fn.trim(vim.fn.system("echo $NVM_CURRENT_ON_START"))

-- Syntax highlighting and filetype plugins
-- vim.cmd('syntax enable')
-- vim.cmd('filetype plugin indent on')


-- Set up lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
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

-- tell lazy.nvim to load all plugins in ~/.config/nvim/lua/plugins{.lua|/*.lua}
require("lazy").setup("plugins")

-- set the colorscheme
vim.cmd[[colorscheme tokyonight-moon]]

