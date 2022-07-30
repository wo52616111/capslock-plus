/*
有道翻译
*/

#Include lib_json.ahk   	;引入json解析文件
#Include sha256.ahk		;引入sha256加密文件

global TransEdit,transEditHwnd,transGuiHwnd, NativeString

youdaoApiInit:
global youdaoApiString:=""

;  #Include *i youdaoApiKey.ahk
; 这里填写默认的id和key
global appID=""
global appKey=""

; 这里不需要判断是否是收费还是免费的了, 翻译api改版了
; free key
if (CLSets.TTranslate.appID != "" && CLSets.TTranslate.appKey != "")
{
	appID:=CLSets.TTranslate.appID
	appKey:=CLSets.TTranslate.appKey
}
youdaoApiString=http://openapi.youdao.com/api?signType=v3&from=auto&to=auto&appKey=%appID%
return

setTransGuiActive:
WinActivate, ahk_id %transGuiHwnd%
return

ydTranslate(ss)
{
transStart:
    ;  if(StrLen(ss) >= 2000)
    ;  {
    ;      MsgBox, , , 文本过长，请重新选择。, 1
    ;      return 
    ;  }
	ss:=RegExReplace(ss, "\s", " ") ;把所有空白符换成空格，因为如果有回车符的话，json转换时会出错
	
	;~ global 
	
	NativeString:=Trim(ss)

transGui:
;~ WinClose, 有道翻译
MsgBoxStr:=NativeString?lang_yd_translating:""

DetectHiddenWindows, On ;可以检测到隐藏窗口
WinGet, ifGuiExistButHide, Count, ahk_id %transGuiHwnd%
if(ifGuiExistButHide)
{
	ControlSetText, , %MsgBoxStr%, ahk_id %transEditHwnd%
	ControlFocus, , ahk_id %transEditHwnd%
	WinShow, ahk_id %transGuiHwnd%
}
else ;IfWinNotExist,  ahk_id %transGuiHwnd% ;有道翻译
{
	;~ MsgBox, 0
	
	Gui, new, +HwndtransGuiHwnd , %lang_yd_name%
	Gui, +AlwaysOnTop -Border +Caption -Disabled -LastFound -MaximizeBox -OwnDialogs -Resize +SysMenu -Theme -ToolWindow
	Gui, Font, s10 w400, Microsoft YaHei UI ;设置字体
	Gui, Font, s10 w400, 微软雅黑
	gui, Add, Button, x-40 y-40 Default, OK  
	
	Gui, Add, Edit, x-2 y0 w504 h405 vTransEdit HwndtransEditHwnd -WantReturn -VScroll , %MsgBoxStr%
	Gui, Color, ffffff, fefefe
	Gui, +LastFound
	WinSet, TransColor, ffffff 210
	;~ MsgBox, 1
	Gui, Show, Center w500 h402, %lang_yd_name%
	ControlFocus, , ahk_id %transEditHwnd%
	SetTimer, setTransActive, 50
}
;~ DetectHiddenWindows, On ;可以检测到隐藏窗口

if(NativeString) ;如果传入的字符串非空则翻译
{
	;~ MsgBox, 2
	SetTimer, ydApi, -1
	return
}

Return


ydApi:
UTF8Codes:="" ;重置要发送的代码
SetFormat, integer, H
UTF8Codes:=UTF8encode(NativeString)
if(youdaoApiString="")
{
	MsgBoxStr=%lang_yd_needKey%
	goto, setTransText
}

; salt sign curtime
; sign=sha256(应用ID+input+salt+curtime+应用密钥)
myNow := A_NowUTC
myNow -= 19700101000000, Seconds
salt := CreateUUID()
myNow := Format("{:d}", myNow)
if (StrLen(NativeString) > 20) {
	NativeStringF := SubStr(NativeString, 1, 10)
	NativeStringE := SubStr(NativeString, -9, 10)
	signString := appID . NativeStringF . Format("{:d}", StrLen(NativeString)) . NativeStringE . salt . myNow . appKey
} else {
	signString := appID . NativeString . salt . myNow . appKey
}
sign:=bcrypt.hash(signString, "SHA256")
sendStr:=youdaoApiString . "&salt=" . salt . "&curtime=" . myNow . "&sign=" . sign . "&q=" . UTF8encode(NativeString)
whr := ComObjCreate("Msxml2.XMLHTTP")

whr.Open("GET", sendStr, False)

;~ MsgBox, 3
try
{
	whr.Send()
}
catch
{
	MsgBoxStr:=lang_yd_errorNoNet
	goto, setTransText
}
afterSend:
responseStr := whr.ResponseText

;~ transJson:=JSON_from(responseStr) 
;MsgBox, % signString
;MsgBox, % sendStr
;MsgBox, % responseStr
transJson:=JSON.Load(responseStr)
; MsgBox, % responseStr
; MsgBox, % JSON_to(transJson) ;弹出整个翻译结果的json，测试用
returnError:=transJson.errorCode
if(returnError) ;如果返回错误结果，显示出相应原因
{
	if(returnError=10)
	{
		MsgBoxStr:=lang_yd_errorTooLong
	}
	else if(returnError=11)
	{
		MsgBoxStr:=lang_yd_errorNoResults
	}
	else if(returnError=20)
	{
		MsgBoxStr:=lang_yd_errorTextTooLong
	}
	else if(returnError=30)
	{
		MsgBoxStr:=lang_yd_errorCantTrans
	}
	else if(returnError=40)
	{
		MsgBoxStr:=lang_yd_errorLangType
	}
	else if(returnError=50)
	{
		MsgBoxStr:=lang_yd_errorKeyInvalid
	}
	else if(returnError=60)
	{
		MsgBoxStr:=lang_yd_errorSpendingLimit
	}
	else if(returnError=70)
	{
		MsgBoxStr:=lang_yd_errorNoFunds
	}
	else if (returnError=202)
	{
		MsgBoxStr:=lang_yd_errorTextTooLong
	}
	goto, setTransText
	return
}
 ;================拼MsgBox显示的内容
{

	MsgBoxStr:= % transJson.query . "`t"   ;原单词
	if(transJson.basic.phonetic)
	{
		MsgBoxStr:=% MsgBoxStr . "[" . transJson.basic.phonetic . "] "  ;读音
	}
	MsgBoxStr:= % MsgBoxStr . "`r`n`r`n" . lang_yd_trans . "`r`n" ;分隔，换行
	;~ MsgBoxStr:= % MsgBoxStr . "--有道翻译--`n"
	Loop
	{
		if (transJson.translation[A_Index])
		{
			if (%A_Index%>1)
			{
				MsgBoxStr:=% MsgBoxStr . A_Space . ";" . A_Space  ;给每个结果之间插入" ; "
			}
			MsgBoxStr:= % MsgBoxStr . transJson.translation[A_Index]                                     ;翻译结果
		}
		else
		{
			MsgBoxStr:= % MsgBoxStr . "`r`n`r`n" . lang_yd_dict . "`r`n"
			break
		}
	}
	;~ MsgBoxStr:= % MsgBoxStr . "--有道词典结果--`n"
	Loop
	{
		if (transJson.basic.explains[A_Index])
		{
			if (A_Index>1)
			{
				;~ MsgBoxStr:=% MsgBoxStr . A_Space . ";" . A_Space  ;给每个结果之间插入" ; "
				MsgBoxStr:=% MsgBoxStr . "`r`n"   ;每条短语换一行
			}
			MsgBoxStr:= % MsgBoxStr . transJson.basic.explains[A_Index]                                      ;有道词典结果
		}
		else
		{
			MsgBoxStr:= % MsgBoxStr . "`r`n`r`n" . lang_yd_phrase . "`r`n"
			break
		}
	}
	;~ MsgBoxStr:= % MsgBoxStr . "--短语--`n"
	Loop
	{
		if (transJson.web[A_Index])
		{
			if (A_Index>1)
			{
				MsgBoxStr:=% MsgBoxStr . "`r`n"   ;每条短语换一行
			}
			MsgBoxStr:= % MsgBoxStr . transJson.web[A_Index].key . A_Space . A_Space   ;短语  
			thisA_index:=A_Index
			Loop
			{
				if(transJson.web[thisA_index].value[A_Index])
				{
					if (A_Index>1)
					{
						MsgBoxStr:=% MsgBoxStr . A_Space . ";" . A_Space  ;给每个结果之间插入" ; "
					}
					MsgBoxStr:= % MsgBoxStr . transJson.web[thisA_index].value[A_Index]
				}
				else
				{
					break
				}
			}
		}
		else
		{
			break
		}
	}
}
;~ MsgBox, % MsgBoxStr
setTransText:
ControlSetText, , %MsgBoxStr%, ahk_id %transEditHwnd%
ControlFocus, , ahk_id %transEditHwnd%
SetTimer, setTransActive, 50
return 
;================拼MsgBox显示的内容

ButtonOK:
Gui, Submit, NoHide

TransEdit:=RegExReplace(TransEdit, "\s", " ") ;把所有空白符换成空格，因为如果有回车符的话，json转换时会出错
NativeString:=Trim(TransEdit)
;~ goto, ydApi
goto, transGui

return

}


;确保激活
setTransActive:
IfWinExist, ahk_id %transGuiHwnd%
{
    SetTimer, ,Off
    WinActivate, ahk_id %transGuiHwnd%
}
return

CreateUUID()
{
    VarSetCapacity(puuid, 16, 0)
    if !(DllCall("rpcrt4.dll\UuidCreate", "ptr", &puuid))
        if !(DllCall("rpcrt4.dll\UuidToString", "ptr", &puuid, "uint*", suuid))
            return StrGet(suuid), DllCall("rpcrt4.dll\RpcStringFree", "uint*", suuid)
    return ""
}