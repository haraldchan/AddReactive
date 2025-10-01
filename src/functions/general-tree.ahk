/**
 * Represents a node in a general tree structure.
 */
class GeneralTreeNode {
    /**
     * Constructs a GeneralTreeNode.
     * @param {string} nodeName - The name of the node.
     * @param {any} content - The content/data of the node.
     */
    __New(nodeName, content) {
        this.parent := ""
        this.children := []

        this.name := nodeName
        this.content := content
    }
}

/**
 * Represents a general tree structure with node management methods.
 */
class GeneralTree {
    /**
     * Constructs a GeneralTree with an empty root.
     */
    __New() {
        this.root := ""
    }

    /**
     * Recursively searches for a node by name starting from curNode.
     * @param {string} name - The name of the node to find.
     * @param {GeneralTreeNode} [curNode] - The node to start searching from (defaults to root).
     * @returns {GeneralTreeNode|false} The found node or false if not found.
     */
    getNode(name, curNode := this.root) {
        if (name == curNode.name) {
            return curNode
        }

        if (curNode.children.Length > 0) {
            for childNode in curNode.children {
                res := this.getNode(name, childNode)
                if (res) {
                    return res
                }
            }
        }

        return false
    }

    /**
     * Removes a node from the tree by name.
     * @param {string} nodeName - The name of the node to remove.
     * @returns {GeneralTreeNode} The removed node.
     */
    removeNode(nodeName) {
        targetNode := this.getNode(nodeName)

        index := ArrayExt.findIndex(targetNode.parent.children, c => c.name == nodeName)
        targetNode.parent.children.RemoveAt(index)
        targetNode.parent := ""

        return targetNode
    }

    /**
     * Adds a child node to the tree.
     * @param {string} name - The name of the new node.
     * @param {any} content - The content/data of the new node.
     * @param {string} [parentName] - The name of the parent node (optional).
     * @returns {GeneralTreeNode|false} The new node or false if parent not found.
     */
    addChild(name, content, parentName := "") {
        newNode := GeneralTreeNode(name, content)

        if (!this.root) {
            this.root := newNode
            return newNode
        }

        if (!parentName && this.root) {
            this.root.children.Push(newNode)
            newNode.parent := this.root
            return newNode
        }

        parentNode := this.getNode(parentName)
        if (!parentNode) {
            return false
        }

        newNode.parent := parentNode
        parentNode.children.Push(newNode)

        return newNode
    }
}