class CallNode {
	/**
	 * Creates a CallNode.
	 * @param {Object} nodeContent 
	 */
	__New(nodeName, content) {
		this.parent := ""
		this.children := []

		this.name := nodeName
		this.content := content
	}
}


class CallTree {
	__New() {
		this.root := ""
		this.stores := ""
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

		if (curNode.children.Length > 0) {
			for childNode in curNode.children {
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
	addChild(name, content, parentName := "") {
		newNode := CallNode(name, content)

		if (!this.root) {
			this.root := newNode
			return newNode
		}

		if (!parentName && this.root) {
			this.root.children.Push(newNode)
			newNode.parent := this.root
			return newNode
		}

		parentNode := this.getNode(parentName)
		if (!parentNode) {
			return false
		}

		newNode.parent := parentNode
		parentNode.children.Push(newNode)

		return newNode
	}


	/**
	 * Adds debugger to a caller node. Also creates caller nodes on the first traverse.
	 * @param {debugger} debugger 
	 * @param {Number} chainIndex 
	 * @param {CallNode} prevNodeReached 
	 */
	addDebugger(debugger, chainIndex := 1, prevNodeReached := "start") {
		if (InStr(debugger.value["fromFile"], "AddReactive\devtools\devtools-ui")) {
			return
		}

		if (chainIndex == 1) {
			; root caller, create or continue depends on whether root node exists
			parentNode := ""

			if (!this.root) {
				parentNode := this.addChild(
					debugger.value["callerChain"][1]["callerName"], 
					{ 
						file: debugger.value["callerChain"][1]["callerFile"], 
						debuggers: [] 
					}
				)
			} 
			else if (this.root.name != debugger.value["callerChain"][1]["callerName"] && !this.root.children.find(node => node.name == debugger.value["callerChain"][1]["callerName"])) {
				parentNode := this.addChild(
					debugger.value["callerChain"][1]["callerName"],
					{
						file: debugger.value["callerChain"][1]["callerFile"], 
						debuggers: [] 						
					}
				)
			}

			this.addDebugger(debugger, chainIndex + 1, parentNode)
		}
		; in the middle of call chain
		else if (chainIndex <= debugger.value["callerChain"].Length) {
			targetNode := this.getNode(debugger.value["callerChain"][chainIndex]["callerName"])
			if (!targetNode) {
				targetNode := this.addChild(
					debugger.value["callerChain"][chainIndex]["callerName"], 
					{ 
						file: debugger.value["callerChain"][chainIndex]["callerFile"], 
						stack: "curCallerStack", 
						debuggers: [] 
					},
					prevNodeReached.name
				)
			}
			this.addDebugger(debugger, chainIndex + 1, targetNode)
		}
		; at the end of the chain, push debugger to node's debuggers array
		else {
			prevNodeReached.content.debuggers.Push(debugger)
		}
	}
}