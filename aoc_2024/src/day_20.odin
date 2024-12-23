package main

import "core:fmt"
import "core:bytes"
import "core:slice"
import q "core:container/queue"
import pq "core:container/priority_queue"
import rl "vendor:raylib"

Cell :: struct {
	distance_from_start:	int,
	distance_from_end:	int,
	is_wall:		bool,
	shortcut:		bool,

}



Dimensions :: struct {
	num_cols :	int, 
	num_rows :	int,
	margin :	f32,
	tilesize :	f32, 
}

nrs : [4]XY : {{0, -1}, {1, 0}, {0, 1}, {-1, 0}}
day_20 :: proc(input: ^[]byte) {
	map_ : [dynamic][dynamic]Cell
	start : XY
	end : XY
	parse_map(&map_, input, &start, &end)
	print_map(&map_, 0)
	frontier: XY = start
	mode : int = 0

	rl.InitWindow(1000, 1000, "Day 6")
	rl.SetTargetFPS(130)
	dims : Dimensions = set_dims(&map_)

	(map_[start.y][start.x]).distance_from_start = 0
	(map_[end.y][end.x]).distance_from_end = 0

	frame : int = 0
	for !rl.WindowShouldClose() { 

		if frontier.x == 0 && frontier.y == 0 && mode == 0 {
			print_map(&map_, 0)
			extract_shortcuts(&map_)
			fmt.println()
			mode = 1
			frontier = end
		}
		if frontier.x == 0 && frontier.y == 0 && mode == 1 {
			// print_map(&map_, 1)
			// fmt.println()
			// print_map(&map_, 2)
			mode = 2
			frontier = end
		}
		if frontier.x == start.x && frontier.y == start.y && mode == 2 {
			mode = 3
			frontier = end
		}

		if frame % 1 == 0 do update(&map_, &frontier, &mode)

		// ---------------------------------------------------------------------------------
		rl.BeginDrawing()
		rl.ClearBackground(rl.BLACK)
		// ---------------------------------------------------------------------------------

		draw_map(&map_, &dims)

		// ---------------------------------------------------------------------------------
		rl.EndDrawing()
		frame += 1
	}
}

update :: proc(map_: ^[dynamic][dynamic]Cell, loc: ^XY, mode: ^int) {
	// fmt.print("current:", loc, " - ")
	curr : Cell = map_[loc.y][loc.x]
	res : XY 
	if mode^ == 0 {
		for n in nrs {
			// fmt.print("", n)
			node : XY = {loc.x + n.x, loc.y + n.y}
			cell : Cell = map_[node.y][node.x]
			if mode^ == 0 {
				if cell.distance_from_start == -1 {
					(map_[node.y][node.x]).distance_from_start = curr.distance_from_start + 1
					if !cell.is_wall do res = {node.x, node.y}
				} else if cell.distance_from_start != curr.distance_from_start - 1 {
					(map_[node.y][node.x]).shortcut = true
					(map_[node.y][node.x]).distance_from_start = curr.distance_from_start - (map_[node.y][node.x]).distance_from_start - 1
				}
			} else if mode^ == 1 {
				if cell.distance_from_end == -1 || cell.distance_from_end > curr.distance_from_end + 1 {
					(map_[node.y][node.x]).distance_from_end = curr.distance_from_end + 1
					if !cell.is_wall do res = {node.x, node.y}
				}

			}
		}
		loc^ = {res.x, res.y}
	}
}

parse_map :: proc(map_: ^[dynamic][dynamic]Cell, input: ^[]byte, start: ^XY, end: ^XY) {
	fmt.println(start)
	input := bytes.split(input^, {10})
	is_wall : bool
	for line, y in input {
		row : [dynamic]Cell = {}
		trimmed := bytes.trim(line, {13})
		for c, x in trimmed {
			if c == '#' do is_wall = true
			else do is_wall = false
			if c == 'S' do start^ = XY{x, y}
			if c == 'E' do end^ = XY{x, y}
			append(&row, Cell{-1, -1, is_wall, false})
		}
		append(map_, row)
	}
}

print_map :: proc(map_: ^[dynamic][dynamic]Cell, mode: int) {
	for row in map_ {
		for c in row {
			if mode == 0 {
				if c.shortcut do fmt.printf("% 3d", c.distance_from_start)
				else if c.is_wall do fmt.printf("  #")
				else do fmt.printf("   ")
			} else if mode == 1 {
				if c.is_wall do fmt.printf("% 3d", c.distance_from_end)
				else do fmt.printf("   ")
			} else if mode == 2 {
				if c.is_wall do fmt.printf("% 3d", c.distance_from_end + c.distance_from_start)
				else do fmt.printf("   ")
			}
		}
		fmt.println()
	}
}

draw_map :: proc(map_: ^[dynamic][dynamic]Cell, d: ^Dimensions) {
	for row, y in map_ {
		for cell, x in row {
			if cell.is_wall {
					
				draw_row_col_size_color(
					y, 
					x, 
					d.num_rows, 
					d.num_cols, 
					d.margin, 
					d.tilesize, 
					1, 
					{255, 255, 255, 30},
					true
				)
				if cell.shortcut {

				draw_row_col_size_color(
					y, 
					x, 
					d.num_rows, 
					d.num_cols, 
					d.margin, 
					d.tilesize, 
					1, 
					{55, 255, 55, 255},
					false
				)
					
				} 
				
			} else {
				if cell.distance_from_start == -1 {
					draw_row_col_size_color(
						y, 
						x, 
						d.num_rows, 
						d.num_cols, 
						d.margin, 
						d.tilesize, 
						0.3, 
						{55, 254 - u8(cell.distance_from_start), 55, 30},
						true
					)
				} else {
					draw_row_col_size_color(
						y, 
						x, 
						d.num_rows, 
						d.num_cols, 
						d.margin, 
						d.tilesize, 
						0.3, 
						{255, 255, 255, 255},
						false
					)

				}


				if cell.distance_from_end != -1 {
					draw_row_col_size_color(
						y, 
						x, 
						d.num_rows, 
						d.num_cols, 
						d.margin, 
						d.tilesize, 
						0.5, 
						{255, 55, 55, 255},

					)

				}

			}
		}
	}

}

set_dims :: proc(map_: ^[dynamic][dynamic]Cell) -> Dimensions { 
	dims : Dimensions
	m : f32 = 33

	dims = {
		num_cols = len(map_[0]),
		num_rows = len(map_),
		margin = m,
		tilesize = (f32(1000) - 3 * m) / f32(len(map_[0])),

	}
	return dims
}

extract_shortcuts :: proc(map_: ^[dynamic][dynamic]Cell) {
	shortcuts : [dynamic]int
	for row in map_ {
		for c in row {
			if c.shortcut {
				append(&shortcuts, c.distance_from_start)
			}
		}
	}
	slice.reverse_sort(shortcuts[:])
	for e, i in shortcuts {
		if e >= 100 do fmt.printf("% 3.d %d\n", i + 1, e)
	}
}
