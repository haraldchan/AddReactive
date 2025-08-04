class StringExt {
    static patch() {
        if (!ARConfig.useExtendMethods) {
            return
        }

        for method, enabled in ARConfig.enableExtendMethods.string.OwnProps() {
            if (enabled) {
                String.Prototype.%method% := ObjBindMethod(this, method)
            }
        }
    }

    static length := StrLen
    static toLower := StrLower
    static toUpper := StrUpper
    static toTitle := StrTitle
    static trim := Trim
    static trimStart := LTrim
    static trimEnd := RTrim
    static includes := InStr
    static replace := StrReplace
    static split := StrSplit
    static substr := SubStr

    static replaceThese(str, needles, replaceText := "", caseSense := false, &outputVarCount := 0, limit := -1) {
        checkType(needles, Array)

        for needle in needles {
            str := StrReplace(str, needle, replaceText, caseSense, &outputVarCount, limit)
        }

        return str
    }
}