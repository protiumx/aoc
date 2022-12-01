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
	for _, line := range lines {
		if line == "" {
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
