package solutions

import "testing"

const testInput13 = `[1,1,3,1,1]
[1,1,5,1,1]

[[1],[2,3,4]]
[[1],4]

[9]
[[8,7,6]]

[[4,4],4,4]
[[4,4],4,4,4]

[7,7,7,7]
[7,7,7]

[]
[3]

[[[]]]
[[]]

[1,[2,[3,[4,[5,6,7]]]],8,9]
[1,[2,[3,[4,[5,6,0]]]],8,9]`

func TestDay13_01(t *testing.T) {
	if ans := Day_13_01(testInput13); ans != 13 {
		t.Errorf("wrong answer %d, wants 13", ans)
	}
}

func TestDay13_02(t *testing.T) {
	if ans := Day_13_02(testInput13); ans != 140 {
		t.Errorf("wrong answer %d, wants 140", ans)
	}
}
