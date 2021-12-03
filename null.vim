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
Plug 'nvim-lua/plenary.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'jose-elias-alvarez/null-ls.nvim'
call plug#end()
PlugInstall | quit

lua << EOF
local null_ls = require("null-ls")
null_ls.config {
    debug = true,
    sources = {
        null_ls.builtins.diagnostics.eslint.with({
            only_local = "node_modules/.bin"
        })
    }
}
require("lspconfig")["null-ls"].setup { }
EOF
