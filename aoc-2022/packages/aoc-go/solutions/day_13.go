package solutions

import (
	"fmt"
	"sort"
	"strconv"
	"strings"
)

func parseSignalList(signal string) ([]any, int) {
	ret := []any{}
	numBytes := []byte{}
	index := 0

	for index < len(signal) {
		char := signal[index]
		switch char {
		case '[':
			child, i := parseSignalList(signal[index+1:])
			index += i + 1
			ret = append(ret, child)

		case ']', ',':
			if len(numBytes) > 0 {
				num, _ := strconv.Atoi(string(numBytes))
				ret = append(ret, num)
				numBytes = []byte{}
			}
			index++
			if char == ']' {
				return ret, index
			}

		default:
			numBytes = append(numBytes, char)
			index++
		}
	}

	return ret, index
}

func compareSignals(left, right any) int {
	leftNum, leftOk := left.(int)
	rightNum, rightOk := right.(int)
	if leftOk && rightOk {
		if leftNum > rightNum {
			return -1
		}

		if rightNum > leftNum {
			return 1
		}
		return 0
	}

	leftList, leftOk := left.([]any)
	if !leftOk {
		leftList = []any{leftNum}
	}

	rightList, rightOk := right.([]any)
	if !rightOk {
		rightList = []any{rightNum}
	}

	for i := 0; i < len(leftList); i++ {
		if i >= len(rightList) {
			return -1
		}
		if sub := compareSignals(leftList[i], rightList[i]); sub != 0 {
			return sub
		}
	}

	if len(rightList) > len(leftList) {
		return 1
	}

	return 0
}

func Day_13_01(input string) int {
	lines := strings.Split(input, "\n")
	var left, right []any
	pairIndex := 0
	total := 0

	for i := 0; i < len(lines); {
		left, _ = parseSignalList(lines[i][1:])
		right, _ = parseSignalList(lines[i+1][1:])

		pairIndex++

		// compare signals
		c := compareSignals(left, right)
		if c >= 0 {
			total += pairIndex
		}
		i += 3
	}
	fmt.Println("total pairs", pairIndex)

	return total
}

func Day_13_02(input string) int {
	lines := strings.Split(input, "\n")
	signals := []any{}

	for i := 0; i < len(lines); i++ {
		if lines[i] == "" {
			continue
		}
		signal, _ := parseSignalList(lines[i][1:])
		signals = append(signals, signal)
	}

	var divider2, divider6 any
	divider2, divider6 = [][]int{{2}}, [][]int{{6}}
	signals = append(signals, divider2, divider6)

	sort.Slice(signals, func(i int, j int) bool {
		a := signals[i]
		b := signals[j]
		return compareSignals(a, b) == 1
	})

	total := 1
	dividers := 2
	for i, signal := range signals {
		if &signal == &divider2 || &signal == divider6 {
			total *= i + i
			dividers--
			if dividers == 0 {
				break
			}
		}
	}
	return total
}
