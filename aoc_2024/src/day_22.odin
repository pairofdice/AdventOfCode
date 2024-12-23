package main

import "core:bytes"
import "core:fmt"

day_22 :: proc(input : ^[]byte) {
	banana_market : map[[4]int]int
	secrets : [dynamic]u64
	input := bytes.split(input^, {'\n'})
	for line in input {
		trimmed := bytes.trim(line, {'\r'})
		append(&secrets, u64(parse_num(trimmed)))
	}
	secret : u64 = 123
	prev : int = int(ones_digit(secret))

	ones : [dynamic]int
	append(&ones, 123)
	for i in 0..<10 { 
		secret = next_secret(secret)
		fmt.println(secret)
		secret_ones : int = int(ones_digit(secret))
		append(&ones, secret_ones - prev)
		prev = secret_ones
	}
	fmt.println("---")
	for n in ones {
		fmt.println(n)
	}

	// part one
	// result : u64 = 0
	// for scrt in secrets {
	// 	result += nth_secret(scrt, 2000)
	// }
	//



	// fmt.println("\nRESULT:", result)
}


mix :: proc(num : u64, secret : u64) -> u64 {
	return num ~ secret
}

prune :: proc(secret : u64) -> u64 {
	return secret % 16777216
}

next_secret :: proc(num: u64) -> u64 {
	step_one := prune(mix(num, (num * 64)))
	step_two := prune(mix(step_one, step_one/32))
	return prune(mix(step_two, step_two * 2048))
	
}

nth_secret :: proc(secret: u64, n: int) -> u64 {
	num := secret
	for i in 0..<n {
		num = next_secret(num)	
	}
	return num
}

ones_digit :: proc(num : u64) -> u64 {
	return num % 10
}
