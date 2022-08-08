# pip
<https://pip.pypa.io/en/stable/>
包管理的命令行工具

## 下载、安装和卸载
```
pip install <pkg specifier>
pip install -r <requirements file>
pip install -e <local path>
pip install -e <vcs name>+<vcs link>

pip download <pkg specifier>
pip download -r <requirements file>
pip download <local path>
pip download <vcs name>+<vcs link>

pip uninstall <pkg>
```
download 是下载包不安装
卸载是`<pkg>` 只需要包的名字即可（并不会连带卸载依赖）
而安装时，`<pkg_specifier>` 可以有多种格式：
+ 单独名字：SomeProject
+ 指定版本：SomeProject==1.3
+ 仅指定大版本，小版本取最新稳定版：SomeProject~=3.0（相当于>=3.0, ==3.*）
+ 限定版本范围：SomeProject >= 1.2, < 2.0（可以使用>, <, >=, <=, !=）
+ 指定环境标识：SomeProject == 5.4 ; python_version < '3.8' 或 SomeProject ; sys_platform == 'win32'

*可以使用SomeProject== 来查看一个包所有可安装的版本号，而不真正去安装*

-r 要求文件格式是freeze 格式的（一般是使用==，可以手动修改为满足`<pkg_specifier>`格式）
local path 直接指定到包文件（比如.whl）的路径
-e 表示可编辑，因为依赖的本地或vcs 都是可以随时修改变更的

`<vcs name>` 包括了
+ Git -- git+
+ Mercurial -- hg+
+ Subversion -- svn+
+ Bazaar -- bzr+

### 下载选项
`-d, --dest <dir>`: 可以指定下载目录

### 安装选项
-U, --upgrade: 将包更新为最新的可用版本（依赖如何更新根据选择的更新策略配置而不同）
`--upgrade-strategy <stg>`: 默认stg 是only-if-needed，即当依赖不满足新版本的要求才更新；若选eager，则无论是否满足都更新
`-i, --index-url <url>`: 指定包仓库的索引地址，即所谓的源，默认为 https://pypi.org/simple
`--extra-index-url <url>`: 额外的包仓库索引地址
`-f, --find-links <url>`: 指定查找路径，可以是一个本地路径，或者一个 HTML 文件链接（实现离线安装）
--no-index: 忽略包仓库地址（通常与 --find-links 配合使用）
--no-deps: 不安装依赖包（默认会连带安装依赖）
--pre: 包含预发布版本或开发测试版本，默认只搜索稳定版

`--trusted-host <domain>`: domain 可以是host 也可以是host:port，用于index-url 置信

### 示例
```
pip install -e git+https://github.com/django/django.git#egg=django
pip install -e git+ssh://git@github.com:django/django.git#egg=django
pip install -e git+file:///path/to/git_dir#egg=project
```

## 配置
`pip config list`: 查看当前所有配置
`pip config [--editor <editor>] edit`: 使用指定的编辑器编辑配置
`pip config get global.index-url`: 获取指定配置
`pip config set global.index-url <url>`: 配置全局index-url
`pip config unset global.index-url`: 取消指定配置

`pip config set install.trusted-host mirrors.aliyun.com`

pip 在各平台上都会优先加载 PIP_CONFIG_FILE 环境变量指定的配置

### 配置选项
--global: 使用系统级配置（/etc/pip.conf、/Library/Application Support/pip/pip.conf、C:\ProgramData\pip\pip.ini）
--user: 使用用户级配置（$HOME/.config/pip/pip.conf、$HOME/.config/pip/pip.conf、%APPDATA%\pip\pip.ini）
--site: 使用当前的环境配置（$VIRTUAL_ENV/pip.conf）

国内镜像源：
+ 清华：https://pypi.tuna.tsinghua.edu.cn/simple/
+ 豆瓣：https://pypi.doubanio.com/simple/
  + http://pypi.douban.com/simple/
+ 阿里：https://mirrors.aliyun.com/pypi/simple/
+ 腾讯：https://mirrors.cloud.tencent.com/pypi/simple/
+ 华为：https://mirrors.huaweicloud.com/repository/pypi/simple/
+ 中科大：https://pypi.mirrors.ustc.edu.cn/simple/
  + http://pypi.mirrors.ustc.edu.cn/simple/
+ 华中理工：https://pypi.hustunique.com/
+ 山东理工：https://pypi.sdutlinux.org/

## 列出已装的包
`pip list` 默认使用多列格式，结果包含安装工具包
`pip freeze` 默认使用requirements 格式，默认不带安装工具包（这种方式生成的requirements文件包含了大量的二级依赖，这些依赖其实并非强制==，而是一个范围，所以对于非强制二级依赖，最好不要包含进来，否则很容易就会冲突，有个比较好用的工具就是pipreqs）

### list选项
-o, --outdated: 列出可升级的包，和响应的最新版本以及格式类型
-u, --uptodate: 列出已更新到最新的包
-e: 列出可编辑的包
--not-required: 列出没有被依赖的包
`--exclude <pkg>`: 将指定包从结果中排除
-l, --local: 在virtualenv 下使用，若virtualenv 拥有全局的依赖，则使用该选项仅显示当前virtualenv 的包
`--format <list_format>`: columns (default), freeze, json
`-i, --index-url <url>`
`--extra-index-url <url>`

### freeze 选项
`-r, --requirement <file>`: 使用其指定的顺序和comments 进行输出
-l, --local: 在virtualenv 下使用，若virtualenv 拥有全局的依赖，则使用该选项仅显示当前virtualenv 的包
--all: 包含安装工具包（distribute, pip, setuptools, wheel）
`--exclude <pkg>`: 将指定包从结果中排除
--exclude-editable: 将可编辑的包从结果中排除

## 查看安装包信息
`pip show <pkg>`
显示的Requires 和Required-by 可以看到直接的依赖和被依赖包
想要查看依赖树，还是pipdeptree 更好用

### 选项
-f, --files: 显示完整的文件列表

## 依赖检查
`pip check`
检查是否有依赖冲突或依赖不足的包

## 缓存
pip cache dir: 获取缓存目录
pip cache info: 获取缓存统计信息
`pip cache list [<pattern>] [--format=[human, abspath]]`: 获取缓冲的包文件和大小
`pip cache remove <pattern>`: 从缓存中移除包
pip cache purge: 清空缓存

## 搜索
`pip search <pkg>`
由于PyPI server 为了防御DDoS 攻击，所以禁用了XMLRPC，所以该功能不可用，会有以下报错：
ERROR: XMLRPC request failed [code: -32500]

所以，只能在[平台](https://pypi.org/)上搜索
或者安装使用`pip-search` 这个包或者[pypi-simple-search](https://github.com/jeffmm/pypi-simple-search) 这个脚本工具（本质上，都还是请求前者平台并渲染返回）

# pipdeptree
默认显示所有安装的包依赖，还会检查循环依赖

## 选项
-a, --all: 从依赖树的顶层显示依赖关系
-p PACKAGES, --packages PACKAGES: 指定查看的包（忽略-a 选项）多个使用逗号分隔
-e PACKAGES, --exclude PACKAGES: 指定不想查看的包（忽略-a 选项）多个使用逗号分隔
-r, --reverse: 从被依赖方反向查询其依赖（默认是依赖方在上，使用该选项是被依赖方在上）
--python PYTHON: 指定Python（从而检查该Python 使用的包依赖）
-l, --local-only: 在virtualenv 下使用，若virtualenv 拥有全局的依赖，则使用该选项仅显示当前virtualenv 的包
-f, --freeze: 以freeze 格式打印树形依赖
-j, --json: 以json 格式打印依赖关系（dependencies 不会进行深度嵌套）
--json-tree: 以json 格式打印依赖关系（dependencies 会进行深度嵌套）
--graph-output OUTPUT_FORMAT: 使用GraphViz 打印依赖图，OUTPUT_FORMAT可以是dot, jpeg, pdf, png, svg

# pipreqs
会分析当前项目import的依赖，并且只导出当前项目需要的包
`pip install pipreqs`

## 用法
`pipreqs [options] [<path>]`
path 就是想要生成requirements 文件的项目根路径，默认是当前目录

### 选项
--print: 不保存文件，而是把equirements 标准输出出来
`--savepath <file>`: 为生成的requirements指定文件，默认是path 下的requirements.txt
--force: 若指定位置已经有requirements.txt，则强制覆盖
`--diff <file>`: 和指定的requirements 文件进行比较
`--clean <file>`: 将指定的requirements 文件中项目未导入的依赖清除
`--mode <scheme>`: 动态依赖：compat（~=）、gt（>=）、non-pin（不标注版本）
`--pypi-server <url>`: 使用自定义的PyPi
`--ignore <dirs>...`: 忽略的目录（多个用逗号分隔）
--no-follow-links: 不管符号链接