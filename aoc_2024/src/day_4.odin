package main

import "core:fmt"

Dir :: enum {
	N,
	NE,
	E,
	SE,
	S,
	SW,
	W,
	NW,
}

XDir :: enum {
	NE,
	SE,
	SW,
	NW,
}

xdir_offset :: proc(d: XDir) -> (int, int) {
	x, y : int

	switch d {
	case .NE:
		x = 1
		y = -1
	case .SE:
		x = 1
		y = 1
	case .SW:
		x = -1
		y = 1
	case .NW:
		x = -1
		y = -1
	}

	return x, y
}

dir_offset :: proc(d: Dir) -> (int, int) {
	x, y : int

	switch d {
	case .N:
		x = 0
		y = -1
	case .NE:
		x = 1
		y = -1
	case .E:
		x = 1
		y = 0
	case .SE:
		x = 1
		y = 1
	case .S:
		x = 0
		y = 1
	case .SW:
		x = -1
		y = 1
	case .W:
		x = -1
		y = 0
	case .NW:
		x = -1
		y = -1
	}

	return x, y
}

get_line_len :: proc(input: ^[]byte) -> int {
	for c, i in input {
		if c == '\n' {
			return i + 1
		}
	}
	return 0
}

xy_to_i :: proc(x, y, line_length, input_length: int) -> (int, bool) {
	i : int
	ok : bool = false
	i = (y * line_length) + x
	if i >= 0 && i < input_length do ok = true
	return i, ok
}

count_xmas_sweep :: proc(input: ^[]byte, i, x, y: int) -> int {
	line_length : int = get_line_len(input)
	xmas : []byte = { 'X', 'M', 'A', 'S' }
	result : int = 0
	x_offset, y_offset  : int
	ok : bool
	global_i := i
	i_local : int

	// fmt.print(string([]u8{input[i], 0 }))
	// i_local, ok = xy_to_i(x, y, line_length, len(input))
	// fmt.print("i", i, "l_i", i_local)
	// fmt.print(i_local)

	direct: for d in Dir {
		// fmt.print("\nd: ", d)
		x_dir, y_dir := dir_offset(d)
		// fmt.print(" dirx: ", x_dir, ", diry: ", y_dir)
		for k in 1..<4 {
			x_offset = x_dir * k
			y_offset = y_dir * k
			local_x := x + x_offset
			local_y := y + y_offset
			// if local_x < 0 do continue direct
			// if local_x >= line_length do continue direct
			// if local_y < 0 do continue direct
			// if local_y >= len(input)/line_length do continue direct

			// if d == .W do fmt.print("W: ", local_x, local_y)
			i_local, ok = xy_to_i(local_x, local_y, line_length, len(input))
			if !ok do continue direct
			if xmas[k] != input[i_local] do continue direct
			// fmt.print(" xmas: ", string([]u8{xmas[k]}), string([]u8{input[i_local]}))
			// fmt.print("   ", local_x, ",", local_y)
		}
		// fmt.print(" ++ ")
		result += 1
	}
	return result
}

count_x_mas :: proc(input: ^[]byte, i, x, y : int) -> int {
	result : int = 0
	x_offset, y_offset  : int
	line_length : int = get_line_len(input)
	mascount : int
	ok : bool
	i_local : int

	for d in XDir {
		fmt.print(d)
		x_dir, y_dir := xdir_offset(d)
		local_x := x + x_dir
		local_y := y + y_dir
		i_local, ok = xy_to_i(local_x, local_y, line_length, len(input))
		if !ok do continue 
		if input[i_local] == 'M' {
			// fmt.print(input[i_local])
			fmt.print(string([]u8{input[i_local]}))
			local_x := x - x_dir
			local_y := y - y_dir
			i_local, ok = xy_to_i(local_x, local_y, line_length, len(input))
			if !ok do continue 
			if input[i_local] == 'S' {
				fmt.print(string([]u8{input[i_local]}))
				mascount += 1
			}

		}
		if mascount == 2 do return 1
		

	}

	return 0
}

day_4a :: proc(input: ^[]byte) {

	count : int = 0
	total : int = 0
	x, y : int = 0, 0

	for i:int=0; i < len(input); i+=1 {
		if input[i] == 10 {
			// i+= 1
			continue
		}

		if input[i] == 13 {
			y += 1
			fmt.println()
			x = 0
			continue
		}
		

		if input[i] == 'X' {
			// fmt.print("i:", i, " x:", x, " y: ", y, ": ")

			count = count_xmas_sweep(input, i, x, y)
			// fmt.println()
			fmt.print(count)
			total += count
		} else {
			fmt.print(".")

		}
		x += 1
	}

	fmt.println("\n\nRESULT:", total)
}

day_4b :: proc(input: ^[]byte) {

	count : int = 0
	total : int = 0
	x, y : int = 0, 0
	fmt.println("day_4b")

	for i:int=0; i < len(input); i+=1 {
		if input[i] == 10 {
			// i+= 1
			continue
		}

		if input[i] == 13 {
			y += 1
			fmt.println()
			x = 0
			continue
		}
		

		if input[i] == 'A' {
			// fmt.print("i:", i, " x:", x, " y: ", y, ": ")

			count = count_x_mas(input, i, x, y)
			// fmt.println()
			fmt.print(count)
			total += count
		} else {
			fmt.print(".")

		}
		x += 1
	}

	fmt.println("\n\nRESULT:", total)
}
