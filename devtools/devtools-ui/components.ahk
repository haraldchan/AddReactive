#Include "./component-details.ahk"

Components(dtUI) {
    NodeContent := Struct({
        name: String,
        stack: String,
        file: String,
        callerChainMap: OrderedMap,
        debuggers: Array
    })

    tree := signal(CALL_TREE)
    selectedNodeContent := signal({ name: "", stack: "", file: "", callerChainMap: OrderedMap(), debugger: [] })

    options := {
        tvOptions: "$ComponentTree x10 w300 h300 ",
        itemOptions: "Expand"
    }

    handleComponentNodeInfoUpdate(ctrl, itemId) {
        content := ctrl.arcWrapper.shadowTree.getNodeById(itemId).content.debuggers.map(d => JSON.stringify(d))
        selectedNodeContent.set(JSON.stringify(content))
    }

    return (
        ; Component Tree
        dtUI.ARTreeView(options, tree).SetFont("s10.5").OnEvent("Click", handleComponentNodeInfoUpdate),
        
        ; Component Details
        ComponentDetails(dtUI, selectedNodeContent),
    )
}