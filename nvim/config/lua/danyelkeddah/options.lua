local icons = require('danyelkeddah.icons')
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.autoformat = true
vim.g.root_spec = { 'lsp', { '.git', 'lua' }, 'cwd' }

-- vim.opt.autowrite = true -- autosave
vim.opt.clipboard = 'unnamedplus'
vim.opt.completeopt = 'menu,menuone,noinsert,noselect'
vim.opt.conceallevel = 2 -- Hide * markup for bold and italic, but not markers with substitutions
-- vim.opt.conceallevel = 0
vim.opt.confirm = true
vim.opt.cursorline = true
vim.opt.expandtab = true -- use spaces instead of tabs
vim.opt.formatoptions = 'jcroqlnt' -- tcqj
vim.opt.grepformat = '%f:%l:%c:%m'
vim.opt.grepprg = 'rg --vimgrep'
vim.opt.ignorecase = true
vim.opt.inccommand = 'nosplit' -- preview incremental substitute
vim.opt.laststatus = 3 -- global statusline
vim.opt.list = true -- Show some invisible characters (tabs...
vim.opt.mouse = 'a' -- Enable mouse mode
vim.opt.number = true -- Print line number
vim.opt.pumblend = 10 -- Popup blend
vim.opt.pumheight = 10 -- Maximum number of entries in a popup
vim.opt.relativenumber = true
--vim.opt.scrolloff = 4 -- Lines of context
vim.opt.sessionoptions = { 'buffers', 'curdir', 'tabpages', 'winsize', 'help', 'globals', 'skiprtp', 'folds' }
vim.opt.shiftround = true -- Round indent
vim.opt.shiftwidth = 2
vim.opt.shortmess:append({
    W = true,
    I = true,
    c = true,
    C = true,
})
vim.opt.showmode = false -- Dont show mode since we have a statusline
--vim.opt.sidescrolloff = 8 -- Columns of context
vim.opt.signcolumn = 'yes:2' -- Always show the signcolumn, otherwise it would shift the text each time
vim.opt.smartcase = true -- Don't ignore case with capitals
vim.opt.smartindent = true -- Insert indents automatically
vim.opt.spelllang = { 'en' }
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.splitkeep = 'screen'
vim.opt.tabstop = 4 -- Number of spaces tabs count for
vim.opt.softtabstop = 2
vim.opt.termguicolors = true
vim.opt.timeoutlen = 300
vim.opt.undofile = true
vim.opt.undolevels = 10000
vim.opt.updatetime = 200 -- Save swap file and trigger CursorHold
-- vim.opt.virtualedit = 'block' -- Allow cursor to move where there is no text in visual block mode
vim.opt.wildmode = 'longest:full,full' -- Command-line completion mode
vim.opt.winminwidth = 5 -- Minimum window width
vim.opt.wrap = false -- Disable line wrap
vim.opt.fillchars = {
    foldopen = '',
    foldclose = '',
    -- fold = "⸱",
    fold = ' ',
    foldsep = ' ',
    diff = '╱',
    eob = ' ',
}
if vim.fn.has('nvim-0.10') == 1 then
    vim.opt.smoothscroll = true
end
-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0
vim.g.vim_markdown_folding_disabled = 1

-- extras
vim.opt.hidden = true
-- vim.opt.backupdir:remove('.')
vim.opt.swapfile = false
vim.opt.autoread = true
vim.opt.encoding = 'utf-8'
vim.opt.backspace = 'indent,eol,start'
vim.opt.cursorlineopt = 'number'
vim.opt.hlsearch = true
vim.opt.title = true
vim.opt.autoindent = true
vim.opt.shada = { '!', "'1000", '<50', 's10', 'h' }
vim.opt.redrawtime = 10000
vim.opt.titlestring = 'vim (' .. vim.fn.substitute(vim.fn.getcwd(), '^.*/', '', '') .. ')'
vim.opt.exrc = true
vim.opt.secure = true
vim.opt.cmdheight = 1
vim.opt.listchars = { tab = '▸ ', trail = '·' }

vim.g.skip_ts_context_commentstring_module = true

vim.diagnostic.config({
    virtual_text = {
        prefix = icons.diagnostics.Dot,
        spacing = 4,
        source = 'if_many',
    },
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = icons.diagnostics.BoldError,
            [vim.diagnostic.severity.WARN] = icons.diagnostics.BoldWarning,
            [vim.diagnostic.severity.HINT] = icons.diagnostics.BoldHint,
            [vim.diagnostic.severity.INFO] = icons.diagnostics.BoldInformation,
        },
    },
    underline = true,
    update_in_insert = false,
    severity_sort = true,
})
