#SingleInstance Force
#Include "../useAddReactive.ahk"

oGui := Gui("+Resize", "")
TreeViewTest(oGui)
oGui.Show()

TreeViewTest(App) {
    tt := GeneralTree()
    tt.addChild("root", { content: "thing1" })
    tree := signal(tt)

    displayContent := signal(JSON.stringify(tt.root.content))

    options := {
        tvOptions: "vtestTree x10 w300 h300",
        itemOptions: "Expand"
    }

    addNode(*) {
        nodeName := App["nodename"].value
        parentName := App["parentname"].value
        content := App["contentGibberish"].value

        parentName := !parentName ? tt.root.name : parentName

        tt.addChild(nodeName, { content: content }, parentName)
        tree.set(t => tt)
    }

    removeNode(*) {
        nodeName := App["nodename"].value

        tt.removeNode(nodeName)
        tree.set(t => tt)
    }

    showContent(TV, itemId) {
        if (!itemId) {
            return
        }
        selectedNodeContent := TV.arcWrapper.shadowTree.getNodeById(itemId).content
        displayContent.set(JSON.stringify(selectedNodeContent))
    }

    return (
        App.ARTreeView(options, tree).OnEvent("Click", showContent).SetFont("s10"),
        App.AddText("x10 y+10 w300 h25", "Node name            Parent Name           Content"),
        App.AddEdit("vnodename x10 y+0 w80 h25", ""),
        App.AddEdit("vparentname x+10 w80 h25", ""),
        App.AddEdit("vcontentGibberish x+10 w120 h25", ""),
        App.AddButton("x10 y+10 w80 h30", "add!").OnEvent("Click", addNode),
        App.AddButton("x+10 w80 h30", "remove!").OnEvent("Click", removeNode),
        App.ARText("x330 y10 w200 h100", "{1}", displayContent)
    )
}