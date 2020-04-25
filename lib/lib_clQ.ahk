global LastHw:=0x000000
global LostFocusHw2Handlers:=Object()
; For catching unfocus events
HandleWindowMessage( p_w, p_l, p_m, p_hw )
{
    global
    local control
    msgbox, % p_l
    setformat, integerfast, h
    if(LastHw==0x000000)
    {
        LastHw:=p_l
        return
    }
    if(LastHw!=p_l)
    {
        aLabel=% LostFocusHw2Handlers[LastHw]
        if (IsLabel(aLabel))
            gosub %aLabel%
        LastHw:=p_l
    }
    return
}


;  #Include lib_functions.ahk ;引入函数库
isFolder(str)
{
    if(InStr(FileExist(str),"D"))
        return true
    else
        return false
}

pickIconsArrayKey(str)
{
    strType := checkStrType(str)
    
    if(strType == "folder")
    {
        ;if checkStrType(str)=="folder", it may not folder(it is possible a file that no file suffix), must check the attributes to make sure
        if(InStr(FileExist(str),"D"))
            return "__folder__"
        else
            strType := "file"
    }
    if(strType == "file")
    {
        ;以下类型含有唯一图标
        if(RegExMatch(str,"i)\.(exe|lnk|ico|ani|cur)$"))
        {
            return str
        }
        else if(RegExMatch(str,"[^\.]+$",matchStr))
        {
            return matchStr
        }
        
    }
    else if(strType == "web")
    {
        return "__web__"
    }
    else
        return str
}

;change string for glob search
easyGlobToRegEx(easyGlobStr)
{
    _str := "iS)" . RegExReplace(easyGlobStr, "[^*?]+", "\Q$0\E")
    StringReplace, _str, _str, *, .*, All
    StringReplace, _str, _str, ?, ., All
    return _str
}

/*
qrunObj:
{
    key:{
        path:"string",  qrun对应的值
        exePath:"string", 如果path是lnk，则还获取它的实际exe路径
        iconIndex:num,
    }
}
starMenuObj:
{
    lnkName:{
        lnkPath:"string",
        exePath:"string",
        iconIndex:num
    }
}
//简写拼音对象，每个一个key是一个简写，对应一个数组，数组的每个值是 starMenuObj 的 key，也就是 lnkName，可以用于简拼搜索
shortPinYinObj:
{
    
}
*/

;简拼搜索用到的对象
;  shortPinyinObjInit:
;  global shortPinyinObj={}
;  return

;将开始菜单的数据保存为对象
loopStarMenuObjInit:
global starMenuObj={}
_arr:=[]
_arr.push(A_StartMenu . "\*")
_arr.push(A_StartMenuCommon . "\*")

loop, 2
loop, % _arr[A_Index], 0, 1
{
    ;如果文件名有以下字符串，跳过它
    if A_LoopFileName contains .ini,卸载,uninstall
        continue

    FileGetShortcut, %A_LoopFileFullPath%, _exePath
    
    ;如果不是.exe文件，跳过
    if(!RegExMatch(_exePath, "i)exe$"))
        continue
    
     _t:=RegExReplace(A_LoopFileName, "i)\.lnk$")
    starMenuObj[_t]:={}
    _obj:=starMenuObj[_t]
    _obj.lnkPath:=A_LoopFileFullPath
    _obj.exePath:=_exePath
    _obj.iconIndex:=listViewIconGet(_exePath)
    
    ;  shortPinyinObj[_t]:=eval("getPinyinRegEx('" . _t . "')")
}
return

qrunObjIconInit:
searchIcon:=IL_Add(ImageList0, "shell32.dll", 23)   ;获取"搜索图标"
ftpIcon:=IL_Add(ImageList0, "C:\Windows\System32\imageres.dll", 69)

for key,value in CLSets.QRun
{
    value.iconIndex:=listViewIconGet(value.setValue)
    ;  shortPinyinObj[key]:=eval("getPinyinRegEx('" . key . "')")
}
for key,value in CLSets.QWeb
{
    value.iconIndex:=listViewIconGet("web")
    ;  shortPinyinObj[key]:=eval("getPinyinRegEx('" . key . "')")
}
for key,value in CLSets.QSearch
{
    value.iconIndex:=searchIcon
    ;  shortPinyinObj[key]:=eval("getPinyinRegEx('" . key . "')")
}



return

#If WinActive("ahk_id" . GuiHwnd)&&CapsLock
;  d::
;  ControlFocus, , ahk_id %LV_show_Hwnd%
;  SendInput, {Down}
;  ControlFocus, , ahk_id %editHwnd%
;  CapsLock2:=""
;  return

;  e::
;  ControlFocus, , ahk_id %LV_show_Hwnd%
;  SendInput, {Up}
;  ControlFocus, , ahk_id %editHwnd%
;  CapsLock2:=""
;  return

;  -::
;  ControlFocus, , ahk_id %LV_show_Hwnd%
;  SendInput, {PgUp}
;  ControlFocus, , ahk_id %editHwnd%
;  CapsLock2:=""
;  return

;  =::
;  ControlFocus, , ahk_id %LV_show_Hwnd%
;  SendInput, {PgDn}
;  ControlFocus, , ahk_id %editHwnd%
;  CapsLock2:=""
;  return

;  i::
;  ControlFocus, , ahk_id %LV_show_Hwnd%
;  SendInput, {Up 5}
;  ControlFocus, , ahk_id %editHwnd%
;  CapsLock2:=""
;  return


;  k::
;  ControlFocus, , ahk_id %LV_show_Hwnd%
;  SendInput, {Down 5}
;  ControlFocus, , ahk_id %editHwnd%
;  CapsLock2:=""
;  return

;  ,::
;  try
;      gosub, % keyset.caps_b_in_qbar
;  return

/::sendinput {/}
#If


#If WinActive("ahk_id" . GuiHwnd)
tab::

ControlGet, ifListVisible, Visible, , , ahk_id %LV_show_Hwnd%
if(!ifListVisible) ;if List hidden
{
    ControlGet, LV_Show_Count, List, Count, , ahk_id %LV_show_Hwnd%
    if(LV_Show_Count) ;如果LV_show里有东西，显示出listview，不然不操作
    {
        ;~ MsgBox, % LV_show_Hwnd
        ;~ GuiControl, Show, %LV_show_Hwnd%
        guiH:=editH+listH+listX*2 
        
        w:=fixDpi(guiW)
        h:=fixDpi(guiH)
        r:=fixDpi(guiRadius)

        WinSet, Region, 0-0 w%w% h%h% R%r%-%r%, ahk_id %GuiHwnd% ;--cjk1
        WinMove, ahk_id %GuiHwnd%, , , , , %h%   ;--cjk1
        WinShow, ahk_id %LV_show_Hwnd%
        goto, change_edit_width
    }
    
    return
}
tabAction:
listSelected:=""
ControlGet, listSelected, List, Selected Col2, , ahk_id %LV_show_Hwnd%
if (!listSelected)  ;如果没有高亮list时tab一下，自动按一下down，再取
{
    ControlFocus, , ahk_id %LV_show_Hwnd%
    SendInput, {Down}
    ControlFocus, , ahk_id %editHwnd%
    ControlGet, listSelected, List, Selected Col2, , ahk_id %LV_show_Hwnd%
}
listSelected:=getShortSetKey(listSelected)
if(LVlistsType == 1)
{
    ControlGetText, editText, , ahk_id %editHwnd%
    listSelected := RegExReplace(editText, "i)(?<=\\)[^\\]*$", listSelected) 
}
ControlSetText, ,%listSelected%, ahk_id %editHwnd%
SendInput, {End}
;  }
return

Down::
ControlFocus, , ahk_id %LV_show_Hwnd%
SendInput, {Down}
ControlFocus, , ahk_id %editHwnd%
return

Up::
ControlFocus, , ahk_id %LV_show_Hwnd%
SendInput, {Up}
ControlFocus, , ahk_id %editHwnd%
return

;unfinished
listViewIndexSel(num)
{
    global
    ;  ControlFocus, , ahk_id %LV_show_Hwnd%
    Gui, ListView, LV_show
    LV_Modify(4, "Select")
    LV_Modify(4, "Focus")
    ;  ControlFocus, , ahk_id %LV_show_Hwnd%
    ;  SendInput, {Down}
    ;  ControlFocus, , ahk_id %editHwnd%
    return 
}



/::
\::
; 禁用 doWhenChanged函数
doNothingWhenChanged:=1

ControlGetText, editText, , ahk_id %editHwnd%

ControlGet, ifListVisible, Visible, , , ahk_id %LV_show_Hwnd%
if(ifListVisible)
{
    if(LVlistsType == 0)
    {
        gosub, tabAction
        ;  ControlGetText, editText, , ahk_id %editHwnd%
        tempText := CLSets.QRun[LTrim(editText)].setValue
        if(tempText != "")
        {
            ;Enable doWhenChanged
            doNothingWhenChanged:=0
            ;  sleep, 10
            ControlSetText, , %tempText%\, ahk_id %editHwnd%
            sendinput, {end}
            ;  ControlGetText, editText, , ahk_id %editHwnd%
            ;  if(RegExMatch(editText, "\\$"))
            ;  listType1Init(RegExReplace(tempText,"[^\\]*$"))0
            return
        }
    }
    
    listSelected:=""
    ControlGet, listSelected, List, Selected Col2, , ahk_id %LV_show_Hwnd%
    if (!listSelected)  ;if no highlight
    {
        ;if edit text has no '*'or'?' AND not end with '\' AND is folder existing
        ; => if input text is a existing folder name 
        if(!RegExMatch(editText,"[\*\?]|\\$") && InStr(FileExist(editText),"D"))
        {
            ;Enable doWhenChanged
            doNothingWhenChanged:=0
            sleep, 10
            sendinput, {U+005C}
            return
        }
    }
    gosub, tabAction
    ControlGetText, editText, , ahk_id %editHwnd%
    
    if(InStr(FileExist(editText),"D"))
    {
        ;Enable doWhenChanged
        doNothingWhenChanged:=0
        sleep, 10
        ;  MsgBox, 1 %doNothingWhenChanged%
        sendinput, {U+005C}
    }
    doNothingWhenChanged:=0
    ;  MsgBox,3 %doNothingWhenChanged%
    return
}
else
{
    ;Enable doWhenChanged
    doNothingWhenChanged:=0
    sendinput, {U+005C}
    
    ;  if(A_ThisHotKey = "\")
    ;      sendinput, {\}
    ;  else if(A_ThisHotKey = "/")
    ;      sendinput, {/}
}
;  if(ifListVisible)   
;      gosub, tabAction
doNothingWhenChanged:=0
return
#If

progressUpdate(now,total)
{
    ;  msgbox, %QProgressHwnd%
    global QProgressHwnd
    _percent := Ceil(now/total*100)
    ;  GuiControlGet, _percentNow, , %QProgressHwnd%
    ;  msgbox, % progressPoint
    if(_percent >= 100)
        GuiControl, , %QProgressHwnd%, 0
    else
        GuiControl, , %QProgressHwnd%, +%_percent%
    return _percent
}


CLq()
{ ;CLq()Start
    global

    if(needInitQ)
    {
        ;  Gui, Destroy
        goto, guiStart
    }

    ;  qbarPathFuture:=[]
    ;  qbarPathHistory:=[""] ;保存 qbar 文件夹浏览时的历史路径，默认就是"空"路径(并不是NULL)
    ;  historyIndex:=1 ;历史指针
    ;  ifInsertHistory:=1   ;是否记录历史的标记
    ifClearFuture:=1
    ;  historyNow:=0   ;对于当前历史指针指向的位置来说，现在是偏未来(1)还是偏过去(-1)还是刚好是当前(0)

    selText:=getSelText() ;调用getSelText()复制文字
    if(selText) ;如果有选中的文字
    { 
        selText:=A_Space . selText ;在前面加个空格先
        SetTimer, MoveCaret, 10 ;移动inputbox光标到开头
    }

    IfWinExist, ahk_id %GuiHwnd%
    {
        ; ControlSetText, , %selText%, ahk_id %GuiHwnd%
        ; WinActivate, ahk_id %GuiHwnd%
        ; CapsLock2:=""
        Gui, %GuiHwnd%:Default
        gosub, QGuiClose

        return
    }

    

    DetectHiddenWindows, On ;可以检测到隐藏窗口
    WinGet, ifGuiExistButHide, Count, ahk_id %GuiHwnd%
    ;~ MsgBox, % ifguiexistbuthide
    if(ifGuiExistButHide) ;看看gui是不是已经有，只是隐藏了而已，如果只是隐藏就只要更改一下内容和显示出来
    {
        Gui, %GuiHwnd%:Default ;将下面的ListView函数操作都指向QGui，否则所有操作无效
        gosub, clearListTop ;清除置顶项
        gosub, change_edit_width ;重排序
        
        ControlSetText, , %selText%, ahk_id %editHwnd%
        GuiControl, Hide, %LV_show_Hwnd%
        guiH:=editH+listX*2 
        
        w:=fixDpi(guiW)
        h:=fixDpi(guiH)
        r:=fixDpi(guiRadius)
        
        WinSet, Region, 0-0 w%w% h%h% R%r%-%r%, ahk_id %GuiHwnd% ;--cjk1
        WinMove, ahk_id %GuiHwnd%, , , , , %h%   ;--cjk1
        ;  WinMove, ahk_id %GuiHwnd%, , , , , %guiH%   ;--cjk1
        WinShow, ahk_id %GuiHwnd%
        
        WinSetTitle, ahk_id %GuiHwnd%, , Qbar ;上面show出窗口后会把窗口标题改成ahk_id xxxx，改回来

        CapsLock2:=""


        SetTimer, closeWhenUnfocus, 50

        return

        closeWhenUnfocus:
        IfWinNotActive, ahk_id %GuiHwnd%
        {
            SetTimer, ,Off
            Gui, %GuiHwnd%:Default
            gosub, QGuiClose
        }
        return
    }


    guiStart:
    ;guiStart---start
    ;0: lists in listView from settings.ini
    ;1: lists in listView from loop folder
    LVlistsType:=0
    guiW:=380
    editH:=26
    _t:=CLSets["QStyle"]["borderRadius"]
    guiRadius:=_t!=""?_t:2
    editW:=354
    listW:=editW-2 ;**改代码时注意**：因为edit为了去掉外框而隐藏掉了2px，所以list要和edit对齐就要-2px
    _t:=CLSets["QStyle"]["borderBackgroundColor"]
    guiBGColor:=_t!=""?_t:0x555555 ;0x515151 ;0x006ab7 ; 0x002b36 ;窗口背景颜色
    _t:=CLSets["QStyle"]["textBackgroundColor"]
    editBGColor:=_t!=""?_t:0xee2255 ;0xff3366 ; 0xd33682 ;edit插件背景颜色
    _t:=CLSets["QStyle"]["textColor"]
    editColor:=_t!=""?_t:0xffffff ;edit文字颜色
    _t:=CLSets["QStyle"]["listColor"]
    listColor:=_t!=""?_t:0xffffff ;list文字颜色
    _t:=CLSets["QStyle"]["listBackgroundColor"]
    listBGColor:=_t!=""?_t:0x333333 ;list背景颜色
    _t:=CLSets["QStyle"]["progressColor"]
    progressColor:=_t!=""?_t:0x11ddaa
    listX:=(guiW-listW)/2 ;list位置坐标X
    listY:=listX+editH-2 ;list位置坐标Y
    editX:=listX-1 ;edit位置坐标X
    editY:=editX ;edit位置坐标Y
    editFontName:=CLSets["QStyle"]["textFontName"]
    _t:=CLSets["QStyle"]["textFontSize"]
    editFontSize:=_t!=""?_t:12
    listFontName:=CLSets["QStyle"]["listFontName"]
    _t:=CLSets["QStyle"]["listFontSize"]
    listFontSize:=_t!=""?_t:10
    _t:=CLSets["QStyle"]["listCount"]
    listCount:=_t!=""?_t:10 ;list的条目数量，这个改了的话listH也要手动更改
    _t:=CLSets["QStyle"]["lineHeight"]
    lineH:=_t!=""?_t:19 ;list的行高，默认字体consolas的话是19px
    listH:=lineH*listCount+4 ;每行19px，padding上下各1px，border上下各1px，一共4px
    prgrsX := listX-1
    prgrsY := editY-2
    prgrsW := listW+2
    ;~ guiH:=editH+listX*2  ;gui的高度，放到下面去了，需要每次都重置这个高度，不能在这里定义死
    ;以上各个数据排列顺序不要动，有依赖关系
    ;--------------------------------------------------------------------------这里是样式区，改样子只动这里！----------------------------start
    
    ;匹配不同DPI的屏幕（屏幕放大125%，150%，200%...）
    ;在不同DPI下，各部件放大之后会有些错位，微调一下
    
    if(A_ScreenDPI>96 && A_ScreenDPI<=120) ;125%
    {
        guiW+=3
        editY+=1
        editX+=1
        listY+=2
        listX+=1
        listW+=1
        listH+=0.2*listCount
    }
    else if(A_ScreenDPI>120 && A_ScreenDPI<=144)    ;150%
    {
        editW-=1
        listY+=1
        listH-=1*listCount
    }
    else if(A_ScreenDPI>144 && A_ScreenDPI<=192)    ;200%
    {
        listY+=1
        listH-=1*listCount
    }
    else if(A_ScreenDPI>192 && A_ScreenDPI<=240)    ;250%
    {
        listY+=1
        listX-=1
        listW+=2
        listH-=2.4*listCount
    }
    else if(A_ScreenDPI>240 && A_ScreenDPI<=288)    ;300%
    {
        listY+=1
        listX-=1
        listW+=2
        listH-=2.2*listCount
    }
    else if(A_ScreenDPI>288)    ; && A_ScreenDPI<=384  >=400%
    {
        listY+=1
        listX-=1
        listW+=2
        listH-=2.9*listCount
    }
    
    
    { ;---绘制Gui---start
    guiH:=editH+listX*2 ;重置guiH,不然的话只有listview出现过一次，就会把guiH撑大
        
    Gui, new, HwndGuiHwnd , Qbar ;创建Gui，获取Hwnd,设置标题为Qbar 
    Gui, %GuiHwnd%:+LabelQGui
    Gui, -Caption -Disabled -LastFound +MinimizeBox +MaximizeBox -OwnDialogs -Resize +SysMenu -ToolWindow  +AlwaysOnTop
    Gui, Color, %guiBGColor%, %editBGColor%
    Gui, Font, c%editColor% s12, 微软雅黑 Bold ;设置字体
    Gui, Font, c%editColor% s12, Microsoft YaHei UI Bold ;设置字体
    Gui, Font, c%editColor% s12, Hiragino Sans GB W6 ;设置字体Hiragino Sans GB W3,首选
    ;~ fSize:=CLSets["QStyle"]["editFontSize"]

    Gui, font, c%editColor% s%editFontSize% , %editFontName%
    ;---edit---start

    Gui, Add, Edit, x%editX% y%editY% w%editW% h%editH% -Multi -Border vinputStr gdoWhenChanged -WantReturn -WantTab HwndeditHwnd, 
    ;~ Clipboard:=ClipboardOld
    editWinSetW:=editW-2
    editWinSetH:=editH-2
    
    w:=fixDpi(editWinSetW)
    h:=fixDpi(editWinSetH)
    ;  x:=fixDpi(1)
    
    WinSet, Region, 1-1 w%w% h%h% , ahk_id %editHwnd%  ;切割外面蓝色边框  --cjk1
    ;---edit---end

    
    
    { ;---ListView---start

    ;  Gui, Font, c%listColor% s10, Microsoft YaHei UI ;设置字体
    ;  Gui, Font, c%listColor% s10, 微软雅黑 ;设置字体
    Gui, Font, c%listColor% s10, consolas
    Gui, Font, c%listColor% s%listFontSize% , %listFontName%
    
    ;  Gui, Font, c%listColor% s10, Source Code Pro
    
    ;Count%runFileNum%
    Gui, Add, ListView, Count1000 x%listX% y%listY% w%listW% r%listCount% NoSortHdr vLV_show -Hdr HwndLV_show_Hwnd -Multi  Background%listBGColor% , Type|FileName|ForSort
    GuiControl, Hide, LV_Show
    
    w:=fixDpi(listW)
    h:=fixDpi(listH)
    
    WinSet, Region, 0-0 w%w% h%h% , ahk_id %LV_show_Hwnd% ;--cjk1
    LV_ModifyCol(1, "Integer") ;for sort quick
    LV_ModifyCol(3, "Integer")
    
    LV_ModifyCol(2, "Sort")
    LV_ModifyCol(1, "Sort")
    

    LV_ModifyCol(2, 306) ;设置listview为1列，高亮时宽度326px
    LV_ModifyCol(1, 20) ;设置listview为1列，高亮时宽度326px
    LV_ModifyCol(3, 0)

    listHide0 := {} ;+Q's list hidding
    listHide1 := {} ;for loop folder
    } ;---ListView---end


    Gui, Add, Button, Default  w0 h0, Submit
    OnMessage(0x201, "MoveWin") ;光标在gui非控件地方可以拖动窗口

    ;原本gui在第一次打开要显示，但是现在在第一次运行不显示，并且运行程序自己先运行一遍，相当于开启即运行一遍，但是第一遍运行不显示，这样就可以做到提前缓存图标，提高用户第一次(其实实际是第二次了)打开的感受
    Gui, Show, Hide Center w%guiW% h%guiH%, Qbar ;--cjk1
    
    w:=fixDpi(guiW)
    h:=fixDpi(guiH)
    r:=fixDpi(guiRadius)
    prgrsY-=fixDpi(1)-1
    
    WinSet, Region, 0-0 w%w% h%h% R%r%-%r%, ahk_id%GuiHwnd% ;--cjk1
    
    Gui, Add, Progress, x%prgrsX% y%prgrsY% w%prgrsW% h3 Background%guiBGColor% c%progressColor% HwndQProgressHwnd
    ;  msgbox, %QProgressHwnd%
    ;  GuiControl,, ahk_id %QProgressHwnd%, 50
    iconsArray0.Count:="" ;下面会用到它作为QGui是否初始化过的判断，如果是数字判定为初始化过，所以要让第二次的初始化能进行，删掉这个变量
    gosub, QListIconInit

    needInitQ:=0 ;初始化+q结束，如果没有其他变化，不需要再重绘Gui

    Return
    } ;---绘制Gui---end



} ;CLq()End



;--------------------------------------------------------------------------这里是样式区，改样子只动这里！----------------------------end

QListIconInit:
{ ;---给list加上图标---star
    Gui, %GuiHwnd%:Default ;将下面的ListView函数操作都指向QGui，否则所有操作无效
    Gui, ListView, LV_show ;目标切换到LV_show
    
    if iconsArray0.Count is number ;如果图标列表已经有了
    {
        for key, QValue in ["QSearch","QRun","QWeb"]
        {
            ;动态删除
            for index,value in setsChanges[QValue].deleted
            {
                listViewDelete(value)
            } 
            setsChanges[QValue].deleted:={}
            
            ;动态添加
            for keyAdd,value in setsChanges[QValue].appended
            {
                shortKey:=getShortSetKey(keyAdd)
                if(QValue="QSearch")
                {
                    iconN := searchIcon
                    CLSets.QSearch[shortKey].iconIndex:=iconN
                }
                else if(QValue="QRun")
                {
                    iconN := listViewIconGet(value)
                    CLSets.QRun[shortKey].iconIndex:=iconN
                }
                else if(QValue="QWeb")
                {
                    iconN := listViewIconGet("web")
                    CLSets.QWeb[shortKey].iconIndex:=iconN
                }
                    
                if(LVlistsType == 0)
                {
                    if(QValue="QSearch")
                        LV_Add("Icon" . iconN, -1,keyAdd,0)
                    if(QValue="QRun")
                        LV_Add("Icon" . iconN, isFolder(value)?0:1,keyAdd,0)
                    if(QValue="QWeb")
                        LV_Add("Icon" . iconN, 2,keyAdd,0)
                }
                else
                    listHide0.insert(keyAdd)
            }
            setsChanges[QValue].appended:={}
            
            ;动态修改
            for keyMdf,value in setsChanges[QValue].modified
            {
                shortKey:=getShortSetKey(keyAdd)
                
                listViewDelete(keyMdf)
                if(QValue="QSearch")
                {
                    iconN := searchIcon
                    CLSets.QSearch[shortKey].iconIndex:=iconN
                }
                else if(QValue="QRun")
                {
                    iconN := listViewIconGet(value)
                    CLSets.QRun[shortKey].iconIndex:=iconN
                }
                else if(QValue="QWeb")
                {
                    iconN := listViewIconGet("web")
                    CLSets.QWeb[shortKey].iconIndex:=iconN
                }

                if(LVlistsType == 0)
                {
                    if(QValue="QSearch")
                        LV_Add("Icon" . iconN, -1,keyMdf,0)
                    if(QValue="QRun")
                        LV_Add("Icon" . iconN, isFolder(value)?0:1,keyMdf,0)
                    if(QValue="QWeb")
                        LV_Add("Icon" . iconN, 2,keyMdf,0)
                }
                else
                    listHide0.insert(keyMdf)
            }
            setsChanges[QValue].modified:={}
        }
        return
    }    
        
    ;-----------------如果还没初始化--------------------
    ImageList0 := IL_Create(CLSets.length.QRun+300) ; 创建图像列表, 这样 ListView 才可以显示图标
    ImageList1 := IL_Create(50,50)
    IL_Add(ImageList0, "shell32.dll", 1)
    IL_Add(ImageList1, "shell32.dll", 1)

    LV_SetImageList(ImageList0, 1) ; 关联图像列表到 ListView, 它就可以显示图标了
    
    
    
    global sfi_size, sfi
    ; 计算 SHFILEINFO 结构需要的缓存大小.计算解释：http://www.autohotkey.com/board/topic/96371-confused-about-data-sizes-in-64-bit-autohotkey/
    sfi_size := A_PtrSize + 8 + (A_IsUnicode ? 680 : 340)
    ;  msgbox, % sfi_size
    VarSetCapacity(sfi, sfi_size)
    ;  VarSetCapacity(sfi, 10240000)
    
    
    global iconsArray0:= {} ;建立iconNum字典，用于存放文件名对应着的图像列表索引，例如iconsArray["c.lnk"]=2，c.lnk的图像在图像列表第2个
    global iconsArray1:= {} ;iconsArray for loop folder
    iconsArray0.Count:=0
    iconsArray1.Count:=0
    gosub, qrunObjIconInit ;初始化qrun的icon
    ;listview 插入数据 初始化
    if(CLSets.length.QSearch) ;v2.5.4，添加搜索提示
    {
        for key,value in CLSets.QSearch
        {
            if(getShortSetKey(key)!="default")
                LV_Add("Icon" . value.iconIndex, -1, value.fullKey, 0)
        }
    }
    if(CLSets.length.QRun)
    {
        for key,value in CLSets.QRun
        {
            if(set2Run(value.setValue))
            {
                ; 在 ListView 中创建新行并把它和上面的图标编号进行关联:
                LV_Add("Icon" . value.iconIndex, isFolder(value.setValue)?0:1, value.fullKey, 0)
            }
        }
    }
    if(CLSets.length.QWeb)
    {
        ;添加QWeb
        for key,value in CLSets.QWeb
        {
            ;~ ; 在 ListView 中创建新行并把它和上面的图标编号进行关联:
            LV_Add("Icon" . value.iconIndex, 2, value.fullKey, 0)
        }
    }

    gosub, loopStarMenuObjInit ;初始化开始菜单对象
    for key,value in starMenuObj
    {
        LV_Add("Icon" . value.iconIndex, 3, key, 0)
    }

} ;---给list加上图标---end
return

listViewDelete(strDelete)
{
    global
    pickingNum:=1 ;下个要取的号码(不能用A_Index，因为如果上一次有删除ListView的话，实际上这一次检查的号码和上一次一样，虽然内容已经不同)
    loop, % LV_GetCount()
    {
        LV_GetText(LVText_i, pickingNum, 2)
        ;~ MsgBox, % LVText_i
        if(LVText_i!=strDelete)
        {
            pickingNum++
            continue
        }  
        else        ;不然的话删掉
        {
            LV_Delete(pickingNum)
        }
    }
    listMaxIndex := listHide%LVlistsType%.MaxIndex()
    loop, % listMaxIndex
    {
        i := listMaxIndex-A_Index+1
        valueTemp := listHide%LVlistsType%[i]
        if(valueTemp = strDelete)
        {
            listHide%LVlistsType%.Remove(i)
        }
    }

    return
}


; fastMode = 1, 不再获取新图标，只返回已查过的图标
listViewIconGet(filePath,listType:=0,fastMode:=0)
{
    global
    ; 获取与此文件扩展名关联的高质量小图标:
    
    if(filePath="web")
    {
        iconPath:=defaultBrowser
        filePathIconKey:="__web__"
        iconN:=iconsArray0.__web__
    }
    else if(RegExMatch(filePath, "^ftp://")) ;如果是ftp路径的话
        iconN:=ftpIcon
    else
    {
        ;  msgbox, % filePath
        filePath:=extractSetStr(filePath) ;从可能有参数的路径字符串中提取出真实路径 v2.5.3.8
        iconPath:=filePath
        ;  msgbox, % filePath
        ;  if(lnk2exe && RegExMatch(filePath, "i)\.lnk$"))  ;如果是lnk文件，取出lnk连接到的实体文件的地址，用来取那个文件的图标，不然直接取lnk文件的图标会带个很丑的快捷方式标志
        ;  {
        ;      FileGetShortcut, %filePath%, iconPath
        ;  }
        filePathIconKey := pickIconsArrayKey(filePath)
        if(filePathIconKey)
            iconN := iconsArray%listType%[filePathIconKey]
        else
            iconN := ""
        
    }
    

    if iconN is number
        return iconN
    else if fastMode = 1
        return 1 ;9999999

    if not DllCall("Shell32\SHGetFileInfo" . (A_IsUnicode ? "W":"A"), "str", iconPath, "uint", 0, "ptr", &sfi, "uint", sfi_size, "uint", 0x101)  ; 0x101 为 SHGFI_ICON+SHGFI_SMALLICON
        IconNumber := 1 ;9999999  ; 把它设置到范围外来显示空图标.
    else ; 成功加载图标.
    {
        ; 从结构中提取 hIcon 成员:
        hIcon := NumGet(sfi, 0)

        ; 下面加上 1 来把返回的索引从基于零转换到基于一:
        IconNumber := DllCall("ImageList_ReplaceIcon", "ptr", ImageList%listType%, "int", -1, "ptr", hIcon) + 1
        ; 现在已经把它复制到图像列表, 所以应销毁原来的:
        DllCall("DestroyIcon", "ptr", hIcon)
        ; 缓存图标来节省内存并提升加载性能:
        
        ;判断filePath类型，exe,lnk的用全名，其他后缀只用后缀，web用"__web__"，文件夹用"__folder__"
        iconsArray%listType%[filePathIconKey] := IconNumber
        ;  msgbox, % filePath . "`n" . pickIconsArrayKey(filePath) . "`n" . iconNumber
    }
    iconsArray%listType%.Count+=1

    return IconNumber
}

clearListTop:
if(listTopCount)    ;取消置顶list
{
    LV_Modify(0, "Col3", 0)
    listTopCount:=0
}
return

doWhenChanged:
;---label:doWhenChanged---start
{
    if(doNothingWhenChanged)
        return
        
    gosub, clearListTop ;清除置顶
        
    preEditString:=nowEditString ;保留上一次数据，和这次作对比
    ControlGetText, nowEditString, , ahk_id %editHwnd%

    if !(nowEditString) ;if edit is empty
    {
        ;--hide ListView
        GuiControl, Hide, LV_Show
        guiH:=editH+listX*2
        Gui, Show, h%guiH%, ahk_id %GuiHwnd%
        
        w:=fixDpi(guiW)
        h:=fixDpi(guiH)
        r:=fixDpi(guiRadius)
        
        WinSet, Region, 0-0 w%w% h%h% R%r%-%r%, ahk_id%GuiHwnd% ;--cjk1
        ControlFocus, , ahk_id %editHwnd%
        
        listType0Init()
        return
    }
    
    ;如果两次输入的字符串一样(覆盖粘贴了一下)
    if(preEditString=nowEditString)
        return
    ;  msgbox, 3
    ;  nowEditString := RegExReplace(nowEditString, "/.?$") ;ignore mode char, like "/q"(quick mode)
    

    GuiControl, -Redraw, LV_Show ;关闭重绘，避免其每次增删行数都绘制，影响效率
    
    ;如果字符串在上一次的基础上增加了字符
    if(InStr(nowEditString,preEditString)) ;if preEditString in nowEditString(chars increase)
        relation := 1
    else if(InStr(preEditString,nowEditString)) ;(chars reduce)字符串在上次的基础上减少
        relation := 2
    else
        relation := 3   ;字符串完全变了，两次之间没有关系
        
    ;  msgbox, % "#" . nowEditString . "#"
    ;RegExMatch(nowEditString,"i)^[a-z]:\\([^.]*\\)?$") && (LVlistsType == 1 || (LVlistsType == 0 && CLSets.QRun[nowEditString] == "" && CLSets.QWeb[nowEditString] == ""))
    ;如果两种设置都不是，而且是文件夹路径，切换成 list1
    if(CLSets.QRun[nowEditString].setValue == "" && CLSets.QWeb[nowEditString].setValue == "" && InStr(FileExist(nowEditString),"D"))
    {
        ; 以'\'结尾，而又不是因为字符减少而导致的
        if(RegExMatch(nowEditString,"\\$") && relation != 2)
        {
            listType1Init(nowEditString)
            ;  gosub, setLVIcon
            
        }
        else
        {
            ; 获取文件夹路径
            ;eg:
            ;e:\        => e:\
            ;e:\abc     => e:\
            ;e:\abc\def => e:\abc\
            ; 如果现在的文件夹和上一次的文件夹不一致，遍历现在的文件夹
            RegExMatch(preEditString,"i)^[a-z]:\\(.*\\)?",preFolderPath)
            RegExMatch(nowEditString,"i)^[a-z]:\\(.*\\)?",nowFolderPath)
            

            if(nowFolderPath!="" && (preFolderPath != nowFolderPath || LVlistsType = 0))
            {
                relation := 1
                
                listType1Init(nowEditString)
            }
        }
    }
    else if(listsType == 1 && checkStrType(nowEditString,1) != "fileOrFolder")
    {
        listType0Init()
    }

    
        
    if(LVlistsType == 0)
        matchStr := nowEditString
    else
        RegExMatch(nowEditString,"i)(?<=\\)[^\\]*$", matchStr)


    ;将匹配字符串转换成支持 glob 搜索的正则
    globMatchStr:=easyGlobToRegEx(matchStr)
    
    ;只取第一个空格之前的字符串当做匹配命令
    matchStrLeft:=RegExReplace(matchStr,"\s.*$")
    
    
    
    ;如果字符增加了或者完全改变了（完全改变的话就算作增加和减少同时成立，两部分的操作都做一遍）
    if(relation == 1 || relation == 3)
    {
        if % LV_GetCount()
        {
            pickingNum:=1
            
            
            loop, % LV_GetCount()
            {
                LV_GetText(LVText_i, pickingNum, 2)
                
                ;如果LV_show的文件包含现在输入栏的字符,放过它
                ;或者第一个空格左边的字符串等于
                shortKey:=getShortSetKey(LVText_i)
                if(RegExMatch(LVText_i,globMatchStr)||shortKey=matchStrLeft)
                {
                    ;如果左边命令全匹配，那就认定匹配字符串就是他，即使后面再输入文件也不改变结果
                    if(shortKey=matchStrLeft)
                        matchStr:=matchStrLeft
                        
                    if(shortKey=matchStr)  ;如果是全等的话，那把该行放在第一位 v2.5.4
                    {
                        LV_Modify(pickingNum, "Col3", 1)
                        listTopCount++
                    }
                    pickingNum++
                    continue
                }
                else        ;不然的话删掉，放到LV_hide里
                {
                    listHide%LVlistsType%.Insert(LVText_i)
                    LV_Delete(pickingNum)
                }
            }
            
            ;~ if % LV_GetCount()==1
            ;~ {
                ;~ LV_GetText(firstListText, 1)
                ;~ if(firstListText==matchStr) ;如果list中仅有一条匹配的，而且是全名匹配，那就隐藏掉list
                ;~ {
                    ;~ Gui, ListView, LV_hide ;目标切换到LV_hide
                    ;~ LV_Add("", firstListText)
                    ;~ Gui, ListView, LV_show ;切换回来LV_show
                    ;~ LV_Delete(1)
                ;~ }
            ;~ }
        }
        ;  else ;如果本来LV_show就没匹配的文件名，字符增加更不可能有匹配的，那就直接return
        ;  {
        ;      GuiControl, +Redraw, LV_Show ;重新打开重绘
        ;      return
        ;  }
    }
    
    ;如果正在浏览文件路径，获取当前有效的文件夹路径
    if(LVlistsType == 1)
    {
        RegExMatch(nowEditString,"i)^[a-z]:\\(.*\\)?",folderPath)
    }
    if(relation == 2 || relation == 3)  ;字符串减少或者完全变了
    {
        gosub, clearListTop ;清除置顶
        
        listMaxIndex := listHide%LVlistsType%.MaxIndex()
        
        
        loop, % listMaxIndex
        {
            i := listMaxIndex-A_Index+1
            value := listHide%LVlistsType%[i]
            ;  IfInString, value, %matchStr%
            shortKey:=getShortSetKey(value)
            if(RegExMatch(value,globMatchStr)||shortKey=matchStrLeft)
            {
                
                if(LVlistsType == 0)
                {
                    ;如果左边命令全匹配，那就认定匹配字符串就是他，即使后面再输入文件也不改变结果
                    if(shortKey=matchStrLeft)
                        matchStr:=matchStrLeft
                    
                    _t:=CLSets.QSearch[shortKey]
                    
                    ifListTop:=0
                    if(shortKey=matchStr)  ;如果是全等的话，那把该行放在第一位 v2.5.4
                    {
                        ifListTop:=1
                        listTopCount++
                    }
                    if(_t.setValue)  ;v2.5.4 modified
                    {
                        LV_Add("icon" . _t.iconIndex, -1,value, ifListTop)
                        listHide0.Remove(i)
                        continue
                    }

                    _t:=CLSets.QRun[shortKey]
                    if(_t.setValue)  ;v2.5.4 modified
                    {
                        path := extractSetStr(_t.setValue)
                        listType := isFolder(path)?0:1
                        LV_Add("icon" . _t.iconIndex, listType,value, ifListTop)
                        listHide0.Remove(i)
                        continue
                    }

                    _t:=CLSets.QWeb[shortKey]
                    if(_t.setValue) ;v2.5.4 modified
                    {
                        ;  iconsStr := CLSets.QWeb[value]
                        ;  listType := 2
                        LV_Add("icon" . _t.iconIndex, 2,value, ifListTop)
                        listHide0.Remove(i)
                        continue
                    }

                    LV_Add("Icon" . starMenuObj[value].iconIndex, 3, value, ifListTop) ;v2.5.4 appended
                    listHide0.Remove(i)
                    continue
                }
                else
                {
                    iconsStr := folderPath . value
                    listType := isFolder(iconsStr)?0:1
                    LV_Add("icon" . iconsArray1[pickIconsArrayKey(iconsStr)], listType,value, 0)
                    listHide1.Remove(i)
                }
                ;  msgbox, % iconsStr
                ;  LV_Add("icon" . iconsArray%LVlistsType%[pickIconsArrayKey(iconsStr)], listType,value)
                ;  listHide%LVlistsType%.Remove(i)
            }
        }
    }
    gosub, change_edit_width

    GuiControl, +Redraw , LV_Show ;重新打开重绘（并重绘）
    
    goto, show_or_hide
    
return
}

;Qrun记录列表加载
;将隐藏列表的项都移回显示列表中
listType0Init()
{
    global
    ;reset listview
    ;if listsType is 1(loop folder), clear listview at first
    if(LVlistsType == 1)
    {
        LV_Delete()
        listHide1 := {}

        LV_SetImageList(ImageList0, 1) ; 关联图像列表0到 ListView
        LVlistsType := 0
    }
    listMaxIndex := listHide0.MaxIndex()
    loop, % listMaxIndex
    {
        i := listMaxIndex-A_Index+1
        _value := listHide0[i]

        _t:=CLSets.QSearch[getShortSetKey(_value)]
        if(_t.setValue) ;如果这是QSearch的项目的话
        {
            LV_Add("icon" . _t.iconIndex, -1,_value, 0)
            listHide0.Remove(i)
            continue
        }
        
        _t:=CLSets.QRun[getShortSetKey(_value)]
        if(_t.setValue) ;如果这是QRun的项目的话
        {
            _pathString := extractSetStr(_t.setValue, 0)
            LV_Add("icon" . _t.iconIndex, isFolder(_pathString)?0:1,_value, 0)
            listHide0.Remove(i)
            continue
        }

        _t:=CLSets.QWeb[getShortSetKey(_value)]
        if(_t.setValue) ;如果是QWeb的项目
        {
            LV_Add("icon" . _t.iconIndex, 2,_value, 0)
            listHide0.Remove(i)
            continue
        }
        
        ;不然就是starMenu的项目了
        LV_Add("Icon" . starMenuObj[_value].iconIndex, 3, _value, 0)
        listHide0.Remove(i)
        continue

        ;下面两行被上面3个 if/else 取代，暂时保留，过一段时间没问题就删掉
        ;  _pathString := CLSets.QRun[_value]?CLSets.QRun[_value]:CLSets.QWeb[_value]
        ;  LV_Add("icon" . iconsArray0[pickIconsArrayKey(_pathString)], CLSets.QRun[_value]?(isFolder(_pathString)?0:1):2,_value)
    }

    gosub, change_edit_width

    return
}

; 路径要以 "\"结尾, eg: e:\123\              e:\123\234\
getFolderObj(path, ByRef _count) ;
{
    _obj:={}
    _count := 0
    loop, % path . "*", 1
    {
        IfInString, A_LoopFileAttrib, H
            continue
        _obj.Insert(A_LoopFileName)
        _count++
    }
    return _obj
}

loopFolderTimeLimit:
_quickType := 1
;  msgbox, opps
return

;文件路径列表加载
listType1Init(folderPath)
{
    global

    ;记录文件路径浏览历史
    ;只有使用回退和前进功能才不记录，因为那就是在"历史之中"，历史不再前进
    ;  if(ifInsertHistory)
    ;  {
    ;      qbarPathHistory.insert(folderPath)
    ;      historyIndex:=qbarPathHistory.MaxIndex()
    ;      historyNow:=0
    ;  }
    ;  else
    ;      ifInsertHistory:=1
    if(ifClearFuture)
        qbarPathFuture:=[]
    else
        ifClearFuture:=1

    if(LVlistsType == 0)
    {
        loop, % LV_GetCount()
        {
            LV_GetText(LVText_i, 1, 2)
            listHide0.Insert(LVText_i)
            LV_Delete(1)
        }
        ;  GuiControl, +r10, ahk_id %LV_show_Hwnd%
        LV_SetImageList(ImageList1, 1) ; relate image list 1 to ListView
        LVlistsType := 1
    }
    else
    {
        LV_Delete()
        listHide1 := {}
    }
    ;  Gui, ListView, LV_show ;目标切换到LV_show
    
    
    if(_quickType)
    {
        ControlSetText, , %folderPath%, ahk_id %editHwnd%
        sendinput, {end}
    }
        
    
    RegExMatch(folderPath,"i)^[a-z]:\\(.*\\)?",folderPath)
    
    folderObj := getFolderObj(folderPath, loopFilesCount) ;

    
    GuiControl, +Count%loopFilesCount%, %LV_show_Hwnd%
        ; 如果查找icon的动作超过1.5s，不再查找，直接返回已经查找到的icon
        SetTimer, loopFolderTimeLimit, -1500, 10
        for key,value in folderObj
        {
            ;  if(_quickType)
            ;  {
                
            ;      LV_Add("Icon999999", value)
            ;  }
            ;  else
            ;  {
            _filePath := folderPath . value
            _iconNum := listViewIconGet(_filePath, 1, _quickType)
            LV_Add("Icon" . _iconNum, isFolder(_filePath)?0:1, value, 0)
            ;  }
            progressUpdate(key,loopFilesCount)
        }
        if(loopFilesCount = 0) ;if is a empty folder
        {
            LV_Add("Icon999999", 0, lang_clq_emptyFolder)
        }
        SetTimer, loopFolderTimeLimit, Off
    ;  }
    gosub, change_edit_width
    return
}




;  setLVIcon:
;  ControlGetText, editText, , ahk_id %editHwnd%
;  loop, % LV_GetCount()
;  {
;      LV_GetText(_text,A_Index,2)
;      filePath := editText . _text
;      iconN := listViewIconGet(filePath, 1)
;      LV_Modify(A_Index, "Icon" . iconN)
;  }
;  return

change_edit_width: ;list条数5个之内拖动条会隐藏，为了好看，把高亮的条向右伸长，以求对称
{
    Gui, ListView, LV_show ;目标切换到LV_show
    ;~ MsgBox, imhere
    if % LV_GetCount()<=listCount ;list条数5个之内拖动条会隐藏，为了好看，把高亮的条向右伸长，以求对称
    {
        LV_ModifyCol(2, 324) ;设置listview为1列，高亮时宽度326px
        ;  LV_ModifyCol(1, 344) ;设置listview为1列，高亮时宽度326px
        LV_ModifyCol(1, 20) ;设置listview为1列，高亮时宽度326px
        LV_ModifyCol(2, "Sort") ;sort by name first

        LV_ModifyCol(1, "Sort") ;sort by type finally

        LV_ModifyCol(3, "SortDesc")
    }
    else
    {
        ;  LV_ModifyCol(1, 326) ;设置listview为1列，高亮时宽度326px
        LV_ModifyCol(2, 306) ;设置listview为1列，高亮时宽度326px
        LV_ModifyCol(1, 20) ;设置listview为1列，高亮时宽度326px
        LV_ModifyCol(2, "Sort") ;sort by name first
        LV_ModifyCol(1, "Sort") ;sort by type finally
        
        LV_ModifyCol(3, "SortDesc")
        
    }
    return
}

show_or_hide:
{
    Gui, ListView, LV_show ;目标切换到LV_show
    if % LV_GetCount()  ;当LV_show里有数据（即有匹配的文件）
    {
        GuiControl, Show, LV_Show
        guiH:=editH+listH+listX*2
        LV_Modify(1, "Focus")
        LV_Modify(1, "Select")
    }
    else  ;当LV_show里没有数据（也就是没有匹配的文件）
    { 
        GuiControl, Hide, LV_Show
        guiH:=editH+listX*2 
    }
    
    w:=fixDpi(guiW)
    h:=fixDpi(guiH)
    r:=fixDpi(guiRadius)
    
    WinSet, Region, 0-0 w%w% h%h% R%r%-%r%, ahk_id %GuiHwnd%  ;;--cjk1
    WinMove, ahk_id %GuiHwnd%, , , , , %h%   ;--cjk1
    return
}


MoveWin() ;拖动窗口
{
    PostMessage, 0xA1, 2
    return
}
MoveCaret: ;edit光标到开头
{
    IfWinNotActive, Qbar 
        return
    ; 否则移动 InputBox 中的光标到开头位置.
    SendInput {Home} ;{Space}{Left}
    SetTimer, MoveCaret, Off
    return
}

QGuiClose:
QGuiEscape:
    listHide1:={}
    Gui, Cancel
return

appendSet(sec,key,val)
{
    global
    StringReplace, t, lang_clq_addIni, {replace0}, %key%
    StringReplace, t, t, {replace1}, %sec%
    
    MsgBox, 0x40001, ,%t%`n`n%val%
    IfMsgBox, OK
    {
        temp:=CLSets[sec][key].setValue
        if(temp)
        {
            StringReplace, t, lang_clq_existing, {replace0}, %key%=%temp%
            StringReplace, t, t, {replace1}, %sec%
            MsgBox, 0x40001, ,%t%`n`n%key%=%val%
            IfMsgBox, Cancel
                return
        }
        if(sec=="TabHotString")
        {
            StringReplace, val, val, \n, \`n, All ;替换换行符
            StringReplace, val, val, `n, \n, All ;有转义符的换回来
        }
        IniWrite, % val, CapsLock+settings.ini, %sec%, % key
        MsgBox, , , done, 0.5
    }
    return
}

;用_exe程序运行_paramStr，如果ifAdmin==true，则用管理员权限运行
;返回true表示操作成功，否则操作失败，程序继续作后续判定
qrunBy(_exe, _paramStr:="", ifAdmin:=false)
{
    global
    
    for key,value in CLSets["QRun"]
    {
        
        if(_exe=getShortSetKey(key))
        {
            ;如果有运行参数（文件网站什么的）
            ;将命令的后半段替换成set.ini里对应的值
            if(_paramStr)
            {
                for key2,value2 in CLSets["QRun"]
                {
                    if(_paramStr=getShortSetKey(key2))
                        _paramStr:=value2.setValue
                }
                for key2,value2 in CLSets["QWeb"]
                {
                    if(_paramStr=getShortSetKey(key2))
                        _paramStr:=value2.setValue
                }
            }
            
            t:=set2Run(value.setValue)
            if(t)
            {
                ;如果是管理员权限运行，而设置中没有设置管理员权限运行，则加上
                if(ifAdmin && !RegExMatch(t, "i)^\*RunAs\s"))
                    t:="*RunAs " . t
                if(_paramStr)
                    t:=t . " " . _paramStr
                run, % t
            }
            else
            {
                t:=value.setValue
                MsgBox, 0x40001, ,%lang_clq_qrunFileNotExist%`n%key%=%t%
                IfMsgBox, OK
                {
                    IniDelete, CapsLock+settings.ini, QRun , %key%
                }
            }
            return true
        }
    }


    return false
}

ButtonSubmit:
;---ButtonSubmit---start
{
    ctrlDn:=GetKeyState("ctrl","P")

    ControlGet, isLVShowIsVisibleWhenSubmit, Visible, , , ahk_id %LV_show_Hwnd%

    Gui, Submit

    uselessStr:=""
    inputStr:=trim(inputStr) ;移除首尾空白符
    
    if(ctrlDn)
    {
        run, % "www." . inputStr . ".com"
        return
    }
    
    StringSplit, cmd, inputStr, %A_Tab%%A_Space%
    
    if(cmd0>=3) ;command section >= 3
    {
        strCmd1_2:=cmd1 . " " . cmd2 . " "

        StringReplace, paramStr, inputStr, %strCmd1_2%
        paramStr:=trim(paramStr)
        
        IfExist, CapsLock+settings.ini
        {
            if (RegExMatch(cmd2, "->(.*)", match)) 
            {
                ;if cmd2 is "->", else cmd2 is "->run", "->web", "->str"

                if(!match1)
                {
                    if(RegExMatch(paramStr,"(http:|www|\.com|\.net|\.org).*{q}"))
                        strType := "qsearch"
                    else
                        strType := checkStrType(paramStr)
                }
                else
                    strType := match1

                if(strType = "run" || strType = "qrun" || strType = "path" || strType = "file" || strType = "folder" || strType = "ftp")
                {
                    appendSet("QRun",cmd1,paramStr)
                    return
                }
                if(strType = "web" || strType = "qweb")
                {
                    appendSet("QWeb",cmd1,paramStr)
                    return
                }
                if(strType = "search" || strType = "qsearch")
                {
                    appendSet("QSearch",cmd1,paramStr)
                    return
                }
                ;!match1:什么run和web都不中，又没指定存储到什么段，那就存到hotstring
                if(!match1 || strType = "str" || strType = "string" || strType = "hotstring" || strType = "tabhotstring")
                {
                    appendSet("TabHotString",cmd1,paramStr)
                    return
                }
            }
            
            ;如果是带有管理员运行标志的程序运行命令
            if(RegExMatch(cmd1,"i)^\*RunAs$"))
            {
                if(qrunBy(cmd2, paramStr, true))
                    return
            }
        } 
    }
    if(cmd0>=2) ;超过两截的文字
    {
        ; --LEVEL 1 START--cl command--
        StringReplace, paramStr, inputStr, % cmd1 . " " ;从inputStr中删掉cmd1(后面还有个空格)
        if(cmd1=">cdo")
        {
            ;  if(RegExMatch(paramStr,"i)^do\s(.*)",_match))
            if(IsLabel(paramStr))
            {
                goto, %paramStr%
                return
            }
            RegExMatch(paramStr,"^(\w+)\((.*)\)",func)
            
            if(IsFunc(func1))
            {
                msgbox, % %func1%(func2)
                return
            }
        }
        if (cmd1="cl")
        {
            if(paramStr="version"||paramStr="about")
            {
                MsgBox, 0x40000, ,%CLversion%
                return
            }

            if(paramStr="set"||paramStr="settings")
            { 
                IfExist, CapsLock+settingsDemo.ini
                    Run, CapsLock+settingsDemo.ini
                
                IfExist, CapsLock+settings.ini
                    Run, CapsLock+settings.ini
                
                return
            }
            if(paramStr="pay")
            {
                Run, http://cjkis.me/payment/
                return
            }
            if(paramStr="donate"||paramStr="contribute")
            {
                Run, http://cjkis.me/donate/
                return
            }
            MsgBox, %lang_clq_noCmd%
            return
        }
        
        if(cmd1="web")
        {
            if(!RegExMatch(paramStr, "i)^http"))
                value:="http://" . paramStr
            run % value
            return
        }
        ; --LEVEL 1 END--cl command--
        
        ; --LEVEL 2 START--
        ;-------------------------------CapsLock+settings.ini--------------
        for key, value in CLSets["QSearch"]
        {
            if((cmd1==key)&&(cmd1!="default")) ;default是用在没有cmd1时用的，排除掉
            {
                paramStr:=URLencode(paramStr)
                value2:=value.setValue
                ;  if(!RegExMatch(value2, "i)^http"))
                ;      value2:="http://" . value2
                
                StringReplace, strRun, value2, {q}, % paramStr
                ;  strRun:="""" . defaultBrowser . """ " . strRun
                
                run % strRun
                
                return
            }
        }

        if(qrunBy(cmd1, paramStr))
            return
        ; --LEVEL 2 END--
        
        ; --FINALLY--
        if (cmd1="s")
        {
            paramStr:=UTF8encode(paramStr)
            if(isLangChinaChinese())
            {
                run https://www.baidu.com/s?wd=%paramStr%
            }
            else
            {
                run https://www.google.com/search?q=%paramStr%
            }
            return
        }
        if (cmd1="bd")
        {
            paramStr:=UTF8encode(paramStr)
            run https://www.baidu.com/s?wd=%paramStr%
            return
        }
        if (cmd1="g"||cmd1="gg") ;google
        {
            paramStr:=UTF8encode(paramStr)
            run https://www.google.com/search?q=%paramStr%
            return
        }
        if (cmd1="tb") ;淘宝
        {
            paramStr:=UTF8encode(paramStr)
            run http://s.taobao.com/search?q=%paramStr%
            return 
        }
        if (cmd1="wk") ;维基百科
        {
            paramStr:=UTF8encode(paramStr)
            run https://zh.wikipedia.org/w/index.php?search=%paramStr%
            return 
        }
        if (cmd1="m"||cmd1="mdn") ;MDN搜索
        {
            paramStr:=UTF8encode(paramStr)
            run https://developer.mozilla.org/zh-CN/search?q=%paramStr%
            return 
        }
    }

    ; 如果当前下拉列表有选中项的话，运行
    Gui, ListView, LV_show ;目标切换到LV_show
    if(isLVShowIsVisibleWhenSubmit && LV_GetCount())  ;当LV_show在回车时是显示状态，并且有数据（即有匹配的文件）
    {
        ; gosub, tabAction
        ; ControlGetText, editText, , ahk_id %editHwnd%
        ControlGet, listSelected, List, Selected Col2, , ahk_id %LV_show_Hwnd%
        listSelected:=getShortSetKey(listSelected)
        ; 如果是文件路径，拼接上输入框的和选中的
        if(LVlistsType == 1)
        {
            ControlGetText, editText, , ahk_id %editHwnd%
            listSelected := RegExReplace(editText, "i)(?<=\\)[^\\]*$", listSelected) 
        }
        inputStr:=listSelected
    }

    if (inputStr) ;如果不是以上的结果，而又非空
    {
        ; --LEVEL 1 START--
        ;QRun
        if(qrunBy(inputStr))
            return
        for key, value in CLSets["QWeb"]
        {
            if(inputStr=key) 
            {
                value2:=value.setValue
                ;  try
                ;      run, % defaultBrowser . " " . value2
                ;  catch e{
                if(!RegExMatch(value2, "i)^http"))
                    value2:="http://" . value2
                run % value2
                ;  }
                return
            }
        }
        
        
        ;运行开始菜单
        for key, value in starMenuObj
        {
            if(inputStr=key)
            {
                try
                {
                    run, % value.lnkPath
                }
                catch
                {
                    run, % value.exePath
                }
                return
            }
        }
        
        
        ; --LEVEL 1 END--

        ; --LEVEL 2 START--
        ;  runStr:=set2Run(inputStr)
        
        ;  if(runStr)
        ;  {
        ;      run, % runStr
        ;      return
        ;  }

        strType := checkStrType(inputStr)
        if(strType == "file" || strType == "folder")
        {
            ifExist, % inputStr
                run, % inputStr
            else
                msgbox, %lang_clq_fileNotExist%
            return
        }
        if(strType = "ftp")
        {
            run, % inputStr
            return
        }
        if(strType == "web")
        { ;网站的话，跳转
            if(SubStr(inputStr,1,4)!="http")
            {
                ;  inputStr:=UTF8encode(inputStr)
                inputStr:="http://" . inputStr
            }
            run %inputStr%
            return
        }
        ; --LEVEL 2 END--

        ; ------------------finally--------------------------------------
        
        ;  inputStr:=URLencode(inputStr)
        inputStr:=UTF8encode(inputStr)
        if(CLSets["QSearch"]["default"].setValue!="")
        {
            strRun:=CLSets["QSearch"]["default"].setValue
            StringReplace, strRun, strRun, {q}, % inputStr
            run % strRun
            return
        }

        if(isLangChinaChinese())
        {
            run https://www.baidu.com/s?wd=%inputStr%
        } else {
            run https://www.google.com/search?q=%inputStr%
        }

        return
    }
return
}


;---ButtonSubmit---end

makeCLQActive:
WinActivate, ahk_id %GuiHwnd%
return