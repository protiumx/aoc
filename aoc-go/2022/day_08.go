package solutions

import (
	"image"
	"strings"
)

var directions = [4]image.Point{
	{1, 0},
	{0, 1},
	{-1, 0},
	{0, -1},
}

func process(input string) (int, int) {
	lines := strings.Split(input, "\n")
	// each point in the map has the size of its tree
	// a point is out of bounds if it doesn't exist in the map
	treesMap := make(map[image.Point]int)
	for r, line := range lines {
		for c, ch := range line {
			treesMap[image.Point{r, c}] = int(ch - '0')
		}
	}

	visibleCount := 0
	maxScenicScore := 0
	for currentPosition, currentTree := range treesMap {
		isVisible, score := 0, 1

		for _, dir := range directions {
			// for each direction visit all positions until the edges
			for i := 1; ; i++ {
				lookAt := currentPosition.Add(dir.Mul(i))
				if neighborTree, ok := treesMap[lookAt]; !ok {
					// reached a border without finding a taller tree
					isVisible = 1
					score *= i - 1
					break
				} else if neighborTree >= currentTree {
					score *= i
					break
				}
			}
		}

		visibleCount += isVisible
		if score > maxScenicScore {
			maxScenicScore = score
		}
	}

	return visibleCount, maxScenicScore
}

func Day_08_01(input string) int {
	count, _ := process(input)
	return count
}

func Day_08_02(input string) int {
	_, score := process(input)
	return score
}
