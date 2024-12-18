package main

import "core:bytes"
import "core:fmt"
import rl "vendor:raylib"

Robot :: struct {
	loc : XY,
	velocity : XY,
}

day_14 :: proc(input: ^[]byte) {
	fmt.println("day 14")
	robots : [dynamic]Robot
	input := bytes.split(input^, {'\n'})
	for line in input {
		temp : [dynamic]Robot
		trimmed := bytes.trim(line, {'\r'})
		first_split := bytes.split(trimmed, {' '})
		pos : XY
		vel : XY
		left := bytes.split(first_split[0], {','})
		right := bytes.split(first_split[1], {','})
		pos.x = parse_num(left[0][2:])
		pos.y = parse_num(left[1])
		vel.x = parse_num(right[0][2:])
		vel.y = parse_num(right[1])
		append(&robots, Robot{pos, vel})
	}

	for robo in robots {
		fmt.println(robo)
	}

	rl.InitWindow(1000, 1000, "Day 14")
	rl.SetTargetFPS(440)
	num_cols : int = 101
	num_rows : int = 103
	// num_cols : int = 11
	// num_rows : int = 7
	margin : f32 = 42
	tilesize : f32 = (f32(1000) - 3 * margin) / f32(num_cols)
	i : = 0
	frame : = 1
	no_tree : bool = true
	rate : = 1
	for !rl.WindowShouldClose() {
		rl.BeginDrawing()
		rl.ClearBackground(rl.BLACK)
		for robo in robots {
			draw_row_col_size_color(robo.loc.y, robo.loc.x, num_rows, num_cols, margin, tilesize, 1, {255, 255, 255, 255}
			)
		}
		rl.DrawRectangleLinesEx({margin- 5, margin-5, margin + f32(num_cols) * tilesize+ 10, margin + f32(num_rows) * tilesize + 10}, 2, {20, 75, 20, 255})

		if rl.IsKeyDown(.A) {
			no_tree = true
			i += 1
		}
		if i < 6446 {
			if i == 6440 do rate = 30
			if frame % rate == 0 {

				fmt.println("FRAME: ", i)
				for &robo in robots {
					robo.loc.x += robo.velocity.x
					if robo.loc.x < 0 do robo.loc.x += num_cols
					robo.loc.x %= num_cols 
					robo.loc.y += robo.velocity.y
					if robo.loc.y < 0 do robo.loc.y += num_rows
					robo.loc.y %= num_rows
				}
				// for robo in robots {
				// 	fmt.println(robo)
				// }
				// fmt.println()

				fmt.println("calculating quadrants")
				a, b, c, d : int
				total := 0
				for robot in robots {
					l := robot.loc
					mid_col : = num_cols / 2
					mid_row : = num_rows / 2
					if l.x < mid_col {
						// left side
						if l.y < mid_row {
							// top left
							a += 1
						} else if l.y > mid_row {
							// bottom left
							b += 1
						}
					} else if l.x > mid_col {
						// right side, ignoring middle col
						if l.y < mid_row {
							// top right
							c += 1
						} else if l.y > mid_row {
							// bottom right
							d += 1
						}

					}

				}
				i += 1
				fmt.println(a, b, c, d)
				fmt.println("Safety factor:", a*b*c*d)
				if a == c && b == d  && a < b {
					no_tree = false
					fmt.println(i)
				}
			} else if i == 100 {
				fmt.println("calculating quadrants")
				a, b, c, d : int
				total := 0
				for robot in robots {
					l := robot.loc
					mid_col : = num_cols / 2
					mid_row : = num_rows / 2
					if l.x < mid_col {
						// left side
						if l.y < mid_row {
							// top left
							a += 1
						} else if l.y > mid_row {
							// bottom left
							b += 1
						}
					} else if l.x > mid_col {
						// right side, ignoring middle col
						if l.y < mid_row {
							// top right
							c += 1
						} else if l.y > mid_row {
							// bottom right
							d += 1
						}

					}

				}
				fmt.println(a, b, c, d)
				fmt.println("Safety factor:", a*b*c*d)
				i += 1
			}
		}

			frame += 1
		rl.EndDrawing()
	}
	rl.EndMode2D()
	rl.EndDrawing()

}
