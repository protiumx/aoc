package solutions

import "testing"

func TestDay09_01(t *testing.T) {
	input := `R 4
U 4
L 3
D 1
R 4
D 1
L 5
R 2`

	if ans := Day_09_01(input); ans != 13 {
		t.Errorf("wrong answer %d", ans)
	}
}

func TestDay09_02(t *testing.T) {
	input := `R 5
U 8
L 8
D 3
R 17
D 10
L 25
U 20`

	if ans := tailPositions(input, 10); ans != 36 {
		t.Errorf("wrong answer %d", ans)
	}
}
