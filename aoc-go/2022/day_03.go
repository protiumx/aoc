package solutions

import (
	"strings"
)

func getPriority(c rune) int {
	if c <= 'Z' {
		return int(c - 'A' + 27)
	}
	return int(c - 'a' + 1)
}

func Day_03_01(input string) int {
	total := 0
	for _, rucksack := range strings.Split(input, "\n") {
		half := len(rucksack) / 2
		halfA, halfB := rucksack[:half], rucksack[half:]
		m := make(map[rune]bool)
		for _, c := range halfA {
			m[c] = false
		}

		for _, c := range halfB {
			if done, ok := m[c]; ok && !done {
				total += getPriority(c)
				m[c] = true
			}
		}
	}

	return total
}

func Day_03_02(input string) int {
	lines := strings.Split(input, "\n")
	total := 0
	for i := 0; i < len(lines); i += 3 {
		prios := make([]int, 53)
		A := lines[i]
		B := lines[i+1]
		C := lines[i+2]

		for _, c := range A {
			p := getPriority(c)
			if prios[p] == 0 {
				prios[p] = 1
			}
		}

		for _, c := range B {
			p := getPriority(c)
			if prios[p] == 1 {
				prios[p] = 2
			}
		}

		for _, c := range C {
			p := getPriority(c)
			if prios[p] == 2 {
				total += p
				break
			}
		}
	}
	return total
}
