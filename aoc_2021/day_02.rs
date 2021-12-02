use std::fs;

fn read() -> Vec<(String, i64)>{
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
    let mut x = 0;
    let mut y = 0;
    for (a, b) in array.iter() {
        match a.as_str() {
            "forward" => {x += b;}
            "down" => {y += b;}
            "up" => {y -= b;}
            _ => ()
        }
    }
    println!("Horizontal: {} Depth: {} Multiplied: {}", x, y, x * y);

}