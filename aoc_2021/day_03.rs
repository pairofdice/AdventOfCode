/*
Each bit in the gamma rate can be determined by finding the most common bit in the corresponding position of all numbers in the diagnostic report.

The epsilon rate is calculated in a similar way; rather than use the most common bit, the least common bit from each position is used.
*/

fn read() -> Vec<i32> {
    include_str!("03.txt")
        .lines()
        .map(|line| i32::from_str_radix(line, 2).unwrap())
        .collect()
}

fn main() {
    let darray = read();
    let mut omega = [0; 12];
    for n in darray {
        let mut mystery = 2048;
        for x in 0..12 {
            if (n & mystery) >= mystery {
                omega[x] += 1;
            } else {
                omega[x] -= 1;
            }
            mystery /= 2;
        }
    }
    let gamma =  i32::from_str_radix(&omega.map(|n: i32| (if n > 0 {1} else {0}).to_string()).join(""), 2).unwrap();
    let epsilon =  !gamma & 4095;
    println!("Part1, gamma: {} epsilon: {} multiplied {}", gamma, epsilon, gamma * epsilon);
}
