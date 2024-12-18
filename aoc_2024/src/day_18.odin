package main

import "core:fmt"
import "core:bytes"
import q "core:container/queue"

rsize : int : 71  // :: instead of := makes a constant
numbytes : int : 1024

day_18 :: proc(input: ^[]byte) {
	coords : [dynamic]XY
	coord : XY
	input := bytes.split(input^, {'\n'})
	
	for line in input {
		trimmedsplit := bytes.split(bytes.trim(line, {13}), {','})
		if len(trimmedsplit) == 2 {
			// fmt.println(trimmedsplit)
			coord = {parse_num(trimmedsplit[0]), parse_num(trimmedsplit[1])}
		}
		append(&coords, coord)
	}
	// for l in coords {
	// 	fmt.println(l)
	// }
	room : [rsize][rsize]int
/*
	for i in 0..<numbytes {
		c : XY = coords[i]
		room[c.y][c.x] = -1
	}
	for r in room {
		for c in r {
			fmt.printf("% 3.d", c)
		}
		fmt.println()
	}
	*/

	// constant const bfs

	// frontier : [dynamic]XY = { {0,0} }
	goal : XY = { rsize - 1, rsize - 1 }


	success : bool = true
	frontier : q.Queue(XY) 

	room = {}
	start_blocks : [dynamic]XY
	end_blocks : [dynamic]XY
	block_exists : bool = false
	for i in 0..<len(coords) {
		fmt.println("i", i, "block:", coords[i])
		q.clear(&frontier)
		block : XY = coords[i]
		room[block.y][block.x] = -1

		if block.x == 0 || block.y == rsize - 1 {
			append(&start_blocks, block)
		}
		if block.x == rsize - 1 || block.y == 0 {
			append(&end_blocks, block)
		}
		for b in start_blocks {
			q.append(&frontier, b)
		}
		// print_room(&room)
		if i == 3027 || i == 3028 || i == 3026{
			print_room(&room)
		}

		for q.len(frontier) > 0 {
			node : XY = q.pop_front(&frontier)
			room[node.y][node.x] = -2
			for goal in end_blocks {
				if node.x == goal.x && node.y == goal.y {
					block_exists = true	
					break
				}
			}
			children := neighbours18(&room, node) 
			for child in children {
				// child_state := room[child.y][child.x]
				q.append(&frontier, child)
			}
		}
		if block_exists {
			fmt.println("BLOCKER:", block)
			break
		}
	}





	// for add_block_i < len(coords) {
	// 	c : XY = coords[add_block_i]
	// 	room[c.y][c.x] = -1
	// 	q.clear(&frontier)
	// 	q.append(&frontier, XY{0,0})
	//
	// 	for q.len(frontier) > 0 {
	// 		node : XY = q.pop_front(&frontier)
	// 		if node.x == goal.x && node.y == goal.y do break
	// 		children := neighbours18(&room, node)
	// 		node_cost : int = room[node.y][node.x]
	// 		for child in children {
	// 			// fmt.println("child")
	// 			child_state := room[child.y][child.x]
	// 			if child_state == 0 || child_state > node_cost + 1 {
	// 				room[child.y][child.x] = node_cost + 1
	// 				q.append(&frontier, child)
	// 			}
	// 		}
	// 	}
	// 	if room[rsize - 1][rsize - 1] == 0 do success = false
	//
	// 	if !success { 
	// 		fmt.println("COORDS:", coords[i])
	// 		break
	// 	}
	// }
		


	fmt.println("---------------------")
	// for r in room {
	// 	for c in r {
	// 		fmt.printf("% 5.d", c)
	// 	}
	// 	fmt.println()
	// }

	fmt.println("\nRESULT:", room[rsize - 1][rsize - 1])
}

neighbours18 :: proc(room: ^[rsize][rsize]int, loc: XY) -> [dynamic]XY {
	// fmt.println("neighbours")
	result : [dynamic]XY
	ds : [4][2]int = {{0, -1}, {1, 0}, {0, 1}, {-1, 0}} 
	for d in  ds {
		nb : XY = {d.x + loc.x, d.y + loc.y} 
		// fmt.println("neighbours - d", d, "neighbour:", nb)
		if nb.x >= 0 && nb.x < rsize && nb.y >= 0 && nb.y < rsize {
			if room[nb.y][nb.x] == -1 {
				// fmt.println("HELLO")
				append(&result, nb)	
			}
		}
	}
	// fmt.println("should have 2 elems:", len(result), result)
	return result
}


print_room :: proc(room: ^[rsize][rsize]int) {
	fmt.println()
	for row in room {
		for c in row {
			if c < 0 do fmt.print("#")
			else do fmt.print(".")
			
		}
		fmt.println()
	}
	fmt.println()
}
