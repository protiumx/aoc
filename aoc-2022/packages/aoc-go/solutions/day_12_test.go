package solutions

import "testing"

func TestDay12_01(t *testing.T) {
	input := `Sabqponm
abcryxxl
accszExk
acctuvwj
abdefghi`

	if ans := Day_12_01(input); ans != 31 {
		t.Errorf("wrong answer %d, wants 31", ans)
	}
}

func TestDay12_02(t *testing.T) {
	input := `Sabqponm
abcryxxl
accszExk
acctuvwj
abdefghi`

	if ans := Day_12_02(input); ans != 29 {
		t.Errorf("wrong answer %d, wants 29", ans)
	}
}
