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
	fmt.Printf("day_03.1 answer: total priority %d\n", solutions.Day_03_01(string(input)))
	fmt.Printf("day_03.2 answer: common in 3 groups  %d\n", solutions.Day_03_02(string(input)))

	input, _ = ioutil.ReadFile("../../input/day_04.in")
	fmt.Printf("day_04.1 answer: pairs contained %d\n", solutions.Day_04_01(string(input)))
	fmt.Printf("day_04.2 answer: pairs overlapped %d\n", solutions.Day_04_02(string(input)))

	input, _ = ioutil.ReadFile("../../input/day_05.in")
	fmt.Printf("day_05.1 answer: pairs contained %s\n", solutions.Day_05_01(string(input)))
	fmt.Printf("day_05.2 answer: pairs overlapped %s\n", solutions.Day_05_02(string(input)))

	input, _ = ioutil.ReadFile("../../input/day_06.in")
	fmt.Printf("day_06.1 answer: start of packet at %d\n", solutions.Day_06_01(string(input)))
	fmt.Printf("day_06.2 answer: pairs overlapped %d\n", solutions.Day_06_02(string(input)))
}
