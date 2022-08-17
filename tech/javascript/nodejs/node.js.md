开源跨平台js 运行时环境
V8 JavaScript engine
单线程执行，通过异步IO 避免阻塞

# 安装 & 执行
<https://nodejs.dev/en/download/>

执行：`node <js-script> args...`
获取命令行参数使用内置变量process.argv，[0] 就是node, [1] 就是js-script, 后面都是args

[nvm](https://github.com/nvm-sh/nvm) 可以方便进行多版本切换去执行node

[标准库](https://nodejs.org/api/)