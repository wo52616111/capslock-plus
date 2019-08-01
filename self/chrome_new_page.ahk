; self-use auto hotkey script.
; alt + t
!t::
Send ^{t}
Capslock:=""
SetCapsLockState Off
Return

; alt + w
!w::
Send ^{w}
Capslock:=""
SetCapsLockState Off
Return

; alt + r
!r::
Send ^{r}
Capslock:=""
SetCapsLockState Off
Return

; command + c
!c::
Send ^{c}
Capslock:=""
SetCapsLockState Off
Return

; command + v
!v::
Send ^{v}
Capslock:=""
SetCapsLockState Off
Return

; command + x
!x::
Send ^{x}
Capslock:=""
SetCapsLockState Off
Return

; command + z
!z::
Send ^{z}
Capslock:=""
SetCapsLockState Off
Return

; command + a
!a::
Send ^{a}
Capslock:=""
SetCapsLockState Off
Return

; command + n
!n::
Send ^{n}
Capslock:=""
SetCapsLockState Off
Return


; command + space
!Space::
Send #{s}
Capslock:=""
SetCapsLockState Off
Return


; command + s simulates save
!s::
Send ^{s}
Capslock:=""
SetCapsLockState Off
Return

; alt + shift + t
!+t::
Send, ^+{t}
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
If (GetKeyState(Capslock,Shift)){
    Send ^+{Tab}
  
} else {
    Send {Tab}
}
Capslock:=""
SetCapsLockState Off
Return

; alt + shift + n
!+n::
Send, ^+{n}
Capslock:=""
SetCapsLockState Off
Return


