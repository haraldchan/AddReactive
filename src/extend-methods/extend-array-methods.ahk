defineArrayMethods(arr) {

    arr.Prototype.some := some
    some(arr, fn) {
        for item in arr {
            if (fn(item)) {
                return true
            }
        }
        return false
    }

    arr.Prototype.every := every
    every(arr, fn) {
        for item in arr {
            if (!fn(item))
                return false
        }
        return true
    }

    arr.Prototype.filter := filter
    filter(arr, fn) {
        newArray := []

        for item in arr {
            if (fn(item)) {
                newArray.Push(item)
            }
        }
        return newArray
    }

    arr.Prototype.find := find
    find(arr, fn) {
        for item in arr {
            if (fn(item)) {
                return item
            }
        }

        return ""
    }

    arr.Prototype.findIndex := findIndex
    findIndex(arr, fn) {
        for item in arr {
            if (fn(item)) {
                return A_Index
            }
        }
    }

    arr.Prototype.map := map
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

    arr.Prototype.reduce := reduce
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

    arr.Prototype.with := with
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

    arr.Prototype.append := append
    append(arr, val) {
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

    arr.Prototype.unshift := unshift
    unshift(arr, val) {
        newArray := [arr*]

        if (val is Array) {

            for item in val.toReversed() {
                newArray.InsertAt(1, item)
            }
        } else {
            newArray.InsertAt(1, val)
        }
        return newArray
    }

    arr.Prototype.toReversed := toReversed
    toReversed(arr) {
        newArray := []
        index := arr.Length

        loop arr.Length {
            newArray.Push(arr[index])
            index--
        }

        return newArray
    }

    arr.Prototype.unique := unique
    unique(arr) {
        newArray := arr

        loop newArray.Length {
            curItem := newArray[1]
            newArray := newArray.filter(item => item != curItem)
            newArray.Push(curItem)
        }

        return newArray
    }

    arr.Prototype.flat := flat
    flat(arr) {
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

    arr.Prototype.join := join
    join(arr, separator := ",") {
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

    arr.Prototype.slice := slice
    slice(arr, start := 1, end := arr.Length + 1) {
        newArray := []

        if (start < 1 || start > arr.length || end < 1 || end > arr.length + 1) {
            return false
        }

        ptr := start
        loop (end == arr.Length + 1 ? arr.Length + 1 : end) - start {
            newArray.Push(arr[ptr])
            ptr++
        }

        return newArray
    }

    arr.Prototype.sort := _sort
    _merge(arr1, arr2) {
        mergedList := []
        i := 1, j := 1

        while (i < arr1.Length+1 && j < arr2.Length+1) {
            if (arr1[i] < arr2[j]) {
                mergedList.Push(arr1[i])
                i++
            } else {
                mergedList.Push(arr2[j])
                j++
            }
        }

        while (i < arr1.Length+1) {
            mergedList.Push(arr1[i])
            i++
        }

        while (j < arr2.Length+1) {
            mergedList.Push(arr2[j])
            j++
        }
        return mergedList
    }
    _sort(arr) {
        if (arr.Length == 1) {
            return arr
        }

        mid := Integer(arr.Length / 2 + 1)
        left := arr.slice(, mid)
        right := arr.slice(mid)

        return _merge(_sort(left), _sort(right))
    }
}

defineArrayMethods(Array)
