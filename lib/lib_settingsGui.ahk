; CapsLock+ 可视化设置面板。先承载窗口顶置设置，后续分类可继续迁入。

global settingsGuiHwnd:=0
global settingsGuiTrayLabel:=""
global settingsGuiPage:="general"
global settingsGuiPhrases:=[]

settingsGui_init(){
    global settingsGuiTrayLabel

    settingsGuiTrayLabel:=isLangChinese() ? "设置..." : "Settings..."
    ; 标准托盘项不能直接用 Menu, Insert 定位。先暂时移除并恢复标准项，
    ; 将设置放在标准项之前，因此自然位于 Exit 上方且不会破坏系统菜单。
    Menu, Tray, NoStandard
    Menu, Tray, Add, %settingsGuiTrayLabel%, settingsGuiOpenFromTray
    Menu, Tray, Standard
    settingsGui_cleanupConfigDefaults()
}

settingsGui_show(){
    global settingsGuiHwnd, SettingsNavGeneralHighlight, SettingsNavPinHighlight, SettingsNavQbarHighlight, SettingsNavHotkeysHighlight, SettingsNavPhrasesHighlight
    global SettingsNavGeneral, SettingsNavPin, SettingsNavQbar, SettingsNavHotkeys, SettingsNavPhrases
    global SettingsGeneralTitle, SettingsGeneralDescription, SettingsAutostart, SettingsLoadingAnimation, SettingsAllowClipboard
    global SettingsMouseSpeedLabel, SettingsMouseSpeed, SettingsSchemeLabel, SettingsHotkeyScheme
    global SettingsHotkeysTitle, SettingsHotkeysDescription, SettingsHotkeysHint
    global SettingsPinTitle, SettingsPinDescription, SettingsPinColorLabel, SettingsPinColorPreview, SettingsPinColorEdit
    global SettingsPinChooseColor, SettingsPinColorHint, SettingsPinSoundEnabled, SettingsPinSoundFileLabel
    global SettingsPinSoundFile, SettingsPinChooseSound, SettingsPinSoundDefaultHint
    global SettingsQbarTitle, SettingsQbarDescription, SettingsQbarExternalApp, SettingsQbarExternalAppLabel, SettingsQbarExternalAppHint
    global SettingsQbarExternalPath, SettingsQbarExternalPathLabel, SettingsQbarExternalPathHint, SettingsQbarChooseExternalPath
    global SettingsPhrasesTitle, SettingsPhrasesDescription, SettingsPhraseListView, SettingsPhraseTriggerLabel, SettingsPhraseReplacementLabel
    global SettingsPhraseTrigger, SettingsPhraseReplacement, SettingsPhraseAddButton, SettingsPhraseDeleteButton
    global SettingsGuiStatus

    if(settingsGuiHwnd && DllCall("IsWindow", "Ptr", settingsGuiHwnd))
    {
        settingsGui_loadValues()
        Gui, SettingsGui:Show
        WinActivate, ahk_id %settingsGuiHwnd%
        return
    }

    chinese:=isLangChinese()
    if(chinese)
    {
        windowTitle:="CapsLock+ 设置"
        pinCategory:="窗口顶置"
        generalLabel:="常规"
        hotkeysLabel:="快捷键"
        hotkeysTitle:="快捷键"
        hotkeysDescription:="选择 CapsLock+ 的快捷键布局。"
        hotkeysHint:="Capslox 为新版布局；CapsLock+ 旧版适合习惯旧快捷键的用户。"
        phrasesLabel:="常用语"
        phrasesTitle:="常用语"
        phrasesDescription:="设置 CapsLock+Tab 的文字替换短语；选中条目后直接编辑，点击底部“保存”。"
        phrasesTriggerLabel:="触发词"
        phrasesReplacementLabel:="替换内容"
        phrasesAddLabel:="添加"
        phrasesDeleteLabel:="删除"
        qbarLabel:="Qbar"
        qbarTitle:="Qbar"
        qbarDescription:="选择 CapsLock+Q 使用内置 Qbar，或绑定外部程序。"
        qExternalAppLabel:="CapsLock+Q 绑定"
        qExternalAppItems:="内置 Qbar|外部程序"
        qExternalAppHint:="选择外部程序后，CapsLock+Q 会启动或激活该程序。"
        qExternalPathLabel:="外部程序路径"
        qExternalChoosePathLabel:="选择程序..."
        qExternalPathHint:="选择外部程序后必须填写有效路径，保存时会检查文件是否存在。"
        generalTitle:="常规"
        generalDescription:="管理 CapsLock+ 的启动方式与基础行为。"
        autostartLabel:="开机时自动启动 CapsLock+"
        loadingLabel:="启动时显示加载动画"
        clipboardLabel:="启用独立剪贴板"
        mouseSpeedLabel:="CapsLock + 左 Alt 临时鼠标速度"
        schemeLabel:="快捷键布局"
        schemeItems:="Capslox（推荐）|CapsLock+ 旧版"
        pageTitle:="窗口顶置"
        pageDescription:="设置窗口顶置后的视觉边框与操作反馈。"
        colorLabel:="外边框颜色"
        colorHint:="支持 RGB（65, 131, 143）或十六进制（#fdfdfd）"
        chooseLabel:="选择颜色..."
        soundLabel:="顶置或取消顶置时播放提示音"
        soundFileLabel:="自定义音效文件"
        chooseSoundLabel:="选择音效..."
        soundDefaultHint:="留空时使用 PowerToys 同款的 Speech On / Speech Sleep"
        resetLabel:="恢复默认"
        cancelLabel:="取消"
        saveLabel:="保存"
        advancedLabel:="打开高级配置文件"
    }
    else
    {
        windowTitle:="CapsLock+ Settings"
        pinCategory:="Always on top"
        generalLabel:="General"
        hotkeysLabel:="Hotkeys"
        hotkeysTitle:="Hotkeys"
        hotkeysDescription:="Choose the CapsLock+ keyboard layout."
        hotkeysHint:="Capslox is the current layout; Legacy keeps the older shortcut arrangement."
        phrasesLabel:="Phrases"
        phrasesTitle:="Phrases"
        phrasesDescription:="Manage CapsLock+Tab phrases; edit a selected row and click Save below."
        phrasesTriggerLabel:="Trigger"
        phrasesReplacementLabel:="Replacement"
        phrasesAddLabel:="Add"
        phrasesDeleteLabel:="Delete"
        qbarLabel:="Qbar"
        qbarTitle:="Qbar"
        qbarDescription:="Use the built-in Qbar or bind CapsLock+Q to an external app."
        qExternalAppLabel:="CapsLock+Q binding"
        qExternalAppItems:="Built-in Qbar|External app"
        qExternalAppHint:="When an external app is selected, CapsLock+Q starts or activates it."
        qExternalPathLabel:="External app path"
        qExternalChoosePathLabel:="Browse..."
        qExternalPathHint:="An existing path is required when an external app is selected."
        generalTitle:="General"
        generalDescription:="Manage startup and basic CapsLock+ behavior."
        autostartLabel:="Start CapsLock+ when Windows starts"
        loadingLabel:="Show the loading animation at startup"
        clipboardLabel:="Enable independent clipboards"
        mouseSpeedLabel:="Temporary mouse speed for CapsLock + Left Alt"
        schemeLabel:="Hotkey layout"
        schemeItems:="Capslox (recommended)|Legacy CapsLock+"
        pageTitle:="Always on top"
        pageDescription:="Configure the border and feedback for pinned windows."
        colorLabel:="Border color"
        colorHint:="RGB (65, 131, 143) or hex (#fdfdfd)"
        chooseLabel:="Choose color..."
        soundLabel:="Play a sound when pinning or unpinning"
        soundFileLabel:="Custom sound file"
        chooseSoundLabel:="Choose sound..."
        soundDefaultHint:="Leave empty to use PowerToys Speech On / Speech Sleep"
        resetLabel:="Reset"
        cancelLabel:="Cancel"
        saveLabel:="Save"
        advancedLabel:="Open advanced config"
    }

    Gui, SettingsGui:New, +HwndsettingsGuiHwnd -MaximizeBox +MinimizeBox, %windowTitle%
    Gui, SettingsGui:Margin, 0, 0
    Gui, SettingsGui:Color, F4F6F8

    ; 左侧分类栏
    Gui, SettingsGui:Add, Progress, x0 y0 w190 h520 Background20242B c20242B Disabled, 100
    Gui, SettingsGui:Font, s15 w600 cFFFFFF, Microsoft YaHei UI
    Gui, SettingsGui:Add, Text, x20 y22 w150 h30 BackgroundTrans, CapsLock+
    Gui, SettingsGui:Font, s9 w400 c89919D, Microsoft YaHei UI
    Gui, SettingsGui:Add, Text, x20 y55 w150 h22 BackgroundTrans, %windowTitle%
    Gui, SettingsGui:Add, Progress, x12 y96 w166 h42 vSettingsNavGeneralHighlight Background1677FF c1677FF Disabled, 100
    Gui, SettingsGui:Font, s10 w600 cFFFFFF, Microsoft YaHei UI
    Gui, SettingsGui:Add, Text, x28 y106 w138 h24 vSettingsNavGeneral BackgroundTrans Center gSettingsGuiShowGeneral, %generalLabel%
    Gui, SettingsGui:Add, Progress, x12 y144 w166 h42 vSettingsNavPinHighlight Background1677FF c1677FF Disabled, 100
    Gui, SettingsGui:Add, Text, x28 y154 w138 h24 vSettingsNavPin BackgroundTrans Center gSettingsGuiShowPin, %pinCategory%
    Gui, SettingsGui:Add, Progress, x12 y192 w166 h42 vSettingsNavQbarHighlight Background1677FF c1677FF Disabled, 100
    Gui, SettingsGui:Add, Text, x28 y202 w138 h24 vSettingsNavQbar BackgroundTrans Center gSettingsGuiShowQbar, %qbarLabel%
    Gui, SettingsGui:Add, Progress, x12 y246 w166 h42 vSettingsNavHotkeysHighlight Background1677FF c1677FF Disabled, 100
    Gui, SettingsGui:Add, Text, x28 y256 w138 h24 vSettingsNavHotkeys BackgroundTrans Center gSettingsGuiShowHotkeys, %hotkeysLabel%
    Gui, SettingsGui:Add, Progress, x12 y300 w166 h42 vSettingsNavPhrasesHighlight Background1677FF c1677FF Disabled, 100
    Gui, SettingsGui:Add, Text, x28 y310 w138 h24 vSettingsNavPhrases BackgroundTrans Center gSettingsGuiShowPhrases, %phrasesLabel%
    Gui, SettingsGui:Font, s9 w400 cAAB1BA, Microsoft YaHei UI
    Gui, SettingsGui:Add, Text, x22 y472 w150 h28 BackgroundTrans gSettingsGuiOpenAdvanced Center 0x200, %advancedLabel%

    ; 右侧内容区
    Gui, SettingsGui:Add, Progress, x190 y0 w590 h520 BackgroundFFFFFF cFFFFFF Disabled, 100
    ; 常规设置页
    Gui, SettingsGui:Font, s18 w600 c20242B, Microsoft YaHei UI
    Gui, SettingsGui:Add, Text, x226 y28 w510 h36 vSettingsGeneralTitle BackgroundTrans, %generalTitle%
    Gui, SettingsGui:Font, s9 w400 c68717D, Microsoft YaHei UI
    Gui, SettingsGui:Add, Text, x228 y70 w500 h24 vSettingsGeneralDescription BackgroundTrans, %generalDescription%
    Gui, SettingsGui:Font, s10 w400 c252A31, Microsoft YaHei UI
    Gui, SettingsGui:Add, Checkbox, x228 y126 w420 h26 vSettingsAutostart, %autostartLabel%
    Gui, SettingsGui:Add, Checkbox, x228 y172 w420 h26 vSettingsLoadingAnimation, %loadingLabel%
    Gui, SettingsGui:Add, Checkbox, x228 y218 w420 h26 vSettingsAllowClipboard, %clipboardLabel%
    Gui, SettingsGui:Font, s10 w600 c252A31, Microsoft YaHei UI
    Gui, SettingsGui:Add, Text, x228 y276 w350 h24 vSettingsMouseSpeedLabel BackgroundTrans, %mouseSpeedLabel%
    Gui, SettingsGui:Font, s10 w400 c252A31, Microsoft YaHei UI
    Gui, SettingsGui:Add, DropDownList, x228 y308 w150 vSettingsMouseSpeed, 1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20
    ; 快捷键设置页
    Gui, SettingsGui:Font, s18 w600 c20242B, Microsoft YaHei UI
    Gui, SettingsGui:Add, Text, x226 y28 w510 h36 vSettingsHotkeysTitle BackgroundTrans, %hotkeysTitle%
    Gui, SettingsGui:Font, s9 w400 c68717D, Microsoft YaHei UI
    Gui, SettingsGui:Add, Text, x228 y70 w500 h24 vSettingsHotkeysDescription BackgroundTrans, %hotkeysDescription%
    Gui, SettingsGui:Font, s10 w600 c252A31, Microsoft YaHei UI
    Gui, SettingsGui:Add, Text, x228 y132 w240 h24 vSettingsSchemeLabel BackgroundTrans, %schemeLabel%
    Gui, SettingsGui:Font, s10 w400 c252A31, Microsoft YaHei UI
    Gui, SettingsGui:Add, DropDownList, x228 y166 w300 r2 vSettingsHotkeyScheme AltSubmit, %schemeItems%
    Gui, SettingsGui:Font, s9 w400 c68717D, Microsoft YaHei UI
    Gui, SettingsGui:Add, Text, x228 y216 w500 h40 vSettingsHotkeysHint BackgroundTrans, %hotkeysHint%

    ; 窗口顶置设置页
    Gui, SettingsGui:Font, s18 w600 c20242B, Microsoft YaHei UI
    Gui, SettingsGui:Add, Text, x226 y28 w510 h36 vSettingsPinTitle BackgroundTrans, %pageTitle%
    Gui, SettingsGui:Font, s9 w400 c68717D, Microsoft YaHei UI
    Gui, SettingsGui:Add, Text, x228 y70 w500 h24 vSettingsPinDescription BackgroundTrans, %pageDescription%

    Gui, SettingsGui:Font, s10 w600 c252A31, Microsoft YaHei UI
    Gui, SettingsGui:Add, Text, x228 y126 w180 h24 vSettingsPinColorLabel BackgroundTrans, %colorLabel%
    Gui, SettingsGui:Add, Progress, x228 y158 w44 h36 vSettingsPinColorPreview Background00ADEF c00ADEF Disabled, 100
    Gui, SettingsGui:Font, s10 w400 c252A31, Microsoft YaHei UI
    Gui, SettingsGui:Add, Edit, x284 y158 w220 h36 vSettingsPinColorEdit gSettingsGuiColorChanged
    Gui, SettingsGui:Add, Button, x516 y157 w112 h38 vSettingsPinChooseColor gSettingsGuiChooseColor, %chooseLabel%
    Gui, SettingsGui:Font, s8 w400 c7B8490, Microsoft YaHei UI
    Gui, SettingsGui:Add, Text, x284 y200 w350 h20 vSettingsPinColorHint BackgroundTrans, %colorHint%

    Gui, SettingsGui:Font, s10 w400 c252A31, Microsoft YaHei UI
    Gui, SettingsGui:Add, Checkbox, x228 y258 w380 h26 vSettingsPinSoundEnabled, %soundLabel%
    Gui, SettingsGui:Font, s10 w600 c252A31, Microsoft YaHei UI
    Gui, SettingsGui:Add, Text, x228 y304 w240 h24 vSettingsPinSoundFileLabel BackgroundTrans, %soundFileLabel%
    Gui, SettingsGui:Font, s9 w400 c252A31, Microsoft YaHei UI
    Gui, SettingsGui:Add, Edit, x228 y336 w380 h36 vSettingsPinSoundFile ReadOnly
    Gui, SettingsGui:Add, Button, x620 y335 w118 h38 vSettingsPinChooseSound gSettingsGuiChooseSound, %chooseSoundLabel%
    Gui, SettingsGui:Font, s8 w400 c7B8490, Microsoft YaHei UI
    Gui, SettingsGui:Add, Text, x228 y378 w500 h20 vSettingsPinSoundDefaultHint BackgroundTrans, %soundDefaultHint%

    ; Qbar 设置页：只保留外部程序绑定，样式继续使用配置文件中的默认值。
    Gui, SettingsGui:Font, s18 w600 c20242B, Microsoft YaHei UI
    Gui, SettingsGui:Add, Text, x226 y28 w510 h36 vSettingsQbarTitle BackgroundTrans, %qbarTitle%
    Gui, SettingsGui:Font, s9 w400 c68717D, Microsoft YaHei UI
    Gui, SettingsGui:Add, Text, x228 y70 w500 h24 vSettingsQbarDescription BackgroundTrans, %qbarDescription%
    Gui, SettingsGui:Font, s10 w600 c252A31, Microsoft YaHei UI
    Gui, SettingsGui:Add, Text, x228 y132 w180 h24 vSettingsQbarExternalAppLabel BackgroundTrans, %qExternalAppLabel%
    Gui, SettingsGui:Font, s10 w400 c252A31, Microsoft YaHei UI
    ; r2 让下拉列表一次显示两个选项。
    Gui, SettingsGui:Add, DropDownList, x228 y166 w280 r2 vSettingsQbarExternalApp gSettingsGuiQbarExternalChanged AltSubmit, %qExternalAppItems%
    Gui, SettingsGui:Font, s9 w400 c68717D, Microsoft YaHei UI
    Gui, SettingsGui:Add, Text, x228 y216 w500 h40 vSettingsQbarExternalAppHint BackgroundTrans, %qExternalAppHint%
    Gui, SettingsGui:Font, s10 w600 c252A31, Microsoft YaHei UI
    Gui, SettingsGui:Add, Text, x228 y276 w240 h24 vSettingsQbarExternalPathLabel BackgroundTrans, %qExternalPathLabel%
    Gui, SettingsGui:Font, s9 w400 c252A31, Microsoft YaHei UI
    Gui, SettingsGui:Add, Edit, x228 y310 w380 h32 vSettingsQbarExternalPath
    Gui, SettingsGui:Add, Button, x620 y309 w118 h34 vSettingsQbarChooseExternalPath gSettingsGuiChooseExternalPath, %qExternalChoosePathLabel%
    Gui, SettingsGui:Font, s8 w400 c68717D, Microsoft YaHei UI
    Gui, SettingsGui:Add, Text, x228 y350 w500 h32 vSettingsQbarExternalPathHint BackgroundTrans, %qExternalPathHint%

    ; 常用语设置页
    phraseColumns:=phrasesTriggerLabel . "|" . phrasesReplacementLabel
    Gui, SettingsGui:Font, s18 w600 c20242B, Microsoft YaHei UI
    Gui, SettingsGui:Add, Text, x226 y28 w510 h36 vSettingsPhrasesTitle BackgroundTrans, %phrasesTitle%
    Gui, SettingsGui:Font, s9 w400 c68717D, Microsoft YaHei UI
    Gui, SettingsGui:Add, Text, x228 y70 w500 h24 vSettingsPhrasesDescription BackgroundTrans, %phrasesDescription%
    Gui, SettingsGui:Font, s9 w400 c252A31, Microsoft YaHei UI
    Gui, SettingsGui:Add, ListView, x228 y112 w510 h190 vSettingsPhraseListView gSettingsGuiPhraseListChanged Grid AltSubmit, %phraseColumns%
    Gui, SettingsGui:Font, s9 w600 c252A31, Microsoft YaHei UI
    Gui, SettingsGui:Add, Text, x228 y318 w245 h22 vSettingsPhraseTriggerLabel BackgroundTrans, %phrasesTriggerLabel%
    Gui, SettingsGui:Add, Text, x493 y318 w245 h22 vSettingsPhraseReplacementLabel BackgroundTrans, %phrasesReplacementLabel%
    Gui, SettingsGui:Font, s9 w400 c252A31, Microsoft YaHei UI
    Gui, SettingsGui:Add, Edit, x228 y342 w245 h48 vSettingsPhraseTrigger
    Gui, SettingsGui:Add, Edit, x493 y342 w245 h48 r3 vSettingsPhraseReplacement
    Gui, SettingsGui:Add, Button, x228 y400 w96 h32 vSettingsPhraseAddButton gSettingsGuiPhraseAdd, %phrasesAddLabel%
    Gui, SettingsGui:Add, Button, x334 y400 w96 h32 vSettingsPhraseDeleteButton gSettingsGuiPhraseDelete, %phrasesDeleteLabel%
    Gui, SettingsGui:Font, s9 w400 c287A46, Microsoft YaHei UI
    Gui, SettingsGui:Add, Text, x228 y432 w500 h20 vSettingsGuiStatus BackgroundTrans
    Gui, SettingsGui:Font, s9 w400 c252A31, Microsoft YaHei UI
    Gui, SettingsGui:Add, Button, x228 y462 w112 h38 gSettingsGuiReset, %resetLabel%
    Gui, SettingsGui:Add, Button, x522 y462 w96 h38 gSettingsGuiCancel, %cancelLabel%
    Gui, SettingsGui:Add, Button, x630 y462 w108 h38 gSettingsGuiSave Default, %saveLabel%

    settingsGui_loadValues()
    settingsGui_setPage("general")
    Gui, SettingsGui:Show, w780 h520 Center, %windowTitle%
}

settingsGui_loadValues(){
    global CLSets, settingsGuiPage

    autostart:=0
    loadingAnimation:=1
    allowClipboard:=1
    mouseSpeed:=3
    hotkeyScheme:=1
    colorValue:="0, 173, 239"
    soundEnabled:=1
    soundFile:=""
    qbarExternalApp:=1
    externalPath:=""
    if(IsObject(CLSets) && IsObject(CLSets.Global))
    {
        autostart:=CLSets.Global.autostart ? 1 : 0
        if(CLSets.Global.loadingAnimation="0")
            loadingAnimation:=0
        if(CLSets.Global.allowClipboard="0")
            allowClipboard:=0
        if(CLSets.Global.mouseSpeed>=1 && CLSets.Global.mouseSpeed<=20)
            mouseSpeed:=CLSets.Global.mouseSpeed
        if(CLSets.Global.default_hotkey_scheme="capslock_plus")
            hotkeyScheme:=2
        if(CLSets.Global.winPinBorderColor!="")
            colorValue:=CLSets.Global.winPinBorderColor
        if(CLSets.Global.winPinSoundEnabled="0")
            soundEnabled:=0
        if(CLSets.Global.winPinSoundFile!="")
            soundFile:=CLSets.Global.winPinSoundFile
        if(CLSets.Global.qbarExternalApp="external" || CLSets.Global.qbarExternalApp="listary")
            qbarExternalApp:=2
        if(CLSets.Global.externalAppPath!="")
            externalPath:=CLSets.Global.externalAppPath
        else if(CLSets.Global.listaryPath!="")
            externalPath:=CLSets.Global.listaryPath
    }
    if(qbarExternalApp=1 && IsObject(CLSets) && IsObject(CLSets.Keys)
        && (InStr(CLSets.Keys.caps_q, "qbarExternalApp") || InStr(CLSets.Keys.caps_q, "qbarListary") || InStr(CLSets.Keys.caps_q, "listary")))
        qbarExternalApp:=2
    ; Qbar 样式不再由设置面板管理。只有检测到旧样式键时才重建 Qbar，
    ; 避免每次打开设置面板都把已初始化的 Qbar 标记为需要重建。
    styleHasValues:=false
    if(IsObject(CLSets) && IsObject(CLSets.QStyle))
    {
        for key,value in CLSets.QStyle
        {
            styleHasValues:=true
            break
        }
    }
    if(styleHasValues)
        settingsGui_restoreQbarDefaults()
    GuiControl, SettingsGui:, SettingsAutostart, %autostart%
    GuiControl, SettingsGui:, SettingsLoadingAnimation, %loadingAnimation%
    GuiControl, SettingsGui:, SettingsAllowClipboard, %allowClipboard%
    GuiControl, SettingsGui:Choose, SettingsMouseSpeed, %mouseSpeed%
    GuiControl, SettingsGui:Choose, SettingsHotkeyScheme, %hotkeyScheme%
    GuiControl, SettingsGui:, SettingsPinColorEdit, %colorValue%
    GuiControl, SettingsGui:, SettingsPinSoundEnabled, %soundEnabled%
    GuiControl, SettingsGui:, SettingsPinSoundFile, %soundFile%
    GuiControl, SettingsGui:Choose, SettingsQbarExternalApp, %qbarExternalApp%
    GuiControl, SettingsGui:, SettingsQbarExternalPath, %externalPath%
    settingsGui_updateQbarExternalControls(qbarExternalApp=2)
    ; 打开或重新打开设置页时，先恢复已保存的 Qbar 路由，避免取消编辑留下临时预览状态。
    keysSet_applyQbarExternalApp()
    settingsGui_updateColorPreview(colorValue)
    settingsGui_loadPhrases()
    GuiControl, SettingsGui:, SettingsGuiStatus,
}

settingsGui_loadPhrases(){
    global CLSets, settingsGuiPhrases

    settingsGuiPhrases:=[]
    if(IsObject(CLSets) && IsObject(CLSets.TabHotString))
    {
        for key,value in CLSets.TabHotString
        {
            settingsGuiPhrases.Push({trigger:key, replacement:settingsGui_decodePhraseValue(value)})
        }
    }
    settingsGui_refreshPhraseList()
    GuiControl, SettingsGui:, SettingsPhraseTrigger,
    GuiControl, SettingsGui:, SettingsPhraseReplacement,
}

settingsGui_refreshPhraseList(selectRow:=0){
    global settingsGuiPhrases

    Gui, SettingsGui:ListView, SettingsPhraseListView
    LV_Delete()
    for index,phrase in settingsGuiPhrases
        LV_Add("", phrase.trigger, phrase.replacement)
    LV_ModifyCol(1, 245)
    LV_ModifyCol(2, 245)
    if(selectRow && selectRow<=settingsGuiPhrases.MaxIndex())
        LV_Modify(selectRow, "Select Focus")
}

settingsGui_phraseSelection(){
    Gui, SettingsGui:ListView, SettingsPhraseListView
    return LV_GetNext(0)
}

settingsGui_validatePhrase(trigger, replacement, currentRow:=0){
    global settingsGuiPhrases

    trigger:=Trim(trigger)
    if(trigger="")
    {
        message:=isLangChinese() ? "请输入触发词。" : "Enter a trigger."
        MsgBox, 0x40030, CapsLock+, %message%
        GuiControl, SettingsGui:Focus, SettingsPhraseTrigger
        return false
    }
    if(InStr(trigger, "=") || InStr(trigger, "`n") || InStr(trigger, "`r"))
    {
        message:=isLangChinese() ? "触发词不能包含等号或换行。" : "A trigger cannot contain '=' or a line break."
        MsgBox, 0x40030, CapsLock+, %message%
        GuiControl, SettingsGui:Focus, SettingsPhraseTrigger
        return false
    }
    if(replacement="")
    {
        message:=isLangChinese() ? "请输入替换内容。" : "Enter replacement text."
        MsgBox, 0x40030, CapsLock+, %message%
        GuiControl, SettingsGui:Focus, SettingsPhraseReplacement
        return false
    }
    for index,phrase in settingsGuiPhrases
    {
        if(index!=currentRow && phrase.trigger=trigger)
        {
            message:=isLangChinese() ? "这个触发词已经存在。" : "That trigger already exists."
            MsgBox, 0x40030, CapsLock+, %message%
            GuiControl, SettingsGui:Focus, SettingsPhraseTrigger
            return false
        }
    }
    return true
}

settingsGui_phraseLoadSelected(){
    global settingsGuiPhrases

    row:=settingsGui_phraseSelection()
    if(!row || !IsObject(settingsGuiPhrases[row]))
        return
    GuiControl, SettingsGui:, SettingsPhraseTrigger, % settingsGuiPhrases[row].trigger
    GuiControl, SettingsGui:, SettingsPhraseReplacement, % settingsGuiPhrases[row].replacement
}

settingsGui_phraseAdd(){
    global settingsGuiPhrases

    GuiControlGet, trigger, SettingsGui:, SettingsPhraseTrigger
    GuiControlGet, replacement, SettingsGui:, SettingsPhraseReplacement
    if(!settingsGui_validatePhrase(trigger, replacement))
        return
    settingsGuiPhrases.Push({trigger:Trim(trigger), replacement:replacement})
    settingsGui_refreshPhraseList()
    Gui, SettingsGui:ListView, SettingsPhraseListView
    LV_Modify(0, "-Select -Focus")
    GuiControl, SettingsGui:, SettingsPhraseTrigger,
    GuiControl, SettingsGui:, SettingsPhraseReplacement,
    GuiControl, SettingsGui:Focus, SettingsPhraseTrigger
    GuiControl, SettingsGui:, SettingsGuiStatus,
}

settingsGui_phraseDelete(){
    global settingsGuiPhrases

    row:=settingsGui_phraseSelection()
    if(!row || !IsObject(settingsGuiPhrases[row]))
    {
        message:=isLangChinese() ? "请先选择要删除的常用语。" : "Select a phrase to delete first."
        MsgBox, 0x40030, CapsLock+, %message%
        return
    }
    settingsGuiPhrases.Remove(row)
    settingsGui_refreshPhraseList()
    GuiControl, SettingsGui:, SettingsPhraseTrigger,
    GuiControl, SettingsGui:, SettingsPhraseReplacement,
}

settingsGui_encodePhraseValue(value){
    StringReplace, normalized, value, `r`n, `n, All
    StringReplace, normalized, normalized, `r, , All
    StringReplace, encoded, normalized, \n, \`n, All
    StringReplace, encoded, encoded, `n, \n, All
    return encoded
}

settingsGui_decodePhraseValue(value){
    StringReplace, decoded, value, \n, `n, All
    StringReplace, decoded, decoded, \`n, \n, All
    return decoded
}

settingsGui_applyPhraseEditor(){
    global settingsGuiPhrases

    row:=settingsGui_phraseSelection()
    if(!row || !IsObject(settingsGuiPhrases[row]))
        return true
    GuiControlGet, trigger, SettingsGui:, SettingsPhraseTrigger
    GuiControlGet, replacement, SettingsGui:, SettingsPhraseReplacement
    if(!settingsGui_validatePhrase(trigger, replacement, row))
        return false
    settingsGuiPhrases[row].trigger:=Trim(trigger)
    settingsGuiPhrases[row].replacement:=replacement
    settingsGui_refreshPhraseList(row)
    return true
}

settingsGui_savePhrases(){
    global CLSets, settingsGuiPhrases

    if(!settingsGui_applyPhraseEditor())
        return false
    if(!IsObject(CLSets.TabHotString))
        CLSets.TabHotString:={}
    for key,value in CLSets.TabHotString
        IniDelete, CapsLock+settings.ini, TabHotString, %key%

    CLSets.TabHotString:={}
    if(!IsObject(CLSets.length))
        CLSets.length:={}
    CLSets.length.TabHotString:=0
    for index,phrase in settingsGuiPhrases
    {
        encodedValue:=settingsGui_encodePhraseValue(phrase.replacement)
        phraseTrigger:=phrase.trigger
        IniWrite, %encodedValue%, CapsLock+settings.ini, TabHotString, %phraseTrigger%
        CLSets.TabHotString[phraseTrigger]:=encodedValue
        CLSets.length.TabHotString++
    }
    SetTimer, hotStringInit, -1
    savedText:=isLangChinese() ? "常用语已保存并立即生效。" : "Phrases saved and applied."
    GuiControl, SettingsGui:, SettingsGuiStatus, %savedText%
    return true
}

settingsGui_cleanupConfigDefaults(){
    global CLSets

    ; Qbar 样式现在完全使用 lib_clQ 的内置回退值，删除旧配置中的所有样式键。
    styleHasValues:=false
    if(IsObject(CLSets) && IsObject(CLSets.QStyle))
    {
        for key,value in CLSets.QStyle
        {
            styleHasValues:=true
            break
        }
    }
    if(styleHasValues)
        settingsGui_restoreQbarDefaults()

    if(!IsObject(CLSets) || !IsObject(CLSets.Global))
        return

    if(CLSets.Global.autostart="0")
        IniDelete, CapsLock+settings.ini, Global, autostart
    if(CLSets.Global.loadingAnimation="1")
        IniDelete, CapsLock+settings.ini, Global, loadingAnimation
    if(CLSets.Global.allowClipboard="1")
        IniDelete, CapsLock+settings.ini, Global, allowClipboard
    if(CLSets.Global.mouseSpeed="3")
        IniDelete, CapsLock+settings.ini, Global, mouseSpeed
    if(CLSets.Global.default_hotkey_scheme="capslox")
        IniDelete, CapsLock+settings.ini, Global, default_hotkey_scheme
    if(CLSets.Global.winPinSoundEnabled="1")
        IniDelete, CapsLock+settings.ini, Global, winPinSoundEnabled
    if(CLSets.Global.winPinSoundFile="")
        IniDelete, CapsLock+settings.ini, Global, winPinSoundFile
    if(CLSets.Global.qbarExternalApp="builtin")
        IniDelete, CapsLock+settings.ini, Global, qbarExternalApp

    if(CLSets.Global.winPinBorderColor!=""
        && winPinBorder_tryParseColor(CLSets.Global.winPinBorderColor, normalizedColor)
        && normalizedColor="00ADEF")
        IniDelete, CapsLock+settings.ini, Global, winPinBorderColor

    externalPath:=CLSets.Global.externalAppPath
    if(externalPath="")
        externalPath:=CLSets.Global.listaryPath
    if(externalPath!="")
    {
        if(CLSets.Global.externalAppPath="")
        {
            IniWrite, %externalPath%, CapsLock+settings.ini, Global, externalAppPath
            CLSets.Global.externalAppPath:=externalPath
        }
    }
    else
        IniDelete, CapsLock+settings.ini, Global, externalAppPath

    if(CLSets.Global.qbarExternalApp="listary")
    {
        IniWrite, external, CapsLock+settings.ini, Global, qbarExternalApp
        CLSets.Global.qbarExternalApp:="external"
    }
    else if(CLSets.Global.qbarExternalApp="" && IsObject(CLSets.Keys)
        && (InStr(CLSets.Keys.caps_q, "qbarListary") || InStr(CLSets.Keys.caps_q, "qbarExternalApp") || InStr(CLSets.Keys.caps_q, "listary")))
    {
        IniWrite, external, CapsLock+settings.ini, Global, qbarExternalApp
        CLSets.Global.qbarExternalApp:="external"
    }
    IniDelete, CapsLock+settings.ini, Global, listaryPath
    keysSet_applyQbarExternalApp()
}

settingsGui_setPage(page){
    global settingsGuiPage

    generalControls:="SettingsGeneralTitle|SettingsGeneralDescription|SettingsAutostart|SettingsLoadingAnimation|SettingsAllowClipboard|SettingsMouseSpeedLabel|SettingsMouseSpeed"
    hotkeysControls:="SettingsHotkeysTitle|SettingsHotkeysDescription|SettingsSchemeLabel|SettingsHotkeyScheme|SettingsHotkeysHint"
    pinControls:="SettingsPinTitle|SettingsPinDescription|SettingsPinColorLabel|SettingsPinColorPreview|SettingsPinColorEdit|SettingsPinChooseColor|SettingsPinColorHint|SettingsPinSoundEnabled|SettingsPinSoundFileLabel|SettingsPinSoundFile|SettingsPinChooseSound|SettingsPinSoundDefaultHint"
    qbarControls:="SettingsQbarTitle|SettingsQbarDescription|SettingsQbarExternalAppLabel|SettingsQbarExternalApp|SettingsQbarExternalAppHint|SettingsQbarExternalPathLabel|SettingsQbarExternalPath|SettingsQbarChooseExternalPath|SettingsQbarExternalPathHint"
    phrasesControls:="SettingsPhrasesTitle|SettingsPhrasesDescription|SettingsPhraseListView|SettingsPhraseTriggerLabel|SettingsPhraseReplacementLabel|SettingsPhraseTrigger|SettingsPhraseReplacement|SettingsPhraseAddButton|SettingsPhraseDeleteButton"
    if(page="pin")
    {
        settingsGuiPage:="pin"
        for index,controlName in StrSplit(generalControls, "|")
            GuiControl, SettingsGui:Hide, %controlName%
        for index,controlName in StrSplit(hotkeysControls, "|")
            GuiControl, SettingsGui:Hide, %controlName%
        for index,controlName in StrSplit(qbarControls, "|")
            GuiControl, SettingsGui:Hide, %controlName%
        for index,controlName in StrSplit(phrasesControls, "|")
            GuiControl, SettingsGui:Hide, %controlName%
        for index,controlName in StrSplit(pinControls, "|")
            GuiControl, SettingsGui:Show, %controlName%
        GuiControl, SettingsGui:Hide, SettingsNavGeneralHighlight
        GuiControl, SettingsGui:Hide, SettingsNavQbarHighlight
        GuiControl, SettingsGui:Hide, SettingsNavHotkeysHighlight
        GuiControl, SettingsGui:Hide, SettingsNavPhrasesHighlight
        GuiControl, SettingsGui:Show, SettingsNavPinHighlight
        GuiControl, SettingsGui:+c89919D, SettingsNavGeneral
        GuiControl, SettingsGui:+cFFFFFF, SettingsNavPin
        GuiControl, SettingsGui:+c89919D, SettingsNavQbar
        GuiControl, SettingsGui:+c89919D, SettingsNavHotkeys
        GuiControl, SettingsGui:+c89919D, SettingsNavPhrases
    }
    else if(page="qbar")
    {
        settingsGuiPage:="qbar"
        for index,controlName in StrSplit(generalControls, "|")
            GuiControl, SettingsGui:Hide, %controlName%
        for index,controlName in StrSplit(hotkeysControls, "|")
            GuiControl, SettingsGui:Hide, %controlName%
        for index,controlName in StrSplit(pinControls, "|")
            GuiControl, SettingsGui:Hide, %controlName%
        for index,controlName in StrSplit(phrasesControls, "|")
            GuiControl, SettingsGui:Hide, %controlName%
        for index,controlName in StrSplit(qbarControls, "|")
            GuiControl, SettingsGui:Show, %controlName%
        GuiControlGet, qbarSelection, SettingsGui:, SettingsQbarExternalApp
        settingsGui_updateQbarExternalControls(qbarSelection=2)
        GuiControl, SettingsGui:Hide, SettingsNavGeneralHighlight
        GuiControl, SettingsGui:Hide, SettingsNavPinHighlight
        GuiControl, SettingsGui:Hide, SettingsNavHotkeysHighlight
        GuiControl, SettingsGui:Hide, SettingsNavPhrasesHighlight
        GuiControl, SettingsGui:Show, SettingsNavQbarHighlight
        GuiControl, SettingsGui:+c89919D, SettingsNavGeneral
        GuiControl, SettingsGui:+c89919D, SettingsNavPin
        GuiControl, SettingsGui:+cFFFFFF, SettingsNavQbar
        GuiControl, SettingsGui:+c89919D, SettingsNavHotkeys
        GuiControl, SettingsGui:+c89919D, SettingsNavPhrases
    }
    else if(page="hotkeys")
    {
        settingsGuiPage:="hotkeys"
        for index,controlName in StrSplit(generalControls, "|")
            GuiControl, SettingsGui:Hide, %controlName%
        for index,controlName in StrSplit(pinControls, "|")
            GuiControl, SettingsGui:Hide, %controlName%
        for index,controlName in StrSplit(qbarControls, "|")
            GuiControl, SettingsGui:Hide, %controlName%
        for index,controlName in StrSplit(phrasesControls, "|")
            GuiControl, SettingsGui:Hide, %controlName%
        for index,controlName in StrSplit(hotkeysControls, "|")
            GuiControl, SettingsGui:Show, %controlName%
        GuiControl, SettingsGui:Hide, SettingsNavGeneralHighlight
        GuiControl, SettingsGui:Hide, SettingsNavPinHighlight
        GuiControl, SettingsGui:Hide, SettingsNavQbarHighlight
        GuiControl, SettingsGui:Hide, SettingsNavPhrasesHighlight
        GuiControl, SettingsGui:Show, SettingsNavHotkeysHighlight
        GuiControl, SettingsGui:+c89919D, SettingsNavGeneral
        GuiControl, SettingsGui:+c89919D, SettingsNavPin
        GuiControl, SettingsGui:+c89919D, SettingsNavQbar
        GuiControl, SettingsGui:+cFFFFFF, SettingsNavHotkeys
        GuiControl, SettingsGui:+c89919D, SettingsNavPhrases
    }
    else if(page="phrases")
    {
        settingsGuiPage:="phrases"
        for index,controlName in StrSplit(generalControls, "|")
            GuiControl, SettingsGui:Hide, %controlName%
        for index,controlName in StrSplit(pinControls, "|")
            GuiControl, SettingsGui:Hide, %controlName%
        for index,controlName in StrSplit(qbarControls, "|")
            GuiControl, SettingsGui:Hide, %controlName%
        for index,controlName in StrSplit(hotkeysControls, "|")
            GuiControl, SettingsGui:Hide, %controlName%
        for index,controlName in StrSplit(phrasesControls, "|")
            GuiControl, SettingsGui:Show, %controlName%
        GuiControl, SettingsGui:Hide, SettingsNavGeneralHighlight
        GuiControl, SettingsGui:Hide, SettingsNavPinHighlight
        GuiControl, SettingsGui:Hide, SettingsNavQbarHighlight
        GuiControl, SettingsGui:Hide, SettingsNavHotkeysHighlight
        GuiControl, SettingsGui:Show, SettingsNavPhrasesHighlight
        GuiControl, SettingsGui:+c89919D, SettingsNavGeneral
        GuiControl, SettingsGui:+c89919D, SettingsNavPin
        GuiControl, SettingsGui:+c89919D, SettingsNavQbar
        GuiControl, SettingsGui:+c89919D, SettingsNavHotkeys
        GuiControl, SettingsGui:+cFFFFFF, SettingsNavPhrases
    }
    else
    {
        settingsGuiPage:="general"
        for index,controlName in StrSplit(pinControls, "|")
            GuiControl, SettingsGui:Hide, %controlName%
        for index,controlName in StrSplit(hotkeysControls, "|")
            GuiControl, SettingsGui:Hide, %controlName%
        for index,controlName in StrSplit(qbarControls, "|")
            GuiControl, SettingsGui:Hide, %controlName%
        for index,controlName in StrSplit(phrasesControls, "|")
            GuiControl, SettingsGui:Hide, %controlName%
        for index,controlName in StrSplit(generalControls, "|")
            GuiControl, SettingsGui:Show, %controlName%
        GuiControl, SettingsGui:Hide, SettingsNavPinHighlight
        GuiControl, SettingsGui:Hide, SettingsNavQbarHighlight
        GuiControl, SettingsGui:Hide, SettingsNavHotkeysHighlight
        GuiControl, SettingsGui:Hide, SettingsNavPhrasesHighlight
        GuiControl, SettingsGui:Show, SettingsNavGeneralHighlight
        GuiControl, SettingsGui:+cFFFFFF, SettingsNavGeneral
        GuiControl, SettingsGui:+c89919D, SettingsNavPin
        GuiControl, SettingsGui:+c89919D, SettingsNavQbar
        GuiControl, SettingsGui:+c89919D, SettingsNavHotkeys
        GuiControl, SettingsGui:+c89919D, SettingsNavPhrases
    }
    GuiControl, SettingsGui:, SettingsGuiStatus,
}

settingsGui_updateQbarExternalControls(showPath){
    pathControls:="SettingsQbarExternalPathLabel|SettingsQbarExternalPath|SettingsQbarChooseExternalPath|SettingsQbarExternalPathHint"
    for index,controlName in StrSplit(pathControls, "|")
    {
        if(showPath)
            GuiControl, SettingsGui:Show, %controlName%
        else
            GuiControl, SettingsGui:Hide, %controlName%
    }
}

settingsGui_updateColorPreview(colorValue){
    if(!winPinBorder_tryParseColor(colorValue, normalizedColor))
        normalizedColor:="D9DEE5"
    GuiControl, SettingsGui:+c%normalizedColor%, SettingsPinColorPreview
    GuiControl, SettingsGui:, SettingsPinColorPreview, 100
}

settingsGui_save(){
    global CLSets, settingsGuiPage, SettingsAutostart, SettingsLoadingAnimation, SettingsAllowClipboard, SettingsMouseSpeed, SettingsHotkeyScheme
    global SettingsPinColorEdit, SettingsPinSoundEnabled, SettingsPinSoundFile
    global SettingsQbarExternalApp, SettingsQbarExternalPath
    global keyset

    Gui, SettingsGui:Submit, NoHide
    oldHotkeyScheme:="capslox"
    if(IsObject(CLSets) && IsObject(CLSets.Global) && CLSets.Global.default_hotkey_scheme="capslock_plus")
        oldHotkeyScheme:="capslock_plus"
    colorValue:=Trim(SettingsPinColorEdit)
    if(!winPinBorder_tryParseColor(colorValue, normalizedColor))
    {
        message:=isLangChinese() ? "颜色格式无效。请输入 65, 131, 143 或 #fdfdfd。" : "Invalid color. Use 65, 131, 143 or #fdfdfd."
        MsgBox, 0x40030, CapsLock+, %message%
        return false
    }

    soundEnabled:=SettingsPinSoundEnabled ? 1 : 0
    soundFile:=Trim(SettingsPinSoundFile)
    if(soundFile!="" && !FileExist(soundFile))
    {
        message:=isLangChinese() ? "选择的音效文件不存在，请重新选择或恢复默认。" : "The selected sound file does not exist. Choose another file or reset it."
        MsgBox, 0x40030, CapsLock+, %message%
        return false
    }

    qbarExternalApp:=SettingsQbarExternalApp=2 ? "external" : "builtin"
    qbarKeyValue:=qbarExternalApp="external" ? "keyFunc_qbarExternalApp" : "keyFunc_qbar"
    externalPath:=Trim(SettingsQbarExternalPath)
    if(qbarExternalApp="external" && externalPath="")
    {
        message:=isLangChinese() ? "选择外部程序后必须填写程序路径。" : "Enter the external application's path before saving."
        MsgBox, 0x40030, CapsLock+, %message%
        GuiControl, SettingsGui:Focus, SettingsQbarExternalPath
        return false
    }
    if(qbarExternalApp="external" && !FileExist(externalPath))
    {
        message:=isLangChinese() ? "外部程序路径不存在，请重新选择。" : "The external application's path does not exist. Choose it again."
        MsgBox, 0x40030, CapsLock+, %message%
        return false
    }

    ; 内置 Qbar 不再暴露样式选项，切回内置模式时恢复项目原始样式。
    if(settingsGuiPage="qbar" && qbarExternalApp="builtin")
        settingsGui_restoreQbarDefaults()

    autostart:=SettingsAutostart ? 1 : 0
    loadingAnimation:=SettingsLoadingAnimation ? 1 : 0
    allowClipboard:=SettingsAllowClipboard ? 1 : 0
    mouseSpeed:=SettingsMouseSpeed
    hotkeyScheme:=SettingsHotkeyScheme=2 ? "capslock_plus" : "capslox"

    settingsGui_writeGlobalValue("autostart", autostart, 0)
    settingsGui_writeGlobalValue("loadingAnimation", loadingAnimation, 1)
    settingsGui_writeGlobalValue("allowClipboard", allowClipboard, 1)
    settingsGui_writeGlobalValue("mouseSpeed", mouseSpeed, 3)
    settingsGui_writeGlobalValue("default_hotkey_scheme", hotkeyScheme, "capslox")
    if(normalizedColor="00ADEF")
        IniDelete, CapsLock+settings.ini, Global, winPinBorderColor
    else
        IniWrite, %colorValue%, CapsLock+settings.ini, Global, winPinBorderColor
    settingsGui_writeGlobalValue("winPinSoundEnabled", soundEnabled, 1)
    settingsGui_writeGlobalValue("winPinSoundFile", soundFile, "")
    settingsGui_writeGlobalValue("qbarExternalApp", qbarExternalApp, "builtin")
    settingsGui_writeGlobalValue("externalAppPath", externalPath, "")
    IniDelete, CapsLock+settings.ini, Global, listaryPath
    ; 显式保存 CapsLock+Q 的路由，避免删除默认键后旧运行实例仍保留外部程序路由。
    IniWrite, %qbarKeyValue%, CapsLock+settings.ini, Keys, caps_q

    if(!IsObject(CLSets.Global))
        CLSets.Global:={}
    CLSets.Global.autostart:=autostart
    CLSets.Global.loadingAnimation:=loadingAnimation
    CLSets.Global.allowClipboard:=allowClipboard
    CLSets.Global.mouseSpeed:=mouseSpeed
    CLSets.Global.default_hotkey_scheme:=hotkeyScheme
    CLSets.Global.winPinBorderColor:=colorValue
    CLSets.Global.winPinSoundEnabled:=soundEnabled
    CLSets.Global.winPinSoundFile:=soundFile
    CLSets.Global.qbarExternalApp:=qbarExternalApp
    CLSets.Global.externalAppPath:=externalPath
    ; 两套布局会为缺失按键补不同的默认值。切换布局时必须先从 INI
    ; 重新建立 Keys 对象，否则旧布局已经补齐的值会阻止新布局生效。
    if(oldHotkeyScheme!=hotkeyScheme)
    {
        CLSets.length.Keys:=""
        settingsSectionInit("Keys")
    }
    if(!IsObject(CLSets.Keys))
        CLSets.Keys:={}
    CLSets.Keys.caps_q:=qbarKeyValue
    if(IsObject(keyset))
        keyset.caps_q:=qbarKeyValue
    keysSet_applyQbarExternalApp()
    winPinBorder_refreshSettings()
    settingsGui_updateColorPreview(colorValue)
    if(IsLabel("globalSettings"))
    {
        settingsTimerLabel:="globalSettings"
        SetTimer, %settingsTimerLabel%, -1
    }
    if(IsLabel("keysInit"))
    {
        settingsTimerLabel:="keysInit"
        SetTimer, %settingsTimerLabel%, -1
    }
    ; keysInit 可能会被设置文件监控延后触发，再补一次路由同步，确保切换后无需 F5。
    SetTimer, settingsGuiApplyQbarRoute, -120
    if(IsLabel("mouseSpeedInit"))
    {
        settingsTimerLabel:="mouseSpeedInit"
        SetTimer, %settingsTimerLabel%, -1
    }

    if(settingsGuiPage="qbar")
        savedText:=isLangChinese() ? "设置已保存，Qbar 路由已立即切换。" : "Saved. Qbar routing switched immediately."
    else
        savedText:=isLangChinese() ? "设置已保存并立即生效。" : "Settings saved and applied."
    GuiControl, SettingsGui:, SettingsGuiStatus, %savedText%
    return true
}

settingsGui_writeGlobalValue(key, value, defaultValue){
    if(value=defaultValue)
        IniDelete, CapsLock+settings.ini, Global, %key%
    else
        IniWrite, %value%, CapsLock+settings.ini, Global, %key%
}

settingsGui_restoreQbarDefaults(){
    global CLSets, needInitQ
    styleChanged:=false
    if(IsObject(CLSets.QStyle))
    {
        for key,value in CLSets.QStyle
        {
            IniDelete, CapsLock+settings.ini, QStyle, %key%
            styleChanged:=true
        }
    }
    CLSets.QStyle:={}
    if(styleChanged)
        needInitQ:=1
}

settingsGui_chooseColor(ownerHwnd, initialColor){
    static customColors
    VarSetCapacity(customColors, 64, 0)
    if(!winPinBorder_tryParseColor(initialColor, normalizedColor))
        normalizedColor:="00ADEF"

    red:=("0x" . SubStr(normalizedColor, 1, 2))+0
    green:=("0x" . SubStr(normalizedColor, 3, 2))+0
    blue:=("0x" . SubStr(normalizedColor, 5, 2))+0
    colorRef:=red | (green << 8) | (blue << 16)

    structSize:=A_PtrSize=8 ? 72 : 36
    ownerOffset:=A_PtrSize=8 ? 8 : 4
    resultOffset:=A_PtrSize=8 ? 24 : 12
    customOffset:=A_PtrSize=8 ? 32 : 16
    flagsOffset:=A_PtrSize=8 ? 40 : 20
    VarSetCapacity(chooseColor, structSize, 0)
    NumPut(structSize, chooseColor, 0, "UInt")
    NumPut(ownerHwnd, chooseColor, ownerOffset, "Ptr")
    NumPut(colorRef, chooseColor, resultOffset, "UInt")
    NumPut(&customColors, chooseColor, customOffset, "Ptr")
    NumPut(0x103, chooseColor, flagsOffset, "UInt") ; CC_RGBINIT | CC_FULLOPEN

    if(!DllCall("Comdlg32\ChooseColorW", "Ptr", &chooseColor))
        return ""
    selected:=NumGet(chooseColor, resultOffset, "UInt")
    return (selected & 0xFF) . ", " . ((selected >> 8) & 0xFF) . ", " . ((selected >> 16) & 0xFF)
}

settingsGuiOpenFromTray:
settingsGui_show()
return

SettingsGuiColorChanged:
GuiControlGet, changedColor, SettingsGui:, SettingsPinColorEdit
settingsGui_updateColorPreview(changedColor)
return

SettingsGuiChooseColor:
GuiControlGet, currentColor, SettingsGui:, SettingsPinColorEdit
selectedColor:=settingsGui_chooseColor(settingsGuiHwnd, currentColor)
if(selectedColor!="")
{
    GuiControl, SettingsGui:, SettingsPinColorEdit, %selectedColor%
    settingsGui_updateColorPreview(selectedColor)
}
return

SettingsGuiShowGeneral:
settingsGui_setPage("general")
return

SettingsGuiShowPin:
settingsGui_setPage("pin")
return

SettingsGuiShowQbar:
settingsGui_setPage("qbar")
return

SettingsGuiShowHotkeys:
settingsGui_setPage("hotkeys")
return

SettingsGuiShowPhrases:
settingsGui_setPage("phrases")
return

SettingsGuiPhraseListChanged:
settingsGui_phraseLoadSelected()
return

SettingsGuiPhraseAdd:
settingsGui_phraseAdd()
return

SettingsGuiPhraseDelete:
settingsGui_phraseDelete()
return

SettingsGuiQbarExternalChanged:
GuiControlGet, qbarSelection, SettingsGui:, SettingsQbarExternalApp
settingsGui_updateQbarExternalControls(qbarSelection=2)
return

settingsGuiApplyQbarRoute:
keysSet_applyQbarExternalApp()
return

SettingsGuiChooseExternalPath:
GuiControlGet, currentExternalPath, SettingsGui:, SettingsQbarExternalPath
externalStartDirectory:=A_ProgramFiles
if(currentExternalPath!="" && FileExist(currentExternalPath))
    SplitPath, currentExternalPath, , externalStartDirectory
externalDialogTitle:=isLangChinese() ? "选择外部程序" : "Choose external application"
FileSelectFile, selectedExternalPath, 1, %externalStartDirectory%, %externalDialogTitle%, Applications (*.exe)
if(selectedExternalPath!="")
    GuiControl, SettingsGui:, SettingsQbarExternalPath, %selectedExternalPath%
return

SettingsGuiChooseSound:
GuiControlGet, currentSoundFile, SettingsGui:, SettingsPinSoundFile
soundStartDirectory:=A_WinDir . "\Media"
if(currentSoundFile!="" && FileExist(currentSoundFile))
    SplitPath, currentSoundFile, , soundStartDirectory
soundDialogTitle:=isLangChinese() ? "选择顶置提示音" : "Choose pinning sound"
FileSelectFile, selectedSoundFile, 1, %soundStartDirectory%, %soundDialogTitle%, WAV Audio (*.wav)
if(selectedSoundFile!="")
    GuiControl, SettingsGui:, SettingsPinSoundFile, %selectedSoundFile%
return

SettingsGuiReset:
if(settingsGuiPage="pin")
{
    GuiControl, SettingsGui:, SettingsPinColorEdit, 0`, 173`, 239
    GuiControl, SettingsGui:, SettingsPinSoundEnabled, 1
    GuiControl, SettingsGui:, SettingsPinSoundFile,
    settingsGui_updateColorPreview("0, 173, 239")
}
else if(settingsGuiPage="qbar")
{
    GuiControl, SettingsGui:Choose, SettingsQbarExternalApp, 1
    GuiControl, SettingsGui:, SettingsQbarExternalPath,
    settingsGui_updateQbarExternalControls(false)
}
else if(settingsGuiPage="hotkeys")
{
    GuiControl, SettingsGui:Choose, SettingsHotkeyScheme, 1
}
else if(settingsGuiPage="phrases")
{
    settingsGuiPhrases:=[]
    settingsGui_refreshPhraseList()
    GuiControl, SettingsGui:, SettingsPhraseTrigger,
    GuiControl, SettingsGui:, SettingsPhraseReplacement,
}
else
{
    GuiControl, SettingsGui:, SettingsAutostart, 0
    GuiControl, SettingsGui:, SettingsLoadingAnimation, 1
    GuiControl, SettingsGui:, SettingsAllowClipboard, 1
    GuiControl, SettingsGui:Choose, SettingsMouseSpeed, 3
}
GuiControl, SettingsGui:, SettingsGuiStatus,
return

SettingsGuiSave:
if(settingsGuiPage="phrases")
    settingsGui_savePhrases()
else
    settingsGui_save()
return

SettingsGuiOpenAdvanced:
Run, CapsLock+settings.ini
return

SettingsGuiCancel:
SettingsGuiClose:
SettingsGuiEscape:
if(settingsGuiPage="qbar")
    keysSet_applyQbarExternalApp()
Gui, SettingsGui:Hide
return
