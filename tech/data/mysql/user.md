# 用户与授权

## 用户
### 创建用户
```
CREATE USER 'username'@'host' IDENTIFIED BY 'password';
```
说明:
+ username - 你将创建的用户名,
+ host - 指定该用户在哪个主机上可以登陆,如果是本地用户可用localhost, 如果想让该用户可以从任意远程主机登陆,可以使用通配符%.
+ password - 该用户的登陆密码(可以为空),如果为空则该用户可以不需要密码登陆服务器.
例子:
```
CREATE USER 'game'@'localhost' IDENTIFIED BY 'game';
```
*注*：这样创建的用户只能连接数据库，并没有任何权限

### 修改用户密码
```
SET PASSWORD [FOR 'username'@'host'] = PASSWORD('newpassword');
```
如果不指定FOR，则表示当前登录用户
或者使用mysqladmin工具：
```
mysqladmin -u用户名 -p旧密码 password 新密码
```

#### 忘记密码
1. 修改配置文件
例如/etc/my.cnf，在[mysqld]的段中加上一句：`skip-grant-tables`
1. 重启mysqld
1. 修改密码
```
update mysql.user set password=PASSWORD('111111') where user='root';
flush privileges;
```
*注意*：完成后去掉配置文件中添加的那行，而后重启mysqld

### 删除用户
```
DROP USER 'username'@'host';
```

### 查看当前所有用户
```
SELECT DISTINCT CONCAT('User: ''',user,'''@''',host,''';') AS query FROM mysql.user;
```


## 授权与撤销
```
GRANT privileges [(columns)] ON databasename.tablename TO 'username'@'host' [IDENTIFIED BY 'password'][WITH GRANT OPTION]
REVOKE privilege ON databasename.tablename FROM 'username'@'host';
```
说明:
+ privileges - 用户的操作权限（详见下）.如果要授予所的权限则使用ALL;
+ columns - 权限应用的列，多个用逗号分隔
+ databasename - 数据库名，可以使用 `*`表示任何数据库；
+ tablename-表名,可以使用`*`表示任何表；
+ username可以为空，则将匹配任何用户，如果用户不存在将自动创建用户
+ 如果指定了password，则老password将被替换
+ 如果想要该用户拥有授权权限，需要加上WITH GRANT OPTION。
+ 撤销权限必须和授权时指定的内容完全对应，过大和过小都不能完成撤销

例子:
```
GRANT SELECT, INSERT ON test.user TO 'game'@'%';
GRANT ALL ON * .* TO 'game'@'%';
```

**注意**：修改用户表（mysql.user）或权限后，需要使用 FLUSH PRIVILEGES; 刷新系统权限表

### 查看权限
```
show grants;
show grants for user@localhost;
```
前者查看自身，后者查看指定用户和host的权限

### 用户权限
#### 第一类
SELECT, INSERT, UPDATE, DELETE
CREATE, ALTER, DROP
INDEX, references
create temporary tables
create view, show view
create routine, alter routine, execute
#### 第二类（全局权限，必须ON *.*）
FILE（文件读写）、PROCESS（线程控制）、RELOAD（缓存相关）、SHUTDOWN（关闭mysql）、super
#### 第三类
ALL（所有）、USAGE（无）
<http://blog.csdn.net/wulantian/article/details/38230635>

### 相关问题
#### 问题 1
> You do not have the SUPER privilege and binary logging is enabled

在 CREATE ROUTINE ,  ALTER ROUTINE ,  CREATE TRIGGER ,  ALTER TRIGGER ,  CREATE FUNCTION  and  ALTER FUNCTION时，需要SUPER权限的是因为：当二进制日志选项开启时，为了主从数据库的复制，需要确保这些不会引入危险语句
解决方法是：
1. 授予用户SUPER权限：`GRANT SUPER ON *.* TO ……`
注：授予SUPER权限必须对全局`*.*`，否则失败
2. 全局打开这些语句的权限（危险）
启动server时修改： `--log-bin-trust-function-creators=1`
client语句： `SET GLOBAL log_bin_trust_function_creators = 1`
3. 关闭二进制日志选项（不复制）：
启动server时，去掉 `--log-bin`

#### 问题 2
`user()`和`current_user()`的区别
+ `user()` 返回你连接server时候指定的用户和主机
+ `current_user()` 返回在mysql.user表中匹配到的用户和主机，这将确定你在数据库中的权限
匹配的原则是精确匹配优先（越精确越优先），host 优于 user 匹配。
所以在进行localhost登录时，''@localhost 会优先于 user@'%' 被匹配，所以`current_user()`将返回前者，拥有较低的权限，即使使用-h 也不行，因为IP会解析为hostname, 而hostname 也有匿名账户
鉴权过程是：
1. 首先检查mysql.user表中的全局权限，如果满足条件，则执行操作
2. 如果上面的失败，则检查mysql.db表中是否有满足条件的权限，如果满足，则执行操作
3. 如果上面的失败，则检查`mysql.table_priv`和`mysql.columns_priv`(如果是存储过程操作则检查`mysql.procs_priv`)，如果满足，则执行操作
4. 如果以上检查均失败，则系统拒绝执行操作
