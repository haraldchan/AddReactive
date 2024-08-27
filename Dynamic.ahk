colorGui := Gui(, "Dynamic Rendering")
colorApp(colorGui)
colorGui.Show()

colorApp(App) {
    color := signal("red")

    redName := "red!"
    blueName := "blue!"
    greenName := "green!"

    components := Map(
        "red", [Red, App, redName],
        "blue", [Blue, App, blueName],
        "green", [Green, App, greenName]
    )

    return (
        components.keys.map((clr, index) =>
            App.AddRadio((index = 1 ? "Checked " : " " . "w100 h25", "select " . clr))
               .OnEvent("Click", (*) => color.set(clr))
        ),
        Dynamic(color, components)
    )
}

class Dynamic {
    __New(signal, componentSets) {
        this.signal := signal
        this.componentSets := componentSets

        for val, componentSet in this.componentSets {
            component := componentSet.RemoveAt(1)
            props := componentSet
            component(props)
        }

        this.renderDynamic(this.signal.value)
        effect(this.signal, cur => this.renderDynamic(cur))
    }

    renderDynamic(currentValue) {
        for val, componentSet in this.componentSets {
            if (this.signal.value = val) {
                componentSet.visible(true)
            } else {
                componentSet.visible(false)
            }
        }
    }
}

class Red extends Component {
    __New(App) {
        super.__New(App, "red")
        this.render(App)
    }

    render(App) {
        return super.Add (
            App.AddReactiveText("w200 h25", "this is red")
        )
    }
}

class Blue extends Component {
    __New(App) {
        super.__New(App, "blue")
        this.render(App)
    }

    render(App) {
        return super.Add (
            App.AddReactiveText("w200 h25", "this is blue")
        )
    }
}

class Green extends Component {
    __New(App) {
        super.__New(App, "green")
        this.render(App)
    }

    render(App) {
        return super.Add (
            App.AddReactiveText("w200 h25", "this is green")
        )
    }
}