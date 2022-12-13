package solutions

import (
	"fmt"
	"image"
	"math"
	"strings"
)

func findShortestPathBFS(heightMap map[image.Point]byte, start, end image.Point, checkStop func(p image.Point) bool) int {
	queue := []image.Point{start}
	steps := make(map[image.Point]int)
	steps[start] = 0
	cycles := 0
	for len(queue) > 0 {
		current := queue[0]
		queue = queue[1:]
		cycles++
		// visited
		if heightMap[current] == '-' {
			continue
		}

		if checkStop(current) {
			fmt.Println("found in cycles", cycles)
			return steps[current]
		}

		for _, dir := range MatrixDirections {
			next := current.Add(dir)
			nextHeight, ok := heightMap[next]
			if !ok || nextHeight > heightMap[current]+1 {
				continue
			}

			queue = append(queue, next)
			if _, ok := steps[next]; !ok {
				steps[next] = 0
			}
			steps[next] = steps[current] + 1
		}

		heightMap[current] = '-'
	}

	return math.MaxInt
}

// Find shortest path descending with Dijkstra
func findShortestPath(heightMap map[image.Point]byte, start, end image.Point, checkStop func(p image.Point) bool) int {
	// steps from every to the end
	steps := make(map[image.Point]int)
	steps[start] = 0

	type Node struct {
		steps    int
		position image.Point
	}

	// prioritize positions with less steps
	pq := NewHeap(-1, func(a, b Node) bool { return a.steps > b.steps })
	pq.Push(Node{0, start})

	cycles := 0

	for pq.Len() > 0 {
		cycles++
		current := pq.Pop()
		currentHeight := heightMap[current.position]

		if checkStop(current.position) {
			fmt.Printf("found in %d cycles\n", cycles)
			return steps[current.position]
		}

		for _, dir := range MatrixDirections {
			next := current.position.Add(dir)
			nextHeight, ok := heightMap[next]
			// boundaries check
			if !ok || nextHeight < currentHeight-1 {
				continue
			}

			newSteps := steps[current.position] + 1
			if prevSteps, ok := steps[next]; !ok || newSteps < prevSteps {
				steps[next] = newSteps
				pq.Push(Node{steps: newSteps, position: next})
			}

		}
	}
	return math.MaxInt
}

func parse(input string) (map[image.Point]byte, image.Point, image.Point) {
	elevationMap := make(map[image.Point]byte)
	var start, end image.Point

	for i, row := range strings.Split(input, "\n") {
		if row == "" {
			break
		}

		for j := 0; j < len(row); j++ {
			pos := image.Pt(j, i)
			elevationMap[pos] = row[j]

			if row[j] == 'S' {
				start = pos
				elevationMap[pos] = 'a'
			}

			if row[j] == 'E' {
				end = pos
				elevationMap[pos] = 'z'
			}
		}
	}
	return elevationMap, start, end
}

func Day_12_01(input string) int {
	heightsMap, start, end := parse(input)
	return findShortestPath(heightsMap, end, start, func(p image.Point) bool { return p == start })
}

func Day_12_02(input string) int {
	heightsMap, start, end := parse(input)
	// stops at the first 'a'
	return findShortestPath(heightsMap, end, start, func(p image.Point) bool { return heightsMap[p] == 'a' })
}
