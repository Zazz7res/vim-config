

这就教你，最简单的方法是**全选替换**，这样不容易出错。

### 1. 准备新配置
先把你现在的配置改成这样（把 `85` 改成了 `92`，并加上了那两行建议）：

```json
{
  "clangd.path": "clangd",
  "clangd.arguments": [
    "--background-index",
    "--clang-tidy",
    "--header-insertion=iwyu",
    "--completion-style=detailed"
  ],
  "suggest.enablePreselect": true,
  "suggest.noselect": false,
  "coc.source.snippets.priority": 92
}
```

### 2. 在 Vim 中替换（分步操作）

1.  **打开配置文件**
    在 Vim 正常模式下输入：
    ```vim
    :CocConfig
    ```

2.  **删除旧内容**
    按顺序按这三个键：
    *   先按 `gg` （跳到第一行）
    *   再按 `dG` （删除全部内容）

3.  **粘贴新配置**
    *   按 `i` 进入插入模式。
    *   把上面**第一步里的代码块**复制粘贴进去。

4.  **保存并生效**
    *   按 `Esc` 退出插入模式。
    *   输入 `:wq` 保存并退出。
    *   输入 `:CocRestart` 重启服务。

### 3. 验证一下
打开一个 `.c` 文件，输入 `for`，看看菜单第一项是不是 `[S] for`。如果是，那就成功切换到“结构优先流”了！
