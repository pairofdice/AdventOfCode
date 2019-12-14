use std::collections::HashSet;
use std::fs;

fn main() {
    let contents = fs::read_to_string("data.txt").expect("Error reading input");

    let mut wires: Vec<(&str, i32)> = Vec::new();

    
    for line in contents.lines() {
        for s in line.split(',') {
            
            let dir = &s.trim()[..1];
            let len = &s.trim()[1..];
            wires.push((dir, len.parse().unwrap()));
        } 
    }

    for (dir, len) in wires {
        println!("{}: {}", dir, len);
    }
    
    let _wire: HashSet<(i32, i32)> = HashSet::new();


}
