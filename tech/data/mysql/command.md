# MySQL 命令
[TOC]
[参考](https://dev.mysql.com/doc/refman/5.7/en/sql-syntax.html)

status

### 数据库
创建：`CREATE DATABASE [IF NOT EXISTS] db_name [DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci];`
删除：`DROP database  'DBname' [if exists 'DBname'];`（加上条件，则如果数据库不存在，仅仅是警告，而不是错误）
显示：`SHOW databases;`
当前数据库：`SELECT database();`
声明默认数据库：`use 'DBname'`
显示当前数据库中的所有表：`SHOW tables;`

### 表
创建：
```
CREATE table <表名> (
     <字段名1> <类型1> [,..<字段名n> <类型n>]
)[engine=InnoDB default charset=utf8];
```
显示：`describe 'tablename';`（可以缩写为desc，是对`SHOW columns from`的简略）
删除：`DROP table 'tablename';`
修改：`alter table <表名> add <字段> <类型> <其他>;`
加索引：`alter table <表名> add index <索引名> (<字段名1> [, <字段名2>, ...]);`
加字段限制：`alter table <表名> add <限制>(<字段名>)`
去除：将上面的add变为DROP
修改：将上面的add变为`change old_field_name new_field_name field_type`
修改表名：`rename table 原表名 to 新表名`;（不能有任何锁定表的事务）
清空（慢，有日志）： `DELETE FROM '表名' WHERE 1`
清空（快，无日志）：`TRUNCATE TABLE '表名'`

#### 表和字段的限制项
```
primary key
foregin key(<字段名>) references tableName(filedName) [on delete|update casecade | no action]
not null
unique
default '0'
check()
auto_increment
```
`primary key`相当于unique和not null

### DML
```
SELECT [DISTINCT] <字段1，字段2，...>
FROM <表名1> JOIN <表名2> ON <条件表达式>
WHERE <条件表达式>
[GROUP BY <字段1，字段2，...>] [HAVING <条件表达式>]
[ORDER BY <字段1 [desc/asc]，字段2 [desc/asc]，...>]
[LIMIT [offset, ]row_count]
```
+ DISTINCT 可以用于去重
+ <表名>可以是一条嵌套的SELECT 语句（可以用小括号括住，然后用AS 命名这个嵌套表）
+ `ON a.id = b.id and a.name = b.name`可以被简写为USING(id, name)
+ LIMIT有两种语法：
`LIMIT row_count` 相当于`LIMIT 0 row_count`
`LIMIT offset, row_count`
offset 表示从第offset条记录之后开始取（第一条是偏移是0），`row_count` 表示只取回`row_count`行记录（如果想要剩下所有，取-1）
也可以使用OFFSET 关键字单独设置offset
+ 多条SELECT 语句可以使用UNION 或UNION ALL 取并集（要求同列同类型），区别是前者会去重，后者不会
	- MySQL 不支持INTERSECT 和MINUS
	INTERSECT 的替代方案是join using，或者用union all 之后统计重复度为2的
	MINUS 的替代方案是where (fa, fb) not in (select a, b from tb)，或者用left join 判断tb.id is null

```
insert into <表名> [( <字段名1>[,... <字段名n>])] values ( <值1> )[,... ( <值n> )] [ON DUPLICATE KEY update 字段=新值,...]
insert into <表名> [( <字段名1>[,... <字段名n>])] <SELECT 语句> [ON DUPLICATE KEY update 字段=新值,...]
delete from <表名> where 表达式
update <表名> set 字段=新值,... where <条件>
replace <表名> set 字段=新值,... where <条件>
```
replace 是insert + update，表示如果key 冲突则覆盖，否则insert

### 表达式
#### 条件表达式
格式1：
```
CASE <字段>
	WHEN <字段值1> THEN <返回值1>
	WHEN <字段值2> THEN <返回值2>
	ELSE <返回值3>
END
```
格式2：
```
CASE
	WHEN <条件表达式1> THEN <返回值1>
	WHEN <条件表达式2> THEN <返回值2>
	ELSE <返回值3>
END
```
如果没有ELSE，且没有满足条件的WHEN，则返回NULL
多个WHEN 不会判断互斥，第一个满足就返回

### 触发器
```
CREATE trigger tri_name
before/after insert/update/delete
on tb_name for each row
tri_body
```
操作完成前触发用before，之后用after；如果before触发器执行失败，sql也会执行失败；如果sql执行失败，after触发器不会执行；如果after执行失败，则sql执行会回滚（innodb）。
在进行insert时，可以使用new引用新加入的记录（读写）
在进行delete时，可以用old引用原有的记录（只读），
没有这些前缀表示当前的记录
`tri_body`如果是单条语句可以直接写；如果是多条语句，需要使用`BEGIN ... END`，因为其中也要使用`;`作为语句分隔，因此为了和全局的`;`相区分，就必须使用delimiter调整全局分隔符：
```
delimiter //
CREATE trigger ...
begin
......;
end//
delimiiter ;
```
小心递归触发
创建、修改和删除触发器都会写入二进制日志中，因此如果需要主从复制，就需要SUPER权限
删除表后，则表上的触发器都会被级联删除

<http://www.cnblogs.com/lyhabc/p/3822267.html>


## mysqldump 导出
注意：导出时，最好一个表一个表的导出，因为会有空间限制。
```
mysqldump -u <user_name> -p[password] -h host <db_name> [<tb_name>] -w "where_condition"
```
该工具会将数据库（表）导出为SQL语句到标准输出
其他选项：
-d, --no-data：只需要结构而不需要数据
-n, --no-create-db：只需要数据而不需要建库
-t, --no-create-info：只需要数据而不需要建表
-R, --routines：导出存储过程和函数
--triggers：导出触发器
--add-drop-database，--add-drop-table：在每个CREATE语句前加上一个DROP
-x, --lock-all-tables：导出过程中锁住所有数据库的所有表（全局读锁），对于MyISAM 表，可以只锁住当前表，-l, --lock-tables（默认启动）
如果数据表不是采用默认的 latin1 字符集的话，那么导出时必须指定该选项，指定导出数据的字符集，--default-character-set
默认开启-K, --disable-keys，在insert语句的开头和结尾加上`/*!40000 ALTER TABLE tb_name DISABLE KEYS */; `和`'/*!40000 ALTER TABLE tb_name ENABLE KEYS */;` 在插入完成后才重建索引，提高插入效率
默认开启--opt，快速导出选项集合
