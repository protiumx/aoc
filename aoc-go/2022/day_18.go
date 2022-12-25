package solutions

import (
	"math"
	"regexp"
	"strconv"
	"strings"
)

type Point = [3]int

var neighbors_3d = [6]Point{
	{1, 0, 0},
	{-1, 0, 0},
	{0, 1, 0},
	{0, -1, 0},
	{0, 0, 1},
	{0, 0, -1},
}

func parse_3d_points(input string) map[Point]bool {
	points := map[Point]bool{}
	r := regexp.MustCompile(`\w+`)
	for _, line := range strings.Split(input, "\n") {
		lava := Point{}
		data := r.FindAllString(line, -1)
		lava[0], _ = strconv.Atoi(data[0])
		lava[1], _ = strconv.Atoi(data[1])
		lava[2], _ = strconv.Atoi(data[2])
		points[lava] = true
	}

	return points
}

func Day_18_01(input string) int {
	points := parse_3d_points(input)

	area := 0
	for p := range points {
		for _, n := range neighbors_3d {
			if _, ok := points[Point{p[0] + n[0], p[1] + n[1], p[2] + n[2]}]; !ok {
				area++
			}
		}
	}

	return area
}
func Day_18_02(input string) int {
	points := parse_3d_points(input)
	min_x, max_x := math.MaxInt, math.MinInt
	min_y, max_y := math.MaxInt, math.MinInt
	min_z, max_z := math.MaxInt, math.MinInt

	// calculate points of a box containing all points
	for p := range points {
		min_x, max_x = min(min_x, p[0]), max(max_x, p[0])
		min_y, max_y = min(min_y, p[1]), max(max_y, p[1])
		min_z, max_z = min(min_z, p[2]), max(max_z, p[2])
	}
	min_x, max_x = min_x-1, max_x+1
	min_y, max_y = min_y-1, max_y+1
	min_z, max_z = min_z-1, max_z+1

	inside_bounds := func(p Point) bool {
		return p[0] >= min_x && p[0] <= max_x &&
			p[1] >= min_y && p[1] <= max_y &&
			p[2] >= min_z && p[2] <= max_z
	}

	outside := map[Point]bool{}
	to_visit := []Point{{min_x, min_y, min_z}}
	for len(to_visit) > 0 {
		p := to_visit[len(to_visit)-1]
		to_visit = to_visit[:len(to_visit)-1]

		_, in_points := points[p]
		_, in_outside := outside[p]
		if !in_points && !in_outside && inside_bounds(p) {
			outside[p] = true
			for _, n := range neighbors_3d {
				to_visit = append(to_visit, Point{p[0] + n[0], p[1] + n[1], p[2] + n[2]})
			}
		}
	}

	sides_touching := 0
	for p := range points {
		for _, n := range neighbors_3d {
			if _, ok := outside[Point{p[0] + n[0], p[1] + n[1], p[2] + n[2]}]; ok {
				sides_touching++
			}
		}
	}

	return sides_touching
}
