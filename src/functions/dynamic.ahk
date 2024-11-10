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
        for val, componentInstance in componentPairs {
            checkType(componentInstance, Component, "Value of componentPairs must be a component instance")
        }
        ; if (props != 0) {
        ;     checkType(props, Object, "Parameter #3 is not an Object")
        ; }

        this.signal := _signal
        this.componentPairs := componentPairs
        this.props := props
        this.options := this.props.HasOwnProp("options") ? this.props.options : ""
        
        ; mount components
        for val, componentInstance in componentPairs {
            componentInstance.render()
            componentInstance.visible(false)
            for key, val in this.props.OwnProps() {
                componentInstance.defineProps(this.props)
            }
            
            for ctrl in componentInstance.ctrls {
                ctrl.Opt(this.options)
            }
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