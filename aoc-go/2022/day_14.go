package solutions

import (
	"fmt"
	"image"
	"math"
	"strconv"
	"strings"
)

func min(nums ...int) int {
	m := nums[0]
	for i := 1; i < len(nums); i++ {
		if nums[i] < m {
			m = nums[i]
		}
	}

	return m
}

func max(nums ...int) int {
	m := nums[0]
	for i := 1; i < len(nums); i++ {
		if nums[i] > m {
			m = nums[i]
		}
	}

	return m
}

func parsePaths(input string) (map[image.Point]byte, image.Point, image.Point) {
	lines := strings.Split(input, "\n")
	paths := map[image.Point]byte{}

	minPoint, maxPoint := image.Pt(math.MaxInt, math.MaxInt), image.Pt(0, 0)
	for _, line := range lines {
		if line == "" {
			break
		}

		points := strings.Split(line, " -> ")
		for i := 0; i < len(points)-1; i++ {
			pair := strings.Split(points[i], ",")
			x1, _ := strconv.Atoi(pair[0])
			y1, _ := strconv.Atoi(pair[1])

			pair = strings.Split(points[i+1], ",")
			x2, _ := strconv.Atoi(pair[0])
			y2, _ := strconv.Atoi(pair[1])

			pathStart := image.Pt(min(x1, x2), min(y1, y2))
			pathEnd := image.Pt(max(x1, x2), max(y1, y2))

			// fill the path between points
			if pathStart.X == pathEnd.X {
				for i := 0; i < pathEnd.Y-pathStart.Y; i++ {
					paths[image.Pt(pathStart.X, pathStart.Y+i)] = '#'
				}
			} else if pathStart.Y == pathEnd.Y {
				for i := 0; i <= pathEnd.X-pathStart.X; i++ {
					paths[image.Pt(pathStart.X+i, pathStart.Y)] = '#'
				}
			}

			// find boundaries
			minPoint.X = min(minPoint.X, pathStart.X)
			minPoint.Y = min(minPoint.Y, pathStart.Y)
			maxPoint.X = max(maxPoint.X, pathEnd.X)
			maxPoint.Y = max(maxPoint.Y, pathEnd.Y)
		}
	}

	return paths, minPoint, maxPoint
}

func printCave(paths map[image.Point]byte, minPoint, maxPoint image.Point) {
	for i := 0; i < maxPoint.Y+1; i++ {
		for j := 0; j < maxPoint.X-minPoint.X+1; j++ {
			if c, ok := paths[image.Pt(minPoint.X+j, i)]; ok {
				fmt.Printf("%c", c)
			} else {
				fmt.Printf(".")
			}
		}
		fmt.Println("")
	}
}

func Day_14_01(input string) int {
	const sandSourceColumn = 500

	paths, minPoint, maxPoint := parsePaths(input)
	source := image.Pt(sandSourceColumn, 0)
	total := 0
	pos := dropSand(paths, maxPoint.Y, source)
	for pos.Y < maxPoint.Y {
		total++
		paths[pos] = 'o'
		pos = dropSand(paths, maxPoint.Y, source)
	}

	printCave(paths, minPoint, maxPoint)

	return total
}

func Day_14_02(input string) int {
	const sandSourceColumn = 500

	paths, minPoint, maxPoint := parsePaths(input)
	// treat last row as a threshold so it's the same problem as part 1
	maxPoint.Y++
	total := 0
	source := image.Pt(sandSourceColumn, 0)
	pos := dropSand(paths, maxPoint.Y, source)
	_, ok := paths[source]
	for !ok {
		total++
		paths[pos] = 'o'
		pos = dropSand(paths, maxPoint.Y, source)
		_, ok = paths[pos]
		// increase boundaries for visualizatin
		// minPoint.X = min(minPoint.X, pos.X)
		// maxPoint.X = max(maxPoint.X, pos.X)
	}

	for i := minPoint.X; i <= maxPoint.X; i++ {
		paths[image.Pt(i, maxPoint.Y+1)] = '#'
	}

	printCave(paths, minPoint, maxPoint.Add(image.Pt(0, 1)))
	return total
}

func dropSand(paths map[image.Point]byte, maxY int, from image.Point) image.Point {
	pos := from
	for {
		prev := pos
		for _, d := range []image.Point{{0, 1}, {-1, 1}, {1, 1}} {
			next := pos.Add(d)
			if _, ok := paths[next]; !ok && next.Y < maxY+1 {
				pos = next
				break
			}
		}

		if pos.Y >= maxY || prev == pos {
			return pos
		}
	}
}
