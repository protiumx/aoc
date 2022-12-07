package solutions

import (
	"strconv"
	"strings"
)

func calculateDirSizes(input string) (*Heap, *FsNode) {
	// Assume every directory is visited only once
	lines := strings.Split(input, "\n")
	root := NewNode("/", true)
	stack := NewStack[*FsNode]()
	stack.Push(&root)
	currentNode := &root
	dirSizes := NewHeap(-1, func(a, b int) bool { return a > b })

	// first command is always cd /, so I skip it
	for i := 1; i < len(lines); i++ {
		line := lines[i]
		words := strings.Split(line, " ")

		if words[0] == "$" {
			if words[1] != "cd" {
				continue
			}

			// process cd command
			if words[2] == ".." {
				d, _ := stack.Pop()
				dirSizes.insert(d.size)

				currentNode, _ = stack.Peek()
				currentNode.size += d.size
			} else {
				currentNode = currentNode.findChild(words[2])
				stack.Push(currentNode)
			}
			continue
		}

		// process ls
		child := NewNode(words[1], true)
		if words[0] != "dir" {
			size, _ := strconv.Atoi(words[0])
			currentNode.size += size
			child.size = size
			child.dir = false
		}
		currentNode.children = append(currentNode.children, &child)
	}
	// empty the stack except for the root dir
	for stack.Size() > 1 {
		p, _ := stack.Pop()
		dirSizes.insert(p.size)
		root.size += p.size
	}
	dirSizes.insert(root.size)
	return &dirSizes, &root
}

func Day_07_01(input string) int {
	const maxSize = 100000
	dirSizes, _ := calculateDirSizes(input)

	total := 0
	for len(dirSizes.items) > 0 {
		size := dirSizes.pop()
		if size > maxSize {
			break
		}
		total += size
	}

	return total
}

func Day_07_02(input string) int {
	const devizeSize = 70000000
	const updateSize = 30000000
	dirSizes, root := calculateDirSizes(input)
	freeSpace := devizeSize - root.size
	requiredSpace := updateSize - freeSpace

	// pop sizes until there is enough space
	lastSize := 0
	for len(dirSizes.items) > 0 {
		if lastSize > requiredSpace {
			break
		}
		lastSize = dirSizes.pop()
	}

	return lastSize
}
