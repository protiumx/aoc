use std::fs::File;
use std::io::{prelude::*, BufReader};

fn part_one() -> i32 {
    let mut data = BufReader::new(File::open("../../input/day_01.in").unwrap())
        .lines()
        .filter_map(|l| l.ok())
        .filter_map(|l| l.parse::<i32>().ok());

    let mut count = 0;
    let mut prev = data.next().unwrap();
    for d in data {
        if d > prev {
            count += 1;
        }
        prev = d;
    }
    count
}

fn part_two() -> i32 {
    let data: Vec<i32> = BufReader::new(File::open("../../input/day_01.in").unwrap())
        .lines()
        .filter_map(|l| l.ok())
        .filter_map(|l| l.parse::<i32>().ok())
        .collect();
    let mut count = 0;
    let mut sum = 0;
    let mut prev_sum = data[0] + data[1] + data[2];
    let win = 3;
    for i in 1..data.len() - 2 {
        for j in 0..win {
            sum += data[i + j as usize];
        }
        if sum > prev_sum {
            count += 1;
        }
        prev_sum = sum;
        sum = 0;
    }
    count
}

pub fn show() {
    println!("- Part one answer: {}", part_one());
    println!("- Part two answer: {}", part_two());
}
