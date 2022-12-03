package solutions

import (
	"strings"
)

func Day_02_01(input string) int {
	total := 0
	for _, match := range strings.Split(input, "\n") {
		if match == "" {
			break
		}
		left := int(match[0] - 'A')
		right := int(match[2] - 'X')
		// Add 4 to handle negative values
		total += ((right-left+4)%3)*3 + right + 1
	}
	return total
}

func Day_02_02(input string) int {
	total := 0
	for _, match := range strings.Split(input, "\n") {
		if match == "" {
			break
		}
		left := int(match[0] - 'A')
		right := (left + 2 + int(match[2]-'X')) % 3
		total += ((right-left+4)%3)*3 + right + 1
	}
	return total
}
