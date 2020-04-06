getSystemLanguage(){
    languageCode_0436 = Afrikaans
    languageCode_041c = Albanian
    languageCode_0401 = Arabic_Saudi_Arabia
    languageCode_0801 = Arabic_Iraq
    languageCode_0c01 = Arabic_Egypt
    languageCode_0401 = Arabic_Saudi_Arabia
    languageCode_0801 = Arabic_Iraq
    languageCode_0c01 = Arabic_Egypt
    languageCode_1001 = Arabic_Libya
    languageCode_1401 = Arabic_Algeria
    languageCode_1801 = Arabic_Morocco
    languageCode_1c01 = Arabic_Tunisia
    languageCode_2001 = Arabic_Oman
    languageCode_2401 = Arabic_Yemen
    languageCode_2801 = Arabic_Syria
    languageCode_2c01 = Arabic_Jordan
    languageCode_3001 = Arabic_Lebanon
    languageCode_3401 = Arabic_Kuwait
    languageCode_3801 = Arabic_UAE
    languageCode_3c01 = Arabic_Bahrain
    languageCode_4001 = Arabic_Qatar
    languageCode_042b = Armenian
    languageCode_042c = Azeri_Latin
    languageCode_082c = Azeri_Cyrillic
    languageCode_042d = Basque
    languageCode_0423 = Belarusian
    languageCode_0402 = Bulgarian
    languageCode_0403 = Catalan
    languageCode_0404 = Chinese_Taiwan
    languageCode_0804 = Chinese_PRC
    languageCode_0c04 = Chinese_Hong_Kong
    languageCode_1004 = Chinese_Singapore
    languageCode_1404 = Chinese_Macau
    languageCode_041a = Croatian
    languageCode_0405 = Czech
    languageCode_0406 = Danish
    languageCode_0413 = Dutch_Standard
    languageCode_0813 = Dutch_Belgian
    languageCode_0409 = English_United_States
    languageCode_0809 = English_United_Kingdom
    languageCode_0c09 = English_Australian
    languageCode_1009 = English_Canadian
    languageCode_1409 = English_New_Zealand
    languageCode_1809 = English_Irish
    languageCode_1c09 = English_South_Africa
    languageCode_2009 = English_Jamaica
    languageCode_2409 = English_Caribbean
    languageCode_2809 = English_Belize
    languageCode_2c09 = English_Trinidad
    languageCode_3009 = English_Zimbabwe
    languageCode_3409 = English_Philippines
    languageCode_0425 = Estonian
    languageCode_0438 = Faeroese
    languageCode_0429 = Farsi
    languageCode_040b = Finnish
    languageCode_040c = French_Standard
    languageCode_080c = French_Belgian
    languageCode_0c0c = French_Canadian
    languageCode_100c = French_Swiss
    languageCode_140c = French_Luxembourg
    languageCode_180c = French_Monaco
    languageCode_0437 = Georgian
    languageCode_0407 = German_Standard
    languageCode_0807 = German_Swiss
    languageCode_0c07 = German_Austrian
    languageCode_1007 = German_Luxembourg
    languageCode_1407 = German_Liechtenstein
    languageCode_0408 = Greek
    languageCode_040d = Hebrew
    languageCode_0439 = Hindi
    languageCode_040e = Hungarian
    languageCode_040f = Icelandic
    languageCode_0421 = Indonesian
    languageCode_0410 = Italian_Standard
    languageCode_0810 = Italian_Swiss
    languageCode_0411 = Japanese
    languageCode_043f = Kazakh
    languageCode_0457 = Konkani
    languageCode_0412 = Korean
    languageCode_0426 = Latvian
    languageCode_0427 = Lithuanian
    languageCode_042f = Macedonian
    languageCode_043e = Malay_Malaysia
    languageCode_083e = Malay_Brunei_Darussalam
    languageCode_044e = Marathi
    languageCode_0414 = Norwegian_Bokmal
    languageCode_0814 = Norwegian_Nynorsk
    languageCode_0415 = Polish
    languageCode_0416 = Portuguese_Brazilian
    languageCode_0816 = Portuguese_Standard
    languageCode_0418 = Romanian
    languageCode_0419 = Russian
    languageCode_044f = Sanskrit
    languageCode_081a = Serbian_Latin
    languageCode_0c1a = Serbian_Cyrillic
    languageCode_041b = Slovak
    languageCode_0424 = Slovenian
    languageCode_040a = Spanish_Traditional_Sort
    languageCode_080a = Spanish_Mexican
    languageCode_0c0a = Spanish_Modern_Sort
    languageCode_100a = Spanish_Guatemala
    languageCode_140a = Spanish_Costa_Rica
    languageCode_180a = Spanish_Panama
    languageCode_1c0a = Spanish_Dominican_Republic
    languageCode_200a = Spanish_Venezuela
    languageCode_240a = Spanish_Colombia
    languageCode_280a = Spanish_Peru
    languageCode_2c0a = Spanish_Argentina
    languageCode_300a = Spanish_Ecuador
    languageCode_340a = Spanish_Chile
    languageCode_380a = Spanish_Uruguay
    languageCode_3c0a = Spanish_Paraguay
    languageCode_400a = Spanish_Bolivia
    languageCode_440a = Spanish_El_Salvador
    languageCode_480a = Spanish_Honduras
    languageCode_4c0a = Spanish_Nicaragua
    languageCode_500a = Spanish_Puerto_Rico
    languageCode_0441 = Swahili
    languageCode_041d = Swedish
    languageCode_081d = Swedish_Finland
    languageCode_0449 = Tamil
    languageCode_0444 = Tatar
    languageCode_041e = Thai
    languageCode_041f = Turkish
    languageCode_0422 = Ukrainian
    languageCode_0420 = Urdu
    languageCode_0443 = Uzbek_Latin
    languageCode_0843 = Uzbek_Cyrillic
    languageCode_042a = Vietnamese

    ; https://www.autohotkey.com/boards/viewtopic.php?t=43376
    RegRead, systemLocale,HKEY_CURRENT_USER,Control Panel\International, Locale

    if(systemLocale)
    {
        systemLocale := SubStr(systemLocale, -3)
    }

    lang := languageCode_%systemLocale%
    ; msgbox, lang: %lang%

    if(lang)
    {
        return lang
    } else {
        return languageCode_%A_Language%
    }

}

isLangChinese()
{
    ; msgbox, % getSystemLanguage()
    ; MsgBox, The system language key is %A_Language%, the locale key is %system_locale%
    return InStr(getSystemLanguage(), "Chinese")
}

isLangChinaChinese()
{
    return getSystemLanguage() == "Chinese_PRC"
}