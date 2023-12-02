#[allow(dead_code)]
fn main() {
    println!("Hello, world!");
    // day01();
    day02();
}

fn day02() {
    let input: &str = include_str!("../day02.txt");
    let mut total = 0;
    let mut power_total = 0;
    let contains_red = 12;
    let contains_green = 13;
    let contains_blue = 14;

    for line in input.lines() {
        let game: Vec<&str> = line.split(' ').collect();
        let id: i32 = game.get(1).unwrap().strip_suffix(':').unwrap().parse().unwrap();
        // print!("{id}: ");
        // println!("{game:?}");

        let mut g_max_g = 0;
        let mut g_max_b = 0;
        let mut g_max_r = 0;

        for i in (2..game.len()).step_by(2) {
            let count: i32 = game.get(i).unwrap().parse().unwrap();
            // print!("{count}");
            match game.get(i + 1) {
                None => {}
                Some(color) => {
                    match color.trim_end_matches([',',';']) {
                        "red" => {
                            if count > g_max_r {
                                g_max_r = count;
                            }
                        },
                        "green" => {
                            if count > g_max_g {
                                g_max_g = count;
                            }
                        },
                        "blue" => {
                            if count > g_max_b {
                                g_max_b = count;
                            }
                        },
                        _ => {}
                    }
                }
            }
          //  print!("{}", game.get(i).unwrap());
        }
        println!("{}", g_max_r * g_max_g * g_max_b);
        power_total += g_max_r * g_max_g * g_max_b;

        if g_max_r <= contains_red && g_max_g <= contains_green  && g_max_b <= contains_blue {
            // println!("VALID!");
            total += id;
        }
    }
    println!("Total: {total}, Power sum: {power_total}");
}

#[allow(dead_code)]
fn day01() {
    let mut total: i64 = 0;
    let input = include_str!("../day01.txt");

    for line in input.lines() {
        let (a, b) = find_wordnum_indx(line);
        // print!("{} - {:?}, {:?}", line, a.unwrap_or_default(), b.unwrap_or_default());
        // print!("{} -", line);
        let mut c;
        let c1;
        if let Some(i) = line.find(char::is_numeric) {
            c = line.get(i..i+1).unwrap();
            c1 = resolve_first_num(c.parse().unwrap(), i as i64, a.unwrap_or((666, 0)));
        } else {
            c1 = resolve_first_num(0, 666, a.unwrap_or((666, 0)));
        }
        let c2;
        if let Some(j) = line.rfind(char::is_numeric){
            c = line.get(j..j+1).unwrap();
            c2 = resolve_second_num(c.parse().unwrap(), j as i64, b.unwrap_or((-1, 0)));
        } else {
            c2 = resolve_second_num(0, -1, b.unwrap_or((-1, 0)));
        }
        let num = format!("{}{}", c1, c2).parse::<i64>().unwrap();
        // println!(" {}", num);
        total += num;
    }
    println!("Day 01 total: {}", total);
}

fn find_wordnum_indx(s: &str) -> (Option<(i64, i64)>, Option<(i64, i64)>) {
    let nums = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"];

    let mut result_a: Option<(i64, i64)> = None;
    let mut result_b: Option<(i64, i64)> = None;

    let mut ai = s.len();
    let mut bi = 0;

    for (nums_index, num) in nums.iter().enumerate() {
        match s.find(num) {
            Some(j) => {
                if j < ai {
                    ai = j;
                    result_a = Some((j as i64, nums_index as i64 + 1));
                }
            },
            None => (),
        }
        match s.rfind(num) {
            Some(j) => {
                if j > bi {
                    bi = j;
                    result_b = Some((j as i64, nums_index as i64 + 1));
                }
            },
            None => (),
        }
    }
    (result_a, result_b)
}

fn resolve_first_num(digit: i64, digit_index: i64, wordnum:(i64, i64)) -> i64 {
    if digit_index < wordnum.0 as i64 {
        digit
    } else {
        wordnum.1
    }
}
fn resolve_second_num(digit: i64, digit_index: i64, wordnum:(i64, i64)) -> i64 {
    if digit_index > wordnum.0 as i64 {
        digit
    } else {
        wordnum.1
    }
}

#[cfg(test)]
mod tests {

    #[test]
    fn test_day02() {
        let input = "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green";
    }
}