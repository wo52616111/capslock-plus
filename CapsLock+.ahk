#SingleInstance force

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
;freezing icon
menu, TRAY, Icon, capslock+icon.ico, , 1
}
Menu, Tray, Icon,,, 1

SetStoreCapslockMode, Off

global CLversion:="Version: 3.3.0.0 | 2023-10-22`n`nCopyright Junkai Chen" 

global cClipboardAll ;capslock+ clipboard
global caClipboardAll ;capslock+alt clipboard
global sClipboardAll ;system clipboard
global whichClipboardNow  ;0 system clipboard; 1 capslock+ clipboard; 2 capslock+alt clipboard
;  global clipSaveArr=[]
allowRunOnClipboardChange:=true


#Include lib
#Include lib_init.ahk ;The beginning of all things

; language
#include ..\language\lang_func.ahk
#include ..\language\Simplified_Chinese.ahk
#include ..\language\English.ahk
;  #include ..\language\Traditional_Chinese.ahk
; /language

#include lib_keysFunction.ahk
#include lib_keysSet.ahk
;  #include lib_ahkExec.ahk
;  #include lib_scriptDemo.ahk
;  #include lib_fileMethods.ahk

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
;ctrlZ:     Capslock+Z undo / redo flag
;Capslock:  Capslock 键状态标记，按下是1，松开是0
;Capslock2: 是否使用过 Capslock+ 功能标记，使用过会清除这个变量
ctrlZ:=CapsLock2:=CapsLock:=1

SetTimer, setCapsLock2, -300 ; 300ms 犹豫操作时间

settimer, changeMouseSpeed, 50 ;暂时修改鼠标速度

KeyWait, Capslock
CapsLock:="" ;Capslock最优先置空，来关闭 Capslock+ 功能的触发
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

;--::-------------------------
;  KEY_TO_NAME := {"a":"a","b":"b","c":"c","d":"d","e":"e","f":"f","g":"g","h":"h","i":"i"
;    ,"j":"j","k":"k","l":"l","m":"m","n":"n","o":"o","p":"p","q":"q","r":"r"
;    ,"s":"s","t":"t","u":"u","v":"v","w":"w","x":"x","y":"y","z":"z"
;    ,"1":"1","2":"2","3":"3","4":"4","5":"5","6":"6","7":"7","8":"8","9":"9","0":"0"
;    ,"f1":"f1","f2":"f2","f3":"f3","f4":"f4","f5":"f5","f6":"f6"
;    ,"f7":"f7","f8":"f8","f9":"f9","f10":"f10","f11":"f11","f12":"f12"
;    ,"f13":"f13","f14":"f14","f15":"f15","f16":"f16","f17":"f17","f18":"f18","f19":"f19"
;    ,"space":"space","tab":"tab","enter":"enter","esc":"esc","backspace":"backspace"
;    ,"`":"backQuote","-":"minus","=":"equal","[":"leftSquareBracket","]":"rightSquareBracket"
;    ,"\":"backSlash",";":"semicolon","'":"quote",",":"comma",".":"dot","/":"slash","ralt":"ralt"
;    ,"wheelUp":"wheelUp","wheelDown":"wheelDown"}

;  for k,v in KEY_TO_NAME{
;      msgbox, % v
;  }
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
