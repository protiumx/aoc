package solutions

import (
	"bufio"
	"fmt"
	"math"
	"os"
	"strconv"
	"strings"
)

type orientation int

const (
	vertical orientation = iota + 1
	horizontal
	diagonal45
	other
)

type Point struct {
	x, y int
}

type Line struct {
	start Point
	end   Point
}

func (l Line) max() int {
	max := l.start.x
	if l.start.y > max {
		max = l.start.y
	}
	if l.end.x > max {
		max = l.end.x
	}
	if l.end.y > max {
		max = l.end.y
	}
	return max
}

func (l Line) orientation() orientation {
	if l.start.x == l.end.x {
		return vertical
	}
	if l.start.y == l.end.y {
		return horizontal
	}
	if math.Abs(float64(l.start.x-l.end.x)) == math.Abs(float64(l.start.y-l.end.y)) {
		return diagonal45
	}
	return other
}

func parsePoint(data string) Point {
	points := strings.Split(data, ",")
	x, _ := strconv.Atoi(points[0])
	y, _ := strconv.Atoi(points[1])
	return Point{x, y}
}

func parseLine(line string) Line {
	points := strings.Split(line, " -> ")
	return Line{
		start: parsePoint(points[0]),
		end:   parsePoint(points[1]),
	}
}

func printBoard(board [][]int) {
	for _, row := range board {
		for _, col := range row {
			if col == 0 {
				fmt.Print(". ")
			} else {
				fmt.Printf("%d ", col)
			}
		}
		fmt.Println("")
	}
	fmt.Println("")
}

func ShowD05() {
	lines := []Line{}
	file, _ := os.Open("../../input/day_05.in")
	defer file.Close()

	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		lines = append(lines, parseLine(scanner.Text()))
	}

	max := 0
	for _, l := range lines {
		lineSize := l.max()
		if lineSize > max {
			max = lineSize
		}
	}

	board := make([][]int, max+1)
	for i := 0; i <= max; i++ {
		board[i] = make([]int, max+1)
	}

	count := 0
	for _, l := range lines {
		if l.orientation() != vertical && l.orientation() != horizontal {
			continue
		}
		start := int(math.Min(float64(l.start.x), float64(l.end.x)))
		end := int(math.Max(float64(l.start.x), float64(l.end.x)))
		if l.orientation() == vertical {
			start = int(math.Min(float64(l.start.y), float64(l.end.y)))
			end = int(math.Max(float64(l.start.y), float64(l.end.y)))
		}
		for start <= end {
			x := start
			y := l.start.y
			if l.orientation() == vertical {
				x = l.start.x
				y = start
			}
			board[y][x] += 1
			if board[y][x] == 2 {
				count += 1
			}
			start += 1
		}
	}

	printBoard(board)
	fmt.Printf("Part 1: %d\n", count)
	for _, l := range lines {
		if l.orientation() != diagonal45 {
			continue
		}
		m := (l.end.x - l.start.x) / (l.end.y - l.start.y)
		yMax := l.start.y
		yMin := l.end.y
		if yMax < yMin {
			yMax, yMin = yMin, yMax
		}
		col := l.start.x
		xMax := l.end.x
		if col > xMax {
			col, xMax = xMax, col
		}
		row := yMin
		if m == -1 {
			row = yMax
		}

		for col <= xMax {
			board[row][col] += 1
			if board[row][col] == 2 {
				count += 1
			}
			col += 1
			row += m
		}

	}

	printBoard(board)
	fmt.Printf("Part 2: %d\n", count)
}
