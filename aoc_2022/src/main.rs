fn main() {
    print!("Day 1a: ");
    // day_01();
    day_02();
}



fn day_01() {
    let contents = include_str!(r"..\day01.txt");
    let mut sum = 0;
    let mut elves: Vec<i32> = Vec::new();
    for line in contents.lines() {
        let num = line.parse::<i32>().unwrap_or(0);
        if num == 0 {
            elves.push(sum);
            sum = 0;
        } else {
            sum += num;
        }
    }
    println!("{}", elves.iter().max().unwrap());
    elves.sort_by(|a, b| b.cmp(a));
    sum = 0;
    for i in 0..=2 {
        sum += elves[i];
    }
    println!("Day 1b: {}", elves[0..3].iter().sum::<i32>());
    println!("Day 1b: {sum}");
}

fn day_02() {
    let contents = include_str!(r"..\day02.txt");
    let mut line_number = 0;
    for line in contents.lines() {
        let split: Vec<&str> = line.split_whitespace().collect();
        let mut them = RoPaSc::Rock;
        match split[0] {
            "A" => them = RoPaSc::Rock,
            "B" => them = RoPaSc::Paper,
            "C" => them = RoPaSc::Scissors,
            _ => (),
        };
        let mut us = RoPaSc::Rock;
        match split[1] {
            "A" => us = RoPaSc::Rock,
            "B" => us = RoPaSc::Paper,
            "C" => us = RoPaSc::Scissors,
            _ => (),
        };
        let score = rps_score(them, us);
        

        println!("{line_number} {line} {:?}", split);
        line_number += 1;
    }

}

enum RoPaSc {
    Rock,
    Paper,
    Scissors,
    None,
}
fn rps_score(a: RoPaSc, b: RoPaSc) {

}
