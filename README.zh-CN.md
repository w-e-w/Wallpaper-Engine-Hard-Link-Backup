# Wallpaper-Engine-Hard-Link-Backup
Preventing Steam from deleting Wallpaper Engine's workshop wallpapers by using hard links as backup

防止Steam删除壁纸的工具

在`疑难排解指南与常见问题集`介绍到一个问题
https://help.wallpaperengine.io/zh/steam/backup.html
> 如果您出于任何原因从 Steam 中删除了壁纸，Steam 也会从您的 PC 上删除这些壁纸。 Wallpaper Engine 无法阻止这种情况，但如果您对此感到担忧，您可以备份壁纸。

官方提供的应对方式是自己建立壁纸备份，但这么做的缺点是会占用一倍的储存空间

虽然可以备份后再取消壁纸的订阅但这么做麻烦，而且无法收到壁纸的更新

---
## 这个项目的目标是
 1. 防止Steam删除壁纸
 2. 在不浪费储存空间的前提
- 使用`硬连结`实现

---
## 硬连结是什么 (简化说明)
硬连结（英语：hard link）
我们在档案系统中看到的`档案物件`其实并不是`档案资料`本身

这个`档案物件`其实是一个告诉电脑`档案资料`存在装置的哪里的一份资讯

这个`档案物件`叫做`硬连结`

一个`档案资料`必须只少有一个对应的`硬连结`，`硬连结`可以同时存在多个

一个`档案资料`只有在它所有的`硬连结`都被删除后才会被删除

注:

1. 多个`硬连结`不会增加你的储存空间使用量，但因为Windows计算档案大小的方式看能会看似占用了大量空间，若要确认可以查看至装置的使用量确认空间使用状况
2. 假设`file A`和`file B`是同一个`档案资料`的`硬连结`, 若对`file A`进行编辑，`file B`也会一同变化，因为这两个是同一个`file data`
3. 严格上来说所有的`档案物件`都是`硬连结`但一般不会称这个称互，尤其是当`档案物件`和`硬连结`是一对一对应时不会这么称互.

### 若欲了解更详细关于`硬连结`的资讯请找其他资讯

---

## 工作原理
将壁纸档案额外建立一份`硬连结`，当Steam尝试删除原档案后，档案因为还存在额外的`硬连结`所以不会真的删除

---
## 脚本功能/作用
- 建立`Steam Workshop下载`的`硬连结`备份
- 对`硬连结 (Hard Link copy)`和`Steam Workshop下载`进行比对，找出缺失的壁纸
- 如果发现有缺失的壁纸，则会将该壁纸移动到`资料夹`中
  - 脚本会尝试判断是`"使用者删除"`或是`"Steam删除"`
    1. 如果壁纸是在`Wallpaper Engine介面`关闭1分钟内被删除的，脚本会判断为`"使用者删除"`
    2. 若是在`Wallpaper Engine介面`启动前被删除的，脚本会判断为`"Steam删除"`
    3. 根据是`"使用者删除"`或`"Steam删除"`脚本会则会将该壁纸移动到不同的`资料夹`中
    - 这个判断方式有缺陷
      1. 如果再`Wallpaper Engine介面`未启动期间使用者使用网路浏览器`退订`了壁纸，脚本会判断为`"Steam删除"`
      2. 或在`Wallpaper Engine介面`启动期间`"Steam删除"`某个壁纸，脚本会判断为`"使用者删除"`
      - 更进阶的判断方式有
        1. 透过网路获取Steam Workshop资讯
        2. 确认壁纸是否存在
        - 以后可能会使用此方案
  - 若判断为`"Steam删除"`壁纸，会将壁纸移动到`备份 (Backups)`资料夹中，然后重新汇入Wallpaper Engine
  - 若判断为`"使用者删除"`壁纸，会将壁纸移动到`移除 (Removed)`资料夹中
    - 可以将`移除 (Removed)`当成类似"资源回收桶"的概念，确认内容确实是不需要的后手动删除
    - 这么做的原因是判断可能有误判的可能性
- If a Wallapaer has be accidentally move to `Removed` folder, you can move it manually to the `Backups` folder
- 若有壁纸被误判断移动到`移除 (Removed)`资料夹中，你可以手动的移动到`备份 (Backups)`资料夹中以复原壁纸，反过来也是
    
---
## 脚本流程
1. 脚本会在背景执行
2. 定时性的确认`Wallpaper Engine介面`使否开启，(预设每5秒检查一次)
3. if it found tha Wallpaper Engine UI is running
4. 若发现`Wallpaper Engine介面`启动后
   1. 比对`硬连结 (Hard Link)`和`Steam Workshop下载`中的壁纸，是否有却失
      1. 若发现缺失则会将壁纸移动到`备份 (Backups)`资料夹中
      2. 然后将`备份 (Backups)`资料夹中的壁纸汇入到Wallpaper engiene内
   2. `Wallpaper Engine介面`关闭后，开始`倒数计时`。(预设倒数1分钟)
      1. `倒数计时`可被`Wallpaper Engine介面`的再度开启打断，若被打断则会回到先期的步骤
      2. 到`倒数计时`完毕后
         1. 比对`硬连结 (Hard Link)`和`Steam Workshop下载`中的壁纸，是否有却失
            1. 若发现缺失则会将壁纸移动到`移除 (Removed)`资料夹中
         2. 对`Steam Workshop下载`中的壁纸进行`硬连结 (Hard Link copy)`备份到`硬连结 (Hard links)`资料夹中
5. 循环

`倒数计时`的原应是给Steam足够的时间删除最近下载然后立刻删除的壁纸，因为使用者可能下载壁纸后发现不喜欢力可删除。

若`硬连结 (Hard Link copy)`是在`Wallpaper Engine介面`关闭后立可执行，则所以的壁纸包含不要的都会被备份。

---

## 使用方是
### 普通模式
1. 下载release page中的执行党(exe)
2. 将exe存放在资料夹中然猴执行，有些生成某些档案
   1. 其中会有个`config.ini`，这档案是设定党，用来调适功能的。
   2. 若你的Wallpaper Engine 不是安装在预设的安装位址，你会需要选取对应的自位置
      1. you may still need to edit `config.ini` if your Wallpaper Enging and or Steam is not installed in the default location
      2. 你可能还会需要到`config.ini`进行额外的确认
   3. where are you want to backup your wallpapers, or use the default location
   4. 你对被询存防备份档案的位置或使用预设位置
      - ( User\USER_NAME\Steam Workshop Backup\Wallpaper Engine\ )
      - **必须与`Steam Workshop下载`在同一碟上**
3. 你询问您是否希望脚本在启动时运行
   - 可以之后手动启用`启动时运行`
4. after confirming these configurations are correct, execute the exe again
5. 确认`config.ini`设定正确后，再度执行exe
6. 脚本将在背景执行，更多资讯参考`脚本流程`

### Advance mode
下载
1. 复制整个repository
2. 记得要也要复制子模组(sub-modules)
3. 若要自动化请安装AutoHotkey
   
自动模式
- 使用AutoHotkey执行`Wallpaper Engine - Hard Links Backup.ahk`
  - 脚本会立刻在背景执行不会进行设定/确认`config.ini`是否正确
    - if you only intend to use it automated, I recommend to just use the released exe
    - 如果你只打算这使用不进行修改，建议使用发布的exe
    - 
手动执行
- 在`Wallpaper Engine module`含有预先组合好的流程
- 根据需求使用

随你怎么用

---
## Steam Workshop 和 Wallpaper Engine behaviors 观察
1. Steam 在任何时候都可以下载workshop当按
2. Steam 只会在`Wallpaper Engine介面`非执行时删除档案
3. user can Subscribed to Wallpapers using Wallpaper Enging UI
4. 使用者使用`Wallpaper Engine介面`订阅壁纸时，壁纸会被立刻下载
5. user can Unsubscribed to Wallpapers using Wallpaper Enging UI
6. 使用者使用`Wallpaper Engine介面`退订壁纸时，退订的壁纸要等`Wallpaper Engine介面`关闭后才会被Steam删除
---

## 警告
- 此脚本是设计给使用NTFS档案系统的Windows电脑
  - 大部分使用Wallpaper Engine的电脑依该都适用
- Even though I use the term **Backup**, This is not truly a Backup Tool
- 我曾在上面多次使用的到**`备份 或 Backup`**但这个不是个真正的备份工具
  - 这部不会对数据丢失有任何保护
  - 你的党案只存在有一份
  
- Steam could changed the methid of deleting files
- Steam可能改变它们删除档案的方式
  - there are methods of deleting files that can delete files with multiple Hard Links
  - 某些删除方式可以完全删除掉有多硬连结的档案
  - 如果Steam使用了改种类的删除方式，此项目将会完全无用

- this tool is not designed for you to keep multiple versions of wallpaper
- 这个工具不是设计来进行多版本壁纸保存的
  - 随然在某些条件下会有此作用
