## 老版本的MySQL配置
```
INSTALL_DIR=$HOME/local/mysql
./configure
--prefix=$INSTALL_DIR       安装目录
--with-charset=utf8         指定默认字符集（默认Latin1(cp1252)字符集
--with-extra-charsets=gbk,utf8,ascii,big5,latin1,binary     服务器需要支持的字符集
--with-tcp-port=3316
--localstatedir=$INSTALL_DIR    指定默认数据库文件保存目录，默认为安装目录下的var目录
--enable-local-infile
--with-unix-socket-path=$INSTALL_DIR/tmp/mysql.sock
--with-mysqld-user=work
--with-debug
--enable-thread-safe-client     编译线程安全版的MySQL客户端库
--with-plugins=all
--with-pthread
--enable-static
--enable-assembler          使用一些字符函数的汇编版本
--without-ndb-debug
--with-client-ldflags       客户端链接参数
--with-mysqld-ldflags       服务器端链接参数
--with-big-tables           在32位平台上支持大于4G行的表
--with-collation            指定默认校对规则。mysql默认使用latin1_swedish_ci校对规则（校对规则必须是字符集的合法校对规则，在mysql中使用SHOW COLLATION语句来确定每个字符集使用哪个校对规则）
```
## 新版本的MySQL
使用cmake进行配置
### 安装cmake
```
./bootstrap --prefix=
gmake
make install
```
### 安装MySQL
```
cmake
-DCMAKE_INSTALL_PREFIX=$INSTALL_DIR         安装目录（默认/usr/local/mysql）
-DSYSCONFDIR=$INSTALL_DIR/etc               配置文件（my.cnf）目录
-DMYSQL_UNIX_ADDR=$INSTALL_DIR/tmp/mysql.sock      默认（默认/tmp/mysql.sock）
-DDEFAULT_CHARSET=utf8                              指定默认字符集（默认latin1）
-DDEFAULT_COLLATION=utf8_general_ci                 指定默认校对规则（默认latin1_swedish_ci）
-DWITH_EXTRA_CHARSETS=all                           支持的扩展字符集  （默认all）
-DENABLED_LOCAL_INFILE=1                            支持使用LOAD DATA INFILE（默认OFF）
-DWITH_INNOBASE_STORAGE_ENGINE=1
-DWITH_ARCHIVE_STORAGE_ENGINE=0
-DWITH_BLACKHOLE_STORAGE_ENGINE=1
-DWITH_PERFSCHEMA_STORAGE_ENGINE=1
-DMYSQL_TCP_PORT=5535                       默认3306
-DENABLED_PROFILING=1                       默认ON
-DWITH_ZLIB=bundled                         压缩库支持（默认system）
-DWITH_DEBUG=0                              调试支持（关闭以提升性能，默认OFF）
-DMYSQL_DATADIR=$INSTALL_DIR/var           数据库存放目录（默认PREFIX/data）
-DINSTALL_SBINDIR=$INSTALL_DIR/libexec/     设置 mysqld目录，为了兼容xdb（默认PREFIX/bin）
-D INSTALL_LIBDIR=$INSTALL_DIR/lib                      库文件目录（默认PREFIX/lib）
-DINSTALL_SCRIPTDIR=$INSTALL_DIR/share/script/        脚本目录（默认PREFIX/scripts）
-DINSTALL_SUPPORTFILESDIR=$INSTALL_DIR/share/support-files/   额外的支持文件目录（默认PREFIX/support-files）
-DINSTALL_MYSQLTESTDIR=$INSTALL_DIR/share/mysql-test/         测试目录（默认PREFIX/mysql-test）
-DINSTALL_MANDIR=$INSTALL_DIR/share/man/              MAN手册目录（默认PREFIX/man）
-DINSTALL_DOCREADMEDIR=$INSTALL_DIR/share/            README文件目录（默认PREFIX）
-DINSTALL_DOCDIR=$INSTALL_DIR/share/docs/             文档目录（默认PREFIX/docs）
```
配置参考：
<http://dev.mysql.com/doc/refman/5.6/en/source-configuration-options.html>
<http://www.blogjava.net/kelly859/archive/2012/09/04/387005.html>
```
make
make install
```
### 启动准备
```
mkdir -p $ INSTALL_DIR/{tmp,log,var,etc}
# touch $ INSTALL_DIR/tmp/mysql.sock
# 拷贝配置
wget ftp://pmo:pmo@ftp.iit.baidu.com/07.online-soft/my_master.cnf -P $ INSTALL_DIR/etc
cd $ INSTALL_DIR/etc
mv my_master.cnf my.cnf
# 或者， 选择一个Mysql自带样例配置文件(如my-medium.cnf等)并cp为my.cnf 
cp support-files/my-medium.cnf my.cnf
```
修改配置文件my.cnf里 client和mysqld中的port号，例如：
```
[client]
#password = your_password
port = 3307
socket = $ INSTALL_DIR/tmp/mysql.sock
[mysqld] 
port = 3307
socket = $ INSTALL_DIR/tmp/mysql.sock
```
初始化授权表（必须指定配置文件路径，其他诸如port、socket、basedir、datadir、log-error、pid-file、user都可以在配置文件中的[mysqld]中设置）
```
./bin/mysql_install_db --basedir= $INSTALL_DIR --defaults-file= $ INSTALL_DIR/etc/my.cnf --datadir= $INSTALL_DIR/var 
```
### 启动mysql 
```
su - work（这里的 - 是为了将环境变量也带过来）
nohup ./bin/mysqld_safe --defaults-file= $INSTALL_DIR/etc/my.cnf &
```
检验是否成功启动：
+ 查看./tmp/mysql.sock，如果存在说明成功启动
+ 运行./bin/mysql，看是否正常进入mysql客户端
+ `ps aux | grep mysql`，查看是否有mysql进程
+ `netstat -tnl | grep 3306`，查看端口是否运行
+ `./bin/mysqladmin version`，读取mysql版本信息

设置root密码
```
mysqladmin -u root password 'new-password'
```
### 登录MySQL客户端
```
./bin/mysql -u user -p[passwd] -h IP -P port -S ./tmp/mysql.sock
```
passwd省略则使用交互式输入密码，但-p不可省略（注意：-p和passwd之间不要有空格 ）
可以直接使用标准输入导入SQL脚本
### 关停MySQL
```
./bin/mysqladmin -u  user -p  [passwd] -h IP -P port shutdown
```
如果未设置MySQL的root密码则默认为空，即直接回车即可（或者不要-p选项）
另外，还可以使用：
```
./share/mysql/mysql.server start/stop/restart
```
**注**：如果使用root用户安装，则需要用mysql用户启动MySQL，并且mysql用户需要有安装目录的权限（只需/data或/var目录的权限即可）：
```
groupadd mysql
useradd -g mysql mysql -s /sbin/nologin（可以加上 -r 表示系统用户，不可用于登录系统）
chown -R mysql:mysql $INSTALL_DIR
```
如果使用其他用户安装，则需要使用该用户启动MySQL。否则，无法启动。
另外，可以在`mysql_install_db`时使用`--user`指定启动MySQL的用户
root用户默认不能远程登录（只能localhost登录），可以使用其他用户远程登录，使用grant授权

添加环境变量：
```
export PATH=$INSTALL_DIR/bin:$PATH
export LD_LIBRARY=$INSTALL_DIR/mysql/lib:$LD_LIBRARY
```
