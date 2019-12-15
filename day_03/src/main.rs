use std::collections::HashSet;
use std::fs;

fn main() {
    let contents = fs::read_to_string("data.txt").expect("Error reading input");

    let mut wires: Vec<Vec<(&str, i32)>> = Vec::new();

    
    for line in contents.lines() {
        let mut wire: Vec<(&str, i32)> = Vec::new();
        for s in line.split(',') {
            
            let dir = &s.trim()[..1];
            let len = &s.trim()[1..];
            wire.push((dir, len.parse().unwrap()));
        } 
        wires.push(wire);
    }
    let mut wire_set: HashSet<(i32, i32)> = HashSet::new();
    let mut crossings = Vec::new();

    for wire in wires {
        let mut x = 0;
        let mut y = 0;
        for (dir, len) in wire {
            for i in 1..=len {
                match dir {
                    // positive y is Up
                    "U" => { y += 1},
                    "D" => { y -= 1},
                    // positive x is Right
                    "R" => { x += 1},
                    "L" => { x -= 1},
                    _=> (),
                }
                if !wire_set.contains(&(x, y)) {
                    wire_set.insert((x, y));
                } else {
                    crossings.push((x, y));
                }
            }
            
            println!("{}: {}", dir, len);
        }
    }
    


}
