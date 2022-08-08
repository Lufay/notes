# setuptools
打包分发工具
原来distutils 的增强版，能支持具有复杂依赖关系的包

## 安装
```
pip install setuptools
```

## 使用
在项目目录下创建setup.py 文件
<https://packaging.python.org/en/latest/tutorials/packaging-projects/#setup-args>

```py
from setuptools import setup

setup(
    name='app_name',
    version='0.0.1',
    packages=find_packages(exclude=['contrib', 'docs', 'tests*']),
    description='',
    url='github link',
    author='',
    author_email='',
    license='MIT',
    install_requires=[],
    python_requires='>=3',
    package_data={'app1': ['data/*.yml'], '': []},  # 项目内数据文件，不指定目录表示所有
    data_files=[('mydata', ['data/conf.yml'])]     # 项目外数据文件，不能使用路径通配符
)
```

> 安装包的类型：sdist 和 bdist
> sdist 是source distribution，支持的压缩格式有：zip（Windows 默认）、gztar（Unix 默认）、bztar、xztar、ztar、tar
> bdist 是built distribution，由于预先构建好，所以安装更快，支持格式除了上面还有：rpm、pkgtool（Solaris）、sdux（HP-UX swinstall）、wininst（Windows自解压）、msi（Microsoft Installer）
> 
> Wheel 也是一种 built 包，而且是官方推荐的打包方式。
> 优点有：安装更快，C 扩展库不需要编译器，跨平台一致性

```
python setup.py sdist --format=     # 可以指定格式，缺省使用平台默认格式
python setup.py bdist --format=
```
目录下会多出 dist 和 *.egg-info 目录

为了简化操作，setuptools 提供了如下命令：bdist_dumb、bdist_rpm、bdist_wininst、bdist_msi

## 创建wheel
新的包格式，此前是egg。其本质上是zip

### 安装
```
pip install wheel
```

### 使用
#### 直接在项目目录使用
```
python setup.py bdist_wheel
```
可以使用参数 --universal，可以使得wheel 包同时支持 Python2 和 Python3
目录下除了 dist 和 *.egg-info 目录外，还有一个 build 目录用于存储打包中间数据。
而后就可以`pip install dist/app_name-version-py3-none-any.whl` 安装该包到本地 Python 的 site-packages 目录
如果自己在开发中的包，需要频繁变更调试，可以使用开发模式安装（不会拷贝到 site-packages 下），而是除一个指向当前应用的链接（*.egg-link）。这样当前位置的源码改动就会马上反映到 site-packages。
开发模式：`pip install -e .` 或 `python setup.py develop`

#### 指定项目目录
```
pip wheel --wheel-dir=~/whl <project_dir>
```
--wheel-dir 指定生成 .whl 文件的存储位置
project_dir 指定包含 setup.py 文件的项目目录
在项目目录中可以将安装依赖写入到 requirements.txt 文件中，然后用 -r 参数指定，在制作 .whl 安装包时会将 requirements.txt 里的安装依赖写入到 dist-info 里的 METADATA 文件中

## 上传到PyPI
虽然 setuptools 支持使用 setup.py upload 上传包文件到 PyPI，但只支持 HTTP 而被新的 twine 取代

### 安装 twine
```
pip install twine
```

### 使用 twine
```
twine upload dist/*
```
如果不想每次都输入账号密码，可以在home目录下创建 .pypirc 文件