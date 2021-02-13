/* Program that counts consecutive 1s */

          .text                   // executable code follows
          .global _start                  
                             
_start:   MOV     R4, #TEST_NUM   // load the data word
		  MOV	  R5, #0		  //Initialize R5 to zero 

//Calls the ONES subroutine for each element of the list		  
MAIN:	  LDR	  R1, [R4], #4 	  //Load R1 with a word from the lsit
		  CMP	  R1, #0		  //Checks for end of the list
		  BEQ	  END
		  MOV	  R0, #0	      // Reset R0 for the new loop
		  BL	  ONES			  //Start the subroutine
		  CMP	  R5, R0		  //If R5<R0 update R5
		  MOVLT   R5, R0
		  B		  MAIN			  //Repeat
		  
END:      B       END    
		  
//Subroutine to find the longest string of ones      
ONES:     CMP     R1, #0          // loop until the data contains no more 1's
          MOVEQ   PC, LR		  //Return to MAIN essentially           
          LSR     R2, R1, #1      // perform SHIFT, followed by AND
          AND     R1, R1, R2      
          ADD     R0, #1          // count the string length so far
          B       ONES            
        
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
