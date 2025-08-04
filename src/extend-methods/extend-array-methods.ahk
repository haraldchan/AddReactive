class ArrayExt {
    static patch() {
        if (!ARConfig.useExtendMethods) {
            return
        }

        for method, enabled in ARConfig.enableExtendMethods.array.OwnProps() {
            if (method == "sort" && enabled) {
                Array.Prototype._merge := ObjBindMethod(this, "_merge")
            }

            if (enabled) {
                Array.Prototype.%method% := ObjBindMethod(this, method)
            }
        }
    }

    static some(arr, fn) {
        for item in arr {
            if (fn(item)) {
                return true
            }
        }
        return false
    }

    static every(arr, fn) {
        for item in arr {
            if (!fn(item))
                return false
        }
        return true
    }

    static filter(arr, fn) {
        newArray := []

        for item in arr {
            if (fn(item)) {
                newArray.Push(item)
            }
        }
        return newArray
    }

    static find(arr, fn) {
        for item in arr {
            if (fn(item)) {
                return item
            }
        }

        return ""
    }

    static findIndex(arr, fn) {
        for item in arr {
            if (fn(item)) {
                return A_Index
            }
        }
    }

    static at(arr, index) {
        if (Abs(index) > arr.Length || index == 0) {
            throw ValueError("Index out of range.")
        }

        if (index > 0) {
            return arr[index]
        }

        if (index < 0) {
            return arr[arr.Length + 1 + index]
        }
    }

    static map(arr, fn) {
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

    static reduce(arr, fn, initialValue) {
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

    static with(arr, index, newValue) {
        if (Abs(index) > arr.Length || index == 0) {
            throw ValueError("Index out of range")
        }

        newArray := [arr*]
        if (index < 0) {
            newArray[arr.Length + 1 + index] := newValue
        } else {
            newArray[index] := newValue
        }

        return newArray
    }

    static append(arr, val) {
        newArray := [arr*]

        if (val is Array) {
            for item in val {
                newArray.Push(item)
            }
        } else {
            newArray.Push(val)
        }
        return newArray
    }

    static unshift(arr, val) {
        newArray := [arr*]

        if (val is Array) {
            for item in val.reverse() {
                newArray.InsertAt(1, item)
            }
        } else {
            newArray.InsertAt(1, val)
        }
        return newArray
    }

    static reverse(arr) {
        newArray := []
        index := arr.Length

        loop arr.Length {
            newArray.Push(arr[index])
            index--
        }

        return newArray
    }

    static unique(arr) {
        newArray := arr

        loop newArray.Length {
            curItem := newArray[1]
            newArray := newArray.filter(item => item != curItem)
            newArray.Push(curItem)
        }

        return newArray
    }

    static flat(arr) {
        newArray := []

        flatInner(arr) {
            for item in arr {
                if (item is Array) {
                    flatInner(item)
                } else {
                    newArray.Push(item)
                }
            }
        }

        flatInner(arr)

        return newArray
    }

    static join(arr, separator := ",") {
        joined := ""

        for item in arr {
            if (A_Index = arr.Length) {
                joined .= item
            } else {
                joined .= item . separator
            }

        }

        return joined
    }

    static slice(arr, start := 1, end := arr.Length + 1) {
        newArray := []

        if (start < 1 || start > arr.length || end < 1 || end > arr.length + 1) {
            return false
        }

        index := start
        loop (end == arr.Length + 1 ? arr.Length + 1 : end) - start {
            newArray.Push(arr[index])
            index++
        }

        return newArray
    }

    static _merge(arr1, arr2, compareFn) {
        mergedList := []

        while (arr1.Length && arr2.Length) {
            mergedList.Push(
                compareFn(arr1[1], arr2[1]) < 0 ? arr1.RemoveAt(1) : arr2.RemoveAt(1)
            )
        }

        (arr1.Length && mergedList.Push(arr1*))
        (arr2.Length && mergedList.Push(arr2*))

        return mergedList
    }
    static sort(arr, compareFn := default(a, b) => a - b) {
        if (arr.Length == 1) {
            return arr
        }

        mid := Integer(arr.Length / 2 + 1)
        left := this.slice(arr, , mid)
        right := this.slice(arr, mid)

        return this._merge(this.sort(left, compareFn), this.sort(right, compareFn), compareFn)
    }
}