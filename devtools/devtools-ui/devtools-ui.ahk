#Include "./components.ahk"

DevToolsUI() {
    dtUI := Gui("", "AddReactive DevToolsUI")
    dtUI.SetFont(,"微软雅黑")

    return (
        Components(dtUI),

        dtUI.Show()
    )
}