jsEval_init:
;comObjError(0) ;关闭 com 对象的报错
gosub, scriptDemoInit
; 使用ie11引擎实现计算功能，经测试，如果自带引擎低于11，会自动使用自带的最新引擎
FixIE(11)

obj:=ComObjCreate("HTMLfile")

;---load javascript---

;build-in script
buildInScript=
( LTrim
<script>
var funcArr=['abs','acos','asin','atan','atan2','ceil','cos','exp','floor','log','max','min','pow','random','round','sin','sqrt','tan'];
var consArr=['E','LN2','LN10','LOG2E','LOG10E','PI','SQRT1_2','SQRT2'];
for(var i=0,len=funcArr.length;i<len;i++){
    window[funcArr[i]]=Math[funcArr[i]];
}
for(var i=0,len=consArr.length;i<len;i++){
    window[consArr[i]]=Math[consArr[i]];
    window[consArr[i].toLowerCase()]=Math[consArr[i]];
}
//fix floating point calculation bug in js like 0.1+0.2=0.30000000000000004
//for(var i=0,k=0;k<100001;k++,i+=0.000001){console.log(i,fixFloatCalcRudely(i));}
function fixFloatCalcRudely(num){
    if(typeof num == 'number'){
        var str=num.toString(),
            match=str.match(/\.(\d*?)(9|0)\2{5,}(\d{1,5})$/);
        if(match != null){
            return num.toFixed(match[1].length)-0;
        }
    }
    return num;
}
</script>
)
obj.write(buildInScript)
buildInScript:=""

;custom script
ifexist, loadScript
{
    jsfiles:=StrSplit(CLSets.Global.loadScript, ",", " `t")
    loop, % jsfiles.MaxIndex()
    {
        obj.write("<script>")
        loop, Read, % "loadScript\" . jsfiles[A_Index]
        {
            obj.write(A_LoopReadLine . "`n")
        }
        obj.write("</script>")
    }
}
return


eval(exp)
{
    global obj
    exp:=escapeString(exp)
    
    obj.write("<body><script>(function(){var t=document.body;t.innerText='';t.innerText=eval('" . exp . "');})()</script></body>")
    return inStr(cabbage:=obj.body.innerText, "body") ? "ERROR" : cabbage
}

escapeString(string){
    ;escape http://www.w3school.com.cn/js/js_special_characters.asp
    string:=regExReplace(string, "('|""|&|\\|\\n|\\r|\\t|\\b|\\f)", "\$1")
    
    ;replace all newline character to '\n'
    string:=regExReplace(string, "\R", "\n")
    return string
}


strSelected2Script(selText){
    ; 允许这样使用caps+tab:
    ;  o.type = obj.type||'';
    ;  ->sort()
    ; 等价于:
    ;sort("o.type = obj.type||'';")
    ;  funcArr:={}

    ;  regex:="(?:((?(3)\s*|\R*)->\s*([\w.]*(\((?>'[^'\\]*(?:\\.[^'\\]*)*'|""[^""\\]*(?:\\.[^""\\]*)*""|[^""'()]++|(?3))*\)))))+\s*\z"
    regex:="\R[ \t]*?\..+\(.*\)\s*$"
    
    matchFuncPos:=RegExMatch(selText, regex, funcMatch)

    if(matchFuncPos)
    {
        selText := SubStr(selText,1,matchFuncPos)
        
        selText := escapeString(selText)
        
        selText := "'" . selText . "'" . RegExReplace(funcMatch, "(^\s*)|(\s*$)")
        ;  regex:="(\s*->\s*([\w.]+\((?>'[^'\\]*(?:\\.[^'\\]*)*'|""[^""\\]*(?:\\.[^""\\]*)*""|[^""'()]++|(?1))*\)))$"
        ;  loop
        ;  {
            
        ;      sliceFuncPos:=RegExMatch(funcMatch, regex, sliceFuncMatch)
        ;      if(sliceFuncPos)
        ;      {
        ;          funcArr.Insert(sliceFuncMatch2)
        ;          funcMatch := SubStr(funcMatch,1,sliceFuncPos-1)
        ;      }
        ;      else
        ;          break
        ;  }
        
    }
    
    ;  if(funcArr.MaxIndex())
    ;  {
    ;      ;just the innermost need escape char and quotes
    ;      selText := escapeString(selText)
    ;      funcNow := funcArr.Remove()
    ;      ;  msgbox, % "funcNow" . funcNow
    ;      if(RegExMatch(funcNow, "\(\S+\)"))
    ;          selText := RegExReplace(funcNow, "\(", "('" . selText . "',")
    ;      else
    ;          selText := RegExReplace(funcNow, "\(", "('" . selText . "'")
    ;      loop, % funcArr.MaxIndex()
    ;      {
    ;          funcNow := funcArr.Remove()
    ;          if(RegExMatch(funcNow, "\(\S+\)"))
    ;              selText := RegExReplace(funcNow, "\(", "(" . selText . ",")
    ;          else
    ;              selText := RegExReplace(funcNow, "\(", "(" . selText)
            ;  msgbox, % selText
    ;      }
    ;  }
    ;  msgbox, % selText
    return selText
}

FixIE(Version=0, ExeName="")
{
	static Key := "Software\Microsoft\Internet Explorer"
	. "\MAIN\FeatureControl\FEATURE_BROWSER_EMULATION"
	, Versions := {7:7000, 8:8888, 9:9999, 10:10001, 11:11001}
	
	if Versions.HasKey(Version)
		Version := Versions[Version]

	
	if !ExeName
	{
		if A_IsCompiled
			ExeName := A_ScriptName
		else
			SplitPath, A_AhkPath, ExeName
	}
	
	RegRead, PreviousValue, HKCU, %Key%, %ExeName%
    ;  msgbox, % PreviousValue . "#" . Version
	if (Version = "")
		RegDelete, HKCU, %Key%, %ExeName%
	else if(PreviousValue != Version)
		RegWrite, REG_DWORD, HKCU, %Key%, %ExeName%, %Version%
        
    ;  msgbox, % Version
	return PreviousValue
}


scriptDemoInit:
;init scriptDemo
if(CLSets.Global.loadScript)
{
    IfNotExist, loadScript
    {
        FileCreateDir, loadScript
    }
    IfNotExist, loadScript\scriptDemo.js
    {       
        ;  FileAppend, %scriptDemoJS%, loadScript\scriptDemo.js, UTF-8-RAW
        FileInstall, loadScript\scriptDemo.js, loadScript\scriptDemo.js
    }
    else
    {
        FileGetTime, setDemoModifyTime, loadScript\scriptDemo.js
        FileGetTime, thisScriptModifyTime, %A_ScriptName%

        thisScriptModifyTime -= setDemoModifyTime, S
        if(thisScriptModifyTime > 0) ;如果主程序文件比较新，那就是更新过，那就覆盖一遍
        {
            ;  FileDelete, loadScript\scriptDemo.js
            ;  FileAppend, %scriptDemoJS%, loadScript\scriptDemo.js, UTF-8-RAW
            FileInstall, loadScript\scriptDemo.js, loadScript\scriptDemo.js, 1
        }
    }
    IfNotExist, loadScript\debug.html
    {   
        ;  FileAppend, %debugHTML%, loadScript\debug.html, UTF-8-RAW
        FileInstall, loadScript\debug.html, loadScript\debug.html
    }
}
return