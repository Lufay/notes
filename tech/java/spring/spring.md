# Spring
<https://spring.io/guides>
<http://c.biancheng.net/spring/>
一站式的轻量级的java开发框架，核心是控制反转（IOC）、依赖注入（DI）和面向切面（AOP），对WEB层、业务层、持久层等都提供了多种配置解决方案
IOC 和DI 保证了松耦合，不主动指定具体类型去查找和创建，而被动的获取依赖对象，而真正的实现类通过配置明确；
AOP 分离了应用的业务逻辑与系统级服务，进行内聚性的开发

+ SpringMVC
在Spring 基础之上的一个MVC框架，属于WEB层的解决方案
原理图：![spring-mvc-flow](./spring-mvc.jpg)
类似的竞品有
	- Struts2 功能虽然强大，但历史上漏洞较多，而且不及SpringMVC 的开发效率和性能;
	- Vert.x、jFinal
+ SpringBoot
针对SpringMVC 配置繁琐的问题，遵循默认优于配置的理念，一定程度上取消xml配置，简化了插件配置流程，集成了快速开发的spring多个插件，同时自动过滤不需要配置的多余的插件，不开发前端视图，是一套快速配置开发的脚手架，能快速开发单个微服务（独立部署、独立访问、水平扩展）；
spring-boot-starter-web模块中包含有一个内置tomcat，可以直接提供容器使用，因此都不用额外的WEB容器，直接生成jar包即可执行
+ SpringCloud
大部分的功能插件都是基于springBoot去实现的，springCloud关注于全局的微服务整合和管理，将多个springBoot单体微服务进行整合以及管理；
简化了分布式系统基础设施的开发, 如服务发现注册、配置中心（协同）、消息总线（通信）、负载均衠、断路器（熔断）、数据监控等

## bean
Spring的依赖注入的最大亮点是所有的Bean对Spring容器的存在是没有意识的，我们可以将Spring容器换成其他的容器，Spring容器中的Bean的耦合度因此也是极低的。
但Bean 需要意识到容器的存在才能调用容器所提供的资源。Spring提供的一系列接口Spring Aware来实现具体的功能。
Aware是一个具有标识作用的超级接口，实现该接口的bean是具有被spring 容器通知的能力的，而被通知的方式就是通过回调。

常见Aware的作用
+ BeanNameAware 获得到容器中Bean的名称
+ BeanFactoryAware 获得当前bean Factory,从而调用容器的服务
+ ApplicationContextAware 获得当前的application context从而调用容器的服务
+ MessageSourceAware 得到message source从而得到文本信息
+ ApplicationEventPublisherAware 应用时间发布器,用于发布事件
+ ResourceLoaderAware 获取资源加载器,可以获得外部资源文件
因为ApplicationContext接口集成了MessageSource接口、ApplicationEventPublisher接口和ResourceLoader接口，因此当Bean继承自ApplicationContextAware的时候就可以得到Spring容器的所有服务


### 初始化
在bean的xml定义中指定init-method属性
给类的方法添加@PostConstruct注解

### 依赖注入
#### bean 生产
##### 在类定义上使用注解
+ @Component: 泛组件
+ @Service: Service层
+ @Controller: Controller层
+ @Repository: 数据存储层

#### bean 使用
##### 使用注解
+ @Autowired 是自动从spring的上下文找到合适的bean来注入
+ @Resource 指定名称注入

可以用在字段、构造器、setter 上


