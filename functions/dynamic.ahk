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
        this.renderDynamic(this.signal.value)
        effect(this.signal, cur => this.renderDynamic(cur))
    }

    renderDynamic(currentValue) {
        for val, component in this.componentPairs {
            component.visible(this.componentPairs[currentValue].name = component.name)
        }
    }
}

; class Dynamic {
;     /**
;      * Render class component dynamically base on signal.
;      * @param {signal} _signal Depend signal.
;      * @param {Map} valueComponentPairs A Map or Array with option values and related class components
;      */
;     __New(_signal, valueComponentPairs) {
;         checkType(_signal, signal, "Parameter #1 is not a signal")
;         checkType(valueComponentPairs, [Array, Map], "Parameter #1 is not a Array or Map")
;         for val, componentSet in valueComponentPairs {
;             checkType(componentSet, Map, "Values of component sets must be a Map")
;             for component, params in componentSet {
;                 checkType(component, Class, "Dynamic can only use with class components")
;                 checkType(params, [Array, Gui], "Parameter #1 is not a Gui object or array")
;             }
;         }

;         this.signal := _signal
;         this.valueComponentPairs := valueComponentPairs
;         this.componentSets := valueComponentPairs.values()
;         this.componentInstances := []

;         ; mount components
;         for componentSet in this.componentSets {
;             for component, props in componentSet {
;                 if (props is Gui) {
;                     this.componentInstances.Push(component.Call(props))
;                 } else {
;                     this.componentInstances.Push(component.Call(props*))
;                 }
;             }
;         }

;         ; hide components
;         for component in this.componentInstances {
;             component.visible(false)
;         }

;         ; show components conditionally
;         this.renderDynamic(this.signal.value)
;         effect(this.signal, cur => this.renderDynamic(cur))
;     }

;     renderDynamic(currentValue) {
;         for component in this.componentInstances {
;             if (this.valueComponentPairs[currentValue].keys()[1].name = component.name) {
;                 component.visible(true)
;             } else {
;                 component.visible(false)
;             }
;         }
;     }
; }
