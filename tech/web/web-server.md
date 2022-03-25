# Web服务器
本身是资源服务器，它的基本功能是提供Web信息浏览服务（内容分发）。与作为客户端的浏览器配合。

协议：HTTP/HTTPS
文档格式：HTML
统一资源定位：URL

## 作用
1. 最重要的：与众多客户端建立连接，接收request并解析，根据方法、资源和HEADER对请求进行处理（识别对应资源，按方法进行操作），而后构建响应（响应码、响应头部、响应体），响应包括静态资源（文本、图片等）也包括动态响应（委托给其他程序，如CGI脚本等server-side技术）
2. 其他功能：代理转发、负载均衡、缓存

## CGI
早期的web server只能响应静态资源，为了能够响应动态内容（使用应用程序解析请求、响应和渲染）就建立起CGI（Common Gateway Interface）通用网关接口，便于web 服务器和应用程序进行交流。
所以说，CGI 就是二者之间的通信协议，协议规定了通信方式以及不同类型正文的格式。它会把HTTP请求Request的Header头设置成进程的环境变量，HTTP请求的Body正文（比如表单）设置成进程的标准输入，进程的标准输出设置为HTTP响应Response，包含Header头和Body正文（返回的HTML）。
CGI程序也就是实现这个协议的应用程序，当它被服务器调用时，它的环境变量就会多了和请求相关的（来自request的header）、服务器相关的、客户端相关的环境变量。

## 流程
当web 服务器收到一个请求，会根据请求文件的扩展名，按照服务器配置，决定是直接去文件系统中查找并返回，还是使用对应的解析器去解析处理
例如请求的是/index.php，根据配置文件，需要去找PHP解析器来处理，这里的CGI程序就是PHP的解析器。因此，服务器就会起一个PHP进程，接下来PHP解析器会解析php.ini文件，初始化执行环境，然后处理请求，再以规定CGI规定的格式返回处理后的结果，退出进程。

## 性能问题
由于每次请求都需要单独起一个CGI进程，重新读取配置，加载扩展，初始化执行环境，而后才能执行具体的程序逻辑，所以成本和时延都比较大。
一种简单的解法是，将解释器进程内置在服务器中，解释器进程在服务器启动时就启动，每次请求只需要将脚本交给解释器执行即可，但这样两者就高度耦合，如果要修改内置的解释器配置，必须要重启服务器。

### FastCGI
将CGI程序保持在内存中并接收FastCGI进程管理器调度，则可以提供良好的性能、伸缩性、Fail-Over特性等

#### 流程
1. Web服务器启动时载入FastCGI进程管理，如IIS的ISAPI、Apache的Module
2. FastCGI进程管理器（master）进行自身初始化，并启动多个CGI解释器进程（worker）并等待Web服务器的连接（预启动几个根据配置）
3. 当客户端请求到达Web服务器时，FastCGI进程管理器选择并连接一个CGI解释器处理请求
4. FastCGI子进程处理完一个请求后，会接着等待并处理来自FastCGI进程管理器的下一个请求

#### 实现
##### PHP-FPM

## 对象化
由于CGI是基于流的IO 处理，对于面向对象语言并不友好，所以面向对象语言有对其进行友好化的接口协议

### Servlet
Java 的接口协议

### WSGI
Python 的接口协议
组件分为『Server』，『Middleware』和『Application』三种
+ Server：这里指的是Web服务器适配器，比如CGI 适配器就是把os.environ和sys.stdin 转换到environ 参数中，并定义了start_response 函数，传给Application进行调用，而后遍历Application 返回的Iterable，写入到sys.stdout 中
+ Middleware：其本质上是Application 的装饰器，可以嵌套多层
+ Application：其签名为(environ:dict, start_response:Callable) -> Iterable[str]
  其中start_resposne 是一个回调，有两个必选参数和一个可选参数：
  + status: str，表示HTTP响应状态
  + response_headers: list[tuple], 每个元素是一个(name, value) 的二元组，表示响应的headers
  + exc_info: 可选的，用于出错时，server需要返回给浏览器的信息
  返回值是一个字符串的可迭代对象，用于返回响应的body