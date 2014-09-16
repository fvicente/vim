" This must be first, because it changes other options as side effect
set nocompatible

" turn filetype detection off and, even if it's not strictly
" necessary, disable loading of indent scripts and filetype plugins
filetype off
filetype plugin indent off

" pathogen runntime injection and help indexing
call pathogen#infect()
call pathogen#helptags()

" turn filetype detection, indent scripts and filetype plugins on
" and syntax highlighting too
filetype plugin indent on
syntax on

autocmd FileType html,htmldjango,jinjahtml,eruby,mako let b:closetag_html_style=1
autocmd FileType html,xhtml,xml,htmldjango,jinjahtml,eruby,mako source ~/.vim/bundle/closetag/plugin/closetag.vim
autocmd FileType python setlocal tabstop=8 shiftwidth=4 softtabstop=4 expandtab

" tab length exceptions on some file types
autocmd FileType html setlocal shiftwidth=2 tabstop=2 softtabstop=2 expandtab
autocmd FileType htmldjango setlocal shiftwidth=2 tabstop=2 softtabstop=2 expandtab
autocmd FileType javascript setlocal shiftwidth=2 tabstop=2 softtabstop=2 expandtab

highlight link SyntasticError SpellBad
highlight link SyntasticWarning SpellCap

" Syntastic
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_enable_signs = 1
let g:syntastic_auto_loc_list = 2
let g:syntastic_cpp_check_header = 1
let g:syntastic_cpp_no_include_search = 0
let g:syntastic_javascript_checkers = ["jshint"]
let g:syntastic_html_jshint_conf = "$HOME/.jshintrc"
let g:syntastic_coffeescript_checkers = ["coffeelint"]
let g:syntastic_cpp_compiler = "g++"
let g:syntastic_java_checkers = []
" if has("unix")
"   let g:syntastic_error_symbol = "█"
"   let g:syntastic_style_error_symbol = ">"
"   let g:syntastic_warning_symbol = "█"
"   let g:syntastic_style_warning_symbol = ">"
" else
"   let g:syntastic_error_symbol = "X"
"   let g:syntastic_style_error_symbol = ">"
"   let g:syntastic_warning_symbol = "!"
"   let g:syntastic_style_warning_symbol = ">"
" endif

:set laststatus=2
:set encoding=utf-8

if filereadable($HOME."/Library/Python/2.7/lib/python/site-packages/powerline/bindings/vim/plugin/powerline.vim")
source ~/Library/Python/2.7/lib/python/site-packages/powerline/bindings/vim/plugin/powerline.vim
set guifont=Source\ Code\ Pro\ for\ Powerline:h12
let g:airline_powerline_fonts=1
else
if filereadable("/Library/Python/2.7/site-packages/powerline/bindings/vim/plugin/powerline.vim")
source /Library/Python/2.7/site-packages/powerline/bindings/vim/plugin/powerline.vim
set guifont=Source\ Code\ Pro\ for\ Powerline:h12
let g:airline_powerline_fonts=1
endif
endif

