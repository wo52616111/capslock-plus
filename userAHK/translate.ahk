ydTranslate_cus(ss)
{
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
    }

    if(NativeString)
    {
        SetTimer, ydApi_cus, -1
        return
    }

    Return

    ydApi_cus:
    SetFormat, integer, H

    ; 获取音标
    sendStr2 := "https://dict.youdao.com/jsonapi_s?doctype=json&jsonversion=4&le=en&q=" . UTF8encode(NativeString)
    whr2 := ComObjCreate("Msxml2.XMLHTTP")
    whr2.Open("GET", sendStr2, False)

    try
    {
        whr2.Send()
    }
    catch
    {
        MsgBoxStr:=MsgBoxStr . lang_yd_errorNoNet
        goto, setTransText_cus
    }

    responseStr2 := whr2.ResponseText
    transJson2 := JSON.Load(responseStr2)

    if (transJson2.simple.query != NativeString)
    {
        MsgBoxStr := MsgBoxStr . lang_yd_errorNoResults
        goto, setTransText_cus
        return
    }

    MsgBoxStr:= % transJson2.simple.query . "`t"   ;原单词
    if (transJson2.simple.word[1].ukphone)
    {
        ; MsgBoxStr := MsgBoxStr . "UK Phonetic: " . transJson2.simple.word[1].ukphone . "`r`n`r`n"
        MsgBoxStr:=% MsgBoxStr . "[" . transJson2.simple.word[1].ukphone . "] "  ;读音
    }
    MsgBoxStr:= % MsgBoxStr . "`r`n`r`n" . lang_yd_trans . "`r`n" ;分隔，换行

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

    ; MsgBoxStr := transJson.data.query . "`r`n`r`n"
    for index, entry in transJson.data.entries
    {
        MsgBoxStr := MsgBoxStr . entry.entry . ": " . entry.explain . "`r`n`r`n"
    }

    setTransText_cus:
    ControlSetText, , %MsgBoxStr%, ahk_id %transEditHwnd%
    ControlFocus, , ahk_id %transEditHwnd%
    return 

}