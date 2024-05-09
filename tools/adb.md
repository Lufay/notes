# 安装
## macOS
`brew install --cask android-platform-tools`

# 手机连接
`adb devices` 查看设备ID，以及连接状态（device 是正常连接状态；unauthorized 是已经连接上，但手机侧并没有信任这个adb）

# shell
可以使用`adb shell` 进入adb 的shell
也可以`adb shell xxx` 直接执行adb 的shell 命令
以下均为adb shell 命令

## app
`pm list packages` 手机所装的所有app 包名
选项：
-s: 仅列出系统应用
-3: 仅列出第三方应用

## 当前所打开的包
`dumpsys window | grep mCurrentFocus`
其中大括号中包含了app包名/子包

## 清理应用数据
`pm clear $app_pkg_name`
如果清理掉闹钟数据，就会把闹钟应用还原初始设置

## 定时器相关
`dumpsys alarm` 查看所有定时器设置（包括所有应用的定时器设置）

如果想要查看的是设置的闹钟，需要按如下进行过滤：
`dumpsys alarm | grep 'Next wake from idle'`
其中大括号中分别是ID、type、最近一次唤起的时间戳（毫秒）、app包名
