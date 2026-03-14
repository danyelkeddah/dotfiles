return {
    cmd = { 'yaml-language-server', '--stdio' },
    filetypes = { 'yaml', 'yaml.docker-compose', 'yaml.gitlab', 'yml' },
    root_markers = { 'package.json', '.git' },
    settings = {
        yaml = {
            schemaStore = {
                enable = false,
                url = '',
            },
            schemas = require('schemastore').yaml.schemas(),
        },
    },
}
