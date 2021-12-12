package main

import (
	"bufio"
	"fmt"
	"io/ioutil"
	"os"
	"strconv"
	"strings"
)

func partOne() int {
	file, _ := os.Open("../../input/day_01.in")
	defer file.Close()
	scanner := bufio.NewScanner(file)
	count := 0
	scanner.Scan()
	prev, _ := strconv.Atoi(scanner.Text())
	for scanner.Scan() {
		d, _ := strconv.Atoi(scanner.Text())
		if d > prev {
			count++
		}
		prev = d
	}
	return count
}

func partTwo() int {
	content, _ := ioutil.ReadFile("../../input/day_01.in")
	lines := strings.Split(string(content), "\n")
	data := make([]int, len(lines))
	for i, l := range lines {
		data[i], _ = strconv.Atoi(l)
	}
	count := 0
	const window = 3
	currSum := 0
	prevSum := 0
	for i := 0; i < window; i++ {
		prevSum += data[i]
	}

	for i := 1; i < len(data)-2; i++ {
		for j := 0; j < window; j++ {
			currSum += data[i+j]
		}
		if currSum > prevSum {
			count++
		}
		prevSum = currSum
		currSum = 0
	}

	return count
}

func main() {
	fmt.Printf("Answer part one: %d\n", partOne())
	fmt.Printf("Answer part two: %d\n", partTwo())
}
