use std::fs;

fn main() {
    let mut counter = 0;
    let data = fs::read_to_string("01a.txt").expect("Error reading file");
    let mut darray: Vec<i64> = Vec::new();
    for line in data.lines() {
        let n = line.trim().parse().unwrap();
        darray.push(n);
    }
    for (i, n) in darray.iter().enumerate() {
        if i == 0 {
            continue;
        }
        if darray[i - 1] < *n {
            counter += 1;
        }
    }
    println!("{}", counter);
}
