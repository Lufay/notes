# UML 绘图
```
@startuml
' 单行注释
/' 多行注释
'/
@enduml
```

## 时序图
不必显式声明参与者
无论参与者还是消息，都可以使用`\n` 进行换行

### 声明参与者
#### 关键字
+ participant
+ actor
+ boundary
+ control
+ entity
+ database

#### 重命名
```
participant "I have a really\nlong name" as L
```

#### 缺省的参与者
```
[-> A: DoWork
A<--] : RequestCreated
A ->] : << createRequest >>
```

#### 指定颜色
```
actor Bob #red
participant Alice #99FF99
```

#### 指定顺序
```
participant Last order 30
participant Middle order 20
participant First order 10
```

#### box
可以使用box和end box画一个盒子将参与者包裹起来。
还可以在box关键字之后添加标题或者背景颜色
```
box "Internal Service" #LightBlue
	participant Bob
	participant Alice
end box
```

### 箭头样式
用`->`来绘制参与者之间传递的消息
用`-->`绘制一个虚线箭头
还能用`<-`和`<--`
`->x` 一条丢失的消息
`->>` 粗箭头
`-\` 箭头只有上半部分（可以`-\\`加粗）
`-/` 箭头只有下半部分（可以`-//`加粗）
`->o` 箭头末尾加圈
`<->` 

#### 指定颜色
```
-[#red]>
-[#0000FF]->
```

### 消息序列编号
关键字 `autonumber [startIdx] [incr] [format]`
默认startuml=incr=1
format 可以是一个html 格式串，用0 或# 占位表示数字（多个表示最小宽度）

autonumber stop 停止自动编号
autonumber resume 继续自动编号

### 生命线
关键字activate和deactivate用来表示参与者的生命活动。
一旦参与者被激活，它的生命线就会显示出来。
```
User -> A: DoWork
activate A #FFBBBB		' 可以简写做User -> A ++ #FFBBBB : DoWork
A -> A: Internal call
activate A #DarkSalmon

A -> User: Done
deactivate A			' 可以简写做A -- -> User: Done
```
可以嵌套，添加不同颜色

#### return
`return msg` 找到最近的一个activate 的生命线，deactivate 掉并返回msg 给调用者

#### create
create 可以动态创建一个参与者
destroy表示一个参与者的生命线的终结。
```
create Other
Alice -> Other : new	' 可以简写做 Alice -> Other ** : new

C --> B: WorkDone
destroy C				' 可以简写做C !! --> B: WorkDone
```

### 标题、页头、页尾、分页线
```
header Page Header
footer Page %page% of %lastpage%

title Example Title

newpage [msg]
```

### 序列块
#### if
```
opt 参数校验不通过
...
end
```

#### if-else
```
alt successful case
	...
else some kind of failure
	...
else Another type of failure
	...
end
```

#### while
```
loop 1000 times
	...
end
```

#### 其他
par
break
critical
group


### 分隔符
```
== Initialization ==

...5 minutes latter...
```

### 注释标签
```
note right: this is a note	' 单行
note left					' 多行
	...
end note
hnote


note right of Alice: This is displayed right of Alice	' 参与者标签
note over Alice: This is displayed over Alice.
note over Alice, Bob #FFAAAA: This is displayed\n over Bob and Alice.
```
文本支持Creole和HTML。

## 状态图
使用`[*]`开始和结束状态图。

### 状态
#### 状态描述
```
State1 : this is a string
State1 : this is another string
```

#### 组合状态
包含子状态
```
state NewValuePreview {
	State1 -> State2
}
```

也可以使用关键字state定义长名字状态
```
state "Accumulate Enough Data\nLong State Name" as long1
```

用`--` or `||`作为分隔符来合成并发状态。

#### 历史状态
历史状态是一个伪状态（Pseudostate）,其目的是记住从组合状态中退出时所处的子状态，当再次进入组合状态，可直接进入这个子状态，而不是再次从组合状态的初态开始。

#### fork & join
状态可以在某一时刻到达多个状态
```
state fork_state <<fork>>
state join_state <<join>>
```

### 箭头
状态转移：执行动作、触发条件
`-->` or `-down->` 默认下向箭头
`->` or `-right->` 右向箭头
`-left->`
`-up->`
可以使用首字母、前两个字母缩写


### 注释标签
```
note left of
note right of
note top of
note bottom of
```
