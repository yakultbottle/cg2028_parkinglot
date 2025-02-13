/**
 ******************************************************************************
 * @project        : CG/[T]EE2028 Assignment 1 Program Template
 * @file           : main.c
 * @author         : Hou Linxin, ECE, NUS
 * @brief          : Main program body
 ******************************************************************************
 *
 * @attention
 *
 * <h2><center>&copy; Copyright (c) 2019 STMicroelectronics.
 * All rights reserved.</center></h2>
 *
 * This software component is licensed by ST under BSD 3-Clause license,
 * the "License"; You may not use this file except in compliance with the
 * License. You may obtain a copy of the License at:
 *                        opensource.org/licenses/BSD-3-Clause
 *
 ******************************************************************************
 */
#include "stdio.h"

#define F 3
#define S 2

extern void asm_func(int* arg1, int* arg2, int* arg3, int* arg4);
extern void initialise_monitor_handles(void);

int main(void)
{
	initialise_monitor_handles();
	int i,j;
	int building[F][S] = {{8,8},{8,8},{8,8}};
	int entry[5] = {1,2,3,4,5};
	int exit[F][S] = {{1,2},{2,3},{3,4}};
	int result[F][S] = {{F,S},{0,0},{0,0}};

	asm_func((int*)building, (int*)entry, (int*)exit, (int*)result);

	// print result[][]
	printf("RESULT\n");
	for (i=0; i<F; i++)
	{
		for (j=0; j<S; j++)
		{
			building[i][j] = result[i][j];
			printf("%d\t", building[i][j]);
		}
	printf("\n");
	}

}
