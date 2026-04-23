local map = vim.keymap.set

-- Movement: j/k walk wrapped display lines when no count; use count for real lines
map({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map({ 'n', 'x' }, '<Down>', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ 'n', 'x' }, '<Up>', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Search: n/N always moves in the forward-slash direction and recenters while opening folds
map('n', 'n', "'Nn'[v:searchforward].'zv'", { expr = true, desc = 'Next search result' })
map('x', 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next search result' })
map('o', 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next search result' })
map('n', 'N', "'nN'[v:searchforward].'zv'", { expr = true, desc = 'Prev search result' })
map('x', 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Prev search result' })
map('o', 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Prev search result' })

-- Clear search highlight on <esc>, plus a broader "recover from noise" combo
map({ 'i', 'n' }, '<esc>', '<cmd>noh<cr><esc>', { desc = 'Escape and clear hlsearch' })
map('n', '<leader>ur', '<cmd>nohlsearch<bar>diffupdate<bar>normal! <C-l><cr>', { desc = 'Redraw / clear hlsearch / diff update' })

-- Visual indent: keep selection after `<` and `>` so you can chain them
map('v', '<', '<gv', { desc = 'Dedent and reselect' })
map('v', '>', '>gv', { desc = 'Indent and reselect' })

-- Paste over a selection without clobbering the unnamed register
map('x', 'p', '"_dP', { desc = 'Paste without overwriting register' })

-- Break the undo chain on common punctuation for finer-grained `u`
map('i', ',', ',<c-g>u')
map('i', '.', '.<c-g>u')
map('i', ';', ';<c-g>u')

-- Save from every common mode
map({ 'i', 'x', 'n', 's' }, '<C-s>', '<cmd>w<cr><esc>', { desc = 'Save file' })

-- Quit
map('n', '<leader>qq', '<cmd>qa<cr>', { desc = 'Quit all' })
map('n', 'q:', ':q<cr>', { desc = 'Quit (q: mis-hit guard)' })

-- Restore the original K (keyword lookup) on <leader>K, since LSP usually overrides K
map('n', '<leader>K', '<cmd>norm! K<cr>', { desc = 'Keywordprg (original K)' })

-- Inspect highlight/treesitter captures under the cursor (debug colorscheme issues)
map('n', '<leader>ui', vim.show_pos, { desc = 'Inspect position' })

-- Windows
map('n', '<leader>ww', '<C-w>p', { desc = 'Jump to other window', remap = true })
map('n', '<leader>wd', '<C-w>c', { desc = 'Close window', remap = true })
map('n', '<leader>wv', '<C-w>v', { desc = 'Split vertically (right)', remap = true })
map('n', '<leader>wh', '<C-w>s', { desc = 'Split horizontally (below)', remap = true })
map('n', '<C-Up>', '<cmd>resize +2<cr>', { desc = 'Increase window height' })
map('n', '<C-Down>', '<cmd>resize -2<cr>', { desc = 'Decrease window height' })
map('n', '<C-Left>', '<cmd>vertical resize -2<cr>', { desc = 'Decrease window width' })
map('n', '<C-Right>', '<cmd>vertical resize +2<cr>', { desc = 'Increase window width' })

-- Move the current line or selection up/down while re-indenting
map('n', '<A-j>', '<cmd>m .+1<cr>==', { desc = 'Move line down' })
map('n', '<A-k>', '<cmd>m .-2<cr>==', { desc = 'Move line up' })
map('i', '<A-j>', '<esc><cmd>m .+1<cr>==gi', { desc = 'Move line down' })
map('i', '<A-k>', '<esc><cmd>m .-2<cr>==gi', { desc = 'Move line up' })
map('v', '<A-j>', ":m '>+1<cr>gv=gv", { desc = 'Move selection down' })
map('v', '<A-k>', ":m '<-2<cr>gv=gv", { desc = 'Move selection up' })

-- Buffers (note: <S-h>/<S-l> override the default H/L "jump to screen top/bottom")
map('n', '<S-h>', '<cmd>bprevious<cr>', { desc = 'Prev buffer' })
map('n', '<S-l>', '<cmd>bnext<cr>', { desc = 'Next buffer' })
map('n', '[b', '<cmd>bprevious<cr>', { desc = 'Prev buffer' })
map('n', ']b', '<cmd>bnext<cr>', { desc = 'Next buffer' })
map('n', '<leader>bb', '<cmd>e #<cr>', { desc = 'Alternate buffer' })

-- Quickfix and location list
map('n', '<leader>xl', '<cmd>lopen<cr>', { desc = 'Location list' })
map('n', '<leader>xq', '<cmd>copen<cr>', { desc = 'Quickfix list' })
map('n', '[q', vim.cmd.cprev, { desc = 'Prev quickfix item' })
map('n', ']q', vim.cmd.cnext, { desc = 'Next quickfix item' })

-- Diagnostics: ]d/[d are built-in defaults since Neovim 0.10; only add severity-filtered helpers
local diagnostic_jump = function(count, severity)
    return function()
        vim.diagnostic.jump({
            count = count,
            severity = severity and vim.diagnostic.severity[severity] or nil,
        })
    end
end
map('n', '<leader>cd', vim.diagnostic.open_float, { desc = 'Line diagnostics' })
map('n', ']e', diagnostic_jump(1, 'ERROR'), { desc = 'Next error' })
map('n', '[e', diagnostic_jump(-1, 'ERROR'), { desc = 'Prev error' })
map('n', ']w', diagnostic_jump(1, 'WARN'), { desc = 'Next warning' })
map('n', '[w', diagnostic_jump(-1, 'WARN'), { desc = 'Prev warning' })

-- Insert-mode navigation (arrows without leaving home row)
map('i', '<C-h>', '<Left>', { desc = 'Insert: cursor left' })
map('i', '<C-l>', '<Right>', { desc = 'Insert: cursor right' })
map('i', '<C-j>', '<Down>', { desc = 'Insert: cursor down' })
map('i', '<C-k>', '<Up>', { desc = 'Insert: cursor up' })
map('i', '<C-b>', '<esc>^i', { desc = 'Insert: jump to start of line' })
map('i', '<C-e>', '<end>', { desc = 'Insert: jump to end of line' })

-- TODO: revisit once all plugins are installed
--   1. <S-h>/<S-l> override the default H/L (jump to screen top/bottom). Intentional but destructive.
--   2. <C-h> in insert mode: by terminal convention <C-h> == <BS>. Remapping to <Left> means Ctrl+H
--      moves instead of backspacing. Fine if you only use real Backspace.
--   3. <C-j>/<C-k> in insert mode will clash with completion plugins (blink.cmp, nvim-cmp) which
--      typically bind them to next/prev completion item. Pick a winner when you install one.
--   4. q: -> :q<cr>. If you'd rather just disable the cmdline history window without risking
--      an accidental quit, swap to: map('n', 'q:', '<nop>').
