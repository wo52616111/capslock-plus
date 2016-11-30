bindWinsInit:
global winsInfos:={}
global tapTimes:={1:0,2:0,3:0,4:0,5:0,6:0,7:0,8:0,9:0,10:0,11:0,12:0,13:0,14:0,15:0,16:0,17:0,18:0,19:0,20:0,btn:-1}
global winTapedX ;winTapedX用于判断多窗口绑定的切换是哪个按键的，在CapsLock松开后winsSort()用来判定一次窗口在窗口组的位置
global lastActiveWinId ;在用窗口激活时，现在正在激活状态的窗口id
;标志有没获取过窗口信息，因为判断多次敲击需要等待时间，
;超时了才执行绑定程序，在等待时间中唤醒绑定窗口会造成绑定失败，
;所以增加一个标志，当唤醒窗口时，标志不假则立刻执行一次绑定程序
global gettingWinInfo:=0

initWinsInfos(n)
{
    winsInfos[n]:={}
    winsInfos[n].class:={}
    winsInfos[n].exe:={}
    winsInfos[n].id:={}
    return
}

IfNotExist, CapsLock+winsInfosRecorder.ini
{
    FileAppend, %lang_winsInfosRecorderIniInit%, CapsLock+winsInfosRecorder.ini, UTF-16
}
lang_winsInfosRecorderIniInit:=""

IniRead, infosSections, CapsLock+winsInfosRecorder.ini, , , %A_Space%
sectionArr:=StrSplit(infosSections,"`n")
loop, % tapTimes.MaxIndex() ;+1：把索引从0开始换成1开始
    initWinsInfos(A_index)
;  {
;  		_t:="group" . A_index-1 ;-1：把索引从1开始换成0开始
;      winsInfos[_t]:={}
;      winsInfos[_t].class:={}
;      winsInfos[_t].exe:={}
;      winsInfos[_t].id:={}
;  }
;取出winsInfosRecorder.ini里的数据，数组存着
for sectionKey,sectionValue in sectionArr
{
    ;~ winsInfos[sectionValue].length:=0
    IniRead, infosKeys, CapsLock+winsInfosRecorder.ini, %sectionValue%, , %A_Space%
    infosKeys:=RegExReplace(infosKeys, "m`n)=.*$")
    keyArr:=StrSplit(infosKeys,"`n")
    for key,keyValue in keyArr
    {
        IniRead, infos, CapsLock+winsInfosRecorder.ini, %sectionValue%, %keyValue%, %A_Space%
        if(keyValue="bindType") ;如果是bindType则直接记录，否则是class,exe,id，再开多一维数组记录
        {
            winsInfos[sectionValue].bindType:=infos
        }
        else
        {
            ni:=StrSplit(keyValue, "_") ;name and id
            winsInfos[sectionValue][ni.1][ni.2]:=infos
        }
    }
}

return
;=function=start============================================================================
getWinInfo(btnx, bindType)
{
  winId:=WinExist("A") ;获取id
  WinGetClass, winClass, ahk_id %winId% ;获取该id窗口的class
  WinGet, winExe, ProcessPath, ahk_id %winId% ;获取该id窗口的path
  infosGx:=winsInfos[btnx] ;记录到窗口绑定变量
  if(bindType==1) ;如果是单窗口绑定
  {
    ;~ if(winId==infosGx.id.0) ;如果重复绑定，不执行
      ;~ return
    infosGx.bindType:=1
    infosGx.id.0:=winId
    infosGx.class.0:=winClass
    infosGx.exe.0:=winExe
    IfExist, CapsLock+winsInfosRecorder.ini
    { 
      IniWrite, 1, CapsLock+winsInfosRecorder.ini, %btnx%, bindType		;写入bindType到ini
      IniWrite, %winClass%, CapsLock+winsInfosRecorder.ini, %btnx%, class_0 ;写入class到ini
      IniWrite, %winExe%, CapsLock+winsInfosRecorder.ini, %btnx%, exe_0 ;写入path到ini
      IniWrite, %winId%, CapsLock+winsInfosRecorder.ini, %btnx%, id_0		;写入id到ini
    }
    else
    {
      MsgBox, %lang_bw_noWIRini%
      return
    }
    loop, % infosGx.id.MaxIndex() ;除了第0个，其他都删掉
    {
      ;~ SendInput, % A_Index
      IniDelete, CapsLock+winsInfosRecorder.ini, %btnx%, class_%A_Index%
      IniDelete, CapsLock+winsInfosRecorder.ini, %btnx%, exe_%A_Index%
      IniDelete, CapsLock+winsInfosRecorder.ini, %btnx%, id_%A_Index%
      infosGx.class.remove(1)
      infosGx.exe.remove(1)
      infosGx.id.remove(1)
    }
    ;~ infosGx.length:=1
    return
  }
  
  else if(bindType==2) ;如果多窗口绑定
  {
    if(infosGx.bindType==3) ;如果现在的绑定模式是3，先清空，再绑上第一个窗口
    {
      infosGx.class.0:=winClass
      infosGx.exe.0:=winExe
      infosGx.id.0:=winId
      
      IniWrite, %winClass%, CapsLock+winsInfosRecorder.ini, %btnx%, class_0 ;写入class到ini
      IniWrite, %winExe%, CapsLock+winsInfosRecorder.ini, %btnx%, exe_0 ;写入path到ini
      IniWrite, %winId%, CapsLock+winsInfosRecorder.ini, %btnx%, id_0		;写入id到ini

      loop, % infosGx.id.MaxIndex() ;除了第0个，其他都删掉
      {
        IniDelete, CapsLock+winsInfosRecorder.ini, %btnx%, class_%A_Index%
        IniDelete, CapsLock+winsInfosRecorder.ini, %btnx%, exe_%A_Index%
        IniDelete, CapsLock+winsInfosRecorder.ini, %btnx%, id_%A_Index%
        infosGx.class.remove(1)
        infosGx.exe.remove(1)
        infosGx.id.remove(1)
      }
      infosGx.bindType:=1
    }
    else ;否则就是模式1或2，直接在现有窗口基础上添加就行
    {
      index:=infosGx.id.MaxIndex()+1
      loop, % index ;查重，如果是已有的窗口，不添加
      {
        if(winId==infosGx.id[A_Index-1])
          return
      }
      ;~ SendInput, % index
      infosGx.class.insert(winClass)
      infosGx.exe.insert(winExe)
      infosGx.id.insert(winId)
      
      IniWrite, %winClass%, CapsLock+winsInfosRecorder.ini, %btnx%, class_%index% ;写入class到ini
      IniWrite, %winExe%, CapsLock+winsInfosRecorder.ini, %btnx%, exe_%index% ;写入path到ini
      IniWrite, %winId%, CapsLock+winsInfosRecorder.ini, %btnx%, id_%index%		;写入id到ini
      
      infosGx.bindType:=2
    }
    IniWrite, 2, CapsLock+winsInfosRecorder.ini, %btnx%, bindType		;写入bindType到ini
  }
  
  else if(bindType==3) ;如果单程序全窗口绑定
  {
    infosGx.bindType:=3
    WinGet, winList, List, ahk_class %winClass% ahk_exe %winExe%
    uselessLength:=infosGx.id.MaxIndex()+1-winList ;多余无用的数据有多少条(原本的-新增的)
    infosGx.class.0:=winClass
    infosGx.exe.0:=winExe
    loop, % winList ;全部id分配到变量里
    {
      infosGx.id[A_Index-1]:=winList%A_Index%
    }
    IniWrite, %winClass%, CapsLock+winsInfosRecorder.ini, %btnx%, class_0 ;写入class到ini
    IniWrite, %winExe%, CapsLock+winsInfosRecorder.ini, %btnx%, exe_0 ;写入path到ini
    loop, % winList ;全部id写到ini里， 不知道写入会不会造成程序等待，所以和分配变量分开两个loop进行
    {
      index:=A_Index-1
      IniWrite, % winList%A_Index%, CapsLock+winsInfosRecorder.ini, %btnx%, id_%index%		;写入id到ini
    }
    loop, % uselessLength ;除了前面刚刚写入的，其他有多的话都删掉
    {
      index:=winList+uselessLength-A_Index
      ;~ SendInput, % index
      infosGx.class.remove(index)
      infosGx.exe.remove(index)
      infosGx.id.remove(index)
      IniDelete, CapsLock+winsInfosRecorder.ini, %btnx%, class_%index%
      IniDelete, CapsLock+winsInfosRecorder.ini, %btnx%, exe_%index%
      IniDelete, CapsLock+winsInfosRecorder.ini, %btnx%, id_%index%
    }
    IniWrite, 3, CapsLock+winsInfosRecorder.ini, %btnx%, bindType		;写入bindType到ini
    ;~ infosGx.length:=winList
  }
  return
}


activateWinAction(btnx)
{
  ;如果正在获取窗口信息，立刻执行窗口绑定程序
  if(gettingWinInfo)
    gosub, doGetWinInfo

  infosGx:=winsInfos[btnx]
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;如果该按键上只绑了一个窗口

  if(infosGx.bindType==1)
  {

    tempId:=infosGx.id.0
    IfWinNotExist, ahk_id %tempId%
    {
      tempClass:=infosGx.class.0
      tempExe:=infosGx.exe.0
      WinGet, tempId, ID,  ahk_exe %tempExe% ahk_class %tempClass% 
      if(tempId)
      {
        IniWrite, %tempId%, CapsLock+winsInfosRecorder.ini, % btnx , id_0
      }
      Else
      {
        IfExist, %tempExe%
        {
          Run, %tempExe%
        }
        Return
      }
    }
    IfWinActive, ahk_id %tempId%
    {
      WinMinimize, ahk_id %tempId%
      if(lastActiveWinId!="" && lastActiveWinId!=tempId)
        WinActivate, ahk_id %lastActiveWinId%
      return
    }

    lastActiveWinId:=WinExist("A")
    WinActivate, ahk_id %tempId%
    return
  }
  ;;;;;;;;;;;;如果该按键上绑了多个独立窗口
  if(infosGx.bindType==2) 
  {
    winTapedX:=btnx ;将按下标记设置为当前按键
    
    ;变量中的窗口被关掉的清除掉
    maxIndex:=infosGx.id.MaxIndex()
    loop, % maxIndex+1
    {
      index:=maxIndex+1-A_Index
      tempId:=infosGx.id[index]
      IfWinNotExist, ahk_id %tempId%
      {
        infosGx.class.remove(index)
        infosGx.exe.remove(index)
        infosGx.id.remove(index)
        IniDelete, CapsLock+winsInfosRecorder.ini, %btnx%, class_%index%
        IniDelete, CapsLock+winsInfosRecorder.ini, %btnx%, exe_%index%
        IniDelete, CapsLock+winsInfosRecorder.ini, %btnx%, id_%index%
      }
    }
    
    ;如果绑定组中只剩一个窗口，自动转换成bindType1
    if(infosGx.id.MaxIndex()=0)
    {
      IniWrite, 1, CapsLock+winsInfosRecorder.ini, %btnx%, bindType		;写入bindType到ini
      infosGx.bindType:=1
      tempId:=infosGx.id.0
      IfWinActive, ahk_id %tempId%
      {
        WinMinimize, ahk_id %tempId%
        return
      }
      WinActivate, ahk_id %tempId%
      return
    }
    
    ;判断当前激活窗口id是否id组中的一个,是的话，激活它的下一个窗口，都不是的话，激活第一个
    actWinId:=WinExist("A") 
    loop, % infosGx.id.MaxIndex()+1
    {
      if(infosGx.id[A_Index-1]=actWinId)
      {
        if(A_index-1=infosGx.id.MaxIndex()) ;如果最后一个窗口才是激活的，那就激活第一个窗口
        {
          tempId:=infosGx.id.0
          WinActivate, ahk_id %tempId%
          return
        }
        tempId:=infosGx.id[A_index]
        WinActivate, ahk_id %tempId%
        return
      }
    }
    tempId:=infosGx.id.0
    WinActivate, ahk_id %tempId%					
    return
  }
  
  if(infosGx.bindType==3)  ;如果该按键绑定了某程序所有窗口
  {
    winTapedX:=btnx ;将按下标记设置为当前按键
    tempClass:=infosGx.class.0
    tempExe:=infosGx.exe.0

    ;变量中的窗口被关掉的清除掉
    maxIndex:=infosGx.id.MaxIndex()
    loop, % maxIndex+1
    {
      index:=maxIndex+1-A_Index
      tempId:=infosGx.id[index]
      IfWinNotExist, ahk_id %tempId%
      {
        infosGx.id.remove(index) 
      }
    }
    
    ;判断现有的某程序的窗口是否增加，有的话添加到变量中
    WinGet, winList, List, ahk_class %tempClass% ahk_exe %tempExe%
    loop, % winList 
    {
      idx:=winList%A_index%
      isExist:=0
      loop, % infosGx.id.MaxIndex()+1
      {
        if(idx=infosGx.id[A_index-1])
        {
          isExist:=1
          break
        }
      }
      if(!isExist)
      {
        infosGx.id.insert(idx)
      }
    }
    
    ;如果当前没有该程序的任何窗口，启动程序
    if(infosGx.id.MaxIndex()="") 
    {
      IfExist, %tempExe%
      {
        Run, %tempExe%
      }
      Return
    }
    ;if only one windows
    else if(infosGx.id.MaxIndex()=0)
    {
      tempId:=infosGx.id.0
      IfWinActive, ahk_id %tempId%
      {
        WinMinimize, ahk_id %tempId%
        return
      }
      WinActivate, ahk_id %tempId%
      return
    }
    
    ;判断当前激活窗口id是否id组中的一个,是的话，激活它的下一个窗口，都不是的话，激活第一个
    actWinId:=WinExist("A") 
    loop, % infosGx.id.MaxIndex()+1
    {
      if(infosGx.id[A_Index-1]=actWinId)
      {
        if(A_index-1=infosGx.id.MaxIndex()) ;如果最后一个窗口才是激活的，那就激活第一个窗口
        {
          tempId:=infosGx.id.0
          WinActivate, ahk_id %tempId%
          return
        }
        tempId:=infosGx.id[A_index]
        WinActivate, ahk_id %tempId%
        return
      }
    }
    tempId:=infosGx.id.0
    WinActivate, ahk_id %tempId%
    return
  }
}

;当放开CapsLock后，对窗口排序，当前激活的窗口排到窗口组的第一位
winsSort(btnx)
{
  infosGx:=winsInfos[btnx]
  loop, % infosGx.id.MaxIndex()+1
  {
    actWinId:=WinExist("A") 
    if(infosGx.id[A_Index-1]=actWinId)
    {
      ;~ MsgBox, % infosGx.id[A_Index-1]
      infosGx.id.insert(0,infosGx.id.remove(A_index-1)) ;将当前激活窗口移到窗口组第一个	
    }
  }
  winTapedX:=-1 ;重置标记
  return
}


tapTimes(btnx) ;判断敲击次数,绑定按键的入口函数，判断完敲击次数会调用doGetWinInfo，再调用getWinInfo
{
  gettingWinInfo:=1
  SetTimer, doGetWinInfo, -500
  tapTimes.tapBtn:=btnx ;记录按下了哪个按键
  if(tapTimes["btn" .  btnx]<1)
  {
    tapTimes["btn" .  btnx]:=1
  }
  if(A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 500)
  {
    if(tapTimes["btn" .  btnx]<2)
    {
      tapTimes["btn" .  btnx]:=2
    }
    else
    {
      tapTimes["btn" .  btnx]:=3
      ;~ gosub, doGetWinInfo
    }
  }
  return
}



doGetWinInfo:
SetTimer, doGetWinInfo, Off
winBtnx:=tapTimes.tapBtn
tTapTimesx:=tapTimes["btn" . winBtnx]
if(tTapTimesx>0&&winBtnx>-1)
{
  getWinInfo(winBtnx, tTapTimesx)
  ;~ SendInput, % winBtnx . "@" . tTapTimesx0@2
}
tapTimes["btn" . winBtnx]:=0 ;重置敲击次数
tapTimes.tapBtn:=-1 ;重置winBtnx
gettingWinInfo:=0
return

;=function=end============================================================================