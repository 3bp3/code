;
; lab3_t3final.asm
;
; Created: 2017/10/6 2:48:06
; Author : lenovo
;


; Replace with your application code


.include "m2560def.inc"

.def row = r12 ; current row value
.def col = r13 ; current col value
.def rmask = r18 ; mask for current row scan
.def cmask = r19 ; mask for current col scan
.def i10 = r20
.def i0 = r10
.def i1 = r21
.def countL = r22
.def countH = r23
.def temp1 = r24
.def temp2 = r25
.def iL = r15
.def iH = r14


.equ portFdir = 0xF0			; PortF 7-4: output, PortF 3-0, input
.equ initColMask = 0xEF			; scan from the leftmost column
.equ initRowMask = 0x01			; scan from the top row
.equ rowMask = 0x0F				; for obtaining input from Port F
.equ loop_count = 50000

.macro delayLoop
	ldi loop_count2,40
initin:
	ldi countL, low(loop_count) ; 1 cycle
	ldi countH, high(loop_count)
	clr iH						; 1
	clr iL
inloop:
		
	
							;clock cycle total in loop = 8
		cp iL, countL		; 1
		cpc iH, countH
		brsh outloop		; 1, 2 (if branch)
		adiw iH:iL, 1		; 2
		rjmp inloop			; 2
outloop:
	dec loop_count2
	cpi loop_count2,0
	breq done
	rjmp initin  
done:
.endmacro




.dseg
mul1: .byte 1
mul2: .byte 1

.cseg

RESET:
															; initialize port
                ldi temp1, portFdir
                out ddrF, temp1
                ser temp1             
                out ddrC, temp1
                ser temp1
                out portC, temp1

															; fixed data
                clr i0
                ldi i1, 1
                ldi i10, 10

init:			
                ldi yl, low(mul2)
                ldi yh, high(mul2)
                clr temp1
                st y, temp1
				;cleardata mul2
                ldi yl, low(mul1)
                ldi yh, high(mul1)
                clr temp1
                st y, temp1
				;cleardata mul1
  
main:
                ldi cmask, initColMask
                clr col

colLoop:
                cpi col, 4
                breq main
                out portF, cMask ; scan a column
                delayLoop 60000
                in temp1, pinF ; read port F
                andi temp1, rowMask
                cpi temp1, 0xF ; check if any row is low (0 value for keypress), checking low byte
                breq nextCol

                ldi rmask, initRowMask ; initialize for row check
                clr row

rowLoop:
                cpi row, 4
                breq nextCol ; scan done, go to next col
                mov temp2, temp1
                and temp2, rmask
                breq convert
                inc row
                lsl rmask
                rjmp rowLoop

nextCol:
                lsl cmask
                inc col								; increase colume value
                rjmp colLoop

convert:
                cpi col, 3
                breq letters

                cpi row, 3
                breq symbols

													; get the int value of button pressed
                mov temp1, row
                lsl temp1
                add temp1, row
                add temp1, col    
                subi temp1,-1

													; multiple int value with existing data stored and store the value
multiply:
                ld temp2, y
                mul temp2, i10
				mov temp2, r0
				cpi r1,1
				brsh overflow        
                add temp1, temp2             
                st y, temp1
                rjmp convertEnd

                
letters:
                clr temp1
                rjmp convertEnd

symbols:
                cp col, i0
                breq star
                cpi col, 1
                breq zero
                ;if a '#' key pressed for result of multiplication
                ldi yl, low (mul2)
                ldi yh, high (mul2)
                ld temp2, y
                ldi yl, low (mul1)
                ldi yh, high (mul1)
                ld temp1, y

                mul temp1, temp2
                mov temp1, r0
                cpi r1, 1
                brsh overflow  
                jmp display

													; change y data storage for next term to multiply
star:
                ldi yl, low (mul2)
                ldi yh, high (mul2)
                clr temp1
                jmp convertEnd

													;zero is pressed and need to multiply and store
zero:
                ldi temp1, 0
                jmp multiply

												; done convert, display and get next key press
convertEnd:
                out portC, temp1                
                jmp main ; restart loop

												;display multiple result and restart entire process
display:  
                out portC, temp1                
                jmp init ; restart all

												 ; overflow of calculation happens
overflow:
                ser temp1
                clr temp2
                out portC, temp1
                delayLoop 60000
                out portC, temp2
                delayLoop 60000
                out portC, temp1
                delayLoop 60000
                out portC, temp2
                delayLoop 60000
                out portC, temp1
                delayLoop 60000
                out portC, temp2
                delayLoop 60000
                clr temp1

                jmp init ; restart all

