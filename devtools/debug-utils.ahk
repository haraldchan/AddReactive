class debugger extends signal {

}

class DebugUtils {
	/**
	 * Gets the caller name from stack string.
	 * @param {String} stackString 
	 * @returns {false|String}
	 */
	static getCallerNameFromStack(stackString) {
		callerSplitted := []
		isCollecting := false
		for char in StrSplit(StrSplit(stackString, ".ahk")[2], "") {
			if (isCollecting && char == "]") {
				return callerSplitted.Length == 0 ? "root" : ArrayExt.join(callerSplitted, "")
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
	 * Gets the caller full file name from stack string.
	 * @param {String} stackString 
	 * @returns {String}
	 */
	static getCallerFileFromStack(stackString) {
		return StrSplit(stackString, ".ahk")[1] . ".ahk"
	}


	/**
	 * Creates a debugger.
	 * @param {signal} signal
	 * @returns {debugger}
	 */
	static createDebugger(signal) {
		try {
			throw Error()
		} catch Error as err {
			stacks := StrSplit(err.Stack, "`r`n")
			stacks.RemoveAt(stacks.Length - 1)

			varLineIndex := ArrayExt.findIndex(stacks, line => line && InStr(line, "[Object.Call]"))
			endIndex := ArrayExt.findIndex(stacks, item => item == "")

			; signal var name
			varLine := StrSplit(stacks[varLineIndex], "[Object.Call]")[2]
			varName := Trim(StrSplit(varLine, ":=")[1])

			; type: signal | computed
			classType := StrSplit(err.What, ".")[1]

			; caller: caller name(direct caller), stack, call chain(full stack)
			callerName := DebugUtils.getCallerNameFromStack(stacks[varLineIndex + 1])
			callerStack := stacks[varLineIndex + 2]

			
			callerChainMap := OrderedMap()
			for stackString in ArrayExt.reverse(ArrayExt.slice(stacks, varLineIndex, endIndex)) {
				callerChainMap[DebugUtils.getCallerNameFromStack(stackString)] := DebugUtils.getCallerFileFromStack(stackstring)	
			}

			return debugger({
				signal: signal,
				varName: varName,
				class: classType,
				value: signal.value,
				stacks: stacks,
				caller: {
					name: callerName,
					stack: callerStack,
					file: DebugUtils.getCallerFileFromStack(callerStack),
					callChainMap: callerChainMap
				}
			})
		}
	}
}