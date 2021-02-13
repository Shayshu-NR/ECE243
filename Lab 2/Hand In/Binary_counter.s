.define LED_ADDRESS 0x1000
.define SW_ADDRESS 0x3000

			mv	r2, #0x0000
MAIN:		mvt	r3, #LED_ADDRESS		// LED reg address 
			add	r2, #1
 			st		r2, [r3]			// write address pointer to LEDs 
			mvt		r5, #0xFF00			//Create delay	
			ld		r5, [r5]
			
OUTER:		mvt	r0, #SW_ADDRESS			// point to SW port 
			ld	r4, [r0]				// load inner loop delay from SW 
			add	r4, #1					// in case 0 was read
INNER:		sub	r4, #1					// decrement inner loop counter 
 			bne	#INNER					// continue inner loop 
 			sub	r5, #1					// decrement outer loop counter 
 			bne	#OUTER					// continue outer loop 

			b	 	#MAIN 				// execute again 