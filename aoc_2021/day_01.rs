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

fn part1(darray: &Vec<i64>) -> i64 {
    let mut counter = 0;
    for (i, n) in darray.iter().enumerate().skip(1) {
        if darray[i - 1] < *n {
            counter += 1;
        }
    }
    counter
}

fn part2(darray: &Vec<i64>) -> i64 {
    let mut counter = 0;
    let mut average: i64;
    let mut bverage;
    for (i, _n) in darray.iter().enumerate().skip(3) {
        // Doesn't feel like a rusty way
        let s1 = (i - 3) as usize; 
        let e1 = (i - 1) as usize;
        let s2 = (i - 2) as usize;
        let e2 = (i - 0) as usize;
        average = darray[s1..=e1].iter().sum();
        bverage = darray[s2..=e2].iter().sum();
        if average < bverage {
            counter += 1;
        }
    }
    counter
}

fn main() {
    let darray = read_into_ints();
    println!("Part 1: {}", part1(&darray));
    println!("Part 2: {}", part2(&darray));
    // Fix for this nonsense?
}
