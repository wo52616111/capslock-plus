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