;
; lab2_2.asm
;
; Created: 2017/9/1 2:56:29
; Author : lenovo
;


; Replace with your application code
.include "m2560def.inc"
.def numberl=r24
.def numberh=r25
.def nl=r16
.def nh=r17
.def c=r18
.def i=r19
.def temp=r21
.def ten=r22
.def zero=r23

.cseg
rjmp main

s: .db "70000",0


main:
	ldi ten,10
	ldi zero,0
	ldi zl,low(s<<1)
	ldi zh,high(s<<1)
	rcall atoi

atoi:
	
	;prologue
	push yl
	push yh
	push nl
	push nh
	push i
	push c
	in yl,spl
	in yh,sph
	sbiw y,4
	out sph,yh
	out sph,yl


	;function body
	clr nl
	clr nh
	lpm c,z+
	ldi i,1

loop:
	
	cpi c,0x30
	brlo done
	cpi c,0x40
	brsh done 
	subi c,0x30
	mul nh,ten
	mov temp,r0
	mul nl,ten
	add r1,temp
	mov nl,r0
	mov nh,r1
	add nl,c
	adc nh,zero
	inc i
	cpi i,6
	brsh done
	lpm c,z+
	rjmp loop

done:
	adiw y,4
	out sph,yh
	out spl,yl
	pop c
	pop i
	pop nh
	pop nl
	pop yh
	pop yl
	ret