[TOC]

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

### 命令
```
git init
```
把当前目录变成git管理的仓库（当前目录下会多了一个.git目录，用于跟踪管理版本库）
该目录就是一个工作区，.git目录是版本库，其中最重要的是stage（或叫index）的暂存区
git为我们自动采集第一个分支master以及指向master的一个指针HEAD
![](./0.jpeg)
![](http://www.liaoxuefeng.com/files/attachments/001384907702917346729e9afbf4127b6dfbae9207af016000/0)

```
git add $file
```
把文件$file的改动添加到仓库的暂存区（当然，该文件要在仓库目录下）
```
git rm $file
```
将仓库中的文件$file删除（还需commit提交）

```
git commit -m "$comment"
```
将暂存区的内容提交到仓库（当前分支）

```
git status
```
仓库的当前状态
新添加而未add的文件状态是Untracked

```
git diff $file
```
将$file文件和仓库中进行对比

```
git log
```
由近及远给出提交日志，可以加上--pretty=oneline参数，将一次提交都显示在一行；可以使用--graph选项看到分支合并图；--abbrev-comit
其中一长串十六进制字符串是commit id（使用SHA1计算）

```
git checkout -- $file
```
把指定文件$file恢复到最近一次add或commit时的状态

#### 分支
```
git branch
```
查看所有分支，当前分支带\*
```
git branch $b_name
```
从当前分支创建`$b_name`分支，  加-d选项是删除分支（对于已合并的分支），而对于未合并的分支需要使用-D
分支策略：
master要稳定，只用于发布新版本，不在上面工作；工作可以开一个自己的分支
```
git checkout $b_name
```
切换到 `$b_name`分支，后面的操作都相对于该分支进行（如果 `$b_name`分支不存在，可以加-b选项，将先进行`branch $b_name`操作）

```
git merge $b_name
```
合并分支`$b_name` 到当前分支（如有冲突，需先解决冲突，再提交，合并完成）
通常合并使用Fast forward模式，但删除分支后会丢掉分支信息，可以使用--no-ff选项禁用Fast forward模式，由于禁用后，合并就要创建一个新的commit，所有需要加上-m "xxx"选项

#### 回滚
```
git reset HEAD $file
```
把暂存区指定文件`$file`的修改撤销掉
```
git reset --hard $ver
```
将工作区回滚的到指定的版本
其中`$ver`：
HEAD表示当前版本，也就是最近一次提交的那个版本
HEAD^表示上个版本
HEAD^^表示上上个版本
HEAD~3表示HEAD^^^（可以将HEAD看做一个指针，总指向当前版本）
也可以给出commit id（不用写全，给出前几位即可）

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

```
git reflog
```
因为git log只会当前版本和之前版本的记录，而不会有之后版本的记录，该命令记录你的每一次命令，而其中commit 命令的第一列，就是commit id的前几位


### GitHub
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

#### 关联本地仓库与一个repository
```
git remote add origin git@github.com:account/repo_name.git
```
其中account是你的GitHub账号名，origin是远程仓库在本地的别名（默认），`repo_name`远程仓库的名字
```
git remote
```
查看远程库信息，使用-v查看详情（fetch是读权限，push是写权限）

#### 本地库推送远程库
```
git push -u origin master
```
origin是远程仓库名，master是推送的分支（并不需要把本地的所有分支都推送远程）
第一次推送，加-u，将本地分支和远程分支联系起来，以后推送或拉取可以简化命令
以后推送可以不带-u
如果远程版本已更新，push失败，就要先拉取远程库试图合并：
```
git pull
```
如果提示没有tracking信息导致拉取失败，可以使用下面的命令建立：
```
git branch --set-upstream $b_name origin/$b_name
```
如果因为自动合并失败导致pull失败，则需要  先解决冲突，再提交，再push

#### 克隆一个远程库
```
git clone git@github.com:account/repo_name.git
```
默认使用git://协议（SSH），还可以使用https等其他协议，克隆后远程仓库的默认名字为origin（对应：<https://github.com/account/repo_name.git>）（不过，https协议速度慢，而且每次推送都要输入口令）
默认只克隆得到master分支
若要获得其他分支需要：
```
git check -b $b_name origin/$b_name
```
前一个`$b_name`是要创建并切换的本地分支，后一个`$b_name`是对应的远程分支，取一样的名字操作更方便

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

### 配置git
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
git config --global alias.unstage ‘reset HEAd’
git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
```
--global是全局参数，在该电脑上使用git这些别名都有效，如果不加，只对当前仓库起作用
配置文件位于.git/config中
要删除别名，直接吧对应的行删掉即可。
当前用户的Git配置放在`$HOME/.gitconfig`



### 搭建自己的Git服务器
1. 安装git
2. adduser git用于运行git服务
3. 收集所有需要登录用户的公钥，存入`/home/git/.ssh/authorized_keys`，每行一个（如果人数很多，可以使用Gitsis管理公钥）
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

