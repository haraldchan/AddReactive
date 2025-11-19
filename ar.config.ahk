class ARConfig {
    static debugMode := true
    static useDevtoolsUI := false

    static useExtendMethods := true
    static enableExtendMethods := {
        array: {
            includes:      true,
            some:          true,
            every:         true,
            filter:        true,
            find:          true,
            findLast:      true,
            findIndex:     true,
            findLastIndex: true,
            at:            true,
            map:           true,
            reduce:        true,
            with:          true,
            append:        true,
            unshift:       true,
            reverse:       true,
            unique:        true,
            flat:          true,
            join:          true,
            slice:         true,
            sort:          true,
        },
        string: {
            length:        true,
            toLower:       true,
            toUpper:       true,
            toTitle:       true,
            trim:          true,
            trimStart:     true,
            trimEnd:       true,
            includes:      true,
            replace:       true,
            replaceThese:  true,
            split:         true,
            substr:        true,
            repeat:        true,
            slice:         true,
            startsWith:    true,
            endsWith:      true,
        },
        integer: {
            times:         true
        },
        map: {
            keys:          true,
            values:        true,
            getKey:        true,
            deepClone:     true,
            setDefault:    true,
        },
        gui: {
            getCtrlByName:     true,
            getCtrlsByMatch:   true,
            getCtrlByType:     true,
            getCtrlByTypeAll:  true,
            getCtrlByText:     true,
            getComponent:      true,
            control: {
                onChange:      true,
                onClick:       true,
                onDoubleClick: true,
                onColClick:    true,
                onContextMenu: true,
                onFocus:       true,
                onBlur:        true,
                onItemCheck:   true,
                onItemEdit:    true,
                onItemExpand:  true,
                onItemFocus:   true,
                onItemSelect:  true,                
                setFont:       true,
            },
            listview: {
                getCheckedRowNumbers: true,
                getFocusedRowNumbers: true
            }
        }
    }

    static useExtendClasses := true
    static enableExtendClasses := {
        duration: {
            integer: {
                seconds: true,
                minutes: true,
                hours:   true,
                days:    true,
            },
            string: {
                secondsBetween:  true,
                minutesBetween:  true,
                hoursBetween:    true,
                daysBetween:     true,
                tomorrow:        true,
                nextDay:         true,
                yesterday:       true,
                toFormat:        true, 
            }
        }
    }
}