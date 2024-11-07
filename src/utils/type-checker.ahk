/**
 * Checks the type of a value.
 * @param {any} val Value to be checked
 * @param {any|Array} typeChecking A type or multiple types to check
 * @param {String} errMsg Error message to show
 */
checkType(val, typeChecking, errMsg := 0) {
    if (val = 0 || val = "") {
        return
    }

    if (typeChecking is Array) {
        for t in typeChecking {
            if (val is t) {
                return
            } else if (t == Object.Prototype) {
                if (isPlainObject(val)) {
                    return
                }
            } else {
                continue
            }
        }

        throw TypeError(errMsg != 0
            ? Format("{1}; `n`nCurrent Type: {2}", errMsg, Type(val))
            : Format("Expect Type: {1}. Current Type: {2}", Type(typeChecking), Type(val))
        )
    }

    if (typeChecking == Object.Prototype) {
        if (!isPlainObject(val)) {
            throw TypeError(errMsg != 0
                ? Format("{1}; `n`nCurrent Type: {2}", errMsg, Type(val))
                : Format("Expect Type: {1}. Current Type: {2}", "plain ", Type(val))
            )    
        }
    }

    if (!(val is typeChecking)) {
        throw TypeError(errMsg != 0
            ? Format("{1}; `n`nCurrent Type: {2}", errMsg, Type(val))
            : Format("Expect Type: {1}. Current Type: {2}", Type(typeChecking), Type(val))
        )
    }
}

checkTypeDepend(depend) {
    if (depend = 0) {
        return
    }
    errMsg := "Parameter #3 (depend) is not a signal or an array containing signals"
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

isPlainObject(obj) {
    return obj.base == Object.Prototype ? true : false
}