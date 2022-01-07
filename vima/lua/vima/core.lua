-- Core configuration
--------------------------------------------------------------------------------

local opt = vim.opt

opt.autowriteall = true
opt.clipboard = 'unnamedplus'
opt.cmdheight = 2
opt.colorcolumn = '120'
opt.completeopt = { 'menuone', 'preview' }
opt.cursorline = true
opt.expandtab = true
opt.fileencoding = 'utf-8'
opt.fillchars = { eob = ' ' }
opt.foldenable = false
opt.foldmethod = 'syntax'
opt.ignorecase = true
opt.iskeyword:append('-')
opt.list = true
opt.listchars = 'tab:⇥ ,trail:·'
opt.mouse = 'a'
opt.number = true
opt.pumheight = 15
opt.relativenumber = true
opt.scrolloff = 5
opt.shiftround = true
opt.shiftwidth = 2
opt.shortmess:append('cI')
opt.showmode = false
opt.showtabline = 2
opt.sidescrolloff = 10
opt.signcolumn = 'yes'
opt.smartcase = true
opt.smartindent = true
opt.splitbelow = true
opt.splitright = true
opt.swapfile = false
opt.switchbuf = 'useopen,usetab,newtab'
opt.tabstop = 2
opt.termguicolors = true
opt.timeoutlen = 300
opt.title = true
opt.undofile = true
opt.undolevels = 2000
opt.updatetime = 300
opt.visualbell = true
opt.whichwrap:append('<>[]hl')
opt.wildignore = 'build,.svn,CVS,.git,.hg,*.o,*.a,*.class,*.mo,*.la,*.so,*.obj,*.swp,*.jpg,*.png,*.xpm,*.gif,*.pyc'
opt.wildmode = 'longest,full'
opt.wrap = false
opt.writebackup = false

-- Core mappings
--------------------------------------------------------------------------------

local map = require('vima.utils').map

-- Space as leader key
vim.g.mapleader = ' '
map('', '<Space>', '<NOP>')

-- Insert mode mappings
map('i', 'jk', '<Esc>')
