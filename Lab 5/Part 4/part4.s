          .text                   // executable code follows
          .global _start
		  
_start:		MOV SP, #0x2000
			LDR R8, =0xFF200020		//R8 has the addres of HEX0-3
			LDR	R9, =0xFFFFFFFF		//Used to reset the edge capture
			STR R9, [R8, #0x3C]
			MOV R10, #DISPLAY_NUMS	//Bit codes for the hex display
			LDR R11, =0xFFFEC600		//Addr of internal timer
			MOV R12, #1
			STR R12, [R11, #0xC]
			MOV R12, #0
			STR R12, [R11, #0x8]
			LDR R12, =0x01312D00	//0.1 seconds at 200MHz
			STR R12, [R11]			//Puts load value into timer
			MOV R0, #0
			MOV R1, #0
			MOV R2, #0
			MOV R3, #0
			
//Increments the hex display with a start/stop button		
MAIN:		LDR R2, [R8, #0x3C]		//Saves key value
			CMP R2, #0
			BEQ	MAIN
			STR R9, [R8, #0x3C]
			MOV R2, #0
			
INC:		BL COUNTER
			BL PUSH
			BL DISPLAY
			B INC

//Increments The counter to the next
//display bit 
COUNTER:	CMP R0, #36 //If R0 == 9 then change R1
			BEQ TENS
			ADD R0, #4
			MOV PC, LR
			
TENS:		MOV R0, #0
			CMP R1, #36 //If R1 == 9 then change R2
			BEQ HUNDREDS
			ADD R1, #4
			MOV PC, LR
			
HUNDREDS:	MOV R1, #0
			CMP R2, #36	//If R2 == 9 then change R3
			BEQ THOUSANDS
			ADD R2, #4
			MOV PC, LR
			
THOUSANDS:	MOV R2, #0
			CMP R3, #20	//If R5 == 5 then reset counter
			BEQ RESET
			ADD R3, #4
			MOV PC, LR

RESET:		MOV R3, #0	//Reset the display/counter
			MOV PC, LR

//Creates a delay of about 0.25 seconds
PUSH:		PUSH {R0, R1, R2, R3}
DELAY:		MOV R0, #0x3
			STR R9, [R8, #0x3C]		//Resets the edge capture 
			STR R0, [R11, #0x8]		//Starts the timer
			
TIMER:		LDR R0, [R11, #0xC]
			LDR R1, [R8, #0x3C]
			CMP R1, #1
			BEQ STOP		//Check for edge capture
			CMP R0, #1
			BNE TIMER		//Check if the timer is done
			MOV R0, #0		
			STR R0, [R11, #0x8]		//Stop the timer
			MOV R0, #1
			STR R0, [R11, #0xC]		//Reset the F bit
			POP {R0, R1, R2, R3}
			MOV PC, LR

//Waits till the start button is pressed again
STOP:		STR R9, [R8, #0x3C]	

START:		LDR R2, [R8, #0x3C]
			CMP R2, #1
			BEQ DELAY
			B START

//Displays the decimal value to the hex display
DISPLAY:	PUSH {R0, R1}
			LDR R0, [R10, R0]
			LDR R1, [R10, R1]
			LSL R1, #8
			ADD R0, R1
			PUSH {R2}
			LDR R2, [R10, R2]
			LSL R2, #16
			ADD R0, R2
			PUSH {R3}
			LDR R3, [R10, R3]
			LSL R3, #24
			ADD R0, R3
			STR R0, [R8]
			POP {R3}
			POP {R2}
			POP {R0}
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