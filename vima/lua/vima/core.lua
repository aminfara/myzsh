local opt = vim.opt

opt.backup = false
opt.clipboard = 'unnamedplus'
opt.expandtab = true
opt.fileencoding = 'utf-8'
opt.hidden = true
opt.hlsearch = true
opt.ignorecase = true
opt.iskeyword:append('-')
opt.shiftround = true
opt.shiftwidth = 2
opt.smartcase = true
opt.smartindent = true
opt.splitbelow = true
opt.splitright = true
opt.swapfile = false
opt.tabstop = 4
opt.timeoutlen = 300
opt.undofile = true
opt.undolevels = 2000
opt.updatetime = 300
opt.visualbell = true
opt.whichwrap:append('<>[]hl')
opt.wrap = false
opt.writebackup = false

if not vim.g.vscode then
    opt.cmdheight = 2
    opt.colorcolumn = '120'
    opt.completeopt = { 'menuone', 'noselect' }
    opt.conceallevel = 0
    opt.cursorline = true
    opt.fillchars = { eob = ' ' }
    opt.foldenable = false
    opt.foldmethod = 'syntax'
    opt.list = true
    opt.listchars = 'tab:⇥ ,trail:·'
    opt.mouse = 'a'
    opt.number = true
    opt.numberwidth = 3
    opt.pumheight = 10
    opt.relativenumber = true
    opt.ruler = true
    opt.scrolloff = 5
    opt.shortmess:append('cI')
    opt.showmode = false
    opt.showtabline = 2
    opt.sidescrolloff = 10
    opt.signcolumn = 'yes'
    opt.switchbuf = 'useopen,usetab,newtab'
    opt.termguicolors = true
    opt.title = true
    opt.wildignore = 'build,.svn,CVS,.git,.hg,*.o,*.a,*.class,*.mo,*.la,*.so,*.obj,*.swp,*.jpg,*.png,*.xpm,*.gif,*.pyc'
    opt.wildmode = 'longest,full'
end

-- disable bundled plugins
vim.g.loaded_matchit = 1
