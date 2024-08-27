class Component {
    __New(gui, name) {
        this.gui := gui
        this.name := name
    }
    
    Add(arcs*) {
        for arc in arcs {
            arc.groupName := "$$" . this.name
        }
        
        this.arcs := this.getComponentByName(gui, "$$" . this.name)
        this.ctrls := this.arcs.map(arc => arc.ctrl)
    }

    visible(bool) {
        for ctrl in this.ctrls {
            ctrl.visible := bool
        }
    }

    getComponentByName(gui, name) {
        componentArcs := []
        for arc in gui.arcs {
            if (arc.groupName = name)
                componentArcs.Push(arc)
        }
        return componentArcs
    }
}