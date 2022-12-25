package solutions

import (
	"io/ioutil"
	"testing"
)

func TestDay_02_01(t *testing.T) {
	input, _ := ioutil.ReadFile("../../../input/day_02.test")
	if ans := Day_02_01(string(input)); ans != 15 {
		t.Errorf("wrong answer: %d", ans)
	}
}

func TestDay_02_02(t *testing.T) {
	input, _ := ioutil.ReadFile("../../../input/day_02.test")
	if ans := Day_02_02(string(input)); ans != 12 {
		t.Errorf("wrong answer: %d", ans)
	}
}
