package solutions

import (
	"fmt"
	"regexp"
	"sort"
	"strconv"
	"strings"
)

func calculateMonkeyBusiness(input string, maxRounds, reliefFactor int64) int64 {
	type monkeyData struct {
		items               []int64
		operation           string
		testDivisibleBy     int64
		numberOfInspections int
		consequenceThrow    int
		alternativeThrow    int
	}

	monkeys := []*monkeyData{}
	monekyRoundDilimiter := regexp.MustCompile(`Monkey \d:\n`)
	numberRegex := regexp.MustCompile(`\d+`)

	for _, data := range monekyRoundDilimiter.Split(input, -1) {
		if data == "" {
			continue
		}

		current := monkeyData{items: []int64{}, numberOfInspections: 0}

		info := strings.Split(data, "\n")
		items := numberRegex.FindAllString(info[0], -1)
		for _, item := range items {
			n, _ := strconv.Atoi(item)
			current.items = append(current.items, int64(n))
		}

		operationIndex := strings.Index(info[1], "=") + 1
		current.operation = strings.TrimSpace(info[1][operationIndex:])

		current.testDivisibleBy, _ = strconv.ParseInt(numberRegex.FindString(info[2]), 10, 64)
		current.consequenceThrow, _ = strconv.Atoi(numberRegex.FindString(info[3]))
		current.alternativeThrow, _ = strconv.Atoi(numberRegex.FindString(info[4]))

		monkeys = append(monkeys, &current)
	}

	// all multipliers and divisors are prime numbers
	// calculate lowest common multiplier
	lcm := int64(1)
	for _, m := range monkeys {
		lcm *= m.testDivisibleBy
	}

	for round := int64(0); round < maxRounds; round++ {
		for _, m := range monkeys {
			for _, worryLevel := range m.items {
				op := strings.ReplaceAll(m.operation, "old", fmt.Sprintf("%d", worryLevel))
				opParts := strings.Fields(op)

				l, _ := strconv.ParseInt(opParts[0], 10, 64)
				r, _ := strconv.ParseInt(opParts[2], 10, 64)

				switch opParts[1] {
				case "*":
					worryLevel = l * r
				case "+":
					worryLevel = l + r
				}

				if reliefFactor == 1 {
					// modulo congruence is preserved for any multiplication or addition operations
					// If a≡b(mod m), then a+c≡b+c(mod m)
					// If a≡b(mod m), then ax≡bx(mod mx)
					worryLevel %= lcm
				}
				worryLevel /= reliefFactor

				throwTo := m.consequenceThrow
				if worryLevel%m.testDivisibleBy != 0 {
					throwTo = m.alternativeThrow
				}

				monkeys[throwTo].items = append(monkeys[throwTo].items, worryLevel)
				m.numberOfInspections++
			}

			m.items = []int64{}
		}
	}

	sort.SliceStable(monkeys, func(i, j int) bool {
		return monkeys[i].numberOfInspections > monkeys[j].numberOfInspections
	})

	return int64(monkeys[0].numberOfInspections) * int64(monkeys[1].numberOfInspections)
}

func Day_11_01(input string) int64 {
	return calculateMonkeyBusiness(input, 20, 3)
}

func Day_11_02(input string) int64 {
	return calculateMonkeyBusiness(input, 10000, 1)
}
