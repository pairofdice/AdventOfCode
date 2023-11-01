fn main() {
    let darray:Vec<i32> = include_str!("03.txt").lines().map(|line| i32::from_str_radix(line, 2).unwrap()).collect();
    let mut omega = [0; 12];
    for n in &darray {
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
    let gamma = i32::from_str_radix(&omega.map(|n| (if n > 0 { 1 } else { 0 }).to_string()).join(""), 2).unwrap();
    let epsilon = !gamma & 4095;
    println!("Part1, gamma: {} epsilon: {} multiplied {}", gamma, epsilon, gamma * epsilon);

    //let o2_indices = Vec::new();
    
    for (i, nb) in gamma.into_iter().enumerate() {
        // println!("{:012b} {}", nb, i);
        println!("{} {}", nb, i);
        /* for o in 0..12 {

        } */
    }

}