language_English:
; lib\lib_bindWins.ahk
global lang_bw_noWIRini:="CapsLock+winsInfosRecorder.ini does not exist"

; clq.ahk
global lang_clq_addIni:="Are you sure to abbreviate the following string to {replace0} and record to {replace1}?"
global lang_clq_existing:="{replace0} `n already exists in {replace1}. Are you sure to overwrite with the following settings?"
global lang_clq_qrunFileNotExist:="The following records exist in QRun, but the corresponding file (folder) does not exist. Do you want to delete this setting?"
global lang_clq_noCmd:="No such command"
global lang_clq_emptyFolder:="<Empty folder>"

; ydTrans.ahk
global lang_yd_translating:="Translating... (If the network is too bad, the translation request will temporarily block the program, just wait a moment)"
global lang_yd_name:="Youdao Translation"
global lang_yd_needKey:="Youdao translator cannot be used without the key of Youdao translation API"
global lang_yd_fileNotExist:="File (folder) does not exist"
global lang_yd_errorNoNet:="Failed to send, maybe the network is disconnected"
global lang_yd_errorTooLong:="Some sentences are too long"
global lang_yd_errorNoResults:="No result"
global lang_yd_errorTextTooLong:="The text to be translated is too long"
global lang_yd_errorCantTrans:="Unable to translate"
global lang_yd_errorLangType:="Unsupported language type"
global lang_yd_errorKeyInvalid:="Invalid key"
global lang_yd_errorSpendingLimit:="Reached today's consumption limit, or the length of the request exceeds the number of characters that can be consumed today"
global lang_yd_errorNoFunds:="Insufficient account balance"
global lang_yd_trans:=  "------------------------------ Youdao Translation -----------------------------"
global lang_yd_dict:=   "------------------------------ Youdao dictionary ------------------------------"
global lang_yd_phrase:= "----------------------------------- Phrase ------------------------------------"

global lang_settingsUserInit:=""
lang_settingsUserInit=
(
;------------ Encoding: UTF-16 ------------
; Please refer to CapsLock+settingsDemo.ini to configure settings
[Global]

loadScript=scriptDemo.js

[QSearch]

[QRun]

[QWeb]

[TabHotString]

[QStyle]

[TTranslate]

[Keys]

)
global lang_settingsIniInit:=""
lang_settingsIniInit=
(
;------------ Encoding: UTF-16 ------------
; # CapsLock+ settings demo
; ****** PLEASE READ THE FOLLOWING INSTRUCTIONS: ******

; - The settings here are read-only, just for demonstration, don't modify the settings here, please write settings in CapsLock+settings.ini
;   For example, if you need to turn on the auto start, please insert a line: autostart=1 under [Global] in CapsLock+settings.ini, and save.

; - "[xxx]" is the section name, which cannot be modified.
; - The format of settings under each section is: key=value, one setting per line.
; - Although QSearch,QRun and QWeb are different sections, in theory, their key names can be repeated, but please keep them unique,
;   otherwise, the quick start function of +Q will not work properly.
; - The line beginning with a semicolon is a comment line. Comment lines do not affect the settings, just like these lines.
; - The input box popped up by Capslock+Q is called "Qbar" below.


;----------------------------------------------------------------
; ## Global Settings
[Global]
; Whether to start automatically after booting, 1 is yes, 0 is no (default).
autostart=0

; Hotkey layout scheme, optional values:
;- capslock_plus        Scheme before Capslock+ 3.0
;- capslox (default)
default_hotkey_scheme=capslox

; The JavaScript files that need to be loaded, separated by commas,
; and the files should be placed in the "loadScript" folder under the same folder as the Capslock+ program.
; They will be loaded in order, after loading, +Tab can use the functions inside.
; When this setting is not empty, the "loadScript" folder and the "debug.html" and "scriptDemo.js" files
; located in the folder will be automatically created when Capslock+ is launched.
loadScript=myScript1.js,myScript2.js, myScript3.js , myScript4.js

; When the Capslock + LAlt key is pressed, the mouse speed will temporarily change,
; the range is 1 ~ 20. The default is 3.
; You can use Capslock + LAlt + mouse wheel up / down to quickly set this value.
mouseSpeed=3

; Whether to allow independent clipboard, 1 is yes (default), 0 is no
allowClipboard=1

; Whether to show the startup loading animation, 1 is yes (default), 0 is no
loadingAnimation=1

;----------------------------------------------------------------
; ## Qbar searching command settings

; - Except the key "default", each key of settings is a seaching command, for example:
;   If you insert a line:
;   g=https://www.google.com/search?q={q}
;   then you can input "g capslock+" in QBar to google the keyword "capslock+".
;   (But this command has been built in, no need to set again.)

; - "default" is the search engine that will be used when no commands are entered.

; - The search link (the value of a setting here) of each search engine is different,
;   you can try to get it like this (not guaranteed to be accurate):
;    1. Open the website where you need to get the search link
;    2. Enter any character in the search bar, such as "capslockplus", search (it doesn't matter whether the search results)
;    3. After the search results appear, find the character you just entered in the address bar and replace it with "{q}"
;       to get the search link (all characters in the address bar after replacement)

; - You can use " ->search " to add a setting to [QSearch], like "g ->search https://www.google.com/search?q={q}"

; - You can add (0~n spaces)<xxx> to the right of the key name as a reminder

; - The following examples are built-in search commands.

[QSearch]

default=https://www.google.com/search?q={q}
bd=https://www.baidu.com/s?wd={q}
g   <google>=https://www.google.com/search?q={q}
tb  <taobao>=http://s.taobao.com/search?q={q}
wk=https://zh.wikipedia.org/w/index.php?search={q}
m=https://developer.mozilla.org/zh-CN/search?q={q}


;----------------------------------------------------------------
; ## Qbar quickly opening files (folders) settings

; - After adding a setting here, you can quickly open a file or folder in Qbar, for example:
;   Insert a line "exp=E:\expFolder\example.exe" here,
;   then you can type "exp" in Qbar to open "E:\expFolder\example.exe"

; - 可以通过 Qbar 的 " -> " 指令快速添加一项设置，例如：在 Qbar 输入"exp2 -> E:\expFolder2\example2.exe"（" -> "两边各有一个空格），确认后将会在这里添加一项"exp2=E:\expFolder2\example2.exe"

; - 如果 " -> " 无法正确识别文件路径而把设置记录到了[QWeb]或[TabHotString]，可以使用 " ->run " 来强制记录到[QRun]

; - 选中文件（文件夹）后，按 +Q ，可以将路径填入 Qbar ，那么，你想记录一个文件来快速打开，就可以这么操作：
;       1. 选中该文件
;       2. 按下 Capslock+Q，弹出的输入框内自动填入了该文件的路径
;       3. 在路径的最前面加上"xxx -> "
;       4. 按下 Enter 键，确认记录

; - 可以在键名的右边加上 （0~n个空格）<xxx> 来作为备注提示

; - 可以设置以管理员启动程序，以及启动程序的参数，
;   需要设置的话程序路径需要用 " （引号）引起来，左边加上 *RunAs 将用管理员权限启动，右边带上启动参数

[QRun]
;一般状态
ie1=C:\Program Files\Internet Explorer\iexplore.exe

;管理员权限打开
ie2=*runas "C:\Program Files\Internet Explorer\iexplore.exe"

;全屏打开
ie3 <full screen>="C:\Program Files\Internet Explorer\iexplore.exe" -k

;管理员权限，全屏打开
ie4=*runas "C:\Program Files\Internet Explorer\iexplore.exe" -k



;----------------------------------------------------------------
; #Qbar 快速打开网页设置

; - 在这里添加一条设置后，可以在 Qbar 用键名快速打开对应键值设置的链接，例如：
;        这里设置了"cldocs=http://cjkis.me/capslock+"，在 Qbar 输入"cldocs"，回车后会用默认浏览器打开"http://cjkis.me/capslock+"

; - 可以通过 Qbar 的 " -> " 指令快速添加一项设置，例如：在 Qbar 输入"cl+ -> http://cjkis.me/capslock+"（" -> "两边各有一个空格），确认后将会在这里添加一项"cl+=http://cjkis.me/capslock+"

; - 如果 " -> " 无法正确识别网址而把设置记录到了[QRun]或[TabHotString]，可以使用 " ->web " 来强制记录到[QWeb]

; - 选中网址后，按 +Q ，可以将网址填入 Qbar ，那么，你想记录一个网址来快速打开，就可以这么操作：
;       1. 选中该网址
;       2. 按下 Capslock+Q，弹出的输入框内自动填入了该网址
;       3. 在路径的最前面加上"xxx -> "
;       4. 按下 Enter 键，确认记录

; - 可以在键名的右边加上 （0~n个空格）<xxx> 来作为备注提示

[QWeb]
cldocs=http://cjkis.me/capslock+



;----------------------------------------------------------------;
; ##TabScript 的字符替换设置

; - Capslock+Tab会将紧靠光标左边的匹配某键名的字符替换成对应键值的字符，例如：
;        这里设置了"@=capslock-plus@cjkis.me"，在任意地方输入"@"，然后按下"Capslock+Tab"，"@"将替换成"capslock-plus@cjkis.me"

; - 这里的优先级高于CapsLock+Tab的计算功能，例如：
;        这里设置了1+1=3，那么输入1+1后CapsLock+Tab，1+1会被替换成3而不是2

; - 可以通过 Qbar 的 " -> " 指令快速添加一项设置，例如：在 Qbar 输入 "tel -> 15012345678" ，确认后将会在这里添加一项 "tel=15012345678"

; - 如果作为键值的字符串是类似网址或文件（夹）路径的格式，例如："ccc -> com.com.com"， " -> " 指令很可能会将它判定为网址或文件（夹）而把设置记录到了[QRun]或[QWeb]，可以使用 " ->str " 来强制记录到[TabHotString]

; - 选中文字后，按 +Q ，可以将文字填入 Qbar ，那么，你想记录一段文字，就可以这么操作：
;       1. 选中该文字
;       2. 按下 Capslock+Q，弹出的输入框内自动填入了该文字
;       3. 在路径的最前面加上"xxx -> "
;       4. 按下 Enter 键，确认记录

[TabHotString]
clp=capslockplus

;----------------------------------------------------------------
; ##Qbar 的样式设置

[QStyle]
;边框颜色
;指定16种HTML基础颜色之一或6位的RGB颜色值(0x前缀可以省略)。例如：red、ffffaa、FFFFAA、0xFFFFAA。下面的颜色设置也一样。
borderBackgroundColor=red

;边框四角的圆角程度，0为直角
borderRadius=9

;文字输入框背景颜色
textBackgroundColor=green

;输入文字颜色
textColor=ffffff

;输入文字字体
;editFontName=Consolas bold
editFontName=Hiragino Sans GB W6

;输入文字大小
editFontSize=12

;提示列表字体
listFontName=consolas

;提示列表字体大小
listFontSize=10

;提示列表背景颜色
listBackgroundColor=blue

;提示列表文字颜色
listColor=0x000000

;提示列表行数
listCount=5

;提示列表每行高度
lineHeight=19

;进度条颜色
progressColor=0x00cc99

;----------------------------------------------------------------;
; ##+T翻译设置

[TTranslate]
;有道api接口
;翻译功能通过调用有道的api实现。
;接口的请求频率限制为每小时1000次，超过限制会被封禁。也就是说所有使用Capslock+翻译的人一小时内翻译的次数加起来不能超过1000次。
;有道api网址：http://fanyi.youdao.com/openapi

;接口类型，0为免费版，1为收费版。通过上面的网址申请的是免费版的，收费版是需要 email 他们来申请的。
apiType=0

;免费版的有道 api key 的 keyfrom 参数，申请 api 时要求填写的。收费版的不需要填写。
keyFrom=xxx

;有道api的key，如果自己申请到key，可以填入，这样就不用和其他人共用api接口，留空则使用自带的key，所有人共用
;注意如果是免费版的key，apiType也要相应设置为0，收费版的填写1
apiKey=0123456789

;----------------------------------------------------------------;
; ##按键功能设置

; - 可设置的按键组合有：
;   Capslock + F1~F12
;   Capslock + 0~9
;   Capslock + a~z
;   Capslock + `-=[]\;',./ 
;   Capslock + Backspace, Tab, Enter, Space, RAlt
;   Capslock + LALt + F1~F12
;   Capslock + LALt + 0~9
;   Capslock + LALt + a~z
;   Capslock + LALt + `-=[]\;',./ 
;   Capslock + LALt + Backspace, Tab, Enter, Space, RAlt
;   Capslock + Win + 0~9

; - 以下设置键名是按键组合名，键值是对应功能，所有支持的功能都在下面

[Keys]
;短按 Caps Lock -> 发送 Esc
tap_caps=keyFunc_esc

;短按 Caps Lock -> 切换大小写
;tap_caps=keyFunc_toggleCapsLock

;Capslock+A -> 光标向左移动一个单词
caps_a=keyFunc_moveWordLeft

;Capslock+B -> 光标向下移动 10 行
caps_b=keyFunc_moveDown(10)

;独立剪贴板 1 的复制
caps_c=keyFunc_copy_1

;光标向下移动
caps_d=keyFunc_moveDown

;光标向上移动
caps_e=keyFunc_moveUp

;光标向右移动
caps_f=keyFunc_moveRight

;光标向右移动一个单词
caps_g=keyFunc_moveWordRight

;向左选中一个单词
caps_h=keyFunc_selectWordLeft

;向上选中
caps_i=keyFunc_selectUp

;向左选中
caps_j=keyFunc_selectLeft

;向下选中
caps_k=keyFunc_selectDown

;向右选中
caps_l=keyFunc_selectRight

;向下选中 10 行
caps_m=keyFunc_selectDown(10)

;向右选中一个单词
caps_n=keyFunc_selectWordRight

;选中至行末
caps_o=keyFunc_selectEnd

;光标移动到行首
caps_p=keyFunc_home

caps_q=keyFunc_doNothing

;delete
caps_r=keyFunc_delete

;光标向左移动
caps_s=keyFunc_moveLeft

caps_t=keyFunc_doNothing

;选中至行首
caps_u=keyFunc_selectHome

;独立剪贴板 1 的粘贴 
caps_v=keyFunc_paste_1

;backspace
caps_w=keyFunc_backspace

;独立剪贴板 1 的剪切
caps_x=keyFunc_cut_1

;向上选中 10 行
caps_y=keyFunc_selectUp(10)

caps_z=keyFunc_doNothing

caps_backquote=keyFunc_doNothing

;Capslock+1~9、0 -> 激活绑定窗口 1~9、10
caps_1=keyFunc_winbind_activate(1)

caps_2=keyFunc_winbind_activate(2)

caps_3=keyFunc_winbind_activate(3)

caps_4=keyFunc_winbind_activate(4)

caps_5=keyFunc_winbind_activate(5)

caps_6=keyFunc_winbind_activate(6)

caps_7=keyFunc_winbind_activate(7)

caps_8=keyFunc_winbind_activate(8)

caps_9=keyFunc_winbind_activate(9)

caps_0=keyFunc_winbind_activate(10)

caps_minus=keyFunc_doNothing

caps_equal=keyFunc_doNothing

;删除光标所在一行
caps_backspace=keyFunc_deleteLine

;TabScript
caps_tab=keyFunc_tabScript

;删除至行首
caps_leftSquareBracket=keyFunc_deleteToLineBeginning

caps_rightSquareBracket=keyFunc_doNothing

caps_backslash=keyFunc_doNothing

;Capslock+; -> end
caps_semicolon=keyFunc_end

caps_quote=keyFunc_doNothing

;换行——无论光标是否在行末
caps_enter=keyFunc_enterWherever

caps_comma=keyFunc_selectCurrentWord

caps_dot=keyFunc_selectWordRight

caps_slash=keyFunc_deleteToLineEnd

;Capslock+space -> enter
caps_space=keyFunc_enter

;Capslock+RAlt -> 无
caps_right_alt=keyFunc_doNothing

;打开 Capslock+ 首页
caps_f1=keyFunc_openCpasDocs

caps_f2=keyFunc_mathBoard

caps_f3=keyFunc_translate

caps_f4=keyFunc_winTransparent

;重载 Capslock+
caps_f5=keyFunc_reload

caps_f6=keyFunc_winPin

caps_f7=keyFunc_doNothing

caps_f8=keyFunc_getJSEvalString

caps_f9=keyFunc_doNothing

caps_f10=keyFunc_doNothing

caps_f11=keyFunc_doNothing

;打开 / 关闭独立剪贴板
caps_f12=keyFunc_switchClipboard

;--------------------LAlt--------------------

;Capslock+LAlt+A -> 向左移 3 个单词
caps_lalt_a=keyFunc_moveWordLeft(3)

caps_lalt_b=keyFunc_moveDown(30)

;独立剪贴板 2 的复制
caps_lalt_c=keyFunc_copy_2

;下移 3 行
caps_lalt_d=keyFunc_moveDown(3)

;上移 3 行
caps_lalt_e=keyFunc_moveUp(3)

;右移 5 次
caps_lalt_f=keyFunc_moveRight(5)

;右移 3 个单词
caps_lalt_g=keyFunc_moveWordRight(3)

;向左选中 3 个单词
caps_lalt_h=keyFunc_selectWordLeft(3)

;向上选中 3 行
caps_lalt_i=keyFunc_selectUp(3)

;向左选中 5 个字符
caps_lalt_j=keyFunc_selectLeft(5)

;向下选中 3 行
caps_lalt_k=keyFunc_selectDown(3)

;向右选中 5 个字符
caps_lalt_l=keyFunc_selectRight(5)

;向下选中 30 行
caps_lalt_m=keyFunc_selectDown(30)

;向右选中 3 个单词
caps_lalt_n=keyFunc_selectWordRight(3)

;选中至页尾
caps_lalt_o=keyFunc_selectToPageEnd

; 选中至页首
caps_lalt_p=keyFunc_moveToPageBeginning

caps_lalt_q=keyFunc_doNothing

;向前删除单词
caps_lalt_r=keyFunc_forwardDeleteWord

;左移 5 次
caps_lalt_s=keyFunc_moveLeft(5)

;上移 30 次
caps_lalt_t=keyFunc_moveUp(30)

;移动至页首
caps_lalt_u=keyFunc_selectToPageBeginning

;独立剪贴板 2 的粘贴
caps_lalt_v=keyFunc_paste_2

;删除单词
caps_lalt_w=keyFunc_deleteWord

;独立剪贴板 2 的 剪切
caps_lalt_x=keyFunc_cut_2

;向上选中 30 行
caps_lalt_y=keyFunc_selectUp(30)

caps_lalt_z=keyFunc_doNothing

caps_lalt_backquote=keyFunc_doNothing

caps_lalt_1=keyFunc_doNothing

caps_lalt_2=keyFunc_doNothing

caps_lalt_3=keyFunc_doNothing

caps_lalt_4=keyFunc_doNothing

caps_lalt_5=keyFunc_doNothing

caps_lalt_6=keyFunc_doNothing

caps_lalt_7=keyFunc_doNothing

caps_lalt_8=keyFunc_doNothing

caps_lalt_9=keyFunc_doNothing

caps_lalt_0=keyFunc_doNothing

caps_lalt_minus=keyFunc_doNothing

caps_lalt_equal=keyFunc_doNothing

;删除全部
caps_lalt_backspace=keyFunc_deleteAll

caps_lalt_tab=keyFunc_doNothing

;删除至页首
caps_lalt_leftSquareBracket=keyFunc_deleteToPageBeginning

;Capslock+LAlt+]
caps_lalt_rightSquareBracket=keyFunc_doNothing

;Capslock+LAlt+\
caps_lalt_backslash=keyFunc_doNothing

;移动至页尾
caps_lalt_semicolon=keyFunc_moveToPageEnd

caps_lalt_quote=keyFunc_doNothing

caps_lalt_enter=keyFunc_doNothing

caps_lalt_comma=caps_comma=keyFunc_selectCurrentLine

caps_lalt_dot=keyFunc_selectWordRight(3)

caps_lalt_slash=keyFunc_deleteToPageEnd

caps_lalt_space=keyFunc_doNothing

caps_lalt_ralt=keyFunc_doNothing

caps_lalt_f1=keyFunc_doNothing

caps_lalt_f2=keyFunc_doNothing

caps_lalt_f3=keyFunc_doNothing

caps_lalt_f4=keyFunc_doNothing

caps_lalt_f5=keyFunc_doNothing

caps_lalt_f6=keyFunc_doNothing

caps_lalt_f7=keyFunc_doNothing

caps_lalt_f8=keyFunc_doNothing

caps_lalt_f9=keyFunc_doNothing

caps_lalt_f10=keyFunc_doNothing

caps_lalt_f11=keyFunc_doNothing

caps_lalt_f12=keyFunc_doNothing

caps_lalt_wheelUp=keyFunc_doNothing

caps_lalt_wheelDown=keyFunc_doNothing

; CapsLock + Windows + 1~0 -> 绑定窗口 1~10
caps_win_1=keyFunc_winbind_binding(1)

caps_win_2=keyFunc_winbind_binding(2)

caps_win_3=keyFunc_winbind_binding(3)

caps_win_4=keyFunc_winbind_binding(4)

caps_win_5=keyFunc_winbind_binding(5)

caps_win_6=keyFunc_winbind_binding(6)

caps_win_7=keyFunc_winbind_binding(7)

caps_win_8=keyFunc_winbind_binding(8)

caps_win_9=keyFunc_winbind_binding(9)

caps_win_0=keyFunc_winbind_binding(10)


;----------------其他功能----------------

;上一首
keyFunc_mediaPrev

;暂停 / 播放
keyFunc_mediaPlayPause

;音量增大
keyFunc_volumeUp

;音量减小
keyFunc_volumeDown

;静音
keyFunc_volumeMute


)
global lang_winsInfosRecorderIniInit:=""
lang_winsInfosRecorderIniInit=
(
;------------ Encoding: UTF-16 ------------
;我负责记录CapsLock+``和1~8绑定的窗口信息，不要手动修改我，无视我就行了，麻烦帮我点下右上角的"X"，谢谢。
;我要工作了，麻烦点下右上角的"X"。
;我不想再说第三遍了。

[0]
bindType=
class_0=
exe_0=
id_0=
[1]
bindType=
class_0=
exe_0=
id_0=
[2]
bindType=
class_0=
exe_0=
id_0=
[3]
bindType=
class_0=
exe_0=
id_0=
[4]
bindType=
class_0=
exe_0=
id_0=
[5]
bindType=
class_0=
exe_0=
id_0=
[6]
bindType=
class_0=
exe_0=
id_0=
[7]
bindType=
class_0=
exe_0=
id_0=
[8]
bindType=
class_0=
exe_0=
id_0=
)

; keysFunction.ahk
global lang_kf_getDebugText:=""
lang_kf_getDebugText=
(
供 TabScript 调试用字符串
点击"OK"将它复制到剪贴板
)
return
