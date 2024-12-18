package main


import "core:bytes"
import "core:fmt"

day_7 :: proc(input: ^[]byte) {
	lines := bytes.split(input^, {'\n'})
	for line in lines {
		line := bytes.split(line, {' '})	
		nums : [dynamic]int
		for n in line {
			append(&nums, parse_num(n))
		}
	
		goal : int = nums[0]
		fmt.println(nums)
		// result := check_equation(goal, nums[1], nums[1:len(nums)])
		// fmt.print(" result: ", result)
	}

}

check_equation :: proc(goal: int, total: int, nums: []int) -> int {
	// count_permutations := 1 << uint(len(nums) - 2)
	for i in 0..<len(nums) - 1 {
	}

	return total
}
