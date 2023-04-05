Scipy

利用numpy 的数据结构进行数学运算，所以依赖于numpy

# 安装
`pip install scipy`

查看版本
```py
import scipy
scipy.__version__
```

## 常量
scipy.constants 包

### 数学
pi 圆周率
golden 黄金分割比

#### 十进制单位
yotta、zetta、exva、peta、tera、giga、mega、kilo、hecto、deka、centi、milli、micro、nano、pico、femto、atto、zepto

#### 二进制单位
kibi、mebi、gibi、tebi、pebi、exbi、exbi、yobi

### 物理
c 光速
h 普朗克常数
e 基本电荷
alpha 精细结构常数
epsilon_0 真空电容率
R 普适气体常数
N_A 阿伏伽德罗常数
k 玻尔兹曼常数
Rydberg 里德伯常数
m_e 电子静止质量
m_p 质子静止质量
m_n 中子静止质量
atm 标准气压（帕斯卡）

### 单位换算
pound 英镑/kg
ounce 盎司/kg
degree 角度/弧度
inch 英寸/米
foot 英尺/米
yard 码/米
mile 英里/米
acre 英亩/平方米
gallon 加仑/立方米
hp 马力/瓦特

## 最优化
scipy.optimize 包



## 特殊函数库
scipy.special 包

### 艾里函数
Ai, Aip, Bi, Bip = airy(x) 艾里函数和其导数，Ai 和Bi 是微分方程对应艾里函数的两种积分形式（两个线性无关解）

相关函数还有
airye 指数缩放的Airy函数及其导数
ai_zeros Ai及其导数的零点（输入为零点的个数，输出为前n 个零点位置和该位置相应的值）
bi_zeros Bi及其导数的零点
Apt, Bpt, Ant, Bnt = itairy(x) Airy函数的积分，Apt, Bpt 分别是Ai、Bi 的正值积分，Ant, Bnt 分别是Ai、Bi 的负值积分

### 椭圆函数
ellipj(u,m): 雅可比椭圆函数

### 贝塞尔函数
jv(v, z)

### 伽马函数

### 勒让德函数

### 超几何函数

### 朗伯W函数

### 误差函数 和 菲涅尔函数


