/* Subroutine to convert the digits from 0 to 9 to be shown on a HEX display.
 *    Parameters: R0 = the decimal value of the digit to be displayed
 *    Returns: R0 = bit patterm to be written to the HEX display
 */
          .text                   // executable code follows
          .global _start                  
                             
_start:   MOV     R4, #TEST_NUM   // load the data word
		  MOV	  R5, #0		  //Initialize R5 to zero 
		  MOV     R6, #0

//Calls the ONES subroutine for each element of the list		  
MAIN:	  LDR	  R12, [R4], #4   //Load R1 with a word from the list
		  MOV     R1, R12
		  CMP	  R12, #0		  //Checks for end of the list
		  BEQ	  DISPLAY
		  MOV	  R0, #0	      // Reset R0 for the new loop
		  
		  BL	  ONES			  //Start the subroutine
		  CMP	  R5, R0		  //If R5 < R0 update R5
		  MOVLT   R5, R0
		  
		  MOV     R1, R12
		  MOV	  R0, #0	      // Reset R0 for the new loop
		  MVN     R1, R1		  //Makes R1 the value inverted	  
		  BL	  ZEROS
		  CMP	  R6, R0
		  MOVLT   R6, R0
		  
		  MOV     R1, R12		  
		  MOV	  R0, #0		  //Resets R1
		  BL	  ALTERNATE
		  ADD     R0, #1		  //Adds one to compensate for LSR 
		  CMP     R7, R0
		  MOVLT   R7, R0
		  B		  MAIN			  //Restart the algorithm
		  
/* Display R5 on HEX1-0, R6 on HEX3-2 and R7 on HEX5-4 */
DISPLAY:    LDR     R8, =0xFF200020 // base address of HEX3-HEX0
            MOV     R0, R5          // display R5 on HEX1-0
            BL      DIVIDE          // ones digit will be in R0; tens digit in R1
            MOV     R9, R1          // save the tens digit
            BL      SEG7_CODE       
            MOV     R4, R0          // save bit code
            MOV     R0, R9          // retrieve the tens digit, get bit code
            BL      SEG7_CODE       
            LSL     R0, #8
            ORR     R4, R0
            
            MOV     R0, R6          // display R6 on HEX2-3
            BL      DIVIDE          // ones digit will be in R0; tens digit in R1
            MOV     R9, R1          // save the tens digit
            BL      SEG7_CODE
			LSL		R0, #16
            ORR		R4, R0          // save bit code
            MOV     R0, R9          // retrieve the tens digit, get bit code
            BL      SEG7_CODE       
            LSL     R0, #24
            ORR     R4, R0
            STR     R4, [R8]        // display the numbers from R6 and R5
			
            LDR     R8, =0xFF200030 // base address of HEX5-HEX4
			MOV     R0, R7          // display R7 on HEX4-5
            BL      DIVIDE          // ones digit will be in R0; tens digit in R1
            MOV     R9, R1          // save the tens digit
            BL      SEG7_CODE       
            MOV     R4, R0          // save bit code
            MOV     R0, R9          // retrieve the tens digit, get bit code
            BL      SEG7_CODE       
            LSL     R0, #8
            ORR     R4, R0
            STR     R4, [R8]        // display the number from R7
			
			B		END
		  

END:      B       END    
		  
//Subroutine to find the longest string of ones      
ONES:     CMP     R1, #0          // loop until the data contains no more 1's
          MOVEQ   PC, LR		  //Return to MAIN essentially           
          LSR     R2, R1, #1      // perform SHIFT, followed by AND
          AND     R1, R1, R2      
          ADD     R0, #1          // count the string length so far
          B       ONES

//Subroutine to find the longest string of ones      
ZEROS:    CMP     R1, #0          // loop until the data contains no more 1's
          MOVEQ   PC, LR		  //Return to MAIN essentially           
          LSR     R2, R1, #1      // perform SHIFT, followed by AND
          AND     R1, R1, R2      
          ADD     R0, #1          // count the string length so far
          B       ZEROS		 

//Finds longest string of alternating 1's and 0's 
ALTERNATE:PUSH    {LR}			  //Add the link reg to the stack
		  LSR	  R2, R1, #1	  //Left shift the word
		  EOR	  R1, R1, R2	  //Exclusive or the bits to isolate alternation
		  BL      ONES			  //Apply ONES subroutine
		  POP     {LR}			  //Pops LR from the stack in order to return to main
		  CMP	  R1, #0
		  MOVEQ	  PC, LR
		  B       ALTERNATE       //This should basically never happen
  

//Divide subroutine returns the tens and unit bits of a number
DIVIDE:     MOV    R1, #0 //R2 is the tens bit

TENS:  		CMP    R0, #10
            BLT    DIV_END
            SUB    R0, #10
            ADD    R1, #1
            B      TENS
			
DIV_END:    MOV    PC, LR
			
			
SEG7_CODE:  MOV     R1, #BIT_CODES  
            ADD     R1, R0         // index into the BIT_CODES "array"
            LDRB    R0, [R1]       // load the bit pattern (to be returned)
            MOV     PC, LR              

BIT_CODES:  .byte   0b00111111, 0b00000110, 0b01011011, 0b01001111, 0b01100110
            .byte   0b01101101, 0b01111101, 0b00000111, 0b01111111, 0b01100111
            .skip   2      // pad with 2 bytes to maintain word alignment

TEST_NUM: .word   0x103fe00f
		  .word	  0x1274fe00
		  .word	  0x00102555
		  .word   0x07100000
		  .word   0xe1111111
		  .word   0x00000009
		  .word   0x1920010e
		  .word   0x10101010
		  .word   0x3210e321
		  .word   0x00007FFF
		  .word   0x00000000
		  
          .end  