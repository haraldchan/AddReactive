; An AddReactive component that allows you to render componeny dynamically based on signal and Map.
class Dynamic {
    /**
     * Render stateful component dynamically base on signal.
     * @param {signal} _signal Depend signal.
     * @param {Map} componentPairs A Map  with option values and related class components
     * @param {Object} props additional props
     */
    __New(_signal, componentPairs, props := {}) {
        checkType(_signal, signal, "Parameter #1 is not a signal")
        checkType(componentPairs, Map, "Parameter #2 is not a Map")

        this.signal := _signal
        this.componentPairs := componentPairs
        this.props := props
        this.options := this.props.HasOwnProp("options") ? this.props.options : ""
        this.components := []
        
        ; mount components
        for val, component in componentPairs {
            instance := component.Call(this.props)
            this.components.Push(instance)

            instance.render()
        }

        ; show components conditionally
        this._renderDynamic(this.signal.value)
        effect(this.signal, cur => this._renderDynamic(cur))
    }

    _renderDynamic(currentValue) {
        for component in this.components {
            component.visible(currentValue == component.name)
        }
    }
}
