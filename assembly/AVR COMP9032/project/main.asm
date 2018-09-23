
; Replace with your application code
;
; project1v2.asm
;
; Created: 2017/10/26 4:59:43
; Author : z5140430   Yingjie Fang
;


; Replace with your application code
.include "m2560def.inc"
.def row = r16 									; current row number
.def col = r17 									; current column number
.def rmask = r18 								; mask for current row during scan
.def cmask = r19 								; mask for current column during scan
.def i10 = r20	
.def temp0 = r24																
.def temp1 = r21 								
.def temp2 = r22								
.def temp3 = r23								
.def temp4 = r25 								

.equ PORTCDIR = 0xF0 							; PC7-4: output, PC3-0, input	use portC for Keypad
.equ INITCOLMASK = 0xEF 						; scan from the leftmost column
.equ INITROWMASK = 0x01 						; scan from the top row
.equ ROWMASK =0x0F								; 
.equ LCD_CTRL_PORT = PORTA						; connect LCD control with Port A
.equ LCD_CTRL_DDR = DDRA 						;
.equ LCD_RS = 7 								; locate the bit of RS on LCD control
.equ LCD_E = 6    								; locate the bit of E on LCD control
.equ LCD_RW = 5  								; locate the bit of RW on LCD control
.equ LCD_BE = 4	  								; locate the bit of RS on LCD control
.equ LCD_DATA_PORT = PORTF						; connect LCD control with Port F
.equ LCD_DATA_DDR = DDRF 						; set a lable of DDRF and PINF
.equ LCD_DATA_PIN = PINF
.equ F_CPU = 16000000 							; frequency of CPU
.equ DELAY_1MS = F_CPU / 4 / 1000 - 4 			; 1ms cost (16000000/4/1000-4)cycles in all
.equ DELAY_1S = 500
												; 4 cycles per iteration - setup/call-return overhead

.dseg
	quotient:	.byte 2
	dividend:	.byte 2
	divisor:	.byte 2
	acc_x:		.byte 2
	acc_y:		.byte 2	

.macro lcd_set 									; set LCD function 
				sbi		LCD_CTRL_PORT, @0 		; set parameter0's bit of Port A
.endmacro
.macro lcd_clr 									; clear the function of LCD
				cbi		LCD_CTRL_PORT, @0 		; clear parameter0's bit of Port A
.endmacro
.macro do_lcd_digits 							; display digits of input on LCD
				mov		temp0, @0
				cpi		temp0, 10
				brlo	ones 				
				clear	dividend 				; clear dividend
				clear	divisor
				ldi		r25,10 					; set divisor as 10
				sts		dividend,temp0 			
				sts		divisor,r25 			; set divisor
				rcall	divide					; call function divide to get the quotient
				lds		r25,quotient 			
				subi	r25,-'0' 				; convert digit into ASCII
				do_lcd_data1 r25 				; display
remove_tens:
				subi	temp0,10 				
				cpi		temp0,10 				
				brsh	remove_tens   				
ones:
				subi	temp0,-'0'   			; convert digit into ASCII
				do_lcd_data1 temp0 				; display
.endmacro
.macro STORE 									; store the value to Port
				.if @0 > 63 					; check if the parameter0 > 63
				sts @0, @1 						; if is, store parameter0 into data space
				.else 							; else
				out @0, @1 						; Store data from parameter0 to I/O Space
				.endif
.endmacro
.macro LOAD 									; load the value from Port
				.if @1 > 63 					; check if the parameter0 > 63
				lds @0, @1 						; if is, load parameter0 from data space
				.else 							; else
				in @0, @1 						; get data from from the I/O Space
				.endif
.endmacro
.macro clear
				ldi		YL, low(@0)     		; load the memory address to Y
				ldi		YH, high(@0)
				clr		r22
				st		Y+, r22         		; clear the two bytes at @0 in SRAM
				st		Y, r22
.endmacro
.macro do_lcd_command 							; initialize LCD command
				ldi		r20, @0 				; load parameter0 to r20
				rcall	lcd_command 			;
				rcall	lcd_wait
.endmacro
.macro do_lcd_data1 						; initialize LCD data
				mov		r20, @0
				rcall	lcd_data 				; display LCD
				rcall	lcd_wait
.endmacro
.macro do_lcd_data2 								; initialize LCD data
				ldi		r20, @0
				rcall	lcd_data 				; display LCD
				rcall	lcd_wait
.endmacro


.cseg
.org 0
				jmp		RESET
.org INT0addr
				jmp		EXT_INT0
.org INT1addr
				jmp		abort

RESET:
				ldi		r20,low(RAMEND) 		; set SPL and SPH point to the address of end of RAM
				out		SPL,r20 				;
				ldi		r20,high(RAMEND) 		;
				out		SPH,r20 				;				
				clr		temp4
				ldi		temp0,(2<<ISC00)|(2<<ISC10)	;set INT0 and INT1 as falling edged sensed interrupt
				sts		EICRA,temp0

				in		temp0,EIMSK					;enable INT0 and INT1 			
				ori		temp0,(1<<INT0)|(1<<INT1)	
				out		EIMSK,temp0
				sei								;set global interrupt flag
				ser		r20 					; enable LCD data and control
				STORE	LCD_DATA_DDR, r20 		;
				STORE	LCD_CTRL_DDR, r20 		;
				clr		r20 					; clear the ports of data and control
				STORE	LCD_DATA_PORT, r20 		;
				STORE	LCD_CTRL_PORT, r20
				do_lcd_command 0b00111000 		; initialize LCD control, with two line and 5*7 dot matrix displayed
				rcall	sleep_5ms 				;
				do_lcd_command 0b00111000 		; 2x5x7
				rcall	sleep_1ms 				;
				do_lcd_command 0b00111000 		; 2x5x7
				do_lcd_command 0b00111000 		; 2x5x7
				do_lcd_command 0b00001000 		; display off
				do_lcd_command 0b00000001 		; clear display
				do_lcd_command 0b00000110 		; increment, no display shift
				do_lcd_command 0b00001110		; Cursor on, bar, no blink
				do_lcd_data2 'G'
				ldi 	temp1, PORTCDIR 		; PF7:4/PF3:0, out/in
				out 	DDRC, temp1 
				ser 	temp1 					; PORTF is output
				out 	DDRF, temp1
				out 	PORTF, temp1 			; initialization
				jmp		wait
wait:			rjmp	wait

EXT_INT0:										;LED start to flash, use portL for the LED
				push	temp0
				ser		temp0
				sts		DDRL,temp0
				sts		PORTL,temp0
				rcall	sleep_1s
				com		temp0					;one's complement
				sts		PORTL,temp0
				rcall	sleep_1s
				com		temp0
				sts		PORTL,temp0
				rcall	sleep_1s
				com		temp0
				sts		PORTL,temp0
				rcall	sleep_1s
				com		temp0
				sts		PORTL,temp0
				rcall	sleep_1s
				com		temp0
				sts		PORTL,temp0
				do_lcd_data2 ' '				;after flashing, get the input for the accident (x , y)
				do_lcd_data2 '('
				jmp		main

main:		
				ldi		i10,10
				ldi		temp0,(2<<ISC10)
				sts		EICRA,temp0
				in		temp0,EIMSK
				ori		temp0,(1<<INT1)
				out		EIMSK,temp0	
				sei		
				ldi 	cmask, INITCOLMASK 		; initial column mask
				clr 	col 					; initial column
colloop:
				cpi 	col, 4
				breq 	clr_current_pressed 			; if all keys are scanned, initialize temp3.
				out 	PORTC, cmask 			; otherwise, scan a column
				ldi 	temp1, 0xFF 			; slow down the scan operation.
delay: 			dec 	temp1
				brne 	delay

				in 		temp1, PINC 			; read PORTF
				andi 	temp1, ROWMASK 			; get the keypad output value
				cpi 	temp1, 0xF 				; check if any row is low
				breq 	nextcol					; if yes, find which row is low
				ldi 	rmask, INITROWMASK 		; initialize for row check
				clr 	row 
rowloop:
				cpi 	row, 4
				breq 	nextcol 				; the row scan is over.
				mov 	temp2, temp1
				and 	temp2, rmask 			; check un-masked bit
				breq 	convert 				; if bit is clear, the key is pressed
				inc 	row 					; else move to the next row
				lsl 	rmask
				jmp 	rowloop
clr_current_pressed: 								
				ser		temp3					; initialize temp3 by a number that never occur in keypad input
				jmp		main
nextcol: 										; if row scan is over
				lsl 	cmask
				inc 	col 					; increase column value
				jmp 	colloop 				; go to the next column
convert:
				cpi 	col, 3 					; If the pressed key is in col 3
				breq 	letters 				; we have a letter
				cpi 	row, 3 					; else, if the key is in row3
				breq 	symbols 				; we have a symbol or 0
				mov 	temp1, row 				; Otherwise we have a number in 1-9
				lsl 	temp1
				add 	temp1, row 
				add 	temp1, col 				; temp1 = row*3 + col difference between 1 and recently pressed key
				subi 	temp1, -1 				; Add the value of number 1
				jmp 	convert_end 			

letters:
				jmp 	halt 					; do not need letters, go to halt
symbols:
				cpi 	col, 0 					; Check if we have a star
				breq 	star   				
				cpi 	col, 1 					; or if we have zero
				breq 	zero
				ldi 	temp1, '#' 				; if not we have hash
				jmp 	convert_end 			; display letter on LED
star:
				ldi 	temp1, '*' 				; Set to star
				jmp 	convert_end 			; display letter on LED
zero:
				ldi 	temp1, 0    			; Set to zero
convert_end:
				ldi		i10,10
				cp		temp1,temp3 			; check if the key is still pressed
				breq	jump 					; if key is not loosen, jump to scan again
				cpi		temp1,'#'				; check if the key is '#'
				breq	accident_location 		; if pressed, the accident (x,y) is done
				cpi     temp1,'*' 				; check if the key is '*'
				breq    next_number				; if pressed '*', jump to next number
				subi	temp1,-'0'
				do_lcd_data1 temp1 
				subi	temp1,'0'				
				ldi		i10,10
				mul     temp4,i10 				; else, multiply 10 to get the next digit
				tst     r1 						; check whether there is an overflow
				brne	jump_halt 				; if there is, jump to halt
				mov		temp4,r0 				; else, move the accident_location to temp4 register
				add		temp4,temp1 			; then add new input number to the digit
				brcs	jump_halt		  		; check carry, if there is one jump to halt
				mov     temp3,temp1 			; use temp3 to stores the recently pressed key
				jmp 	main 					; Restart main loop
next_number:		
				cp		temp3,temp1 			; check if the key is still pressed
				breq	jump 					; if key is not loosen, jump to scan again
				do_lcd_data2 ','
				ldi     YL,low(acc_x)
				st  	Y, temp4				; get the x position, then store the value of temp4, which is the register hold the value x
				clr		temp3 					; clear the last pressed key
				clr		temp4 					; clear temp4
				mov		temp3,temp1 			; use temp3 to stores the recently pressed key
				jmp		main
jump:
				jmp		main 					; jump to scan again
jump_halt:
				jmp halt

accident_location: 	
				do_lcd_data2 ')'
				rcall	sleep_1s
				ldi     YL,low(acc_y)			; get the second number position									
				st		Y,temp4 				; store accident y in
				jmp		search

abort:
				cli
				do_lcd_command 0b00000001		; clear display
				do_lcd_command 0b00000110		; increment, no display shift
				do_lcd_command 0b00001110		; Cursor on, bar, no blink
				sei
				do_lcd_data2 'A'
				jmp		halt
search:
				ldi		temp0,(2<<ISC10)
				sts		EICRA,temp0
				in		temp0,EIMSK
				ori		temp0,(1<<INT1)
				out		EIMSK,temp0				
				sei
				rcall	motor_initialize
				do_lcd_command 0b00000001		; clear display
				do_lcd_command 0b00000110		; increment, no display shift
				do_lcd_command 0b00001110		; Cursor on, bar, no blink
				ldi		ZL,low(mountain << 1)
				ldi		ZH,high(mountain << 1)
				clr		temp1
				clr		r18						;r18 drone x
				clr		r19						;r19 drone y
				ldi		YL,low(acc_x)
				ld		r16,Y					;r16 stores x of the accident location
				ldi		YL,low(acc_y)			
				ld		r17,Y					;r17 stores y of the accident location
searching:
				ldi		temp0,0xFF
				STORE	OCR3BL,temp0			;input the high speed of the motor 
				rcall	sleep_5ms
				rcall	sleep_5ms
				rcall	sleep_5ms
				rcall	sleep_5ms
				rcall	sleep_5ms
				rcall	sleep_5ms
				rcall	sleep_5ms
				rcall	sleep_5ms
				rcall	sleep_5ms
				rcall	sleep_5ms
				ldi		temp0,0x4A
				STORE	OCR3BL,temp0			;input the low speed of the motor
				rcall	sleep_5ms
				rcall	sleep_5ms
				rcall	sleep_5ms
				rcall	sleep_5ms
				rcall	sleep_5ms
				rcall	sleep_5ms
				rcall	sleep_5ms
				rcall	sleep_5ms
				rcall	sleep_5ms
				rcall	sleep_5ms
				inc		r18						;search from x = 0
				lpm		r23,Z+					;get the height
compare_height:	
				cp		temp1,r23
				brlo	max_height	
				cp		r16,r18
				brne	display_location
				cp		r17,r19
				brne	display_location
				jmp		fly_back				;got the accident place, and fly back
max_height:
				mov		temp1,r23
				rjmp	compare_height				
display_location:
				ldi		temp0,0xFF
				STORE	OCR3BL,temp0			;input the high speed of the motor 
				rcall	sleep_5ms
				rcall	sleep_5ms
				rcall	sleep_5ms
				rcall	sleep_5ms
				rcall	sleep_5ms
				rcall	sleep_5ms
				rcall	sleep_5ms
				rcall	sleep_5ms
				rcall	sleep_5ms
				rcall	sleep_5ms
				subi	r23,-10
				do_lcd_command 0b00000001		; clear display
				do_lcd_command 0b00000110		; increment, no display shift
				do_lcd_command 0b00001110		; Cursor on, bar, no blink
				do_lcd_data2 'S'
				do_lcd_data2 ' '
				do_lcd_data2 '('
				do_lcd_digits r18
				do_lcd_data2 ','
				do_lcd_digits r19
				do_lcd_data2 ','
				do_lcd_digits r23
				do_lcd_data2 ')'
				do_lcd_command 0b11000000
				do_lcd_data2 'n'
				do_lcd_data2 'o'
				do_lcd_data2 't'
				do_lcd_data2 ' '
				do_lcd_data2 'f'
				do_lcd_data2 'o'
				do_lcd_data2 'u'
				do_lcd_data2 'n'
				do_lcd_data2 'd'	
				cpi		r18,64
				brsh	search_nextcol
				jmp		searching
search_nextcol:	
				inc		r19						;increase the drone y
				clr		r18						;initialize drone x
				cpi		r19,65
				brlo	jump_searching
				jmp		halt
jump_searching:
				jmp		searching
fly_back:
				do_lcd_command 0b00000001		; clear display
				do_lcd_command 0b00000110		; increment, no display shift
				do_lcd_command 0b00001110		; Cursor on, bar, no blink
				do_lcd_data2 'G'
				do_lcd_data2 ' '
				do_lcd_data2 '('
				do_lcd_digits r18
				do_lcd_data2 ','
				do_lcd_digits r19
				do_lcd_data2 ','
				do_lcd_digits r23
				do_lcd_data2 ')'
				ldi		temp0,0x4A					; the value controls the PWM duty cycle
				STORE	OCR3BL,temp0
				rcall	sleep_1s
				rcall	sleep_1s
				rcall	sleep_1s
				rcall	sleep_1s
fly_loop1:
				dec		r18
				ldi		temp0,0xFF
				STORE	OCR3BL,temp0			;input the high speed of the motor 
				rcall	sleep_5ms
				rcall	sleep_5ms
				rcall	sleep_5ms
				rcall	sleep_5ms
				rcall	sleep_5ms
				rcall	sleep_5ms
				rcall	sleep_5ms
				rcall	sleep_5ms
				rcall	sleep_5ms
				rcall	sleep_5ms
				do_lcd_command 0b00000001		; clear display
				do_lcd_command 0b00000110		; increment, no display shift
				do_lcd_command 0b00001110		; Cursor on, bar, no blink
				do_lcd_data2 'G'
				do_lcd_data2 ' '
				do_lcd_data2 '('
				do_lcd_digits r18
				do_lcd_data2 ','
				do_lcd_digits r19
				do_lcd_data2 ','
				do_lcd_digits temp1
				do_lcd_data2 ')'
				cpi		r18,0
				breq	fly_loop2
				jmp		fly_loop1
fly_loop2:
				dec r19
				ldi		temp0,0xFF
				STORE	OCR3BL,temp0			;input the high speed of the motor 
				rcall	sleep_5ms
				rcall	sleep_5ms
				rcall	sleep_5ms
				rcall	sleep_5ms
				rcall	sleep_5ms
				rcall	sleep_5ms
				rcall	sleep_5ms
				rcall	sleep_5ms
				rcall	sleep_5ms
				rcall	sleep_5ms
				do_lcd_command 0b00000001		; clear display
				do_lcd_command 0b00000110		; increment, no display shift
				do_lcd_command 0b00001110		; Cursor on, bar, no blink
				do_lcd_data2 'G'
				do_lcd_data2 ' '
				do_lcd_data2 '('
				do_lcd_digits r18
				do_lcd_data2 ','
				do_lcd_digits r19
				do_lcd_data2 ','
				do_lcd_digits temp1
				do_lcd_data2 ')'
				cpi		r19,0
				breq	halt 
				jmp		fly_loop2


halt:
				rcall	motor_initialize	
end:			rjmp	end

lcd_command:
				STORE	LCD_DATA_PORT, r20 		; store the command to LCD_DATA_PORT
				rcall	sleep_1ms
				lcd_set LCD_E 					; set LCD_E, enable the data read/write of LCD
				rcall	sleep_1ms 				; delay to meet timing
				lcd_clr LCD_E 					; clear LCD_E, disable the data read/write of LCD
				rcall	sleep_1ms
				ret
lcd_data: 
				STORE	LCD_DATA_PORT, r20 		; store the DATA to LCD_DATA_PORT
				lcd_set	LCD_RS 					; set LCD_RS to 1, choose to read data other than command
				rcall	sleep_1ms 				; delay to meet timing
				lcd_set LCD_E 					; set LCD_E, enable the data read/write of LCD
				rcall	sleep_1ms
				lcd_clr LCD_E 					; clear LCD_E, disable the data read/write of LCD
				rcall	sleep_1ms 				; clear LCD_RS, enable command write
				lcd_clr LCD_RS
				ret
lcd_wait: 										; wait lcd
				push	r20
				clr		r20
				STORE	LCD_DATA_DDR, r20 		; set Port F as input, to turn off output
				STORE	LCD_DATA_PORT, r20 		; clear PORT F
				lcd_set LCD_RW 					; set LCD to read
lcd_wait_loop:
				rcall	sleep_1ms 			
				lcd_set LCD_E 					; set LCD_E, enable the data read/write of LCD 
				rcall	sleep_1ms 		
				LOAD	r20, LCD_DATA_PIN 		; load the LCD_DATA on Port F to r20
				lcd_clr LCD_E 					; disable the data read/write of LCD
				sbrc	r20, 7 					; judge if busy flag is cleared, to check if the command or data is transfered
				rjmp	lcd_wait_loop 			; if not, return to loop again
				lcd_clr LCD_RW 					; clear LCD_RW, for a command write
				ser		r20 					; set all bits of r20
				STORE	LCD_DATA_DDR, r20 		; set Port F as output
				pop		r20
				ret

motor_initialize:
				push	temp0
				LOAD	temp0,DDRE
				ori		temp0,0b00010000
				STORE	DDRE, temp0
				LOAD	temp0,PORTE
				ori		temp0,0b00010000
				STORE	PORTE, temp0
				ldi		temp0,0b00100001
				STORE	TCCR3A, temp0
				ldi		temp0,0b00001100
				STORE	TCCR3B, temp0
				ser		temp0
				STORE	OCR3AL,temp0
				clr		temp0
				STORE	OCR3AH,temp0
				STORE	OCR3BL,temp0
				STORE	OCR3BH,temp0

				pop		temp0
				ret

sleep_1ms:
				push	r24 					; delay 1ms
				push	r25 					; store the value in r25 and r24 in stack
				ldi		r25, high(DELAY_1MS) 	; load r25:r24 by delay_1ms cycles
				ldi		r24, low(DELAY_1MS) 	;
delayloop_1ms: 									; iteration of 1ms
				sbiw	r25:r24, 1 				; r25:r24 minus 1
				brne	delayloop_1ms 			; if not equal to zero, go to subtraction operation again
				pop		r25 					; get the value stored in stack
				pop		r24
				ret
sleep_5ms: 										; recall 5 times of the delay 1ms function to delay 5ms
				rcall	sleep_1ms
				rcall	sleep_1ms
				rcall	sleep_1ms
				rcall	sleep_1ms
				rcall	sleep_1ms
				ret
sleep_1s:
				push	r24 					
				push	r25
				ldi		r25, high(DELAY_1S). 	; load r25:r24 by delay_1ms cycles
				ldi		r24, low(DELAY_1S)	
innerloop:
				rcall	sleep_1ms
				sbiw	r25:r24, 1 
				brne	innerloop
				pop		r25
				pop		r24
				ret	

divide: 										
				push	r24 					; Prologue starts.
				push	r23 					; Save all conflict registers in the prologue.
				push	r22 					;
				push	r21 					;
				clear	quotient 				; clear the quotient
				lds		r23,dividend 			; load dividend into r23
				lds		r24,divisor 			; load divisor into r24
				clr		r21 					; reset r21, which is used to store every digit
				cp		r23,r24 				; compare dividend with divisor
				breq	display1 				; if equal jump to display1
				brsh	loop1 					; if bigger, jump to loop1
				ldi		r22,0 					; else jump to display '0'
				jmp		halt1
display1:
				ldi		r22,1 					; about to display '1'
				jmp		halt1				
loop1:
				sub		r23,r24 				; continuously substract divisor from dividend
				inc		r21 					; r21 + 1
				cp		r23,r24  				; 
				brsh	loop1 					; until dividend is lower than divisor
				mov		r22,r21 				; get the r21
				jmp		halt1
halt1:           
				sts		quotient,r22 			; store the digit into quotient
				pop		r21 					; Epilogue starts: Restore all conflict registers from the stack
				pop		r22 					;
				pop		r23	 					;
				pop		r24 					;
				ret 

mountain:					
.db 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10
.db 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10
.db 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10
.db 10, 10, 10, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 10, 10, 10, 10, 10, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 10, 10
.db 10, 10, 10, 11, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 11, 10, 10, 10, 10, 10, 12, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 12, 10, 10
.db 10, 10, 10, 11, 14, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 14, 11, 10, 10, 10, 10, 10, 12, 16, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 16, 12, 10, 10
.db 10, 10, 10, 11, 14, 17, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 17, 14, 11, 10, 10, 10, 10, 10, 12, 16, 20, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 20, 16, 12, 10, 10
.db 10, 10, 10, 11, 14, 17, 20, 23, 23, 23, 23, 23, 23, 23, 23, 23, 23, 23, 23, 23, 23, 23, 23, 23, 23, 23, 20, 17, 14, 11, 10, 10, 10, 10, 10, 12, 16, 20, 24, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 24, 20, 16, 12, 10, 10
.db 10, 10, 10, 11, 14, 17, 20, 23, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 23, 20, 17, 14, 11, 10, 10, 10, 10, 10, 12, 16, 20, 24, 28, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 28, 24, 20, 16, 12, 10, 10
.db 10, 10, 10, 11, 14, 17, 20, 23, 26, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29, 26, 23, 20, 17, 14, 11, 10, 10, 10, 10, 10, 12, 16, 20, 24, 28, 32, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 32, 28, 24, 20, 16, 12, 10, 10
.db 10, 10, 10, 11, 14, 17, 20, 23, 26, 29, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 29, 26, 23, 20, 17, 14, 11, 10, 10, 10, 10, 10, 12, 16, 20, 24, 28, 32, 36, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 36, 32, 28, 24, 20, 16, 12, 10, 10
.db 10, 10, 10, 11, 14, 17, 20, 23, 26, 29, 32, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 32, 29, 26, 23, 20, 17, 14, 11, 10, 10, 10, 10, 10, 12, 16, 20, 24, 28, 32, 36, 40, 44, 44, 44, 44, 44, 44, 44, 44, 44, 44, 44, 40, 36, 32, 28, 24, 20, 16, 12, 10, 10
.db 10, 10, 10, 11, 14, 17, 20, 23, 26, 29, 32, 35, 38, 38, 38, 38, 38, 38, 38, 38, 38, 35, 32, 29, 26, 23, 20, 17, 14, 11, 10, 10, 10, 10, 10, 12, 16, 20, 24, 28, 32, 36, 40, 44, 48, 48, 48, 48, 48, 48, 48, 48, 48, 44, 40, 36, 32, 28, 24, 20, 16, 12, 10, 10
.db 10, 10, 10, 11, 14, 17, 20, 23, 26, 29, 32, 35, 38, 41, 41, 41, 41, 41, 41, 41, 38, 35, 32, 29, 26, 23, 20, 17, 14, 11, 10, 10, 10, 10, 10, 12, 16, 20, 24, 28, 32, 36, 40, 44, 48, 52, 52, 52, 52, 52, 52, 52, 48, 44, 40, 36, 32, 28, 24, 20, 16, 12, 10, 10
.db 10, 10, 10, 11, 14, 17, 20, 23, 26, 29, 32, 35, 38, 41, 44, 44, 44, 44, 44, 41, 38, 35, 32, 29, 26, 23, 20, 17, 14, 11, 10, 10, 10, 10, 10, 12, 16, 20, 24, 28, 32, 36, 40, 44, 48, 52, 56, 56, 56, 56, 56, 52, 48, 44, 40, 36, 32, 28, 24, 20, 16, 12, 10, 10
.db 10, 10, 10, 11, 14, 17, 20, 23, 26, 29, 32, 35, 38, 41, 44, 47, 47, 47, 44, 41, 38, 35, 32, 29, 26, 23, 20, 17, 14, 11, 10, 10, 10, 10, 10, 12, 16, 20, 24, 28, 32, 36, 40, 44, 48, 52, 56, 60, 60, 60, 56, 52, 48, 44, 40, 36, 32, 28, 24, 20, 16, 12, 10, 10
.db 10, 10, 10, 11, 14, 17, 20, 23, 26, 29, 32, 35, 38, 41, 44, 47, 50, 47, 44, 41, 38, 35, 32, 29, 26, 23, 20, 17, 14, 11, 10, 10, 10, 10, 10, 12, 16, 20, 24, 28, 32, 36, 40, 44, 48, 52, 56, 60, 64, 60, 56, 52, 48, 44, 40, 36, 32, 28, 24, 20, 16, 12, 10, 10
.db 10, 10, 10, 11, 14, 17, 20, 23, 26, 29, 32, 35, 38, 41, 44, 47, 47, 47, 44, 41, 38, 35, 32, 29, 26, 23, 20, 17, 14, 11, 10, 10, 10, 10, 10, 12, 16, 20, 24, 28, 32, 36, 40, 44, 48, 52, 56, 60, 60, 60, 56, 52, 48, 44, 40, 36, 32, 28, 24, 20, 16, 12, 10, 10
.db 10, 10, 10, 11, 14, 17, 20, 23, 26, 29, 32, 35, 38, 41, 44, 44, 44, 44, 44, 41, 38, 35, 32, 29, 26, 23, 20, 17, 14, 11, 10, 10, 10, 10, 10, 12, 16, 20, 24, 28, 32, 36, 40, 44, 48, 52, 56, 56, 56, 56, 56, 52, 48, 44, 40, 36, 32, 28, 24, 20, 16, 12, 10, 10
.db 10, 10, 10, 11, 14, 17, 20, 23, 26, 29, 32, 35, 38, 41, 41, 41, 41, 41, 41, 41, 38, 35, 32, 29, 26, 23, 20, 17, 14, 11, 10, 10, 10, 10, 10, 12, 16, 20, 24, 28, 32, 36, 40, 44, 48, 52, 52, 52, 52, 52, 52, 52, 48, 44, 40, 36, 32, 28, 24, 20, 16, 12, 10, 10
.db 10, 10, 10, 11, 14, 17, 20, 23, 26, 29, 32, 35, 38, 38, 38, 38, 38, 38, 38, 38, 38, 35, 32, 29, 26, 23, 20, 17, 14, 11, 10, 10, 10, 10, 10, 12, 16, 20, 24, 28, 32, 36, 40, 44, 48, 48, 48, 48, 48, 48, 48, 48, 48, 44, 40, 36, 32, 28, 24, 20, 16, 12, 10, 10
.db 10, 10, 10, 11, 14, 17, 20, 23, 26, 29, 32, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 32, 29, 26, 23, 20, 17, 14, 11, 10, 10, 10, 10, 10, 12, 16, 20, 24, 28, 32, 36, 40, 44, 44, 44, 44, 44, 44, 44, 44, 44, 44, 44, 40, 36, 32, 28, 24, 20, 16, 12, 10, 10
.db 10, 10, 10, 11, 14, 17, 20, 23, 26, 29, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 29, 26, 23, 20, 17, 14, 11, 10, 10, 10, 10, 10, 12, 16, 20, 24, 28, 32, 36, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 36, 32, 28, 24, 20, 16, 12, 10, 10
.db 10, 10, 10, 11, 14, 17, 20, 23, 26, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29, 26, 23, 20, 17, 14, 11, 10, 10, 10, 10, 10, 12, 16, 20, 24, 28, 32, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 32, 28, 24, 20, 16, 12, 10, 10
.db 10, 10, 10, 11, 14, 17, 20, 23, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 23, 20, 17, 14, 11, 10, 10, 10, 10, 10, 12, 16, 20, 24, 28, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 28, 24, 20, 16, 12, 10, 10
.db 10, 10, 10, 11, 14, 17, 20, 23, 23, 23, 23, 23, 23, 23, 23, 23, 23, 23, 23, 23, 23, 23, 23, 23, 23, 23, 20, 17, 14, 11, 10, 10, 10, 10, 10, 12, 16, 20, 24, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 24, 20, 16, 12, 10, 10
.db 10, 10, 10, 11, 14, 17, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 17, 14, 11, 10, 10, 10, 10, 10, 12, 16, 20, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 20, 16, 12, 10, 10
.db 10, 10, 10, 11, 14, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 14, 11, 10, 10, 10, 10, 10, 12, 16, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 16, 12, 10, 10
.db 10, 10, 10, 11, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 11, 10, 10, 10, 10, 10, 12, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 12, 10, 10
.db 10, 10, 10, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 10, 10, 10, 10, 10, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 10, 10
.db 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10
.db 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10
.db 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10
.db 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10
.db 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10
.db 10, 10, 10, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 10, 10, 10, 10, 10, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 10, 10
.db 10, 10, 10, 12, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 12, 10, 10, 10, 10, 10, 11, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 11, 10, 10
.db 10, 10, 10, 12, 16, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 16, 12, 10, 10, 10, 10, 10, 11, 14, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 14, 11, 10, 10
.db 10, 10, 10, 12, 16, 20, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 20, 16, 12, 10, 10, 10, 10, 10, 11, 14, 17, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 17, 14, 11, 10, 10
.db 10, 10, 10, 12, 16, 20, 24, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 24, 20, 16, 12, 10, 10, 10, 10, 10, 11, 14, 17, 20, 23, 23, 23, 23, 23, 23, 23, 23, 23, 23, 23, 23, 23, 23, 23, 23, 23, 23, 23, 20, 17, 14, 11, 10, 10
.db 10, 10, 10, 12, 16, 20, 24, 28, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 28, 24, 20, 16, 12, 10, 10, 10, 10, 10, 11, 14, 17, 20, 23, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 23, 20, 17, 14, 11, 10, 10
.db 10, 10, 10, 12, 16, 20, 24, 28, 32, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 32, 28, 24, 20, 16, 12, 10, 10, 10, 10, 10, 11, 14, 17, 20, 23, 26, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29, 26, 23, 20, 17, 14, 11, 10, 10
.db 10, 10, 10, 12, 16, 20, 24, 28, 32, 36, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 36, 32, 28, 24, 20, 16, 12, 10, 10, 10, 10, 10, 11, 14, 17, 20, 23, 26, 29, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 29, 26, 23, 20, 17, 14, 11, 10, 10
.db 10, 10, 10, 12, 16, 20, 24, 28, 32, 36, 40, 44, 44, 44, 44, 44, 44, 44, 44, 44, 44, 44, 40, 36, 32, 28, 24, 20, 16, 12, 10, 10, 10, 10, 10, 11, 14, 17, 20, 23, 26, 29, 32, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 32, 29, 26, 23, 20, 17, 14, 11, 10, 10
.db 10, 10, 10, 12, 16, 20, 24, 28, 32, 36, 40, 44, 48, 48, 48, 48, 48, 48, 48, 48, 48, 44, 40, 36, 32, 28, 24, 20, 16, 12, 10, 10, 10, 10, 10, 11, 14, 17, 20, 23, 26, 29, 32, 35, 38, 38, 38, 38, 38, 38, 38, 38, 38, 35, 32, 29, 26, 23, 20, 17, 14, 11, 10, 10
.db 10, 10, 10, 12, 16, 20, 24, 28, 32, 36, 40, 44, 48, 52, 52, 52, 52, 52, 52, 52, 48, 44, 40, 36, 32, 28, 24, 20, 16, 12, 10, 10, 10, 10, 10, 11, 14, 17, 20, 23, 26, 29, 32, 35, 38, 41, 41, 41, 41, 41, 41, 41, 38, 35, 32, 29, 26, 23, 20, 17, 14, 11, 10, 10
.db 10, 10, 10, 12, 16, 20, 24, 28, 32, 36, 40, 44, 48, 52, 56, 56, 56, 56, 56, 52, 48, 44, 40, 36, 32, 28, 24, 20, 16, 12, 10, 10, 10, 10, 10, 11, 14, 17, 20, 23, 26, 29, 32, 35, 38, 41, 44, 44, 44, 44, 44, 41, 38, 35, 32, 29, 26, 23, 20, 17, 14, 11, 10, 10
.db 10, 10, 10, 12, 16, 20, 24, 28, 32, 36, 40, 44, 48, 52, 56, 60, 60, 60, 56, 52, 48, 44, 40, 36, 32, 28, 24, 20, 16, 12, 10, 10, 10, 10, 10, 11, 14, 17, 20, 23, 26, 29, 32, 35, 38, 41, 44, 47, 47, 47, 44, 41, 38, 35, 32, 29, 26, 23, 20, 17, 14, 11, 10, 10
.db 10, 10, 10, 12, 16, 20, 24, 28, 32, 36, 40, 44, 48, 52, 56, 60, 64, 60, 56, 52, 48, 44, 40, 36, 32, 28, 24, 20, 16, 12, 10, 10, 10, 10, 10, 11, 14, 17, 20, 23, 26, 29, 32, 35, 38, 41, 44, 47, 50, 47, 44, 41, 38, 35, 32, 29, 26, 23, 20, 17, 14, 11, 10, 10
.db 10, 10, 10, 12, 16, 20, 24, 28, 32, 36, 40, 44, 48, 52, 56, 60, 60, 60, 56, 52, 48, 44, 40, 36, 32, 28, 24, 20, 16, 12, 10, 10, 10, 10, 10, 11, 14, 17, 20, 23, 26, 29, 32, 35, 38, 41, 44, 47, 47, 47, 44, 41, 38, 35, 32, 29, 26, 23, 20, 17, 14, 11, 10, 10
.db 10, 10, 10, 12, 16, 20, 24, 28, 32, 36, 40, 44, 48, 52, 56, 56, 56, 56, 56, 52, 48, 44, 40, 36, 32, 28, 24, 20, 16, 12, 10, 10, 10, 10, 10, 11, 14, 17, 20, 23, 26, 29, 32, 35, 38, 41, 44, 44, 44, 44, 44, 41, 38, 35, 32, 29, 26, 23, 20, 17, 14, 11, 10, 10
.db 10, 10, 10, 12, 16, 20, 24, 28, 32, 36, 40, 44, 48, 52, 52, 52, 52, 52, 52, 52, 48, 44, 40, 36, 32, 28, 24, 20, 16, 12, 10, 10, 10, 10, 10, 11, 14, 17, 20, 23, 26, 29, 32, 35, 38, 41, 41, 41, 41, 41, 41, 41, 38, 35, 32, 29, 26, 23, 20, 17, 14, 11, 10, 10
.db 10, 10, 10, 12, 16, 20, 24, 28, 32, 36, 40, 44, 48, 48, 48, 48, 48, 48, 48, 48, 48, 44, 40, 36, 32, 28, 24, 20, 16, 12, 10, 10, 10, 10, 10, 11, 14, 17, 20, 23, 26, 29, 32, 35, 38, 38, 38, 38, 38, 38, 38, 38, 38, 35, 32, 29, 26, 23, 20, 17, 14, 11, 10, 10
.db 10, 10, 10, 12, 16, 20, 24, 28, 32, 36, 40, 44, 44, 44, 44, 44, 44, 44, 44, 44, 44, 44, 40, 36, 32, 28, 24, 20, 16, 12, 10, 10, 10, 10, 10, 11, 14, 17, 20, 23, 26, 29, 32, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 32, 29, 26, 23, 20, 17, 14, 11, 10, 10
.db 10, 10, 10, 12, 16, 20, 24, 28, 32, 36, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 36, 32, 28, 24, 20, 16, 12, 10, 10, 10, 10, 10, 11, 14, 17, 20, 23, 26, 29, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 29, 26, 23, 20, 17, 14, 11, 10, 10
.db 10, 10, 10, 12, 16, 20, 24, 28, 32, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 32, 28, 24, 20, 16, 12, 10, 10, 10, 10, 10, 11, 14, 17, 20, 23, 26, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29, 26, 23, 20, 17, 14, 11, 10, 10
.db 10, 10, 10, 12, 16, 20, 24, 28, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 28, 24, 20, 16, 12, 10, 10, 10, 10, 10, 11, 14, 17, 20, 23, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 23, 20, 17, 14, 11, 10, 10
.db 10, 10, 10, 12, 16, 20, 24, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 24, 20, 16, 12, 10, 10, 10, 10, 10, 11, 14, 17, 20, 23, 23, 23, 23, 23, 23, 23, 23, 23, 23, 23, 23, 23, 23, 23, 23, 23, 23, 23, 20, 17, 14, 11, 10, 10
.db 10, 10, 10, 12, 16, 20, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 20, 16, 12, 10, 10, 10, 10, 10, 11, 14, 17, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 17, 14, 11, 10, 10
.db 10, 10, 10, 12, 16, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 16, 12, 10, 10, 10, 10, 10, 11, 14, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 14, 11, 10, 10
.db 10, 10, 10, 12, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 12, 10, 10, 10, 10, 10, 11, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 11, 10, 10
.db 10, 10, 10, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 10, 10, 10, 10, 10, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 10, 10
.db 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10
.db 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10

