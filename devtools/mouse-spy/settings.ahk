MouseSpy_Settings(App, config, MouseSpyWindowTitle) {
    hotkeySetup := {
        markAnchor: {
            hotkey: config["hotkeys"]["markAnchor"],
            callback: (*) => store.anchorPos.set(store.useMethod("handleMousePosUpdate")())
        },
        moveToAnchor: {
            hotkey: config["hotkeys"]["moveToAnchor"],
            callback: store.useMethod("moveToAnchor")
        }
    }

    setHotkeys() {
        CoordMode("Mouse", "Screen")

        HotIfWinExist(MouseSpyWindowTitle)
        Hotkey "~*Ctrl", (*) => store.followMouse.set(false)
        Hotkey "~*Ctrl up", (*) => store.followMouse.set(true)
        Hotkey "~*Shift", (*) => store.followMouse.set(false)
        Hotkey "~*Shift up", (*) => store.followMouse.set(true)
        
        Hotkey hotkeySetup.moveToAnchor.hotkey, hotkeySetup.moveToAnchor.callback, "On"
        
        HotIf((*) => WinExist(MouseSpyWindowTitle) && App["useMousePosAnchor"].Value)
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
        SetTimer(store.useMethod("updater"), ctrl.Value)
        
        config["misc"]["updateInterval"] := ctrl.Value
        handleConfigUpdate()
    }

    return (
        ; { hotkeys setup
        App.AddGroupBox("Section w350 h80", "Hotkeys").SetFont("s10 bold"),
        ; anchor marking
        App.AddText("xs10 yp+22 w100 h20 0x200", "Mark Anchor:"),
        App.AddHotkey("vmarkAnchorHotkey x+10", config["hotkeys"]["markAnchor"])
           .OnEvent("Change", handleSetHotkeys),
        ; move to anchor
        App.AddText("xs10 yp+25 w100 h20 0x200", "Move to Anchor:"),
        App.AddHotkey("vmoveToAnchorHotkey x+10", config["hotkeys"]["moveToAnchor"])
           .OnEvent("Change", handleSetHotkeys),
        ; }

        ; { misc
        App.AddGroupBox("Section w350 x22 yp+40 h160", "Misc").SetFont("s10 bold"),
        ; refresh interval
        App.AddText("xs10 yp+22 w100 h20 0x200", "Update Interval:"),
        App.AddEdit("vupdateInterval x+10 w110 h20 Number", config["misc"]["updateInterval"])
           .OnEvent("LoseFocus", handleUpdateIntervalUpdate),
        App.AddText("x+5 w50 h20 0x200", "ms"),
        ; }

        setHotkeys()
    )
}