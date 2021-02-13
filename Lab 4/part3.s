/* Program that counts consecutive 1s */

          .text                   // executable code follows
          .global _start                  
                             
_start:   MOV     R4, #TEST_NUM   // load the data word
		  MOV	  R5, #0		  //Initialize R5 to zero 
		  MOV     R6, #0

//Calls the ONES subroutine for each element of the list		  
MAIN:	  LDR	  R12, [R4], #4   //Load R1 with a word from the list
		  MOV     R1, R12
		  CMP	  R12, #0		  //Checks for end of the list
		  BEQ	  END
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
        
TEST_NUM: .word   0x00007FFF
		  .word	  0x00002000
		  .word	  0x00111111
		  .word   0x00000000
		  
          .end                            
