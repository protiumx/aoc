pub fn show() {
    let count = include_str!("../../../input/day_06.in")
        .lines()
        .take(1)
        .flat_map(|l| l.split(','))
        .map(|c| c.parse().unwrap())
        .fold([0u64; 9], |mut acc, f: usize| {
            acc[f] += 1;
            acc
        });

    println!("- Part 1: {:?}", simulate(80, count.clone()));
    println!("- Part 2: {:?}", simulate(256, count.clone()));
}

fn simulate(days: u32, mut initial: [u64; 9]) -> u64 {
    for i in 0..days {
        let last = initial[0];
        initial[0] = 0;
        for d in 1..9 {
            initial[d - 1] += initial[d];
            initial[d] = 0;
        }
        initial[8] = last;
        initial[6] += last;
    }
    initial.iter().sum::<u64>()
}
