;~ 初始化段，也就是自动运行段，所有需要自动运行的代码放这里，然后放到程序最开头
SetTimer, initAll, -400 ;等个100毫秒，等待其他文件的include都完成

return

initAll:
Suspend, On ;挂起所有热键

IniRead, loadingAnimation, CapsLock+settings.ini, Global, loadingAnimation, 1
IniRead, language, CapsLock+settings.ini, Global, language, 0

if(loadingAnimation != "0")
	gosub, showLoading

;------------  language -----------
;  language:=CLsets.global.language

; 字符串初始化,这个要第一个运行
;  if(language and IsLabel("language_" . language))
;  	gosub, language_%language%
;  else if(getSystemLanguage() == "Chinese_PRC")
;  	gosub, language_Simplified_Chinese
;  else if(getSystemLanguage() == "Chinese_Hong_Kong" or getSystemLanguage() == "Chinese_Taiwan")
;  	gosub, language_Traditional_Chinese
;  else
;  	gosub, language_English
gosub, language_Simplified_Chinese
;------------  /language -----------

gosub, settingsInit ;初始化设置


gosub, bindWinsInit

gosub, jsEval_init
setTimer, youdaoApiInit, -1 ;初始化翻译api
gosub, getDefaultBrowser

global needInitQ:=1 ;+q初始化标志位
CLq() ;初始化+q

setTimer, mouseSpeedInit, -1
Suspend, Off

if(loadingAnimation != "0")
	gosub, hideLoading

return

getDefaultBrowser:
global defaultBrowser
;获取默认浏览器图标，QWeb的listview用
RegRead, defaultBrowser, HKCU, SOFTWARE\Microsoft\Windows\Shell\Associations\UrlAssociations\http\UserChoice, ProgId
RegRead, defaultBrowser, HKLM, SOFTWARE\Classes\%defaultBrowser%\shell\open\command
RegExMatch(defaultBrowser, "[a-zA-Z]:\\[\s\S]*\.exe", defaultBrowser)
;~ MsgBox, % defaultBrowser
if(defaultBrowser="")
	defaultBrowser:="C:\Program Files (x86)\Internet Explorer\IExplore.exe"
return
