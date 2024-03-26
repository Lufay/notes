# 配置


# 快捷键
## 快捷键设置
cmd+k, cmd+s
也可以通过*设置-键盘快捷方式*找到

## 快速定位
### 打开文件
cmd+p
+ 可以直接输入文件名
+ 可以文件名后加 @symbol 可以直接定位到文件中的指定符号上
+ 可以文件名后加 :line_num 可以直接定位到文件中的指定行

### 光标导航
后退：ctrl+-
前进：ctrl+shift+-
到指定的行：ctrl+g
到指定的符号：cmd+shift+o（可以在@ 后面跟一个: 则下拉框会按符号类型进行分组）
到全局的符号：cmd+t（在Markdown 文本中就是目录标题）

## 命令面板
cmd+shift+p

### 工作区命令
将文件夹从工作区删除：可以删除指定vscode项目

## tab 操作
cmd+\ 向右拆分屏
cmd+opt+左右方向键 左右切换tab

## 编辑
行复制：shift+alt+Up/Down
行删除：cmd+x

### 多行编辑
+ alt 可以点选多行
+ alt+shift 可以块状圈选
+ alt+cmd 可以使用Up/Down 键选多行
+ cmd+d/u 可以基于已经选中的内容，向后找到下一个相同内容选中/取消最近一个选中内容
  + cmd+k, cmd+d 可以取消最近一个选中的内容，然后选中下一个

ctrl+j 多行使用空格连接

### 输入建议
opt+esc
ctrl+空格: 这个会和输入法切换冲突

### 代码生成
源代码操作：cmd+k, cmd+g

### 代码段操作
格式化：shift+alt+f
折叠/展开：`cmd+alt+[`/`]`

# 功能和技巧
删除空白行：正则替换`^\s*(?=\r?$)\n` 为空
拆分多行：正则正则替换为`\n`

## 侧边栏
+ 资源管理器：项目的目录结构
+ 大纲：当前文件代码或Markdown 文本的目录结构
+ 时间线：当前文件的不同时间点保存的内容diff

## 代码调试
### 配置launch.json文件
在菜单选择*运行-添加配置*，然后选择要执行的语言，就会在项目根目录生成一个 .vscode 文件夹，其中就包含了launch.json 配置

#### Go
若想要vscode 识别go mod 的模式，必须打开的目录是go.mod 所在的目录

调试需要dlv 的调试工具，可以使用命令面板中的"Go: install/update tools" 来安装，或者使用`go get github.com/go-delve/delve/cmd/dlv`（会装到$GOPATH/bin下），或者使用`GOBIN=/tmp/ go install github.com/go-delve/delve/cmd/dlv@master && mv /tmp/dlv $GOPATH/bin`
支持基于启动程序（launch）的调试和基于运行进程（attach）的调试
```json
[
  {
      "name": "Attach to Process",
      "type": "go",
      "request": "attach",
      "mode": "local",
      "processId": 53575
  },
  {
      "name": "Launch Package",
      "type": "go",
      "request": "launch",
      "mode": "auto",
      "program": "${relativeFile}"
  },
  {
    "name": "Connect to server",
    "type": "go",
    "request": "attach",  // launch 对应program
    "mode": "remote",
    "remotePath": "{编译的项目路径}", // 不是进程当前的目录，也不是本地项目的代码目录，而是编译二进制的项目目录
    "port": 2345,   // dlv server 启动的端口
    "host": "192.168.56.12"
  }
]
```

远程调试可以开启一个dlv dap 服务器，然后可以attach 到对应的进程上
`dlv --headless -l 0.0.0.0:2345 attach 7488 --api-version 2`


### Logpoints
调试运行时可以打印日志消息到调试工作台（日志中可以使用{exp}来引用变量表达式，如同f-string）
1. 在左边栏可以添加记录点
2. 也可以编辑断点而后选择日志消息

# 插件