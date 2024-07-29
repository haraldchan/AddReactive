defineArrayMethods(arr) {
    arr.Prototype.some := some
    arr.Prototype.every := every
    arr.Prototype.filter := filter
    arr.Prototype.filter := find
    arr.Prototype.map := map
    arr.Prototype.reduce := reduce
    arr.Prototype.with := with
    arr.Prototype.concat := concat
    arr.Prototype.unshift := unshift
    arr.Prototype.toReversed := toReversed
    arr.Prototype.unique := unique
    arr.Prototype.find := find

    some(arr, fn) {
        for item in arr {
            if (fn(item)) {
                return true
            }
        }
        return false
    }

    every(arr, fn) {
        for item in arr {
            if (!fn(item))
                return false
        }
        return true
    }

    filter(arr, fn) {
        newArray := []

        for item in arr {
            if (fn(item)) {
                newArray.Push(item)
            }
        }
        return newArray
    }

    find(arr, fn){
        for item in arr {
            if (fn(item)) {
                return item
            }
        }   
    }

    map(arr, fn) {
        newArray := []

        if (fn.MaxParams = 1) {
            for item in arr {
                newArray.Push(fn(item))
            }
        } else if (fn.MaxParams = 2) {
            for item in arr {
                newArray.Push(fn(item, A_Index))
            }
        }

        return newArray
    }

    reduce(arr, fn, initialValue) {
        initIsSet := !(initialValue = 0)
        accumulator := initIsSet ? initialValue : arr[1]
        currentValue := initIsSet ? arr[1] : arr[2]
        loopTimes := initIsSet ? arr.Length : arr.Length - 1
        result := 0

        loop loopTimes {
            if (A_Index = 1) {
                result := fn(accumulator, currentValue)
            } else {
                if (!(initialValue = 0)) {
                    result := fn(result, arr[A_Index])
                } else {
                    result := fn(result, arr[A_Index + 1])
                }
            }
        }
        return result
    }

    with(arr, index, newValue) {
        if (index > arr.Length) {
            throw ValueError("Index out of range")
        }

        newArray := []
        for item in arr {
            newArray.Push(item)
        }
        newArray[index] := newValue
        return newArray
    }

    concat(arr, val) {
        newArray := arr

        if (val is Array) {
            for item in val {
                newArray.Push(item)
            }
        } else {
            newArray.Push(val)
        }
        return newArray
    }

    unshift(arr, val) {
        newArray := arr

        if (val is Array) {

            for item in val.toReversed() {
                newArray.InsertAt(1, item)
            }
        } else {
            newArray.InsertAt(1, val)
        }
        return newArray
    }

    toReversed(arr) {
        newArray := []
        index := arr.Length

        loop arr.Length {
            newArray.Push(arr[index])
            index--
        }

        return newArray
    }

    unique(arr){
        newArray := arr

        loop newArray.Length {
            curItem := newArray[1]
            newArray := newArray.filter(item => item != curItem)
            newArray.Push(curItem)
        }

        return newArray
    }
}

defineArrayMethods(Array)

; LSP syntax fragments for vscode-autohotkey2-lsp
;#defineArrayMethods.ahk
; /**
;  * Returns true if, in the array, it finds an element for which the provided function returns true; 
;  * otherwise it returns false. It doesn't modify the array.
;  */
; some(callbackFn) => Boolean

; /**
;  * Tests whether all elements in the array pass the test implemented by the provided function.
;  */
; every(callbackFn) => Boolean

; /**
;  * Creates a shallow copy of a portion of a given array, filtered down to just the elements from the given array that pass the test implemented by the provided function.
;  */
; filter(callbackFn) => Array

; /**
;  * Executes a user-supplied "reducer" callback function on each element of the array, in order, passing in the return value from the calculation on the preceding element. The final result of running the reducer across all elements of the array is a single value.
;  * @param callbackFn 
;  * A function to execute for each element in the array. Its return value becomes the value of the accumulator parameter on the next invocation of callbackFn. 
;  * For the last invocation, the return value becomes the return value of reduce(). The function is called with arguments: accumulator, currentValue.
;  * @param accumulator 
;  * The value resulting from the previous call to callbackFn. On the first call, its value is initialValue if the latter is specified; otherwise its value is array[1]
;  * @param currentValue
;  * The index position of currentValue in the array. On the first call, its value is 0 if initialValue is specified, otherwise 1.
;  */
; reduce(callbackFn) => Any

; /**
;  * Creates a new array populated with the results of calling a provided function on every element in the calling array.
;  * @param callbackFn A function to execute for each element in the array. Its return value is added as a single element in the new array. The function is called with arguments: element [, index]
;  * @param element
;  * The current element being processed in the array.
;  * @param index
;  * The index of the current element being processed in the array.
;  */
; map(callbackFn) => Array

; /**
;  * Returns a new array with the element at the given index replaced with the given value.
;  */
; with(index, newValue) => Array

; /**
;  * Adds the specified elements to the end of an array and returns the new concatenated array.
;  * @param element Can be an array or a single value.
;  */
; concat(element) => Array

; /**
;  * Adds the specified elements to the beginning of an array and returns the new concatenated array.
;  * @param element Can be an array or a single value.
;  */
; unshift(element) => Array

; /**
;  * returns a new array with the elements in reversed order.
;  */
; toReversed() => Array