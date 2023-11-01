use std::fs::File;
use std::io::prelude::*;
use std::io::BufReader;
use std::path::Path;

struct Slope {
    x: usize,
    y: usize,
}

fn main() {
    let path = Path::new("input.txt");
    let f = File::open(&path).unwrap();
    let reader = BufReader::new(f);

    let mut input = vec![];

    for line_ in reader.lines() {
        let line = line_.unwrap();
        input.push(line.chars().collect());
    }

    println!("Phase one: {}", part_one(&Slope { x: 3, y: 1 }, &input));

    let slopes = vec![
        Slope { x: 1, y: 1 },
        Slope { x: 3, y: 1 },
        Slope { x: 5, y: 1 },
        Slope { x: 7, y: 1 },
        Slope { x: 1, y: 2 },
    ];
    println!("----");

    let mut answer: u64 = 1;
    for s in slopes.iter() {
        answer *= part_one(s, &input) as u64;
    }
    println!("Phase two: {}", answer);
}

fn part_one(slope: &Slope, input: &Vec<Vec<char>>) -> u32 {
    let mut trees = 0;

    for (i, line) in input.iter().enumerate() {
        if i % slope.y == 0 {
            if line[((i/slope.y) * slope.x) % line.len()] == '#' {
                trees += 1;
            }
        }
    }
    println!("Trees hit: {}: slope.y: {}", trees, slope.y);
    //line_as_chars[(pos * 3) % line.len()]
    trees
}
