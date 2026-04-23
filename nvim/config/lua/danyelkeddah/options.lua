-- Leader
vim.g.mapleader = ' ' -- use Space as the global leader key
vim.g.maplocalleader = ' ' -- use Space as the buffer-local leader key

-- UI
vim.opt.termguicolors = true -- enable 24-bit RGB colors in the terminal
vim.opt.cursorline = true -- highlight the screen line the cursor is on
vim.opt.cursorlineopt = 'number' -- highlight only the line number, not the whole row
vim.opt.number = true -- show absolute line numbers
vim.opt.relativenumber = true -- show other line numbers relative to the cursor
vim.opt.signcolumn = 'yes:2' -- always reserve 2 columns so text doesn't shift when signs appear
vim.opt.showmode = false -- hide the default mode indicator (the statusline shows it)
vim.opt.laststatus = 3 -- one global statusline across all splits
vim.opt.pumblend = 10 -- make the completion popup slightly transparent
vim.opt.pumheight = 10 -- cap the completion popup to 10 visible entries
vim.opt.title = true -- set the terminal window title
vim.opt.titlestring = 'vim (' .. vim.fn.substitute(vim.fn.getcwd(), '^.*/', '', '') .. ')' -- format: "vim (dirname)"
vim.opt.list = true -- render invisible whitespace markers (see listchars)
vim.opt.listchars = { tab = '▸ ', trail = '·' } -- glyphs for tab characters and trailing whitespace
vim.opt.fillchars = { -- glyphs used for folds, diffs, empty lines, etc.
    foldopen = '▾',
    foldclose = '▸',
    fold = ' ',
    foldsep = ' ',
    diff = '╱',
    eob = ' ', -- hide the ~ on empty lines below the buffer
}
vim.opt.smoothscroll = true -- scroll by screen line instead of jumping for wrapped lines

-- Indentation (tabs render as 4 columns, but actual indent is 2 spaces)
vim.opt.expandtab = true -- insert spaces instead of literal tab characters
vim.opt.shiftwidth = 2 -- spaces per indent level (used by >>, <<, auto-indent)
vim.opt.tabstop = 4 -- columns a literal tab character displays as
vim.opt.softtabstop = 2 -- spaces inserted when pressing <Tab> in insert mode
vim.opt.shiftround = true -- round >> / << to the nearest multiple of shiftwidth
vim.opt.smartindent = true -- auto-indent new lines based on syntax

-- Editing
vim.opt.clipboard = 'unnamedplus' -- share yank/paste with the system clipboard
vim.opt.confirm = true -- prompt on :q with unsaved changes instead of erroring
vim.opt.conceallevel = 2 -- hide markers (bold/italic/etc.); markdown autocmd drops to 0 in insert mode
vim.opt.formatoptions = 'jcroqlnt' -- auto-format rules for comments / text (see :h fo-table)
vim.opt.mouse = 'a' -- enable mouse in all modes including command-line
vim.opt.completeopt = 'menu,menuone,noinsert,noselect' -- show menu always, don't auto-insert or preselect
vim.opt.timeoutlen = 300 -- ms to wait for a mapped key sequence to complete
vim.opt.wrap = false -- do not visually wrap long lines

-- Search
vim.opt.ignorecase = true -- case-insensitive search by default
vim.opt.smartcase = true -- ...except when the pattern contains uppercase letters
vim.opt.grepprg = 'rg --vimgrep' -- use ripgrep for :grep
vim.opt.grepformat = '%f:%l:%c:%m' -- how to parse file:line:col:message from ripgrep output
vim.opt.wildmode = 'longest:full,full' -- cmdline completion: complete longest match, then show menu

-- Splits
vim.opt.splitbelow = true -- horizontal splits open below the current window
vim.opt.splitright = true -- vertical splits open to the right of the current window
vim.opt.splitkeep = 'screen' -- keep visible text fixed when creating a split (don't scroll)
vim.opt.winminwidth = 5 -- minimum width a window can be resized to

-- Persistence
vim.opt.undofile = true -- persist undo history to disk across sessions
vim.opt.undolevels = 10000 -- how many undo steps to keep in memory per buffer
vim.opt.swapfile = false -- don't create .swp files
vim.opt.sessionoptions = { 'buffers', 'curdir', 'tabpages', 'winsize', 'help', 'globals', 'skiprtp', 'folds' } -- what :mksession captures
vim.opt.shada = { '!', "'1000", '<50', 's10', 'h' } -- ShaDa: remember 1000 marks instead of the default 100
vim.opt.updatetime = 200 -- ms idle before CursorHold fires / swap writes
vim.opt.redrawtime = 10000 -- ms budget for syntax redraw on long lines

-- Misc
vim.opt.shortmess:append({ W = true, I = true, c = true, C = true }) -- silence "written", intro, and completion noise
vim.opt.exrc = true -- source project-local .nvim.lua (requires :trust per project)
vim.g.markdown_recommended_style = 0 -- don't let runtime ftplugin/markdown.vim override tabstop/shiftwidth

-- Diagnostics
vim.diagnostic.config({
    virtual_text = { -- inline message at the end of the offending line
        prefix = '●',
        spacing = 4,
        source = 'if_many', -- show source name only when multiple sources disagree
    },
    signs = { -- per-severity icon in the signcolumn
        text = {
            [vim.diagnostic.severity.ERROR] = '',
            [vim.diagnostic.severity.WARN] = '',
            [vim.diagnostic.severity.HINT] = '',
            [vim.diagnostic.severity.INFO] = '',
        },
    },
    severity_sort = true, -- order diagnostics by severity (errors first)
})
