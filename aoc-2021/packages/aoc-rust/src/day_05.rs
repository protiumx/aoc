use std::cmp::{max, min};
use std::ops::{Range, RangeInclusive};
use std::str::FromStr;

#[derive(Debug)]
struct Line {
    x: (usize, usize),
    y: (usize, usize),
}

impl FromStr for Line {
    type Err = std::io::Error;

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        let (start, end) = s.split_once(" -> ").unwrap();
        let (x1, y1) = start.split_once(",").unwrap();
        let (x2, y2) = end.split_once(",").unwrap();
        let x1 = x1.parse::<usize>().unwrap();
        let x2 = x2.parse::<usize>().unwrap();
        let y1 = y1.parse::<usize>().unwrap();
        let y2 = y2.parse::<usize>().unwrap();
        return Ok(Line {
            x: (x1, x2),
            y: (y1, y2),
        });
    }
}

enum Orientation {
    Vertical,
    Horizontal,
    Diagonal45,
    Other,
}

impl Line {
    fn orientation(&self) -> Orientation {
        if self.x.0 == self.x.1 {
            return Orientation::Vertical;
        } else if self.y.0 == self.y.1 {
            return Orientation::Horizontal;
        } else if (self.x.0 as i32 - self.x.1 as i32).abs()
            == (self.y.0 as i32 - self.y.1 as i32).abs()
        {
            return Orientation::Diagonal45;
        }
        Orientation::Other
    }

    fn is_straight(&self) -> bool {
        match self.orientation() {
            Orientation::Vertical | Orientation::Horizontal => true,
            _ => false,
        }
    }
}

fn print_board(board: &Vec<Vec<i32>>) {
    for l in board.iter() {
        for c in l.iter() {
            print!(
                "{} ",
                if *c == 0 {
                    ".".to_string()
                } else {
                    c.to_string()
                }
            );
        }
        println!("");
    }
    println!("");
}

pub fn show() {
    let lines: Vec<Line> = include_str!("../../../input/day_05.in")
        .lines()
        .map(|x| x.parse().unwrap())
        .collect();

    // Get the size of the matrix
    let size = lines.iter().fold(0, |mut max, line| {
        let max_line = vec![line.x.0, line.x.1, line.y.0, line.y.1];
        match max_line.iter().max() {
            Some(m) => {
                if *m > max {
                    max = *m
                }
            }
            _ => {}
        }
        max
    });
    let (board, count) = lines.iter().filter(|l| l.is_straight()).fold(
        (vec![vec![0; size + 1]; size + 1], 0),
        |(mut board, mut count), line| {
            let vertical = matches!(line.orientation(), Orientation::Vertical);
            let mut start = min(line.x.0, line.x.1);
            let mut end = max(line.x.0, line.x.1);
            if vertical {
                start = min(line.y.0, line.y.1);
                end = max(line.y.0, line.y.1)
            }

            while start <= end {
                let x = if vertical { line.x.0 } else { start };
                let y = if vertical { start } else { line.y.0 };
                board[y][x] += 1;
                if board[y][x] == 2 {
                    count += 1;
                }
                start += 1;
            }
            return (board, count);
        },
    );
    //print_board(&board);
    println!("- Part 1: {}", count);

    let (board, count) = lines
        .iter()
        .filter(|l| matches!(l.orientation(), Orientation::Diagonal45))
        .fold((board, count), |(mut board, mut count), line| {
            let m: i32 = (line.x.1 as i32 - line.x.0 as i32) / (line.y.1 as i32 - line.y.0 as i32);
            let y_max = max(line.y.0, line.y.1);
            let y_min = min(line.y.0, line.y.1);
            // Always go from left to right
            let mut col = min(line.x.0, line.x.1);
            // Start from top or bottom depending on the line's orientation
            let mut row = (if m == -1 { y_max } else { y_min }) as i32;

            while col <= max(line.x.0, line.x.1) {
                board[row as usize][col] += 1;
                if board[row as usize][col] == 2 {
                    count += 1;
                }

                col += 1;
                row += m;
            }
            return (board, count);
        });
    //print_board(&board);
    println!("- Part 2: {}", count);
}
