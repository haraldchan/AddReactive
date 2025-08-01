class ARConfig {
    static useExtendMethods := true

    static extendMethods := {
        array: {
            some:      true,
            every:     true,
            filter:    true,
            find:      true,
            findIndex: true,
            at:        true,
            map:       true,
            reduce:    true,
            with:      true,
            append:    true,
            unshift:   true,
            reverse:   true,
            unique:    true,
            flat:      true,
            join:      true,
            slice:     true,
            sort:      true,
        },
        map: {
            keys:      true,
            values:    true,
            getKey:    true,
            deepClone: true,

        },
        gui: {
            getCtrlByName:    true,
            getCtrlByType:    true,
            getCtrlByTypeAll: true,
            getCtrlByText:    true,
            getComponent:     true,
            listview: {
                getCheckedRows: true,
                getFocusedRows: true
            }
        }
    }
}