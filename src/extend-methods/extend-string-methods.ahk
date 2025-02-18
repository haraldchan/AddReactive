defineStringMethods(str) {

    str.Prototype.Length := StrLen(str)
    str.Prototype.toLower := StrLower
    str.Prototype.toUpper := StrUpper
    str.Prototype.toTitle := StrTitle
    str.Prototype.trim := Trim
    str.Prototype.trimStart := LTrim
    str.Prototype.trimEnd := RTrim
    str.Prototype.includes := InStr
    str.Prototype.replace := StrReplace
    str.Prototype.split := StrSplit
    str.Prototype.substr := SubStr
}

defineStringMethods(String)