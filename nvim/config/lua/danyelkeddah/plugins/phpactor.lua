return {
    'phpactor/phpactor',
    build = 'composer install --no-dev --optimize-autoloader',
    ft = 'php',
    keys = {
        { '<Leader>pm', ':PhpactorContextMenu<CR>', ft = 'php' },
        { '<Leader>pn', ':PhpactorClassNew<CR>', ft = 'php' },
    },
}
