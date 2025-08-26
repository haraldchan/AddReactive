class CallNode {
	/**
	 * Creates a CallNode.
	 * @param {Object} nodeContent 
	 */
	__New(nodeName, content) {
		this.parent := ""
		this.childrens := []

		this.name := nodeName
		this.content := content
	}
}


class CallTree {
	__New() {
		this.root := ""
	}


	/**
	 * Gets a node by using name and file as search keys.
	 * @param {String} name 
	 * @param {CallNode} curNode 
	 * @returns {CallNode | false}
	 */
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


	/**
	 * Appends children node to a node by using name and file as search keys.
	 * @param {String} name 
	 * @param {Object} content 
	 * @param {String} parentName  
	 * @returns {CallNode | false} 
	 */
	addChildren(name, content, parentName := "") {
		newNode := CallNode(name, content)

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


	/**
	 * Adds debugger to a caller node. Also creates caller nodes on the first traverse.
	 * @param {debugger} debugger 
	 * @param {Number} chainIndex 
	 * @param {CallNode} prevNodeReached 
	 */
	addDebugger(debugger, chainIndex := 1, prevNodeReached := "") {
		if (InStr(debugger.value["caller"]["file"], "AddReactive\devtools")) {
			return
		}

		callChain := debugger.value["caller"]["callChainMap"]
		if (chainIndex > callChain.Length) {
			return
		}

		curCallerName := callChain[chainIndex][1]
		curCallerFile := callChain[chainIndex][2]
		curCallerStack := callChain[chainIndex][3]

		; start from root
		if (chainIndex == 1) {
			; root caller, create or continue depends on whether root node exists
			if (!this.root) {
				this.addChildren(
					debugger.value["caller"]["name"], 
					{ file: curCallerFile, stack: curCallerStack, debuggers: [] }
				)
			}
			this.addDebugger(debugger, chainIndex + 1, this.root)
		}
		; in the middle of call chain
		else if (curCallerName !== "Object.Call") {
			targetNode := this.getNode(curCallerName)
			if (!targetNode) {
				targetNode := this.addChildren(
					curCallerName, 
					{ file: curCallerFile, stack: curCallerStack, debuggers: [] },
					prevNodeReached.name
				)
			}
			this.addDebugger(debugger, chainIndex + 1, targetNode)
		}
		; at the end of the chain, push debugger to node's debuggers array
		; caller is now Object.Call
		else {
			prevNodeReached.content.debuggers.Push(debugger)
		}
	}
}

CALL_TREE := CallTree()