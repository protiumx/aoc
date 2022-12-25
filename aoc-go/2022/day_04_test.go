package solutions

import "testing"

func TestDay04_01(t *testing.T) {
	input := `2-4,6-8
2-3,4-5
5-7,7-9
2-8,3-7
6-6,4-6
2-6,4-8`

	if ans := Day_04_01(input); ans != 2 {
		t.Errorf("wrong answer %d", ans)
	}
}
