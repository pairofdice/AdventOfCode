use std::collections::HashSet;
use std::fs;

#[derive(PartialEq, Eq, Hash)]
struct WireBit {
    x: i32,
    y: i32,
    distance: i32,
}

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
    let mut wire_set_alt: HashSet<WireBit> = HashSet::new();
    let mut crossings = Vec::new();
    let mut crossings_alt = Vec::new();

    for wire in wires {
        let mut x = 0;
        let mut y = 0;
        let mut wire_length = 0; // distance of wirebit from origin along the wire
        for (dir, len) in wire {
            for _ in 0..len {
                match dir {
                    // positive y is Up
                    "U" => { y += 1; wire_length += 1},
                    "D" => { y -= 1; wire_length += },
                    // positive x is Right
                    "R" => { x += 1; wire_length += },
                    "L" => { x -= 1; wire_length += },
                    _=> (),
                }
                if !wire_set.contains(&(x, y)) {
                    wire_set.insert((x, y));
                } else {
                    crossings.push((x, y));
                }
                let bit = WireBit{x: x, y: y, distance: wire_length};
                if !wire_set_alt.contains(&bit) {
                    wire_set_alt.insert(bit);
                } else {
                    // add stuff for adding lengths of both wires ..
                    crossings_alt.push(bit);
                }
            }
        }
    }
    
    let mut closest: (i32, i32) = (i32::max_value(), i32::max_value());
    let mut min = i32::max_value();
    for c in crossings {
        if manhattan_distance(c) < min {
            closest = c;
            min = manhattan_distance(c);
        }
    }
    println!("Closest wire crossin to origin is: {:?}: {}", closest, min);
}

fn manhattan_distance((x, y): (i32, i32)) -> i32 {
    x.abs() + y.abs() // did I really need a function for this?
}

#[cfg(test)]
mod test {
    use super::*; 
    #[test]
    fn correct_distance() {
/*
R75,D30,R83,U83,L12,D49,R71,U7,L72
U62,R66,U55,R34,D71,R55,D58,R83
distance 159

R75,D30,R83,U83,L12,D49,R71,U7,L72
U62,R66,U55,R34,D71,R55,D58,R83
distance 135
*/
        assert_eq!(manhattan_distance((20, 20)), 40);
    }
}
