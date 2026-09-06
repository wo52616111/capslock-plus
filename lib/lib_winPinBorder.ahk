; 为 CapsLock+ 置顶的窗口绘制持续可见的边框。
; 边框由一个中间镂空、不激活、鼠标穿透的工具窗口组成，不会影响目标窗口操作。

global winPinBorders:={}
global winPinBorderGuiNames:={}
global winPinBorderSizes:={}
global winPinBorderPositions:={}
global winPinBorderVisibility:={}
global winPinBorderFrameMetrics:={}
global winPinBorderWinIds:=[]
global winPinBorderColor:="00ADEF"
global winPinBorderWidth:=6
global winPinBorderSyncInterval:=0
global winPinBorderIdleTicks:=0
global winPinBorderActiveInterval:=15
global winPinBorderIdleInterval:=50
global winPinCustomSoundFile:=""

winPinBorder_add(winId){
    global winPinBorders, winPinBorderGuiNames, winPinBorderColor, winPinBorderSizes, winPinBorderPositions, winPinBorderVisibility, winPinBorderFrameMetrics, winPinBorderWinIds, winPinBorderWidth, winPinBorderActiveInterval, winPinBorderIdleInterval, winPinBorderIdleTicks

    if(!IsObject(winPinBorders))
        winPinBorders:={}
    if(!IsObject(winPinBorderGuiNames))
        winPinBorderGuiNames:={}
    if(!IsObject(winPinBorderSizes))
        winPinBorderSizes:={}
    if(!IsObject(winPinBorderPositions))
        winPinBorderPositions:={}
    if(!IsObject(winPinBorderVisibility))
        winPinBorderVisibility:={}
    if(!IsObject(winPinBorderFrameMetrics))
        winPinBorderFrameMetrics:={}
    if(!IsObject(winPinBorderWinIds))
        winPinBorderWinIds:=[]
    if(winPinBorderColor="")
        winPinBorderColor:="00ADEF"
    if(winPinBorderWidth="")
        winPinBorderWidth:=6
    if(winPinBorderActiveInterval="")
        winPinBorderActiveInterval:=15
    if(winPinBorderIdleInterval="")
        winPinBorderIdleInterval:=50
    if(winPinBorderIdleTicks="")
        winPinBorderIdleTicks:=0
    winPinBorder_refreshSettings()
    if(!DllCall("IsWindow", "Ptr", winId))
        return false

    if(winPinBorders.HasKey(winId))
        return true

    rect:=winPinBorder_getRect(winId)
    if(!IsObject(rect))
        return false
    x:=rect.x
    y:=rect.y
    w:=rect.w
    h:=rect.h
    dpi:=rect.dpi
    thickness:=Max(2, Round(winPinBorderWidth*dpi/96))

    guiName:="WinPinBorder_" . Format("{:d}", winId+0)
    Gui, %guiName%:New, +HwndborderHwnd -Caption +ToolWindow +AlwaysOnTop +E0x20 +E0x08000000
    Gui, %guiName%:Color, %winPinBorderColor%

    ; 将边框设为目标窗口的 owned window。Windows 会保证它位于目标窗口之上，
    ; 同时把二者作为同一个 Z 顺序组处理，其他前景窗口可正常盖住整个组。
    if(A_PtrSize=8)
        DllCall("User32\SetWindowLongPtr", "Ptr", borderHwnd, "Int", -8, "Ptr", winId, "Ptr") ; GWLP_HWNDPARENT
    if(A_PtrSize!=8)
        DllCall("User32\SetWindowLong", "Ptr", borderHwnd, "Int", -8, "Ptr", winId, "Ptr")

    showOptions:="NA x" . Format("{:d}", x) . " y" . Format("{:d}", y) . " w" . Format("{:d}", w) . " h" . Format("{:d}", h)
    Gui, %guiName%:Show, %showOptions%
    winPinBorder_setRegion(borderHwnd, w, h, thickness)

    winPinBorders[winId]:=borderHwnd
    winPinBorderGuiNames[winId]:=guiName
    winPinBorderSizes[winId]:=w . "|" . h . "|" . thickness
    winPinBorderPositions[winId]:=x . "|" . y . "|" . w . "|" . h
    winPinBorderVisibility[winId]:=true
    winPinBorderWinIds.Push(winId)
    winPinBorderIdleTicks:=0
    winPinBorder_setTimerInterval(winPinBorderActiveInterval)
    return true
}

winPinBorder_remove(winId){
    global winPinBorders, winPinBorderGuiNames, winPinBorderSizes, winPinBorderPositions, winPinBorderVisibility, winPinBorderWinIds, winPinBorderSyncInterval

    if(!winPinBorders.HasKey(winId))
        return

    borderHwnd:=winPinBorders[winId]
    guiName:=winPinBorderGuiNames[winId]
    Gui, %guiName%:Destroy

    winPinBorders.Delete(winId)
    winPinBorderGuiNames.Delete(winId)
    winPinBorderSizes.Delete(winId)
    winPinBorderPositions.Delete(winId)
    winPinBorderVisibility.Delete(winId)
    Loop, % winPinBorderWinIds.Length()
    {
        if(winPinBorderWinIds[A_Index]=winId)
        {
            winPinBorderWinIds.RemoveAt(A_Index)
            break
        }
    }
    if(!winPinBorders.Count())
    {
        SetTimer, winPinBorderSyncTimer, Off
        winPinBorderSyncInterval:=0
    }
}

winPinBorder_setTimerInterval(interval){
    global winPinBorderSyncInterval, winPinBorderIdleTicks

    if(winPinBorderSyncInterval=interval)
        return
    winPinBorderSyncInterval:=interval
    if(interval>0)
        SetTimer, winPinBorderSyncTimer, %interval%
    else
        SetTimer, winPinBorderSyncTimer, Off
    if(interval>0)
        winPinBorderIdleTicks:=0
}

winPinBorder_parseColor(value){
    if(winPinBorder_tryParseColor(value, normalizedColor))
        return normalizedColor
    return "00ADEF"
}

winPinBorder_tryParseColor(value, ByRef normalizedColor){
    value:=Trim(value)
    if(RegExMatch(value, "i)^(?:#|0x)?([0-9a-f]{6})$", colorMatch))
    {
        StringUpper, normalizedColor, colorMatch1
        return true
    }

    if(RegExMatch(value, "^\s*(\d{1,3})\s*,\s*(\d{1,3})\s*,\s*(\d{1,3})\s*$", rgbMatch))
    {
        red:=rgbMatch1+0
        green:=rgbMatch2+0
        blue:=rgbMatch3+0
        if(red<=255 && green<=255 && blue<=255)
        {
            normalizedColor:=Format("{:02X}{:02X}{:02X}", red, green, blue)
            return true
        }
    }
    normalizedColor:=""
    return false
}

winPinBorder_refreshSettings(){
    global CLSets, winPinBorderColor, winPinBorders, winPinBorderGuiNames

    if(!IsObject(winPinBorders))
        winPinBorders:={}
    if(!IsObject(winPinBorderGuiNames))
        winPinBorderGuiNames:={}

    configuredColor:=""
    if(IsObject(CLSets) && IsObject(CLSets.Global))
        configuredColor:=CLSets.Global.winPinBorderColor
    newColor:=winPinBorder_parseColor(configuredColor)
    if(newColor=winPinBorderColor)
        return

    winPinBorderColor:=newColor
    for winId,borderHwnd in winPinBorders
    {
        guiName:=winPinBorderGuiNames[winId]
        Gui, %guiName%:Color, %winPinBorderColor%
        DllCall("User32\RedrawWindow", "Ptr", borderHwnd, "Ptr", 0, "Ptr", 0, "UInt", 0x105)
    }
}

winPin_playSound(isPinned, force:=false){
    static pinSoundFile:=A_WinDir . "\Media\Speech On.wav"
    static unpinSoundFile:=A_WinDir . "\Media\Speech Sleep.wav"
    global CLSets, winPinCustomSoundFile

    if(!force && IsObject(CLSets) && IsObject(CLSets.Global) && CLSets.Global.winPinSoundEnabled="0")
        return false

    configuredSoundFile:=""
    if(IsObject(CLSets) && IsObject(CLSets.Global))
        configuredSoundFile:=Trim(CLSets.Global.winPinSoundFile)
    if(configuredSoundFile!=winPinCustomSoundFile)
        winPinCustomSoundFile:=configuredSoundFile

    if(winPinCustomSoundFile!="" && FileExist(winPinCustomSoundFile))
        return DllCall("Winmm\PlaySoundW", "WStr", winPinCustomSoundFile, "Ptr", 0, "UInt", 0x20003)

    ; 异步播放期间路径缓冲区必须保持有效，因此直接传入静态变量。
    if(isPinned)
    {
        if(!FileExist(pinSoundFile))
            return false
        return DllCall("Winmm\PlaySoundW", "WStr", pinSoundFile, "Ptr", 0, "UInt", 0x20003)
    }

    if(!FileExist(unpinSoundFile))
        return false
    return DllCall("Winmm\PlaySoundW", "WStr", unpinSoundFile, "Ptr", 0, "UInt", 0x20003)
}

winPinBorder_setRegion(borderHwnd, w, h, thickness){
    outerRegion:=DllCall("Gdi32\CreateRectRgn", "Int", 0, "Int", 0, "Int", w, "Int", h, "Ptr")
    innerRegion:=DllCall("Gdi32\CreateRectRgn", "Int", thickness, "Int", thickness, "Int", Max(thickness+1, w-thickness), "Int", Max(thickness+1, h-thickness), "Ptr")

    DllCall("Gdi32\CombineRgn", "Ptr", outerRegion, "Ptr", outerRegion, "Ptr", innerRegion, "Int", 4) ; RGN_DIFF
    if(!DllCall("User32\SetWindowRgn", "Ptr", borderHwnd, "Ptr", outerRegion, "Int", true))
        DllCall("Gdi32\DeleteObject", "Ptr", outerRegion)
    DllCall("Gdi32\DeleteObject", "Ptr", innerRegion)
}

winPinBorder_shouldShow(winId){
    if(!DllCall("IsWindowVisible", "Ptr", winId))
        return false

    if(DllCall("User32\IsIconic", "Ptr", winId))
        return false

    return true
}

winPinBorder_getRect(winId){
    static rectBuffer
    global winPinBorderFrameMetrics

    VarSetCapacity(rectBuffer, 16, 0)
    if(!DllCall("User32\GetWindowRect", "Ptr", winId, "Ptr", &rectBuffer))
        return false
    rectX:=NumGet(rectBuffer, 0, "Int")
    rectY:=NumGet(rectBuffer, 4, "Int")
    rectW:=NumGet(rectBuffer, 8, "Int")-rectX
    rectH:=NumGet(rectBuffer, 12, "Int")-rectY
    if(rectW<=0 || rectH<=0)
        return false

    dpi:=DllCall("User32\GetDpiForWindow", "Ptr", winId, "UInt")
    if(!dpi)
        dpi:=A_ScreenDPI

    ; Win10/11 会在可缩放窗口四周保留一圈不可见的调整边距。
    ; 按系统边框指标向内修正，避免可见边框与窗口之间出现空隙。
    windowStyle:=DllCall("User32\GetWindowLongPtr", "Ptr", winId, "Int", -16, "Ptr")
    if(windowStyle & 0x40000) ; WS_THICKFRAME
    {
        if(!winPinBorderFrameMetrics.HasKey(dpi))
        {
            frameX:=DllCall("User32\GetSystemMetricsForDpi", "Int", 32, "UInt", dpi, "Int")
            frameY:=DllCall("User32\GetSystemMetricsForDpi", "Int", 33, "UInt", dpi, "Int")
            padded:=DllCall("User32\GetSystemMetricsForDpi", "Int", 92, "UInt", dpi, "Int")
            winPinBorderFrameMetrics[dpi]:={x:frameX+padded, y:frameY+padded}
        }
        frameX:=winPinBorderFrameMetrics[dpi].x
        frameY:=winPinBorderFrameMetrics[dpi].y
        if(frameX>0 && frameY>0)
        {
            rectX+=frameX
            rectW-=2*frameX
            rectH-=frameY
        }
    }

    if(rectW<=0 || rectH<=0)
        return false
    return {x:rectX, y:rectY, w:rectW, h:rectH, dpi:dpi}
}

winPinBorder_show(borderHwnd, show){
    showCommand:=show ? 8 : 0 ; SW_SHOWNA / SW_HIDE
    DllCall("ShowWindow", "Ptr", borderHwnd, "Int", showCommand)
}

winPinBorderSyncTimer:
winPinBorderSyncChanged:=false
winPinBorderSyncIndex:=winPinBorderWinIds.Length()
while(winPinBorderSyncIndex>=1)
{
    winPinBorderSyncWinId:=winPinBorderWinIds[winPinBorderSyncIndex]
    if(!DllCall("IsWindow", "Ptr", winPinBorderSyncWinId))
    {
        winPinBorder_remove(winPinBorderSyncWinId)
        winPinBorderSyncIndex--
        continue
    }

    winPinBorderSyncExStyle:=DllCall("User32\GetWindowLongPtr", "Ptr", winPinBorderSyncWinId, "Int", -20, "Ptr")
    if(!(winPinBorderSyncExStyle & 0x8))
    {
        winPinBorder_remove(winPinBorderSyncWinId)
        winPinBorderSyncIndex--
        continue
    }

    winPinBorderSyncHwnd:=winPinBorders[winPinBorderSyncWinId]
    if(!winPinBorder_shouldShow(winPinBorderSyncWinId))
    {
        if(winPinBorderVisibility[winPinBorderSyncWinId])
        {
            DllCall("User32\ShowWindow", "Ptr", winPinBorderSyncHwnd, "Int", 0)
            winPinBorderVisibility[winPinBorderSyncWinId]:=false
            winPinBorderSyncChanged:=true
        }
        winPinBorderSyncIndex--
        continue
    }

    winPinBorderSyncRect:=winPinBorder_getRect(winPinBorderSyncWinId)
    if(!IsObject(winPinBorderSyncRect))
    {
        winPinBorderSyncIndex--
        continue
    }

    winPinBorderSyncX:=winPinBorderSyncRect.x
    winPinBorderSyncY:=winPinBorderSyncRect.y
    winPinBorderSyncW:=winPinBorderSyncRect.w
    winPinBorderSyncH:=winPinBorderSyncRect.h
    winPinBorderSyncDpi:=winPinBorderSyncRect.dpi
    winPinBorderSyncThickness:=Max(2, Round(winPinBorderWidth*winPinBorderSyncDpi/96))

    winPinBorderSyncPositionKey:=winPinBorderSyncX . "|" . winPinBorderSyncY . "|" . winPinBorderSyncW . "|" . winPinBorderSyncH
    if(winPinBorderPositions[winPinBorderSyncWinId]!=winPinBorderSyncPositionKey)
    {
        DllCall("User32\MoveWindow", "Ptr", winPinBorderSyncHwnd+0, "Int", winPinBorderSyncX, "Int", winPinBorderSyncY, "Int", winPinBorderSyncW, "Int", winPinBorderSyncH, "Int", true)
        winPinBorderPositions[winPinBorderSyncWinId]:=winPinBorderSyncPositionKey
        winPinBorderSyncChanged:=true
    }
    if(!winPinBorderVisibility[winPinBorderSyncWinId])
    {
        DllCall("User32\ShowWindow", "Ptr", winPinBorderSyncHwnd+0, "Int", 8)
        winPinBorderVisibility[winPinBorderSyncWinId]:=true
        winPinBorderSyncChanged:=true
    }

    winPinBorderSyncSizeKey:=winPinBorderSyncW . "|" . winPinBorderSyncH . "|" . winPinBorderSyncThickness
    if(winPinBorderSizes[winPinBorderSyncWinId]!=winPinBorderSyncSizeKey)
    {
        winPinBorder_setRegion(winPinBorderSyncHwnd, winPinBorderSyncW, winPinBorderSyncH, winPinBorderSyncThickness)
        winPinBorderSizes[winPinBorderSyncWinId]:=winPinBorderSyncSizeKey
        winPinBorderSyncChanged:=true
    }
    winPinBorderSyncIndex--
}
if(winPinBorderSyncChanged)
{
    winPinBorderIdleTicks:=0
    winPinBorder_setTimerInterval(winPinBorderActiveInterval)
}
else
{
    winPinBorderIdleTicks++
    if(winPinBorderIdleTicks>=20)
        winPinBorder_setTimerInterval(winPinBorderIdleInterval)
}
return
