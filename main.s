;****************** main.s ***************
; ECE473, W 2015, Example
;*****************************************

        IMPORT   PortF_Init
		IMPORT   delay
        IMPORT   blue_led_on
		IMPORT   blue_led_off
		IMPORT   red_led_on
		IMPORT   red_led_off
		IMPORT   green_led_on
		IMPORT   green_led_off
       
; we align 32 bit variables to 32-bits
; we align op codes to 16 bits
       THUMB
       AREA    DATA, ALIGN=4 
       EXPORT  M [DATA,SIZE=4]
	   EXPORT  ARRAY_RAM [DATA,SIZE=32]
		   
M      SPACE   4
ARRAY_RAM  SPACE   32
	
       AREA    |.text|, CODE, READONLY, ALIGN=2
       EXPORT  Start

ARRAY_ROM DCD  0x01,0x02,0x03,0x04		
;*******************************************
; No need to worry about anything above
;*******************************************
; PF1: Red
; PF2: Blue
; PF3: Green
; User functions:
; 	PortF_init:   to initialize port F
; 	blue_led_on:  to turn blue LED on
;	blue_led_off: to turn blue LED off
; 	delay:        delay fixed amount of time (3 * 0.25 = 0.75s)

; By manipulating the sequence of funtion calls, the user can generate different light patterns. 
; This lab is used to demonstrate the development tools and debugging features.

Start
    BL  PortF_Init                  ; initialize input and output pins of Port F

Myloop	
	MOV  R5,#0x1234
	PUSH {R5}
	POP  {R6}		
	
	MOV R4, #2


; QUESTION 2
LoopBlue	
	BL  blue_led_on
    BL  delay
	BL  blue_led_off
    BL  delay

LoopRed
	BL  red_led_on
	BL  delay
	BL  red_led_off
	BL  delay
	SUBS R4, R4, #1
	BNE LoopRed
    
	MOV R4, #3
LoopGreen
	
	BL  green_led_on
	BL  delay
	BL  green_led_off
	BL  delay
	SUBS R4, R4, #1
	BNE LoopGreen
		
; QUESTION 3

; R = X + Y
	MOV R4, #0x00000010 ; X
	MOV R5, #0xFFFFFFF4 ; Y
    ADDS R4, R5
; R = X - X
	MOV R4, #0x00000010 ; X
	SUBS R4, R4
; R = Z - X
	MOV R4, #0x00000010 ; X
	MOV R6, #0x80000000 ; Z
	SUBS R6, #3
	SUBS R6, R4
; R = Y - Z
	MOV R5, #0xFFFFFFF4 ; Y
	MOV R6, #0x80000000 ; Z
	SUBS R6, #3
	SUBS R5, R6
	
; R = Y + Z
	MOV R5, #0xFFFFFFF4 ; Y
	MOV R6, #0x80000000 ; Z
	SUBS R6, #3
	ADDS R5, R6
	
	
	B   Myloop


		END