package solutions

import "testing"

func TestDay14_01(t *testing.T) {
	input := `498,4 -> 498,6 -> 496,6
503,4 -> 502,4 -> 502,9 -> 494,9`

	if ans := Day_14_01(input); ans != 24 {
		t.Errorf("wrong answer %d, wants 24", ans)
	}
}

func TestDay14_02(t *testing.T) {
	input := `498,4 -> 498,6 -> 496,6
503,4 -> 502,4 -> 502,9 -> 494,9`

	if ans := Day_14_02(input); ans != 93 {
		t.Errorf("wrong answer %d, wants 93", ans)
	}
}
