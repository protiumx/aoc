package solutions

import "testing"

func TestDay17_01(t *testing.T) {
	input := ">>><<><>><<<>><>>><<<>>><<<><<<>><>><<>>"
	if ans := Day_17(input, 2023); ans != 3068 {
		t.Errorf("wrong answer %d, wants 3068", ans)
	}
}
func TestDay17_02(t *testing.T) {
	input := ">>><<><>><<<>><>>><<<>>><<<><<<>><>><<>>"
	if ans := Day_17(input, 1_000_000_000_000); ans != 1514285714288 {
		t.Errorf("wrong answer %d, wants 1514285714288", ans)
	}
}
