fn project(segment: &str) -> u32 {
    return segment
        .chars()
        // convert char to byte and shift 1 by c spaces. e.g. a: 1. b: 10, c: 100
        // so segments like cab will be 111, same for abc or bca and so
        .map(|c| 0x1 << (c as u8 - b'a'))
        .fold(0, |acc, bc| acc + bc);
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
}
