/* Program that converts a binary number to decimal */
           .text               // executable code follows
           .global _start
_start:
            MOV    R4, #N
            MOV    R5, #Digits  // R5 points to the decimal digits storage location
            LDR    R4, [R4]     // R4 holds N
            MOV    R0, R4       // parameter for DIVIDE goes in R0
            BL     DIVIDE
			STRB   R6, [R5, #3]	
			STRB   R3, [R5, #2]
            STRB   R1, [R5, #1] // Tens digit is now in R1
            STRB   R0, [R5]     // Ones digit is in R0
END:        B      END

/* Subroutine to perform the integer division R0 / 10.
 * Returns: quotient in R1, and remainder in R0
*/
DIVIDE:     MOV    R2, #0 //R2 is the tens bit
			MOV	   R3, #0 //R3 is the hundreds bit
			MOV	   R6, #0 //R6 is the thousands bit

			
THOUSANDS:  CMP    R0, #1000
            BLT    HUNDREDS
            SUB    R0, #1000
            ADD    R6, #1
            B      THOUSANDS

HUNDREDS:	CMP	   R0, #100
			BLT	   TENS
			SUB	   R0, #100
			ADD    R3, #1
			B	   HUNDREDS

TENS:		CMP	   R0, #10
			BLT	   DIV_END
			SUB	   R0, #10
			ADD    R2, #1
			B	   TENS

DIV_END:    MOV    R1, R2     // quotient in R1 (remainder in R0)
            MOV    PC, LR


N:          .word  9178         // the decimal number to be converted
Digits:     .space 4          // storage space for the decimal digits

            .end
