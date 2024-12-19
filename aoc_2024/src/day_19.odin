package main

import "core:fmt"
import "core:bytes"
import q "core:container/queue"

day_19 :: proc(input: ^[]byte) {
	input := bytes.split(input^, {'\n'})
	raw_patterns : [dynamic][]byte
	patterns : [dynamic][]byte
	designs : [dynamic][]byte
	for p in bytes.split(input[0], {','}) {
		trimmed := bytes.trim(p, {' ', '\r'})
		append(&raw_patterns, trimmed)
	}

	for d in input[2:] {
		trimmed := bytes.trim(d, {'\r'})
		append(&designs, trimmed)
	}

	// pattern_max_len : int = 0 
	// for p in raw_patterns {
	// 	if len(p) > pattern_max_len do pattern_max_len = len(p)
	// } 
	// fmt.println("------------------------")
	//
	// for p in raw_patterns {
	// 	fmt.printf("%s\n", p)
	// }
	// fmt.println("------------------------")
	//
	// fmt.println("------------------------")
	// for p in patterns {
	// 	fmt.printf("%s\n", p)
	//
	// }

	fmt.println("------------------------")
	fmt.println("raw pattern len:", len(raw_patterns), "processed patterns:", len(patterns))

	// print_things(patterns)
	// print_things(designs)

	count_possible : int = 0
	frontier : q.Queue([dynamic]byte)
	// test()

	for i in 0..<len(designs) { 
		fmt.printf("%s\n", designs[i])
		q.clear(&frontier)
		append_patterns(&frontier, &patterns, &designs[i])
		count_possible += is_design_possible(&designs[i], &patterns, &frontier)
	}


	fmt.println("\nResult:", count_possible)
}

is_design_possible :: proc(design: ^[]byte, patterns: ^[dynamic][]byte, frontier: ^q.Queue([dynamic]byte)) -> int { 
	matches : bool = false
	for q.len(frontier^) > 0 {
		node := q.pop_front(frontier)
		if len(node) == len(design) do return 1
		for &p in patterns {
			// TODO only push if pattern matches correct substring of design
			if pattern_matches_design(len(node), &p, design) {
				a : [dynamic]byte
				append_elems(&a, ..node[:])
				append_elems(&a, ..p[:])
				fmt.printf("Pushing: %s\n", a)
				q.push_back(frontier, a)
			}
		}
	}
	return 0
}

pattern_matches_design :: proc(index: int, pattern: ^[]byte, design: ^[]byte) -> bool {
	for i in 0..<len(pattern) {
		if len(design) > index + i {
			if design[index + i] != pattern[i] do return false
		} else do return false
	}
	return true
}

append_patterns :: proc(frontier: ^q.Queue([dynamic]byte), patterns: ^[dynamic][]byte, design: ^[]byte) {
	for &p in patterns {
		pattern : [dynamic]byte
		for b in p {
			append(&pattern, b)
		}
		if pattern_matches_design(0, &p, design) {
			a : [dynamic]byte
			append_elems(&a, ..p[:])
			q.push_back(frontier, a)
		}
	}
}





is_design_possible_rec :: proc(design: []byte, patterns: ^[dynamic][]byte) -> int {
	// fmt.printf("% 10s %d len: %d\n", design, design, len(design))
	pattern_len : int
	matches : bool
	last_chance : bool = true
	if len(design) == 1 {
		for p in patterns {
			if len(p) == 1 { 
				if design[0] == p[0] do last_chance = false
			}
		}

	} else do last_chance = false
	if last_chance {
		return 0
	} 
	for p in patterns {
		// fmt.printf(" %s ", p)
		pattern_len = len(p)
		matches = false
		if pattern_len > len(design) do continue
		for i in 0..<pattern_len {
			if p[i] != design[i] do break
			// fmt.printf("[%s matches]\n", p)
			if i == pattern_len - 1 do matches = true
		}


		if matches {
			if pattern_len == len(design) {
				fmt.printf("pattern possible, END\n\n")
				return 1
			}
			if is_design_possible_rec(design[pattern_len:], patterns) == 1 do return 1
		} 
	}
	// fmt.printf("\npattern impossible\n\n")
	return 0
}







print_things :: proc(list: [dynamic][]byte) {
	fmt.println("--------------------------------------------")

	for i in 0..<len(list) {
		fmt.printf("%s ", list[i])
	}

	fmt.println("\n--------------------------------------------")
}

test :: proc() {
	fmt.println("TESTING")
	a : [dynamic]byte = {4, 5, 6}
	b : [dynamic]byte = {7, 8, 9}
	append_elems(&a, ..b[:])
	fmt.println(a)
	fmt.println("TESTING")
}
