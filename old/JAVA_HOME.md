# 关于JAVA_HOME

前几天浏览器不知道为什么说需要JAVA环境，然后提示我更新，我就更新了，其实我不太想更新来着，java1.8不知道会有什么不兼容的问题。更新了之后它帮我自动配置到环境变量中去了，然后尼玛我的Ecpilse打不开了，我感觉这个跟环境变量有关。话说我现在还不知道它到底是怎么帮我配置环境变量的。今天用CMD命令行，发现java版本已经变成1.8了，有点不爽，于是去环境变量里看了一下，发现它居然帮我再`path`这个系统全局环境变量里面，加了个这个路径`C:\ProgramData\Oracle\Java\javapath`,然后这个目录下面有三个链接文件似的东西，最终指向这个路径下面的文件`C:\Program Files (x86)\Java\jre1.8.0_66\bin` `java.exe` `javaw.exe` `javawx.exe`。我说吧，果然指向java1.8的路径下了。于是将这个东西去掉，加上`%JAVA_HOME%`，这下终于好了。![环境变量](https://github.com/caiqiqi/Notes/master/img/环境变量.png)</br>
这不，一改好了环境变量，马上Eclipse就启动起来了
