#Include "./components.ahk"

DevToolsUI() {
    ARConfig.useDevtoolsUI := true

    dtUI := Gui("", "AddReactive DevTools")
    dtUI.SetFont(,"微软雅黑")

    return (
        Tabs := dtUI.AddTab3(, ["Components", "Code Preview", "Replay"]),
        
        Tabs.UseTab(1),
        Components(dtUI),

        dtUI.Show()
    )
}