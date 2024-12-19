pub fn run(input: &Vec<String>) {
    let mut counter : i32 = 0;
    let mut index : i32 = 1;
    let mut until_first : bool = false;
    println!("Day 1 part one");
    for line in input {
        for c in line.as_bytes() {
            if *c == 40 {
                counter += 1
            } else if *c == 41 {
                counter -= 1
            }
            if counter == -1 {
                until_first = true;
            }
            if !until_first {
                index += 1;
            }
        }
    }
    println!("Part 1 result: {}", counter);
    println!("Part 2 result: {}", index);
}
