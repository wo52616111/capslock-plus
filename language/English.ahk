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
global lang_yd_free_key_unavailable_warning:="Youdao Translate no longer provides free translation API, now you can only use the paid API (new accounts have a trial amount), please refer to the instructions in the [TTranslate] section of the CapsLock+settingsDemo.ini file to set up the key and use the translation function."

global lang_settingsFileContent:=""
lang_settingsFileContent=
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
global lang_settingsDemoFileContent_1:=""
global lang_settingsDemoFileContent_2:=""
lang_settingsDemoFileContent_1=
(
;------------ Encoding: UTF-16 ------------
; # CapsLock+ settings demo
; ****** PLEASE READ THE FOLLOWING INSTRUCTIONS: ******

; - The settings here are read-only, just for demonstration, don't modify the settings here, please write settings in
;   CapsLock+settings.ini. For example, if you need to turn on the auto start, please insert a line: autostart=1 under
;   [Global] in CapsLock+settings.ini, and save.

; - "[xxx]" is the section name, which cannot be modified.
; - The format of settings under each section is: key=value, one setting per line.
; - Although QSearch,QRun and QWeb are different sections, in theory, their key names can be repeated, but please keep
;   them unique, otherwise, the quick start function of +Q will not work properly.
; - The line beginning with a semicolon is a comment line. Comment lines do not affect the settings, just like these
;   lines.
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

; - You can use " ->search " to add a setting to [QSearch], like "g ->search https://www.google.com/search?q={q}",
;   will insert a line "g=https://www.google.com/search?q={q}" under the [QSearch] section.

; - You can add (0~n spaces)<xxx> to the right of the key name as a reminder

; - The following examples are also built-in search commands.

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

; - You can quickly add a setting through Qbar's " -> " command, for example: enter "exp2 -> E:\expFolder2\example2.exe"
;   in Qbar (each side a space), after confirmation, an item "exp2=E:\expFolder2\example2.exe" will be inserted.

; - If " -> " cannot correctly identify the file path and record the setting to [QWeb] or [TabHotString], you can use
;   " ->run " to force the recording to [QRun]

; - After you selecting a file (folder) and press +Q, the path will be filled in Qbar, so if you want to record a file to
;   open it quickly, you can do this:
;       1. Select the file
;       2. Press Capslock+Q, the path of the file will be filled in
;       3. Add "xxx -> " before the path
;       4. Press Enter, and confirm to record

; - You can add "(0~n spaces)<xxx>" after the key name as a reminder

; - You can set to run a program as administrator, or (and) with startup parameters. See the examples below.

[QRun]
; Normal
ie1=C:\Program Files\Internet Explorer\iexplore.exe

; Run as administrator
ie2=*runas "C:\Program Files\Internet Explorer\iexplore.exe"

; Run in full screen
ie3 <full screen>="C:\Program Files\Internet Explorer\iexplore.exe" -k

; Run as administrator, in full screen
ie4=*runas "C:\Program Files\Internet Explorer\iexplore.exe" -k



;----------------------------------------------------------------
; ## Qbar quickly open website settings

; - After adding a setting here, you can quickly open a link using the corresponding key name, for example:
;   There is a setting here: "cldocs=https://capslox.com/capslock-plus/en.html", then you can type "cldocs" in Qbar to open
;   "https://capslox.com/capslock-plus/en.html"

; - You can quickly add a setting through Qbar's " -> " command, for example:
;   Input "cl+ -> https://capslox.com/capslock-plus/en.html" in Qbar, a settting "cl+=https://capslox.com/capslock-plus/en.html"
;   will be inserted after confirmation.

; - If " -> " cannot correctly identify the URL and record the setting to [QRun] or [TabHotString], you can use
;   " ->web " to force the recording to [QWeb]

; - After you selecting an URL and press +Q, it will be filled in Qbar, so if you want to record an URL to open it
;   quickly, you can do this:
;       1. Select the URL
;       2. Press Capslock+Q, the URL will be filled in
;       3. Add "xxx -> " before the URL
;       4. Press Enter, and confirm to record

; - You can add "(0~n spaces)<xxx>" after the key name as a reminder

[QWeb]
cldocs=https://capslox.com/capslock-plus/en.html


;----------------------------------------------------------------;
; ## The hotstring settings of TabScript

; - Capslock + Tab will replace the string matching a key name on the left of the cursor with the corresponding value,
;   for example:
;   There is "@=capslock-plus@cjkis.me" here, then you can type "@" anywhere, and press "Capslock+Tab", the "@" will be
;   replaced with "capslock-plus@cjkis.me"

; - The priority of settings here is higher than the calculation function of CapsLock+Tab, for example:
;   If "1+1=3" is set here, then after typing "1+1", "CapsLock+Tab", "1+1" will be replaced by "3" instead of "2".

; - You can quickly add a setting through Qbar's " -> " command, for example:
;   Input "tel -> 1234567890" in Qbar, a setting "tel=1234567890" will be inserted after confirmation.

; - If the value of a setting is a string that looks like an URL, the " -> " command will probably determine it as a URL
;   or file (folder) path and record the setting in [QWeb] or [QRun], you can use " ->str " to force the recording to
;   [TabHotString]

; - After you selecting some text and press +Q, they will be filled in Qbar, so if you want to record some text:
;       1. Select some text
;       2. Press Capslock+Q, they will be filled in
;       3. Add "xxx -> " before the text
;       4. Press Enter, and confirm to record

[TabHotString]
clp=capslockplus

;----------------------------------------------------------------
; ## Qbar's style settings

[QStyle]
; Border color
; Specify one of 16 HTML basic colors or 6-bit RGB color values (the 0x prefix can be omitted). For example:
; red, ffffaa, FFFFAA, 0xFFFFAA. The color settings below are the same.

borderBackgroundColor=red

; Rounded corners, 0 means right angle
borderRadius=9

; The background color of the input box
textBackgroundColor=green

; The color of the input text
textColor=ffffff

; The font name of the input text
;editFontName=Consolas bold
textFontName=Hiragino Sans GB W6

; The font size of the input text
textFontSize=12

; The font name of the drop-down list
listFontName=consolas

; The font size of the drop-down list
listFontSize=10

; The background color of the drop-down list
listBackgroundColor=blue

; The text color of the drop-down list
listColor=0x000000

; The number of rows in the drop-down list
listCount=5

; The height of each row in the drop-down list
lineHeight=19

; Progress bar color
progressColor=0x00cc99

;----------------------------------------------------------------;
; ## +T Translation settings (Chinese <-> English)

[TTranslate]
; About Youdao API
; The translation function is implemented by calling Youdao API.

; Youdao's paid version API website: https://ai.youdao.com/console/#/
; Getting started docs about Youdao's API: https://ai.youdao.com/doc.s#guide

; Translation API type, currently can only be 1
; 0: Free version of Youdao API (no longer available, no longer provided by Youdao)
; 1: Paid version of Youdao API (default value)
apiType=1

; Parameters for paid version Youdao application

; Application ID
appPaidID=xxx

; Application key
appPaidKey=xxx

; Capslock+ could use either the free version or the paid version of the Yodao API before, to provide translation functions, now Yodao no longer provides the free version of the API,
; only the paid version of the API can be used. The following parameters related to the free version of the API have been deprecated, please delete them if they are used in your settings file.
; apiKey=xxx
; keyFrom=xxx


;----------------------------------------------------------------;

)

lang_settingsDemoFileContent_2=
(
; ## Hotkey settings

; - Available hotkeys:
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

; - The following setting key name is the hotkey name, the key value is the corresponding function,
;   all supported actions are below.

[Keys]
; Tap Caps Lock -> Send input: Esc
; press_caps=keyFunc_esc

; Tap Caps Lock -> Switch case
press_caps=keyFunc_toggleCapsLock

; Capslock+A -> Move Left a Word
caps_a=keyFunc_moveWordLeft

; Capslock+B -> Move Down 10 Times
caps_b=keyFunc_moveDown(10)

; The Extra Clipboard 1 - Copy
caps_c=keyFunc_copy_1

; Move Down
caps_d=keyFunc_moveDown

; Move Up
caps_e=keyFunc_moveUp

; Move Right
caps_f=keyFunc_moveRight

; Move Right a Word
caps_g=keyFunc_moveWordRight

; Select Left Word
caps_h=keyFunc_selectWordLeft

; Select Up
caps_i=keyFunc_selectUp

; Select Left
caps_j=keyFunc_selectLeft

; Select Down
caps_k=keyFunc_selectDown

; Select Right
caps_l=keyFunc_selectRight

; Select Down 10 Times
caps_m=keyFunc_selectDown(10)

; Select Right a Word
caps_n=keyFunc_selectWordRight

; Select to the End of the Line
caps_o=keyFunc_selectEnd

; Move to the beginning of the Line
caps_p=keyFunc_home

; QBar
caps_q=keyFunc_qbar

; Delete
caps_r=keyFunc_delete

; Move Left
caps_s=keyFunc_moveLeft

; Do Nothing
caps_t=keyFunc_doNothing

; Select to the beginning of the Line
caps_u=keyFunc_selectHome

; The Extra Clipboard 1 - Paste
caps_v=keyFunc_paste_1

; Backspace
caps_w=keyFunc_backspace

; The Extra Clipboard 1 - Cut
caps_x=keyFunc_cut_1

; Select Up 10 Times
caps_y=keyFunc_selectUp(10)

caps_z=keyFunc_doNothing

caps_backquote=keyFunc_doNothing

; Capslock+0~9 -> Activate the Binding Windows 0~9
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

; Delete Line
caps_backspace=keyFunc_deleteLine

; TabScript
caps_tab=keyFunc_tabScript

; Delete to the Beginning of the Line
caps_leftSquareBracket=keyFunc_deleteToLineBeginning

caps_rightSquareBracket=keyFunc_doNothing

caps_backslash=keyFunc_doNothing

; Capslock+; -> Move to the End of the Line
caps_semicolon=keyFunc_end

caps_quote=keyFunc_doNothing

; Insert Line Below
caps_enter=keyFunc_enterWherever

; Select the Current Word
caps_comma=keyFunc_selectCurrentWord

; Select Right a Word
caps_dot=keyFunc_selectWordRight

; Delete to the End of the Line
caps_slash=keyFunc_deleteToLineEnd

; Capslock+Space -> enter
caps_space=keyFunc_enter

; Capslock+RAlt -> Nothing
caps_right_alt=keyFunc_doNothing

; Open the Docs of Capslock+
caps_f1=keyFunc_openCpasDocs

; Math Board
caps_f2=keyFunc_mathBoard

; Youdao Translation
caps_f3=keyFunc_translate

; Make the active window transparent
caps_f4=keyFunc_winTransparent

; Reload Capslock+
caps_f5=keyFunc_reload

; Pin the active window
caps_f6=keyFunc_winPin

caps_f7=keyFunc_doNothing

caps_f8=keyFunc_getJSEvalString

caps_f9=keyFunc_doNothing

caps_f10=keyFunc_doNothing

caps_f11=keyFunc_doNothing

; Turn On / Off Extra Clipboards
caps_f12=keyFunc_switchClipboard

;--------------------LAlt--------------------

; Capslock+LAlt+A -> Move Left 3 Words
caps_lalt_a=keyFunc_moveWordLeft(3)

; Move Down 30 Times
caps_lalt_b=keyFunc_moveDown(30)

; The Extra Clipboard 2 - Copy
caps_lalt_c=keyFunc_copy_2

; Move Down 3 Times
caps_lalt_d=keyFunc_moveDown(3)

; Move Up 3 Times
caps_lalt_e=keyFunc_moveUp(3)

; Move Right 5 Times
caps_lalt_f=keyFunc_moveRight(5)

; Move Right 3 Words
caps_lalt_g=keyFunc_moveWordRight(3)

; Select Left 3 Words
caps_lalt_h=keyFunc_selectWordLeft(3)

; Move Up 3 Times
caps_lalt_i=keyFunc_selectUp(3)

; Select Left 5 Times
caps_lalt_j=keyFunc_selectLeft(5)

; Select Down 3 Times
caps_lalt_k=keyFunc_selectDown(3)

; Select Right 5 Times
caps_lalt_l=keyFunc_selectRight(5)

; Select Down 30 Times
caps_lalt_m=keyFunc_selectDown(30)

; Select Right 3 Words
caps_lalt_n=keyFunc_selectWordRight(3)

; Select to the End of the Page
caps_lalt_o=keyFunc_selectToPageEnd

; Move to the Beginning of the Page
caps_lalt_p=keyFunc_moveToPageBeginning

caps_lalt_q=keyFunc_doNothing

; Forward Delete Word
caps_lalt_r=keyFunc_forwardDeleteWord

; Move Left 5 Times
caps_lalt_s=keyFunc_moveLeft(5)

; Move Up 30 Times
caps_lalt_t=keyFunc_moveUp(30)

; Select to the Beginning of the Page
caps_lalt_u=keyFunc_selectToPageBeginning

; The Extra Clipboard 2 - Paste
caps_lalt_v=keyFunc_paste_2

; Delete Word
caps_lalt_w=keyFunc_deleteWord

; The Extra Clipboard 2 - Cut
caps_lalt_x=keyFunc_cut_2

; Select Up 30 Times
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

; Delete All
caps_lalt_backspace=keyFunc_deleteAll

caps_lalt_tab=keyFunc_doNothing

; Delete to the Beginning of the Page
caps_lalt_leftSquareBracket=keyFunc_deleteToPageBeginning

; Capslock+LAlt+]
caps_lalt_rightSquareBracket=keyFunc_doNothing

; Capslock+LAlt+\
caps_lalt_backslash=keyFunc_doNothing

; Move to the End of the Page
caps_lalt_semicolon=keyFunc_moveToPageEnd

caps_lalt_quote=keyFunc_doNothing

caps_lalt_enter=keyFunc_doNothing

; Select the Current Line
caps_lalt_comma=caps_comma=keyFunc_selectCurrentLine

; Select Right 3 Words
caps_lalt_dot=keyFunc_selectWordRight(3)

; Delete to the End of the Page
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

; CapsLock + Windows + 0~9 -> Bind window 0~9
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


;----------------Other Functions----------------

; wrap the selected text with specified characters, or input specified characters
; examples:
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

; Previous media
keyFunc_mediaPrev

; Play / Pause
keyFunc_mediaPlayPause

; Volume Up
keyFunc_volumeUp

; Volume Down
keyFunc_volumeDown

; Mute
keyFunc_volumeMute

; click left mouse button
keyfunc_click_left

; click right mouse button
keyfunc_click_right

; mouse movement
keyfunc_mouse_up

keyfunc_mouse_down

keyfunc_mouse_left

keyfunc_mouse_right

; mouse wheel up (away from you)
keyfunc_wheel_up

; mouse wheel down (toward you)
keyfunc_wheel_down


)
global lang_winsInfosRecorderIniInit:=""
lang_winsInfosRecorderIniInit=
(
;------------ Encoding: UTF-16 ------------
; The data for Window Binding, DO NOT modify the content of this file!
; Just click the "X" in the upper right.

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
The string for debug TabScript
Click "OK" to copy it to the clipboard.
)
return
