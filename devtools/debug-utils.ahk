#Include "../useAddReactive.ahk"

class debugger extends signal {
	notifyChange() {
		if (ARConfig.useDevtoolsUI) {
			CALL_TREE.updateTimeStamp.set(A_Now . A_MSec)
		}
	}
}

class DebugUtils {
	static getCallerFromStack(stack) {
		l := ") : ["
		r := "]"

		callerName := pipe(
			s => StrSplit(s, l)[2],
			s => !StringExt.startsWith(s, "[") && StrSplit(s, r)[1]
		)(stack) 

		callerFile := StrSplit(stack, ".ahk")[1] . ".ahk"

		return Map(
			"callerName", callerName,
			"callerFile", callerFile
		)
	}

	static getCallerChainAndFilename(callStacks, signalName) {
		callerChain := []

		startIndex := ArrayExt.findIndex(callStacks, item => InStr(item, "Object.Call"))
		endIndex := ArrayExt.findIndex(callStacks, item => !InStr(item, ") : ["))
		trimmedCallStacks := ArrayExt.slice(callStacks, startIndex + 1, endIndex)

		; SetTimer((*) => msgbox(JSON.stringify(callStacks), signalName), -1)

		for stack in trimmedCallStacks {
			caller := DebugUtils.getCallerFromStack(stack)
			if (!caller["callerName"]) {
				continue
			}

			callerChain.InsertAt(1, caller)
		}

		fromFile := StrSplit(callStacks[startIndex], ".ahk")[1] . ".ahk"

		return [callerChain, fromFile]
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

			; SetTimer((*) => msgbox(JSON.stringify(stacks)), -1)
			
			signalName := signal.name
			signalType := match(stacks[2], Map(
				s => InStr(s, "[signal.Prototype.__New]"), "signal",
				s => InStr(s, "[computed.Prototype.__New]"), "computed",
			))

			unpack([&callerChain, &fromFile], DebugUtils.getCallerChainAndFilename(stacks, signalName))

			debuggerObj := {
				signalInstance: signal,
				signalName: signalName,
				signalType: signalType,
				callerChain: callerChain,
				fromFile: fromFile,
			}

			; msgbox JSON.stringify(debuggerObj)

			return debugger(debuggerObj)
		}
	}
}