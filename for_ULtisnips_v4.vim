# ========================================
# C 语言代码片段 - 手动触发
# ========================================

# 基础花括号块 - 手动触发
snippet { "Manual brace block"
{
	$0
}
endsnippet

# if 语句 - 手动触发  
snippet if "Manual if statement"
if (${1:condition}) {
	$0
}
endsnippet

# while 循环 - 手动触发
snippet while "Manual while loop"
while (${1:condition}) {
	$0
}
endsnippet

# for 循环 - 手动触发
snippet for "Manual for loop"
for (${1:int i = 0}; ${2:i < N}; ${3:i++}) {
	$0
}
endsnippet

# 函数定义 - 手动触发
snippet fun "Manual function"
${1:void} ${2:function_name}(${3:void}) {
	$0
}
endsnippet

# 主函数 - 手动触发
snippet main "Manual main function"
int main(int argc, char *argv[]) {
	$0
	return 0;
}
endsnippet

# 结构体定义 - 手动触发
snippet struct "Manual struct definition"
struct ${1:name} {
	${0:/* data */}
};
endsnippet
