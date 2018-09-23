;
; lab4t2.asm
;
; Created: 2017/10/12 12:27:31
; Author : lenovo
;


; Replace with your application code
.include "m2560def.inc"


.def countl =r24
.def temp1 = r18 
.def temp2 = r17
.def temp=r19
.def lcd =r20
.def d = r21			; used to display decimal numbers digit by digit
.def count_1 =r16


.equ LCD_CTRL_PORT = PORTA 	; connect LCD control with Port A
.equ LCD_CTRL_DDR = DDRA 	;
.equ LCD_RS = 7 			; locate the bit of RS on LCD control
.equ LCD_E = 6    			; locate the bit of E on LCD control
.equ LCD_RW = 5  			; locate the bit of RW on LCD control
.equ LCD_BE = 4	  			; locate the bit of RS on LCD control


.equ LCD_DATA_PORT = PORTF	; connect LCD control with Port F
.equ LCD_DATA_DDR = DDRF 	; set a lable of DDRF and PINF
.equ LCD_DATA_PIN = PINF

.dseg
TempCounter:
   .byte 2
quotient:
	.byte 2
dividend: 
	.byte 2
divisor: 
	.byte 2

.macro STORE 				; store the value to Port
.if @0 > 63 				; check if the parameter0 > 63
sts @0, @1 					; if is, store parameter0 into data space
.else 						; else
out @0, @1 					; Store data from parameter0 to I/O Space
.endif
.endmacro

.macro LOAD 				; load the value from Port
.if @1 > 63 				; check if the parameter0 > 63
lds @0, @1 					; if is, load parameter0 from data space
.else 						; else
in @0, @1 					; get data from from the I/O Space
.endif
.endmacro

.macro clear
    ldi YL, low(@0)     	; load the memory address to Y
    ldi YH, high(@0)
    clr r22
    st Y+, r22         		; clear the two bytes at @0 in SRAM
    st Y, r22
.endmacro

.macro do_lcd_command 		; initialize LCD command
	ldi r20, @0 			; load parameter0 to r20
	rcall lcd_command 		;
	rcall lcd_wait
.endmacro

.macro do_lcd_data 			; initialize LCD data
	mov r20, @0
	rcall lcd_data 			; display LCD
	rcall lcd_wait
.endmacro

.macro do_lcd_digits 		; display digits of countl on LCD
	mov temp, @0 			; get parameter0
	clear dividend 			; clear dividend
	sts dividend,temp		; store number in dividend
	cpi temp,100 			; compare parameter0's value with 100
	brsh one_hundred 		; if > 100 jump to 100
	jmp ten 				; else jump to ten
one_hundred:
	ldi d,100 				; set divisor as 100
	clear divisor 			;
	sts divisor,d 			;
	rcall get 				; recall get function
	lds d,quotient 			; get quotient
	subi d,-'0' 			; convert digit into ASCII
	do_lcd_data d 			; display
loop1:
	subi temp,100 			; substract temp until it lower than 100
	cpi temp,100 			;
	brsh loop1 				;
ten:
	ldi d,10 				; set divisor as 10
	clear divisor 			; clear
	clear dividend 			; clear
	sts dividend,temp 		; store number in rest dividend 
	sts divisor,d 			; set divisor
	rcall get				; call a function
	lds d,quotient 			; get quotient
	subi d,-'0' 			; convert digit into ASCII
	do_lcd_data d 			; display
	cpi temp,10 			; check if rest number is lower than 10
	brlo one 				; if is , directly display the rest digit
loop2:
	subi temp,10 			; substract temp until it lower than 10
	cpi temp,10 			;
	brsh loop2   			;
one:
	subi temp,-'0'   		; convert digit into ASCII
	do_lcd_data temp 		; display
.endmacro
.cseg

.org 0


	jmp RESET 				; reset
.org INT2addr 				; when falling edge happens, start from here
	jmp EXT_INT2 			; jump to external interrupt operation
.org OVF0addr 				; time overflow address
	jmp	Timer0OVF 			; jump to Timer0OVF
							; 256ги8 bits)*64(frequency)/16million = 1024 microseconds    
							;250 counts take 250ms, and 1 second has 4 250ms, and 1 cycle has 4 holes,so we just count 250ms





RESET: 						
	ldi r20,low(RAMEND) 		; set SPL and SPH point to the address of end of RAM
	out SPL,r20 				;
	ldi r20,high(RAMEND) 		;
	out SPH,r20 				;

	ser r20 					; enable LCD data and control
	STORE LCD_DATA_DDR, r20 	;
	STORE LCD_CTRL_DDR, r20 	;
	clr r20 					; clear the ports of data and control
	STORE LCD_DATA_PORT, r20 	;
	STORE LCD_CTRL_PORT, r20 	;
	do_lcd_command 0b00111000 	; initialize LCD control, with two line and 5*7 dot matrix displayed
	rcall sleep_5ms 			;
	do_lcd_command 0b00111000 	; 2x5x7
	rcall sleep_1ms 			;
	do_lcd_command 0b00111000 	; 2x5x7
	do_lcd_command 0b00111000 	; 2x5x7
	do_lcd_command 0b00001000 	; display off
	do_lcd_command 0b00000001 	; clear display
	do_lcd_command 0b00000110 	; increment, no display shift
	do_lcd_command 0b00001110 	; Cursor on, bar, no blink
jmp main
	

EXT_INT2: 						; external interrupt
		in temp,SREG 			; save SREG into stack
		push temp 				;
		inc countl 				; if there is an interrupt, countl + 1
		pop temp 				; pop SREG out of stack
		out SREG,temp 			;
		reti 					; return
		
Timer0OVF:
		push temp				; save temp
		in temp, SREG			; interrupt subroutine for Timer0
		push temp				; Prologue starts.
		push YH					; Save all conflict registers in the prologue.
		push YL 				;
		push r25 				;
		lds r25,TempCounter 	; load TempCounter into r25
		inc r25 				; r25 + 1
		cpi r25, 250 			; compare r25 with 250, 250 = 1000ms/4(holes)
		brne end 				; if not equal, continue to count
		jmp lcd_1 				; else, display speed
end:
		jmp EndIF 				; jump to EndIF
lcd_1:
		do_lcd_command 0b00000001 ; clear display
		do_lcd_command 0b00000110 ; increment, no display shift
		do_lcd_command 0b00001110 ; Cursor on, bar, no blink
		cpi countl,10 			; check if countl is lower than 10
		brsh nzero 				; if bigger than or equal to 10, jump to nzero
		subi countl,-'0' 		; else, convert digits into ASCII code
		do_lcd_data countl	    ; dislpay digits
		rjmp cleartemp	  		; clear TempCounter
nzero:
		do_lcd_digits countl 	; display digits
cleartemp:
		clear TempCounter 		; reset all counters
		clr r25 				;
		clr countl 				;
EndIF:
	sts TempCounter,r25			; store new TempCounter
	pop r25 					; Epilogue starts: Restore all conflict registers from the stack
	pop YL 						;
	pop YH						;
	pop temp 					;
	out SREG, temp 				;
	pop temp 					;
	reti 						; return from interrupt

main:
	clear TempCounter 			; reset TempCounter
	ldi temp, (2 << ISC20)		; set INT2 as falling edge triggered interrupt
	sts EICRA, temp     		; 
	in temp, EIMSK				; get current EIMSK

	ori temp, (1<<INT2) 		; 
	out EIMSK, temp 			; enable int2
	ldi temp, 0b00000000 		; 
	out TCCR0A, temp 			; 
	ldi temp, 0b00000011 		;
	out TCCR0B, temp			; Prescaling value=64

	ldi temp, 1<<TOIE0			; =1024 microseconds
	sts TIMSK0, temp 			; enable interrupt Timer/Counter0
	sei							; enable Global Interrupt
halt:
	rjmp halt

.macro lcd_set 					; set the function 
	sbi LCD_CTRL_PORT, @0 		; set parameter0's bit of Port A
.endmacro
.macro lcd_clr 					; clear the function of LCD
	cbi LCD_CTRL_PORT, @0 		; clear parameter0's bit of Port A
.endmacro

;
; Send a command to the LCD (r20)
;

lcd_command:
	STORE LCD_DATA_PORT, r20 	; store the command to LCD_DATA_PORT
	rcall sleep_1ms
	lcd_set LCD_E 				; set LCD_E, enable the data read/write of LCD
	rcall sleep_1ms 			; delay to meet timing
	lcd_clr LCD_E 				; clear LCD_E, disable the data read/write of LCD
	rcall sleep_1ms
	ret

lcd_data: 
	STORE LCD_DATA_PORT, r20 	; store the DATA to LCD_DATA_PORT
	lcd_set LCD_RS 				; set LCD_RS to 1, choose to read data other than command
	rcall sleep_1ms 			; delay to meet timing
	lcd_set LCD_E 				; set LCD_E, enable the data read/write of LCD
	rcall sleep_1ms
	lcd_clr LCD_E 				; clear LCD_E, disable the data read/write of LCD
	rcall sleep_1ms 			; clear LCD_RS, enable command write
	lcd_clr LCD_RS
	ret

lcd_wait: 						; wait lcd
	push r20
	clr r20
	STORE LCD_DATA_DDR, r20 	; set Port F as input, to turn off output
	STORE LCD_DATA_PORT, r20 	; clear PORT F
	lcd_set LCD_RW 				; set LCD to read
lcd_wait_loop:
	rcall sleep_1ms 			
	lcd_set LCD_E 				; set LCD_E, enable the data read/write of LCD 
	rcall sleep_1ms 		
	LOAD r20, LCD_DATA_PIN 		; load the LCD_DATA on Port F to r20
	lcd_clr LCD_E 				; disable the data read/write of LCD
	sbrc r20, 7 				; judge if busy flag is cleared, to check if the command or data is transfered
	rjmp lcd_wait_loop 			; if not, return to loop again
	lcd_clr LCD_RW 				; clear LCD_RW, for a command write
	ser r20 					; set all bits of r20
	STORE LCD_DATA_DDR, r20 	; set Port F as output
	pop r20
	ret

.equ F_CPU = 16000000 			; frequency of CPU
.equ DELAY_1MS = F_CPU / 4 / 1000 - 4 	; 1ms cost (16000000/4/1000-4)cycles in all
; 4 cycles per iteration - setup/call-return overhead

sleep_1ms:
	push r24 					; delay 1ms
	push r25 					; store the value in r25 and r24 in stack
	ldi r25, high(DELAY_1MS). 	; load r25:r24 by delay_1ms cycles
	ldi r24, low(DELAY_1MS) 	;
delayloop_1ms: 					; iteration of 1ms
	sbiw r25:r24, 1 			; r25:r24 minus 1
	brne delayloop_1ms 			; if not equal to zero, go to subtraction operation again
	pop r25 					; get the value stored in stack
	pop r24
	ret

sleep_5ms: 						; recall 5 times of the delay 1ms function to delay 5ms
	rcall sleep_1ms
	rcall sleep_1ms
	rcall sleep_1ms
	rcall sleep_1ms
	rcall sleep_1ms
	ret


get: 							; get every digit of countl
	push r24 					; Prologue starts.
	push r23 					; Save all conflict registers in the prologue.
	push r22 					;
	push count_1 				;
	clear quotient 				; clear quotient
	lds r23,dividend 			; load dividend into r23
	lds r24,divisor 			; load divisor into r24
	clr count_1 				; reset count_1, which is used to store every digit
	cp   r23,r24 				; compare dividend with divisor
	breq compl 					; if equal jump to compl
	brsh loop1 					; if bigger, jump to loop1
	ldi r22,0 					; else jump to display '0'
	jmp halt1

compl:
	ldi r22,1 					; about to display '1'
	jmp halt1
				
loop1:
	sub r23,r24 				; continuously substract divisor from dividend
	inc count_1 				; count_1 + 1
	cp r23,r24  				; 
	brsh loop1 					; until dividend is lower than divisor
	mov r22,count_1 			; get the count_1
	jmp halt1
halt1:           
    sts  quotient,r22 			; store the digit into quotient
	pop count_1 				; Epilogue starts: Restore all conflict registers from the stack
	pop	r22 					;
	pop r23	 					;
	pop r24 					;
	ret 						; return

	
