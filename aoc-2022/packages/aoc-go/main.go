package main

import (
	"fmt"
	"io/ioutil"

	"protiumx.dev/aoc/solutions"
)

func main() {
	input, _ := ioutil.ReadFile("../../input/day_01.in")
	fmt.Printf("day_01.1 answer: %d\n", solutions.Day_01_01(string(input)))
	fmt.Printf("day_01.2 answer: %d\n", solutions.Day_01_02(string(input)))
}
