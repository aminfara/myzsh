local o = vim.opt

o.autowriteall = true -- auto save
o.backup = false -- do not create backup files
o.clipboard = 'unnamedplus' -- allows neovim to access the system clipboard
o.cmdheight = 2 -- more space in the neovim command line for displaying messages
o.colorcolumn = '120' -- vertical wrapping boundary
o.completeopt = { 'menuone', 'noselect' } -- options for auto completion
o.conceallevel = 0 -- so that `` is visible in markdown files
o.cursorline = true -- highlight the current line
o.expandtab = true -- convert tabs to spaces
o.fileencoding = 'utf-8' -- the encoding written to a file
o.fillchars = { eob = ' ' } -- disable tilde at the end of buffer
o.foldenable = false -- do not fold by default
o.foldmethod = 'syntax' -- use syntax parser for folding, this will be overwritten by treesitter
o.hidden = true -- allow to switch to other files when current buffer is unsaved
o.hlsearch = true -- highlight all matches on previous search pattern
o.ignorecase = true -- ignore case in search patterns
o.iskeyword:append('-') -- consider words with dash as a whole word like 'up-to-date'
o.list = true -- show invisible characters
o.listchars = 'tab:⇥ ,trail:·' -- symbols for invisible characters
o.mouse = 'a' -- allow the mouse to be used in neovim
o.number = true -- set numbered lines
o.numberwidth = 4 -- set number column width to 2 {default 4}
o.pumheight = 10 -- pop up menu height
o.relativenumber = true -- set relative numbered lines
o.scrolloff = 8 -- scrolling offset
o.shiftround = true -- round indentation to match shiftwidth
o.shiftwidth = 2 -- the number of spaces inserted for each indentation
o.shortmess:append('cI') -- remove completion short messages
o.showmode = false -- we don't need to see things like -- INSERT -- anymore
o.showtabline = 2 -- always show tabs
o.sidescrolloff = 8 -- horizontal scrolling offset
o.signcolumn = 'yes' -- always show the sign column, otherwise it would shift the text each time
o.smartcase = true -- smart case
o.smartindent = true -- make indenting smarter again
o.splitbelow = true -- force all horizontal splits to go below current window
o.splitright = true -- force all vertical splits to go to the right of current window
o.swapfile = false -- do not create a swapfile
o.switchbuf = 'useopen,usetab,newtab' -- behaviour of switching between buffers
o.tabstop = 2 -- insert 2 spaces for a tab
o.termguicolors = true -- set term gui colors (most terminals support this)
o.timeoutlen = 300 -- time to wait for a mapped sequence to complete (in milliseconds)
o.title = true -- set the title of nvim window
o.undofile = true -- enable persistent undo
o.undolevels = 2000 -- how many changes to keep in undo history
o.updatetime = 300 -- faster completion (4000ms default)
o.visualbell = true -- hush up beeps
o.whichwrap:append('<>[]hl') -- move cursor to next/previous line on right/left movements
o.wildignore = 'build,.svn,CVS,.git,.hg,*.o,*.a,*.class,*.mo,*.la,*.so,*.obj,*.swp,*.jpg,*.png,*.xpm,*.gif,*.pyc' -- ignore these patterns in wild menu
o.wildmenu = true -- enhanced command line completion
o.wildmode = 'longest,full' -- match behaviour in wildmenu
o.wrap = false -- display lines as one long line
o.writebackup = false -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
