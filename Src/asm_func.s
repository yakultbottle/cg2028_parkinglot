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

@ Write Student 1’s Name here:
@ Write Student 2’s Name here:

@ Look-up table for registers:

@ R0 ...
@ R1 ...
@ ...

@ write your program from here:

asm_func:
	@ Reorganise registers
 	MOV R9, R0
 	MOV R10, R1
 	MOV R11, R2
 	MOV R12, R3

	@ Compute F * S
 	LDR R3, [R12]
 	LDR R4, [R12, #4]
 	MUL R8, R3, R4

 	@ Flatten entry[] array
 	MOV R0, #0
 	MOV R1, #0
 	MOV R2, #5
flatten_entry:
 	LDR R4, [R10, R1]
 	ADD R0, R4
 	ADD R1, #4
 	SUBS R2, #1
 	BNE flatten_entry

 	BX LR
