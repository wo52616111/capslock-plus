[功能说明文档](http://cjkis.me/capslock+/)

觉得好用欢迎[捐赠](http://cjkis.me/payment/)

##1.怎么运行Capslock+的源码？
1. 下载 [AutoHotkey](http://www.ahkscript.org/)，并安装。
2. 从 GitHub 下载 Capslock+ 源码。
3. 运行`Capslock+.ahk`。

##2.能不能在XXX快捷键上实现XXX功能？
打开`/userAHK/main.ahk`，看看开头的说明。

还是抄一下吧：

```ahk
/*
不打算修改程序本身，只想为某个按键实现功能的话，可以在这里：
1. 添加 keyfunc_xxxx() 的函数，
2. 在 Capslock+settings.ini [keys]下添加设置，
例如按下面这样写，然后添加设置：caps_f7=keyFunc_test2(apple)
3. 保存，重载 capslock+ (capslock+F5)
4. 按下 capslock+F7 试试
************************************************/
keyfunc_test2(str){
  msgbox, % str
  return
}
```

*为了避免按键设置会调到内部函数，所以规定了所有函数以`keyfunc_`开头

具体要实现什么功能，就去学下 AutoHotkey 咯，很快上手的。下面提供一下例子：

###把 Capslock+Q 替换成 Listary
有同学跟我吐槽`qbar`太弱鸡，让我参考`WOX`，`Listary`等把`qbar`写得厉害一点，但我觉得`qbar`就是够用就好，如果有更高的需求那就直接用它们代替`qbar`吧。以`Listary`为例子，`Listary`虽然强大，但是个人觉得跟`qbar`比有两个不足的地方：

1. 呼出输入框快捷键不方便，按两下`Ctrl`太累人，其他自定义快捷键我都觉得不如`Capslock+Q`顺手。
2. 更重要的是，不能将选中的文字直接填入，这个我是接受不了了。

那我们可以这样做来解决这两个问题：

1. 把下面代码复制到`/userAHK/main.ahk`里：
  ```ahk
  keyfunc_listary(){
    ; 获取选中的文字
    selText:=getSelText()

    ; 发送 win+F 按键（Listary默认的呼出快捷键），呼出Listary
    sendinput, #{f}

    ; 等待 Listary 输入框打开
    winwait, ahk_exe Listary.exe, , 0.5

    ; 如果有选中文字的话
    if(selText){
      ; 在选中的字前面加上"gg "（因为谷歌搜索是我最常用的，你也可以不加）
      selText:="gg " . selText
      ; 输出刚才复制的文字，并按一下`home`键将光标移到开头，以方便加入其它关键词
      sendinput, %selText%{home}
    }
  }
  ```

2. 在`Capslock+settings.ini` `[keys]`设置：`caps_q=keyfunc_listary()`，保存，按下`Capslock+F5`重载，搞定。
![caps_q Listary](http://dn-cjk.qbox.me/caps_listary.gif)

##3.那你原有的功能我想改怎么改？
`Capslock+.ahk`是入口文件，其他所有依赖文件都扔`/lib`里了，各文件说明如下：

|文件|说明|
|:---|:---|
|lib_bindWins.ahk|窗口绑定|
|lib_clQ.ahk|qbar|
|lib_functions.ahk|一些依赖函数|
|lib_init.ahk|各种初始化从这里开始|
|lib_jsEval.ahk|调用ie引擎实现的计算功能，计算板和Caps+Tab的计算功能都用到|
|lib_json.ahk|json库|
|lib_keysFunction.ahk|几乎所有按键功能都在这实现|
|lib_language.ahk|程序用到的字符串放到这|
|lib_loadAnimation.ahk|程序加载动画|
|lib_mathBoard.ahk|计算板|
|lib_mouseSpeed.ahk|鼠标变速|
|lib_settings.ahk|Capslock+settings.ini设置项提取|
|lib_ydTrans.ahk|翻译|

##4.你代码写得也太烂了吧，注释又少...
我也觉得，当初 Capslock+ 是我写来自己用的，想要什么功能就直接加上去，没怎么规划，但求够用和快点写完。当然很大原因也是水平不够。

一直想着有时间好好重构一遍，并写多些注释再扔出来。不过一直没时间，已经拖了好久了，就先放出来吧...


