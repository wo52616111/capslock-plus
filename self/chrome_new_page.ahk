; alt + t
!t::
SendInput,^{t}
Capslock:=""
SetCapsLockState Off
Return

; alt + w
!w::
SendInput,^{w}
Capslock:=""
SetCapsLockState Off
Return

; alt + shift + t
!+t::
SendInput, ^+{t}
Capslock:=""
SetCapsLockState Off
Return

; ctrl + tab
Capslock & Tab::^Tab
Capslock:=""
SetCapsLockState Off
Return

; ctrl + shift + tab
Tab::
If GetKeyState("Ctrl","Shift")
Send ^+{Tab}
Capslock:=""
SetCapsLockState Off
Return
