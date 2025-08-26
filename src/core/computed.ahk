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

        ; debug mode
        if (!IsSet(DebugUtils) && !IsSet(debugger)) {
            return
        }

        if (ARConfig.debugMode && !(this is debugger)) {
            this.createDebugger := DebugUtils.createDebugger
            this.debugger := this.createDebugger(this)
            if (InStr(this.debugger.value["caller"]["file"], "\AddReactive\devtools")) {
                this.debugger := false
            } else {
                IsSet(CALL_TREE) && CALL_TREE.addDebugger(this.debugger)
            }
        }
    }

    /**
     * Interface for subscribed signal to sync value to date.
     * @param {signal} subbedSignal subscribed signal
     */
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
    }

    /**
     * Interface for AddReactiveControl instances to subscribe.
     * @param {AddReactive} AddReactiveControl 
     */
    addSub(AddReactiveControl) {
        this.subs.Push(AddReactiveControl)
    }

    /**
     * Interface for computed instances to subscribe.
     * @param {computed} computed 
     */
    addComp(computed) {
        this.comps.Push(computed)
    }

    /**
     * Interface for effect instances to subscribe.
     * @param {effect} effect
     */
    addEffect(effect) {
        this.effects.Push(effect)
    }
}