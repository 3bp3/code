;
; lab2mint.asm
;
; Created: 2017/8/11 11:49:17
; Author : lenovo
;


; Replace with your application code
.include "m2560def.inc"
.def a=r16
.def b=r17
						;first loop
cp r16,r17				;compare a,b
breq end				;if a=b jump to the end ,else to loop
brlo else1				;to  judge which one is greater
	sub a,b				;if a>b , a=a-b
	rjmp loop2			;jump to the next loop
else1:
	sub b,a
						;second loop
loop2:					
cp r16,r17				
breq end				;judge at this time, is a == b, if equal,jump to the end
brlo else2
	sub a,b
	rjmp loop3
else2:
	sub b,a
	

loop3:
cp r16,r17
breq end
brlo else3
	sub a,b
	rjmp loop4
else3:
	sub b,a
	
loop4:
	cp r16,r17
	breq end
	brlo else4
		sub a,b
		rjmp loop
	else4:
		sub b,a						


								;four times loop, go to the main loop
loop:
	cp r16,r17
	breq end
	brlo else
		sub a,b
		rjmp loop				;jump to the loop
	else:
		sub b,a
		rjmp loop				;jump to the loop
end:
	rjmp end