package solutions

import (
	"fmt"
	"image"
	"math"
	"strings"
)

func findShortestPathBFS(heightMap map[image.Point]byte, start, end image.Point, checkStop func(p image.Point) bool) int {
	type Node struct {
		pos   image.Point
		steps int
	}

	queue := []Node{
		{start, 0},
	}
	cycles := 0
	for len(queue) > 0 {
		current := queue[0]
		queue = queue[1:]
		cycles++
		// visited
		if heightMap[current.pos] == '-' {
			continue
		}

		for _, dir := range MatrixDirections {
			next := current.pos.Add(dir)
			nextHeight, ok := heightMap[next]
			if !ok || nextHeight < heightMap[current.pos]-1 {
				continue
			}

			if checkStop(next) {
				fmt.Println("found in cycles", cycles)
				return current.steps + 1
			}

			queue = append(queue, Node{next, current.steps + 1})
		}

		heightMap[current.pos] = '-'
	}

	return math.MaxInt
}

// Find shortest path descending with Dijkstra
func findShortestPath(heightMap map[image.Point]byte, start, end image.Point, checkStop func(p image.Point) bool) int {
	type Node struct {
		prioroty int
		position image.Point
	}

	// prioritize positions with less steps from the start
	pq := NewHeap(-1, func(a, b Node) bool { return a.prioroty > b.prioroty })
	pq.Push(Node{0, start})

	// steps of each position from the start to the position at the top of the queue
	steps := make(map[image.Point]int)
	steps[start] = 0

	cycles := 0

	for pq.Len() > 0 {
		cycles++
		current := pq.Pop()
		currentHeight := heightMap[current.position]

		for _, dir := range MatrixDirections {
			next := current.position.Add(dir)
			nextHeight, ok := heightMap[next]
			// boundaries check
			if !ok || nextHeight < currentHeight-1 {
				continue
			}

			if checkStop(next) {
				fmt.Printf("found in %d cycles\n", cycles)
				return steps[current.position] + 1
			}

			newSteps := steps[current.position] + 1
			if prevSteps, ok := steps[next]; !ok || newSteps < prevSteps {
				steps[next] = newSteps
				pq.Push(Node{prioroty: newSteps, position: next})
			}

		}
	}
	return math.MaxInt
}

func parse(input string) (map[image.Point]byte, image.Point, image.Point) {
	elevationMap := make(map[image.Point]byte)
	var SPosition, EPos image.Point

	for i, row := range strings.Split(input, "\n") {
		if row == "" {
			break
		}

		for j := 0; j < len(row); j++ {
			pos := image.Pt(j, i)
			elevationMap[pos] = row[j]

			if row[j] == 'S' {
				SPosition = pos
				elevationMap[pos] = 'a'
			}

			if row[j] == 'E' {
				EPos = pos
				elevationMap[pos] = 'z'
			}
		}
	}
	return elevationMap, SPosition, EPos
}

func Day_12_01(input string) int {
	heightsMap, SPos, EPos := parse(input)
	return findShortestPath(heightsMap, EPos, SPos, func(p image.Point) bool { return p == SPos })
}

func Day_12_02(input string) int {
	heightsMap, SPos, EPos := parse(input)
	// stops at the first 'a'
	return findShortestPath(heightsMap, EPos, SPos, func(p image.Point) bool { return heightsMap[p] == 'a' })
}
