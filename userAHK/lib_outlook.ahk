;==============================
; Outlook Enhanced Functions
;==============================
; This module provides Outlook-specific hotkeys and functions
; Include this file in userAHK/main.ahk

Outlook_Get(){
    return GetCOMObject("ahk_class rctrl_renwnd32")
}

#IfWinActive, ahk_class rctrl_renwnd32
{
    !q::SendInput, ^q

    !w::
        SendInput, !jlfc
        Sleep, 1000
        SendInput, !jlfw
        return
}
#IfWinActive
