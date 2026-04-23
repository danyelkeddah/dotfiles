local ai = require('mini.ai')

ai.setup({
    custom_textobjects = {
        o = ai.gen_spec.treesitter({
            a = { '@block.outer', '@conditional.outer', '@loop.outer' },
            i = { '@block.inner', '@conditional.inner', '@loop.inner' },
        }),
        f = ai.gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }),
        c = ai.gen_spec.treesitter({ a = '@class.outer', i = '@class.inner' }),
        t = { '<([%p%w]-)%f[^<%w][^<>]->.-</%1>', '^<.->().*()</[^/]->$' }, -- HTML/JSX tags
        d = { '%f[%d]%d+' }, -- digits
        e = { -- camel/snake word chunks
            { '%u[%l%d]+%f[^%l%d]', '%f[%S][%l%d]+%f[^%l%d]', '%f[%P][%l%d]+%f[^%l%d]', '^[%l%d]+%f[^%l%d]' },
            '^().*()$',
        },
        u = ai.gen_spec.function_call(),
        U = ai.gen_spec.function_call({ name_pattern = '[%w_]' }), -- no dot in function name
    },
})
