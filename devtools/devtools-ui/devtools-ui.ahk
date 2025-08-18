#Include "./components.ahk"

DevToolsUI() {
    dtUI := Gui("w450 h300", "AddReactive DevToolsUI")
    dtUI.SetFont("微软雅黑")

    return (
        Components(dtUI),

        dtUI.Show()
    )
}