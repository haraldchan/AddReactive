defineStringMethods(str) {

    str.Prototype.length := StrLen
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
    
    str.Prototype.replaceThese := replaceThese
    replaceThese(str, needles, replaceText := "", caseSense := false, &outputVarCount := 0, limit := -1) {
        checkType(needles, Array)

        for needle in needles {
            str := StrReplace(str, needle, replaceText, caseSense, &outputVarCount, limit)
        }

        return str
    }
}

defineStringMethods(String)
