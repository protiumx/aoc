package solutions

func uniqueSubStringIndex(input string, size int) int {
	// assuming input is a-z
	lastSeen := [26]int{}
	for i := 0; i < 26; i++ {
		lastSeen[i] = -1
	}

	window := size
	nextWindow := window - 1
	for i := 0; i < len(input); i++ {
		charIndex := int(input[i] - 'a')
		skipTo := lastSeen[charIndex] + window
		if skipTo > nextWindow {
			// char was previously seen within the last window
			nextWindow = skipTo
		} else if nextWindow <= i { // reached a window-size group of unique chars
			return i + 1
		}
		lastSeen[charIndex] = i
	}
	return -1
}

func Day_06_01(input string) int {
	return uniqueSubStringIndex(input, 4)
}

func Day_06_02(input string) int {
	return uniqueSubStringIndex(input, 14)
}
