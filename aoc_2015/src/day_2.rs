pub fn run(input: &Vec<String>) {
    let mut result : u64 = 0;
    for line in input { 
        let mut parts = line.split('x');
        let l: u64 = parts.next().expect("l").parse().unwrap();
        let w: u64 = parts.next().expect("l").parse().unwrap();
        let h: u64 = parts.next().expect("l").parse().unwrap();
        //          2*l*w + 2*w*h + 2*h*l
        let usage = 2 * l * w + 2 * w * h + 2 * h * l + min(w*l, w*h, h*l);
        result += usage;

        // println!("{l:>3} {w:>3} {h:>3}");
    }
    println!("Part 1 result: {result}");
}

fn min(a: u64, b: u64, c: u64) -> u64 {
    if a < b {
        if a < c {
            return a;
        } else {
            return c;
        }
    } else {
        if b < c {
            return b;
        } else {
            return c;
        }
    }
}
