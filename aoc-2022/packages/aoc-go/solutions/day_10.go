package solutions

import (
	"math"
	"strconv"
	"strings"
)

var opCycles = map[string]int{
	"addx": 2,
	"noop": 1,
}

func Day_10_01(input string) int {
	const maxCycle = 220
	const signalSize = 40

	currentCycle := 0
	readMark := 20
	registerX := 1
	signalSum := 0
OP:
	for _, op := range strings.Split(input, "\n") {
		parts := strings.Fields(op)
		for i := 0; i < opCycles[parts[0]]; i++ {
			currentCycle += 1
			if currentCycle == readMark {
				signalSum += registerX * currentCycle
				readMark += signalSize
			}

			if currentCycle >= maxCycle {
				break OP
			}
		}

		switch parts[0] {
		case "addx":
			value, _ := strconv.Atoi(parts[1])
			registerX += value
		}
	}

	return signalSum
}

func Day_10_02(input string) string {
	const maxCycle = 240
	const screenCols = 40
	const screenRows = 6

	screen := [screenRows][screenCols]byte{}

	currentCycle := 0
	registerX := 1
OP:
	for _, op := range strings.Split(input, "\n") {
		parts := strings.Fields(op)
		for i := 0; i < opCycles[parts[0]]; i++ {
			currentCycle += 1

			row, col := getPosition(currentCycle, screenCols)
			if math.Abs(float64(col-registerX)) <= 1 {
				screen[row][col] = '#'
			} else {
				screen[row][col] = '.'
			}

			if currentCycle >= maxCycle {
				break OP
			}
		}

		switch parts[0] {
		case "addx":
			value, _ := strconv.Atoi(parts[1])
			registerX += value
		}
	}

	var out strings.Builder
	for i, line := range screen {
		out.WriteString(string(line[:]))
		if i < screenRows-1 {
			out.WriteString("\n")
		}
	}

	return out.String()
}

func getPosition(currentCycle, cols int) (int, int) {
	col := (currentCycle - 1) % cols
	row := (currentCycle - 1) / cols
	return row, col
}
