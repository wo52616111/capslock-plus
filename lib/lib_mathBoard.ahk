/*
计算板
*/
keyFunc_mathBoard(){
ClipboardOld:=ClipboardAll
Clipboard:=""
SendInput, ^{c} ;
ClipWait, 0.1
if(!ErrorLevel)
{
    result:=clCalculate(Clipboard,res, , 1)
    if(res="?")
        result:=""
}
IfWinExist, Math Board
{
	ControlSetText, , %result%, ahk_id %CalcEditHwnd%
    WinActivate, ahk_id %CalcGui%

    sendinput, {end}
}
else
{
    Gui, mathBoard:new, hwndCalcGui, Math Board
    Gui mathBoard:+LabelmathBoard_
    Gui, +AlwaysOnTop -Border +Caption -Disabled -LastFound -MaximizeBox -OwnDialogs +Resize +SysMenu -Theme -ToolWindow
    Gui, Font, s12 w400, consolas
    ;  Gui, Font, s12 w400, Source Code Pro
    Gui, Add, Edit, x-2 y0 h403 w604 -Wrap hwndCalcEditHwnd, %result%
    Gui, Show, h400 w600
    sendinput, {end}
}

Sleep, 200

Clipboard:=ClipboardOld
CapsLock2:=""
return
}
mathBoard_Size:
WinGetPos, , ,mathBoard_W , mathBoard_H, ahk_id %CalcGui%
;  msgbox, % mathBoard_W . "#" . mathBoard_H
edit_w:=mathBoard_W-12
edit_h:=mathBoard_H-37
GuiControl, Move, %CalcEditHwnd%, w%edit_w% h%edit_h%
return

mathBoard_Close:
mathBoard_Escape:
Gui, Cancel
return

;-----------------------in calculator GUI start-------------
#if WinActive("Math Board") && GetKeyState("CapsLock","T")
u::sendinput, {7}
i::sendinput, {8}
o::sendinput, {9}
j::sendinput, {4}
k::sendinput, {5}
l::sendinput, {6}
m::sendinput, {1}
,::sendinput, {2}
.::sendinput, {3}
space::sendinput, {0}
RAlt::sendinput, {U+002e}
`;::sendinput, {U+002b}
'::sendinput, {U+002d}
p::sendinput, {U+002a}
/::
[::
sendinput, {U+002f}
return

#IF WinActive("Math Board")
NumpadEnter::
enter::
ClipboardOld:=ClipboardAll
Clipboard:=""

SendInput, +{Home}
Sleep, 10
SendInput, ^{c}
ClipWait, 0.1
if(!ErrorLevel)
{
    if(RegExMatch(Clipboard,"(?<=:\=).*;$",calResult))
    {
        clCalculate(Clipboard,calResult,0,1)
        SendInput, {End}{Enter}
    }
    else if(RegExMatch(Clipboard,"(?<=\=)[\deE\+\-\.a-fA-f]+$",calResult))
    {
        sendinput, {End}{Enter}
    }
    else
    {
        Clipboard := clCalculate(Clipboard,calResult,0,1)
        SendInput, ^{v}
        Sleep, 200
    }
}
;  }


Clipboard:=ClipboardOld
return

^NumpadEnter::
^enter::
sendinput, {enter}
return

+NumpadEnter::
+enter::
ClipboardOld:=ClipboardAll
Clipboard:=""
SendInput, +{Home}
Sleep, 10
SendInput, ^{c}
ClipWait, 0.1
if(!ErrorLevel)
{
    if(RegExMatch(Clipboard,"(?<=\=)(?<!:\=)[\deE\+\-\.a-fA-f]+$",calResult))
    {
        sendinput, {End}
    }
    else
    {
        Clipboard := clCalculate(Clipboard,calResult,0,1)
        SendInput, ^{v}
        Sleep, 200
    }
}
Clipboard:=ClipboardOld
sendinput, {enter}
sendinput, {RAW}%calResult%

;  temp := tabAction(1)
;  ;  msgbox, % temp
;  sendinput, {enter}%temp%
return
    
#IF
;-----------------------in calculator GUI end-------------