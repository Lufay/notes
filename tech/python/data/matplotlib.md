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
# 修改全局字体设置，为支持中文的字体，SimHei中文黑体、Kaiti楷体、LiSu隶书、FangSong仿宋、YouYuan幼圆、STSong华文宋体
plt.rcParams['font.sans-serif'] =['SimHei']
# 中文负号（当字体设置支撑中文后,必须设置符号,否则当数值中出现负值时,负号无法显示）
plt.rcParams['axes.unicode_minus']=False
# 修改全局画布对象的分辨率
plt.rcParams['figure.dpi'] =100
# 修改全局画布对象的大小为500X300px
plt.rcParams['figure.figsize']=(5,3)
```

# 点线图
```py
import matplotlib.pyplot as plt

plt.scatter(x, y)   # 直接显示x/y 横纵坐标的打点图
plt.plot(x, y, label="line")      # 基于x/y 横纵坐标的打点连接成线图，label 是该线在图例中的显示文本
plt.plot(x, y, 'y--_',  # 一次性绘制多条线，"y--_" 表示yellow + dashed + _
         x+3, y, "r:x", # "r:x" 表示red + dotted + x
         x+6, y, "b-D") # "b-D" 表示blue + solid + D
plt.show()          # 显示出图
```
可选的关键字参数：
color='green'：线的颜色，g: green，c: cyan，m: magenta，k: black，w: white
linewidth
linestyle：线的样式，solid 实线（-）、'dashed' 虚线（--）、dashdot 点线相间（-.）、dotted 点线（:）、None
marker：点的样式，'.' 点、'o' 圆圈、'*' 星号、'+'、 'x'、'v'、'^'、'<'、'>'、'|'、'_'、D、d 大小菱形
markerfacecolor='blue'：点的颜色
markersize=12：点的大小

也可以使用简写方式作为横纵坐标后的第三个参数

## 定制坐标系
xticks(ticks, labels=None): 展示x 轴都显示哪些刻度（ticks）以及刻度对应的显示文本（labels）
yticks(ticks, labels=None)
其他参数还包括：rotation 旋转角度，color 

### 网格
grid(visable=True, which='both', axis='both')
其他参数还包括：linestyle、color、linewidth

## 图例
legend(loc='upper left')
loc 还可以是"lower right"、"center right"，也可以不设置，则将自动选择位置

## 关键点提示
text(x[1], y[1], s): 直接在指定点位置显示文本
其他参数：verticalalignment（可以缩写为va）可以是top/bottom，herizontalalignment（可以缩写为ha）可以是left/right/center

annotate(text, xy=(x[2], y[2]), xytext=(-5, 5), arrowprops={"facecolor": "black", "shrink": 0.05})
text 是关键点提示文案；xy 是箭头指向的点，xytext 是文案的坐标；arrowprops 是一个字典，key 可以设置以下的值：
+ width: 箭线宽度
+ frac: 箭头占整个箭线的比例
+ headwidth: 箭头宽度
+ shrink: 箭头距数据点和文本之间的空隙 占 数据点至文本距离 的比例
+ facecolor: 颜色

## 标题和坐标名
title(label, fontdict={"fontsize":20}, loc='center')
xlabel(label, fontsize = 16)
ylabel(label, fontdict={"fontsize":12})
设置图标题、坐标名为label，loc 还可以是left/right

# 子视图
subplot(nrows, ncols, index): 表示在指定的行列分区中选择第index 个（从左上为1，向右数），返回一个坐标系对象
subplot2grid(shape, loc, rowspan=1, colspan=1): shape 表示每个维度的长度是多少，loc 表示每个维度的index（从0计），rowspan/colspan 表示跨几格，返回一个坐标系对象

坐标系对象除了一些set_ 方法跟pyplot 有差异外，其他跟其对应函数一致

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

