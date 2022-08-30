[TOC]

[练习](https://git-school.github.io/visualizing-git/)
[学习&练习](https://learngitbranching.js.org/?locale=zh_CN)

## 概述
### 概念
+ 工作区（workspace）：编辑的目录
+ 暂存区（index）：准备入库的文件
+ 本地仓库（local repository）：已提交的本地仓库
+ 远程仓库（remote repository）：用于同步的其他仓库

这几个概念的关系：
![](./1.png)
![](http://www.zhanglian2010.cn/wp-content/uploads/2014/07/XwVzT.png)

### 比较
+ CVS及SVN都是集中式的版本控制系统，而Git是分布式版本控制系统
+ git 跟踪的是修改，而非文件
一次提交生成一个版本构成一个节点，这些节点可以串成一条时间线，时间线可以有分支，主分支是master分支，HEAD指向当前分支的当前版本

##### 集中式版本控制系统
版本库是集中存放在中央服务器的，而干活的时候，用的都是自己的电脑，所以要先从中央服务器取得最新的版本，然后开始干活，干完活了，再把自己的活推送给中央服务器。
最大的毛病就是必须联网才能工作，而且需要一个稳定的中央服务器
##### 分布式版本控制系统
没有"中央服务器"，每个人的电脑上都是一个完整的版本库，这样，你工作的时候，就不需要联网了，因为版本库就在你自己的电脑上。修改后只需要将修改推送给对方即可。
在实际使用分布式版本控制系统的时候，通常也有一台充当"中央服务器"的电脑，但这个服务器的作用仅仅是用来方便"交换"大家的修改，没有它大家也一样干活，只是交换修改不方便而已。

## 命令
```
git init [--bare] [directory]
```
把指定目录directory（默认为当前目录，若该目录不存在会自动创建）变成git管理的仓库（当前目录下会多了一个.git目录，用于跟踪管理版本库）这个指定的目录directory的路径就是这个版本库的clone URL
该目录就是一个工作区，.git目录是版本库，其中最重要的是stage（或叫index）的暂存区
如果使用--bare选项，则没有工作区，即一个裸的版本库，它将直接将原本在.git 目录中的内容直接放在指定的目录下。由于没有任何记录，所以通常用于作为push 的远程库

git为我们自动生成第一个分支master以及指向master的一个指针HEAD
![](./0.jpeg)
![](http://www.liaoxuefeng.com/files/attachments/001384907702917346729e9afbf4127b6dfbae9207af016000/0)


```
git add $file
```
把文件$file的改动添加到仓库的暂存区（当然，该文件要在仓库目录下）

```
git rm [-r] [--cached] $file
```
将仓库中的文件$file删除（还需commit提交）
如果$file 是一个目录，则需要使用-r 选项（除非该目录是一个子模块目录）
如果不想删除工作区的文件，只想删除版本库中的文件，使用--cached 选项

```
git clean [-ndfx] [$path]
```
将untracked 文件清理掉，若没有指定$path，默认是当前目录
-n 用于演示将删除哪些文件，并不真实删除
-d untracked 的目录也会被清理
-x 默认不删除.gitignore文件里面指定的文件夹和文件，该选项可以无视.gitignore文件
-f 若clean.requireForce不是FALSE，则需要加上该选项才能执行删除

```
git commit -m "$comment"
```
将暂存区的内容提交到仓库（当前分支）
如果没有使用-m 选项，则会打开一个编辑器输入提交信息
```
git commit --amend
```
对最后一次提交进行修改重新提交，没有-m 选项会打开编辑器，可以使用--no-edit选项复用上次提交的信息
**注：需要确保最后一次提交还没push 到远程**


```
git status
```
仓库的当前状态
新添加而未add的文件状态是Untracked


### 版本
每次提交都会生成一个sha1的commit id
在命令中可以使用
HEAD 是一个指针，指向当前的工作版本，commit/checkout/reset 都会移动该指针，如果HEAD没有指向一个分支的最新节点，则认为HEAD 是游离状态的
也可以给出commit id（不用写全，给出前几位即可），其也可以替代上面的HEAD。

<rev>^表示上个版本
<rev>^^表示上上个版本
<rev>~3表示HEAD^^^
对于merge结点，可能有多个父节点则用<rev>^<n>表示第n 个父节点，特别的，n=0时表示<rev>本身。

版本集合
<rev>，表示包括<rev>及其祖先节点
^<rev>，表示从集合中剔除<rev>及其祖先节点
<rev1>..<rev2>，前开后闭集合，表示^<rev1> <rev2>的交集，即从<rev2>及其祖先节点的集合中剔除<rev1>及其祖先节点（如果rev1或rev2缺省，则表示HEAD）
<rev1>...<rev2>，前闭后闭集合，表示从<rev1>及其祖先节点和<rev2>及其祖先节点的集合中剔除他们的公共祖先节点（如果rev1或rev2缺省，则表示HEAD）
<rev>^@，表示<rev>的祖先节点（不包括自身）
<rev>^!，表示只包括<rev>，剔除其所有祖先结点


```
git show [options] <object>...
```
<object>可以是：
commit id：展示提交日志和文本diff；
tag：展示tag 信息和被引用对象；
tree：等价于git ls-tree --name-only
blob：展示内容


```
git diff [--options] [<path>...]
```
查看指定路径下的文件工作区和暂存区的文件diff
```
git diff [--options] <commit> [<path>...]
```
查看指定路径下的文件工作区和指定的提交之间的文件diff
```
git diff [--options] <commit> <commit> [<path>...]
```
查看指定路径下的文件两个指定的提交之间的文件diff
```
git diff [--options] --cached [<commit>] [<path>...]
```
查看指定路径下的文件暂存区和指定的提交（如果缺省表示HEAD）之间的文件diff
其中option可以使用
--color[=<when>]：<when>可以使用always（默认）, never, auto
--name-status：只看改动文件和改动状态
--submodule[=<format>]：查看子模块的diff，format可选log, short


```
git log [option] [revision range] [-- path]
```
由近及远给出提交日志，其中一长串十六进制字符串是commit id（使用SHA1计算）
可以限定版本号范围和路径（路径前加`^`表示排除）
options:
-N 参数只显示最近N 次提交记录；
--author 仅显示指定作者相关的提交；--committer 仅显示指定提交者相关的提交
`-p <path> [--full-diff]` 显示指定路径下提交的diff 内容
--graph选项看到分支合并图；
--oneline 等价于--pretty=oneline --abbrev-commit；
--pretty=oneline参数，将一次提交都显示在一行；
--abbrev-commit 仅显示 SHA-1 的前几个字符，而非所有的 40 个字符；
--stat 显示每次有变更的文件列表（带有修改统计信息）；
--name-only 显示每次有变更的文件列表（不带编辑状态）；
--name-status 显示每次新增、修改、删除的文件列表（带有编辑状态）；

```
git reflog
```
因为git log只会当前版本和之前版本的记录，而不会有回退之后版本的记录，该命令记录你的每一次命令，而其中commit 命令的第一列，就是commit id的前几位
该记录并不会同步到远端


```
git archive [--format=<fmt>] [--prefix=<prefix>/] [-o <file> | --output=<file>] [--remote=<repo> [--exec=<git-upload-archive>]] <tree-ish> [<path>...]
```
给仓库中的一个或多个目录或文件建立归档，如果想要忽略某些文件或目录时，可以为相应文件或目录建立export-ignore属性加以实现
其中
<fmt>支持的格式可以使用-l查看，如果该选项没给，而output给了，就从<file>推断，否则就是tar；
<prefix>是给归档中的文件加上前缀目录
<file>给出归档文件的文件名（而不是默认的输出到标准输出）
<repo>指定建立归档的远程仓库名或url（默认是从本地仓库）
<tree-ish>可以是一个树对象ID（如分支名）、commit-id 或 tag-id


### 分支
分支策略：
master要稳定，只用于发布新版本，不在上面工作；工作可以开一个自己的分支

```
git branch
```
查看所有本地分支，当前分支带\*，使用-r 选项可以看到远程跟踪分支
```
git branch $b_name
```
从当前分支创建`$b_name`分支
加-d选项是删除分支（对于已合并的分支），而对于未合并的分支需要使用-D（相当于--force）
```
git branch (-m | -M) [$old_b_name] $new_b_name
```
分支改名，$new_b_name不存在可以使用-m，如果已经存在，使用-M 强制

```
git checkout $b_name
```
切换到 `$b_name`分支，后面的操作都相对于该分支进行
如果 `$b_name`分支不存在，可以加-b选项，将先进行`branch $b_name`操作
```
git checkout -- $file
```
丢弃指定文件工作区的改动（即，回撤到暂存区或仓库中的版本）

```
git merge [$repo_short_name/]$b_name
```
合并分支`$b_name` 到当前分支（如有冲突，需先解决冲突，再提交，合并完成）
通常合并使用Fast forward模式（如果没有合并冲突，就直接移动指针，不新建合并提交，看起来就好像没有这次分支合并一样），可以使用--no-ff 选项禁用Fast forward模式，禁用后，合并就要创建一个新的commit，所以需要加上-m "xxx"选项
Git用`<<<<<<<`，`=======`，`>>>>>>>`标记出不同分支的内容，将冲突合并并去掉该标记后重新提交
如果不想解决此次merge冲突，退回到merge前状态，使用`git reset --merge`

```
git rebase -i [startpoint] [endpoint]
```
以交互模式合并多次提交（从startpoint 到endpoint 前开后闭区间）合并为一次提交，endpoint 默认为HEAD
交互模式会分成2步：第一步先编辑合并方式，第二部编辑合并后的新提交信息

```
git rebase [--onto <newbase>] [<upstream> [<branch>]]
```
该命令会把当前分支相对于upstream 分支（从checkout fork之后的）所有提交暂存起来，然后在upstream 分支的onto位置开始提交，如果遇到冲突，该过程将中止，需要手动解决冲突，而后git rebase --continue 继续；或者git rebase --skip 跳过造成冲突的commit；git rebase --abort 将终止rebase，并回到原分支。
如果未指定<branch>，则使用当前分支，若指定则先切换（switch）到该分支；
如果<upstream>未指定，将使用当前分支配置中的remote 和 merge 项；
如果指定onto，当前分支将被reset 到<newbase>指定的位置，否则默认在upstream 最新位置开始提交。
*注意：upstream分支并不会推进，所以当完成rebase后，一般需要将upstream 进行merge*
*由于当前分支已经被切换到新提交的这些commit上了，所以原来的那些提交由于失去了分支指针，被认为是废弃的，会被gc 清理掉*

```
git cherry-pick <commit>...
```
将若干个提交的变更应用于当前分支
<commit>... 默认不按commit 提交集合解析，除非明确使用集合运算符


### 恢复、回退（前进）、回滚
```
git checkout -- $file
```
把指定文件$file恢复到最近一次add或commit时的状态（丢弃工作区的修改）


```
git reset HEAD $paths
```
把暂存区指定路径下的文件的修改撤销掉（相当于git add 的逆操作）

```
git reset [--mode] [<commit>] $paths
```
重置HEAD 到指定的版本（既可以是之前的版本，也可以是之后的版本）
选项--mode可以是以下情形：
--soft：仅回退仓库，该版本后的变更存放在暂存区
--mixed [-N]：回退仓库和暂存区（默认选项）该版本后的变更存放在工作区，如果指定-N，则被移除的路径标记为intent-to-add
--hard：回退仓库、暂存区、工作区，即会彻底清理掉变更
--merge：
--keep：
因为回退之后的本地版本低于已同步的远程仓库的版本，所以基于回退版本的push就会遭遇冲突，此时需要的是revert


```
git revert [--no-edit] [-n] [-m parent-number] <commit>...
```
反向提交，撤销掉历史上的一些提交带来的效果，但历史并不回退，而是生成一个新的提交(undo commit)。（要求工作区和HEAD commit没有diff）
<commit>...可以是一个版本集合
执行该命令，默认将打开一个文本编辑器去编辑此次提交的comment，除非使用--no-edit，将不打开文本编辑器去编辑，而使用默认的comment
使用-n 选项，将仅仅对工作区和暂存区进行修改，而不生成一个新的提交
对于一个merge 操作的commit，需要使用-m 选项指定一个父编号来决定回滚的方向
undo过程中可能有冲突，可以用以下三个命令控制：
```
git revert --continue
git revert --quit
git revert --abort
```
分别用在冲突解决后、不再解决后续冲突、放弃已修改的冲突并回到最初状态。


### 保存工作区
```
git stash
```
不提交，保存工作区，然后将工作区回退到当前分支上次提交的状态
```
git stash list
```
查看保存的工作区，其中第一列冒号之前为`$stash_id`
```
git stash apply $stash_id
```
恢复工作区（并不删除）
```
git stash drop
```
删除工作区
```
git stash pop
```
恢复工作区并删除之

### 远程仓库
#### 克隆一个远程库
```
git clone [--recursive] <repository> [<directory>]
```
<repository>是远程库的url，可以是`git@github.com:$account/$repo_name.git`或`https://github.com/$account/$repo_name.git`或一个本地仓库路径
默认使用git://协议（SSH），还可以使用https等其他协议
克隆后远程仓库的默认别名为origin，默认只克隆得到master分支
如果使用--recursive 将自动检出子模块
若要获得其他分支需要：
```
git check -b $local_b_name origin/$remote_b_name
```
`$local_b_name`是要创建并切换的本地分支，`$remote_b_name`是对应的远程分支，可以取一样的名字操作更方便

#### 查看远程库信息
```
git remote
```
使用-v查看详情（fetch是读权限，push是写权限）
```
git remote show $remote_repo
```
显示指定远程仓库详细信息

#### 添加一个关联的远程仓库
```
git remote add $repo_short_name $url
```
其中
`$repo_short_name`是远程仓库在本地的别名
$url是远程仓库的url地址，例如`git@github.com:$account/$repo_name.git``https://github.com/$account/$repo_name.git`（$account是你的GitHub账号名）
```
git remote rename $old $new
```
远程仓库改名
```
git remote set-url $remote_repo $new_url
```
修改远程仓库地址
```
git remote rm $remote_repo
```
移除关联的远程仓库

#### 本地库推送远程库
```
git push [OPTIONS] $remote_repo [$local_b_name[:$remote_b_name]]
```
`$remote_repo`是远程仓库，可以是短别名，也可以是url
`$local_b_name`是推送的本地分支名，如果缺省而远程分支未缺省，表示推送一个空的分支到远程分支，相当于删除远程分支即`git push $remote_repo --delete $remote_b_name`
`$remote_b_name`是推送的远程分支，如果远程分支不存在则创建，如果有追踪关系可以缺省；如果和本地分支都缺省表示从当前分支推到远程追踪的分支
如果当前分支与多个远程库存在追踪关系，则可以使用-u | --set-upstream 选项指定一个默认远程库，这样后面就可以不加任何参数使用git push
如果不管是否存在对应的远程分支，将本地的所有分支都推送到远程库，这时需要使用--all选项
如果远程主机的版本比本地版本更新，推送时Git会报错，要求先在本地做git pull合并差异，然后再推送到远程主机。这时，如果你一定要推送，可以使用--force选项
git push不会推送标签(tag)，除非使用--tags选项
--recurse-submodules=check|on-demand

#### 拉取远程库
如果远程版本已更新，push失败，就要先拉取远程库并试图合并（默认的行为是fetch+merge，如果使用-r/--rebase 选项，则使用fetch+rebase 命令，即将本地变更重新提交到分支的最新commit后面）
```
git pull [$remote_repo [+][$remote_b_name[:$local_b_name]]]
```
如果因为自动合并失败导致pull失败，则需要先解决冲突，再提交，再push
`$remote_repo` 和 `$remote_b_name` 缺省的默认值是当前分支配置中的remote 和 merge 项
如果不带+ 表示使用fast-forward 进行fetch，带+ 表示强制更新
*如果远程库和当前库的分支没有共同的祖先，merge 时会失败，提示refusing to merge unrelated histories. 如果想要强制合并，可以使用--allow-unrelated-histories 选项*

只拉取不合并
```
git fetch [$remote_repo [+][$remote_b_name[:$local_b_name]]]
```

如果提示没有tracking信息导致拉取失败，可以使用下面的命令建立：
```
git branch --set-upstream $b_name origin/$b_name
```


### tag管理
若要发布一个版本，通常先在版本库打一个tag，该tag就是那个发布版本的快照，便于随时取得对应的版本（实际上，也是一个指向某个commit的指针，因此，创建和删除都很快）
要打tag，需要先切换到打tag的分支，然后：
```
git tag vx.x.x
```
就打好了一个vx.x.x的tag（指向HEAD），如果想指定某次提交，可以跟上一个commit id，此外，还可以使用-m选项加入说明，使用-d删除一个tag
可以用`git tag`查看所有标签（按字母序排列）
可以用`git show vx.x.x`查看标签信息
如果要推送标签到远程库：
```
git push origin vx.x.x 推送一个tag
```
或
```
git push origin --tag 推送所有tag
```
推送到远程之后删除就复杂些：
需要先使用-d删除本地，再使用push删除远程：
```
git push origin :refs/tags/vx.x.x
```

### 子模块
将另一个代码库作为自己项目的子模块，可以方便地跟踪更新，也可以直接修改该代码库
#### 添加子模块
```
git submodule add [-b <branch>] [--name <name>] <repository> [<path>]
```
<repository>是作为子模块的代码库路径（URL），该URL尽可能确保使用者都能访问，如果你要使用的推送 URL 与他人的拉取 URL 不同，那么请使用他人能访问到的 URL。 你也可以根据自己的需要，通过在本地执行 `git config submodule.<name>.url <私有URL>` 来覆盖这个选项的值。
<branch>是子模块的默认检出分支名；
<path>是将子模块的代码放到该目录下（目录可以不存在会自动创建）
如果没有指定<name>，就将<path>相对于项目根目录的路径作为子模块的名字
子项目信息会记录在项目根目录下的.gitmodules文件中
```
git rm <path>
```
移除子模块
<path>是上面指定的目录（无需使用-r 选项）
该命令会删除该目录，并清除记录在.gitmodules文件中的对应信息，但不会清除在.git/config中的注册信息

#### 查看子模块
```
git submodule
git submodule status [--recursive] [--] [<path>...]
```
显示子模块的当前commit id
使用--recursive 则返回嵌套子模块的信息
如果有`-`开头，表示该子模块尚未检出；
如果有`+`开头，表示该子模块的当前commit id和父模块保存的不一致；
如果有`U`开头，表示该检出的子模块merge冲突。

#### 注册子模块
```
git submodule init [<path>...]
```
将指定路径的子模块从.gitmodules 注册到.git/config
该命令不会改变已经存在在.git/config 中的信息
```
git submodule deinit [-f|--force] <path>...
```
注销一个子模块，删除.git/config的注册信息，并清空目录树
如果该子模块有本地修改，可能无法注销，可以使用-f 选项强制注销

#### 更新子模块
```
git submodule update [--init] [--remote] [-f|--force] [--rebase|--merge] [--recursive] [<path>...]
```
按照子模块信息，检出在.git/config中注册的子模块，使用--init将自动执行`git submodule init`，使用--recursive将递归更新嵌套子模块
默认检查为保存在父模块中记录的commit id，如果使用--remote选项，将检出子模块远程仓库对应分支（最初是master）的的最新commit id
该目录的行为取决于选项（优先）和submodule.<name>.update 的配置变量：
如果使用--checkout 或该配置变量设为checkout或未设置（默认），行为是检出子模块（检出的子模块不在任何分支，但HEAD 和master的commit id一致）；
如果使用--merge 或该配置变量设为merge，行为是将父模块中保存的提交记录merge到子模块的当前分支中；
如果使用--rebase 或该配置变量设为rebase，行为是子模块的当前分支rebase到父模块的提交记录中；
如果未使用选项且该配置变量设为!command，行为是执行`command $commit_id`；
如果未使用选项且该配置变量设为none，子模块将不更新。
```
git config -f .gitmodules submodule.$name.branch $b_name
```
修改$name子模块检出的分支（再使用git submodule update --remote时，将检出该分支的最新commit id，使用-f .gitmodules 是为了将该配置影响到其他的克隆）

#### 在各个子模块执行
```
git submodule foreach [--recursive] <command>
```
在每个已经检出的子模块中执行命令<command>，命令可以是任意的shell命令，在命令中还可以变量$name, $path, $sha1, $toplevel，分别是子模块名，子模块路径，子模块记录的commit id，父模块所在的绝对路径，为了避免$ 符号被解析，<command>最后使用引号''包住。如果在任一子模块中执行命令返回非0，迭代就会停止（可以在命令后加上`|| :`避免）。
如果使用--recursive 选项，将在嵌套子模块中执行该命令


### 配置git
带--global 是修改全局配置，否则是修改当前仓库的配置
当前仓库的配置文件位于仓库根目录的.git/config中
当前用户的Git配置放在`$HOME/.gitconfig`中
```
git config --global color.ui true
```
让命令输入显示颜色

提交忽略文件：
比如带有敏感信息的配置文件，系统或编译自动生成的文件
在Git工作区的根目录下创建一个.gitignore文件，git就会自动忽略其中填写的文件。
当然GitHub已经为我们准备了各种配置文件，只需要组合一下就可以使用了：<https://github.com/github/gitignore>

svn的别名，git也可以，而且还能自己配置，比如：
```
git config --global alias.st status
git config --global alias.ci commit
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.unstage 'reset HEAD'
git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
git config --global pull.rebase true
```
要删除别名，直接吧对应的行删掉即可。

## 配置文件
### .git/config

### .gitignore
用于说明不需要版本控制的文件（Specifies intentionally untracked files to ignore）
注意其英文表述，是忽略untracked的文件，也就是说一旦文件已经被tracked，那么就无法被忽略
[生成网站](https://www.toptal.com/developers/gitignore)

#### 格式
1. 支持`#`作为行注释
1. 以`/`开头表示只匹配从项目根目录开始的指定文件或目录，否则匹配从项目任意相对目录开始的指定文件或目录
1. 以`/`结尾表名忽略目录
1. 支持shell的模式匹配（`? * []`）
1. 可以使用`!`进行忽略排除
1. 按行从上到下进行规则匹配的，意味着如果前面的规则匹配的范围更大，则后面的规则将不会生效


## GitHub
提供Git仓库托管服务，传输使用SSH加密，因此需要SSH Key：
用户目录.ssh目录中`id_rsa`和`id_rsa.pub`两个文件：
```
ssh-keygen -t rsa -C "name@email.com"
```
一直回车即可
登录https://github.com/settings/ssh，增加一个：
Title可以起任意名字
Key为`id_rsa.pub`文件的内容
如果有多台电脑可以添加多个
注意：免费使用的是公共仓库，任何人都可以看（只有你才能改）
创建仓库：
New repository
可以从这个仓库克隆，也可以把一个已有的本地仓库与之关联，然后把本地仓库推送到GitHub上
克隆其他开源项目：
找到一个开源项目主页，比如  https://github.com/twbs/bootstrap，点Fork，就在自己的账号下克隆了一个bootstrap仓库（Fork到自己的账号下才能提交修改）
然后就可以在下面，git clone而后进行修改了
改好后，可以通过pull request给官方仓库贡献代码，对方选择是否接受


## 搭建自己的Git服务器
1. 安装git
2. 添加git用户adduser git，用于运行git服务
3. 确认本机有openssl服务已启动，收集所有需要登录用户的公钥，存入`/home/git/.ssh/authorized_keys`，每行一个（如果人数很多，可以使用Gitsis管理公钥）
4. 选择一个目录做为git仓库，在那里执行`git init --bare sample.git`，创建一个裸仓库（没有工作区），因为不让用户登录修改工作区，而纯粹为了共享
5. 修改属主：`chown -R git:git sample.git`
编辑/etc/passwd：
git:x:1001:1001:,,,:/home/git:/bin/bash
改为：
git:x:1001:1001:,,,:/home/git:/usr/bin/git-shell
使之不能使用shell登录
6. 在各自的电脑上克隆远程库：
git clone git@server:/path/to/sample.git
7. 可选，Git支持钩子（hook），可以在服务器端写脚本，来控制提交等操作（Gitolite就是这个工具）


参考：
<http://www.liaoxuefeng.com/wiki/0013739516305929606dd18361248578c67b8067c8c017b000>
<http://blog.csdn.net/sunboy_2050/article/details/7527877>
<http://www.open-open.com/lib/view/open1405048177091.html>

