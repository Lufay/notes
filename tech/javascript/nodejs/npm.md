node.js 的包管理工具

# 命令
## 安装
npm i/install XXX
XXX可以是module name，后面也可以接`@version` 从而指定版本

# 配置
可以通过`npm config get userconfig`命令查看配置文件位置
一般会得到用户级的配置文件，即`~/.npmrc`
其余还有，项目级、全局级（`$PREFIX/etc/npmrc`）、命令级
其中PREFIX 可以通过`npm config get prefix`获取

## 更换源
默认：https://registry.npmjs.org/
淘宝源：`npm config set registry http://registry.npm.taobao.org/`
查看：`npm config get registry`

# package.json
必须是纯JSON的

