return {
    {
        'neovim/nvim-lspconfig',
        version = '2.0.0',
        config = function()
            require 'lspconfig'.lua_ls.setup {
                on_init = function(client)
                    client.config.settings.Lua = vim.tbl_deep_extend('force',
                        client.config.settings.Lua, {
                            runtime = {
                                version = 'LuaJIT'
                            },
                            workspace = {
                                checkThirdParty = false,
                                library = {
                                    vim.env.VIMRUNTIME
                                }
                            }
                        })
                end,
                settings = {
                    Lua = {}
                }
            }
        end
    },
}
