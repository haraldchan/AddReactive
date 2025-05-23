/**
 * Evaluates a value against a lookup dataset (Object or Map) and returns the corresponding result.
 * If the matched result is a function, it is called and its return value is returned.
 * Supports an optional default fallback when no match is found.
 *
 * @param {any} value - The key or value to match against the dataset.
 * @param {Object|Map} dataset - A plain object or Map containing keys and associated values or functions.
 * @param {any} [default] - Optional fallback value or function if no match is found.
 * @returns {any} - The matched value or the result of the matched function; or the default/fallback if no match is found.
 * @throws {UnsetError} - Throws if no match is found and no default is provided.
 */
matchCase(value, dataset, default := false) {
	if (dataset.Base == Object.Prototype) {
		datasetType := "object"
	} else if (dataset is Map) {
		datasetType := "map"
		,default && dataset.Default := default
	}

	if (datasetType == "object") {
		if dataset.hasOwnProp(value) {
			res := dataset.%value%
		} else if (default) {
			res := default
		} else { 
			throw UnsetError("Unknown Property", -1, value)
		}
	} else if (datasetType == "map") {
		res := dataset[value]
	}

	return res is Func ? res.Call() : res
}