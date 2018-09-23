;
; lab1v2mintime.asm
;
; Created: 2017/8/5 2:41:07
; Author : lenovo
;


; Replace with your application code
.include "m2560def.inc"
.def a=r16
.def b=r17
.def a2=r18
.def b2=r19
.def shift=r20


judge:						;judge how many times should shift back
	mov r18,r16				;copy a,b
	mov r19,r17
	or r18,r19				;logical or between a,b copy
	andi r18,1				;logical and r18 to see if it is a even
	cpi r18,0
	brne loop1 
	lsr r16					
	lsr r17
	inc r20					;to judge r18 bit0 into C flag
	rjmp judge				;check if r18 is a even

	
	
loop1:
	mov r18,r16
	mov r19,r17                      ;to make a become an odd                                                
	andi r18,1
	cpi r18,0
	brne loop2
	lsr r16					;right shift r16
	rjmp loop1
				;make a is always odd
loop2:
	
	cp r16,r17				;compare a,b
	breq end				
	mov a2,a
	mov b2,b
	andi b2,1
	cpi b2,0
	brne b_odd
	lsr r17

	rjmp loop2
b_odd:	
	cp r16,r17
	brlo smaller		;judge if a is smaller than b
		sub r16,r17
		lsr r16
		rjmp loop2
	smaller:
		sub r17,r16 
		lsr r17
		rjmp loop2
		
	
		
shift_back:
	lsl r16	
	dec r20

	cpi r20,0
	breq end
	rjmp shift_back

end:
	rjmp end



