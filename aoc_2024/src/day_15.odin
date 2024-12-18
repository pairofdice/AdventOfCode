package main

import rl "vendor:raylib"
import "core:fmt"
import "core:bytes"

Rbt :: struct {
	loc : XY,
	command_index: int,
}

done : bool
day_15 :: proc(input: ^[]byte) {
	done = false
	fmt.println("Day 15")
	room : [dynamic][dynamic]int
	commands : [dynamic]byte
	id : int = 100

	input := bytes.split(input^, {'\n'})
	for line in input {
		linetrimmed := bytes.trim(line, {'\r'})
		l : [dynamic]int
		if line[0] == '#' {
			for c in linetrimmed {
				if c == '@'{
					append(&l, 64)
					append(&l, 46)
				} else if c == 79 {
					append(&l, id)
					append(&l, id)
					id += 1
				} else {
					append(&l, int(c))
					append(&l, int(c))
				}

			}
			append(&room, l)
		} else if len(linetrimmed) > 0 {
			for c in linetrimmed {
				append(&commands, c)
			}
		}
	}
	robot : Rbt
	for line, y in room {
		for c, x in line {
			if c == 64 {
				room[y][x] = 46
				robot.loc.x = x
				robot.loc.y = y
			}
		}
		fmt.println(line)
	}
	fmt.println(robot)

	fmt.println(string(commands[:]))



	s : i32 = 720
	rl.InitWindow(s, s, "Day 15")
	rl.SetTargetFPS(30)
	num_cols : int = len(room[0])
	num_rows : int = len(room)
	margin : f32 = 42
	tilesize : f32 = (f32(s) - 3 * margin) / f32(num_cols)
	frame := -20
	printed : bool = false
	for !rl.WindowShouldClose() {
		if !done && frame > 0 && frame % 20 == 0 do day15update(&room, &commands, &robot)
		if done && !printed {
			print_sum_coords(&room)
			printed = true
		}
		rl.BeginDrawing()
		rl.ClearBackground(rl.BLACK)
		for row, row_i in room {
			for chr, col_i in row {
				if chr == 35 {				// # - 35
					draw_row_col_size_color(
						row_i, 
						col_i, 
						num_rows, 
						num_cols, 
						margin, 
						tilesize, 
						1, 
						{255, 255, 255, 255})
				} else if chr == 46 {			// . - 46
					// draw_row_col_size_color(
					// 	row_i, 
					// 	col_i, 
					// 	num_rows, 
					// 	num_cols, 
					// 	margin, 
					// 	tilesize, 
					// 	0.4, 
					// 	{55, 55, 55, 255})
				} else if chr > 99 {			// O - 79
					draw_row_col_size_color(
						row_i, 
						col_i, 
						num_rows, 
						num_cols, 
						margin, 
						tilesize, 
						0.85, 
						{105, 5, 5, 255}, true)
					draw_row_col_size_color(
						row_i, 
						col_i, 
						num_rows, 
						num_cols, 
						margin, 
						tilesize, 
						0.85, 
						{255, 0, 0, 255})
				} 
				draw_row_col_size_color(
					robot.loc.y, 
					robot.loc.x, 
					num_rows, 
					num_cols, 
					margin, 
					tilesize, 
					0.6, 
					{5, 15, 5, 255}, true)
				draw_row_col_size_color(
					robot.loc.y, 
					robot.loc.x, 
					num_rows, 
					num_cols, 
					margin, 
					tilesize, 
					0.6, 
					{55, 255, 55, 255})
			}
		}

		rl.EndDrawing()
		frame += 1
	}
	rl.EndMode2D()
	rl.EndDrawing()

}

day15update :: proc(room : ^[dynamic][dynamic]int, commands : ^[dynamic]byte, robot: ^Rbt) {
	fmt.println(robot.command_index, "/", len(commands))
	ok : bool
	if robot.command_index >= len(commands) {
		done = true
		return
	}
	reset := robot.loc
	command := commands[robot.command_index]
	switch command {
	case '<':
		robot.loc.x -= 1
	case '^':
		robot.loc.y -= 1
	case '>':
		robot.loc.x += 1
	case 'v':
		robot.loc.y += 1
	}
	if room[robot.loc.y][robot.loc.x] == '#' {
		robot.loc = reset
	} else if room[robot.loc.y][robot.loc.x] > 99 {
		ok = try_move_boxes(robot.loc, room, command)
		if !ok do robot.loc = reset

	}


	robot.command_index += 1
}

try_move_boxes :: proc(loc: XY, room: ^[dynamic][dynamic]int, command: byte) -> bool {
	// # 35
	// . 46
	loc_look : = loc
	for room[loc_look.y][loc_look.x] != 35 && room[loc_look.y][loc_look.x] != 46 {

		switch command {
		case '<':
			loc_look.x -= 1
		case '^':
			loc_look.y -= 1
		case '>':
			loc_look.x += 1
		case 'v':
			loc_look.y += 1
		}
		if room[loc_look.y][loc_look.x] == 46 {
			room[loc.y][loc.x] = 46 
			room[loc_look.y][loc_look.x] = 79			// 79 = O
			return true
		} else if room[loc_look.y][loc_look.x] == 35 {
			return false
		}
			
	} 
	return false
}

print_sum_coords :: proc(room : ^[dynamic][dynamic]int) { 
	result := 0

	for row, y in room {
		for c, x in row {
			if room[y][x] == 79 {
				result += 100 * y + x
			}

		}
	}
	fmt.println(result)
}
