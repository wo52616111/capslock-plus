;为了避免在IDE里Ctrl+C会复制一行，写个函数来获取
getSelText_testVersion()
{
    ClipboardOld:=ClipboardAll
    Clipboard:=""
    SendInput, +{Left}^{c}+{Right}
    ClipWait, 0.1
    if(!ErrorLevel)
    {
        selText:=Clipboard
        Clipboard:=ClipboardOld
        ;~ MsgBox, % "@" . Asc(selText) . "@"
        ;~ MsgBox, % StrLen(selText)
        if(Asc(selText)!=13&&StrLen(selText)>1)
        {
            return SubStr(selText, 2)
        }
        else
        {
            return
        }
    }
    Clipboard:=ClipboardOld
    return
}


getSelText()
{
    ClipboardOld:=ClipboardAll
    Clipboard:=""
    SendInput, ^{insert}
    ClipWait, 0.1
    if(!ErrorLevel)
    {
        selText:=Clipboard
        Clipboard:=ClipboardOld
        StringRight, lastChar, selText, 1
        if(Asc(lastChar)!=10) ;如果最后一个字符是换行符，就认为是在IDE那复制了整行，不要这个结果
        {
            return selText
        }
    }
    Clipboard:=ClipboardOld
    return
}

UTF8encode(str) ;UTF8转码
{
    SetFormat, integer, h
    returnStr:=""
    StrCap := StrPut(str, "CP65001")
    VarSetCapacity(UTF8String, StrCap)
    StrPut(str, &UTF8String, "CP65001")

    Loop, % StrCap - 1   ;StrPut 返回的长度中包含末尾的字符串截止符，因此必须减 1。
    {
        returnStr .= "%"SubStr(NumGet(UTF8String, A_Index - 1, "UChar"), 3) ; 逐字节获取，去除开头的“0x”后在前面加上"%"连接起来。
    }
    ;~ MsgBox, % returnStr ; 显示“E4B8AD”，前面附加“0x”就变成十六进制了。
    return returnStr
}

URLencode(str) ;用于链接的话只要符号转换就行。需要全部转换的，用UTF8encode()
{
    local arr1:=["!","#","$","&","'","(",")","*","+",",",":",";","=","?","@","[","]"], ;"/",
          arr2:=["%21","%23","%24","%26","%27","%28","%29","%2a","%2b","%2c","%3a","%3b","%3d","%3f","%40","%5b","%5d"] ;"%2f",

    loop, % arr1.MaxIndex()
    {
        StringReplace, str, str, % arr1[A_Index], % arr2[A_Index], All 
    }
    ; MsgBox, % str
    return str
}


checkStrType(str, fuzzy:=0)
{
    if(!FileExist(str))
    {
        ;  msgbox, % str
        if(RegExMatch(str,"iS)^((https?:\/\/)|www\.)([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?|(https?:\/\/)?([\da-z\.-]+)\.(com|net|org)(\W[\/\w \.-]*)*\/?$"))
            return "web"
    }
    if(RegExMatch(str, "i)^ftp://"))
        return "ftp"
    else
    {
        if(fuzzy)
            return "fileOrFolder"
        if(RegExMatch(str,"iS)^[a-z]:\\.+\..+$"))
            return "file"
        if(RegExMatch(str,"iS)^[a-z]:\\[^.]*$"))
            return "folder"
    }
    return "unknown"
}

;winset, region窗口切割功能在放大了屏幕后(也就是dpi改变)不会改变，这里用来修复这个问题
;  100%dpi：96
;  125%dpi：120
;  150%dpi：144
;  200%dpi：192
;  250%dpi：240
;  300%dpi：288
;  400%dpi：384
;  500%dpi：480
fixDpi(num)
{
    ;msgbox, % Ceil(1/96*A_ScreenDPI)
    t:=Ceil(num/96*A_ScreenDPI)
    if(A_ScreenDPI>96 && A_ScreenDPI<=120)  ;125%
        t+=1
    if(A_ScreenDPI>120 && A_ScreenDPI<=144) ;150
        t+=1
    if(A_ScreenDPI>144 && A_ScreenDPI<=192) ;200%
        t+=2
    if(A_ScreenDPI>192 && A_ScreenDPI<=240) ;250
        t+=3
    if(A_ScreenDPI>240 && A_ScreenDPI<=288) ;300%
        t+=4
    if(A_ScreenDPI>288) ; && A_ScreenDPI<=384 >=400%
        t+=6
    return t
}



;保存设置到settings.ini
setSettings(sec,key,val)
{
    IniWrite, % val, CapsLock+settings.ini, %sec%, % key
}

;显示一个信息
showMsg(msg,t)
{
    ToolTip, % msg
    t:=-t
    settimer, clearToolTip, % t
}

clearToolTip:
ToolTip
return


;提取Set里QRun的信息
;返回文件路径，runStr为供run运行的字符串，ifAdmin是否管理员权限运行，param程序运行参数
extractSetStr(str, ByRef runStr:="", ByRef ifAdmin:=false, ByRef param:="")
{
    str:=Trim(str, " `t")

    ;如果有系统变量，替换成实际路径
	if(!RegExMatch(str, "^%(\w+)%", str0Match))
		RegExMatch(str, "(?<=(?:'|""))%(\w+)%", str0Match)
	if(str0Match1)
	{
		EnvGet, _t, % str0Match1
		StringReplace, str, str, % str0Match, % _t
	}
	
	;没有引号且文件存在，例：C:\Program Files\Internet Explorer\iexplore.exe
    ;或者是ftp路径
    if(FileExist(str)||RegExMatch(str, "^ftp://"))
	{
		runStr:=str
        return str
	}

	
	;有引号且文件存在，例："C:\Program Files\Internet Explorer\iexplore.exe"
	RegExMatch(str, "^('|"")(.*)\1$", strMatch)
	if(FileExist(strMatch2)||RegExMatch(str, "^ftp://"))
	{
		runStr:=str
		return strMatch2
    }
	
	RegExMatch(str, "('|"")(.*)\1", strMatch)
	if(FileExist(strMatch2))
	{
		runStr:=strMatch
		;判断是否管理员权限
		strArr:=StrSplit(str, strMatch)
		arr1:=Trim(strArr[1])
		arr2:=Trim(strArr[2])
        
		if(RegExMatch(arr1,"i)^\*RunAs$"))
		{
			ifAdmin:=true
			runStr:="*RunAs " . runStr
		}
		;如果有参数
		if(arr2)
		{
			param:=arr2
			runStr:=runStr . " " . arr2
		}
		return strMatch2
	}
	return
}

alert(str)
{
    msgbox, % str
    return
}

;将set.ini里的QRun字符串转换成run使用的字符串
;如果文件(夹)不存在，会返回空
set2Run(str)
{
	runStr:=""
	extractSetStr(str, runStr)
    ;  msgbox, % runStr
	return runStr
}

;用来修复 excel 里复制一整行（列）会报错的问题
;弹出这个 gui 再进行赋值操作，然后回去
foolGui(switch=1){

	if !switch
	{
		Gui, foolgui:Destroy
		return
	}

	Gui, foolgui: -Caption +E0x80000 +LastFound +OwnDialogs +Owner
	Gui, foolgui: Show, NA, foolgui
	WinActivate, foolgui
}

clipSaver(clipX)
{
    global
    if(WinActive("ahk_exe EXCEL.EXE"))
    {
        foolgui()
        if(clipX="s")
            sClipboardAll:=ClipboardAll
        else if(clipX="c")
            cClipboardAll:=ClipboardAll
        else ; if(clipX="ca")
            caClipboardAll:=ClipboardAll
        foolgui(0)
    }
    else
    {
        if(clipX="s")
            sClipboardAll:=ClipboardAll
        else if(clipX="c")
            cClipboardAll:=ClipboardAll
        else ; if(clipX="ca")
            caClipboardAll:=ClipboardAll
    }
}

;字符串中的特殊字符转义
;  escapeCharForString(str){
;      ;  StringReplace, str, str, ``, ````, All
;      ;  StringReplace, str, str, ", `"`", All
;      StringReplace, str, str, \", ", All
;      StringReplace, str, str, \', ', All
;      StringReplace, str, str, \\, \, All
    
;      return str
;  }

;运行函数字符串，被运行的函数的参数只接收字符串，参数分割按 CSV 方式
; 最多支持3个参数
runFunc(str){
    ;如果只给了函数名，没有括号，当做是不传参直接调用函数
    if(!RegExMatch(Trim(str), "\)$"))
    {
        %str%()
        return
    }
    if(RegExMatch(str, "(\w+)\((.*)\)$", match))
    {
        func:=Func(match1)
        
        if(!match2)
        {
            func.()
            return
        }
        ;  msgbox, % "match2" . match2
        ;  pos := 1, params:=[]
        ;  While pos := RegExMatch(match2, "(?:""((?:[^""\\]|\\.)*)"")|(?:'((?:[^'\\]|\\.)*)')", matchB, pos+StrLen(matchB))
        ;  {
        ;      if(matchB1)
        ;          params.insert(matchB1)
        ;      else if(match2)
        ;          params.insert(matchB2)
        ;  }

        ;  parmasLen:=params.MaxIndex()

        params:={}
        loop, Parse, match2, CSV
        {
            params.insert(A_LoopField)
        }

        parmasLen:=params.MaxIndex()
        
        if(parmasLen==1)
        {
            func.(params[1])
            return
        }
        if(parmasLen==2)
        {
            func.(params[1],params[2])
            return
        }
        if(parmasLen==3)
        {
            func.(params[1],params[2],params[3])
            return
        }
    }
}