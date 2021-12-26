# iBATIS
iBATIS一词来源于“internet”和“abatis”的组合，是一个基于Java的持久层框架
创建于2002年，后很快加入了Apache，但是2010年又易主到google code，并改名为MyBatis。

设计思想：
应用程序的源代码（即使发展了很多版本）随着时间的流逝最终还是过时了，但他的数据库甚至是SQL本身却仍然很有价值
iBATIS并不试图去隐藏SQL或者避免使用SQL，而是将SQL 从应用程序的源代码中分离出来，使之独立于任何特定的语言或平台
iBATIS就是这样一个混合型的持久层解决方案，吸取了SQL、老式存储过程（“两层应用程序”）、现代存储过程、内联SQL、动态SQL、ORM这些解决方案中最有价值的思想并将他们融会贯通.


## sqlMapConfig
```xml
<properties resource="properties/database.properties"/>

<settings cacheModelsEnabled="true" enhancementEnabled="true"
		lazyLoadingEnabled="false" maxRequests="10000" maxSessions="10000"
		maxTransactions="10000" useStatementNamespaces="false" />

<sqlMap resource="sqlmap/***.xml" />
```
properties 提供一个properties格式的文件，从而使得主配置文件更加通用
settings 属性：
+ lazyLoadingEnabled：默认为true，用于指定当存在相关联的映射语句时，是否使用延迟加载。
+ cacheModelsEnabled：为了充分利用高速缓存技术，还必须为映射语句配置高速缓存模型
+ enhancementEnabled：默认为true，用于指定是否使用cglib中那些已优化的类来提高延迟加载的性能
+ useStatementNamespaces：默认为false，在引用映射语句时，是否需要使用限定名（qualified name）
+ maxRequests、maxSessions、maxTransactions：已废弃

### typeHandler
用于做DB 类型和Java 类型的映射转换，这里是一个全局的设置
```xml
<typeHandler javaType="java.lang.String" jdbcType="CLOB" callback="org.springframework.orm.ibatis.support.ClobStringTypeHandler"/>
<typeHandler javaType="[B" jdbcType="BLOB" callback="org.springframework.orm.ibatis.support.BlobByteArrayTypeHandler"/>
```
这里就给定了BLOB、CLOB 这两种DB 类型的映射转换的全局设置
BLOB 此外还有org.springframework.orm.ibatis.support.BlobSerializableTypeHandler，可以映射为Serializable 对象
处理 LOB 数据时，Spring 要求在事务环境下工作（否则会抛IllegalStateException 异常），所以还必须配置一个事务管理器。
参考<https://developer.ibm.com/zh/articles/j-lo-spring-lob/>

#### 自定义TypeHandler
需要实现TypeHandlerCallback 接口
setParameter(ParameterSetter setter, Object parameter)方法主要是给PrepareStatement赋值. 因此是在insert, update, delete这些操作的时候, 指定传递参数用的。parameter 就是insert, update, delete 这些语句中传入的Java 对象，通过调用setter 的各种set 方法，来转换为DB 对应的字段类型
getResult(ResultGetter getter)方法用来将ResultSet结果集中的内容（通过getter 的各种get 方法）转换到JavaBean中对应的属性.
valueOf(String s)主要是用来当没有指定的值的时候, 指定默认值的. 主要是ResultSet到JavaBean之间的转换的时候会用到. 最好不要返回null值, 它跟nullValue相关

### sqlMap
可以指定namespace 属性，可以限定下面的id 所属

#### typeAlias
```xml
<typeAlias alias="account" type="com.partner4java.demo.entity.Account" />
```
给全限定名起别名
iBATIS 有一些预定义的别名（比如string/hashMap等）

#### sql & include
```xml
<sql id="aaa">xxx</sql>
<include refid="aaa" />
```
用sql 可以定义代码片段，用include 就可以引用
要注意id 的全局唯一性

#### 定义mapper
##### parameterMap
```xml
<parameterMap id="" class="">
	<parameter property=""/>
</parameterMap>
```
parameterMap 的属性：
+ property: 指定DO 对象的字段名
+ column: 指定数据库表的列名
+ javaType: 指定DO 对象的字段类型，通常可以通过反射推断出来，如果无法推断且未指定，则认为Object
+ jdbcType: 指定数据库表的列类型
+ nullValue: 当DO 对象的字段值为该值时，则向DB 写入空值，反之亦然（读取DB 空值，则读出该字段值为该值）
+ mode: 专门用于支持存储过程
+ typeHandler: 想要指定类型处理器（而不是让iBATIS 根据javaType和jdbcType属性来选择类型处理器）

##### resultMap
显式结果映射，
```xml
<resultMap id="" class="">
	<result property="" column="" javaType="" jdbcType="" nullValue=""/>
</resultMap>
```
resultMap 的属性：
+ groupBy: 

result 的属性：
+ property: 指定DO 对象的字段名
+ column: 指定数据库表的列名
+ columnIndex: 可选字段，用于提供列的索引以代替ResultSet中的列名
+ javaType: 指定DO 对象的字段类型，通常可以通过反射推断出来，如果无法推断且未指定，则认为Object
	数组类型比较特别，比如`byte[]` 要写为`[B`
+ jdbcType: 指定数据库表的列类型，对于BLOB/CLOB 要使用typeHandler 以及lobHandler
+ nullValue: 当DO 对象的字段值为该值时，则向DB 写入空值，反之亦然（读取DB 空值，则读出该字段值为该值）
+ select: 用于描述对象之间的关系（即包含其他的实体），其值为一条select 映射语句（外键=#value#）的ID，用以自动加载外键关联的实体
+ typeHandler：作用和全局的typeHandler 一样，这里仅作用于单列

#### 映射语句
```xml
<!-- 单值：使用string 或java.lang.String -->
<!-- 单值：使用long -->
<select id="" resultMap="" parameterClass="string">
	select ...
	where name = #value#
</select>

<insert id="" parameterClass="java.util.List">
	<!--selectKey keyProperty 为model中的主键的属性名，这里会将查出来的值放到该主键属性上 -->
	<selectKey resultClass="long" keyProperty="rId">
		select last_insert_id() as rId
	</selectKey>
</insert>

<update id="" >
</update>

<delete id="" >
</delete>

<statement id="">
</statement>
```
parameterClass: 指定一个类的全限定名（或别名）
parameterMap：指定mapper 的ID
resultClass: 指定一个类的全限定名（或别名）
resultMap：指定mapper 的ID

##### 内联参数
`#xxx#`: 按类型替换
`$xxx$`: 按值替换（小心SQL 注入）
其中xx 可以是fieldName:jdbcType:nullValue，后两部分可省

##### iterate
以一个集合或数组类型的特性作为其property属性值，通过遍历这个集合（数组）来从一组值中重复产生某种SQL小片段
property: 当parameterClass为对象或map 时，其中一个字段为list，使用其指定该字段名或key
conjunction：连接每个迭代的片段的字符串
open：加在每个迭代内容前；如果内容体为空，将不起作用
close：加在每个迭代内容体后；如果内容体为空，将不起作用

###### 实例
+ 数组：无需指定parameterClasss 和property
```xml
<iterate close=")" open="("  conjunction=",">
	<![CDATA[
		#[]#
	]]>
</iterate>
```
+ List类型: parameterClass="java.util.List", 无需指定property
```xml
<iterate open="(" close=")" conjunction=",">
	#wid[]#
</iterate>
```
字符串数组见上，对象数组可以使用objs[].field
+ map 中一个value 为list: parameterClass="map", property=这个list value的key
```xml
<iterate open="(" close=")" conjunction="," property="q.codeSet">
	#q.codeSet[]#
</iterate>
```

##### 动态SQL
`<dynamic>`: 不能嵌套
prepend：加在内容体前（若有open 则在open 之前）；如果内容体为空，将不起作用
open：加在内容体前；如果内容体为空，将不起作用
close：加在内容体后；如果内容体为空，将不起作用

当使用prepend 且其中的内容不为空时，将自动忽略其下第一个标签的prepend

###### 一元标签
如果参数对象的状态结果为真，那么结果SQL中就会包含其内容体
`<isPropertyAvailable>`: 确定property 指定的字段或key 是否存在
`<isNotPropertyAvailable>`
`<isNull>`: 确定property 指定的字段值或value 是否为null（key 不存在也为true）
`<isNotNull>`
`<isEmpty>`: 确定property 指定的字段值或value 是否为空（null、空串、空集合，String.valueOf 后的空串）
`<isNotEmpty>`
property: 参数基准字段
prepend：加在内容体前（若有open 则在open 之前）；如果内容体为空，将不起作用
open：加在内容体前；如果内容体为空，将不起作用
close：加在内容体后；如果内容体为空，将不起作用
removeFirstPrepend: 若为true，则其第一个子标签prepend值无效

###### 二元标签
如果比较结果为true，那么结果SQL中就包含其内容体
`<isEqual>`: `property == compare*`
`<isNotEqual>`: `property != compare*`
`<isGreaterThan>`: `property > compare*`
`<isGreaterEqual>`: `property >= compare*`
`<isLessThan>`: `property < compare*`
`<isLessEqual>`: `property <= compare*`
property: 比较基准字段（被比较字段，用于同compareProperty或者compareValue相比较）
compareProperty、compareValue: 用于和property字段比较的字段或值，二者必选其一
prepend：加在内容体前（若有open 则在open 之前）；如果内容体为空，将不起作用
open：加在内容体前；如果内容体为空，将不起作用
close：加在内容体后；如果内容体为空，将不起作用
removeFirstPrepend: 若为true，则其第一个子标签prepend值无效

###### 参数标签
用来检查某个特定参数是否被传递给了映射语句
`<isParameterPresent>`：确定参数对象是否出现。
`<isNotParameterPresent>`：确定参数对象是否不存在。


## SqlMapClient
iBATIS API的核心是SqlMapClient接口，用于执行全部的数据访问、事务操作
```java
Reader reader = Resources.getResourceAsReader("sql-map-config.xml");
SqlMapClient sqlMap = SqlMapClientBuilder.buildSqlMapClient(reader);
```
reader 用于读取sqlMapConfig 配置
sqlMap 就可以调用接口方法：
+ queryForObject: 从数据库中获取一条记录
+ queryForList: 用于从数据库中返回一行或多行，返回一个列表，可以指定int skip, int max 来进行分页
+ queryForMap: 用于从数据库中返回一行或多行，返回一个map（通过指定key），可以通过指定value 来指指返回指定的字段

+ insert
+ update
+ delete

事务相关:
+ startTransaction()
+ startBatch()
+ executeBatch
+ commitTransaction()
+ endTransaction()
+ getDataSource()
+ openSession


### bean 配置
通常不用代码去配置SqlMapClient，而直接配置bean
```xml
<bean id="xxxDAO" class="com....IbatisXxxDAO" parent="baseSqlMapClientDAO" />

<bean id="baseSqlMapClientDAO" abstract="true">
	<property name="dataSource">
		<ref bean="dataSource"/>
	</property>
	<property name="sqlMapClient">
		<ref bean="xxxSqlMapClient"/>
	</property>
</bean>

<bean id="xxxSqlMapClient" class="org.springframework.orm.ibatis.SqlMapClientFactoryBean">
	<property name="dataSource" ref="dataSource"/>
	<property name="configLocations">
		<list>
			<value>classpath:sqlmap/mysql/*.xml</value>
			<value>classpath:sqlmap/oracle/*.xml</value>
		</list>
	</property>
	<property name="lobHandler" ref="defaultLobHandler"/>
</bean>

<bean id="defaultLobHandler" class="org.springframework.jdbc.support.lob.DefaultLobHandler" lazy-init="true"/>
```
由于Oracle 9i 采用了非 JDBC 标准的 API 操作 LOB 数据，所以不能使用DefaultLobHandler，而应该使用org.springframework.jdbc.support.lob.OracleLobHandler，这个lobHandler还需要org.springframework.jdbc.support.nativejdbc.CommonsDbcpNativeJdbcExtractor 或SimpleNativeJdbcExtractor 这个bean（也需要使用lazy-init）作为nativeJdbcExtractor 的property（需要访问本地 JDBC 对象）

## cacheModel
```xml
<cacheModel type="MEMORY" id="">
    <!-- flushOnExecute标签用于指定当某个映射语句被访问时，其存储结果将被清除。 -->
    <flushOnExecute statement="insert" />
    <flushOnExecute statement="update" />
    <flushOnExecute statement="delete" />
	<!-- flushInterval标签定义一个定时清除的时间间隔 -->
    <!-- 每一种类型的高速缓存模型都有一些专用于它自己配置的特性，property标签就是用于构建一个可传递给高速缓存模型组件以供其初始化的Properties对象。name指定该高速缓存模型特性的名称，value指定特性的值。 -->
    <property name="reference-type" value="WEAK" />
</cacheModel>
```
id 用于映射语句的cacheModel 属性
type 其有效值包括MEMORY（简单放在内存中）、LRU（最近最少使用策略）、FIFO（先入先出策略）和OSCACHE（使用OpenSymphony），也可取值为某个实现CacheController接口的全限定类名
readOnly 是否只读缓存
serialize 读取缓存时，是否进行深拷贝

### 缓存模型类型
+ MEMORY: 基于引用，不同的引用类型指导GC 如何回收
	- WEAK：该对象在垃圾收集器的第一遍收集中就会被移除
	- SOFT：除非确定需要更多的内存，否则垃圾收集器始终不会收集对象
	- STRONG：永远不会被废弃，除非到达了指定清除时间间隔
+ LRU：`<property name="size" value="200" />` 指定固定大小（包含的对象数目）
+ FIFO：同上，仅仅是淘汰策略不同
+ OSCACHE：依赖OSCache的jar。需要放入OSCache需要的配置文件

## 和Spring 的协同
Spring 提供了SqlMapClientDaoSupport 的抽象类，用以DAO 实现的继承，该类有一个SqlMapClientTemplate 的成员就是Spring解决iBatis会话管理和异常处理问题的方案，其包裹了一个SqlMapClient来透明的打开和关闭会话，还捕获抛出的SQLException
同一数据源的DAO 实现的bean可以共有一个父bean（父bean 必须abstract="true" 或lazy-init=true，阻止bean 工厂将其实例化），而在父bean 中指定dataSource 和sqlMapClient
在Spring里，获得SqlMapClient的最佳方式是通过SqlMapClientFactoryBean，所以sqlMapClient bean 的class="org.springframework.orm.ibatis.SqlMapClientFactoryBean"，需要配置其dataSource 和configLocations（configLocation）用以指定一组sqlMapConfig 的配置xml 文件的相对路径（参考上面的bean 配置）

### 事务配置
```xml
<bean id="transactionManager"
	class="org.springframework.jdbc.datasource.DataSourceTransactionManager">
	<property name="dataSource" ref="dataSource"/>
</bean>
```

## 其他
SQL中经常有与xml规范相冲突的字符对xml映射文件的合法性造成影响（比如大于号>、小于号<，虽然可以直接写为`&gt;`/`&lt;`）。
使用`<![CDATA[ sql-statement ]]` 标记来避免冲突，但是在sql-statement 中有动态语句的时候，会导致系统无法识别动态判断部分，所以要缩小范围。

