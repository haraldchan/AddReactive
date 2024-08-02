checkType(val, typeChecking, errMsg := 0) {
    if (val = 0 || val = "") {
        return
    }

    if(typeChecking is Array) {
        for t in typeChecking {
            if (val is t) {
                return
            } else {
                continue
            }
        }

        throw TypeError(Format("{1}; `n`nCurrent Type: {2}", errMsg, Type(val)))
    }

    if (!(val is typeChecking)) {
        throw TypeError(Format("{1}; `n`nCurrent Type: {2}", errMsg, Type(val)))
    }
}

checkTypeDepend(depend) {
    if (depend = 0) {
        return
    }
    errMsg := "Forth(depend signal) parameter is not a Signal or an array containing Signals"
    if (depend is Array) {
         for item in depend {
            if (!(item is signal || item is computed)) {
                throw TypeError(Format("{1}; `n`nCurrent Type: {2}", errMsg, Type(depend)))
            }
        }
    } else if (!(depend is signal || depend is computed)) {
        throw TypeError(Format("{1}; `n`nCurrent Type: {2}", errMsg, Type(depend)))
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