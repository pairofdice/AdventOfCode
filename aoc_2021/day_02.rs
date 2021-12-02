use std::fs;

fn read() -> Vec<(String, i64)> {
    let data = fs::read_to_string("02.txt").expect("Error reading file");
    let mut darray: Vec<(String, i64)> = Vec::new();
    for line in data.lines() {
        let mut split = line.trim().split(' ');
        if let Some(s) = split.next() {
            if let Some(n) = split.next() {
                darray.push((s.to_string(), n.parse().unwrap()));
            }
        }
    }
    darray
}

fn main() {
    let array = read();
    let mut depth = 0;
    let mut depth_part2 = 0;
    let mut pos = 0;
    let mut aim = 0;

    for (a, b) in array.iter() {
        match a.as_str() {
            "forward" => {
                pos += b;
                depth_part2 += aim * b;
            }
            "down" => {
                aim += b;
                depth += b;
            }
            "up" => {
                aim -= b;
                depth -= b;
            }
            _ => (),
        }
    }
    println!(
        "Part1, Horizontal: {} Depth: {} Multiplied: {} Part2: {}",
        depth,
        pos,
        depth * pos,
        depth_part2 * pos
    );
}
