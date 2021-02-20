# log4j2.xml
日志级别以及优先级排序: OFF > FATAL > ERROR > WARN > INFO > DEBUG > TRACE > ALL

大小写不敏感
```
<?xml version="1.0" encoding="UTF-8"?>
<Configuration status="WARN" monitorInterval="1800">
	<Properties>
		<property name="logFileName">qfxLog4jDemoLog</property>
		<property name="basePath">${sys:user.home}/logs/${logFileName}</property>
	</Properties>
	<Appenders>
		<Console name="STDOUT-APPENDER" target="SYSTEM_OUT">
			<PatternLayout pattern="%-5p %c{2} - %m%n%throwable" charset="UTF-8"/>
		</Console>
		<Console name="STDERR-APPENDER" target="SYSTEM_ERR">
			<ThresholdFilter level="WARN" onMatch="ACCEPT" onMismatch="DENY"/>
			<PatternLayout pattern="%-5p %c{2} - %m%n%throwable" charset="UTF-8"/>
		</Console>
		<File name="log" fileName="${logFilePath}/${logFileName}" append="false">
			<PatternLayout pattern="%d{HH:mm:ss.SSS} %-5level %class{36} %L %M - %msg%xEx%n"/>
		</File>
		<SMTP name="Mail" subject="****异常信息" to="abc@163.com" from="def@163.com" smtpUsername="abc" smtpPassword="LENG****1234" smtpHost="mail.lengjing.info" smtpDebug="false" smtpPort="25" bufferSize="10">
			<PatternLayout pattern="[%-5p]:%d{YYYY-MM-dd HH:mm:ss} [%t] %c{1}:%L - %msg%n" />
		</SMTP>
		<RollingFile name="ERROR-APPENDER" fileName="${ctx:log_root}/${ctx:app_name}/common-error.log"
						filePattern="${ctx:log_root}/${ctx:app_name}/common-error.log.%d{yyyy-MM-dd}"
						append="true">
			<PatternLayout
					pattern="%d [%X{traceId} %X{rpcId} - %X{loginUserEmail}/%X{loginUserID}/%X{remoteAddr}/%X{clientId} - %X{requestURIWithQueryString}] %-5p %c{2} - %m%n%throwable"
					charset="UTF-8"/>
			<Policies>
				<TimeBasedTriggeringPolicy interval="6" modulate="true"/>
				<SizeBasedTriggeringPolicy size="100 MB"/>
			</Policies>
			<DefaultRolloverStrategy max="20"/>
			<Filters>
				<ThresholdFilter level="ERROR"/>
				<RegexFilter regex=".* test .*" onMatch="DENY" onMismatch="NEUTRAL"/>
				<TimeFilter start="05:00:00" end="05:30:00" onMatch="ACCEPT" onMismatch="DENY"/>
			</Filters>
		</RollingFile>
		<RollingRandomAccessFile name="File" immediateFlush="true" fileName="${LOG_HOME}/today.log"
								filePattern="${LOG_HOME}/history-%d{yyyy-MM-dd}.log">
			<!-- same to RollingFile -->
		</RollingRandomAccessFile>
	</Appenders>
	<Loggers>
		<logger name="org.springframework" level="INFO"></logger>
		<logger name="org.mybatis.spring" level="WARN" additivity="false">
			<appender-ref ref="Console"/>
		</logger>
		<AsyncLogger name="LOGGER-NAME" additivity="false" level="${ctx:log_level}">
			<AppenderRef ref="EVAL-TASK-DIGEST-APPENDER"/>
			<AppenderRef ref="ERROR-APPENDER"/>
		</AsyncLogger>

		<Root level="debug">
			<AppenderRef ref="File"/>
		</Root>
		<AsyncRoot name="AsyncLogger" level="trace" includeLocation="true" additivity="false">
			<appender-ref ref="RollingFileError"/>
		</AsyncRoot>
	</Loggers>
</Configuration>
```
Configuration.status: 设置log4j2自身内部的信息输出,可以不设置
Configuration.monitorInterval: 自动检测配置的间隔时间（秒）
Properties: 可以设置变量，后面可以使用`${}` 进行引用
Appenders: 定义日志输出target，[参考](http://logging.apache.org/log4j/2.x/manual/appenders.html)
ThresholdFilter: level 及以上的执行onMatch，以下执行onMismatch，ACCEPT为白名单，可以跳过其他过滤器，DENY为黑名单，NEUTRAL为再看看其他过滤器
File.append=false：同步输出日志到本地文件，每次清空文件重新输入日志,可用于测试
RollingFile.filePattern: 历史日志封存路径，能自动识别zip/gz等后缀，表示历史日志需要压缩
Policies: 若下面的策略仅有一个，则可以省略
TimeBasedTriggeringPolicy.interval: 时间滚动策略,默认0点小时产生新的文件，这里设置每隔几小时产生新文件
TimeBasedTriggeringPolicy.modulate: 产生文件是否以0点偏移时间，false 则相对于前一次偏移
SizeBasedTriggeringPolicy.size: 文件大小滚动策略
DefaultRolloverStrategy.max: 默认为最多同一文件夹下7个文件，这里设置了20
Filters: 若下面的过滤器只有一个，可以省略
immediateFlush: true会严重影响性能
Loggers：定义日志对象，用于LoggerFactory.getLogger 进行获取
logger.name: 可以是一个自定义的名字，也可以是一个包的名字，表示该包下的所有类都可以使用该对象进行打印
logger.additivity: 是否向上传递，例如当命中aa.bb.cc.dd 包的日志对象后，若向上传递，还会继续命中aa.bb.cc 的日志对象
AppenderRef.ref: 这里应用了Appenders 中定义的name 来指定target
AsyncLogger: 异步日志
AsyncLogger.includeLocation：默认不打印location信息，诸如代码文件、行号、类、方法等，true 可以，但会慢30-100倍
Root: 若未命中任何一个logger，则使用

## 异步日志
异步日志在程序的classpath需要加载disruptor-3.0.0.jar或者更高的版本
### 全异步模式
Logger仍然使用`<root>` and`<logger>`
只需要在主程序代码开头，加一句系统属性的代码：
```
System.setProperty("Log4jContextSelector", "org.apache.logging.log4j.core.async.AsyncLoggerContextSelector");
```
或者JVM启动参数（boot.ini）加上
```
-DLog4jContextSelector=org.apache.logging.log4j.core.async.AsyncLoggerContextSelector
```
### 混合模式
Logger使用`<asyncLogger>` and`<asyncRoot>`
