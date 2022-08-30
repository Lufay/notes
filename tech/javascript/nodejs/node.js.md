<http://nodejs.cn/learn/introduction-to-nodejs>
开源跨平台js 运行时环境
V8 JavaScript engine
单线程执行，通过异步IO 避免阻塞

# 安装 & 执行
<https://nodejs.dev/en/download/>

执行：`node <js-script> args...`
获取命令行参数使用内置变量process.argv，[0] 就是node, [1] 就是js-script, 后面都是args
获取环境变量使用process.env

[nvm](https://github.com/nvm-sh/nvm) 可以方便进行多版本切换去执行node

[标准库](https://nodejs.org/api/)

# 库
## IO
```js
const fs = require('fs')

fs.readFile(html_file, 'utf8', (err, data) => {
    if (err) {
        console.error(err)
        return
    }
    // process data(Buffer)
})

let data
try {
    data = fs.readFileSync('./server.js', 'utf8')   // 有encoding 返回string，缺省则返回buffer
    console.log(data.toString())
} catch (err) {
    console.error(err.message)
} finally {
    console.log('end')
}
```

### http/https
#### server 端
```js
const http = require('http')

const hostname = '127.0.0.1'
const port = 3000

const server = http.createServer((req, res) => {
    /**
     * req: http.IncomingMessage
     * res: http.ServerResponse 
     */
    let file
    if (/\/.*\.js/.test(req.url)) {
      file = req.url
    } else {
      file = '/a.html'
    }
    const fs = require('fs')
    fs.readFile(__dirname + file, (err, data) => {
      if (err) {
        console.error(err.message)
        res.statusCode = 400
        res.setHeader('Content-Type', 'text/plain')
        res.end(err.message)
        return
      }
      res.statusCode = 200
      res.setHeader('Content-Type', ' text/html')
      res.end(data.toString())
    })
})

server.listen(port, hostname, () => {
    // 通知server 已启动
    console.log(`Server running at http://${hostname}:${port}/`)
})
```

#### client 端
```js
const https = require('https')

https.get(url, (resp) => {
    const {statusCode} = resp
    const contType = resp.headers['content-type']
    let err
    if (statusCode !== 200) {
        err = new Error(`request failed with code ${statusCode}`)
    } else if (!/^text\/html/.test(contType)) {
        err = new Error(`invalid content-type of ${contType}`)
    }
    if (err) {
        console.error(err.message)
        resp.resume()
        return
    }

    let rawData = ''
    resp.on('data', (chunk) => {    // data 事件，chunk 数据，并不完整
        rawData += chunk
    })
    resp.on('end', () => {          // end 事件，数据传输结束
        console.log(JSON.parse(rawData))
    })
}).on('error', (err) => {
    console.error(err.message)
})
```

[request](https://github.com/request/request) 这个三方包已经废弃
可以考虑[bent](https://github.com/mikeal/bent)，axios/superagent/got 等三方库