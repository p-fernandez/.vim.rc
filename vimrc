" GENERAL "
"""""""""""

" When started as 'evim', evim.vim will already have done these settings
if v:progname =~? "evim"
  finish
endif

set encoding=utf-8
set nocompatible
set nonumber

" Convert tab into spaces
set tabstop=2 shiftwidth=2 expandtab

" Allow backspacing over everything in insert mode
set backspace=indent,eol,start

set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set wildmenu		" display completion matches in a status line
set incsearch		" do incremental searching
set ttimeout		" time out for key codes
set ttimeoutlen=100	" wait up to 100ms after Esc for special key

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine.  By enabling it you can position the cursor, Visually select and scroll with the mouse.
if has('mouse')
  set mouse=a
endif

" Copy to MacOSx clipboard
set clipboard=unnamed

" Pastetoggle
" Code from:
" http://stackoverflow.com/questions/5585129/pasting-code-into-terminal-window-into-vim-on-mac-os-x then https://coderwall.com/p/if9mda
" and then https://github.com/aaronjensen/vimfiles/blob/59a7019b1f2d08c70c28a41ef4e2612470ea0549/plugin/terminaltweaks.vim
" to fix the escape time problem with insert mode.
"
" Docs on bracketed paste mode:
" http://www.xfree86.org/current/ctlseqs.html
" Docs on mapping fast escape codes in vim
" http://vim.wikia.com/wiki/Mapping_fast_keycodes_in_terminal_Vim
if !exists("g:bracketed_paste_tmux_wrap")
  let g:bracketed_paste_tmux_wrap = 1
endif

function! WrapForTmux(s)
  if !g:bracketed_paste_tmux_wrap || !exists('$TMUX')
    return a:s
  endif

  let tmux_start = "\<Esc>Ptmux;"
  let tmux_end = "\<Esc>\\"

  return tmux_start . substitute(a:s, "\<Esc>", "\<Esc>\<Esc>", 'g') . tmux_end
endfunction

let &t_ti .= WrapForTmux("\<Esc>[?2004h")
let &t_te .= WrapForTmux("\<Esc>[?2004l")

function! XTermPasteBegin(ret)
  set pastetoggle=<f29>
  set paste
  return a:ret
endfunction

execute "set <f28>=\<Esc>[200~"
execute "set <f29>=\<Esc>[201~"
map <expr> <f28> XTermPasteBegin("i")
imap <expr> <f28> XTermPasteBegin("")
vmap <expr> <f28> XTermPasteBegin("c")
cmap <f28> <nop>
cmap <f29> <nop>

" Maintain undo history between sessions
if !isdirectory($HOME."/.vim")
  call mkdir($HOME."/.vim", "", 0770)
endif
if !isdirectory($HOME."/.vim/undodir")
    call mkdir($HOME."/.vim/undodir", "", 0700)
endif
set undodir=~/.vim/undodir
set undofile

" Switch syntax highlighting on, when the terminal has colors
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif



" PLUG "
""""""""

" Specify a directory for plugins (for Neovim: ~/.local/share/nvim/plugged)
call plug#begin('~/.vim/plugged')

" Plugins installed
Plug 'will133/vim-dirdiff'
Plug 'pangloss/vim-javascript', { 'for': 'javascript' }
Plug 'mxw/vim-jsx', { 'for': 'javascript' }
Plug 'vim-airline/vim-airline'
Plug 'ap/vim-css-color'
Plug 'fleischie/vim-styled-components', { 'for': 'javascript' }
Plug 'hail2u/vim-css3-syntax'
Plug 'airblade/vim-gitgutter'
Plug 'brooth/far.vim'

" Initialize plugin system
call plug#end()



" PATHOGEN "
""""""""""""

execute pathogen#infect()



" AIRLINE "
"""""""""""

set laststatus=2
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts=1



" SYNTASTIC "
"""""""""""""

set statusline+=%{SyntasticStatuslineFlag()}

" let g:syntastic_debug = 3
let g:syntastic_loc_list_height = 5
let g:syntastic_auto_loc_list = 1 
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 1
let g:syntastic_aggregate_errors = 1
let g:syntastic_enable_balloons = 1
let g:syntastic_stl_format = '[%E{E:%e(#%fe)}%B{,}%W{W:%w(#%fw)}]'
let g:syntastic_error_symbol = '⛔️'
let g:syntastic_style_error_symbol = '🚫'
let g:syntastic_warning_symbol = '⚠️ '
let g:syntastic_style_warning_symbol = '🚸'

highlight link SyntasticErrorSign SignColumn
highlight link SyntasticWarningSign SignColumn
highlight link SyntasticStyleErrorSign SignColumn
highlight link SyntasticStyleWarningSign SignColumn

" JSX
let g:jsx_ext_required = 0

" Javascript
let g:syntastic_javascript_eslint_exe = '$(npm bin)/eslint'
let g:syntastic_javascript_checkers = ['eslint']

" Others checkers
let g:syntastic_typescript_checkers = ['tslint', 'tsc', 'eslint']
let g:syntastic_php_checkers = ['php', 'phpcs', 'phpmd']
let g:syntastic_css_checkers = ['csslint', 'stylelint']
let g:syntastic_scss_checkers = ['csslint', 'stylelint']
let g:syntastic_html_checkers = ['w3']



" COLORSCHEME "
"""""""""""""""

" Set vim to 256 colors
set t_Co=256
colorscheme afterglow



" INDENT "
""""""""""

" set noautoindent
" set nocindent
" set nosmartindent

filetype indent on
set autoindent
