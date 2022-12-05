package solutions

import "testing"

func TestDay05_01(t *testing.T) {
	input := `    [D]    
[N] [C]    
[Z] [M] [P]
 1   2   3 

move 1 from 2 to 1
move 3 from 1 to 3
move 2 from 2 to 1
move 1 from 1 to 2`

	if ans := Day_05_01(input); ans != "CMZ" {
		t.Errorf("wrong answer %s", ans)
	}
}

func TestDay05_02(t *testing.T) {
	input := `    [D]    
[N] [C]    
[Z] [M] [P]
1   2   3 

move 1 from 2 to 1
move 3 from 1 to 3
move 2 from 2 to 1
move 1 from 1 to 2`

	if ans := Day_05_02(input); ans != "MCD" {
		t.Errorf("wrong answer %s", ans)
	}
}
