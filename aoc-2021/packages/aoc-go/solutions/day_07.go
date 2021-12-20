package solutions

import (
	"fmt"
	"io/ioutil"
	"math"
	"strconv"
	"strings"
)

func disatance(positions []int64, position int64, accumulate bool) int64 {
	total := int64(0)
	for _, p := range positions {
		d := int64(math.Abs(float64(p - position)))
		if accumulate {
			total += d * (d + 1) / 2
		} else {
			total += d
		}
	}
	return total
}

func ShowD07() {
	data, _ := ioutil.ReadFile("../../input/day_07.in")
	input := strings.TrimSpace(string(data))
	crabPositions := []int64{}
	for _, n := range strings.Split(input, ",") {
		parse, _ := strconv.Atoi(n)
		crabPositions = append(crabPositions, int64(parse))
	}

	min, max := int64(10000), int64(0)
	for _, p := range crabPositions {
		if p < min {
			min = p
		}
		if p > max {
			max = p
		}
	}

	minFuel := int64(math.MaxInt64)
	for i := min; i < max; i++ {
		current := disatance(crabPositions, i, false)
		if current < minFuel {
			minFuel = current
		}
	}
	fmt.Printf("- Part 1: %d\n", minFuel)

	minFuelAcc := int64(math.MaxInt64)
	for i := min; i < max; i++ {
		current := disatance(crabPositions, i, true)
		if current < minFuelAcc {
			minFuelAcc = current
		}
	}

	fmt.Printf("- Part 2: %d\n", minFuelAcc)
}
