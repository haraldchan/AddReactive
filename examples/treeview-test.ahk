#SingleInstance Force
#Include "../useAddReactive.ahk"

oGui := Gui("+Resize", "")
TreeViewTest(oGui)
oGui.Show()

TreeViewTest(App) {
    tt := TestTree()
    tt.addChildren("root", { content: "thing1" })
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

        tt.addChildren(nodeName, { content: content }, parentName)
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
        App.ARText("x330 y10 w200 h100", "{1}", displayContent)
    )
}


class TestNode {
    __New(name, content) {
        this.name := name
        this.content := content
        this.parent := ""
        this.childrens := []
    }
}

class TestTree {
    __New() {
        this.root := ""
    }

    getNode(name, curNode := this.root) {
        if (name == curNode.name) {
            return curNode
        }

        if (curNode.childrens.Length > 0) {
            for childNode in curNode.childrens {
                res := this.getNode(name, childNode)
                if (res) {
                    return res
                }
            }
        }

        return false
    }

    addChildren(name, content, parentName := "") {
        newNode := TestNode(name,content)

        if (!this.root) {
            this.root := newNode
            return newNode
        }

        if (!parentName && this.root) {
            this.root.childrens.Push(newNode)
            newNode.parent := this.root
            return newNode
        }

        parentNode := this.getNode(parentName)
        if (!parentNode) {
            return false
        }

        newNode.parent := parentNode
        parentNode.childrens.Push(newNode)

        return newNode
    }

}