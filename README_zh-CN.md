[English](readme.md) | 中文

---

master 分支：v3.0+

v2 分支：v2.x

[官网（说明文档）](https://capslox.com/capslock-plus/)


## 怎么运行Capslock+的源码？
1. 下载 [AutoHotkey (v1.1.+)](http://www.ahkscript.org/)，并安装。
2. 从 GitHub 下载 Capslock+ 源码。
3. 运行`Capslock+.ahk`。

## 怎么修改某个热键为自定义功能？
1. 在 `/userAHK/main.ahk`，编写自定义的按键功能函数，例如 `keyFunc_example1`
2. 在 `CapsLock+settings.ini` 的 [Keys] 字段下添加设置按键设置，例如：
    `caps_f7=keyFunc_example1`
3. 保存后重载 Capslock+ (Capslock+F5)
4. 之后再按下 `CapsLock+F7` 就可以触发该函数。

* 为了避免按键设置会调到内部函数，所以规定了所有函数以`keyfunc_`开头

下面提供一个例子：

### 把 Capslock+Q 替换成 Listary
有同学跟我吐槽`qbar`太弱鸡，让我参考`WOX`，`Listary`等把`qbar`写得厉害一点，但我觉得`qbar`就是够用就好，如果有更高的需求那就直接用它们代替`qbar`吧。以`Listary`为例子，`Listary`虽然强大，但是个人觉得跟`qbar`比有两个不足的地方：

1. 我觉得 Listary 的默认热键不如 `Capslock+Q` 顺手
2. 不能将选中的文字直接填入

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
        ; 在选中的字前面加上"gg "，使用 google 搜索
        selText:="gg " . selText

        ; 输出刚才复制的文字，并按一下`home`键将光标移到开头，以方便加入其它关键词
        sendinput, %selText%{home}
    }
}
```

2. 在`CapsLock+settings.ini` `[keys]`设置：`caps_q=keyfunc_listary()`，保存，按下`CapsLock+F5`重载，搞定。

## 怎么修改原有的功能？
`CapsLock+.ahk`是入口文件，其他所有依赖文件都扔`/lib`里了，各文件说明如下：

|文件|说明|
|:---|:---|
|lib_bindWins.ahk|窗口绑定|
|lib_clQ.ahk|qbar|
|lib_clTab.ahk|CapsLock+Tab|
|lib_functions.ahk|一些依赖函数|
|lib_init.ahk|各种初始化从这里开始|
|lib_jsEval.ahk|调用ie引擎实现的计算功能，计算板和Caps+Tab的计算功能都用到|
|lib_json.ahk|json库|
|lib_keysFunction.ahk|几乎所有按键功能都在这实现|
|lib_keysSet.ahk|热键布局|
|lib_language.ahk|程序用到的字符串放到这|
|lib_loadAnimation.ahk|程序加载动画|
|lib_mathBoard.ahk|计算板|
|lib_mouseSpeed.ahk|鼠标变速|
|lib_settings.ahk|Capslock+settings.ini设置项提取|
|lib_ydTrans.ahk|翻译|

