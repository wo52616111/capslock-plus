if not A_IsAdmin ;running by administrator
{
   Run *RunAs "%A_ScriptFullPath%" 
   ExitApp
}


IfExist, capslock+icon.ico
{
;freezing icon
menu, TRAY, Icon, capslock+icon.ico, , 1
}
Menu, Tray, Icon,,, 1



global CLversion:="Version: 2.6.0.6 | 2016-7-7`n`nCopyright 2016 Chen JunKai" 

global cClipboardAll ;capslock+ clipboard
global caClipboardAll ;capslock+alt clipboard
global sClipboardAll ;system clipboard
global whichClipboardNow  ;0 system clipboard; 1 capslock+ clipboard; 2 capslock+alt clipboard
;  global clipSaveArr=[]
allowRunOnClipboardChange:=true


#Include lib
#Include lib_init.ahk ;The beginning of all things
#include lib_language.ahk
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
    SetCapsLockState, % GetKeyState("CapsLock","T") ? "Off" : "On"
}
CapsLock2:=""

;
if(winTapedX!=-1)
{
    winsSort(winTapedX)
}

Return

setCapsLock2:
CapsLock2:=""
return

OnClipboardChange:  ; 剪贴板内容改变时将运行

; 如果有复制操作时，capslock键没有按下，那就是系统原生复制
if (allowRunOnClipboardChange && !CapsLock && CLsets.global.allowClipboard != "0")
{
    clipSaver("s")
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
    runFunc(keyset.caps_lalt_wheel_up)
Capslock2:=""
return

<!WheelDown::
try
    runFunc(keyset.caps_lalt_wheel_down)
Capslock2:=""
return


;--------------A~Z-------------
a::
try
    runFunc(keyset.caps_a)
Capslock2:=""
Return

b::
try
    runFunc(keyset.caps_b)
Capslock2:=""
Return

c::
try
    runFunc(keyset.caps_c)
Capslock2:=""
return

d::
try
    runFunc(keyset.caps_d)
Capslock2:=""
Return

e::
try
    runFunc(keyset.caps_e)
Capslock2:=""
Return

f::
try
    runFunc(keyset.caps_f)
Capslock2:=""
Return

g::
try
    runFunc(keyset.caps_g)
Capslock2:=""
Return

h::
try
    runFunc(keyset.caps_h)
Capslock2:=""
return

i::
try
    runFunc(keyset.caps_i)
Capslock2:=""
return

j::
try
    runFunc(keyset.caps_j)
Capslock2:=""
return

k::
try
    runFunc(keyset.caps_k)
Capslock2:=""
return

l::
try
    runFunc(keyset.caps_l)
Capslock2:=""
return

m::
try
    runFunc(keyset.caps_m)
Capslock2:=""
return

n::
try
    runFunc(keyset.caps_n)
Capslock2:=""
Return

o::
try
    runFunc(keyset.caps_o)
Capslock2:=""
return

p::
try
    runFunc(keyset.caps_p)
Capslock2:=""
Return

q::
try
    runFunc(keyset.caps_q)
Capslock2:=""
return

r::
try
    runFunc(keyset.caps_r)
Capslock2:=""
Return

s::
try
    runFunc(keyset.caps_s)
Capslock2:=""
Return

t::
try
    runFunc(keyset.caps_t)
Capslock2:=""
Return

u::
try
    runFunc(keyset.caps_u)
Capslock2:=""
return

v::
try
    runFunc(keyset.caps_v)
Capslock2:=""
Return

w::
try
    runFunc(keyset.caps_w)
Capslock2:=""
Return

x::
try
    runFunc(keyset.caps_x)
Capslock2:=""
Return

y::
try
    runFunc(keyset.caps_y)
Capslock2:=""
return

z::
try
    runFunc(keyset.caps_z)
Capslock2:=""
Return

`::
try
    runFunc(keyset.caps_backquote)
Capslock2:=""
return

1::
try
    runFunc(keyset.caps_1)
Capslock2:=""
return

2::
try
    runFunc(keyset.caps_2)
Capslock2:=""
return

3::
try
    runFunc(keyset.caps_3)
Capslock2:=""
return

4::
try
    runFunc(keyset.caps_4)
Capslock2:=""
return

5::
try
    runFunc(keyset.caps_5)
Capslock2:=""
return

6::
try
    runFunc(keyset.caps_6)
Capslock2:=""
return

7::
try
    runFunc(keyset.caps_7)
Capslock2:=""
return

8::
try
    runFunc(keyset.caps_8)
Capslock2:=""
return

9::
try
    runFunc(keyset.caps_9)
Capslock2:=""
Return

0::
try
    runFunc(keyset.caps_0)
Capslock2:=""
Return

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

BackSpace::
try
    runFunc(keyset.caps_backspace)
Capslock2:=""
Return

Tab::
try
    runFunc(keyset.caps_tab)
Capslock2:=""
Return

[::
try
    runFunc(keyset.caps_left_square_bracket)
Capslock2:=""
Return

]::
try
    runFunc(keyset.caps_right_square_bracket)
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

Enter::
try
    runFunc(keyset.caps_enter)
Capslock2:=""
Return

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

Space::
try
    runFunc(keyset.caps_space)
Capslock2:=""
Return

RAlt::
try
    runFunc(keyset.caps_right_alt)
Capslock2:=""
return

;--------------F1~F12-------------

F1::
try
    runFunc(keyset.caps_f1)
Capslock2:=""
return

F2::
try
    runFunc(keyset.caps_f2)
Capslock2:=""
return

F3::
try
    runFunc(keyset.caps_f3)
Capslock2:=""
return

F4::
try
    runFunc(keyset.caps_f4)
Capslock2:=""
return

F5::
try
    runFunc(keyset.caps_f5)
Capslock2:=""
return

F6::
try
    runFunc(keyset.caps_f6)
Capslock2:=""
return

F7::
try
    runFunc(keyset.caps_f7)
Capslock2:=""
return

F8::
try
    runFunc(keyset.caps_f8)
Capslock2:=""
return

F9::
try
    runFunc(keyset.caps_f9)
Capslock2:=""
return

F10::
try
    runFunc(keyset.caps_f10)
Capslock2:=""
return

F11::
try
    runFunc(keyset.caps_f11)
Capslock2:=""
return

F12::
try
    runFunc(keyset.caps_f12)
Capslock2:=""
return

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
    runFunc(keyset.caps_lalt_left_square_bracket)
Capslock2:=""
Return

<!]::
try
    runFunc(keyset.caps_lalt_right_square_bracket)
Capslock2:=""
Return

<!\::
try
    runFunc(keyset.caps_lalt_backslash)
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
    runFunc(keyset.caps_lalt_right_alt)
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

#If




GuiClose:
GuiEscape:
Gui, Cancel
return
