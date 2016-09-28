# MySQL 命令

### 数据库
创建：`CREATE DATABASE [IF NOT EXISTS] db_name [DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci];`
删除：`drop database  'DBname' [if exists 'DBname'];`（加上条件，则如果数据库不存在，仅仅是警告，而不是错误）
显示：`show databases;`
声明默认数据库：`use 'DBname'`
显示当前数据库中的所有表：`show tables;`

### 表
创建：
```
create table <表名> (
     <字段名1> <类型1> [,..<字段名n> <类型n>]
)[engine=InnoDB default charset=utf8];
```
显示：`describe 'tablename';`（对`show columns from`的简略）
删除：`drop table 'tablename';`
修改：`alter table <表名> add <字段> <类型> <其他>;`
加索引：`alter table <表名> add index <索引名> (<字段名1> [, <字段名2>, ...]);`
加字段限制：`alter table <表名> add <限制>(<字段名>)`
去除：将上面的add变为drop
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
select <字段1，字段2，...> from <表名> where <表达式> [ORDER BY ...] [LIMIT [offset, ]row_count]
insert into <表名> [( <字段名1>[,... <字段名n>])] values ( <值1> )[,... ( <值n> )]
delete from <表名> where 表达式
update <表名> set 字段=新值,... where <条件>
replace
```
LIMIT有两种语法：
`LIMIT row_count` 相当于`LIMIT 0 row_count`
`LIMIT offset, row_count`
offset 表示从第offset条记录之后开始取，`row_count` 表示只取回`row_count`行记录

### 触发器
```
create trigger tri_name
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
create trigger ...
begin
......;
end//
delimiiter ;
```
小心递归触发
创建、修改和删除触发器都会写入二进制日志中，因此如果需要主从复制，就需要SUPER权限
删除表后，则表上的触发器都会被级联删除

<http://www.cnblogs.com/lyhabc/p/3822267.html>
