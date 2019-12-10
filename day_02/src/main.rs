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

    let mut input: Vec<usize> = Vec::new();
    
    for s in contents.split(',') {
        input.push(s.trim().parse().unwrap());
    }

    for (index, n) in input.iter().enumerate() {
        match n {
            1 => {
                let i_a = input[index + 1];
                let i_b = input[index + 2];
                let o_index = input[index + 3];
                let result = input[i_a] + input[i_b];
                input[o_index] = result;
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
