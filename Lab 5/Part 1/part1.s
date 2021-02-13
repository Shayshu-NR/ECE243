          .text                   // executable code follows
          .global _start
		  
_start:		LDR R0, =0xFF200020		//R0 has the addres of HEX0-3
			LDR	R1, =0xFFFFFFFF
			STR R1, [R0, #0x3C]
			MOV R5, #0
			MOV R4, #DISPLAY_NUMS
			
		
MAIN:		LDR R2, [R0, #0x30]		//Saves key value
			CMP R2, #0
			BEQ	MAIN
			
UN_PRESS:	LDR R3, [R0, #0x30] //Saves 'edge' value
			CMP R3, R2
			BEQ UN_PRESS		//Wait till the button is unpressed
			
			//Branch to the correct instruction
			CMP R2, #0x1
			BEQ	SET_ZERO
			
			CMP R2, #0x2
			BEQ INCREMENT
			
			CMP R2, #0x4
			BEQ DECREMENT
			
			CMP R2, #0x8
			BEQ BLANK
			
			B MAIN

//Sets the DISPLAY TO ZERO			
SET_ZERO:	MOV R4, #DISPLAY_NUMS
			LDR R4, [R4]
			STR R4, [R0]
			MOV R5, #0
			B MAIN

//Increases the value on HEX0
INCREMENT:	MOV R4, #DISPLAY_NUMS
			CMP R5, #0b00100100	
			BEQ TO_ZERO
			ADD R5, #4
			LDR	R4, [R4, R5]
			STR R4, [R0]
			B MAIN
TO_ZERO:	MOV R5, #0		//Resets the display to 0	
			LDR R4, [R4, R5]
			STR R4, [R0]
			B	MAIN

//Decreases the value on HEX0
DECREMENT:	MOV R4, #DISPLAY_NUMS
			CMP R5, #0b0
			BEQ TO_NINE
			SUB R5, #4
			LDR	R4, [R4, R5]
			STR R4, [R0]
			B MAIN
TO_NINE:	MOV R5, #36		//Resets the display to 9
			LDR R4, [R4, R5]
			STR R4, [R0]
			B	MAIN

//Blanks the display till another key is pressed
BLANK:		MOV R4, #DISPLAY_BLANK
			LDR R4, [R4]
			STR R4, [R0]
NEW_KEY:	LDR R2, [R0, #0x30]		
			CMP R2, #8
			BEQ NEW_KEY
			CMP R2, #0
			BEQ	NEW_KEY
			B	SET_ZERO

			
DISPLAY_BLANK: .word 0b00000000

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