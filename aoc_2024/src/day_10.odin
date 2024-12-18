package main

import "core:fmt"
import "core:bytes"

import rl "vendor:raylib"

Dir10 :: enum {
	U,
	R,
	D,
	L,
}

dir10_to_xy :: proc(d: Dir10) -> (int, int) {
	x, y : int

	switch d {
	case .U:
		x = 0
		y = -1
	case .R:
		x = 1
		y = 0
	case .D:
		x = 0
		y = 1
	case .L:
		x = -1
		y = 0
	}
	return x, y
}

Loc :: struct {
	x : int,
	y : int,
	value : int,
	// taken : bool,
}


Trailhead :: struct {
	trailcount : int,
	loc : Loc,
	trails : [dynamic]Loc
}



day_10 :: proc(input: ^[]byte) {
	input := bytes.split(input^, {'\n'}, context.allocator)
	day10map : [dynamic][dynamic]Loc

	for line, y in input {
		new : [dynamic]Loc
		// append(&day10map, [dynamic]int{})

		line := bytes.trim(line, {'\r',})
		for b, x in line {

			append(&new, Loc{x, y, int(b - '0')})
		}
		append(&day10map, new)
	}

	for row in day10map {
		for l in row {
			fmt.print(l.value)
		}
		fmt.println()

	}
	fmt.println()

	for row in day10map {
		for l in row {
			fmt.print(l.x, l.y, "  ")
		}
		fmt.println()

	}
	fmt.println()

	// --- basic input done ---

	trailheads : [dynamic]Trailhead
	frontier : [dynamic]Loc

	for row_i in 0..<len(day10map) {
		for col_i in 0..<len(day10map[0]) {
			loc : Loc = day10map[row_i][col_i]
			if loc.value == 0 {
				th : Trailhead
				th.loc.x = col_i
				th.loc.y = row_i

				append(&th.trails, loc)
				append(&trailheads, th)
			}
		}
	}
	// bfs
	// expand_frontier(&day10map, &frontier, &th, row_i, col_i)

	for &th in trailheads {
		// fmt.println("trailhead: ", th)
		children := expand_frontier(&day10map, &frontier, th.loc)
		for child in children {
			append(&th.trails, child)
		}

	}
	for len(frontier) > 0 {
		clear(&frontier)
		for &th in trailheads {
			fmt.println("trails: ", th.trails)
			threshold := th.trails
			fmt.println("copy: ", threshold)
			clear(&th.trails)
			for loc in threshold {
				if loc.value == 9 do th.trailcount += 1
				children := expand_frontier(&day10map, &frontier, loc)
				for child in children {
					append(&th.trails, child)
				}
			}
		}
	}

	total : int = 0
	for th in trailheads {
		total += th.trailcount
	}
	fmt.println("result: ", total)

	for f in frontier {
		fmt.println(f)
	}
	

	// --- draw it --- 


	rl.InitWindow(1000, 1000, "Day 6")
	rl.SetTargetFPS(44)
	num_cols : int = len(day10map[0])
	num_rows : int = len(day10map)
	margin : f32 = 33
	tilesize : f32 = (f32(1000) - 3 * margin) / f32(num_cols)

	for !rl.WindowShouldClose() {
		rl.BeginDrawing()
		rl.ClearBackground(rl.BLACK)

		for row, row_i in day10map {
			for col, col_i in row {

				draw_row_col_size_color(row_i, col_i, num_rows, num_cols, margin, tilesize, 1, {255, 255, 255, 30})
			}
		}
		for th in trailheads {
			loc : Loc = th.loc
			draw_row_col_size_color(loc.y, loc.x, num_rows, num_cols, margin, tilesize, 0.5, {255, 255, 255, 255})
			for l in th.trails {
				if l.value == 9 {
					
				draw_row_col_size_color(l.y, l.x, num_rows, num_cols, margin, tilesize, 0.2, {90, 255, 90, 255})
				} else {
					
				draw_row_col_size_color(l.y, l.x, num_rows, num_cols, margin, tilesize, 0.2, {255, 90, 90, 255})
				}
			}

		}

		// rl.EndMode2D()
		rl.EndDrawing()
	}

	rl.EndMode2D()
	rl.EndDrawing()
}

draw_row_col_size_color :: proc(row, col, num_rows, num_cols : int, margin, tilesize: f32, size: f32, clr: rl.Color, solid : bool = false) {

	size_offset : f32 = (tilesize / 2) - size * (tilesize / 2)
	offset_x : f32 = /* f32(col) * (margin / f32(num_cols - 1)) + */ size_offset
	offset_y : f32 = /* f32(row) * (margin / f32(num_rows - 1)) + */ size_offset
	x : f32 = f32(col) * tilesize + margin + offset_x
	y : f32 = f32(row) * tilesize + margin + offset_y

	if solid {
		rl.DrawRectangleRec({x, y, tilesize * size,  tilesize * size}, clr)
		
	} else {
		rl.DrawRectangleLinesEx({x, y, tilesize * size,  tilesize * size}, 1,  clr)
	}
}

expand_frontier :: proc(map_: ^[dynamic][dynamic]Loc, frontier : ^[dynamic]Loc, loc: Loc) -> [dynamic]Loc {
	result : [dynamic]Loc
	fmt.print("trailhead: ", loc.x, loc.y, " neighbours: ")
	for d in Dir10 { 
		x, y := dir10_to_xy(d)
		x += loc.x
		y += loc.y
		if x < 0 do continue
		if y < 0 do continue
		if x >= len(map_[0]) do continue
		if y >= len(map_) do continue
		//if !elem_in_list({x, y, 0}, frontier) {
			curr_value : int = map_[loc.y][loc.x].value
			next_value : int = map_[y][x].value
			if next_value == curr_value + 1 {
				loc : Loc = {x, y, next_value}
				// map_[y][x].taken = true
				
				append(&result, loc)
				append(frontier, loc)
				
			}


		// }
	}
	fmt.println()
	return result
}

elem_in_list :: proc(elem: Loc, list: ^[dynamic]Loc) -> bool {
	for e in list {
		if elem.x == e.x && elem.y == e.y {
			// fmt.print(e, " already in frontier ")
			return true
		}
	}
	return false
}
