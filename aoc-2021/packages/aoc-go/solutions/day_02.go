package solutions

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

func d02_partOne() int {
	file, _ := os.Open("../../input/day_02.in")
	defer file.Close()

	scanner := bufio.NewScanner(file)
	x := 0
	y := 0
	for scanner.Scan() {
		data := strings.Split(scanner.Text(), " ")
		value, _ := strconv.Atoi(data[1])
		switch data[0] {
		case "forward":
			x += value
		case "up":
			y -= value
		case "down":
			y += value
		}
	}
	return x * y
}

func d02_partTwo() int {
	file, _ := os.Open("../../input/day_02.in")
	defer file.Close()

	scanner := bufio.NewScanner(file)
	x := 0
	y := 0
	aim := 0
	for scanner.Scan() {
		data := strings.Split(scanner.Text(), " ")
		value, _ := strconv.Atoi(data[1])
		switch data[0] {
		case "forward":
			x += value
			y += aim * value
		case "up":
			aim -= value
		case "down":
			aim += value
		}
	}
	return x * y
}

func ShowD02() {
	fmt.Printf("- Answer part one: %d\n", d02_partOne())
	fmt.Printf("- Answer part two: %d\n", d02_partTwo())
}
