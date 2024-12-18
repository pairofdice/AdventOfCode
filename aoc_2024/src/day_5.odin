package main

import "core:bytes"
import "core:fmt"

day_5 :: proc(input: ^[]byte) {
	result : int
	input := bytes.split(input^, {'\n'}, context.allocator)
	section := 1
	left : int = 0
	right : int = 0
	ruleslr : map[int][dynamic]int
	ruleslr = make(map[int][dynamic]int)

	rulesrl : map[int][dynamic]int
	rulesrl = make(map[int][dynamic]int)

	for line in input {
		if line[0] == 13 {
			section = 2
			continue
		}
		if section == 1 {

			left = int(10 * (line[0] - '0') + (line[1] - '0'))
			right = int(10 * (line[3] - '0') + (line[4] - '0'))

			if right not_in rulesrl do rulesrl[right] = { left }
			else {
				append(&rulesrl[right], left)
			}

			if left not_in ruleslr do ruleslr[left] = { right }
			else {
				append(&ruleslr[left], right)
			}
		} else if section == 2 {
			update : [dynamic]int
			linelen := 0
			if line[len(line) - 1] == 13 do linelen = len(line) -1
			else do linelen = len(line)
			s2line := bytes.split(line[0:linelen], {','})
			for u in s2line {
				num := 10 * (u[0] - '0') + (u[1] - '0')
				append(&update, int(num))
			}
			// fmt.println(s2line)
			// fmt.println(update)
			middle := process_update(update[:], &rulesrl)
			result += middle

		}

		// fmt.print(section, " ", left, "-", right, "")
		// fmt.println(line)
	}
	fmt.println("---")
	for k, v in ruleslr {
		fmt.println(k, v)
	}

	fmt.println("---")
	for k, v in rulesrl {
		fmt.println(k, v)
	}

	fmt.println("RESULT: ", result)
}

process_update :: proc(update: []int, rules: ^map[int][dynamic]int) -> int {
	result : int = 0
	correct := true
	
	for i in 0..<len(update) - 1 {
		value := update[i]	
		must_not_trail := rules[value]
		for ii in update[i+1:] {
			for k in must_not_trail {
				if ii == k do correct = false
			}

		}
	}
	// fmt.println("middle value?: ", update[len(update)/2], "")
	fmt.println(update, correct ? "correct" : "false")
	// result = correct ? update[len(update)/2] : 0

	// part 2

	if !correct {
		fmt.println("Correcting: ", update)

		for !correct {

			b: for left_i in 0..<len(update) - 1 {
				left_value := update[left_i]
				should_not_trail := rules[left_value]
				for right_i in (left_i + 1)..<len(update) {
					right_value := update[right_i]
					for x in should_not_trail {
						if right_value == x {
							t := update[left_i]
							update[left_i] = right_value
							update[right_i] = t
							fmt.print("-")
							
							break b
						}
					}

				}
			}

			correct = is_correct(update, rules)
		}
		fmt.println(" corrected!")
		result = update[len(update) / 2]

	}

	return result
	// 3587: wrong
	// 3062: correct
}

is_correct :: proc(update: []int, rules: ^map[int][dynamic]int) -> bool {
	correct := true

	for i in 0..<len(update) - 1 {
		value := update[i]	
		must_not_trail := rules[value]
		for ii in update[i+1:] {
			for k in must_not_trail {
				if ii == k do return false
			}
		}
	}
	return correct
}
