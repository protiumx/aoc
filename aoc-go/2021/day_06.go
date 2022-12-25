package solutions

import (
	"fmt"
	"io/ioutil"
	"strconv"
	"strings"
)

func ShowD06() {
	content, _ := ioutil.ReadFile("../../input/day_06.test")
	data := []uint64{}
	for _, n := range strings.Split(strings.Replace(string(content), "\n", "", 1), ",") {
		if n == "" {
			continue
		}
		f, _ := strconv.Atoi(n)
		data = append(data, uint64(f))
	}
	count := [9]uint64{}
	for _, n := range data {
		count[n] += 1
	}
	p1 := count
	p2 := count
	fmt.Printf("- Part 1: %d\n", simulate(80, p1))
	fmt.Printf("- Part 1: %d\n", simulate(256, p2))
}

func simulate(days int, count [9]uint64) uint64 {
	for d := 0; d < days; d++ {
		last := count[0]
		count[0] = 0
		for dc := 1; dc < 9; dc++ {
			count[dc-1] += count[dc]
			count[dc] = 0
		}
		count[8] = last
		count[6] += last
	}

	total := uint64(0)
	for _, c := range count {
		total += c
	}
	return total
}
