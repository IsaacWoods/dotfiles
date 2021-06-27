set nocompatible
filetype off

let mapleader=" "

" Enable relative line numbers
set number
set relativenumber

" Set tabbing up correctly
set tabstop=4
set softtabstop=0
set expandtab
set shiftwidth=4
set smarttab

" Disable the arrow keys for navigation in normal mode
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

" Easier split navigation
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
set splitbelow
set splitright

" Disable modeline support as a workaround for that vulnerability
set modelines=0
set nomodeline

" Tell vim to linewrap at 115 characters (we're not on an 80-line terminal anymore, Grampa)
set textwidth=115

" Stop Rust language files from being a pain (setting textwidth to 99)
let g:rust_recommended_style=0

" Set up VimPlug
call plug#begin('~/.local/share/nvim/plugged')

"--- XXX: Call :PlugInstall after adding to this list ---
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
Plug 'sheerun/vim-polyglot'
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'itchyny/lightline.vim'
Plug 'tpope/vim-commentary'
Plug 'Raimondi/delimitMate'

Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'tomtom/tlib_vim'
Plug 'garbas/vim-snipmate'

Plug 'rust-lang/rust.vim'

Plug 'neoclide/coc.nvim', {'branch': 'release'}
"--- ---

call plug#end()

" Configure delimitMate
let g:delimitMate_expand_cr=1
au FileType rust let b:delimitMate_quotes = "\" `" "DelimitMate doesn't play nicely with lifetimes. See rust.vim#114

" Set up Language Server plugins
" if executable('rls')
"     au User lsp_setup call lsp#register_server({
"         \ 'name': 'rls',
"         \ 'cmd': {server_info->['rustup', 'run', 'nightly', 'rls']},
"         \ 'whitelist': ['rust'],
"         \ })
" endif
" let g:lsp_diagnostics_enabled = 0

" Run rustfmt on save
let g:rustfmt_autosave = 1

" Configure LightLine
let g:lightline =
    \{
        \'colorscheme': 'wombat',
    \}

function! LightLineReadonly()
    return &readonly && &filetype !~# '\v(help|nerdtree)' ? 'RO' : ''
endfunction

" Configure asyncomplete
let g:asyncomplete_remove_duplicates=1
set completeopt-=preview

" Vim-markdown helpfully chooses to randomly fold stuff, so disable that
let g:vim_markdown_folding_disabled=1

" Change colors used for Git diffs for filetype 'gitcommit' to make them actually readable
hi diffAdded        cterm=bold ctermfg=DarkGreen
hi diffRemoved      cterm=bold ctermfg=DarkRed
hi diffFile         cterm=NONE ctermfg=DarkBlue
hi diffIndexLine    cterm=NONE ctermfg=DarkBlue

" Set up NERDtree
map <leader>k :NERDTreeToggle<CR>
let NERDTreeIgnore=['\.o$']

" Use the non-legacy SnipMate parser
let g:snipMate = { 'snippet_version': 1 }

"Custom filetypes
autocmd BufRead,BufNewFile *.asl setlocal filetype=asl
autocmd BufRead,BufNewFile *.s setlocal filetype=asm        "This suddenly started being needed. Idk why.

if has('nvim')
    " Set up terminal splits
    " (Require two Escs to exit Terminal mode (allows nesting vim instances))
    tnoremap <Esc><Esc> <C-\><C-n>
    map <leader>l :vsp term://bash<CR>i
  
    " Allow scrolling using the mouse, but unmap the left button to prevent cursor-positioning
    set mouse=a
    nmap <LeftMouse> <nop>
    imap <LeftMouse> <nop>
    vmap <LeftMouse> <nop>
    tmap <LeftMouse> <nop>
    nmap <2-LeftMouse> <nop>
    imap <2-LeftMouse> <nop>
    vmap <2-LeftMouse> <nop>
    tmap <2-LeftMouse> <nop>
  
    " Clear highlighting when Esc pressed
    nnoremap <silent> <Esc> :noh<CR><Esc>

    " Make <A-r> paste a register into a terminal buffer
    tnoremap <expr> <A-r> '<C-\><C-N>"'.nr2char(getchar()).'pi'
endif

if exists('$WAYLAND_DISPLAY')
    " GTK3 on Wayland puts stuff in the clipboard with a carriage return at the end of each line for some reason.
    " We strip it off here.
    let g:clipboard = {
          \   'name': 'wayland-strip-carriage',
          \   'copy': {
          \      '+': 'wl-copy --foreground --type text/plain',
          \      '*': 'wl-copy --foreground --type text/plain --primary',
          \    },
          \   'paste': {
          \      '+': {-> systemlist('wl-paste --no-newline | sed -e "s/\r$//"')},
          \      '*': {-> systemlist('wl-paste --no-newline --primary | sed -e "s/\r$//"')},
          \   },
          \   'cache_enabled': 1,
          \ }
endif
