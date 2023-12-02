fn main() {
    println!("Hello, world!");
    day01();
}


fn day01() {
    let mut total: i64 = 0;
    let input = include_str!("../day01.txt");

    for line in input.lines() {
        let (a, b) = find_wordnum_indx(line);
        // print!("{} - {:?}, {:?}", line, a.unwrap_or_default(), b.unwrap_or_default());
    print!("{} -", line);
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
        println!(" {}", num);
        total += num;
    }
    println!("Total: {}", total);
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