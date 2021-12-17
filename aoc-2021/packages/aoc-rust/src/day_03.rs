use std::fs::File;
use std::io::{prelude::*, BufReader};

fn part_one() -> i32 {
    let data: Vec<Vec<i32>> = BufReader::new(File::open("../../input/day_03.in").unwrap())
        .lines()
        .map(|l| {
            l.unwrap()
                .chars()
                .map(|c| (c as u8 - b'0') as i32)
                .collect()
        })
        .collect();
    let cols = data[0].len();
    let half = data.len() as i32 / 2;
    let gama_rate = data
        .iter()
        .fold(vec![0; cols], |mut v, line| {
            for i in 0..cols as usize {
                v[i] += line[i]
            }
            v
        })
        .iter()
        .map(|d| if *d > half { 1 } else { 0 })
        .fold(0, |acc, d| (acc << 1) + d);
    /*
     * 00000101 -> 11111010 -> shift everything but the number of columns
     * 01000000 -> shif back -> 00000010
     */
    gama_rate * (!gama_rate << (32 - cols) >> (32 - cols))
}

fn part_two() -> i32 {
    let data: Vec<Vec<i32>> = BufReader::new(File::open("../../input/day_03.in").unwrap())
        .lines()
        .map(|l| {
            l.unwrap()
                .chars()
                .map(|c| (c as u8 - b'0') as i32)
                .collect()
        })
        .collect();
    let cols = data[0].len();
    let mut oxygen_data = data.clone();
    for i in 0..cols {
        let oxygen_half = (oxygen_data.len() as u32 + 1) / 2;
        let most_common = if oxygen_data
            .iter()
            .fold(0_u32, |acc, line| acc + line[i] as u32)
            < oxygen_half
        {
            0
        } else {
            1
        };

        oxygen_data = oxygen_data
            .into_iter()
            .filter(|line| line[i] == most_common)
            .collect();
        if oxygen_data.len() == 1 {
            break;
        }
    }
    let mut co2_data = data;
    for i in 0..cols {
        let co2_half = (co2_data.len() as u32 + 1) / 2;
        let most_common = if co2_data
            .iter()
            .fold(0_u32, |acc, line| acc + line[i] as u32)
            < co2_half
        {
            0
        } else {
            1
        };
        co2_data = co2_data
            .into_iter()
            .filter(|line| line[i] != most_common)
            .collect();
        if co2_data.len() == 1 {
            break;
        }
    }
    let oxygen_rate = oxygen_data[0].iter().fold(0, |acc, d| (acc << 1) + d);
    let co2_rate = co2_data[0].iter().fold(0, |acc, d| (acc << 1) + d);
    oxygen_rate * co2_rate
}
pub fn show() {
    println!("Answer part one: {}", part_one());
    println!("Answer part two: {}", part_two());
}
