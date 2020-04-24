English | [中文](README_zh-CN.md)

---

master branch: v3.0+

v2 branch: v2.x

[Docs](https://capslox.com/capslock-plus/en.html)


## How to run the source code?
1. Download and install [AutoHotkey (v1.1.+)](http://www.ahkscript.org/)
2. Clone the Capslock+ source code
3. Run `Capslock+.ahk`

## How to set a custom function to a hotkey?
1. There is a key function `keyFunc_example2` in demo.ahk.
2. Add below setting under the [Keys] section in `CapsLock+settings.ini`:
    `caps_f7=keyFunc_example2`
3. Save, reload Capslock+ (CapsLock+F5)
4. Press `CapsLock+F7` to invoke the function

* In order to avoid calling the internal functions, all the key functions are restricted to start with `keyfunc_`

An example here:

### Replace Capslock+Q with Listary
Listary is a good app launcher, now I want to add two features to it:

1. Activate Listary with `CapsLock+Q`
2. I want to fill the selected text into the pop-up text input box

We can make it like this:

1. Copy the following code to `/userAHK/main.ahk`:
```ahk
keyfunc_listary(){
    ; Get the selected text
    selText:=getSelText()

    ; Send win+F (the default hotkey of Listary) to activate Listary
    sendinput, #{f}

    ; Wait until Listary is activated
    winwait, ahk_exe Listary.exe, , 0.5

    ; If there is any selected text
    if(selText){
        ; Add "gg " before the selected text to google
        selText:="gg " . selText

        ; Fill the text, and press `home` key to move the cursor to the beginning,
        ; in order to add other keywords if you need.
        sendinput, %selText%{home}
    }
}
```

2. Add a setting `caps_q=keyfunc_listary()` under `[Keys]` section in `CapsLock+settings.ini`, save, press `CapsLock+F5` to reload, done.

## How to modify the original functions?
`CapsLock+.ahk` is the entry file, library files are in the `/lib` folder,
the function of each file is as follows:

|Filename|Description|
|:---|:---|
|lib_bindWins.ahk|Window binding|
|lib_clQ.ahk|qbar|
|lib_clTab.ahk|CapsLock+Tab|
|lib_functions.ahk|Some utils|
|lib_init.ahk|Program initialization|
|lib_jsEval.ahk|The calculation function implemented by using the IE engine, required by Math Board and CapsLock+Tab|
|lib_json.ahk|json library|
|lib_keysFunction.ahk|All the key functions|
|lib_keysSet.ahk|Hotkey layouts|
|lib_loadAnimation.ahk|Loading animation when the program starts|
|lib_mathBoard.ahk|Math Board|
|lib_mouseSpeed.ahk|Mouse speed modification|
|lib_settings.ahk|Load the settings in CapsLock+settings.ini|
|lib_ydTrans.ahk|Youdao Translation|

