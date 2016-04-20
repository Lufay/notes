# 展现
[TOC]

### 格式化器
`Yii::$app->formatter`
yii\i18n\Formatter类
格式化日期、数字、本地化

### 分页对象
\yii\data\Pagination类
填充totalCount、pageSize、page属性
```
$pagination = new Pagination(['defaultPageSize' => 5, 'totalCount' => $query->count(), ]);
```
在查询中填入offset和limit，并在渲染时传递这个分页对象，从而可以在使用LinkPager（yii\widgets\LinkPager）(分页按钮)这个widget时，使用该对象。即：
```
$countries = $query->orderBy('name')->offset($pagination->offset)->limit($pagination->limit)->all();
```
```
<?= LinkPager::widget(['pagination' => $pagination]) ?>
```
小部件 yii\widgets\LinkPager 使用 yii\data\Pagination::createUrl() 方法生成的 URL 去渲染翻页按钮。URL 中包含必要的参数 page 才能查询不同的页面编号。

### 排序对象
yii\data\Sort类
填充attributes属性，指定排序规则
在查询中填入orderBy，并在渲染时传递这个分页对象，从而可以通过其link方法显示排序动作的链接

### 数据源
yii\data\DataProviderInterface接口
持有数据，并处理分页和排序
实现该接口的实例，预定义三个：
+ ActiveDataProvider：通过ActiveRecord获取数据，返回一个ActiveQuery对象
+ SqlDataProvider：基于复杂的sql查询得到的数据，返回数组
+ ArrayDataProvider：基于数组数据（不如前两个高效）
他们都可以通过设置pagination和sort属性设置分页和排序（false禁用），还可以通过设置key属性指定key的生成方式

例如：
```
/* Get all the articles for one author by using the author relation define in Articles */
$dataProvider = new ActiveDataProvider([
    'query' => Articles::find()->with('author')->where(['Name'=>'Arno Slatius']),
    'pagination' => [...],
    'sort' => [...],
]);
```
query属性如果是yii\db\Query对象，返回数组数据；如果是yii\db\ActiveQuery，返回ActiveRecord数组。默认使用db组件作为数据库链接，可以通过自身的db属性变更。

```
$dataProvider = new SqlDataProvider([
    'sql' => 'SELECT Name, Title, COUNT(ArticleTags.ID) AS TagCount ' .
             'FROM Authors ' .
             'INNER JOIN Articles ON (Authors.ID = Articles.AuthorID) ' .
             'INNER JOIN ArticleTags ON (Articles.ID = ArticleTags.ID) ' .
             'WHERE Name=:author' .
             'GROUP BY ArticleID',
    'params' => [':author' => 'Arno Slatius'],
]);
```

```
$dataProvider = new ArrayDataProvider([
    'allModels' => Authors::find()->all(),
]);
```
方法：
getModels()：获得返回数据
getKeys()：返回数据对应的key值
getCount()：当前页数据个数
getTotalCount()：全部的数据个数

### DetailView
yii\widgets\DetailView类
显示一条记录
model属性: 指定要显示的记录model对象
attributes属性: 决定显示模型哪些属性和格式化方式

### ListView
yii\widgets\ListView类
一个有序或无序的列表
dataProvider：数据源
itemView，指定一个渲染一个li的视图名，在视图文件中，可以访问`$model、$key、$index、$widget`。
viewParams，传递给视图的额外参数，是一个kv-array

### GridView
yii\grid\GridView类
可配置的HTML table，可以排序，分页，选择每页展示的数量，表格最后的总结信息
dataProvider：数据源
columns：配置表格的列（），有以下预定义的类型：
columns：数据列的配置，是一个数组，每个元素对应一列，而每个元素都是 yii\grid\Column 子类的一个实例化配置数组，内置四种列类型：

+ yii\grid\SerialColumn，序号列，从1开始增长
+ yii\grid\DataColumn，数据列，默认，可以设置attribute、format属性来指定模型的属性名和格式化方式
+ yii\grid\CheckboxColumn，复选框列，被选择的行可通过调用下面的JavaScript代码来获得`$('#grid').yiiGridView('getSelectedRows')`，返回一个与被选行相关联的键组成的数组
+ yii\grid\ActionColumn，操作列，可以设置controller指定控制器ID，如未设置，则使用当前控制器，template定义构建每个单元格的模板，{}中的内容作为actionID，它们将被buttons指定的对应按钮的渲染回调函数替代，如果没有回调函数，则使用空串替代，urlCreator按钮URL的回调函数。

*特别的*，为了简化列的配置，可以把属性名、格式化器、显示label简化为一个`"attribute:format:label"`的字符串（后两个可省）

formatter：格式化器，将model的attribute值格式化为显示文本，是yii\i18n\Formatter的实例或实例化配置数组
layout：整体布局字符串，可以使用5 种内置元素：

+ `{summary}`：总结描述，调用renderSummary()渲染
+ `{errors}`：filterModel的错误信息，调用renderErrors()渲染
+ `{items}`：实体部分，调用renderItems()渲染
+ `{sorter}`：排序器，调用renderSorter()渲染
+ `{pager}`：分页器，调用renderPager()渲染
可以指定列的header、footer、visible、content属性和headerOptions、footerOptions、filterOptions、contentOptions属性

#### 搜索功能
需要一个提供搜索功能（实现search方法）的model（也定义了验证规则）
而后将该模型的一个实例指定给filterModel属性

例子：
```
<?= GridView::widget([
    'dataProvider' => $dataProvider,
    'filterModel' => $searchModel,
    'layout' => '{items}<div class="text-right tooltip-demo">{pager}</div>',    //重定义分页样式
    'pager' => [
        //'options'=>['class'=>'hidden']//关闭分页
        'firstPageLabel'=>"First",
        'prevPageLabel'=>'Prev',
        'nextPageLabel'=>'Next',
        'lastPageLabel'=>'Last',
     ],
    'columns' => [
        ['class' => 'yii\grid\SerialColumn'],
        'id',
        [
            'class' => 'yii\grid\DataColumn', //由于是默认类型，可以省略
            'attribute' => 'category',
            'label'=>'栏目',
            'value'=> function($model) {    //可以通过回调函数调整显示的内容
                return $model->category;   //如果是数组数据则为 $data['name']
            },
            'filter' => ['1'=>'男','0'=>'女'],
            // or
            // 'filter' => Html::activeDropDownList($searchModel,
            //                  'sex',['1'=>'男','0'=>'女'],
            //                  ['prompt'=>'全部']
            // ),
        ],
        [
            'label' => '标题',
            'value' => 'title.name',        //关联表
        ],
        [
            'attribute' => 'updatetime',
            'label'=>'更新时间',
            'format' => ['date', 'php:Y-m-d'],
            'value'=> 'update_at',
            'headerOptions' => ['width' => '170'],
        ],
        [
            'class' => 'yii\grid\ActionColumn',
            'header' => '操作',
            'template' => '{delete} {update}',
            'headerOptions' => ['width' => '240'],
            'buttons' => [
                'delete' => function($url, $model, $key) {
                    return Html::a('<i class="fa fa-ban"></i> 删除',
                            ['del', 'id' => $key],
                            [
                                'class' => 'btn btn-default btn-xs',
                                'data' => ['confirm' => '你确定要删除文章吗？',],
                            ]
                    );
                },
                'update' => function($url, $model) {
                    if () {
                        return Html::
                    }
                    return null;
            ],
            'urlCreator' => function ($action, $model, $key, $index) {
                if ($action === 'view') {
                    return ['view', 'id' => $model->id];
                } else if ($action === 'update') {
                    return ['update', 'id' => $model->id];
                } else if ($action === 'area') {
                    return ['area/index', 'group_id' => $model->id];
                }
            },
        ],
    ],
]); ?>
```
#### GridView配置详解
dataColumnClass：data column的类型，默认为yii\grid\DataColumn；
caption：table的caption；
captionOptions：caption这个tag的option；
tableOptions：table这个tag的option；

#### run过程
1. 按照layout的格式调用对应的函数渲染每个段(renderSection)
2. renderItems()是渲染的实体部分，该部分依次调用renderCaption、renderColumnGroup、renderTableHeader、renderTableBody、renderTableFooter进行渲染（当然，其中header和footer有showHeader和showFooter两个配置决定是否渲染）
    1. caption：通过caption配置，option 是captionOptions；
    2. colgroup：略（浏览器支持程度不同，用于同一设置多个列的样式）
    3. thead：调用Column类的renderHeaderCell，该方法调用renderHeaderCellContent方法渲染 th 标签，option为column::headerOptions，该方法的默认实现是使用header作为列头，而后将这些列集合为tr 标签，option为headerRowOptions（并联上renderFilters 的结果）
        1. DataColumn 的实现是如果设置了header，或者label和attribute属性都是空的话，就使用父类实现；如果设置了label，就使用其作为表头；没有前两个的话，就用attribute属性，调用model的getAttributeLabel方法或使用Inflector::camel2words方法进行处理作为列头
        2. CheckboxColumn 的实现是如果设置了header 或者multiple 属性为false，就使用父类实现；否则就用一个带全选功能的checkbox 作为表头
    4. tbody：dataProvider的getModels返回一个model数组，对每个model执行renderTableRow 方法，在其之前和之后调用beforeRow 和 afterRow 回调函数，最后将这些tr 组合为tbody
    renderTableRow方法有三个参数：model，model的key，和model在数组中的index。它调用Column类的renderDataCell方法渲染 td 标签，该方法调用renderDataCellContent作为列的内容，其默认实现是调用column::content函数，option是column::contentOptions，而后将这些列集合为tr 标签，option为rowOptions
        1. SerialColumn 的实现是index+1，即从1 开始的序号
        2. DataColumn 的实现是如果设置了content则使用父类实现，否则调用getDataCellValue方法得到内容，再用grid->formatter进行格式化
        getDataCellValue方法是如果设置了value，则使用其获得内容（字符串则为model的属性，回调则调用之）；否则，则如果设置了attribute，则它就是model的属性
        3. CheckboxColumn 的实现是生成一个复选框，option是checkboxOptions
        4. ActionColumn 的实现是按照column::template配置的格式逐个按钮进行渲染，template中使用{btn_name}表示已经定义在buttons的按钮名，已经内置的按钮有{view}, {update}, {delete}，每个按钮a 的option是buttonOptions，配置新按钮的方法是在buttons中加入一条：
        ```
        'btn_name' => function ($url, $model, $key) {
            return Html::a(...);
        }
        ```
        其中url是为了生成a 标签，model 和 key 同上
        在渲染按钮时，先生成一个url，如果定义了urlCreator这个回调函数`function($action, $model, $key, $index)`，则就调用其返回url，否则就用配置自身的controller（如果没有就用当前活跃的`controller+$action`作为url。而后在用该url，调用`buttons[$name]`这个回调函数渲染一个按钮。
    5. tfoot：默认不渲染，方式同thead，只不过配置的是footer，而且，子类并未重载实现。

### ActiveForm
yii\widgets\ActiveForm类
基于model的表单
配置：
fieldClass：默认是yii\widgets\ActiveField
fieldConfig：field的实例化配置，可以是一个配置数组，也可以是一个返回配置数组的回调函数

例子：
```
<?php
use yii\helpers\Html;
use yii\widgets\ActiveForm;

$form = ActiveForm::begin([
    'action' => ['controller/action'],
    'method' => 'get',							# 默认是'post'
    'options' => ['class' => 'form-horizontal'],
]) ?>
    <?= $form->field($model, 'username') ?>
    <?= $form->field($model, 'password')->passwordInput() ?>

    <div class="form-group">
        <div class="col-lg-offset-1 col-lg-11">
            <?= Html::submitButton('Login', ['class' => 'btn btn-primary']) ?>
        </div>
    </div>
<?php ActiveForm::end() ?>
```

因为ActiveForm是一个widget，begin()静态方法将实例化这个widget（调用init），end()静态方法将调用这个widget的run()方法，他们都返回这个widget实例
+ init方法：调用Html::beginForm构造表单头部
+ field方法：构造一个field对象。
+ beginField 和 endField 方法：构造field对象，并调用begin和end方法生成开标签
+ validate方法：
	- 用法1. validate($model, $attr)，调用$model->validate($attr)方法
	- 用法2. validate($model1, $model2, ...)，逐个调用model的validate方法，验证所有属性
+ validateMultiple方法，第一个参数model数组，验证一组模型的$attr属性

而ActiveField只是一个Component
+ __toString方法：调用render()方法
+ render($content)方法：
	- 如果是null, 按template中的各部分逐个渲染，作为content（如果input、label、error、hint这四部分如果之前没生成过，就调用默认的方法进行生成）
	- 字符串，直接作为$content
	- function($field), 调用之作为content
	而后将content包围上begin() 和 end() 方法返回（这两个方法构造field的容器，默认是div）
+ label($label, $options)方法：生成label标签
    - 如果$label 为false，则label为空
    - 如果$label 为null, 则调用model的getAttributeLabel方法得到
    - 否则，则使用$label
+ error方法，调用Html::error生成 Error
+ hint($content, $options)方法，调用Html::activeHint生成 hint，如果$content不是null，就使用其，否则就调用model的getAttributeHint
+ 生成input的方法比较多
