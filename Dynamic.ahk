class Dynamic {
    __New(_signal, componentSets) {
        checkType(_signal, signal, "Parameter #1 is not a signal")
        checkType(componentSets, [Array, Map], "Parameter #1 is not a Array or Map")

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