package main

import "core:bytes"
import "core:fmt"
import "core:math"

day_13 :: proc(input: ^[]byte) {
	map_ : [dynamic][dynamic][]byte

	input := bytes.split(input^, {'\r'})
	for line in input {
		temp : [dynamic][]byte
		trimmed := bytes.trim(line, {'\n'})
		for b in bytes.split(trimmed, {' '}) {
			append(&temp, b)
		}
		append(&map_, temp)
	}

	asd : XY64
	button_a : XY64
	button_b : XY64
	prize : XY64
	fmt.println(map_)
	fmt.println()
	total : u64 = 0
	for line, i in map_ {
		if i % 4 == 0 {		// button A
			button_a.x = u64( parse_num(line[2][2:]) )
			button_a.y = u64( parse_num(line[3][2:]) )
			fmt.println("A:", button_a.x, button_a.y)
		} else if i % 4 == 1 {		// button B
			button_b.x = u64( parse_num(line[2][2:]) )
			button_b.y = u64( parse_num(line[3][2:]) )
			fmt.println("B:", button_b.x, button_b.y)
		} else if i % 4 == 2 { 
			prize.x = u64( parse_num(line[1][2:]) ) + 10000000000000
			prize.y = u64( parse_num(line[2][2:]) ) + 10000000000000
			fmt.println("Prize:", prize.x, prize.y)
			fmt.println( "a.x:", button_a.x, "a.y:", button_a.y, )
			fmt.println( "b.x:", button_b.x, "b.y:", button_b.y)
			fmt.println("a.x/b.x:", f64(button_a.x) / f64(button_b.x))
			fmt.println("a.y/b.y:", f64(button_a.y) / f64(button_b.y))
			// -------------------------------------------------------------------------------------------------
			a_mult : f64 = f64(button_a.y) / f64(button_a.x)
			b_mult : f64 = f64(button_b.y) / f64(button_b.x)

			b_y_offset : f64 = b_mult * (-f64(prize.x)) + f64(prize.y)
			x: f64 = b_y_offset / (a_mult - b_mult)

			// fmt.println("MATHSOL: x: ", x, "x/buttonax:", x/f64(button_a.x))
			amult : u64 = u64(math.round(x / f64(button_a.x)))

			lowest_cost : u64 = 9999999999999999999
			lowest_presses : XY64 
			max_a := min(prize.x / button_a.x, prize.y / button_a.y)
			fmt.println("maxa: ", max_a, "gcd:", math.gcd(prize.x, button_a.x))

			axy : XY64
			diff : XY64
			sol : bool = false

			axy.x = amult * button_a.x
			bmult := (prize.x - axy.x) / button_b.x
			solxy : XY64 
			solxy.x = button_a.x * amult + button_b.x * bmult
			solxy.y = button_a.y * amult + button_b.y * bmult
			if solxy.x == prize.x && solxy.y == prize.y {
				fmt.println("MATHSOL?", amult, bmult)
				sol = true
				lowest_cost = amult * 3 + bmult
				fmt.println(solxy)
				// total += u64(amult * 3 + bmult)

			}
			// brutest force

			/*
			for a in 1..=max_a {

				axy.x = a * button_a.x
				axy.y = a * button_a.y
				diff.x = prize.x - axy.x
				diff.y = prize.y - axy.y
				max_b := min(diff.x / button_b.x, diff.y / button_b.y)
				for b in max_b-2..=max_b {
					bxy : XY64
					bxy.x = b * button_b.x
					bxy.y = b * button_b.y
					a_plus_b : XY64
					a_plus_b.x = axy.x + bxy.x
					a_plus_b.y = axy.y + bxy.y
					if a_plus_b.x == prize.x && a_plus_b.y == prize.y {
						sol = true
						fmt.println("BRUTE SOLUTION!")
						fmt.println("presses of a:", a, "presses of b:", b, "a/b:", f64(a)/f64(b))

						fmt.println("a:", a* button_a.x, a* button_a.y, "b:", b* button_b.x, b * button_b.y)
						if amult != a {
							fmt.println("---!!! DISAGREEMENT !!! ---")
						}
						cost : = a * 3 + b
						if cost < lowest_cost {
							lowest_cost = cost
							lowest_presses.x = a
							lowest_presses.y = b
						}
					}
				}
			}

			*/

			if sol {
				fmt.println("Solution found!", lowest_cost)
				total += u64(lowest_cost)
			} else {
				fmt.println("NO solution")

			}


			fmt.println()
			fmt.println()
		}
	}
	fmt.println("RESULT: ", total)
}
// wrong 209917198607440
