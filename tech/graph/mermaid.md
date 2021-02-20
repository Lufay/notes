# mermaid
<https://mermaid-js.github.io/mermaid>
<https://mermaid-js.github.io/mermaid-live-editor>

## 流程图
```
graph TD
    A[Start] --> B{Is it?};
    B -->|Yes| C[OK];
    C --> D[Rethink];
    D --> B;
    B ---->|No| E[End];
```

### 图的布局方向
TB - top to bottom
TD - top-down/ same as top to bottom
BT - bottom to top
RL - right to left
LR - left to right

### 节点形状
矩形：`[text]`
圆角矩形：`(text)`
跑道形：
子程序形：
圆柱形：
圆形：
标签形：
菱形：
六边形：
平行四边形：
反平行四边形：
梯形：
反梯形：

### 边形状
无向边：
有向边：
虚边：
粗边：
附带文字：
链：
组合：
加长边：

### 子图
```
subgraph title
    graph definition
end
```

### 附加
#### 注释
#### 样式
#### 行动脚本


## 时序图

## 饼图

## 甘特图

## 类图
```
%% Comments，单行注释
classDiagram
      Animal <|-- Duck
      Animal <|-- Fish
      Animal <|-- Zebra
      Animal : +int age
      Animal : +String gender
      Animal: +isMammal() bool
      Animal: +mate()
	  <<interface>> Animal
      class Duck{
          +String beakColor
          +swim()
          +quack()
      }
      class Fish{
          -int sizeInFeet
          -canEat()
      }
      class Zebra{
          +bool is_wild
		  List~int~ position
          +run()
      }
	  class Color{
		<<enumeration>>
		RED
		BLUE
	  }
```
类可以显式用class 声明，也可以隐式声明，而后补充成员
类的注解：
`<<Interface>>`
`<<abstract>>`
`<<Service>>`
`<<enumeration>>`

### 成员
用括号区分成员变量和方法
泛型的`< >` 用`~` 替代

#### 可见性
`+` Public
`-` Private
`#` Protected
`~` Package/Internal

方法修饰（在括号后）
`*` Abstract e.g.: `abstractMethod()*`
`$` Static e.g.: `staticMethod()$`

### 关系
```
classDiagram
Animal <|-- Fish	:	继承（实线三角）is-a 关系
Flying <|.. Bird	:	实现（虚线三角）can-do 关系
Head *-- Peaple		:	组合（实心菱形）contains 关系（部分不能脱离整体而独立存在）
Crowd o-- Peaple	:	聚合（空心菱形）has-a 关系（部分有独立的生命周期）
classG <-- classH	:	关联（实线箭头）非owns 的关系
Car <.. Driver		:	依赖（虚线箭头）use-a 关系（通过使用被依赖对象来完成所需的功能）
Teacher -- Student	:	实链接（实线）双向关联
classO .. classP	:	虚链接（虚线）
```
`:` 后面是关系上显示的文案

#### 关系的度
`1` Only 1
`0..1` Zero or One
`1..*` One or more
`*` Many
`n` n {where n>1}
`0..n` zero to n {where n>1}
`1..n` one to n {where n>1}
格式：[classA] "cardinality1" [Arrow] "cardinality2" [ClassB]:LabelText

## 实体关系图

## 用户动线图（User Journey）
