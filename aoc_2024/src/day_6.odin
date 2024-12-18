package main

import "core:bytes"
import "core:fmt"
import rl "vendor:raylib"

Facing :: enum {
	Up,
	Right,
	Down,
	Left,
}

facing_xy :: proc(d: Facing) -> (int, int) {
	x, y : int

	switch d {
	case .Up:
		x = 0
		y = -1
	case .Right:
		x = 1
		y = 0
	case .Down:
		x = 0
		y = 1
	case .Left:
		x = -1
		y = 0
	}
	return x, y
}

Guard :: struct {
	x: int,
	y: int,
	dir: Facing,
	dir_i: int
}


has_hit_obstacle : bool = false
loop : bool = false
day_6 :: proc(input: ^[]byte) {
	loops_counter : int = 0
	tilesize : f32 = 32
	rl.InitWindow(1000, 1000, "Day 6")
	rl.SetTargetFPS(44)
	
	room : [dynamic][2]int
	history : [dynamic][3]int

	guard : Guard
	startx : int
	starty : int
	loop_test : [2]int
	history_index : int = 0

	x, y : int
	for c in input {
		switch c {
		case '\n':
			y += 1
			x = 0
		case '#':
			append(&room, [2]int{x, y})
			x += 1
		case '^':
			guard.x = x
			guard.y = y
			guard.dir = .Up
			guard.dir_i = 0
			x += 1
		
		case '.':
			x += 1
		}
	}
	startx = guard.x
	starty = guard.y
	width := x
	height := y + 1
	part_one : bool = true
	prev_obstacle : [2]int = {12, 12}
	append(&room, prev_obstacle)
	done : bool = false

	for !rl.WindowShouldClose() {
		if guard.x >= 0 && guard.x < width && guard.y >= 0 && guard.y < height {
			if !part_one && !done{
				if has_hit_obstacle do fmt.println("--- obstacle---")
				has_hit_obstacle = false

				if loop {

					history_index += 1
					prev_obstacle = pop(&room)
					append(&room, [2]int{history[history_index][0], history[history_index][1]})
					guard.x = startx
					guard.y = starty
					guard.dir = .Up
					loops_counter += 1
					fmt.println("loops: ", loops_counter)
					
					loop = false
				}

			}
			update_guard(&room, &guard, &history)
		} else {
			fmt.println("OUT OF BOUNDS, RESET")
			history_index += 1
			prev_obstacle = pop(&room)
			append(&room, [2]int{history[history_index][0], history[history_index][1]})
			guard.x = startx
			guard.y = starty
			guard.dir = .Up
			part_one = false
		}

		rl.BeginDrawing()
		rl.ClearBackground(rl.BLACK)

		rl.DrawRectangleLinesEx({0,0, tilesize * f32(width), tilesize * f32(width)}, 2, rl.DARKGREEN)
		rl.DrawRectangleLinesEx({f32(guard.x) * tilesize, f32(guard.y) * tilesize, tilesize, tilesize}, 2, rl.WHITE)
		for x, i in room {
			if i == len(room) - 1 {
				rl.DrawRectangleLinesEx({f32(x[0]) * tilesize, f32(x[1]) * tilesize, tilesize, tilesize}, 1, rl.GREEN)
			} else do rl.DrawRectangleLinesEx({f32(x[0]) * tilesize, f32(x[1]) * tilesize, tilesize, tilesize}, 1, rl.LIGHTGRAY)
		}
		for x in history {
			if part_one {
				rl.DrawRectangleLinesEx({f32(x[0]) * tilesize + tilesize / 3, f32(x[1]) * tilesize + tilesize / 3, tilesize / 3, tilesize / 3}, 1, rl.RED)
			}
		}

		rl.EndMode2D()
		rl.EndDrawing()

	}
}

good_loc :: proc(room: ^[dynamic][2]int, loc: [2]int) -> bool {
	for furniture, i in room {
		if furniture[0] == loc[0] && furniture[1] == loc[1] {
			if i == len(room) - 1 {
				if has_hit_obstacle {
					fmt.println("[loop]")
					loop = true
				}
				has_hit_obstacle = true
			}
			return false
		}
	}
	return true
}

next_loc :: proc (guard: ^Guard) -> [2]int {
	dir_x, dir_y : = facing_xy(guard.dir)
	next_loc : [2]int = {guard.x + dir_x, guard.y + dir_y}
	return next_loc
	
}

loc_in_history :: proc(history: ^[dynamic][3]int, loc: [2]int) -> bool {
	for h in history {
		if h[0] == loc[0] && h[1] == loc[1] do return true
	}
	return false
}

loc_in_history_with_dir :: proc(history: ^[dynamic][3]int, loc: [3]int) -> bool {
	for h in history {
		if h[0] == loc[0] && h[1] == loc[1] && h[2] == loc[2] do return true
	}
	return false
}

update_guard :: proc(room: ^[dynamic][2]int, guard: ^Guard, history: ^[dynamic][3]int) {
	

	if !loc_in_history(history, {guard.x, guard.y}) {
		append(history, [3]int{guard.x, guard.y, int(guard.dir)})
		fmt.println(len(history))
	} else do fmt.println("Already visited")

	good_loc_bool : bool = false
	next : [2]int

	for !good_loc_bool {
		next =  next_loc(guard)
		good_loc_bool = good_loc(room, next)
		if good_loc_bool do break
		guard.dir += Facing(1)
		if guard.dir == Facing(4) do guard.dir = Facing(0)
	}
	guard.x = next[0]
	guard.y = next[1]
}
