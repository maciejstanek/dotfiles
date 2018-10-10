set shortmess=I
set number
set expandtab
set shiftwidth=2
set autoindent
set smartindent
set ruler
set nowrap
set tabstop=2
set softtabstop=0
set expandtab
set shiftwidth=2
set smarttab
set guitablabel=%t\ %M
set showbreak=\ ...
set cursorline
set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<
set sm
set ls=2
syntax enable 
autocmd FileType diff map <F3> :next<CR>
autocmd FileType diff map <S-F3> :prev<CR>
autocmd FileType tex set wrap
autocmd FileType tex setlocal spell spelllang=en,pl

"autocmd BufNewFile,BufRead *.py set tabstop=2 noexpandtab shiftwidth=2 softtabstop=2 foldmethod=indent foldlevel=99
autocmd BufNewFile,BufRead *.py set tabstop=4 expandtab shiftwidth=4 softtabstop=4 foldmethod=indent
"autocmd BufNewFile,BufRead *.py set tabstop=2 expandtab shiftwidth=2 softtabstop=2 foldmethod=indent
autocmd BufNewFile,BufRead *.tsv set tabstop=12 noexpandtab shiftwidth=12 softtabstop=12
autocmd BufNewFile,BufRead *.TSV set tabstop=12 noexpandtab shiftwidth=12 softtabstop=12
autocmd BufNewFile,BufRead *.cpp set foldmethod=indent foldlevel=99
autocmd BufNewFile,BufRead *.cxx set foldmethod=indent foldlevel=99
autocmd BufNewFile,BufRead *.c set foldmethod=indent foldlevel=99
autocmd BufNewFile,BufRead *.hpp set foldmethod=indent foldlevel=99
autocmd BufNewFile,BufRead *.hxx set foldmethod=indent foldlevel=99
autocmd BufNewFile,BufRead *.h set foldmethod=indent foldlevel=99
set bs=2
set hlsearch
syntax on
filetype on

function! TestCurrentFile()
  let CurrentClassName = expand('%:t:r')
  if (CurrentClassName =~ "_test")
    let CurrentTestName = CurrentClassName
  else
    let CurrentTestName = CurrentClassName . "_test"
  endif
  let GTestFilter = "--gtest_filter=" . CurrentTestName . "*"
  let TestExecutableDirectory = "build/tests"
  let TestExecutable = "mfce_unit_tests"
  let TestCommand = "(cd " . TestExecutableDirectory . " && ./" . TestExecutable . " " . GTestFilter . ")"
  execute "!" . TestCommand
endfunction

setlocal spell spelllang=en_us
set nospell

au BufNewFile,BufRead *.launch set filetype=xml
au BufNewFile,BufRead *.do set filetype=tcl

map <F1> <nop>
map <F1><F1> :set list! list?<CR>
map <F1><F2> :set number! number?<CR>
map <F1><F3> :set wrap! wrap?<CR>
map <F1><F4> :set spell! spell?<CR>
map <F2><F2> :bd<CR>
map <F4> :set foldmethod=marker foldmethod?<CR>
map <F5><F4> :!cd build && cmake ..<CR>
map <F5><F5> :!cd build && cmake --build .<CR>
map <F5><F6> :!cd build && ctest<CR>
map <F5><F7> :call TestCurrentFile()<CR>
map <F5><F8> :!cd build && ctest -VV<CR>
" map <F5><F8> :!cd meta && ./clang-format.sh<CR>
map <F6> :set syn=sh<CR>
map <F8> :set syn=verilog<CR>
map <F9> :set syn=cpp<CR>
map <F10> :set syn=tcl<CR>
map <F11> :set syn=json<CR>

if !filereadable(expand("~/.vim/autoload/plug.vim"))
  echoe "Missing 'plug.vim'. Attempting to download it."
  echom system("curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim")
  if v:shell_error
    echoe "Executing 'curl' failed. Is 'curl' installed?"
  else
    echom "Successfully downloaded 'plug.vim'."
  endif
endif

call plug#begin('~/.vim/plugged')
Plug 'Shougo/neocomplete.vim'
Plug 'easymotion/vim-easymotion'
Plug 'elzr/vim-json'
Plug 'itchyny/lightline.vim'
Plug 'nanotech/jellybeans.vim'
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'pboettch/vim-cmake-syntax'
Plug 'scrooloose/nerdtree'
Plug 'sickill/vim-monokai'
Plug 'sirtaj/vim-openscad'
Plug 'taku-o/vim-toggle'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'vim-scripts/ifdef-highlighting'
" Plug 'Xuyuanp/nerdtree-git-plugin'
" Plug 'chrisbra/Colorizer'
call plug#end()

colorscheme jellybeans
set colorcolumn=80,100,120
set t_Co=256
highlight Visual cterm=reverse ctermbg=NONE
highlight ColorColumn ctermbg=234 guibg=#1c1c1c

let g:deoplete#enable_at_startup = 1
let g:acp_enableAtStartup = 0
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_smart_case = 1
let g:neocomplete#sources#syntax#min_keyword_length = 3
inoremap <expr><C-g> neocomplete#undo_completion()
inoremap <expr><C-l> neocomplete#complete_common_string()
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return (pumvisible() ? "\<C-y>" : "" ) . "\<CR>"
endfunction
inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
"inoremap <expr><Space> pumvisible() ? "\<C-y>" : "\<Space>"
"let g:neocomplete#enable_auto_select = 1

let g:lightline = {
      \ 'colorscheme': 'jellybeans',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'fugitive#head'
      \ },
      \ }
set noshowmode " For lightline
set laststatus=2 " For lightline

" autocmd vimenter * NERDTree
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | wincmd p | endif
" autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif
" autocmd VimEnter * if exists("b:NERDTree") | exe 'NERDTree' argv()[0] | wincmd p | endif
map <C-n> :NERDTreeToggle<CR>
autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
let g:NERDTreeDirArrowExpandable="+"
let g:NERDTreeDirArrowCollapsible="~"
" let g:NERDTreeIndicatorMapCustom = {
"     \ "Modified"  : "*",
"     \ "Staged"    : "+",
"     \ "Untracked" : "O",
"     \ "Renamed"   : ">",
"     \ "Unmerged"  : "=",
"     \ "Deleted"   : "X",
"     \ "Dirty"     : "!",
"     \ "Clean"     : ".",
"     \ 'Ignored'   : '-',
"     \ "Unknown"   : "?"
"     \ }

" Switching buffers with left and right keys
" should not be done when in the NERD Tree.
function! MapBufferShift()
  silent! unmap <LEFT>
  silent! unmap <RIGHT>
  if @% !~ "NERD_tree_"
    noremap <LEFT> :bp<CR>
    noremap <RIGHT> :bn<CR>
  endif
endfunction
autocmd BufEnter,BufWinEnter,VimEnter * call MapBufferShift()

noremap <DOWN> :<CR>
noremap <UP> :ls<CR>
noremap <PAGEUP> :<CR>
noremap <PAGEDOWN> :<CR>

let g:EasyMotion_do_mapping = 0 " Disable default mappings

" Jump to anywhere you want with minimal keystrokes, with just one key binding.
" `s{char}{label}`
" nmap s <Plug>(easymotion-overwin-f)
" or
" `s{char}{char}{label}`
" Need one more keystroke, but on average, it may be more comfortable.
" nmap s <Plug>(easymotion-overwin-f2)
nmap <Leader>s <Plug>(easymotion-overwin-f2)

" Turn on case insensitive feature
let g:EasyMotion_smartcase = 1

" JK motions: Line motions
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)

" <Leader>f{char} to move to {char}
map  <Leader>f <Plug>(easymotion-bd-f)
nmap <Leader>f <Plug>(easymotion-overwin-f)

" Move to line
map <Leader>l <Plug>(easymotion-bd-jk)
nmap <Leader>l <Plug>(easymotion-overwin-line)

" Move to word
map  <Leader>w <Plug>(easymotion-bd-w)
nmap <Leader>w <Plug>(easymotion-overwin-w)

"""""""""""""""""""""""""""""""""""""""""""""""""""
