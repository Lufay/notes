<https://www.elastic.co/cn/elasticsearch/>

ELK：
- Elasticsearch（数据存储和搜索引擎）：一个分布式搜索和分析引擎，基于 Apache Lucene 构建。它主要用于存储、搜索和分析大规模数据。
- Logstash（日志采集和处理）：一个数据收集和处理引擎，能够从各种来源（如日志文件、数据库、消息队列等）收集数据，并将其传输到指定的存储目标。
- Kibana（数据可视化和分析）：一个数据可视化和分析工具，专为与 Elasticsearch 集成而设计。它提供了丰富的可视化组件和交互功能，帮助用户探索和分析数据。

# 核心概念
## 集群Cluster
由多个节点(Node)组成的，每个集群都有一个cluster name 作为标识。

## 节点Node
运行在单个物理或虚拟机器上的一个实例

节点按承担的角色可以分为以下几种：
- Master节点：管理集群元信息，包括创建索引、删除索引；集群状态的广播同步；监听集群各节点状态
- Data节点：负责数据的存储和相关具体操作
- Coordinating节点：协调节点是一种角色，而不是真实的ES节点，我们没有办法通过配置项来配置哪个节点为协调节点。集群中的任何节点都可以充当协调节点的角色。当收到客户端的请求时，它负责把请求转发给涉及的节点，将结果进行聚合/排序/组装后，返回给客户端。 

## 索引Index
ES 通过索引来组织文档，可以认为是一个基于索引的虚表


## 分片Shard
也即数据的水平扩展
按类型可以分为主分片和副本（Replica）分片。一个副本分片只是一个主分片的拷贝（不能共存在同一节点上）。
主分片的数量在创建索引时确定，不可增加；副本分片复制主分片的数据，可以增加。

索引的文档在插入的时候被分配到某个主分片上，shard = hash(routing) % number_of_primary_shards，（routing 是一个可变值，默认是文档的 _id ，也可以设置成一个自定义的值）再被复制到副本分片上。

## 段Segment
存储数据的物理单元，其内容不可变，必须创建新的来更新数据，旧的Segment 会被后续合并或删除
通过段来实现索引的实时更新

## 文档Document
就是一条数据（也就是被索引的原子单位），JSON 格式

### 映射Mapping
可以用以定义文档中的字段约束，也即Schema
每个索引都有一个映射
映射还可以指定每个字段的分析器（analyzer），用来在建立索引前对文本进行预处理。

映射爆炸（mapping explosion）
从 5.x 及更高版本开始将索引中的字段数限制为 1,000 个，如果我们的字段数超过 1,000，我们必须手动更改默认索引字段限制（使用 index.mapping.total_fields.limit 设置）
对于可能嵌套较多字段的字段，可以指定为flattened 类型，避免该问题。该类型只能使用kv的完全匹配（区分大小写）、前缀、范围、match、存在性查询，不能进行分词查询

动态映射（Dynamic Mapping）
判断顺序：
数字	long
小数	float
true/false	boolean
日期格式字符串	date
数字类型字符串	float/long
其他字符串	text + keyword
数组	取决于数组中的第一个非空元素的类型
object	object
可以使用动态模板来改变默认的动态映射规则，规则本身是一个数组，所以会按序进行匹配，一旦命中就不会匹配后续的，所以越精准越前置
比如：
```json
{
 "mappings": {
  "dynamic_templates": [{
    "integers": {
     "match_mapping_type": "long",
     "mapping": {
      "type": "integer"
     }
    }
   },
   {
    "longs_as_strings": {
     "match_mapping_type": "string",
     "match": "num_*",
     "unmatch": "*_text",
     "mapping": {
      "type": "keyword"
     }
    }
   }
  ]
 }
}
```
表示把所有long 类型的字段都映射为integer，把所有以num_开头且不以_text 结尾的字段映射为keyword

一旦字段的映射被创建，就不能再修改字段的数据类型了，所以最好事先定义好mapping

### 字段Field
#### 数据类型
ElasticSearch 中没有明确的数组类型定义，但是每个字段都可以含有多个值，只要保证同一字段中所有值的数据类型一致即可。

##### 数值类型
integer, long, unsigned_long, short，byte，double，float, half_float
scaled_float: 用整型+倍率（scaled_float）存储浮点数，比如scaled_float=10, 2.34 将存储为23，即多余部分会四舍五入
ES 对数值类型的范围查询进行了优化，而对于不需要范围查询的ID精准匹配的场景，最好使用keyword 类型

token_count 用于存储文本字段中的词元数量。此字段常用于信息检索场景
dense_vector 记录浮点值的密集向量。这种类型常用于存储机器学习模型的输出
rank_feature 记录单个数值特征以优化排名。当这个字段被查询时，Elasticsearch 会考虑其值来重新排序搜索结果。
rank_features 记录多个数值特征以优化排名。与rank_feature类似，但它能够处理包含多个特征的对象。当这些字段被查询时，Elasticsearch 会考虑它们的值来重新排序搜索结果。

##### 字符串类型
keyword 支持过滤、排序、聚合，不进行分词，直接索引。最大支持的长度为32766个UTF-8类型的字符,可以通过设置ignore_above指定自持字符长度，超过给定长度后的数据将不被索引，无法通过term精确匹配检索返回结果。
constant_keyword 用于在所有文档中都始终有相同值的字段。即全局常量字段
wildcard 可以使用通配符表达式进行查询（有性能代价）

text 不支持排序、聚合，会分词，然后索引。长度没有限制
annotated-text 支持包含标记的文本。这些标记表示文本中的命名实体或其他重要项，可以在后续搜索中使用
completion 专门为自动补全和搜索建议设计的数据类型
search_as_you_type 被优化以提供按键查询时的即时反馈，从而提高用户输入时的搜索体验。

binary 二进制字符串，经过Base64编码处理

##### 日期
可以提供一个表示日期的字符串，如2013-12-25T09:00:00，ES 会解析转为UTC 以来的毫秒数（long存储）
也可以是毫秒数/秒数的时间戳

date_nanos：精度是纳秒，可存储的日期范围小，即：从大约 1970 到 2262

##### 空间
geo_point：表示地理位置的点，存储纬度和经度信息。
geo_shape：表示复杂的地理形状，如多边形、线、圆等。
point：在笛卡尔空间中表示一个点，存储X和Y坐标。
shape：在笛卡尔空间中表示任意复杂的几何形状。

ip

##### 布尔类型boolean
false: "false", ""
true: 所有除了false的以外的值

##### 对象类型
object 默认，对象数组转化时会失去每个对象的独立性
nested 转化时，会保存对象数组中每个对象的独立性
flattened 不解析对象内部结构到mapping中，解决映射爆炸问题
join 用于模拟在文档之间的父/子关系。这样可以创建一对多的连接

nested 和 join 的关联文档查询都会导致查询性能下降数倍

#### 元数据
#### mapping参数
index=true 默认，是否对当前字段创建倒排索引，如果关闭，则不会被搜索到，可以在source 元数据中展示，该设置可以节省空间占用
index_options=docs/freqs/position/offset，这4个选项是依次包含关系，也就是offset将包含文档ID、词频、词出现位置、词的在文档中的开始和结束位置（可用于高亮展示），text类型默认为position，其他类型为docs
enable=true 默认，index对应的全局设置
ignore_above=256 针对keyword类型字段，超过指定长度的字符串，ES 不会对其建立索引。
analyzer 分词器（character filter、分词Tokenizer、分词过滤器TokenFilter）
boost=1 默认，对当前字段相关度的评分权重
coerce 是否允许强制类型转换，为 true的话 “1”能被转为 1，false则转不了。开启自动转换可能会掩盖一些数据上的错误
copy_to 该参数允许将多个字段的值复制到组字段（既可以是单个字段，也可以是数组表示的多个字段）中，然后可以将其作为单个字段进行查询。配置该参数的属性，将不会再出现在_source 中
doc_values=true 为了提升排序和聚合效率.如果确定不需要对字段进行排序或聚合，也不需要通过脚本访问字段值，则可以禁用doc值以节省磁盘空间，对于text字段和annotated_text字段，无法禁用此选项，因为这些字段类型在默认情况下不使用doc values（这时可以使用fielddata参数）
eager_global_ordinals 用于聚合的字段上，优化聚合性能，但不适用于 Frozen indices（低命中数据，不会保存在内存中，只读的）。
fielddata=false 查询时内存数据结构，在首次用当前字段聚合、排序或者在脚本中使用时，需要字段为fielddata数据结构，并且创建倒排索引保存到堆中。
fields 给field创建多字段，用于不同目的（全文检索或者聚合分析排序）。
format 比如date的格式
null_value：为 null 值设置默认值。注意，这里并不会影响`_source`中的数据的值，只会在检索时用默认值参与。另外，null值也是会覆盖其他值的。
similarity：为字段设置相关度算法，和评分有关。支持BM25、classic（TF-IDF）、boolean。
store=false：设置字段是否仅查询，默认不做单独的存储。一般开启用于关闭_source，使用该选项仅单独保存某些字段

##### 实例
```json
{
  "title": {
    "type": "text",
    "fields": {
      "keyword": {  // 可以给text 一个keyword 的不分词子字段，这样在不超长的情况下，就可以用title.keyword 进行精准检索
        "type": "keyword",
        "ignore_above": 256
      }
    }
  }
}
```

#### 动态mapping设置
dynamic=true 默认，可以动态添加新字段到mapping中
dynamic=false 新增字段不会添加到mapping中，但会出现在_source中
dynamic=strict 拒绝包含有新增字段的doc，引发异常

date_detection=true 自动日期识别
dynamic_date_formats 指定要识别的日期格式
numeric_detection 能够识别数字型字符串

#### 分词
使用中文分词器，比较推荐的是 IK分词器，当然也有些其它的比如 smartCN、HanLP。IK分词器 支持自定义词库，支持热更新分词字典。
另外，也有建议使用 hao 代替 IK


# 原理
三级结构：
1. Term Index：保存词项前缀的索引，底层数据结构使用了FST。
2. Term Dictionary：保存了所有文档中出现的词项，还包括了词项在倒排表中的位置、词项频率（在所有文档中的总出现次数）、文档频率（出现该词项的文档数量）
3. Posting List：包括了词项对应的所有文档以及其在文档中的位置

## FST（Finite State Transducer，有限状态转换机）
从Trie树（前缀匹配）演化而来的架构，压缩了重复的数据组成

## Search 过程
1. 倒排召回
2. 正排过滤
3. 相关性打分/排序
4. 获取正排字段

- 客户端向ES 集群的任意节点发出请求，这个节点将作为本次请求的协调节点。
- 协调节点解析查询条件，构造SearchRequest。
- 协调节点根据路由表，选择涉及索引对应的分片。这些分片可能是主分片，也可能是副本分片。
- 通过负载均衡策略，协调节点将SearchRequest转发到各个分片所在的节点上。
- 各个节点收到SearchRequest后，根据查询条件开始进行查询：
  - 对于精确匹配型查询，例如 gender = 1 无需排序。
  - 对于全文相似性查询，例如match(title = '中国')，需要进行相似度排序。
- 各个节点返回(offset, limit)个结果给协调节点。例如，当 limit 为10，offset 为10，则会取出20条记录。
- 协调节点对结果进行重排序，最终选择真正返回给客户端的(offset, limit)个doc_id_list。

# DSL
基于JSON的Query 语句，通过Restful API发送

```json
GET /<index>/_search
{
  "query": {<查询条件>},
  "sort": {<排序键>},
  "size": {<返回doc的数量，默认为10>},
  "from": {<指定偏移量，默认为0>}
}
```

## 常见的查询条件
- match_all：查询简单的匹配所有文档。
- match：标准查询，精确查询和全文搜索均可，在执行查询前，它将用分析器去分析查询字符串。
- multi_match：可以在多个字段上执行相同的 match 查询。
  - fields: 指定多个字段
  - query: 查询的内容
- match_phrase: 和match查询类似，该查询也首先解析查询字符串来产生一个词条列表。然后会搜索所有的词条，但只保留含有了所有搜索词条的文档，并且词条的位置要邻接
- term：用于精确值匹配，这些精确值可能是数字、时间、布尔等等（相当于`==`）。
- terms: 同term 查询一样，但可以指定多值进行匹配，匹配任何一个值即可（相当于`IN`操作）。
- prefix: 前缀匹配
- wildcard: 单字段的通配符匹配
- regexp: 正则匹配
- range：查询找出那些落在指定区间内的数字或者时间，操作符包括gt、gte、lt、lte。
- exists: 存在指定的字段且有值
- missing: 无值字段
- bool: 组合查询条件，可以是以下条件的组合
  - must：文档必须匹配所有这些条件才能被包含进来，会影响相关性得分_score（结果会按相关性排序）。
  - should：文档满足这些语句中的任意语句就会返回，类似于 or。会计算相关性得分，主要用于修正每个文档的相关性得分。
  - must_not：文档必须完全不命中这些条件才能被包含进来，不计算相关性得分。
  - filter：必须匹配，不计算相关性得分，只是根据过滤标准来排除或包含文档（性能比计算相关性要高）。它里面可以通过and/or/not 组合多个filter
- boosting: 控制相关性打分的影响
  - positive: 正相关条件，分数加成
  - negative: 负相关条件，分数折扣
  - negative_boost: 分数折扣系数
- constant_score: 将打分设置为一个固定值，效率比普通查询高
  - filter: 跟bool 中的filter 一样
  - boost：设置的打分固定值
- function_score: 用于用户干预相关度打分，有多种辅助函数可以对原相关分进行修改

## 排序
默认按照相关性打分_score进行排序
也可以指定排序字段，支持的排序字段类型有：keyword、数值类型、日期类型、地理类型等
可以指定多个排序字段，也就是当第一个字段相同是，看第二个字段，以此类推

## 分页
from+size 不能超过10000，因为集群每个节点都要查top10000，然后再汇总，会导致汇总节点压力过大

针对深度分页
推荐使用的search_after，指定上一页最后的一组sort值，这样就可以从该值之后开始查询

### 举例
```json
{
  "query": {
    "bool": {
      "must": [
        { "match": { "title": "action" } }      // 包含关键词 "action"
      ],
      "filter": [
        { "range": { "rating": { "gte": 8 } } } // 评分在8分以上
      ]
    }
  },
  "sort": [
    { "release_date": { "order": "desc" } } // 这里按字段 "release_date" 降序排序
    {
      "_geo_distance": {
        "<geo_field>": "纬度, 经度",  // 这里指定geo 字段 和 目标的经纬度
        "order": "asc",
        "unit": "km"    // 排序的距离单位
      }
    }
  ],
  "size": 10
}
```

## 聚合
### 桶聚合
- terms: 这里主要是指定一个分组的key，可以使用一个size 的属性指定返回的最大分组数量。默认是对文档计数，也就是value_count
  - field: 直接指定一个字段作为key
  - missing: 当字段不存在时，指定一个默认值作为key
  - script: 可以使用脚本来对字段进行处理，然后再作为key。如果同时指定了field和script，则脚本字符串中可以使用`_value`来获取字段值参与脚本计算
    - source: 可以使用painless脚本语言，将其返回值作为key。脚本字符串中，可以使用doc.field或doc['field'] 来访问文档的字段，用字段的value属性来获取字段值
    - lang: 脚本语言，默认是painless
    - params: 可以指定一个map，里面可以指定一些参数，在脚本中可以使用（用params.xx引用）
- histogram: 直方图聚合，用于数值聚合
  - field
  - interval: 数值分桶间隔
- date_histogram: 日期的直方图聚合
  - field
  - calendar_interval: 日期间隔（可以使用year、month、week、day、hour、minute）
  - format: 返回结果中桶key的时间格式
- range: 数值区间聚合
  - field
  - ranges: 它是一个关于{"from": xx, "to": yy} 的数组，每一段一个桶，另外每个桶可以用"key"指定一个名字

#### 桶排序
默认按doc_count文档总数，降序排序，即"order": {"_count": "desc"}
除了_count 外还有：
- _term: 按词项的字符串值的字母顺序排序。只在 terms 内使用
- _key: 按每个桶的键值数值排序, 仅对 histogram 和 date_histogram 有效
- 嵌套的字段值排序

### 指标聚合
- value_count: 对指定字段的所有值统计总数
- cardinality: 对指定字段的所有值去重计数，不能用于text类型的字段，另外为了性能，这里的总数是一个近似值
- min: 对指定字段的所有值求最小值
- max: 对指定字段的所有值求最大值
- sum: 对指定字段的所有值求和
- avg: 对指定字段的所有值求平均值
- stats: 对指定字段的所有值求总数、最小值、最大值、平均值、求和等
- extended_stats: 在stats的基础上，还可以计算方差、标准差等统计信息
- percentiles: 对指定字段的所有值求百分位的统计
  - percents: 指定统计那些百分位值，默认是[1, 5, 25, 75, 95, 99]
  - keyed: 默认为true，表示默认返回一个map，key是百分位，value是对应百分位的值，可以通过keyed=false 来指定返回一个数组，数组的元素是百分位和对应的值
- percentile_ranks: 根据数据获取在系统中的百分位
- string_stats: 如果我们需要进行统计的字段如果是 text 字段，那么就需要加上 .keyword 来进行统计，如果是字段属性是 keyword，就不需要这样处理。

### 嵌套聚合
- aggs: 可以嵌套使用聚合，这样就在上述分组中再进行聚合


### 距离
```json
{
  "size": 0,    // 不要查询结果，只要聚合结果
  "aggs": {     // aggregations的缩写
    "aggregation_name": {  // 这里的名字可以自定义
      "AGG_NAME": {<聚合属性>}
    }
  }
}
```


## 索引
### 创建&删除索引
```
PUT /{index_name}?pretty

DELETE {index_name}
```
pretty参数:用来格式化返回值

### mapping
```
# 创建映射
PUT {index_name}/_mapping
{
  "properties":{
    "bid":{
      "type":"keyword",
      "index":true
    },
    "name":{
      "type":"text",
      "index":true
    },
    "desc":{
      "type":"text",
      "index":true
    },
    "type":{
      "type":"text",
      "index":false
    }
  }
}
//查看索引完整的mapping
GET /{index_name}/_mappings
//查看索引指定字段的mapping
GET /{index_name}/_mappings/field/{field_name}
```

### 索引重建
```json
POST _reindex
{
  "conflicts": "proceed",
  "source": {
  #源索引
  "index": "blog_index",
  #可以根据查询条件重建部分数据
  "query": {
    "term"
    "user": {
      "value": "tom"
    }
  },
  "dest":{
    #目的索引
    "index": "blog_new_index"
  }
}
```
如果重建索引涉及到的数据量较大，可以通过设置参数 wait_for_completion 为 false 来异步执行。

## 文档
### 创建文档
PUT 和 POST 都行
```
POST {index_name}/_doc/{doc_id}
{
  "user": "tom",
  "title": "title",
  "content": "content"
}
```
若没有指定doc_id，则ES 服务器会随机生成一个
如果doc_id 已经存在，则会覆盖原来的文档

### 批量操作
```
POST _bulk
{"create":{"_index":"test_newes","_type":"_doc"}}
{"title":"vivo手机","category":"拍照","images":"http://www.ios.com/xm.jpg","price":4000.00}
{"create":{"_index":"test_newes","_type":"_doc"}}
{"title":"华为手机","category":"荣耀","images":"http://www.ios.com/xm.jpg","price":3000.00}
```

### 修改文档
<https://www.elastic.co/guide/en/elasticsearch/reference/7.6/docs-update.html>
支持script 和 doc 两种修改模式，如果同时指定，则忽略doc
doc 是局部更新的方式，即其中指定的字段，进行覆盖更新，未指定的字段，则保持原状
```json
POST {index_name}/_update/{doc_id}
{
  "script" : {
    "source": "ctx._source.counter += params.count",  // 累积
    // "source": "ctx._source.tags.add(params.tag)",  // 数组增添
    // "source": "if (ctx._source.tags.contains(params.tag)) { ctx._source.tags.remove(ctx._source.tags.indexOf(params.tag)) }",  // 数组移除
    // "script" : "ctx._source.new_field = 'value_of_new_field'"  // 增加新字段
    // "script" : "ctx._source.remove('new_field')" // 字段删除
    // "source": "if (ctx._source.tags.contains(params.tag)) { ctx.op = 'delete' } else { ctx.op = 'none' }"  // 当条件满足时，删除文档，否则无操作
    "lang": "painless",   // default
    "params" : {
      "count" : 4,
      "tags" : "blue"
    }
  },
  "doc":{
    "title":"苹果11",
    "price":5800.00
  },
  "detect_noop": false,   // 默认为true，即若探测到doc 中对于已保存的文档不存在更新，则不再执行修改和写入，返回"result": "noop"。这里false强制更新
  "upsert" : {      // 当doc_id 指定的文档不存在时，则使用这里的默认文档存入，存在时才执行script
    "counter" : 1
  },
  "scripted_upsert":true,    // 无论文档是否存在，都执行script
  "doc_as_upsert" : true    // 当doc_id 指定的文档不存在时，使用doc 进行存入
}
```

### 删除文档
并不会立即物理删除，而是先标记删除
```
DELETE {index_name}/_doc/{doc_id}
```

### 按ID查询
```
GET {index_name}/_doc/{doc_id}
```