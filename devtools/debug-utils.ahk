class SignalTracker {
	static trackings := Map()
}

class debugger extends signal {

}

class DebugUtils {
	/**
	 * Returns the caller name from stack string.
	 * @param {String} stackString 
	 * @returns {false|String}
	 */
	static getCallerNameFromStack(stackString) {
		callerSplitted := []
		isCollecting := false
		for char in StrSplit(StrSplit(stackString, ".ahk")[2], "") {
			if (isCollecting && char == "]") {
				return callerSplitted == "" ? "Index File" : ArrayExt.join(callerSplitted, "")
			}

			if (char == "[") {
				isCollecting := true
				continue
			}

			if (isCollecting) {
				callerSplitted.Push(char)
			}

			if (!isCollecting) {
				continue
			}
		}

		return false
	}


	/**
	 * Creates a debugger property for SignalTracker to capture.
	 * @param {signal} signal
	 * @returns {debugger}
	 */
	static createDebugInfo(signal) {
		try {
			throw Error()
		} catch Error as err {
			stacks := StrSplit(err.Stack, "`r`n")

			varLineIndex := ArrayExt.findIndex(stacks, line => line && InStr(line, "this.createDebugInfo")) + 1
			endIndex := ArrayExt.findIndex(stacks, item => item == "")

			; signal var name
			varLine := StrSplit(stacks[varLineIndex], "[Object.Call]")[2]
			varName := Trim(StrSplit(varLine, ":=")[1])

			; type: signal | computed
			classType := StrSplit(err.What, ".")[1]

			; caller: caller name(direct caller), stack, call chain(full stack)
			callerName := this.getCallerNameFromStack(stacks[varLineIndex + 1])
			callerStack := stacks[varLineIndex + 2]

			callerChain := OrderedMap()
			for stackString in ArrayExt.reverse(ArrayExt.slice(varLineIndex, endIndex)) {
				callerChain[this.getCallerNameFromStack(stackString)] := stackString
			}

			return debugger({
				varName: varName,
				class: classType,
				value: signal.value,
				caller: {
					name: callerName,
					stackString: callerStack,
					callChainMap: callerChain
				}
			})
		}
	}

}