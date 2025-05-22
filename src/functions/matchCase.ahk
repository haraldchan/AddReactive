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