package solutions

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

type Board struct {
	rows      [5][5]int
	completed bool
}

func NewBoard(matrix [5][5]int) *Board {
	rows := [5][5]int{}
	for i := range matrix {
		rows[i] = matrix[i]
	}
	return &Board{rows: rows, completed: false}
}

func (board *Board) mark(m int) bool {
	for i, row := range board.rows {
		for j, col := range row {
			if col == m {
				board.rows[i][j] = -1
				board.completed = board.check(i, j)
			}
		}
	}
	return board.completed
}

func (board *Board) check(row, col int) bool {
	rowSum := 0
	for _, n := range board.rows[row] {
		rowSum += n
	}
	if rowSum == -5 {
		return true
	}
	colSum := 0
	for _, row := range board.rows {
		colSum += row[col]
	}
	return colSum == -5
}

func (board *Board) sum() int {
	total := 0
	for _, row := range board.rows {
		for _, n := range row {
			if n == -1 {
				continue
			}
			total += n
		}
	}
	return total
}

func copyBoards(b []*Board) []*Board {
	c := []*Board{}
	for _, board := range b {
		c = append(c, NewBoard(board.rows))
	}
	return c
}

func ShowD04() {
	file, _ := os.Open("../../input/day_04.test")
	defer file.Close()

	scanner := bufio.NewScanner(file)
	scanner.Scan()

	linesas := strings.Split(scanner.Text(), ",")
	moves := make([]int, len(linesas))
	for i, n := range linesas {
		moves[i], _ = strconv.Atoi(n)
	}
	scanner.Scan()

	boards := []*Board{}
	for scanner.Scan() {
		board := [5][5]int{}
		for i := 0; i < 5; i++ {
			l := strings.Split(scanner.Text(), " ")
			if len(l) == 0 {
				break
			}

			row := [5]int{}
			col := 0
			for _, c := range l {
				if c == "" {
					continue
				}
				row[col], _ = strconv.Atoi(c)
				col++
			}
			board[i] = row
			scanner.Scan()
		}
		boards = append(boards, NewBoard(board))
	}

	p1 := copyBoards(boards)
loop:
	for _, m := range moves {
		for _, board := range p1 {
			if board.mark(m) {
				fmt.Printf("Part 1: %d\n", m*board.sum())
				break loop
			}
		}
	}
	lastSum := 0

	for _, m := range moves {
		for _, board := range boards {
			if !board.completed && board.mark(m) {
				lastSum = m * board.sum()
			}
		}
	}
	fmt.Printf("Part 2: %d\n", lastSum)
}
