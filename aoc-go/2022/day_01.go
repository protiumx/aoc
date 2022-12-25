package solutions

import (
	"fmt"
	"strconv"
	"strings"
)

func Day_01_01(input string) int {
	lines := strings.Split(input, "\n")
	max := 0
	current := 0
	for i, line := range lines {
		if line == "" || i == len(lines)-1 {
			if current > max {
				max = current
			}
			current = 0
			continue
		}

		lineValue, err := strconv.Atoi(line)
		if err != nil {
			fmt.Printf("error parsing %s: %v", line, err)
		}
		current += lineValue
	}

	return max
}

func Day_01_02(input string) int {
	lines := strings.Split(input, "\n")
	h := NewHeap(3, func(a, b int) bool { return a > b })
	current := 0
	for i, line := range lines {
		if line == "" || i == len(lines)-1 {
			h.Push(current)
			current = 0
			continue
		}

		lineValue, err := strconv.Atoi(line)
		if err != nil {
			fmt.Printf("error parsing %s: %v", line, err)
		}
		current += lineValue
	}

	max := 0
	for i := 0; i < 3; i++ {
		max += h.Pop()
	}

	return max
}
