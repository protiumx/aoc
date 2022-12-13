package solutions

import (
	"fmt"
	"strings"
)

type FsNode struct {
	name     string
	size     int
	dir      bool
	children []*FsNode
}

func NewNode(name string, dir bool) FsNode {
	return FsNode{name: name, dir: dir, children: []*FsNode{}}
}

func (n *FsNode) findChild(name string) *FsNode {
	for _, child := range n.children {
		if child.name == name {
			return child
		}
	}
	return nil
}

// DFS
func (n *FsNode) getDirSize(h *Heap[int]) int {
	if !n.dir {
		return n.size
	}

	size := 0
	for _, c := range n.children {
		size += c.getDirSize(h)
	}
	n.size = size
	h.Push(size)
	return size
}

func (n *FsNode) String() string {
	var out strings.Builder
	stack := NewStack[*FsNode]()
	stack.Push(n)
	// there is one dir in the stack
	currentChilds := 1
	level := 0
	for stack.Size() > 0 {
		// finished popping all the children of the current dir
		if currentChilds == -1 {
			level--
		}
		node, _ := stack.Pop()
		currentChilds--

		padding := ""
		for i := 0; i < level; i++ {
			padding += " "
		}
		if len(node.children) > 0 {
			level++
			currentChilds = len(node.children)
			for _, child := range node.children {
				stack.Push(child)
			}
		}

		out.WriteString(padding)
		out.WriteString("- ")
		out.WriteString(node.name)
		out.WriteString(" (")
		out.WriteString(fmt.Sprintf("%d", node.size))
		out.WriteString(")\n")
	}

	return out.String()
}
