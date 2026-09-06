; CapsLock+ 可视化设置面板。先承载窗口顶置设置，后续分类可继续迁入。

global settingsGuiHwnd:=0
global settingsGuiTrayLabel:=""
global settingsGuiPage:="general"

settingsGui_init(){
    global settingsGuiTrayLabel

    settingsGuiTrayLabel:=isLangChinese() ? "设置..." : "Settings..."
    ; 标准托盘项不能直接用 Menu, Insert 定位。先暂时移除并恢复标准项，
    ; 将设置放在标准项之前，因此自然位于 Exit 上方且不会破坏系统菜单。
    Menu, Tray, NoStandard
    Menu, Tray, Add, %settingsGuiTrayLabel%, settingsGuiOpenFromTray
    Menu, Tray, Standard
}

settingsGui_show(){
    global settingsGuiHwnd, SettingsNavGeneralHighlight, SettingsNavPinHighlight, SettingsNavGeneral, SettingsNavPin
    global SettingsGeneralTitle, SettingsGeneralDescription, SettingsAutostart, SettingsLoadingAnimation, SettingsAllowClipboard
    global SettingsMouseSpeedLabel, SettingsMouseSpeed, SettingsSchemeLabel, SettingsHotkeyScheme
    global SettingsPinTitle, SettingsPinDescription, SettingsPinColorLabel, SettingsPinColorPreview, SettingsPinColorEdit
    global SettingsPinChooseColor, SettingsPinColorHint, SettingsPinSoundEnabled, SettingsPinSoundFileLabel
    global SettingsPinSoundFile, SettingsPinChooseSound, SettingsPinSoundDefaultHint
    global SettingsQbarTitle, SettingsQbarDescription, SettingsQbarExternalApp, SettingsQbarExternalAppLabel, SettingsQbarExternalAppHint
    global SettingsNavQbarHighlight, SettingsNavQbar, SettingsGuiStatus

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
        comingSoon:="后续逐步迁移"
        generalLabel:="常规"
        hotkeysLabel:="快捷键"
        translationLabel:="外部程序"
        qbarLabel:="Qbar"
        qbarTitle:="Qbar"
        qbarDescription:="选择 CapsLock+Q 使用内置 Qbar，或绑定外部程序。"
        qExternalAppLabel:="CapsLock+Q 绑定"
        qExternalAppItems:="内置 Qbar|Listary"
        qExternalAppHint:="选择 Listary 后，CapsLock+Q 会呼出 Listary，并自动填入选中文字。"
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
        comingSoon:="Coming later"
        generalLabel:="General"
        hotkeysLabel:="Hotkeys"
        translationLabel:="External apps"
        qbarLabel:="Qbar"
        qbarTitle:="Qbar"
        qbarDescription:="Use the built-in Qbar or bind CapsLock+Q to an external app."
        qExternalAppLabel:="CapsLock+Q binding"
        qExternalAppItems:="Built-in Qbar|Listary"
        qExternalAppHint:="When Listary is selected, CapsLock+Q opens Listary and fills the selected text."
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
    Gui, SettingsGui:Font, s9 w400 c727B87, Microsoft YaHei UI
    Gui, SettingsGui:Add, Text, x20 y262 w150 h20 BackgroundTrans, %comingSoon%
    Gui, SettingsGui:Add, Text, x28 y294 w140 h24 BackgroundTrans, %hotkeysLabel%
    Gui, SettingsGui:Add, Text, x28 y326 w140 h24 BackgroundTrans, %translationLabel%
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
    Gui, SettingsGui:Font, s10 w600 c252A31, Microsoft YaHei UI
    Gui, SettingsGui:Add, Text, x228 y362 w200 h24 vSettingsSchemeLabel BackgroundTrans, %schemeLabel%
    Gui, SettingsGui:Font, s10 w400 c252A31, Microsoft YaHei UI
    Gui, SettingsGui:Add, DropDownList, x228 y394 w260 vSettingsHotkeyScheme AltSubmit, %schemeItems%

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
    ; r2 让下拉列表一次显示两个选项，避免用户还要滚动才能看到 Listary。
    Gui, SettingsGui:Add, DropDownList, x228 y166 w280 r2 vSettingsQbarExternalApp AltSubmit, %qExternalAppItems%
    Gui, SettingsGui:Font, s9 w400 c68717D, Microsoft YaHei UI
    Gui, SettingsGui:Add, Text, x228 y216 w500 h40 vSettingsQbarExternalAppHint BackgroundTrans, %qExternalAppHint%

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
        if(CLSets.Global.qbarExternalApp="listary")
            qbarExternalApp:=2
    }
    if(qbarExternalApp=1 && IsObject(CLSets) && IsObject(CLSets.Keys)
        && InStr(CLSets.Keys.caps_q, "listary"))
        qbarExternalApp:=2
    ; 旧版 Qbar 页面曾把示例红/绿/蓝配色写入配置。内置模式下自动迁移回原始默认值。
    if(qbarExternalApp=1 && IsObject(CLSets) && IsObject(CLSets.QStyle)
        && CLSets.QStyle.borderBackgroundColor="red"
        && CLSets.QStyle.textBackgroundColor="green"
        && CLSets.QStyle.listBackgroundColor="blue")
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
    settingsGui_updateColorPreview(colorValue)
    GuiControl, SettingsGui:, SettingsGuiStatus,
}

settingsGui_setPage(page){
    global settingsGuiPage

    generalControls:="SettingsGeneralTitle|SettingsGeneralDescription|SettingsAutostart|SettingsLoadingAnimation|SettingsAllowClipboard|SettingsMouseSpeedLabel|SettingsMouseSpeed|SettingsSchemeLabel|SettingsHotkeyScheme"
    pinControls:="SettingsPinTitle|SettingsPinDescription|SettingsPinColorLabel|SettingsPinColorPreview|SettingsPinColorEdit|SettingsPinChooseColor|SettingsPinColorHint|SettingsPinSoundEnabled|SettingsPinSoundFileLabel|SettingsPinSoundFile|SettingsPinChooseSound|SettingsPinSoundDefaultHint"
    qbarControls:="SettingsQbarTitle|SettingsQbarDescription|SettingsQbarExternalAppLabel|SettingsQbarExternalApp|SettingsQbarExternalAppHint"
    if(page="pin")
    {
        settingsGuiPage:="pin"
        for index,controlName in StrSplit(generalControls, "|")
            GuiControl, SettingsGui:Hide, %controlName%
        for index,controlName in StrSplit(qbarControls, "|")
            GuiControl, SettingsGui:Hide, %controlName%
        for index,controlName in StrSplit(pinControls, "|")
            GuiControl, SettingsGui:Show, %controlName%
        GuiControl, SettingsGui:Hide, SettingsNavGeneralHighlight
        GuiControl, SettingsGui:Hide, SettingsNavQbarHighlight
        GuiControl, SettingsGui:Show, SettingsNavPinHighlight
        GuiControl, SettingsGui:+c89919D, SettingsNavGeneral
        GuiControl, SettingsGui:+cFFFFFF, SettingsNavPin
        GuiControl, SettingsGui:+c89919D, SettingsNavQbar
    }
    else if(page="qbar")
    {
        settingsGuiPage:="qbar"
        for index,controlName in StrSplit(generalControls, "|")
            GuiControl, SettingsGui:Hide, %controlName%
        for index,controlName in StrSplit(pinControls, "|")
            GuiControl, SettingsGui:Hide, %controlName%
        for index,controlName in StrSplit(qbarControls, "|")
            GuiControl, SettingsGui:Show, %controlName%
        GuiControl, SettingsGui:Hide, SettingsNavGeneralHighlight
        GuiControl, SettingsGui:Hide, SettingsNavPinHighlight
        GuiControl, SettingsGui:Show, SettingsNavQbarHighlight
        GuiControl, SettingsGui:+c89919D, SettingsNavGeneral
        GuiControl, SettingsGui:+c89919D, SettingsNavPin
        GuiControl, SettingsGui:+cFFFFFF, SettingsNavQbar
    }
    else
    {
        settingsGuiPage:="general"
        for index,controlName in StrSplit(pinControls, "|")
            GuiControl, SettingsGui:Hide, %controlName%
        for index,controlName in StrSplit(qbarControls, "|")
            GuiControl, SettingsGui:Hide, %controlName%
        for index,controlName in StrSplit(generalControls, "|")
            GuiControl, SettingsGui:Show, %controlName%
        GuiControl, SettingsGui:Hide, SettingsNavPinHighlight
        GuiControl, SettingsGui:Hide, SettingsNavQbarHighlight
        GuiControl, SettingsGui:Show, SettingsNavGeneralHighlight
        GuiControl, SettingsGui:+cFFFFFF, SettingsNavGeneral
        GuiControl, SettingsGui:+c89919D, SettingsNavPin
        GuiControl, SettingsGui:+c89919D, SettingsNavQbar
    }
    GuiControl, SettingsGui:, SettingsGuiStatus,
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
    global SettingsQbarExternalApp
    global needInitQ

    Gui, SettingsGui:Submit, NoHide
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

    qbarExternalApp:=SettingsQbarExternalApp=2 ? "listary" : "builtin"
    qbarKeyValue:=qbarExternalApp="listary" ? "keyFunc_qbarListary" : "keyFunc_qbar"

    ; 内置 Qbar 不再暴露样式选项，切回内置模式时恢复项目原始样式。
    if(settingsGuiPage="qbar" && qbarExternalApp="builtin")
        settingsGui_restoreQbarDefaults()

    autostart:=SettingsAutostart ? 1 : 0
    loadingAnimation:=SettingsLoadingAnimation ? 1 : 0
    allowClipboard:=SettingsAllowClipboard ? 1 : 0
    mouseSpeed:=SettingsMouseSpeed
    hotkeyScheme:=SettingsHotkeyScheme=2 ? "capslock_plus" : "capslox"

    IniWrite, %autostart%, CapsLock+settings.ini, Global, autostart
    IniWrite, %loadingAnimation%, CapsLock+settings.ini, Global, loadingAnimation
    IniWrite, %allowClipboard%, CapsLock+settings.ini, Global, allowClipboard
    IniWrite, %mouseSpeed%, CapsLock+settings.ini, Global, mouseSpeed
    IniWrite, %hotkeyScheme%, CapsLock+settings.ini, Global, default_hotkey_scheme
    IniWrite, %colorValue%, CapsLock+settings.ini, Global, winPinBorderColor
    IniWrite, %soundEnabled%, CapsLock+settings.ini, Global, winPinSoundEnabled
    IniWrite, %soundFile%, CapsLock+settings.ini, Global, winPinSoundFile
    IniWrite, %qbarExternalApp%, CapsLock+settings.ini, Global, qbarExternalApp
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
    if(!IsObject(CLSets.Keys))
        CLSets.Keys:={}
    CLSets.Keys.caps_q:=qbarKeyValue
    needInitQ:=1
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
    if(IsLabel("mouseSpeedInit"))
    {
        settingsTimerLabel:="mouseSpeedInit"
        SetTimer, %settingsTimerLabel%, -1
    }

    if(settingsGuiPage="qbar")
        savedText:=isLangChinese() ? "设置已保存，Qbar 下次打开时应用。" : "Saved. Qbar will apply it next time it opens."
    else
        savedText:=isLangChinese() ? "设置已保存并立即生效。" : "Settings saved and applied."
    GuiControl, SettingsGui:, SettingsGuiStatus, %savedText%
    return true
}

settingsGui_restoreQbarDefaults(){
    global CLSets, needInitQ
    ; 这些值来自 lib_clQ 原有的内置回退值，而不是设置示例里的红/绿/蓝配色。
    defaults:={borderBackgroundColor:"555555", borderRadius:2, textBackgroundColor:"EE2255", textColor:"FFFFFF"
        , textFontName:"", textFontSize:12, listFontName:"", listFontSize:10
        , listBackgroundColor:"333333", listColor:"FFFFFF", listCount:10, lineHeight:19, progressColor:"11DDAA"}
    for key,value in defaults
        IniWrite, %value%, CapsLock+settings.ini, QStyle, %key%
    if(!IsObject(CLSets.QStyle))
        CLSets.QStyle:={}
    for key,value in defaults
        CLSets.QStyle[key]:=value
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
}
else
{
    GuiControl, SettingsGui:, SettingsAutostart, 0
    GuiControl, SettingsGui:, SettingsLoadingAnimation, 1
    GuiControl, SettingsGui:, SettingsAllowClipboard, 1
    GuiControl, SettingsGui:Choose, SettingsMouseSpeed, 3
    GuiControl, SettingsGui:Choose, SettingsHotkeyScheme, 1
}
GuiControl, SettingsGui:, SettingsGuiStatus,
return

SettingsGuiSave:
settingsGui_save()
return

SettingsGuiOpenAdvanced:
Run, CapsLock+settings.ini
return

SettingsGuiCancel:
SettingsGuiClose:
SettingsGuiEscape:
Gui, SettingsGui:Hide
return
