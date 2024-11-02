; 'https://dict.youdao.com/jsonapi_s?doctype=json&jsonversion=4'
; 'q=i%20am%20sorry&le=en&t=7&client=web&sign=d1d46a696e94826a992dccc7592827ea&keyfrom=webdict'

; l = {
;     q: NativeString,
;     le: en,
;     t: (NativeString.length + "webdict".length) % 10,
;     client: "web",
;     sign: ,
;     keyfrom: "webdict"
; }

ydTranslate_cus(ss)
{
    ss:=RegExReplace(ss, "\s+", " ") ;把所有空白符换成空格，因为如果有回车符的话，json转换时会出错
    NativeString:=Trim(ss)
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

    signString := NativeString . "webdict"
    tempSign := bcrypt.hash(signString, "MD5")
    ; MsgBox, , , %tempSign%, 

    t := Mod(StrLen(NativeString) + StrLen("webdict"), 10)

    n := "web" . NativeString . t . "Mk6hqtUp33DGGtoS63tTJbMUYjRrG1Lu" . tempSign
    sign := bcrypt.hash(n, "MD5")
    ; MsgBox, , , %sign%,


    whr := ComObjCreate("Msxml2.XMLHTTP")
    whr.Open("POST", "https://dict.youdao.com/jsonapi_s?doctype=json&jsonversion=4", False)
    whr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded")
    body := "q=" . UTF8encode(NativeString) . "&le=en&t=" . t . "&client=web&sign=" . sign . "&keyfrom=webdict"
    ; MsgBox,  ,  , %body%,  

    try
    {
        whr.Send(body)
    }
    catch
    {
        MsgBoxStr:= lang_yd_errorNoNet
        goto, setTransText_cus
    }

    responseStr := whr.ResponseText
    transJson := JSON.Load(responseStr)

    MsgBoxStr := NativeString

    if(transJson.fanyi){
        MsgBoxStr := % MsgBoxStr . "`r`n`r`n" . lang_yd_trans . "`r`n`r`n" ;分隔，换行
        MsgBoxStr := % MsgBoxStr . transJson.fanyi.tran . "`r`n`r`n"

        goto, setTransText_cus
    }

    if(transJson.ec){
        if(transJson.ec.word.usphone){
            MsgBoxStr := % MsgBoxStr . "      " . "[" . transJson.ec.word.usphone . "] "  ;读音
        }

        if(transJson.ec.word.ukphone){
            MsgBoxStr := % MsgBoxStr . "      " . "[" . transJson.ec.word.ukphone . "] "  ;读音
        }

        MsgBoxStr := % MsgBoxStr . "`r`n`r`n" . lang_yd_trans . "`r`n`r`n" ;分隔，换行

        for index , web_tran in transJson.ec.web_trans
        {
            if(index > 1) {
                MsgBoxStr:=% MsgBoxStr . A_Space . ";" . A_Space
            }

            MsgBoxStr := % MsgBoxStr . web_tran
        }

        if(transJson.phrs){
            MsgBoxStr := % MsgBoxStr . "`r`n`r`n" . lang_yd_phrase . "`r`n`r`n" ;分隔，换行

            for index, entry in transJson.phrs.phrs
            {
                MsgBoxStr := MsgBoxStr . entry.headword . ": " . entry.translation . "`r`n`r`n"
            }
        }

        goto, setTransText_cus
    }

    MsgBoxStr := lang_yd_errorNoResults

    setTransText_cus:
    ControlSetText, , %MsgBoxStr%, ahk_id %transEditHwnd%
    ControlFocus, , ahk_id %transEditHwnd%
    return 
}