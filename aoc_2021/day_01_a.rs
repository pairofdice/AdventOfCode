use std::fs;

fn read_into_ints() -> Vec<i64> {
    let data = fs::read_to_string("01a.txt").expect("Error reading file");
    let mut darray: Vec<i64> = Vec::new();
    for line in data.lines() {
        let n = line.trim().parse().unwrap();
        darray.push(n);
    }
    darray
}

fn part1() -> i64 {
    let darray = read_into_ints();
    let mut counter = 0;
    for (i, n) in darray.iter().enumerate().skip(1) {
        if darray[i - 1] < *n {
            counter += 1;
        }
    }
    counter
}

fn main() {

    println!("Part 1: {}", part1());
}
