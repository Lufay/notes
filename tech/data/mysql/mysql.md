# MySQL 内置

## mysql.help_topic 表
帮助信息主题表(
    help_topic_id,  # 递增ID，从0开始，最大值为636
    name,           # 帮助主题名称
    help_category_id,   # 帮助主题类别ID，对应help_category表中的help_category_id字段
    description,    # 帮助主题的详细信息
    example,        # 帮助主题的示例信息
    url             # 对应在MySQL官方在线手册中的URL链接地址
)
该表常用于一行拆解为多行，使用非等值连接（本质上是笛卡尔积筛选）
比如 T.tags 是一个使用`,`分隔的字符串字段
```sql
select T.*, substring_index(
    substring_index(T.tags, ',', topic.help_topic_id + 1), ',', -1
) as tag
from T join mysql.help_topic topic on topic.help_topic_id < (length(T.tags) - length(replace(T.tags, ',', '')) + 1);
```

如果该表无权限或者长度不够，可以选择自己构造自然序列表
```sql
-- 测算所需行数
select max(length(T.tags) - length(replace(T.tags, ',', '')) + 1)
from T

-- 构造自然序列表
SELECT
	@i := @i + 1 AS id
FROM
	( SELECT @i := -1 UNION           -- 给i赋初值，确保id 从0开始
    SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 ) t1,
	( SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 ) t2
```
如上，使用笛卡尔积构造了一个5*4=20 行的表

## information_schema 库
保存MySQL的元数据信息

### INNODB_TABLESTATS 表
该表记录了所有ENGINE=InnoDB 的表