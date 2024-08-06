class useListPlaceholder {
    /**
     * Set placeholder value for AddReactive ListView such as loading or error.
     * @param {signal} signal Signal that provides list content.
     * @param {Object | Array} columnDetails An object or Array containing the keys for column values.
     * @param {String} placeHolder Text as placeholder.
     */
    __New(_signal, columnDetails, placeholder) {
        checkType(_signal, signal, "First Parameter is not a signal.")
        checkType(_signal.value, Array, "useListPlaceholder can only work with Array signals.")
        checkType(columnDetails, [Object, Array], "Second Parameter is not an Object.")
        checkType(placeholder, String, "Third Parameter is not an String.")

        this.columnKeys := ((columnDetails is Object) && !(columnDetails is Array)) 
            ? columnDetails.keys 
            : columnDetails
        this.placeHolder := placeholder

        _signal.set([this.setLoadingValue()])
    }

    setLoadingValue(){
        loadingValue := Map()

        for key in this.columnKeys {
            loadingValue[key] := this.placeHolder
        }

        return loadingValue
    }
}