package solutions

import (
	"fmt"
)

// bit at position 0 is the right wall. left wall is at position 9, technically overflows the byte
// each rock is described from bottom to top
var (
	// ####
	// ....
	// ....
	// ....
	rock_a [4]byte = [4]byte{
		0b00111100,
		0b00000000,
		0b00000000,
		0b00000000,
	}

	// .#.
	// ###
	// .#.
	// ...
	rock_b [4]byte = [4]byte{
		0b00010000,
		0b00111000,
		0b00010000,
		0b00000000,
	}

	// ..#
	// ..#
	// ###
	// ...
	rock_c [4]byte = [4]byte{
		0b00111000,
		0b00001000,
		0b00001000,
		0b00000000,
	}

	// #
	// #
	// #
	// #
	rock_d [4]byte = [4]byte{
		0b00100000,
		0b00100000,
		0b00100000,
		0b00100000,
	}

	// ##
	// ##
	// ..
	// ..
	rock_e [4]byte = [4]byte{
		0b00110000,
		0b00110000,
		0b00000000,
		0b00000000,
	}
)

// order follows the order in the problem description
var rock_patterns = [5][4]byte{
	rock_a,
	rock_b,
	rock_c,
	rock_d,
	rock_e,
}

func Day_17(input string, simulation_count int64) int64 {
	// |.......
	const left_wall = byte(1 << 7)
	// .......|
	const right_wall = byte(1 << 1)

	cave := [10_000]byte{}
	height := int64(0)
	var falling_rock [4]byte

	vertical_pos := int64(3)
	rocks_count := int64(0)
	tick := int64(0)

	spawn := func() int64 {
		rock_index := rocks_count % 5
		// copy array by value
		falling_rock = rock_patterns[rock_index]
		rocks_count++
		vertical_pos = height + 4 // the tallest rock is 4 rows tall
		return rock_index
	}

	move_bit := func(bitset_row *byte, left bool) {
		if left {
			*bitset_row <<= 1
		} else {
			*bitset_row >>= 1
		}
	}

	// check if a wall bit is in all the rock bits
	hits_wall := func(wallset byte) bool {
		return (falling_rock[0]|falling_rock[1]|falling_rock[2]|falling_rock[3])&wallset != 0
	}

	// check if any of the current rock bits overlaps with another rock in the cave
	overlaps := func(vertical_pos int64) bool {
		return (falling_rock[0]&cave[vertical_pos] |
			falling_rock[1]&cave[vertical_pos+1] |
			falling_rock[2]&cave[vertical_pos+2] |
			falling_rock[3]&cave[vertical_pos+3]) != 0
	}

	// add bits of the current rock to the cave
	rest_rock := func(vertical_pos int64) {
		cave[vertical_pos] |= falling_rock[0]
		cave[vertical_pos+1] |= falling_rock[1]
		cave[vertical_pos+2] |= falling_rock[2]
		cave[vertical_pos+3] |= falling_rock[3]
	}

	// find the next bit row that is empty
	get_heighest := func(highest int64) int64 {
		i := highest
		for cave[i] != 0 {
			i += 1
		}
		return i - 1
	}

	// find the next occupied row from the current height
	get_ceiling := func() [7]int64 {
		ret := [7]int64{}
		for i := 7; i >= 1; i-- {
			col := byte(1 << i)
			h := height
			for ; h >= 0; h-- {
				// fmt.Printf("checking %08b against %08b\n", col, cave[h])
				if cave[h]&col != 0 {
					// fmt.Println("found foor", h, height)
					break
				}
			}

			ret[i-1] = height - h
		}
		return ret
	}

	cache := map[string][2]int64{}

	last_rock_index := spawn()
	vertical_pos = 3
	virtual_height := int64(0)
	cycle_found := false
	for rocks_count < simulation_count {
		movement_index := tick % int64(len(input))
		is_left := input[movement_index] == '<'
		wall := left_wall
		if !is_left {
			wall = right_wall
		}

		if !hits_wall(wall) {
			for i := range falling_rock {
				move_bit(&falling_rock[i], is_left)
			}
		}

		if overlaps(vertical_pos) {
			// restore last position
			for i := range falling_rock {
				move_bit(&falling_rock[i], !is_left)
			}
		}

		if vertical_pos == 0 || overlaps(vertical_pos-1) {
			rest_rock(vertical_pos)
			height = get_heighest(height)
			last_rock_index = spawn()

			ceiling := get_ceiling()
			key := fmt.Sprintf("%v-%d-%d", ceiling, last_rock_index, movement_index)
			if data, ok := cache[key]; !cycle_found && ok {
				cycle_found = true
				fmt.Println("found cycle", key, data)

				rocks_per_cycle := rocks_count - data[0]
				height_per_cycle := height - data[1]
				remaining_rocks := simulation_count - rocks_count
				remaining_cycles := remaining_rocks / rocks_per_cycle

				virtual_height = remaining_cycles * height_per_cycle
				rocks_count += rocks_per_cycle * remaining_cycles
			} else {
				cache[key] = [2]int64{rocks_count, height}
			}

		} else {
			vertical_pos -= 1
		}

		tick++
	}

	// for i := 20; i >= 0; i-- {
	// 	r := fmt.Sprintf("%08b\n", cave[i])
	// 	r = strings.ReplaceAll(r, "0", ".")
	// 	r = strings.ReplaceAll(r, "1", "#")
	// 	fmt.Println(r)
	// }
	// Missing 2 units for part be for some reason
	return height + virtual_height + 1
}
