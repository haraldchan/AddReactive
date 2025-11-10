MouseSpy_Settings(App, config, MouseSpyWindowTitle) {
    unpack({ 
        ; curMouseCoordMode: &curMouseCoordMode,
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
            hotkey: config["hotkeys"]["markAnchor"],
            callback: (*) => anchorPos.set(handleMousePosUpdate())
        },
        moveToAnchor: {
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
        
        Hotkey hotkeySetup.moveToAnchor.hotkey, hotkeySetup.moveToAnchor.callback, "On"
        
        HotIf((*) => WinExist(MouseSpyWindowTitle) && App["use-mouse-pos-anchor"].Value)
        Hotkey hotkeySetup.markAnchor.hotkey, hotkeySetup.markAnchor.callback, "On"
    }

    handleConfigUpdate() {
        FileDelete("./mousespy.config.json")
        FileAppend(JSON.stringify(config), "./mousespy.config.json", "UTF-8")
    }
    
    handleSetHotkeys(ctrl, _) {
        curHotkeyName := StrReplace(ctrl.Name, "Hotkey", "")

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
        ; { hotkeys setup
        App.AddGroupBox("Section w350 h80", "Hotkeys").SetFont("s10 bold"),
        ; anchor marking
        App.AddText("xs10 yp+22 w100 h20 0x200", "Mark Anchor:"),
        App.AddHotkey("vmark-anchor-hotkey x+10", config["hotkeys"]["markAnchor"])
           .OnEvent("Change", handleSetHotkeys),
        ; move to anchor
        App.AddText("xs10 yp+25 w100 h20 0x200", "Move to Anchor:"),
        App.AddHotkey("vmove-to-anchor-hotkey x+10", config["hotkeys"]["moveToAnchor"])
           .OnEvent("Change", handleSetHotkeys),
        ; }

        ; { misc
        App.AddGroupBox("Section w350 x22 yp+40 h160", "Misc").SetFont("s10 bold"),
        ; refresh interval
        App.AddText("xs10 yp+22 w100 h20 0x200", "Update Interval:"),
        App.AddEdit("vupdate-interval x+10 w110 h20 Number", config["misc"]["updateInterval"])
           .OnEvent("LoseFocus", handleUpdateIntervalUpdate),
        App.AddText("x+5 w50 h20 0x200", "ms"),
        ; }

        setHotkeys()
    )
}