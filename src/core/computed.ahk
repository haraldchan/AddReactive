class computed {
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

        if (this.signal is Array) {
            this.subbedSignals := Map()

            for s in this.signal {
                this.subbedSignals[s] := s.value
                s.addComp(this)
            }
            this.value := this.mutation.Call(this.subbedSignals.values()*)
        } else {
            this.signal.addComp(this)
            this.value := this.mutation.Call(this.signal.value)
        }
    }

    sync(subbedSignal) {
        if (this.signal is Array) {
            for s in this.subbedSignals {
                if (s = subbedSignal) {
                    this.subbedSignals[s] := s.value
                    break
                }
            }
            this.value := this.mutation.Call(this.subbedSignals.values()*)
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
        if (this.effects.Length > 0) {
            for effect in this.effects {
                effect()
            }
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
}