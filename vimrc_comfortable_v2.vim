" ============================================================================
" Vim C 语言开发配置
" 作者: Harry
" 目标: 稳定、高效、兼容、低配友好
" ============================================================================

" ----------------------------
" 1. 基础设置与兼容性 (必须第一行)
" ----------------------------
set nocompatible              " 关闭 Vi 兼容模式，启用 Vim 现代特性
filetype off                  " 在加载插件前关闭文件类型检测

" ----------------------------
" 2. 强制禁用自动注释 - 核心修复
" ----------------------------
" 问题根源：/usr/share/vim/vim91/ftplugin/c.vim 第24行的 formatoptions=croql
" 解决方案：在文件类型检测后强制覆盖系统设置
augroup NoAutoComment
    autocmd!
    " 针对所有文件类型禁用自动注释
    autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o formatoptions-=q formatoptions-=l
    " 特别针对 C 文件类型，在系统设置后强制执行
    autocmd FileType c,cpp,h,hpp setlocal formatoptions-=c formatoptions-=r formatoptions-=o formatoptions-=q formatoptions-=l
    autocmd FileType c,cpp,h,hpp setlocal nosmartindent
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
    set clipboard=unnamed     "备用方案（旧版vim)
endif
set scrolloff=10               " 光标距离窗口边缘至少 10 行
set sidescrolloff=8           " 水平滚动时保持光标距离边缘 8 列
set updatetime=300            " 减少交换文件写入频率（提升性能")

" [低配可选] 24位真彩色在某些终端可能不兼容，若颜色异常请注释
" set termguicolors

" ----------------------------
" 4. C 语言专项配置 (修复版)
" ----------------------------
autocmd FileType c,cpp,h,hpp setlocal tabstop=4 shiftwidth=4 expandtab
autocmd FileType c,cpp,h,hpp setlocal makeprg=gcc\ -Wall\ -Wextra\ -g\ -o\ %<\ %
autocmd FileType c,cpp setlocal errorformat=%f:%l:%c:\ %t%*[^:]:\ %m
autocmd QuickFixCmdPost * nested cwindow
set suffixesadd=.c,.h,.cpp,.hpp
" 配置 tags 文件路径，支持递归向上查找
" 依赖：需在项目根目录运行 `ctags -R .`
set tags=./tags;,tags

" ----------------------------
" 5. 目录与备份设置 (避免污染项目目录)
" ----------------------------
set backupdir=~/.vim/backup//
set directory=~/.vim/swap//
set undodir=~/.vim/undo//
if !isdirectory(expand("~/.vim/backup")) | call mkdir(expand("~/.vim/backup"), "p", 0700) | endif
if !isdirectory(expand("~/.vim/swap"))   | call mkdir(expand("~/.vim/swap"), "p", 0700)   | endif
if !isdirectory(expand("~/.vim/undo"))  | call mkdir(expand("~/.vim/undo"), "p", 0700)  | endif
set undofile                  " 启用持久化撤销

" [低配可选] 光标行/列高亮是性能大户，低配机器建议关闭
" set cursorline
" set cursorcolumn

" [低配可选] 限制语法高亮扫描列数，提升大文件性能
" set synmaxcol=200

" ============================================================================
" 插件管理 (使用 vim-plug)
" ============================================================================
call plug#begin(has('nvim') ? stdpath('data') . '/plugged' : '~/.vim/plugged')

" =============== 核心必备插件 (强烈推荐) ===============
" 文件树浏览器 - 经典稳定，低配友好
Plug 'preservim/nerdtree'

" 智能注释 - C 语言开发刚需
Plug 'preservim/nerdcommenter'

" 状态栏增强 - 信息丰富且轻量
Plug 'vim-airline/vim-airline'

" Git 状态显示 - 行级修改标记，轻量低开销
Plug 'airblade/vim-gitgutter'

" 自动管理 tags 文件，替代手动 ctags
Plug 'ludovicchabant/vim-gutentags'

" 智能补全引擎
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" =============== 增强插件 (按需选择) ===============
" 模糊查找 - 快速打开文件/缓冲区 (基础功能无需额外工具)
" Plug 'junegunn/fzf.vim'

" =============== 低配慎用插件 ===============
" 彩虹括号 - 美观但可能影响性能
" Plug 'luochen1990/rainbow'

call plug#end()

" 重新启用文件类型检测
filetype plugin indent on

" ============================================================================
" 插件个性化配置
" ============================================================================

" NERDTree 配置
let NERDTreeShowHidden=1      " 显示隐藏文件
let NERDTreeQuitOnOpen=1      " 打开文件后自动关闭
nnoremap <C-n> :NERDTreeToggle<CR>  " Ctrl+n 快速开关

" NERDCommenter - C语言专业注释配置（已优化）
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

" Gutentags 配置 (通常开箱即用，无需额外配置)
" 它会自动在项目根目录生成和更新 tags 文件

" ============================================================================
" Coc.nvim 配置 - 主流稳定方案
" ============================================================================

" 基础补全设置
set completeopt=menu,menuone,noselect
set shortmess+=c

" Coc 扩展配置
let g:coc_global_extensions = [
      \ 'coc-clangd',
      \ 'coc-snippets',
      \ 'coc-json',
      \ 'coc-vimlsp'
      \ ]

" ============================================================================
" 代码补全快捷键 - 简洁主流方案
" ============================================================================

" Tab 补全导航
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ <SID>check_back_space() ? "\<Tab>" :
      \ coc#refresh()

inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" 回车键确认补全
inoremap <silent><expr> <cr> coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>"

" 辅助函数
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" ============================================================================
" 代码导航和操作快捷键
" ============================================================================

" 跳转到定义
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

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

" 代码格式化
command! -nargs=0 Format :call CocAction('format')
nmap <leader>f :Format<CR>

" 代码操作
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" 诊断导航
nmap <silent> [d <Plug>(coc-diagnostic-prev)
nmap <silent> ]d <Plug>(coc-diagnostic-next)

" ============================================================================
" 自动命令和文件类型特定设置
" ============================================================================

" 高亮当前符号
autocmd CursorHold * silent call CocActionAsync('highlight')

" C/C++ 文件特定设置
augroup c_cpp_settings
    autocmd!
    " 为 C/C++ 文件设置更智能的补全
    autocmd FileType c,cpp setlocal omnifunc=coc#complete
    " 禁用某些自动补全以避免冲突
    autocmd FileType c,cpp setlocal completeopt-=preview
augroup END

" ----------------------------
" 6. 最终确认设置生效
" ----------------------------
" 启动后最终确认 formatoptions 设置
autocmd VimEnter * set formatoptions-=croql

" 调试命令：检查当前设置是否生效
" :set formatoptions?
" 正确结果应该不包含 'r' 和 'o' 选项

" ----------------------------
" 7. 跨平台兼容性处理
" ----------------------------
"if has("win32") || has("win64")
    " Windows 配置：使用 PowerShell
"    set shell=powershell.exe
"    set shellcmdflag=-NoLogo\ -NoProfile\ -ExecutionPolicy\ RemoteSigned\ -Command
 "   set shellxquote=\"
 "   let &shellredir = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
"endif

" Neovim 特定配置（如有需要可在此扩展）
"if has('nvim')
    " Neovim 默认剪贴板处理通常已优化
"endif

" ============================================================================
" 安装说明和故障排除
" ============================================================================

" 1. 安装 vim-plug (如果尚未安装):
"    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
"        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim  
"
" 2. 安装插件:
"    :PlugInstall
"
" 3. 安装 coc-clangd (C/C++ 语言服务器):
"    :CocInstall coc-clangd
"
" 4. 如果补全仍然不工作，检查:
"    :CocInfo
"    :CocConfig
"
" 5. 确保系统已安装 clangd:
"    Ubuntu/Debian: sudo apt-get install clangd
"    CentOS/RHEL: sudo yum install clang-tools-extra
"
" 6. 创建 ~/.config/coc-settings.json 文件:
"    {
"      "languageserver": {
"        "ccls": {
"          "command": "ccls",
"          "filetypes": ["c", "cpp", "cuda", "objc", "objcpp"],
"          "rootPatterns": [".ccls", "compile_commands.json", ".git/", ".hg/"],
"          "initializationOptions": {
"            "cache": {
"              "directory": "/tmp/ccls"
"            }
"          }
"        }
"      }
"    }
"代码补全操作
"触发补全：输入代码时自动弹出，或按 Ctrl + 空格
"选择补全项：
"Tab 键：向下选择
"Shift + Tab 键：向上选择
"确认选择：Enter 键
"其他常用操作
"取消补全：Ctrl + E
"查看文档：选择补全项时按 K 键
