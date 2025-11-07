package main

import "core:os"
import "core:fmt"
import "core:strconv"
import "core:slice"
import "core:strings"
import "core:bytes"

d2_record :: struct {
	levels : [dynamic]int,
	ok: bool
}


main :: proc() {
	input, ok := os.read_entire_file("data/d23.txt")
	if ok {
		day_23(&input)
	} else do fmt.println("Fukt up reading file")
}

parse_num :: proc(str: []u8) -> int {
	result, ok := strconv.parse_int(string(str))
	return result

}

day_1 :: proc(input: []u8) {

	left : [dynamic]int
	right : [dynamic]int
	is_left : bool
	was_digit : bool = true
	num : int
	numstr : [dynamic]byte
	num_start : int
	num_end : int

	for c, index in input {

		switch c {
		case '\n': {
			num_end = index

			num = parse_num(input[num_start:num_end])
			append(&right, num)
			num_start = index + 1

		}
		case '0'..='9': {
			digit := c - 48
			// num += int(digit)
			// fmt.println(digit)
			was_digit = true
		}
		case ' ': {
			if was_digit {
				num_end = index
				num = parse_num(input[num_start:num_end])
				append(&left, num)
			}

			is_left = false
			num_start = index + 1

			was_digit = false
		}
		}

	}
	for n in left {
		fmt.printf("%d ", n)
	}
	fmt.println()
	for n in right {
		fmt.printf("%d ", n)
	}

	slice.sort(left[:])
	fmt.println()
	for n in left {
		fmt.printf("%d ", n)
	}
	fmt.println()
	slice.sort(right[:])
	fmt.println()
	for n in right {
		fmt.printf("%d ", n)
	}
	fmt.println()

	total : int

	for i in 0..<len(left) {
		diff := abs(left[i] - right[i])
		total += diff
	}
	fmt.printfln("Total diffs: %d\n", total)

	lnum : int
	multiplier := 0
	total = 0

	for i in 0..<len(left) {
		lnum = left[i]
		l: for rnum in right {
			if lnum == rnum {
				multiplier += 1
			}
			if rnum > lnum {
				break l
			}
		}
		total += lnum * multiplier
		multiplier = 0
	}
	fmt.printfln("Similarity: %d", total)
}

day_2a :: proc(input: ^[]byte) {
	lines := strings.split(string(input^), "\n")


	safe_count := 0

	for l, i in lines {

		report : [dynamic]int

		for val in strings.split(strings.trim(l, "\r\n "), " ") {
			num, ok := strconv.parse_int(val)
			if ok {
				append(&report, num)
			} else do fmt.println("Something funny parsing ints", num, ok)

		}

		if process_report(report[:], i) do safe_count += 1
	}

	fmt.println("\nSafe count: ", safe_count)

}

process_report :: proc(report: []int, index: int) -> bool {
	length := len(report)
	ascending := find_slope(report)
	limit := 3
	bad_count := 0
	ok := true


	for i in 0..<length - 1 {
		curr := report[i]
		next := report[i + 1]
		diff := next - curr
		normed_diff := ascending * diff
		if normed_diff < 1 || normed_diff > limit {
			ok = false
			bad_count += 1
		}
	}

	if bad_count == 1 || bad_count == 2{
		for bad_index in 0..<length {
		ok = true
			one_bad : [dynamic]int
			for i in 0..<length {
				if i != bad_index do append(&one_bad, report[i])	
			}
			for i in 0..<len(one_bad) - 1 {
				
				curr := one_bad[i]
				next := one_bad[i + 1]
				diff := next - curr
				normed_diff := ascending * diff
				if normed_diff < 1 || normed_diff > limit {
					ok = false
				}
			}
			if ok {
				break
				
			}
		}
	}


	if !ok && bad_count < 3{

		fmt.print(index,  ascending == 1 ? "asc" : "desc",  report, " --- ")
		fmt.print(" UNsafe", bad_count, " diffs: ")
		for i in 0..<len(report) - 1 {
			fmt.print(report[i+1] - report[i], " ")
		}
		fmt.println()
	} else if ok{
		
		fmt.print(index,  ascending == 1 ? "asc" : "desc", report, " --- ")
		fmt.print(" SAFE", bad_count, " diffs: ")
		for i in 0..<len(report) - 1 {
			fmt.print(report[i+1] - report[i], " ")
		}
		fmt.println()
	}

	// } 
	return ok
}

find_slope :: proc(report: []int) -> int {
	up : = 0
	down : = 0
	for i in 0..<len(report) - 1 {
		if report[i + 1] - report[i] > 0 do up += 1
		else if report[i + 1] - report[i] < 0 do down += 1
	}
	return up > down ? 1 : -1
}

day_3 :: proc(input: ^[]byte) {
	enabled := true
	sum := 0
	mul : []byte = {109, 117, 108, 40}
	m : byte = 109
	l := len(input)
	// fmt.println(l)
	comma : byte = byte(',')
	paren : byte = byte(')')
	ddont := transmute([]u8)string("don't()")
	ddo := transmute([]u8)string("do()")

	for i:=0 ; i < l; i += 1 {
		oi := i
		chr := input[i]
		// fmt.println("\nindex: ", i)
		// fmt.print(string(input[i:i+1]), i, " ")
		if chr != 'm' && chr != 'd' {
			continue
		}	
		if i + 8 > l {
			fmt.println("BROKE")
			break
		}
		if bytes.compare(ddont, input[i:i+7]) == 0 {
			fmt.println(string( input[i:i+7] ))
			enabled = false
			i+=6
			continue
		}
		if bytes.compare(ddo, input[i:i+4]) == 0 {
			fmt.println(string( input[i:i+4] ))
			enabled = true
			i+=3
			continue
		}

		// 182 446 874
		//  58 278 420
		//  59 097 164
		// if !enabled do continue
		if bytes.compare(mul, input[i:i+4]) != 0 {	// doesn't match "mul("
			// fmt.println(" - no match")
			continue	
		}
		// now we should be at the starting m of a "mul("
		i+=4
		// fmt.print(string(input[i:i+3]))
		comma_index, ok := finding_byte(input[i:l], comma)
		if !ok {
			fmt.println("no comma")
			continue
		}

		first_num : int
		second_num : int
		// fmt.print(" should be comma: ", string(input[i + comma_index: i+comma_index + 1]))
		first_num, ok = strconv.parse_int(string(input[i:i+comma_index]))
		if !ok {
			fmt.println("not good first int")
			continue
		}
		// fmt.println("parsed num: ", first_num)

			
		i += comma_index + 1
		if i >= l do break
		right_paren_index : int
		right_paren_index, ok = finding_byte(input[i:l], paren)
		if !ok {
			fmt.println("no right parenthesis")
			continue
		}
		// fmt.print(" should be ): ", string(input[i + right_paren_index: i+right_paren_index + 1]))
		second_num, ok = strconv.parse_int(string(input[i:i+right_paren_index]))
		if !ok {
			fmt.println("not good second int")
			continue
		}
		// fmt.println("parsed num: ", second_num)
		if enabled do sum += first_num * second_num
		i += right_paren_index 
		fmt.print(string(input[oi:i + 1]))
		fmt.println("", enabled)
		
	}
	fmt.println("\nRESULT: ", sum)

}

finding_byte :: proc(input: []byte, x: byte) -> (int, bool) {
	// fmt.println("finding comma ", input[0])
	was_digit := false
	result := 0
	for c, i in input {
			result = i
		if c  >= 48 && c < 58 {
			// fmt.println("DIGIT?: ", rune(c))
			was_digit = true
		} else {
			if c == x && was_digit {
				return result, true
			} else {
				return result, false
			}
		}
	}

	return result, was_digit
}
