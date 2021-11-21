-- Core vim options
--------------------------------------------------------------------------------

local opt = vim.opt

-- TODO: reorder
-- vim specific files
opt.backup = false
opt.writebackup = false
opt.swapfile = false
opt.undofile = true
opt.undolevels = 2000

-- save
opt.autowriteall = true

-- indentation
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.shiftround = true

-- search
opt.ignorecase = true
opt.smartcase = true

-- buffers
-- https://stackoverflow.com/questions/12740527/problems-with-vim-while-switching-between-open-files
opt.hidden = true
opt.switchbuf = 'useopen,usetab,newtab'

-- wild menu
opt.wildmode = 'longest,full'
opt.wildignore = 'build,.svn,CVS,.git,.hg,*.o,*.a,*.class,*.mo,*.la,*.so,*.obj,*.swp,*.jpg,*.png,*.xpm,*.gif,*.pyc'

-- input timeout
opt.ttimeoutlen = 100

-- folding
opt.foldmethod = 'syntax'

-- invisible characters
opt.list = true
opt.listchars = 'tab:⇥ ,trail:·'

-- scroll offsets
opt.scrolloff = 5
opt.sidescrolloff = 10

-- split behaviour
opt.splitbelow = true
opt.splitright = true

-- column and row highlight
opt.colorcolumn = '120'
opt.cursorline = true

-- line numbers
opt.number = true
opt.relativenumber = true

-- go to prev/next line with left/right
opt.whichwrap:append('<>[]hl')

-- mouse
opt.mouse = 'a'

-- miscellaneous
opt.visualbell = true
opt.signcolumn = 'yes'
opt.title = true
opt.fillchars = { eob = ' ' } -- disable tilde at the end of buffer
opt.termguicolors = true
