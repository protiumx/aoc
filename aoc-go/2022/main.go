package solutions

import (
	"fmt"
	"io/ioutil"
)

func main() {
	input, _ := ioutil.ReadFile("../../input/day_01.in")
	// fmt.Printf("day_01.1 answer: max calories %d\n", Day_01_01(string(input)))
	// fmt.Printf("day_01.2 answer: sum of top 3 calories %d\n", Day_01_02(string(input)))
	//
	// input, _ = ioutil.ReadFile("../../input/day_02.in")
	// fmt.Printf("day_02.1 answer: game points %d\n", Day_02_01(string(input)))
	// fmt.Printf("day_02.2 answer: game points %d\n", Day_02_02(string(input)))
	//
	// input, _ = ioutil.ReadFile("../../input/day_03.in")
	// fmt.Printf("day_03.1 answer: total priority %d\n", Day_03_01(string(input)))
	// fmt.Printf("day_03.2 answer: common in 3 groups  %d\n", Day_03_02(string(input)))
	//
	// input, _ = ioutil.ReadFile("../../input/day_04.in")
	// fmt.Printf("day_04.1 answer: pairs contained %d\n", Day_04_01(string(input)))
	// fmt.Printf("day_04.2 answer: pairs overlapped %d\n", Day_04_02(string(input)))
	//
	// input, _ = ioutil.ReadFile("../../input/day_05.in")
	// fmt.Printf("day_05.1 answer: pairs contained %s\n", Day_05_01(string(input)))
	// fmt.Printf("day_05.2 answer: pairs overlapped %s\n", Day_05_02(string(input)))
	//
	// input, _ = ioutil.ReadFile("../../input/day_06.in")
	// fmt.Printf("day_06.1 answer: start of packet at %d\n", Day_06_01(string(input)))
	// fmt.Printf("day_06.2 answer: pairs overlapped %d\n", Day_06_02(string(input)))
	//
	// input, _ = ioutil.ReadFile("../../input/day_07.in")
	// fmt.Printf("day_07.1 answer: total size of directories %d\n", Day_07_01(string(input)))
	// fmt.Printf("day_07.2 answer: size of directory to delete %d\n", Day_07_02(string(input)))
	//
	// input, _ = ioutil.ReadFile("../../input/day_08.in")
	// fmt.Printf("day_08.1 answer: total visible trees %d\n", Day_08_01(string(input)))
	// fmt.Printf("day_08.2 answer: max score %d\n", Day_08_02(string(input)))
	//
	// input, _ = ioutil.ReadFile("../../input/day_09.in")
	// fmt.Printf("day_09.1 answer: total unique tail positions %d\n", Day_09_01(string(input)))
	// fmt.Printf("day_09.2 answer: total unique tail positions %d\n", Day_09_02(string(input)))
	//
	// input, _ = ioutil.ReadFile("../../input/day_10.in")
	// fmt.Printf("day_10.1 answer: total signal strength %d\n", Day_10_01(string(input)))
	// fmt.Printf("day_10.2 answer: max score \n%s\n", Day_10_02(string(input)))
	//
	// input, _ = ioutil.ReadFile("../../input/day_11.in")
	// fmt.Printf("day_11.1 answer: monkey business %d\n", Day_11_01(string(input)))
	// fmt.Printf("day_11.2 answer: crazy monkey business %d\n", Day_11_02(string(input)))
	//
	// input, _ = ioutil.ReadFile("../../input/day_12.in")
	// fmt.Printf("day_12.1 answer: minimum steps %d\n", Day_12_01(string(input)))
	// fmt.Printf("day_12.2 answer: minimum steps to 'a' position %d\n", Day_12_02(string(input)))
	//
	// input, _ = ioutil.ReadFile("../../input/day_13.in")
	// fmt.Printf("day_13.1 answer: count of ordered pairs indexes %d\n", Day_13_01(string(input)))
	// fmt.Printf("day_13.2 answer: decoder key %d\n", Day_13_02(string(input)))
	//
	// input, _ = ioutil.ReadFile("../../input/day_14.in")
	// fmt.Printf("day_14.1 answer: dropped sand %d\n", Day_14_01(string(input)))
	// fmt.Printf("day_14.2 answer: dropped sand %d\n", Day_14_02(string(input)))

	// input, _ = ioutil.ReadFile("../../input/day_15.in")
	// fmt.Printf("day_15.1 answer: covered positions at row 2000000 %d\n", Day_15_01(string(input), 2000000))
	// fmt.Printf("day_15.2 answer: tuning frequency is %d\n", Day_15_02(string(input), 4000000))

	// input, _ = ioutil.ReadFile("../../input/day_16.in")
	// fmt.Printf("day_16.1 answer: covered positions at row 2000000 %d\n", Day_16_01(string(input)))
	// fmt.Printf("day_16.2 answer: tuning frequency is %d\n", Day_16_02(string(input), 4000000))

	// input, _ = ioutil.ReadFile("../../input/day_17.in")
	// fmt.Printf("day_17.1 answer: high after 2023 rocks %d\n", Day_17(string(input), 2023))
	// fmt.Printf("day_17.2 answer: high after 1000000000000 rocks %d\n", Day_17(
	// 	string(input), 1_000_000_000_000))

	input, _ = ioutil.ReadFile("../../input/day_18.in")
	fmt.Printf("day_18.1 answer: lava surface area is %d\n", Day_18_01(string(input)))
	fmt.Printf("day_18.2 answer: exterior surface area is %d\n", Day_18_02(string(input)))
}
