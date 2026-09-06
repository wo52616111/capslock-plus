; 为 CapsLock+ 置顶的窗口绘制持续可见的边框。
; 边框由一个中间镂空、不激活、鼠标穿透的工具窗口组成，不会影响目标窗口操作。

global winPinBorders:={}
global winPinBorderSizes:={}
global winPinBorderPositions:={}
global winPinBorderWinIds:=[]
global winPinBorderColor:="00ADEF"
global winPinBorderWidth:=6

winPinBorder_add(winId){
    global winPinBorders, winPinBorderColor, winPinBorderSizes, winPinBorderPositions, winPinBorderWinIds, winPinBorderWidth

    if(!IsObject(winPinBorders))
        winPinBorders:={}
    if(!IsObject(winPinBorderSizes))
        winPinBorderSizes:={}
    if(!IsObject(winPinBorderPositions))
        winPinBorderPositions:={}
    if(!IsObject(winPinBorderWinIds))
        winPinBorderWinIds:=[]
    if(winPinBorderColor="")
        winPinBorderColor:="00ADEF"
    if(winPinBorderWidth="")
        winPinBorderWidth:=6
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
    dpi:=DllCall("User32\GetDpiForWindow", "Ptr", winId, "UInt")
    if(!dpi)
        dpi:=A_ScreenDPI
    thickness:=Max(2, Round(winPinBorderWidth*dpi/96))

    guiName:="WinPinBorder_" . winId
    Gui, %guiName%:New, +HwndborderHwnd -Caption +ToolWindow +AlwaysOnTop +E0x20 +E0x08000000
    Gui, %guiName%:Color, %winPinBorderColor%

    ; 将边框设为目标窗口的 owned window。Windows 会保证它位于目标窗口之上，
    ; 同时把二者作为同一个 Z 顺序组处理，其他前景窗口可正常盖住整个组。
    if(A_PtrSize=8)
        DllCall("User32\SetWindowLongPtr", "Ptr", borderHwnd, "Int", -8, "Ptr", winId, "Ptr") ; GWLP_HWNDPARENT
    if(A_PtrSize!=8)
        DllCall("User32\SetWindowLong", "Ptr", borderHwnd, "Int", -8, "Ptr", winId, "Ptr")

    Gui, %guiName%:Show, NA x%x% y%y% w%w% h%h%
    winPinBorder_setRegion(borderHwnd, w, h, thickness)

    winPinBorders[winId]:=borderHwnd
    winPinBorderSizes[winId]:=w . "|" . h . "|" . thickness
    winPinBorderPositions[winId]:=x . "|" . y . "|" . w . "|" . h
    winPinBorderWinIds.Push(winId)
    SetTimer, winPinBorderSyncTimer, 10
    return true
}

winPinBorder_remove(winId){
    global winPinBorders, winPinBorderSizes, winPinBorderPositions, winPinBorderWinIds

    if(!winPinBorders.HasKey(winId))
        return

    borderHwnd:=winPinBorders[winId]
    Gui, %borderHwnd%:Destroy

    winPinBorders.Delete(winId)
    winPinBorderSizes.Delete(winId)
    winPinBorderPositions.Delete(winId)
    Loop, % winPinBorderWinIds.Length()
    {
        if(winPinBorderWinIds[A_Index]=winId)
        {
            winPinBorderWinIds.RemoveAt(A_Index)
            break
        }
    }
    if(!winPinBorders.Count())
        SetTimer, winPinBorderSyncTimer, Off
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

    VarSetCapacity(rectBuffer, 16, 0)
    if(!DllCall("User32\GetWindowRect", "Ptr", winId, "Ptr", &rectBuffer))
        return false
    rectX:=NumGet(rectBuffer, 0, "Int")
    rectY:=NumGet(rectBuffer, 4, "Int")
    rectW:=NumGet(rectBuffer, 8, "Int")-rectX
    rectH:=NumGet(rectBuffer, 12, "Int")-rectY
    if(rectW<=0 || rectH<=0)
        return false

    ; Win10/11 会在可缩放窗口四周保留一圈不可见的调整边距。
    ; 按系统边框指标向内修正，避免可见边框与窗口之间出现空隙。
    windowStyle:=DllCall("User32\GetWindowLongPtr", "Ptr", winId, "Int", -16, "Ptr")
    if(windowStyle & 0x40000) ; WS_THICKFRAME
    {
        dpi:=DllCall("User32\GetDpiForWindow", "Ptr", winId, "UInt")
        if(!dpi)
            dpi:=A_ScreenDPI
        frameX:=DllCall("User32\GetSystemMetricsForDpi", "Int", 32, "UInt", dpi, "Int")
        frameY:=DllCall("User32\GetSystemMetricsForDpi", "Int", 33, "UInt", dpi, "Int")
        padded:=DllCall("User32\GetSystemMetricsForDpi", "Int", 92, "UInt", dpi, "Int")
        if(frameX>0 && frameY>0)
        {
            frameX+=padded
            frameY+=padded
            rectX+=frameX
            rectW-=2*frameX
            rectH-=frameY
        }
    }

    if(rectW<=0 || rectH<=0)
        return false
    return {x:rectX, y:rectY, w:rectW, h:rectH}
}

winPinBorder_show(borderHwnd, show){
    showCommand:=show ? 8 : 0 ; SW_SHOWNA / SW_HIDE
    DllCall("ShowWindow", "Ptr", borderHwnd, "Int", showCommand)
}

winPinBorderSyncTimer:
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
    winPinBorderSyncRect:=winPinBorder_getRect(winPinBorderSyncWinId)
    if(!winPinBorder_shouldShow(winPinBorderSyncWinId) || !IsObject(winPinBorderSyncRect))
    {
        DllCall("User32\ShowWindow", "Ptr", winPinBorderSyncHwnd, "Int", 0)
        winPinBorderSyncIndex--
        continue
    }

    winPinBorderSyncX:=winPinBorderSyncRect.x
    winPinBorderSyncY:=winPinBorderSyncRect.y
    winPinBorderSyncW:=winPinBorderSyncRect.w
    winPinBorderSyncH:=winPinBorderSyncRect.h
    winPinBorderSyncDpi:=DllCall("User32\GetDpiForWindow", "Ptr", winPinBorderSyncWinId, "UInt")
    if(!winPinBorderSyncDpi)
        winPinBorderSyncDpi:=A_ScreenDPI
    winPinBorderSyncThickness:=Max(2, Round(winPinBorderWidth*winPinBorderSyncDpi/96))

    winPinBorderSyncPositionKey:=winPinBorderSyncX . "|" . winPinBorderSyncY . "|" . winPinBorderSyncW . "|" . winPinBorderSyncH
    if(winPinBorderPositions[winPinBorderSyncWinId]!=winPinBorderSyncPositionKey)
    {
        DllCall("User32\MoveWindow", "Ptr", winPinBorderSyncHwnd+0, "Int", winPinBorderSyncX, "Int", winPinBorderSyncY, "Int", winPinBorderSyncW, "Int", winPinBorderSyncH, "Int", true)
        winPinBorderPositions[winPinBorderSyncWinId]:=winPinBorderSyncPositionKey
    }
    if(!DllCall("User32\IsWindowVisible", "Ptr", winPinBorderSyncHwnd+0))
        DllCall("User32\ShowWindow", "Ptr", winPinBorderSyncHwnd+0, "Int", 8)

    winPinBorderSyncSizeKey:=winPinBorderSyncW . "|" . winPinBorderSyncH . "|" . winPinBorderSyncThickness
    if(winPinBorderSizes[winPinBorderSyncWinId]!=winPinBorderSyncSizeKey)
    {
        winPinBorder_setRegion(winPinBorderSyncHwnd, winPinBorderSyncW, winPinBorderSyncH, winPinBorderSyncThickness)
        winPinBorderSizes[winPinBorderSyncWinId]:=winPinBorderSyncSizeKey
    }
    winPinBorderSyncIndex--
}
return
