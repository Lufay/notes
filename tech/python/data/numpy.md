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

### 属性
dtype 支持的类型可以通过包变量`sctypeDict` 这个字典查看（该字典的key就是可以作为dtype 参数的值，value 就是对应的类对象）
ndim 数组的维度
shape 数组各维度的长度
size 数组元素的总数
real 元素的实部
imag 元素的虚部
flat 返回一个迭代器，迭代数组的每个单元素。可以将一个list 赋值给它，从而可以改变这个多维数组
T 把轴序逆序后，作数组的转置

#### 轴
表示对数组进行操作，按第几个维度进行，可以是None 或自然数，None 表示将数组平铺后再进行操作
由外向内，轴从0递增

轴0 表示从最外层每次取一个元素，作为操作单元
轴1 表示从次外层每次取一个元素，作为操作单元
...

### 构造
#### 使用已有数据构造
array(list, dtype=...): 使用list 构造一个ndarray 对象，dtype 可以指定数据类型（比如complex）
asarray(arr, dtype=...): 可以使用已有的数据构造一个ndarray 对象
frombuffer(buf, dtype=..., count, offset): 使用byte 的序列来构造
fromiter(it, dtype=..., count): 使用迭代器来构造
fromfile(f, dtype=..., count, sep, offset)

#### 使用shape
shape 可以是一个正整数，也可以是一个数组，用于指定维度和对应长度信息

empty(shape, dtype=...): 构造一个多维数组（比如[2, 3]可以构造一个2行3列的矩阵，即第一个是最外面的长度，后面是内层，这里的元素是没有做特殊设置的，就像C 中未初始化的变量一样）
ones(shape, dtype=...): 全1的多维数组
zeros(shape, dtype=...): 全0的多维数组

#### 矩阵构造
eye(n, m, dtype=...): 一个n*m 的对角线全1的矩阵，若m缺省，则==n，即单位阵
tri(n, m, dtype=...): 一个n*m 的下三角矩阵

#### 插值构造
`arange([start,] stop, [step,] dtype=...):`: 相当于`array(range([start,] stop, [step,]))`
linspace(start, stop, num, endpoint=True, retstep=False, dtype=..., axis=0): 从start 到stop 均匀选num 个值构成数组；endpoint决定是否使用stop 作为最后一个元素；retstep 决定是否返回步长（将返回一个二元组）
logspace(start, stop, num, endpoint=True, base=10, dtype=..., axis=0): 从start 到stop 均匀选num 个值，将每个值以base为底的指数值构成数组

#### 采样构造
random.rand(d0, d1, d2, ...): 使用`[0, 1)` 的随机数填充一个d0*d1*d2*...的多维数组
random.randint(low, high): low和high 可以是整数，也可以是整数的高维数组，如果结构不对齐，可以使用广播机制进行对齐，返回的结构跟对齐后的一致
random.randn(d0, d1, d2, ...): 使用标准正态分布的随机数填充d0*d1*d2*...的多维数组。loc+scale*randn(d0, d1, ...) 等价于 normal(loc, scale, (d0, d1, ...))
random.normal(loc, scale, size): 按正态分布随机生成size 个随机数，loc 是均值，scale 是标准差
random.beta()
random.dirichlet()
random.poisson()

#### 其他
asmatrix(data, dtype=...)
copy(a)
diag(v, k)
tril(v, k)
triu(v, k)
vander(x, N, increasing)

### 支持的运算
`[i1, i2, ... , in]` 列举每一个维度（轴）信息获取一个新的数组，n为数组的维度，每一个ix 都具有相同的结构（如果没有则使用广播机制进行扩展），用以指示结果的结构。ix 也可以可以通过True/False 枚举每个字段来获取True 位置的字段（这种True/False 数组必须和原数组等长）
`[start:end:step, start:end:step]` 支持多维切片（可读可写），多个`:`（例如`:,:,:`）可以写作`...`，可以使用None 来增加一个维度（长度为1）
`+ - * / %`     两个相同规格的ndarray 对应元素相加减乘除余，对应add/subtract/multiply/divide/mod 函数
`**n`   数组每个元素进行幂运算，对应power 函数
`@`     矩阵乘，对应matmul 函数（dot 函数的应用就更广泛一些，可以做标量运算、向量点积、矩阵运算，还可以做高维数组运算）

#### 索引
从上面可以看到，多个维度的索引使用`,` 进行分割，每个维度（轴）的索引可以使用整数、布尔值、多维数组、切片、None

+ 如果索引个数少于维度，则使用`:` append补齐剩余维度
+ None 不占用维度，而是在指定的轴增加一个维度，长度为1
+ 若使用布尔值作为维度信息，则这个布尔数组的长度需要和该维度的长度相同，相当于一维数组
+ 整数，表示指定对应轴的位序
+ 切片，是一维数组的简写
+ 多维数组，表示取对应轴的多个位序，则每个轴的信息都必须是该结构（可使用广播机制扩展）而其结构对应了结果的结构
+ 如果想要使用笛卡尔积指定多个维度，可以使用`ix_()` 这个函数

```py
a = np.arange(20).reshape((4, 5))
a[2]        # 按照维度补齐a[2, :]，即取2 行所有元素，跟原索引语义一致
a[[1,3]]    # 维度补齐为a[[1,3], :]，即取1、3 两行的所有元素
a[[1,3], None]  # 在axis=1位置插入一个维度，然后在补齐维度，将得到一个2*1*5 的一个多维数组
a[[1,3,2], [4, 1, 2]]   # 两个数组都是一维，长度相同，结果为 [a[1,4], a[3,1], a[2,2]]
a[[[0,0],[3,3]], [0,2]] # 多维数组，需要打平到2*2，按广播机制将第二个扩展为a[[[0,0],[3,3]], [[0,2],[0,2]]] 则结果为[[a[0,0],a[0,2]],[a[3,0],a[3,2]]]
a[a > 5]    # 根据运算符的广播机制，将5 扩展为4*5的数组，返回一个4*5的布尔值高维数组，然后返回那些为True位置的元素（拍平为一维）
a[~np.isnan(a)]     # 同上使用ufunc 广播机制展开，~ 表示取反
a[np.ix_([1,3], [0, 2, 4])] # ix_ 函数会把第一个1*2数组转置为2*1，第二个保持1*3，那么按广播机制，会打平到2*3 的多维数组，也就是结果就是2*3
```

#### ufunc 和广播机制
对两个相同规格的ndarray 对应元素执行相应的运算的函数
除了上面已有运算符的，还有：
1. 算术运算：fabs/log/exp/sqrt 等
2. 三角函数：sin/cos/tan/arcsin 等
3. 位运算：bitwise_and/bitwise_or/bitwise_xor/invert/left_shift 等
4. 浮点运算：isfinite/fmod/floor/ceil 等
5. 比较：greater/greater_equal/less/not_equal/logical_and 等

当维度不一致时，会使用广播机制：
+ 小维度会补齐到大维度，被补的维度长度为1
+ 各维度长度若为1，则使用这个唯一元素补齐到最大长度；否则必须一致，不然将失败

#### 高维数组运算
dot(a, b) 函数在进行高维数组运算时，是以a, b 的最内轴的矩阵进行交叉矩阵乘
比如a.shape=(1,2,3,4)，b.shape=(7,6,4,5)，a, b 的最内轴是个3*4 和4*5 的矩阵，矩阵乘后就是个3*5 的矩阵，交叉矩阵乘就是a 中每一个3*4的矩阵切片和b 中每一个4*5 的矩阵切片进行矩阵乘，就对应结果中的一个单元，所以结果res.shape=(1,2,3,7,6,5)
即，消掉了a 的最后一个轴和b 的倒数第二个轴，然后进行连接，就是结果的shape

### 方法
astype(dtype): 转换元素的类型
reshape(shape): shape 的最后一维，可以设置为-1，可以使之自定计算最后一维长度
flatten(order=None): 将数组平铺，返回的是拷贝，不影响原数组
ravel(order=None): 将数组平铺，修改会影响原数组

all(axis)/any(axis)/max(axis)/min(axis)/mean(axis)
dot(b)

## matrix
ndarray 的一个子类，维度固定为2

mat(data, dtype): 构造

## broadcast
模拟广播的对象
广播对象可以直接迭代，就类似于迭代iters 属性一样

broadcast(*arrs): 构造
iters: 返回多个可迭代对象的元组，对应构造时的每个数组
shape: 广播后的shape


## 自定义类型
dtype(fields): fields 是一个(name, type)的二元组列表，返回的类型，可以作为dtype 参数的值。类似与namedtuple，使用自定义类型的ndarray 可以使用name 作为索引

# 函数
## 遍历
nditer(arr): 返回一个迭代器，拍平进行迭代。
ndenumerate(arr): enumerate 的多维版本，返回的index 是一个多维索引
```py
for a in np.nditer(arr):
    # 常规遍历，这种等价于遍历arr.flat
    # a 是只读的

for a in np.nditer(arr, op_flags=['readwrite']):
    # 读写遍历
    a[...] = a * 2

for a, b in np.nditer([arr, brr]):
    # 一次性遍历多个数组，若这些数组结构不对齐，可以使用广播机制进行对齐

it = np.nditer(arr, flags=['f_index'])    # 列优先（小轴优先），或者c_index 行优先（大轴优先）
while not it.finished:
    print(it[0], it.index)  # 只有设置了f_index 或 c_index，迭代器才有index 属性
    it.iternext()

it = np.nditer(arr, flags=['multi_index'])
while not it.finished:
    print(it[0], it.multi_index)  # 只有设置了multi_index，迭代器才有multi_index 属性
    it.iternext()
```

reshape(arr, shape, order=None): 将arr 平铺后重新按shape 进行组织
resize(arr, shape): 可以对arr 扩缩容，若需要扩容，则循环使用数组元素进行补充
ravel(arr, order=None): 平铺数组，修改影响原数组
atleast_1d(arr)/atleast_2d(arr)/atleast_3d(arr): 将arr 拆解到至少1、2、3 维，若arr 维度已经达到，就没有变化
broadcast_to(arr, shape): 使用广播机制，将arr 扩展到指定的shape
expand_dims(arr, axis=None): 在axis 指定的位置插入一个维度（比如原来2*3的数组，axis=1，将变为2*1*3 的数组）
squeeze(arr, axis=None): 移除一个长度为1 的维度（axis 指定，若未指定，则移除所有）
stack(arrs, axis=0, out=None): arrs 指定数组的序列，将这些n 维 arr 堆叠成一个n+1 维arr
concatenate(arrs, axis=0, out=None): arrs 指定数组的序列，将这些n 维 arr 连接成一个n 维arr
column_stack: 相当于stack axis=1
vstack, hstack, dstack: v, h, d相当于concatenate axis=0, 1, 2（有一个例外是对于1维数组，h对应的axis=0）；若轴超出维度，则先用atleast 函数进行维度扩展
tile(arr, reps): 使用arr 进行多维度repeat，reps 可以是整数或者整数数组（表示在各个轴上复制几次），结果的维度是max(arr.ndim, len(reps))
split(arr, indices_or_sections, axis=None): indices_or_sections 若为正整数，则表示均分；若是序列，则表示在这些索引位置进行切分，返回多个数组
vsplit, hsplit, dsplit: 相当于split axis=0, 1, 2
append(arr, values, axis=None): 在指定的轴最后插入values
insert(arr, idx, values, axis=None): 在指定的轴的idx位置插入values
delete(arr, idx, axis=None): 在指定的轴的idx位置删除
（idx 可以使用`s_[::2]`这样的形式构造切片索引）

sum(arr, axis=None, dtype=None, out=None, keepdims=True, initial=0, where=): 基于axis 轴投影求和
unique(arr, return_index=False, return_inverse=False, return_counts=False, axis=None): 返回的是一个元组，第一个元素是去重后的结果，第二个是结果在原数组中的索引，第三个是原数组每个元组在结果数组中的索引，第四个是每个元组在原数组中的计数
where(cond): 返回满足条件的元素位置

sort(arr, axis=-1, kind=None, order=None): 基于axix 指定的轴，按kind 指定的排序算法（quicksort/mergesort/heapsort），对数组进行排序。order 可以指定一个字符串或字符串列表，用以指示用于排序的比较的字段
transpose(arr, axes=None): axes 指定轴元组，即将原来的(0,1,2,..) 轴序，转置为axes 指定的轴序
rollaxis(arr, axis, start=0): 将axis 轴移到start位置上，其他向后顺延（也就是从start 到axis 向后滚动）
swapaxes(arr, axis1, axis2): 将两个轴交换
flip(arr, axis=None): 基于axis 轴，进行逆序操作
fliplr(arr)、flipud(arr): 对矩阵按对角线进行左右、上下反转

