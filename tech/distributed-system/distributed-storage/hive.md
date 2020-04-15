# Hive

1. 字符串连接和拆分
`CONCAT()` & `CONCAT_WS()`
`SPLIT()` & `SPLIT_PART()`

1. 排序行号
`ROW_NUMBER() OVER(PARTITION BY group_col ORDER BY score DESC) AS rank_num`
按`group_col` 进行分组排序后，给每个记录一个排序行号，每个分组从1 开始

1. 分组聚集连接
`COLLECT_LIST(col)` & `COLLECT_SET(col)`
类似于COUNT/SUM/MAX 等聚集函数，使用在group by 场景，将指定的列按分组多行连接成一列（可以使用size(col)统计，也可以使用col[i] 进行分量引用）
区别是后者会做去重处理
