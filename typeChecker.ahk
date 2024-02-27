checkType(val, typeChecking, errMsg := 0) {
    if (val = 0 || val = "") {
        return
    }
    if (!(val is typeChecking)) {
        throw TypeError(Format("{1}; `n`nCurrent Type: {2}", errMsg, Type(val)))
    }
}

checkTypeFormattedString(fs) {
    if (fs = "") {
        return
    }
    if (!(fs is String)) {
        throw TypeError(Format("{1}; `n`nCurrent Type: {2}",
            "Third(formatted string) parameter is not a String.",
            Type(fs)))
    } else if (RegExMatch(fs, "\{\d+\}")) {
        throw TypeError(Format("{1}; `n`nCurrent Type: {2}",
            "Third(formatted string) parameter is not a formatted string with {}.",
            Type(fs)))
    }
}

checkTypeDepend(depend) {
    if (depend = 0) {
        return
    }
    errMsg := "Forth(depend signal) parameter is not a ReactiveSignal or an array containing ReactiveSignals"
    if (!(depend is ReactiveSignal)) {
        throw TypeError(Format("{1}; `n`nCurrent Type: {2}"), errMsg, Type(depend))
    } else if (depend is Array) {
        for item in depend {
            if (!(item is AddReactive)) {
                throw TypeError(Format("{1}; `n`nCurrent Type: {2}"), errMsg, Type(depend))
            }
        }
    }
}

checkTypeEvent(e) {
    if (e = 0) {
        return
    } 
    errMsg := "Fifth(event) parameter is not an [ event, callback ] array."
    if (e is Array && e.Length != 2) {
        throw TypeError(errMsg)
    } else {
        checkType(e, Array, errMsg)
    }
}