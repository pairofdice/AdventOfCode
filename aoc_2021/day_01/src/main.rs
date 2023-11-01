use std::fs::File;
use std::io::prelude::*;
use std::path::Path;

fn main() {
    // Create a path to the desired file
    // let path = Path::new("test.txt");
    let path = Path::new("input.txt");
    let display = path.display();

    // Open the path in read-only mode, returns `io::Result<File>`
    let mut file = match File::open(&path) {
        Err(why) => panic!("couldn't open {}: {}", display, why),
        Ok(file) => file,
    };

    // Read the file contents into a string, returns `io::Result<usize>`
    let mut s = String::new();
    match file.read_to_string(&mut s) {
        Err(why) => panic!("couldn't read {}: {}", display, why),
        Ok(_) => print!("{} contains:\n{}\n\n", display, s),
    }

    let mut input: Vec<u32> = Vec::new();
    for line in s.lines() {
        input.push(line.parse().unwrap());
    }

    for (i, n) in input.iter().enumerate() {
        for k in (i+1)..input.len() {
            if n + input[k] == 2020 {
                println!("{n} + {k} = {nk}, {n} * {k} \t= {nnkk}",n= n , k=input[k], nk =n+input[k], nnkk = n* input[k]);
            }
            for t in (k+1)..input.len() {
                if n + input[k] + input[t] == 2020 {

                    println!("{n} + {k} + {t} = {nkt}, {n} * {k} * {t} \t= {nnkktt}",
                    n= n , k=input[k],t=input[t], nkt =n+input[k]+input[t], nnkktt = n* input[k]*input[t]);
                }
            }
        }
    }
}
