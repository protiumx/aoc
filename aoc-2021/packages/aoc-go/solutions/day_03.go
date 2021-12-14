package solutions

import (
	"bufio"
	"fmt"
	"os"
)

func day03_partOne() uint32 {
	file, _ := os.Open("../../input/day_03.test")
	defer file.Close()

	scanner := bufio.NewScanner(file)
	lineCount := uint(0)
	var columnSums []uint
	for scanner.Scan() {
		line := scanner.Text()
		if columnSums == nil {
			columnSums = make([]uint, len(line))
		}
		for i, c := range line {
			columnSums[i] += uint(c - '0')
		}
		lineCount += 1
	}
	gamaRate := uint32(0)
	for _, s := range columnSums {
		gamaRate = gamaRate << 1
		if s > lineCount/2 {
			gamaRate += 1
		}
	}
	colShift := 32 - len(columnSums)
	return gamaRate * (^gamaRate << colShift >> colShift)
}

func day03_partTwo() int {
	file, _ := os.Open("../../input/day_03.test")
	defer file.Close()

	scanner := bufio.NewScanner(file)
	data := [][]int{}
	for scanner.Scan() {
		line := scanner.Text()
		lineData := make([]int, len(line))
		for i, c := range line {
			lineData[i] = int(c - '0')
		}
		data = append(data, lineData)
	}
	cols := len(data[0])
	oxygenData := data

	for i := 0; i < cols; i++ {
		columnSum := 0
		dataRows := len(oxygenData)
		for row := 0; row < dataRows; row++ {
			columnSum += oxygenData[row][i]
		}
		filterOxygen := [][]int{}
		mostCommon := 1
		if columnSum < (dataRows+1)/2 {
			mostCommon = 0
		}
		for row := 0; row < dataRows; row++ {
			if oxygenData[row][i] == mostCommon {
				filterOxygen = append(filterOxygen, oxygenData[row])
			}
		}
		oxygenData = filterOxygen
		if len(oxygenData) == 1 {
			break
		}
	}

	co2Data := data
	for i := 0; i < cols; i++ {
		columnSum := 0
		dataRows := len(co2Data)
		for row := 0; row < dataRows; row++ {
			columnSum += co2Data[row][i]
		}
		filterCo2 := [][]int{}
		mostCommon := 1
		if columnSum < (dataRows+1)/2 {
			mostCommon = 0
		}
		for row := 0; row < dataRows; row++ {
			if co2Data[row][i] != mostCommon {
				filterCo2 = append(filterCo2, co2Data[row])
			}
		}
		co2Data = filterCo2
		if len(co2Data) == 1 {
			break
		}
	}

	oxygenRate := 0
	co2Rate := 0
	for i := 0; i < cols; i++ {
		oxygenRate = (oxygenRate << 1) + oxygenData[0][i]
		co2Rate = (co2Rate << 1) + co2Data[0][i]
	}
	return oxygenRate * co2Rate
}

func ShowD03() {
	fmt.Printf("- Answer part one: %d\n", day03_partOne())
	fmt.Printf("- Answer part two: %d\n", day03_partTwo())
}
