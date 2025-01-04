; An AddReactive component that allows you to render componeny dynamically based on signal and Map.
class Dynamic {
    /**
     * Render stateful component dynamically base on signal.
     * ```
     * Dynamic(color, colorEntries, props)
     * ```
     * @param {signal} _signal Depend signal.
     * ```
     * color := signal("Red")
     * ```
     * @param {Map} componentEntries A Map  with option values and related class components
     * ```
     * Red(props) {
     *     r := Component(props.oGui, A_ThisFuc)
     *     return r
     * }
     * 
     * colorEntries := Map("Red", Red, "Blue", Blue)
     * ```
     * @param {Object} props additional props
     * ```
     * props := { gui: oGui, style: "w200 h30" }
     * ```
     */
    __New(_signal, componentEntries, props) {
        checkType(_signal, signal, "Parameter #1 is not a signal")
        checkType(componentEntries, Map, "Parameter #2 is not a Map")
        checkType(props, Object.Prototype, "Parameter #3 is not an Object")

        this.signal := _signal
        this.componentEntries := componentEntries
        this.props := props
        this.components := []
        
        ; mount components
        for val, component in this.componentEntries {
            instance := component.Call(this.props)
            this.components.Push(instance)

            instance.render()
            this._handleNestedComponentRender(instance.childComponents)
        }

        ; show components conditionally
        this._renderDynamic(this.signal.value)
        effect(this.signal, cur => this._renderDynamic(cur))
    }

    _renderDynamic(currentValue) {
        for component in this.components {
            component.visible(this.componentEntries[currentValue].name == component.name)
        }
    }

    _handleNestedComponentRender(childComponents){
        if (childComponents.Length == 0) {
            return
        }

        for childComponent in childComponents {
            childComponent.render()
            if (childComponent.childComponents.Length > 0) {
                this._handleNestedComponentRender(childComponent.childComponents)
            }
        }
    }
}