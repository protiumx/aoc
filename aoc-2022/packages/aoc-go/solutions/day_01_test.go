package solutions

import (
	"io/ioutil"
	"testing"
)

func TestDay01_01(t *testing.T) {
	input, _ := ioutil.ReadFile("../../../input/day_01.test")
	if ans := Day_01_01(string(input)); ans != 24000 {
		t.Errorf("incorrect answer %d", ans)
	}
}

func TestDay01_02(t *testing.T) {
	input, _ := ioutil.ReadFile("../../../input/day_01.test")
	if ans := Day_01_02(string(input)); ans != 45000 {
		t.Errorf("incorrect answer %d", ans)
	}
}
