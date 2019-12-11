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
    let input_copy = input.clone();
    
    for noun in 0..100 {
        for verb in 0..100 {
            input = input_copy.clone();
            
            input[1] = noun;
            input[2] = verb;
            if run(input)[0] == 19690720 {
                println!("noun: {}\t verb:{}", noun, verb);
                println!("result?: {}{}", noun, verb);
                break;
            }
        }
    }

}

fn run(mut input: Vec<u32>) -> Vec<u32> {
    let mut code = input[0];
    let mut index = 0;

    while code != 99 {
        code = input[index];
        if code > (input.len()-6) as u32{
            continue;
        }
        match code {
            1 => {
                let i_a = input[index + 1] as usize;
                let i_b = input[index + 2] as usize;
                let o_index = input[index + 3] as usize;
                let result = input[i_a] + input[i_b];
                input[o_index] = result;
                index += 4;
            },
            2 => {
                let i_a = input[index + 1] as usize;
                let i_b = input[index + 2] as usize;
                let o_index = input[index + 3] as usize;
                let result = input[i_a] * input[i_b];
                input[o_index] = result;
                index += 4;

            },
            _ => (),
        }
    }
    input
}



#[cfg(test)]
mod tests {
}
