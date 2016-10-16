mouseSpeedInit:
global mouseSpeed,OrigMouseSpeed,SPI_GETMOUSESPEED,SPI_SETMOUSESPEED
SPI_GETMOUSESPEED = 0x70
SPI_SETMOUSESPEED = 0x71


mouseSpeed:=CLSets.Global.mouseSpeed!=""?CLSets.Global.mouseSpeed:3
if(mouseSpeed<1)
{
    mouseSpeed:=1
    setSettings("Global","mouseSpeed",mouseSpeed)    
}
else if(mouseSpeed>20)
{
    mouseSpeed:=20
    setSettings("Global","mouseSpeed",mouseSpeed)
}
return

;改变鼠标速度
changeMouseSpeed:
{
    if(GetKeyState("LAlt", "P"))
    {
        ; 获取鼠标当前的速度以便稍后恢复:
        DllCall("SystemParametersInfo", UInt, SPI_GETMOUSESPEED, UInt, 0, UIntP, OrigMouseSpeed, UInt, 0)
        settimer, stopChangeMouseSpeed, 50
        ; 在倒数第3个参数中设置速度 (范围为 1-20):
        ;  sendinput, % origmouseSpeed
        DllCall("SystemParametersInfo", UInt, SPI_SETMOUSESPEED, UInt, 0, Ptr, mouseSpeed, UInt, 0)
        settimer, changeMouseSpeed, off
    }
    ;如果Capslock松开
    if(!Capslock)
    {
        settimer, changeMouseSpeed, off
    }
    return
}

stopChangeMouseSpeed:
if(!GetKeyState("LAlt", "P") || !Capslock)
{
    settimer, stopChangeMouseSpeed, off
    ;  sendinput, aaa%OrigMouseSpeed%
    DllCall("SystemParametersInfo", UInt, 0x71, UInt, 0, Ptr, OrigMouseSpeed, UInt, 0)  ; 恢复原来的速度.
    if(Capslock)   ;如果放开alt的时候caps还没放开，就再回去changeMouseSpeed继续监视Alt有没再次按下
    {
        settimer, changeMouseSpeed, 50
    }
}
return