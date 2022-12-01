package main

import (
	"fmt"
	"io/ioutil"

	"protiumx.dev/aoc/solutions"
)

func main() {
	input, _ := ioutil.ReadFile("../../input/day_01.in")
	fmt.Printf("day_01 answer: %d\n", solutions.Day_01_01(string(input)))
}
