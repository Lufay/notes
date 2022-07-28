# MySQL 命令和函数
[TOC]
[参考](https://dev.mysql.com/doc/refman/5.7/en/sql-syntax.html)

## SQL 语句
status

### 数据库
创建：`CREATE DATABASE [IF NOT EXISTS] <db_name> [DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci];`
删除：`DROP database <db_name> [if exists <db_name>];`（加上条件，则如果数据库不存在，仅仅是警告，而不是错误）
显示：`SHOW databases;`
当前数据库：`SELECT database();`
声明默认数据库：`use <db_name>`
显示当前数据库中的所有表：`SHOW tables;`
修改字符集：`ALTER database <db_name> CHARACTER SET 'gbk'`

> MySQL 的utf8最多只能支持3bytes长度的字符编码，对于一些需要占据4bytes的文字，mysql的utf8就不支持了，要使用utf8mb4才行。从mysql 8.0开始，mysql默认的CHARSET已经不再是Latin1了，改为了utf8mb4，并且默认的COLLATE也改为了utf8mb4_0900_ai_ci（0900指代unicode比较算法的编号）。
> COLLATE 是用于指定字符的排序规则，每种字符集都有一个默认的排序规则，例如Latin1编码的默认COLLATE为latin1_swedish_ci，GBK编码的默认COLLATE为gbk_chinese_ci，utf8mb4编码的默认值为utf8mb4_general_ci。其中ci 表示Case Insensitive的缩写，即大小写无关，cs 表示Case Sensitive，即大小写敏感的；bin 表示直接将所有字符看作二进制串，然后从最高位往最低位比对；ai表示accent insensitive（发音无关）。utf8mb4_unicode_ci和utf8mb4_general_ci对于中文和英文来说，其实是没有任何区别的。只是对于某些西方国家的字母来说，utf8mb4_unicode_ci会比utf8mb4_general_ci更符合他们的语言习惯一些，general是mysql一个比较老的标准了。
> CHARACTER SET 和COLLATE 都可以设置为全局级别（位于mysql配置文件或启动指令中的collation_connection系统变量）、库级别、表级别、列级别、语句级别（位于order 后，limit前）

### 表
创建：
```sql
CREATE table <表名> (
     <字段名1> <类型1> primary key auto_increment comment '字段的注释'
	 ,<字段名2> <类型2> [CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci] default '' comment '字段的注释'
	 [,.. , <字段名n> <类型n>]
)[ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8_unicode_ci comment='表的注释'];
```
复制创建：`CREATE table <表名> like <已有表>`（仅结构） 或 `CREATE table <表名> like select * from <已有表>`（结构+数据）
展示表信息：`show create table 'tablename'`
显示：`describe 'tablename';`（可以缩写为desc，是对`SHOW columns from`的简略）
修改表名：`rename table 原表名 to 新表名` 或`alter table <表名> RENAME TO <新表名>`;（不能有任何锁定表的事务）
删表：`DROP table 'tablename' [if exists 'tablename'];`
加列：`alter table <表名> ADD [COLUMN] <字段> <类型> <字段限定项> [FIRST|AFTER <col>];`（默认加到最后一列，FIRST加到第一列，AFTER可以指定在哪一列后）
加索引：`alter table <表名> ADD INDEX <索引名> (<字段名1> [, <字段名2>, ...]), [ADD INDEX <索引名>(...)];`
加字段限制：`alter table <表名> ADD <限制>(<字段名>)`
删列、索引、限制：将上面的add变为DROP
修改列：将上面的add变为`change <old_field_name> <new_field_name> <field_type>`
仅改名：将上面的add变为`RENAME COLUMN <old_field_name> TO <new_field_name>`
仅改类型和约束：将上面的add变为`MODIFY COLUMN <field_name> <type> <限制>`
清空表（慢，有日志）： `DELETE FROM '表名' WHERE 1`
清空表（快，无日志）：`TRUNCATE TABLE '表名'`

#### 表和字段的限制项
```sql
primary key
foregin key(<字段名>) references tableName(filedName) [on delete|update casecade | no action]
not null
unique
default now()
check()
auto_increment
```
`primary key`相当于unique和not null

### DML
```sql
SELECT [DISTINCT] <字段1, 字段2, ...>
FROM <表名1> JOIN <表名2> ON <条件表达式>
WHERE <条件表达式>
[GROUP BY <字段1, 字段2, ...>] [WITH ROLLUP] [HAVING <条件表达式>]
[ORDER BY <字段1 [desc/asc], 字段2 [desc/asc], ...>]
[LIMIT [offset, ]row_count]
[FOR UPDATE [OF column_list][WAIT n|NOWAIT][SKIP LOCKED]]
```
+ DISTINCT 可以用于去重（必须是后面的字段全相同才是重复）
+ <表名>可以是一条嵌套的SELECT 语句（可以用小括号括住，然后用AS 命名这个嵌套表）
+ 若连接条件的列名相同，如`ON a.id = b.id and a.name = b.name`可以被简写为USING(id, name)
+ 三个条件表达式执行时机是：
  + 首先是on 表达式，作用于两表连接阶段（如果是左连接，则对左表的筛选不会生效，因为左表记录不会考虑是否满足on 条件都会出现在结果表中）
  + 然后是where 表达式，作用于连接后的中间结果（尚未分组，不能用聚合表达式）
  + 最后是having 表达式，作用于分组后的中间结果（因此可以使用聚合函数）
+ WITH ROLLUP 是MySQL的扩展，其他有不同的格式，加上该语句，在分组的最后会有一个全体数据的汇总行（分组key 为NULL）
+ 如果同时使用GROUP BY 和ORDER BY 的话，因为逻辑是先分组后排序，所以只能按分组字段或聚合字段进行排序，而不能组内排序
+ LIMIT有两种语法：
`LIMIT row_count` 相当于`LIMIT 0 row_count`
`LIMIT offset, row_count`
offset 表示从第offset条记录之后开始取（第一条是偏移是0），`row_count` 表示只取回`row_count`行记录（如果想要剩下所有，取-1）
也可以使用OFFSET 关键字单独设置offset
+ 随机选取使用`ORDER BY rand() LIMIT n`可以随机选取n 个
+ 按指定顺序排序 `ORDER BY instr(',3,5,1,' , ','+ltrim(id)+',')`
+ 多条SELECT 语句可以使用UNION 或UNION ALL 取并集（要求同列同类型），区别是前者会去重，后者不会
	- MySQL 不支持INTERSECT 和MINUS
	INTERSECT 的替代方案是join using，或者用union all 之后统计重复度为2的
	MINUS 的替代方案是where (fa, fb) not in (select a, b from tb)，或者用left join 判断tb.id is null
+ FOR UPDATE 可以给选定的行加上行锁（必须执行在事务里，事务结束才会释放锁；必须使用主键的等值查询，否则为表锁），其他update/delete还是另一个for update 语句都会block 住，仅适用于InnoDB，Myisam 只支持表级锁
	OF 子句用于指定即将更新的列，即锁定行上的特定列
	WAIT 子句指定等待其他用户释放锁的秒数，防止无限期的等待（报告“资源已被占用”）
	nowait子句的作用就是避免进行等待，当发现请求加锁资源被锁定未释放的时候，直接报错返回（“资源正忙”）
	若使用了skip locked，则可以越过锁定的行，不报告异常

```sql
insert into <表名> [( <字段名1>[,... <字段名n>])] values ( <值1> )[,... ( <值n> )] [ON DUPLICATE KEY update 字段=新值,...]

insert into <表名> [( <字段名1>[,... <字段名n>])] <SELECT 语句> [ON DUPLICATE KEY update 字段=新值,...]

delete from <表名> where 表达式

update <表名> set 字段=新值,... where <条件>

replace <表名> set 字段=新值,... where <条件>
```
delete 的where 表达式中不允许嵌套同表的查询语句
replace 是insert + update，表示如果key 冲突则覆盖，否则insert

### 表达式
#### 条件表达式
格式1：
```sql
CASE <字段>
	WHEN <字段值1> THEN <返回值1>
	WHEN <字段值2> THEN <返回值2>
	ELSE <返回值3>
END
```
格式2：
```sql
CASE
	WHEN <条件表达式1> THEN <返回值1>
	WHEN <条件表达式2> THEN <返回值2>
	ELSE <返回值3>
END
```
如果没有ELSE，且没有满足条件的WHEN，则返回NULL
多个WHEN 不会判断互斥，第一个满足就返回

### 触发器
```sql
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
```sql
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

### 函数
#### 字符串函数
CHAR(x): 可以将整数x 转换为对应的字符，比如CHAR(13) 表示换行
CONCAT(exp1, exp2,...): 连接，若有一个值为NULL，则返回NULL，MySQL 可以直接使用空格将多个字符串连接在一起
CONCAT_WS(seperator, exp1, exp2,...): 使用分隔符连接，会忽略NULL的值
replace(str, sub, rep): 将str 中的sub 替换为rep 返回
length(str): 返回字符串所占的字节数。一个汉字或是中文符号是算三个字节,一个数字或字母或英文符号算一个字节。
char_length: 返回字符串所占的字符数，不管汉字还是数字或者是字母或者符号(不分中英文)都算是一个字符。
`instr`: 类似string.find，不区分大小写，找得到返回位序，找不到返回0
`substring_index(str, delim, idx)`: 若idx为正数，则返回str 中第idx个 delim 位置之前的子串；若idx 为负，则返回str 中倒数-idx 的delim 位置之后的子串

#### 类型转换
CAST(var AS INT): 转为指定的类型

#### 分组聚合函数
SUM()、MAX()、MIN()、AVG()
`GROUP_CONCAT`: 分组连接，格式：
```
GROUP_CONCAT([DISTINCT] exp1, exp2, ...
    [ORDER BY expression [ASC/DESC]]
    [SEPARATOR sep])
```
该函数是一个聚集函数（类似sum），可以将分组中的多行的一个表达式合并为一行，可以去重、指定排序方式（默认升序）和分隔符（默认使用逗号）
该函数默认忽略表达式值为NULL的行，若所有行均为NULL，则返回NULL
该函数的最大返回长度默认是1024，可以通过在SESSION或GLOBAL级别设置group_concat_max_len系统变量来扩展最大长度：
```
SET @@GROUP_CONCAT_MAX_LEN=4
SET [SESSION | GLOBAL] group_concat_max_len = 4;
```

#### 逻辑函数
if(predict, true_res, false_res): predict 为真返回true_res，否则返回false_res
IFNULL(exp, res): exp 为非NULL返回exp，否则返回res
coalesce(a, b, c,...): 从a, b, c,... 中选出第一个不是NULL的值返回，若都是NULL，则返回NULL

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
