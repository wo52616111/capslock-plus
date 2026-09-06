; 1. Include the .ahk file(s) containing custom key functions here,
;   or just put the functions here.
;   * A key function must start with "keyFunc_" (case insensitive)

; 2. Add a setting under the [Keys] section in `CapsLock+settings.ini`

; Example:
; 1. There is a key function `keyFunc_example2` in demo.ahk.
; 2. Add below setting under the [Keys] section in `CapsLock+settings.ini`:
;   caps_f7=keyFunc_example2
; 3. Save, reload Capslock+ (CapsLock+F5)
; 4. Press `CapsLock+F7` to invoke the function

#include demo.ahk

keyFunc_example1(){
  msgbox, example1
}

keyFunc_qbarExternalApp(){
    global CLSets
    KeyWait, CapsLock
    externalPath:=""
    if(IsObject(CLSets) && IsObject(CLSets.Global))
    {
        externalPath:=Trim(CLSets.Global.externalAppPath)
        if(externalPath="")
            externalPath:=Trim(CLSets.Global.listaryPath)
    }
    if(externalPath="")
    {
        message:="Set the external application path in Settings > Qbar first."
        MsgBox, 0x40030, CapsLock+, %message%
        return
    }
    if(!FileExist(externalPath))
    {
        message:="The external application path does not exist. Configure it again."
        MsgBox, 0x40030, CapsLock+, %message%
        return
    }
    externalExeName:=""
    SplitPath, externalPath, externalExeName
    StringLower, externalExeNameLower, externalExeName
    isListary:=externalExeNameLower="listary.exe"
    if(isListary)
        selText:=getSelText()
    Process, Exist, %externalExeName%
    if(!ErrorLevel)
    {
        quotedExternalPath:="""" . externalPath . """"
        Run, %quotedExternalPath%,, UseErrorLevel
        if(ErrorLevel)
        {
            message:="The external application could not be started. Check its path."
            MsgBox, 0x40030, CapsLock+, %message%
            return
        }
        Sleep, 300
    }
    if(isListary)
    {
        SendInput, !{Space}
        WinWait, ahk_exe %externalExeName%, , 0.8
        if(selText!="")
        {
            selText:="gg " . selText
            SendInput, %selText%
            SendInput, {Home}
        }
    }
    else
    {
        WinWait, ahk_exe %externalExeName%, , 1.5
        WinActivate, ahk_exe %externalExeName%
    }
    return
}

; Keep the legacy function name working for existing configuration files.
keyFunc_qbarListary(){
    keyFunc_qbarExternalApp()
    return
}

; end demo


#include translate.ahk


; This function calls the Youdao translation web API to achieve free translation functionality.
; It is an unconventional method, but I hope it can give you some inspiration.
; How to use:
; 1. add below setting under the [Keys] section in `CapsLock+settings.ini`:
;   caps_f9=keyFunc_translate_cus
; 2. Save, reload Capslock+ (CapsLock+F5)
; 3. Press `CapsLock+F9` to invoke the function
keyFunc_translate_cus(){
    global
    selText:=getSelText()
    if(selText)
    {
        ydTranslate_cus(selText)
    }
    else
    {
        ClipboardOld:=ClipboardAll
        Clipboard:=""
        SendInput, ^{Left}^+{Right}^{insert}
        ClipWait, 0.05
        selText:=Clipboard
        ydTranslate_cus(selText)
        Clipboard:=ClipboardOld
    }
    SetTimer, setTransGuiActive, -400
    Return

}
