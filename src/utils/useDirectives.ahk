class useDirectives {
    __New(GuiObj) {
        this.guiObj := GuiObj
        this.directiveOptionMap := Map(
            "@IconOnly", " 0x40 0x300 ",
            "@TextAlignCenter", " Center 0x200 ",
        )
    }

    parseDirective(opt) {
        if (!StringExt.startsWith(opt, "@")) {
            ; ahk options
            return opt
        }
        if (this.directiveOptionMap.Has(opt)) {
            return this.directiveOptionMap[opt]
        }
        else if (StringExt.startsWith(opt, "@Align")) {
        ; else if (RegExMatch(opt, "^@Align(?!.*(.).*\1)[XYWH]+:.*$")) {
            unpack([&alignment, &targetCtrl], StrSplit(opt, ":"))
            
            this.guiObj[targetCtrl].GetPos(&X, &Y, &Width, &Height)

            parsedPos := ""
            loop parse StrReplace(alignment, "@Align", ""), "" {
                parsedPos .= match(A_LoopField, Map(
                    "X", Format(" x{1} ", X),
                    "Y", Format(" y{1} ", Y),
                    "W", Format(" w{1} ", Width),
                    "H", Format(" h{1} ", Height),
                ))
            }

            return parsedPos
        }
        else { 
            throw ValueError("Unknown directive", -1, opt)
        }
    }
}