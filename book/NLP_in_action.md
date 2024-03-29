自然语言处理实战
利用Python理解、分析和生成文本

第一部分：分词、TF-IDF向量化、从词频向量到语义向量的转换
第二部分：深度学习的神经网络、词向量、卷积神经网络CNN、循环神经网络RNN、长短期记忆LSTM网络、序列到序列建模和注意力机制（有助于对新模型，如Transformer和BERT的掌握）
第三部分：实战中的信息提取、问答系统、人机对话、自动阅读和协作、知识库构建等场景的模型构建、性能挑战、意图分析、情感分析等

Steven Pinker 在《The Stuff of Thought》 中提出一个观点：我们实际上是用自然语言思考的。沃尔夫假说认为语言会影响我们的思维方式。自然语言无疑是文化和集体意识的传播媒介。
因此，当我们想要在机器上模拟人类的思维，那么自然语言处理可能是至关重要的。
而通过语言的社交反馈回路，任何微小的扰动可能对机器和人类产生深远的影响（比如对机器人”自私属性“的微小调整，就可能对整个社交体系造成巨大的网络效应）

# 一、文本处理
## 1. NLP 概述
自然语言是人类在进化和发展过程中自发生成的语言，区别于人为了特定的目的而人工设计和构建出来的语言
为什么基于规则的编译器无法解决自然语言的解析。因为自然语言是模糊（多种含义）和容错（兼容一些不影响主体含义的例外和建立于常识、背景知识和上下文基础上的精简）的，而基于规则或模式的有限状态机（FSM）具有很大的局限性和脆弱性。
自动机按识别能力从低到高可以分为：组合逻辑、有限状态机、下推自动机、图灵机
形式语言按复杂度从低到高可以分为：正则、上下文无关、上下文有关、递归可枚举的
而自然语言不是任何形式语言可以定义的


NLP 系统尝尝被称为pipeline，因为该系统通常包括多个处理环节。每个阶段可以看做是层，逐层拆解构建，将线性的文本构建成为实体关系结构，乃至知识库。不过并非所有应用都需要更深的层才能完成，

经典的NLP模式匹配方法是建立在心智计算理论（CTM）的基础上。CTM 假设类人的NLP可以通过一系列处理的有限逻辑规则来完成。心智“连接主义”理论的发展运行并行流水线同时处理自然语言。
另一种则是基于统计的机器学习方法，通过大量的数据（包括语料库和词库）来让机器度量不同文本之间的含义差距，像杰卡德距离（Jaccard）莱文斯坦距离（Levenshtein）和欧几里得距离（Euclidean）这样的方法可以为结果添加“模糊性”

词袋向量模型
以一条语句为例，将其分词后进行计数统计，就形成了该语句的向量表示。通过该方式产生的所有可能的向量称为向量空间。通过线性代数可以对这些向量进行计算，但这种向量必然是是特别稀疏且高维，因此如何进行维度合并来降低“维度灾难”问题就很重要。
另一个划分维度的方式是通过设计关于主题和感受等特点来对文本进行评级，这样就可以将文本转换为关于问题空间的值向量。而上面的分词计数其实也是一种关于“语句是否包含某个单词”或“包含多少个某单词”这种问题的向量。

分词统计遗漏了词序的信息，而词序信息在特定的语法规则下会严重影响到语句表达的意义

聊天机器人通常包括了4个处理阶段和一个数据库来维护过去的语句和回复的记录、以及分析、打分、人物画像等生成的中间数据。
1. 解析：分词器（模糊正则），提取特征、结构化数值数据（打标签、NER）降维
2. 分析：拼写检查、语法检查、语义打分、情感分析、人性分析、流派分析、LSTM，来生成和组合特征
3. 生成：使用搜索、模板（FSM、MCMC、LSTM）或语言模型生成所有可能的回复
4. 执行：通过泛化和分类，来更新模型和目标，选择一种进行回复

POS标注通常使用有限状态转换机来完成，就像nltk.tag 包中的方法一样

## 2. 分词

## 3. 向量化

## 4. 语义

# 二、深度学习

# 三、现实挑战