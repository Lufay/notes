# Lombok
<https://projectlombok.org/>

## 类注解
### @Data
集合了@ToString, @EqualsAndHashCode, 所有字段的@Getter/@Setter,  @RequiredArgsConstructor

### @Value
生成值类型，所有字段都会加上private final
不生成setter，会生成getter, AllArgsConstructor, toString(), equals(),  hashCode()

### @ToString
生成toString() 方法，默认按源文件顺序输出，可以通过字段注解@ToString.Exclude 排除输出字段
+ includeFieldNames: 是否带字段名输出
+ onlyExplicitlyIncluded: 白名单模式, 是否启用@ToString.Include（name/rank 越大越靠前，默认为0，相同按源文件顺序）
+ callSuper: 是否调用父类的toString() 方法
+ doNotUseGetters: 是否直接访问字段

### @EqualsAndHashCode
生成equals(Object other) 和 hashCode() 方法，使用所有非静态、非transient 字段，可以通过字段注解@EqualsAndHashCode.Exclude 排除字段
+ onlyExplicitlyIncluded: 白名单模式，是否启用@EqualsAndHashCode.Include
+ callSuper: 是否调用父类（注意：如果父类不是Object 最好设为true）
+ doNotUseGetters
如果不是final 类，或者父类是Object，会生成一个方法：
```
public boolean canEqual(Object other) {
	return (other instanceof ThisClass);
}
```
参考<https://www.artima.com/articles/how-to-write-an-equality-method-in-java>
equals 方法调用that.canEqual(this) 已确保如果该类的派生类重定义了equals 方法，那么父类实例和子类实例就notEqual，否则则可以一起比较

### @NoArgsConstructor, @RequiredArgsConstructor, @AllArgsConstructor
生成无参、必要参数（final 和非null 字段，比如使用@NonNull标记而未初始化的字段）、所有参数的构造器
若有final 字段还要生成无参构造器，需要加参数force = true，这些final 字段会被设置为默认值
+ staticName: 生成静态工厂方法，并私有化构造器，这里指定的就是工厂方法名
+ access: AccessLevel，如果作用于enum，自动设置为AccessLevel.PRIVATE

### @Builder
.builder().field1(a).field2(b).build()
由于依赖一个全参构造器，所以会包含@AllArgsConstructor(access = AccessLevel.PACKAGE)，如果指定@NoArgsConstructor 或手动写了一个无参构造器，会抑制这个全参构造器的生成，所以如果Builder 和NoArgsConstructor 同时指定后，必须带上AllArgsConstructor（当然，也可以给字段增加@Builder.Default 注解，只不过比较麻烦）
由于使用全参构造器，所以会使用类型默认值覆盖字段上指定的默认值，所以对于字段上有默认值的，需要增加@Builder.Default 注解，才能生效

## 字段注解
### @Getter / @Setter
可以给类，也可以给字段
+ AccessLevel: PUBLIC, PROTECTED, PACKAGE, PRIVATE, NONE（为了单独将某个字段排除在类设置之外）
+ noIsPrefix: 是否不用is 作为boolean 字段的前缀

### @NonNull
可以给字段，也可以给函数的参数，生成检查null，不满足抛出NullPointerException
+ exceptionType: 可以指定抛出异常的类型

## 类型推断
### var , val

## 其他注解
### @Cleanup
给IO 对象自动生成try-catch-finally 并在最后调用close()
