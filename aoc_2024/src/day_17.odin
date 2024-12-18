package main

import "core:bytes"
import "core:fmt"
import "core:math"

reg_i :: enum {
	A,
	B,
	C,
}

output : [dynamic]u64
day_17 :: proc(input: ^[]byte) {
	instructions : [8]proc(operand: u64, registers: ^[3]u64, instruction_ptr: ^u64) = {
		adv,
		bxl,
		bst,
		jnz,
		bxc,
		out,
		bdv,
		cdv,
	}
	registers : [3]u64
	program : [dynamic]u64
	input := bytes.split(input^, {'\n'})
	for line, i in input {
		trimmed := bytes.trim(line, {13})
		// fmt.println(trimmed, i)
		if len(trimmed) > 0{
			if trimmed[0] == 'R' { 
				register := bytes.split(trimmed, {' '})
				registers[i] = u64(parse_num(register[2]))
				// fmt.println(registers[i])
			} else if trimmed[0] == 'P' {
				programline := bytes.split(trimmed[9:], {','})
				for b in programline {
					append(&program, u64(b[0] - '0'))
				}

			}
		}
	}
	fmt.println(program)
	fmt.println(registers)
	// [opcode, operand]
	opcode : u64 = 0
	operand : u64 = 0
	instruction_pointer : u64 = 0
	a_inc : u64 = 11025338047
	//           11025338047
	a: for true {
		if instruction_pointer < 0 || instruction_pointer >= u64(len(program)) {
			a_inc += 1
			clear(&output)
			instruction_pointer = 0
			registers = {a_inc, 0, 0}
			continue
		}
		for i in 0..<len(output) {
			if output[i] != program[i] {
				a_inc += 1
				clear(&output)
				instruction_pointer = 0
				registers = {a_inc, 0, 0}
			} else {
				if i > 6 {
					fmt.println("ainc:", a_inc, "output:", output)
				}
				if len(output) == len(program) do break a
			}
		}

		opcode = program[instruction_pointer]
		operand = program[instruction_pointer + 1]
		fn := instructions[opcode]
		fn(operand, &registers, &instruction_pointer)
		// fmt.println("A inc", a_inc, "opcode:", opcode, "regs:", registers, "output:", output)
		// fmt.println()
	}
	fmt.println("RESULT:", registers, "A increment:", a_inc)
}

// 0
adv :: proc(operand: u64, registers: ^[3]u64, instruction_ptr: ^u64) {
	// fmt.println("A div:", registers[reg_i.A], registers[reg_i.A] / pow(2, combo(operand, registers)))
	registers[reg_i.A] = registers[reg_i.A] / pow(2, combo(operand, registers))
	instruction_ptr^ += 2
}

// 1
bxl :: proc(operand: u64, registers: ^[3]u64, instruction_ptr: ^u64) {
	registers[reg_i.B] = operand ~ registers[reg_i.B] 
	instruction_ptr^ += 2
}

// 2
bst :: proc(operand: u64, registers: ^[3]u64, instruction_ptr: ^u64) {
	registers[reg_i.B] = combo(operand, registers) % 8
	instruction_ptr^ += 2
}

// 3
jnz :: proc(operand: u64, registers: ^[3]u64, instruction_ptr: ^u64) {
	if registers[reg_i.A] != 0 {
		instruction_ptr^ = operand
	} else {
		instruction_ptr^ += 2
	}
}

// 4
bxc :: proc(operand: u64, registers: ^[3]u64, instruction_ptr: ^u64) {
	registers[reg_i.B] = registers[reg_i.B] ~ registers[reg_i.C] 
	instruction_ptr^ += 2
}

// 5
out :: proc(operand: u64, registers: ^[3]u64, instruction_ptr: ^u64) {
	append(&output, combo(operand, registers) % 8)
	instruction_ptr^ += 2
}

// 6
bdv :: proc(operand: u64, registers: ^[3]u64, instruction_ptr: ^u64) {
	registers[reg_i.B] = registers[reg_i.A] / pow(2, combo(operand, registers))
	instruction_ptr^ += 2
}

// 7
cdv :: proc(operand: u64, registers: ^[3]u64, instruction_ptr: ^u64) {
	registers[reg_i.C] = registers[reg_i.A] / pow(2, combo(operand, registers))
	instruction_ptr^ += 2
}

/*
Combo operands 0 through 3 represent literal values 0 through 3.
Combo operand 4 represents the value of register A.
Combo operand 5 represents the value of register B.
Combo operand 6 represents the value of register C.
Combo operand 7 is reserved and will not appear in valid programs.
*/
combo :: proc(operand : u64, registers: ^[3]u64) -> u64 {
	if 0 <= operand && operand <= 3 {
		return operand
	} else {
		return registers[operand - 4]
	}
}

pow :: proc(a: u64, b: u64 ) -> u64 {
	result : u64 = 1

	for i in 0..<b {
		result *= a
	}

	return result
}
/*
2 4 1 3
[2, 4, 1, 3, 7, 5, 1, 5, 0, 3, 4, 3, 5, 5, 3, 0]
    4     7     0     0     6     0     5     1,
    */
