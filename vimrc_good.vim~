" ============================================================================
" Vim Ultimate God Mode Configuration
" Philosophy: Performance over Compatibility, Feature-Rich, IDE-like
" Author: AI Vim Expert
" ============================================================================

" ----------------------------
" 1. Core Environment (极致开启)
" ----------------------------
set nocompatible
filetype plugin indent on
syntax on

" --- 编码 ---
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8,ucs-bom,gb18030,gbk,gb2312,cp936

" --- 界面 (全部开启) ---
set number
set relativenumber
set cursorline
set cursorcolumn
set showcmd
set showmatch
set matchtime=1
set ruler
set laststatus=2

" --- 鼠标与剪贴板 (全功能) ---
set mouse=a
set selection=exclusive
set selectmode=mouse,key

" 👇 替换成安全的手动映射 (需要复制时才用)
" 普通的 y/p 还是在 Vim 内部飞快，不碰系统剪贴板
nnoremap <leader>y "+y
xnoremap <leader>y "+y
nnoremap <leader>yy "+yy
nnoremap <leader>p "+p

" --- 编辑行为 (激进模式) ---
set tabstop=4
set shiftwidth=4
set expandtab
set smarttab
set autoindent
set smartindent
set cindent
set wrap
set linebreak

" --- 搜索 (高亮智能) ---
set hlsearch
set incsearch
set ignorecase
set smartcase

" --- 性能 (极致响应) ---
set lazyredraw
set ttyfast
set updatetime=100      " 极短延迟，实时保存
set timeoutlen=300
set ttimeoutlen=50
set redrawtime=10000

" --- 容错 ---
set hidden              " 允许不保存切换 Buffer"
set backspace=indent,eol,start
set history=10000
set undolevels=1000
set backup
set writebackup
set undofile
set swapfile

" ----------------------------
" 2. Plugin Management (Plug)
" ============================================================================
call plug#begin('~/.vim/plugged')

"---------------  3. Theme & UI ----------------
" --- Theme & UI (Gruvbox - Vim 圈主流之王) ---
Plug 'morhetz/gruvbox'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'preservim/nerdtree'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'airblade/vim-gitgutter'

" --- Completion & LSP (核心) ---
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" 扩展：C语言, 片段, Git, 资源管理器, 列表, 高亮, 翻译
let g:coc_global_extensions = [
    \ 'coc-clangd', 'coc-snippets', 'coc-git', 
    \ 'coc-explorer', 'coc-lists', 'coc-highlight', 'coc-translator'
    \ ]

" --- Snippets (片段库) ---
Plug 'honza/vim-snippets'

" --- Editing Enhancements (编辑增强) ---
Plug 'tpope/vim-surround'            " 快速包围符修改
Plug 'tpope/vim-commentary'          " 快速注释
Plug 'jiangmiao/auto-pairs'          " 自动补全括号 (性能允许，开它!)
Plug 'junegunn/vim-easy-align'       " 快速对齐

" --- Navigation & Search (导航) ---
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'majutsushi/tagbar'             " 标签栏

" --- C / C++ Tools ---
Plug 'rhysd/vim-clang-format'

" --- Git ---
Plug 'tpope/vim-fugitive'

call plug#end()

" ============================================================================
" 3. Theme Settings (Gruvbox Dark - Hard Contrast)
" ============================================================================
set background=dark
colorscheme gruvbox

" --- 核心设置 ---
" 使用 "hard" 模式，增加对比度，让代码更清晰，减少视觉疲劳
let g:gruvbox_contrast_dark='hard'
" 设置背景色为 256 色，兼容性最好
let g:gruvbox_termcolors=256

" --- Airline Settings (集成 Gruvbox) ---
let g:airline_theme='gruvbox'
let g:airline_powerline_fonts = 0
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_buffers = 1
let g:airline_skip_empty_sections = 1

" --- 补全菜单颜色 ---
" 注意：Gruvbox 插件已经自动处理好了，这里只需要微调背景融合
" 如果你之前有 highlight Pmenu ... 的代码，请全部删掉，让 Gruvbox 自己管

" 4. Coc Configuration (智能核心)
" ============================================================================
" Coc Snippets & Pairs
let g:coc_snippet_next = '<c-j>'
let g:coc_snippet_prev = '<c-k>'

" Clangd 配置 (高性能)
call coc#config('clangd', {
    \ "arguments": [
    \   "--background-index",
    \   "--clang-tidy",
    \   "--header-insertion=iwyu",
    \   "--completion-style=detailed",
    \   "--function-arg-placeholders",
    \   "--fallback-style=llvm"
    \ ],
    \ "completeUnimported": { "enable": 1 }
    \ })

" 补全菜单高亮
highlight Pmenu ctermbg=236 guibg=#282a36 ctermfg=15 guifg=#f8f8f2
highlight PmenuSel ctermbg=39 guibg=#bd93f9 ctermfg=0 guifg=#282a36
highlight CocFloating guibg=#282a36 ctermbg=236
highlight CocMenuSel ctermbg=39 guibg=#bd93f9

" Tab 键逻辑 (UltiSnips 集成)
function! CheckBackSpace() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackSpace() ? "\<TAB>" :
      \ coc#refresh()

inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>"

" ----------------------------
" 5. Key Mappings (高效键位)
" ============================================================================
let mapleader = ","

" --- File Operations ---
nmap <leader>w :w<CR>
nmap <leader>q :q<CR>
nmap <leader>x :x<CR>

" --- Navigation ---
nnoremap <C-p> :Files<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>t :Tags<CR>
nnoremap <leader>e :CocCommand explorer<CR> " 使用 Coc Explorer 替代 NERDTree
nnoremap <C-n> :NERDTreeToggle<CR>

" --- Git ---
nmap <leader>gs :Gstatus<CR>
nmap <leader>gd :Gdiff<CR>
nmap <leader>gb :Gblame<CR>

" --- Coc LSP ---
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
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

" --- Refactoring ---
nmap <leader>rn <Plug>(coc-rename)
nmap <leader>qf <Plug>(coc-fix-current)
vmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

" --- Misc ---
nnoremap <leader><space> :nohlsearch<CR>
vmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" ----------------------------
" 6. Plugin Specific Configs
" ============================================================================
" Auto-Pairs
let g:AutoPairs = {'(':')', '[':']', '{':'}',"'":"'",'"':'"', '`':'`'}

" NERDTree
let NERDTreeShowHidden=1
let NERDTreeIgnore=['\.git$','\.o$','\.a$','\.swp$','\.swo$']

" ClangFormat
let g:clang_format#style_options = {
            \ "BasedOnStyle": "Google",
            \ "IndentWidth": 4,
            \ "ColumnLimit": 100}

" ----------------------------
" 7. Auto Commands (自动化)
" ============================================================================
" 自动保存
autocmd CursorHold,CursorHoldI * silent! update | silent! nohlsearch
" 保存时自动格式化 C/C++
autocmd BufWritePre *.c,*.cpp,*.h,*.hpp :ClangFormat

" 自动安装 vim-plug
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" 自动安装缺失插件
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
  \| endif
" ----------------------------
" 9. 禁止注释传染 (强迫症福音)
" ============================================================================
augroup c_cpp_settings
    autocmd!
    autocmd FileType c,cpp,h,hpp setlocal formatoptions-=croql
augroup END
