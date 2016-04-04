" This must be first, because it changes other options as side effect
set nocompatible
set modeline
let syntastic_python_flake8_args='--ignore=E501'

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
" autocmd FileType html setlocal shiftwidth=2 tabstop=2 softtabstop=2 expandtab
" autocmd FileType htmldjango setlocal shiftwidth=2 tabstop=2 softtabstop=2 expandtab
autocmd FileType html setlocal shiftwidth=4 tabstop=4 softtabstop=4
autocmd FileType htmldjango setlocal shiftwidth=4 tabstop=4 softtabstop=4
" autocmd FileType javascript setlocal shiftwidth=2 tabstop=2 softtabstop=2 expandtab
autocmd FileType javascript setlocal shiftwidth=4 tabstop=4 softtabstop=4
autocmd FileType c setlocal shiftwidth=4 tabstop=4 softtabstop=4
autocmd FileType h setlocal shiftwidth=4 tabstop=4 softtabstop=4

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
:set colorcolumn=80
" :colorscheme vividchalk
:colorscheme PaperColor
" :colorscheme codeschool
" :colorscheme desertEx
" :set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<
:set listchars=tab:>-,trail:~,extends:>,precedes:<
:set list
:let g:ctrlp_max_files=0
:let g:ctrlp_custom_ignore='.git$|\tmp$'

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
