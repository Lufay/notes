Matplot
基于跨平台的工具包的绘图库
[用户手册](https://matplotlib.org/stable/users/index.html)
[实例](https://matplotlib.org/3.7.0/gallery/index.html)

# 安装
`pip install matplotlib`

查看版本
```py
import matplotlib
matplotlib._version.version
```

全局配置
```py
# 返回默认配置位置
matplotlib.matplotlib_fname()

# 修改全局字体设置，为支持中文的字体，SimHei中文黑体、Kaiti楷体、LiSu隶书、FangSong仿宋、YouYuan幼圆、STSong华文宋体
plt.rcParams['font.sans-serif'] =['SimHei']
plt.rcParams['font.family']='STFangsong'    # 字体名
plt.rcParams['font.style']=    # 'normal' or 'italic'
plt.rcParams['font.size']=      # 整数字号 or 'large' or 'x-small'
# 中文负号（当字体设置支撑中文后,必须设置符号,否则当数值中出现负值时,负号无法显示）
plt.rcParams['axes.unicode_minus']=False
# 修改全局画布对象的分辨率
plt.rcParams['figure.dpi'] =100
# 修改全局画布对象的大小为500X300px
plt.rcParams['figure.figsize']=(5,3)
```

# 点线图
横纵坐标既支持python list 也支持numpy.array

```py
import matplotlib.pyplot as plt

plt.scatter(x, y,   # 直接显示x/y 横纵坐标的打点图
            sizes=[20,50,100,200,500,1000])   # 可以决定每个点的大小（可选参数）
plt.plot(x, y, label="line")      # 基于x/y 横纵坐标的打点连接成线图，label 是该线在图例中的显示文本
# 一次性绘制多条线，如果不指定颜色，会自动选择不同颜色（除了单字母颜色，还可以使用类似#008000的RGB编码）
plt.plot(x, y, 'y--_',  # "y--_" 表示yellow + dashed + _
         x+3, y, "r:x", # "r:x" 表示red + dotted + x
         x+6, y, "b-D") # "b-D" 表示blue + solid + D
plt.show()          # 显示出图
```
可选的关键字参数：
color='green'：线的颜色，g: green，c: cyan，m: magenta，k: black，w: white
linewidth
linestyle：线的样式，solid 实线（-）、'dashed' 虚线（--）、dashdot 点线相间（-.）、dotted 点线（:）、None
marker：点的样式，'.' 点、',' 极小点、'o' 圆圈、'*' 星号、'+'、 'x'、'v'、'^'、'<'、'>'、'|'、'_'、D、d 大小菱形
markerfacecolor='blue'：点的颜色
markersize=12：点的大小

也可以使用简写方式作为横纵坐标后的第三个参数

## 定制坐标系
xlim(left=None, right=None): 设置并返回当前显示的坐标轴区间
ylim(left, right)
xticks(ticks, labels=None): 展示x 轴都显示哪些刻度（ticks）以及刻度对应的显示文本（labels）
yticks(ticks, labels=None)
其他参数还包括：rotation 旋转角度，color 
tick_params(axis='both', **kwargs): axis 还可以是x, y，表示对谁作用
其他参数包括direction（坐标刻度朝in,out,inout）, length, color, width, pad（刻度线与刻度标签之间的间隔）,labelsize, labelrotation

### 网格
grid(visable=True, which='both', axis='both')
其他参数还包括：linestyle、color、linewidth

## 图例
legend(loc='upper left')
一般绘线的函数会带上label参数，这样legend就会直接使用该参数
loc 还可以是"best"(1), "upper right"(2), "lower right"(5), "center right"，也可以不设置，则将自动选择位置
fontsize： int或float或{‘xx-small’, ‘x-small’, ‘small’, ‘medium’, ‘large’, ‘x-large’, ‘xx-large’}
shadow: 是否为图例边框添加阴影

## 关键点提示
text(x[1], y[1], s): 直接在指定点位置显示文本
其他参数：verticalalignment（可以缩写为va）可以是top/bottom，herizontalalignment（可以缩写为ha）可以是left/right/center
fontweight：设置字体粗细，可选参数 [‘light’, ‘normal’, ‘medium’, ‘semibold’, ‘bold’, ‘heavy’, ‘black’]
alpha：透明度，参数值0至1之间
rotation： (旋转角度)可选参数为:vertical,horizontal 也可以为数字
backgroundcolor：背景颜色
color： 字体颜色

annotate(text, xy=(x[2], y[2]), xytext=(-5, 5), arrowprops={"facecolor": "black", "shrink": 0.05})
text 是关键点提示文案；xy 是箭头指向的点，xytext 是文案的坐标；arrowprops 是一个字典，key 可以设置以下的值：
+ width: 箭线宽度
+ frac: 箭头占整个箭线的比例
+ headwidth: 箭头宽度
+ headlength
+ shrink: 箭头距数据点和文本之间的空隙 占 数据点至文本距离 的比例
+ facecolor: 颜色

## 标题和坐标名
```py
title(label, fontdict={"fontsize":20}, loc='center')    # loc 还可以是left/right
xlabel(label, fontsize=16)    # loc 可以是center/left/right
ylabel(label, fontdict={"fontsize":12}) # loc 可以是center/top/bottom
```
设置图标题、坐标名为label

### 获取轴对象
```py
# ax 为子图对象
ax.spines["left"]   # 左侧的轴对象，可以调用其方法进行控制
ax.spines["bottom"]
ax.spines["top"]
ax.spines["right"]
```

#### 方法
set_color("darkblue")
set_linewidth(3)
set_visible(False)

# 画布
创建一个指定大小的画布，如果没有创建会默认使用一个
fig = plt.figure(num=1,figsize=(4,4))
画布对象并不直接用于绘图，跟画布相关的操作是输出图像

用于绘图的对象是子视图，plt下的模块函数都是在默认画布下的一个默认子视图进行绘图

fig.add_subplot(221)    # 返回 2*2 子图的第一个（左上）
fig.add_subplot(222)    # 返回 2*2 子图的第一个（右上）
fig.add_subplot(223)    # 返回 2*2 子图的第一个（左下）
fig.add_subplot(224)    # 返回 2*2 子图的第一个（右下）
这种子图默认是均分的，如果想要非均分的分块，可以使用网格
```py
import matplotlib.gridspec as gridspec

gs = gridspec.GridSpec(3,3)   # 3*3 网格
ax1=fig.add_subplot(gs[0,:])    # 第1行占满
ax2=fig.add_subplot(gs[1,:-1])  # 第2行，0到倒数1列
ax3=fig.add_subplot(gs[1:,-1])  # 第1到最终行，倒数1列
ax4=fig.add_subplot(gs[2,0])    # 第3行，第1列
ax5=fig.add_subplot(gs[2,1])    # 第3行，第2列
```

## 子视图
一个子视图就是一个坐标系对象

subplot(nrows, ncols, index): 表示在指定的行列分区中选择第index 个（从左上为1，向右数），返回一个坐标系对象
subplots(): 一次生成多个子图，返回一个(画布对象, 坐标系对象集合) 的二元组
subplot2grid(shape, loc, rowspan=1, colspan=1): shape 表示每个维度的长度是多少，loc 表示每个维度的index（从0计），rowspan/colspan 表示跨几格，返回一个坐标系对象

坐标系对象除了一些set_ 方法跟pyplot 模块函数有差异外，其他跟其对应函数一致
特有方法：
set_xticklabels(labels, fontproperties="SimHei", fontsize=12): # 设置刻度标签（字体属性可选）
set_yticklebels(labels)

## 三维绘图
```py
from mpl_toolkits.mplot3d import Axes3D     # 必须引入该包
ax: Axes3D = plt.subplot(1, 1, 1, projection='3d')  # 使用projection 创建3维坐标图

ax.plot(x, y, z, c='r', marker='>'): c 就是color 参数

x, y = np.meshgrid(x, y)    # 将x, y 变为二维数组
z = np.sin(x+y)
ax.plot_surface(x, y, z, cmap='Spectral')   # 用色带指定的颜色绘制三维平面
```

### 边框
```py
ax.spines['top'].set_color('none')  # 不显示上边框
ax.spines['left'].set_position(('data',0))  # 移动左边框，data 表示移动到指定刻度，axes 表示移动比例（0~1），outward 表示向外移动几个数据点
```

# 静态图像
静态图可以表示为一个M*N*3（RGB像素）或M*N*4（RGBA）的三维数组形式

```py
import matplotlib.image as mpimg
img = mpimg.imread('a.png')     # 读入图像文件
plt.imshow(img) # 将图像显示在坐标中

gray_img = img[:, :, 0]     # 提取一个通道的颜色值成为灰度图像
plt.imshow(gray_img, cmap='binary') # 黑白灰度图，其他还有'winter' 蓝绿冷色，'Spectral' 彩虹谱
```

## 颜色直方图
常用来进行颜色均衡化或增强对比度

```py
plt.hist(img.ravel(), bins=256)
```
bins 表示坐标粒度，越大越精细

## 插值
较小的像素点填充较多像素点的画布，这些多出来的像素就需要进行插值
imgshow 还有interpolation 这个参数可以指定插值算法，比如'none', 'nearest', 'bicubic', 'sinc', 'bilinear', 'spline16', 'spline36', 'hanning', 'hamming', 'hermite', 'kaiser', 'quadric', 'catrom', 'gaussian', 'bessel', 'mitchell', 'lanczos'

# 等值图
plt.contour(x, y, z): 以x,y 为自变量，以z 的值做等值线，返回一个等值线对象cs
plt.contourf(x, y, z)：绘制实心等值

plt.clabel(cs) 给一个等值线图的等值线上标上z 值

# 输出
## 直接保存
保存为jpg 或 png 格式可以直接使用`plt.savefig(path)` 进行保存