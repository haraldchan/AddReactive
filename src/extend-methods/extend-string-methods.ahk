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

    static length(args*) => StrLen(args*)
    static toLower(args*) => StrLower(args*)
    static toUpper(args*) => StrUpper(args*)
    static toTitle(args*) => StrTitle(args*)
    static trim(args*) => Trim(args*)
    static trimStart(args*) => LTrim(args*)
    static trimEnd(args*) => RTrim(args*)
    static includes(args*) => InStr(args*)
    static replace(args*) => StrReplace(args*)
    static split(args*) => StrSplit(args*)
    static substr(args*) => SubStr(args*)

    static replaceThese(str, needles, replaceText := "", caseSense := false, &outputVarCount := 0, limit := -1) {
        checkType(needles, Array)

        for needle in needles {
            str := StrReplace(str, needle, replaceText, caseSense, &outputVarCount, limit)
        }

        return str
    }
}
