# 线程管理
## std::thread
C++11，代表一个执行线程，通过传入一个函数来启动一个线程

### 方法
joinable()
join()
detach()

### 实例
```cpp
#include <iostream>
#include <thread>

void printNumber(int number) {
    std::cout << "Hello, the number is: " << number << std::endl;
}

int main() {
    std::thread t(printNumber, 42);

    // 检查线程是否可以join
    if (t.joinable()) {
        t.join();
    }

    return 0;
}
```

## std::async
启动一个异步任务（内部实际上是创建了一个 std::promise），它返回一个 std::future 对象，你可以用它来获取异步任务的结果


### 实例
```cpp
#include <iostream>
#include <future>
#include <thread>

// 定义一个简单的函数来模拟一个计算任务
int compute() {
    std::this_thread::sleep_for(std::chrono::seconds(2)); // 模拟耗时操作
    return 42; // 返回一些结果
}

int main() {
    // 使用std::async启动异步任务
    std::future<int> result = std::async(std::launch::async, compute);

    // 这里可以做一些其他的工作...
    std::cout << "Main thread is free to run other tasks." << std::endl;

    // 等待异步任务完成并获取结果
    std::cout << "Computed value: " << result.get() << std::endl; // 这里会阻塞直到异步任务完成

    return 0;
}
```

## std::this_thread::sleep_for
线程休眠，参数使用std::chrono::seconds(n)

## std::promise & std::future
当你创建一个 std::promise 对象时，它会自动创建一个与之关联的 std::future 对象。
前者给生产者去set_value()或set_exception()，后者给消费者去get()，阻塞直到有值或异常被抛出
若前者没有显示调用set_xxx方法，后者会收到std::future_error 异常

```cpp
#include <iostream>
#include <thread>
#include <future>

void do_work(std::promise<int>&& prom) {
    // 计算一个结果，比如得到42
    prom.set_value(42); // 通知future
}

int main() {
    std::promise<int> promise;
    std::future<int> future = promise.get_future();
    std::thread t(do_work, std::move(promise));

    // get() 会阻塞，直到promise被满足
    std::cout << "Result is: " << future.get() << std::endl;

    t.join();
    return 0;
}
```

# 线程同步方法

## 锁包装器
RAII（Resource Acquisition Is Initialization）原则是所有的资源都必须有管理对象，而资源的申请操作在管理对象的构造函数中进行，而资源的回收则在管理对象的析构函数中进行。

### std::lock_guard
C++11，最简单的锁管理器，构造时获取锁，析构时释放锁

### std::unique_lock
C++11，lock_guard 的进阶版（也是排他锁管理器），支持手动锁定、解锁、转移，可以跟条件变量、延迟锁情况下使用。

### std::shared_lock
C++14，共享锁管理器，支持手动锁定和解锁，以及尝试锁定。不支持手动锁定和解锁，也不支持条件变量

#### 方法
lock：共享锁定。若已经被互斥锁定将被阻塞
try_lock：尝试共享锁定。若已经被互斥锁定则返回
try_lock_for：尝试共享锁定，可以指定超时时长
try_lock_until：尝试共享锁定，可以指定超时时间点
unlock：共享解锁

#### 实例
```cpp
std::shared_mutex sh_mtx;
int shared_data = 0;

void read_data() {
	std::shared_lock<std::shared_mutex> lock(sh_mtx);   // 共享锁
	std::cout << "Read shared_data: " << shared_data << std::endl;
}

void write_data() {
	std::unique_lock<std::shared_mutex> lock(sh_mtx);   // 排他锁
	++shared_data;
	std::cout << "Incremented shared_data: " << shared_data << std::endl;
}
```

### std::scoped_lock
C++17，用于同时锁定并释放多个互斥量，以避免死锁。
不支持手动锁定和解锁，也不支持条件变量

#### 实例
```cpp
std::mutex mtx1;
std::mutex mtx2;
int shared_data1 = 0;
int shared_data2 = 0;

void increment_both() {
    std::scoped_lock lock(mtx1, mtx2);
    ++shared_data1;
    ++shared_data2;
    std::cout << "Incremented shared_data1: " << shared_data1 << ", shared_data2: " << shared_data2 << std::endl;
}
```

## 锁

### std::mutex & std::timed_mutex
最基本的互斥锁，任意时刻只有一个线程可以拥有锁
用于竞争程度较低，即锁的持有时间短并且存在大量不竞争的锁请求时
后者支持超时释放锁

#### 实例
```cpp
std::mutex m;
void thread_function() {
    std::lock_guard<std::mutex> guard(m);
    // access shared resource
}

std::timed_mutex m;
bool try_lock_for_period() {
    auto timeout = std::chrono::milliseconds(100);
    if (m.try_lock_for(timeout)) {
        // got lock within 100ms
        m.unlock();
        return true;
    }
    return false;
}
```

### std::recursive_mutex & std::recursive_timed_mutex
可重入锁，允许同一个线程多次获取

#### 实例
```cpp
std::recursive_mutex m;
void recursive_function(int i) {
    if (i <= 0) return;
    std::lock_guard<std::recursive_mutex> guard(m);
    // access shared resource
    recursive_function(i - 1);
}
```

### std::shared_mutex & std::shared_timed_mutex
C++17，共享锁，不可重入
有最大共享数量，目前实现至少保证10000

#### 方法
lock：互斥锁定，加锁失败则阻塞
try_lock：尝试锁定互斥,若互斥不可用则返回
unlock：解锁互斥。该锁必须为当前执行线程所锁定，否则行为未定义

lock_shared：共享锁定。若已经被互斥锁定将被阻塞
try_lock_shared：尝试共享锁定。若已经被互斥锁定则返回
unlock_shared：共享解锁

### 自选锁（spinlock）
忙等待的锁，当线程试图获取一个已被其他线程持有的锁时，它将在一个循环中不断地检查锁是否已经可用。
可以避免线程上下文切换的开销，但同时也会持续占用CPU。因此，当锁的持有时间非常短时，自旋锁可以提供较高的性能。
适合用在锁竞争不激烈且持锁时间很短的场景中
暂无标准库实现，可以使用原子操作`std::atomic_flag`或者`std::atomic<bool>`类型变量来自行实现自旋锁

```cpp
#include <atomic>
#include <thread>

class SpinlockMutex {
    std::atomic_flag flag;

public:
    SpinlockMutex() : flag(ATOMIC_FLAG_INIT) {}

    void lock() {
        while (flag.test_and_set(std::memory_order_acquire)) {
            // 在这里自旋，等待锁释放
        }
    }

    void unlock() {
        flag.clear(std::memory_order_release);
    }
};
```

## 原子量
### std::atomic_flag
#### 实例
```cpp
std::atomic_flag lock = ATOMIC_FLAG_INIT;

void f(int n)
{
    for(int cnt = 0; cnt < 100; ++cnt)
    {
        while (lock.test_and_set(std::memory_order_acquire));  // 获取锁
        std::cout << "Output from thread " << n << '\\n';
        lock.clear(std::memory_order_release);  // 释放锁
    }
}
```
简单的自旋锁来保护std::cout

### std::atomic
```cpp
std::atomic<int> count = 0; // 定义一个原子整数

void increment() {
    for (int i = 0; i < 1000; ++i){
        ++count; // 原子性递增操作
    }
}

// 无锁：Compare-And-Swap (CAS) Loop

std::atomic<int> num (0); // 原子整数

void increment() {
    int oldNum = num.load();
    while (!num.compare_exchange_weak(oldNum, oldNum + 1)) {
        // CAS操作失败，重试
    }
}
```
其他无锁同步：
1. 硬件原子指令
2. 内存屏障（Memory Barrier）
3. 总线加锁或者缓存加锁
4. OS 同步原语：信号量（semaphores）、事件（events）和临界区（critical sections）等

## 条件变量
### std::condition_variable
允许一个或多个线程在某些条件下等待或接收通知。

#### 实例
```cpp
#include <iostream>
#include <thread>
#include <mutex>
#include <condition_variable>

std::mutex m;
std::condition_variable cv;
bool ready = false;

void print_id(int id) {
    std::unique_lock<std::mutex> lock(m);
    while (!ready) { // 如果标志不为真，则等待...
        cv.wait(lock); // 当前线程被阻塞，同时释放了锁
    }
    // 执行到此处，已经获得了锁
    std::cout << "thread " << id << '\\n';
}

void go() {
    std::unique_lock<std::mutex> lock(m);
    ready = true; // 设置全局标志为真
    cv.notify_all(); // 唤醒所有等待的线程
}

int main() {
    std::thread threads[10];
    // 启动10个线程
    for (int i = 0; i < 10; ++i)
        threads[i] = std::thread(print_id, i);

    std::cout << "10 threads ready to race...\\n";
    go(); // 去，让所有线程开始竞争

    for (auto &th : threads)
        th.join();

    return 0;
}
```
