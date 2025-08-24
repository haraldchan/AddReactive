#Include "./component-details.ahk"

Components(dtUI) {
    tree := signal(CALL_TREE)
    CALL_TREE.updateTimeStamp := signal(A_Now . A_MSec)
    selectedNodeContent := signal({ 
        name: CALL_TREE.root.name, 
        debuggers: CALL_TREE.root.debuggers 
    })

    effect(CALL_TREE.updateTimeStamp, refreshComponentNodeInfo)
    refreshComponentNodeInfo(*) {
        TV := dtUI["componentTree"]
        node := TV.arcWrapper.shadowTree.getNodeById(TV.GetSelection())
        selectedNodeContent.set({ 
            name: node.name,
            debuggers: node.debuggers
        })
    }

    options := {
        tvOptions: "vcomponentTree x10 w300 h500",
        itemOptions: "Expand"
    }

    handleComponentNodeInfoUpdate(ctrl, itemId) {
        if (!itemId) {
            return
        }

        node := ctrl.arcWrapper.shadowTree.getNodeById(itemId)
        selectedNodeContent.set({ 
            name: node.name,
            debuggers: node.debuggers
        })
    }

    return (
        ; Component Tree
        dtUI.ARTreeView(options, tree).SetFont("s10.5").OnEvent("Click", handleComponentNodeInfoUpdate),
        
        ; Component Details
        ComponentDetails(dtUI, selectedNodeContent)
    )
}