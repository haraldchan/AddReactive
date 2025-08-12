
; g := Gui()
; App(g)
; g.Show()

; App(App) {
; 	getItem(*) {
; 		msgbox TV.getText(P1C1)
; 	}

; 	return (
; 		TV := App.AddTreeView(),
; 		TV.SetFont("s10.5"),
; 		P1 := TV.Add("First parent"),
; 		P1C1 := TV.Add("Parent 1's first child", P1, "Check Bold"),
; 		P2 := TV.Add("Second parent"),
; 		P2C1 := TV.Add("Parent 2's first child", P2),
; 		P2C2 := TV.Add("Parent 2's second child", P2),
; 		P2C2C1 := TV.Add("Child 2's first child", P2C2)

; 		App.AddButton("h30 w100", "get second p").OnEvent("Click", getItem)
; 	)
; }

class CompNode {
	__New(nodeContent) {
		this.content := nodeContent
		this.parent := ""
		this.childrens := []
	}
}

class CompTree {
	__New() {
		this.root := ""
	}

	copy() {
		
	}

	getNode(label, curNode := this.root) {
		if (label == curNode.content.label) {
			return curNode
		}

		if (curNode.childrens.Length > 0) {
			for childNode in curNode.childrens {
				res := this.getNode(label, childNode)
				if (res) {
					return res
				}
			}
		}

		return false
	}

	modifyNode(label, newContent) {
		targetNode := this.getNode(label)
		if (!targetNode) {
			return false
		}

		targetNode.content := newContent

		return true
	}

	addChildren(label, parentLabel := 0) {
		newNode := CompNode({ label: label })

		if (!parentLabel && !this.root) {
			this.root := newNode
			return newNode
		}

		if (!parentLabel && this.root) {
			this.root.childrens.Push(newNode)
			newNode.parent := this.root
			return newNode
		}

		parentNode := this.getNode(parentLabel)
		if (!parentNode) {
			return false
		}

		newNode.parent := parentNode
		parentNode.childrens.Push(newNode)

		return true
	}
}

ct := CompTree()
ct.addChildren("root node")

ct.addChildren("A")
ct.addChildren("A1", "A")
ct.addChildren("A2", "A")

ct.addChildren("B")
ct.addChildren("B1", "B")
ct.addChildren("B11", "B1")
ct.addChildren("B12", "B1")
ct.addChildren("B111", "B11")

ct.addChildren("C")
ct.modifyNode("C", { label: "C", id: "123" })

st := ct.copy()

st.modifyNode("C", { label: "C", id: "456" })

; msgbox ct.getNode("C").content.id