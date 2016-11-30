showLoading:
;~ global 
;~ LoadingChar:=["—","/","|","\"]
;~ LoadingChar:=["1","2","3","4","5","6","7","8"]
LoadingChar:=[   "_('<------"
                ," _('=-----"
                ," _('<-----"
                ,"  _('=----"
                ,"  _('<----"
                ,"   _('=---"
                ,"   _('<---"
                ,"    _('=--"
                ,"    _('<--"
                ,"     _('=-"
                ,"     _('<-"
                ,"      _(*="
                ,"------_(*="
                ,"------_(^<"
                ,"------_(^<"
                ,"------ |  "
                ,"------>')_"
                ,"-----=')_ "
                ,"----->')_ "
                ,"----=')_  "
                ,"---->')_  "
                ,"---=')_   "
                ,"--->')_   "
                ,"--=')_    "
                ,"-->')_    "
                ,"-=')_     "
                ,"->')_     "
                ,"=*)_      "
                ,"=*)_------"
                ,">^)_------"
                ,">^)_------"
                ,"  | ------"]
;  LoadingChar:=[   "=---------"
;                  ,"-=--------"
;                  ,"--=-------"
;                  ,"---=------"
;                  ,"----=-----"
;                  ,"-----=----"
;                  ,"------=---"
;                  ,"-------=--"
;                  ,"--------=-"
;                  ,"---------="
;                  ,"--------=-"
;                  ,"-------=--"
;                  ,"------=---"
;                  ,"-----=----"
;                  ,"----=-----"
;                  ,"---=------"
;                  ,"--=-------"
;                  ,"-=--------"]
Gui, LoadingGui:new, HwndLoadingGuiHwnd -Caption +AlwaysOnTop +Owner
Gui, Font, S12 C0x555555, Lucida Console ;后备字体
Gui, Font, S12 C0x555555, Fixedsys      ;后备字体
Gui, Font, S12 C0x555555, Courier New   ;后备字体
Gui, Font, S12 C0x555555, Source Code Pro   ;后备字体
Gui, Font, S12 C0x555555, Consolas
Gui, Add, Text, HwndLoadingTextHwnd H20 W100 Center,% LoadingChar[1]
Gui, Color, ffffff, ffffff
Gui, LoadingGui:Show, Center NA
;~ WinSet, TransColor, ffffff, ahk_id %LoadingGuiHwnd%
WinSet, Transparent, 230, ahk_id %LoadingGuiHwnd%
charIndex:=1
loadingCharMaxIndex:=LoadingChar._MaxIndex()
SetTimer, changeLoadingChar, 250, 777   ;优先级777
return


hideLoading:
SetTimer, changeLoadingChar, Off
Gui, LoadingGui:Destroy
return


changeLoadingChar:
charIndex:=Mod(charIndex, loadingCharMaxIndex)+1
ControlSetText, , % LoadingChar[charIndex], ahk_id %LoadingTextHwnd%
return


