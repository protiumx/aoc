#[derive(Debug, Clone)]
struct Board {
    rows: Vec<Vec<i32>>,
    completed: bool,
}

impl Board {
    fn parse(board: &[Vec<i32>]) -> Self {
        let mut rows: Vec<Vec<i32>> = Vec::new();
        for row in board {
            rows.push(Vec::from_iter(row.iter().cloned()));
        }

        Self {
            rows,
            completed: false,
        }
    }

    fn mark(&mut self, value: i32) -> bool {
        'out: for i in 0..5 {
            for j in 0..5 {
                if self.rows[i][j] == value {
                    self.rows[i][j] = -1;
                    self.completed = self.check(i, j);
                    break 'out;
                }
            }
        }
        self.completed
    }

    fn check(&self, row: usize, col: usize) -> bool {
        if self.rows[row].iter().sum::<i32>() == -5 {
            return true;
        }
        self.rows.iter().fold(0, |acc, row| acc + row[col]) == -5
    }

    fn remaining_sum(&self) -> i32 {
        self.rows.iter().flatten().filter(|cell| *cell != &-1).sum()
    }
}

fn part_one() {
    let input = include_str!("../../../input/day_04.in");
    let mut lines = input.lines();
    let moves: Vec<i32> = lines
        .next()
        .unwrap()
        .split(',')
        .map(|m| m.parse::<i32>().unwrap())
        .collect();

    let mut boards = Vec::new();
    let l = &mut lines;
    while let Some(_) = l.next() {
        let _ = l.skip(1);

        let rows: Vec<Vec<i32>> = l
            .take(5)
            .map(|l| l.split_whitespace().map(|m| m.parse().unwrap()).collect())
            .collect();
        boards.push(Board::parse(&rows));
    }

    {
        let mut boards = boards.clone();
        'moves: for m in &moves {
            println!("move {}", *m);
            for board in boards.iter_mut() {
                if board.mark(*m) {
                    println!("Part 1: {}", m * board.remaining_sum());
                    break 'moves;
                }
            }
        }
    }

    {
        let mut last_result = 0;
        for m in &moves {
            for board in boards.iter_mut() {
                if !board.completed && board.mark(*m) {
                    last_result = m * board.remaining_sum();
                }
            }
        }

        println!("Part 2: {}", last_result);
    }
}

pub fn show() {
    part_one();
}
