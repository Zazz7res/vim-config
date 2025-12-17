" ============================================================================
" Vim C 语言开发配置
" 作者: Harry
" 目标: 稳定、高效、兼容、低配友好
" 版本: 2.0 - 完整增强版
" ============================================================================

" ----------------------------
" 1. 基础设置与兼容性
" ----------------------------
set nocompatible              " 关闭 Vi 兼容模式，启用 Vim 现代特性
filetype off                  " 在加载插件前关闭文件类型检测

" ----------------------------
" 2. 强制禁用自动注释 - 核心修复
" ----------------------------
augroup NoAutoComment
    autocmd!
    " 针对所有文件类型禁用自动注释
    autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o formatoptions-=q formatoptions-=l
augroup END

" ----------------------------
" 3. 通用编辑体验优化
" ----------------------------
set number                    " 显示绝对行号
" [低配可选] 相对行号在滚动大文件时可能卡顿，低配机器建议注释掉
" set relativenumber

set tabstop=4                 " Tab 显示宽度为 4 空格
set shiftwidth=4              " 自动缩进宽度为 4
set expandtab                 " 将 Tab 转为空格
set softtabstop=4             " 按 Tab/Backspace 时操作的空格数，解决删除问题
set smarttab                  " 智能 Tab 行为
set autoindent                " 自动继承上一行缩进

set ignorecase smartcase      " 搜索忽略大小写，但含大写字母时区分
set incsearch                 " 输入搜索词时实时高亮
set hlsearch                  " 高亮所有搜索结果
set showcmd                   " 底部显示当前输入的命令

set hidden                    " 允许切换未保存的缓冲区
set mouse=a                   " 启用鼠标支持（全模式）

" 启用系统剪切板（仅当vim支持时）
if has('clipboard')
    set clipboard=unnamedplus "Linux 使用 + 寄存器
elseif has('xterm_clipboard')
    set clipboard=unnamed     "备用方案（旧版vim）
else
    echo "Warning: Clipboard not supported, install vim with +clipboard"
endif

set scrolloff=10              " 光标距离窗口边缘至少 10 行
set sidescrolloff=8           " 水平滚动时保持光标距离边缘 8 列
set lazyredraw                " 延迟重绘，提升宏和脚本执行性能

" 性能优化配置
set history=500               " 历史命令记录数量
set maxmempattern=2000        " 最大内存模式匹配大小
set synmaxcol=200             " 限制语法高亮扫描列数
"  2025年12月17日  21：53
"
"
"
"
" [低配可选] 24位真彩色在某些终端可能不兼容，若颜色异常请注释
" set termguicolors

" ----------------------------
" 4. C 语言专项配置
" ----------------------------
augroup c_cpp_settings
    autocmd!
    " 禁用自动注释和智能缩进
    autocmd FileType c,cpp,h,hpp setlocal formatoptions-=croql
    autocmd FileType c,cpp,h,hpp setlocal nosmartindent
    " 缩进设置
    autocmd FileType c,cpp,h,hpp setlocal tabstop=4 shiftwidth=4 expandtab
    
    " 代码格式化（需要安装 clang-format）
    autocmd FileType c,cpp,h,hpp nnoremap <buffer> <leader>cf :ClangFormat<CR>
    autocmd FileType c,cpp,h,hpp vnoremap <buffer> <leader>cf :ClangFormat<CR>
augroup END

autocmd QuickFixCmdPost * nested cwindow
set suffixesadd=.c,.h,.cpp,.hpp

" 配置 tags 文件路径，支持递归向上查找
" 依赖：需在项目根目录运行 `ctags -R .`
set tags=./tags;,tags

" ----------------------------
" 5. 增强的交换文件管理
" ----------------------------

" 1. 修复目录创建（修正路径）
if !isdirectory(expand("~/.vim"))
    call mkdir(expand("~/.vim"), "p", 0755)
endif
if !isdirectory(expand("~/.vim/backup"))
    call mkdir(expand("~/.vim/backup"), "p", 0755)
endif
if !isdirectory(expand("~/.vim/swap"))
    call mkdir(expand("~/.vim/swap"), "p", 0755)
endif
if !isdirectory(expand("~/.vim/undo"))
    call mkdir(expand("~/.vim/undo"), "p", 0755)
endif

" 2. 优化交换文件设置
set directory=~/.vim/swap//    " 双斜杠确保唯一文件名
set backupdir=~/.vim/backup//
set undodir=~/.vim/undo//

" 3. 增加交换文件写入延迟（提升性能，减少冲突）
set updatetime=1000            " 增加到 1000ms
set swapfile                   " 确保启用交换文件
set undofile                   " 启用持久化撤销

" 4. 添加交换文件自动清理功能
function! CleanOldSwapFiles()
    let swap_dir = expand('~/.vim/swap')
    if isdirectory(swap_dir)
        " 删除超过7天的交换文件
        let old_swap_files = systemlist('find ' . shellescape(swap_dir) . ' -name "*.swp" -mtime +7')
        for swap_file in old_swap_files
            call delete(swap_file)
            echo "Deleted old swap file: " . swap_file
        endfor
        if len(old_swap_files) > 0
            echo "Cleaned " . len(old_swap_files) . " old swap files."
        endif
    endif
endfunction

" 启动时自动清理旧交换文件
autocmd VimEnter * call CleanOldSwapFiles()

" 5. 交换文件管理快捷键
" 快速删除当前文件的交换文件
function! DeleteSwapFile()
    let swapfile = substitute(expand('%:p'), '/', '%', 'g')
    let swapfile = '~/.vim/swap/' . swapfile . '.swp'
    if filereadable(expand(swapfile))
        call delete(expand(swapfile))
        echo "Deleted swap file: " . swapfile
    else
        echo "No swap file found for current buffer"
    endif
endfunction

command! DeleteSwap call DeleteSwapFile()
nnoremap <leader>ds :DeleteSwap<CR>

" ----------------------------
" 6. 性能优化 - 大文件处理
" ----------------------------
augroup large_file
    autocmd!
    " 超过 1MB 的文件禁用部分功能
    autocmd BufReadPre * let f=getfsize(expand("<afile>")) | if f > 1000000 || f == -2 | set eventignore+=FileType | endif
    autocmd BufReadPost * if getfsize(expand("<afile>")) > 1000000 | syntax off | setlocal nocursorline nocursorcolumn | endif
augroup END

" [低配可选] 光标行/列高亮是性能大户，低配机器建议关闭
set nocursorline
set nocursorcolumn

" ============================================================================
" 7. 插件管理 (使用 vim-plug)
" ============================================================================
call plug#begin(has('nvim') ? stdpath('data') . '/plugged' : '~/.vim/plugged')

" =============== 核心必备插件 ===============
" 文件树浏览器 - 经典稳定，低配友好
Plug 'preservim/nerdtree'

" 智能注释 - C 语言开发刚需
Plug 'preservim/nerdcommenter'

" 状态栏增强 - 信息丰富且轻量
Plug 'vim-airline/vim-airline'

" Git 状态显示 - 行级修改标记，轻量低开销
Plug 'airblade/vim-gitgutter'

" 自动管理 tags 文件
Plug 'ludovicchabant/vim-gutentags'

" 智能补全引擎
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" =============== 代码片段插件 ===============
" UltiSnips - 强大的代码片段引擎
Plug 'SirVer/ultisnips'
" 预定义的代码片段库
Plug 'honza/vim-snippets'

" =============== 增强插件 (推荐安装) ===============
" 自动括号配对
Plug 'jiangmiao/auto-pairs'

" 模糊查找文件
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Git 集成增强
Plug 'tpope/vim-fugitive'

" 代码格式化
Plug 'rhysd/vim-clang-format'

" =============== 可选插件 ===============
" 彩虹括号 - 美观但可能影响性能
" Plug 'luochen1990/rainbow'

" 文件大纲
" Plug 'liuchengxu/vista.vim'

call plug#end()

" 重新启用文件类型检测
filetype plugin indent on

" ============================================================================
" 8. 插件个性化配置
" ============================================================================

" NERDTree 配置
let NERDTreeShowHidden=1      " 显示隐藏文件
let NERDTreeQuitOnOpen=1      " 打开文件后自动关闭
nnoremap <C-n> :NERDTreeToggle<CR>  " Ctrl+n 快速开关

" NERDCommenter - C语言专业注释配置
let g:NERDCustomDelimiters = {
    \ 'c': { 'left': '/*','right': '*/', 'leftAlt': '//', 'rightAlt': '' },
    \ 'cpp': { 'left': '/*','right': '*/', 'leftAlt': '//', 'rightAlt': '' }
    \ }
let g:NERDDefaultAlign = 'left'      " 左对齐
let g:NERDSpaceDelims = 1            " /* 和 */ 周围加空格
let g:NERDCompactSexyComs = 1        " 多行注释紧凑显示
let g:NERDCommentEmptyLines = 1      " 注释空行
let g:NERDToggleCheckAllLines = 1    " 智能切换注释
let g:NERDDisableAutoNesting = 1     " 禁用自动嵌套注释

" 快捷键（行业标准）
nmap <leader>/ <plug>NERDCommenterToggle
xmap <leader>/ <plug>NERDCommenterToggle
nmap <leader>c<space> <plug>NERDCommenterToggle
xmap <leader>c<space> <plug>NERDCommenterToggle

" vim-airline 配置
let g:airline_powerline_fonts = 0  " 设为 1 需 Powerline 字体
let g:airline#extensions#tabline#enabled = 1  " 显示多标签页

" vim-gitgutter 配置
let g:gitgutter_sign_column_always = 1  " 始终显示符号列

" fzf 配置
nnoremap <C-p> :Files<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>l :Lines<CR>

" ClangFormat 配置
let g:clang_format#detect_style_file = 1
let g:clang_format#auto_format = 0  " 不自动格式化，手动触发

" Auto-pairs 配置
let g:AutoPairs = {'(':')', '[':']', '{':'}',"'":"'",'"':'"', '`':'`'}

" ============================================================================
" 9. UltiSnips 配置 - 智能混合触发方案
" ============================================================================

" 🎯 智能触发方案：结合手动和自动触发
let g:UltiSnipsExpandTrigger = '<c-j>'         " Ctrl+J 展开片段
let g:UltiSnipsJumpForwardTrigger = '<c-j>'    " Ctrl+J 跳到下一个占位符
let g:UltiSnipsJumpBackwardTrigger = '<c-k>'   " Ctrl+K 跳回上一个占位符
let g:UltiSnipsListSnippets = '<c-l>'          " Ctrl+L 列出所有片段

let g:UltiSnipsEnableSnipMate = 0              " 禁用 SnipMate 兼容
let g:UltiSnipsRemoveSelectModeMappings = 0    " 保持完全手动控制
" UltiSnips 目录设置
let g:UltiSnipsSnippetDirectories = ['~/.vim/UltiSnips', 'UltiSnips']

" ============================================================================
" 10. Coc.nvim 配置 - 主流稳定方案
" ============================================================================

" 基础补全设置
set completeopt=menu,menuone,noselect
set shortmess+=c

" Coc 扩展配置 - 明确使用 clangd
let g:coc_global_extensions = [
      \ 'coc-clangd',
      \ 'coc-json',
      \ 'coc-vimlsp',
      \ 'coc-snippets'
      \ ]

" ============================================================================
" 11. 补全菜单颜色优化 - 适配黑白黄背景
" ============================================================================

" 补全菜单颜色配置
highlight PmenuSbar guibg=#1c1c1c ctermbg=234
highlight PmenuThumb guibg=#444444 ctermbg=240

" Coc 浮动窗口颜色
highlight CocFloating guibg=#2b2b2b ctermbg=238

" 文档悬浮窗口颜色
highlight CocHintFloat guibg=#1c1c1c ctermbg=234

" 让补全菜单有更好的边框效果
highlight CocMenuSel ctermbg=24 guibg=#005f87

" 选中的补全项
highlight CocSearch ctermfg=12 guifg=#18A3FF
highlight CocCursorRange ctermbg=17 guibg=#264F78

" ============================================================================
" 12. 智能 Tab 补全方案 - 解决键位冲突
" ============================================================================

" 🎯 智能 Tab 行为：自动判断当前上下文
function! CheckBackSpace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackSpace() ? "\<Tab>" :
      \ coc#refresh()

inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" 使用 Enter 键确认补全
inoremap <silent><expr> <cr> coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>"

" 手动触发补全
inoremap <silent><expr> <c-space> coc#refresh()

" ============================================================================
" 13. 代码导航和操作快捷键
" ============================================================================

" 跳转到定义
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> gD <Plug>(coc-declaration)

" 显示文档
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

" 重命名符号
nmap <leader>rn <Plug>(coc-rename)

" 格式化代码
nmap <leader>f <Plug>(coc-format-selected)
xmap <leader>f <Plug>(coc-format-selected)

" 代码操作
nmap <leader>ca <Plug>(coc-codeaction)
xmap <leader>ca <Plug>(coc-codeaction)
nmap <leader>cl <Plug>(coc-codelens-action)

" 快速修复
nmap <leader>qf <Plug>(coc-fix-current)

" ============================================================================
" 14. 其他实用快捷键
" ============================================================================

" 清除搜索高亮
nnoremap <silent> <leader><space> :nohlsearch<CR>

" 快速保存
nnoremap <silent> <C-s> :w<CR>
inoremap <silent> <C-s> <C-o>:w<CR>

" 快速退出
nnoremap <leader>q :q<CR>
nnoremap <leader>wq :wq<CR>
nnoremap <leader>qa :qa<CR>

" 窗口导航
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" 调整窗口大小
nnoremap <M-left> :vertical resize -5<CR>
nnoremap <M-right> :vertical resize +5<CR>
nnoremap <M-up> :resize -5<CR>
nnoremap <M-down> :resize +5<CR>

" ============================================================================
" 15. 项目管理功能
" ============================================================================

let g:project_root = {}
function! SetProjectRoot()
    let l:root = finddir('.git', '.;')
    if l:root != ''
        let g:project_root = fnamemodify(l:root, ':h')
        echo 'Project root: ' . g:project_root
        execute 'cd ' . g:project_root
    else
        let g:project_root = getcwd()
        echo 'Using current directory as project root'
    endif
endfunction

nnoremap <leader>pr :call SetProjectRoot()<CR>
nnoremap <leader>cd :cd %:p:h<CR>:pwd<CR>

" ============================================================================
" 17. 错误处理和 Quickfix 管理
" ============================================================================

function! QuickfixToggle()
    if empty(filter(getwininfo(), 'v:val.quickfix'))
        copen
    else
        cclose
    endif
endfunction

nnoremap <leader>co :call QuickfixToggle()<CR>
nnoremap ]q :cnext<CR>
nnoremap [q :cprev<CR>
nnoremap ]Q :clast<CR>
nnoremap [Q :cfirst<CR>

" ============================================================================
" 18. 代码统计功能
" ============================================================================

function! CountLines()
    let l:save_pos = getpos('.')
    let l:lines = line('$')
    let l:non_blank = 0
    let l:comment_lines = 0
    
    for lnum in range(1, l:lines)
        let line = getline(lnum)
        if line =~ '\S'  " 非空行
            let l:non_blank += 1
            if line =~ '^\s*/\*\|^\s*//\|^\s*\*'  " 注释行
                let l:comment_lines += 1
            endif
        endif
    endfor
    
    call setpos('.', l:save_pos)
    echo 'Total lines: ' . l:lines . 
         \ ' | Non-blank: ' . l:non_blank .
         \ ' | Comments: ' . l:comment_lines .
         \ ' | Code: ' . (l:non_blank - l:comment_lines)
endfunction
command! CountLines call CountLines()

" ============================================================================
" 19. 文件类型特定优化
" ============================================================================

" C/C++ 文件头文件自动包含提示
augroup c_cpp_completion
    autocmd!
    autocmd FileType c,cpp setlocal include=^\\s*#\\s*include
    autocmd FileType c,cpp setlocal includeexpr=substitute(v:fname,'\\.','/','g')
    autocmd FileType c,cpp setlocal path=.,/usr/include,,/usr/local/include
augroup END

" ============================================================================
" 20. 检查 Coc 状态
" ============================================================================

augroup CocGroup
    autocmd!
    autocmd User CocNvimInit silent! call s:check_coc_status()
augroup END

function! s:check_coc_status()
    if !get(g:, 'coc_enabled', 0)
        echo "Coc.nvim not fully initialized. Run :CocInfo for details."
    endif
endfunction

" ============================================================================
" 21. 自定义命令
" ============================================================================

" 重新加载配置
command! ReloadConfig source ~/.vimrc | echo "Configuration reloaded!"

" 显示当前文件信息
command! FileInfo echo expand('%:p') . ' (' . &filetype . ')'

" ============================================================================
" 22. 启动时自动执行
" ============================================================================

" 启动时检查并设置项目根目录
autocmd VimEnter * if argc() > 0 | call SetProjectRoot() | endif

" ============================================================================
" 自动安装 vim-plug（如果不存在）
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    echo "Installing vim-plug and plugins..."
    autocmd VimEnter * PlugInstall --sync | quit
endif

" 自动安装缺少的插件
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
  \| endif

" ============================================================================
" 配置结束
" ============================================================================
