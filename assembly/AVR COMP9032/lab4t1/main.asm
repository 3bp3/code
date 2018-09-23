;
; lab4t1.asm
;
; Created: 2017/10/12 11:03:22
; Author : lenovo
;


; Replace with your application code
.include  "m2560def.inc"
.def row = r16   ;current row value
.def col = r17
.def rmask = r18 ;mask for current row scan
.def cmask = r19   ;mask for current col scan
.def i0=r10
.def i1=r11
.def iClear=r12
.def delayLow=r20
.def delayHigh=r21
.def temp1=r22
.def temp2=r23
.def iCount=r24
.equ keyDef=0xF0  ;port L 7-4 output 0-3 input 
.equ keyPort=portL
.equ keyDdr=ddrL
.equ keyPin=pinL
.equ initColMask=0xEF  ;  scan  from  left  col  1110  (not  used)-1111  ;  using  high  byte  for col
.equ initRowMask=0x01  ;  scan  from  top  row  (not  used)-0000  0001  ;  using  low  byte  for row
.equ rowMask=0x0F  ;  0000  1111.equ  LCD_CTRL_PORT=portA
.equ LCD_CTRL_PORT = portA
.equ LCD_CTRL_DDR = ddrA
.equ LCD_RS=7
.equ LCD_E=6
.equ LCD_RW=5
.equ LCD_BE=4
.equ LCD_DATA_PORT = portF
.equ LCD_DATA_DDR = ddrF
.equ LCD_DATA_PIN = pinF


.macro  STORE
	.if  @0 > 63
		sts @0,@1
	.else
		out @0,@1
	.endif
.endmacro

.macro LOAD
	.if  @1 > 63
		lds @0,@1
	.else
		in @0,@1
	.endif
.endmacro

.macro do_lcd_command
	ldi temp1,@0
	rcall lcd_command
	rcall lcd_wait
.endmacro

.macro do_lcd_data
	ldi temp1,@0
	rcall lcd_data
	rcall lcd_wait
.endmacro

.macro delayLoop
	push temp2
	ldi temp2,  5
loop1:
	ldi delayLow,low(@0)
	ldi delayHigh,high(@0)
loop2:
	nop
	nop
	nop
	sub  delayLow,  i1
	sbc  delayHigh,  i0
	cpi  delayLow,  0
	cpc  delayHigh,  i0
	brne  loop2
	subi  temp2,  1
	brsh  loop1
	pop  temp2
.endmacro


.cseg
RESET:
	ldi  temp1,  low(RAMEND)
	out  SPL,  temp1
	ldi  temp1,  high(RAMEND)
	out  SPH,  temp1
	ser  temp1
	STORE LCD_DATA_DDR,temp1	;set DDR = logic one for output
	STORE LCD_CTRL_DDR,temp1
	clr  temp1
	STORE LCD_DATA_PORT,temp1	;set port = logic zero active output pull up	
	STORE LCD_CTRL_PORT,temp1
	do_lcd_command  0b00111000  ;  2x5x7
	rcall  sleep_5ms
	do_lcd_command  0b00111000  ;  2x5x7rcall  sleep_1ms
	do_lcd_command  0b00111000  ;  2x5x7
	do_lcd_command  0b00111000  ;  2x5x7
	do_lcd_command  0b00001000  ;  display  off
	do_lcd_command  0b00000001  ;  clear  display
	do_lcd_command  0b00000110  ;  increment,  no  display  shift
	do_lcd_command  0b00001110  ;  Cursor  on,  bar,  no  blink
	;  initialize  port
	ldi  temp1,  keyDef
	sts  keyDdr,  temp1
	ser  temp1
	out  ddrC,  temp1
	ser  temp1
	out  portC,  temp1
	;  fixed  data
	clr  i0
	clr  i1
	inc  i1
	;  reset  counter
	clr  iCount
	clr  iClear
main:
	ldi  cmask,  initColMask
	clr  col

colLoop:
	cpi  col,  4
	breq  main
	sts  keyPort,  cMask  ;  scan  a  column
	delayLoop  2000
	lds  temp1,  keyPin  ;  read  key  input  pin
	andi  temp1,  rowMask
	cpi  temp1,  0xF  ;  check  if  any  row  is  low  (0  value  for  keypress),  checking  lowbyte
	breq  nextCol
	ldi  rmask,  initRowMask  ;  initialize  for  row  check
	clr  row

rowLoop:
	cpi  row,  4
	breq  nextCol  ;  scan  done,  go  to  next  col
	mov  temp2,  temp1
	and  temp2,  rmask
	breq  convert
	inc  row
	lsl  rmask
	rjmp  rowLoop

nextCol:
	lsl  cmask
	inc  col  ;  increase  colume  value
	rjmp  colLoop
convert:
	cpi  col,  3
	breq  letters
	cpi  row,  3
	breq  symbols
	//  get  the  int  value  of  button  pressed
	mov  temp1,  row
	lsl  temp1
	add  temp1,  row
	add  temp1,  col
	subi  temp1,  -'1'
	rjmp  convertEnd
letters:
	ldi  temp1,  'A'
	add  temp1,  row
	rjmp  convertEnd
symbols:
	cp  col,  i0
	breq  star
	cp  col,  i1
	breq  zero
	ldi  temp1,  '#'
	rjmp  convertEnd
//  change  y  data  storage  for  next  term  to  multiply
star:
	ldi  temp1,  '*'
	jmp  convertEnd
//  zero  is  pressed  and  need  to  multiply  and  store
zero:
	ldi  temp1,  '0'
//  done  convert,  display  and  get  next  key  press
convertEnd:
	out  portC,  temp1
	delayLoop  60000
	rcall  lcd_data
	rcall  lcd_wait
	inc  iCount
	cpi  iCount,  16
	brsh  lcdNewLine
	jmp  main  ;  restart  loop

lcdNewline:
	cp  iClear,  i1
	breq  lcdClear
	do_lcd_command  0b11000000
	clr  iCount
	inc  iClear
	jmp  main

lcdClear:
	do_lcd_command  0b00000001
	clr  iCount
	clr  iClear
	jmp  main

.macro lcd_set
	sbi LCD_CTRL_PORT,@0
.endmacro

.macro lcd_clr
	cbi LCD_CTRL_PORT,@0
.endmacro
 
; Send  a  command  to  the  LCD  (r16)

lcd_command:
	STORE  LCD_DATA_PORT,  temp1
	rcall  sleep_1ms
	lcd_set  LCD_E
	rcall  sleep_1ms
	lcd_clr  LCD_E
	rcall  sleep_1ms
	ret

lcd_data:
	STORE  LCD_DATA_PORT, temp1
	lcd_set  LCD_RS
	rcall  sleep_1ms
	lcd_set  LCD_E
	rcall  sleep_1ms
	lcd_clr  LCD_E
	rcall  sleep_1ms
	lcd_clr  LCD_RS
	ret

lcd_wait:
	push  temp1
	clr  temp1
	STORE  LCD_DATA_DDR,  temp1			;set as input
	STORE  LCD_DATA_PORT,  temp1
	lcd_set  LCD_RW						;select rw read mode
lcd_wait_loop:
	rcall  sleep_1ms
	lcd_set  LCD_E
	rcall  sleep_1ms
	LOAD  temp1, LCD_DATA_PIN
	lcd_clr  LCD_E
	sbrc  temp1,  7
	rjmp  lcd_wait_loop
	lcd_clr  LCD_RW
	ser  temp1
	STORE  LCD_DATA_DDR,  temp1
	pop  temp1
	ret

.equ  F_CPU=16000000
.equ  DELAY_1MS=F_CPU/4/1000-4
;  4  cycles  per  iteration  -  setup/call-return  overhead
sleep_1ms:
	push  r24
	push  r25
	ldi  r25,  high(DELAY_1MS)
	ldi  r24,  low(DELAY_1MS)
delayloop_1ms:
	sbiw  r25:r24,  1
	brne  delayloop_1ms
	pop  r25
	pop  r24
	ret

sleep_5ms:
	rcall  sleep_1ms
	rcall  sleep_1ms
	rcall  sleep_1ms
	rcall  sleep_1ms
	rcall  sleep_1ms
	ret
