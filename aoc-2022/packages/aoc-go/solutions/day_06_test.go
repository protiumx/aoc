package solutions

import "testing"

func TestDay06_01(t *testing.T) {
	tests := []struct {
		input    string
		expected int
	}{
		{"mjqjpqmgbljsphdztnvjfqwrcgsmlb", 7},
		{"bvwbjplbgvbhsrlpgdmjqwftvncz", 5},
		{"nppdvjthqldpwncqszvftbrmjlhg", 6},
		{"nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg", 10},
		{"zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw", 11},
	}

	for _, tt := range tests {
		if ans := Day_06_01(tt.input); ans != tt.expected {
			t.Errorf("wrong answer %d, expected %d", ans, tt.expected)
		}
	}
}

func TestDay06_02(t *testing.T) {
	tests := []struct {
		input    string
		expected int
	}{
		{"mjqjpqmgbljsphdztnvjfqwrcgsmlb", 19},
		{"bvwbjplbgvbhsrlpgdmjqwftvncz", 23},
		{"nppdvjthqldpwncqszvftbrmjlhg", 23},
		{"nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg", 29},
		{"zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw", 26},
	}

	for _, tt := range tests {
		if ans := Day_06_02(tt.input); ans != tt.expected {
			t.Errorf("wrong answer %d, expected %d", ans, tt.expected)
		}
	}
}
