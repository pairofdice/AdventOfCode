extern crate regex;

use regex::Regex;
use std::fs;


fn main() {
    let contents = fs::read_to_string("data.txt").expect("Error reading input");

    let mut input: Vec<u32> = Vec::new();
    let re = Regex::new("[0-9]+").unwrap();


    for n in re.captures_iter(&contents) {
        input.push((&n[0]).parse().unwrap());
    }

    for asdsf in input {
        println!("{} {}", asdsf, asdsf*asdsf); // JEEEEEEEE
    }
}
