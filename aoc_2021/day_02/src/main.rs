use std::fs::File;
use std::io::prelude::*;
use std::path::Path;

fn main() {
    // Create a path to the desired file
    let path = Path::new("input.txt");
    // let path = Path::new("test.txt");
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

    let mut lines: Vec<(usize, usize, &str, &str)> = Vec::new();

    for line in s.lines() {
        let l: Vec<&str> = line.split_ascii_whitespace().collect();
        let ab: Vec<&str> = l[0].split('-').collect();
        let a = ab[0].parse::<usize>().unwrap();
        let b = ab[1].parse::<usize>().unwrap();
        lines.push((a, b, &l[1][0..1], l[2]));
    }

    let mut c = 0;
    let mut c2 = 0;
    for xyz in lines {
        let (a, b, ch, st) = xyz;
        let counted: Vec<&str> = st.rmatches(ch).collect();
        if counted.len() >= a && counted.len() <= b {
            c += 1;
        }
        let mut matches = 0;
        if &st[(a-1)..a] == ch {
            matches += 1;
        }
        if &st[(b-1)..b] == ch {
            matches += 1;
        }

        if matches == 1 {
            c2 += 1;
        }

    }
    println!("part 1 matches: {}, part 2 matches: {}", c, c2);
}