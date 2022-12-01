package solutions

import (
	"fmt"
	"io/ioutil"
	"testing"
)

func TestDay01_01(t *testing.T) {
	input, err := ioutil.ReadFile("../../../input/day_01.test")
	if ans := day_01_01(string(input)); ans != 24000 {
		t.Errorf("incorrect answer %d", ans)
	}
}
