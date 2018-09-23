;
; lab1t2v2.asm
;
; Created: 2017/8/18 15:37:09
; Author : lenovo
;


; Replace with your application code
.include "m2560def.inc"

.def a=r16
.def n=r17
.def carry=r18

.def suml=r20
.def sumh=r21

mov r0,a                ;initial value of r0, give a
mov suml,a				;initial value of sum

main:
	dec n				;judge when to stop loop
	cpi n,0
	breq end
						;start power
	mov carry,r0		;hold r0
	mul r1,a			;multiply high byte first
	add sumh,r0			;add high byte result r0 to sum first
	mul carry,a			;then calculate low byte
						
						;add low byte result
	add suml,r0			
	adc sumh,r1
	
	rjmp main


end:
	rjmp end