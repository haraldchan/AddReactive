class Dynamic {
    /**
     * Render class component dynamically base on signal.
     * @param _signal Depend signal.
     * @param componentSets A Map or Array with option values and related class components
     */
    __New(_signal, componentSets) {
        checkType(_signal, signal, "Parameter #1 is not a signal")
        checkType(componentSets, [Array, Map], "Parameter #1 is not a Array or Map")
        for val, componentSet in componentSets {
            checkType(componentSet, Map, "Values of component sets must be a Map")
            for component, params in componentSet {
                checkType(component, Class, "Dynamic can only use with class components")
                checkType(params[1], Gui, "Parameter #1 is not a Gui object")
                checkType(params[2], [String, Number], "Parameter #2 is not a String")
            }
        }

        this.signal := _signal
        this.componentSets := componentSets

        ; hide components
        for val, component in this.componentSets {
            component.visible(false)
        }

        ; show components conditionally
        this.renderDynamic(this.signal.value)
        effect(this.signal, cur => this.renderDynamic(cur))
    }

    renderDynamic(currentValue) {
        for val, component in this.componentSets {
            if (this.signal.value = val) {
                component.visible(true)
            } else {
                component.visible(false)
            }
        }
    }
}