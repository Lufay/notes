[git home](https://github.com/axios/axios)

基于Promise 的HTTP client

```js
const axios = require('axios')
axios.get(url, config)          // config 可缺省
    .then(res => {
        console.log(typeof res.data)
    })
    .catch(err => {
        console.error(err)
    })
```
axios 会自动解析JSON


并行请求
```js
axios.all([
    axios.get('https://people.xxx.net/exam/examinee/7129451261899834894'),
    axios.get('https://www.cnblogs.com/ltfxy/p/12515307.html')
]).then((resp) => {
    console.log(resp[0].data)
    console.log(resp[1].data)
})
```