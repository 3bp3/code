;
; lab1.asm
;
; Created: 2017/8/4 17:42:16
; Author : lenovo
;


; Replace with your application code
.include "m2560def.inc"
.def a=r16
.def b=r17
loop:
	cp r17,r16
	breq end
		cp a,b
		brlo else
		sub a,b
		rjmp loop
	else:
		sub b,a
		rjmp loop
end:
	rjmp end
