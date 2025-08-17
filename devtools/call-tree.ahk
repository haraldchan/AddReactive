class CallNode {
	/**
	 * Creates a CallNode.
	 * @param {Object} nodeContent 
	 */
	__New(nodeContent) {
		this.parent := ""
		this.childrens := []
		this.content := nodeContent
		this.content.debuggers := []

		; nodeContent: debugger.caller
		this.name := nodeContent.name
		this.file := nodeContent.file
		this.stack := nodeContent.stack
		this.callChainMap := nodeContent.callChainMap
	}
}


class CallTree {
	__New() {
		this.root := ""
	}


	/**
	 * Gets a node by using name and file as search keys.
	 * @param {String} name 
	 * @param {String} file 
	 * @param {CallNode} curNode 
	 * @returns {false|CallNode}
	 */
	getNode(name, file, curNode := this.root) {
		if (name == curNode.name && file == curNode.file) {
			return curNode
		}

		if (curNode.childrens.Length > 0) {
			for childNode in curNode.childrens {
				res := this.getNode(name, file, childNode)
				if (res) {
					return res
				}
			}
		}

		return false
	}


	/**
	 * Appends children node to a node by using name and file as search keys.
	 * @param {Object} content 
	 * @param {String} parentName 
	 * @param {String} parentFile 
	 * @returns {false|CallNode}
	 */
	addChildren(content := 0, parentName := "root", parentFile := 0) {
		newNode := CallNode(content)

		if (!this.root) {
			this.root := newNode
			return newNode
		}

		if (!parentFile && this.root) {
			this.root.childrens.Push(newNode)
			newNode.parent := this.root
			return newNode
		}

		parentNode := this.getNode(parentName, parentFile)
		if (!parentNode) {
			return false
		}

		newNode.parent := parentNode
		parentNode.childrens.Push(newNode)
	}


	/**
	 * Adds debugger to a caller node. Also creates caller nodes on the first traverse.
	 * @param {debugger} debugger 
	 * @param {Number} chainIndex 
	 * @param {CallNode} prevNodeReached 
	 */
	addDebugger(debugger, chainIndex := 1, prevNodeReached := 0) {
		callChain := debugger.value["caller"]["callChainMap"].entries()
		if (chainIndex > callChain.Length) {
			return
		}

		unpack([&curCallerName, &curCallerFile], callChain[chainIndex])
		msgbox curCallerFile, curCallerName

		; start from root
		if (chainIndex == 1) {
			; root caller, create or continue depends on whether root node exists
			if (!this.root) {
				this.addChildren(debugger["caller"])
			}
			this.addDebugger(debugger, chainIndex + 1, this.root)
		}
		; in the middle of call chain
		else if (curCallerName !== "Object.Call") {
			targetNode := this.getNode(curCallerName, curCallerFile)
			if (!targetNode) {
				targetNode := this.addChildren(debugger["caller"], prevNodeReached.name, prevNodeReached.file)
			}
			this.addDebugger(debugger, chainIndex + 1, targetNode)
		}
		; at the end of the chain, push debugger to node's debuggers array
		; caller is now Object.Call
		else {
			endCallerNode := this.getNode(prevNodeReached.name, prevNodeReached.file)
			endCallerNode.content.debuggers.Push(debugger)
		}
	}
}


CALL_TREE := CallTree()