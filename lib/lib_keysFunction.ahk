; keys functions start-------------
; 所有按键对应功能都放在这，为防止从set.ini通过按键设置调用到非按键功能函数，
; 规定函数以"keyFunc_"开头

keyFunc_doNothing(){
    return
}

keyFunc_test(){
    MsgBox, , , testing, 1
    return
}

keyFunc_send(p){
    sendinput, % p
    return
}

keyFunc_run(p){
    run, % p
    return
}

keyFunc_toggleCapsLock(){
    SetCapsLockState, % GetKeyState("CapsLock","T") ? "Off" : "On"
    return
}

keyFunc_mouseSpeedIncrease(){
    global
    mouseSpeed+=1
    if(mouseSpeed>20)
    {
        mouseSpeed:=20
    }
    showMsg("mouse speed: " . mouseSpeed, 1000)
    setSettings("Global","mouseSpeed",mouseSpeed)
    return
}


keyFunc_mouseSpeedDecrease(){
    global
    mouseSpeed-=1
    if(mouseSpeed<1)
    {
        mouseSpeed:=1
    }
    showMsg("mouse speed: " . mouseSpeed, 1000)
    setSettings("Global","mouseSpeed",mouseSpeed)
    return
}


keyFunc_moveLeft(i:=1){
    SendInput, {left %i%}
    return
}


keyFunc_moveRight(i:=1){
    SendInput, {right %i%}
    Return
}


keyFunc_moveUp(i:=1){
    global
    if(WinActive("ahk_id" . GuiHwnd))
    {
        ControlFocus, , ahk_id %LV_show_Hwnd%
        SendInput, {Up %i%}
        Sleep, 5
        ControlFocus, , ahk_id %editHwnd%
    }
    else
        SendInput,{up %i%}
    Return
}


keyFunc_moveDown(i:=1){
    global
    if(WinActive("ahk_id" . GuiHwnd))
    {
        ControlFocus, , ahk_id %LV_show_Hwnd%
        SendInput, {Down %i%}
        Sleep, 5
        ControlFocus, , ahk_id %editHwnd%
    }
    else
        SendInput,{down %i%}
    Return
}


keyFunc_moveWordLeft(i:=1){
    SendInput,^{Left %i%}
    Return
}


keyFunc_moveWordRight(i:=1){
    SendInput,^{Right %i%}
    Return
}


keyFunc_backspace(){
    SendInput,{backspace}
    Return
}


keyFunc_delete(){
    SendInput,{delete}
    Return
}

keyFunc_deleteAll(){
    SendInput, ^{a}{delete}
    Return
}

keyFunc_deleteWord(){
    SendInput, +^{left}
    SendInput, {delete}
    Return
}


keyFunc_forwardDeleteWord(){
    SendInput, +^{right}
    SendInput, {delete}
    Return
}


keyFunc_translate(){
    global
    selText:=getSelText()
    if(selText)
    {
        ydTranslate(selText)
    }
    else
    {
        ClipboardOld:=ClipboardAll
        Clipboard:=""
        SendInput, ^{Left}^+{Right}^{insert}
        ClipWait, 0.05
        selText:=Clipboard
        ydTranslate(selText)
        Clipboard:=ClipboardOld
    }
    SetTimer, setTransGuiActive, -400
    Return
}


keyFunc_end(){
    SendInput,{End}
    Return
}


keyFunc_home(){
    SendInput,{Home}
    Return
}


keyFunc_moveToPageBeginning(){
    SendInput, ^{Home}
    Return
}


keyFunc_moveToPageEnd(){
    SendInput, ^{End}
    Return
}

keyFunc_deleteLine(){
    SendInput,{End}+{home}{bs}
    Return
}

keyFunc_deleteToLineBeginning(){
    SendInput,+{Home}{bs}
    Return
}

keyFunc_deleteToLineEnd(){
    SendInput,+{End}{bs}
    Return
}

keyFunc_deleteToPageBeginning(){
    SendInput,+^{Home}{bs}
    Return
}

keyFunc_deleteToPageEnd(){
    SendInput,+^{End}{bs}
    Return
}

keyFunc_enterWherever(){
    SendInput,{End}{Enter}
    Return
}

keyFunc_esc(){
    SendInput, {Esc}
    Return
}

keyFunc_enter(){
    SendInput, {Enter}
    Return
}

;双字符
keyFunc_doubleChar(char1,char2:=""){
    if(char2=="")
    {
        char2:=char1
    }
    charLen:=StrLen(char2)
    selText:=getSelText()
    ClipboardOld:=ClipboardAll
    if(selText)
    {
        Clipboard:=char1 . selText . char2
        SendInput, +{insert}
    }
    else
    {
        Clipboard:=char1 . char2
        SendInput, +{insert}
        ; prevent the left input from interrupting the paste (may occur in vscode)
        ; fact: tests show that 50ms is not enough
        Sleep, 75
        SendInput, {left %charLen%}
    }
    Sleep, 100
    Clipboard:=ClipboardOld
    Return
}

keyFunc_sendChar(char){
    ClipboardOld:=ClipboardAll
    Clipboard:=char
    SendInput, +{insert}
    Sleep, 50
    Clipboard:=ClipboardOld
    return
}

keyFunc_doubleAngle(){
    if(!keyFunc_qbar_upperFolderPath())
        keyFunc_doubleChar("<",">")
    return
}

keyFunc_pageUp(){
    global
    if(WinActive("ahk_id" . GuiHwnd))
    {
        ControlFocus, , ahk_id %LV_show_Hwnd%
        SendInput, {PgUp}
        ControlFocus, , ahk_id %editHwnd%
    }
    else
        SendInput, {PgUp}
    return
}


keyFunc_pageDown(){
    global
    if(WinActive("ahk_id" . GuiHwnd))
    {
        ControlFocus, , ahk_id %LV_show_Hwnd%
        SendInput, {PgDn}
        ControlFocus, , ahk_id %editHwnd%
    }
    else
        SendInput, {PgDn}
    Return
}

;页面向上移动一页，光标不动
keyFunc_pageMoveUp(){
    SendInput, ^{PgUp}
    return
}

;页面向下移动一页，光标不动
keyFunc_pageMoveDown(){
    SendInput, ^{PgDn}
    return
}

keyFunc_switchClipboard(){
    global
    if(CLsets.global.allowClipboard)
    {
        CLsets.global.allowClipboard:="0"
        setSettings("Global","allowClipboard","0")
        showMsg("Clipboard OFF",1500)
    }
    else
    {
        CLsets.global.allowClipboard:="1"
        setSettings("Global","allowClipboard","1")
        showMsg("Clipboard ON",1500)
    }
    return
}


keyFunc_pasteSystem(){
    global

    ; ;
    ; 禁止 OnClipboardChange 运行，防止 Clipboard:=sClipboardAll 重复执行，导致偶尔会粘贴出空白
    ;  if(!CLsets.global.allowClipboard)  ;禁用剪贴板功能
    ;  {
    ;      CapsLock2:=""
    ;      return
    ;  }
    if (whichClipboardNow!=0)
    {
        allowRunOnClipboardChange:=false
        Clipboard:=sClipboardAll
        whichClipboardNow:=0
    }
    SendInput, ^{v}
    return
}


keyFunc_cut_1(){
    global
    if(CLsets.global.allowClipboard="0")  ;禁用剪贴板功能
    {
        CapsLock2:=""
        return
    }

    ClipboardOld:=ClipboardAll
    Clipboard:=""
    SendInput, ^{x}
    ClipWait, 0.1
    if (ErrorLevel)
    {
        SendInput,{home}+{End}^{x}
        ClipWait, 0.1
    }
    if (!ErrorLevel)
    {
        ;cClipboardAll:=ClipboardAll
        clipSaver("c")
        whichClipboardNow:=1
    }
    else
    {
        Clipboard:=ClipboardOld
    }
    Return
}


keyFunc_copy_1(){
    global
    if(CLsets.global.allowClipboard="0")  ;禁用剪贴板功能
    {
        CapsLock2:=""
        return
    }

    ClipboardOld:=ClipboardAll
    Clipboard:=""
    SendInput, ^{insert}
    ClipWait, 0.1
    if (ErrorLevel)
    {
        SendInput,{home}+{End}^{insert}{End}
        ClipWait, 0.1
    }
    if (!ErrorLevel)
    {
        ;  cClipboardAll:=ClipboardAll
        clipSaver("c")
        whichClipboardNow:=1
    }
    else
    {
        Clipboard:=ClipboardOld
    }
    return
}


keyFunc_paste_1(){
    global
    if(CLsets.global.allowClipboard="0")  ;禁用剪贴板功能
    {
        CapsLock2:=""
        return
    }

    if (whichClipboardNow!=1)
    {
        Clipboard:=cClipboardAll
        whichClipboardNow:=1
    }
    SendInput, ^{v}
    Return
}


keyFunc_undoRedo(){
    global
    if(ctrlZ)
    {
        SendInput, ^{z}
        ctrlZ:=""
    }
    Else
    {
        SendInput, ^{y}
        ctrlZ:=1
    }
    Return
}


keyFunc_cut_2(){
    global
    if(CLsets.global.allowClipboard="0")  ;禁用剪贴板功能
    {
        CapsLock2:=""
        return
    }

    ClipboardOld:=ClipboardAll
    Clipboard:=""
    SendInput, ^{x}
    ClipWait, 0.1
    if (ErrorLevel)
    {
        SendInput,{home}+{End}^{x}
        ClipWait, 0.1
    }
    if (!ErrorLevel)
    {
        ;  caClipboardAll:=ClipboardAll
        clipSaver("ca")
        whichClipboardNow:=2
    }
    else
    {
        Clipboard:=ClipboardOld
    }
    Return
}


keyFunc_copy_2(){
    global
    if(CLsets.global.allowClipboard="0")  ;禁用剪贴板功能
    {
        CapsLock2:=""
        return
    }

    ClipboardOld:=ClipboardAll
    Clipboard:=""
    SendInput, ^{insert}
    ClipWait, 0.1
    if (ErrorLevel)
    {
        SendInput,{home}+{End}^{insert}{End}
        ClipWait, 0.1
    }
    if (!ErrorLevel)
    {
        ;  caClipboardAll:=ClipboardAll
        clipSaver("ca")
        whichClipboardNow:=2
    }
    else
    {
        Clipboard:=ClipboardOld
    }
    return
}


keyFunc_paste_2(){
    global
    if(CLsets.global.allowClipboard="0")  ;禁用剪贴板功能
    {
        CapsLock2:=""
        return
    }

    if (whichClipboardNow!=2)
    {
        Clipboard:=caClipboardAll
        whichClipboardNow:=2
    }
    SendInput, ^{v}
    Return
}


keyFunc_qbar(){
    global
    SetTimer, setCLqActive, 50
    ;先关闭所有Caps热键，然后再打开
    ;防止其他功能在 qbar 出来这段时间因为输入文字而被触发
    CapsLock:=CapsLock2:=""
    CLq()
    CapsLock:=1
    return

    setCLqActive:
    IfWinExist, ahk_id %GuiHwnd%
    {
        SetTimer, ,Off
        WinActivate, ahk_id %GuiHwnd%
    }
    return
}


keyFunc_tabPrve(){
    SendInput, ^+{tab}
    return
}


keyFunc_tabNext(){
    SendInput, ^{tab}
    return
}


keyFunc_jumpPageTop(){
    SendInput, ^{Home}
    return
}


keyFunc_jumpPageBottom(){
    SendInput, ^{End}
    return
}


keyFunc_selectUp(i:=1){
    SendInput, +{Up %i%}
    return
}


keyFunc_selectDown(i:=1){
    SendInput, +{Down %i%}
    return
}


keyFunc_selectLeft(i:=1){
    SendInput, +{Left %i%}
    return
}


keyFunc_selectRight(i:=1){
    SendInput, +{Right %i%}
    return
}


keyFunc_selectHome(){
    SendInput, +{Home}
    return
}


keyFunc_selectEnd(){
    SendInput, +{End}
    return
}

keyFunc_selectToPageBeginning(){
    SendInput, +^{Home}
    return
}


keyFunc_selectToPageEnd(){
    SendInput, +^{End}
    return
}


keyFunc_selectCurrentWord(){
    SendInput, ^{Left}
    SendInput, +^{Right}
    return
}


keyFunc_selectCurrentLine(){
    SendInput, {Home}
    SendInput, +{End}
    return
}


keyFunc_selectWordLeft(i:=1){
    SendInput, +^{Left %i%}
    return
}


keyFunc_selectWordRight(i:=1){
    SendInput, +^{Right %i%}
    return
}

;页面移动一行，光标不动
keyFunc_pageMoveLineUp(i:=1){
    SendInput, ^{Up %i%}
    return
}


keyFunc_pageMoveLineDown(i:=1){
    SendInput, ^{Down %i%}
    return
}



keyFunc_getJSEvalString(){
    global
    ClipboardOld:=ClipboardAll
    Clipboard:=""
    SendInput, ^{insert} ;
    ClipWait, 0.1
    if(!ErrorLevel)
    {
        result:=escapeString(Clipboard)
        inputbox, result,,%lang_kf_getDebugText%,,,,,,,, % result
        if(!ErrorLevel)
        {
            Clipboard:=result

            return
        }
    }
    Sleep, 200
    Clipboard:=ClipboardOld
    return
}


keyFunc_tabScript(){
    tabAction()
    Return
}


keyFunc_openCpasDocs(){
    if(isLangChinese())
    {
        Run, https://capslox.com/capslock-plus
    } else {
        Run, https://capslox.com/capslock-plus/en.html
    }
    return
}


keyFunc_mediaPrev(){
    SendInput, {Media_Prev}
    return
}


keyFunc_mediaNext(){
    SendInput, {Media_Next}
    return
}


keyFunc_mediaPlayPause(){
    SendInput, {Media_Play_Pause}
    return
}


keyFunc_volumeUp(){
    SendInput, {Volume_Up}
    return
}


keyFunc_volumeDown(){
    SendInput, {Volume_Down}
    return
}


keyFunc_volumeMute(){
    SendInput, {Volume_Mute}
    return
}


keyFunc_reload(){
    MsgBox, , , reload, 0.5
    Reload
    return
}

keyFunc_send_dot(){
    if(!keyFunc_qbar_lowerFolderPath())
        SendInput, {U+002e}
    return
}

;qbar中跳到上层文件路径
keyFunc_qbar_upperFolderPath(){
    global
    if(!WinActive("ahk_id" . GuiHwnd))
    {
        return
    }
    if(LVlistsType=0)
    {

        return true
    }
    ControlGetText, editText, , ahk_id %editHwnd%
    ;  if(historyIndex>1)
    ;      historyIndex--

    ;  _t:=qbarPathHistory[historyIndex+1]
    ;  if(_t=editText)
    ;  {
    ;      editText:=qbarPathHistory[historyIndex]
    ;  }
    ;  else
    ;      editText:=_t
    qbarPathFuture.insert(editText)    ;记录路径历史
    editText := RegExReplace(editText,"i)([^\\]*\\|[^\\]*)$")
    ;  ifInsertHistory:=0  ;禁止记录地址
    ifClearFuture:=0
    ControlSetText, , %editText%, ahk_id %editHwnd%
    sendinput, {end}
    return true
}

;qbar中跳到下层文件路径
keyFunc_qbar_lowerFolderPath(){
    global
    if(!WinActive("ahk_id" . GuiHwnd))
    {
        return
    }
    ;  ifInsertHistory:=0  ;禁止记录地址
    editText:=qbarPathFuture.remove()
    if(editText)
    {
        ifClearFuture:=0
        ControlSetText, , %editText%, ahk_id %editHwnd%
        sendinput, {end}
    }
    return true
}

;winbind-------------
keyFunc_winbind_activate(n){
    global
    activateWinAction(n)
    return
}


keyFunc_winbind_binding(n){
    global
    if(tapTimes[n]=="")
        initWinsInfos(n)
    tapTimes(n)
    return
}


keyFunc_winPin(){
    _id:=WinExist("A")
    ;  WinGet, ExStyle, ExStyle
    ;  if (ExStyle & 0x8)
    ;  {
    ;      WinSet, AlwaysOnTop, Off
    ;      WinSet, Transparent, Off
    ;
    ;      return
    ;  }
    WinSet, AlwaysOnTop
    ;  WinSet, Transparent, 210
    return
}


keyFunc_goCjkPage(){
    global
    run, http://cjkis.me
    return
}

; 鼠标左键点击
keyfunc_click_left(){
    Click, Left
}

; 鼠标右键点击
keyfunc_click_right(){
    Click, Right
}

; 移动鼠标
keyfunc_mouse_up(){
    MouseMove, 0, -dynamic_speed(), 0, R
}

keyfunc_mouse_down(){
    MouseMove, 0, dynamic_speed(), 0, R
}

keyfunc_mouse_left(){
    MouseMove, -dynamic_speed(), 0, 0, R
}

keyfunc_mouse_right(){
    MouseMove, dynamic_speed(), 0, 0, R
}

; 上滑滚轮
keyfunc_wheel_up(){
    Send, {WheelUp 3}
}

; 下滑滚轮
keyfunc_wheel_down(){
    Send, {Wheeldown 3}
}


;keys functions end-------------


; 判断是否为连续点击，连续点击时指数增加移动速度
; init 初始单次移动距离
; a 加速度
; max 最大单次移动距离
dynamic_speed(init:=10, a:=0.2, max:=80)
{
    static N := 0
    if (A_ThisHotkey = A_PriorHotkey) and (A_TimeSincePriorHotkey < 300)
        N += a
    else
        N = 0
    return Min(Floor(init+Exp(N)), max)
}


; testing area ---

keyFunc_activateSideWin(UDLR){
    activateSideWin(UDLR)
}

keyFunc_putWinToBottom(){
    putWinToBottom()
}

keyFunc_winJumpIgnore(){
    winJumpIgnore()
}

keyFunc_clearWinMinimizeStach(){
    clearWinMinimizeStach()
}

keyFunc_popWinMinimizeStack(){
    popWinMinimizeStack()
}

keyFunc_pushWinMinimizeStack(){
    pushWinMinimizeStack()
}

keyFunc_unshiftWinMinimizeStack(){
    unshiftWinMinimizeStack()
}

keyFunc_winTransparent(){
    winTransparent()
}