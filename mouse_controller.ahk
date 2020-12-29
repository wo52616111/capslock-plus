; CapsLock Mouse Controller
; modified from Feng Ruohang's AHK Script 



; CapsLock + Up | Mouse Up

; CapsLock + Down | Mouse Down

; CapsLock + Left | Mouse Left

; CapsLock + Right | Mouse Right

; CapsLock + Enter(Push Release) | Mouse Left Push(Release)

;-----------------------------------o---------------------------------o

CapsLock & Up::

if GetKeyState("space") = 0

{

if GetKeyState("alt") = 0

MouseMove, 0, -240, 0, R

else

MouseMove, -120, -120, 0, R

return

}

else {

if GetKeyState("alt") = 0

MouseMove, 0, -20, 0, R

else

MouseMove, -20, -20, 0, R

return

}

return

CapsLock & Down::

if GetKeyState("space") = 0

{

if GetKeyState("alt") = 0

MouseMove, 0, 240, 0, R

else

MouseMove,120, 120, 0, R

return

}

else {

if GetKeyState("alt") = 0

MouseMove, 0, 20, 0, R

else

MouseMove, 20, 20, 0, R

return

}

return

CapsLock & Left::

if GetKeyState("space") = 0

{

if GetKeyState("alt") = 0

MouseMove, -240, 0, 0, R

else

MouseMove, -120, 120, 0, R

return

}

else {

if GetKeyState("alt") = 0

MouseMove, -20, 0, 0, R

else

MouseMove, -20, 20, 0, R

return

}

return

CapsLock & Right::

if GetKeyState("space") = 0

{

if GetKeyState("alt") = 0

MouseMove, 240, 0, 0, R

else

MouseMove, 120, -120, 0, R

return

}

else {

if GetKeyState("alt") = 0

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
