class SignalTracker {
	static trackings := Map()
}

class Debugger extends signal {

}

getCallerNameFromStack(stack) {
	callerSplitted := []
	isCollecting := false
	for char in StrSplit(StrSplit(stack, ".ahk")[2], "") {
		if (isCollecting && char == "]") {
			return ArrayExt.join(callerSplitted, "")
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
}