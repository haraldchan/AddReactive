class Dynamic {
    /**
     * Render class component dynamically base on signal.
     * @param {signal} _signal Depend signal.
     * @param {Map} componentPairs A Map  with option values and related class components
     * @param {Object} props additional props
     */
    __New(_signal, componentPairs, props := 0) {
        checkType(_signal, signal, "Parameter #1 is not a signal")
        checkType(componentPairs, Map, "Parameter #2 is not a Array or Map")
        for val, componentInstance in componentPairs {
            checkType(componentInstance, Component, "Value of componentPairs must be a component instance")
        }
        if (props != 0) {
            checkType(props, Object, "Parameter #3 is not an Object")
        }

        this.signal := _signal
        this.componentPairs := componentPairs
        this.props := props
        if (this.props != 0) {
            for val, componentInstance in componentPairs {
                componentInstance.defineProps(this.props)
            }
        }

        ; mount components
        for val, componentInstance in componentPairs {
            componentInstance.render()
            componentInstance.visible(false)
        }

        ; show components conditionally
        this._renderDynamic(this.signal.value)
        effect(this.signal, cur => this._renderDynamic(cur))
    }

    _renderDynamic(currentValue) {
        for val, component in this.componentPairs {
            component.visible(this.componentPairs[currentValue].name = component.name)
        }
    }
}