# ========================================
# C 语言代码片段 - UltiSnips配置
# 版本: 1.6 - 最终清理版
# ========================================

# ----------------------------
# 1. 基础结构
# ----------------------------
snippet { "Manual brace block"
{
    $0
}
endsnippet

snippet {{ "Indented brace block"
    {
        $0
    }
endsnippet

# ----------------------------
# 2. 控制结构
# ----------------------------
snippet if "Manual if statement"
if (${1:condition}) {
    $0
}
endsnippet

snippet ife "Manual if-else statement"
if (${1:condition}) {
    ${2:// if code}
} else {
    ${0:// else code}
}
endsnippet

snippet switch "Manual switch statement"
switch (${1:expression}) {
    case ${2:value}:
        ${3:/* code */}
        break;
    ${4:default:
        break;}
}
endsnippet

snippet for "Manual for loop"
for (${1:int i = 0}; ${2:i < N}; ${3:i++}) {
    $0
}
endsnippet

snippet while "Manual while loop"
while (${1:condition}) {
    $0
}
endsnippet

snippet do "Manual do-while loop"
do {
    $0
} while (${1:condition});
endsnippet

# ----------------------------
# 3. 函数定义
# ----------------------------
snippet fun "Manual function definition"
 ${1:void} ${2:function_name}(${3:void}) {
    $0
}
endsnippet

snippet main "Manual main function"
int main(int argc, char *argv[]) {
    $0
    return 0;
}
endsnippet

snippet sfun "Manual static function"
static ${1:void} ${2:function_name}(${3:void}) {
    $0
}
endsnippet

# ----------------------------
# 4. 数据结构
# ----------------------------
snippet struct "Manual struct definition"
struct ${1:name} {
    ${0:/* members */}
};
endsnippet

snippet tstruct "Typedef struct definition"
typedef struct ${1:name} {
    ${2:/* members */}
} ${3:name}_t;
endsnippet

snippet enum "Manual enum definition"
enum ${1:name} {
    ${2:FIRST},
    ${0:/* more values */}
};
endsnippet

snippet union "Manual union definition"
union ${1:name} {
    ${0:/* members */}
};
endsnippet

# ----------------------------
# 5. 输入输出
# ----------------------------
snippet printf "Manual printf statement"
printf("${1:format}", ${2:arguments});
endsnippet

snippet printfl "printf with newline"
printf("${1:format}\\n", ${2:arguments});
endsnippet

snippet dprint "Debug print statement"
printf("DEBUG: %s:%d: ${3:format}\\n", __FILE__, __LINE__, ${4:arguments});
endsnippet

snippet scanf "Manual scanf statement"
scanf("${1:format}", &${2:variable});
endsnippet

# ----------------------------
# 6. 内存管理
# ----------------------------
snippet malloc "Manual malloc allocation"
 ${1:type} *${2:ptr} = malloc(sizeof(${1:type}) * ${3:count});
if (${2:ptr} == NULL) {
    fprintf(stderr, "Memory allocation failed\\n");
    exit(EXIT_FAILURE);
}
 $0
endsnippet

snippet free "Manual memory free"
if (${1:ptr} != NULL) {
    free(${1:ptr});
    ${1:ptr} = NULL;
}
endsnippet

# ----------------------------
# 7. 错误处理
# ----------------------------
snippet check "Error checking macro"
if (${1:condition}) {
    perror("${2:error message}");
    ${3:exit(EXIT_FAILURE);}
}
endsnippet

snippet assert "Manual assert statement"
assert(${1:condition});
endsnippet

# ----------------------------
# 8. 常用宏
# ----------------------------
snippet min "Minimum macro"
#define MIN(a, b) ((a) < (b) ? (a) : (b))
endsnippet

snippet max "Maximum macro"
#define MAX(a, b) ((a) > (b) ? (a) : (b))
endsnippet

snippet arraysize "Array size macro"
#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]))
endsnippet

# ----------------------------
# 9. 文件操作
# ----------------------------
snippet fopen "File open with error check"
FILE *${1:fp} = fopen("${2:filename}", "${3:mode}");
if (${1:fp} == NULL) {
    perror("Failed to open file");
    exit(EXIT_FAILURE);
}
 $0
endsnippet

snippet fclose "File close"
if (${1:fp} != NULL) {
    fclose(${1:fp});
    ${1:fp} = NULL;
}
endsnippet

snippet freadl "File read loop"
char buffer[${1:1024}];
while (fgets(buffer, sizeof(buffer), ${2:fp}) != NULL) {
    ${0:/* process line */}
}
endsnippet

# ----------------------------
# 10. 多文件编程
# ----------------------------
snippet guard "Header guard (Manual Input)"
#ifndef ${1:SYMBOL_NAME}_H
#define ${1:SYMBOL_NAME}_H

 ${2:/* code */}

#endif /* ${1:SYMBOL_NAME}_H */
endsnippet

snippet inc "Include header file"
#include "${1:header.h}"
endsnippet

snippet incsys "Include system header"
#include <${1:stdio.h}>
endsnippet

# ----------------------------
# 11. 调试辅助
# ----------------------------
snippet debug_start "Debug region start"
#ifdef DEBUG
printf("DEBUG: %s:%d: Entering %s\\n", __FILE__, __LINE__, __func__);
#endif
endsnippet

snippet debug_end "Debug region end"
#ifdef DEBUG
printf("DEBUG: %s:%d: Exiting %s\\n", __FILE__, __LINE__, __func__);
#endif
endsnippet

snippet time_start "Start timing"
clock_t ${1:start} = clock();
endsnippet

snippet time_end "End timing"
clock_t ${2:end} = clock();
double ${3:elapsed} = (double)(${2:end} - ${1:start}) / CLOCKS_PER_SEC;
printf("Time elapsed: %.6f seconds\\n", ${3:elapsed});
endsnippet

# ----------------------------
# 12. 算法模板
# ----------------------------
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
    
    return -1; // Not found
}
endsnippet

snippet llnode "Linked list node"
typedef struct node {
    ${1:int} data;
    struct node *next;
} node_t;
endsnippet

# ----------------------------
# 13. 常用代码模式
# ----------------------------
snippet loop "Infinite loop"
while (1) {
    $0
}
endsnippet

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
# 14. 注释快捷方式
# ----------------------------
snippet // "Single line comment"
// $0
endsnippet

snippet /* "Multi-line comment"
/*
 * $0
 */
endsnippet

snippet todo "TODO comment"
// TODO: $0
endsnippet

snippet fixme "FIXME comment"
// FIXME: $0
endsnippet
