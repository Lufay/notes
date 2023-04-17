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

+ root(func, x0): func 是求根的函数，x0 是猜测根的初始值。返回一个对象，其中x 属性就是根的list
+ minimize(func, x0, method, callback, options): method 是要使用的方法（'CG'，'BFGS'，'Newton-CG'，'L-BFGS-B'，'TNC'，'COBYLA'，'SLSQP'），callback 是每次迭代后调用的函数，options 是个字典（{"disp": False, "gtol": num}，disp 是是否显示细节，gtol 是容忍的误差）。返回一个对象，x 属性是最小值对应的 x 值，func 属性是函数最小值

## 稀疏矩阵
scipy.sparse 包

按压缩形式可以分为
+ CSC - 压缩稀疏列（Compressed Sparse Column），按列压缩。
+ CSR - 压缩稀疏行（Compressed Sparse Row），按行压缩。

### 创建
```py
arr = np.array([0, 0, 0, 0, 0, 1, 1, 0, 2])
csr_matrix(arr)
```

### 属性
data: 查看存储的非0 元素（不含位置信息）

### 方法
count_nonzero(): 返回非 0 元素的个数
eliminate_zeros(): 删除矩阵中 0 元素
sum_duplicates(): 删除重复项
tocsc(): 转换csc 压缩格式

## 图算法
scipy.sparse.csgraph 包

参数csgraph 可以是一个多维数组，也可以是一个稀疏矩阵
若 directed=False，则csgraph 只需要上三角的数据即可
+ connected_components(csgraph, directed=True, connection='weak', return_labels=True): 默认返回一个(n, arr)二元组，n 表示图的节点按照连通性可以划分为几个部分，arr表示每个节点所属的分组编号。若return_labels=False 则只返回n
+ dijkstra(csgraph, directed=True, indices=None, return_predecessors=False, unweighted=False, limit=np.inf, min_only=False): 默认返回一个矩阵，每一行表示一个节点到各个节点通过Dijkstra 算法计算出来的最短路径。indices 可以是数组或整数，表示只返回这些节点到各个节点的最短路径；limit 可以限定路径的最大权重，超过的边将被认为是不连通的，unweighted=True 可以去除边的权重，只计算边的个数；若return_predecessors=True，则返回一个二元组，第一个元素是距离矩阵，第二个元元素是前驱节点矩阵（即，在该最短路径下的前置节点是谁，可以通过这些前置节点关系绘制出最短路径图）；若min_only=True，则距离矩阵变为一维数组，表示每个节点到indices 中的节点中的距离最小值，若同时return_predecessors=True，则返回的是三元组，第三个元素表示的是每个节点最短路径中到达indices 中的那一个目标节点
+ floyd_warshall(csgraph, directed=True, return_predecessors=False, unweighted=False, overwrite=False): 使用弗洛伊德算法计算任意两点间的最短路径。若csgraph 是稠密矩阵，并且是dtype=float64 的C-ordered 数组时，可以设置overwrite=True，将结果直接覆写在csgraph 上
+ bellman_ford(csgraph, directed=True, indices=None, return_predecessors=False, unweighted=False): 使用贝尔曼-福特算法计算任意两点间的最短路径。可以在带负权图中使用
+ depth_first_order(csgraph, i_start, directed=True, return_predecessors=True): 深度优先排序（结果可能不唯一），i_start指定遍历的起始节点
+ breadth_first_order(csgraph, i_start, directed=True, return_predecessors=True): 广度优先排序（结果可能不唯一），i_start指定遍历的起始节点

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


