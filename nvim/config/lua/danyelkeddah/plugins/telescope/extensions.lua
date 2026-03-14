local actions = require('telescope.actions')
return {
    wrap_results = true,
    fzf = {},
    ['ui-select'] = {
        require('telescope.themes').get_dropdown({}),
    },
    live_grep_args = {
        mappings = {
            i = {
                ['<C-k>'] = require('telescope-live-grep-args.actions').quote_prompt(),
                ['<C-space>'] = actions.to_fuzzy_refine,
            },
        },
    },
}
