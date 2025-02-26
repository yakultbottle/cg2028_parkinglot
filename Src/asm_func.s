/*
 * asm_func.s
 *
 *  Created on: 7/2/2025
 *      Author: Hou Linxin
 */
   .syntax unified
	.cpu cortex-m4
	.fpu softvfp
	.thumb

		.global asm_func

@ Start of executable code
.section .text

@ CG/[T]EE2028 Assignment 1, Sem 2, AY 2024/25
@ (c) ECE NUS, 2025

@ Write Student 1’s Name here: Lim Wei Ming, Benjamin
@ Write Student 2’s Name here: Chittazhi Nivedit Nandakumar

@ Look-up table for registers:

@ R0 - Remaining number of entering cars
@ R1 - Offset for entry[] array, Offset for current lot/leave section
@ R2 - Counter, used for looping
@ R3 - Used to load F value from result[][] one time, Scratch register to load *lot values into
@ R4 - Used to load S value from result[][] one time, Scratch register to load *entry/exit values into
@ R5 - Scratch register used for diff values
@ R6 - MAX_CARS_PER_LOT, 12
@ R7 - Unused
@ R8 - F * S - number of sections total among all floors
@ R9 - Pointer to building[][]
@ R10 - Pointer to entry[]
@ R11 - Pointer to exit[][]
@ R12 - Pointer to result[][]
@ R13 - Reserved, SP
@ R14 - Reserved, LP
@ R15 - Reserved, PC

@ write your program from here:

.equ WORD_SIZE, 4
.equ MAX_CARS_PER_LOT, 12

asm_func:
	@ Reorganise registers
 	MOV R9, R0
 	MOV R10, R1
 	MOV R11, R2
 	MOV R12, R3
 	MOV R6, MAX_CARS_PER_LOT

	@ Compute F * S
 	LDR R3, [R12]
 	LDR R4, [R12, WORD_SIZE]
 	MUL R8, R3, R4

 	@ Flatten entry[] array
 	MOV R0, #0
 	MOV R1, #0
 	MOV R2, #5
flatten_entry:
 	LDR R4, [R10, R1]
 	ADD R0, R4
 	ADD R1, WORD_SIZE
 	SUBS R2, #1
 	BNE flatten_entry

 	@ Add cars
 	MOV R1, #0
 	MOV R2, R8
add_cars:
	@ Check if R1 is pointing in bounds
	CMP R2, #0
	BEQ handle_exit
	@ Skip currently filled lots
	LDR R3, [R9, R1]
	SUBS R5, R6, R3
	BNE is_not_filled
	STR R6, [R12, R1]
	ADD R1, WORD_SIZE
	SUB R2, #1
	B add_cars

is_not_filled:
	CMP R0, R5
	BGT handle_excess

	@ If remaining cars can all fit in this lot
	ADD R3, R0
	STR R3, [R12, R1]
	MOV R0, #0
	B iterate
handle_excess:
	STR R6, [R12, R1]
	SUB R0, R5
iterate:
	ADD R1, WORD_SIZE
	SUB R2, #1
	B add_cars

handle_exit:
	MOV R1, #0 @initialize offset register

subtract_cars:
	@ times by 4 to compare since R1 is incremented by word size
 	CMP R1, R8, LSL #2
 	@ exit if all floors and sections have been cleared
 	BEQ exit
 	LDR R4, [R11, R1] @ exiting cars of curr level and section
 	LDR R3, [R12, R1] @ present status of curr level and section

is_exit_empty:
 	@ move to next section if no exiting cars
 	CMP R4, #0
 	BEQ iterate_exit

handle_section:
	# set to 0 if greater than or equal
	CMP R4, R3
	BGE set_to_zero
	@ else handle
	BLT subtract_section

set_to_zero:
	MOV R3, #0
	STR R3, [R12, R1]
	B iterate_exit

subtract_section:
	SUB R3, R4
	STR R3, [R12, R1]

iterate_exit:
	ADD R1, WORD_SIZE
	CMP R1, R8, LSL #2
	BLT subtract_cars

exit:
 	BX LR
