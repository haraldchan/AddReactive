; #Include "./components.ahk"
#Include "./reactives.ahk"

if (ARConfig.debugMode) {
    global CALL_TREE := CallTree()
}

DevToolsUI() {
    if (!ARConfig.debugMode) {
        return
    }

    ARConfig.useDevtoolsUI := true

    dtUI := Gui("", "AddReactive DevTools")
    dtUI.SetFont(,"Verdana")
    dtUI.useDirectives()

    return (
        Tabs := dtUI.AddTab3(, ["Reactives", "Components", "Code Preview", "Replay"]),
        
        Tabs.UseTab("Reactives"),
        Reactives(dtUI),

        ; Tabs.UseTab("Components"),
        ; Components(dtUI),

        dtUI.Show()
    )
}