package solutions

import (
	"io/ioutil"
	"testing"
)

func TestDay08_01(t *testing.T) {
	input := `30373
25512
65332
33549
35390`

	if ans := Day_08_01(input); ans != 21 {
		t.Errorf("wrong answer %d", ans)
	}
}

func TestDay08_02(t *testing.T) {
	input := `30373
25512
65332
33549
35390`

	if ans := Day_08_02(input); ans != 8 {
		t.Errorf("wrong answer %d", ans)
	}
}

func BenchmarkDay08_01(b *testing.B) {
	input, _ := ioutil.ReadFile("../../../input/day_08.in")
	Day_08_01(string(input))
}
