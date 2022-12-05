package solutions

import (
	"regexp"
	"strconv"
	"strings"
)

func Day_05_01(input string) string {
	lines := strings.Split(input, "\n")
	stacks := [][]byte{}
	// harcoded according to input day_05.in
	for i := 0; i < 10; i++ {
		stacks = append(stacks, []byte{})
	}

	digitsRegex := regexp.MustCompile(`\d+`)

	instructionsIndex := 0
	// parse stacks
	for i, line := range lines {
		if digitsRegex.MatchString(line) {
			// this is the indexes line, instructions are 2 lines below
			instructionsIndex = i + 2
			break
		}

		// account for spaces and [] chars
		for s, c := 0, 1; c < len(line); c, s = c+4, s+1 {
			if line[c] == ' ' {
				continue
			}
			stacks[s] = append(stacks[s], line[c])
		}
	}

	for i := instructionsIndex; i < len(lines); i += 1 {
		if lines[i] == "" {
			break
		}

		instructions := digitsRegex.FindAllString(lines[i], 3)
		n, _ := strconv.Atoi(instructions[0])
		from, _ := strconv.Atoi(instructions[1])
		dest, _ := strconv.Atoi(instructions[2])

		for ; n > 0; n-- {
			// prepend
			stacks[dest-1] = append([]byte{stacks[from-1][0]}, stacks[dest-1]...)
			stacks[from-1] = stacks[from-1][1:]
		}
	}

	result := []byte{}

	for _, s := range stacks {
		if len(s) == 0 {
			break
		}

		result = append(result, s[0])
	}
	return string(result)
}

func Day_05_02(input string) string {
	lines := strings.Split(input, "\n")
	stacks := [][]byte{}
	for i := 0; i < 10; i++ {
		stacks = append(stacks, []byte{})
	}

	digitsRegex := regexp.MustCompile(`\d+`)

	instructionsIndex := 0
	// parse stacks
	for i, line := range lines {
		if digitsRegex.MatchString(line) {
			// this is the indexes line, instructions are 2 lines below
			instructionsIndex = i + 2
			break
		}

		// account for spaces and [] chars
		for s, c := 0, 1; c < len(line); c, s = c+4, s+1 {
			if line[c] == ' ' {
				continue
			}
			stacks[s] = append([]byte{line[c]}, stacks[s]...)
		}
	}

	for i := instructionsIndex; i < len(lines); i += 1 {
		if lines[i] == "" {
			break
		}

		instructions := digitsRegex.FindAllString(lines[i], 3)
		n, _ := strconv.Atoi(instructions[0])
		from, _ := strconv.Atoi(instructions[1])
		dest, _ := strconv.Atoi(instructions[2])

		fromStack := stacks[from-1]
		stacks[dest-1] = append(stacks[dest-1], fromStack[len(fromStack)-n:]...)
		stacks[from-1] = stacks[from-1][:len(fromStack)-n]
	}

	result := []byte{}

	for _, s := range stacks {
		if len(s) == 0 {
			break
		}

		result = append(result, s[len(s)-1])
	}
	return string(result)
}
