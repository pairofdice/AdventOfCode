package main


import "core:fmt"
import rl "vendor:raylib"

Antinode :: struct {
	x: int,
	y: int,
}

Antenna :: struct {
	x: int,
	y: int,
	freq: byte,
}

day_8 :: proc(input: ^[]byte) {
	antinodes : [dynamic]Antinode
	antennas : [dynamic]Antenna
	antennas_map : map[byte][dynamic]Antenna
	//      48   57   97    122   65    90
	b : [6]byte = {'0', '9', 'a',  'z',  'A',  'Z'}
	fmt.println(b)
	for k, v in antennas_map {
		fmt.println(k, v)
	}

	x, y : int
	for c in input {
		if c == '\n' {
			y += 1
			x = 0
		} else if is_freq(c){
			// append(&antennas, [2]int{x, y})

			append(&antennas, Antenna{x, y, c})
			if c not_in antennas_map {
				antennas_map[c] = {}
				append(&antennas_map[c], Antenna{x, y, c})
			} else {
				append(&antennas_map[c], Antenna{x, y, c})
			}
			x += 1
		} else if c == '.' {
			x += 1
		}
	}
	width := x
	height := y + 1
	font : rl.Font = rl.LoadFont("resources/romulus.png")
	tilesize : f32 = 16

	for k, v in antennas_map {
		for left in 0..<len(v) - 1 {
			for right in (left + 1)..<len(v) {
				la : Antenna = v[left]
				ra : Antenna = v[right]
			}
		}
	}

	rl.InitWindow(1000, 1000, "Day 6")
	rl.SetTargetFPS(10)



	third_os : f32 = tilesize / 3
	third_osi : i32 = i32(tilesize / 3)
	half_os : f32 =  tilesize /2
	half_osi : i32 = i32(tilesize /2)

	for !rl.WindowShouldClose() {
		rl.BeginDrawing()
		rl.ClearBackground(rl.BLACK)
		rl.DrawRectangleLinesEx({0,0, tilesize * f32(width), tilesize * f32(height)}, 2, rl.DARKGREEN)
		for a in antennas {
			x, y : f32
			x = f32(a.x) * tilesize
			y = f32(a.y) * tilesize
			rl.DrawTextEx(font, fmt.ctprintf("%d", a.freq), {x, y}, 12, 6, rl.WHITE)
			rl.DrawRectangleLinesEx({x, y, tilesize, tilesize}, 1, rl.GREEN)
		}
		
		for k, v in antennas_map {
			for left in 0..<len(v) - 1 {
				for right in (left + 1)..<len(v) {
					la : Antenna = v[left]
					ra : Antenna = v[right]
					lx, ly, rx, ry: i32

					// drawing
					lx = i32(f32(la.x) * tilesize) 
					ly = i32(f32(la.y) * tilesize) 
					rx = i32(f32(ra.x) * tilesize) 
					ry = i32(f32(ra.y) * tilesize) 
					rl.DrawLine(lx + half_osi, ly + half_osi, rx + half_osi, ry + half_osi,  rl.WHITE)
					// ---

					diffx, diffy : int

					// antinodes
					diffx = ra.x - la.x
					diffy = ra.y - la.y

					// ran := Antinode{int(ra.x + diffx), int(ra.y + diffy)}
					// lan := Antinode{int(la.x - diffx), int(la.y - diffy)}
					// rl.DrawRectangleLinesEx({f32(ran.x) * tilesize + third_os, f32(ran.y) * tilesize + third_os , tilesize/3, tilesize/3}, 1, rl.RED)
					//
					// rl.DrawRectangleLinesEx({f32(lan.x) * tilesize + third_os , f32(lan.y) * tilesize + third_os , tilesize/3, tilesize/3}, 1, rl.YELLOW)

					// rl.DrawLine( i32(f32(lan.x) * tilesize) + half_osi , i32(f32(lan.y) * tilesize) + half_osi , lx + half_osi, ly + half_osi,  rl.PINK)
					// rl.DrawLine( i32(f32(ran.x) * tilesize) + half_osi, i32(f32(ran.y) * tilesize)  + half_osi, rx + half_osi, ry + half_osi,  rl.VIOLET)

					i : = 0

					ran := Antinode{ra.x + diffx * 0, ra.y + diffy * 0}
					for item_in_bounds(width, height, ran) {
						ran = Antinode{ra.x + diffx * i, ra.y + diffy * i}
						if !item_in_array(&antinodes, ran) {
							if item_in_bounds(width, height, ran) {
							append(&antinodes, ran)
							}
						}
						i += 1
					}

					i = 0
					lan := Antinode{la.x - diffx * 0, la.y - diffy * 0}
					for item_in_bounds(width, height, lan) {
						lan = Antinode{la.x - diffx * i, la.y - diffy * i}
						if !item_in_array(&antinodes, lan) {
							if item_in_bounds(width, height, lan) {
								append(&antinodes, lan)
							}
						}
						i += 1
					}

					for an in antinodes {
						rl.DrawRectangleLinesEx({f32(an.x) * tilesize + third_os , f32(an.y) * tilesize + third_os , tilesize/3, tilesize/3}, 1, rl.YELLOW)
						
					}

					fmt.println(len(antinodes))

				}
			}
		}
		
		rl.EndMode2D()
		rl.EndDrawing()
	}
}

is_freq :: proc(c: byte) -> bool {
	if 47 < c && c < 58 do return true
	if 96 < c && c < 123 do return true
	if 64 < c && c < 91 do return true
	return false
}

item_in_array :: proc(array: ^[dynamic]Antinode, an: Antinode) -> bool {
	for item in array {
		if item == an do return true	
	}
	return false
}

item_in_bounds :: proc(w: int, h: int, item : Antinode) -> bool {
	if item.x < 0 do return false
	if item.y < 0 do return false
	if item.x >= w do return false
	if item.y >= h do return false
	return true
}
