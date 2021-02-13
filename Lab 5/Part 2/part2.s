          .text                   // executable code follows
          .global _start
		  
_start:		LDR R8, =0xFF200020		//R8 has the addres of HEX0-3
			LDR	R9, =0xFFFFFFFF		//Used to reset the edge capture
			STR R9, [R8, #0x3C]
			MOV R10, #DISPLAY_NUMS	//Bit codes for the hex display
			MOV R0, #0
			MOV R1, #0
			
//Increments the hex display with a start/stop button			
MAIN:		LDR R2, [R8, #0x3C]		//Saves key value
			CMP R2, #0
			BEQ	MAIN
			STR R9, [R8, #0x3C]
			
INC:		BL COUNTER
			PUSH {R0, R1}
			BL DELAY
			POP {R0, R1}
			BL DISPLAY
			B INC

//Increments The counter to the next
//display bit 
COUNTER:	CMP R0, #36 //If R0 == 9 then change R1
			BEQ TO_ZERO
			ADD R0, #4
			MOV PC, LR
			
TO_ZERO:	MOV R0, #0
			CMP R1, #36 //If R1 == 9 then reset counter
			BEQ RESET
			ADD R1, #4
			MOV PC, LR
			
RESET:		MOV R1, #0
			MOV PC, LR

//Creates a delay of about 0.25 seconds
DELAY:		STR R9, [R8, #0x3C]
			LDR R0, =2000000
			
SUB_LOOP:	LDR R2, [R8, #0x3C]
			CMP R2, #1
			BEQ STOP		//Branches when button is pressed
			SUBS R0, #1
			BNE SUB_LOOP
			MOV PC, LR

//Waits till the start button is pressed again
STOP:		STR R9, [R8, #0x3C]	

START:		LDR R2, [R8, #0x3C]
			CMP R2, #1
			BEQ DELAY
			B START

//Displays the decimal value to the hex display
DISPLAY:	LDR R2, [R10, R1]
			LSL R2, #8
			PUSH {R1}
			LDR R1, [R10, R0]
			ADD R2, R1
			STR R2, [R8]
			POP {R1}
			MOV PC, LR
		
DISPLAY_NUMS: .word 0b00111111
			  .word 0b00000110
			  .word 0b01011011
			  .word 0b01001111
			  .word 0b01100110
			  .word 0b01101101
			  .word 0b01111101
			  .word 0b00000111
			  .word 0b01111111
			  .word 0b01100111
			  .end