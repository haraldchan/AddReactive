class ARConfig {
    static useExtendMethods := true
    static enableExtendMethods := {
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
                toFormat:        true, 
            }
        }
    }
}
