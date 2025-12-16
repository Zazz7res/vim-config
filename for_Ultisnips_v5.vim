# ========================================
# C 语言代码片段 - 智能手动触发
# 版本: 1.2 - 增强版
# ========================================

# ----------------------------
# 1. 基础结构
# ----------------------------

# 基础花括号块
snippet { "Manual brace block"
{
	$0
}
endsnippet

# 带缩进的花括号块
snippet {{ "Indented brace block"
	{
		$0
	}
endsnippet

# ----------------------------
# 2. 控制结构
# ----------------------------

# if 语句
snippet if "Manual if statement"
if (${1:condition}) {
	$0
}
endsnippet

# if-else 语句
snippet ife "Manual if-else statement"
if (${1:condition}) {
	${2:// if code}
} else {
	${0:// else code}
}
endsnippet

# if-else if-else 链
snippet ifee "Manual if-else if chain"
if (${1:condition}) {
	${2:// if code}
} else if (${3:condition}) {
	${4:// else if code}
} else {
	${0:// else code}
}
endsnippet

# switch 语句
snippet switch "Manual switch statement"
switch (${1:expression}) {
	case ${2:value}:
		${3:/* code */}
		break;
	${4:default:
		break;}
}
endsnippet

# while 循环
snippet while "Manual while loop"
while (${1:condition}) {
	$0
}
endsnippet

# do-while 循环
snippet do "Manual do-while loop"
do {
	$0
} while (${1:condition});
endsnippet

# for 循环 - 基础版
snippet for "Manual for loop"
for (${1:int i = 0}; ${2:i < N}; ${3:i++}) {
	$0
}
endsnippet

# for 循环 - 遍历数组
snippet fori "Manual for loop for array"
for (int i = 0; i < ${1:length}; i++) {
	${2:array}[i] = $0;
}
endsnippet

# for 循环 - 遍历指针
snippet forp "Manual for loop with pointer"
for (${1:int} *p = ${2:array}; p < ${2:array} + ${3:length}; p++) {
	*p = $0;
}
endsnippet

# ----------------------------
# 3. 函数定义
# ----------------------------

# 函数定义
snippet fun "Manual function definition"
${1:void} ${2:function_name}(${3:void}) {
	$0
}
endsnippet

# 主函数
snippet main "Manual main function"
int main(int argc, char *argv[]) {
	$0
	return 0;
}
endsnippet

# 带参数的函数
snippet funp "Manual function with parameters"
${1:int} ${2:function_name}(${3:int arg1}, ${4:char *arg2}) {
	$0
}
endsnippet

# 静态函数
snippet sfun "Manual static function"
static ${1:void} ${2:function_name}(${3:void}) {
	$0
}
endsnippet

# 内联函数
snippet ifun "Manual inline function"
inline ${1:void} ${2:function_name}(${3:void}) {
	$0
}
endsnippet

# 函数原型声明
snippet proto "Function prototype"
${1:void} ${2:function_name}(${3:void});
endsnippet

# ----------------------------
# 4. 数据结构
# ----------------------------

# 结构体定义
snippet struct "Manual struct definition"
struct ${1:name} {
	${0:/* members */}
};
endsnippet

# 结构体定义带 typedef
snippet tstruct "Typedef struct definition"
typedef struct ${1:name} {
	${2:/* members */}
} ${3:name}_t;
endsnippet

# 枚举定义
snippet enum "Manual enum definition"
enum ${1:name} {
	${2:FIRST},
	${0:/* more values */}
};
endsnippet

# 联合体定义
snippet union "Manual union definition"
union ${1:name} {
	${0:/* members */}
};
endsnippet

# ----------------------------
# 5. 输入输出
# ----------------------------

# printf 语句
snippet printf "Manual printf statement"
printf("${1:format}", ${2:arguments});
endsnippet

# 带换行的 printf
snippet printfl "printf with newline"
printf("${1:format}\\n", ${2:arguments});
endsnippet

# 调试打印
snippet dprint "Debug print statement"
printf("DEBUG: %s:%d: " ${3:format} "\\n", __FILE__, __LINE__, ${4:arguments});
endsnippet

# scanf 语句
snippet scanf "Manual scanf statement"
scanf("${1:format}", &${2:variable});
endsnippet

# ----------------------------
# 6. 内存管理
# ----------------------------

# malloc 分配内存
snippet malloc "Manual malloc allocation"
${1:type} *${2:ptr} = (${1:type} *)malloc(sizeof(${1:type}) * ${3:count});
if (${2:ptr} == NULL) {
	fprintf(stderr, "Memory allocation failed\\n");
	exit(EXIT_FAILURE);
}
$0
endsnippet

# calloc 分配内存
snippet calloc "Manual calloc allocation"
${1:type} *${2:ptr} = (${1:type} *)calloc(${3:count}, sizeof(${1:type}));
if (${2:ptr} == NULL) {
	fprintf(stderr, "Memory allocation failed\\n");
	exit(EXIT_FAILURE);
}
$0
endsnippet

# realloc 重新分配内存
snippet realloc "Manual reallocation"
${1:ptr} = realloc(${1:ptr}, ${2:new_size});
if (${1:ptr} == NULL) {
	fprintf(stderr, "Memory reallocation failed\\n");
	exit(EXIT_FAILURE);
}
$0
endsnippet

# 释放内存
snippet free "Manual memory free"
if (${1:ptr} != NULL) {
	free(${1:ptr});
	${1:ptr} = NULL;
}
endsnippet

# ----------------------------
# 7. 错误处理
# ----------------------------

# 错误检查宏
snippet check "Error checking macro"
if (${1:condition}) {
	perror("${2:error message}");
	${3:exit(EXIT_FAILURE);}
}
endsnippet

# 带返回值的错误检查
snippet checkr "Error check with return"
if (${1:condition}) {
	perror("${2:error message}");
	return ${3:-1};
}
endsnippet

# 断言
snippet assert "Manual assert statement"
assert(${1:condition});
endsnippet

# ----------------------------
# 8. 常用宏
# ----------------------------

# 最小值宏
snippet min "Minimum macro"
#define MIN(a, b) ((a) < (b) ? (a) : (b))
endsnippet

# 最大值宏
snippet max "Maximum macro"
#define MAX(a, b) ((a) > (b) ? (a) : (b))
endsnippet

# 数组大小宏
snippet arraysize "Array size macro"
#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]))
endsnippet

# 安全释放宏
snippet safefree "Safe free macro"
#define SAFE_FREE(ptr) do { \
	if ((ptr) != NULL) { \
		free(ptr); \
		(ptr) = NULL; \
	} \
} while(0)
endsnippet

# ----------------------------
# 9. 测试框架
# ----------------------------

# 单元测试函数
snippet test "Unit test function"
void test_${1:function_name}(void) {
	${2:/* setup */}
	
	${3:/* test code */}
	
	${4:/* verification */}
	
	printf("test_${1:function_name}: PASS\\n");
}
endsnippet

# 测试断言
snippet test_assert "Test assertion"
if (!(${1:condition})) {
	fprintf(stderr, "Test failed: %s:%d: %s\\n", 
		__FILE__, __LINE__, "${2:message}");
	return ${3:-1};
}
endsnippet

# ----------------------------
# 10. 文件操作
# ----------------------------

# 文件打开
snippet fopen "File open with error check"
FILE *${1:fp} = fopen("${2:filename}", "${3:mode}");
if (${1:fp} == NULL) {
	perror("Failed to open file");
	exit(EXIT_FAILURE);
}
$0
endsnippet

# 文件关闭
snippet fclose "File close"
if (${1:fp} != NULL) {
	fclose(${1:fp});
	${1:fp} = NULL;
}
endsnippet

# 读文件循环
snippet freadl "File read loop"
char buffer[${1:1024}];
while (fgets(buffer, sizeof(buffer), ${2:fp}) != NULL) {
	${0:/* process line */}
}
endsnippet

# ----------------------------
# 11. 多文件编程
# ----------------------------

# 头文件保护宏
snippet guard "Header guard"
#ifndef ${1/(.*)/\U\1\E/}_H
#define ${1/(.*)/\U\1\E/}_H

${2:/* code */}

#endif /* ${1/(.*)/\U\1\E/}_H */
endsnippet

# 包含头文件
snippet inc "Include header file"
#include "${1:header.h}"
endsnippet

# 包含系统头文件
snippet incsys "Include system header"
#include <${1:stdio.h}>
endsnippet

# 前置声明
snippet forward "Forward declaration"
typedef struct ${1:name} ${1:name};
endsnippet

# ----------------------------
# 12. 调试辅助
# ----------------------------

# 调试标记开始
snippet debug_start "Debug region start"
#ifdef DEBUG
printf("DEBUG: %s:%d: Entering %s\\n", __FILE__, __LINE__, __func__);
#endif
endsnippet

# 调试标记结束
snippet debug_end "Debug region end"
#ifdef DEBUG
printf("DEBUG: %s:%d: Exiting %s\\n", __FILE__, __LINE__, __func__);
#endif
endsnippet

# 计时开始
snippet time_start "Start timing"
clock_t ${1:start} = clock();
endsnippet

# 计时结束
snippet time_end "End timing"
clock_t ${2:end} = clock();
double ${3:elapsed} = (double)(${2:end} - ${1:start}) / CLOCKS_PER_SEC;
printf("Time elapsed: %.6f seconds\\n", ${3:elapsed});
endsnippet

# ----------------------------
# 13. 算法模板
# ----------------------------

# 二分查找
snippet binary_search "Binary search algorithm"
int binary_search(${1:int} arr[], int size, ${1:int} target) {
	int left = 0;
	int right = size - 1;
	
	while (left <= right) {
		int mid = left + (right - left) / 2;
		
		if (arr[mid] == target) {
			return mid;
		} else if (arr[mid] < target) {
			left = mid + 1;
		} else {
			right = mid - 1;
		}
	}
	
	return -1; // 未找到
}
endsnippet

# 快速排序
snippet quicksort "Quick sort algorithm"
void quicksort(${1:int} arr[], int left, int right) {
	if (left >= right) return;
	
	int i = left, j = right;
	${1:int} pivot = arr[(left + right) / 2];
	
	while (i <= j) {
		while (arr[i] < pivot) i++;
		while (arr[j] > pivot) j--;
		
		if (i <= j) {
			${1:int} temp = arr[i];
			arr[i] = arr[j];
			arr[j] = temp;
			i++;
			j--;
		}
	}
	
	quicksort(arr, left, j);
	quicksort(arr, i, right);
}
endsnippet

# 链表节点
snippet llnode "Linked list node"
typedef struct node {
	${1:int} data;
	struct node *next;
} node_t;
endsnippet

# ----------------------------
# 14. 常用代码模式
# ----------------------------

# 无限循环
snippet loop "Infinite loop"
while (1) {
	$0
}
endsnippet

# 延迟循环
snippet delay "Delay loop"
for (volatile int i = 0; i < ${1:1000000}; i++);
endsnippet

# 简单的状态机
snippet state "Simple state machine"
typedef enum {
	STATE_${1:IDLE},
	STATE_${2:RUNNING},
	STATE_${3:ERROR}
} state_t;

state_t current_state = STATE_${1:IDLE};

switch (current_state) {
	case STATE_${1:IDLE}:
		${4:/* idle code */}
		break;
	case STATE_${2:RUNNING}:
		${5:/* running code */}
		break;
	case STATE_${3:ERROR}:
		${6:/* error handling */}
		break;
}
endsnippet

# ----------------------------
# 15. 代码片段快捷方式
# ----------------------------

# 单行注释
snippet // "Single line comment"
// $0
endsnippet

# 多行注释
snippet /* "Multi-line comment"
/*
 * $0
 */
endsnippet

# TODO 注释
snippet todo "TODO comment"
// TODO: $0
endsnippet

# FIXME 注释
snippet fixme "FIXME comment"
// FIXME: $0
endsnippet

# NOTE 注释
snippet note "NOTE comment"
// NOTE: $0
endsnippet

# ----------------------------
# 配置结束
# ----------------------------
