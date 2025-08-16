class CallNode {
	__New(nodeContent) {
		this.parent := ""
		this.childrens := []
		this.debuggers := []

		; nodeContent: debugger.caller
		this.name := nodeContent.name
		this.stackString := nodeContent.stackString
	}
}


class CallTree {
	__New() {
		this.root := CallNode({
			name: "Index File",
			stackString: "",
		})
	}

	getNode(stackString, curNode := this.root) {
		if (stackString == curNode.stackString) {
			return curNode
		}

		if (curNode.childrens.Length > 0) {
			for childNode in curNode.childrens {
				res := this.getNode(stackString, childNode)
				if (res) {
					return res
				}
			}
		}

		return false
	}

	addNode(content := 0, parentStackString := 0, debugger := 0) {
		newNode := CallNode(content)

		if (!parentStackString && this.root) {
			this.root.childrens.Push(newNode)
			newNode.parent := this.root
			return newNode
		}

		parentNode := this.getNode(parentStackString)
		if (!parentNode) {
			return false
		}

		newNode.parent := parentNode
		parentNode.childrens.Push(newNode)
	}

	/**
	 * should be call on creating debugger, 
	 * @param {debugger} debugger 
	 */
	addDebugger(debugger, chainIndex := 1) {
		/**
		 * ideal addNode should be:
		 * 1. use callChain as a ref, from the most top-layer caller
		 * 2. [index] -> [top comp] -> [parent comp] -> [comp]
		 *    lookup index, for:
		 * 		- top comp exists
		 * 		- look for parent comp in childrens of top comp
		 * 		- parent comp exists
		 * 		- look for comp in childrens of parent comp
		 * 		- ...
		 * 		end-1: if comp exists, only push signal.debugger to its debuggers array
		 * 		end-2: else, call add node or nodes to the intersect caller node
		 */
		callChainMap := debugger.value["caller"]["callChainMap"]

		if (chainIndex > callChainMap.Capacity) {
			return
		}

		unpack([&curCallerName, &curCallerStackString], callChainMap[chainIndex].entries()[chainIndex])

		callerNode := this.getNode(curCallerStackString)
		; reaches the end of caller node, add debugger
		if (callerNode && chainIndex == callChainMap.Capacity) {
			callerNode.content.debuggers.Push(debugger)
			return
		}
		; in the middle of the chain, but curCaller not fount, still need to add nodes, then go deeper
		else if (!callerNode && chainIndex < callChainMap.Capacity) {
			this.addNode({ name: curCallerName, stackString: curCallerStackString }, callerNode.stackString)
			this.addDebugger(debugger, chainIndex + 1)
		}
		; node found, but in the middle of the chain, just go deeper
		else {
			this.addDebugger(debugger, chainIndex + 1)
		}
	}
}

ct := CallTree()