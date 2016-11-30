#include lib_jsEval.ahk

;if autoMatch=1, match mathematical expressions from inputStr
;if autoMatch=0, to identify inputStr as mathematical expressions
clCalculate(inputStr,ByRef result,autoMatch:=0,isScratch:=0) ;46494*234-(123+234/3)+123*3/2+5=
{ 
    if(autoMatch){
        ;精确匹配四则运算和幂运算回合表达式  strRegEx:="i)\(*-?\d*\.?\d+\)*(\s?([-+*/]|\*\*)\s?\(*-?\d*\.?\d+\)*)*\s*(\$(b|h|x|)(\d*[eEgG]?))?\s?=?\s?$"
        ;模糊匹配所有算式
        ;  strRegEx0:="S)``.+$"
        ; this RegEx is for monsterEval
        ;  strRegEx:="S)(\w*\d*(\(.*\))?\s?:=|\w*?\(|\$(b|h|x|)(\d*[eEgG]?)|\d+|[\+\-'~!]|(pi|PI|[eE])\s?[-+*/]+)[\d\w\(\)\-\+\*/'!~\^\?\$:=;><|&\s%\.]*$"
        ; this RegEx is for jsEval
        strRegEx:="\S*$"
        foundPos:=RegExMatch(inputStr, "(``)(.*)", calStr)
        if(!foundPos)
            foundPos:=RegExMatch(inputStr, strRegEx, calStr)
        else
            calStr:=LTrim(calStr, "``")
            
        if(foundPos){
            inputStr:=SubStr(inputStr,1,foundPos-1)
            
        }else{
            return inputStr
        }
        
    }else{
        calStr:=inputStr
        inputStr:=""
    }
    
    eqSignPos:=RegExMatch(calStr, " ?= ?$", eqSign)
    if(eqSignPos)
        StringMid, calStr2, calStr, % eqSignPos-1, , L
    else
        calStr2:=calStr
    
    
    
    ; 如果在计算板，则修复js的浮点计算错误
    ; e.g. 0.1+0.2=0.30000000000000004
    ; 函数体在 lib/lib_jsEval.ahk
    
    if(isScratch)
        result:=eval("fixFloatCalcRudely(" . calStr2 . ")")
    else if(CLSets.global.javascriptOriginalReturn) ; 如果.ini设置了javascriptOriginalReturn=1，则返回原js结果
        result:=eval(calStr2)
    else
        result:=eval("fixFloatCalcRudely(" . calStr2 . ")")
        
        
    if(result="")
        result:="?"
    
    if(isScratch){
        if(eqSignPos){
            inputStr .= calStr2 . eqSign . result
        }else{
            inputStr .= calStr2 . "=" . result
        }
    }else if(eqSignPos){
        inputStr .= calStr2 . eqSign . result
    }else{
        inputStr .= result
    }
    
    return inputStr
}

tabAction()
{
    ClipboardOld:=ClipboardAll
    selText:=getSelText()
    
    if(selText)
    {
        ; 让caps+tab支持这样：
        ;  o.type = obj.type||'';
        ;  ->sort()
        ; 选中以上两行再caps+tab，等价于:
        ;sort("o.type = obj.type||'';")
        selText:=strSelected2Script(selText)
        
        Clipboard := clCalculate(selText,calResult)
    }
    else
    {
        Clipboard:=""
        SendInput, +{Home}
        sleep, 10 ;make sure text is selecting
        SendInput, ^{c}
        ClipWait, 0.1
        if(!ErrorLevel)
        {
            if(!CLhotString())
            {
                ;  text2Script:=strSelected2Script(Clipboard)
                ;  if(text2Script != Clipboard)
                ;      Clipboard := clCalculate(text2Script,calResult)
                ;  else
                    Clipboard := clCalculate(Clipboard,calResult,1)
            }
        }
    }
    SendInput, ^{v}
    Sleep, 200
    Clipboard:=ClipboardOld
    return calResult
}

