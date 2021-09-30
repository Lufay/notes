查看依赖列表: `mvn dependency:list`
查看依赖树结构: `mvn dependency:tree`
使用verbose参数可以看冲突和重复的具体情况: `-Dverbose`
查看依赖树中包含某个groupId的依赖链: `-Dincludes=com.alibaba:fastjson`
查看依赖树中包含某个artifactId的依赖链（artifactId前面加上冒号）: `-Dincludes=:fastjson`

简单的，可以直接使用Maven Helper 这个插件

对于NoSuchMethodError 这种问题，可以查看对应的依赖是否存在多版本（尤其是那些隐藏在其他包中的间接依赖），通过添加exclusion 来将间接依赖中的低版本排除掉
