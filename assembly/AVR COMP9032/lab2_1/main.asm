;
; lab2_1.asm
;
; Created: 2017/8/25 5:37:35
; Author : lenovo
;


; Replace with your application code
.include "m2560def.inc"

;date memory
.dseg
.org 0x200
quotinent: .byte 2

;program memory
.cseg

ldi zl,low(divider<<1)
ldi zh,high(divider<<1)
ldi yh,high(quotinent)
ldi yl,low(quotinent)

;define register
.def bit_positionL = r16
.def bit_positionH = r17
.def quotinentL = r18
.def quotinentH = r19
.def divisorL = r20
.def divisorH = r21
.def dividendL = r22
.def dividendH = r23
.def divisorHcp = r24
.def compareL = r10
.def compareH = r11

	clr compareL
	clr compareH
	clr bit_positionH
	ldi bit_positionL,1
	clr quotinentH
	ldi quotinentL,0

	lpm divisorL,z+
	lpm divisorH,z+
	lpm dividendL,z+
	lpm dividendH,z
while1:
	mov divisorHcp,divisorH
	andi divisorHcp,0x80           ;logical and high byte
	cpi divisorHcp,0
	brne while2
	cp dividendL,divisorL
	cpc dividendH,divisorH
	breq while2
	brlo while2
	lsl divisorL
	rol divisorH
	lsl bit_positionL
	rol bit_positionH
	rjmp while1

while2:
	cp bit_positionL,compareL
	cpc bit_positionH,compareH
	breq load
	brlo load
	cp dividendL,divisorL
	cpc dividendH,divisorH
	brlo while2main
	sub dividendL,divisorL
	sbc dividendH,divisorH
	add quotinentL,bit_positionL
	adc quotinentH,bit_positionH

while2main:
	lsr divisorH
	ror divisorL
	lsr bit_positionH
	ror bit_positionL
	rjmp while2


load:
	st y+,quotinentL
	st y+,quotinentH

end:
	rjmp end


divider: .dw 4
		 .dw 20000
	
		

