# 模型转换
在分层架构中，站在不同的层次对问题的描述需要不同的模型：
+ VO（View Object）：视图对象，用于展示层，它的作用是把某个指定页面（或组件）的所有数据封装起来。
+ DTO（Data Transfer Object）：数据传输对象，这个概念来源于J2EE的设计模式，原来的目的是为了EJB的分布式应用提供粗粒度的数据实体，以减少分布式调用的次数，从而提高分布式调用的性能和降低网络负载，但在这里，我泛指用于展示层与服务层之间的数据传输对象。
+ DO（Domain Object）：领域对象，就是从现实世界中抽象出来的有形或无形的业务实体。
+ PO（Persistent Object）：持久化对象，它跟持久层（通常是关系型数据库）的数据结构形成一一对应的映射关系，如果持久层是关系型数据库，那么，数据表中的每个字段（或若干个）就对应PO的一个（或若干个）属性。

## 模型转换工具
###  apache.BeanUtils
基于反射，性能差，复杂场景支持能力不足，支持名称相同但类型不同的属性的转换
用java.beans.Introspector类的getBeanInfo()方法获取对象的属性信息及属性get/set方法，接着使用Method的invoke 方法进行赋值

### spring.BeanUtils
对apache.BeanUtils 优化，针对复杂场景支持能力不足，支持忽略某些属性不进行映射
设置了缓存保存已解析过的BeanInfo信息

### PropertyUtils
基于反射，性能差，复杂场景支持能力不足

### cglib.BeanCopier
动态生成一个要代理类的子类,其实就是通过字节码方式转换成性能最好的get和set方式,重要的开销在创建BeanCopier，但是针对复杂场景支持能力不足（不支持属性名称不同或者属性名称相同但属性类型不同）
```
// 不使用Converter
BeanCopier copier = BeanCopier.create(Source.class, Target.class, false);
copier.copy(source, target, null);

// 使用Converter
BeanCopier copier = BeanCopier.create(Source.class, Target.class, true);
copier.copy(source, target, new Converter() {
	public Object convert(Object sourceValue, Class targetClass, Object methodName) {
	}
});
```

### Dozer
基于反射，性能不如编译时
能对不同名称的对象属性进行映射，支持简单属性映射、复杂类型映射、双向映射、隐式映射以及递归映射
可使用xml或者注解进行映射的配置，支持自动类型转换
#### 依赖
```
<groupId>com.github.dozermapper</groupId>
<artifactId>dozer-core</artifactId>
```

#### 使用
在bean 的field 上注解`@Mapping("field_name")` 

### Orika
底层采用了javassist类库生成Bean映射的字节码，之后直接加载执行生成的字节码文件
支持单个和集合对象转换、嵌套对象转换、自定义转换
#### 依赖
```
<groupId>ma.glasnost.orika</groupId>
<artifactId>orika-core</artifactId>
```

#### 使用
```
MapperFactory mapperFactory = new DefaultMapperFactory.Builder().build();

// 注册字段映射，这里是双向注册
mapperFactory.classMap(PersonSource.class, PersonDestination.class)
   .field("firstName", "givenName")
   .field("lastName", "sirName")
   .byDefault()		// 用于注册同名field
   // .exclude		// 用于排除同名field
   .register();

// 进行映射
MapperFacade mapper = mapperFactory.getMapperFacade();

PersonSource source = new PersonSource();
// set some source object's field
PersonDest destination = mapper.map(source, PersonDest.class);
```

##### 复杂映射
list <--> multi field
```
.field("nameParts[0]", "firstName")
.field("nameParts[1]", "lastName")
```

object <--> multi field
```
.field("name.first", "firstName")
```

##### 自定义转换
```
public class MyConverter extends CustomConverter<Src, Dst> {
   public Dst convert(Src source, Type<? extends Dst> destinationType) {
      // return a new instance of destinationType with all properties filled
   }
}

// 全局范围的转换
ConverterFactory converterFactory = mapperFactory.getConverterFactory();
converterFactory.registerConverter(new MyConverter());

// 几个属性使用转换器
ConverterFactory converterFactory = mapperFactory.getConverterFactory();
converterFactory.registerConverter("myConverterIdValue", new MyConverter());

mapperFactory.classMap( Source.class, Destination.class )
   .fieldMap("sourceField1", "sourceField2").converter("myConverterIdValue").add()
   ...
   .register();
```

### mapstruct
通过编译时注解处理器来实现的。其识别Mapper 接口，自动生成实现类，并将同名字段自动进行转换，并通过Mappers.getMapper 来获得这个自动生成的实现类
其支持单个和集合对象转换、嵌套对象、多个对象转一个、自定义转换

先声明一个mapper 的interface
```
@Mapper
public interface TeacherMapper {
    TeacherMapper MAPPER = Mappers.getMapper( TeacherMapper.class );

    TeacherEntity dataToEntity(TeacherDO req);
    TeacherDO entityToData(TeacherEntity req);
}
```
进行转换
```
TeacherEntity entity = TeacherMapper.MAPPER.dataToEntity(do);
```

注意：
如果在maven-compiler-plugin工具中显式指定了annotationProcessorPaths(注解处理器扫描路径)，此时如果又使用了Lombok 等注解处理器原理的工具，就需要将其注解处理器路径指定进去，否则就会导致这些工具失效。
