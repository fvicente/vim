" This must be first, because it changes other options as side effect
set nocompatible
set modeline

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

" autocmd FileType html,htmldjango,jinjahtml,eruby,mako let b:closetag_html_style=1
" autocmd FileType html,xhtml,xml,htmldjango,jinjahtml,eruby,mako source ~/.vim/bundle/closetag/plugin/closetag.vim
autocmd FileType python setlocal tabstop=8 shiftwidth=4 softtabstop=4 expandtab

" tab length exceptions on some file types
" autocmd FileType html setlocal shiftwidth=2 tabstop=2 softtabstop=2 expandtab
" autocmd FileType htmldjango setlocal shiftwidth=2 tabstop=2 softtabstop=2 expandtab
autocmd FileType html setlocal shiftwidth=4 tabstop=4 softtabstop=4
autocmd FileType htmldjango setlocal shiftwidth=4 tabstop=4 softtabstop=4
autocmd FileType javascript setlocal shiftwidth=2 tabstop=2 softtabstop=2 expandtab
" autocmd FileType javascript setlocal shiftwidth=4 tabstop=4 softtabstop=4
autocmd FileType c setlocal shiftwidth=4 tabstop=4 softtabstop=4
autocmd FileType h setlocal shiftwidth=4 tabstop=4 softtabstop=4

set backspace=indent,eol,start

let g:javascript_plugin_jsdoc = 1
let g:javascript_plugin_ngdoc = 1
let g:javascript_plugin_flow = 1

" Highlight ES6 template strings
hi link javaScriptTemplateDelim String
hi link javaScriptTemplateVar Text
hi link javaScriptTemplateString String

" ALE
let g:ale_python_flake8_args="--ignore=E501"
let g:ale_linters = {
\   'javascript': ['eslint'],
\}
" '❌'
" '⛔'
" '⁉️'
" '⚠️'
let g:ale_sign_error = '🐞'
let g:ale_sign_warning = '💩'
highlight clear ALEErrorSign
highlight clear ALEWarningSign

" jsx
let g:jsx_ext_required = 0

:set laststatus=2
:set encoding=utf-8

" Airline settings to display ALE errors
let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#ale#error_symbol = 'E:'
let g:airline#extensions#ale#warning_symbol = 'W:'

if filereadable($HOME."/Library/Python/2.7/lib/python/site-packages/powerline/bindings/vim/plugin/powerline.vim")
	source ~/Library/Python/2.7/lib/python/site-packages/powerline/bindings/vim/plugin/powerline.vim
	set guifont=Source\ Code\ Pro\ for\ Powerline:h12
	let g:airline_powerline_fonts=1
else
	if filereadable("/Library/Python/2.7/site-packages/powerline/bindings/vim/plugin/powerline.vim")
		source /Library/Python/2.7/site-packages/powerline/bindings/vim/plugin/powerline.vim
		set guifont=Source\ Code\ Pro\ for\ Powerline:h12
		let g:airline_powerline_fonts=1
	else
 		if filereadable("/usr/local/lib/python2.7/dist-packages/powerline/bindings/vim/plugin/powerline.vim")
			source /usr/local/lib/python2.7/dist-packages/powerline/bindings/vim/plugin/powerline.vim
			set guifont=Source\ Code\ Pro\ for\ Powerline:h12
			let g:airline_powerline_fonts=1
		endif
	endif
endif

:set colorcolumn=+1        " highlight column after 'textwidth'
:set colorcolumn=+1,+2,+3  " highlight three columns after 'textwidth'
:highlight ColorColumn ctermbg=lightgrey guibg=lightgrey
:set colorcolumn=120
" :colorscheme vividchalk
:colorscheme PaperColor
" :colorscheme codeschool
" :colorscheme desertEx
" :set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<
:set listchars=tab:>-,trail:~,extends:>,precedes:<
:set list
:let g:ctrlp_max_files = 0
let g:ctrlp_custom_ignore = '\v[\/](node_modules|target|dist)|(\.(swp|ico|git|svn|DS_Store))$'

if has("mouse")
	set mouse=a
endif

" XML formatter
function! DoFormatXML() range
	" Save the file type
	let l:origft = &ft

	" Clean the file type
	set ft=

	" Add fake initial tag (so we can process multiple top-level elements)
	exe ":let l:beforeFirstLine=" . a:firstline . "-1"
	if l:beforeFirstLine < 0
		let l:beforeFirstLine=0
	endif
	exe a:lastline . "put ='</PrettyXML>'"
	exe l:beforeFirstLine . "put ='<PrettyXML>'"
	exe ":let l:newLastLine=" . a:lastline . "+2"
	if l:newLastLine > line('$')
		let l:newLastLine=line('$')
	endif

	" Remove XML header
	exe ":" . a:firstline . "," . a:lastline . "s/<\?xml\\_.*\?>\\_s*//e"

	" Recalculate last line of the edited code
	let l:newLastLine=search('</PrettyXML>')

	" Execute external formatter
	exe ":silent " . a:firstline . "," . l:newLastLine . "!xmllint --noblanks --format --recover -"

	" Recalculate first and last lines of the edited code
	let l:newFirstLine=search('<PrettyXML>')
	let l:newLastLine=search('</PrettyXML>')
	
	" Get inner range
	let l:innerFirstLine=l:newFirstLine+1
	let l:innerLastLine=l:newLastLine-1

	" Remove extra unnecessary indentation
	exe ":silent " . l:innerFirstLine . "," . l:innerLastLine "s/^  //e"

	" Remove fake tag
	exe l:newLastLine . "d"
	exe l:newFirstLine . "d"

	" Put the cursor at the first line of the edited code
	exe ":" . l:newFirstLine

	" Restore the file type
	exe "set ft=" . l:origft
endfunction
command! -range=% FormatXML <line1>,<line2>call DoFormatXML()

nmap <silent> <leader>x :%FormatXML<CR>
vmap <silent> <leader>x :FormatXML<CR>

" set backup dir to a temp dir
set backupdir=~/tmp/vim/bkp//
set directory=~/tmp/vim/swp//
set undodir=~/tmp/vim/undo//
