package solutions

import (
	"io/ioutil"
	"testing"
)

func TestDay_03_01(t *testing.T) {
	input, _ := ioutil.ReadFile("../../../input/day_03.test")
	if ans := Day_03_01(string(input)); ans != 157 {
		t.Errorf("wrong answer a %d", ans)
	}
}

func TestDay_03_02(t *testing.T) {
	input := `vJrwpWtwJgWrhcsFMMfFFhFp
jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
PmmdzqPrVvPwwTWBwg
wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
ttgJtRGJQctTZtZT
CrZsJsPPZsGzwwsLwLmpwMDw`

	if ans := Day_03_02(string(input)); ans != 70 {
		t.Errorf("wrong answer a %d", ans)
	}
}
