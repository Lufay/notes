# virtualenv
作用：生成虚拟化的运行环境，避免和其他项目由于依赖版本差异而导致的各种问题

## 安装
```sh
pip install virtualenv  # python3 用 pip3
# 或
apt-get install python-virtualenv
```

## 使用
在项目目录下使用`virtualenv venv` 命令，生成名为venv 文件夹的当前项目的虚拟环境。在Python3.3 之后（内置模块），还可以使用`python3 -m venv $venv_dir` 创建虚拟环境
而后使用`source venv/bin/activate` 就可以激活虚拟化环境
在虚拟化环境下使用`pip install` 安装的包就都只在当前项目下生效，不会污染系统环境
最后使用`deactivate` 退出虚拟化环境

### 选项
-p PYTHON_EXE：可以指定Python 解释器版本。默认使用的是当前系统安装(/usr/bin/python)的python解析器
--clear 清理重建环境
--no-site-packages （默认）令隔离环境不能访问系统全局的site-packages目录（不使用本机已安装的包）
--system-site-packages 令隔离环境可以访问系统全局的site-packages目录
--never-download 禁止从网上下载任何数据。如果在本地搜索发布包失败，virtualenv就会报错
--extra-search-dir=SEARCH_DIRS 用于查找setuptools/distribute/pip发布包的目录，可以添加多个
--relocatable 重定位某个已存在的隔离环境。使用该选项将修正脚本并令所有.pth文件使用相当路径

## 关联的
### 导出导入依赖
`pip freeze > requirements.txt` 可以导出当前环境安装的依赖
`pip install -r requirements.txt` 可以按requirements文件导入依赖

### virtualenvwrapper
可以集中管理多个虚拟环境

#### 安装&激活
要确保 virtualenv 已经安装了
```sh
pip install virtualenvwrapper
export WORKON_HOME=~/Envs  # 设置集中存放的虚拟环境目录
source /path/to/virtualenvwrapper.sh # 激活，该文件一般是在python解释器中的site-packages中
```

#### 使用
`mkvirtualenv project_env` 创建一个项目的虚拟环境，可以使用--python= 指定解释器
`workon project_env` 在虚拟环境上工作，也可以在各个环境做切换，virtualenvwrapper 提供环境名字的tab补全功能
`deactivate` 停止虚拟环境
`rmvirtualenv project_env` 删除虚拟环境
lsvirtualenv    # 列举所有的环境。
cdvirtualenv    # 导航到当前激活的虚拟环境的目录中，比如说这样您就能够浏览它的 site-packages。
cdsitepackages  # 和上面的类似，但是是直接进入到当前环境的 site-packages 目录中。
lssitepackages  # 显示当前环境 site-packages 目录中的内容（安装了哪些包）。
toggleglobalsitepackages    # 控制当前环境是否使用global site-packages
`cpvirtualenv [source] [dest]`  # 复制虚拟环境
