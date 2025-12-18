# ============================================
# C 语言代码片段配置 - UltiSnips
# ============================================

# [第一步：创建此文件]
# 在终端执行以下命令创建目录和文件：
# mkdir -p ~/.vim/UltiSnips
# touch ~/.vim/UltiSnips/c.snippets

# [第二步：添加以下代码片段内容]
# 将下面的片段定义复制到此文件中并保存

# [第三步：测试方法]
# 1. 打开一个 C 文件：vim test.c
# 2. 进入插入模式：按 i
# 3. 输入片段关键词（如 if）
# 4. 按 Tab 键展开片段
# 5. 使用 Ctrl+j 和 Ctrl+k 在占位符间跳转

# ============================================
# 基础代码片段定义
# ============================================

# 基础花括号块 - 手动触发
# 使用方法：输入 { 然后按 Tab
snippet { "Manual brace block"
{
	$0
}
endsnippet

# if 语句 - 手动触发
# 使用方法：输入 if 然后按 Tab
snippet if "Manual if statement"
if (${1:condition}) {
	$0
}
endsnippet

# while 循环 - 手动触发
# 使用方法：输入 while 然后按 Tab
snippet while "Manual while loop"
while (${1:condition}) {
	$0
}
endsnippet

# for 循环 - 手动触发
# 使用方法：输入 for 然后按 Tab
snippet for "Manual for loop"
for (${1:int i = 0}; ${2:i < N}; ${3:i++}) {
	$0
}
endsnippet

# 函数定义 - 手动触发
# 使用方法：输入 fun 然后按 Tab
snippet fun "Manual function"
${1:void} ${2:function_name}(${3:void}) {
	$0
}
endsnippet

# 主函数 - 手动触发
# 使用方法：输入 main 然后按 Tab
snippet main "Manual main function"
int main(int argc, char *argv[]) {
	$0
	return 0;
}
endsnippet

# 结构体定义 - 手动触发
# 使用方法：输入 struct 然后按 Tab
snippet struct "Manual struct definition"
struct ${1:name} {
	${0:/* data */}
};
endsnippet

# ============================================
# 扩展片段（可选添加）
# ============================================

# include 语句
# 使用方法：输入 inc 然后按 Tab
snippet inc "Include statement"
#include <${1:stdio}.h>
$0
endsnippet

# printf 语句
# 使用方法：输入 pf 然后按 Tab
snippet pf "printf statement"
printf("${1:%s}\\n", ${2:message});
$0
endsnippet

# scanf 语句
# 使用方法：输入 sf 然后按 Tab
snippet sf "scanf statement"
scanf("${1:%s}", ${2:&variable});
$0
endsnippet

# ============================================
# [第四步：保存文件后测试]
# 1. 重启 Vim 或重新加载配置：:source ~/.vimrc
# 2. 打开测试文件：vim test.c
# 3. 按 i 进入插入模式，尝试输入 if 然后按 Tab
# 4. 应该看到 if 语句被展开
# ============================================
