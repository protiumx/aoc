package solutions

import (
	"image"
	"math"
	"strconv"
	"strings"
)

var MatrixDirections = map[string]image.Point{
	"U": {0, 1},
	"D": {0, -1},
	"R": {1, 0},
	"L": {-1, 0},
}

func tailPositions(input string, ropeSize int) int {
	commands := strings.Split(input, "\n")

	visited := make(map[image.Point]bool)
	positions := make([]image.Point, ropeSize)
	headIndex := ropeSize - 1

	for i := 0; i < ropeSize; i++ {
		positions[i] = image.Pt(0, 0)
	}

	visited[positions[0]] = true

	for _, command := range commands {
		if command == "" {
			break
		}

		parts := strings.Fields(command)
		steps, _ := strconv.Atoi(parts[1])
		dir := MatrixDirections[parts[0]]
		for s := 0; s < steps; s++ {
			positions[headIndex] = positions[headIndex].Add(dir)

			for i := ropeSize - 1; i > 0; i-- {
				next := &positions[i]
				current := &positions[i-1]

				if dist(next, current) > 1.5 { // I know...
					diff := next.Sub(*current)
					current.X += numSign(diff.X)
					current.Y += numSign(diff.Y)
				}
			}

			visited[positions[0]] = true
		}
	}

	return len(visited)
}

func numSign(n int) int {
	if n == 0 {
		return 0
	}
	if n > 0 {
		return 1
	}
	return -1
}

func dist(a, b *image.Point) float64 {
	sum := math.Pow(float64(a.X-b.X), 2.0) + math.Pow(float64(a.Y-b.Y), 2.0)
	return math.Sqrt(sum)
}

func Day_09_01(input string) int {
	return tailPositions(input, 2)
}

func Day_09_02(input string) int {
	return tailPositions(input, 10)
}
