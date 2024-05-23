language_Simplified_Chinese:
; lib\lib_bindWins.ahk
global lang_bw_noWIRini:="CapsLock+winsInfosRecorder.ini 不存在"

; lib_clq.ahk
global lang_clq_addIni:="确定将以下字符串简写成 {replace0}，并记录到 {replace1}？"
global lang_clq_existing:="{replace0}`n已存在于 {replace1}，确定用以下设置覆盖？"
global lang_clq_qrunFileNotExist:="QRun中存在以下记录，而对应文件（文件夹）不存在，是否删除该设置？"
global lang_clq_noCmd:="没有该命令"
global lang_clq_emptyFolder:="<空文件夹>"

; ydTrans.ahk
global lang_yd_translating:="翻译中...  （如果网络太差，翻译请求会暂时阻塞程序，稍等就好）"
global lang_yd_name:="有道翻译"
global lang_yd_needKey:="缺少有道翻译API的key，有道翻译无法使用"
global lang_yd_fileNotExist:="文件（文件夹）不存在"
global lang_yd_errorNoNet:="发送异常，可能是网络已断开"
global lang_yd_errorTooLong:="部分句子过长"
global lang_yd_errorNoResults:="无词典结果"
global lang_yd_errorTextTooLong:="要翻译的文本过长"
global lang_yd_errorCantTrans:="无法进行有效的翻译"
global lang_yd_errorLangType:="不支持的语言类型"
global lang_yd_errorKeyInvalid:="无效的key"
global lang_yd_errorSpendingLimit:="已达到今日消费上限，或者请求长度超过今日可消费字符数"
global lang_yd_errorNoFunds:="帐户余额不足"
global lang_yd_trans:="------------------------------------有道翻译------------------------------------"
global lang_yd_dict:="------------------------------------有道词典------------------------------------"
global lang_yd_phrase:="--------------------------------------短语--------------------------------------"
global lang_yd_free_key_unavailable_warning:="有道翻译已经不再提供免费的翻译 API，现在只能使用收费 API（新账号有试用额度），请参考 CapsLock+settingsDemo.ini 文件中 [TTranslate] 部分的说明设置密钥后使用翻译功能。"

global lang_settingsFileContent:=""
lang_settingsFileContent=
(
;------------ Encoding: UTF-16 ------------
;请对照 CapsLock+settingsDemo.ini 来配置相关设置
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
global lang_settingsDemoFileContent_1:=""
global lang_settingsDemoFileContent_2:=""
lang_settingsDemoFileContent_1=
(
;------------ Encoding: UTF-16 ------------
; # CapsLock+ 设置样本
; - ******请务必阅读以下说明：******

; - **这里的设置是只读的，仅作说明参考，不要修改这里的设置（修改了也无效），需要自定义设置请在 CapsLock+settings.ini 中的对应段名中作添加修改
;     例如，需要开启开机自启动，请在 CapsLock+settings.ini 的 [Global] 下添加：autostart=1，并保存

; - "[]"里面是段名，不能修改
; - 各段下所有设置的格式都为：键名=键值，每行一个
; - 虽然 QSearch,QRun 和 QWeb 是不同的段，理论上它们的键名可以重复，但请不要这样设置，否则 +Q 的快速启动功能会无法区分
; - 分号开头的是注释行，注释行不影响设置，就像这几行
; - 以下把 Capslock+Q 弹出的输入框称为 "Qbar"


;----------------------------------------------------------------
; ## 全局设置
[Global]
;是否开机自启动，1为是，0为否（默认）。
autostart=0

;热键布局方案，可选值：
;- capslock_plus  Capslock+ 3.0 之前的布局
;- capslox（默认）  Capslock+ 3.0 之后的布局
default_hotkey_scheme=capslox

;需要加载的 JavaScript 文件，以逗号分隔，文件应放在与 Capslock+ 程序同文件夹下的 loadScript 文件夹。
;Capslock+ 将会按照顺序加载，加载完后 +Tab 可以使用里面的函数
;在本设置不为空时，启动 Capslock+ 时将自动创建 loadScript 文件夹，以及位于文件夹中的 debug.html 和 scriptDemo.js 文件
loadScript=myScript1.js,myScript2.js, myScript3.js , myScript4.js

;按下 Capslock+LAlt 键时，临时改变鼠标速度，范围是1~20。不设置的话默认3
;可以用 Capslock+LAlt+鼠标滚轮上 / 下快速设置这个值
mouseSpeed=3

;是否允许独立剪贴板功能，1为是（默认），0为否
allowClipboard=1

;是否开启程序加载动画，1是（默认），0否
loadingAnimation=1

;----------------------------------------------------------------
; ## Qbar搜索指令设置

; - 除default外的键名为搜索指令，该指令会按对应的搜索链接搜索关键词，例如：
;        这里设置了"bd=https://www.baidu.com/s?wd={q}"，可以在 Qbar 输入"bd capslock+"来百度搜索关键词"capslock+"
;   （不过bd这个指令已经自带，不需要设置，但可以通过将bd设置成别的链接来替换成别的搜索）

; - default为不输入任何指令时将使用的搜索

; - 键名可以自定义，如果下列例子中键名对应的键值没有被修改，Capslock+将保留相应的搜索指令

; - 每个网站的搜索链接（这里的键值）都不一样，可以尝试这样获取（不保证准确）：
;    1. 打开需要获取搜索链接的网站
;    2. 在搜索栏输入任意字符，例如"capslockplus"，搜索（有没有搜索出结果无所谓）
;    3. 在跳转后的地址栏中找到刚刚输入的字符，找到刚才搜索的字符并替换成"{q}"（不包括引号），得到搜索链接（替换后地址栏上的所有字符）

; - 可以使用 " ->search " 来添加一条设置到[QSearch]

; - 可以在键名的右边加上 （0~n个空格）<xxx> 来作为备注提示

[QSearch]

default=https://www.baidu.com/s?wd={q}
bd=https://www.baidu.com/s?wd={q}
g   <google>=https://www.google.com/search?q={q}
tb  <taobao>=http://s.taobao.com/search?q={q}
wk=https://zh.wikipedia.org/w/index.php?search={q}
m=https://developer.mozilla.org/zh-CN/search?q={q}


;----------------------------------------------------------------
; ## Qbar 快速打开文件（文件夹）设置

; - 在这里添加一条设置后，就可以在 Qbar 用键名快速打开对应键值设置的文件或文件夹，例如：
;        这里设置了"exp=E:\expFolder\example.exe"，在 Qbar 输入"exp"，回车后会打开"E:\expFolder\example.exe"这个文件

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
; ## Qbar 快速打开网页设置

; - 在这里添加一条设置后，可以在 Qbar 用键名快速打开对应键值设置的链接，例如：
;        这里设置了"cldocs=https://capslox.com/capslock-plus"，在 Qbar 输入"cldocs"，回车后会用默认浏览器打开"https://capslox.com/capslock-plus"

; - 可以通过 Qbar 的 " -> " 指令快速添加一项设置，例如：在 Qbar 输入"cl+ -> https://capslox.com/capslock-plus"（" -> "两边各有一个空格），确认后将会在这里添加一项"cl+=https://capslox.com/capslock-plus"

; - 如果 " -> " 无法正确识别网址而把设置记录到了[QRun]或[TabHotString]，可以使用 " ->web " 来强制记录到[QWeb]

; - 选中网址后，按 +Q ，可以将网址填入 Qbar ，那么，你想记录一个网址来快速打开，就可以这么操作：
;       1. 选中该网址
;       2. 按下 Capslock+Q，弹出的输入框内自动填入了该网址
;       3. 在路径的最前面加上"xxx -> "
;       4. 按下 Enter 键，确认记录

; - 可以在键名的右边加上 （0~n个空格）<xxx> 来作为备注提示

[QWeb]
cldocs=https://capslox.com/capslock-plus



;----------------------------------------------------------------;
; ## TabScript 的字符替换设置

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
; ## Qbar 的样式设置

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
textFontName=Hiragino Sans GB W6

;输入文字大小
textFontSize=12

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
; ## +T翻译设置

[TTranslate]
;有道api接口
;翻译功能通过调用有道的api实现。

;收费版api申请网址: https://ai.youdao.com/console/#/
;有道翻译 API 入门指南: https://ai.youdao.com/doc.s#guide

;翻译 API 类型，目前只能为 1
;0: 免费版有道 API（已不可使用，有道翻译不再提供）
;1: 收费版有道 API（默认值）
apiType=1

;收费版申请的参数

;应用ID
appPaidID=xxx

;应用密钥
appPaidKey=xxx

;曾经 Capslock+ 可以选择使用免费版或收费版的有道 API 来提供翻译功能，现在有道已经不再提供免费版 API，
;只能使用收费版的 API，以下与免费版 API 相关的参数已经废弃，如果你的设置文件中有使用，请删除掉。
;apiKey=xxx
;keyFrom=xxx

;----------------------------------------------------------------;

)

lang_settingsDemoFileContent_2=
(
; ## 按键功能设置

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
;press_caps=keyFunc_esc

;短按 Caps Lock -> 切换大小写
press_caps=keyFunc_toggleCapsLock

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

; QBar
caps_q=keyFunc_qbar

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

;Capslock+0~9 -> 激活绑定窗口 0~9
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

caps_minus=keyFunc_qbar_upperFolderPath

caps_equal=keyFunc_qbar_lowerFolderPath

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

;选中当前单词
caps_comma=keyFunc_selectCurrentWord

;向右选中单词
caps_dot=keyFunc_selectWordRight

;删除至行尾
caps_slash=keyFunc_deleteToLineEnd

;Capslock+Space -> enter
caps_space=keyFunc_enter

;Capslock+RAlt -> 无
caps_right_alt=keyFunc_doNothing

;打开 Capslock+ 首页
caps_f1=keyFunc_openCpasDocs

;Math Board
caps_f2=keyFunc_mathBoard

;有道翻译
caps_f3=keyFunc_translate

;窗口透明
caps_f4=keyFunc_winTransparent

;重载 Capslock+
caps_f5=keyFunc_reload

;窗口置顶
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

;下移 30 次
caps_lalt_b=keyFunc_moveDown(30)

;独立剪贴板 2 的复制
caps_lalt_c=keyFunc_copy_2

;下移 3 次
caps_lalt_d=keyFunc_moveDown(3)

;上移 3 次
caps_lalt_e=keyFunc_moveUp(3)

;右移 5 次
caps_lalt_f=keyFunc_moveRight(5)

;右移 3 个单词
caps_lalt_g=keyFunc_moveWordRight(3)

;向左选中 3 个单词
caps_lalt_h=keyFunc_selectWordLeft(3)

;向上选中 3 次
caps_lalt_i=keyFunc_selectUp(3)

;向左选中 5 个字符
caps_lalt_j=keyFunc_selectLeft(5)

;向下选中 3 次
caps_lalt_k=keyFunc_selectDown(3)

;向右选中 5 个字符
caps_lalt_l=keyFunc_selectRight(5)

;向下选中 30 次
caps_lalt_m=keyFunc_selectDown(30)

;向右选中 3 个单词
caps_lalt_n=keyFunc_selectWordRight(3)

;选中至页尾
caps_lalt_o=keyFunc_selectToPageEnd

;移动至页首
caps_lalt_p=keyFunc_moveToPageBeginning

caps_lalt_q=keyFunc_doNothing

;向前删除单词
caps_lalt_r=keyFunc_forwardDeleteWord

;左移 5 次
caps_lalt_s=keyFunc_moveLeft(5)

;上移 30 次
caps_lalt_t=keyFunc_moveUp(30)

;选中至页首
caps_lalt_u=keyFunc_selectToPageBeginning

;独立剪贴板 2 的粘贴
caps_lalt_v=keyFunc_paste_2

;删除单词
caps_lalt_w=keyFunc_deleteWord

;独立剪贴板 2 的 剪切
caps_lalt_x=keyFunc_cut_2

;向上选中 30 次
caps_lalt_y=keyFunc_selectUp(30)

caps_lalt_z=keyFunc_doNothing

caps_lalt_backquote=keyFunc_doNothing

caps_lalt_1=keyFunc_winbind_binding(1)

caps_lalt_2=keyFunc_winbind_binding(2)

caps_lalt_3=keyFunc_winbind_binding(3)

caps_lalt_4=keyFunc_winbind_binding(4)

caps_lalt_5=keyFunc_winbind_binding(5)

caps_lalt_6=keyFunc_winbind_binding(6)

caps_lalt_7=keyFunc_winbind_binding(7)

caps_lalt_8=keyFunc_winbind_binding(8)

caps_lalt_9=keyFunc_winbind_binding(9)

caps_lalt_0=keyFunc_winbind_binding(10)

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

;选中当前行
caps_lalt_comma=caps_comma=keyFunc_selectCurrentLine

;向右选中 3 个单词
caps_lalt_dot=keyFunc_selectWordRight(3)

;删除至页尾
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

; CapsLock + Windows + 0~9 -> 绑定窗口 0~9
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

; 用指定的字符包裹选定的文本，或输出指定的字符
; 例如:
;
; "..."
; caps_quote=keyFunc_doubleChar(""")
;
; (...)
; caps_9=keyFunc_doubleChar((,))
;
; {...}
; caps_leftSquareBracket=keyFunc_doubleChar({,})
;
; [...]
; caps_rightSquareBracket=keyFunc_doubleChar([,])
;
keyFunc_doubleChar

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

; 鼠标左键点击
keyfunc_click_left

; 鼠标右键点击
keyfunc_click_right

; 移动鼠标（长按可加快移动速度）
keyfunc_mouse_up

keyfunc_mouse_down

keyfunc_mouse_left

keyfunc_mouse_right

; 滚轮上滑
keyfunc_wheel_up

; 滚轮下滑
keyfunc_wheel_down

)
global lang_winsInfosRecorderIniInit:=""
lang_winsInfosRecorderIniInit=
(
;------------ Encoding: UTF-16 ------------
;这里记录着窗口的数据，不要手动修改本文件内容，点下右上角的"X"就好。

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
