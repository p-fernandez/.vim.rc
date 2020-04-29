"""""""""""""""
" COLORSCHEME "
"""""""""""""""

set t_Co=256
colorscheme afterglow


"""""""""""
" OPTIONS "
"""""""""""

set autoindent " Carry over indenting from previous line
set backspace=indent,eol,start " Allow backspacing over everything in insert mode
set clipboard=unnamed " Copy to MacOSx clipboard
set cursorline
set encoding=utf8
set history=10 " keep 50 lines of command line history
set hlsearch " Hilight searching
set incsearch	" do incremental searching
set lazyredraw " Performance because of ALE
set linebreak " Break long lines by word, not char
set nocompatible
set nospell " Disables spelling checking
set number " Sets number of the line.
set relativenumber " Combined with set number shows the relative position of
" other lines respect cursor current one
set ruler " show the cursor position all the time
set showcmd		" display incomplete commands
set title " Turn on setting the title.
set tabstop=2 shiftwidth=2 expandtab " Convert tab into spaces
set ttimeout		" time out for key codes
set ttimeoutlen=100	" wait up to 100ms after Esc for special key
set wildmenu		" display completion matches in a status line


"""""""""""
" GENERAL "
"""""""""""

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine.  By enabling it you can position the cursor, Visually select and scroll with the mouse.
if has('mouse')
  set mouse=a
endif


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

" Modify readonly files from Vim
cnoremap w!! w !sudo tee > /dev/null %

" Update .vimrc config on the fly after saving to the current window
augroup myvimrc
    au!
    au BufWritePost .vimrc,_vimrc,vimrc,.gvimrc,_gvimrc,gvimrc so $MYVIMRC | if has('gui_running') && filereadable($MYGVIMRC) | so $MYGVIMRC | endif
augroup END


""""""""""""
" PATHOGEN "
""""""""""""

execute pathogen#infect()


""""""""
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
Plug 'styled-components/vim-styled-components', { 'branch': 'main', 'for': 'javascript' }
Plug 'hail2u/vim-css3-syntax'
Plug 'airblade/vim-gitgutter'
Plug 'w0rp/ale'
Plug 'elzr/vim-json'
Plug 'p-fernandez/vim-jdaddy'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'Kuniwak/vint'

" Initialize plugin system
call plug#end()


"""""""""""
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


"""""""
" ALE "
"""""""

" List of errors open inside Airline extension (bottom) showing up to 3 at the
" same time
let g:ale_completion_enabled = 1
let g:ale_open_list = 1
let g:ale_set_quickfix = 0
let g:ale_list_window_size = 100
let g:ale_list_vertical = 1 
" Delay the checking
let g:ale_lint_delay = 500
" Left column closed when no errors
let g:ale_sign_column_always = 0
" Highlights
let g:ale_set_highlights = 1
highlight ALEErrorLine ctermbg=1 ctermfg=white
highlight ALEErrorSign ctermfg=1
highlight ALEError ctermbg=52 ctermfg=white
highlight ALEWarningLine ctermbg=220 ctermfg=black
highlight ALEWarningSign ctermfg=220
highlight ALEWarning ctermbg=178 ctermfg=black
" Signs
let g:ale_sign_error = '✕'
let g:ale_sign_warning = '▵'

let g:ale_php_phpcs_standard= 'PSR12'
let g:ale_fixers = {}
let g:ale_fixers['javascript'] = ['prettier']
let g:ale_fixers['json'] = ['jsonlint']
let g:ale_fixers['css'] = ['prettier']
let g:ale_fixers['html'] = ['prettier']
let g:ale_fixers['jsx'] = ['prettier']
let g:ale_fixers['php'] = ['phpcbf', 'phpstan']
let g:ale_fixers['sh'] = ['shellcheck']
let g:ale_fixers['vim'] = ['vint']
let g:ale_fixers['yaml'] = ['swaglint']
let g:ale_fixers['yml'] = ['swaglint']
let g:ale_fix_on_save = 0


""""""""""""""
" GIT-GUTTER "
""""""""""""""

if exists('&signcolumn')  " Vim 7.4.2201
  set signcolumn=yes
else
  let g:gitgutter_sign_column_always = 1
endif

" GitGutter styling to use · instead of +/-
let g:gitgutter_sign_added = '●'
let g:gitgutter_sign_modified = '●'
let g:gitgutter_sign_removed = '●'
let g:gitgutter_sign_removed_first_line = '●'
let g:gitgutter_sign_modified_removed = '●'

let g:gitgutter_override_sign_column_highlight = 0
"highlight clear SignColumn
highlight GitGutterAdd guifg=#008000 ctermfg=2
highlight GitGutterChange guifg=#bbbb00 ctermfg=3
highlight GitGutterChangeDelete guifg=#800000 ctermfg=1
highlight GitGutterDelete guifg=#800000 ctermfg=1

""""""""""""
" VIM-JSON "
""""""""""""

" Disable fancy concealing of attribute quotes.
let g:vim_json_syntax_conceal = 0


""""""""""""""
" VIM-JDADDY "
""""""""""""""

function! JsonParse ()
  call feedkeys("gqaj")  
endfunction

command! JsonParse call JsonParse()

function! JsonStringify ()
  call feedkeys("gsj")  
endfunction

command! JsonStringify call JsonStringify()
