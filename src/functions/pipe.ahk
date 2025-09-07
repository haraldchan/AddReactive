/**
 * 
 * @param {Func[]} fns 
 * @returns {Any}
 */
pipe(fns*) {
    f(input) {
        res := input

        for fn in fns {
            res := fn(res)
        }

        return res
    }

    return f
}