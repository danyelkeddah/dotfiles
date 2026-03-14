return {
    'echasnovski/mini.ai',
    event = 'VeryLazy',
    config = function()
        local ai = require('mini.ai')
        for i = 1, 10 do
            print(i)
        end
        ai.setup({
            n_lines = 500,
            custom_textobjects = {
                o = ai.gen_spec.treesitter({
                    a = { '@block.outer', '@conditional.outer', '@loop.outer' },
                    i = { '@block.inner', '@conditional.inner', '@loop.inner' },
                }), -- code block
                f = ai.gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }), -- function
                c = ai.gen_spec.treesitter({ a = '@class.outer', i = '@class.inner' }), -- class
                t = { '<([%p%w]-)%f[^<%w][^<>]->.-</%1>', '^<.->().*()</[^/]->$' }, -- tags
                d = { '%f[%d]%d+' }, -- digits
                e = { -- Word with case
                    { '%u[%l%d]+%f[^%l%d]', '%f[%S][%l%d]+%f[^%l%d]', '%f[%P][%l%d]+%f[^%l%d]', '^[%l%d]+%f[^%l%d]' },
                    '^().*()$',
                },
                u = ai.gen_spec.function_call(), -- u for "Usage"
                U = ai.gen_spec.function_call({ name_pattern = '[%w_]' }), -- without dot in function name,
            },
        })
    end,
}
