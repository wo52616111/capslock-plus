;SetCapsLockState, AlwaysOff

!t::
SendInput,^{t}
return

!w::
SendInput,^{w}
return

!+t::
SendInput, ^+{t}
return

CapsLock & Tab::^Tab
return

Tab::
If GetKeyState("Ctrl","Shift")
Send ^+{Tab}
return