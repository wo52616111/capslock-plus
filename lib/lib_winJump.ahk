activateSideWin(UDLR){
    global winJumpSelected, winJumpIgnoreCount
    _sensitivity := Ceil(20/96*A_ScreenDPI) ; 灵敏度，每隔多少像素点检测一次，高分屏按dpi等比增加扫描间隔
    _deskTopExtra := 0 ; 在桌面中的话，增大移动距离
    winLastFoundId:=""
    CoordMode, Mouse, Screen
    ; 如果没有已选中的窗口，则取当前激活窗口为参照窗口
    ; 或者，如果选中的的窗口是最小化状态的 winJumpSelected
    if(!winJumpSelected){
        winHwnd := WinExist("A")
        ;  isFromActiveWin:=true
    }
    else{
        winHwnd := winJumpSelected
        ;  isFromActiveWin:=false
    }
    WinGetPos, winX, winY, winW, winH, ahk_id %winHwnd%
    MouseGetPos, mouX, mouY ; 保存原鼠标位置
    WinGetPos, , , screenW, screenH, Program Manager ; 获取全屏大小
    


    goY:=winY+winH/2
    goX:=winX+winW/2
    ;  h := screenH/2

    if(UDLR="r")
        goX:=winX+winW
    else if(UDLR="l")
        goX:=winX
    else if(UDLR="u")
        goY:=winY
    else if(UDLR="d")
        goY:=winY+winH
    else if(UDLR="fl")  ; 从最左扫描
        goX:=0
    else if(UDLR="fr")  ; 从最右扫描
        goX:=screenW
    else if(UDLR="c"){  ; 中间
        goXY:=[]
        winW1_4:=winW/4
        winH1_4:=winH/4
        ; 取窗口中等分的9个点扫描
        goXY.Insert(1, goX, goY)
        goXY.Insert(3, goX-winW1_4, goY-winH1_4)
        goXY.Insert(5, goX+winW1_4, goY+winH1_4)
        goXY.Insert(7, goX-winW1_4, goY+winH1_4)
        goXY.Insert(9, goX+winW1_4, goY-winH1_4)
        goXY.Insert(11, goX-winW1_4, goY)
        goXY.Insert(13, goX+winW1_4, goY)
        goXY.Insert(15, goX, goY-winH1_4)
        goXY.Insert(17, goX, goY+winH1_4)

        winJumpCover(winX+10, winY, 0, 0)
        winLastFoundId:=winHwnd
    }
    SystemCursor(0) ; 隐藏鼠标
    ;  msgbox, % goX . "$" . goY
    ; scaning
    loop{
        if(UDLR="r")
            goX += _sensitivity+_deskTopExtra
        else if(UDLR="l")
            goX -= _sensitivity+_deskTopExtra
        else if(UDLR="u")
            goY -= _sensitivity+_deskTopExtra
        else if(UDLR="d")
            goY += _sensitivity+_deskTopExtra
        else if(UDLR="fl")
            goX += (A_index=1?0:_sensitivity+_deskTopExtra)
        else if(UDLR="fr")
            goX -= (A_index=1?0:_sensitivity+_deskTopExtra)
        else if(UDLR="c"){

            if(A_index<=9){
                goX:=goXY[A_index*2-1]
                goY:=goXY[A_index*2]
            }else{
                winJumpCover(winX, winY, winW, winH)
                break
            }
                
            ;  scanParticleSize:=5
            ;  if(A_index<=scanParticleSize){
            ;      goX += (winW-30)/scanParticleSize
            ;      goY += (winH-30)/scanParticleSize
            ;  }else{
            ;      goX := winX+winW/scanParticleSize*(A_index-scanParticleSize-1)
            ;      goY := (winY+winH)-winH/scanParticleSize*(A_index-scanParticleSize-1)
            ;  }
            
            
        ;  ;      scanParticleSize:=5
        ;  ;      ; 从左上角扫到右下角
        ;  ;      msgbox, % goX . "@" . winX . "@" . winX+winW . "||" . goY . "@" . winY . "@" . winY+winH
        ;  ;      if(scanParticleSize>=A_index){
        ;  ;          goX := winX+winW/scanParticleSize*(A_index)
        ;  ;          goY := winY+winH/scanParticleSize*(A_index)
        ;  ;      }else{  ; 从左下角到右上角
        ;  ;          goX := winX+winW/scanParticleSize*(A_index-scanParticleSize-1)
        ;  ;          goY := (winY+winH)-winH/scanParticleSize*(A_index-scanParticleSize-1)
        ;  ;      }
            ;  msgbox, % A_index . "%" . sgoX . "@" . winX . "@" . winX+winW . "||" . goY . "@" . winY . "@" . winY+winH
            ;  if(goX<winX or goX>winX+winW or goY<winY or goY>winY+winH)
            ;      break
            ;  if(A_index>=(scanParticleSize*2))
            ;      break
        }
        ;  msgbox, % screenW . "@" . screenH

        if(UDLR!="c" and (goX<0 or goX>screenW or goY<0 or goY>screenH))
            break
        
        MouseMove, %goX%, %goY%, 0
        MouseGetPos, , , winNowId, controlClass
        ; 如果有需要忽略的窗口，则加速跳过
        if(winNowId=winLastFoundId){
            _deskTopExtra+=10
            continue
        }
        ;  msgbox, 1
        WinGetTitle, title, ahk_id %winNowId%

        ; 如果是桌面，加速跳过
        if(title="Program Manager"){
            _deskTopExtra+=10
            continue
        }

        WinGetPos, winNowX, winNowY, winNowW, winNowH, ahk_id %winNowId%
        
        ; 不是启动栏的话 
        if(controlClass!="MSTaskListWClass1"){

            ; 如果有需要跳过的窗口，跳过（若干次）
            if(winJumpIgnoreCount>0){
                winLastFoundId:=winNowId
                winJumpIgnoreCount--
                continue
            }
            ;  msgbox, cover%winJumpIgnoreCount%
            winJumpCover(winNowX, winNowY, winNowW, winNowH)
            winJumpSelected:=winNowId

            settimer, winJumpActivate, 50
            
            break
        }
        
    }
    MouseMove, mouX, mouY, 0
    SystemCursor() ; 显示鼠标
    return
}


winJumpActivate:
if(!GetKeyState("LAlt", "P") || !Capslock)
{
    ; clean
    destroyWinJumpCover()
    winJumpIgnoreCount:=0
    ; /clean
    WinSet, Top,, ahk_id %winJumpSelected%
    WinActivate, ahk_id %winJumpSelected%
    winJumpSelected:=""
    settimer, winJumpActivate, off
}
return

putWinToBottom(){
    global winJumpSelected
    ;  SendInput, !{esc}
    if(winJumpSelected)
      WinSet, Bottom,, ahk_id %winJumpSelected%
    else
      SendInput, !{esc}
}

winJumpCover(x,y,w,h){
    Gui winCover:+LastFoundExist
    IfWinExist
    {
        WinMove, , , %x%, %y%, %w%, %h%
        return
    }
    Gui, winCover:New, +HwndwinCoverHwnd
    Gui, -Caption -Disabled -Resize +ToolWindow +AlwaysOnTop
    Gui, Color, 000000
    Gui, +LastFound
    WinSet, Transparent, 100
    Gui, Show, X%x% Y%y% W%w% H%h% 
    return
}

destroyWinJumpCover(){
    Gui, winCover:Destroy
    return
}
; 跳窗的时候忽略窗口，按几下忽略几个
winJumpIgnore(){
    global winJumpIgnoreCount
    settimer, cleanWinJumpIgnore, 50
    if(!winJumpIgnoreCount)
        winJumpIgnoreCount:=1
    else
        winJumpIgnoreCount++
    ;  msgbox, % winJumpIgnoreCount
    return
}

cleanWinJumpIgnore:
if(!GetKeyState("LAlt", "P") || !Capslock)
{
    ; clean
    winJumpIgnoreCount:=0
    settimer, cleanWinJumpIgnore, off
}
return


; 窗口栈---------------
clearWinMinimizeStach(){
    global minimizeWinArr
    minimizeWinArr:={}
    return
}

popWinMinimizeStack(){
    global minimizeWinArr
    id:=minimizeWinArr.Remove()
    if(id)
        WinActivate, ahk_id %id%
}

pushWinMinimizeStack(){
    _inWinMinimizeStack()
}

unshiftWinMinimizeStack(){
    _inWinMinimizeStack(true)
}

_inWinMinimizeStack(ifInStart:=false){
    global minimizeWinArr, winJumpSelected
    if not minimizeWinArr
        minimizeWinArr:={}

    if(winJumpSelected){
        id:=winJumpSelected
        WinMinimize, ahk_id %id%

        winNowId:=WinExist("A")
        if(winNowId){
            WinGetPos, winNowX, winNowY, winNowW, winNowH, ahk_id %winNowId%
            winJumpCover(winNowX, winNowY, winNowW, winNowH)
            winJumpSelected:=winNowId
            ;  WinGetTitle, title , ahk_id %winNowId%
            ;  msgbox, % title
        }
        
    }else{
        id:=WinExist("A")
        WinMinimize, ahk_id %id%
    }
    
    if not ifInStart
        minimizeWinArr.insert(id)
    else
        minimizeWinArr.insert(1, id)
    ;  showMsg(id)
}