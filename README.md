# Major target: use todo-txt.cli to manage your big plan(Ubuntu)
Minor target: learn shell and linux, same time use [emacs org-mode][26] to manage your small plan.

The thing actullay classified into three parts:

1. [.bashrc](#ubuntu)(cygwin,maybe .bash_profile also needed)
    destination:  path the todo.sh, complete function for todo.sh, configure todo.sh, let you can use `t`
2. [.todo.actions.d][24]
    destination: some add ons for todo.sh, such as mit,mitf,view,again etc , let you can use `t mitf ....`
3.  [todo-txt.cli-2...][25]
    destination: todo.txt live in the folder, todo.cfg also. todo.sh is the main source, the kernal of the todo-txt.cli
      Important !  let you can use todo.sh, it is the home of todo.txt-cli.
    
If you can finish the three parts above, you can use the todo-txt-cli now also add-ons functions.


## Use Todo.txt to manage your life job

### [Todo.txt][1]
开源的计划管理工具，支持多种编程语言的开发

### [Todo.txt add on][3]
cygwin制作linux环境，需要把bash文件dos2unix.exe转换文件，否则出现故障。

[安装插件方法][16]

可以参考我的[todo add on 仓库][20]
注意在ubuntuhu环境下得设置

0. PATH=$PATH:/Todo/
2. alias t='todo.sh -d /Todo/todo.cfg'
3. set TODO_ACTIONS_DIR="/home/yezhaoliang/.todo.actions.d" not ~/.todo.actions.d
4. let plugin be executable , chmod +x .


+ [t graph][5] 
+ [t mit][6]
       t mit 日期 任务信息：日期包含着具体的日子[today,mon,tue,wed,thr,fri,sat,2017.05.05]、月份[jan,feb]、季度[q1,q2,q3,q4]、年[2017,2018]等信息
       【日度】 【月度】  【季度】 【年度】计划的指定工具
       t mit 可以查看【四度】计划表，相当于计划汇总表
       t mit @f708 显示所有地点在f708的计划表，四度都会显示出来，但是速度慢一些
       t mit not @f708  显示不在f708的计划表[可惜的是，还无法支持地点分层]
       t mit rm和t mit mv类似于 t rm和t mv.'

<font color="red">quarter bug</font>

如果使用case老是匹配不上，只能用if判断了。
```

  currentQuarter=`date +%-m`
  if [[ $currentQuarter -eq 1 || $currentQuarter -eq 2 || $currentQuarter -eq 3 ]] ; then
      THISQUARTER=`date +%Y0101`
  elif  [[ $currentQuarter -eq 4 || $currentQuarter -eq 5 || $currentQuarter -eq 6 ]] ; then
      THISQUARTER=`date +%Y0401`
  elif  [[ $currentQuarter -eq 7 || $currentQuarter -eq 8 || $currentQuarter -eq 9 ]] ; then
      THISQUARTER=`date +%Y0701`
  elif  [[ $currentQuarter -eq 10 || $currentQuarter -eq 11 || $currentQuarter -eq 12 ]] ; then
      THISQUARTER=`date +%Y1001`
  fi
#  echo "Ye: $THISQUARTER "
  # case `date +%-m` in
  #   [1-3] )
  #     THISQUARTER=`date +%Y0101`
  #     ;;
  #   [4-6] )
  #     THISQUARTER=`date +%Y0401`
  #     ;;
  #   [7-9] )
  #     THISQUARTER=`date +%Y0701`
  #     ;;
  #   [10-12] )
  #     THISQUARTER=`date +%Y1001`
  #     ;;
  #     *)
  #    THISQUARTER=20170101
  #    ;;
  # esac
  # echo "Inside processMITS: $THISQUARTER"
  #

```

+ [t mitf 1d][7]
       带时间段的定义task
       t mitf 1w "... @f708 +multiAxis "
       t mitf 1m "... @f708 +multiAxis"
       t mitf 1d "... @f708 +multiAxis"

       context and project information must be in the end of line
+ [t top   t view  t edit][8]
       top显示头20天信息。

       view比较好用
       一般用t view project 显示【项目分层】的计划表，t view context显示【地点相关分层】的计划表，由于时间相关的
       任务得在每条任务中添加t:2017-05-03的标签，所以t view date,t view today ,t view tomorrow,t view future,
       t view past等时间相关的任务在任务中没有t:开头的时间标签都认为是无效，得手动进行添加了,This is shortage,希望改进。

       为此改进如下：只要添加t:2017-05-03日期规范即可，于是写了如下【简单】脚本【简单又复杂2h】【注意dos2unix.exe】

【addView.sh】用于t view date和t due，经过这个修改【t due只需要修改due.py的due为t和4改为2，想看t due插件】即可, t again也是用着类似于t due的思路，也得对应修改due 为t。

【addView.sh和deletView.sh】都是用于【修改todo.txt】的小工具。

``` sh
#count=1;
for quartern in `grep -no "[^ :]*{[^ ]\+}" todo.txt|tr "." "-"|awk -F"[{-}]" '{printf("%s%s\n",$1,$2)}'`;do 
    item=`echo $quartern|cut -d ":" -f1`
    quarter=`echo $quartern|cut -d ":" -f2`
    date1=`echo $quarter|sed 's/\(.*\)00-00/\101-01/'|
    sed 's/\(.*\)[qQ]1-00/\101-01/'|
    sed 's/\(.*\)[qQ]2-00/\104-01/'|
    sed 's/\(.*\)[qQ]3-00/\107-01/'|
    sed 's/\(.*\)[qQ]4-00/\110-01/'|
    awk -F"-" '{if($3==00) printf("%s%s%s%s%s\n","t:",$1,"-",$2,"-01"); else printf("%s%s%s%s%s%s\n","t:",$1,"-",$2,"-",$3)}'`
#    echo ${item}
#    echo $date1
    todo.sh append ${item} $date1
#    echo ${count} 
#    echo ${date1} 
#    count=$((count+1));

done
```

修正到期日子，这样配合t due ,t view date,t again更好一些。

```
    date1=`echo $quarter|sed 's/\(.*\)00-00/\101-01/'|
    sed 's/\(.*\)[qQ]1-00/\101-01/'|
    sed 's/\(.*\)[qQ]2-00/\104-01/'|
    sed 's/\(.*\)[qQ]3-00/\107-01/'|
    sed 's/\(.*\)[qQ]4-00/\110-01/'|

```
【思路】：
+ 抓取todo.txt的行号和时间信息，目标结合mit的时间，所以是大括号里头的时间，得到对应行号和时间信息
+ 获取行号，可以提供给todo.sh append中的$item选项，即计划好 ，对应todo.txt的行号
+ 获取时间，并进行特殊日期处理，比如年、季度、月份的处理
+ 最后调用todo.sh append即可，刚好在对应任务插入一行字符串，perfect解决

因为重复上述脚本，会不断增加t:日期，于是又写了一个【删除】脚本【保存为deleteView.sh】

``` sh
sed -ie "s/t:.*$//g" todo.txt
```

注意得修改deleteView.sh,用于配套t note套件。

``` sh
sed -ie 's/t:.*\s*//g' todo.txt

```

update deleteView.sh, because of the bug there are note:zo0.md after t:2018-05-28
`-Ei` ,rather than `-iE`, `-iE` not working! but `-Ei` works!

```
sed  -Ei 's/t:[0-9]{4}-[0-9]{2}-[0-9]{2}//g' todo.txt

```

删除todo.txt目录下的该文件， 从t:开始到行尾都删除掉。增删就都完成了，这样就可以使用t view date, t view tomorrow, t view today , t view past ,t view future,
t view nodate等。
![todo][14]
![result][15]

```
https://raw.githubusercontent.com/jueqingsizhe66尝试访问本地图片 没用！
改为： https://raw.github.com/jueqingsizhe66尝试访问本地图片 有用！
github内部机制,似乎无效
https://github.com/jueqingsizhe66/Todo/blob/master/finalResult2.png
有效了
```

<hr/>
<hr/>

+ [t xp][9]
       更好显示【已完成】任务
       t xp -o 10 
       显示10天内完成的任务

+ [t birdseye][10]
        t birdseye: 生成产量报告,完成量和未完成量的统计
        A Python script birdseye.py (called with the birdseye action) analyzes the todo.txt and done.txt files to generate a report of completed and incomplete items in every context and project. (Requires Python and both birdseye.py and birdseye files to run.)

+ [t sync][11]

同步，需要[t commit][12],算了不用这个了,手动提交。

+ [t revive][17]

t revive查找done.txt,然后显示出来完成的任务，t revive #item表示完成done.txt的记录号，一把就是行号。
但是这个不会修改日期，只是删除x+日期而已。

但是自从有了again插件之后，发现这个插件有点鸡肋。
但是突然想到了一个思路，有时候你会想着恢复done.txt，这样你就可以配合上addView,这样修改的日期就会不断的朝前，
并且也不会说不断的增加done的数据，只保留最新的一个版本。maybe a little complex.
但是，后来我查了一下，t revive并不会删掉done的数据。


```
$ t revive
1 x 2017-05-02 due:2017-05-01 @f708 +graduate info the Huang to check the report
2 x 2017-05-02 due:2017-05-02 @jpw +jr dpme
3 x 2017-05-03 {2017.05.03} @F708 +graduate call WangNanMan to do report
5 x 2017-05-04 {2017.05.04} @f708 +graduate talk with WangNanMan to add an interface to my Project  t:2017-05-04
4 x 2017-05-04 {2017.05.04} @Subway +multiAxis read the paper about the wind turbine yaw  t:2017-05-04
6 x 2017-05-04 {2017.05.04} transact a check for the DELL @NCEPU +lab t:2017-05-04
--
DONE: 6 of 6 tasks shown

$ t revive 6
26 {2017.05.04} transact a check for the DELL @NCEPU +lab t:2017-05-04
TODO: 26 added.


```

+ [t again][18]

完成某个任务，并且重复再做，或者推迟几天再做。

为了配合上mit又得类似于due插件做一个小调整，把due tag换成t tag
一般得配合上t view today或者t list 亦或者t due 3 ,t due 1等使用

```
# Replace any due date (due:DATE) of the item in $LINE by $ADJUST
function replace_due_date()
{
  #TAG=due
  TAG=t
  replace_tagged_date
}

```

测试例子

```
$ t again 26 +1
26 x 2017-05-04 {2017.05.04} transact a check for the DELL @NCEPU +lab t:2017-05-04
TODO: 26 marked as done.
x 2017-05-04 {2017.05.04} transact a check for the DELL @NCEPU +lab t:2017-05-04
TODO: /cygdrive/d/Todo/todo.txt_cli-2.9/todo.txt archived.
26 {2017.05.04} tr
```

<font color="red">注意:</font>

+ t again 26 1表示增加一天的期限【这个命令我经常会用，开心，拖上一天再干】
+ t again 26 +1 表示增加2天的期限
+ t again 26 +2 表示增加3天的期限，依次类推



官网的例子：

```
$ date +%F
2015-11-12

$ todo.sh list
1 learn something new
2 change bathroom towels due:2015-11-15
3 deposit paycheck due:2015-11-15
4 replace smoke alarm batteries due:2015-10-20
5 pay rent due:2015-12-03
6 send flowers to Mom for her birthday due:2016-01-14 again:+1y

$ todo.sh again 1
1 x 2015-11-12 learn something new
TODO: 1 marked as done.
7 learn something new
TODO: 7 added.

$ todo.sh again 2 14
2 x 2015-11-12 change bathroom towels due:2015-11-15
TODO: 2 marked as done.
8 change bathroom towels due:2015-11-26
TODO: 8 added.

$ todo.sh again 3 +14
3 x 2015-11-12 deposit paycheck due:2015-11-15
TODO: 3 marked as done.
9 deposit paycheck due:2015-11-29
TODO: 9 added.

$ todo.sh again 4 1y
4 x 2015-11-12 replace smoke alarm batteries due:2015-10-20
TODO: 4 marked as done.
10 replace smoke alarm batteries due:2016-11-12
TODO: 10 added.

$ todo.sh again 5 +1m
5 x 2015-11-12 pay rent due:2015-12-03
TODO: 5 marked as done.
11 pay rent due:2016-01-03
TODO: 11 added.

$ todo.sh again 6
6 x 2015-11-12 send flowers to Mom for her birthday due:2016-01-14 again:+1y
TODO: 6 marked as done.
12 send flowers to Mom for her birthday due:2017-01-14 again:+1y
TODO: 12 added.
```

[again插件调整天  星期  月 年的高级命令][19]
<hr/>
<hr/>

+ [t chcon][21]

特别小的插件，用于调整context 计划的地点，类似的思路调整项目，但是一般没有必要。

+ [t note][22]

除非真的想要添加笔记，一般I don't wanna添加的，t again , t mit, t due, t lately, t view用的好好的，不整这么复杂的。

```
t note add taskID 
t note show taskID
t note edit taskID

after archived, use  t note show a
```

Because of TODO_NOTE_EXT and EDITOR , so you write note with vim by the md extension of file

1. 【add】约定是在每个任务后面加上一个note:任意文件名.md 该文件名存储在todo.txt文件的目录下.
按照原理每个任务如果添上note会有一个文件名，通过名字对应。
2. 【done】另外当一个task完成后，会创建一个archive*.md文件，也就是在done.txt的时候，查看只能通过t note show a #item
或者t note edit a #item ;a代表着archive的意思
3. 【delete】理论上删除一个task，也会删除对应的note.md

注意得修改deleteView.sh:

``` sh
sed -ie 's/t:.*\s*//g' todo.txt

```
需要额外在todo.cfg配置全局环境

```
# for the note
# Note file extension
export TODO_NOTE_EXT=.md
export EDITOR=vim

```

安装说明：
```
Installation

Copy the archive, del and rm files in this directory to your add-ons folder. Be aware that this add-on overrides the archive, del and rm commands. If you already have overriden some of them, you'll need to do some tweaking to combine both versions.
```

得替换掉默认的t archive生成一个bak文件，和t rm和t del,否则无法配合done的时候，完成笔记的关联关系。
目的是构成一个笔记系统。
这样，如果完成一个done之后，就会删掉对应的*.md文件【已确认，的确是删除了】，并存放到archive.md文件，可以通过t note a 查看archive.md的日记信息。


就这样构成了，添加note，note和待完成计划的关系，以及计划完成之后，依然保留note的方式(也就是archive.md中)。
【note简易系统】


官网简单使用说明,一般都是配合上t ls,t view today ,t due ,t due 3等使用

```
$ t note add 27
27 {2017.05.04} transact a check for the DELL @NCEPU +lab t:2017-05-04 note:gby.md
TODO: Note added to task 27.
Edit note?  (y/n)
y

$ t note show 27
test it# {2017.05.04} transact a check for the DELL @NCEPU +lab t:2017-05-04

$ t note show a
test it# {2017.05.04} transact a check for the DELL @NCEPU +lab t:2017-05-04



```


+ [t due][13]

【注意：】 关于due.py 只需要修改due.py的re.search的due改为t,并且把针对于due的4改为2即可。

```
        for i, task in enumerate(content):
            #match = re.search(r'due:\d{4}-\d{2}-\d{2}', task)
            match = re.search(r't:\d{4}-\d{2}-\d{2}', task)

            if match is not None:
                #date = datetime.strptime(match.group()[4:], '%Y-%m-%d').date()
                date = datetime.strptime(match.group()[2:], '%Y-%m-%d').date()



```

<hr/>
<hr/>
<hr/>

<hr/>


### [Todo.txt vim plugin][4]

用vim来修改你的todo.txt文件，挺方便的,通过bundle安装一下，不需要再.vimrc修改其他东西。

``` vim
Sorting tasks:
 <localleader>s  Sort the file
 <localleader>s+  Sort the file on +Projects
 <localleader>s@  Sort the file on @Contexts
 <localleader>sd  Sort the file on dates
 <localleader>sdd  Sort the file on due dates

Edit priority:
 <localleader>j  Decrease the priority of the current line
 <localleader>k  Increase the priority of the current line
 <localleader>a  Add the priority (A) to the current line
 <localleader>b  Add the priority (B) to the current line
 <localleader>c  Add the priority (C) to the current line

Date:
 <localleader>d  Set current task's creation date to the current date
 date<tab>  (Insert mode) Insert the current date

Mark as done:
 <localleader>x  Mark current task as done
 <localleader>X  Mark all tasks as done
 <localleader>D  Move completed tasks to done.txt

```
### [The video about Todo.txt][2]


### [todo原始命令的使用][23]

**注意事先得对t进行alias，并执行todo的命令补全功能shell,具体官网看说明**

+ t add @f708 +multiAxis finish paper
表示 添加一个t add命令表示添加一个命令  @后面跟着【地点】 +后面跟着【项目名】，之后的都叫做任务信息(task info)

+ t list
或者t ls,表示【列出】todo.txt内容的所有【任务】

+ t listall
<font color="red">把已完成和未完成的任务通通显示出来，并在报告的结尾做一个【简短的报告】，well done</font>.

+ t p 18 B
表示给任务号为18的【添加】一个B的【权限】(权限按照字母表A-Z都可以)，可以通过t list显示所有任务信息，然后通过t lsp显示所有的
带权限的任务。 
相反地，t depri 或者t dp表示【去除】相应任务的【权限】

+ t lsprj
表示【显示】任务中涉及到的【项目】(注意区分显示带权限的任务),也可以写作t listproj,类似的t lsc表示显示项目中所有涉及到地址(即@打头的),也可以写作t listcon
+ t rm  1
```
$ t rm 1
Delete '(A) due:2017.05.02  @home do some job'?  (y/n)
```
显示是否【删除】一个task no 的【任务】。类似于t del 1。

+ t do 1
完成任务1，并把该条语句信息【包含完成时间】提交到done.txt中

+ t report
生成一个report.txt,然后把对应日期里面的【未完成】的计划数、【已完成】的计划数写在后面两位

+ t
单单一个t会显示所有的项目名字和地址名字

+ t listfile
或者t lf列出所有todo.txt目录相关的文件

```
Files in the todo.txt directory:
done.txt
hey.txt
report.txt
todo.txt
```

+ t archive
定期可以做一个【归档】,会把todo.txt done.txt中的空行去除，生成.bak文件

+ t prepend 1 "hello"
或者t prep 1 hello，引号可以省略，表示在一个任务号前面添加信息
```
$ t prep 1 fuck
1 fuck due:2017.05.02  @home do some job
```
相反地，t append 1 "fuck" 或者t app 1 fuck表示在任务1的末尾添加fuck字段。


### .bashrc的相应配置

核心的功能就是<font color="red">【**todo.sh**】</font>
``` sh
#one thing: load todo.txt-cli
PATH=$PATH:"/cygdrive/d/Todo/todo.txt_cli-2.9"
alias t='todo.sh -d /cygdrive/d/Todo/todo.txt_cli-2.9/todo.cfg'
export TODOTXT_DEFAULT_ACTION=ls

#2nd thing: todo completion
source /cygdrive/d/Todo/todo.txt_cli-2.9/todo_completion
complete -F _todo t

#3rd thing: mit completion
source /cygdrive/d/Todo/todo.txt_cli-2.9/todo2.sh
complete -F _todotxtcli t

alias cdtodo='cd /cygdrive/d/Todo/todo.txt_cli-2.9'

```


<h3 id="ubuntu">Ubuntu version</h3>
you need to configure the Path, t etc, you also need to complete the commands for t.

``` sh
PATH=$PATH:"~/TodoXshell/todo.txt_cli-3.9"
alias t='todo.sh -d ~/TodoXshell/todo.txt_cli-2.9/todo.cfg'
export TODOTXT_DEFAULT_ACTION=ls
source ~/TodoXshell/todo.txt_cli-2.9/todo_completion
complete -F _todo t

source ~/TodoXshell/todo.txt_cli-2.9/todo2.sh
complete -F _todotxtcli t

alias cdtodo="cd ~/TodoXshell/todo.txt_cli-2.9"

alias .="cd ../"
alias ..="cd ../../"
alias ...="cd ../../.."


```



todo2.sh参考[Mit][6], the same with ubuntu, don't need to be modified.
``` sh
# todo-txt completion
_todotxtcli() {
  local cur="${COMP_WORDS[COMP_CWORD]}"
  local pre="${COMP_WORDS[COMP_CWORD-1]}"
  local cst="${COMP_WORDS[COMP_CWORD-2]}_${COMP_WORDS[COMP_CWORD-1]}"
#  echo "start--->"
#  echo $cur
#  echo $pre
#  echo $cst
#  echo "end-->"
  case $pre in
    mit )
      COMPREPLY=( $(compgen -W "today tomorrow monday tuesday wednesday thursday friday saturday sunday january february march april may june july august september october november december" -- $cur) )
      ;;
    * )
      if [[ $cst =~ ^mv_[0-9]+$ ]]; then
        COMPREPLY=( $(compgen -W "today tomorrow monday tuesday wednesday thursday friday saturday sunday january february march april may june july august september october november december" -- $cur) )
      else
        COMPREPLY=( $(compgen -W "mit `eval todo.sh lsprj` `eval todo.sh lsc`" -- $cur) )
      fi
      ;;
  esac
#  echo $COMPREPLY
}
complete -F _todotxtcli t

```

[User manual][27]

### git credential

```
git config --global credential.helper store
```

[1]:https://github.com/ginatrapani/todo.txt-cli 
[2]:https://vimeo.com/3263629 
[3]:https://github.com/ginatrapani/todo.txt-cli/wiki/Todo.sh-Add-on-Directory#mit-most-important-task 
[4]:https://github.com/freitass/todo.txt-vim 
[5]:https://github.com/timpulver/todo.txt-graph 
[6]:https://github.com/codybuell/mit 
[7]:https://github.com/linduxed/todo.txt-mitf 
[8]:https://github.com/Thann/todo-cli-plugins 
[9]:https://github.com/gr0undzer0/xp 
[10]:https://github.com/ginatrapani/todo.txt-cli/tree/addons/.todo.actions.d 
[11]:https://github.com/ginatrapani/todo.txt-cli/wiki/Todo.sh-Add-on-Directory#sync-sync-state-between-local-and-remote-git-repository 
[12]: https://raw.githubusercontent.com/fnd/todo.txt-cli/extensions/commit
[13]:https://github.com/rebeccamorgan/due 
[14]:https://github.com/jueqingsizhe66/Todo/blob/master/finalResult.png
[15]:https://github.com/jueqingsizhe66/Todo/blob/master/finalResult2.png
[16]:https://github.com/ginatrapani/todo.txt-cli/wiki/Creating-and-Installing-Add-ons#installing-add-ons 
[17]:https://github.com/duncanje/todo.txt-revive 
[18]:https://github.com/nthorne/todo.txt-cli-again-addon 
[19]:https://github.com/nthorne/todo.txt-cli-again-addon#adjustment-format 
[20]:https://github.com/jueqingsizhe66/TodoPlugins/tree/develop  
[21]:https://github.com/kunkku/todo.txt-cli-chcon 
[22]:https://github.com/mgarrido/todo.txt-cli/tree/note/todo.actions.d 
[23]:https://github.com/ginatrapani/todo.txt-cli/blob/master/todo.sh 
[24]:https://github.com/jueqingsizhe66/TodoActionXshell 
[25]:https://github.com/jueqingsizhe66/TodoXshell
[26]:https://github.com/jueqingsizhe66/ranEmacs.d
[27]:https://github.com/todotxt/todo.txt-cli/wiki/User-Documentation
