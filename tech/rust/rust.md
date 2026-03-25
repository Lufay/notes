Rust
[官方文档](https://doc.rust-lang.org/)
[官方文档中文版](https://www.rust-lang.org/zh-CN/)
[Rust 程序设计语言](https://doc.rust-lang.org/stable/book/)
[Rust 程序设计语言](https://www.gitbook.com/book/kaisery/rust-book-chinese/details)
[极客学堂](http://wiki.jikexueyuan.com/project/rust)
[REPL](https://play.rust-lang.org/?version=stable&mode=debug)
[TOC]

# Rust 概述
+ Memory safety without garbage collection
RAII, ownership, borrow, lifetime
+ Concurrency without data races
actor
+ Abstraction without overhead
基于Trait 的泛型
+ Cargo 包管理器
Cargo 是Rust 的构建和打包工具
+ 基于trait，非面向对象
不支持继承
+ 函数可以作为变量传递（闭包）
+ 静态分发
编译器可以极大地优化代码，也无需安装依赖共享库

## 安装
Rustup：Rust 安装器和版本管理工具

安装Rustup：`curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh`
安装成功之后，同时也会获得cargo、rustc（编译器）、rustfmt（代码格式化）、clippy（链接器）
默认情况下，这些命令行工具都被安装到`~/.cargo/bin`下，可以将该路径添加到PATH环境变量中（默认rustup安装时会试图配置）

更新Rust：`rustup update`
查看本地Rust文档：`rustup doc`

卸载：`rustup self uninstall`

其他平台的安装方式参考：<https://rust-lang.github.io/rustup/installation/other.html>

## Cargo
创建项目：`cargo new hello-rust`（默认生成Hello, world!）`cargo init`（在当前目录下生成）
构建项目：`cargo build`（下载依赖并编译）
运行项目：`cargo run`（构建并执行）
测试项目：`cargo test`
构建文档：`cargo doc`（生成当前项目的HTML文档，也包括每个依赖的文档）
发布库到crates.io：`cargo publish`
增加依赖到项目：`cargo add [lib-name]`

### 项目文件结构
Cargo.toml：项目元信息manifest（包括依赖，每一个依赖被称为crate）
src/main.rs：程序代码

#### 添加依赖
比如想要使用ferris-says 这个crate
+ 方法1
可以在Cargo.toml 文件中添加如下内容：
```toml
[dependencies]
ferris-says = "0.3.1"
```
+ 方法2
使用命令`cargo add ferris-says`

然后在代码中引入这个crate的一个函数：`use ferris_says::say;`

构建后会生成Cargo.lock 这个构建日志，里面包括了所有依赖实际的版本信息
构建成果都被放进target/目录中

#### 主函数
```rust
fn main() {

}
```

# 语法
## 创建变量（变量绑定）
```rust
let a = 10;          // 类型推断
let b: i64 = 1_000_000;     // 声明类型
let c = 30i32;       // 数字字面值的类型注解
let d = 30_i32;      // 数字字面值的类型注解（增加可读性）
```
赋值语句的返回是空类型()
drop() 变量解绑
数据默认不可变（只读）

### 变量存储
10 栈中的整数
Box::new(10); 整数装箱，放在堆上
Rc::new(Box::new(10)); 包装引用计数
Arc::new(Mutex::new(10)); 包装原子引用计数，并互斥锁保护

### 变量所有权
&var 借用，只读访问

## 类型

### 数字类型
类型转换必须是显式的
带类型注解的字面值可以使用方法，比如`2.5_f32.round()`

#### 方法
pow(n) n次幂

### 字符串
字符串使用双引号，单引号表示字符（char）
支持Unicode，需要确保UTF-8编码
字符串字面值支持多行，行末的\可以忽略该行的换行符

#### 方法
lines() 返回一个分行迭代器
trim()
len()
split(',')
parse::<f32>() 试图解析为一个浮点数
clone() 返回一个拷贝

### 数组
数组可以直接用[]列举（默认是静态数组），或用
let mut letters = vec!["a", "b", "c"];  创建可变动态数组
let mut grains: Vec<Cereal> = vec![]; 初始化空数组
let buffer = &mut[0u8; 1024]； 将一个可变数组（1024个无符号8为整数，初始化为0）的引用绑定到变量buffer

#### 方法
push(e)
map(lambda).collect()

### 枚举
enum Cereal {
    Barley, Millet, Rice,
    Rye, Spelt, Wheat,
}
Cereal::Rye 访问

### 迭代器
很多类型都有iter()方法，返回一个迭代器
迭代器可以使用enumerate() 方法，生成另一个迭代器，可以同时遍历索引和元素

### 类型注解
let fields: Vec<_> 动态数组，下划线是让rust自己根据赋值推断元素类型
类型测试
if let Ok(var) = field.parse::<f32>() {} 若解析成功则把解析出的值赋给var
if let结构若解析成功则返回Ok()，若解析式吧，则返回Err()

## 逻辑控制
for (var1, var2) in 循环
continue

## 函数
```rust
fn add(i: i32, j: i32) -> i32 {    // 定义函数，必须声明类型
  i + j                            // 函数最后一个表达式默认为该函数的return值，必须是表达式，也就是说如果是分号结尾，就会变为返回()
}
```

### lambda
|var| var.trim()

### 宏
宏返回一段代码

比如
println! 输出到stdout，eprintln! 输出到stderr
    占位符{}、{:?}默认表示形式

cfg!(debug_assertions) 条件编译，编译时检查配置，不会被包含到release build中（cargo --release）

## 并发
### 线程
thread::spawn(lambda)




