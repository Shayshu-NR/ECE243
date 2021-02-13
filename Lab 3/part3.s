/* Program that finds the largest number in a list of integers */
.text // executable code follows 
.global _start

_start:
		MOV R4, #RESULT  // R4 points to result location 
		LDR R2, [R4, #4] // R0 holds the number of elements in the list 
		MOV R1, #NUMBERS // R1 points to the start of the list 
		MOV R0, #0		 //The largest number is now zero
		BL LARGE 		 // Start the subroutine	
		STR R0, [R4] // R0 holds the subroutine return value
		
END: B END

// Subroutine for finding the largest number from a list of integers
LARGE: 
		SUBS  R2, #1	//Subtract 1 from the counter 
		MOVEQ PC, LR	//Return back to main is the subtraction returns zero
		LDR   R3, [R1]	//Load the integer from the numbers list
		ADD	  R1, #4	//Add 4 to the pointer to the numbers list to get the next value
		CMP	  R0, R3	//Compare the current largest value and a number from the list
		BGE   LARGE		//If the current largest value is greater restart the loop
		MOV   R0, R3	//Otherwise make the current largest value the value from the list
		B	  LARGE		//Restart the subroutine
		

RESULT: 	.word 0
N: 			.word 7 // number of entries in the list
NUMBERS: 	.word 4, 5, 3, 6 // the data
			.word 1, 8, 2
			.end
