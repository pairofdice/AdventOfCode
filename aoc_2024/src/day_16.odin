package main

import "core:bytes"
import "core:fmt"
import rl "vendor:raylib"

State16 :: struct {
	room : [dynamic][dynamic]byte,
	costs : [dynamic][dynamic]int,
	frontier : [dynamic]Reindeer,
	curr_index : int,
	reached : [dynamic]XY,
	goal : XY,
	winners : [dynamic]Reindeer,

}

Reindeer :: struct {
	loc : XY,
	facing : Direction,
	history : [dynamic]XY,
	cost : int,
	steps : int,
}


day_16 :: proc(input: ^[]byte) {
	state : State16

	start_loc : XY
	start_facing : Direction = .East
	end : XY

	input := bytes.split(input^, {'\n'})
	x, y : int
	for line in input {
		x = 0
		linetrimmed := bytes.trim(line, {'\r'})
		l : [dynamic]byte
		costsline : [dynamic]int
		for c in linetrimmed {
			append(&costsline, 0)

			if c == 'S' {
				start_loc = {x, y}
				append(&l, '.')
			} else if c == 'E' {
				end = {x, y}
				append(&l, '.')
			} else {
				append(&l, c)
			}
			x += 1
		}
		append(&state.room, l)
		append(&state.costs, costsline)
		y += 1
	}
	start : Reindeer = {start_loc, Direction.East, {start_loc}, 0, 1}
	append(&state.reached, start.loc)
	append(&state.frontier, start)
	state.goal = end

	for row, y in state.room {
		fmt.println(string(row[:]))
		// for chr, x in row {
		// 	fmt.print(chr)
		// }
		//
		// fmt.println()
	}
	for row, y in state.costs {
		fmt.println(row)
	}


	s : i32 = 720
	rl.InitWindow(s, s, "Day 15")
	rl.SetTargetFPS(300)
	num_cols : int = len(state.room[0])
	num_rows : int = len(state.room)
	margin : f32 = 42
	tilesize : f32 = (f32(s) - 2 * margin) / f32(num_cols)
	frame := 1
	printed : bool = false
	for !rl.WindowShouldClose() {
		if len(state.frontier) > state.curr_index  && frame > 0{
			fmt.println("UPDATE!", len(state.frontier), state.curr_index)
			update_day16(&state)
		} else if printed == false {
			all_spots : [dynamic]XY
			for route in state.winners {
				fmt.println(route)
				if route.cost == state.costs[end.y][end.x] {
					for c in route.history {
						if !xy_in_list(c, &all_spots) {
							append(&all_spots, c)
						}
					}	
				}

			}
			fmt.println("--- RESULT ---:", state.costs[end.y][end.x])
			fmt.println("cost at goal:", state.costs[end.y][end.x], "len(hist) of winner", all_spots)
			printed = true
		}
		rl.BeginDrawing()
		rl.ClearBackground(rl.BLACK)
		for row, row_i in state.room {
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
						{255, 255, 255, 255}, true)
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
				}
				draw_row_col_size_color(start.loc.y, start.loc.x, num_rows, num_cols, margin, tilesize, 0.8, {0, 255, 0, 255}, true)
				draw_row_col_size_color(end.y, end.x, num_rows, num_cols, margin, tilesize, 0.8, {255, 0, 0, 255}, true)
			}
		}
		for node in state.frontier {
			draw_row_col_size_color(node.loc.y, node.loc.x, num_rows, num_cols, margin, tilesize, 0.6, {30, 30, 95, 255}, true)
			draw_row_col_size_color(node.loc.y, node.loc.x, num_rows, num_cols, margin, tilesize, 0.6, {100, 100, 255, 255})
		}
		rl.EndDrawing()
		frame += 1
		leng : int = 0
	}
}

update_day16 :: proc(state : ^State16) {
	fmt.println("len(front):", len(state.frontier) - state.curr_index) 
	node : Reindeer = state.frontier[state.curr_index]
	state.curr_index += 1
	if node.loc.x == state.goal.x && node.loc.y == state.goal.y {
		return
	}
	children := neighbours(state, node)
	for &child in children {
		l := child.loc
		if child.cost <= state.costs[l.y][l.x] || state.costs[l.y][l.x] == 0{
			state.costs[l.y][l.x] = child.cost
			// delete higher cost from frontier if it still is there
			// delete_from_frontier(state, child)
			for n in node.history {
				append(&child.history, n)
			}
				append(&child.history, child.loc)
			if child.loc.x == state.goal.x && child.loc.y == state.goal.y {
				append(&state.winners, child)
			}
			// child.history = node.history
			// append(&child.history, child.loc)
			append(&state.frontier, child)
		}

	}
}

xy_in_list :: proc(node: XY, list: ^[dynamic]XY) -> bool {
	for loc in list {
		if node.x == loc.x && node.y == loc.y
		{
			return true
		}
	}
	return false
}

reindeer_in_list :: proc(node: Reindeer, list: ^[dynamic]XY) -> bool {
	for loc in list {
		if node.loc.x == loc.x && node.loc.y == loc.y
		{
			return true
		}
	}
	return false
}

delete_from_frontier :: proc(state: ^State16, node: Reindeer) {
	index : int = -1
	for r, i in state.frontier {
		if r.loc.x == node.loc.x && r.loc.y == node.loc.y
		{
			if r.cost > node.cost {
				index = i
			}
		}
	}
	if index != -1 {
		ordered_remove(&state.frontier, index)
		if index < state.curr_index do state.curr_index -= 1
	}

}

neighbours :: proc(state: ^State16, node: Reindeer) -> [dynamic]Reindeer {
	result : [dynamic]Reindeer
	for d in Direction {
		child : Reindeer
		switch d {
		case .North:
			child.loc.x = node.loc.x
			child.loc.y = node.loc.y - 1
			child.facing = .North
			if node.facing == .North {
				child.cost = node.cost + 1
			}
			if node.facing == .East || node.facing == .West {
				child.cost = node.cost + 1001
			}
			if node.facing == .South {
				child.cost = node.cost + 2001
			}
		case .East:
			child.loc.x = node.loc.x + 1
			child.loc.y = node.loc.y
			child.facing = .East
			if node.facing == .East {
				child.cost = node.cost + 1
			}
			if node.facing == .North || node.facing == .South {
				child.cost = node.cost + 1001
			}
			if node.facing == .West {
				child.cost = node.cost + 2001
			}
		case .South:
			child.loc.x = node.loc.x
			child.loc.y = node.loc.y + 1
			child.facing = .South
			if node.facing == .South {
				child.cost = node.cost + 1
			}
			if node.facing == .East || node.facing == .West {
				child.cost = node.cost + 1001
			}
			if node.facing == .North {
				child.cost = node.cost + 2001
			}
		case .West:
			child.loc.x = node.loc.x - 1
			child.loc.y = node.loc.y
			child.facing = .West
			if node.facing == .West {
				child.cost = node.cost + 1
			}
			if node.facing == .North || node.facing == .South {
				child.cost = node.cost + 1001
			}
			if node.facing == .East {
				child.cost = node.cost + 2001
			}
		}
		if state.room[child.loc.y][child.loc.x] == '.' {
			child.steps = node.steps + 1
			append(&result, child)
		}
	}

	return result
}

/*

State16 :: struct {
	room : [dynamic][dynamic]byte,
	costs : [dynamic][dynamic]int,
	frontier : [dynamic]Reindeer,
	curr_index : int,
	reached : [dynamic]Reindeer,
	goal : XY

}

Reindeer :: struct {
	loc : XY,
	facing : Direction,
	history : [dynamic]XY,
	cost : int,
}

*/
