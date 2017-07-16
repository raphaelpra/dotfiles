set nocompatible	" be iMproved

" tabs
set tabstop=4 " how to display tab characters
set softtabstop=2
set shiftwidth=2 " space for each setp of (auto)indent
set shiftround " round indents to multiples of shiftwidth
set expandtab
set smarttab

" Requested by LustyExplorer
set hidden

" indent
set autoindent
set smartindent

" backspace
set backspace=indent,eol,start

" backup
set backup
set backupdir=~/.vim-tmp,~/.tmp,/var/tmp,/tmp

" search options
set ignorecase
set incsearch
set hls

" cursorline
set cursorline
set cursorcolumn

" Menu on top
set showtabline=2

" encoding
set encoding=utf-8
set fileencoding=utf-8
set termencoding=utf-8

" for big lines
set showbreak=...

" CtrlP ignore files
set wildignore+=*/tmp/*,*/public/*,*.so,*.swp,*.zip
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn)$',
  \ 'file': '\v\.(exe|so|dll)$',
  \ }

" Turning on the syntax coloring on Max os x
colorscheme molokai

syntax on

" highlight trailing whitespace
:autocmd BufWinEnter * match ExtraWhitespace /\s\+\%#\@<!$/
:highlight ExtraWhitespace ctermbg=red guibg=red

" Pry abbreviations
ab rpry require 'pry'
ab bpry binding.pry
function! RemovePry()
  :g/pry/d
endfunction


" Shortcut to show the number of line
map ,n :set invnumber<CR>
map zz :bd<CR>

map zj 10j
map zk 10k
map zh 10h
map zl 10l

" For toggling the list of tags
map ,e :TlistToggle<CR>

" Shortcut for commenting
map gc<Space> gcc

map ,v  :set invpaste<CR>
map ,h  :s/:\([^ ]*\)\(\s*\)=>/\1:/g<CR>
map ,%h :%s/:\([^ ]*\)\(\s*\)=>/\1:/g<CR>
map ,' :s/"/'/g<CR>:noh<CR>
map ," :s/'/"/g<CR>:noh<CR>


" map gh :bp<CR>
" map gj :cp<CR>
" map gk :bn<CR>
" map gl :cn<CR>

" Escape easily
imap jj <ESC>

vmap t :Tabularize /

nnoremap :x :w

" Remove empty trailing characters
" To be improved
nnoremap ,c :%s/ *$//g<CR>:noh<CR>

" Add as starus bar
set ruler
set laststatus=2
set statusline=%t[%{strlen(&fenc)?&fenc:'none'},%{&ff}]%h%m%r%y%=%c,%l/%L\ %P

" Navigate existing buffer
nmap ,<tab> :bn<CR>
nmap ,<S-tab> :bp<CR>

" Recherche intelligente en visual mode
function! s:VSetSearch()
    let temp = @@
    norm! gvy
    let @/ = '\V' . substitute(escape(@@, '\'), '\n', '\\n', 'g')
    let @@ = temp
endfunction

vnoremap * :<C-u>call <SID>VSetSearch()<CR>//<CR>
vnoremap # :<C-u>call <SID>VSetSearch()<CR>??<CR>

call plug#begin('~/.vim/plugged')

" My Plugs here:
" live checking of syntax errors
Plug 'scrooloose/syntastic'
" Plug 'syntastic'
" RoR support
Plug 'tpope/vim-rails'

" Go support
Plug 'fatih/vim-go', { 'for': 'go' }
Plug 'nsf/gocode', { 'for': 'go', 'rtp': 'vim', 'do': '~/.vim/plugged/gocode/vim/symlink.sh' }

" For Git integration
Plug 'tpope/vim-fugitive'

Plug 'cakebaker/scss-syntax.vim'

Plug 'tpope/vim-surround'

Plug 'tpope/vim-commentary'

Plug 'ctrlpvim/ctrlp.vim'

" To manage aligning text effeciently (exemple ':Tab /=')
Plug 'godlygeek/tabular'

" to repeat hte command like surround
Plug 'tpope/vim-repeat'

" Tablist
" FIXME
" Plug 'taglist.vim'

" To rename a file
Plug 'danro/rename.vim'

" All of your Plugins must be added before the following line
call plug#end()            " required


" Golang support
let g:go_fmt_command = "goimports"
let g:go_fmt_autosave = 1

" For matchit installation
runtime macros/matchit.vim

" Coloration json
autocmd BufNewFile,BufRead *.json set ft=json
autocmd BufNewFile,BufRead *.md set ft=md

"ruby
autocmd FileType ruby,eruby set omnifunc=rubycomplete#Complete
autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading = 1
autocmd FileType ruby,eruby let g:rubycomplete_rails = 1
autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global = 1

filetype plugin indent on     " required!

" In order to make zen coding work
let g:user_zen_expandabbr_key = '<c-e>'
let g:use_zen_complete_tag = 1

" Shortcuts for tags
nnoremap <c-t> <c-]>
nnoremap <c-T> g<c-]>
nnoremap ,p :CtrlPTag<cr>

nmap ff :echo @%<CR>
map ,m :%s/\r/\r/g<CR>

let mapleader=","
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PROMOTE VARIABLE TO RSPEC LET
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! PromoteToLet()
  :normal! dd
  " :exec '?^\s*it\>'
  :normal! P
  :.s/\(\w\+\) = \(.*\)$/let(:\1) { \2 }/
  :normal ==
endfunction
:command! PromoteToLet :call PromoteToLet()
:map ,l :PromoteToLet<cr>

" This makes RVM work inside Vim. I have no idea why.
set shell=bash
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" RUNNING TESTS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <leader>t :call RunTestFile()<cr>
map <leader>T :call RunNearestTest()<cr>
map <leader>a :call RunTests('')<cr>
" map <leader>c :w\|:!script/features<cr>
map <leader>w :w\|:!script/features --profile wip<cr>

function! RunTestFile(...)
    if a:0
        let command_suffix = a:1
    else
        let command_suffix = ""
    endif

    " Run the tests for the previously-marked file.
    let in_test_file = match(expand("%"), '\(.feature\|_spec.rb\)$') != -1
    if in_test_file
        call SetTestFile()
    elseif !exists("t:grb_test_file")
        return
    end
    call RunTests(t:grb_test_file . command_suffix)
endfunction

function! RunNearestTest()
    let spec_line_number = line('.')
    call RunTestFile(":" . spec_line_number . " -b")
endfunction

function! SetTestFile()
    " Set the spec file that tests will be run for.
    let t:grb_test_file=@%
endfunction

function! RunTests(filename)
    " Write the file and run tests for the given filename
    :w
    :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
    :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
    :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
    :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
    :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
    :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
    if match(a:filename, '\.feature$') != -1
        exec ":!script/features " . a:filename
    else
        if filereadable("script/test")
            exec ":!script/test " . a:filename
        elseif filereadable("Gemfile")
            exec ":!bundle exec rspec --color " . a:filename
        else
            exec ":!rspec --color " . a:filename
        end
    end
endfunction
