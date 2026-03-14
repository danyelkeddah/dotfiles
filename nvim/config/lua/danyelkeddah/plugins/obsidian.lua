return {
    'epwalsh/obsidian.nvim',
    enabled = true,
    version = '*',
    lazy = true,
    ft = 'markdown',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'preservim/vim-markdown',
    },
    opts = {
        note_frontmatter_func = function(note)
            -- Add the title of the note as an alias.
            if note.title then
                note:add_alias(note.title)
            end

            local out = { id = note.id, aliases = note.aliases, tags = note.tags }

            -- `note.metadata` contains any manually added fields in the frontmatter.
            -- So here we just make sure those fields are kept in the frontmatter.
            if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
                for k, v in pairs(note.metadata) do
                    out[k] = v
                end
            end

            return out
        end,
        note_id_func = function(title)
            -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
            -- In this case a note with the title 'My new note' will be given an ID that looks
            -- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
            local suffix = ''
            if title ~= nil then
                -- If title is given, transform it into valid file name.
                suffix = title:gsub(' ', '-'):gsub('[^A-Za-z0-9-]', ''):lower()
            else
                -- If title is nil, just add 4 random uppercase letters to the suffix.
                for _ = 1, 4 do
                    suffix = suffix .. string.char(math.random(65, 90))
                end
            end
            return tostring(os.time()) .. '-' .. suffix
        end,
        templates = {
            folder = 'misc/templates',
            date_format = '%Y-%m-%d',
            time_format = '%H:%M',
        },
        workspaces = {
            {
                name = 'second-brain',
                path = '~/second-brain',
            },
        },
        notes_subdir = 'notes',
        new_notes_location = 'notes_subdir',
        daily_notes = {
            folder = 'dailies',
        },
        ui = {
            enable = true, -- set to false to disable all additional syntax features
            update_debounce = 200, -- update delay after a text change (in milliseconds)
            -- Define how various check-boxes are displayed
            checkboxes = {
                -- NOTE: the 'char' value has to be a single character, and the highlight groups are defined below.
                [' '] = { char = '󰄱', hl_group = 'ObsidianTodo' },
                ['x'] = { char = '', hl_group = 'ObsidianDone' },
                ['>'] = { char = '', hl_group = 'ObsidianRightArrow' },
                ['~'] = { char = '󰰱', hl_group = 'ObsidianTilde' },
                -- Replace the above with this if you don't have a patched font:
                -- [" "] = { char = "☐", hl_group = "ObsidianTodo" },
                -- ["x"] = { char = "✔", hl_group = "ObsidianDone" },

                -- You can also add more custom ones...
            },
            -- Use bullet marks for non-checkbox lists.
            bullets = { char = '•', hl_group = 'ObsidianBullet' },
            external_link_icon = { char = '', hl_group = 'ObsidianExtLinkIcon' },
            -- Replace the above with this if you don't have a patched font:
            -- external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
            reference_text = { hl_group = 'ObsidianRefText' },
            highlight_text = { hl_group = 'ObsidianHighlightText' },
            tags = { hl_group = 'ObsidianTag' },
            hl_groups = {
                -- The options are passed directly to `vim.api.nvim_set_hl()`. See `:help nvim_set_hl`.
                ObsidianTodo = { bold = true, fg = '#f78c6c' },
                ObsidianDone = { bold = true, fg = '#89ddff' },
                ObsidianRightArrow = { bold = true, fg = '#f78c6c' },
                ObsidianTilde = { bold = true, fg = '#ff5370' },
                ObsidianBullet = { bold = true, fg = '#89ddff' },
                ObsidianRefText = { underline = true, fg = '#c792ea' },
                ObsidianExtLinkIcon = { fg = '#c792ea' },
                ObsidianTag = { italic = true, fg = '#89ddff' },
                ObsidianHighlightText = { bg = '#75662e' },
            },
        },
    },
}
