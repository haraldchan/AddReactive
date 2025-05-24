destruct(refs, resolver) {
    checkType(refs, [Array, Object.Prototype, Map])
    checkType(resolver, [Array, Object.Prototypr, Map])
    
    if (refs is Array) {
        if (refs.Length > resolver) {
            throw IndexError("Index out of range.")
        }

        
    }
}