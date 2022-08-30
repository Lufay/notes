[git home](https://github.com/visionmedia/superagent)

```js
const superagent = require('superagent');

superagent.get('https://api.nasa.gov/planetary/apod')
.query({ api_key: 'DEMO_KEY', date: '2017-08-02' })
.end((err, res) => {
  if (err) { return console.log(err); }
  console.log(res.body.url);            // 自动解析JSON
  console.log(res.body.explanation);
});
```