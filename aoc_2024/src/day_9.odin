package main

import "core:fmt"
import "core:strings"

day_9 :: proc(input: ^[]byte) {
	expanded : [dynamic]int
	fmt.println("raw: ", input^)
	file_index := 0
	for elem, index in input {
		if index % 2 == 0 {
			for i in 0..<elem - '0' {
				append(&expanded, file_index)
			}
			file_index += 1
		} else {
			for i in 0..<elem - '0' {
				append(&expanded, -1)
			}

		}
	}
	// input_as_string := strings.clone_from_bytes(expanded[:])
	fmt.println("exp: ", expanded)

	compact(&expanded)
	// input_as_string = strings.clone_from_bytes(expanded[:])
	fmt.println(expanded)
	fmt.println()
	fmt.println("Checksum: ", aoc9_checksum(&expanded))

	// wrong: 6394280034330
	// wrong: 6394015581036
	//        6395800119709
}

aoc9_checksum :: proc(input: ^[dynamic]int) -> u64 {
	result : u64 = 0

	for elem, index in input {
		if elem == -1 do break
		result += u64(elem * index)
		
	}

	return result
}

compact :: proc(input: ^[dynamic]int) {
	left := 0
	right := len(input) - 1

	for ;left <= right; {
		// fmt.println(left, input[left], input[right], right)
		if input[left] == -1 {
			for input[right] == -1 do right -= 1
			input[left] = input[right]
			input[right] = -1
			
			right -= 1
		}


		left += 1
	}

}
