#Include "./AddReactive.ahk"

test := Gui(, "test of class component")
testApp(test)
test.Show()

testApp(App) {
    isShow := signal(true)
    effect(isShow, show => Counters.visible(show))

    return (
        Counters(App),
        App.AddButton("w200 h35", "click to hide")
        .OnEvent("Click", (*) => isShow.set(s => !s))
    )
}

class Counters extends Component {
    __New(App) {
        super.__New(App, "counters")
        this.render(App)
    }

    render(App) {
        count := signal(0)
        doubled := computed(count, c => c * 2)

        increase := Map("Click", (*) => count.set(c => c + 1))

        return super.Add(
            App.AddReactiveText("w200 h35", "count is {1}", count,, increase),
            App.AddReactiveText("w200 h35", "doubled is {1}", doubled)
        )
    }
}