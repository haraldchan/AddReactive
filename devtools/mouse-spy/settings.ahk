MouseSpy_Settings(App, config, MouseSpyWindowTitle) {
    unpack({ 
        curMouseInfo:      &curMouseInfo,
        anchorPos:         &anchorPos,
        followMouse:       &followMouse,
        methods: { 
            updater:       &updater,
            handleMousePosUpdate: &handleMousePosUpdate,
            moveToAnchor:  &moveToAnchor
        }
    }, mouseStore)

    hotkeySetup := {
        markAnchor: {
            defaultHotkey: "+!s",
            hotkey: config["hotkeys"]["markAnchor"],
            callback: (*) => anchorPos.set(handleMousePosUpdate())
        },
        moveToAnchor: {
            defaultHotkey: "+!q",
            hotkey: config["hotkeys"]["moveToAnchor"],
            callback: moveToAnchor
        }
    }

    setHotkeys() {
        CoordMode("Mouse", "Screen")

        HotIfWinExist(MouseSpyWindowTitle)
        Hotkey "~*Ctrl", (*) => followMouse.set(false)
        Hotkey "~*Ctrl up", (*) => followMouse.set(true)
        Hotkey "~*Shift", (*) => followMouse.set(false)
        Hotkey "~*Shift up", (*) => followMouse.set(true)
        
        if (!hotkeySetup.moveToAnchor.hotkey) {
            hotkeySetup.moveToAnchor.hotkey := hotkeySetup.moveToAnchor.defaultHotkey
            config["hotkeys"]["moveToAnchor"] := hotkeySetup.moveToAnchor.defaultHotkey
            App["move-to-anchor-hotkey"].Value := hotkeySetup.moveToAnchor.defaultHotkey
            handleConfigUpdate()
        }
        if (!hotkeySetup.markAnchor.hotkey) {
            hotkeySetup.markAnchor.hotkey := hotkeySetup.markAnchor.defaultHotkey
            config["hotkeys"]["markAnchor"] := hotkeySetup.markAnchor.defaultHotkey
            App["mark-anchor-hotkey"].Value := hotkeySetup.markAnchor.defaultHotkey
            handleConfigUpdate()
        }
        Hotkey hotkeySetup.moveToAnchor.hotkey, hotkeySetup.moveToAnchor.callback, "On"
        
        HotIf((*) => WinExist(MouseSpyWindowTitle) && App["use-mouse-pos-anchor"].Value)
        Hotkey hotkeySetup.markAnchor.hotkey, hotkeySetup.markAnchor.callback, "On"
    }

    handleConfigUpdate() {
        FileDelete("./mousespy.config.json")
        FileAppend(JSON.stringify(config), "./mousespy.config.json", "UTF-8")
    }
    
    handleSetHotkeys(ctrl, _) {
        ; curHotkeyName := StrReplace(ctrl.Name, "-hotkey", "")
        curHotkeyName := pipe(
            name => StrReplace(name, "-hotkey", ""),
            name => StrSplit(name, "-"),
            name => ArrayExt.map(name, (chunk, index) => index > 1 ? StrTitle(chunk) : chunk),
            name => ArrayExt.join(name, "")
        )(ctrl.Name)

        Sleep 200
        try {
            Hotkey hotkeySetup.%curHotkeyName%.hotkey, hotkeySetup.%curHotkeyName%.callback, "Off"
            hotkeySetup.%curHotkeyName%.hotkey := ctrl.Value
            
            Hotkey hotkeySetup.%curHotkeyName%.hotkey, hotkeySetup.%curHotkeyName%.callback, "On"
            
            config["hotkeys"][curHotkeyName] := ctrl.Value
            handleConfigUpdate()
        }
    }

    handleUpdateIntervalUpdate(ctrl, _) {
        SetTimer(updater, ctrl.Value)
        
        config["misc"]["updateInterval"] := ctrl.Value
        handleConfigUpdate()
    }

    return (
        StackBox(App,
            {
                name: "hotkey-setup",
                fontOptions: "s10 bold",
                groupbox: {
                    title: "Record Options",
                    options: "Section w345 h80"
                }
            },
            () => [
                ; anchor marking
                App.AddText("xs10 yp+22 w100 h20 0x200", "Mark Anchor:"),
                App.AddHotkey("vmark-anchor-hotkey x+10", config["hotkeys"]["markAnchor"]).onChange(handleSetHotkeys),
                
                ; move to anchor
                App.AddText("xs10 yp+25 w100 h20 0x200", "Move to Anchor:"),
                App.AddHotkey("vmove-to-anchor-hotkey x+10", config["hotkeys"]["moveToAnchor"]).onChange(handleSetHotkeys)
            ]
        ),

        StackBox(App,
            {
                name: "misc-settings",
                fontOptions: "s10 bold",
                groupbox: {
                    title: "Misc",
                    options: "Section w345 x22 y+5 h160"
                }
            },
            () => [
                ; refresh interval
                App.AddText("xs10 yp+22 w100 h20 0x200", "Update Interval:"),
                App.AddEdit("vupdate-interval x+10 w110 h20 Number", config["misc"]["updateInterval"]).onBlur(handleUpdateIntervalUpdate),
                App.AddText("x+5 w50 h20 0x200", "ms"),
            ]
        ),

        setHotkeys()
    )
}