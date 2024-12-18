package main

import "core:fmt"
import "core:bytes"
import rl "vendor:raylib"

State :: struct {
	map_ : [dynamic][dynamic]int,
	areas : map[int]Area
}

XY128 :: struct {
	x : u128,
	y : u128,
}
XY64 :: struct {
	x : u64,
	y : u64,
}

XY :: struct {
	x : int,
	y : int,
}

Direction :: enum{North, East, South, West}

Direction_Vectors :: [Direction][2]int {
	.North =	{  0, -1 },
	.East  =	{ +1,  0 },
	.South =	{  0, +1 },
	.West  =	{ -1,  0 },
}

Area :: struct {
	id : int,
	area : int,
	perimeter : int,
	plots : [dynamic]XY,
}

day_12 :: proc(input: ^[]byte) {
	state : State
	input := bytes.split(input^, {'\r'})
	for line in input {
		temp : [dynamic]int
		trimmed := bytes.trim(line, {'\n'})
		for b in trimmed {
			append(&temp, int(b))
		}
		append(&state.map_, temp)
	}

	for line in state.map_ {
		for c in line {
			fmt.printf("% 2.d ", c - 'A')
		}
		fmt.println()
	}
	fmt.println()
// ------------------------------------------------------------------------------------------------

	id : int = 0

	for row, row_i in state.map_ {
		for elem, col_i in row {
			if id in state.areas {
				continue	
			} else {
				loc : XY = {col_i, row_i}
				floodfill(&state, loc, id)
				id += 1
			}
		}
	}


// ------------------------------------------------------------------------------------------------
	rl.InitWindow(1000, 1000, "Day 12")
	rl.SetTargetFPS(44)
	num_cols : int = len(state.map_[0])
	num_rows : int = len(state.map_)
	margin : f32 = 33
	tilesize : f32 = (f32(1000) - 3 * margin) / f32(num_cols)
	for !rl.WindowShouldClose() {
		rl.BeginDrawing()
		rl.ClearBackground(rl.BLACK)
		for row, row_i in state.map_ {
			for col, col_i in row {
				draw_row_col_size_color(row_i, col_i, num_rows, num_cols, margin, tilesize, 1, 
					{255 - u8(state.map_[row_i][col_i] - 'A') * 10,
					 u8(state.map_[row_i][col_i] - 'A') * 10,
					  u8(state.map_[row_i][col_i] - 'A') * 10,
					 255}
				)
			}
		}
		rl.EndDrawing()
	}
	rl.EndMode2D()
	rl.EndDrawing()
}

floodfill :: proc(state: ^State, loc: XY, id: int) {
	target : = state.map_[loc.y][loc.x]
	
}
