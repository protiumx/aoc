package solutions

import (
	"fmt"
	"regexp"
	"strconv"
	"strings"
)

type Valve struct {
	name       string
	flow_rate  int
	neightbors []string
}

func Day_16_01(input string) int {
	const max_time = 30
	const start_valve = "AA"

	r := regexp.MustCompile(`Valve (\w+)\s.*=(\d+).*valves? (.+)`)

	valves := []Valve{}
	valves_ids := map[string]int{}
	positve_flow_valves := []int{}
	current_valve_index := 0

	for _, line := range strings.Split(input, "\n") {
		match := r.FindAllStringSubmatch(line, -1)
		name := match[0][1]
		flow_rate, _ := strconv.Atoi(match[0][2])
		neightbors := strings.Split(match[0][3], ", ")
		valves = append(valves, Valve{name, flow_rate, neightbors})
		valves_ids[name] = current_valve_index
		if flow_rate > 0 || name == "AA" {
			positve_flow_valves = append(positve_flow_valves, current_valve_index)
		}

		current_valve_index++
	}

	// for i, v := range valves {
	// 	fmt.Printf("node %s at %d\n", v.name, i)
	// }

	n_valves := len(valves)
	// init distances with a large value
	distances := make([][]int, n_valves)
	for i := 0; i < n_valves; i++ {
		distances[i] = make([]int, n_valves)
	}

	for i := 0; i < n_valves; i++ {
		for j := 0; j < n_valves; j++ {
			if i == j {
				distances[i][j] = 0
			} else {
				distances[i][j] = 1e6
			}
		}

		// each valve has a cost of 1 minute to reach their neighbors
		for _, n := range valves[i].neightbors {
			nid := valves_ids[n]
			distances[i][nid] = 1
			distances[nid][i] = 1
		}
	}
	fmt.Println(valves)

	// run Floyd-Warshall
	for i := 0; i < n_valves; i++ {
		for j := 0; j < n_valves; j++ {
			for k := 0; k < n_valves; k++ {
				distances[i][j] = min(distances[i][j], distances[i][k]+distances[k][j])
			}
		}
	}

	// for i, r := range distances {
	// 	for j, c := range r {
	// 		fmt.Printf("distance from %s to %s is %d\n", valves[i].name, valves[j].name, c)
	// 	}
	// }
	// memoize opened valves at certain minute { time: bitmask }
	// use a bit mas assuming we don't have more than 32 positive flow valves.
	// input has 15 positive flow valves
	cache := map[string]int{}

	total := find_max_flow_rate(
		valves,
		30,
		valves_ids["AA"],
		0,
		distances,
		positve_flow_valves,
		cache,
	)

	return total
}

func find_max_flow_rate(
	valves []Valve,
	time, valve_id, opened_valves int,
	distances [][]int,
	positve_flow_valves []int,
	cache map[string]int,
) int {
	// key := fmt.Sprintf("%d:%d:%10b", time, valve_id, opened_valves)
	// fmt.Printf("valve %s time: %d opened: %010b\n", valves[valve_id].name, time, opened_valves)
	// if flow, ok := cache[key]; ok {
	// 	return flow
	// }

	if time < 1 {
		return 0
	}

	max_flow := 0
	for i, next_valve := range positve_flow_valves {
		if opened_valves&(1<<i) > 0 {
			continue
		}

		next_time := time - distances[valve_id][next_valve] - 1
		if next_time < 0 {
			continue
		}

		next_flow := next_time * valves[next_valve].flow_rate
		max_flow = max(max_flow, next_flow+find_max_flow_rate(
			valves,
			next_time,
			next_valve,
			opened_valves|(1<<i),
			distances,
			positve_flow_valves,
			cache,
		))
	}

	// cache[key] = max_flow

	return max_flow
}
