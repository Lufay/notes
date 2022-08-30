[git home](https://github.com/jsdom/jsdom)

```js
const {JSDOM} = require("jsdom");
// const url = require('url');
// const html_url = url.pathToFileURL(html_file)
// const html_file = url.fileURLToPath(html_url)
const {document} = new JSDOM(html_data, {"runScripts":"dangerously",
                                        "resources":"usable",
                                        url: html_url.href}).window
console.log(document.body.childElementCount)
document.addEventListener('DOMContentLoaded', () => {
    setImmediate(() => {
        console.log(document.body.children[0].outerHTML)
    })
})
```

由于node 没有宿主对象，所以需要使用库来模拟浏览器对象
html_data 是html 的字符串
option 的配置对象中url 可以辅助html_data 中的src 进行路径解析，否则将无法下载相关资源（如果是本地文件可以使用url 库获取本地文件的URI 路径）
默认jsdom 并不会解析HTML 中的js 脚本，需要option 设置"runScripts":"dangerously", 才能解析内嵌的js 脚本，而想要解析src 中的脚本，则还需要"resources":"usable"

对于defer 的script 由于是异步执行的，所以注册DOMContentLoaded 事件可以确保对应的js 脚本已经生效

jsdom 无法对window.location 变更进行模拟，所以对于该js 语句会报错