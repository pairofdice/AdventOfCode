use std::fs::File;
use std::io::{self,BufRead};
use std::path::Path;
mod day_2;

fn main() {

    let mut input : Vec<String> = Vec::new();
    if let Ok(lines) = read_lines("data/day_2.txt") {
        for line in lines.flatten() {
            input.push(line);
        }
        day_2::run(&input);
    } else {
        println!("No Gucci");
    }
}

fn read_lines<P>(filename: P) -> io::Result<io::Lines<io::BufReader<File>>>
where P: AsRef<Path>, {
    let file = File::open(filename)?;
    Ok(io::BufReader::new(file).lines())
}

