//extern crate regex;

//use regex::Regex;
use std::fs;


fn main() {
    let contents = fs::read_to_string("data.txt").expect("Error reading input");

    /*     
    let re = Regex::new("[0-9]+").unwrap();

    for n in re.captures_iter(&contents) {
        input.push((&n[0]).parse().unwrap());
    } */

    let mut input: Vec<u32> = Vec::new();
    
    for s in contents.split(',') {
        input.push(s.trim().parse().unwrap());
    }

    for j in input {
        match j {
            1 => {

            },
            2 => {

            },
            99 => {
                break;
            },
            _ => (),
        }
    }
}



#[cfg(test)]
mod tests {
}
