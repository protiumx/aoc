use std::fs::File;
use std::io::{prelude::*, BufReader};

fn part_one() -> i32 {
    let data = BufReader::new(File::open("../../input/day_02.in").unwrap())
        .lines()
        .filter_map(|l| l.ok())
        .fold((0_i32, 0_i32), |x_y, line| {
            let data: Vec<&str> = line.split(' ').collect();
            let val = data[1].parse::<i32>().unwrap();
            match data[0] {
                "forward" => (x_y.0 + val, x_y.1),
                "up" => (x_y.0, x_y.1 - val),
                "down" => (x_y.0, x_y.1 + val),
                _ => x_y,
            }
        });
    data.0 * data.1
}

fn part_two() -> i32 {
    let data = BufReader::new(File::open("../../input/day_02.in").unwrap())
        .lines()
        .filter_map(|l| l.ok())
        .fold((0_i32, 0_i32, 0_i32), |x_y_aim, line| {
            let data: Vec<&str> = line.split(' ').collect();
            let val = data[1].parse::<i32>().unwrap();
            match data[0] {
                "forward" => (x_y_aim.0 + val, x_y_aim.1 + x_y_aim.2 * val, x_y_aim.2),
                "up" => (x_y_aim.0, x_y_aim.1, x_y_aim.2 - val),
                "down" => (x_y_aim.0, x_y_aim.1, x_y_aim.2 + val),
                _ => x_y_aim,
            }
        });
    data.0 * data.1
}
pub fn show() {
    println!("- Answer part one: {}", part_one());
    println!("- Answer part two: {}", part_two());
}
