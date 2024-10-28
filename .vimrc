"""""""""""
" OPTIONS "
"""""""""""

set backspace=indent,eol,start " Allow backspacing over everything in insert mode
set clipboard=unnamed " Copy to MacOSx clipboard
set colorcolumn=80
set cursorcolumn
set cursorline
set directory=$HOME/.vim/swp// " No annoying swap files in the projects. This absolute link them to reference them inside said directory.
set encoding=utf8
set fileencoding=utf8
set guicursor=n-c-v:block-nCursor
set hidden " keep buffers open
set history=50 " keep 50 lines of command line history
set hlsearch " Hilight searching
set incsearch	" do incremental searching
set infercase " Autocomplete in Vim
set lazyredraw " Performance because of ALE
set nocompatible
set noerrorbells
set noshowcmd		" display incomplete commands
set nospell " Disables spelling checking
set nowrap
set number " Sets number of the line.
set path+=** " Makes search find recursive
set ruler " show the cursor position all the time
set scrolloff=8
set signcolumn=yes
set smartindent
set softtabstop=2 shiftwidth=2 expandtab " Convert tab into spaces
set t_Co=256
set termencoding=utf-8
set title " Turn on setting the title.
set ttimeout		" time out for key codes
set ttimeoutlen=100	" wait up to 100ms after Esc for special key
set wildignore+=**/node_modules/** " folders to ignore when using :find
set wildmode=full wildmenu		" display completion matches in a status line

" https://youtu.be/XA2WjJbmmoM?t=368
syntax enable
filetype plugin on


"""""""""""
" GENERAL "
"""""""""""

" Relative numbers only in Normal Mode.
augroup toggle_relative_number
autocmd InsertEnter * :setlocal norelativenumber
autocmd InsertLeave * :setlocal relativenumber
 
" Create tags
command! MakeTags !ctags -R .

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
set noswapfile
set nobackup
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

" Source the vimrc file after saving it
autocmd! BufWritePost $MYVIMRC source $MYVIMRC | echom "Reloaded $MYVIMRC"

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Improve Vim's Command Line Autocompletion
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set completeopt=menuone,noinsert,longest,preview

set wildignore+=*.o,*.obj,*.pyc,*.pyo,*.DS_STORE,*.db,*.swc,*.rbc " Binary objects
set wildignore+=__pycache__
set wildignore+=*/tmp/*,*.so,*.swp,*.zip                    " Temp files
set wildignore+=vendor/rails/**,vendor/gems/**              " Rails stuff
set wildignore+=*.jar,*.class,*.log,*.gz                    " Java bin files
set wildignore+=.git,*.rbc,*.svn
set wildignore+=*.jpeg,*.jpg,*.jpeg*,*.png,*.gif            " Media files
set wildignore+=*/log/*,*/.bundle/*,*/bin/*,*/tmp/*,*/build/*,*/dist/*,*/node_modules/*
set wildignore+=*/.sass-cache/*


""""""""
" PLUG "
""""""""

" Specify a directory for plugins (for Neovim: ~/.local/share/nvim/plugged)
call plug#begin('~/.vim/plugged')

" Plugins installed
Plug 'ryanoasis/vim-devicons'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'will133/vim-dirdiff'
Plug 'dense-analysis/ale'
Plug 'ap/vim-css-color'
Plug 'styled-components/vim-styled-components', { 'branch': 'main', 'for': 'javascript' }
Plug 'airblade/vim-gitgutter'
Plug 'elzr/vim-json'
Plug 'p-fernandez/vim-jdaddy'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'Kuniwak/vint'
Plug 'cespare/vim-toml'
Plug 'stedolan/jq'
Plug 'fatih/vim-go'
Plug 'othree/html5.vim'
Plug 'evanleck/vim-svelte', {'branch': 'main'}
Plug 'dotenv-linter/dotenv-linter'
Plug 'OlegGulevskyy/better-ts-errors.nvim'

" Delete soon
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'yaegassy/coc-volar', { 'do': 'yarn install --frozen-lockfile' }
Plug 'yaegassy/coc-volar-tools', { 'do': 'yarn install --frozen-lockfile' }

" Styles
Plug 'morhetz/gruvbox'
Plug 'danilo-augusto/vim-afterglow'
Plug 'tyrannicaltoucan/vim-deep-space'
Plug 'whatyouhide/vim-gotham'
Plug 'arcticicestudio/nord-vim'
Plug 'jacoborus/tender.vim'
Plug 'sonph/onehalf', { 'rtp': 'vim' }


" Initialize plugin system
call plug#end()


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


"""""""""""""""
" COLORSCHEME "
"""""""""""""""

colorscheme gotham256

" Background highlight
highlight Normal guibg=NONE


"""""""""""
" AIRLINE "
"""""""""""
set laststatus=2
let g:airline_powerline_fonts=1
let g:airline_skip_empty_sections=1
let g:airline_statusline_ontop=1
let g:airline_theme = 'onehalfdark'
let g:airline#extensions#ale#enabled=1
let g:airline#extensions#tabline#enabled=1
let g:airline#extensions#tabline#formatter='unique_tail'

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


"""""""""
" ICONS "
"""""""""
if exists("g:loaded_webdevicons")
	call webdevicons#refresh()
endif
let g:webdevicons_enable = 1
let g:webdevicons_enable_airline_tabline = 1
let g:webdevicons_enable_airline_statusline = 1


"""""""
" ALE "
"""""""

let g:ale_history_log_output = 1
" List of errors open inside Airline extension (bottom) showing up to 3 at the
" same time
set omnifunc=ale#completion#OmniFunc
let g:ale_completion_enabled = 1
let g:ale_completion_autoimport = 1
let g:ale_open_list = 1
" Run only linters you've explicitly configured. 0 = Disabled.
let g:ale_linters_explicit = 0
let g:ale_set_quickfix = 0
let g:ale_list_window_size = 5
let g:ale_list_vertical = 0 
" Delay the checking
let g:ale_lint_delay = 500
" Left column closed when no errors
let g:ale_sign_column_always = 0
let g:ale_fix_on_save = 1
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
let g:ale_sign_style_error = '※'
let g:ale_sign_warning = '▲'
let g:ale_sign_style_warning = '⁂'

" To enable combination with CoC LSP
" let g:ale_disable_lsp = 1

" Vue
let g:vue_disable_pre_processors = 1

" Svelte
let g:svelte_preprocessors = ['typescript']

" Go
let g:go_def_mode='gopls'
let g:go_info_mode='gopls'

let g:ale_php_phpcs_standard= 'PSR12'
let g:ale_fixers = {}
let g:ale_linters = {}
let g:ale_linters_ignore = {}
let g:ale_fixers['css'] = ['stylelint']
let g:ale_fixers['go'] = ['gofmt', 'gopls']
let g:ale_fixers['graphql'] = ['gqlint']
let g:ale_fixers['html'] = ['prettier']
let g:ale_fixers['javascript'] = ['eslint', 'prettier']
let g:ale_fixers['json'] = ['jq']
let g:ale_fixers['jsx'] = ['prettier']
let g:ale_fixers['php'] = ['phpcbf', 'phpstan']
let g:ale_fixers['rust'] = ['rustfmt', 'rls']
let g:ale_fixers['svelte'] = ['prettier']
let g:ale_fixers['typescript'] = ['prettier']
let g:ale_fixers['typescriptreact'] = ['prettier']
let g:ale_fixers['vue'] = ['volar', 'eslint']
let g:ale_fixers['yaml'] = ['yamlfix']
let g:ale_fixers['yml'] = ['yamlfix']
let g:ale_linters['css'] = ['stylelint', 'eslint']
let g:ale_linters['go'] = ['gobuild', 'golangserver', 'gofmt', 'gopls', 'govert']
let g:ale_linters['graphql'] = ['eslint', 'gqlint']
let g:ale_linters['html'] = ['tidy', 'stylelint']
let g:ale_linters['javascript'] = ['eslint']
let g:ale_linters['json'] = ['jq']
let g:ale_linters['jsx'] = ['eslint']
let g:ale_linters['rust'] = ['rustfmt', 'rls']
let g:ale_linters['sh'] = ['']
let g:ale_linters['svelte'] = ['svelteserver', 'stylelint', 'eslint']
let g:ale_linters['vim'] = ['vint']
let g:ale_linters['vue'] = ['volar', 'eslint']
let g:ale_linters['yaml'] = ['circleci', 'spectral', 'yamllint']
let g:ale_linters['yml'] = ['circleci', 'spectral', 'yamllint']
let g:ale_linters_ignore['javascript'] = ['flow']


" COC
" https://raw.githubusercontent.com/neoclide/coc.nvim/master/doc/coc-example-config.vim

" May need for Vim (not Neovim) since coc.nvim calculates byte offset by count
" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" Having longer updatetime (default is 4000 ms = 4s) leads to noticeable
" delays and poor user experience
set updatetime=300

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate
" NOTE: There's always complete item selected by default, you may want to enable
" no select by `"suggest.noselect": true` in your configuration file
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s)
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying code actions to the selected code block
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying code actions at the cursor position
nmap <leader>ac  <Plug>(coc-codeaction-cursor)
" Remap keys for apply code actions affect whole buffer
nmap <leader>as  <Plug>(coc-codeaction-source)
" Apply the most preferred quickfix action to fix diagnostic on the current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Remap keys for applying refactor code actions
nmap <silent> <leader>re <Plug>(coc-codeaction-refactor)
xmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)
nmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)

" Run the Code Lens action on the current line
nmap <leader>cl  <Plug>(coc-codelens-action)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> to scroll float windows/popups
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges
" Requires 'textDocument/selectionRange' support of language server
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>
