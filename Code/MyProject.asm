
_PWM_init:

;MyProject.c,27 :: 		void PWM_init(unsigned int dc, unsigned int p)
;MyProject.c,29 :: 		duty_cycle = dc;
	MOVF       FARG_PWM_init_dc+0, 0
	MOVWF      _duty_cycle+0
	MOVF       FARG_PWM_init_dc+1, 0
	MOVWF      _duty_cycle+1
;MyProject.c,30 :: 		period = p;
	MOVF       FARG_PWM_init_p+0, 0
	MOVWF      _period+0
	MOVF       FARG_PWM_init_p+1, 0
	MOVWF      _period+1
;MyProject.c,33 :: 		T2CON = 0x07;//enable Timer2 at Fosc/4 with 1:16 prescaler (8 uS percount 2000uS to count 250 counts)
	MOVLW      7
	MOVWF      T2CON+0
;MyProject.c,34 :: 		CCP1CON = 0x0C;//enable PWM for CCP1
	MOVLW      12
	MOVWF      CCP1CON+0
;MyProject.c,35 :: 		CCP2CON = 0x0C;//enable PWM for CCP2
	MOVLW      12
	MOVWF      CCP2CON+0
;MyProject.c,36 :: 		PR2 = period;
	MOVF       FARG_PWM_init_p+0, 0
	MOVWF      PR2+0
;MyProject.c,37 :: 		TRISC = 0x00;
	CLRF       TRISC+0
;MyProject.c,38 :: 		CCPR1L = (duty_cycle * period) / 100;
	MOVF       FARG_PWM_init_dc+0, 0
	MOVWF      R0+0
	MOVF       FARG_PWM_init_dc+1, 0
	MOVWF      R0+1
	MOVF       FARG_PWM_init_p+0, 0
	MOVWF      R4+0
	MOVF       FARG_PWM_init_p+1, 0
	MOVWF      R4+1
	CALL       _Mul_16X16_U+0
	MOVLW      100
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Div_16X16_U+0
	MOVF       R0+0, 0
	MOVWF      CCPR1L+0
;MyProject.c,39 :: 		CCPR2L = (duty_cycle * period) / 100;
	MOVF       R0+0, 0
	MOVWF      CCPR2L+0
;MyProject.c,40 :: 		}
L_end_PWM_init:
	RETURN
; end of _PWM_init

_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;MyProject.c,42 :: 		void interrupt(void)
;MyProject.c,46 :: 		if (INTCON&0x01)
	BTFSS      INTCON+0, 0
	GOTO       L_interrupt0
;MyProject.c,48 :: 		PORTB=0x00;
	CLRF       PORTB+0
;MyProject.c,49 :: 		PORTD=0x00;
	CLRF       PORTD+0
;MyProject.c,50 :: 		}
L_interrupt0:
;MyProject.c,52 :: 		INTCON = INTCON & 0xFD;
	MOVLW      253
	ANDWF      INTCON+0, 1
;MyProject.c,53 :: 		}
L_end_interrupt:
L__interrupt50:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_Delay500Us:

;MyProject.c,55 :: 		void Delay500Us()
;MyProject.c,57 :: 		for(i = 0; i < (8000000 * 0.5 / 1000000); i++);
	CLRF       _i+0
	CLRF       _i+1
L_Delay500Us1:
	MOVF       _i+0, 0
	MOVWF      R0+0
	MOVF       _i+1, 0
	MOVWF      R0+1
	CALL       _word2double+0
	MOVLW      0
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVLW      0
	MOVWF      R4+2
	MOVLW      129
	MOVWF      R4+3
	CALL       _Compare_Double+0
	MOVLW      1
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R0+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_Delay500Us2
	INCF       _i+0, 1
	BTFSC      STATUS+0, 2
	INCF       _i+1, 1
	GOTO       L_Delay500Us1
L_Delay500Us2:
;MyProject.c,58 :: 		}
L_end_Delay500Us:
	RETURN
; end of _Delay500Us

_MoveXoneStep:

;MyProject.c,60 :: 		void MoveXoneStep(unsigned int dir)
;MyProject.c,64 :: 		if (dir == 1)
	MOVLW      0
	XORWF      FARG_MoveXoneStep_dir+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__MoveXoneStep53
	MOVLW      1
	XORWF      FARG_MoveXoneStep_dir+0, 0
L__MoveXoneStep53:
	BTFSS      STATUS+0, 2
	GOTO       L_MoveXoneStep4
;MyProject.c,65 :: 		PORTD = PORTD | 0x02;
	BSF        PORTD+0, 1
	GOTO       L_MoveXoneStep5
L_MoveXoneStep4:
;MyProject.c,69 :: 		PORTD = PORTD & 0xFD;
	MOVLW      253
	ANDWF      PORTD+0, 1
L_MoveXoneStep5:
;MyProject.c,73 :: 		PORTD= PORTD & 0xFE;
	MOVLW      254
	ANDWF      PORTD+0, 1
;MyProject.c,74 :: 		Delay500Us();
	CALL       _Delay500Us+0
;MyProject.c,75 :: 		PORTD= PORTD & 0xFE;
	MOVLW      254
	ANDWF      PORTD+0, 1
;MyProject.c,76 :: 		Delay500Us();
	CALL       _Delay500Us+0
;MyProject.c,77 :: 		PORTD= PORTD | 0x01;
	BSF        PORTD+0, 0
;MyProject.c,78 :: 		Delay500Us();
	CALL       _Delay500Us+0
;MyProject.c,80 :: 		}
L_end_MoveXoneStep:
	RETURN
; end of _MoveXoneStep

_MoveYoneStep:

;MyProject.c,82 :: 		void MoveYoneStep(unsigned int dir)
;MyProject.c,86 :: 		if (dir == 1)
	MOVLW      0
	XORWF      FARG_MoveYoneStep_dir+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__MoveYoneStep55
	MOVLW      1
	XORWF      FARG_MoveYoneStep_dir+0, 0
L__MoveYoneStep55:
	BTFSS      STATUS+0, 2
	GOTO       L_MoveYoneStep6
;MyProject.c,87 :: 		PORTB = PORTB | 0x02;
	BSF        PORTB+0, 1
	GOTO       L_MoveYoneStep7
L_MoveYoneStep6:
;MyProject.c,91 :: 		PORTB = PORTB & 0xFD;
	MOVLW      253
	ANDWF      PORTB+0, 1
L_MoveYoneStep7:
;MyProject.c,94 :: 		PORTB= PORTB & 0xFB;
	MOVLW      251
	ANDWF      PORTB+0, 1
;MyProject.c,95 :: 		Delay500Us();
	CALL       _Delay500Us+0
;MyProject.c,96 :: 		PORTB= PORTB & 0xFB;
	MOVLW      251
	ANDWF      PORTB+0, 1
;MyProject.c,97 :: 		Delay500Us();
	CALL       _Delay500Us+0
;MyProject.c,98 :: 		PORTB= PORTB | 0x04;
	BSF        PORTB+0, 2
;MyProject.c,99 :: 		Delay500Us();
	CALL       _Delay500Us+0
;MyProject.c,101 :: 		}
L_end_MoveYoneStep:
	RETURN
; end of _MoveYoneStep

_moveXuntilHome:

;MyProject.c,103 :: 		void moveXuntilHome()
;MyProject.c,107 :: 		while(!(PORTD | 0x08))
L_moveXuntilHome8:
	MOVLW      8
	IORWF      PORTD+0, 0
	MOVWF      R0+0
	BTFSS      STATUS+0, 2
	GOTO       L_moveXuntilHome9
;MyProject.c,109 :: 		MoveXoneStep(0);
	CLRF       FARG_MoveXoneStep_dir+0
	CLRF       FARG_MoveXoneStep_dir+1
	CALL       _MoveXoneStep+0
;MyProject.c,110 :: 		}
	GOTO       L_moveXuntilHome8
L_moveXuntilHome9:
;MyProject.c,112 :: 		}
L_end_moveXuntilHome:
	RETURN
; end of _moveXuntilHome

_moveYuntilHome:

;MyProject.c,114 :: 		void moveYuntilHome()
;MyProject.c,118 :: 		while(!(PORTD | 0x04))
L_moveYuntilHome10:
	MOVLW      4
	IORWF      PORTD+0, 0
	MOVWF      R0+0
	BTFSS      STATUS+0, 2
	GOTO       L_moveYuntilHome11
;MyProject.c,120 :: 		MoveXoneStep(0);
	CLRF       FARG_MoveXoneStep_dir+0
	CLRF       FARG_MoveXoneStep_dir+1
	CALL       _MoveXoneStep+0
;MyProject.c,121 :: 		}
	GOTO       L_moveYuntilHome10
L_moveYuntilHome11:
;MyProject.c,123 :: 		}
L_end_moveYuntilHome:
	RETURN
; end of _moveYuntilHome

_main:

;MyProject.c,127 :: 		void main()
;MyProject.c,130 :: 		TRISD = 0b00001100;//setting all pins as output except for pin2,pin3 for the limit switches.
	MOVLW      12
	MOVWF      TRISD+0
;MyProject.c,131 :: 		TRISB = 0b00000001;//setting all pins as output except for pin0 for external interrupt.
	MOVLW      1
	MOVWF      TRISB+0
;MyProject.c,132 :: 		INTCON=0x90;
	MOVLW      144
	MOVWF      INTCON+0
;MyProject.c,137 :: 		UART1_Init(9600);
	MOVLW      51
	MOVWF      SPBRG+0
	BSF        TXSTA+0, 2
	CALL       _UART1_Init+0
;MyProject.c,139 :: 		while(1)
L_main12:
;MyProject.c,141 :: 		if(UART1_Data_Ready())
	CALL       _UART1_Data_Ready+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main14
;MyProject.c,143 :: 		rcv = UART1_Read(); //Read the char. received via BT
	CALL       _UART1_Read+0
	MOVF       R0+0, 0
	MOVWF      _rcv+0
;MyProject.c,144 :: 		if (rcv == 'S')
	MOVF       R0+0, 0
	XORLW      83
	BTFSS      STATUS+0, 2
	GOTO       L_main15
;MyProject.c,146 :: 		while(count1!=0)
L_main16:
	MOVLW      0
	XORWF      _count1+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main59
	MOVLW      0
	XORWF      _count1+0, 0
L__main59:
	BTFSC      STATUS+0, 2
	GOTO       L_main17
;MyProject.c,148 :: 		MoveXoneStep(0);
	CLRF       FARG_MoveXoneStep_dir+0
	CLRF       FARG_MoveXoneStep_dir+1
	CALL       _MoveXoneStep+0
;MyProject.c,149 :: 		count1--;
	MOVLW      1
	SUBWF      _count1+0, 1
	BTFSS      STATUS+0, 0
	DECF       _count1+1, 1
;MyProject.c,151 :: 		}
	GOTO       L_main16
L_main17:
;MyProject.c,154 :: 		while(count2!=0)
L_main18:
	MOVLW      0
	XORWF      _count2+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main60
	MOVLW      0
	XORWF      _count2+0, 0
L__main60:
	BTFSC      STATUS+0, 2
	GOTO       L_main19
;MyProject.c,156 :: 		MoveYoneStep(0);
	CLRF       FARG_MoveYoneStep_dir+0
	CLRF       FARG_MoveYoneStep_dir+1
	CALL       _MoveYoneStep+0
;MyProject.c,157 :: 		count2--;
	MOVLW      1
	SUBWF      _count2+0, 1
	BTFSS      STATUS+0, 0
	DECF       _count2+1, 1
;MyProject.c,159 :: 		}
	GOTO       L_main18
L_main19:
;MyProject.c,161 :: 		while(count3!=0)
L_main20:
	MOVLW      0
	XORWF      _count3+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main61
	MOVLW      0
	XORWF      _count3+0, 0
L__main61:
	BTFSC      STATUS+0, 2
	GOTO       L_main21
;MyProject.c,163 :: 		MoveXoneStep(1);
	MOVLW      1
	MOVWF      FARG_MoveXoneStep_dir+0
	MOVLW      0
	MOVWF      FARG_MoveXoneStep_dir+1
	CALL       _MoveXoneStep+0
;MyProject.c,164 :: 		count3--;
	MOVLW      1
	SUBWF      _count3+0, 1
	BTFSS      STATUS+0, 0
	DECF       _count3+1, 1
;MyProject.c,165 :: 		}
	GOTO       L_main20
L_main21:
;MyProject.c,168 :: 		while(count4!=0)
L_main22:
	MOVLW      0
	XORWF      _count4+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main62
	MOVLW      0
	XORWF      _count4+0, 0
L__main62:
	BTFSC      STATUS+0, 2
	GOTO       L_main23
;MyProject.c,170 :: 		MoveYoneStep(1);
	MOVLW      1
	MOVWF      FARG_MoveYoneStep_dir+0
	MOVLW      0
	MOVWF      FARG_MoveYoneStep_dir+1
	CALL       _MoveYoneStep+0
;MyProject.c,171 :: 		count4--;
	MOVLW      1
	SUBWF      _count4+0, 1
	BTFSS      STATUS+0, 0
	DECF       _count4+1, 1
;MyProject.c,173 :: 		}
	GOTO       L_main22
L_main23:
;MyProject.c,175 :: 		while (move1!=0)
L_main24:
	MOVLW      0
	XORWF      _move1+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main63
	MOVLW      0
	XORWF      _move1+0, 0
L__main63:
	BTFSC      STATUS+0, 2
	GOTO       L_main25
;MyProject.c,177 :: 		MoveXoneStep(0);
	CLRF       FARG_MoveXoneStep_dir+0
	CLRF       FARG_MoveXoneStep_dir+1
	CALL       _MoveXoneStep+0
;MyProject.c,178 :: 		move1--;
	MOVLW      1
	SUBWF      _move1+0, 1
	BTFSS      STATUS+0, 0
	DECF       _move1+1, 1
;MyProject.c,179 :: 		}
	GOTO       L_main24
L_main25:
;MyProject.c,181 :: 		while (move2!=0)
L_main26:
	MOVLW      0
	XORWF      _move2+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main64
	MOVLW      0
	XORWF      _move2+0, 0
L__main64:
	BTFSC      STATUS+0, 2
	GOTO       L_main27
;MyProject.c,183 :: 		MoveYoneStep(0);
	CLRF       FARG_MoveYoneStep_dir+0
	CLRF       FARG_MoveYoneStep_dir+1
	CALL       _MoveYoneStep+0
;MyProject.c,184 :: 		move2--;
	MOVLW      1
	SUBWF      _move2+0, 1
	BTFSS      STATUS+0, 0
	DECF       _move2+1, 1
;MyProject.c,185 :: 		}
	GOTO       L_main26
L_main27:
;MyProject.c,188 :: 		while(count11!=0)
L_main28:
	MOVLW      0
	XORWF      _count11+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main65
	MOVLW      0
	XORWF      _count11+0, 0
L__main65:
	BTFSC      STATUS+0, 2
	GOTO       L_main29
;MyProject.c,190 :: 		MoveXoneStep(0);
	CLRF       FARG_MoveXoneStep_dir+0
	CLRF       FARG_MoveXoneStep_dir+1
	CALL       _MoveXoneStep+0
;MyProject.c,191 :: 		count11--;
	MOVLW      1
	SUBWF      _count11+0, 1
	BTFSS      STATUS+0, 0
	DECF       _count11+1, 1
;MyProject.c,193 :: 		}
	GOTO       L_main28
L_main29:
;MyProject.c,196 :: 		while(count22!=0)
L_main30:
	MOVLW      0
	XORWF      _count22+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main66
	MOVLW      0
	XORWF      _count22+0, 0
L__main66:
	BTFSC      STATUS+0, 2
	GOTO       L_main31
;MyProject.c,198 :: 		MoveYoneStep(0);
	CLRF       FARG_MoveYoneStep_dir+0
	CLRF       FARG_MoveYoneStep_dir+1
	CALL       _MoveYoneStep+0
;MyProject.c,199 :: 		count22--;
	MOVLW      1
	SUBWF      _count22+0, 1
	BTFSS      STATUS+0, 0
	DECF       _count22+1, 1
;MyProject.c,201 :: 		}
	GOTO       L_main30
L_main31:
;MyProject.c,203 :: 		while(count33!=0)
L_main32:
	MOVLW      0
	XORWF      _count33+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main67
	MOVLW      0
	XORWF      _count33+0, 0
L__main67:
	BTFSC      STATUS+0, 2
	GOTO       L_main33
;MyProject.c,205 :: 		MoveXoneStep(1);
	MOVLW      1
	MOVWF      FARG_MoveXoneStep_dir+0
	MOVLW      0
	MOVWF      FARG_MoveXoneStep_dir+1
	CALL       _MoveXoneStep+0
;MyProject.c,206 :: 		count33--;
	MOVLW      1
	SUBWF      _count33+0, 1
	BTFSS      STATUS+0, 0
	DECF       _count33+1, 1
;MyProject.c,207 :: 		}
	GOTO       L_main32
L_main33:
;MyProject.c,210 :: 		while(count44!=0)
L_main34:
	MOVLW      0
	XORWF      _count44+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main68
	MOVLW      0
	XORWF      _count44+0, 0
L__main68:
	BTFSC      STATUS+0, 2
	GOTO       L_main35
;MyProject.c,212 :: 		MoveYoneStep(1);
	MOVLW      1
	MOVWF      FARG_MoveYoneStep_dir+0
	MOVLW      0
	MOVWF      FARG_MoveYoneStep_dir+1
	CALL       _MoveYoneStep+0
;MyProject.c,213 :: 		count44--;
	MOVLW      1
	SUBWF      _count44+0, 1
	BTFSS      STATUS+0, 0
	DECF       _count44+1, 1
;MyProject.c,215 :: 		}
	GOTO       L_main34
L_main35:
;MyProject.c,217 :: 		while (move3!=0)
L_main36:
	MOVLW      0
	XORWF      _move3+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main69
	MOVLW      0
	XORWF      _move3+0, 0
L__main69:
	BTFSC      STATUS+0, 2
	GOTO       L_main37
;MyProject.c,219 :: 		MoveXoneStep(0);
	CLRF       FARG_MoveXoneStep_dir+0
	CLRF       FARG_MoveXoneStep_dir+1
	CALL       _MoveXoneStep+0
;MyProject.c,220 :: 		move3--;
	MOVLW      1
	SUBWF      _move3+0, 1
	BTFSS      STATUS+0, 0
	DECF       _move3+1, 1
;MyProject.c,221 :: 		}
	GOTO       L_main36
L_main37:
;MyProject.c,223 :: 		while (move4!=0)
L_main38:
	MOVLW      0
	XORWF      _move4+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main70
	MOVLW      0
	XORWF      _move4+0, 0
L__main70:
	BTFSC      STATUS+0, 2
	GOTO       L_main39
;MyProject.c,225 :: 		MoveYoneStep(0);
	CLRF       FARG_MoveYoneStep_dir+0
	CLRF       FARG_MoveYoneStep_dir+1
	CALL       _MoveYoneStep+0
;MyProject.c,226 :: 		move4--;
	MOVLW      1
	SUBWF      _move4+0, 1
	BTFSS      STATUS+0, 0
	DECF       _move4+1, 1
;MyProject.c,227 :: 		}
	GOTO       L_main38
L_main39:
;MyProject.c,229 :: 		while(count111!=0)
L_main40:
	MOVLW      0
	XORWF      _count111+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main71
	MOVLW      0
	XORWF      _count111+0, 0
L__main71:
	BTFSC      STATUS+0, 2
	GOTO       L_main41
;MyProject.c,231 :: 		MoveXoneStep(0);
	CLRF       FARG_MoveXoneStep_dir+0
	CLRF       FARG_MoveXoneStep_dir+1
	CALL       _MoveXoneStep+0
;MyProject.c,232 :: 		count111--;
	MOVLW      1
	SUBWF      _count111+0, 1
	BTFSS      STATUS+0, 0
	DECF       _count111+1, 1
;MyProject.c,234 :: 		}
	GOTO       L_main40
L_main41:
;MyProject.c,237 :: 		while(count222!=0)
L_main42:
	MOVLW      0
	XORWF      _count222+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main72
	MOVLW      0
	XORWF      _count222+0, 0
L__main72:
	BTFSC      STATUS+0, 2
	GOTO       L_main43
;MyProject.c,239 :: 		MoveYoneStep(0);
	CLRF       FARG_MoveYoneStep_dir+0
	CLRF       FARG_MoveYoneStep_dir+1
	CALL       _MoveYoneStep+0
;MyProject.c,240 :: 		count222--;
	MOVLW      1
	SUBWF      _count222+0, 1
	BTFSS      STATUS+0, 0
	DECF       _count222+1, 1
;MyProject.c,242 :: 		}
	GOTO       L_main42
L_main43:
;MyProject.c,244 :: 		while(count333!=0)
L_main44:
	MOVLW      0
	XORWF      _count333+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main73
	MOVLW      0
	XORWF      _count333+0, 0
L__main73:
	BTFSC      STATUS+0, 2
	GOTO       L_main45
;MyProject.c,246 :: 		MoveXoneStep(1);
	MOVLW      1
	MOVWF      FARG_MoveXoneStep_dir+0
	MOVLW      0
	MOVWF      FARG_MoveXoneStep_dir+1
	CALL       _MoveXoneStep+0
;MyProject.c,247 :: 		count333--;
	MOVLW      1
	SUBWF      _count333+0, 1
	BTFSS      STATUS+0, 0
	DECF       _count333+1, 1
;MyProject.c,248 :: 		}
	GOTO       L_main44
L_main45:
;MyProject.c,251 :: 		while(count444!=0)
L_main46:
	MOVLW      0
	XORWF      _count444+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main74
	MOVLW      0
	XORWF      _count444+0, 0
L__main74:
	BTFSC      STATUS+0, 2
	GOTO       L_main47
;MyProject.c,253 :: 		MoveYoneStep(1);
	MOVLW      1
	MOVWF      FARG_MoveYoneStep_dir+0
	MOVLW      0
	MOVWF      FARG_MoveYoneStep_dir+1
	CALL       _MoveYoneStep+0
;MyProject.c,254 :: 		count444--;
	MOVLW      1
	SUBWF      _count444+0, 1
	BTFSS      STATUS+0, 0
	DECF       _count444+1, 1
;MyProject.c,256 :: 		}
	GOTO       L_main46
L_main47:
;MyProject.c,258 :: 		}
L_main15:
;MyProject.c,261 :: 		}
L_main14:
;MyProject.c,262 :: 		}
	GOTO       L_main12
;MyProject.c,264 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
