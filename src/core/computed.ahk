class computed extends signal {
    /**
     * Create a computed signal which derives a reactive value.
     * ```
     * count := signal(2)
     * 
     * doubled := computed(count, c => c * 2) ; doubled.value : 4
     * ```
     * @param {signal | signal[]} depend The signal derives from.
     * @param {Func} mutation computation function expression.
     * @return {computed}
     */
    __New(_signal, mutation) {
        checkType(_signal, [signal, computed, Array], "First parameter is not a signal.")
        checkType(mutation, Func, "Second parameter is not a Function.")

        this.signal := _signal
        this.mutation := mutation
        this.subs := []
        this.comps := []
        this.effects := []
        this.debugger := false

        if (this.signal is Array) {
            for s in this.signal {
                s.addComp(this)
            }
            this.value := this.mutation.Call(this.signal.map(s => s.value)*)
        } else {
            this.signal.addComp(this)
            this.value := this.mutation.Call(this.signal.value)
        }

        if (ARConfig.debugMode && !(this is Debugger)) {
            this.createDebugInfo()
            SignalTracker.trackings[this.debugger.value["varName"]] := this.debugger
        }
    }

    sync(subbedSignal) {
        prevValue := this.value

        if (this.signal is Array) {
            this.value := this.mutation.Call(this.signal.map(s => s.value)*)
        } else {
            this.value := this.mutation.Call(subbedSignal.value)
        }

        ; notify all subscribers to update
        for ctrl in this.subs {
            ctrl.update(this)
        }

        ; notify all computed signals
        for comp in this.comps {
            comp.sync(this)
        }

        ; run all effectss
        for effect in this.effects {
            if (effect.depend is signal) {
                e := effect.effectFn
                if (effect.effectFn.MaxParams == 1) {
                    e(this.value)
                } else if (effect.effectFn.MaxParams == 2) {
                    e(this.value, prevValue)
                } else {
                    e()
                }
            } else if (effect.depend is Array) {
                e := effect.effectFn
                e(effect.depend.map(dep => dep.value)*)
            }
        }

        ; notify signal tracker
        if (this.debugger) {
            this.debugger.update("value", this.value)
        }
    }

    addSub(controlInstance) {
        this.subs.Push(controlInstance)
    }

    addComp(computed) {
        this.comps.Push(computed)
    }

    addEffect(effectFn) {
        this.effects.Push(effectFn)
    }


    createDebugInfo() {
        try {
            throw Error()
        } catch Error as err {
            stacks := StrSplit(err.Stack, "`r`n")

            varLine := StrSplit(
                stacks[ArrayExt.findIndex(stacks, line => line && InStr(line, "this.createDebugInfo")) + 1],
                "[Object.Call]"
            )[2]

            varName := Trim(StrSplit(varLine, ":=")[1])

            classType := StrSplit(err.What, ".")[1]

            scopeLine := stacks[ArrayExt.findIndex(stacks, line => line && InStr(line, "this.createDebugInfo")) + 2]
            scopeName := Trim(StringExt.replaceThese(StrSplit(StrSplit(scopeLine, varName)[1], ":")[2], ["[", "]"]))

            this.debugger := Debugger({
                varName: varName,
                class: classType,
                value: this.value,
                scope: scopeName
            })
        }
    }
}