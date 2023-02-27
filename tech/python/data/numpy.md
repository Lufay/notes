NumPy
Numerical Python的缩写，由Numeric、numarray 等开源库逐步发展而来，出于历史兼容，其中也包含了很多的数学运算。但Scipy 中提供了更多更新的功能，所以这些数学运算最好使用Scipy 库。

这个库为Python提供了大量的数据结构，可以高效地存储和处理大型矩阵，可以轻松地执行多维数组和矩阵计算

# 安装
`pip install numpy`

查看版本
```py
import numpy as np
np.__version__
```

# 数据结构
## ndarray
多维数组结构，比原生list 更易用，也更高效
但要求数组元素必须是同一类型，同一规格

### 构造
#### 使用list
array(list, dtype=...): 使用list 构造一个ndarray 对象，dtype 可以指定数据类型（比如complex）

#### 使用shape
shape 可以是一个正整数，也可以是一个数组，用于指定维度和对应长度信息

empty(shape, dtype=...): 使用随机数，构造一个多维数组（比如[2, 3]可以构造一个2行3列的矩阵，即第一个是最外面的长度，后面是内层）
ones(shape, dtype=...): 全1的多维数组
zeros(shape, dtype=...): 全0的多维数组

#### 矩阵构造
eys(n, m, dtype=...): 一个n*m 的对角线全1的矩阵，若n==m，就是单位阵
tri(n, m, dtype=...): 一个n*m 的下三角矩阵

#### 插值构造
`arange([start,] stop, [step,] dtype=...):`: 相当于`array(range([start,] stop, [step,]))`
linespace(start, stop, num, endpoint=True, retstep=False, dtype=..., axis=0): 从start 到stop 均匀选num 个值构成数组；endpoint决定是否使用stop 作为最后一个元素；retstep 决定是否返回步长（将返回一个二元组）
logspace(start, stop, num, endpoint=True, base=10, dtype=..., axis=0): 从start 到stop 均匀选num 个值，将每个值以base为底的指数值构成数组

#### 采样构造
random.rand(d0, d1, d2, ...): 使用[0, 1) 的随机数填充一个d0*d1*d2*...的多维数组
random.normal(loc, scale, size): 按正态分布随机生成size 个随机数，loc 是均值，scale 是标准差
random.beta()
random.dirichlet()
random.poisson()

### 支持的运算
`*`     两个相同规格的ndarray 对应元素相乘
`**n`   数组每个元素进行幂运算
