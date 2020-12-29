; CapsLock relevant content is modified from Feng Ruohang's AHK Script 


Rctrl:::
RShift::_
Xbutton2::Enter
Xbutton1::Del
RAlt::Send ^{b}
^Xbutton1::BackSpace


; wps pdf highlight.  ! 代表Alt ,换回Alt倒不行

#f:: 
Send ^{F2}
return

#j:: 
Send ^5
return

; 高亮是把6换成02



+!m::
Send, 58466600666666666@qq.com
return

+!x::
Send, 2017211211
return

+!c::
Send, 131371371310086
return
#c:: 
Send {Ctrl down}c{Ctrl up}
Path := "C:\Program Files\Google\Chrome\Application\chrome.exe" 
cmd := "https://www.google.com/search?q=" 
run ,  %Path%  "%cmd%%Clipboard%"
return

!c:: 
Send {Home}
Send +{End}
Send {Ctrl down}c{Ctrl up}
Path := "C:\Program Files\Google\Chrome\Application\chrome.exe" 
cmd := "https://www.google.com/search?q=" 
run ,  %Path%  "%cmd%%Clipboard%"
return


#b:: 
Send {Ctrl down}c{Ctrl up}	
Path := "C:\Program Files\Google\Chrome\Application\chrome.exe" 
cmd := "https://www.baidu.com/s?wd=" 
run ,  %Path%  "%cmd%%Clipboard%"
return

#a::
Send {Ctrl down}c{Ctrl up}	
Path := "C:\Program Files\Google\Chrome\Application\chrome.exe" 
cmd := "https://www.semanticscholar.org/search?q=" 
run ,  %Path%  "%cmd%%Clipboard%"
return



#g:: 
Send {Ctrl down}c{Ctrl up}
Path := "C:\Program Files\Google\Chrome\Application\chrome.exe" 
cmd := "https://github.com/search?q="  
run ,  %Path%  "%cmd%%Clipboard%"
return


#z:: 
Send {Ctrl down}c{Ctrl up}
Path := "C:\Program Files\Google\Chrome\Application\chrome.exe" 
cmd := "https://www.zhihu.com/search?q=" 
run ,  %Path%  "%cmd%%Clipboard%"
return

; 注释  加号是shift  叹号是alt
;========================特殊功能区5: 程序切换区==============================
; #NoTrayIcon  ;不显示托盘图标

; Function to run a program or activate an already running instance 
RunOrActivateProgram(Program, WorkingDir="", WindowSize=""){ 
    SplitPath Program, ExeFile 
    Process, Exist, %ExeFile% 
    PID = %ErrorLevel% 
    if (PID = 0) { 
    Run, %Program%, %WorkingDir%, %WindowSize% 
    }else{ 
    WinActivate, ahk_pid %PID% 
    } 
}


;打开or切换Typora
;之前只有Typora不灵，这种方式就可以诶 =。=  哇。。。知乎万岁
; !v::   ;Alt+V
; DetectHiddenWindows, On
; SetTitleMatchMode, 2
; WinGet, winid, ID, Typora
; ;MsgBox,%winid%
; SetTitleMatchMode, 1
; If (winid) {
; WinWait, ahk_id %winid%
; WinShow
; WinActivate
; ControlFocus, EditComponent2, A
; ControlSetText, EditComponent2,, A
; }else{
; ; RunOrActivateProgram("D:\Program Files\AliWangWang\AliIM.exe")
; RunOrActivateProgram("C:\Program Files\Typora\Typora.exe")
; }
; DetectHiddenWindows, Off
; return

^!1::send {home}{#}{space}----------{end}----------
^!2::send {home}{#}{#}{space}---{end}---
::/qm::584400706@qq.com


;=====================================================================o
;                   Feng Ruohang's AHK Script                         |
;Summary:                                       
;|CapsLock;             | {ESC}  Especially Convient for vim user     |
;|CaspLock + `          | {CapsLock}CapsLock Switcher as a Substituent| 
;|CapsLock + hjklwb     | Vim-Style Cursor Mover                      |
;|CaspLock + uiop       | Convient Home/End PageUp/PageDn             |
;|CaspLock + nm,.       | Convient Delete Controller                  |
;|CapsLock + xcvay     | Windows-Style Editor                        |
;|CapsLock + Direction  | Mouse Move                                  |
;|CapsLock + Enter      | Mouse Click                                 |
;|CaspLock + {F1}!{F7}  | Media Volume Controller                     |
;|CapsLock + qs         | Windows & Tags Control                      |
;|CapsLock + ;'[]       | Convient Key Mapping                        |
;|CaspLock + dfert      | Frequently Used Programs (Self Defined)     |
;|CaspLock + 123456     | Dev-Hotkey for Visual Studio (Self Defined) |
;|CapsLock + 67890-=    | Shifter as Shift                            |
;=====================================================================o
;                       CapsLock Initializer                        
;---------------------------------------------------------------------o
SetCapsLockState, AlwaysOff                                         
;---------------------------------o-----------------------------------o
;                    CapsLock + ` | {CapsLock}                      
;---------------------------------o-----------------------------------o
CapsLock & `::                                                      
GetKeyState, CapsLockState, CapsLock, T                             
if CapsLockState = D                                                
    SetCapsLockState, AlwaysOff                                     
else                                                                
    SetCapsLockState, AlwaysOn                                      
KeyWait, ``                                                         
return                                                              
;---------------------------------------------------------------------o
;                        CapsLock  |  {ESC}                         
CapsLock::Send, {ESC}                                               
;---------------------------------------------------------------------o
;                    CapsLock Direction Navigator                   
;-----------------------------------o---------------------------------o
;                      CapsLock + h |  Left                         
;                      CapsLock + j |  Down                         
;                      CapsLock + k |  Up                           
;                      CapsLock + l |  Right                        
;-----------------------------------o---------------------------------o
CapsLock & h::                                                      
if GetKeyState("control") = 0                                       
{                                                                   
    if GetKeyState("alt") = 0                                       
        Send, {Left}                                                
    else                                                            
        Send, +{Left}                                               
    return                                                          
}                                                                   
else {                                                              
    if GetKeyState("alt") = 0                                       
        Send, ^{Left}                                               
    else                                                            
        Send, +^{Left}                                              
    return                                                          
}                                                                   
return                                                              
;-----------------------------------o                               
CapsLock & j::                                                      
if GetKeyState("control") = 0                                       
{                                                                   
    if GetKeyState("alt") = 0                                       
        Send, {Down}                                                
    else                                                            
        Send, +{Down}                                               
    return                                                          
}                                                                   
else {                                                              
    if GetKeyState("alt") = 0                                       
        Send, ^{Down}                                               
    else                                                            
        Send, +^{Down}                                              
    return                                                          
}                                                                   
return                                                              
;-----------------------------------o                               
CapsLock & k::                                                      
if GetKeyState("control") = 0                                       
{                                                                   
    if GetKeyState("alt") = 0                                       
        Send, {Up}                                                  
    else                                                            
        Send, +{Up}                                                 
    return                                                          
}                                                                   
else {                                                              
    if GetKeyState("alt") = 0                                       
        Send, ^{Up}                                                 
    else                                                            
        Send, +^{Up}                                                
    return                                                          
}                                                                   
return                                                              
;-----------------------------------o                               
CapsLock & l::                                                      
if GetKeyState("control") = 0                                       
{                                                                   
    if GetKeyState("alt") = 0                                       
        Send, {Right}                                               
    else                                                            
        Send, +{Right}                                              
    return                                                          
}                                                                   
else {                                                              
    if GetKeyState("alt") = 0                                       
        Send, ^{Right}                                              
    else                                                            
        Send, +^{Right}                                             
    return                                                          
}                                                                   
return                                                              
;---------------------------------------------------------------------o
 
 
;=====================================================================o
;                     CapsLock Home/End Navigator                   
;-----------------------------------o---------------------------------o
;                      CapsLock + i |  Home                         
;                      CapsLock + o |  End                          
;                      Ctrl, Alt Compatible                         
;-----------------------------------o---------------------------------o
CapsLock & i::                                                      
if GetKeyState("control") = 0                                       
{                                                                   
    if GetKeyState("alt") = 0                                       
        Send, {Home}                                                
    else                                                            
        Send, +{Home}                                               
    return                                                          
}                                                                   
else {                                                              
    if GetKeyState("alt") = 0                                       
        Send, ^{Home}                                               
    else                                                            
        Send, +^{Home}                                              
    return                                                          
}                                                                   
return                                                              
;-----------------------------------o                               
CapsLock & o::                                                      
if GetKeyState("control") = 0                                       
{                                                                   
    if GetKeyState("alt") = 0                                       
        Send, {End}                                                 
    else                                                            
        Send, +{End}                                                
    return                                                          
}                                                                   
else {                                                              
    if GetKeyState("alt") = 0                                       
        Send, ^{End}                                                
    else                                                            
        Send, +^{End}                                               
    return                                                          
}                                                                   
return                                                              
;---------------------------------------------------------------------o
 
 
;=====================================================================o
;                      CapsLock Page Navigator                      
;-----------------------------------o---------------------------------o
;                      CapsLock + u |  PageUp                       
;                      CapsLock + p |  PageDown                     
;                      Ctrl, Alt Compatible                         
;-----------------------------------o---------------------------------o
CapsLock & u::                                                      
if GetKeyState("control") = 0                                       
{                                                                   
    if GetKeyState("alt") = 0                                       
        Send, {PgUp}                                                
    else                                                            
        Send, +{PgUp}                                               
    return                                                          
}                                                                   
else {                                                              
    if GetKeyState("alt") = 0                                       
        Send, ^{PgUp}                                               
    else                                                            
        Send, +^{PgUp}                                              
    return                                                          
}                                                                   
return                                                              
;-----------------------------------o                               
CapsLock & p::                                                      
if GetKeyState("control") = 0                                       
{                                                                   
    if GetKeyState("alt") = 0                                       
        Send, {PgDn}                                                
    else                                                            
        Send, +{PgDn}                                               
    return                                                          
}                                                                   
else {                                                              
    if GetKeyState("alt") = 0                                       
        Send, ^{PgDn}                                               
    else                                                            
        Send, +^{PgDn}                                              
    return                                                          
}                                                                   
return                                                              
;---------------------------------------------------------------------o
 
 
;=====================================================================o
;                     CapsLock Mouse Controller                     
;-----------------------------------o---------------------------------o
;                   CapsLock + Up   |  Mouse Up                     
;                   CapsLock + Down |  Mouse Down                   
;                   CapsLock + Left |  Mouse Left                   
;                  CapsLock + Right |  Mouse Right                  
;    CapsLock + Enter(Push Release) |  Mouse Left Push(Release)      
 ;-----------------------------------o---------------------------------o
CapsLock & Up::                                                      
if GetKeyState("alt") = 0                                       
{                                                                   
    if GetKeyState("control") = 0                                       
        MouseMove, 0, -240, 0, R                                              
    else                                                            
        MouseMove, -120, -120, 0, R                                              
    return                                                          
}                                                                   
else {                                                              
    if GetKeyState("control") = 0                                       
        MouseMove, 0, -20, 0, R                                              
    else                                                            
        MouseMove, -20, -20, 0, R 
    return                                                          
}                                                                   
return                     
CapsLock & Down::                                                      
if GetKeyState("alt") = 0                                       
{                                                                   
    if GetKeyState("control") = 0                                       
        MouseMove, 0, 240, 0, R                                              
    else                                                            
        MouseMove,120, 120, 0, R                                              
    return                                                          
}                                                                   
else {                                                              
    if GetKeyState("control") = 0                                       
        MouseMove, 0, 20, 0, R                                              
    else                                                            
        MouseMove, 20, 20, 0, R 
    return                                                          
}                                                                   
return                     
CapsLock & Left::                                                      
if GetKeyState("alt") = 0                                       
{                                                                   
    if GetKeyState("control") = 0                                       
        MouseMove, -240, 0, 0, R                                              
    else                                                            
        MouseMove, -120, 120, 0, R                                              
    return                                                          
}                                                                   
else {                                                              
    if GetKeyState("control") = 0                                       
        MouseMove, -20, 0, 0, R                                              
    else                                                            
        MouseMove, -20, 20, 0, R 
    return                                                          
}                                                                   
return                     
CapsLock & Right::                                                      
if GetKeyState("alt") = 0                                       
{                                                                   
    if GetKeyState("control") = 0                                       
        MouseMove, 240, 0, 0, R                                              
    else                                                            
        MouseMove, 120, -120, 0, R 
    return                                                          
}                                                                   
else {                                                              
    if GetKeyState("control") = 0                                       
        MouseMove, 40, 0, 0, R                                              
    else                                                            
        MouseMove, 60, -60, 0, R                                              
    return                                                          
}                                                                   
return                     

;-----------------------------------o                               
CapsLock & Enter::                                                  
SendEvent {Blind}{LButton down}                                     
KeyWait Enter                                                       
SendEvent {Blind}{LButton up}                                       
return                                                              
;---------------------------------------------------------------------o
 
 
;=====================================================================o
                    ;  CapsLock Deletor                       
;-----------------------------------o---------------------------------o
;                     CapsLock + n  |  Ctrl + Delete (Delete a Word)
;                     CapsLock + m  |  Delete                       
;                     CapsLock + ,  |  BackSpace                    
;                     CapsLock + .  |  Ctrl + BackSpace             
;-----------------------------------o---------------------------------o
CapsLock & ,:: Send, {Del}                                          
CapsLock & .:: Send, ^{Del}                                         
CapsLock & m:: Send, {BS}                                           
CapsLock & n:: Send, ^{BS}                                          
;---------------------------------------------------------------------o
 
 
;=====================================================================o
;                            CapsLock Editor                        
;-----------------------------------o---------------------------------o
;                     CapsLock + w  |  Ctrl + Right(Move as [vim: w]);|
;                     CapsLock + b  |  Ctrl + Left (Move as [vim: b]);|
;-----------------------------------o---------------------------------o
CapsLock & b:: Send, ^{Left}                                        
;---------------------------------------------------------------------o
 
CapsLock & v:: Send, ^v                                             
CapsLock & a:: Send, ^a                                             
CapsLock & y:: Send, ^y                                             


CapsLock & x:: RunOrActivateProgram("E:\moba\MobaXterm.exe")
CapsLock & c:: RunOrActivateProgram("C:\Program Files\Google\Chrome\Application\chrome.exe")
CapsLock & w:: RunOrActivateProgram("C:\Users\noway\AppData\Local\Kingsoft\WPS Office\ksolaunch.exe")
 
;=====================================================================o
;                       CapsLock Media Controller                   
;-----------------------------------o---------------------------------o
;                    CapsLock + F1  |  Volume_Mute                  
;                    CapsLock + F2  |  Volume_Down                  
;                    CapsLock + F3  |  Volume_Up                    
;                    CapsLock + F3  |  Media_Play_Pause             
;                    CapsLock + F5  |  Media_Prev                   
;                    CapsLock + F6  |  Media_Next                                               
;                    CapsLock + F7  |  Media_Stop                   
;-----------------------------------o---------------------------------o
CapsLock & F1:: Send, {Volume_Mute}                                 
CapsLock & F2:: Send, {Volume_Down}                                 
CapsLock & F3:: Send, {Volume_Up}                                   
CapsLock & F4:: Send, {Media_Play_Pause}                            
CapsLock & F5:: Send, {Media_Prev}                                  
CapsLock & F6:: Send, {Media_Next}                                  
CapsLock & F7:: Send, {Media_Stop}                                  
;---------------------------------------------------------------------o
 
 
;=====================================================================o
;                      CapsLock Window Controller                   
;-----------------------------------o---------------------------------o
;                     CapsLock + s  |  Ctrl + Tab (Swith Tag)       
;                     CapsLock + q  |  Ctrl + W   (Close Tag)       
;   (Disabled)  Alt + CapsLock + s  |  AltTab     (Switch Windows)  
;               Alt + CapsLock + q  |  Ctrl + Tab (Close Windows)   
;                     CapsLock + g  |  AppsKey    (类似鼠标右键)        
;-----------------------------------o---------------------------------o
CapsLock & s::Send, ^{Tab}                                          
;-----------------------------------o                               
CapsLock & q::                                                      
if GetKeyState("alt") = 0                                           
{                                                                   
    Send, ^w                                                        
}                                                                   
else {                                                              
    Send, !{F4}                                                     
    return                                                          
}                                                                   
return                                                              
;-----------------------------------o                               
CapsLock & g:: Send, {AppsKey}                                      
;---------------------------------------------------------------------o
 
 
;=====================================================================o
;                        CapsLock Self Defined Area                 
;-----------------------------------o---------------------------------o
;                     CapsLock + d  |  Alt + d(Dictionary)          
;                     CapsLock + f  |  Alt + f(Search via Everything);|
;                     CapsLock + e  |  Open Search Engine           
;                     CapsLock + r  |  Open Shell                   
;                     CapsLock + t  |  Open Text Editor             
;-----------------------------------o---------------------------------o

CapsLock & f:: Send, !f                                             
CapsLock & e:: Run http://cn.bing.com/                              
CapsLock & r:: Run Powershell                                       
CapsLock & t:: RunOrActivateProgram("C:\Users\noway\AppData\Local\Programs\Microsoft VS Code\code.exe")
CapsLock & z:: RunOrActivateProgram("C:\Program Files (x86)\Zotero\zotero.exe")
;---------------------------------------------------------------------o
 
 
;=====================================================================o
;                        CapsLock Char Mapping                      
;-----------------------------------o---------------------------------o
;                     CapsLock + ;  |  Enter (Cancel)               
;                     CapsLock + '  |  =                            
;                     CapsLock + [  |  Back         (Visual Studio) 
;                     CapsLock + ]  |  Goto Define  (Visual Studio) 
;                     CapsLock + /  |  Comment      (Visual Studio) 
;                     CapsLock + \  |  Uncomment    (Visual Studio) 
;                     CapsLock + 1  |  Build and Run(Visual Studio) 
;                     CapsLock + 2  |  Debuging     (Visual Studio) 
;                     CapsLock + 3  |  Step Over    (Visual Studio) 
;                     CapsLock + 4  |  Step In      (Visual Studio) 
;                     CapsLock + 5  |  Stop Debuging(Visual Studio) 
;                     CapsLock + 6  |  Shift + 6     ^              
;                     CapsLock + 7  |  Shift + 7     &              
;                     CapsLock + 8  |  Shift + 8     *              
;                     CapsLock + 0  |  Shift + 0     )              
;-----------------------------------o---------------------------------o
CapsLock & `;:: Send, {Enter}                                       
CapsLock & ':: Send, =                                              
CapsLock & [:: Send, ^-                                             
CapsLock & ]:: Send, {F12}                                          
;-----------------------------------o                               
CapsLock & /::                                                      
Send, ^e                                                            
Send, c                                                             
return                                                              
;-----------------------------------o                               
CapsLock & \::                                                      
Send, ^e                                                            
Send, u                                                             
return                                                              
;-----------------------------------o                               
; CapsLock & 1:: Send,^{F5}                                           
; CapsLock & 2:: Send,{F5}                                            
; CapsLock & 3:: Send,{F10}                                           
; CapsLock & 4:: Send,{F11}                                           
; CapsLock & 5:: Send,+{F5}                                           
;-----------------------------------o                               
CapsLock & 6:: Send,+6                                              
CapsLock & 7:: Send,+7                                              
CapsLock & 8:: Send,+8                                              
CapsLock & 9:: Send,+9                                              
CapsLock & 0:: Send,+0                                              
;---------------------------------------------------------------------o

; 还可以用的快捷键
; !z::
