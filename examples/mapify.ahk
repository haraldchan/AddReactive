#SingleInstance Force
#Include "../useAddReactive.ahk"

obj := {
    name: "johnson",
    age: 99,
    contact: {
        tel: {
            mobile: 1339999583,
            home: 00009999
        },
        email: "233@gmail.com"
    },
    hobbies: [ "coding", "driving", { sports: ["tennis", "swimming"] } ],
    family: Map(
        "father", "jones",
        "mother", "jane",
        "grandparents", Map(
            "grandfather", "johaness",
        )
    )
}

mapify(obj) {
    if (!isPlainObject(obj) || !(obj is Array) || !(obj is Map)) {
        return
    }

    if (isPlainObject(obj) || obj is Map) {
        res := Map()
        for key, value in (obj is Map ? obj : obj.OwnProps()) {
            if (isPlainObject(value) || value is Array || value is Map) {
                res[key] := mapify(value)
            }

            res[key] := value
        }

        return res
    }

    if (obj is Array) {
        res := []
        for item in obj {
            if (isPlainObject(item) || item is Map) {
                res.Push(mapify(item))
            }

            res.Push(item)
        }

        return res
    }
}

mapped := mapify(obj)