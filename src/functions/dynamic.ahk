; An AddReactive component that allows you to render componeny dynamically based on signal and Map.
class Dynamic {
    /**
     * Render stateful component dynamically base on signal.
     * @param {Gui} guiObj The GUI object to which the Dynamic belongs
     * ```
     * Dynamic(gui, color, colorEntries, props)
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
     * props := { style: "w200 h30" }
     * ```
     */
    __New(guiObj, _signal, componentEntries, props := "", &instances := []) {
        checkType(guiObj, Gui, "Parameter is not a Gui object")
        checkType(_signal, signal, "Parameter is not a signal")
        checkType(componentEntries, Map, "Parameter is not a Map")
        checkType(props, Object.Prototype, "Parameter is not an Object")

        this.signal := _signal
        this.componentEntries := componentEntries
        this._props := props
        this.components := []
        
        ; mount components
        for val, component in this.componentEntries {
            instance := this._props ? component.Call(guiObj, this._props) : component.Call(guiObj)
            this.components.Push(instance)

            instance.render()
            this._handleNestedComponentRender(instance.childComponents)
        }

        ; show components conditionally
        this._renderDynamic(this.signal.value)
        effect(this.signal, cur => this._renderDynamic(cur))

        ; pass component instances reference
        instances := this.components
    }

    _renderDynamic(currentValue) {
        for component in this.components {
            component.visible(false)
        }

        componentToShow := 
            ArrayExt.find(this.components, instance => instance.name == this.componentEntries[currentValue].name) 
            || ArrayExt.find(this.components, instance => instance.name == currentValue)


        componentToShow.visible(true)
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

Gui.Prototype.AddDynamic := Dynamic