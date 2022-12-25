package solutions

import "testing"

func TestDay18_01(t *testing.T) {
	input := `2,2,2
1,2,2
3,2,2
2,1,2
2,3,2
2,2,1
2,2,3
2,2,4
2,2,6
1,2,5
3,2,5
2,1,5
2,3,5`
	if ans := Day_18_01(input); ans != 64 {
		t.Errorf("wrong answer %d wants 64", ans)
	}
}

func TestDay18_02(t *testing.T) {
	input := `2,2,2
  1,2,2
  3,2,2
  2,1,2
  2,3,2
  2,2,1
  2,2,3
  2,2,4
  2,2,6
  1,2,5
  3,2,5
  2,1,5
  2,3,5`
	if ans := Day_18_02(input); ans != 58 {
		t.Errorf("wrong answer %d wants 58", ans)
	}
}
