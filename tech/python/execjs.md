# pyexecjs
<https://github.com/doloopwhile/PyExecJS>
该库也已经不再维护，作者推荐使用subprocess 的方式调用node

底层实现方式是：在本地 JS 环境下运行 JS 代码
支持的 JS 环境包含：Node.js、PyV8、PhantomJS、Nashorn（默认，基于JVM） 等

由于 PyExecJS 运行在本地 JS 环境下，使用之前会启动 JS 环境，因此初次运行会偏慢

## 安装
`pip install pyexecjs`

安装[node.js](https://nodejs.org/en/download/)

检查使用的引擎：
```py
execjs.get().name
```
安装完Node.js，就会变（因为它会遍历`execjs.runtimes().keys()` 找到第一个可用的）
如果想要自己指定，可以通过设置环境变量EXECJS_RUNTIME，可选的值可以从`from execjs.runtime_names import XX` 进行导入

## 使用
### 模块方法
eval(js_str, cwd=None): 直接执行js 表达式并返回表达式的结果（貌似不能执行语句），即使用js eval 执行字符串
exec_(source, cwd=None): 将source 放进runner_source 中去执行，将标准输出返回（字符串）
compile(js_str, cwd=None): 编译js 代码并返回上下文对象


### 上下文对象方法
call('func_name', *args): 可以直接调用js_str 中定义的函数
eval(source): 将return eval(source) 作为参数调用exec_()
exec_(source): 将上下文对象编译的js_str 和source 连接在一起，放进runner_source 中去执行，将标准输出返回（字符串）


## 使用


# js2py
<https://github.com/PiotrDabkowski/Js2Py>
纯 Python 实现的 JS 解释器，直接将 JS 代码转换为 Python 代码
对于很长的混淆 JS 代码，转译过来的大概率会报错，所以只能尝试不保证稳定

`pip install js2py`

## 使用
```py
js_str = '''function func(s1, s2) {
    return s1 + s2
}
'''

context = js2py.EvalJs()
context.execute(js_str)     # 执行整段JS代码
context.func(1, 2)          # 直接执行函数
```

# PyV8
Google 将 Chrome V8 引擎用 Python 封装的库
它不依赖本地 JS 环境，运行速度很快
由于官方只支持Python2，所以在 Python3 环境下，使用 PyV8 会报各种奇怪的问题，而且[二进制文件](https://github.com/emmetio/pyv8-binaries)也处于废弃状态，所以不推荐使用?

# 直接调用Node.js
```js
// t.js
function concat(s1, s2) {
    // 模糊类型，在js 中既可以是数字加，又可以是字符串连接
    return s1 + s2;
}
function add(num1, num2) {
    // 明确数字加
    return Number(num1) + Number(num2);
}

//新增一个导出函数（node方式）
module.exports.init = function (arg1, arg2) {
    //调用函数，并返回
    console.log(concat(arg1, arg2));
};

// 直接使用命令行参数
console.log(concat(process.argv[2], process.argv[3]))
console.log(add(process.argv[2], process.argv[3]))
```

```py
file = './t.js'
cmd = f'node -e "require(\\"{file}\\").init({arg1}, {arg2})"'

import os
p = os.popen(cmd)
print(p.read())
```