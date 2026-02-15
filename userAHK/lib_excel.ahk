;==============================
; Excel Enhanced Functions
;==============================
; This module provides Excel-specific hotkeys and functions
; Include this file in userAHK/main.ahk

Excel_Get(){
    return GetCOMObject("ahk_class XLMAIN")
}

#IfWinActive, ahk_class XLMAIN
{
    f3::PostMessage, 0x111, 447, 0, , a

    !l::
        objExcel:=Excel_Get()
        objExcel.Application.DisplayAlerts:= false
        objExcel.ActiveWorkbook.Save
        objExcel.ActiveWorkbook.close
        objExcel.Application.DisplayAlerts:= true
        objExcel:=""
    return

    !j::send,!asa
    !k::send,!asd
    !s::Send,!ae

    !q::
        objExcel:=Excel_Get()
        objExcel.Selection.Interior.ColorIndex := 6
        objExcel.Selection.Font.ColorIndex := 3
        objExcel:=""
    return

    !a::
        try{
            objExcel:=Excel_Get()
            objExcel.Selection.Interior.ColorIndex := -4142
            objExcel.Selection.Font.ColorIndex := 1
            objExcel:=""
        }
        catch e{
            Send,!hhn
        }
    return

    !e::Send,!hac
    !w::Send,!hw
    !t::send,!wff
    !r::send,!ohr

    !g::
        try{
            objExcel:=Excel_Get()
            objExcel.Selection.ActiveSheet.UsedRange.RemoveDuplicates
            objExcel:=""
        }
        catch e{
            Send,!am
        }
    return

    !x::
        try{
            ox := ComObjActive("Excel.Application")
            ox.Application.Selection.EntireRow.AutoFit
            ox:=""
        }
        catch e{
            Send,!ora
        }
    return

    !z::
        try{
            ox := ComObjActive("Excel.Application")
            ox.Application.Selection.EntireColumn.AutoFit
            ox:=""
        }
        catch e{
            Send,!oca
        }
    return

    !c:: send,{F2}^+{Home}^c{Esc}

    !v::
        Send {Blind}{LAlt Up}
        clipboard = %clipboard%
        Sleep 100
        send,{Blind}^v
    return

    !f::
        objExcel:=Excel_Get()
        InputBox,b,批量插入行
        if(b is integer && b > 0)
        {
            loop % b
            {
                objExcel.ActiveCell.EntireRow.Insert
            }
        }
        else
        {
            MsgBox, 16, 错误, 请输入有效的正整数
        }
        objExcel:=""
    return

    !d::
        objExcel:=Excel_Get()
        InputBox,b,批量插入列
        if(b is integer && b > 0)
        {
            loop % b
            {
                objExcel.ActiveCell.EntireColumn.Insert
            }
        }
        else
        {
            MsgBox, 16, 错误, 请输入有效的正整数
        }
        objExcel:=""
    return

    !WheelUp::Send,{WheelLeft}
    !WheelDown::Send,{WheelRight}
    +WheelUp::Send,{Left}
    +WheelDown::Send,{Right}
    !Right::SendInput,^{PgDn}
    !Left::SendInput,^{PgUp}
    return
}
#IfWinActive
