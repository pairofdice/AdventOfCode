package main

import "core:fmt"
import "core:bytes"
import "core:time"
import "core:math/big"

day_11 :: proc(input: ^[]byte) {
	input := bytes.trim(input^, {'\r', '\n'})
	inputsplit := bytes.split(input, []u8{' '})
	stones : [dynamic]u64
	counts : map[u64]u64
	temp : map[u64]u64
	for num in inputsplit {
		append(&stones, u64(parse_num(num)))
	}
	for num in stones {
		counts[num] = 1
	}
	test_num_digits_is_even()
	test_split_num()
	fmt.println("Tests done\n")

	blinks := 75
	// fmt.println(stones)
	fmt.println(counts)
	fmt.println()
	start : time.Time = time.now()
	for i in 0..<blinks {
		blinkmap(&counts, &temp)
		// blink(&stones)
		fmt.println("blink", i, "done, stone count:",  "timer", time.since(start))
	}
	result : u64 = 0
	fmt.println()
	for key, value in counts {
		if value > 0 {
			fmt.print(key, "", value, ", ")
			result += value
		}
	}
	// fmt.println("\nRESULT:", len(stones))
	fmt.println()
	fmt.println("\nRESULT:", result)
	// WRONG 253582806898300
	// WRONG 253582809323481
	// WRONG 253582806885538
	//       253582806874332
	//	 253582806509115
	// right 253582809724830
}

blink :: proc(stones: ^[dynamic]u64) {

	// for stone, i in stones {
	stone : u64
	i : u64 = 0
	len : u64 = u64(len(stones))
	for i < len {
		stone = stones[i]
		num_digits : int = num_digits(u64(stone))
		if stone == 0 do stones[i] = 1
		else if num_digits % 2 == 0 {
			left, right := split_nump(stone, u64(num_digits))

			stones[i] = left
			append(stones, right)
		} else do stones[i] = stone * 2024
		i += 1
	}
}

blinkmap :: proc(counts: ^map[u64]u64, temp: ^map[u64]u64) {
	clear(temp)
	
	for key, value in counts {
		num_d := num_digits(key)
		if value < 1 do continue
		if key == 0 {
			temp[1] += value
		} else if num_d % 2 == 0 {
			left, right := split_nump(key, u64(num_d))
			temp[left] += value
			temp[right] += value
		} else {
			temp[key * 2024] += value
		}

	}
	clear(counts)
	for key, value in temp {
		counts[key] = value
	}
}

num_digits :: proc(num: u64) -> int {
	num_digits : int
	num := num
	if num == 0 do return 1
	for num > 0 {
		num /= 10
		num_digits += 1
	}
	return num_digits
}

num_digits_is_even :: proc(num: u64) -> bool {
	num_digs := num_digits(num)
	// fmt.print("digits:", num_digs, "")
	if num_digits(num) % 2 == 0 do return true
	else do return false
}


split_nump :: proc(num: u64, num_digits : u64) -> (u64, u64) {
	num := num
	// num_digits := num_digits(num)
	left, right : u64
	power : u64 = 1
	left = num
	for i in 0..<num_digits/2 {
		
		power *= 10
	}

		right = num % power
		left /= power
		power *= 10
	return left, right
}

split_num :: proc(num: u64, num_digits : u64) -> (u64, u64) {
	num := num
	// num_digits := num_digits(num)
	left, right : u64
	power : u64 = 1
	left = num

	for _ in 0..<num_digits / 2 {
		right += (num % 10) * power
		num /= 10
		left /= 10
		power *= 10
	}
	return left, right
}

test_num_digits_is_even :: proc() {
	fmt.println("Testing is_even")
	nums : []u64 = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 55, 99, 100, 666, 999, 1000, 2222, 9999, 10000}
		//		0	1	2	3	4	5	6	7	8	9	10	11	12	13	14	15	16	17	18	19
	is_even : []bool = {	false,	false,	false,	false,	false,  false,  false,	false,	false,	false,	true,	true,	true,	true,	true,	true,	true,	true,	true,	true,	
	//	20      21	55	99	100	666	999	1000	2222	9999	10000}
		true,	true,	true,	true,	false,	false,	false,	true,	true,	true,	false}
	for i in 0..<len(nums) {
		if num_digits_is_even(nums[i]) == is_even[i] do fmt.println("case", nums[i], "correct ")
		else {
			fmt.println("case", nums[i], "is WRONG, should be",  is_even[i])
		}
	}
	fmt.println("is_even tests done\n")
}

test_split_num :: proc() {
	fmt.println("Testing splits")
	nums : []u64 = {	10,	11,	20,	99,	1000,	1111,	2222,	2002,	9999,	100000,	100001}
	splits : [][]u64 = {
		{1, 0},
		{1, 1},
		{2, 0},
		{9, 9},
		{10, 0},
		{11, 11},
		{22, 22},
		{20, 2},
		{99, 99},
		{100, 0},
		{100, 1},
	}

	for i in 0..<len(nums) {
		numd : u64 = u64(num_digits(nums[i]))
		left, right : u64 = split_num(nums[i], numd)
		if left == splits[i][0] && right == splits[i][1] {
			fmt.println("case", nums[i], left, "", right, "correct")
		} else {
			fmt.println("case", nums[i], left, "", right, "WRONG")
		}

	}
}
