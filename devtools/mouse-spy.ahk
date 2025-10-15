#SingleInstance Force
#Include "../useAddReactive.ahk"

MouseSpyGui := Gui("+AlwaysOnTop", "MouseSpy")
MouseSpy(MouseSpyGui)
MouseSpyGui.Show()

MouseSpy(App) {
    mousePos := signal(getMousePos())
    SetTimer(() => mousePos.set(getMousePos()), 200)

    anchorPos := signal({ screen: { x: 0, y: 0 }, client: { x: 0, y: 0 } })
    distance := computed(
        [mousePos, anchorPos], 
        (curMP, curAP) => { 
            x: curMP["screen"]["x"] - curAP["screen"]["x"], 
            y: curMP["screen"]["y"] - curAP["screen"]["y"]
        }
    )

    columnDetails := {
        keys: ["posType", "X", "Y"],
        width: [70, 50, 50]
    }

    options := {
        lvOptions: "Grid -ReadOnly -Multi LV0x4000 w200 r16 x20 y+10",
    }


    onMount() {
        HotIfWinExist("MouseSpy")
        Hotkey "^s", (*) => anchorPos.set(getMousePos())
    }


    return (
        ; current Mouse Pos
        App.AddText("x10 w200 h20", "Mouse Position:").SetFont("s10.5 bold"),
        App.ARText("x10 y+10 w200 h20", "Screen:  {1}, {2}", mousePos, [v => v["screen"]["x"], v => v["screen"]["y"]]),
        App.ARText("x10 w200 h20", "Client:     {1}, {2}", mousePos, [v => v["client"]["x"], v => v["client"]["y"]]),

        ; save anchor
        App.AddText("x10 y+20 w200 h20", "Anchored Position(Mouse)").SetFont("s10.5 bold"),
        App.ARText("x10 y+10 w200 h20", "Screen:  {1}, {2}", anchorPos, [v => v["screen"]["x"], v => v["screen"]["y"]]),
        App.ARText("x10 w200 h20", "Client:     {1}, {2}", anchorPos, [v => v["client"]["x"], v => v["client"]["y"]]),

        ; TODO: add anchor using ImageSearch
        App.AddText("x10 y+20 w200 h20", "Anchored Position(Image)").SetFont("s10.5 bold"),
        

        ; relative distance
        App.AddText("x10 y+20 w200 h20", "Relative Distance").SetFont("s10.5 bold"),
        App.ARText("x10 y+10 w200 h20", "distance: {1}, {2}", distance, ["x", "y"]),
        


        onMount()
    )
}

getMousePos() {
    CoordMode "Mouse", "Screen"
    MouseGetPos(&initScreenX, &initScreenY)
    CoordMode "Mouse", "Client"
    MouseGetPos(&initClientX, &initClientY)

    return {
        screen: { x: Integer(initScreenX), y: Integer(initScreenY) },
        client: { x: Integer(initClientX), y: Integer(initClientY) }
    }
}

