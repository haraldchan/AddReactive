class AddReactiveText extends AddReactive {
    /**
     * Add a reactive Text control to Gui
     * @param {Gui} GuiObject The target Gui Object.
     * @param {string} options Options apply to the control, same as Gui.Add.
     * @param {string} content Text or formatted text to hold signal values.
     * @param {signal} [depend] Subscribed signal
     * @param {array} [key] the keys or index of the signal's value
     * @returns {AddReactiveText}     
     */
    __New(GuiObject, options := "", content := "", depend := 0, key := 0) {
        checkType(options, String, "Parameter #1 (options) is not a String")
        checkType(content, [String, Number], "Parameter #2 (content) is not a String")
        checkTypeDepend(depend)

        this.key := key
        super.__New(GuiObject, "Text", options, content, depend, key)
    }
}
class ARText extends AddReactiveText {
    ; alias
}


class AddReactiveEdit extends AddReactive {
    /**
     * Add a reactive Edit control to Gui
     * @param {Gui} GuiObject The target Gui Object.
     * @param {string} options Options apply to the control, same as Gui.Add.
     * @param {string} content Text or formatted text to hold signal values.
     * @param {signal} [depend] Subscribed signal.
     * @param {array} [key] the keys or index of the signal's value.
     * @returns {AddReactiveEdit}     
     */
    __New(GuiObject, options := "", content := "", depend := 0, key := 0) {
        checkType(options, String, "Parameter #1 (options) is not a String")
        checkType(content, [String, Number], "Parameter #2 (content) is not a String")
        checkTypeDepend(depend)

        this.key := key
        super.__New(GuiObject, "Edit", options, content, depend, key)
    }
}
class AREdit extends AddReactiveEdit {
    ; alias
}


class AddReactiveButton extends AddReactive {
    /**
     * Add a reactive Button control to Gui
     * @param {Gui} GuiObject The target Gui Object.
     * @param {string} options Options apply to the control, same as Gui.Add.
     * @param {string} content Text or formatted text to hold signal values.
     * @param {signal} [depend] Subscribed signal
     * @param {array} [key] the keys or index of the signal's value
     * @returns {AddReactiveButton}     
     */
    __New(GuiObject, options := "", content := "", depend := 0, key := 0) {
        checkType(options, String, "Parameter #1 (options) is not a String")
        checkType(content, [String, Number], "Parameter #2 (content) is not a String")
        checkTypeDepend(depend)

        this.key := key
        super.__New(GuiObject, "Button", options, content, depend, key)
    }
}
class ARButton extends AddReactiveButton {
    ; alias
}

class AddReactiveCheckBox extends AddReactive {
    /**
     * Add a reactive CheckBox control to Gui
     * @param {Gui} GuiObject The target Gui Object.
     * @param {string} options Options apply to the control, same as Gui.Add.
     * @param {string} content Text or formatted text to hold signal values.
     * @param {signal} [depend] Subscribed signal
     * @param {array} [key] the keys or index of the signal's value
     * @returns {AddReactiveCheckBox}     
     */
    __New(GuiObject, options := "", content := "", depend := 0, key := 0) {
        checkType(options, String, "Parameter #1 (options) is not a String")
        checkType(content, [String, Number], "Parameter #2 (content) is not a String")
        checkTypeDepend(depend)

        this.key := key
        super.__New(GuiObject, "CheckBox", options, content, depend, key)
    }
}
class ARCheckBox extends AddReactiveCheckBox {
    ; alias
}


class AddReactiveRadio extends AddReactive {
    /**
     * Add a reactive Radio control to Gui
     * @param {Gui} GuiObject The target Gui Object.
     * @param {string} options Options apply to the control, same as Gui.Add.
     * @param {string} content Text or formatted text to hold signal values.
     * @param {signal} [depend] Subscribed signal
     * @param {array} [key] the keys or index of the signal's value
     * @returns {AddReactiveRadio}     
     */
    __New(GuiObject, options := "", content := "", depend := 0, key := 0) {
        checkType(options, String, "Parameter #1 (options) is not a String")
        checkType(content, [String, Number], "Parameter #2 (content) is not a String")
        checkTypeDepend(depend)

        this.key := key
        super.__New(GuiObject, "Radio", options, content, depend, key)
    }
}
class ARRadio extends AddReactiveRadio {
    ; alias
}


class AddReactiveDropDownList extends AddReactive {
    __New(GuiObject, options, depend := 0, key := 0) {
        checkType(options, String, "Parameter #1 (options) is not a String")
        checkTypeDepend(depend)
        this.key := key

        super.__New(GuiObject, "DropDownList", options, , depend, key)
    }
}
class ARDropDownList extends AddReactiveDropDownList {
    ; alias
}
class ARDDL extends AddReactiveDropDownList {
    ; alias
}


class AddReactiveComboBox extends AddReactive {
    __New(GuiObject, options, depend := 0, key := 0) {
        checkType(options, String, "Parameter #1 (options) is not a String")
        checkTypeDepend(depend)

        this.key := key
        super.__New(GuiObject, "ComboBox", options, , depend, key)
    }
}
class ARComboBox extends AddReactiveComboBox {
    ; alias
}


class AddReactiveListView extends AddReactive {
    /**
     * Add a reactive ListView control to Gui
     * @param {Gui} GuiObject The target Gui Object.
     * @param {string} options Options apply to the control, same as Gui.Add.
     * @param { {keys: string[], titles: string[], width: number[]} } columnDetails Descriptor object contains keys of col value, column title texts and column width.
     * @param {signal} depend Subscribed signal
     * @param {array} [key] the keys or index of the signal's value
     * @returns {AddReactiveListView}     
     */
    __New(GuiObject, options, columnDetails, depend := 0, key := 0) {
        ; options type checking
        checkType(options, Object.Prototype, "Parameter #1 (options) is not an Object")
        checkType(options.lvOptions, String, "options.lvOptions is not a string")
        if (options.HasOwnProp("itemOptions")) {
            checkType(options.itemOptions, String, "options.itemOptions is not a string")
        }
        ; colTitleGrid type checking
        checkType(columnDetails, Object.Prototype, "Parameter #2 is (columnDetails) is not an Object")
        checkType(columnDetails.keys, Array, "columnDetails.keys is not an Array")
        if (columnDetails.HasOwnProp("titles")) {
            checkType(columnDetails.titles, Array, "columnDetails.titles is not an Array")
        }
        if (columnDetails.HasOwnProp("widths")) {
            checkType(columnDetails.widths, Array, "columnDetails.widths is not an Array")
        }
        ; depend type checking
        checkTypeDepend(depend)
        checkType(depend.value, Array, "Depend value of AddReactive ListView is not an Array")

        this.key := key
        super.__New(GuiObject, "ListView", options, columnDetails, depend, key)
    }

    /**
     * Applies new options to columns
     * @param {Object} newColumnDetails 
     * @param {String} columnOptions 
     */
    setColumndDetails(newColumnDetails, columnOptions := "") {
        colDiff := newColumnDetails.keys.Length - this.titleKeys.Length
        if (colDiff > 0) {
            loop colDiff {
                this.ctrl.InsertCol()
            }
        } else if (colDiff < 0) {
            loop Abs(colDiff) {
                this.ctrl.DeleteCol(this.titleKeys.Length - A_Index)
            }
        }

        this.titleKeys := newColumnDetails.keys
        this.content := newColumnDetails.HasOwnProp("titles") ? newColumnDetails.titles : this.titleKeys
        this.colWidths := newColumnDetails.HasOwnProp("widths") ? newColumnDetails.widths : this.titleKeys.map(item => "AutoHdr")

        for title in this.content {
            this.ctrl.ModifyCol(A_Index, this.colWidths[A_Index], title)
        }
    }
}
class ARListView extends AddReactiveListView {
    ; alias
}


class AddReactiveGroupBox extends AddReactive {
    /**
     * Add a reactive GroupBox control to Gui
     * @param {Gui} GuiObject The target Gui Object.
     * @param {string} options Options apply to the control, same as Gui.Add.
     * @param {string} content Text or formatted text to hold signal values.
     * @param {signal} [depend] Subscribed signal
     * @param {array} [key] the keys or index of the signal's value
     * @returns {AddReactiveCheckBox}     
     */
    __New(GuiObject, options := "", content := "", depend := 0, key := 0) {
        checkType(options, String, "Parameter #1 (options) is not a String")
        checkType(content, String, "Parameter #2 (content) is not a String")
        checkTypeDepend(depend)

        this.key := key
        super.__New(GuiObject, "GroupBox", options, content, depend, key)
    }
}
class ARGroupBox extends AddReactiveGroupBox {
    ; alias
}


class AddReactiveDateTime extends AddReactive {
    /**
     * Add a reactive GroupBox control to Gui
     * @param {Gui} GuiObject The target Gui Object.
     * @param {string} options Options apply to the control, same as Gui.Add.
     * @param {string} content Text or formatted text to hold signal values.
     * @param {signal} [depend] Subscribed signal
     * @param {array} [key] the keys or index of the signal's value
     * @returns {AddReactiveCheckBox}     
     */
    __New(GuiObject, options := "", content := "", depend := 0, key := 0) {
        checkType(options, String, "Parameter #1 (options) is not a String")
        checkType(content, String, "Parameter #2 (content) is not a String")
        checkTypeDepend(depend)

        this.key := key
        super.__New(GuiObject, "GroupBox", options, content, depend, key)
    }
}
class ARDateTime extends AddReactiveDateTime {
    ; alias
}


class AddReactiveTreeView extends AddReactive {
    __New(GuiObject, options := "", depend := 0, key := 0) {
        checkType(options, [String, Object.Prototype])

        this.key := key
        super.__New(GuiObject, "TreeView", options, "", depend, key)
    }

    class ShadowNode {
        /**
         * Make a copy node with the original tree
         * @param {Gui.TreeView} TreeView 
         * @param {Object} originNode 
         */
        __New(TreeView, originNode) {
            this.name := originNode.name
            this.content := originNode.content
            this.parent := ""
            this.childrens := []
            this.nodeId := 0
        }   

        /**
         * Creates a node on TreeView control
         * @param {Gui.TreeView} TreeView 
         * @param {Number} parentId 
         */
        createTreeViewNode(TreeView, parentId := 0) {
            if (parentId) {
                this.nodeId := TreeView.Add(this.name, parentId)
            } else {
                this.nodeId := TreeView.Add(this.name)
            }
        }
    }

    class ShadowTree {
        /**
         * Creates copy tree base on the depend tree-structured object/
         * @param {Gui.TreeView} TreeView 
         */
        __New(TreeView) {
            this.TreeView := TreeView
            this.root := ""
        }

        /**
         * Creates a copy with original tree-structured object.
         * @param {Object} originTree 
         */
        copy(originTree) {
            ; clear tree and copy root
            this.root := ""
            this.addChildren(originTree.root)

            ; copyChildrens
            this.copyChildren(originTree.root)
        }

        /**
         * Copy children node and add it to shadow tree.
         * @param {Object} originNode 
         */
        copyChildren(originNode) {
            if (originNode.childrens.Length == 0) {
                return
            }

            for node in originNode.childrens {
                this.addChildren(node, node.parent.name)
                this.copyChildren(node)
            }
        }

        /**
         * Print tree nodes with a custom function.
         * @param {Func} fn 
         */
        print(fn := node => node) {
            results := []
            this._printTree(fn, results)

            return results
        }
        _printTree(fn := node => node, results := [], curNode := this.root) {
            results.Push(fn(curNode))

            if (curNode.childrens.Length > 0) {
                for childNode in curNode.childrens {
                    this._printTree(fn, results)
                }
            }
        }

        /**
         * Gets a ShadowNode with `content.name`.
         * @param {String} name content.name
         * @param {ShadowNode} curNode starting node
         * @returns {false|ShadowNode}
         */
        getNode(name, curNode := this.root) {
            if (name == curNode.name) {
                return curNode
            }

            if (curNode.childrens.Length > 0) {
                for childNode in curNode.childrens {
                    res := this.getNode(name, childNode)
                    if (res) {
                        return res
                    }
                }
            }

            return false
        }

        /**
         * Gets a ShadowNode with Item ID of a TreeView node.
         * @param {Number} nodeId Item ID of the target TreeView node
         * @param {ShadowNode} curNode starting node
         * @returns {false|ShadowNode}
         */
        getNodeById(nodeId, curNode := this.root) {
            if (nodeId == curNode.nodeId) {
                return curNode
            }

            if (curNode.childrens.Length > 0) {
                for childNode in curNode.childrens {
                    res := this.getNodeById(nodeId, childNode)
                    if (res) {
                        return res
                    }
                }
            }

            return false
        }

        /**
         * Adds a children node to a node.
         * @param {Object} originNode 
         * @param {String} parentName `content.name` of a node
         */
        addChildren(originNode, parentName := 0) {
            newShadowNode := AddReactiveTreeView.ShadowNode(this.TreeView, originNode)

            if (!parentName && !this.root) {
                this.root := newShadowNode
                newShadowNode.createTreeViewNode(this.TreeView)
                return newShadowNode
            }

            if (!parentName && this.root) {
                this.root.childrens.Push(newShadowNode)
                newShadowNode.parent := this.root
                newShadowNode.createTreeViewNode(this.TreeView, this.root.nodeId)
                return newShadowNode
            }

            parentShadowNode := this.getNode(parentName)
            if (!parentShadowNode) {
                return false
            }

            newShadowNode.parent := parentShadowNode
            parentShadowNode.childrens.Push(newShadowNode)
            newShadowNode.createTreeViewNode(this.TreeView, parentShadowNode.nodeId)

            return newShadowNode
        }
    }
}
class ARTreeView extends AddReactiveTreeView {
    ; alias
}


; mount to Gui.Prototype
Gui.Prototype.AddReactiveText := AddReactiveText
Gui.Prototype.ARText := ARText
Gui.Prototype.AddReactiveEdit := AddReactiveEdit
Gui.Prototype.AREdit := AREdit
Gui.Prototype.AddReactiveButton := AddReactiveButton
Gui.Prototype.ARButton := ARButton
Gui.Prototype.AddReactiveCheckBox := AddReactiveCheckBox
Gui.Prototype.ARCheckBox := ARCheckBox
Gui.Prototype.AddReactiveRadio := AddReactiveRadio
Gui.Prototype.ARRadio := ARRadio
Gui.Prototype.AddReactiveComboBox := AddReactiveComboBox
Gui.Prototype.ARComboBox := ARComboBox
Gui.Prototype.AddReactiveDropDownList := AddReactiveDropDownList
Gui.Prototype.ARDropDownList := ARDropDownList
Gui.Prototype.ARDDL := ARDDL
Gui.Prototype.AddReactiveListView := AddReactiveListView
Gui.Prototype.ARListView := ARListView
Gui.Prototype.AddReactiveGroupBox := AddReactiveGroupBox
Gui.Prototype.ARGroupBox := ARGroupBox
Gui.Prototype.AddReactiveDateTime := AddReactiveDateTime
Gui.Prototype.ARDateTime := ARDateTime
Gui.Prototype.AddReactiveDateTime := AddReactiveTreeView
Gui.Prototype.ARDateTime := ARTreeView
Gui.Prototype.AddReactiveTreeView := AddReactiveTreeView
Gui.Prototype.ARTreeView := ARTreeView