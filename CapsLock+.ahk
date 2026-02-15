#SingleInstance force
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; If the script is not elevated, relaunch as administrator and kill current instance:
full_command_line := DllCall("GetCommandLine", "str")
if not (A_IsAdmin or RegExMatch(full_command_line, " /restart(?!\S)"))
{
    try ; leads to having the script re-launching itself as administrator
    {
        if A_IsCompiled
            Run *RunAs "%A_ScriptFullPath%" /restart
        else
            Run *RunAs "%A_AhkPath%" /restart "%A_ScriptFullPath%"
    }
    ExitApp
}

IfExist, capslock+icon.ico
{
    menu, TRAY, Icon, capslock+icon.ico, , 1
}
Menu, Tray, Icon,,, 1

SetStoreCapslockMode, Off

global CLversion:="Version: 3.3.0.0 | 2023-10-22`n`nCopyright Junkai Chen" 

global cClipboardAll ;capslock+ clipboard
global caClipboardAll ;capslock+alt clipboard
global sClipboardAll ;system clipboard
global whichClipboardNow  ;0 system clipboard; 1 capslock+ clipboard; 2 capslock+alt clipboard
allowRunOnClipboardChange:=true


#Include %A_ScriptDir%\lib
#Include lib_init.ahk ;The beginning of all things

; language
#include ..\language\lang_func.ahk
#include ..\language\Simplified_Chinese.ahk
#include ..\language\English.ahk

#include lib_keysFunction.ahk
#include lib_keysSet.ahk

#include lib_settings.ahk ;get the settings from capslock+settings.ini
#Include lib_clQ.ahk ;capslock+Q
#Include lib_ydTrans.ahk  ;capslock+T translate
#Include lib_clTab.ahk 
#Include lib_functions.ahk ;public functions
#Include lib_bindWins.ahk ;capslock+` 1~8, windows bind
#Include lib_winJump.ahk
#Include lib_winTransparent.ahk
#Include lib_mouseSpeed.ahk
#Include lib_mathBoard.ahk
#include lib_loadAnimation.ahk
#include lib_GetCOMObject.ahk

;change dir
#include ..\userAHK
#include *i main.ahk

#MaxHotkeysPerInterval 500
#NoEnv
;  #WinActivateForce
Process Priority,,High


start:

;-----------------START-----------------
global ctrlZ, CapsLock2, CapsLock

Capslock::
; ctrlZ:     Capslock+Z undo / redo flag
; Capslock:  Capslock 键状态标记，按下是1，松开是0
; Capslock2: 是否使用过 Capslock+ 功能标记，使用过会清除这个变量
ctrlZ:=CapsLock2:=CapsLock:=1

SetTimer, setCapsLock2, -300 ; 300ms 犹豫操作时间

settimer, changeMouseSpeed, 50 ; 暂时修改鼠标速度

KeyWait, Capslock
CapsLock:="" ; Capslock最优先置空，来关闭 Capslock+ 功能的触发
if CapsLock2
{
    if keyset.press_caps
    {
        try
            runFunc(keyset.press_caps)
    }
    else
    {
        SetCapsLockState, % GetKeyState("CapsLock","T") ? "Off" : "On"
    }
    ; sendinput, {esc}
}
CapsLock2:=""

;
if(winTapedX!=-1)
{
    winsSort(winTapedX)
}
return

<!Capslock::
#Capslock::
; 按下lalt+Capslock或win+Capslock时，同样启动 Capslock+ 功能
CapsLock:=1
KeyWait, Capslock
CapsLock:=""
return

setCapsLock2:
CapsLock2:=""
return

OnClipboardChange:  ; 剪贴板内容改变时将运行

; 如果有复制操作时，capslock键没有按下，那就是系统原生复制
if (allowRunOnClipboardChange && !CapsLock && CLsets.global.allowClipboard != "0")
{
    try {
        clipSaver("s")
    } catch _ {
        sleep 100
        clipSaver("s")
    }
    whichClipboardNow:=0
}
allowRunOnClipboardChange:=true
return

;---------------------------- Excel 相關 -------------------------------
;-- 获取Excel窗口的COM对象
Excel_Get()
{
    return GetCOMObject("ahk_class XLMAIN")
}

#IfWinActive,ahk_class XLMAIN
{
    ; F功能区重新利用
    f3::PostMessage, 0x111, 447, 0, , a
    !l::
        objExcel:=Excel_Get()
        objExcel.Application.DisplayAlerts:= false
        objExcel.ActiveWorkbook.Save
        objExcel.ActiveWorkbook.close
        objExcel.Application.DisplayAlerts:= true
        objExcel:=""
    return

    ; az排序
    !j::send,!asa

    ; za排序
    !k::send,!asd

    ;没快捷键的常用功能,主要根据英文名改的
    ; 资料剖析
    !s::Send,!ae

    ; 底色改为 黄色
    !q::
        objExcel:=Excel_Get()
        objExcel.Selection.Interior.ColorIndex := 6
        objExcel.Selection.Font.ColorIndex := 3
        objExcel:=""
    return

    ; 无填充
    !a::
        try{
            objExcel:=Excel_Get()
            objExcel.Selection.Interior.ColorIndex := -4142
            objExcel.Selection.Font.ColorIndex := 1
            objExcel:=""
        }
        catch e{
            Send,!hhn
        }
    return

    ; 居中
    !e::Send,!hac

    ; 自动换行
    !w::Send,!hw

    ; 冻结窗格
    !t::send,!wff

    ; 编辑 Sheet 名
    !r::send,!ohr

    ; 移除重复项目
    !g::
        try{
            objExcel:=Excel_Get()
            objExcel.Selection.ActiveSheet.UsedRange.RemoveDuplicates
            objExcel:=""
        }
        catch e{
            Send,!am
        }
    return

    ; 自行调整行高
    !x::
        try{
            ox := ComObjActive("Excel.Application")
            ox.Application.Selection.EntireRow.AutoFit
            ox:=""
        }
        catch e{
            Send,!ora
        }
    return

    !z::
        try{
            ox := ComObjActive("Excel.Application")
            ox.Application.Selection.EntireColumn.AutoFit
            ox:=""
        }
        catch e{
            Send,!oca
        }
    return

    ; 自行调整列宽
    !z::
        try{
            ox := ComObjActive("Excel.Application")
            ox.Application.Selection.EntireColumn.AutoFit
        }
        catch e{
            Send,!oca
        }
    return

    ; 复制单元格纯文本
    !c:: send,{F2}^+{Home}^c{Esc}

    !v::
        Send {Blind}{LAlt Up}
        ; Clipboard:=""
        ; SendInput,^c
        ; Sleep 100
            ; MsgBox,4096,选中粘贴的位置,选中粘贴的位置
            ; Sleep 100
            clipboard = %clipboard%
            Sleep 100
            send,{Blind}^v
    return

    ; 批量插入行
    !f::
        objExcel:=Excel_Get()
        InputBox,b,批量插入行
        if(b is integer && b > 0)
        {
            loop % b
            {
                objExcel.ActiveCell.EntireRow.Insert
            }
        }
        else
        {
            MsgBox, 16, 错误, 请输入有效的正整数
        }
        objExcel:=""
    return

    ; 批量插入列
    !d::
        objExcel:=Excel_Get()
        InputBox,b,批量插入列
        if(b is integer && b > 0)
        {
            loop % b
            {
                objExcel.ActiveCell.EntireColumn.Insert
            }
        }
        else
        {
            MsgBox, 16, 错误, 请输入有效的正整数
        }
        objExcel:=""
    return

    ; 自行调整行高
    !x::
        try{
            ox := ComObjActive("Excel.Application")
            ox.Application.Selection.EntireRow.AutoFit
            ox:=""
        }
        catch e{
            Send,!ora
        }
    return

    ; 自行调整列宽
    !z::
        try{
            ox := ComObjActive("Excel.Application")
            ox.Application.Selection.EntireColumn.AutoFit
            ox:=""
        }
        catch e{
            Send,!oca
        }
    return

    !d::
        objExcel:=Excel_Get()
        InputBox,b,批量插入列
        if(b is integer && b > 0)
        {
            loop % b
            {
                objExcel.ActiveCell.EntireColumn.Insert
            }
        }
        else
        {
            MsgBox, 16, 错误, 请输入有效的正整数
        }
        objExcel:=""
    return

    ; 选中和移动光标和切换工作表格中的行和列
    ; 鼠标滚轮和方向键功能修改  
    !WheelUp::Send,{WheelLeft}     ; 当鼠标滚轮向上滚动时，发送 WheelLeft 键（相当于按下左箭头键）  
    !WheelDown::Send,{WheelRight}    ; 当鼠标滚轮向下滚动时，发送 WheelRight 键（相当于按下右箭头键）  
    +WheelUp::Send,{Left}          ; 当鼠标滚轮向上滚动时（加上 Shift 键），发送 Left 键（相当于按下左箭头键）  
    +WheelDown::Send,{Right}       ; 当鼠标滚轮向下滚动时（加上 Shift 键），发送 Right 键（相当于按下右箭头键）  
    !Right::SendInput,^{PgDn}      ; 当按下右箭头键时，发送 {PgDn} 组合键（相当于按下 PageDown 键）  
    !Left::SendInput,^{PgUp}        ; 当按下左箭头键时，发送 {PgUp} 组合键（相当于按下 PageUp 键）  
    return
}


;---------------------------- Outlook 相關 -------------------------------

;-- 获取Outlook窗口的COM对象
Outlook_Get()
{
    return GetCOMObject("ahk_class rctrl_renwnd32")
}

;仅在Outlook生效
#IfWinActive, ahk_class rctrl_renwnd32
{
    ; 将 Ctrl+Q 映射为 Alt+Q
    !q::SendInput, ^q

    ; 表格自动适应栏宽
    !w::
        SendInput, !jlfc
        Sleep, 1000
        SendInput, !jlfw
        ; SendInput, !hac
        return

}

;---------------------------- 自定義按鍵 -------------------------------


;---------------------------- 鼠标相关 -------------------------------

; 鼠标中键
; #IfWinActive, ahk_class TTOTAL_CMD
; {
;     ; 鼠标中键
;     MButton::
;         SendInput, !{F12}
;         return  ; 確保每個熱鍵塊以 return 結尾
; }
;----------------------------keys-set-start-----------------------------
#if CLsets.global.allowClipboard != "0"
$^v::
try
    keyFunc_pasteSystem()
return
#if

#If CapsLock ;when capslock key press and hold

LAlt::return

<!WheelUp::
try
    runFunc(keyset.caps_lalt_wheelUp)
Capslock2:=""
return

<!WheelDown::
try
    runFunc(keyset.caps_lalt_wheelDown)
Capslock2:=""
return

a::
b::
c::
d::
e::
f::
g::
h::
i::
j::
k::
l::
n::
m::
o::
p::
q::
r::
s::
t::
u::
v::
w::
x::
y::
z::
1::
2::
3::
4::
5::
6::
7::
8::
9::
0::
f1::
f2::
f3::
f4::
f5::
f6::
f7::
f8::
f9::
f10::
f11::
f12::
space::
tab::
enter::
esc::
backspace::
ralt::
try
    runFunc(keyset["caps_" . A_ThisHotkey])
Capslock2:=""
Return

`::
try
    runFunc(keyset.caps_backQuote)
Capslock2:=""
return


-::
try
    runFunc(keyset.caps_minus)
Capslock2:=""
return

=::
try
    runFunc(keyset.caps_equal)
Capslock2:=""
Return


[::
try
    runFunc(keyset.caps_leftSquareBracket)
Capslock2:=""
Return

]::
try
    runFunc(keyset.caps_rightSquareBracket)
Capslock2:=""
Return

\::
try
    runFunc(keyset.caps_backslash)
Capslock2:=""
return

`;::
try
    runFunc(keyset.caps_semicolon)
Capslock2:=""
Return

'::
try
    runFunc(keyset.caps_quote)
Capslock2:=""
return


,::
try
    runFunc(keyset.caps_comma)
Capslock2:=""
Return

.::
try
    runFunc(keyset.caps_dot)
Capslock2:=""
return

/::
try
    runFunc(keyset.caps_slash)
Capslock2:=""
Return

;  RAlt::
;  try
;      runFunc(keyset.caps_ralt)
;  Capslock2:=""
;  return



;---------------------caps+lalt----------------

<!a::
try
    runFunc(keyset.caps_lalt_a)
Capslock2:=""
return

<!b::
try
    runFunc(keyset.caps_lalt_b)
Capslock2:=""
Return

<!c::
try
    runFunc(keyset.caps_lalt_c)
Capslock2:=""
return

<!d::
try
    runFunc(keyset.caps_lalt_d)
Capslock2:=""
Return

<!e::
try
    runFunc(keyset.caps_lalt_e)
Capslock2:=""
Return

<!f::
try
    runFunc(keyset.caps_lalt_f)
Capslock2:=""
Return

<!g::
try
    runFunc(keyset.caps_lalt_g)
Capslock2:=""
Return

<!h::
try
    runFunc(keyset.caps_lalt_h)
Capslock2:=""
return

<!i::
try
    runFunc(keyset.caps_lalt_i)
Capslock2:=""
return

<!j::
try
    runFunc(keyset.caps_lalt_j)
Capslock2:=""
return

<!k::
try
    runFunc(keyset.caps_lalt_k)
Capslock2:=""
return

<!l::
try
    runFunc(keyset.caps_lalt_l)
Capslock2:=""
return

<!m::
try
    runFunc(keyset.caps_lalt_m)
Capslock2:=""
return

<!n::
try
    runFunc(keyset.caps_lalt_n)
Capslock2:=""
Return

<!o::
try
    runFunc(keyset.caps_lalt_o)
Capslock2:=""
return

<!p::
try
    runFunc(keyset.caps_lalt_p)
Capslock2:=""
Return

<!q::
try
    runFunc(keyset.caps_lalt_q)
Capslock2:=""
return

<!r::
try
    runFunc(keyset.caps_lalt_r)
Capslock2:=""
Return

<!s::
try
    runFunc(keyset.caps_lalt_s)
Capslock2:=""
Return

<!t::
try
    runFunc(keyset.caps_lalt_t)
Capslock2:=""
Return

<!u::
try
    runFunc(keyset.caps_lalt_u)
Capslock2:=""
return

<!v::
try
    runFunc(keyset.caps_lalt_v)
Capslock2:=""
Return

<!w::
try
    runFunc(keyset.caps_lalt_w)
Capslock2:=""
Return

<!x::
try
    runFunc(keyset.caps_lalt_x)
Capslock2:=""
Return

<!y::
try
    runFunc(keyset.caps_lalt_y)
Capslock2:=""
return

<!z::
try
    runFunc(keyset.caps_lalt_z)
Capslock2:=""
Return

<!`::
    runFunc(keyset.caps_lalt_backquote)
Capslock2:=""
return

<!1::
try
    runFunc(keyset.caps_lalt_1)
Capslock2:=""
return

<!2::
try
    runFunc(keyset.caps_lalt_2)
Capslock2:=""
return

<!3::
try
    runFunc(keyset.caps_lalt_3)
Capslock2:=""
return

<!4::
try
    runFunc(keyset.caps_lalt_4)
Capslock2:=""
return

<!5::
try
    runFunc(keyset.caps_lalt_5)
Capslock2:=""
return

<!6::
try
    runFunc(keyset.caps_lalt_6)
Capslock2:=""
return

<!7::
try
    runFunc(keyset.caps_lalt_7)
Capslock2:=""
return

<!8::
try
    runFunc(keyset.caps_lalt_8)
Capslock2:=""
return

<!9::
try
    runFunc(keyset.caps_lalt_9)
Capslock2:=""
Return

<!0::
try
    runFunc(keyset.caps_lalt_0)
Capslock2:=""
Return

<!-::
try
    runFunc(keyset.caps_lalt_minus)
Capslock2:=""
return

<!=::
try
    runFunc(keyset.caps_lalt_equal)
Capslock2:=""
Return

<!BackSpace::
try
    runFunc(keyset.caps_lalt_backspace)
Capslock2:=""
Return

<!Tab::
try
    runFunc(keyset.caps_lalt_tab)
Capslock2:=""
Return

<![::
try
    runFunc(keyset.caps_lalt_leftSquareBracket)
Capslock2:=""
Return

<!]::
try
    runFunc(keyset.caps_lalt_rightSquareBracket)
Capslock2:=""
Return

<!\::
try
    runFunc(keyset.caps_lalt_Backslash)
Capslock2:=""
return

<!`;::
try
    runFunc(keyset.caps_lalt_semicolon)
Capslock2:=""
Return

<!'::
try
    runFunc(keyset.caps_lalt_quote)
Capslock2:=""
return

<!Enter::
try
    runFunc(keyset.caps_lalt_enter)
Capslock2:=""
Return

<!,::
try
    runFunc(keyset.caps_lalt_comma)
Capslock2:=""
Return

<!.::
try
    runFunc(keyset.caps_lalt_dot)
Capslock2:=""
return

<!/::
try
    runFunc(keyset.caps_lalt_slash)
Capslock2:=""
Return

<!Space::
try
    runFunc(keyset.caps_lalt_space)
Capslock2:=""
Return

<!RAlt::
try
    runFunc(keyset.caps_lalt_ralt)
Capslock2:=""
return

<!F1::
try
    runFunc(keyset.caps_lalt_f1)
Capslock2:=""
return

<!F2::
try
    runFunc(keyset.caps_lalt_f2)
Capslock2:=""
return

<!F3::
try
    runFunc(keyset.caps_lalt_f3)
Capslock2:=""
return

<!F4::
try
    runFunc(keyset.caps_lalt_f4)
Capslock2:=""
return

<!F5::
try
    runFunc(keyset.caps_lalt_f5)
Capslock2:=""
return

<!F6::
try
    runFunc(keyset.caps_lalt_f6)
Capslock2:=""
return

<!F7::
try
    runFunc(keyset.caps_lalt_f7)
Capslock2:=""
return

<!F8::
try
    runFunc(keyset.caps_lalt_f8)
Capslock2:=""
return

<!F9::
try
    runFunc(keyset.caps_lalt_f9)
Capslock2:=""
return

<!F10::
try
    runFunc(keyset.caps_lalt_f10)
Capslock2:=""
return

<!F11::
try
    runFunc(keyset.caps_lalt_f11)
Capslock2:=""
return

<!F12::
try
    runFunc(keyset.caps_lalt_f12)
Capslock2:=""
return

#1::
try
    runFunc(keyset.caps_win_1)
Capslock2:=""
return

#2::
try
    runFunc(keyset.caps_win_2)
Capslock2:=""
return

#3::
try
    runFunc(keyset.caps_win_3)
Capslock2:=""
return

#4::
try
    runFunc(keyset.caps_win_4)
Capslock2:=""
return

#5::
try
    runFunc(keyset.caps_win_5)
Capslock2:=""
return

#6::
try
    runFunc(keyset.caps_win_6)
Capslock2:=""
return

#7::
try
    runFunc(keyset.caps_win_7)
Capslock2:=""
return

#8::
try
    runFunc(keyset.caps_win_8)
Capslock2:=""
return

#9::
try
    runFunc(keyset.caps_win_9)
Capslock2:=""
return

#0::
try
    runFunc(keyset.caps_win_0)
Capslock2:=""
return
;  #s::
;      keyFunc_activateSideWin("l")
;  Capslock2:=""
;  return

;  #f::
;      keyFunc_activateSideWin("r")
;      Capslock2:=""
;  return

;  #e::
;      keyFunc_activateSideWin("u")
;  Capslock2:=""
;  return

;  #d::
;      keyFunc_activateSideWin("d")
;      Capslock2:=""
;  return

;  #w::
;      keyFunc_putWinToBottom()
;      Capslock2:=""
;  return

;  #a::
;      keyFunc_activateSideWin("fl")
;      Capslock2:=""
;  return

;  #g::
;      keyFunc_activateSideWin("fr")
;      Capslock2:=""
;  return

;  #z::
;      keyFunc_clearWinMinimizeStach()
;      CapsLock2:=""
;  return

;  #x::
;      keyFunc_inWinMinimizeStack(true)
;      Capslock2:=""
;  return

;  #c::
;      keyFunc_inWinMinimizeStack()
;      Capslock2:=""
;  return

;  #v::
;      keyFunc_outWinMinimizeStack()
;      Capslock2:=""
;  return



#If

GuiClose:
GuiEscape:
Gui, Cancel
return
