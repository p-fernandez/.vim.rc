" COLORSCHEME "
"""""""""""""""

set t_Co=256
colorscheme afterglow
" Search color highlighting
set hlsearch


" GENERAL "
"""""""""""

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


" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis | wincmd p | diffthis
endif

" Close quick-fix window if it is the last one open
aug QFClose
  au!
  au WinEnter * if winnr('$') == 1 && getbufvar(winbufnr(winnr()), "&buftype") == "quickfix"|q|endif
aug END


" PATHOGEN "
""""""""""""

execute pathogen#infect()


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
Plug 'w0rp/ale'

" Initialize plugin system
call plug#end()


" AIRLINE "
"""""""""""

set laststatus=2
let g:airline_powerline_fonts = 1
let g:airline_skip_empty_sections = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'

hi airline_c ctermfg=white ctermbg=234
hi airline_c_bold term=bold ctermfg=white ctermbg=234
hi airline_x ctermfg=white ctermbg=234
hi airline_x_bold term=bold ctermfg=white ctermbg=234
hi airline_tabfill ctermfg=white ctermbg=234
hi airline_tabhid ctermfg=white ctermbg=234
hi airline_tabhid_right ctermfg=white ctermbg=234
" Integration with ALE
let airline#extensions#ale#error_symbol = ' ✕ -> '
let airline#extensions#ale#warning_symbol = ' ▵ -> '
let airline#extensions#ale#open_lnum_symbol = ' ['
let airline#extensions#ale#close_lnum_symbol = '] '
" Highlighting search
hi Search term=bold ctermbg=22 ctermfg=white
hi Error term=reverse ctermbg=52 ctermfg=white

" ALE "
"""""""""""""

" List of errors open inside Airline extension (bottom) showing up to 3 at the
" same time
let g:ale_open_list = 1
let g:ale_set_quickfix = 0
let g:ale_list_window_size = 3
" Delay the checking
let g:ale_lint_delay = 500
" Left column closed when no errors
let g:ale_sign_column_always = 0
" Highlights
let g:ale_set_highlights = 1
highlight ALEErrorLine ctermbg=52 ctermfg=white
highlight ALEErrorSign ctermbg=52 ctermfg=white
highlight ALEError ctermbg=88 ctermfg=white
highlight ALEWarningLine ctermbg=178 ctermfg=black
highlight ALEWarningSign ctermbg=178 ctermfg=black
highlight ALEWarning ctermbg=220 ctermfg=black
" Signs
let g:ale_sign_error = '✕'
let g:ale_sign_warning = '▵'


" INDENT "
""""""""""

" set noautoindent
" set nocindent
" set nosmartindent

filetype indent on
set autoindent
