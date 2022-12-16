package solutions

import (
	"image"
	"math"
	"regexp"
	"sort"
	"strconv"
	"strings"
)

type Sensor struct {
	pos     image.Point
	beacon  image.Point
	radious int // coverage from sensor position to nearest beacon
}

func manhattanDistance(x1, y1, x2, y2 int) int {
	return int(math.Abs(float64(x1-x2)) + math.Abs(float64(y1-y2)))
}

func parseSensors(input string) ([]Sensor, int, int) {
	lines := strings.Split(input, "\n")

	r := regexp.MustCompile(`-?\d+`)
	min_x, max_x := math.MaxInt, 0
	sensors := []Sensor{}

	for _, line := range lines {
		data := r.FindAllString(line, -1)
		sx, _ := strconv.Atoi(data[0])
		sy, _ := strconv.Atoi(data[1])
		bx, _ := strconv.Atoi(data[2])
		by, _ := strconv.Atoi(data[3])

		s := Sensor{image.Pt(sx, sy), image.Pt(bx, by), manhattanDistance(sx, sy, bx, by)}
		// boundaries of the sensor's area
		min_x = min(min_x, s.pos.X-s.radious)
		max_x = max(max_x, s.pos.X+s.radious)
		sensors = append(sensors, s)
	}

	return sensors, min_x, max_x
}

func Day_15_01(input string, checkRow int) int {
	sensors, min_x, max_x := parseSensors(input)
	total := 0

	for x := min_x; x <= max_x; x++ {
		for _, sensor := range sensors {
			if x == sensor.beacon.X && checkRow == sensor.beacon.Y {
				// we now sensor is covering this beacon
				break
			}

			// check x,checkRow are covered by the sensor
			if manhattanDistance(x, checkRow, sensor.pos.X, sensor.pos.Y) <= sensor.radious {
				total++
				break
			}
		}
	}

	return total
}

// Max area is the side of a square
func Day_15_02(input string, maxArea int) int {
	sensors, _, _ := parseSensors(input)
	currentPosition := image.Pt(0, 0)
	currentSensor := Sensor{}

	sort.Slice(sensors, func(i, j int) bool { return sensors[i].radious > sensors[j].radious })

	for {
		isCoveredPosition := false

		// find sensor that covers the current position
		for _, sensor := range sensors {
			isCoveredPosition = manhattanDistance(sensor.pos.X, sensor.pos.Y, currentPosition.X, currentPosition.Y) <= sensor.radious
			if isCoveredPosition {
				currentSensor = sensor
				break
			}
		}

		if !isCoveredPosition {
			// found an uncovered position
			break
		}

		// move to the nearest not covered position
		distance := manhattanDistance(currentSensor.pos.X, currentSensor.pos.Y, currentPosition.X, currentPosition.Y)
		skip := currentSensor.radious - distance + 1
		if currentPosition.X+skip > maxArea {
			// next position is out of bounds. continue to the next row
			currentPosition.X = 0
			currentPosition.Y++
		} else {
			currentPosition.X += skip
		}
	}

	return currentPosition.X*4000000 + currentPosition.Y
}
