pub fn run(input: &Vec<String>) {
    let mut result : i32 = 0;
    for line in input { 
        println!("{:?}", line.split('x').map(|x| x.parse::<i32>().unwrap()));
    }
    println!("Part 1 result: {}", result);
}
