fn distance(positions: &Vec<u64>, position: u64, accumulate: bool) -> i64 {
    let mut distance_sum = 0;
    positions.iter().for_each(|p| {
        let d = (*p as i64 - position as i64).abs();
        if accumulate {
            distance_sum += d * (d + 1) / 2;
        } else {
            distance_sum += d;
        }
    });
    distance_sum
}

pub fn show() {
    let crabs_positions: Vec<u64> = include_str!("../../../input/day_07.in")
        .trim()
        .split(',')
        .map(|c| c.parse::<u64>().unwrap())
        .collect();

    let (min, max) = crabs_positions.iter().fold((1000, 0), |mut bounds, p| {
        if *p < bounds.0 {
            bounds.0 = *p
        }
        if *p > bounds.1 {
            bounds.1 = *p
        }
        bounds
    });

    let count = (min..max)
        .map(|x| distance(&crabs_positions, x, false))
        .min()
        .unwrap();
    println!("- Part 1: {}", count);

    let count = (min..max)
        .map(|x| distance(&crabs_positions, x, true))
        .min()
        .unwrap();
    println!("- Part 2: {}", count);
}
