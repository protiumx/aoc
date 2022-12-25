package solutions

import (
	"bufio"
	"fmt"
	"math"
	"math/bits"
	"os"
	"strings"
)

func project(number string) uint {
	val := uint(0)
	for _, c := range number {
		val += 0x1 << uint(c-'a')
	}
	return val
}

func contains(a, b uint) bool {
	return a&b == b
}

func missing(a, b uint) uint {
	return uint(bits.OnesCount(a ^ b))
}

func getValue(projected uint, numbers []uint) uint {
	for i, n := range numbers {
		if n == projected {
			return uint(i)
		}
	}
	return 0
}

func printNumbers(numbers []uint) {
	for i, n := range numbers {
		fmt.Printf("%d -> %b\n", i, n)
	}
	fmt.Println("")
}

func ShowD08() {
	file, _ := os.Open("../../input/day_08.test")
	defer file.Close()

	scanner := bufio.NewScanner(file)
	lines := []string{}

	for scanner.Scan() {
		lines = append(lines, scanner.Text())
	}

	acc := uint(0)
	for _, line := range lines {
		parts := strings.Split(line, " | ")

		input, output := parts[0], parts[1]

		inputNumbers := strings.Split(input, " ")
		projectedNumbers := make(map[uint]bool, len(inputNumbers))
		for _, n := range inputNumbers {
			switch len(n) {
			case 2, 3, 4, 7:
				projectedNumbers[project(n)] = true
			}
		}

		for _, n := range strings.Split(output, " ") {
			if projectedNumbers[project(n)] {
				acc += 1
			}
		}
	}

	fmt.Printf("- Part 1: %d\n", acc)

	total := uint(0)

	for _, line := range lines {
		parts := strings.Split(line, " | ")

		input, output := parts[0], parts[1]

		inputNumbers := strings.Split(input, " ")
		numbers := make([]uint, 10)
		length5 := []uint{}
		length6 := []uint{}

		for _, n := range inputNumbers {
			switch len(n) {
			case 2:
				numbers[1] = project(n)
			case 3:
				numbers[7] = project(n)
			case 4:
				numbers[4] = project(n)
			case 7:
				numbers[8] = project(n)
			case 5:
				length5 = append(length5, project(n))
			case 6:
				length6 = append(length6, project(n))
			}
		}

		// 9 contains the bits of 4
		// there are only 2 digits that use 6 segments
		nine := uint(0)
		for i, n := range length6 {
			if contains(n, numbers[4]) {
				nine = n
				length6 = append(length6[:i], length6[i+1:]...)
				break
			}
		}
		numbers[9] = nine

		// number 2 and 9 have 3 different segments
		two := uint(0)
		// number 7 and 5 have 4 different segments
		five := uint(0)
		three := uint(0)
		for _, n := range length5 {
			if missing(n, numbers[9]) == 3 {
				two = n
			} else if missing(n, numbers[7]) == 4 {
				five = n
			} else {
				three = n
			}
		}

		numbers[2] = two
		numbers[3] = three
		numbers[5] = five

		// number 6 contains 5
		six := uint(0)
		zero := uint(0)
		for _, n := range length6 {
			if contains(n, numbers[5]) {
				six = n
			} else {
				zero = n
			}
		}

		numbers[0] = zero
		numbers[6] = six

		outputNumbers := strings.Split(output, " ")

		outputVal := uint(0)

		for i := 0; i < len(outputNumbers); i++ {
			digit := outputNumbers[len(outputNumbers)-1-i]
			//fmt.Printf("digit: %s segment: %d\n", digit, getValue(project(digit), numbers))
			outputVal += uint(math.Pow10(i)) * getValue(project(digit), numbers)
		}

		printNumbers(numbers)
		//fmt.Printf("line: %s\nline total: %d\n", line, outputVal)
		total += outputVal
	}

	fmt.Printf("- Part 2: %d\n", total)
}
