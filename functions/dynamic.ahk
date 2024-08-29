class Dynamic {
    /**
     * Render class component dynamically base on signal.
     * @param _signal Depend signal.
     * @param valueComponentPairs A Map or Array with option values and related class components
     */
    __New(_signal, valueComponentPairs) {
        checkType(_signal, signal, "Parameter #1 is not a signal")
        checkType(valueComponentPairs, [Array, Map], "Parameter #1 is not a Array or Map")
        for val, componentSet in valueComponentPairs {
            checkType(componentSet, Map, "Values of component sets must be a Map")
            for component, params in componentSet {
                checkType(component, Class, "Dynamic can only use with class components")
                checkType(params, [Array, Gui], "Parameter #1 is not a Gui object or array")
            }
        }

        this.signal := _signal
        this.valueComponentPairs := valueComponentPairs
        this.componentSets := valueComponentPairs.values()
        this.componentInstances := []

        ; mount components
        for componentSet in this.componentSets {
            for component, props in componentSet {
                if (props is Gui) {
                    this.componentInstances.Push(component.Call(props))
                } else {
                    this.componentInstances.Push(component.Call(props*))
                }
            }
        }

        ; hide components
        for component in this.componentInstances {
            component.visible(false)
        }

        ; show components conditionally
        this.renderDynamic(this.signal.value)
        effect(this.signal, cur => this.renderDynamic(cur))
    }

    renderDynamic(currentValue) {
        for component in this.componentInstances {
            if (this.valueComponentPairs[currentValue].keys()[1].name = component.name) {
                component.visible(true)
            } else {
                component.visible(false)
            }
        }
    }
}