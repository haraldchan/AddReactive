/**
 * Creates a function that pipes a value through a sequence of functions.
 * @template T,U
 * @param {Func[]} fns - A list of functions to apply from left to right.
 * @returns {(input) => Any} A new function that takes an input and passes it through all functions in order.
 *
 * ```
 * add1   := x => x + 1
 * double := x => x * 2
 * pipeline := pipe(add1, double)
 * 
 * result := pipeline(3) ; => 8
 *
 * ; using non-unary functions or arrow functions.
 * result := pipe(
 *   x => StrTitle(x),
 *   x => StrReplace(x, " ", ", "),
 *   x => Format("Greet: {1}", x),
 *   x => x . "!!"
 * )("hello world") ; => "Greet: Hello, World!!"
 * ```
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