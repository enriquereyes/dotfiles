syntax on
set incsearch
set hlsearch
set autoindent
set shiftwidth=2
set softtabstop=2
set expandtab
set number
set autowrite
set t_Co=256
filetype plugin indent on
set encoding=utf-8
set fileencoding=utf-8
let g:netrw_altv = 1
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_winsize = 80

" Colors
if has('gui_running')
    colorscheme codeschool
else
    colorscheme codedark
endif

" Install vim-plug if not found
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'OmniSharp/omnisharp-vim'
Plug 'fsharp/vim-fsharp', {
      \ 'for': 'fsharp',
      \ 'do':  'make fsautocomplete',
      \}

" On-demand loading
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }

" Initialize plugin system
call plug#end()

let g:go_version_warning = 0

" NERDTree
set autochdir
let NERDTreeChDirMode=2
nnoremap <leader>n :NERDTree .<CR>

" OmniSharp: {{{
let g:OmniSharp_popup_position = 'peek'
if has('nvim')
  let g:OmniSharp_popup_options = {
  \ 'winhl': 'Normal:NormalFloat'
  \}
else
  let g:OmniSharp_popup_options = {
  \ 'highlight': 'Normal',
  \ 'padding': [0, 0, 0, 0],
  \ 'border': [1]
  \}
endif
let g:OmniSharp_popup_mappings = {
\ 'sigNext': '<C-n>',
\ 'sigPrev': '<C-p>',
\ 'pageDown': ['<C-f>', '<PageDown>'],
\ 'pageUp': ['<C-b>', '<PageUp>']
\}

"if s:using_snippets
"  let g:OmniSharp_want_snippet = 1
"endif

let g:OmniSharp_highlight_groups = {
\ 'ExcludedCode': 'NonText'
\}

"let g:OmniSharp_server_use_mono = 1
let g:OmniSharp_server_use_net6 = 1
" }}}

" Vim FZF integration, used as OmniSharp selector
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

"Selector UI
let g:OmniSharp_selector_ui = 'fzf'

" Code Snippets
Plug 'SirVer/ultisnips'

"Go
let g:go_def_mode='gopls'
let g:go_info_mode='gopls'
let g:go_auto_type_info = 1           " Automatically get signature/type info for object under cursor
let g:go_gopls_matcher = 'fuzzy'
autocmd FileType go nmap <leader>b  <Plug>(go-build)
autocmd FileType go nmap <leader>r  <Plug>(go-run)

" Autocomplete
"au filetype go inoremap <buffer> <Nul> <C-x><C-o>

" . autocomplete
" Go
au filetype go inoremap <buffer> . .<C-x><C-o><C-p>
" C#
au filetype cs inoremap <buffer> . .<C-x><C-o<C-p>>

" Tab autocomplete
" Go
au filetype go inoremap <expr> <Tab> pumvisible() ? '<C-n>' :
\ getline('.')[col('.')-2] =~# '[[:alnum:].-_#$]' ? '<C-x><C-o><C-p>' : '<Tab>'
" C#
au filetype cs inoremap <expr> <Tab> pumvisible() ? '<C-n>' :
\ getline('.')[col('.')-2] =~# '[[:alnum:].-_#$]' ? '<C-x><C-o><C-p>' : '<Tab>'
