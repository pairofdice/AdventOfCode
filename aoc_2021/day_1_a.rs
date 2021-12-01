use std::fs;

fn main() {
    let data = fs::read_to_string("day01a.txt").expect("Error reading file");
    for i in data.lines() {
        println!(i);
    }
}