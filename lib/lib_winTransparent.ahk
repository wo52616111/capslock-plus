winTransparentInit:
global winTranSetting, transpWinId, allowWinTranspToggle, transp

; 窗口透明度
;  transp:=CLSets.Global.mouseSpeed

return

winTransparent(){
    if(!winTranSetting){ ; 按下按下后只有第一次生效
        winTranSetting:=true
        allowWinTranspToggle:=true

        transpWinId:=WinExist("A")

        WinGet, transp, Transparent, ahk_id %transpWinId%

        setTimer, winTranspKeyCheck, 50

        setTimer, checkIfTranspToggle, -300 ; 快速短按的话反转窗口的透明度
    }
    
    return
}


checkIfTranspToggle:
allowWinTranspToggle:=false
return

winTranspReduce:
;  if(!transp)
;      WinGet, transp, Transparent, ahk_id %transpWinId%
if(!transp)
    transp:=245
transp-=10
if(transp<15)
    transp:=15

WinSet, Transparent, %transp%, ahk_id %transpWinId%
return


winTranspAdd:
;  if(!transp)
;      WinGet, transp, Transparent, ahk_id %transpWinId%
if(!transp or transp=255)
    return

transp+=10
if(transp>255){
    transp:=255
    WinSet, Transparent, off, ahk_id %transpWinId%
    WinSet, Redraw
    return
}

WinSet, Transparent, %transp%, ahk_id %transpWinId%
return



winTranspKeyCheck:
if(!GetKeyState("f4", "P") || !Capslock){
    setTimer, checkIfTranspToggle, off ; 关闭短按切换透明度
    setTimer, winTranspKeyCheck, off
    
    if(allowWinTranspToggle){

        ;  WinGet, transp, Transparent, ahk_id %transpWinId%
        if(transp){
            WinSet, Transparent, off, ahk_id %transpWinId%
            WinSet, Redraw
        }
        else
            WinSet, Transparent, 170, ahk_id %transpWinId%
        ;  msgbox, 0
    }
    ;  msgbox,1
    winTranSetting:=false
    ;  transp:=""
}
return

#if winTranSetting

WheelUp::
;  send, 1
gosub, winTranspAdd
return

WheelDown::
;  send, 2
gosub, winTranspReduce

#if