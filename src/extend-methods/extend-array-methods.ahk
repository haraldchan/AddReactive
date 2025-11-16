/**
 * ArrayExt provides extended array manipulation methods similar to JavaScript Array methods.
 */
class ArrayExt {
    /**
     * Patches Array prototype with enabled methods from ARConfig.
     */
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

    /**
     * Returns true if at least one element in the array passes the test implemented by the provided function.
     * @param {Array} arr - The array to test.
     * @param {Function} fn - The test function.
     * @returns {Boolean}
     */
    static some(arr, fn) {
        for item in arr {
            if (fn(item)) {
                return true
            }
        }
        return false
    }

    /**
     * Returns true if the array contains a certain element, starting the search at fromIndex.
     * @param {Array} arr - The array to search.
     * @param {Any} val - The value to search for.
     * @param {Integer} [fromIndex=1] - The index to start the search from.
     * @returns {Boolean}
     */
    static includes(arr, val, fromIndex := 1) {
        for item in arr {
            if (A_Index < fromIndex) {
                continue
            }
            
            if (item = val) {
                return true
            }
        }
        return false
    }

    /**
     * Returns true if all elements in the array pass the test implemented by the provided function.
     * @param {Array} arr - The array to test.
     * @param {Function} fn - The test function.
     * @returns {Boolean}
     */
    static every(arr, fn) {
        for item in arr {
            if (!fn(item))
                return false
        }
        return true
    }

    /**
     * Creates a new array with all elements that pass the test implemented by the provided function.
     * @param {Array} arr - The array to filter.
     * @param {Function} fn - The test function.
     * @returns {Array}
     */
    static filter(arr, fn) {
        newArray := []

        for item in arr {
            if (fn(item)) {
                newArray.Push(item)
            }
        }
        return newArray
    }

    /**
     * Returns the value of the first element in the array that satisfies the provided testing function.
     * @param {Array} arr - The array to search.
     * @param {Function} fn - The test function.
     * @returns {Any|false} - The found element or false if none found.
     */
    static find(arr, fn) {
        for item in arr {
            if (fn(item)) {
                return item
            }
        }

        return false
    }

    /**
     * Returns the value of the last element in the array that satisfies the provided testing function.
     * @param {Array} arr  The array to search.
     * @param {Function} fn - The test function.
     * @returns {Any|false} - The found element or false if none found.
     */
    static findLast(arr, fn) {
        index := arr.Length

        loop {
            if (fn(arr[index])) {
                return arr[index]
            }

            index--
        } until (index == 0)
    
        return false
    }

    /**
     * Returns the index of the first element in the array that satisfies the provided testing function.
     * @param {Array} arr - The array to search.
     * @param {Function} fn - The test function.
     * @returns {Integer|false} - The index of the found element or false if none found.
     */
    static findIndex(arr, fn) {
        for item in arr {
            if (fn(item)) {
                return A_Index
            }
        }

        return false
    }

    /**
     * Returns the index of the last element in the array that satisfies the provided testing function.
     * @param {Array} arr - The array to search.
     * @param {Function} fn - The test function.
     * @returns {Integer|false} - The index of the found element or false if none found.
     */
    static findLastIndex(arr, fn) {
        index := arr.Length
        
        loop {
            if (fn(arr[index])) {
                return index
            }

            index--
        } until (index == 0)

        return false
    }

    /**
     * Returns the element at the given index. Supports negative indexing.
     * @param {Array} arr - The array.
     * @param {Integer} index - The index (can be negative).
     * @returns {Any}
     * @throws {ValueError} If index is out of range.   
     */
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

    /**
     * Creates a new array with the results of calling a provided function on every element.
     * @param {Array} arr  - The array to map.
     * @param {Function} fn - The mapping function.
     * @returns {Array}
     */
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

    /**
     * Applies a function against an accumulator and each element to reduce it to a single value.
     * @param {Array} arr - The array to reduce.
     * @param {Function} fn - The reducer function.
     * @param {Any} initialValue - Initial value for the accumulator.
     * @returns {Any}
     */
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

    /**
     * Returns a new array with the element at the given index replaced with newValue.
     * @param {Array} arr - The array.
     * @param {Integer} index - The index to replace.
     * @param {Any} newValue - The new value.
     * @returns {Array}
     */
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

    /**
     * Returns a new array with val appended. If val is an array, appends all its elements.
     * @param {Array} arr - The array.
     * @param {Any} val - Value or array to append.
     * @returns {Array}
     */
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

    /**
     * Returns a new array with val inserted at the start. If val is an array, inserts all its elements.
     * @param {Array} arr - The array.
     * @param {Any} val - Value or array to insert.
     * @returns {Array}
     */
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

    /**
     * Returns a new array with the elements reversed.
     * @param {Array} arr - The array to reverse.
     * @returns {Array}
     */
    static reverse(arr) {
        newArray := []
        index := arr.Length

        loop arr.Length {
            newArray.Push(arr[index])
            index--
        }

        return newArray
    }

    /**
     * Returns a new array with only unique elements.
     * @param {Array} arr - The array to filter.
     * @returns {Array}
     */
    static unique(arr) {
        newArray := arr

        loop newArray.Length {
            curItem := newArray[1]
            newArray := newArray.filter(item => item != curItem)
            newArray.Push(curItem)
        }

        return newArray
    }

    /**
     * Returns a new array with all sub-array elements concatenated into it recursively.
     * @param {Array} arr - The array to flatten.
     * @returns {Array}
     */
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

    /**
     * Joins all elements of the array into a string separated by separator.
     * @param {Array} arr - The array to join.
     * @param {String} [separator=','] - Separator string.
     * @returns {String}
     */
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

    /**
     * Returns a shallow copy of a portion of an array into a new array object.
     * Includes start, excludes end.
     * @param {Array} arr - The array to slice.
     * @param {Integer} start - Start index (inclusive).
     * @param {Integer} [end] - End index (exclusive).
     * @returns {Array}
     */
    static slice(arr, start, end := arr.Length + 1) {
        newArray := []

        loop {
            if (A_Index < start) {
                continue
            }

            newArray.Push(arr[A_Index])

        } until A_Index == end - 1

        return newArray
    }

    /**
     * Merges two sorted arrays into one sorted array using compareFn.
     * @param {Array} arr1 - First sorted array.
     * @param {Array} arr2 - Second sorted array.
     * @param {Function} compareFn - Comparison function.
     * @returns {Array}
     */
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
    /**
     * Sorts the array using merge sort and compareFn.
     * @param {Array} arr - The array to sort.
     * @param {Function} [compareFn] - Comparison function.
     * @returns {Array}
     */
    static sort(arr, compareFn := default(a, b) => a - b) {
        if (arr.Length == 1) {
            return arr
        }

        mid := Integer(arr.Length / 2 + 1)
        left := this.slice(arr, 1, mid)
        right := this.slice(arr, mid)

        return this._merge(this.sort(left, compareFn), this.sort(right, compareFn), compareFn)
    }
}