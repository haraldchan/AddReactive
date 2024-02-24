checkType(val, typeChecking, errMsg := 0) {
    if (!(val is typeChecking)) {
        throw TypeError(Format("{1}; `n`nCurrent Type: {2}", errMsg, Type(val)))
    }
}

checkTypeFormattedString(fs) {
    if (!(fs is String)) {
        throw TypeError(Format("{1}; `n`nCurrent Type: {2}",
            "Third(formatted string) parameter is not a String.",
            Type(fs)))
    } else if (!RegExMatch(fs, "/{(\d+)}/g")) {
        throw TypeError(Format("{1}; `n`nCurrent Type: {2}",
            "Third(formatted string) parameter is not a formatted string with {}.",
            Type(fs)))
    }
}

checkTypeDepend(depend) {
    errMsg := "Forth(depend signal) parameter is not a ReactiveSignal or an array containing ReactiveSignals"
    if (!(depend is ReactiveSignal)) {
        throw TypeError(Format("{1}; `n`nCurrent Type: {2}"), errMsg, Type(depend))
    } else if (depend is Array) {
        for item in depend {
            if (!(item is ReactiveControl)) {
                throw TypeError(Format("{1}; `n`nCurrent Type: {2}"), errMsg, Type(depend))
            }
        }
    }
}

checkTypeEvent(e) {
    errMsg := "Fifth(event) parameter is not an [ event, callback ] array."
    if (e := 0) {
        return
    } else if (e.Length != 2) {
        throw TypeError(errMsg)
    }
    checkType(e, Array, errMsg)
}