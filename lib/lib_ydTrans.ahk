/*
有道翻译
*/

#Include lib_json.ahk   	;引入json解析文件

global TransEdit,transEditHwnd,transGuiHwnd, NativeString

youdaoApiInit:
global youdaoApiString:=""

;  #Include *i youdaoApiKey.ahk
global youdaoApiKey0, youdaoApiKey1
youdaoApiKey0=12763084

if(CLSets.TTranslate.apiType=1)
{
	if(CLSets.TTranslate.apiKey!="")
	{
		key:=CLSets.TTranslate.apiKey
		youdaoApiString=http://fanyi.youdao.com/paidapi/fanyiapi?key=%key%&type=data&doctype=json&q=
	}
	else if(youdaoApiKey1)
	{
		youdaoApiString=http://fanyi.youdao.com/paidapi/fanyiapi?key=%youdaoApiKey1%&type=data&doctype=json&q=
	}
}
else
{
	if(CLSets.TTranslate.apiKey!="")
	{
		key:=CLSets.TTranslate.apiKey
		keyFrom:=ClSets.TTranslate.keyFrom
		youdaoApiString=http://fanyi.youdao.com/openapi.do?keyfrom=%keyFrom%&key=%key%&type=data&doctype=json&version=1.1&q=
	}
	else if(youdaoApiKey0)
	{
		youdaoApiString=http://fanyi.youdao.com/openapi.do?keyfrom=CapsLock&key=%youdaoApiKey0%&type=data&doctype=json&version=1.1&q=
	}
}
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
sendStr:=youdaoApiString . UTF8Codes
whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")

whr.Open("GET", sendStr)

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
	if(returnError=11)
	{
		MsgBoxStr:=lang_yd_errorNoResults
	}
	if(returnError=20)
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