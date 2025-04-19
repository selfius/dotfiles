-- mapping the leader keys
vim.g.mapleader = ","
vim.g.maplocalleader = ","

-- escape terminal input mode from `:terminal` with Esc instead of C-\ C-n
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')

-- navigation between buffers
vim.keymap.set('n', '<Leader>e', '<cmd> :ls <CR>:b ')

-- LSP code formatting for all the languages
vim.api.nvim_set_keymap('n', '<leader>f', ':lua vim.lsp.buf.format()<CR>', { noremap = true, silent = true })

-- showing diagnostics for current line

vim.api.nvim_set_keymap('n', '<leader>q', ':lua vim.diagnostic.open_float()<CR>', { noremap = true, silent = true })


vim.keymap.set('n', '<leader>m',
        function()
                vim.lsp.buf.code_action(
                        {
                                filter = function(x)
                                        return x.title and string.find(x.title, 'Import')
                                end,
                                apply = true
                        })
        end,
        { noremap = true, silent = true })

vim.keymap.set('n', '<leader>a', vim.lsp.buf.code_action, { noremap = true, silent = true })


vim.opt.signcolumn = 'yes:1'
vim.opt.relativenumber = true
vim.opt.virtualedit = 'block'


vim.opt.sessionoptions = 'curdir,folds,globals,help,tabpages,terminal,winsize'
vim.o.showtabline = 2
vim.o.softtabstop = 4
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.list = true

require("config.lazy")
