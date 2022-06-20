# FastAPI
[文档](https://fastapi.tiangolo.com/zh/)

需要Python3.6+

高性能，归功于 Starlette（路由部分）和 Pydantic（数据验证）

## 安装
```sh
pip install fastapi
pip install uvicorn     # 服务器
# 或者
pip install fastapi[all]
```

## 快速开始
```py
from fastapi import FastAPI
import uvicorn

# 类似于 app = Flask(__name__)
app = FastAPI()

# 绑定路由和视图函数
@app.get("/")
async def index():
    return {"name": "value"}     # 可以返回任意类型的变量

if __name__ == "__main__":
    # 启动服务，第一个参数 "main:app" 表示main.py 文件中的名为app 的FastAPI 对象，然后是 host 和 port 表示监听的 ip 和端口
    uvicorn.run("main:app", host="0.0.0.0", port=5555)
```
