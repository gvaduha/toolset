set runtimepath+=/opt/vim_runtime

source /opt/vim_runtime/vimrcs/basic.vim
source /opt/vim_runtime/vimrcs/filetypes.vim
source /opt/vim_runtime/vimrcs/plugins_config.vim
source /opt/vim_runtime/vimrcs/extended.vim

try
source /opt/vim_runtime/my_configs.vim
catch
endtry

" https://github.com/mike-hearn/base16-vim-lightline
let g:lightline = {'colorscheme': 'base16_espresso'}
