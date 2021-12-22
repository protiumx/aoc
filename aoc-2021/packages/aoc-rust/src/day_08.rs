// based on https://github.com/ThePrimeagen/aoc/blob/2021/src/day8_2.rs

fn project(segment: &str) -> u32 {
    return segment
        .chars()
        // convert char to byte and shift 1 by c spaces. e.g. a: 1. b: 10, c: 100
        // so segments like cab will be 111, same for abc or bca and so
        .map(|c| 0x1 << (c as u8 - b'a'))
        .fold(0, |acc, bc| acc + bc);
}

fn contains(a: u32, b: u32) -> bool {
    return a & b == b;
}

fn missing(a: u32, b: u32) -> u32 {
    (a ^ b).count_ones()
}

fn create_contain(b: u32) -> Box<dyn Fn(&u32) -> bool> {
    return Box::new(move |a| {
        println!("create_contain  :: a: {:#010b} b: {:#010b}", a, b);
        return contains(*a, b);
    });
}

fn create_missing(b: u32, count: u32) -> Box<dyn Fn(&u32) -> bool> {
    return Box::new(move |a| {
        println!(
            "create_missing :: a: {:#010b} b: {:#010b} count {}",
            a,
            b,
            missing(*a, b)
        );
        return missing(*a, b) == count;
    });
}

fn remove(list: Vec<u32>, f: Box<dyn Fn(&u32) -> bool>) -> (Vec<u32>, u32) {
    println!("list {:?}", list);
    let (idx, matched) = list
        .iter()
        .enumerate()
        .filter(|it| {
            return f(it.1);
        })
        .take(1)
        .collect::<Vec<(usize, &u32)>>()[0];

    let mut list = list.clone();
    list.remove(idx);
    return (list, *matched);
}

fn get_value(proj_val: u32, numbers: &[u32; 10]) -> usize {
    let (idx, _) = numbers
        .iter()
        .enumerate()
        .filter(|it| {
            let (_, x) = it;
            return **x == proj_val;
        })
        .collect::<Vec<(usize, &u32)>>()[0];

    return idx;
}

pub fn show() {
    let data = include_str!("../../../input/day_08.in")
        .lines()
        .fold(0, |acc, line| {
            let (input, output) = line.trim().split_once(" | ").unwrap();
            let known_segments: Vec<u32> = input
                .split(" ")
                // 1 = 2 segments, 4 = 4 segments, 7 = 3 segments, 8 = 7 segments
                .filter(|seg| match seg.len() {
                    2 | 3 | 4 | 7 => true,
                    _ => false,
                })
                .map(project)
                .collect();

            output
                .split(" ")
                .map(project)
                .filter(|o| known_segments.contains(o))
                .count()
                + acc
        });

    println!("- Part 1: {}", data);

    let count = include_str!("../../../input/day_08.in")
        .lines()
        .fold(0, |acc, line| {
            let (input, output) = line.trim().split_once(" | ").unwrap();
            let input = input.split(" ");
            let mut numbers: [u32; 10] = input.clone().fold([0; 10], |mut numbers, seg| {
                match seg.len() {
                    2 => numbers[1] = project(seg),
                    7 => numbers[8] = project(seg),
                    4 => numbers[4] = project(seg),
                    3 => numbers[7] = project(seg),
                    _ => {}
                }
                numbers
            });

            let group5: Vec<u32> = input
                .clone()
                .filter(|seg| &seg.len() == &5)
                .map(project)
                .collect();
            let group6: Vec<u32> = input.filter(|seg| &seg.len() == &6).map(project).collect();

            let (group6, nine) = remove(group6, create_contain(numbers[4]));
            numbers[9] = nine;

            let (group5, two) = remove(group5, create_missing(numbers[9], 3));
            numbers[2] = two;

            // find 5
            let (group5, five) = remove(group5, create_missing(numbers[7], 4));
            numbers[5] = five;
            numbers[3] = group5[0];

            let (group6, six) = remove(group6, create_contain(numbers[5]));
            numbers[6] = six;

            numbers[0] = group6[0];

            let output: Vec<u32> = output.split(" ").map(str::trim).map(project).collect();

            let res = output.iter().rev().enumerate().fold(0, |acc, it| {
                let (idx, val) = it;
                let val_idx = get_value(*val, &numbers);
                return acc + 10_u32.pow(idx as u32) * val_idx as u32;
            });
            return res + acc;
        });

    println!("- Part 2: {}", count);
}
