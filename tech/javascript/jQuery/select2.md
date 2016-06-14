# 基于jQuery优化的select 标签
[TOC]

[官网](http://select2.github.io)

## 依赖
jQuery

## 用法
```
<select>
    <option>aaa</option>
    ...
</select>

$('select').select2();
```

### 更多配置

### 事件

### API

## 功能
支持placeholder
支持带label 的optgroup
支持搜索（可以自定义匹配函数）
支持多种数据源（js数组，ajax）
支持多选（框内标签方式，支持用户新增标签）
支持限制最大选择数（支持select 和optgroup 级别）
支持禁用select, group 和 option
可编程性：可以通过templateResult指定的函数修改option 或optgroup 的展现方式
支持百分比width


## 类比
[bootstrap-select](../bootstrap/bootstrap-select.md)
优点：
多选的tag
多种数据源
可自定义搜索匹配
不依赖bootstrap
可以使用Yii2-widget引入
