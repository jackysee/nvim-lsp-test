if has('vim_starting')
  set encoding=utf-8
endif
scriptencoding utf-8

if &compatible
  set nocompatible
endif

let s:plug_dir = expand('/tmp/plugged/vim-plug')
if !filereadable(s:plug_dir .. '/plug.vim')
  execute printf('!curl -fLo %s/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim', s:plug_dir)
end

execute 'set runtimepath+=' . s:plug_dir
call plug#begin(s:plug_dir)
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/nvim-lsp-installer'
call plug#end()
PlugInstall | quit

lua << EOF
local lsp_installer = require("nvim-lsp-installer")
lsp_installer.settings({
    install_root_dir = '/tmp/lsp_servers'
});

local lsp_installer_servers = require'nvim-lsp-installer.servers'
local server_available, requested_server = lsp_installer_servers.get_server("efm")
if server_available then
    requested_server:on_ready(function ()
        local eslint = {
            -- lintCommand = "eslint_d -f unix --stdin --stdin-filename ${INPUT}",
            lintCommand = "npx eslint -f unix --stdin --stdin-filename ${INPUT}",
            lintStdin = true,
            lintFormats = {"%f:%l:%c: %m"},
            lintIgnoreExitCode = true
        }
        local opts = {
            filetypes = { "javascript"},
            init_options = { documentFormatting = false },
            root_dir = require'lspconfig.util'.root_pattern('package.json', '.eslintrc.js'),
            settings = {
                rootMarkers = { "package.json" , ".eslintrc.js"},
                languages = {
                    javascript = { eslint }
                }
            }
        } 
        requested_server:setup(opts)
    end)
    if not requested_server:is_installed() then
        -- Queue the server to be installed
        requested_server:install()
    end
end

EOF
