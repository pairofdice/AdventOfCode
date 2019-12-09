use std::fs;


fn main() {
    
    let contents = fs::read_to_string("data.txt").expect("Error reading input");


    let mut total: u64 = 0;
    for line in contents.trim().lines() {
        let module_weight: u64 = line.parse().unwrap();
        
        let fuel_needed = fuel_calc(module_weight);
        let tyranny = more_fuel(fuel_needed);
        total += fuel_needed + tyranny;
    }
    //println!("Fuel needed without tyranny: {}", fuel_needed); // correct
    
    //println!("Extra tyranny fuel needed: {}",  tyranny);
    println!("Total fuel needed: {}",  total);

    // ----- There is a rustier way vvv
    let calc = |w: &str| (w.parse::<u64>().unwrap() /3 - 2);
    let _answer: u64 = contents.trim().lines().map(calc).sum();
    // --- ^^
    
}

fn fuel_calc(f: u64) -> u64 {
    match (f/3).checked_sub(2) {
        Some(v) => v,
        None    => 0
    }
    
}

fn more_fuel(w: u64) -> u64 {
    let mut t = w;
    let mut r = 0;
    while t > 0 {
        t = fuel_calc(t);
        r += t;
    }
    r
}


#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn base_fuel() {
        assert_eq!(fuel_calc(12), 2);
        assert_eq!(fuel_calc(14), 2);
        assert_eq!(fuel_calc(1969), 654);
        assert_eq!(fuel_calc(100756), 33583);
    }

    #[test]
    fn extra_fuel() {
        assert_eq!(more_fuel(100756), 50346);
        assert_eq!(more_fuel(1969), 966);
        assert_eq!(more_fuel(14), 2);
        assert_eq!(more_fuel(8), 0);
        assert_eq!(more_fuel(11), 1);
    }
}


