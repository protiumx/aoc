package solutions

import (
	"regexp"
	"strconv"
	"strings"
)

func Day_04_01(input string) int {
	contained := 0
	r := regexp.MustCompile(`\d+`)
	for _, line := range strings.Split(input, "\n") {
		matches := r.FindAllString(line, 4)
		a1, _ := strconv.Atoi(string(matches[0]))
		a2, _ := strconv.Atoi(string(matches[1]))
		b1, _ := strconv.Atoi(string(matches[2]))
		b2, _ := strconv.Atoi(string(matches[3]))
		if (a1 >= b1 && a2 <= b2) || (b1 >= a1 && b2 <= a2) {
			contained += 1
		}
	}

	return contained
}

func Day_04_02(input string) int {
	overlapped := 0
	r := regexp.MustCompile(`\d+`)
	for _, line := range strings.Split(input, "\n") {
		matches := r.FindAllString(line, 4)
		a1, _ := strconv.Atoi(string(matches[0]))
		a2, _ := strconv.Atoi(string(matches[1]))
		b1, _ := strconv.Atoi(string(matches[2]))
		b2, _ := strconv.Atoi(string(matches[3]))
		if (a1 <= b1 && a2 >= b1) || (b1 <= a1 && b2 >= a1) {
			overlapped += 1
		}
	}

	return overlapped
}
