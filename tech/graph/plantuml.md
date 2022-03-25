# UML 绘图
注释
```
@startuml
' 单行注释

/' 多行注释
'/

@enduml
```

切分多图
```
@startuml ./image.png
...
newpage
...
newpage
...
@enduml
```
2个newpage 就可以切分出3个图：./image.png、./image001.png、./image002.png

## 用例图
### 用例
```
("用例1") <<interface>>
("用例1") as (uc1) <<interface>>

usecase "用例2"
usecase ("用例2") as us2
```
两种格式，都可以使用别名
interface 非必选项，可以指定构造型

#### 用例文本
可以使用分隔线
```
== 双行分隔
==TEXT== 可指定文本

__ 略粗分隔
__TEXT__ 可指定文本TEXT

-- 最细分隔
--TEXT-- 可指定文本TEXT

.. 虚线
..TEXT.. 可指定文本TEXT
```

### actor
```
actor1 -> (uc1)
actor1 -> (uc1) : LABEL

actor2 <<interface>>
:actor2: as ac2 <<interface>>

actor "actor3"
actor "actor3" as ac3
```
3种格式
+ 第一种是直连用例
+ 后两者可以独立定义actor，冒号的作用和第三种的引号一样，为了避免actor名字中的空格别误识别，可以使用别名
+ interface 非必选项，可以指定构造型
+ 默认火柴人样式，可以改为用户头像样式（`skinparam actorStyle awesome`）或透明人样式（`skinparam actorStyle hollow`）

### 标注
```
note "text" as N
(uc) .. N

note left of ac : text
note right of ac : text
note top of (uc) : text
note bottom of (uc) : text

note left of (uc)
text
end note
```
三种格式
+ 第一种可以声明一个独立的note 节点
+ 第二三种都是依附在一个用例或actor 节点上，前者是单行文本，后者是多行文本

### 连接用例
```
->	实线箭头, 默认水平
-	不带箭头
-->	实线箭头, 默认垂直（越多-，长度越长）
--	不带箭头. - 越多线越长
--> 的反向连接可以为 <--. 其它同此
-left-> 指向左侧的箭头
-right-> 指向右侧的箭头
-up-> 指向上的箭头
-down-> 指向下的箭头

.>, 虚线箭头, 线较短
. 不带箭头
..>, 虚线箭头, 线较长. .. 不带箭头. . 越多线越长
```

### 继承扩展
```
:main admin: as Admin
(use app) as (Use)
User <|-- Admin
(Start) <|- (Use)
```
用例和actor 都可以继承扩展

## 模块包
```
package pack_name {
	...
}

rectangle pack_name {
    ...
}
```
2种方式可以定义一个模块包，包里面可以定义图和节点

## 类图
<https://plantuml.com/zh/class-diagram>

## 活动图
从V7947开始提出一种全新的、更好的语法格式和软件实现供用户使用(beta版)
<https://plantuml.com/zh/activity-diagram-beta>

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

## 对象图
<https://plantuml.com/zh/object-diagram>

## 组件图
<https://plantuml.com/zh/deployment-diagram>

## 部署图
<https://plantuml.com/zh/deployment-diagram>

## 甘特图
<https://plantuml.com/zh/gantt-diagram>

## 思维导图
<https://plantuml.com/zh/mindmap-diagram>

## 工作分解结构（WBS）
<https://plantuml.com/zh/wbs-diagram>

## 实体关系图（ER图）
<https://plantuml.com/zh/ie-diagram>