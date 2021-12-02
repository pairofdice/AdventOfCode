use std::fs;

fn read() -> Vec<(String, i64)> {
    let data = fs::read_to_string("02.txt").expect("Error reading file");
    let mut darray: Vec<(String, i64)> = Vec::with_capacity(1000);
    for line in data.lines() {
        let mut split = line.split(' ');
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
    let (mut depth, mut depth_part2, mut pos, mut aim) = (0, 0, 0, 0);

    for (command, value) in array.iter() {
        match command.as_str() {
            "forward" => {
                pos += value;
                depth_part2 += aim * value;
            }
            "down" => {
                aim += value;
                depth += value;
            }
            "up" => {
                aim -= value;
                depth -= value;
            }
            _ => (),
        }
    }
    println!(
        "Part1, Horizontal: {0} Depth: {1} \tMultiplied: {2} \nPart2, Horizontal: {0} Depth: {3} \tMultiplied: {4}",
        pos,
        depth,
        depth * pos,
        depth_part2,
        depth_part2 * pos
    );
}
