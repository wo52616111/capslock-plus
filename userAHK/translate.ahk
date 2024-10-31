ydTranslate_cus(ss)
{
    if(CLSets.TTranslate.apiType = 0 || CLSets.TTranslate.appPaidID = "")
    {
        MsgBox, %lang_yd_free_key_unavailable_warning%
        return
    }
    transStart_cus:
    ss:=RegExReplace(ss, "\s", " ") ;把所有空白符换成空格，因为如果有回车符的话，json转换时会出错
    NativeString:=Trim(ss)

    transGui_cus:
    MsgBoxStr:=NativeString?lang_yd_translating:""

    DetectHiddenWindows, On ;可以检测到隐藏窗口
    WinGet, ifGuiExistButHide, Count, ahk_id %transGuiHwnd%
    if(ifGuiExistButHide)
    {
        ControlSetText, , %MsgBoxStr%, ahk_id %transEditHwnd%
        ControlFocus, , ahk_id %transEditHwnd%
        WinShow, ahk_id %transGuiHwnd%
    }
    else
    {
        Gui, new, +HwndtransGuiHwnd , %lang_yd_name%
        Gui, +AlwaysOnTop -Border +Caption -Disabled -LastFound -MaximizeBox -OwnDialogs -Resize +SysMenu -Theme -ToolWindow
        Gui, Font, s10 w400, Microsoft YaHei UI ;设置字体
        Gui, Font, s10 w400, 微软雅黑
        gui, Add, Button, x-40 y-40 Default, OK  
        Gui, Add, Edit, x-2 y0 w504 h405 vTransEdit HwndtransEditHwnd -WantReturn -VScroll , %MsgBoxStr%
        Gui, Color, ffffff, fefefe
        Gui, +LastFound
        WinSet, TransColor, ffffff 210
        Gui, Show, Center w500 h402, %lang_yd_name%
        ControlFocus, , ahk_id %transEditHwnd%
        SetTimer, setTransActive, 50
    }

    if(NativeString)
    {
        SetTimer, ydApi_cus, -1
        return
    }

    Return

    ydApi_cus:
    UTF8Codes:="" ;重置要发送的代码
    SetFormat, integer, H
    UTF8Codes:=UTF8encode(NativeString)
    if(youdaoApiString="")
    {
        MsgBoxStr=%lang_yd_needKey%
        goto, setTransText_cus
    }

    sendStr := "https://dict.youdao.com/suggest?num=6&ver=3.0&doctype=json&cache=false&le=en&q=" . UTF8encode(NativeString)
    whr := ComObjCreate("Msxml2.XMLHTTP")
    whr.Open("GET", sendStr, False)

    try
    {
        whr.Send()
    }
    catch
    {
        MsgBoxStr:=lang_yd_errorNoNet
        goto, setTransText_cus
    }

    responseStr := whr.ResponseText
    transJson := JSON.Load(responseStr)

    if (transJson.result.code != 200)
    {
        MsgBoxStr := lang_yd_errorNoResults
        goto, setTransText_cus
        return
    }

    MsgBoxStr := transJson.data.query . "`r`n`r`n"
    for index, entry in transJson.data.entries
    {
        MsgBoxStr := MsgBoxStr . entry.entry . ": " . entry.explain . "`r`n`r`n"
    }

    setTransText_cus:
    ControlSetText, , %MsgBoxStr%, ahk_id %transEditHwnd%
    ControlFocus, , ahk_id %transEditHwnd%
    SetTimer, setTransActive, 50
    return 

    ButtonOK_cus:
    Gui, Submit, NoHide
    TransEdit:=RegExReplace(TransEdit, "\s", " ") ;把所有空白符换成空格，因为如果有回车符的话，json转换时会出错
    NativeString:=Trim(TransEdit)
    goto, transGui_cus

    return
}