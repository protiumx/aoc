package main

import (
	"fmt"
	"io/ioutil"

	"protiumx.dev/aoc/solutions"
)

func main() {
	input, _ := ioutil.ReadFile("../../input/day_01.in")
	fmt.Printf("day_01.1 answer: max calories %d\n", solutions.Day_01_01(string(input)))
	fmt.Printf("day_01.2 answer: sum of top 3 calories %d\n", solutions.Day_01_02(string(input)))

	input, _ = ioutil.ReadFile("../../input/day_02.in")
	fmt.Printf("day_02.1 answer: game points %d\n", solutions.Day_02_01(string(input)))
	fmt.Printf("day_02.2 answer: game points %d\n", solutions.Day_02_02(string(input)))

	input, _ = ioutil.ReadFile("../../input/day_03.in")
	fmt.Printf("day_03.1 answer: game points %d\n", solutions.Day_03_01(string(input)))
	fmt.Printf("day_03.2 answer: game points %d\n", solutions.Day_03_02(string(input)))
}
