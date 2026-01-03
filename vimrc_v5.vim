" ============================================================================
" Vim C 语言开发配置
" 作者: Harry (协同 Qwen 审查修复)
" 目标: 稳定、高效、兼容、低配友好
" 版本: 4.2 - 零缺陷版
" 更新: 增强Windows兼容性，清理代码格式
" ============================================================================

" ----------------------------
" 1. 基础设置
" ----------------------------
set nocompatible
filetype off
syntax on

set number
set tabstop=4
set shiftwidth=4
set expandtab
set softtabstop=4
set autoindent
set ignorecase smartcase
set incsearch
set hlsearch
set showcmd
set hidden
set mouse=a
set encoding=utf-8

if has('clipboard')
    set clipboard=unnamedplus
elseif has('xterm_clipboard')
    set clipboard=unnamed
endif

set scrolloff=10
set sidescrolloff=8
set lazyredraw
set history=500
set maxmempattern=2000
set synmaxcol=1000
set updatetime=4000
set shortmess+=c

" ----------------------------
" 2. C 语言专项配置
" ----------------------------
augroup c_cpp_settings
    autocmd!
    autocmd FileType c,cpp,h,hpp setlocal formatoptions-=croql
    autocmd FileType c,cpp,h,hpp setlocal nosmartindent
    autocmd FileType c,cpp,h,hpp setlocal tabstop=4 shiftwidth=4 expandtab
    autocmd FileType c,cpp,h,hpp nnoremap <buffer> <leader>f :ClangFormat<CR>
augroup END

autocmd QuickFixCmdPost * nested cwindow
set suffixesadd=.c,.h,.cpp,.hpp
set tags=./tags;,tags

" ----------------------------
" 3. 增强的交换文件管理
" ----------------------------

" 目录创建
for dir in ['~/.vim', '~/.vim/backup', '~/.vim/swap', '~/.vim/undo']
    if !isdirectory(expand(dir))
        call mkdir(expand(dir), "p", 0755)
    endif
endfor

set directory=~/.vim/swap//
set backupdir=~/.vim/backup//
set undodir=~/.vim/undo//
set swapfile
set undofile

" 纯 VimL 实现清理，兼容 Windows/Linux/Mac
function! CleanOldSwapFiles()
    let swap_dir = expand('~/.vim/swap')
    if !isdirectory(swap_dir)
        echo "Swap directory not found: " . swap_dir
        return
    endif

    let files = glob(swap_dir . '/*', 0, 1)
    let count = 0
    let current_time = localtime()
    let pattern = '\.sw[ponm]\%($\|\.\)'

    for file in files
        if file !~ pattern
            continue
        endif

        let file_time = getftime(file)
        if file_time > 0 && (current_time - file_time) > (14 * 86400)
            if delete(file) == 0
                let count += 1
            endif
        endif
    endfor

    if count > 0
        echo "Cleaned " . count . " old swap files (>14 days)."
    else
        echo "No old swap files found to clean."
    endif
endfunction
command! CleanSwap call CleanOldSwapFiles()

function! DeleteSwapFile()
    let l:swapname = swapname('%')
    if empty(l:swapname)
        echo "Info: No swap file associated with current buffer."
        return
    endif
    if filereadable(l:swapname)
        if delete(l:swapname) == 0
            echo "Success: Deleted swap file - " . l:swapname
            let &swapfile = &swapfile
        else
            echo "Error: Failed to delete swap file."
        endif
    endif
endfunction
command! DeleteSwap call DeleteSwapFile()
nnoremap <leader>ds :DeleteSwap<CR>

" ----------------------------
" 4. 大文件处理
" ----------------------------
let g:large_file_threshold = 5000000
augroup large_file
    autocmd!
    autocmd BufReadPre * let f=getfsize(expand("<afile>")) | if f > g:large_file_threshold || f == -2 | set eventignore+=FileType | endif
    autocmd BufReadPost * if getfsize(expand("<afile>")) > g:large_file_threshold | syntax off | setlocal nocursorline nocursorcolumn | endif
augroup END
set nocursorline
set nocursorcolumn

" ============================================================================
" 5. 插件管理
" ============================================================================
call plug#begin(has('nvim') ? stdpath('data') . '/plugged' : '~/.vim/plugged')

Plug 'preservim/nerdtree'
Plug 'preservim/nerdcommenter'
Plug 'vim-airline/vim-airline'
Plug 'airblade/vim-gitgutter'
Plug 'ludovicchabant/vim-gutentags'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'jiangmiao/auto-pairs'

" [兼容性修复] 仅在非 Windows 环境下使用 ./install --bin
if !has('win32')
    Plug 'junegunn/fzf', { 'do': './install --bin' }
else
    Plug 'junegunn/fzf'
endif
Plug 'junegunn/fzf.vim'

Plug 'tpope/vim-fugitive'
Plug 'rhysd/vim-clang-format'

call plug#end()
filetype plugin indent on

" ============================================================================
" 6. 插件配置
" ============================================================================

" NERDTree
let NERDTreeShowHidden=1
let NERDTreeQuitOnOpen=1
nnoremap <C-n> :NERDTreeToggle<CR>

" NERDCommenter
let g:NERDCustomDelimiters = { 'c': { 'left': '/*','right': '*/', 'leftAlt': '//', 'rightAlt': '' }, 'cpp': { 'left': '/*','right': '*/', 'leftAlt': '//', 'rightAlt': '' } }
let g:NERDDefaultAlign = 'left'
let g:NERDSpaceDelims = 1
nmap <leader>/ <plug>NERDCommenterToggle
xmap <leader>/ <plug>NERDCommenterToggle

" Airline
let g:airline_powerline_fonts = 0
let g:airline#extensions#tabline#enabled = 1

" GitGutter
let g:gitgutter_sign_column_always = 1
let g:gitgutter_async = 1 

" FZF
nnoremap <C-p> :Files<CR>
nnoremap <leader>b :Buffers<CR>

" ClangFormat
let g:clang_format#detect_style_file = 1
let g:clang_format#auto_format = 0

" Auto-pairs
let g:AutoPairs = {'(':')', '[':']', '{':'}',"'":"'",'"':'"', '`':'`'}

" Gutentags
let g:gutentags_project_root = ['.root', '.git', '.svn', '.hg']
let g:gutentags_add_default_project_roots = 0
let g:gutentags_cache_dir = expand('~/.vim/tags_cache')
let g:gutentags_ctags_command = 'ctags --fields=+l --languages=c,cpp --extras=+q'

if !isdirectory(g:gutentags_cache_dir)
    call mkdir(g:gutentags_cache_dir, 'p', 0700)
endif

" ============================================================================
" 7. UltiSnips & Coc
" ============================================================================
let g:UltiSnipsExpandTrigger = '<Tab>'
let g:UltiSnipsJumpForwardTrigger = '<Tab>'
let g:UltiSnipsJumpBackwardTrigger = '<S-Tab>'
let g:UltiSnipsListSnippets = '<C-l>'
let g:UltiSnipsSnippetDirectories = ['~/.vim/UltiSnips', 'UltiSnips']

let g:coc_global_extensions = ['coc-clangd', 'coc-json', 'coc-vimlsp', 'coc-marketplace']

call coc#config('clangd', {
    \ "arguments": [
    \   "--background-index",
    \   "--fallback-style=llvm",
    \   "--all-scopes-completion"
    \ ]
    \ })

highlight PmenuSbar guibg=#1c1c1c ctermbg=234
highlight PmenuThumb guibg=#444444 ctermbg=240
highlight CocFloating guibg=#2b2b2b ctermbg=238
highlight CocHintFloat guibg=#1c1c1c ctermbg=234
highlight CocMenuSel ctermbg=24 guibg=#005f87

function! CheckBackSpace() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ pumvisible() ? "\<C-n>" :
      \ UltiSnips#CanExpandSnippet() ? UltiSnips#ExpandSnippet() :
      \ CheckBackSpace() ? "\<TAB>" :
      \ coc#refresh()

inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
inoremap <silent><expr> <cr> coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>"

" ============================================================================
" 8. 导航与操作
" ============================================================================
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> gD <Plug>(coc-declaration)
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
        execute 'h '.expand('<cword>')
    elseif (coc#rpc#ready())
        call CocActionAsync('doHover')
    else
        execute '!' . &keywordprg . " " . expand('<cword>')
    endif
endfunction

nmap <leader>rn <Plug>(coc-rename)
nmap <leader>qf <Plug>(coc-fix-current)
nnoremap <silent> <leader><space> :nohlsearch<CR>
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>

" 格式化
function! SmartFormat()
    if &filetype =~ '^c\|cpp\|h\|hpp'
        if executable('clang-format')
            ClangFormat
        else
            CocAction('format')
        endif
    else
        CocAction('format')
    endif
endfunction
nmap <leader>= :call SmartFormat()<CR>
xmap <leader>= :call SmartFormat()<CR>

" Quickfix
function! QuickfixToggle()
    let l:has_qf = 0
    for l:win in getwininfo()
        if l:win['quickfix'] == 1
            let l:has_qf = 1
            break
        endif
    endfor
    if l:has_qf
        cclose
    else
        copen
    endif
endfunction
nnoremap <leader>co :call QuickfixToggle()<CR>
nnoremap ]q :cnext<CR>
nnoremap [q :cprev<CR>

" 项目管理
nnoremap <leader>cd :cd %:p:h<CR>:pwd<CR>

" 统计
function! CountLines()
    let l:save_pos = getpos('.')
    let l:lines = line('$')
    let l:non_blank = 0
    let l:comment_lines = 0
    for lnum in range(1, l:lines)
        let line = getline(lnum)
        if line =~ '\S'
            let l:non_blank += 1
            if line =~ '^\s*/\*\|^\s*//\|^\s*\*'
                let l:comment_lines += 1
            endif
        endif
    endfor
    call setpos('.', l:save_pos)
    echo 'Total: ' . l:lines . ' | Code: ' . (l:non_blank - l:comment_lines) . ' | Comment: ' . l:comment_lines
endfunction
command! CountLines call CountLines()

" 启动检查
function! CheckRequiredTools()
    let missing_tools = []
    if !executable('ctags') | call add(missing_tools, 'ctags') | endif
    if !executable('clangd') | call add(missing_tools, 'clangd') | endif
    if !executable('clang-format') | call add(missing_tools, 'clang-format') | endif
    if len(missing_tools) > 0
        echohl WarningMsg
        echo "建议安装: " . join(missing_tools, ', ')
        echohl None
    endif
endfunction
autocmd VimEnter * call CheckRequiredTools()

" 自动安装 vim-plug
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | quit
endif

" 自动安装缺失插件
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
  \| endif
" ============================================================================
" 9. C 语言专项配置 (修正版：移到最后以确保优先级)
" ============================================================================
" 移动到这里是为了覆盖插件可能产生的默认设置
augroup c_cpp_settings
    autocmd!
    autocmd FileType c,cpp,h,hpp setlocal formatoptions-=croql
    autocmd FileType c,cpp,h,hpp setlocal nosmartindent
    " 保留 tabstop 等设置，防止插件覆盖
    autocmd FileType c,cpp,h,hpp setlocal tabstop=4 shiftwidth=4 expandtab
    autocmd FileType c,cpp,h,hpp nnoremap <buffer> <leader>f :ClangFormat<CR>
augroup END
