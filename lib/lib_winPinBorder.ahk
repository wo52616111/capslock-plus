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
global winPinBorderIdleInterval:=100
global winPinCustomSoundFile:=""
global winPinBorderLocationHook:=0
global winPinBorderLocationCallback:=0
global winPinBorderEventSyncPending:=false
global winPinBorderNewHwnd:=0

winPinBorder_add(winId){
    local
    global winPinBorders, winPinBorderGuiNames, winPinBorderColor, winPinBorderSizes, winPinBorderPositions, winPinBorderVisibility, winPinBorderFrameMetrics, winPinBorderWinIds, winPinBorderWidth, winPinBorderActiveInterval, winPinBorderIdleInterval, winPinBorderIdleTicks, winPinBorderNewHwnd
    local rect, thickness, borderHwnd, frameLeft, frameTop, frameWidth, frameHeight

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
        winPinBorderIdleInterval:=100
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
    thickness:=rect.thickness
    frameLeft:=rect.frameLeft
    frameTop:=rect.frameTop
    frameWidth:=rect.frameWidth
    frameHeight:=rect.frameHeight
    ; 与 PowerToys 一样，以 DWM 返回的可见窗口边界为基准，边框向外展开。
    ; 内孔正好等于目标窗口的可见区域，因此不会压住窗口内容，也不会留下阴影间隙。
    ; 当前边框由普通 GUI 背景色绘制，不能使用 WS_EX_NOREDIRECTIONBITMAP；
    ; 否则 DWM 不会为窗口建立可见的重定向表面。
    winPinBorderNewHwnd:=0
    Gui, New, -Caption +ToolWindow +AlwaysOnTop +Disabled +E0x20 +HwndwinPinBorderNewHwnd
    borderHwnd:=winPinBorderNewHwnd
    Gui, Color, %winPinBorderColor%
    ; 先让 AHK 完成底层窗口初始化，但保持隐藏；随后由 Win32 API 按物理像素显示。
    Gui, Show, Hide x0 y0 w1 h1

    winPinBorders[winId]:=borderHwnd
    winPinBorderGuiNames[winId]:=borderHwnd
    ; AHK 函数线程内对刚创建 GUI 的定位/显示可能不会立即落地。
    ; 留空缓存并交给顶层同步标签完成首次定位、裁剪和显示。
    winPinBorderSizes[winId]:=""
    winPinBorderPositions[winId]:=""
    winPinBorderVisibility[winId]:=false
    winPinBorderWinIds.Push(winId)
    winPinBorderIdleTicks:=0
    winPinBorder_ensureEventHook()
    winPinBorder_setTimerInterval(winPinBorderActiveInterval)
    SetTimer, winPinBorderEventSyncTimer, -1
    return true
}

winPinBorder_remove(winId){
    global winPinBorders, winPinBorderGuiNames, winPinBorderSizes, winPinBorderPositions, winPinBorderVisibility, winPinBorderWinIds, winPinBorderSyncInterval

    if(!winPinBorders.HasKey(winId))
        return

    borderHwnd:=winPinBorders[winId]
    DllCall("User32\DestroyWindow", "Ptr", borderHwnd)

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
        winPinBorder_stopEventHook()
    }
}

winPinBorder_setTimerInterval(interval){
    global winPinBorderSyncInterval, winPinBorderIdleTicks

    if(winPinBorderSyncInterval=interval)
        return
    winPinBorderSyncInterval:=interval
    if(interval>0)
        SetTimer, winPinBorderSyncTimer, % interval
    else
        SetTimer, winPinBorderSyncTimer, Off
    if(interval>0)
        winPinBorderIdleTicks:=0
}

winPinBorder_ensureEventHook(){
    global winPinBorderLocationHook, winPinBorderLocationCallback

    if(winPinBorderLocationHook)
        return true
    if(!winPinBorderLocationCallback)
        winPinBorderLocationCallback:=RegisterCallback("winPinBorder_winEventProc", "", 7)
    if(!winPinBorderLocationCallback)
        return false

    ; EVENT_OBJECT_LOCATIONCHANGE。由系统在窗口移动/缩放时主动通知，
    ; 避免单纯依赖 AHK 定时器造成边框落后一帧或数帧。
    winPinBorderLocationHook:=DllCall("User32\SetWinEventHook", "UInt", 0x800B, "UInt", 0x800B, "Ptr", 0, "Ptr", winPinBorderLocationCallback, "UInt", 0, "UInt", 0, "UInt", 0, "Ptr")
    return winPinBorderLocationHook ? true : false
}

winPinBorder_stopEventHook(){
    global winPinBorderLocationHook

    if(winPinBorderLocationHook)
    {
        DllCall("User32\UnhookWinEvent", "Ptr", winPinBorderLocationHook)
        winPinBorderLocationHook:=0
    }
}

winPinBorder_winEventProc(hWinEventHook, event, hwnd, idObject, idChild, eventThread, eventTime){
    global winPinBorders, winPinBorderIdleTicks, winPinBorderEventSyncPending

    ; OBJID_WINDOW=0、CHILDID_SELF=0。过滤光标和子控件的位置变化事件。
    if(event!=0x800B || !hwnd || idObject!=0 || idChild!=0)
        return
    if(!IsObject(winPinBorders) || !winPinBorders.HasKey(hwnd))
        return

    ; AHK 回调线程内直接移动边框 GUI 可能被系统忽略。只投递一个立即执行的
    ; 顶层定时任务，在目标窗口的位置消息处理完毕后同步边框。
    winPinBorderIdleTicks:=0
    if(!winPinBorderEventSyncPending)
    {
        winPinBorderEventSyncPending:=true
        SetTimer, winPinBorderEventSyncTimer, -1
    }
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
    static selectedBorderHwnd
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
        selectedBorderHwnd:=borderHwnd
        Gui, %selectedBorderHwnd%:Default
        Gui, Color, %winPinBorderColor%
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

winPinBorder_setRegion(borderHwnd, w, h, thickness, cornerRadius:=0){
    if(cornerRadius>0)
    {
        outerRadius:=cornerRadius+thickness
        outerDiameter:=Max(2, 2*outerRadius)
        innerDiameter:=Max(2, 2*cornerRadius)
        outerRegion:=DllCall("Gdi32\CreateRoundRectRgn", "Int", 0, "Int", 0, "Int", w, "Int", h, "Int", outerDiameter, "Int", outerDiameter, "Ptr")
        innerRegion:=DllCall("Gdi32\CreateRoundRectRgn", "Int", thickness, "Int", thickness, "Int", Max(thickness+1, w-thickness), "Int", Max(thickness+1, h-thickness), "Int", innerDiameter, "Int", innerDiameter, "Ptr")
    }
    else
    {
        outerRegion:=DllCall("Gdi32\CreateRectRgn", "Int", 0, "Int", 0, "Int", w, "Int", h, "Ptr")
        innerRegion:=DllCall("Gdi32\CreateRectRgn", "Int", thickness, "Int", thickness, "Int", Max(thickness+1, w-thickness), "Int", Max(thickness+1, h-thickness), "Ptr")
    }

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
    global winPinBorderFrameMetrics, winPinBorderWidth

    VarSetCapacity(rectBuffer, 16, 0)
    ; PowerToys 使用 DWMWA_EXTENDED_FRAME_BOUNDS：它排除了 Windows 10/11
    ; 为缩放和阴影保留的不可见边距，比按系统指标估算更贴合实际窗口轮廓。
    dwmResult:=DllCall("Dwmapi\DwmGetWindowAttribute", "Ptr", winId, "UInt", 9, "Ptr", &rectBuffer, "UInt", 16, "Int")
    usedDwmBounds:=(dwmResult=0)
    if(!usedDwmBounds && !DllCall("User32\GetWindowRect", "Ptr", winId, "Ptr", &rectBuffer))
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

    ; 仅在 DWM API 不可用时保留原来的系统指标回退。
    if(!usedDwmBounds)
    {
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
    }

    if(rectW<=0 || rectH<=0)
        return false
    cornerRadius:=winPinBorder_getCornerRadius(winId, dpi)
    thickness:=Max(2, Round(winPinBorderWidth*dpi/96))
    frameLeft:=rectX-thickness
    frameTop:=rectY-thickness
    frameWidth:=rectW+2*thickness
    frameHeight:=rectH+2*thickness
    return {"left":rectX, "top":rectY, "width":rectW, "height":rectH, "dpi":dpi, "cornerRadius":cornerRadius
        , "thickness":thickness, "frameLeft":frameLeft, "frameTop":frameTop, "frameWidth":frameWidth, "frameHeight":frameHeight}
}

winPinBorder_getCornerRadius(winId, dpi){
    local
    local preference, logicalRadius

    if(DllCall("User32\IsZoomed", "Ptr", winId))
        return 0

    preference:=0
    ; DWMWA_WINDOW_CORNER_PREFERENCE=33，仅 Windows 11 支持。
    dwmResult:=DllCall("Dwmapi\DwmGetWindowAttribute", "Ptr", winId, "UInt", 33, "UInt*", preference, "UInt", 4, "Int")
    if(dwmResult)
        return 0
    if(preference=1) ; DWMWCP_DONOTROUND
        return 0
    logicalRadius:=preference=3 ? 4 : 8 ; ROUND_SMALL / DEFAULT or ROUND
    return Max(1, Round(logicalRadius*dpi/96))
}

winPinBorder_show(borderHwnd, show){
    showCommand:=show ? 8 : 0 ; SW_SHOWNA / SW_HIDE
    DllCall("ShowWindow", "Ptr", borderHwnd, "Int", showCommand)
}

winPinBorderEventSyncTimer:
winPinBorderEventSyncPending:=false
Gosub, winPinBorderSyncTimer
return

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
    winPinBorderSyncThickness:=winPinBorderSyncRect.thickness
    winPinBorderSyncRadius:=winPinBorderSyncRect.cornerRadius
    winPinBorderSyncLeft:=winPinBorderSyncRect.frameLeft
    winPinBorderSyncTop:=winPinBorderSyncRect.frameTop
    winPinBorderSyncWidth:=winPinBorderSyncRect.frameWidth
    winPinBorderSyncHeight:=winPinBorderSyncRect.frameHeight
    winPinBorderSyncPositionKey:=winPinBorderSyncLeft . "|" . winPinBorderSyncTop . "|" . winPinBorderSyncWidth . "|" . winPinBorderSyncHeight

    if(winPinBorderPositions[winPinBorderSyncWinId]!=winPinBorderSyncPositionKey)
    {
        if(DllCall("User32\SetWindowPos", "Ptr", winPinBorderSyncHwnd, "Ptr", -1, "Int", winPinBorderSyncLeft, "Int", winPinBorderSyncTop, "Int", winPinBorderSyncWidth, "Int", winPinBorderSyncHeight, "UInt", 0x10)) ; HWND_TOPMOST, SWP_NOACTIVATE
        {
            winPinBorderPositions[winPinBorderSyncWinId]:=winPinBorderSyncPositionKey
            winPinBorderSyncChanged:=true
        }
    }
    winPinBorderSyncSizeKey:=winPinBorderSyncWidth . "|" . winPinBorderSyncHeight . "|" . winPinBorderSyncThickness . "|" . winPinBorderSyncRadius
    if(winPinBorderSizes[winPinBorderSyncWinId]!=winPinBorderSyncSizeKey)
    {
        winPinBorder_setRegion(winPinBorderSyncHwnd, winPinBorderSyncWidth, winPinBorderSyncHeight, winPinBorderSyncThickness, winPinBorderSyncRadius)
        winPinBorderSizes[winPinBorderSyncWinId]:=winPinBorderSyncSizeKey
        winPinBorderSyncChanged:=true
    }
    if(!winPinBorderVisibility[winPinBorderSyncWinId])
    {
        DllCall("User32\ShowWindow", "Ptr", winPinBorderSyncHwnd, "Int", 8)
        winPinBorderVisibility[winPinBorderSyncWinId]:=true
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
