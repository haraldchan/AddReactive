/**
 * Matches a value against a set of exact cases or condition functions.
 *
 * @param {Any} value           The value to match against.
 * @param {Object|Map} dataset  A set of match cases.
 *                               - If Object: uses property name as case.
 *                               - If Map: keys can be values or condition functions.
 * @param {Any} [default=false] Optional fallback if no match is found.
 *
 * @returns {Any} The result corresponding to the matched case. If the result is a function, it is called.
 *
 * ```
 * match("X", { "A": "One", "B": "Two" }, "Unknown")  ; => "Unknown"
 *
 * match(12, Map(
 *   x => x < 10, "Small",
 *   x => x < 20, "Medium",
 *   x => x >= 20, "Large"
 * ))  ; => "Medium"
 *
 */
match(value, dataset, default := false) {
	res := default

	if (dataset.Base == Object.Prototype) {
		datasetType := "object"
	} else if (dataset is Map) {
		datasetType := "map"
		,default && dataset.Default := default
	}

	if (datasetType == "object") {
		if dataset.hasOwnProp(value) {
			res := dataset.%value%
		} else if (!default) {
			throw UnsetError("Unknown Property", -1, value)
		}
	} else if (datasetType == "map") {
		if (dataset.Has(value)) {
			res := dataset[value]
		} else {
			for condition, returns in dataset {
				if (condition is Func && condition(value)) {
					res := returns
					break
				}
			}
		}
	}

	return res is Func ? res.Call() : res
}