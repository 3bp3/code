;
; lab3_t1.asm
;
; Created: 2017/9/7 23:45:30
; Author : lenovo
;


; Replace with your application code
.include "m2560def.inc"

;macro defination
.equ loop_count = 50000


.def iH = r25
.def iL = r24
.def countH = r17
.def countL = r16
.def loop_count2 = r20
.def temp = r27

;Tclock = 1/16MHZ = 1/16 * (10)^(-6)   Tclock * (4 + 8*X + 4) = 1(s)
.macro oneSecondDelay
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

.cseg

		jmp reset
.org	INT0addr ; defined in m2560def.inc
		jmp EXT_INT0
reset:
	ldi zl,low(pattern<<1)
	ldi zh,high(pattern<<1)
	
	ldi temp, (2 << ISC00) ; set INT0 as falling edge triggered interrupt
	sts EICRA, temp
	in temp, EIMSK ; enable INT0
	ori temp, (1<<INT0)
	out EIMSK, temp
	sei ; enable Global Interrupt
	jmp main

EXT_INT0:
	push temp ; save register
	in temp, SREG ; save SREG
	push temp
	
	jmp end

	pop temp ; restore SREG
	out SREG, temp
	pop temp ; restore register
	reti

main:

	ser r18				;1 clock cycle
	out DDRC, r18		;1
	cbi DDRD, 0			;clear bit 0 of
	lpm r21,z+
	lpm r22,z+
	lpm r23,z+
	lpm r26,z
loop:	
			
	out PORTC, r21		;1     clock cycle total = 6
	oneSecondDelay
	out PORTC, r22		;1     clock cycle total = 6
	oneSecondDelay
	out PORTC, r23		;1     clock cycle total = 6
	oneSecondDelay
	out PORTC, r26		;1     clock cycle total = 6
	oneSecondDelay
	rjmp loop


end:
	clr r18
	out PORTC, r18		;1     clock cycle total = 6

stop:
	rjmp stop


;define the pattern
pattern:	.dw 0xA0AA
			.dw 0x1F0A