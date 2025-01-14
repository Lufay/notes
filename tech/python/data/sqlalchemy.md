SQLAlchemy

# 创建engine
`dialect[+driver]`: dialect 是数据库名，比如mysql, oracle, postgresql等；driver 是读写DB 的库包
```py
from sqlalchemy import create_engine
engine = create_engine("mysql+pymysql://user:password@127.0.0.1:port/db_name?charset=utf8mb4", echo=True)
```
echo 表示是否回显DB的操作

# 表定义
```py
class Base(DeclarativeBase):    # 在1.x版本写作 Base = declarative_base()
    pass

@dataclass
class Xxx(Base):
    __tablename__ = 'tb_xxx'    # 指定表名
    __table_args__ = {'extend_existing': True}

    id: Mapped[int] = mapped_column(BigInteger, primary_key=True, comment='主键')
    create_time: Mapped[datetime] = mapped_column(comment='创建时间', server_default=func.current_timestamp())
    product_id: Mapped[int] = mapped_column(nullable=True, comment='产品线ID')
    key: Mapped[str] = mapped_column(String(64), comment='场景key')
    version: Mapped[int] = mapped_column(server_default=text('0'), comment='版本号')
    status: Mapped[int] = mapped_column(server_default=text('1'), comment='版本状态: 1 稳定版; 2 待发布')
    conf: Mapped[str] = mapped_column(LONGTEXT, deferred=True, comment='pipeline conf')
    rule: Mapped[str] = mapped_column(LONGTEXT, deferred=True, comment='pipeline rule')
    description: Mapped[str] = mapped_column(String(128), nullable=True, comment='版本描述')
    operator: Mapped[str] = mapped_column(String(32), nullable=True, comment='最近操作人')
```
extend_existing=True，这个设置是为了解决建表时，会报告 tb_xxx 表already defined for this MetaData instance的问题

这个类将生成一个Table 对象（保存在该类的`__table__`属性中），而 mapped_column 函数将给这些字段生成Column 对象（`__table__.columns`集合对象），即：
```py
Xxx.__table__ = Table(
    'tb_xxx',
    Base.metadata,
    Columns('id', BigInteger, primary_key=True, comment='主键'),
    ...
)
```
mapped_column 也只用于DeclarativeBase 中
其前两个参数是`__name`, `__type` 可以缺省，则自动从属性名、类型注解进行解析映射
其他参数：
deferred：是否支持延迟加载
default：用于生成`__init__` 的默认值（不会表现在建表语句中）
insert_default：用于赋给生成Column 对象的default，会影响到插入数据的默认值
server_default：用于建表语句中，其值必须是一个字符串
sort_order：可以指定一个整数（默认是0），则在生成columns时会按其升序排列。默认按照类中定义的顺序，继承的属性排在后面

如果不通过属性声明字段，也可以通过方法来声明，需要`@declared_attr`装饰：

## 内置数据类型
```py
from sqlalchemy import (
    Integer,        # int 默认类型
    SmallInteger,
    BigInteger,
    Float,          # 将映射为数据库float
    DECIMAL,        # 需要2个参数
    Boolean,        # 将映射为数据库tinyint
    Enum,
    String,         # str 默认类型
    Text,
    Date,           # datetime.date 默认类型
    Time,           # datetime.time 默认类型
    DateTime,       # datetime.datetime 默认类型
)
from sqlalchemy.dialects.mysql import (
    DOUB
    LONGTEXT,
)
```



insert data:
https://www.osgeo.cn/sqlalchemy/tutorial/data_insert.html