# bootstrap 风格的select 标签
[TOC]

[官网](http://silviomoreto.github.io/bootstrap-select/)

## 依赖
jQuery v1.8.0+
Bootstrap 的 dropdown.js 组件和CSS

## 用法
最简用法：直接在select 标签上添加 selectpicker 的class 即可

### 更多配置
```
$('.selectpicker').selectpicker({
	style: 'btn-info',
 	size: 4
});
```

### 事件

### API

## 功能
支持placeholder（title标签）和展示方式调整（option的title和value，计数）
支持带label 的optgroup
支持搜索（可以使用附加关键字辅助搜索）
支持多选（列表勾选方式）
支持限制最大选择数（支持select 和optgroup 级别）
支持全选和全不选
支持选项分隔线和header
支持禁用select, group 和 option
自适应dropup or dropdown（dropupAuto: true）
展现样式（btn样式，width，icon，Custom content，Subtext，列表size）

## 类比
[select2](../jQuery/select2.md)
优点：
搜索附加关键字
optgroup级别显示最大选择数
全选和全不选按钮
分割线和header

问题：
1. select title 变化如何更新
由于bootstrap-select 会把`<select>`元素转换为一个button+dropdownMenu的div，而此时在调整select 元素的title 属性也无法改变button 中显示的内容（即使调用render 或refresh 接口也不行），除非先用destroy 接口清除该转化（注意：如果当前有title属性，清除后会留下一个title的option，需要自己手动清除）而后再调用selectpicker() 进行重建。
