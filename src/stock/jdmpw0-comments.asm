;OUTPUTS:
;pins
;injectors: P2.0-P2.3
;A1  - injector 1
;A3  - injector 2
;A5  - injector 3
;A7  - injector 4

;A6  - purge cut-off solenoid valve - P0.3
;A8  - vtec solenoid - ON -> P1.0 = 0 and P1.1 = 0
;A10 - pressure regulator cut-off solenoid valve - P0.2

;B8  - A/C clutch relay - ON p0.7 == 1 (pulled to ground)
;B15 - ignitor  TCON2.2
;B17 - ignitor  TCON2.2

;    - CEL dash light P0.6
;    - CEL LED P1.2

;INPUTS:
;B3  - A/C clutch switch - ON -> ffh.6 == 0 (pin to ground)
;B11 - Rear de-mister    - 12v on B11, ADCR1h = 00h. 0v on B11, ADCR1h = ffh
;B20 - Timing Adjust Connector
;
;C10 - Brake Switch
;ram inputs; Ecu uses all of them
;FFh.0 = Knock sensor??? Auto Trans lockup input?
;FFh.1 =
;FFh.2 = vtec solenoid feedback
;FFh.3
;FFh.4
;FFh.5
;FFh.6 = AC switch
;FFh.7 = Starter signal
;
;
;



                org 0000h
int_start_vec:            DW  int_start        ; 0000 reset pin/startup
int_break_vec:            DW  int_break        ; 0002 BRK instruction
int_WDT_vec:              DW  int_WDT          ; 0004 watch dog timer
int_NMI_vec:              DW  int_NMI          ; 0006 non maskable interrupt

int_INT0_vec:             DW  int_INT0         ; 0008      0
int_serial_rx_vec:        DW  int_serial_rx    ; 000A      1
int_serial_tx_vec:        DW  int_break        ; 000C      2
int_serial_rx_BRG_vec:    DW  int_serial_rx_BRG; 000E      3
int_timer_0_overflow_vec: DW  int_timer_0_overflow; 0010   4
int_timer_0_vec:          DW  int_timer_0      ; 0012      5
int_timer_1_overflow_vec: DW  int_timer_1_overflow; 0014   6
int_timer_1_vec:          DW  int_timer_1      ; 0016      7
int_timer_2_overflow_vec: DW  int_break        ; 0018      8
int_timer_2_vec:          DW  int_timer_2      ; 001A      9
int_timer_3_overflow_vec: DW  int_break        ; 001C      10
int_timer_3_vec:          DW  int_break        ; 001E      11
int_a2d_finished_vec:     DW  int_break        ; 0020      12
int_PWM_timer_vec:        DW  int_PWM_timer    ; 0022      13
int_serial_tx_BRG_vec:    DW  int_break        ; 0024      14
int_INT1_vec:             DW  int_INT1         ; 0026      15

vcal_0_vec:               DW  vcal_0           ; 0028 6D2D
vcal_1_vec:               DW  vcal_1           ; 002A CB2D
vcal_2_vec:               DW  vcal_2           ; 002C A72D
vcal_3_vec:               DW  vcal_3           ; 002E B92D
vcal_4_vec:               DW  vcal_4           ; 0030 0519
vcal_5_vec:               DW  vcal_5           ; 0032 0A2F
vcal_6_vec:               DW  vcal_6           ; 0034 2630
vcal_7_vec:               DW  vcal_7           ; 0036 2830
code_start:     DB  001h,045h,008h,000h,0E5h,0CEh,0D5h,01Ah ; 0038
                DB  0A2h,018h,042h,055h,067h,000h,001h,0F5h ; 0040
                DB  055h,0C5h,056h,00Bh,0CEh,00Ch,0C5h,006h ; 0048
                DB  02Fh,0C5h,007h,015h,0CAh,004h,0C5h,007h ; 0050
                DB  098h,002h,052h,0F2h,0D5h,051h,065h,052h ; 0058
                DB  0E5h,0CCh,0A2h,008h,0D5h,01Ah,002h ; 0060

;****************************************************************************

; stolen from a1k0n's explanation of the obd1 p72:

; The Honda engineers played some tricks here to allow passing of 10-bit addresses using an 8-bit protocol:
; 1.  By sending the byte in address transmit mode instead of data transmit mode,
;     a multiprocessor comm error is forced, and bit 8 of the address is set to 1
; 2.  By sending a byte with even parity instead of odd, a parity error is forced,
;     and bit 9 of the address is set to 1

                                               ; 0067 from 000A (DD0,???,???)
int_serial_rx:  L       A, 0ceh                ; 0067 1 ??? ??? E5CE
                ST      A, IE                  ; mask interrupts
                SB      PSWH.0                 ;
                L       A, DP                  ;
                PUSHS   A                      ;
                CLRB    A                      ;

                RB      SRSTAT.3               ; Clear multiprocessor communication error flag
                JEQ     label_0077             ; if it is 0 jump
                ADDB    A, #001h               ; else address 100h to 1ffh

                                               ; 0077 from 0073 (DD0,???,???)
label_0077:     RB      SRSTAT.2               ; parity error
                JEQ     label_007e             ; if 0 then jump
                ADDB    A, #002h               ; else address 200h to 2ffh or 300h to 3ffh

                                               ; 007E from 007A (DD0,???,???)
label_007e:     STB     A, ACCH                ; store page/segment #
                LB      A, SRBUF               ; get byte (address)
                MOV     DP, A                  ; move into DP
                LB      A, [DP]                ; get value at that address
                STB     A, STBUF               ; send byte

                ;do ending stuff
                POPS    A                      ;
                MOV     DP, A                  ;
                L       A, 0cch                ;
                RB      PSWH.0                 ;
                ST      A, IE                  ;
                RTI                            ;

;******************************************************************************
                                               ; 008F from 0006 (DD0,???,???)
                                               ; 008F from 171E
int_NMI:        MOV     LRB, #00020h           ; 008F 0 100 ??? 572000
                RB      0fdh.3                 ; check fdh.3 it will be 1 if the interupted
                							   ; code was setting the error bits
                JEQ     label_009a             ; if fdh.3 was = 0 jump, if 1, set the r6 code.

                CAL     label_3040             ; set the code in r6

                                               ; 009A from 0095 (DD0,100,???)
label_009a:     MOV     DP, #0027dh            ;
                RB      [DP].2                 ; same as 132.2?? if so then its a code 19 (auto tranny lockup sol)
                JEQ     label_00a4             ; if it was 0 then jump
                CAL     label_3052             ; check codes and set 27eh
                                               ; 00A4 from 009F
label_00a4:     MOV     DP, #00036h            ; 00A4 for the loop
                                               ; 00A7 from 00AC
label_00a7:     MB      C, P4.1                ; 00A7 .
                JGE     label_00d2             ; 00AA if p4.1 is 0 then jump
                JRNZ    DP, label_00a7         ; 00AC loop 36h times

                MOV     IE, #00040h            ; 00AE disable all interrupts except timer 1 overflow (40h = 01000000b)
                MOVB    TCON1, #0e0h           ; 00B3 prep for external clock input, auto-reload timer (#0e0h = 11100000b)
                CLR     IRQ                    ; 00B7 clear the interrupt request register
                SB      P4SF.1                 ; 00BA this bit is "Timer 1 external clock input"
                MOV     TM1, #0ffffh           ; 00BD set timer 1 up counter to #0ffffh
                SB      TCON1.4                ; 00C2 start timer 1
                SB      SBYCON.2               ; 00C5 set all ports to high impedance state
                LB      A, #005h               ; 00C8
                STB     A, STPACP              ; 00CA STPACP = 5 (what does this do?)
                SLLB    A                      ; 00CC
                STB     A, STPACP              ; 00CD STPACP = 0x0A (what does this do?)
                SB      SBYCON.0               ; 00CF STOP mode

                                               ; 00D2 from 00AA (DD0,100,???)
label_00d2:     MOVB    0f0h, #047h            ; 00D2 #047h is a non error number
                BRK                            ; 00D6 break
;*******************************************************************

                                               ; 00D7 from 0016 (DD0,???,???)
int_timer_1:    CAL     label_2a85             ; 00D7 0 ??? ??? 32852A
                RTI                            ; 00DA 0 ??? ??? 02

;****************************************************************************
                                               ; 00DB from 001A (DD0,???,???)
int_timer_2:    L       A, 0ceh                ; 00DB 1 ??? ??? E5CE
                ST      A, IE                  ; 00DD 1 ??? ??? D51A
                SB      PSWH.0                 ; 00DF 1 ??? ??? A218
                CLR     LRB                    ; 00E1 1 ??? ??? A415
                LB      A, 0dfh                ; 00E3 0 ??? ??? F5DF
                ADDB    A, #001h               ; 00E5 0 ??? ??? 8601
                CMPB    A, #003h               ; 00E7 0 ??? ??? C603
                JLT     label_00f5             ; 00E9 0 ??? ??? CA0A
                JBR     off(07ff42h).2, label_00f5 ; 00EB 0 ??? ??? DA4207
                MOV     off(07ff3ah), 0dch     ; 00EE 0 ??? ??? B5DC7C3A
                RB      TCON2.3                ; 00F2 0 ??? ??? C5420B
                                               ; 00F5 from 00E9 (DD0,???,???)
                                               ; 00F5 from 00EB (DD0,???,???)
label_00f5:     L       A, 0cch                ; 00F5 1 ??? ??? E5CC
                RB      PSWH.0                 ; 00F7 1 ??? ??? A208
                ST      A, IE                  ; 00F9 1 ??? ??? D51A
                RTI                            ; 00FB 1 ??? ??? 02
;****************************************************************************
; INT1

; we are essentially just checking the CKP sensor and setting or unsetting
; the cel code here (tier 1). If there is a TDC code then we dont bother,
; and if something is bad with it then we jump into the main code (assuming
; in limp mode). If all is well, we just return without running the main
; code.
                                               ; 00FC from 0026 (DD0,???,???)
int_INT1:       L       A, IE                  ;
                PUSHS   A                      ; push old interrupt mask
                L       A, #00010h             ; only enable timer 0 interrupt
                SCAL    label_0136             ; set page and LRB
                JBS     off(0130h).7, label_0116 ; if TDC code
                JBS     off(0130h).3, label_011c ; if CKP code
                RB      IRQ.7                  ; if timer 1 IRQ
                JEQ     label_0119             ; ==0 then jump to set CKP code

                ;else
                RB      off(012eh).0           ; unset CKP sensor code
                MOVB    off(01b4h), #02dh      ; set CKP counter to 2dh

                ; 0116 from above
label_0116:     J       label_03d9             ; jump to return from interrupt

                                               ; 0119 from 010D (DD1,???,???)
label_0119:     SB      off(012eh).0           ; SET CKP sensor code

                ; 011C from above if CKP code
label_011c:     L       A, ADCR5               ; load map
                ST      A, 0b0h                ; store map
                L       A, TM1                 ;
                ST      A, TMR1                ; timer1 register gets timer1 counter
                LB      A, #001h               ; e4h = 1
                STB     A, 0e4h                ;
                STB     A, off(019ah)          ; CKP RAM?
                SB      P2.4                   ; this bit seems to be for limp mode
                CAL     label_2b09             ; Check for ignition output code

                J       label_0237             ; JUMP into main code


;****************************************************************************
;set page and LRB
                                               ; 0133 from 0144 (DD1,???,???)
label_0133:     L       A, #00011h             ; 0133 1 ??? ??? 671100
                                               ; 0136 from 0102 (DD1,???,???)
label_0136:     ST      A, IE                  ; 0136 1 ??? ??? D51A
                MOV     PSW, #00102h           ;
                MOV     LRB, #00022h           ; set page to 1
                RT                             ; 0140 1 110 ??? 01

;****************************************************************************
; ////////timer 0 checks TDC code, CKP code, then runs main code
                                               ; 0141 from 0012 (DD0,???,???)
int_timer_0:    L       A, IE                  ; old mask
                PUSHS   A                      ; goes into stack
                SCAL    label_0133             ; set page and such
                MOVB    off(01b4h), #02dh      ; set CKP counter to 2dh
                SB      off(0120h).0           ; 120h.0 = 1
                JNE     label_015b             ; if 120h.0 == 1 then jump to check codes


                RB      IRQH.7                 ; INT1 IRQ = 0
                RB      off(0118h).0           ; 118h.0 = 0
                RB      TRNSIT.0               ; 0155 1 ??? ??? C54608
                J       label_02a0             ; skip code checking and the 1st call of injector routine
                                               ; 015B from 014D (DD1,???,???)
label_015b:     LB      A, 0e3h                ; load old e3h
                ADDB    A, #001h               ; A = [e3h]+1

;********************************************
;TDC and CKP checking
                JBS     off(0130h).7, label_019d ; If TDC code store A into e3h
                RB      IRQH.7                 ; INT1 IRQ = 0
                JNE     label_017a             ; if INT1 IRQ == 1 jump
                RB      off(0118h).0           ; 118h.0 = 0
                JNE     label_017a             ; if 118h.0 was 1
                STB     A, r0                  ; r0 = [e3h]+1
                ANDB    A, #003h               ; A = A%4
                JNE     label_0177             ; if A != 0, jump

				;these get set when the possible e3h value goes over 3
                SB      off(012eh).1           ; else set TDC code t1
                SB      off(011ah).0           ; & set TDC t1 code indicator

                                               ; 0177 from 016F (DD0,???,???)
label_0177:     LB      A, r0                  ; load [e3h]+1
                SJ      label_019d             ; jump to store A into e3h

                ; 017A from 0165 (DD0,???,???)
                ; 017A from 016A (DD0,???,???)
label_017a:     RB      off(011ah).0           ; reset TDC code indicator
                MOVB    off(01b5h), #02dh      ; reset TDC counter
                CMPB    A, #004h               ; compare [e3h]+1 to 4
                JEQ     label_019c             ; if == to 4 jump and set no cel code bits
                SB      off(0121h).1           ; else set 121h.1 to 1
                JLT     label_0193             ; if it was 1 jump
                CMPB    A, #008h               ; else compare to 8
                JLT     label_0199             ; if e3h < 8 jump

                                               ; 018E from 0196 (DD0,???,???)
label_018e:     SB      off(012eh).5           ; CKP code t2
                SJ      label_019c             ; clear A
                                               ; 0193 from 0188 (DD0,???,???)
label_0193:     JBR     off(019ah).0, label_0199 ; if bit then set TDC code
                JBS     off(019ah).1, label_018e ; if bit then set CKP code
                                               ; 0199 from 018C (DD0,???,???)
                                               ; 0199 from 0193 (DD0,???,???)
label_0199:     SB      off(012eh).4           ; TDC code t2
;end TDC and CKP checking (second tier)
;*******************************************
                                               ; 019C from 0183 (DD0,???,???)
                                               ; 019C from 0191 (DD0,???,???)
label_019c:     CLRB    A                      ; clear A
                                               ; 019D from 015F (DD0,???,???)
                                               ; 019D from 0178 (DD0,???,???)
label_019d:     STB     A, 0e3h                ; store A into e3h
                ANDB    A, #003h               ; limit the range from 0 to 3
                STB     A, 0e4h                ; e4h gets 0 to 3

;********************************************
;CYP sensor checking

                LB      A, off(019ah)          ;
                ADDB    A, #001h               ; [19ah]+1

                JBS     off(0131h).0, label_01da ; IF CYP sensor code jump

                RB      TRNSIT.0               ; CYP in? TDC maybe?
                JNE     label_01bd             ; if bit was 1 jump
                STB     A, r0                  ; else store [19ah]+1 into A
                ANDB    A, #00fh               ; [19ah]+1 AND 00001111b
                JNE     label_01ba             ; if ([19ah]+1 AND fh) != 0 then jump

				; these get set when possible [19ah] val goes over fh.
                SB      off(012eh).2           ; else set CYP code
                SB      off(011ah).1           ; and set 11a.1
                                               ; 01BA from 01B2 (DD0,???,???)
label_01ba:     LB      A, r0                  ;
                SJ      label_01da             ; jump to set 19ah

                ; 01BD from 01AD when TRNSIT.0 == 1
                ; if TRNSIT.0 is the CYP input then the ECU is
                ; polling the sensor. Also, if it is the correct
                ; input, then the following code deals with when
                ; the cyp is fired.

                ; this will reset the 19ah byte to 0.
label_01bd:     RB      off(011ah).1           ; this seems to be good
                MOVB    off(01b6h), #007h      ; reset CYP counter

                CMPB    A, #010h               ; compare 19ah to 16
                JEQ     label_01cf             ; if 16 then jump
                JGE     label_01d9             ; else if 19ah>16 jump to clear 19ah
                JBR     off(0121h).1, label_01d6 ; else if 121h.1 == 0 then cYP code
                SJ      label_01d9             ; else jump to clear 19ah

                ; 01CF from 01C6 (DD0,???,???)
label_01cf:     RB      off(0121h).1         ; 01CF 0 ??? ??? C42109
                LB      A, 0e4h                ; 01D2 0 ??? ??? F5E4
                JEQ     label_01da             ; if crank position == 0 jump to set 19ah to 0
                                               ; 01D6 from 01CA (DD0,???,???)
label_01d6:     SB      off(012eh).6           ; other CYP code

;********************************************

                                               ; 01D9 from 01C8 (DD0,???,???)
                                               ; 01D9 from 01CD (DD0,???,???)
label_01d9:     CLRB    A                      ; 01D9 0 ??? ??? FA
                                               ; 01DA from 01A7 (DD0,???,???)
                                               ; 01DA from 01BB (DD0,???,???)
                                               ; 01DA from 01D4 (DD0,???,???)
label_01da:     STB     A, off(019ah)          ; 01DA 0 ??? ??? D49A


                ANDB    A, #00fh               ; if 19ah % fh == 0 jump
                JNE     label_01f5             ;

				; e7h is some counter
                LB      A, 0e7h                ; else
                JEQ     label_01e9             ; if [e7h] == 0 jump
                DECB    0e7h                   ; else [e7h]--
                SJ      label_01f2             ;

                ; 01E9 from 01E2 when [e7h] == 0
label_01e9:     MOV     DP, #0021ah            ;
                MB      C, [DP].0              ; c = 21ah.0
                LB      A, #001h               ; AL = 1;
                JGE     label_01f3             ; if 21ah.0 == 0 jump

                ; 01F2 from 01E7 when [e7h] != 0
label_01f2:     CLRB    A                      ; 01F2 0 ??? ??? FA

                ; 01F3 from 01F0 A = 1
                ; if no jump then A = 0
label_01f3:     STB     A, 0e5h                ; 01F3 0 ??? ??? D5E5


                                               ; 01F5 from 01DE (DD0,???,???)
label_01f5:     JBS     off(0130h).7, label_01fb ; if TDC code jump
                JBR     off(011ah).0, label_0208 ; if TDC code t1 NOT set jump

                ;///error values:
                                                 ; 01FB from 01F5 (DD0,???,???)
label_01fb:     ANDB    0e3h, #0fch              ; fch = 1111 1101
                LB      A, off(019ah)            ; load CYP ram

                ANDB    A, #003h                 ; and with 3
                ORB     0e3h, A                  ; 0203 0 ??? ??? C5E3E1
                STB     A, 0e4h   				 ;
                ;///

                ; 0208 from 01F8 GOOD!
label_0208:     JBS     off(0131h).0, label_020e ; if CYP code
                JBR     off(011ah).1, label_0217 ; if CYP code t1 NOT set jump

                ;///error values:
                                                 ; 020E from 0208 (DD0,???,???)
label_020e:     ANDB    off(019ah), #0fch        ; 020E 0 ??? ??? C49AD0FC

                LB      A, 0e4h                  ; 0212 0 ??? ??? F5E4
                ORB     off(019ah), A            ; 0214 0 ??? ??? C49AE1
                ;///

                ; 0217 from 020B GOOD!
label_0217:     RC                               ; 0217 0 ??? ??? 95
                JBS     off(0130h).7, label_021e ; IF TDC code
                JBR     off(011ah).0, label_0224 ; if TDC code t1 NOT set jump

                ;BAD! if here
                                                 ; 021E from 0218 (DD0,???,???)
label_021e:     JBS     off(0131h).0, label_0227 ; IF CYP code
                JBS     off(011ah).1, label_0227 ; if CYP code t1 set, jump


                ; 0224 from 021B GOOD!!
label_0224:     JBR     off(0131h).6, label_0228 ; if NO IGNITION OUTPUT code


                                               ; 0227 from 021E (DD0,???,???)
                                               ; 0227 from 0221 (DD0,???,???)
label_0227:     SC                             ; 0227 0 ??? ??? 85
                                               ; 0228 from 0224 (DD0,???,???)
label_0228:     MB      off(0121h).3, C        ; 121h.3 = 0 if all is good

;******

                JGE     label_0230             ; if C = 0 jump (all is good)
                SB      0feh.6                 ; Baaaaaad
                                               ; 0230 from 022B (DD0,???,???)
label_0230:     JBS     off(0120h).6, label_0237 ;

				;else get rid of the 2nd tier ckp, tdc, and cyp codes
                ANDB    off(012eh), #08fh      ; 8fh = 10001111

;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
;//////////////////////////////////////////////
;this is really the beginning of the main code.
;//////////////////////////////////////////////
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

; the structure seems to go like this:

; do calculations and then turn on proper injector if necessary
; get rev count values from timers
; do calculations then turn on ignitor if necessary
; calculate RPM values (bah, a6h, a7h)
; calculate map image
; calc TPS stuff
; calculate map image corrected for delta MAP

; find new ignition value
; pick fuel cell
; vtec routine
; a few corrections (1a0h and 1a1h)
; revlimit calcs.
; calculate a bunch of bits
; calc fuel corrections
; calc final fuel value
;



; this looks to be part of the injector turn-on portion...

                                               ; 0237 from INT1
                                               ; 0237 from 0230 (DD0,???,???)
label_0237:     JBS     off(011fh).4, label_02a0 ; if starting or error in rev count, jump
                JBS     off(0121h).2, label_025c ; 023A 0 ??? ??? EA211F
                MOV     DP, #00199h            ; 023D 0 ??? ??? 629901
                LB      A, 0e5h                ; 0240 0 ??? ??? F5E5
                SRLB    A                      ; 0242 0 ??? ??? 63
                LB      A, off(019ah)          ; 0243 0 ??? ??? F49A
                JLT     label_0249             ; if 21ah.0 == 0 ([e5h] == 1) jump
                ADDB    A, #004h               ; else A = 19ah + 4
                                               ; 0249 from 0245 (DD0,???,???)
label_0249:     ANDB    A, #007h               ; A = A%8
                CMPB    A, [DP]                ;
                JNE     label_02a0             ; if A != [199h] jump

                LB      A, off(0198h)          ; 024F 0 ??? ??? F498
                CMPB    A, [DP]                ; 0251 0 ??? ??? C2C2
                JEQ     label_025c             ; 0253 0 ??? ??? C907
                DECB    [DP]                   ; 0255 0 ??? ??? C217
                JLT     label_025c             ; 0257 0 ??? ??? CA03
                ADDB    [DP], #002h            ; 0259 0 ??? ??? C28002
                                               ; 025C from 023A (DD0,???,???)
                                               ; 025C from 0253 (DD0,???,???)
                                               ; 025C from 0257 (DD0,???,???)
label_025c:     CLR     A                      ; A = 0
                LB      A, 0e5h                ; next cylinder
                SLLB    A                      ; A = [e5h] * 2
                MOV     DP, A                  ; store in DP
                ANDB    A, #002h               ; get bit 1.
                ;Primary o2: X1 = 0
                ;if the primary o2 is on cyl 1 and 4, then that means:
                ;e5h==0 -> cyl 1 or 4
                ;e5h==2 -> cyl 4 or 1

                ;Secondary o2: X1 = 2
                ;if the secondary o2 is on cyl 2 and 3, then that means:
                ;e5h==1 -> cyl 3 or 2
                ;e5h==3 -> cyl 2 or 3
                ;e5h must follow the firing order...

                MOV     X1, A                  ; X1 can be 0 or 2
                MOV     er0, 00162h[X1]        ; move in 162h or 164h
                L       A, 001bch[X1]          ; load 1bch or 1beh
                JNE     label_0271             ; if != 0 jump
                L       A, #08000h             ; if == 0 then no correction
                ST      A, er0                 ;
                
                                               ; 0271 from 026B (DD1,???,???)
label_0271:     SRL     X1                     ; X1 can be 0 or 1
                LB      A, 0011bh[X1]          ; load 11bh or 11ch
                SRLB    A                      ; shift right
                
                ;if [11bh or 11ch].0 = 0 then jump
                ;these were set to 0 in an error part of the code
                JGE     label_0280             ; if no carry from shifting jump

                ;WTF? individual cylinder o2 fuel adjust? Odd...
                CLR     A                      ; else A = 0
                LC      A, 03789h[DP]          ; and we load this which will be 0.
                ADD     er0, A                 ; then add it to the o2 sensors
                
                                               ; 0280 from 0277 (DD0,???,???)
label_0280:     L       A, off(0144h)          ; load final fuel value from map
                MUL                            ; er1A = A*er0 = [144h]*[162h or 164h]
                SLL     A                      ; shift left to get the most sig bit
                L       A, er1                 ; A = [144h]*[162h or 164h]/10000h
                ROL     A                      ; [144h]*[162h or 164h]/10000h *2 + carry from MSBit of low word
                JLT     label_028d             ; if theres a carry, then shit shit!
                ADD     A, off(0146h)          ; else  A = [144h]*[162h or 164h]/10000h *2 + [146h]
                                               ; basically: A = table_value * o2_correction/10000h * 2 + fuel_trims
                JGE     label_0290             ; if good, store it in d6h

                ; 028D from 0287 bad: overflow
label_028d:     L       A, #0ffffh             ; whatever
                ; 0290 from 028B if good
label_0290:     ST      A, 0d6h                ; next injector final fuel value


				;is this the actual injector routine? I think so.
                CAL     label_2b25             ; holy long function call


;*************************
; find rev count
; every 45 degrees TMR1 is set with TM1's value

                MOV     LRB, #00022h           ; 0295 1 110 ??? 572200
                LB      A, 0e5h                ; e5h should be 0 or 1 at this point
                ADDB    A, #001h               ; A++
                ANDB    A, #003h               ; A AND 0000 0110
                STB     A, 0e5h                ; should be 2 or 0 ??

                                               ; 02A0 from 0158 (DD1,???,???)
                                               ; 02A0 from 0237 (DD0,???,???)
                                               ; 02A0 from 024D (DD0,???,???)
label_02a0:     L       A, TMR1                ; load timer1 register
                ST      A, er0                 ; er0 = timer1
                SUB     A, 0e0h                ; A = timer1 - old timer

                ;if there ecu does not see CKP code for more than 6 iterations
                JBR     off(0121h).2, label_02be ; seems to be the norm. store into rev count val

                JBS     off(011eh).7, label_02b1 ; TIMER1 overflow old
                JBR     off(011eh).6, label_02b2 ;    "      "     new
                JLT     label_02b2             ; if cur timer1 < old timer 1 jump (timer overflow)
                                               ; 02B1 from 02A9 (DD1,???,???)
label_02b1:     CLR     A                      ; 02B1 1 ??? ??? F9
                                               ; 02B2 from 02AC (DD1,???,???)
                                               ; 02B2 from 02AF (DD1,???,???)
label_02b2:     MOV     USP, #0020dh           ; 02B2 1 ??? 20D A1980D02
                PUSHU   A                      ; 02B6 1 ??? 20B 76
                PUSHU   A                      ; 02B7 1 ??? 209 76
                PUSHU   A                      ; 02B8 1 ??? 207 76
                PUSHU   A                      ; 02B9 1 ??? 205 76
                ST      A, 0b8h                ; 02BA 1 ??? 205 D5B8
                SJ      label_02d0             ; 02BC 1 ??? 205 CB12
                                               ; 02BE from 02A6 (DD1,???,???)
label_02be:     MB      C, TCON1.2             ; timer1 control.2 -> C
                JGE     label_02c4             ; if 0 skip next line
                CLR     A                      ; else A = 0

                ;good! store the revcount
                                               ; 02C4 from 02C1 (DD1,???,???)
label_02c4:     ST      A, 0b8h                ; [b8h] = 0 or (timer1 - old timer1)
                LB      A, 0e4h                ; [e4h] must be a val from 0 to 3.
                SLLB    A                      ; A = [e4h] * 2
                EXTND                          ; sign extend
                MOV     X1, A                  ; X1 = A
                L       A, 0b8h                ; load the timer1-[e0h]
                ST      A, 00206h[X1]          ; put it one of the rev counter vars

;*********************************************************************************
;*********************************************************************************
;*********************************************************************************
;** now this should be the ignitor turn on area...
;*********************************************************************************
;*********************************************************************************
;*********************************************************************************

;134h is the final ignition value.
; Its complimented and put in 136h. Then some crap happens, and something is placed
; in TMR2. timer2 is in real time output mode. I cant remember exactly how it works,
; but something to do with TM2 reaching TMR2's value (they are different registers),
; TCON2.3 is moved into TCON2.2 thus turning the ignitor on or off.

                                               ; 02D0 from 02BC (DD1,???,205)
label_02d0:     L       A, er0                 ; load timer1 value that was stored before
                ST      A, 0e0h                ; put it in e0h
                SLL     A                      ; A*=2
                JLT     label_02dc             ; if carry jump
                MB      C, IRQ.6               ; 02D6 1 ??? ??? C5182E
                MB      0fdh.4, C              ; timer 1 overflow -> fdh.4

                                               ; 02DC from 02D4 (DD1,???,???)
label_02dc:     ANDB    off(011eh), #03fh      ; 3fh = 01101111
                LB      A, 0e4h                ; load crank position
                JEQ     label_02f7             ; if 0 then jump
                CMPB    A, #003h               ; else compare with 3
                JEQ     label_034d             ; if 3 jump

                ;here [e4h] == 1 or 2
                JBS     off(0118h).1, label_0340 ; 02E8 0 ??? ??? E91855
                MOV     USP, #00206h           ; 02EB 0 ??? 206 A1980602
                CLR     er2                    ; 02EF 0 ??? 206 4615
                CMPB    A, #001h               ; if e4h == 1
                JEQ     label_032a             ; then jump
                SJ      label_0347             ; else (if e4h = 2 jump

;*******************

                ; 02F7 from 02E2 e4 == 0
label_02f7:     LB      A, #012h               ; 401 RPM
                JBR     off(0118h).1, label_02fe ; 02F9 0 ??? ??? D91802
                LB      A, #00bh               ; 657 rpm
                                               ; 02FE from 02F9 (DD0,???,???)
label_02fe:     CMPB    A, 0bbh                ; compare rpm with 1200h or b00h
                MB      off(0118h).1, C        ; if A<bbh, 118h.1 == 1
                JGE     label_0317             ; if at low rpm, jump

                CMPB    0e8h, #00fh            ; some cel code/error BS
                JNE     label_030f             ;
                SB      off(0119h).2           ; 030C 0 ??? ??? C4191A
                                               ; 030F from 030A (DD0,???,???)
label_030f:     RC                             ; 030F 0 ??? ??? 95
                JBS     off(0119h).2, label_0317 ; 0310 0 ??? ??? EA1904

                LB      A, #028h               ; 0313 0 ??? ??? 7728
                CMPB    A, off(01b5h)          ; compare 28h TDC counter if less than

                                               ; 0317 from 0304 (DD0,???,???)
                                               ; 0317 from 0310 (DD0,???,???)
label_0317:     MB      P2.4, C                ; limp mode?
                CAL     label_2b09             ; 031A 0 ??? ??? 32092B
                MOV     DP, #08000h            ; 031D 0 ??? ??? 620080
                LB      A, P1                  ; 0320 0 ??? ??? F522
                CAL     label_30f4             ; 0322 0 ??? ??? 32F430


                MOV     LRB, #00022h           ; 0325 0 110 ??? 572200
                SJ      label_0372             ; 0328 0 110 ??? CB48

;*****************

                ; 032A from 02F3 if e4h == 1;
label_032a:     MOV     er0, (0020ch-00206h)[USP] ; er0 = [20ch]
                JBR     off(0119h).1, label_0335 ; if 134h != 0 jump
                MOV     er2, er0               ; else er2 = er0
                                               ; 0332 from 0347 (DD0,???,206)
label_0332:     MOV     er0, (00206h-00206h)[USP] ; er0 = [206h]


                ; 0335 from 032D with er2 == 0 and er0 = [20ch] : timer ticks to go 45deg
                ; from no jump with er2 = [20ch] and er0 = [206h]: timer ticks to go 90deg.

                ; c0eh * feh = bf5e4h

                ;case: 775 rpm and [134h] = 3bh = 00111100
                ; so [136h] = 11000100 = b4h and [20ch] = ~955h

                ; b4h*955h = 68fc4h, er1 = dah = 6
label_0335:     LB      A, off(0136h)          ; [134h] 2's compliment
                STB     A, ACCH                ;
                CLRB    A                      ; clear low byte

                MUL                            ; A = A*er0, er1 gets overflow
                L       A, er2                 ;
                ADD     A, er1                 ; high word + er2
                JGE     label_0343             ; if no over flow, jump

                                               ; 0340 from 02E8 (DD0,???,???)
label_0340:     L       A, #0ffffh             ; else overflow!! load generic val
                                               ; 0343 from 033E (DD1,???,206)
                                               ; 0343 from 034B (DD1,???,206)
label_0343:     ST      A, 0dah                ; 0343 1 ??? ??? D5DA
                SJ      label_0372             ; 0345 1 ??? ??? CB2B

;*****************
                ; 0347 from 02F5 e4h = 2
label_0347:     JBS     off(0119h).1, label_0332 ; 0347 0 ??? 206 E919E8
                CLR     A                      ; 034A 1 ??? 206 F9
                SJ      label_0343             ; 034B 1 ??? 206 CBF6

;*****************
;calc deh
                ; 034D from 02E6 with e4 == 3
label_034d:     CLR     A                      ;
                CLRB    A                      ;
                STB     A, r1                  ; r1 = 0
                SUBB    A, off(0135h)          ; A = -[135h] ; @ 4k rpm with 12V [135h] =~ 25h
                L       A, ACC                 ; change DD
                SLL     A                      ; A *= 2
                MOVB    r0, off(0134h)         ; r0 = [134h]
                SUB     A, er0                 ; A = -([135h]*2) - [134h]
                SLL     A                      ; A*=2
                CMPB    ACCH, #0feh            ; compare to feh
                JNE     label_0363             ; if != jump
                L       A, #0ff00h             ; else load ff00

                                               ; 0363 from 035E (DD1,???,???)
label_0363:     ST      A, 0deh                ; actual timing value.
											   ;? if [deh]&0xff = 0; dist all the way advnced (45deg.)
											   ;? if [deh]&0xff = ffh; dist all the way retarded (0deg.)

;*********
;compliment 134h
                LB      A, off(0134h)          ;
                XORB    A, #0ffh               ;
                SLLB    A                      ;
                INCB    ACC                    ;
                STB     A, off(0136h)          ; [136h] = 2s compliment ([134h])
                MB      off(0119h).1, C        ; this is set if [134h] is 0

;*****************

                                               ; 0372 from 0328 (DD0,110,???)
                                               ; 0372 from 0345 (DD1,???,???)
label_0372:     MOV     er2, #0001eh           ;
                LB      A, 0dfh                ; 0376 0 ??? ??? F5DF
                CMPB    A, #0ffh               ; 0378 0 ??? ??? C6FF
                JEQ     label_037e             ; if [dfh] == ffh jump
                SUBB    A, #001h               ; else [dfh]--
                                               ; 037E from 037A (DD0,???,???)
label_037e:     ANDB    A, #003h               ; AND with 0000 0011
                CLRB    r7                     ;
                CMPB    0e4h, #001h            ;
                JNE     label_038c             ; if e4h != 1 jump
                CMPB    A, #002h               ; else compare A with 2
                JEQ     label_0392             ; if A == 2 jump

                ; 038C from 0386 (DD0,???,???)
label_038c:     CMPB    A, 0e4h                ; 038C 0 ??? ??? C5E4C2
                JNE     label_03d0             ; 038F 0 ??? ??? CE3F
                INCB    r7                     ; 0391 0 ??? ??? AF


				;it looks like deh is the actual timing value used.
				;First they find the timer ticks from the last ckp interrupt (in TMR1)
				;to the point where the ignitor should be turned on. This ticks value is
				;   er1 = [deh]*revcount(b8h)/100h
				;Then (provided the TM2 value corresponds to TM1's) they check to see if it
				;is time to turn on the ignitor by comparing (TM2-TMR1) to the ticks value.
				;If its time they turn it on (SB      TCON2.2).
				;If it is NOT time, they use the real-time output mode on Timer2 by putting
				;TMR1+er1 into TMR2. When TM2 reaches TMR2's value, the ignitor is turned on.
				;
                                               ; 0392 from 038A (DD0,???,???)
label_0392:     LB      A, 0deh                ; load deh
                STB     A, ACCH                ;
                CLRB    A                      ; A = [deh]*100h
                MOV     er0, 0b8h              ; move timer1 - old timer1 (essentially a rev count)
                MUL                            ; er1a = (rev count) * [deh]*100h
                CMPB    0dfh, #0ffh            ;
                JNE     label_03c1             ; if its not ffh, jump
                L       A, TM2                 ; load tm2
                SUB     A, TMR1                ; tm2 - tmr1: the number of timer ticks to where we are now
                ADD     A, #00010h             ; add 16
                CMP     A, er1                 ; compare to the number of ticks needed to pass before we turn on
                JLT     label_03b7             ; if its not time yet, jump
                SB      TCON2.2                ; turn the biatch on
                L       A, TM2                 ; A = TM2
                SUB     A, #00001h             ; why is this sub?
                SJ      label_03ba             ; jump to set the
                                               ; 03B7 from 03AB (DD1,???,???)
label_03b7:     L       A, TMR1                ; this is the base
                ADD     A, er1                 ; add the number of base ticks to
                							   ; the base-to-turn-on tick count
                							   ; Now A has the value that TM2 will be when the
                							   ; ignitor is next turned on.

                                               ; 03BA from 03B5 (DD1,???,???)
label_03ba:     SB      TCON2.3                ; Timer2 is in real-time output mode.
											   ; when TM2 == TMR2 TCON2.3 is moved into TCON2.2
                ST      A, TMR2                ; set the time
                SJ      label_03d0             ; 03BF 1 ??? ??? CB0F

                ;***
                                               ; 03C1 from 03A0 (DD0,???,???)
label_03c1:     CLR     A                      ; 03C1 1 ??? ??? F9
                JBS     off(0117h).0, label_03c7 ; 03C2 1 ??? ??? E81702
                L       A, 0b8h                ; 03C5 1 ??? ??? E5B8
                                               ; 03C7 from 03C2 (DD1,???,???)
label_03c7:     ADD     A, er1                 ; 03C7 1 ??? ??? 09
                JGE     label_03cd             ; 03C8 1 ??? ??? CD03
                L       A, #0ffffh             ; 03CA 1 ??? ??? 67FFFF
                                               ; 03CD from 03C8 (DD1,???,???)
label_03cd:     CMP     A, er2                 ; 03CD 1 ??? ??? 4A
                JGE     label_03d1             ; 03CE 1 ??? ??? CD01

                ;***
                                               ; 03D0 from 038F (DD0,???,???)
                                               ; 03D0 from 03BF (DD1,???,???)
label_03d0:     L       A, er2                 ; 03D0 1 ??? ??? 36
                                               ; 03D1 from 03CE (DD1,???,???)
label_03d1:     ST      A, 0d8h                ; 03D1 1 ??? ??? D5D8
                LB      A, 0e4h                ; 03D3 0 ??? ??? F5E4
                CMPB    A, #001h               ; 03D5 0 ??? ??? C601
                JEQ     label_03df             ; 03D7 0 ??? ??? C906


                                               ; 03D9 from INT1 if TDC cel code
                                               ; 03D9 from 03DF (DD0,???,???)
                                               ; 03D9 from 0409 (DD0,???,???)
label_03d9:     RB      PSWH.0                 ; 03D9 1 ??? ??? A208


                ; 03DB from 1581 return from timer 0 interrupt

                ;return from INT1 or timer0 interrupt
label_03db:     POPS    A                      ; 03DB 1 ??? ??? 65
                ST      A, IE                  ; 03DC 1 ??? ??? D51A
                RTI                            ; 03DE 1 ??? ??? 02
;****************************************************************************
;continue with main code...
                                               ; 03DF from 03D7 (DD0,???,???)
label_03df:     JBS     off(0119h).0, label_03d9 ; 03DF 0 ??? ??? E819F7
                L       A, #000e0h             ; 03E2 1 ??? ??? 67E000
                JBR     off(011eh).3, label_03eb ; 03E5 1 ??? ??? DB1E03
                L       A, #000f0h             ; 03E8 1 ??? ??? 67F000
                                               ; 03EB from 03E5 (DD1,???,???)
label_03eb:     CMP     0bah, A                ; 03EB 1 ??? ??? B5BAC1
                MOVB    r0, #003h              ; 03EE 1 ??? ??? 9803
                MB      off(011eh).3, C        ; 03F0 1 ??? ??? C41E3B
                JLT     label_0406             ; 03F3 1 ??? ??? CA11
                LB      A, #0d8h               ; 03F5 0 ??? ??? 77D8
                JBR     off(011eh).2, label_03fc ; 03F7 0 ??? ??? DA1E02
                LB      A, #0d0h               ; 03FA 0 ??? ??? 77D0
                                               ; 03FC from 03F7 (DD0,???,???)
label_03fc:     CMPB    A, 0a6h                ;A-rpm, A might have f0h, d8h, or d0h   ; 03FC 0 ??? ??? C5A6C2
                MOVB    r0, #001h              ; 03FF 0 ??? ??? 9801
                MB      off(011eh).2, C        ;if A<rpm then set bit   ; 0401 0 ??? ??? C41E3A
                JGE     label_040b             ;else jump   ; 0404 0 ??? ??? CD05
                                               ; 0406 from 03F3 (DD1,???,???)
label_0406:     LB      A, 0e5h                ; 0406 0 ??? ??? F5E5
                ANDB    A, r0                  ; 0408 0 ??? ??? 58
                JNE     label_03d9             ; 0409 0 ??? ??? CECE
                                               ; 040B from 0404 (DD0,???,???)
label_040b:     L       A, 0cch                ; 040B 1 ??? ??? E5CC
                MOV     PSW, #01001h           ; 040D 1 ??? ??? B504980110
                SB      off(0119h).0           ; 0412 1 ??? ??? C41918
                ST      A, IE                  ; 0415 1 ??? ??? D51A
                SB      PSWH.0                 ; 0417 1 ??? ??? A218


;***********************************************
;RPM routines
                MOV     LRB, #00021h           ; 0419 1 108 ??? 572100
                MOV     DP, #00206h            ; 041C 1 108 ??? 620602
                CLR     A                      ; 041F 1 108 ??? F9
                ST      A, er0                 ; 0420 1 108 ??? 88
                ST      A, er1                 ; 0421 1 108 ??? 89

                ;er0 = er1 = 0
                ;4 passes
                ;this loop does this: er0 = [206h] + [208h] + [20ah] + [20ch]
                ;where all are words.
                ;r2 = overflow from all addition operations
                                               ; 0422 from 0430 (DD1,108,???)
label_0422:     L       A, [DP]                ; load [206h] (pass 1)
                JEQ     label_043f             ; if its 0 jump to 43fh
                ADD     er0, A                 ; else we add it to er0
                ADCB    r2, #000h              ; add the carry to r2 (high byte of er1)
                INC     DP                     ;
                INC     DP                     ;
                CMP     DP, #0020eh            ; if dp
                JNE     label_0422             ; != 20eh then loop


                RORB    r2                     ; roll right
                ROR     er0                    ; roll right er0
                RORB    r2                     ; roll right r2
                ROR     er0                    ; roll right er0
                CAL     label_32f4             ; 043A 1 108 ??? 32F432

;label_32f4:     RB      off(0011eh).5          ; 32F4 1 108 ??? C41E0D
;                RB      off(0011fh).0          ; 32F7 1 108 ??? C41F08
;                RT                             ; 32FA 1 108 ??? 01

				;now er0 has AVERAGE of all the rev count vals

                SJ      label_0446             ; 043D 1 108 ??? CB07

                ;this seems to be error.
                                               ; 043F from 0423 (DD1,108,???)
label_043f:     MOV     er0, #0ffffh           ; 043F 1 108 ??? 4498FFFF
                SB      off(0011fh).0          ; Key on, engine off


                ;next 6 lines explanation:
                ;cascade the words down one.
                ;[20eh] -> [210h] -> [212h] -> er3
                ;then current rev count -> [20eh]
                ;it looks like these are the rev count for the last 4 iterations of the code

                ; 1st     2nd     3rd    4th
                ;[20eh]  [210h]  [212h]  er3

                                               ; 0446 from 043D (DD1,108,???)
label_0446:     MOV     USP, #0020eh           ;
                MOV     er3, (00212h-0020eh)[USP] ; load [212h] into er3
                L       A, (00210h-0020eh)[USP] ; load [210h] into A
                ST      A, (00212h-0020eh)[USP] ; store [210h] into [212h]
                L       A, (0020eh-0020eh)[USP] ; load [20eh] into A
                ST      A, (00210h-0020eh)[USP] ; store [20eh] into [210h]


                L       A, 0bah					;load rev counter
                ST      A, (0020eh-0020eh)[USP] ; store it in 20eh
                L       A, er0					; load the newly calculated rev count
                ST      A, 0bah					; put it in bah which is the most current rev count
                SUB     A, er3					; A = [bah] - least current rev count

                ;if [bah] < er3 then set 11eh.4. this is if RPM is increasing
                MB      off(0011eh).4, C        ; rpm is increasing
                JGE     label_0465              ; if rpm is decreasing jump

                ;else rpm is increasing
                ST      A, er0                  ; compliment difference b/t oldest and newest rpm
                CLR     A                       ;
                SUB     A, er0                  ; A = 0 - difference

                                               ; 0465 from 0460 (DD1,108,20E)
label_0465:     ST      A, 0bch                ; [bch] = |dif b/t oldest and newest rpm|

                MOV     er2, 0bah              ; er2 = current rev count
                LB      A, r5                  ; load rev counter high byte into A
                JNE     label_0476             ; if not == 0 then jump (if rpm < 7262)

                ;were over 7262 rpm here
                LB      A, r4                  ; load low byte
                CMPB    A, #0bbh               ; A - #bbh. if over ~9900rpm then c = 1
                LB      A, #0ffh               ; load ff into A
                JLT     label_04b1             ; if c == 1 jump to set a6h to ffh and vtec.1 to 1
                SJ      label_04af             ; if 7262< rpm <9900 set a6h to feh and vtec.1 to 1

                ;<7262rpm, so high byte > 0
                                               ; 0476 from 046B (DD0,108,20E)
label_0476:     CMPB    A, #010h               ;

				;if rpm <= 452 jump
                JGE     label_04a5             ; if rev count high byte >= #10h jump. a6h = 0 or 1 and vtec.1 = 1

                ;A < #09h and 452<rpm<7262
                SWAPB                          ; else swap nibbles (* by 16)
                MOV     er3, #0ffc0h           ; er3 = #ffc0h
                MOV     er0, #00008h           ; er0 = #8h
                MOV     DP, #00004h            ; dp = 4

                ;loop 4 times max
                ;if A = F0h to 80h. 452 to 904;		er0 = 8, er3 = ffc0h
                ;if A = 70h to 40h. 904 to 1808;	er0 = 4, er3 = 0000h
                ;if A = 30h to 20h. 1808 to 3617;	er0 = 2, er3 = 0040h
                ;if A = 10h.		3624 to 7234;	er0 = 1, er3 = 0080h
                ;if A = 00h.		7262;			er0 = 0, er3 = 00c0h

                                               ; 0486 from 048F (DD0,108,20E)
label_0486:     SLLB    A                      ; shift left the nibble-swapped byte.
                JLT     label_0491             ; if c = 1 jump
                SRL     er0                    ; shift er0 right
                ADD     er3, #00040h           ; add 40 to er3
                JRNZ    DP, label_0486         ; loop 4 times max


                                               ; 0491 from 0487 (DD0,108,20E)
label_0491:     CLR     A                      ; A = 0

				;62 = 1385,94 = 2374rpm
				;case 1: 452 to 904 rpm -> rev count = fffh to 800h
				;er0 = 8, er3 = ffc0h
				;[a6h] = ffc0h + 80000h/(rev count*2)  (only can be a word so ffc0h + 40h = 0)
				;[a6h] = 0h to 40h

				;case 2: 904 to 1808 rpm -> rev count = 7ffh to 400h
				;er0 = 4, er3 = 0h
				;[a6h] = 0h + 40000h/(rev count*2)
				;[a6h] = 40h to 80h

				;case 3: 1809 to 3617 rpm -> rev count = 3ffh to 200h
				;er0 = 2, er3 = 40h
				;[a6h] = 40h + 20000h/(rev count*2)
				;[a6h] = 80h to c0h

				;case 4: 3624 to 7234 rpm -> rev count = 1ffh to 100h
				;er0 = 1, er3 = 80h
				;[a6h] = 80h + 10000h/(rev count*2)
				;[a6h] = c0h to ffh

				;<er0A> = <er0A> / er2
                DIV                            ; er0A = er0A/er2: A = 8(or 4,2,1,0)0000h/rev count
                SRL     A					   ; A/=2 , If division returns odd then C==1
                MB      PSWL.4, C              ; odd division
                ADD     er3, A                 ; er3 from above += div result
                LB      A, r7                  ; load er3 high byte to A
                JNE     label_04af             ; if A > 0 jump set a6 to feh
                LB      A, r6                  ; else load er3 low byte
                JEQ     label_04a9             ; if its 0 jump
                CMPB    A, #0ffh               ;
                JGE     label_04af             ; if er3 low byte == #ffh jump and set to #feh
                SJ      label_04b3             ; store the val


                ; 04A5 from 0478 when rpm<7262 and the rev counter low byte > #10h
label_04a5:     CLRB    A                      ;
                JBS     off(0011eh).5, label_04ab ;

                ;A is 0 here
                                               ; 04A9 from 049D (DD0,108,20E)
label_04a9:     LB      A, #001h               ;make A == 1

                ; 04AB from 04A6 if 11e.5 == 1. A = 0h if from jump
label_04ab:     RB      PSWL.4                 ; retarded?? yes.
                SJ      label_04b1             ; because it sets it again in this jump
                                               ; 04AF from 0474 (DD0,108,20E)
                                               ; 04AF from 049A (DD0,108,20E)
                                               ; 04AF from 04A1 (DD0,108,20E)
label_04af:     LB      A, #0feh               ;
                                               ; 04B1 from 0472 (DD0,108,20E)
                                               ; 04B1 from 04AD (DD0,108,20E)
label_04b1:     SB      PSWL.4                 ; 04B1 0 108 20E A31C

				;store a6h
                                               ; 04B3 from 04A3 (DD0,108,20E)
label_04b3:     STB     A, 0a6h                ;store into rpm low byte


				;rpm = [a7h] * 1852000/d000h

                MB      C, PSWL.4              ; 04B5 0 108 20E A32C
                MB      off(00129h).1, C       ;set vtec.1 if PSWL.4
                CLRB    r7                     ; r7 = 0
                JBS     off(0011eh).5, label_04d2 ; if 11eh.5 then set A7 to 0
                DECB    r7                     ; r7 = ffh
                MOV     er2, 0bah              ; get rev counter again.
                MOV     er0, #0d000h           ; load d000h
                CLR     A                      ; A = 0
                DIV                            ; er0A = er0A / er2: er0A = d000 0000/rev count
                LB      A, r1                  ; load er0 high byte
                JNE     label_04d2             ; if r1 != 0 then a7h = ffh (rpm >= 8903)
                LB      A, r0                  ; load er0 low byte
                JNE     label_04d3             ; if r0 != 0 then were good. jump and store r0 to a7h

                ;here if rpm<=34
                MOVB    r7, #001h              ; else er0 = 0 and so a7h = 1;
                                               ; 04D2 from 04BC (DD0,108,20E)
                                               ; 04D2 from 04CB (DD0,108,20E)
label_04d2:     LB      A, r7                  ;
                                               ; 04D3 from 04CE (DD0,108,20E)
label_04d3:     STB     A, 0a7h                ; so rpm = [a7h]*34.78

;end RPM routines
;*********************************************
;if map sensor is bad, use the TPS
                JBS     off(00130h).2, label_04db ;if fault code 1.2 goto 04db (map sensor unplugged code)
                JBR     off(00130h).4, label_04e3 ;if the map sensor is not bad/unplugged and there is no mechanical problem jump to map sensor calcs
                                               ; 04DB from 04D5 (DD0,108,20E)
label_04db:     LB      A, 0ach                ; load TPS
                MOV     X1, #03b1dh            ;
                VCAL    2                      ; interpolate between [X1] and [X1+2]
                SJ      label_050e             ;


;********************************************************************************************
;start of map sensor calculations

;they are super duper crazy careful about the upper limit on the map bytes.
;the upper limit IS 100% #0dfh. They check it like 8 or 10 times before the map interpolation.
;why? cause there are only 15 columns (0-14) and column 14 is used for interpolation ONLY.
;this is sort of bad because this limits us to 17 columns using this byte structure.
;And I think we would need more than 2 extra columns for boost...
;(these 2 extra columns are easy to come by, though)

label_04e3:     L       A, 0b0h                ; load map sensor val thats from ADCR5
                SWAP                           ; AH->AL, AL->AH
                LB      A, ACC                 ; switch to byte mode...
                CMPB    A, #0a1h               ; upper limit of map. ~2.85V
                JGT     label_04f0             ; if AL > #0a1h; if [b0h] > A100h
                CMPB    A, #00bh               ; lower limit. if linear then its
                JGE     label_04f5             ; if AL >= #00bh && AL <= #0a1h

                ;here if A<bh or A>A1h
                ;
                ;outside the accepted range of values. ECU goes: shit! shit! shit!
                                               ; 04F0 from 04EA (DD0,108,20E)
label_04f0:     SC                             ; 04F0 0 108 20E 85
                LB      A, 0b4h                ; 04F1 0 108 20E F5B4
                SJ      label_0512             ; 04F3 0 108 20E CB1D

                ;here if Bh <= AL <= a1h
                ;assuming this is a good thing
                                               ; 04F5 from 04EE (DD0,108,20E)
label_04f5:     CMPB    A, #070h               ; cmp	b0h, #7000h
                JGT     label_0504             ; if AL > 70h
                MB      C, ACCH.7              ; else move A.15 into C
                ROLB    A                      ; AL * = 2
                SUBB    A, #030h               ; AL -= 30h; min val = -30h, max = b0h
                JGE     label_050e             ; if AL >= 30h
                CLRB    A                      ; 0501 0 108 20E FA
                SJ      label_050e             ; 0502 0 108 20E CB0A
                                               ; 0504 from 04F7 if AL > 70h
label_0504:     ADDB    A, #040h               ; AL += 40h; min val == b1h, max val = E1, carry should always be 0
                JLT     label_050c             ; jump if AL < B1h && AL > E1h. weird?? yes.
                CMPB    A, #0e0h               ;
                JLT     label_050e             ; AL < E0h then were good. jump.

                ;here if we got some shitty value because of who knows what
                                               ; 050C from 0506 (DD0,108,20E)
label_050c:     LB      A, #0dfh               ; ignore whats in it and just use dfh

                                               ; 050E from 04E1 (DD0,108,20E)
                                               ; 050E from 04FF (DD0,108,20E)
                                               ; 050E from 0502 (DD0,108,20E)
                                               ; 050E from 050A (DD0,108,20E)
label_050e:     XCHGB   A, 0b4h                ; put our calculated AL into b4h and [b4h] -> AL
                RC                             ; 0511 0 108 20E 95

                ;here from the "outside accepted values" trail if from jump
                                               ; 0512 from 04F3 (DD0,108,20E)
label_0512:     STB     A, 0b7h                ; [b4h] -> [b7h]

				;MAP CEL CODE setting (code 3)
                MB      off(0012ch).0, C       ; 1 if error, 0 if we're ok

                LB      A, off(001e3h)         ;
                JEQ     label_0527             ; if [1e3h] == 0 jump

                ;not jump. error?
                ;I'm guessing this way cause there is no calculation
                ;for b3h, beh, or c0h.
                ;that seems to be the trend for error stuff...
                LB      A, 0b4h                ; else put [b4h]
                STB     A, 0b3h                ; into b3h
                                               ; 051F from 0542 (DD1,108,20E)
label_051f:     L       A, 0bah                ; load the rev counter
                ST      A, 0beh                ; put it in beh
                ST      A, 0c0h                ; and c0h
                SJ      label_0579             ;


                ;different trail
                ;only here if [1e3h] == 0
                ;good
                ;calc b2h/b3h

                ;b2h/b3h is the "old" map value
                ; the function below makes b2/b3 behave like
                ; a corner of a hyperbole. The asemptote is the original
                ; map image (b4h). Sooooo if b4h was going nice and steady,
                ; then all of a sudden jumped up because the driver stomped
                ; the gas pedal, the difference between b4h*100h and b3h|b2h
                ; would be large. This is used later for a correction...
                                               ; 0527 from 0519 (DD0,108,20E)
label_0527:     CLR     A                      ;
                MOV     DP, #000b2h            ; 0528 1 108 20E 62B200
                MOV     er1, #08000h           ; 052B 1 108 20E 45980080
                LB      A, 0b4h                ; 052F 0 108 20E F5B4
                CMPB    A, 0b3h                ; 0531 0 108 20E C5B3C2
                JGT     label_053a             ; if [b4h] > [b3h] then jump
                MOV     er1, #04000h           ; else er1 gets 4000h instead of 8000h
                                               ; 053A from 0534 (DD0,108,20E)
label_053a:     MOV     er0, er1               ; er0 <- er1
                L       A, ACC                 ; change DD
                SWAP                           ; AH = [b4h] AL = 0

                ;calculate the val at b2h
                ;b4h is the asemptote
                CAL     label_2efd             ; ;[DP] = ([DP] - [DP]*er0/10000h) + (A*er0/10000h)


                JBS     off(00120h).5, label_051f ; if 120.5 jump, I think this is an error

;end map crap
;*******************************************************************************

                ;calculate the value at beh
                ;average of the last 4 rev count values.
                L       A, 0bah                ; load rev counter
                MOV     USP, #0020eh           ;
                CLRB    r0                     ; r0 = 0
                ADD     A, (0020eh-0020eh)[USP] ; A += [20eh]
                ADCB    r0, #000h				; add C to r0
                ADD     A, (00210h-0020eh)[USP] ; A += [210h]
                ADCB    r0, #000h               ; add C to r0
                ADD     A, (00212h-0020eh)[USP] ; A += [212h]
                ADCB    r0, #000h              ; add C to r0
                SRLB    r0                     ; maybe set carry
                ROR     A                      ; roll right with carry
                SRLB    r0                     ; maybe set carry
                ROR     A                      ; roll right with carry
                ST      A, 0beh                ; store it in beh

                ;calculate c0h
                MOV     DP, #000c0h            ; 0567 1 108 20E 62C000
                CMP     A, [DP]                ; 056A 1 108 20E B2C2
                MOV     er0, #03000h           ; 056C 1 108 20E 44980030
                JGE     label_0576             ; 0570 1 108 20E CD04
                MOV     er0, #0d000h           ; 0572 1 108 20E 449800D0
                                               ; 0576 from 0570 (DD1,108,20E)
label_0576:     CAL     label_2efd             ;[DP] = ([DP] - [DP]*er0/10000h) + (A*er0/10000h)





;*************************************************************************
;TPS stuff

label_0579:     L       A, ADCR7               ; 0579 1 108 20E E56E
                MOV     DP, #000ach            ; 057B 1 108 20E 62AC00
                CAL     label_2e4f             ; Calculate values for ach and adh

                ;no carry if error
                ;carry if new adh value is lower than old adh value
                MB      off(0011fh).2, C       ; 0581 1 108 20E C41F3A

                ;just cascading the "punch it" bit.
                ;123.5 = 123.4
                ;123.4 = 123.3
                MB      C, off(00123h).4       ; 0584 1 108 20E C4232C
                MB      off(00123h).5, C       ; 0587 1 108 20E C4233D
                MB      C, off(00123h).3       ; 058A 1 108 20E C4232B
                MB      off(00123h).4, C       ; 058D 1 108 20E C4233C

                MOV     DP, #00278h            ; could these be the old tps values?
                LB      A, [DP]                ;
                JLT     label_0598             ;
                ADDB    A, #002h               ;
                                               ; 0598 from 0594 (DD0,108,20E)
label_0598:     ADDB    A, #003h               ; 0598 0 108 20E 8603
                CMPB    A, 0ach                ; compare [278h]+3 (and +2 depending on 123.3)

				;123.3 == 1 when we punch it.
				;123.3 == 0 when we let off the gas
                MB      off(00123h).3, C       ; if the TPS is > the last value then set this


                MB      C, off(0011fh).6       ; 05A0 0 108 20E C41F2E
                MB      off(0011fh).7, C       ; 05A3 0 108 20E C41F3F
                MB      C, off(0011fh).5       ; 05A6 0 108 20E C41F2D
                MB      off(0011fh).6, C       ; 05A9 0 108 20E C41F3E

                LB      A, #046h               ; compared to rpm
                MOVB    r0, #077h              ; compared to map sensor
                JGE     label_05b6				;if
                LB      A, #04eh               ; compared to rpm
                MOVB    r0, #089h              ; compared to map sensor
                                               ; 05B6 from 05B0 (DD0,108,20E)
label_05b6:     CMPB    0a6h, A                ;
                JGE     label_05bf             ; if rpm >= 46h or 4eh jump
                LB      A, r0                  ;
                CMPB    0b4h, A                ; else if map< 77h or 89h C = 1
                                               ; 05BF from 05B9 no carry if rpm (from jump)
label_05bf:     MB      off(0011fh).5, C       ;
                LB      A, #000h               ; why?
                JBR     off(00122h).2, label_05c9 ; dumb
                LB      A, #000h               ;


label_05c9:     CMPB    A, 0a6h                ; C is always going to be 1 when the car is running
                MB      off(00122h).2, C       ; Hey, look, its running!

                L       A, 0bah                ; RPM
                SUB     A, off(00172h)         ; [bah] - [172h]
                MB      off(00125h).2, C       ; 1 if target idle > current revs
                JGE     label_05db             ;
                ST      A, er0                 ;
                CLR     A                      ;
                SUB     A, er0                 ;
                                               ; 05DB from 05D6 (DD1,108,20E)
label_05db:     ST      A, 0c2h                ; [c2h] = difference between revs and target idle
                CLRB    A                      ; AL = 0
                STB     A, r7                  ; r7 = 0
                CMPB    0a3h, #04fh            ; if temp <= 51deg C
                JGE     label_0619             ; then jump

                ;are these checking errors?
                JBR     off(0011fh).5, label_0619 ; Set a few lines above when CMPB 0b4h A
                JBS     off(00123h).3, label_0619 ; if TPS increasing?
                JBS     off(0011ah).7, label_05f4 ; if we made timing connector compare last time
                JBR     off(00125h).5, label_0619 ; 05EE 0 108 20E DD2528
                JBS     off(00125h).2, label_0619 ; 05F1 0 108 20E EA2525

;*********************************************
;calculate [13bh] - idle adjust connector (B20)
                                               ; 05F4 from 05EB (DD0,108,20E)
label_05f4:     INCB    r7                     ; 05F4 0 108 20E AF
                CMPB    09dh, #003h            ; 05F5 0 108 20E C59DC003
                JLE     label_0617             ; if idle adjust connector NOT plugged in jump

                MOVB    r1, #010h              ; useless
                JBR     off(00125h).2, label_0602 ; useless
                MOVB    r1, #010h              ; useless
                                               ; 0602 from 05FD (DD0,108,20E)
label_0602:     STB     A, r0                  ; AL = 0
                L       A, 0c2h                ; load diff b/t revs and target idle
                MUL                            ; [c2h]*1000h
                MOVB    r4, #00ch              ; 0607 1 108 20E 9C0C
                LB      A, r3                  ; 0609 0 108 20E 7B
                JNE     label_0610             ; 060A 0 108 20E CE04
                LB      A, r2                  ; 060C 0 108 20E 7A
                CMPB    A, r4                  ; 060D 0 108 20E 4C
                JLT     label_0611             ; 060E 0 108 20E CA01
                                               ; 0610 from 060A (DD0,108,20E)
label_0610:     LB      A, r4                  ; 0610 0 108 20E 7C
                                               ; 0611 from 060E (DD0,108,20E)
label_0611:     JBR     off(00125h).2, label_0617 ; 0611 0 108 20E DA2503
                STB     A, r0                  ; 0614 0 108 20E 88
                CLRB    A                      ; 0615 0 108 20E FA
                SUBB    A, r0                  ; 0616 0 108 20E 28
                                               ; 0617 from 05F9 (DD0,108,20E)
                                               ; 0617 from 0611 (DD0,108,20E)
label_0617:     ADDB    A, #000h               ; 0617 0 108 20E 8600

                ; 0619 from 05E3 temp <= 51deg C
                ; 0619 from 05E5 map > 77h or 89h or rpm >= 46h or 4eh
                ; 0619 from 05E8 [278h]+3 (and +2 depending on 123.3) < [ach]

                ;if from jump it will be 0;
                ; so will r7
label_0619:     STB     A, off(0013bh)         ; 0619 0 108 20E D43B
;end of 13bh calculation. if theres an error [13bh] = 0

;*********************************************

                MB      C, r7.0                ; this will be 1 if we got to
                								;actually make the timing connector compare

                MB      off(0011ah).7, C       ; = r7.0
                JBS     off(00125h).3, label_0627 ; ?
                MOVB    off(001e5h), #01eh     ;
                                               ; 0627 from 0620 (DD0,108,20E)
label_0627:     LB      A, off(001e5h)         ; 0627 0 108 20E F4E5
                JNE     label_062e             ; if [1e5h] !=0 then jump
                J       label_068a             ; else skip the following code...

;*********************************************
;calculation of val @ b5h...

; this is delta_map. If this code sees a big change in the map image, it will
; correct more (or less, depending)

; it takes about 13 or 14 iterations of the code for the b3|b2 val to catch up
; to b4|00 when a big change is detected (such as column 3 to col 13 or something)

                                               ; 062E from 0629 (DD0,108,20E)
                                               ; 062E from 0695 (DD1,108,20E)
label_062e:     CLR     A                      ; 062E 1 108 20E F9
                LB      A, 0b4h                ;
                L       A, ACC                 ;
                SWAP                           ; A = [b4h]*10000h
                SUB     A, 0b2h                ; A = [b4h]*10000h - [b2h/b3h]

                ;stock #00b00h
                MOV     er0, #01600h           ; delta_map enrichment?? stock #b00h
                JGE     label_0644             ; 063B 1 108 20E CD07
                ST      A, er1                 ; 063D 1 108 20E 89
                CLR     A                      ; 063E 1 108 20E F9
                SUB     A, er1                 ; 063F 1 108 20E 29

                ;stock #00b00h; redundant
                MOV     er0, #01600h           ; delta_map enrichment?? mugen -> #1600h
                                               ; 0644 from 063B (DD1,108,20E)
label_0644:     ROLB    r7                     ; r7 = 0 or 1 from above; now r7 = 0 or 2
                CMP     A, #00100h             ; compare the difference to 100h
                JGE     label_064c             ; if its greater than 100h jump
                CLR     A                      ; else A = 0

                ; 064C from 0649 (DD1,108,20E)
                ; if difference >= enrichment, jump , else enrichment = difference
label_064c:     CMP     A, er0                 ;
                JGE     label_0650             ;
                ST      A, er0                 ;
                                               ; 0650 from 064D (DD1,108,20E)
label_0650:     CLRB    A                      ;
                CMPB    0a6h, #0a9h            ; if rpm is less than a9h, jump
                JLT     label_0659             ;
                ADDB    A, #004h               ; else add 4

                                               ; 0659 from 0655 (DD0,108,20E)
label_0659:     JBR     off(0010fh).0, label_065e ; if need addition, jump
                ADDB    A, #002h               ; else add 2
                                               ; 065E from 0659 (DD0,108,20E)
label_065e:     EXTND                          ;
                LC      A, 03858h[ACC]         ; get specific enrichment val
                MUL                            ; er1A = A*er0, r2 has correction
                LB      A, 0b4h                ; get map image


                JBS     off(0010fh).0, label_0676 ; if this then subtract
                ADDB    A, r2                  ; 066B 0 108 20E 0A
                JLT     label_0672             ; any carry is bad
                CMPB    A, #0dfh               ; if A ([b4h]+r2)
                JLE     label_0686             ; is < dfh then we are good
                                               ; 0672 from 066C (DD0,108,20E)
label_0672:     LB      A, #0dfh               ; else load dfh in there
                SJ      label_0686             ; 0674 0 108 20E CB10


                                               ; 0676 from 0668 (DD0,108,20E)
label_0676:     CMPB    0a3h, #080h            ; euro pw0 replace temp check with
                JLT     label_0682             ; JBS     off(00128h).1, label_0682
                CMPB    0f9h, #00fh            ; if f9h < fh
                JLT     label_0686             ; dont correct
                                               ; 0682 from 067A (DD0,108,20E)
label_0682:     SUBB    A, r2                  ; subtract
                JGE     label_0686             ;
                CLRB    A                      ; 0685 0 108 20E FA
                                               ; 0686 from 0670 (DD0,108,20E)
                                               ; 0686 from 0674 (DD0,108,20E)
                                               ; 0686 from 0680 (DD0,108,20E)
                                               ; 0686 from 0683 (DD0,108,20E)
label_0686:     STB     A, 0b5h                ; 0686 0 108 20E D5B5
                SJ      label_06d8             ; 0688 0 108 20E CB4E


                ;here in error
                                               ; 068A from 062B (DD0,108,20E)
label_068a:     L       A, 0beh                ; 068A 1 108 20E E5BE
                SUB     A, 0c0h                ; 068C 1 108 20E B5C0A2
                ST      A, er3                 ; 068F 1 108 20E 8B
                JGE     label_0697             ; 0690 1 108 20E CD05
                JBR     off(00123h).3, label_06d4 ; 0692 1 108 20E DB233F
                                               ; 0695 from 06BF (DD1,108,20E)
label_0695:     SJ      label_062e             ; 0695 1 108 20E CB97
                                               ; 0697 from 0690 (DD1,108,20E)
label_0697:     MOV     er2, #00019h           ; 0697 1 108 20E 46981900
                MOV     er0, #00002h           ; 069B 1 108 20E 44980200
                JBS     off(0011eh).4, label_06bf ; 069F 1 108 20E EC1E1D
                CMP     0bch, #0009dh          ; compare the delta rev to 9dh
                JGE     label_06ac             ; if big change jump
                JBR     off(00120h).3, label_06bf ; 06A9 1 108 20E DB2013
                                               ; 06AC from 06A7 (DD1,108,20E)
label_06ac:     CMP     er3, #00064h           ; 06AC 1 108 20E 47C06400
                JLT     label_06bf             ; 06B0 1 108 20E CA0D
                SB      off(00120h).3          ; 06B2 1 108 20E C4201B
                MOV     er2, #0004bh           ; 06B5 1 108 20E 46984B00
                MOV     er0, #0000ah           ; 06B9 1 108 20E 44980A00
                SJ      label_06c5             ; 06BD 1 108 20E CB06
                                               ; 06BF from 069F (DD1,108,20E)
                                               ; 06BF from 06A9 (DD1,108,20E)
                                               ; 06BF from 06B0 (DD1,108,20E)
label_06bf:     JBS     off(00123h).3, label_0695 ; 06BF 1 108 20E EB23D3
                RB      off(00120h).3          ; 06C2 1 108 20E C4200B
                                               ; 06C5 from 06BD (DD1,108,20E)
label_06c5:     LB      A, 0b4h                ; 06C5 0 108 20E F5B4
                STB     A, 0b5h                ; 06C7 0 108 20E D5B5
                L       A, er3                 ; er3 has some rev count value
                MUL                            ; 06CA 1 108 20E 9035
                SRL     A                      ; 06CC 1 108 20E 63
                SRL     A                      ; 06CD 1 108 20E 63
                CMP     A, er2                 ; 06CE 1 108 20E 4A
                JLT     label_06dc             ; 06CF 1 108 20E CA0B
                L       A, er2                 ; 06D1 1 108 20E 36
                SJ      label_06dc             ; 06D2 1 108 20E CB08
                                               ; 06D4 from 0692 (DD1,108,20E)
label_06d4:     LB      A, 0b4h                ; 06D4 0 108 20E F5B4
                STB     A, 0b5h                ; 06D6 0 108 20E D5B5
                                               ; 06D8 from 0688 (DD0,108,20E)

                ;done wih b5h calc
label_06d8:     RB      off(00120h).3          ; 06D8 0 108 20E C4200B
                CLR     A                      ; 06DB 1 108 20E F9
                                               ; 06DC from 06CF (DD1,108,20E)
                                               ; 06DC from 06D2 (DD1,108,20E)
label_06dc:     ST      A, off(00150h)         ; 06DC 1 108 20E D450
                LB      A, #0dfh               ; 06DE 0 108 20E 77DF
                JBS     off(00130h).2, label_06e8 ;if map sensor code jump to 6e8h
                JBS     off(00130h).4, label_06e8 ;if map sensor mechanical prob jump to   "
                LB      A, 0b5h                ;map RAM -> AL

;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
;**************************************************************************
;/////////////////////////////////////////////////////////////////////////
;
;this is where the ignition stuff begins.
;We will pick the cell in the map, do some corrections
;then finally find the final value.
;

;************************
;ignition cell picking
;at the end we will have:
; 138h = value picked from table;
;
; this ignition section uses a few ram locations:
; 134h: final ign value
;
; 137h: some correction
; 138h: value picked from table/map
; 139h: correction for brake switch (0 or [9eh]+80h)
; 13ah: ect corection for sure
; 13bh: idle adjust connector. (0 if not plugged in)
; 13ch: some correction
; 13dh: Knock correction
; 13eh: some correction
;
;

                                               ; 06E8 from 06E0 (DD0,108,20E)
                                               ; 06E8 from 06E3 (DD0,108,20E)
label_06e8:     STB     A, r6                  ; 06E8 0 108 20E 8E
                LB      A, 0a7h						 ;rpm high byte -> accL
                RC									 ;reset carry
                MOV     X1, #03ce5h					 ;vtec ignmap
                MOV     X2, #03bc6h					 ;vtec rpm scalars
                JBS     off(00129h).7, label_0700	 ;if vtec.7 then skip the next 5 lines  (vtec is on)
                LB      A, 0a6h						 ;rpm low byte -> acc
                MB      C, off(00129h).1			 ;set carry to some vtec val bit 1
                MOV     X1, #03be6h					 ;else no vtec so set X1 to -> no vtec ign map
                MOV     X2, #03bb6h					 ;and -> no tec rpm scalars
											   ; 0700 from 06F2 (DD0,108,20E)
label_0700:     STB     A, r7				   ;
                MB      off(00129h).2, C       ;move carry into vtec bit 2, if vtec.7 then it will be 0, else it will be 0129h.1
                SB      PSWL.5                 ; 0704 0 108 20E A31D
                CAL     label_2cb3             ; find cell, get ign value to use
                MOVB    off(00138h), A         ; store it in 138h

;end cell choosing
;******************************
; begin 137h calc: at the end it really has to do with rpm and some constant


	;first we error check
                JBS     off(0012bh).2, label_074e ; 070C 0 108 20E EA2B3F

                ;fault code 1 check
                ;74h == 01110100
                ;codes 3(map), 5(map), 6(ect), 7(tps)
                LB      A, off(00130h)         ; 070F 0 108 20E F430
                ANDB    A, #074h               ; 0711 0 108 20E D674
                JNE     label_074e          ;if 130h == X111X1XX then jump   ; 0713 0 108 20E CE39

                ;else check fault code 3
                ;37h == 00110111
                ;codes 17(vss), 18(??), 19(auto tans lockup), 21(vtec sol), 22(PS)
                LB      A, off(00132h)         ; 0715 0 108 20E F432
                ANDB    A, #037h               ; 0717 0 108 20E D637
                JNE     label_074e             ; 0719 0 108 20E CE33

                JBS     off(00127h).3, label_074e ; 071B 0 108 20E EB2730

                MOV     DP, #00278h            ; OLD TPS
                LB      A, [DP]                ;
                JEQ     label_074e             ; if old tps = 0 no correction

                CMPB    0a3h, #02eh            ; temp check
                JGE     label_074e             ; if temp<89deg C
	;done error checking


                LB      A, #005h               ; speed compare
                MOVB    r0, #0ffh              ; 072C 0 108 20E 98FF
                MOVB    r1, #0cfh              ; 072E 0 108 20E 99CF
                JBS     off(0011ah).2, label_0739 ; 0730 0 108 20E EA1A06
                LB      A, #008h			   ; speed compare
                MOVB    r0, #0f0h              ; 0735 0 108 20E 98F0
                MOVB    r1, #0cbh              ; 0737 0 108 20E 99CB
                                               ; 0739 from 0730 (DD0,108,20E)

                ;Speed in KM/H = Value(decimal)
label_0739:     CMPB    A, 0cbh					;AL-speed  AL may be 5 or 8
                JGE     label_0746				;if A >= speed goto label_746
                LB      A, 0cbh					;


                CMPB    A, r0					;speed byte-r0, r0 may be FF or F0 (weird)
                JGE     label_0746				;else if speed >= r0 goto label_746
                LB      A, 0a6h				    ;
                CMPB    A, r1					;A-r1, r1 may be cfh or cbh (~4k rpm)

                ;if from jump then speed is >5 or 8 and <f0h or ffh
                ; 0746 from 073C car is like stopped from here
                ; 0746 from 0741 fast if from here
label_0746:     MB      off(0011ah).2, C		;if get here from a jump (speed), C will be 0, if from above it could be 1
                JGE     label_074e				;if bit == 0 (got there from jump, high/low speed or possibly high rpm)
              	;we only get to here if the car is moving at a resonable
              	;speed (not too fast or slow) and if rpm < ~4k
              	; otherwise the 137h val = 0;

              	JBR     off(0011fh).5, label_0751 ; if 11fh.5 then continue

                                               ; 074E from 070C (DD0,108,20E)
                                               ; 074E from 0713 (DD0,108,20E)
                                               ; 074E from 0719 (DD0,108,20E)
                                               ; 074E from 071B (DD0,108,20E)
                                               ; 074E from 0722 (DD0,108,20E)
                                               ; 074E from 0728 (DD0,108,20E)
                                               ; 074E from 0749 (DD0,108,20E)
                                               ; 074E from 0751 (DD0,108,20E)
                                               ; 074E from 076B (DD0,108,20E)


                ;Cel code jumps come here
                ;error!
                ;goes to: 137h = 0; Thats it.
label_074e:     J       label_07bf             ;



                                                  ; 0751 from 074B (DD0,108,20E)
label_0751:     JBR     off(00123h).3, label_074e ; if TPS didnt increase (or decreased) on last
												  ; iteration, 137h = 0

                JBS     off(00123h).4, label_075b ; if TPS value increased on last 2
                								  ; iterations jump to continue

                ; here if TPS increased last time, but not the time before
                MOVB    0f5h, #003h            	  ;
                                                  ; 075B from 0754 (DD0,108,20E)
label_075b:     LB      A, 0f5h					  ;
                JEQ     label_07a3				  ; if f5 == 0;


                DECB    0f5h					  ; else 0f5h--
                LB      A, 0afh                   ; 0762 0 108 20E F5AF
                JBS     off(00122h).2, label_0769 ; 0764 0 108 20E EA2202
                LB      A, 0adh                   ; TPS?
                                                  ; 0769 from 0764 (DD0,108,20E)
label_0769:     CMPB    A, #083h                  ; another error check
                JLE     label_074e                ; 076B 0 108 20E CFE1
                CLRB    0f5h                      ; 076D 0 108 20E C5F515
                CAL     label_3256                ; just loads X1 up depending on 129.0
                JBS     off(00124h).0, label_077c ; 0773 0 108 20E E82406
                JBS     off(00124h).1, label_077c ; 0776 0 108 20E E92403
                CAL     label_3260                ; just loads X1 up depending on 129.0

                ;MOV     X1, #038f3h
                ;JBR     off(00129h).0, label_3269
                ;MOV     X1, #03242h

				;3269: RT

                                               ; 077C from 0773 (DD0,108,20E)
                                               ; 077C from 0776 (DD0,108,20E)
label_077c:     LB      A, 0a6h                ; 077C 0 108 20E F5A6
                VCAL    0                      ; 077E 0 108 20E 10
                JBS     off(00123h).1, label_0785 ; 077F 0 108 20E E92303
                JBR     off(00123h).2, label_0792 ; 0782 0 108 20E DA230D
                                               ; 0785 from 077F (DD0,108,20E)
label_0785:     MOVB    r0, #080h              ; 0785 0 108 20E 9880
                MULB                           ; A = AL*r0: A = AL (from vcal_0) * 80h
                SLL     ACC                    ; 0789 0 108 20E B506D7
                LB      A, ACCH                ; 078C 0 108 20E F507
                JGE     label_0792             ; 078E 0 108 20E CD02
                LB      A, #0ffh               ; 0790 0 108 20E 77FF
                                               ; 0792 from 0782 (DD0,108,20E)
                                               ; 0792 from 078E (DD0,108,20E)
label_0792:     STB     A, off(00137h)         ; 0792 0 108 20E D437


                CMPB    0a6h, #086h            ; 0794 0 108 20E C5A6C086
                MB      off(00119h).6, C       ; 0798 0 108 20E C4193E
                LB      A, #014h               ; 079B 0 108 20E 7714
                JLT     label_07a1             ; 079D 0 108 20E CA02
                LB      A, #019h               ; 079F 0 108 20E 7719
                                               ; 07A1 from 079D (DD0,108,20E)
label_07a1:     STB     A, 0f4h                ; 07A1 0 108 20E D5F4


                                               ; 07A3 from 075D (DD0,108,20E)
label_07a3:     LB      A, off(00137h)         ; 07A3 0 108 20E F437
                JEQ     label_07c2             ; 07A5 0 108 20E C91B
                CAL     label_326a             ; loads DP
                JBS     off(00119h).6, label_07af ; 07AA 0 108 20E EE1902
                INC     DP                     ; 07AD 0 108 20E 72
                INC     DP                     ; 07AE 0 108 20E 72
                                               ; 07AF from 07AA (DD0,108,20E)
label_07af:     LB      A, 0f4h                ; 07AF 0 108 20E F5F4
                JEQ     label_07b7             ; 07B1 0 108 20E C904
                INC     DP                     ; 07B3 0 108 20E 72
                DECB    0f4h                   ; 07B4 0 108 20E C5F417
                                               ; 07B7 from 07B1 (DD0,108,20E)
label_07b7:     LCB     A, [DP]                ; 07B7 0 108 20E 92AA
                STB     A, r0                  ; 07B9 0 108 20E 88
                LB      A, off(00137h)         ; 07BA 0 108 20E F437
                SUBB    A, r0                  ; 07BC 0 108 20E 28
                JGE     label_07c0             ; 07BD 0 108 20E CD01
                ;to here


                                               ; 07BF from 074E (DD0,108,20E)
label_07bf:     CLRB    A                      ; 07BF 0 108 20E FA


                                               ; 07C0 from 07BD (DD0,108,20E)
label_07c0:     STB     A, off(00137h)         ; 07C0 0 108 20E D437

;end 0137h calc
;*******************************************************************************
;calc 13ah
;ect correction
                                               ; 07C2 from 07A5 (DD0,108,20E)
label_07c2:     LB      A, off(0013fh)         ; 07C2 0 108 20E F43F
                JEQ     label_07e8             ; if 13fh == 0 set 13ah = 0;
                JBS     off(0013fh).7, label_07e8 ; if 13fh>=128d set 13ah
                CMPB    0a3h, #02eh				; temp check
                JLT     label_07e8              ; if hotter than 98deg. C set 13ah = 13fh
                CMPB    0f8h, #00ah				; oil pressure check? stock #00ah
                JLT     label_07e8              ; if no oil pressure set 13ah = 13fh
                ;NOP
                ;NOP
                LB      A, 0a3h                ; load temp
                MOV     X1, #0390bh            ; move in scalar
                VCAL    2                      ; make sure temp is w/in certain val and call vcal_0
                STB     A, r7                  ; store the vcal_2/0 correction into r7
                CLRB    r6                     ; r6 = 0
                MOV     X1, #0390fh            ;
                CAL     label_2d58             ; interpolate between [X1] and [X1+2] with r7 as the key
                CLRB    A                      ;
                SUBB    A, r6                  ; make pos
                ADDB    A, off(0013fh)         ;

                                               ; 07E8 from 07C4 (DD0,108,20E)
                                               ; 07E8 from 07C6 (DD0,108,20E)
                                               ; 07E8 from 07CD (DD0,108,20E)
                                               ; 07E8 from 07D3 (DD0,108,20E)
label_07e8:     STB     A, off(0013ah)         ; 07E8 0 108 20E D43A
;end 13ah calc
;******************************************************************88*************

                MOV     X1, #03887h            ; move vector
                LB      A, 0a7h                ; move vtec rpm
                VCAL    0                      ; interpolate for 13e
                STB     A, off(0013eh)         ;

;*********************************************************************************
; knock correction. I think.

; I am a bit confused, though. The meat of the correction code just
; does a vcal_0 against the X1 vector (no error) or the X2 vector (error)
; with RPM as the key. Why RPM and not knock stuff?

                ;Euro PW0 missing code from ~here:
                MB      C, P2.4                ; does this have something to do with limp mode?
                JGE     label_07fa             ; if P2.4 == 0 then enter reg code
                J       label_0880             ; else skip 13dh calculation
                                               ; 07FA from 07F5 (DD0,108,20E)
                ;28 vals b/t
                ;what is at these addresses?
label_07fa:     MOV     DP, #000a7h            ; vtec DP
                L       A, #038bbh             ; vtec A
                MOV     USP, #0389fh           ; vtec usp
                JBS     off(00129h).7, label_080f ; vtec then x1 & x2 = addys above DP = a7h
                DEC     DP					   ; else dp = a6
                L       A, #038adh			   ; and these addys
                MOV     USP, #03891h           ;
                                               ; 080F from 0804 (DD1,108,389F)
label_080f:     MOV     X1, A                  ;
                MOV     X2, USP                ;
                CMPB    09eh, #01fh            ; brake switch??????
                JLT     label_0874             ; if 9eh < #1fh then skip all this

				;else
				;r7 = 12bh.0 and .1
				;12bh.0 = ffh.0 and 12bh.1 = ffh.1
				; one of these is probably the "is knocking bit"
				; I suppose I should test that, eh?
				; maybe its a range thing, i.e. from 0-3 (binary) is the severity of knocking
                LB      A, off(0012bh)         ;
                ANDB    A, #003h               ; 3h = 00000011b
                STB     A, r7                  ; 081C 0 108 3891 8F
                LB      A, 0ffh                ; 081D 0 108 3891 F5FF
                ANDB    A, #003h               ; 081F 0 108 3891 D603
                ANDB    off(0012bh), #0fch     ; fch = 11111100b
                ORB     off(0012bh), A         ; this should put ffh's low 2 bit in 12bh
                CLRB    r5                     ; 0828 0 108 3891 2515
                CMPB    A, r7                  ;

                ;essentially:
                ;if last ffh.0 != 0 or last ffh.1 != 0 jump
                JNE     label_085e             ; 082B 0 108 3891 CE31

                SRLB    A                      ; 082D 0 108 3891 63
                JGE     label_0863             ; if ffh.0 = 0 jump

                CMPB    0a3h, #042h			   ; temp check
                JGE     label_0845             ; 0834 0 108 3891 CD0F

                JBS     off(0011dh).5, label_084f ; 0836 0 108 3891 ED1D16
                CMPB    0a6h, #069h			   ; if rpm<3360?
                JLT     label_0845             ; 083D 0 108 3891 CA06
                CMPB    off(001ffh), #001h     ; 083F 0 108 3891 C4FFC001
                SJ      label_084a             ; 0843 0 108 3891 CB05
                                               ; 0845 from 0834 (DD0,108,3891)
                                               ; 0845 from 083D (DD0,108,3891)
label_0845:     MOVB    off(001ffh), #03ch     ; 0845 0 108 3891 C4FF983C
                RC                             ; 0849 0 108 3891 95
                                               ; 084A from 0843 (DD0,108,3891)
label_084a:     MB      off(0011dh).5, C       ; 084A 0 108 3891 C41D3D
                SJ      label_0852             ; 084D 0 108 3891 CB03
                                               ; 084F from 0836 (DD0,108,3891)
label_084f:     SRLB    A                      ; 084F 0 108 3891 63
                JGE     label_0863             ; 0850 0 108 3891 CD11

                ;check fault codes 1 and 3
                                               ; 0852 from 084D (DD0,108,3891)
                ; BCh = 10111100 bin
                ;codes 3(map), 4(ckp), 5(map), 6(ect), 8(tdc)
label_0852:     LB      A, off(00130h)         ; 0852 0 108 3891 F430
                ANDB    A, #0bch               ; 0854 0 108 3891 D6BC
                JNE     label_0863             ; 0856 0 108 3891 CE0B
                ; 31h = 00110001
                ;codes 17(vss), 21(vtec sol), 22(PS)
                LB      A, off(00132h)         ; 0858 0 108 3891 F432
                ANDB    A, #031h               ; 085A 0 108 3891 D631
                JNE     label_0863             ; 085C 0 108 3891 CE05
                                               ; 085E from 082B (DD0,108,3891)
                ;no error codes so we load 13Dh from ram
                ;and jump to somewhere else if [13D] is zero
label_085e:     LB      A, off(0013dh)         ; load existing value
                JEQ     label_0883             ; jump out of this "function"
                INCB    r5                     ; else r5++


                                               ; 0863 from 082E (DD0,108,3891)
                                               ; 0863 from 0850 (DD0,108,3891)
                                               ; 0863 from 0856 (DD0,108,3891)
                                               ; 0863 from 085C (DD0,108,3891)

                ;this seems like the real correction
label_0863:     LB      A, [DP]                ; load rpm
                VCAL    0                      ; finally use x1

                ;gets here only if theres some error?
                ; so if 10dh.0 = 1 then we are good?
                JBR     off(0010dh).0, label_0881 ; 0865 0 108 3891 D80D19
                LB      A, off(0013dh)         ; load old, non 0 value
                ADDB    A, #002h               ; A+=2
                JLT     label_0880             ; if overflow then jump ( 13dh == 0 )

                ;if (A<=r6)
                ;  jump to store;
                ;else
                ;  A = r6;
                CMPB    A, r6                  ; r6 has vcal_0 value
                JGE     label_0881             ;
                LB      A, r6                  ;
                SJ      label_0881             ;
                ;end error handling??


                ; 0874 from 0816 if ram9eh<#01fh
                ; Case1:  X1 = #038bbh, X2 = #0389fh, DP = a7h
                ; Case2:  X1 = #038adh, X2 = #03891h, DP = a6h
label_0874:     CMPB    0a6h, #042h				;rpm - 932rpm
                JLT     label_0880				; if rpm<932 then 13dh = 0; its idling!!
                MOV     X1, X2                 ;
                LB      A, [DP]                ; A gets rpm
                VCAL    0                      ;
                SJ      label_0881             ; 087E 0 108 3891 CB01
                                               ; 0880 from 07F7 (DD0,108,20E)
                                               ; 0880 from 0878 (DD1,108,3891)
                                               ; 0880 from 086C (DD0,108,3891)
label_0880:     CLRB    A                      ; no correction


                ; 0881 from 087E A has correction from vcal_0
                ; 0881 from 0865 A has correction from vcal_0
                ; 0881 from 086F A has old value of 13dh + 2
                ; 0881 from 0872 A has old value of 13dh + 2
label_0881:     STB     A, off(0013dh)         ; knock

;to here
;end 13dh calc
;************************************************************************************

;take all the corrections and put them all together to get the final ignition val
;
                                               ; 0883 from 0860 (DD0,108,3891)
label_0883:     LB      A, off(00137h)         ; 0883 0 108 20E F437
                JEQ     label_0897             ; 0885 0 108 20E C910
                STB     A, r0                  ; 0887 0 108 20E 88
                SC                             ; 0888 0 108 20E 85
                LB      A, 0f4h					;calced in 137h function
                JNE     label_0899             ; 088B 0 108 20E CE0C
                JBS     off(0011eh).4, label_0899 ; 088D 0 108 20E EC1E09
                CMP     0bch, #00010h          ; compare delta revs to 10h
                JLT     label_0899             ; 0895 0 108 20E CA02
                                               ; 0897 from 0885 (DD0,108,20E)
label_0897:     STB     A, r0                  ; 0897 0 108 20E 88
                RC                             ; 0898 0 108 20E 95

                ; 0899 not from jump C = 0, r0 = [f4h] = 0, A = [f4h].
                ; 0899 from 088B C = 1, r0 = [137h], A = [f4h]. gets here if [f4h]!=0
                ; 0899 from 088D C = 1, r0 = [137h], A = [f4h]. gets here if [f4h]== 0 && 11eh.4 == 1
                ; 0899 from 0895 C = ?, r0 = [137h], A = [f4h]. gets here if [f4h]== 0 && 11eh.4 == 0 && [bch] < 10h
label_0899:     MB      off(00119h).7, C       ; 0899 0 108 20E C4193F
                LB      A, off(00138h)			;load ign value?
                SUBB    A, r0					;AL = [138h] - [137h] (or 0)
                JLT     label_08a8              ;if ign val < r0 jump
                JBR     off(00119h).5, label_08a9 ; 08A1 0 108 20E DD1905
                ADDB    A, #0f8h               ; [138h] - [137h] + f8h
                JLT     label_08a9             ; 08A6 0 108 20E CA01
                                               ; 08A8 from 089F (DD0,108,20E)
label_08a8:     CLRB    A                      ; 08A8 0 108 20E FA
                                               ; 08A9 from 08A1 (DD0,108,20E)
                                               ; 08A9 from 08A6 (DD0,108,20E)
label_08a9:     MOV     DP, #00005h            ; 08A9 0 108 20E 620500
                MOV     USP, #00139h           ; 08AC 0 108 139 A1983901
                JBR     off(00130h).5, label_08ba ;if no ECT code jump
                MOV     DP, #00002h            ; 08B3 0 108 139 620200
                MOV     USP, #0013ch           ; 08B6 0 108 13C A1983C01

                                               ; 08BA from 08B0 (DD0,108,139)
                                               ; 08BA from 08D0 loopage
label_08ba:     MB      C, (0013ch-0013ch)[USP].7 ; [USP].7
                ROLB    r7                     ; r7 = r7*2 + C
                ADDB    A, (0013ch-0013ch)[USP] ; ([138h] - [137h] + [usp]) or ([138h] - [137h] + f8h + [usp])
                JBS     off(0010fh).0, label_08cb ; if this bit then clear A
                JGE     label_08ce             ; if Adding result <= #ffh
                LB      A, #0ffh               ; else load #ffh
                SJ      label_08ce             ; and loop
                                               ; 08CB from 08C2 (DD0,108,13C)
label_08cb:     JLT     label_08ce             ; if adding produced a carry jump to loop
                CLRB    A                      ; else clear A
                                               ; 08CE from 08C5 (DD0,108,13C)
                                               ; 08CE from 08C9 (DD0,108,13C)
                                               ; 08CE from 08CB (DD0,108,13C)
label_08ce:     INC     USP                    ; USP could = 139h to 13eh (most likely. no ect code) or 13dh to 13eh(value calced above)
                JRNZ    DP, label_08ba         ; loop


                STB     A, r2                  ;
                LB      A, #046h               ; 08D3 0 108 13D 7746
                JBS     off(00119h).4, label_08da ; 08D5 0 108 13D EC1902
                LB      A, #054h               ; 08D8 0 108 13D 7754
                                               ; 08DA from 08D5 (DD0,108,13D)
label_08da:     CMPB    A, 0a6h                ; 08DA 0 108 13D C5A6C2
                MB      off(00119h).4, C       ; 08DD 0 108 13D C4193C
                JLT     label_0909             ; 08E0 0 108 13D CA27
                LB      A, 0a3h                ; load temp
                CMPB    A, #0fbh               ;
                JGE     label_0909             ; if temp < 16deg. C jump
                CMPB    A, #013h               ;
                JLT     label_0909             ; if temp > really hot jump
                MB      C, P2.4                ; is this a limp mode check?
                JLT     label_0910             ; limp? jump
                MOV     DP, #03884h            ; else change DP to 3884h = 3 in rom
                CMPB    A, #070h               ;
                JGE     label_08fe             ; if temp < 24deg C jump
                INC     DP                     ; else dp = 3885h = 3 in rom
                CMPB    A, #050h               ; if temp > 33deg C jump
                JGE     label_08fe             ;
                INC     DP                     ; else dp = 3886h = 3 in rom
                                               ; 08FE from 08F6 (DD0,108,13D)
                                               ; 08FE from 08FB (DD0,108,13D)
label_08fe:     LCB     A, [DP]                ; load the 3
                ADDB    A, off(00133h)         ; add 3 to 133h
                JLT     label_0909             ; if A > #ffh then jump
                STB     A, off(00133h)         ; else 133h += 3
                CMPB    A, r2                  ; compare value above (r2) to [DP] + [133h]
                JLT     label_0914             ; if [133h]+3 < r2 jump
                                               ; 0909 from 08E0 (DD0,108,13D)
                                               ; 0909 from 08E6 (DD0,108,13D)
                                               ; 0909 from 08EA (DD0,108,13D)
                                               ; 0909 from 0902 (DD0,108,13D)

                ;[133h] = ffh
                ; and then end

label_0909:     LB      A, r2                  ; 0909 0 108 13D 7A
                MOVB    off(00133h), #0ffh     ; 090A 0 108 13D C43398FF
                SJ      label_0914             ; 090E 0 108 13D CB04

                ; 0910 from 08EF some error.
label_0910:     LB      A, #022h               ; 0910 0 108 13D 7722
                STB     A, off(00133h)         ; 0912 0 108 13D D433

                                               ; 0914 from 0907 if [133h]+3 < r2
                                               ; 0914 from 090E just skips error code
label_0914:     ADDB    A, off(0013eh)         ; 0914 0 108 13D 873E
                JGE     label_091a             ; if result <= #ffh
                LB      A, #0ffh               ; else load in #ffh
                                               ; 091A from 0916 (DD0,108,13D)



                ;whats at 38c9 or 38d7?
label_091a:     STB     A, r2                  ; store the final ign...


				;example: a7h = 73h @ 4k rpm
				; r3 =~ 70h
                ; k   v   k   v   k   v   k   v   k   v   k   v   k
                ;FFh,A4h,D5h,9Ah,AAh,90h,70h,61h,40h,38h,1Ch,1Ch,00h
                MOV     X1, #038c9h            ;
                LB      A, 0a7h                ; 091E 0 108 13D F5A7
                VCAL    0                      ; 0920 0 108 13D 10
                STB     A, r3                  ; 0921 0 108 13D 8B

                ; k   v   k   v   k   v   k   v   k   v   k
                ;FFh,15h,A7h,33h,92h,40h,68h,66h,3Fh,C6h,00h
                MOV     X1, #038d7h            ; 0922 0 108 13D 60D738
                LB      A, 09ah                ; voltage
                VCAL    0                      ; interpolate

                ; so when normal running, A should be ~15h

                EXTND                          ; sign extend A
                MOVB    r0, r3                 ; move the RPM vcal above into r0
                MULB                           ; A = A*r0
                MOVB    r0, #0b3h              ; move #b3h
                SLL     A                      ; shift left
                JLT     label_093f             ; if carry jump and set A=#b3h
                SLL     A                      ; shift left
                JLT     label_093f             ; if carry jump and set A=#b3h
                LB      A, ACCH                ; AL = AH
                CMPB    A, r0                  ;
                JGE     label_093f             ; if A>= #b3h then jump to A=#b3h
                MOVB    r0, #00fh              ; r0 = 15
                CMPB    A, r0                  ;
                JGE     label_0940             ; if A<= #fh then jump to A=#fh
                                               ; 093F from 0930 (DD1,108,13D)
                                               ; 093F from 0933 (DD1,108,13D)
                                               ; 093F from 0938 (DD0,108,13D)
label_093f:     LB      A, r0                  ; 093F 0 108 13D 78
                                               ; 0940 from 093D (DD0,108,13D)


                ;right here #fh <= A <= #b3h



label_0940:     STB     A, ACCH                ; 0940 0 108 13D D507
                LB      A, r2                  ; 0942 0 108 13D 7A


                ;final ignition value!!!!!!!!!!!!!!!!!!!!!!
                ;ignition DONE.
                MOV     off(00134h), A         ; 134h = high byte calced from above and low byte ign value

;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
;*******************************************************************************************
;//////////////////////////////////////////////////////////////////////////////////////////
;it seems like this is where the fuel stuff starts
;so we either load up the limp mode/cranking stuff OR we
;grab the cell,do some corrections, then store
;the final fuel val


                LB      A, ADCR6H              ; Alternator
                STB     A, 0a5h                ; woo woooo

                JBS     off(0011fh).4, label_0950 ; if cranking then jump into this code
                J       label_0a1c             ; else skip all this code..



                ;based on the 11fh.4 check this may be the code that starts the engine
                ;*********************************************************************
                                               ; 0950 from 094A (DD0,108,13D)
label_0950:     JBR     off(00130h).5, label_096d ; if no ect sensor code

				;fuel calc if there is an ect code and in limp mode...
                CLR     A                      ; 0953 1 108 13D F9
                MOV     DP, #03b11h            ; 0954 1 108 13D 62113B
                LB      A, off(001e4h)         ; 0957 0 108 13D F4E4
                MOVB    r0, #014h              ; 0959 0 108 13D 9814
                DIVB                           ; 095B 0 108 13D A236
                EXTND                          ; 095D 1 108 13D F8
                SLL     A                      ; 095E 1 108 13D 53
                SUB     DP, A                  ; 095F 1 108 13D 92A1
                LC      A, [DP]                ; 0961 1 108 13D 92A8
                ST      A, off(00140h)         ; 0963 1 108 13D D440
                LC      A, 0000ah[DP]          ; 0965 1 108 13D 92A90A00
                ST      A, off(0016ch)         ; 0969 1 108 13D D46C
                SJ      label_097b             ; 096B 1 108 13D CB0E


                ; 096D from 0950 no ect code!
                ; now figure out the fuel...
label_096d:     LB      A, 0a3h                ; temp
                MOV     X1, #03951h            ; 096F 0 108 13D 605139
                JBS     off(0011ah).5, label_0978 ; 0972 0 108 13D ED1A03
                MOV     X1, #03966h            ; 0975 0 108 13D 606639
                                               ; 0978 from 0972 (DD0,108,13D)
label_0978:     VCAL    1                      ; 0978 0 108 13D 11
                STB     A, off(00140h)         ; fuel value: raw


                                               ; 097B from 096B (DD1,108,13D)
label_097b:     LB      A, 0bbh                ; rev count high byte

				;DB  030h,080h,012h,05Ah
                MOV     X1, #0394dh            ; rev scalar?
                ;between 80h and 5ah
                ;>401rpm, A = 5ah

                VCAL    2                      ;
                STB     A, off(00168h)         ; rpm rough calc?

                EXTND                          ;
                MOVB    r0, #080h              ; r0 = 80h
                MULB                           ; A = AL*r0, A = 2d00 if > 400 rpm
                MOV     er0, off(00140h)       ; load up the non vtec fuel value
                MUL                            ; er1A = er0*A

                MB      C, 0fdh.7              ;
                JLT     label_09a0             ;
                ROL     A                      ;
                ROL     er1                    ;
                JLT     label_099c             ;
                ROL     A                      ; 0997 1 108 13D 33
                ROL     er1                    ; 0998 1 108 13D 45B7
                JGE     label_09a0             ; 099A 1 108 13D CD04
                                               ; 099C from 0995 (DD1,108,13D)
label_099c:     MOV     er1, #0ffffh           ; 099C 1 108 13D 4598FFFF
                                               ; 09A0 from 0990 (DD1,108,13D)
                                               ; 09A0 from 099A (DD1,108,13D)
label_09a0:     MOV     off(00144h), er1       ; 09A0 1 108 13D 457C44
                L       A, off(0014ch)         ; 09A3 1 108 13D E44C
                ST      A, off(00146h)         ; 09A5 1 108 13D D446
                ADD     A, er1                 ; 09A7 1 108 13D 09
                JGE     label_09ad             ; 09A8 1 108 13D CD03
                L       A, #0ffffh             ; 09AA 1 108 13D 67FFFF
                                               ; 09AD from 09A8 (DD1,108,13D)
label_09ad:     ST      A, 0d6h                ; 09AD 1 108 13D D5D6
                ST      A, off(00148h)         ; store final fuel value

;startup final fuel val found!
;********************

                CMPB    0e6h, #004h            ; 09B1 1 108 13D C5E6C004
                JEQ     label_09bd             ; 09B5 1 108 13D C906
                MB      C, 0fdh.7              ; 09B7 1 108 13D C5FD2F
                JLT     label_09bd             ; 09BA 1 108 13D CA01
                CLR     A                      ; 09BC 1 108 13D F9
                                               ; 09BD from 09B5 (DD1,108,13D)
                                               ; 09BD from 09BA (DD1,108,13D)
label_09bd:     ST      A, 0d0h                ; 09BD 1 108 13D D5D0
                ST      A, 0d2h                ; 09BF 1 108 13D D5D2
                ST      A, 0d4h                ; 09C1 1 108 13D D5D4

                ;o2 sensors...
                L       A, #08000h             ; 09C3 1 108 13D 670080
                ST      A, off(00162h)         ;
                ST      A, off(00164h)         ;
                RB      off(0011bh).0          ; 09CA 1 108 13D C41B08
                RB      off(0011ch).0          ; 09CD 1 108 13D C41C08

                ;call inector routine
                CAL     label_2b25             ; 09D0 1 108 13D 32252B


                MOV     LRB, #00021h           ; 09D3 1 108 13D 572100
                RB      0feh.6                 ; 09D6 1 108 13D C5FE0E
                LB      A, 0e5h                ; 09D9 0 108 13D F5E5
                ADDB    A, #001h               ; 09DB 0 108 13D 8601
                ANDB    A, #003h               ; 09DD 0 108 13D D603
                STB     A, 0e5h                ; 09DF 0 108 13D D5E5

;********************************************************************
;ect related
                JBS     off(00130h).5, label_0a0e ; if ect sensor code
                MOV     X1, #03791h            ; 09E4 0 108 13D 609137
                L       A, #037a3h             ; 09E7 1 108 13D 67A337
                JBS     off(0011ah).5, label_09ee ; 09EA 1 108 13D ED1A01
                MOV     X1, A                  ; 09ED 1 108 13D 50
                                               ; 09EE from 09EA (DD1,108,13D)
label_09ee:     LB      A, 0a3h                ; 09EE 0 108 13D F5A3
                VCAL    1                      ; 09F0 0 108 13D 11
                CMPB    0a4h, #034h            ; useless
                JGE     label_09fa             ; stupid
                ADDB    A, #000h               ; code
                NOP                            ; 09F9 0 108 13D 00
                                               ; 09FA from 09F5 (DD0,108,13D)
label_09fa:     STB     A, off(0016ch)         ; 09FA 0 108 13D D46C

;*********************************************************************
;ect related

; A = vcal_0(a3h, #36f7h)
; A = A*8;
; A /= 2
; if(A > 100h)
;	A = 100h;
; [16ah] = A;
                LB      A, 0a3h                ; 09FC 0 108 13D F5A3
                MOV     X1, #036f7h            ; 09FE 0 108 13D 60F736
                VCAL    0                      ; 0A01 0 108 13D 10
                MOVB    r0, #008h              ; 0A02 0 108 13D 9808
                MULB                           ; 0A04 0 108 13D A234
                L       A, ACC                 ; 0A06 1 108 13D E506
                SRL     A                      ; 0A08 1 108 13D 63
                CMP     A, #00100h             ; 0A09 1 108 13D C60001
                JGE     label_0a11             ; 0A0C 1 108 13D CD03
                                               ; 0A0E from 09E1 (DD0,108,13D)
label_0a0e:     L       A, #00100h             ; 0A0E 1 108 13D 670001
                                               ; 0A11 from 0A0C (DD1,108,13D)
label_0a11:     ST      A, off(0016ah)         ; 0A11 1 108 13D D46A
                CLRB    off(0016eh)            ; 0A13 1 108 13D C46E15
                CAL     label_2fe0             ; 0A16 1 108 13D 32E02F
                J       label_1579             ; 0A19 1 108 13D 037915
                ;to here...



;***********************************************************************************
; Knock dealings?
; If so I am again confused. Why here? The final ign value has been found.

                ;NOT IN EURO PW0!!
label_0a1c:     MOVB    r7, #007h                ; 0A1C 0 108 13D 9F07
                MB      C, P2.4                  ; Limp mode bit check?
                ;JLT     label_0a99              ; if limp mode then skip this shit, y0
                SJ		label_0a99
                ;the mugen pr3 changes the above line to SJ
                ;I think it has something to do with knock sensor correction?

                ;
                CMPB    09eh, #01fh               ; brake switch
                JLT     label_0a99                ; if [9e]<1fh skip the rest of the code

                ;
                LB      A, off(0013dh)            ; load the knock correction
                								  ;

                JNE     label_0a99                ; if its != 0 skip the rest of the code

                ;probably telling us if its knocking or not.
                JBS     off(0012bh).2, label_0a5d ; related to ffh.0
                JBS     off(00119h).7, label_0a99 ; 0A30 0 108 13D EF1966
                JBS     off(00129h).3, label_0a45 ; vtec vss check bit
                LB      A, #0c6h                  ; ~3700 rpm
                JBR     off(0011ah).4, label_0a3d ;
                LB      A, #0c2h                  ; ~3600 rpm
                                                  ; 0A3D from 0A38 (DD0,108,13D)
label_0a3d:     CMPB    A, 0a6h				   	  ;compare a-rpm where a is c6 or c2 depending on 11Ah.4
                MB      off(0011ah).4, C          ; if cur rpm > c2 (or c6) then set 11ah.4
                JLT     label_0a99                ; if above is set then jump
                                                  ; 0A45 from 0A33 (DD0,108,13D)
label_0a45:     JBR     off(0011eh).4, label_0a59 ; if engine decelerating
                LB      A, 0a6h                   ; rpm

                ;vector at #03860h:
                ;FFh,10h,00h,E0h,10h,00h,D0h,20h,00h,B0h,30h,00h,
                ; A0h,40h,00h,80h,50h,00h,70h,60h,00h,50h,70h,00h,
                ; 40h,80h,00h,20h,90h,00h,10h,A0h,00h,00h
                MOV     X1, #03860h             ; some vector
                VCAL    1                       ; 0A4D 0 108 13D 11
                MOVB    r7, #007h               ; reset r7. But why? vcal_1 doesnt fuck it up.
                ; warning: had to flip DD
                CMP     A, 0bch                 ; A from vcal 1 compared to delta revs. Higher the rpm, the lower the revs
                JGE     label_0a59              ; if big change jump
                MOVB    off(001ech), #000h      ; else 1ec = 0
                                                ; 0A59 from 0A45 (DD0,108,13D)
                                                ; 0A59 from 0A53 (DD1,108,13D)
label_0a59:     LB      A, off(001ech)          ; 0A59 0 108 13D F4EC
                JNE     label_0a99              ; 0A5B 0 108 13D CE3C
                                                ; 0A5D from 0A2D (DD0,108,13D)
label_0a5d:     LB      A, 0a3h                 ; coolant temp
                MOVB    r7, #003h               ; r7 = 3
                CMPB    A, #023h                ; 117deg. C
                JLT     label_0a78              ; if temp > 117deg. C jump

                MOVB    r7, #005h               ; r7 = 5
                CMPB    A, #040h                ; 64deg. C
                JLT     label_0a78              ; if temp > 64deg. C jump

                MOVB    r7, #002h               ; r7 = 2
                CMPB    A, #06eh                ; 37deg. C
                JLT     label_0a87              ; if temp > 37deg. C jump

                DECB    r7                      ; r7 = 1
                CMPB    A, #0a1h                ; 25deg. C
                JLT     label_0a87              ; if temp > 25deg. C jump

                ;the motor is really cold if we get here
                SJ      label_0a96                ; 0A76 0 108 13D CB1E
                                                  ; 0A78 from 0A63 (DD0,108,13D)
                                                  ; 0A78 from 0A69 (DD0,108,13D)
label_0a78:     LB      A, #0c0h                  ; 0A78 0 108 13D 77C0
                JBR     off(0012bh).3, label_0a7f ; 0A7A 0 108 13D DB2B02
                LB      A, #0bch                  ; 0A7D 0 108 13D 77BC
                                                  ; 0A7F from 0A7A (DD0,108,13D)
label_0a7f:     CMPB    A, 0b4h                   ; 0A7F 0 108 13D C5B4C2
                MB      off(0012bh).3, C          ; 0A82 0 108 13D C42B3B
                JLT     label_0a98                ; 0A85 0 108 13D CA11
                                                  ; 0A87 from 0A6F (DD0,108,13D)
                                                  ; 0A87 from 0A74 (DD0,108,13D)
label_0a87:     LB      A, #0aeh                  ; 0A87 0 108 13D 77AE
                JBR     off(0012bh).4, label_0a8e ; 0A89 0 108 13D DC2B02
                LB      A, #0a7h                  ; 0A8C 0 108 13D 77A7
                                                  ; 0A8E from 0A89 (DD0,108,13D)
label_0a8e:     CMPB    A, 0b4h                   ; 0A8E 0 108 13D C5B4C2
                MB      off(0012bh).4, C          ; 0A91 0 108 13D C42B3C
                JLT     label_0a99                ; 0A94 0 108 13D CA03
                                                  ; 0A96 from 0A76 (DD0,108,13D)
label_0a96:     MOVB    r7, #0ffh                 ; 0A96 0 108 13D 9FFF
                                                  ; 0A98 from 0A85 (DD0,108,13D)
label_0a98:     INCB    r7                        ; 0A98 0 108 13D AF
                                                  ; 0A99 from 0A21 (DD0,108,13D)
                                                  ; 0A99 from 0A27 (DD0,108,13D)
                                                  ; 0A99 from 0A2B (DD0,108,13D)
                                                  ; 0A99 from 0A30 (DD0,108,13D)
                                                  ; 0A99 from 0A43 (DD0,108,13D)
                                                  ; 0A99 from 0A5B (DD0,108,13D)

                ;what the shit are we doing here w/ p1?
                ;does not touch P1.7
                ;if low vacuum (lots 'o throttle) then r7 = ffh;
                ;otherwise r7 is 7, 5, 3, 2, or 1
                                               ; 0A99 from 0A94 (DD0,108,13D)
label_0a99:     LB      A, r7                  ; 0A99 0 108 13D 7F
                SWAPB                          ; 0A9A 0 108 13D 83
                SRLB    A                      ; 0A9B 0 108 13D 63
                STB     A, r7                  ; 0A9C 0 108 13D 8F
                LB      A, P1                  ; 0A9D 0 108 13D F522
                ANDB    A, #0c7h               ; c7h = 11010111b
                ORB     A, r7                  ; 0AA1 0 108 13D 6F
                STB     A, P1                  ; 0AA2 0 108 13D D522
                ;euro pw0 missing code to here

;**********************
;fuel cell picking
;
;
                ;load fuel map
                MOVB    r6, 0b5h				;map image
                MOVB    r7, 0a6h				;rpm low byte
                MOV     X1, #03de4h             ;no vtec fuel map
                MOV     X2, #03bd6h				;no vtec rpm scalars
                MB      C, off(00129h).1        ;set carry to vtec bit 1
                MB      off(00129h).2, C        ;set vtec bit 2 to what vtec bit 1 was
                RB      PSWL.5					;reset program state word bit 5
                CAL     label_2cb3             ; interpolation
                CAL     label_2d3c             ; 0ABB 0 108 13D 323C2D
                STB     A, off(00140h)			;140h: non vtec fuel value

                MOVB    r6, 0b5h                ;map image
                MOVB    r7, 0a7h                ;rpm high byte
                MOV     X1, #03ef2h             ;vtec fuel map
                MOV     X2, #03be6h             ;vtec fuel map rpm scalars?
                RB      off(00129h).2          ; 0ACC 0 108 13D C4290A
                RB      PSWL.5                 ; show that we are reading fuel map
                CAL     label_2cb3             ; interpolation
                CAL     label_2d3c             ; 0AD4 0 108 13D 323C2D
                STB     A, off(00142h)			;142h: vtec fuel value


;end fuel cell picking
;*********************


                LB      A, #003h               ; 0AD9 0 108 13D 7703
                JBS     off(00120h).6, label_0ae0 ; 0ADB 0 108 13D EE2002
                LB      A, #008h               ; 0ADE 0 108 13D 7708
                                               ; 0AE0 from 0ADB (DD0,108,13D)
label_0ae0:     CMPB    A, 0a6h                ; 0AE0 0 108 13D C5A6C2
                MB      off(00120h).6, C       ; set if running...
                
                LB      A, #0c5h               ; 0AE6 0 108 13D 77C5
                JBS     off(00120h).5, label_0aed ; 0AE8 0 108 13D ED2002
                LB      A, #0c9h               ; 0AEB 0 108 13D 77C9
                                               ; 0AED from 0AE8 (DD0,108,13D)
label_0aed:     CMPB    A, 0a6h                ; 0AED 0 108 13D C5A6C2
                MB      off(00120h).5, C       ; set if rpm over ~5k?
                
                MOVB    r0, #020h              ; 0AF3 0 108 13D 9820
                JBS     off(00129h).3, label_0afa ; vtec vss check bit
                MOVB    r0, #028h              ; 0AF8 0 108 13D 9828
                                               ; 0AFA from 0AF5 (DD0,108,13D)

                ;vtec routine
label_0afa:     MOV     DP, #03ad8h				;load the start of the vtec vals into the DP
                MOV     X1, #03adch				;Load the lastvtec val+1 into x1
                LB      A, r0					;a=r0
                CMPB    A, 0cbh					; vtec vss check!
                ;SC								;ignore VSS check, set carry unconditionally
                ;NOP
                ;NOP
                MB      off(00129h).3, C		;if speed>A then set to 1
                LC      A, [DP]					;load 1st and 2nd vtec val into A
                INC     DP						;
                INC     DP						;3rd vtec val

                ;if vtec is already engaged then we use 1st val, else we load 2nd val (ACCH)
                JBS     off(00129h).4, label_0b10 ; already in vtec? if yes we jump and use current val as disengage
                LB      A, ACCH					  ; 2nd vtec val, vtec not engaged yet

label_0b10:     CMPB    A, 0a6h					;a-rpm
                MB      off(00129h).4, C		;if rpm>A (a is either vtec val1 or ?) set vtec.4 vtec engage
                LC      A, [DP]					;get 3rd and 4th vtec val; AL = 3rd, AH = 4th
                JBS     off(00129h).5, label_0b1d ; already in vtec? if yes we use 3rd as disengage
                LB      A, ACCH					;4th vtec val

label_0b1d:     CMPB    A, 0a6h					;3rd or 4th vtec val- rpm
                MB      off(00129h).5, C		;if rpm > val set to 1

                ;vector #3adch:
                ;FFh,76h,07h,F0h,76h,07h,E0h,76h,07h,D9h,26h,07h,D4h,5Ch,08h,CFh,2Ah,08h,00h,2Ah,08h
                LB      A, 0a6h					;load rpm into A
                VCAL    1                      ; A = interpolation
                STB     A, off(00154h)         ; vcal_1 value -> 154h

                ;codes 3 (MAP), 4(ckp), 5(map mechanical), 6(ect), 8(tdc sensor)
                LB      A, off(00130h)         ; load error byte 1
                ANDB    A, #0bch               ; bch = 10111100b
                JNE     label_0b38             ; if not 0 then we call foul
                MOV     er0, #0fcedh           ; save this for the special situation later...

                ;checks for error code 3
                ;if 132h == 0 then jump, no error
                ;error bits are .0, .4, .5 cause 31h == 00110001 binary
                ;its checking codes 17 (vss), 21 (vtec sol), and 22 (pressure switch)
                LB      A, off(00132h)         ; 0B32 0 108 13D F432
                ANDB    A, #031h               ; 0B34 0 108 13D D631
                ;JEQ     label_0b3d				;jump if 132.0, .4, and .5 are 0
                SJ		label_0b3d				;cel check disable
                                               ; 0B38 from 0B2C (DD0,108,13D)
                ;gets here if error codes
label_0b38:     SB      P1.1                   ; no vtec for you
                SJ      label_0b55             ; 0B3B 0 108 13D CB18
                                               ; 0B3D from 0B36 (DD0,108,13D)
                ;gets here if 132h == 0. no error
label_0b3d:     RB      P1.1                   ; does this "prime" the vtec?

				;sensor check? oil pressure?
                CMPB    0f8h, #000h            ; stock -> #032h
                ;NOP
                ;NOP
                JLT     label_0b55             ;

                ;coolant temp check. If temp byte >= specified. lower is hotter?
                CMPB    0a3h, #062h				; #044h      ;feels changed to: CMPB    0a3h, #062h
                ;JGE     label_0b55
                NOP		;temp check disable
                NOP

                ;JBR     off(00129h).3, label_0b55 ; feels changed to NOP NOP NOP; 0B4C 0 108 13D DB2906
                NOP
                NOP		;vss check disable
                NOP

                JBS     off(00129h).4, label_0b5d ; if rpm was > VTEC byte jump; 0B4F 0 108 13D EC290B
                JBS     off(00129h).7, label_0ba6 ; rpm was not high enough so check vtec.7  ; 0B52 0 108 13D EF2951
                                               ; 0B55 from 0B3B (DD0,108,13D)
                                               ; 0B55 from 0B44 (DD0,108,13D)
                                               ; 0B55 from 0B4A (DD0,108,13D)
                                               ; 0B55 from 0B4C (DD0,108,13D)
                ;if too cold (a3h)
                ;if too slow (129.3 == 0)
                ;if ram0F8h < 032h ??
                ;if error code 3 (132.0, .4, .5)
                ;if rpm<vtec byte and 129.7 == 0
label_0b55:     SB      P1.0                   ; 0B55 0 108 13D C52218
                RB      off(00129h).6          ; 0B58 0 108 13D C4290E
                SJ      label_0bb8             ; 0B5B 0 108 13D CB5B
                                               ; 0B5D from 0B4F (DD0,108,13D)
label_0b5d:     JBS     off(00129h).5, label_0b8a ; 0B5D 0 108 13D ED292A
                JBS     off(00120h).5, label_0b7e ; 0B60 0 108 13D ED201B
                JBS     off(00122h).0, label_0b8a ; 0B63 0 108 13D E82224
                                               ; 0B66 from 0B88 (DD1,108,13D)

               ;this is executed if rpm is > than ONLY the 2nd vtec byte
               ;special situation? when it only needs the 2nd vtec byte
label_0b66:     L       A, off(00140h)			;load the non vtec fuel value
                JBR     off(00129h).6, label_0b74 ; if not in vtec jump
                MUL                             ;Else er1,A = A*er0
												;A = no tec fuel value * fcedh
                L       A, er1                 ; A = overflow
                SUB     A, #00000h             ; set condition codes?
                JGE     label_0b74             ; always gonna jump. I think.
                CLR     A                      ; 0B73 1 108 13D F9
                                               ; 0B74 from 0B68 (DD1,108,13D)
                                               ; 0B74 from 0B71 (DD1,108,13D)
label_0b74:     CMP     A, off(00142h)			;compare A to the vtec fuel value
                JLT     label_0b8a             ; if A<[142h] engage

                ;this counter will keep it engaged until the counter =0
                LB      A, off(001d5h)         ; load counter; if vtec then this will be 14h
                JNE     label_0b8e             ; if [1d5h] != 0 then engage
                SJ      label_0ba6             ; else disengage
                ;end special situation
                                               ; 0B7E from 0B60 (DD0,108,13D)
label_0b7e:     L       A, 0d6h                     ; 0B7E 1 108 13D E5D6
                JBR     off(00129h).6, label_0b86   ; if no vtec jump
                ADD     A, #000a0h                  ; 0B83 1 108 13D 86A000
                                               ; 0B86 from 0B80 (DD1,108,13D)
label_0b86:     CMP     A, off(00154h)			;if vtec is NOT on then A = ramD6h else A = ramD6h+#A0h
                JLT     label_0b66             ; if A<[154h] jump to special situation
                                               ; 0B8A from 0B5D (DD0,108,13D)
                                               ; 0B8A from 0B63 (DD0,108,13D)
                                               ; 0B8A from 0B76 (DD1,108,13D)

                ;gets here if all systems are go and vtec needs to be activated
label_0b8a:     MOVB    off(001d5h), #014h     ; reset the engage-to-disengage counter
                                               ; 0B8E from 0B7A (DD0,108,13D)
label_0b8e:     RB      P1.0                   ; does this actually tell the vtec sol to go?
                SB      off(00129h).6          ; 0B91 0 108 13D C4291E
                MB      C, 0ffh.2              ; vtec solenoid feedback???
                JGE     label_0bb4             ; 0B97 0 108 13D CD1B

                ;we are here when...
                                               ; 0B99 from 0BB2 (DD0,108,13D)
label_0b99:     LB      A, off(001b0h)         ; 0B99 0 108 13D F4B0
                JNE     label_0bbc             ; 0B9B 0 108 13D CE1F
                MOVB    off(001b1h), #00ah     ; 0B9D 0 108 13D C4B1980A

                                               ; 0BA1 from 0BB6 (DD0,108,13D)
                ;set vtec byte .7
label_0ba1:     SB      off(00129h).7          ; 0BA1 0 108 13D C4291F
                SJ      label_0bbf             ; 0BA4 0 108 13D CB19


                ;this is the disengage
                                               ; 0BA6 from 0B52 (DD0,108,13D)
                                               ; 0BA6 from 0B7C (DD0,108,13D)
label_0ba6:     CLRB    off(001d5h)            ; 0BA6 0 108 13D C4D515
                SB      P1.0                   ; 0BA9 0 108 13D C52218
                RB      off(00129h).6          ; 0BAC 0 108 13D C4290E
                MB      C, 0ffh.2              ; vtec solenoid feedback????
                JLT     label_0b99             ; 0BB2 0 108 13D CAE5

                ;we are here if the vtec is currently on but needs to be shut off.
                ;so we check this counter and if it is not 0 (which means not enough time
                ;has passed) then we just reset the vtec bit to 1
                                               ; 0BB4 from 0B97 (DD0,108,13D)
label_0bb4:     LB      A, off(001b1h)         ; check disengage counter
                JNE     label_0ba1             ; if counter != 0, then jump and turn the vtec byte on

                                               ; 0BB8 from 0B5B (DD0,108,13D)
label_0bb8:     MOVB    off(001b0h), #00ah     ; 0BB8 0 108 13D C4B0980A
;reset vtec.7
                                               ; 0BBC from 0B9B (DD0,108,13D)
label_0bbc:     RB      off(00129h).7          ; 0BBC 0 108 13D C4290F

				;end vtec routine
;****************************************************************************
;1a2h
                                               ; 0BBF from 0BA4 (DD0,108,13D)
label_0bbf:     JBS     off(00123h).3, label_0bdc ; 0BBF 0 108 13D EB231A
                CMPB    0a3h, #001h            ; 0BC2 0 108 13D C5A3C001
                JGE     label_0bdd             ; 0BC6 0 108 13D CD15
                CAL     label_3156             ; 0BC8 0 108 13D 325631

                ;_3156
                ;LB      A, #0ffh               ; 3156 0 108 13D 77FF
                ;CMPB    A, 0a6h                ; 3158 0 108 13D C5A6C2
                ;RT                             ; 315B 0 108 13D 01

                NOP                            ; 0BCB 0 108 13D 00
                JGE     label_0bdd             ; 0BCC 0 108 13D CD0F
                JBS     off(00123h).0, label_0bdd ; 0BCE 0 108 13D E8230C
                JBS     off(0011eh).4, label_0bdc ; 0BD1 0 108 13D EC1E08
                L       A, #0ffffh             ; 0BD4 1 108 13D 67FFFF
                CMP     A, 0bch                ; compare delta revs to ffffh
                JLT     label_0bdd             ; 0BDA 1 108 13D CA01
                                               ; 0BDC from 0BBF (DD0,108,13D)
                                               ; 0BDC from 0BD1 (DD0,108,13D)
label_0bdc:     RC                             ; 0BDC 1 108 13D 95
                                               ; 0BDD from 0BC6 (DD0,108,13D)
                                               ; 0BDD from 0BCC (DD0,108,13D)
                                               ; 0BDD from 0BCE (DD0,108,13D)
                                               ; 0BDD from 0BDA (DD1,108,13D)
label_0bdd:     MB      off(00123h).0, C       ; 0BDD 1 108 13D C42338
                MB      C, off(00123h).1       ; 0BE0 1 108 13D C42329
                MB      off(00123h).2, C       ; 0BE3 1 108 13D C4233A
                MB      C, 0feh.6              ; 0BE6 1 108 13D C5FE2E
                MB      off(00123h).1, C       ; 0BE9 1 108 13D C42339

                ;this is mainly the whole 1a2h value:
                MOV     X1, #0392ch            ; 0BEC 1 108 13D 602C39
                LB      A, 0a6h                ; 0BEF 0 108 13D F5A6
                VCAL    0                      ; 0BF1 0 108 13D 10
                STB     A, off(001a2h)         ; 0BF2 0 108 13D D4A2

;********************************************
;1a0h

                MOVB    r6, #040h              ; 0BF4 0 108 13D 9E40
                L       A, #0602eh             ; 0BF6 1 108 13D 672E60
                MOV     X1, #03936h            ; 0BF9 1 108 13D 603639
                MOV     DP, #03942h            ; 0BFC 1 108 13D 624239
                ST      A, er1                 ; 0BFF 1 108 13D 89
                LB      A, 0a3h                ; 0C00 0 108 13D F5A3
                CMPB    A, r2                  ; [a3h] cmpb #2eh
                JLT     label_0c06             ; 0C03 0 108 13D CA01
                VCAL    0                      ; 0C05 0 108 13D 10
                                               ; 0C06 from 0C03 (DD0,108,13D)
label_0c06:     LB      A, r6                  ; 0C06 0 108 13D 7E
                JBR     off(0012ah).3, label_0c0e ; 0C07 0 108 13D DB2A04
                CMPB    A, r3                  ; 0C0A 0 108 13D 4B
                JGE     label_0c0e             ; 0C0B 0 108 13D CD01
                LB      A, r3                  ; 0C0D 0 108 13D 7B
                                               ; 0C0E from 0C07 (DD0,108,13D)
                                               ; 0C0E from 0C0B (DD0,108,13D)
label_0c0e:     JBR     off(00120h).4, label_0c16 ; 0C0E 0 108 13D DC2005
                SUBB    A, #01ch               ; 0C11 0 108 13D A61C
                JGE     label_0c16             ; 0C13 0 108 13D CD01
                CLRB    A                      ; 0C15 0 108 13D FA
                                               ; 0C16 from 0C0E (DD0,108,13D)
                                               ; 0C16 from 0C13 (DD0,108,13D)
label_0c16:     STB     A, r6                  ; 0C16 0 108 13D 8E
                STB     A, off(001a0h)         ; 0C17 0 108 13D D4A0

;********************************************
;1a1h
                LB      A, r2                  ; 0C19 0 108 13D 7A
                J       label_32c3             ; 0C1A 0 108 13D 03C332
                ;32c3
                ;CMPB    A, 0a3h                ; 32C3 0 108 13D C5A3C2
				;JGT     label_32cb             ; 32C6 0 108 13D C803
                ;J       label_0c1f             ; 32C8 0 108 13D 031F0C

                DW  00000h           ; 0C1D
                                               ; 0C1F from 32C8 (DD0,108,13D)
label_0c1f:     INC     DP                     ; 0C1F 0 108 13D 72
                JBS     off(00123h).7, label_0c27 ; 0C20 0 108 13D EF2304
                JBS     off(00124h).2, label_0c27 ; 0C23 0 108 13D EA2401
                INC     DP                     ; 0C26 0 108 13D 72
                                               ; 0C27 from 32D5 (DD0,108,13D)
                                               ; 0C27 from 0C20 (DD0,108,13D)
                                               ; 0C27 from 0C23 (DD0,108,13D)
label_0c27:     LCB     A, [DP]                ; 0C27 0 108 13D 92AA
                                               ; 0C29 from 32D8 (DD0,108,13D)
label_0c29:     ADDB    A, r6                  ; 0C29 0 108 13D 0E
                JGE     label_0c2e             ; 0C2A 0 108 13D CD02
                LB      A, #0ffh               ; 0C2C 0 108 13D 77FF
                                               ; 0C2E from 0C2A (DD0,108,13D)
label_0c2e:     STB     A, off(001a1h)         ; 0C2E 0 108 13D D4A1

;*******************************************
                JBR     off(00123h).1, label_0c34 ; 0C30 0 108 13D D92301
                LB      A, r6                  ; 0C33 0 108 13D 7E



                                               ; 0C34 from 0C30 (DD0,108,13D)
label_0c34:     CMPB    A, 0a6h                ; 0C34 0 108 13D C5A6C2
                MB      off(00121h).4, C       ; 0C37 0 108 13D C4213C

;*********************************************************
;revlimit
;lo cam rev is 3918h
;high cam is 391ah

                MOV     DP, #03918h             ; load first revlimit from revlimits list
                L       A, #03920h              ;
                MOV     er0, #00000h			; feels -> #00270h, stock -> #003cfh, maybe speed lim?
                MB      C, 0feh.7				; if this bit then DP -> 3920h (restart) else DP->3918h (limit)
                JGE     label_0c4e              ; if not on revlimt jump
                MOV     DP, A                   ; load restart addy
                MOV     er0, #00002h			; feels -> #00270h, stock -> #003f1h, speed lim restart?

                                                ; 0C4E from 0C47 (DD1,108,13D)
label_0c4e:     L       A, 0c4h					; load speed word
                CMP     A, er0                  ; compare to speed to limiter values
                JLT     label_0c62				; DP-> lo cam revlimit/restart if over speed

                INC     DP                      ; DP++;
                INC     DP						; DP -> high cam revlimit/restart
                JBS     off(00129h).7, label_0c62 ;if vtec
                INC     DP                      ; DP++
                INC     DP                      ; DP++ -> low cam hot limit
                CMPB    0a3h, #02eh				; temp check
                JLT     label_0c62				; if its hot enough, jump
                INC     DP                      ;
                INC     DP                      ; lowcam cold limit
                                                ; 0C62 from 0C51 (DD1,108,13D)
                                                ; 0C62 from 0C55 (DD1,108,13D)
                                                ; 0C62 from 0C5E (DD1,108,13D)

label_0c62:		LC      A, [DP]					; load the limit rpm from rom
			 ;  MB      C, P2.4					; this line is in launch
				CAL		launch					; if speed < specified then we set the limit (A) to FTL limit
                JLT     label_0c6c              ; if limp mode jump
                JBR     off(00131h).7, label_0c6f ; if no injector system code (16) then jump with limit byte
                                               ; 0C6C from 0C67 (DD1,108,13D)

                ;is this the limp mode limit? ~3125 rpm
label_0c6c:     L       A, #00240h             ;
			                                   ; 0C6F from 0C69 (DD1,108,13)

label_0c6f:		CMP     0bah, A					; compare rev count to revlimit byte
                MB      0feh.7, C				; set fe.7 to carry from [BAh]-limit byte
                JLT     label_0ca1             ; if we need to get on the revlimit, jump
                SC                             ; else
                JBS     off(00131h).5, label_0c82 ; if IACV code??
                JBS     off(0012dh).0, label_0c82 ; iacv??
                CMPB    0a9h, #010h            ; Check PA sensor
                                               ; 0C82 from 0C78 (DD1,108,13D)
                                               ; 0C82 from 0C7B (DD1,108,13D)

                ;******
                ;WTF does this do?
                ;revlimit? why?

                ; so if
                ; PAP<1.33Volt and RPM>3000 or PAP<0.98Volt and RPM>1400
                ; then cut fuel

                ;mugen PR3 skips this:
                ;with J		label_0ca1 <- mugen
label_0c82:     MB      off(00127h).3, C       ; if theres an iacv code or [a9h]<#10h then set this
                JGE     label_0ca1             ; if [A9h]>#10h jump
                LB      A, #097h               ;
                JBS     off(00130h).6, label_0c99 ; if tps code
                JBS     off(0012ch).2, label_0c99 ; set in TPS function if 130.6 is set
                LB      A, 0ach				   ; load TPS
                CMPB    A, #044h               ;
                JGE     label_0cb0             ; if throttle > 30% jump
                MOV     X1, #03928h            ; 0C95 0 108 13D 602839
                ;3928h:
                ;044h,0A9h,032h,062h,0FFh

                VCAL    2                      ; 0C98 0 108 13D 12

                ;if there is a TPS code for some reason
                ;there will be a revlimit @ 2459
label_0c99:     CMPB    A, 0a6h                ; 0C99 0 108 13D C5A6C2
                MB      0feh.7, C              ; 0C9C 0 108 13D C5FE3F
                SJ      label_0cb0             ; 0C9F 0 108 13D CB0F
                ;to here
                ;*******

;revlimit code done....
;****************************************************
                                               ; 0CA1 from 0C75 (DD1,108,13D)
                                               ; 0CA1 from 0C85 (DD1,108,13D)

label_0ca1:     JBS     off(00123h).0, label_0cd6 ; 0CA1 1 108 13D E82332
                LB      A, off(001e3h)         ; 0CA4 0 108 13D F4E3
                JNE     label_0cd6             ; 0CA6 0 108 13D CE2E
                JBS     off(00123h).3, label_0cb0 ; 0CA8 0 108 13D EB2305
                MOVB    r7, #001h              ; 0CAB 0 108 13D 9F01
                JBS     off(00121h).4, label_0ccd ; 0CAD 0 108 13D EC211D
                                               ; 0CB0 from 0C93 (DD0,108,13D)
                                               ; 0CB0 from 0C9F (DD0,108,13D)
                                               ; 0CB0 from 0CA8 (DD0,108,13D)
label_0cb0:     LB      A, #086h               ; 0CB0 0 108 13D 7786
                JBR     off(00120h).7, label_0cb7 ; 0CB2 0 108 13D DF2002
                LB      A, #07eh               ; 0CB5 0 108 13D 777E
                                               ; 0CB7 from 0CB2 (DD0,108,13D)
label_0cb7:     CMPB    A, 0a6h                ; 0CB7 0 108 13D C5A6C2
                MB      off(00120h).7, C       ; 0CBA 0 108 13D C4203F

;********************************************

                JGE     label_0cd6             ; 0CBD 0 108 13D CD17
                CLRB    r7                     ; 0CBF 0 108 13D 2715
                LB      A, off(001a2h)         ; 0CC1 0 108 13D F4A2
                JBR     off(00123h).1, label_0cc8 ; 0CC3 0 108 13D D92302
                ADDB    A, #009h               ; 0CC6 0 108 13D 8609
                                               ; 0CC8 from 0CC3 (DD0,108,13D)
label_0cc8:     CMPB    0b4h, A                ; 0CC8 0 108 13D C5B4C1
                JGE     label_0cd6             ; 0CCB 0 108 13D CD09
                                               ; 0CCD from 0CAD (DD0,108,13D)
label_0ccd:     LB      A, off(001d6h)         ; 0CCD 0 108 13D F4D6
                JNE     label_0d21             ; skip some bit setting
                SC                             ; 0CD1 0 108 13D 85
                CLRB    r7                     ; 0CD2 0 108 13D 2715
                SJ      label_0d22             ; skip some bit setting
                                               ; 0CD6 from 0CA1 (DD1,108,13D)
                                               ; 0CD6 from 0CA6 (DD0,108,13D)
                                               ; 0CD6 from 0CBD (DD0,108,13D)
                                               ; 0CD6 from 0CCB (DD0,108,13D)
label_0cd6:     MOV     DP, #03916h            ; 0CD6 1 108 13D 621639
                CMPB    0a3h, #080h            ; 0CD9 1 108 13D C5A3C080
                JLT     label_0ce5             ; 0CDD 1 108 13D CA06
                CMPB    0f9h, #00ah            ; 0CDF 1 108 13D C5F9C00A
                JLT     label_0ced             ; 0CE3 1 108 13D CA08
                                               ; 0CE5 from 0CDD (DD1,108,13D)
label_0ce5:     DEC     DP                     ; 0CE5 1 108 13D 82
                DEC     DP                     ; 0CE6 1 108 13D 82
                RC                             ; 0CE7 1 108 13D 95
                JBS     off(00118h).7, label_0ced ; 0CE8 1 108 13D EF1802
                DEC     DP                     ; 0CEB 1 108 13D 82
                DEC     DP                     ; 0CEC 1 108 13D 82
                                               ; 0CED from 0CE3 (DD1,108,13D)
                                               ; 0CED from 0CE8 (DD1,108,13D)
label_0ced:     MB      off(0011dh).6, C       ; 0CED 1 108 13D C41D3E

;********************************************

                CMPB    0a3h, #032h            ; 0CF0 1 108 13D C5A3C032
                JGE     label_0d12             ; 0CF4 1 108 13D CD1C
                JBR     off(00124h).3, label_0d12 ; 0CF6 1 108 13D DB2419
                LB      A, #089h               ; 0CF9 0 108 13D 7789
                MOVB    r0, #077h              ; 0CFB 0 108 13D 9877
                JBS     off(00123h).6, label_0d04 ; 0CFD 0 108 13D EE2304
                LB      A, #091h               ; 0D00 0 108 13D 7791
                MOVB    r0, #09ch              ; 0D02 0 108 13D 989C
                                               ; 0D04 from 0CFD (DD0,108,13D)
label_0d04:     CMPB    A, 0a6h                ; 0D04 0 108 13D C5A6C2
                JLT     label_0d0d             ; 0D07 0 108 13D CA04
                LB      A, r0                  ; 0D09 0 108 13D 78
                CMPB    A, 0b4h                ; 0D0A 0 108 13D C5B4C2
                                               ; 0D0D from 0D07 (DD0,108,13D)
label_0d0d:     MB      off(00123h).6, C       ; 0D0D 0 108 13D C4233E

;********************************************

                JGE     label_0d16             ; 0D10 0 108 13D CD04
                                               ; 0D12 from 0CF4 (DD1,108,13D)
                                               ; 0D12 from 0CF6 (DD1,108,13D)
label_0d12:     MOVB    off(001d7h), #00fh     ; 0D12 0 108 13D C4D7980F
                                               ; 0D16 from 0D10 (DD0,108,13D)
label_0d16:     LB      A, off(001d7h)         ; 0D16 0 108 13D F4D7
                JEQ     label_0d1b             ; 0D18 0 108 13D C901
                INC     DP                     ; 0D1A 0 108 13D 72
                                               ; 0D1B from 0D18 (DD0,108,13D)
label_0d1b:     LCB     A, [DP]                ; 0D1B 0 108 13D 92AA
                STB     A, off(001d6h)         ; 0D1D 0 108 13D D4D6

;********************************************

                CLRB    r7                     ; 0D1F 0 108 13D 2715
                                               ; 0D21 from 0CCF (DD0,108,13D)
label_0d21:     RC                             ; 0D21 0 108 13D 95
                                               ; 0D22 from 0CD4 (DD0,108,13D)
label_0d22:     MB      0feh.6, C              ; 0D22 0 108 13D C5FE3E
                SRLB    r7                     ; 0D25 0 108 13D 27E7
                MB      off(00120h).4, C       ; 0D27 0 108 13D C4203C

;********************************************

                MOVB    r0, #04ch              ; 0D2A 0 108 13D 984C
                MOVB    r1, #04ch              ; 0D2C 0 108 13D 994C
                MOVB    r2, #043h              ; 0D2E 0 108 13D 9A43
                MOVB    r3, #051h              ; 0D30 0 108 13D 9B51
                JBR     off(0012bh).2, label_0d3d ; 0D32 0 108 13D DA2B08
                MOVB    r0, #04ch              ; 0D35 0 108 13D 984C
                MOVB    r1, #04ch              ; 0D37 0 108 13D 994C
                MOVB    r2, #043h              ; 0D39 0 108 13D 9A43
                MOVB    r3, #051h              ; 0D3B 0 108 13D 9B51
                                               ; 0D3D from 0D32 (DD0,108,13D)
label_0d3d:     JBS     off(00120h).5, label_0d5e ; 0D3D 0 108 13D ED201E
                JBR     off(00122h).0, label_0d8f ; 0D40 0 108 13D D8224C
                LB      A, #03eh               ; 0D43 0 108 13D 773E
                JBS     off(00122h).1, label_0d4a ; 0D45 0 108 13D E92202
                LB      A, #046h               ; 0D48 0 108 13D 7746
                                               ; 0D4A from 0D45 (DD0,108,13D)
label_0d4a:     CMPB    A, 0a6h                ; 0D4A 0 108 13D C5A6C2
                MB      off(00122h).1, C       ; 0D4D 0 108 13D C42239

;********************************************

                MOVB    r1, #051h              ; 0D50 0 108 13D 9951
                JGE     label_0d9b             ; 0D52 0 108 13D CD47
                MOVB    r1, r0                 ; 0D54 0 108 13D 2049
                LB      A, off(001e7h)         ; 0D56 0 108 13D F4E7
                JEQ     label_0d9b             ; 0D58 0 108 13D C941
                MOVB    r1, #04ch              ; 0D5A 0 108 13D 994C
                SJ      label_0d9b             ; 0D5C 0 108 13D CB3D

;*******
                                               ; 0D5E from 0D3D (DD0,108,13D)
label_0d5e:     LB      A, #0c2h               ; 0D5E 0 108 13D 77C2
                JBS     off(0012bh).6, label_0d65 ; 0D60 0 108 13D EE2B02
                LB      A, #0c8h               ; 0D63 0 108 13D 77C8
                                               ; 0D65 from 0D60 (DD0,108,13D)
label_0d65:     CMPB    A, 0b4h                ; 0D65 0 108 13D C5B4C2
                MB      off(0012bh).6, C       ; 0D68 0 108 13D C42B3E
                JLT     label_0d9b             ; 0D6B 0 108 13D CA2E

;********************************************


                ;open loop?
                LB      A, #0d2h               ; 0D6D 0 108 13D 77D2
                JBS     off(0012bh).7, label_0d74 ; 0D6F 0 108 13D EF2B02
                LB      A, #0ddh               ; 0D72 0 108 13D 77DD
                                               ; 0D74 from 0D6F (DD0,108,13D)
label_0d74:     CMPB    A, 0ach                ; 0D74 0 108 13D C5ACC2
                MB      off(0012bh).7, C       ; 0D77 0 108 13D C42B3F
                JLT     label_0d9b             ; 0D7A 0 108 13D CA1F

;********************************************

                LB      A, #0a5h               ; 0D7C 0 108 13D 77A5
                JBS     off(0012bh).5, label_0d83 ; 0D7E 0 108 13D ED2B02
                LB      A, #0adh               ; 0D81 0 108 13D 77AD
                                               ; 0D83 from 0D7E (DD0,108,13D)
label_0d83:     CMPB    A, 0b4h                ; 0D83 0 108 13D C5B4C2
                MB      off(0012bh).5, C       ; 0D86 0 108 13D C42B3D

;********************************************
                JGE     label_0d8f             ; 0D89 0 108 13D CD04
                MOVB    r1, r2                 ; 0D8B 0 108 13D 2249
                SJ      label_0d9b             ; 0D8D 0 108 13D CB0C
                                               ; 0D8F from 0D40 (DD0,108,13D)
                                               ; 0D8F from 0D89 (DD0,108,13D)
label_0d8f:     MOVB    off(001e7h), #000h     ; 0D8F 0 108 13D C4E79800
                MOVB    off(001c1h), #082h     ; 0D93 0 108 13D C4C19882
                LB      A, #040h               ; 0D97 0 108 13D 7740
                SJ      label_0dc2             ; 0D99 0 108 13D CB27
                                               ; 0D9B from 0D52 (DD0,108,13D)
                                               ; 0D9B from 0D58 (DD0,108,13D)
                                               ; 0D9B from 0D5C (DD0,108,13D)
                                               ; 0D9B from 0D6B (DD0,108,13D)
                                               ; 0D9B from 0D7A (DD0,108,13D)
                                               ; 0D9B from 0D8D (DD0,108,13D)
label_0d9b:     JBR     off(00120h).5, label_0daa ; 0D9B 0 108 13D DD200C
                CMPB    0a3h, #013h            ; 0D9E 0 108 13D C5A3C013
                JLT     label_0dbf             ; 0DA2 0 108 13D CA1B
                LB      A, off(001c1h)         ; 0DA4 0 108 13D F4C1
                JEQ     label_0dbf             ; 0DA6 0 108 13D C917
                SJ      label_0dc1             ; 0DA8 0 108 13D CB17
                                               ; 0DAA from 0D9B (DD0,108,13D)
label_0daa:     LB      A, #077h               ; 0DAA 0 108 13D 7777
                JBR     off(0011ah).3, label_0db1 ; 0DAC 0 108 13D DB1A02
                LB      A, #069h               ; 0DAF 0 108 13D 7769
                                               ; 0DB1 from 0DAC (DD0,108,13D)
label_0db1:     CMPB    A, 0a6h                ; 0DB1 0 108 13D C5A6C2
                MB      off(0011ah).3, C       ; 0DB4 0 108 13D C41A3B
                JGE     label_0dc1             ; 0DB7 0 108 13D CD08

;********************************************

                CMPB    0a3h, #018h            ; 0DB9 0 108 13D C5A3C018
                JGE     label_0dc1             ; 0DBD 0 108 13D CD02
                                               ; 0DBF from 0DA2 (DD0,108,13D)
                                               ; 0DBF from 0DA6 (DD0,108,13D)
label_0dbf:     MOVB    r1, r3                 ; 0DBF 0 108 13D 2349
                                               ; 0DC1 from 0DA8 (DD0,108,13D)
                                               ; 0DC1 from 0DB7 (DD0,108,13D)
                                               ; 0DC1 from 0DBD (DD0,108,13D)
label_0dc1:     LB      A, r1                  ; 0DC1 0 108 13D 79
                                               ; 0DC2 from 0D99 (DD0,108,13D)
label_0dc2:     STB     A, off(0015bh)         ; 0DC2 0 108 13D D45B

;end 15bh correction
;*******************************************************************
;start o2 stuff...

                CLRB    r7                     ; r7 = 0
                
                ;this may be error checking. if r7 == 0, then error?
                LB      A, off(0016fh)         ; ?
                JNE     label_0df0             ; 
                JBS     off(00122h).0, label_0df0 ; 0DCA 0 108 13D E82223
                JBR     off(00120h).6, label_0df0 ; if the car is not running, jump
                MB      C, 0feh.6              ; load bad ignition bit
                JLT     label_0df0             ; if ignition problems, jump
                
                
                INCB    r7                     ; r7 = 1
                
                JBR     off(00120h).5, label_0df0 ; jump with r7 == 1; this bit is set if RPM is over ~5k
                
                ;could be the values for the switch FROM open -> closed loop.
                LB      A, #0e9h               ; 0DD9 0 108 13D 77E9
                MOVB    r0, #055h              ; 0DDB 0 108 13D 9855
                
                JBR     off(0011dh).0, label_0de4 ; if bit == 0, jump
                
                ;could vals for the switch TO open loop?
                LB      A, #0ech               ; 0DE0 0 108 13D 77EC
                MOVB    r0, #064h              ; 0DE2 0 108 13D 9864
                
                
                                               ; 0DE4 from 0DDD (DD0,108,13D)
label_0de4:     CMPB    A, 0a6h                ; 
                JLT     label_0df0             ; if RPM over ~6k, jump
                LB      A, r0                  ; 
                CMPB    A, 0b4h                ; if we are over column 5 or 6 in the fuel table
                JLT     label_0df0             ; JUMP!
                INCB    r7                     ; else we are under ~6k and in table col 0 - 5; r7 = 2
                
                                               ; 0DF0 from 0DC8 (DD0,108,13D)
                                               ; 0DF0 from 0DCA (DD0,108,13D)
                                               ; 0DF0 from 0DCD (DD0,108,13D)
                                               ; 0DF0 from 0DD3 (DD0,108,13D)
                                               ; 0DF0 from 0DD6 (DD0,108,13D)
                                               ; 0DF0 from 0DE7 (DD0,108,13D)
                                               ; 0DF0 from 0DED (DD0,108,13D)
label_0df0:     LB      A, r7                  ; A = r7; will be 0000b, 0001b, or 0010b
                SRLB    A                      ; shift right. C = r7.0
                MB      off(0011ch).7, C       ; 
                MB      C, off(0011dh).1       ; 
                MB      off(0011dh).2, C       ; 
                MB      C, off(0011dh).0       ; 
                MB      off(0011dh).1, C       ; 
                SRLB    A                      ; 
                MB      off(0011dh).0, C       ; 0011dh.0 gets 1 when we are below the rpm/map

                ;call o2 sensor routine1
                ;DP = 11bh
                CAL     label_2f1f             ; put o2 value into ram and r6. r7 gets TM0.0 &.1 + TMR0.6 & .7
                MB      C, off(0019ah).3       ; 0E08 0 108 13D C49A2B
                JBS     off(0011eh).2, label_0e11 ; 0E0B 0 108 13D EA1E03
                MB      C, off(0019ah).2       ; 0E0E 0 108 13D C49A2A
                                               ; 0E11 from 0E0B (DD0,108,13D)
label_0e11:     JGE     label_0e17             ; if 19a.2/.3 == 0 then jump

				;call 2nd o2 sensor routine
				;DP = 11ch
                CAL     label_2f39             ; r6 gets o2 val, r7 *= 2
                SC                             ; lets us know that we are using the 2nd o2?

                                               ; 0E17 from 0E11 (DD0,108,13D)
label_0e17:     MB      r7.7, C                ; 0E17 0 108 13D 273F

                L       A, off(001bch)         ; 0E19 1 108 13D E4BC
                JEQ     label_0e20             ; 0E1B 1 108 13D C903
                DEC     off(001bch)            ; 0E1D 1 108 13D B4BC17
                                               ; 0E20 from 0E1B (DD1,108,13D)
label_0e20:     L       A, off(001beh)         ; 0E20 1 108 13D E4BE
                JEQ     label_0e27             ; 0E22 1 108 13D C903
                DEC     off(001beh)            ; 0E24 1 108 13D B4BE17
                                               ; 0E27 from 0E22 (DD1,108,13D)
label_0e27:     MOV     er2, #08000h           ; 0E27 1 108 13D 46980080

				;cel checking...
                JBS     off(00130h).2, label_0e6b ; if map code
                JBS     off(00130h).4, label_0e6b ; if map code 2
                MOV     er2, #08000h           ; redundant...
                JBS     off(00130h).5, label_0e6b ; if ect sensor
                JBS     off(00130h).6, label_0e6b ; if tps
                JBS     off(0010fh).0, label_0e6b ; 0E3B 1 108 13D E80F2D
                JBS     off(0010fh).6, label_0e68 ; 0E3E 1 108 13D EE0F27
                JBR     off(0011eh).1, label_0e6b ; 0E41 1 108 13D D91E27

                MB      C, [DP].3              ; 0E44 1 108 13D C22B
                JGE     label_0e4c             ; 0E46 1 108 13D CD04
                LB      A, (00197h-0013dh)[USP] ; 0E48 0 108 13D F35A
                JEQ     label_0e51             ; 0E4A 0 108 13D C905
                                               ; 0E4C from 0E46 (DD1,108,13D)
label_0e4c:     JBR     off(0011fh).5, label_0e6b ; 0E4C 0 108 13D DD1F1C
                SJ      label_0e68             ; 0E4F 0 108 13D CB17
                                               ; 0E51 from 0E4A (DD0,108,13D)
label_0e51:     LB      A, #000h               ; 0E51 0 108 13D 7700
                JBS     off(00122h).0, label_0e65 ; 0E53 0 108 13D E8220F
                JBS     off(0011dh).0, label_0e6e ; 0E56 0 108 13D E81D15
                JBS     off(00120h).5, label_0e68 ; 0E59 0 108 13D ED200C
                JBS     off(0011ch).7, label_0e6e ; 0E5C 0 108 13D EF1C0F
                JBR     off(00120h).6, label_0e68 ; 0E5F 0 108 13D DE2006
                J       label_100c             ; 0E62 0 108 13D 030C10
                                               ; 0E65 from 0E53 (DD0,108,13D)
label_0e65:     J       label_0feb             ; 0E65 0 108 13D 03EB0F
                                               ; 0E68 from 0E3E (DD1,108,13D)
                                               ; 0E68 from 0E4F (DD0,108,13D)
                                               ; 0E68 from 0E59 (DD0,108,13D)
                                               ; 0E68 from 0E5F (DD0,108,13D)
label_0e68:     J       label_1022             ; 0E68 1 108 13D 032210

				;error...
                                               ; 0E6B from 0E2B (DD1,108,13D)
                                               ; 0E6B from 0E2E (DD1,108,13D)
                                               ; 0E6B from 0E35 (DD1,108,13D)
                                               ; 0E6B from 0E38 (DD1,108,13D)
                                               ; 0E6B from 0E3B (DD1,108,13D)
                                               ; 0E6B from 0E41 (DD1,108,13D)
                                               ; 0E6B from 0E4C (DD0,108,13D)
label_0e6b:     J       label_102d             ; kick out!

                                               ; 0E6E from 0E56 (DD0,108,13D)
                                               ; 0E6E from 0E5C (DD0,108,13D)
label_0e6e:     JBR     off(0011fh).5, label_0e7d ; 0E6E 0 108 13D DD1F0C
                JBS     off(00123h).3, label_0e7d ; 0E71 0 108 13D EB2309
                LB      A, (00165h-0013dh)[USP] ; 0E74 0 108 13D F328
                MOV     X1, #0374eh            ; 0E76 0 108 13D 604E37
                JEQ     label_0ea5             ; 0E79 0 108 13D C92A
                SJ      label_0ea9             ; 0E7B 0 108 13D CB2C
                                               ; 0E7D from 0E6E (DD0,108,13D)
                                               ; 0E7D from 0E71 (DD0,108,13D)
label_0e7d:     MOVB    (00165h-0013dh)[USP], #00ah ; 0E7D 0 108 13D C328980A
                MOV     X1, #0375ah            ; 0E81 0 108 13D 605A37
                JBR     off(00120h).5, label_0e91 ; 0E84 0 108 13D DD200A
                LCB     A, 00026h[X1]          ; 0E87 0 108 13D 90AB2600
                ADD     X1, #00018h            ; 0E8B 0 108 13D 90801800
                SJ      label_0ea0             ; 0E8F 0 108 13D CB0F
                                               ; 0E91 from 0E84 (DD0,108,13D)
label_0e91:     LC      A, 00024h[X1]          ; 0E91 0 108 13D 90A92400
                CMPB    A, 0b4h                ; 0E95 0 108 13D C5B4C2
                JGE     label_0e9e             ; 0E98 0 108 13D CD04
                ADD     X1, #0000ch            ; 0E9A 0 108 13D 90800C00
                                               ; 0E9E from 0E98 (DD0,108,13D)
label_0e9e:     LB      A, ACCH                ; 0E9E 0 108 13D F507
                                               ; 0EA0 from 0E8F (DD0,108,13D)
label_0ea0:     CMPB    A, 0a6h                ; 0EA0 0 108 13D C5A6C2
                JGE     label_0ea9             ; 0EA3 0 108 13D CD04
                                               ; 0EA5 from 0E79 (DD0,108,13D)
label_0ea5:     ADD     X1, #00006h            ; 0EA5 0 108 13D 90800600
                                               ; 0EA9 from 0E7B (DD0,108,13D)
                                               ; 0EA9 from 0EA3 (DD0,108,13D)

label_0ea9:     LB      A, #01fh               ; load 1fh
                CMPB    A, r6                  ; compare to o2 sensor
                RB      [DP].1                 ; 0EAC 0 108 13D C209
                MB      [DP].1, C              ; [DP].1 = lean or rich; 0 for lean 1 for rich
                JEQ     label_0eb5             ; if lean jump
                XORB    PSWH, #080h            ; toggle PSWH.7
                                               ; 0EB5 from 0EB0 (DD0,108,13D)
label_0eb5:     MB      r0.0, C                ; 0EB5 0 108 13D 2038
                SB      [DP].0                 ; 0EB7 0 108 13D C218
                JEQ     label_0f03             ;

                JBR     off(0011fh).7, label_0ed1 ; 0EBB 0 108 13D DF1F13
                JBR     off(0011fh).5, label_0ec9 ; 0EBE 0 108 13D DD1F08
                JBS     off(00123h).5, label_0ee6 ; 0EC1 0 108 13D ED2322
                JBR     off(00123h).3, label_0ee6 ; 0EC4 0 108 13D DB231F
                SJ      label_0f19             ; 0EC7 0 108 13D CB50
                                               ; 0EC9 from 0EBE (DD0,108,13D)
label_0ec9:     JBR     off(00118h).7, label_0ee6 ; if no auto skip down


                JBS     off(00123h).3, label_0ee6 ; 0ECC 0 108 13D EB2317
                SJ      label_0f2f             ; 0ECF 0 108 13D CB5E
                                               ; 0ED1 from 0EBB (DD0,108,13D)
label_0ed1:     JBS     off(0011fh).5, label_0ee6 ; 0ED1 0 108 13D ED1F12
                JBR     off(0011dh).2, label_0eda ; 0ED4 0 108 13D DA1D03
                JBR     off(0011dh).0, label_0f2f ; 0ED7 0 108 13D D81D55
                                               ; 0EDA from 0ED4 (DD0,108,13D)
label_0eda:     CMPB    0a3h, #02eh            ; 0EDA 0 108 13D C5A3C02E
                JLT     label_0ee6             ; 0EDE 0 108 13D CA06
                JBS     off(00123h).5, label_0ee6 ; 0EE0 0 108 13D ED2303
                JBS     off(00123h).3, label_0f2f ; 0EE3 0 108 13D EB2349

                                               ; 0EE6 from 0EC1 (DD0,108,13D)
                                               ; 0EE6 from 0EC4 (DD0,108,13D)
                                               ; 0EE6 from 0ED1 (DD0,108,13D)
                                               ; 0EE6 from 0EDE (DD0,108,13D)
                                               ; 0EE6 from 0EE0 (DD0,108,13D)
                                               ; 0EE6 from 0EC9 (DD0,108,13D)
                                               ; 0EE6 from 0ECC (DD0,108,13D)
label_0ee6:     RB      [DP].5                 ; 0EE6 0 108 13D C20D
                JEQ     label_0ef6             ; 0EE8 0 108 13D C90C
                LB      A, (00195h-0013dh)[USP] ; 0EEA 0 108 13D F358
                JNE     label_0ef6             ; 0EEC 0 108 13D CE08
                JBS     off(0011fh).5, label_0f14 ; 0EEE 0 108 13D ED1F23
                L       A, 00270h[X2]          ; 0EF1 1 108 13D E17002
                SJ      label_0f45             ; 0EF4 1 108 13D CB4F
                                               ; 0EF6 from 0EE8 (DD0,108,13D)
                                               ; 0EF6 from 0EEC (DD0,108,13D)
label_0ef6:     JBR     off(00108h).0, label_0f48 ; 0EF6 0 108 13D D8084F
                L       A, 001bch[X2]          ; 0EF9 1 108 13D E1BC01
                JNE     label_0f65             ; 0EFC 1 108 13D CE67
                L       A, #08000h             ; 0EFE 1 108 13D 670080
                SJ      label_0f45             ; 0F01 1 108 13D CB42
                ;**************

                                               ; 0F03 from 0EB9 (DD0,108,13D)
label_0f03:     MB      C, [DP].2              ; 0F03 0 108 13D C22A
                JGE     label_0f0b             ; 0F05 0 108 13D CD04
                LB      A, (00169h-0013dh)[USP] ; 0F07 0 108 13D F32C
                JNE     label_0f48             ; possibility of skipping o2 code


                                               ; 0F0B from 0F05 (DD0,108,13D)
label_0f0b:     JBS     off(0011fh).5, label_0f14 ; 0F0B 0 108 13D ED1F06
                JBS     off(0011dh).0, label_0f26 ; 0F0E 0 108 13D E81D15
                JBS     off(00123h).3, label_0f2f ; 0F11 0 108 13D EB231B
                                               ; 0F14 from 0F0B (DD0,108,13D)
                                               ; 0F14 from 0EEE (DD0,108,13D)
label_0f14:     L       A, 0026ch[X2]          ; 0F14 1 108 13D E16C02
                SJ      label_0f45             ; 0F17 1 108 13D CB2C
                ;**************
                                               ; 0F19 from 0EC7 (DD0,108,13D)
label_0f19:     MOVB    (00195h-0013dh)[USP], #028h ; 0F19 0 108 13D C3589828
                L       A, 00274h[X2]          ; 0F1D 1 108 13D E17402
                MOV     er0, #08000h           ; 0F20 1 108 13D 44980080
                SJ      label_0f40             ; 0F24 1 108 13D CB1A
                                               ; 0F26 from 0F0E (DD0,108,13D)
label_0f26:     L       A, 00270h[X2]          ; 0F26 1 108 13D E17002
                MOV     er0, #08000h           ; 0F29 1 108 13D 44980080
                SJ      label_0f40             ; 0F2D 1 108 13D CB11
                                               ; 0F2F from 0F11 (DD0,108,13D)
                                               ; 0F2F from 0ED7 (DD0,108,13D)
                                               ; 0F2F from 0EE3 (DD0,108,13D)
                                               ; 0F2F from 0ECF (DD0,108,13D)
label_0f2f:     L       A, 00270h[X2]          ; 0F2F 1 108 13D E17002
                MOV     er0, #08400h           ; 0F32 1 108 13D 44980084
                CMPB    0a3h, #040h            ; 0F36 1 108 13D C5A3C040
                JLT     label_0f40             ; 0F3A 1 108 13D CA04
                MOV     er0, #087afh           ; 0F3C 1 108 13D 4498AF87
                                               ; 0F40 from 0F24 (DD1,108,13D)
                                               ; 0F40 from 0F2D (DD1,108,13D)
                                               ; 0F40 from 0F3A (DD1,108,13D)
label_0f40:     MUL                            ; 0F40 1 108 13D 9035
                SLL     A                      ; 0F42 1 108 13D 53
                L       A, er1                 ; 0F43 1 108 13D 35
                ROL     A                      ; 0F44 1 108 13D 33


                                               ; 0F45 from 0F17 (DD1,108,13D)
                                               ; 0F45 from 0EF4 (DD1,108,13D)
                                               ; 0F45 from 0F01 (DD1,108,13D)
label_0f45:     ST      A, 00162h[X2]          ; 0F45 1 108 13D D16201
				; o2 correction



                                               ; 0F48 from 0F09 (DD0,108,13D)
                                               ; 0F48 from 0EF6 (DD0,108,13D)
label_0f48:     RB      [DP].2                 ; 0F48 0 108 13D C20A
                SUBB    (00163h-0013dh)[USP], #002h ; 0F4A 0 108 13D C326A002
                JLE     label_0f53             ; 0F4E 0 108 13D CF03

                J       label_1045             ; skip out of o2 stuff

                ;X1 = #0375ah, #3772h, or #3766h
                                               ; 0F53 from 0F4E (DD0,108,13D)
label_0f53:     CLR     A                      ; 0F53 1 108 13D F9
                LC      A, [X1]                ; 0F54 1 108 13D 90A8
                MB      C, [DP].1              ; set earlier in the lean/rich check
                							   ; 0 for lean 1 for rich
                JGE     label_0f5d             ; if lean, jump
                ST      A, er0                 ; else we compliment A
                CLR     A                      ;
                SUB     A, er0                 ;
                                               ; 0F5D from 0F58 (DD1,108,13D)
label_0f5d:     ADD     A, 00162h[X2]          ; 0F5D 1 108 13D B1620182
                SB      r7.1                   ;?
                SJ      label_0fa1             ; 0F63 1 108 13D CB3C
                ;*************************
                                               ; 0F65 from 0EFC (DD1,108,13D)
label_0f65:     JBR     off(0011fh).5, label_0f73 ; 0F65 1 108 13D DD1F0B
                LB      A, (00165h-0013dh)[USP] ; 0F68 0 108 13D F328
                JEQ     label_0f73             ; 0F6A 0 108 13D C907
                SUBB    A, #002h               ; 0F6C 0 108 13D A602
                JGE     label_0f71             ; 0F6E 0 108 13D CD01
                CLRB    A                      ; 0F70 0 108 13D FA
                                               ; 0F71 from 0F6E (DD0,108,13D)
label_0f71:     STB     A, (00165h-0013dh)[USP] ; 0F71 0 108 13D D328
                                               ; 0F73 from 0F65 (DD1,108,13D)
                                               ; 0F73 from 0F6A (DD0,108,13D)
label_0f73:     CLR     A                      ; 0F73 1 108 13D F9
                LC      A, 00002h[X1]          ; 0F74 1 108 13D 90A90200
                ST      A, er2                 ; 0F78 1 108 13D 8A
                MB      C, [DP].1              ; 0 for lean 1 for rich?
                JLT     label_0f9b             ; jump if rich?
                LB      A, (0016bh-0013dh)[USP] ; 0F7D 0 108 13D F32E
                JNE     label_0f98             ; 0F7F 0 108 13D CE17
                MOVB    (0016bh-0013dh)[USP], #014h ; 0F81 0 108 13D C32E9814
                LB      A, 09eh                ;
                ANDB    A, #0c0h               ; 0F87 0 108 13D D6C0
                SWAPB                          ; 0F89 0 108 13D 83
                EXTND                          ; 0F8A 1 108 13D F8
                SRL     A                      ; 0F8B 1 108 13D 63
                LC      A, 03781h[ACC]         ; 0F8C 1 108 13D B506A98137
                ST      A, er2                 ; 0F91 1 108 13D 8A
                LC      A, 00004h[X1]          ; 0F92 1 108 13D 90A90400
                ADD     er2, A                 ; 0F96 1 108 13D 4681
                                               ; 0F98 from 0F7F (DD0,108,13D)
label_0f98:     CLR     A                      ; 0F98 1 108 13D F9
                SUB     A, er2                 ; 0F99 1 108 13D 2A
                ST      A, er2                 ; 0F9A 1 108 13D 8A
                                               ; 0F9B from 0F7B (DD1,108,13D)
label_0f9b:     L       A, 00162h[X2]          ; 0F9B 1 108 13D E16201
                SUB     A, er2                 ; 0F9E 1 108 13D 2A
                RB      r7.1                   ;
                                               ; 0FA1 from 0F63 (DD1,108,13D)
label_0fa1:     MOV     er0, #0b6e0h           ; upper limit
                MOV     er1, #05720h           ; lower limit
                CAL     label_2fd5             ; make sure were within the limits
                ST      A, 00162h[X2]          ; store in o2 correction ram
                ;store in o2 correction ram


                L       A, off(0014eh)         ; 0FAF 1 108 13D E44E
                JNE     label_0fe9             ; 0FB1 1 108 13D CE36

                MB      C, P0.3                ; purge control solenoid valve
                JGE     label_0fe9      ;if C==0       ; skip out of o2 code
                JBS     off(0011dh).0, label_0fe9 ; 0FB8 1 108 13D E81D2E
                MOV     X1, DP                 ; 0FBB 1 108 13D 9278
                L       A, #00274h             ; 0FBD 1 108 13D 677402
                ADD     A, X2                  ; 0FC0 1 108 13D 9182
                MOV     DP, A                  ; 0FC2 1 108 13D 52
                MOV     er0, #000ffh           ; 0FC3 1 108 13D 4498FF00
                LB      A, (00195h-0013dh)[USP] ; 0FC7 0 108 13D F358
                JNE     label_0fe1             ; 0FC9 0 108 13D CE16
                JBS     off(0010fh).1, label_0fe7 ; 0FCB 0 108 13D E90F19
                SUB     DP, #00004h            ; 0FCE 0 108 13D 92A00400
                MOV     er0, #00080h           ; 0FD2 0 108 13D 44988000
                JBR     off(0011fh).5, label_0fe1 ; 0FD6 0 108 13D DD1F08
                SUB     DP, #00004h            ; 0FD9 0 108 13D 92A00400
                MOV     er0, #000ffh           ; 0FDD 0 108 13D 4498FF00
                                               ; 0FE1 from 0FC9 (DD0,108,13D)
                                               ; 0FE1 from 0FD6 (DD0,108,13D)
label_0fe1:     L       A, 00162h[X2]          ; 0FE1 1 108 13D E16201
                CAL     label_2efd             ; [DP] = [DP] - ([DP]*er0 overflow) + (A * er0 overflow)
                                               ; 0FE7 from 0FCB (DD0,108,13D)
label_0fe7:     MOV     DP, X1                 ; 0FE7 1 108 13D 907A
                                               ; 0FE9 from 0FB1 (DD1,108,13D)
                                               ; 0FE9 from 0FB6 (DD1,108,13D)
                                               ; 0FE9 from 0FB8 (DD1,108,13D)
label_0fe9:     SJ      label_103a             ; 0FE9 1 108 13D CB4F
;****************

                                               ; 0FEB from 0E65 (DD0,108,13D)
label_0feb:     MB      C, [DP].0              ; 0FEB 0 108 13D C228
                JGE     label_0ff3             ; 0FED 0 108 13D CD04
                SB      [DP].2                 ; 0FEF 0 108 13D C21A
                STB     A, (00169h-0013dh)[USP] ; 0FF1 0 108 13D D32C
                                               ; 0FF3 from 0FED (DD0,108,13D)
label_0ff3:     CMPB    off(0015bh), #040h     ; 0FF3 0 108 13D C45BC040
                JNE     label_102f             ; 0FF7 0 108 13D CE36
                LB      A, (00169h-0013dh)[USP] ; 0FF9 0 108 13D F32C
                MOV     er0, 00270h[X2]        ; 0FFB 0 108 13D B1700248
                JEQ     label_1005             ; 0FFF 0 108 13D C904
                MOV     er0, 00162h[X2]        ; 1001 0 108 13D B1620148
                                               ; 1005 from 0FFF (DD0,108,13D)
label_1005:     JBR     off(00109h).7, label_102f ; 1005 0 108 13D DF0927
                MOV     er2, er0               ; 1008 0 108 13D 444A
                SJ      label_102f             ; 100A 0 108 13D CB23
                                               ; 100C from 0E62 (DD0,108,13D)
label_100c:     MB      C, [DP].0              ; 100C 0 108 13D C228
                JGE     label_1014             ; 100E 0 108 13D CD04
                SB      [DP].2                 ; 1010 0 108 13D C21A
                STB     A, (00169h-0013dh)[USP] ; 1012 0 108 13D D32C
                                               ; 1014 from 100E (DD0,108,13D)
label_1014:     LB      A, (00169h-0013dh)[USP] ; 1014 0 108 13D F32C
                MOV     er2, 00270h[X2]        ; 1016 0 108 13D B170024A
                JEQ     label_102f             ; 101A 0 108 13D C913
                MOV     er2, 00162h[X2]        ; 101C 0 108 13D B162014A
                SJ      label_102f             ; 1020 0 108 13D CB0D
                                               ; 1022 from 0E68 (DD1,108,13D)
label_1022:     MOV     er2, 00270h[X2]        ; 1022 1 108 13D B170024A
                JBR     off(0011fh).5, label_102d ; 1026 1 108 13D DD1F04
                MOV     er2, 0026ch[X2]        ; 1029 1 108 13D B16C024A
                                               ; 102D from 0E6B (DD1,108,13D)
                                               ; 102D from 1026 (DD1,108,13D)
label_102d:     RB      [DP].2                 ; 102D 1 108 13D C20A
                                               ; 102F from 101A (DD0,108,13D)
                                               ; 102F from 1020 (DD0,108,13D)
                                               ; 102F from 0FF7 (DD0,108,13D)
                                               ; 102F from 1005 (DD0,108,13D)
                                               ; 102F from 100A (DD0,108,13D)
label_102f:     ANDB    [DP], #0deh            ; 102F 1 108 13D C2D0DE
                MOVB    (00165h-0013dh)[USP], #00ah ; 1032 1 108 13D C328980A
                L       A, er2                 ; 1036 1 108 13D 36
                ST      A, 00162h[X2]          ; 1037 1 108 13D D16201
;end o2 finally.
;********************************************************************************

                                               ; 103A from 0FE9 (DD1,108,13D)
label_103a:     MOVB    r0, #004h              ; 103A 1 108 13D 9804
                LB      A, (00165h-0013dh)[USP] ; 103C 0 108 13D F328
                JNE     label_1042             ; 103E 0 108 13D CE02
                MOVB    r0, #004h              ; 1040 0 108 13D 9804
                                               ; 1042 from 103E (DD0,108,13D)
label_1042:     LB      A, r0                  ; 1042 0 108 13D 78
                STB     A, (00163h-0013dh)[USP] ; 1043 0 108 13D D326

;***************************************************
;knock code checking
                                               ; 1045 from 0F50 (DD0,108,13D)
label_1045:     LB      A, 0feh                ; 1045 0 108 13D F5FE
                STB     A, r0                  ; 1047 0 108 13D 88
                LB      A, off(001c4h)         ; 1048 0 108 13D F4C4
                JNE     label_109c             ; 104A 0 108 13D CE50

                ;77h = 01110111b
                ;codes 1 (o2), 2 (2nd o2), 3(map), 5(map), 6(ect), 7(tps)
                LB      A, off(00130h)         ; 104C 0 108 13D F430
                ANDB    A, #077h               ; 104E 0 108 13D D677
                JNE     label_109c             ; 1050 0 108 13D CE4A


                JBS     off(0010fh).6, label_109c ; 1052 0 108 13D EE0F47
                CMPB    0a3h, #026h            ; 1055 0 108 13D C5A3C026
                JGE     label_109c             ; 1059 0 108 13D CD41
                JBS     off(00108h).6, label_107d ; 105B 0 108 13D EE081F
                CMPB    0a6h, #062h            ; 105E 0 108 13D C5A6C062
                JGE     label_1068             ; 1062 0 108 13D CD04
                MOVB    (0019ah-0013dh)[USP], #032h ; 1064 0 108 13D C35D9832
                                               ; 1068 from 1062 (DD0,108,13D)
label_1068:     LB      A, (0019ah-0013dh)[USP] ; 1068 0 108 13D F35D
                JNE     label_106e             ; 106A 0 108 13D CE02
                SB      [DP].6                 ; 106C 0 108 13D C21E
                                               ; 106E from 106A (DD0,108,13D)
label_106e:     RC                             ; 106E 0 108 13D 95
                JBS     off(00108h).7, label_10a3 ; 106F 0 108 13D EF0831


                LB      A, #040h               ; 1072 0 108 13D 7740
                CMPB    A, off(0015bh)         ; 1074 0 108 13D C75B
                JGE     label_10a3             ; if 40h>=[15bh] jump with c == 0
                CMPB    r6, #003h              ; 3 bytes. RC NOP NOP??


                SJ      label_10a3             ; 107B 0 108 13D CB26
                                               ; 107D from 105B (DD0,108,13D)
label_107d:     JBS     off(00123h).2, label_1083 ; 107D 0 108 13D EA2303
                LB      A, r6                  ; 1080 0 108 13D 7E
                STB     A, (00161h-0013dh)[USP] ; 1081 0 108 13D D324
                                               ; 1083 from 107D (DD0,108,13D)
label_1083:     MB      C, [DP].6              ; 1083 0 108 13D C22E
                JGE     label_109e             ; 1085 0 108 13D CD17
                LB      A, #09ah               ;
                CMPB    A, r6                  ; 1089 0 108 13D 4E
                JGE     label_109c             ; no knock code
                JBS     off(00123h).3, label_109c ; 108C 0 108 13D EB230D
                LB      A, (00161h-0013dh)[USP] ; load [161h]
                SUBB    A, r6                  ; 1091 0 108 13D 2E
                JGE     label_1097             ; 1092 0 108 13D CD03
                STB     A, r1                  ; 1094 0 108 13D 89
                CLRB    A                      ; 1095 0 108 13D FA
                SUBB    A, r1                  ; 1096 0 108 13D 29
                                               ; 1097 from 1092 (DD0,108,13D)
label_1097:     CMPB    A, #003h               ; 1097 0 108 13D C603
                NOP                            ; 1099 0 108 13D 00
                JLT     label_10a3             ; if A<3 set the knock bit
                                               ; 109C from 104A (DD0,108,13D)
                                               ; 109C from 1050 (DD0,108,13D)
                                               ; 109C from 1052 (DD0,108,13D)
                                               ; 109C from 1059 (DD0,108,13D)
                                               ; 109C from 108A (DD0,108,13D)
                                               ; 109C from 108C (DD0,108,13D)
label_109c:     RB      [DP].6                 ; 109C 0 108 13D C20E
                                               ; 109E from 1085 (DD0,108,13D)
label_109e:     MOVB    (0019ah-0013dh)[USP], #032h ; 109E 0 108 13D C35D9832
                RC                             ; 10A2 0 108 13D 95
                                               ; 10A3 from 106F (DD0,108,13D)
                                               ; 10A3 from 1076 (DD0,108,13D)
                                               ; 10A3 from 107B (DD0,108,13D)
                                               ; 10A3 from 109A (DD0,108,13D)
label_10a3:     JBS     off(0010fh).7, label_10ab ; 10A3 0 108 13D EF0F05

                MB      off(0012dh).4, C       ; sets the knock CEL
                ;NOP
                ;NOP
                ;NOP
;*******************************************************

                SJ      label_10ae             ; 10A9 0 108 13D CB03
                                               ; 10AB from 10A3 (DD0,108,13D)
label_10ab:     MB      off(0012dh).5, C       ; 10AB 0 108 13D C42D3D

;*******************************************************
;ect correction?

label_10ae:     MOVB    r5, #040h              ; 10AE 0 108 13D 9D40
                MOV     X1, #03717h            ; 10B0 0 108 13D 601737
                CAL     label_2d4b             ; 10B3 0 108 13D 324B2D

;label_2d4b:     LB      A, 0a3h                ; 2D4B 0 108 13D F5A3
;                VCAL    0                      ; 2D4D 0 108 13D 10
;                STB     A, r7                  ; 2D4E 0 108 13D 8F
;                MOVB    r6, r5                 ; 2D4F 0 108 13D 254E
;                                               ; 2D51 from 1110 (DD0,108,13D)
;label_2d51:     MOV     X1, #03727h            ; 2D51 0 108 13D 602737
;                JBS     off(00118h).7, label_2d58 ; if auto
;                INC     X1                     ; 2D57 0 108 13D 70
;
;
;                                               ; 2D58 from 07E1 (DD0,108,20E)
;                                               ; 2D58 from 2D54 (DD0,108,13D)
;
;label_2d58:     LB      A, 0b4h                ; load map
;
;			;[X1] is upper limit and [X1+2] is lower limit.
;			; so:
;			; if(A < [X1] && A >= [X1+2])
;;			;	interpolate between the 2 values.
;			; else if(
;		;   A ==
;                                               ; 2D5A from 31CA (DD0,108,13D)
;label_2d5a:     CMPCB   A, [X1]                ;
;                JLT     label_2d60             ; 2D5C 0 108 20E CA02
;                LCB     A, [X1]                ; 2D5E 0 108 20E 90AA
;                                               ; 2D60 from 2D5C (DD0,108,20E)
;label_2d60:     CMPCB   A, 00002h[X1]          ; 2D60 0 108 20E 90AF0200
;                JGE     label_2d6a             ; 2D64 0 108 20E CD04
;                LCB     A, 00002h[X1]          ; 2D66 0 108 20E 90AB0200
				                                               ; 2D6A from 2D64 (DD0,108,20E)
;label_2d6a:     STB     A, r0                  ; 2D6A 0 108 20E 88
                ;SJ      label_2d82             ; 2D6B 0 108 20E CB15
                ;this jumps nto the middle of VCAL_0

				;based on MAP image. stays between 51h and dfh

                STB     A, off(00169h)         ; 10B6 0 108 13D D469

;*******************************************
;
                ;74h = 01110100
                ;codes 3, 5, 6, 7
                LB      A, off(00130h)         ; 10B8 0 108 13D F430
                ANDB    A, #074h               ; 10BA 0 108 13D D674
                JNE     label_1115             ; 10BC 0 108 13D CE57

                LB      A, 0b4h                ; 10BE 0 108 13D F5B4
                SUBB    A, 0b7h                ; 10C0 0 108 13D C5B7A2
                JGE     label_10c6             ; 10C3 0 108 13D CD01
                CLRB    A                      ; 10C5 0 108 13D FA
                                               ; 10C6 from 10C3 (DD0,108,13D)
label_10c6:     STB     A, r0                  ; 10C6 0 108 13D 88
                CMP     off(0016ch), #00180h   ; 10C7 0 108 13D B46CC08001
                JGE     label_1115             ; 10CC 0 108 13D CD47
                LB      A, #006h               ; 10CE 0 108 13D 7706
                MOVB    r1, #0cfh              ; 10D0 0 108 13D 99CF
                JBS     off(00121h).6, label_10d9 ; 10D2 0 108 13D EE2104
                LB      A, #014h               ; 10D5 0 108 13D 7714
                MOVB    r1, #0cbh              ; 10D7 0 108 13D 99CB
                                               ; 10D9 from 10D2 (DD0,108,13D)
label_10d9:     CMPB    A, 0a6h                ; 10D9 0 108 13D C5A6C2
                JGE     label_10e1             ; 10DC 0 108 13D CD03
                LB      A, 0b4h                ; 10DE 0 108 13D F5B4
                CMPB    A, r1                  ; 10E0 0 108 13D 49
                                               ; 10E1 from 10DC (DD0,108,13D)
label_10e1:     MB      off(00121h).6, C       ; 10E1 0 108 13D C4213E
                JGE     label_1115             ; 10E4 0 108 13D CD2F
                CMPB    r0, #003h              ; 10E6 0 108 13D 20C003
                JGE     label_1115             ; 10E9 0 108 13D CD2A
                LB      A, 0afh                ; 10EB 0 108 13D F5AF
                JBS     off(00122h).2, label_10f2 ; 10ED 0 108 13D EA2202
                LB      A, 0adh                ; 10F0 0 108 13D F5AD
                                               ; 10F2 from 10ED (DD0,108,13D)
label_10f2:     CMPB    A, #083h               ; 10F2 0 108 13D C683
                JGE     label_1115             ; 10F4 0 108 13D CD1F
                MOV     X1, #03707h            ; 10F6 0 108 13D 600737
                LB      A, 0a3h                ; 10F9 0 108 13D F5A3
                VCAL    0                      ; 10FB 0 108 13D 10
                LB      A, off(0015dh)         ; 10FC 0 108 13D F45D
                MOVB    r0, #0cch              ; 10FE 0 108 13D 98CC
                MULB                           ; 1100 0 108 13D A234
                LB      A, ACCH                ; 1102 0 108 13D F507
                STB     A, off(0015dh)         ; 1104 0 108 13D D45D
;*******************

                ADDB    A, r6                  ; 1106 0 108 13D 0E
                STB     A, r2                  ; 1107 0 108 13D 8A
                MOV     X1, #036e7h            ; 1108 0 108 13D 60E736
                LB      A, 0a3h                ; 110B 0 108 13D F5A3
                VCAL    0                      ; 110D 0 108 13D 10
                MOVB    r7, r2                 ; 110E 0 108 13D 224F
                CAL     label_2d51             ; vcal with map (b4h)
                SJ      label_1121             ; 1113 0 108 13D CB0C
                                               ; 1115 from 10BC (DD0,108,13D)
                                               ; 1115 from 10CC (DD0,108,13D)
                                               ; 1115 from 10E4 (DD0,108,13D)
                                               ; 1115 from 10E9 (DD0,108,13D)
                                               ; 1115 from 10F4 (DD0,108,13D)
label_1115:     CAL     label_2fe0             ; 1115 0 108 13D 32E02F
                MOV     X1, #036e7h            ; 1118 0 108 13D 60E736
                MOV     X2, #036f7h            ; 111B 0 108 13D 61F736
                CAL     label_2d45             ; 111E 0 108 13D 32452D
                                               ; 1121 from 1113 (DD0,108,13D)
label_1121:     STB     A, off(00168h)         ; 1121 0 108 13D D468

;*********************************************************************

                SUBB    A, #040h               ; 1123 0 108 13D A640
                MOVB    r0, #01ch              ; 1125 0 108 13D 981C
                MULB                           ; 1127 0 108 13D A234
                ADDB    ACCH, #001h            ; 1129 0 108 13D C5078001
                J       label_3182             ; 112D 0 108 13D 038231

;label_3182:     MOV     off(00166h), A         ; 3182 0 108 13D B4668A
;
;				;74h = 01110100
;				;
;				LB      A, off(00130h)         ; 3185 0 108 13D F430
;				ANDB    A, #074h               ; 3187 0 108 13D D674
;				JNE     label_31e7             ; 3189 0 108 13D CE5C
;
;				JBS     off(00131h).1, label_31e7 ; cyp sensor code check
;				JBS     off(00132h).0, label_31e7 ; vss code
;				J       label_32b3             ; 3191 0 108 13D 03B332
;				DB  000h ; 3194
;											   ; 3195 from 32BD (DD0,108,13D)
;label_3195:     LB      A, #010h               ; 3195 0 108 13D 7710
;				JBS     off(0011dh).3, label_319c ; 3197 0 108 13D EB1D02
;				LB      A, #018h               ; 319A 0 108 13D 7718
;											   ; 319C from 3197 (DD0,108,13D)
;label_319c:     ;CMPB	A, #001h				;vss
;				CMPB    A, 0cbh                ; 319C 0 108 13D C5CBC2
;				MB      off(0011dh).3, C       ; 319F 0 108 13D C41D3B
;				JLT     label_31e7             ; 31A2 0 108 13D CA43
;				JBR     off(00125h).3, label_31e7 ; 31A4 0 108 13D DB2540
;;				CMPB    0adh, #083h            ; 31A7 0 108 13D C5ADC083
;				JGE     label_31e7             ; 31AB 0 108 13D CD3A
;				LB      A, 0b4h                ; 31AD 0 108 13D F5B4
;				SUBB    A, 0b3h                ; 31AF 0 108 13D C5B3A2
;				JLT     label_31e7             ; 31B2 0 108 13D CA33
;				STB     A, r2                  ; 31B4 0 108 13D 8A
;				CMPB    A, #004h               ; 31B5 0 108 13D C604
;				JLT     label_31e1             ; 31B7 0 108 13D CA28
;				MOV     X1, #03163h            ; 31B9 0 108 13D 606331
;				VCAL    0                      ; 31BC 0 108 13D 10
;				XCHGB   A, r2                  ; 31BD 0 108 13D 2210
;				MOV     X1, #0316fh            ; 31BF 0 108 13D 606F31
;				VCAL    0                      ; 31C2 0 108 13D 10
;;				MOVB    r7, r2                 ; 31C3 0 108 13D 224F
;				MOV     X1, #0317bh            ; 31C5 0 108 13D 607B31
;				LB      A, 0a3h                ; 31C8 0 108 13D F5A3
;				CAL     label_2d5a             ; 31CA 0 108 13D 325A2D
;				STB     A, r2                  ; 31CD 0 108 13D 8A
;				MOV     X1, #0317eh            ; 31CE 0 108 13D 607E31
;				LB      A, 0a4h                ; 31D1 0 108 13D F5A4
;				VCAL    2                      ; 31D3 0 108 13D 12
;				MOVB    r0, r2                 ; 31D4 0 108 13D 2248
;				MULB                           ; 31D6 0 108 13D A234
;				SLL     ACC                    ; 31D8 0 108 13D B506D7
;				JGE     label_31e1             ; 31DB 0 108 13D CD04
;				MOVB    ACCH, #0ffh            ; 31DD 0 108 13D C50798FF
;											   ; 31E1 from 31B7 (DD0,108,13D)
;											   ; 31E1 from 31DB (DD0,108,13D)
;label_31e1:     LB      A, ACCH                ; 31E1 0 108 13D F507
;				CMPB    A, #080h               ; 31E3 0 108 13D C680
;				JGE     label_31e9             ; 31E5 0 108 13D CD02
;											   ; 31E7 from 3189 (DD0,108,13D)
;											   ; 31E7 from 318B (DD0,108,13D)
;											   ; 31E7 from 318E (DD0,108,13D)
;											   ; 31E7 from 32C0 (DD0,108,13D)
;											   ; 31E7 from 31A2 (DD0,108,13D)
;											   ; 31E7 from 31A4 (DD0,108,13D)
;											   ; 31E7 from 31AB (DD0,108,13D)
;											   ; 31E7 from 31B2 (DD0,108,13D)
;label_31e7:     LB      A, #080h               ; 31E7 0 108 13D 7780
;											   ; 31E9 from 31E5 (DD0,108,13D)
;label_31e9:     STB     A, off(00153h)         ; 31E9 0 108 13D D453
;                J       label_1130             ; 31EB 0 108 13D 033011
;                                               ; 1130 from 31EB (DD0,108,13D)


label_1130:     CLRB    r7                     ; 1130 0 108 13D 2715
                LB      A, off(0013dh)         ; 1132 0 108 13D F43D
                JNE     label_1139             ; 1134 0 108 13D CE03
                JBR     off(0012bh).2, label_1161 ; 1136 0 108 13D DA2B28
                                               ; 1139 from 1134 (DD0,108,13D)
label_1139:     LB      A, #0d7h               ; 1139 0 108 13D 77D7
                MOVB    r0, #065h              ; 113B 0 108 13D 9865
                JBR     off(00121h).0, label_1144 ; 113D 0 108 13D D82104
                LB      A, #0d2h               ; 1140 0 108 13D 77D2
                MOVB    r0, #056h              ; 1142 0 108 13D 9856
                                               ; 1144 from 113D (DD0,108,13D)
label_1144:     CMPB    A, 0a6h                ; 1144 0 108 13D C5A6C2
                JGE     label_114d             ; 1147 0 108 13D CD04
                LB      A, r0                  ; 1149 0 108 13D 78
                CMPB    A, 0b4h                ; 114A 0 108 13D C5B4C2
                                               ; 114D from 1147 (DD0,108,13D)
label_114d:     MB      off(00121h).0, C       ; 114D 0 108 13D C42138
                JGE     label_1161             ; 1150 0 108 13D CD0F
                JBS     off(0011dh).0, label_1161 ; 1152 0 108 13D E81D0C
                LB      A, #040h               ; 1155 0 108 13D 7740
                CMPB    A, off(00168h)         ; 1157 0 108 13D C768
                JNE     label_1161             ; 1159 0 108 13D CE06
                CMPB    A, off(0015bh)         ; 115B 0 108 13D C75B
                JNE     label_1161             ; 115D 0 108 13D CE02
                MOVB    r7, #013h              ; 115F 0 108 13D 9F13
                                               ; 1161 from 1136 (DD0,108,13D)
                                               ; 1161 from 1150 (DD0,108,13D)
                                               ; 1161 from 1152 (DD0,108,13D)
                                               ; 1161 from 1159 (DD0,108,13D)
                                               ; 1161 from 115D (DD0,108,13D)
label_1161:     LB      A, r7                  ; 1161 0 108 13D 7F
                STB     A, off(00159h)         ; 1162 0 108 13D D459
;*********************************************************************

                CLRB    r6                     ; 1164 0 108 13D 2615
                JBS     off(00132h).0, label_11aa ; checking vss code
                JBS     off(00118h).6, label_11aa ; starter signal
                JBR     off(00124h).2, label_11aa ; 116C 0 108 13D DA243B
                LB      A, #0b3h               ; 116F 0 108 13D 77B3
                MOVB    r0, #046h              ; 1171 0 108 13D 9846
                JBR     off(00121h).5, label_117a ; 1173 0 108 13D DD2104
                LB      A, #0bah               ; 1176 0 108 13D 77BA
                MOVB    r0, #040h              ; 1178 0 108 13D 9840
                                               ; 117A from 1173 (DD0,108,13D)
label_117a:     CMPB    0a6h, A                ; 117A 0 108 13D C5A6C1
                JGE     label_1183             ; 117D 0 108 13D CD04
                LB      A, r0                  ; 117F 0 108 13D 78
                CMPB    A, 0a6h                ; 1180 0 108 13D C5A6C2
                                               ; 1183 from 117D (DD0,108,13D)
label_1183:     MB      off(00121h).5, C       ; 1183 0 108 13D C4213D
                JGE     label_11aa             ; 1186 0 108 13D CD22
                MOV     er0, 0bah              ; er0 = revs
                CLR     A                      ; A = 0
                MOV     er2, 0c4h              ; er2 = speed

                ;er0A = er0A/er2
                DIV                            ; er0A = revs0000h/speed

                ;one could assume that this would
                ;net something like a gear number or something
                CMP     er0, #00000h           ; if revs are much higher than speed
                JEQ     label_119a             ; then we will not jump
                L       A, #0ffffh             ; and a= ffffh
                                               ; 119A from 1195 (DD1,108,13D)
label_119a:     MOV     DP, #00268h            ; move the division result into [268h]
                ST      A, [DP]                ;


                CMP     A, #02a2dh             ;
                JGE     label_11aa             ; if result >= 2a2dh, jump with r6==0
                INCB    r6                     ; r6 = 1
                CMP     A, #01bb9h             ; if result >= 1bb9h, jump with r6 == 1
                JGE     label_11aa             ;
                INCB    r6                     ; else r6 = 2
                                               ; 11AA from 1166 (DD0,108,13D)
                                               ; 11AA from 1169 (DD0,108,13D)
                                               ; 11AA from 116C (DD0,108,13D)
                                               ; 11AA from 1186 (DD0,108,13D)
                                               ; 11AA from 11A1 (DD1,108,13D)
                                               ; 11AA from 11A7 (DD1,108,13D)
                ;is this ghetto gear correction?
                ; guess: 	in 1st or sitting 124h.0=124h.1=0
                ;			in 2nd 124h.1 = 1, 124h.0 = 0
                ;			in 3rd 124h.1 = 0, 124h.0 = 1
label_11aa:     LB      A, r6                  ; load r6 (0,1,or 2)
                SRLB    A                      ; shift right
                MB      off(00124h).1, C       ; 124h.1 = 1 if r6 = 1
                SRLB    A                      ; shift again
                MB      off(00124h).0, C       ; 124h.0 = 1 if r6 = 2 (or 3 I guess)


                CMPB    0a6h, #0e8h            ; 11B3 0 108 13D C5A6C0E8
                JGE     label_11e7             ; 11B7 0 108 13D CD2E
                MB      C, off(0011fh).3       ; 11B9 0 108 13D C41F2B
                MOV     DP, #000afh            ; 11BC 0 108 13D 62AF00
                JBS     off(00122h).2, label_11c7 ; 11BF 0 108 13D EA2205
                MB      C, off(0011fh).2       ; 11C2 0 108 13D C41F2A
                DEC     DP                     ; 11C5 0 108 13D 82
                DEC     DP                     ; 11C6 0 108 13D 82
                                               ; 11C7 from 11BF (DD0,108,13D)
label_11c7:     ROLB    r0                     ; 11C7 0 108 13D 20B7
                LB      A, #083h               ; 11C9 0 108 13D 7783
                CMPB    [DP], A                ; compare TPS to 83h
                JGE     label_11fa             ; 11CD 0 108 13D CD2B
                LB      A, #07ch               ; 11CF 0 108 13D 777C
                CMPB    off(001d2h), #000h     ; 11D1 0 108 13D C4D2C000
                JEQ     label_11d9             ; 11D5 0 108 13D C902
                SUBB    A, #008h               ; 11D7 0 108 13D A608
                                               ; 11D9 from 11D5 (DD0,108,13D)
label_11d9:     CMPB    [DP], A                ; 11D9 0 108 13D C2C1
                JLT     label_11ed             ; 11DB 0 108 13D CA10
                JBS     off(00122h).3, label_11f3 ; 11DD 0 108 13D EB2213


                                               ; 11E0 from 121A (DD0,108,13D)
label_11e0:     L       A, off(0014ah)         ;
                JEQ     label_11e7             ;
                JBS     off(00123h).3, label_11ea 	; if the tps is increasing, jump
                									; to deal with the ??tip in??

                                               ; 11E7 from 11B7 (DD0,108,13D)
                                               ; 11E7 from 11E2 (DD1,108,13D)
                                               ; 11E7 from 11F5 (DD0,108,13D)
label_11e7:     J       label_1325             ; start finding final fuel val

                                               ; 11EA from 11E4 (DD1,108,13D)
label_11ea:     J       label_127a             ; jump to set 14ah
                                               ; 11ED from 11DB (DD0,108,13D)
label_11ed:     JBR     off(00108h).0, label_11f3 ; 11ED 0 108 13D D80803
                J       label_12c0             ; 11F0 0 108 13D 03C012
                                               ; 11F3 from 11DD (DD0,108,13D)
                                               ; 11F3 from 11ED (DD0,108,13D)
label_11f3:     LB      A, off(0015ch)         ; 11F3 0 108 13D F45C
                JEQ     label_11e7             ; 11F5 0 108 13D C9F0
                J       label_130f             ; 11F7 0 108 13D 030F13
                                               ; 11FA from 11CD (DD0,108,13D)
label_11fa:     JBS     off(00108h).0, label_121c ; 11FA 0 108 13D E8081F

                MOVB    r1, #090h              ;
                JBS     off(00124h).0, label_1217 ; if 3rd gear? jump
                MOVB    r1, #090h              ;
                JBS     off(00124h).1, label_1217 ; if 2nd gear? jump

                ;else if standing or in 1st r1 is based on RPM
                MOVB    r1, #084h              ; 1207 0 108 13D 9984
                LB      A, 0a6h                ; 1209 0 108 13D F5A6
                CMPB    A, #062h               ; 120B 0 108 13D C662
                JGE     label_1217             ; 120D 0 108 13D CD08
                MOVB    r1, #088h              ; 120F 0 108 13D 9988
                CMPB    A, #094h               ; 1211 0 108 13D C694
                JGE     label_1217             ; 1213 0 108 13D CD02
                MOVB    r1, #084h              ; 1215 0 108 13D 9984
                                               ; 1217 from 11FF (DD0,108,13D)
                                               ; 1217 from 1204 (DD0,108,13D)
                                               ; 1217 from 120D (DD0,108,13D)
                                               ; 1217 from 1213 (DD0,108,13D)
label_1217:     LB      A, r1                  ;
                CMPB    [DP], A                ; compare r1 to TPS (ADh)
                JLT     label_11e0             ; 121A 0 108 13D CAC4



                                               ; 121C from 11FA (DD0,108,13D)
label_121c:     CLRB    A                      ; 121C 0 108 13D FA
                CMPB    0a3h, #02eh            ; 121D 0 108 13D C5A3C02E
                JGE     label_1239             ; 1221 0 108 13D CD16
                JBS     off(00124h).0, label_1230 ; if 3rd gear? jump
                JBR     off(00124h).1, label_1239 ; if 2nd gear? jump
                ;else
                LB      A, #020h               ; 1229 0 108 13D 7720
                CMPB    [DP], #029h            ; 122B 0 108 13D C2C029
                SJ      label_1235             ; 122E 0 108 13D CB05
                                               ; 1230 from 1223 (DD0,108,13D)
label_1230:     LB      A, #018h               ; 1230 0 108 13D 7718
                CMPB    [DP], #019h            ; 1232 0 108 13D C2C019
                                               ; 1235 from 122E (DD0,108,13D)
label_1235:     SCAL    label_1275             ; 1235 0 108 13D 313E
                SJ      label_124c             ; 1237 0 108 13D CB13
                                               ; 1239 from 1221 (DD0,108,13D)
                                               ; 1239 from 1226 (DD0,108,13D)
label_1239:     JBS     off(00122h).7, label_1249 ; 1239 0 108 13D EF220D
                JBS     off(00123h).1, label_1242 ; 123C 0 108 13D E92303
                JBR     off(00123h).2, label_1247 ; 123F 0 108 13D DA2305
                                               ; 1242 from 123C (DD0,108,13D)
label_1242:     SB      off(00122h).7          ; 1242 0 108 13D C4221F
                SJ      label_1249             ; 1245 0 108 13D CB02
                                               ; 1247 from 123F (DD0,108,13D)
label_1247:     LB      A, #00ch               ; 1247 0 108 13D 770C
                                               ; 1249 from 1239 (DD0,108,13D)
                                               ; 1249 from 1245 (DD0,108,13D)
label_1249:     CAL     label_1269             ; 1249 0 108 13D 326912

;REAL delta TPS calcs HERE!!!!

;DB  057h,009h,0E1h,000h,057h,007h,0AFh,000h ; 312E
;DB  057h,007h,06Fh,000h,057h,008h,0C8h,000h ; 3136
;DB  057h,007h,07Dh,000h,057h,006h,07Dh,000h ; 313E
;DB  04Bh,006h,000h,000h,019h,003h,04Bh,000h ; 3146
;DB  057h,00Dh,088h,0FEh,029h,002h,04Bh,000h ; 314E
;
                                               ; 124C from 1237 (DD0,108,13D)
label_124c:     EXTND                          ; 124C 1 108 13D F8
                ADD     A, #0312eh             ; 124D 1 108 13D 862E31
                MOV     X1, A                  ; 1250 1 108 13D 50
                LB      A, [DP]                ; load TPS
                ADDB    A, #080h               ; A+=80h
                CMPCB   A, [X1]                ;
                JLT     label_125a             ; if(A>=[X1]) A = [X1];
                LCB     A, [X1]                ;
                                               ; 125A from 1256 (DD0,108,13D)
label_125a:     STB     A, r0                  ; r0 = A
                INC     X1                     ;
                LCB     A, [X1]                ; A = [X1+1]
                MULB                           ; A = AL*r0
                L       A, ACC                 ; 1260 1 108 13D E506
                ST      A, er3                 ; 1262 1 108 13D 8B
                INC     X1                     ; 1263 1 108 13D 70
                LC      A, [X1]                ; 1264 1 108 13D 90A8
                VCAL    5                      ; A = [X1+2]+r0*[X1+1]
                SJ      label_12ab             ; store 14ah

;********************************************
;62 = 1385,94 = 2374rpm
;if(rpm<2374 && rpm>= 1385)
;	A+=4h
;else if(rpm<1385)
;	A+=8h
                                               ; 1269 from 1285 (DD0,108,13D)
                                               ; 1269 from 1249 (DD0,108,13D)
label_1269:     CMPB    0a6h, #094h            ; 1269 0 108 13D C5A6C094
                JGE     label_1279             ; 126D 0 108 13D CD0A
                ADDB    A, #004h               ; 126F 0 108 13D 8604
                CMPB    0a6h, #062h            ; 1271 0 108 13D C5A6C062
                                               ; 1275 from 1235 (DD0,108,13D)
label_1275:     JGE     label_1279             ; 1275 0 108 13D CD02
                ADDB    A, #004h               ; 1277 0 108 13D 8604
                                               ; 1279 from 1275 (DD0,108,13D)
                                               ; 1279 from 126D (DD0,108,13D)
label_1279:     RT                             ; 1279 0 108 13D 01

;********************************************
;Seems to be delta TPS correction.
;14ah is 0 unless a largish change is TPS is
;detected.

; so it looks like this is gear dependant
;
                                               ; 127A from 11EA (DD1,108,13D)
label_127a:     LB      A, #024h               ; 127A 0 108 13D 7724
                JBS     off(00124h).0, label_1293 ; 127C 0 108 13D E82414
                LB      A, #02ah               ; 127F 0 108 13D 772A
                JBS     off(00124h).1, label_1293 ; 1281 0 108 13D E9240F
                CLRB    A                      ; 1284 0 108 13D FA
                CAL     label_1269             ; 1285 0 108 13D 326912

                STB     A, r0                  ; 1288 0 108 13D 88
                SRLB    A                      ; 1289 0 108 13D 63
                ADDB    A, r0                  ; 128A 0 108 13D 08
                CMPB    0a3h, #057h            ; 121deg. F
                JLT     label_1293             ; if hotter than, jump
                ADDB    A, #012h               ; 1291 0 108 13D 8612
                                               ; 1293 from 127C (DD0,108,13D)
                                               ; 1293 from 1281 (DD0,108,13D)
                                               ; 1293 from 128F (DD0,108,13D)
label_1293:     EXTND                          ; 1293 1 108 13D F8
                ADD     A, #03808h             ; 1294 1 108 13D 860838
                MOV     X1, A                  ; 1297 1 108 13D 50
                L       A, off(0014ah)         ; 1298 1 108 13D E44A
                ST      A, er0                 ; 129A 1 108 13D 88
                CMPC    A, 00004h[X1]          ; 129B 1 108 13D 90AD0400
                JGE     label_12a3             ; 129F 1 108 13D CD02
                INC     X1                     ; 12A1 1 108 13D 70
                INC     X1                     ; 12A2 1 108 13D 70
                                               ; 12A3 from 129F (DD1,108,13D)
label_12a3:     LC      A, [X1]                ; load code
                XCHG    A, er0                 ; a = code value, er0 = old value
                SUB     A, er0                 ; A = code value - oldvalue
                JGE     label_12ab             ; 12A8 1 108 13D CD01
                CLR     A                      ; 12AA 1 108 13D F9
                                               ; 12AB from 12A8 (DD1,108,13D)
                                               ; 12AB from 1267 (DD1,108,13D)
label_12ab:     ST      A, off(0014ah)         ; 12AB 1 108 13D D44A

;**************************************************
                JEQ     label_1325             ; 12AD 1 108 13D C976
                SB      r7.0                   ; 12AF 1 108 13D 2718
                RB      0feh.6                 ; 12B1 1 108 13D C5FE0E
                CLRB    off(0015ch)            ; 12B4 1 108 13D C45C15
                RB      off(00122h).3          ; 12B7 1 108 13D C4220B
                MOVB    off(001d2h), #00ah     ; 12BA 1 108 13D C4D2980A
                SJ      label_1333             ; 12BE 1 108 13D CB73
                                               ; 12C0 from 11F0 (DD0,108,13D)
label_12c0:     JBS     off(00122h).3, label_12e8 ; 12C0 0 108 13D EB2225
                JBS     off(00124h).0, label_1325 ; 12C3 0 108 13D E8245F
                JBR     off(00124h).1, label_12cf ; 12C6 0 108 13D D92406
                CMPB    0cbh, #038h            ; 12C9 0 108 13D C5CBC038
                JLT     label_1325             ; 12CD 0 108 13D CA56
                                               ; 12CF from 12C6 (DD0,108,13D)
label_12cf:     LB      A, off(001e3h)         ; 12CF 0 108 13D F4E3
                JNE     label_1325             ; 12D1 0 108 13D CE52
                CMPB    0ach, #06ch            ; 12D3 0 108 13D C5ACC06C
                JGE     label_1325             ; 12D7 0 108 13D CD4C
                LB      A, 0a6h                ; 12D9 0 108 13D F5A6
                CMPB    A, #05eh               ; 12DB 0 108 13D C65E
                JLT     label_1325             ; 12DD 0 108 13D CA46
                CMPB    A, #0beh               ; 12DF 0 108 13D C6BE
                JGE     label_1325             ; 12E1 0 108 13D CD42
                CMPB    A, #094h               ; 12E3 0 108 13D C694
                MB      off(00122h).4, C       ; 12E5 0 108 13D C4223C
                                               ; 12E8 from 12C0 (DD0,108,13D)
label_12e8:     MOVB    r2, #020h              ; 12E8 0 108 13D 9A20
                MOVB    r0, #004h              ; 12EA 0 108 13D 9804
                MOVB    r1, #0ffh              ; 12EC 0 108 13D 99FF
                JBR     off(00122h).4, label_12f7 ; 12EE 0 108 13D DC2206
                MOVB    r2, #00fh              ; 12F1 0 108 13D 9A0F
                MOVB    r0, #007h              ; 12F3 0 108 13D 9807
                MOVB    r1, #0ffh              ; 12F5 0 108 13D 99FF
                                               ; 12F7 from 12EE (DD0,108,13D)
label_12f7:     LB      A, #080h               ; 12F7 0 108 13D 7780
                SUBB    A, [DP]                ; 12F9 0 108 13D C2A2
                CMPB    A, r2                  ; 12FB 0 108 13D 4A
                JLT     label_12ff             ; 12FC 0 108 13D CA01
                LB      A, r2                  ; 12FE 0 108 13D 7A
                                               ; 12FF from 12FC (DD0,108,13D)
label_12ff:     MULB                           ; 12FF 0 108 13D A234
                CMPB    ACCH, #000h            ; 1301 0 108 13D C507C000
                JNE     label_130c             ; 1305 0 108 13D CE05
                XCHGB   A, r1                  ; 1307 0 108 13D 2110
                SUBB    A, r1                  ; 1309 0 108 13D 29
                JGE     label_131e             ; 130A 0 108 13D CD12
                                               ; 130C from 1305 (DD0,108,13D)
label_130c:     CLRB    A                      ; 130C 0 108 13D FA
                SJ      label_131e             ; 130D 0 108 13D CB0F
                                               ; 130F from 11F7 (DD0,108,13D)
label_130f:     MOVB    r0, #003h              ; 130F 0 108 13D 9803
                CMPB    0a6h, #094h            ; 1311 0 108 13D C5A6C094
                JGE     label_1319             ; 1315 0 108 13D CD02
                MOVB    r0, #003h              ; 1317 0 108 13D 9803
                                               ; 1319 from 1315 (DD0,108,13D)
label_1319:     LB      A, off(0015ch)         ; 1319 0 108 13D F45C
                ADDB    A, r0                  ; 131B 0 108 13D 08
                JLT     label_1325             ; 131C 0 108 13D CA07
                                               ; 131E from 130A (DD0,108,13D)
                                               ; 131E from 130D (DD0,108,13D)
label_131e:     STB     A, off(0015ch)         ; 131E 0 108 13D D45C
                SB      off(00122h).3          ; 1320 0 108 13D C4221B
                SJ      label_132b             ; 1323 0 108 13D CB06

;***************************************************************************
; fuel calculation routine. This takes all the corrections/trims/whatever
; and does some calcs to get the final fuel values: 148h and 144h and 146h

;what does it use?

;hred comments:
;$16A : calculated at 97D for starting or 12F8 for normal running

;I suppose the lambda correction is $15E or $14A...
;I suppose the lambda calculations are between C2C and may be 10A8...
;end hred comments

;R:
;00140h/141h non vtec fuel value (from table)
;00142h/143h vtec fuel table value
;0014ah/14bh (90% sure its delta tps)
;0014ch/14dh battery ? (0)
;0014eh/14fh AC related?
;00150h/151h TPS related? (0)

;00152h idle adjust connector trim (pin B20)
;00158h 0-5V trim
;0015ah IAT fuel trim (vector at 372bh. vcal_0)
;0015bh
;0015ch
;0015eh/15fh

;00166h/167h (340 - 400) (temp?)
;00169h based on map image (b4h).value between 51h and dfh
;0016ah/16bh ect? between 0 and 100h (0)
;0016ch/16dh another ect?
;0016eh
;0016fh
;00168h

;W:
;0015eh/15fh

;Final Fuel values:
;00144h/145h : ([140h or 142h] * [15eh]/10000h)/2
;00146h/147h : ([16ah]* ([14ah]*[166h]/100h)/100h) + [14ch] + [150h] + [152h] + [14eh]
;00148h/149h : [144h] + [146h] - [14eh]
                                               ; 1325 from 11E7 (DD1,108,13D)
                                               ; 1325 from 12C3 (DD0,108,13D)
                                               ; 1325 from 12CD (DD0,108,13D)
                                               ; 1325 from 12D1 (DD0,108,13D)
                                               ; 1325 from 12D7 (DD0,108,13D)
                                               ; 1325 from 12DD (DD0,108,13D)
                                               ; 1325 from 12E1 (DD0,108,13D)
                                               ; 1325 from 131C (DD0,108,13D)
                                               ; 1325 from 12AD (DD1,108,13D)

                                               ;122 = 21 or 0, (10101)
label_1325:     CLRB    off(0015ch)            ; 1325 1 108 13D C45C15
                RB      off(00122h).3          ; 1328 1 108 13D C4220B
                                               ; 132B from 1323 (DD0,108,13D)
label_132b:     CLR     off(0014ah)            ; 132B 1 108 13D B44A15
                RB      off(00122h).7          ; 132E 1 108 13D C4220F
                RB      r7.0                   ; 1331 1 108 13D 2708
                                               ; 1333 from 12BE (DD1,108,13D)
label_1333:     SRLB    r7                     ; 1333 1 108 13D 27E7
                RB      off(00122h).5          ; 1335 1 108 13D C4220D
                MB      off(00122h).5, C       ; 1338 1 108 13D C4223D
                JGE     label_1340             ; 133B 1 108 13D CD03
                JEQ     label_1340             ; 133D 1 108 13D C901
                RC                             ; 133F 1 108 13D 95
                                               ; 1340 from 133B (DD1,108,13D)
                                               ; 1340 from 133D (DD1,108,13D)
label_1340:     MB      off(00122h).6, C       ; 1340 1 108 13D C4223E
                L       A, off(0016ch)         ; 1343 1 108 13D E46C
                CMP     A, #00100h             ; 1345 1 108 13D C60001
                JEQ     label_1391             ; 1348 1 108 13D C947
                ST      A, er0                 ; 134A 1 108 13D 88
                CLRB    r7                     ; 134B 1 108 13D 2715
                MOV     X1, #001b3h            ; 134D 1 108 13D 60B301
                MOV     X2, #00133h            ; 1350 1 108 13D 613301
                JBR     off(0011ah).5, label_135e ; 1353 1 108 13D DD1A08
                MOVB    r7, #008h              ; 1356 1 108 13D 9F08
                MOV     X1, #001d9h            ; 1358 1 108 13D 60D901
                MOV     X2, #00133h            ; 135B 1 108 13D 613301
                                               ; 135E from 1353 (DD1,108,13D)
label_135e:     CMP     A, X1                  ; 135E 1 108 13D 90C2
                JGE     label_1367             ; 1360 1 108 13D CD05
                ADDB    r7, #004h              ; 1362 1 108 13D 278004
                CMP     A, X2                  ; 1365 1 108 13D 91C2
                                               ; 1367 from 1360 (DD1,108,13D)
label_1367:     LB      A, r7                  ; 1367 0 108 13D 7F
                JGE     label_137c             ; 1368 0 108 13D CD12
                LB      A, #010h               ; 136A 0 108 13D 7710
                CMPB    0a4h, #0a6h            ; 136C 0 108 13D C5A4C0A6
                JGE     label_137c             ; 1370 0 108 13D CD0A
                LB      A, #014h               ; 1372 0 108 13D 7714
                CMPB    0a4h, #034h            ; 1374 0 108 13D C5A4C034
                JGE     label_137c             ; 1378 0 108 13D CD02
                LB      A, #018h               ; 137A 0 108 13D 7718
                                               ; 137C from 1368 (DD0,108,13D)
                                               ; 137C from 1370 (DD0,108,13D)
                                               ; 137C from 1378 (DD0,108,13D)
label_137c:     EXTND                          ; 137C 1 108 13D F8
                LC      A, 037b5h[ACC]         ; 137D 1 108 13D B506A9B537
                ST      A, er1                 ; 1382 1 108 13D 89
                LB      A, off(0016eh)         ; 1383 0 108 13D F46E
                SUBB    A, r2                  ; 1385 0 108 13D 2A
                STB     A, off(0016eh)         ; 1386 0 108 13D D46E
                LB      A, r0                  ; 1388 0 108 13D 78
                SBCB    A, r3                  ; 1389 0 108 13D 3B
                STB     A, r2                  ; 138A 0 108 13D 8A
                LB      A, r1                  ; 138B 0 108 13D 79
                SBCB    A, #000h               ; 138C 0 108 13D B600
                STB     A, r3                  ; 138E 0 108 13D 8B
                JNE     label_1398             ; 138F 0 108 13D CE07
                                               ; 1391 from 1348 (DD1,108,13D)
label_1391:     MOV     er1, #00100h           ; 1391 0 108 13D 45980001
                MOV     off(0016ah), er1       ; 1395 0 108 13D 457C6A
                                               ; 1398 from 138F (DD0,108,13D)
label_1398:     MOV     off(0016ch), er1       ; 1398 0 108 13D 457C6C
                LB      A, off(00158h)         ; A = [158h]
                MOVB    r1, #001h              ; 139D 0 108 13D 9901
                JBS     off(00158h).7, label_13a3 ; 139F 0 108 13D EF5801
                INCB    r1                     ; 13A2 0 108 13D A9
                                               ; 13A3 from 139F (DD0,108,13D)
label_13a3:     ADDB    A, off(0015ah)         ; 13A3 0 108 13D 875A
                STB     A, r0                  ; r0 = [158h]+[15ah]
                JGE     label_13a9             ; 13A6 0 108 13D CD01
                INCB    r1                     ; 13A8 0 108 13D A9
                                               ; 13A9 from 13A6 (DD0,108,13D)
label_13a9:     LB      A, off(0016fh)         ; 13A9 0 108 13D F46F
                JEQ     label_13b4             ; 13AB 0 108 13D C907
                STB     A, ACCH                ; 13AD 0 108 13D D507
                CLRB    A                      ; 13AF 0 108 13D FA
                MUL                            ; 13B0 0 108 13D 9035
                MOV     er0, er1               ; 13B2 0 108 13D 4548
                                               ; 13B4 from 13AB (DD0,108,13D)
label_13b4:     LB      A, off(0015ch)         ; 13B4 0 108 13D F45C
                JEQ     label_13bf             ; 13B6 0 108 13D C907
                STB     A, ACCH                ; 13B8 0 108 13D D507
                CLRB    A                      ; 13BA 0 108 13D FA
                MUL                            ; 13BB 0 108 13D 9035
                MOV     er0, er1               ; 13BD 0 108 13D 4548
                                               ; 13BF from 13B6 (DD0,108,13D)
label_13bf:     J       label_31ee             ; 13BF 0 108 13D 03EE31
                DB  000h ; 13C2
                                               ; 13C3 from 3206 (DD0,108,13D)
label_13c3:     MOVB    ACCH, #001h            ; 13C3 0 108 13D C5079801
                MUL                            ; 13C7 0 108 13D 9035
                MOVB    r1, r2                 ; 13C9 0 108 13D 2249
                MOVB    r0, ACCH               ; 13CB 0 108 13D C50748
                                               ; 13CE from 3209 (DD0,108,13D)
label_13ce:     CLRB    r5                     ; 13CE 0 108 13D 2515
                LB      A, off(00168h)         ; 13D0 0 108 13D F468
                CMPB    A, off(0015bh)         ; 13D2 0 108 13D C75B
                JGE     label_13d8             ; 13D4 0 108 13D CD02
                LB      A, off(0015bh)         ; 13D6 0 108 13D F45B
                                               ; 13D8 from 13D4 (DD0,108,13D)
label_13d8:     STB     A, r4                  ; 13D8 0 108 13D 8C
                JBS     off(0011bh).0, label_13df ; 13D9 0 108 13D E81B03
                JBR     off(0011ch).0, label_13eb ; 13DC 0 108 13D D81C0C
                                               ; 13DF from 13D9 (DD0,108,13D)
label_13df:     MOVB    r4, off(00169h)        ; 13DF 0 108 13D C4694C
                L       A, #00100h             ; 13E2 1 108 13D 670001
                CMPB    0a4h, #028h            ; 13E5 1 108 13D C5A4C028
                JGE     label_13ed             ; 13E9 1 108 13D CD02
                                               ; 13EB from 13DC (DD0,108,13D)
label_13eb:     L       A, off(0016ch)         ; 13EB 1 108 13D E46C
                                               ; 13ED from 13E9 (DD1,108,13D)
label_13ed:     MUL                            ; 13ED 1 108 13D 9035
                MOVB    r1, r2                 ; 13EF 1 108 13D 2249
                MOVB    r0, ACCH               ; 13F1 1 108 13D C50748
                L       A, er2                 ; 13F4 1 108 13D 36
                MUL                            ; 13F5 1 108 13D 9035
                MOV     er0, er1               ; 13F7 1 108 13D 4548
                MOV     er2, #00040h           ; 13F9 1 108 13D 46984000
                DIV                            ; 13FD 1 108 13D 9037
                ST      A, off(0015eh)         ; 13FF 1 108 13D D45E
                MB      C, 0feh.6              ; limp mode? Weird fuel cut?
                JGE     label_1417             ; 1404 1 108 13D CD11
                CLR     A                      ; 1406 1 108 13D F9
                AND     IE, #00080h            ; 1407 1 108 13D B51AD08000
                RB      PSWH.0                 ; 140C 1 108 13D A208
                ST      A, off(00144h)         ; 140E 1 108 13D D444
                ST      A, off(00146h)         ; 1410 1 108 13D D446
                ST      A, off(00148h)         ; 1412 1 108 13D D448
                J       label_152b             ; 1414 1 108 13D 032B15




                                               ; 1417 from 1404 (DD1,108,13D)
label_1417:     MOV     er0, off(00142h)       ; load the vtec fuel value
                JBS     off(00129h).7, label_1436 ; if vtec is on then jump
                MB      C, P1.1                ; move the vtec bit into C
                JGE     label_1431             ; if C = 0 jump to non vtec
                LB      A, #0e0h               ; 5429 rpm
                JBR     off(0011dh).7, label_1429 ;
                LB      A, #0d8h               ; 4977 rpm


                                               ; 1429 from 1424 (DD0,108,13D)
label_1429:     CMPB    A, 0a6h                ; compare rpm
                MB      off(0011dh).7, C       ; if constant< rpm c = 1
                JLT     label_1434             ; if c = 1 jump

                ; 1431 from 1420 if vtec is off
label_1431:     MOV     er0, off(00140h)       ; else move non vtec fuel into er0

                ; 1434 from 142F (DD0,108,13D)
label_1434:     L       A, off(0015eh)         ; load what?

                ; 1436 from 141A (DD1,108,13D)
label_1436:     MUL                            ; er1A = A*er0 = fuel value * [15eh]
                SRL     er1                    ; (fuel value * [15eh]/10000h)/2
                ROR     A                      ; fuel value * [15eh]/2
                LB      A, r2                  ; load er1 low byte
                L       A, ACC                 ; dd = 1
                SWAP                           ; AccH = r2, AccL = high byte from multiplication
                CMPB    r3, #000h              ; compare er1 high byte to 0
                JEQ     label_1447             ; if mult result was <= 1ffffffh jump
                L       A, #0ffffh             ; else load ffffh into the acc
                                               ; 1447 from 1442 (DD1,108,13D)
label_1447:     MOV     X1, A                  ; put our A val into X1
                L       A, off(0014ah)         ; load [14ah]
                MOV     er0, off(00166h)       ; er0 = [166h]
                MUL                            ; er1A = [14ah]*[166h]
                MOVB    r1, r2                 ; move er1 low into er0 high
                MOVB    r0, ACCH               ; move AH into er0 low
                L       A, off(0016ah)         ;
                MUL                            ; er1A = A*er0 = [16ah]* ([14ah]*[166h]/100h)
                MOVB    r7, r2                 ; seed er3
                MOVB    r6, ACCH               ; er3 = ([16ah]* ([14ah]*[166h]/100h)/100h)
                L       A, off(0014ch)         ; er3 += A
                VCAL    5                      ; er3 += 14ch (battery)
                L       A, off(00150h)         ;
                VCAL    5                      ; er3 += 150h (TPS related)
                LB      A, off(00152h)         ;
                EXTND                          ;
                VCAL    5                      ; add 152h (idle adj conn)
                ST      A, er2                 ; store these in er2


                L       A, off(0014eh)         ; AC related?
                VCAL    5                      ;
                AND     IE, #00080h            ; 146B 1 108 13D B51AD08000
                RB      PSWH.0                 ; 1470 1 108 13D A208
                ST      A, off(00146h)         ; ([16ah]* ([14ah]*[166h]/100h)/100h) + 14ch + 150h + 152h + 14eh
                L       A, X1                  ;
                ST      A, off(00144h)         ; 15eh* fuelval/2
                SB      PSWH.0                 ; 1477 1 108 13D A218
                L       A, 0cch                ; 1479 1 108 13D E5CC
                ST      A, IE                  ; 147B 1 108 13D D51A
                L       A, X1                  ; 147D 1 108 13D 40
                ADD     A, er2                 ; 147E 1 108 13D 0A
                JGE     label_1484             ; 147F 1 108 13D CD03
                L       A, #0ffffh             ; 1481 1 108 13D 67FFFF
                                               ; 1484 from 147F (DD1,108,13D)
label_1484:     MOV     er0, off(00148h)       ; get old fuel val
                ST      A, off(00148h)         ; store the final fuel value...

;**********************************************************************************




                CLRB    r5                     ; 
                CMPB    0a3h, #044h            ; 
                JGE     label_14d4             ; if under 137deg F, jump
                CMPB    0a6h, #0feh            ; 
                JLT     label_149a             ; if under 7200 RPM. Normal!
                JBS     off(00122h).6, label_14d4 ; 1497 1 108 13D EE223A
                                               ; 149A from 1495 (DD1,108,13D)
label_149a:     CMPB    0a6h, #037h            ; 
                JGE     label_14a8             ; if over idle jump
                SUB     A, er0                 ; else A = new value - old value
                JLT     label_14a8             ; if new < old, jump
                CMP     A, #00080h             ; else if the difference is
                JGE     label_14be             ; over 80h, jump

                ;////////
                                               ; 14A8 from 149E (DD1,108,13D)
                                               ; 14A8 from 14A1 (DD1,108,13D)
label_14a8:     CLR     A                      ; 
                CMPB    0a3h, #02eh            ; 
                JGE     label_14fd             ; if colder than 156deg F
                CMPB    0a6h, #0a9h            ; 
                JGE     label_14fd             ; if over 2200 RPM
                JBR     off(00122h).6, label_14fd ;
                MOV     er0, #00100h           ;
                SJ      label_14e9             ;

                ;////////
                                               ; 14BE from 14A6 (DD1,108,13D)
label_14be:     MOV     er0, #006d6h           ; 
                CMP     A, er0                 ; 
                JGE     label_14c6             ; 
                ST      A, er0                 ; 
                                               ; 14C6 from 14C3 (DD1,108,13D)
label_14c6:     CMPB    0a6h, #014h            ; SUPER LOW RPM
                L       A, #000b0h             ; 14CA 1 108 13D 67B000
                JLT     label_14ed             ; 14CD 1 108 13D CA1E
                L       A, #000b0h             ; 14CF 1 108 13D 67B000
                SJ      label_14ed             ; 14D2 1 108 13D CB19

                ;
                                               ; 14D4 from 148F (DD1,108,13D)
                                               ; 14D4 from 1497 (DD1,108,13D)
label_14d4:     INCB    r5                     ; 14D4 1 108 13D AD
                MOV     X1, #037f8h            ; 14D5 1 108 13D 60F837
                LB      A, 0a3h                ; 14D8 0 108 13D F5A3
                VCAL    0                      ; 14DA 0 108 13D 10
                STB     A, r0                  ; 14DB 0 108 13D 88
                CLRB    r1                     ; 14DC 0 108 13D 2115
                SLL     er0                    ; 14DE 0 108 13D 44D7
                L       A, off(0016ah)         ; some ECT correction
                MUL                            ; 14E2 1 108 13D 9035
                LB      A, r2                  ; 14E4 0 108 13D 7A
                L       A, ACC                 ; 14E5 1 108 13D E506
                SWAP                           ; 14E7 1 108 13D 83
                ST      A, er0                 ; 14E8 1 108 13D 88

                ;/////////
                                               ; 14E9 from 14BC (DD1,108,13D)
label_14e9:     L       A, off(0014ah)         ; delta TPS
                JEQ     label_14fd             ; 14EB 1 108 13D C910
                                               ; 14ED from 14CD (DD1,108,13D)
                                               ; 14ED from 14D2 (DD1,108,13D)
label_14ed:     MUL                            ; 14ED 1 108 13D 9035
                LB      A, r3                  ; 14EF 0 108 13D 7B
                JNE     label_14fa             ; 14F0 0 108 13D CE08
                LB      A, r2                  ; 14F2 0 108 13D 7A
                L       A, ACC                 ; 14F3 1 108 13D E506
                SWAP                           ; 14F5 1 108 13D 83
                ADD     A, off(0014ch)         ; some battery trim
                JGE     label_14fd             ; 14F8 1 108 13D CD03
                                               ; 14FA from 14F0 (DD0,108,13D)
label_14fa:     L       A, #0ffffh             ; 14FA 1 108 13D 67FFFF
                                               ; 14FD from 14AD (DD1,108,13D)
                                               ; 14FD from 14B3 (DD1,108,13D)
                                               ; 14FD from 14B5 (DD1,108,13D)
                                               ; 14FD from 14EB (DD1,108,13D)
                                               ; 14FD from 14F8 (DD1,108,13D)
label_14fd:     ST      A, er3                 ; 14FD 1 108 13D 8B
                JBS     off(0010dh).0, label_1502 ; 14FE 1 108 13D E80D01
                CLR     A                      ; 1501 1 108 13D F9
                                               ; 1502 from 14FE (DD1,108,13D)
label_1502:     CLRB    r5                     ; 1502 1 108 13D 2515
                JBS     off(00118h).7, label_1514 ; if auto jump
                CMPB    0a3h, #029h            ; 1507 1 108 13D C5A3C029
                JGE     label_1514             ; 150B 1 108 13D CD07
                JBR     off(00124h).2, label_1514 ; 150D 1 108 13D DA2404
                JBS     off(00123h).3, label_1514 ; 1510 1 108 13D EB2301
                INCB    r5                     ; 1513 1 108 13D AD
                                               ; 1514 from 1504 (DD1,108,13D)
                                               ; 1514 from 150B (DD1,108,13D)
                                               ; 1514 from 150D (DD1,108,13D)
                                               ; 1514 from 1510 (DD1,108,13D)
label_1514:     AND     IE, #00080h            ; 1514 1 108 13D B51AD08000
                RB      PSWH.0                 ; 1519 1 108 13D A208
                ST      A, 0d0h                ; 151B 1 108 13D D5D0
                ST      A, 0d2h                ; 151D 1 108 13D D5D2
                L       A, er3                 ; 151F 1 108 13D 37
                JBR     off(00123h).1, label_1529 ; 1520 1 108 13D D92306
                L       A, off(00148h)         ; 1523 1 108 13D E448
                JBR     off(0010dh).0, label_1529 ; 1525 1 108 13D D80D01
                CLR     A                      ; 1528 1 108 13D F9
                                               ; 1529 from 1520 (DD1,108,13D)
                                               ; 1529 from 1525 (DD1,108,13D)
label_1529:     ST      A, 0d4h                ; 1529 1 108 13D D5D4
                                               ; 152B from 1414 (DD1,108,13D)
label_152b:     SB      PSWH.0                 ; 152B 1 108 13D A218
                L       A, 0cch                ; 152D 1 108 13D E5CC
                ST      A, IE                  ; 152F 1 108 13D D51A
                CLR     A                      ; 1531 1 108 13D F9
                CLRB    A                      ; 1532 0 108 13D FA
                LC      A, 0373dh[ACC]         ; A = 5ddh
                MOV     DP, #001e8h            ; 1538 0 108 13D 62E801
                STB     A, r0                  ; 153B 0 108 13D 88
                LB      A, ACCH                ; value is ddh

                CMPB    A, 0ach                ; open/closed loop check?
                MOV     er1, #0036bh           ; 1541 0 108 13D 45986B03
                JLT     label_1558             ; 1545 0 108 13D CA11
                INC     DP                     ; 1547 0 108 13D 72
                
                CMPB    0a3h, #002h            ; SUPER HOT
                JLT     label_1555             ; 
                CMPB    0a3h, #002h            ; SUPER HOT
                JLT     label_1572             ; 
                
                INC     DP                     ; 1554 0 108 13D 72
                                               ; 1555 from 154C (DD0,108,13D)
label_1555:     MOV     er1, off(00156h)       ; 1555 0 108 13D B45649
                                               ; 1558 from 1545 (DD0,108,13D)
label_1558:     L       A, 0d6h                ; 1558 1 108 13D E5D6
                SUB     A, off(0014eh)         ; AC fuel trim
                JLT     label_1567             ; 155C 1 108 13D CA09
                CMP     er1, A                 ; 155E 1 108 13D 45C1
                JGE     label_1567             ; 1560 1 108 13D CD05
                LB      A, [DP]                ; 1562 0 108 13D F2
                JNE     label_1572             ; 1563 0 108 13D CE0D
                SJ      label_1573             ; 1565 0 108 13D CB0C
                                               ; 1567 from 155C (DD1,108,13D)
                                               ; 1567 from 1560 (DD1,108,13D)
label_1567:     MOVB    off(001e8h), #000h     ; 1567 1 108 13D C4E89800
                MOVB    off(001e9h), r0        ; 156B 1 108 13D 207CE9
                MOVB    off(001eah), #000h     ; 156E 1 108 13D C4EA9800
                                               ; 1572 from 1552 (DD0,108,13D)
                                               ; 1572 from 1563 (DD0,108,13D)
label_1572:     RC                             ; 1572 0 108 13D 95
                                               ; 1573 from 1565 (DD0,108,13D)
label_1573:     MB      off(00122h).0, C       ; 1573 0 108 13D C42238
                SB      0feh.5                 ; 1576 0 108 13D C5FE1D


                ;from ?limp mode code? after TPS storage into A5
                                               ; 1579 from 0A19 (DD1,108,13D)
label_1579:     CAL     label_327e             ;

;label_327e:     SB      0feh.4                 ; indicate we are finished with main code one time
;                AND     IE, #00080h            ; 3281 1 108 13D B51AD08000
;                RT

                RB      PSWH.0                 ; 157C 1 108 13D A208
                RB      off(00119h).0          ; 157E 1 108 13D C41908
                J       label_03db             ; return from interrupt

;main code finish
;done with fuel...
;****************************************************************************
;VSS interrupt
                                               ; 1584 from 0008 (DD0,???,???)
int_INT0:       L       A, IE                  ; save
                PUSHS   A                      ; old interrupt enable
                L       A, 0ceh                ;
                ST      A, IE                  ; IE = [ceh]
                SB      PSWH.0                 ; setPSWH.0
                MOV     LRB, #00020h           ; LRB = 20h
                SB      0feh.0                 ; set feh.0

                ;c8h|c9h = timer1
                ;c6h|c7h = timer1 from last interrupt
                ;cah = old e2h
                ;e2h = 0 if no TM1 overflow, 1 if overfow and TM1>8000h
                L       A, TM1                 ;
                XCHG    A, 0c8h                ;
                ST      A, 0c6h                ;
                LB      A, 0e2h                ;
                STB     A, 0cah                ;
                CLRB    0e2h                   ; e2h = 0...
                RB      IRQ.6                  ; if timer1 has NOT overflowed then we jump
                JEQ     label_15bc             ; ...
                MB      C, off(0011eh).6       ; else
                MB      off(0011eh).7, C       ; 11eh.7 = old timer 1 overflow in int_INT0
                SB      off(0011eh).6          ; 11eh.6 = timer 1 overflow in int_INT0
                MB      C, 0c9h.7              ; if TM1 < 1000 0000 0000 0000b
                JGE     label_15b9             ; jump
                INCB    0e2h                   ; else e2h = 1
                SJ      label_15bc             ; and we skip
                                               ; 15B9 from 15B2 (DD0,100,???)
label_15b9:     INCB    0cah                   ; cah++
                                               ; 15BC from 15A4 (DD0,100,???)
                                               ; 15BC from 15B7 (DD0,100,???)
label_15bc:     RB      PSWH.0                 ; reset PSWH.0
                POPS    A                      ;
                ST      A, IE                  ; reset old interrupt enable val
                RTI                            ;

;**************************************************************************

                                               ; 15C2 from 000E (DD0,???,???)
int_serial_rx_BRG: SB      0feh.1                 ; 15C2 0 ??? ??? C5FE19
                L       A, ADCR7               ; 15C5 1 ??? ??? E56E
                ST      A, 0aah                ; 15C7 1 ??? ??? D5AA
                RTI                            ; 15C9 1 ??? ??? 02

;*****************************************************************************
; I think this turns off the injectors
                                               ; 15CA from 0010 (DD0,???,???)
int_timer_0_overflow: MOV     LRB, #00040h           ; 15CA 0 200 ??? 574000
                L       A, off(00214h)         ; 15CD 1 200 ??? E414
                JNE     label_1603             ; 15CF 1 200 ??? CE32
                L       A, off(00216h)         ; 15D1 1 200 ??? E416
                JEQ     label_1638             ; 15D3 1 200 ??? C963

                ;case 1
                ;A = 216h
                LB      A, off(0021bh)         ; 15D5 0 200 ??? F41B
                MB      C, ACC.7               ; 15D7 0 200 ??? C5062F
                ROLB    A                      ; AL=AL*2/C=Reserve/AL=AL+B7(21bh)
                ORB     off(0021ch), A         ; 15DB 0 200 ??? C41CE1
                MB      C, ACC.7               ; 15DE 0 200 ??? C5062F
                ROLB    A                      ; 15E1 0 200 ??? 33


                STB     A, off(0021bh)         ; 15E2 0 200 ??? D41B
                ORB     A, off(0021ch)         ; 15E4 0 200 ??? E71C
                ANDB    A, #00fh               ; 15E6 0 200 ??? D60F
                STB     A, off(0021ch)         ; 15E8 0 200 ??? D41C
                CAL     label_2a61             ; 15EA 0 200 ??? 32612A

;label_2a61:     CMP     TM0, #0000dh           ; compare timer0 to 13
;                JGE     label_2a72             ; if greater, jump
;                RB      IRQ.7                  ; reset timer 1 int
;                JEQ     label_2a61             ; if it was 0, loop
;                SCAL    label_2a85             ; else call 2a85 (timer 1)
;                MOV     LRB, #00040h           ; reset to page 2
;                                               ; 2A72 from 2A66 (DD0,200,???)
;                                               ; 2A72 from 2A77 (DD0,200,???)
;label_2a72:     CMP     TM0, #00018h           ;
;                JLT     label_2a72             ; wait til TM0 >= 18h
;                RT                             ;

                ORB     P2, off(0021ch)        ; Possibly turn off an injector.
                L       A, off(00216h)         ; 15F1 1 200 ??? E416
                ST      A, TM0                 ; 15F3 1 200 ??? D530
                CAL     label_2a7a             ; 15F5 1 200 ??? 327A2A

;label_2a7a:     RB      IRQ.7                  ; 2A7A 1 200 ??? C5180F
;                JEQ     label_2a84             ; 2A7D 1 200 ??? C905
;                SCAL    label_2a85             ; 2A7F 1 200 ??? 3104
;                MOV     LRB, #00040h           ; 2A81 1 200 ??? 574000
;                                               ; 2A84 from 2A7D (DD1,200,???)
;label_2a84:     RT                             ; 2A84 1 200 ??? 01

                MOV     off(00214h), off(00218h) ; 15F8 1 200 ??? B4187C14
                L       A, #0ffffh             ; 15FC 1 200 ??? 67FFFF
                ST      A, off(00216h)         ; 15FF 1 200 ??? D416
                SJ      label_1629             ; 1601 1 200 ??? CB26


                ;case2
                ;A = 214h
                                               ; 1603 from 15CF (DD1,200,???)
label_1603:     LB      A, off(0021bh)         ; 1603 0 200 ??? F41B
                MB      C, ACC.7               ; 1605 0 200 ??? C5062F
                ROLB    A                      ; 1608 0 200 ??? 33

                STB     A, off(0021bh)         ; 1609 0 200 ??? D41B
                ANDB    A, #00fh               ; 160B 0 200 ??? D60F
                ORB     off(0021ch), A         ; 160D 0 200 ??? C41CE1
                CAL     label_2a61             ; 1610 0 200 ??? 32612A
                ORB     P2, off(0021ch)        ; 1613 0 200 ??? C524E31C
                L       A, off(00214h)         ; 1617 1 200 ??? E414
                ST      A, TM0                 ; 1619 1 200 ??? D530
                CAL     label_2a7a             ; 161B 1 200 ??? 327A2A
                MOV     off(00214h), off(00216h) ; 161E 1 200 ??? B4167C14
                MOV     off(00216h), off(00218h) ; 1622 1 200 ??? B4187C16
                L       A, #0ffffh             ; 1626 1 200 ??? 67FFFF
                                               ; 1629 from 1601 (DD1,200,???)
                                               ; 1629 from 1662 (DD1,200,???)
label_1629:     ST      A, off(00218h)         ; 1629 1 200 ??? D418
                CMPB    off(0021ch), #00fh     ; 162B 1 200 ??? C41CC00F
                JNE     label_1637             ; 162F 1 200 ??? CE06
                RB      TCON0.4                ; 1631 1 200 ??? C5400C
                RB      IRQ.4                  ; 1634 1 200 ??? C5180C
                                               ; 1637 from 162F (DD1,200,???)
label_1637:     RTI                            ; 1637 1 200 ??? 02

				;case 3
				;A = 218h
                                               ; 1638 from 15D3 (DD1,200,???)
label_1638:     L       A, off(00218h)         ; 1638 1 200 ??? E418
                JEQ     label_1664             ; 163A 1 200 ??? C928
                LB      A, off(0021bh)         ; 163C 0 200 ??? F41B
                XORB    A, #0ffh               ; 163E 0 200 ??? F6FF
                ANDB    A, #00fh               ; 1640 0 200 ??? D60F
                ORB     off(0021ch), A         ; 1642 0 200 ??? C41CE1
                LB      A, off(0021bh)         ; 1645 0 200 ??? F41B
                MB      C, ACC.0               ; 1647 0 200 ??? C50628
                RORB    A                      ; 164A 0 200 ??? 43
                STB     A, off(0021bh)         ; 164B 0 200 ??? D41B
                CAL     label_2a61             ; 164D 0 200 ??? 32612A
                ORB     P2, off(0021ch)        ; 1650 0 200 ??? C524E31C
                L       A, off(00218h)         ; 1654 1 200 ??? E418
                ST      A, TM0                 ; 1656 1 200 ??? D530
                                               ; 1658 from 166F (DD1,200,???)
label_1658:     CAL     label_2a7a             ; 1658 1 200 ??? 327A2A
                L       A, #0ffffh             ; 165B 1 200 ??? 67FFFF
                ST      A, off(00214h)         ; 165E 1 200 ??? D414
                ST      A, off(00216h)         ; 1660 1 200 ??? D416
                SJ      label_1629             ; 1662 1 200 ??? CBC5
                                               ; 1664 from 163A (DD1,200,???)
label_1664:     MOVB    off(0021ch), #00fh     ; 1664 1 200 ??? C41C980F
                CAL     label_2a61             ; 1668 1 200 ??? 32612A
                ORB     P2, #00fh              ; Injectors OFF!!
                SJ      label_1658             ; 166F 1 200 ??? CBE7

;*******************************************************************************
;crank position sensor?
                                               ; 1671 from 0014 (DD0,???,???)
int_timer_1_overflow: AND     IE, #00080h            ; 1671 0 ??? ??? B51AD08000
                SB      PSWH.0                 ; 1676 0 ??? ??? A218
                MOV     LRB, #00020h           ; 1678 0 100 ??? 572000

                MB      C, off(0011eh).6       ; 167B 0 100 ??? C41E2E
                MB      off(0011eh).7, C       ; 167E 0 100 ??? C41E3F
                SB      off(0011eh).6          ; 1681 0 100 ??? C41E1E
                L       A, 0ceh                ; 1684 1 100 ??? E5CE
                ST      A, IE                  ; 1686 1 100 ??? D51A
                RB      0fdh.4                 ; 1688 1 100 ??? C5FD0C
                JEQ     label_1691             ; 168B 1 100 ??? C904
                ANDB    off(0011eh), #03fh     ; 3fh = 0011 1111
                                               ; 1691 from 168B (DD1,100,???)
label_1691:     INCB    0e2h                   ; 1691 1 100 ??? C5E216


                L       A, 0cch                ; 1694 1 100 ??? E5CC
                RB      PSWH.0                 ; 1696 1 100 ??? A208
                ST      A, IE                  ; 1698 1 100 ??? D51A
                RTI                            ; 169A 1 100 ??? 02
;************************************************************************

;IACV control
                                               ; 169B from 0022 (DD0,???,???)
int_PWM_timer:  L       A, 0ceh                ; 169B 1 ??? ??? E5CE
                ST      A, IE                  ; 169D 1 ??? ??? D51A
                SB      PSWH.0                 ; 169F 1 ??? ??? A218
                MOV     LRB, #00040h           ; 16A1 1 200 ??? 574000
                JBR     off(0021dh).0, label_16c6 ; 16A4 1 200 ??? D81D1F
                RB      off(0021dh).0          ; 16A7 1 200 ??? C41D08
                MOV     PWMR1, #0fd58h         ; 16AA 1 200 ??? B5769858FD
                L       A, ADCR4               ; 16AF 1 200 ??? E568
                ST      A, 0a8h                ; 16B1 1 200 ??? D5A8
                L       A, off(00202h)         ; should have some sort of duty cycle value?
                ST      A, off(00204h)         ; 16B5 1 200 ??? D404
                JBS     off(00203h).4, label_16bd ; 16B7 1 200 ??? EC0303
                L       A, #0e001h             ; 16BA 1 200 ??? 6701E0
                                               ; 16BD from 16B7 (DD1,200,???)
                                               ; 16BD from 16D0 (DD1,200,???)
                                               ; 16BD from 16D6 (DD1,200,???)
label_16bd:     ST      A, PWMR0               ; 16BD 1 200 ??? D572
                L       A, 0cch                ; 16BF 1 200 ??? E5CC
                RB      PSWH.0                 ; 16C1 1 200 ??? A208
                ST      A, IE                  ; 16C3 1 200 ??? D51A
                RTI                            ; 16C5 1 200 ??? 02
                                               ; 16C6 from 16A4 (DD1,200,???)
label_16c6:     SB      off(0021dh).0          ; 16C6 1 200 ??? C41D18
                MOV     PWMR1, #0ffffh         ; 16C9 1 200 ??? B57698FFFF
                L       A, off(00204h)         ; 16CE 1 200 ??? E404
                JBR     off(00205h).4, label_16bd ; 16D0 1 200 ??? DC05EA
                L       A, #0ffffh             ; 16D3 1 200 ??? 67FFFF
                SJ      label_16bd             ; 16D6 1 200 ??? CBE5

;***********************************************
                ;this is where we start...
                                               ; 16D8 from 0000 (DD0,???,???)
int_start:      MOV     PSW, #00010h           ; 16D8 0 ??? ??? B504981000
                                               ; 16DD from 1702 (DD0,???,???)
label_16dd:     MOVB    WDT, #03ch             ; 16DD 0 ??? ??? C511983C
                MOV     SSP, #00264h           ; 16E1 0 ??? ??? A0986402
                MOV     LRB, #00010h           ; 16E5 0 080 ??? 571000
                CLR     er1                    ; 16E8 0 080 ??? 4515
                JBR     off(PSW).4, label_1704 ; this tells us that we are coming from a break, not from startup. if break, jump.
                                               ; 16ED from 1708 (DD0,080,???)
label_16ed:     MOV     DP, #04000h            ; 16ED 0 080 ??? 620040
                MOVB    A, [DP]                ; 16F0 0 080 ??? C299
                ANDB    A, #080h               ; 16F2 0 080 ??? D680
                STB     A, r0                  ; 16F4 0 080 ??? 88
                MOVB    r1, #020h              ; 16F5 0 080 ??? 9920
                MOVB    r2, #014h              ; 16F7 0 080 ??? 9A14
                SJ      label_171b             ; 16F9 0 080 ??? CB20
                                               ; 16FB from 0004 (DD0,???,???)
int_WDT:        MOVB    0f0h, #044h            ; 16FB 0 ??? ??? C5F09844


                                               ; 16FF from 0002 (DD0,???,???)
                                               ; 16FF from 000C (DD0,???,???)
                                               ; 16FF from 0018 (DD0,???,???)
                                               ; 16FF from 001C (DD0,???,???)
                                               ; 16FF from 001E (DD0,???,???)
                                               ; 16FF from 0020 (DD0,???,???)
                                               ; 16FF from 0024 (DD0,???,???)
int_break:      CLR     PSW                    ; 16FF 0 ??? ??? B50415
                SJ      label_16dd             ; 1702 0 ??? ??? CBD9
                                               ; to here cause there was a sys restart
label_1704:     CMPB    0f0h, #047h            ; if from NMI
                JEQ     label_16ed             ; then goto 16EDh
                SB      0fdh.6                 ; 170A 0 080 ??? C5FD1E
                MOVB    r0, off(000fdh)        ; 170D 0 080 ??? C4FD48
                MOVB    r1, off(000e9h)        ; 1710 0 080 ??? C4E949
                MOVB    r3, off(000f0h)        ; 1713 0 080 ??? C4F04B
                JBS     off(000f0h).3, label_171b ; 1716 0 080 ??? EBF002
                SB      PSWL.4                 ; 1719 0 080 ??? A31C
                                               ; 171B from 16F9 (DD0,080,???)
                                               ; 171B from 1716 (DD0,080,???)
label_171b:     JBR     off(P4).1, label_1721  ; 171B 0 080 ??? D92C03
                J       int_NMI                ; 171E 0 080 ??? 038F00
                                               ; 1721 from 171B (DD0,080,???)
label_1721:     CLRB    PRPHF                  ; 1721 0 080 ??? C51215
                MOVB    P0, #0bfh              ; p0 = 11001111b
                LB      A, #0ffh               ; All 1s
                STB     A, P0IO                ; All outputs
                MOVB    P1, #0fbh              ; p1 = 11111100b
                STB     A, P1IO                ; All outputs
                MOVB    P2, #01fh              ; P2 = 00011111b
                STB     A, P2IO                ; All outputs
                MOVB    P2SF, #000h            ; no specials
                STB     A, P3                  ; All 1s


                MOVB    STTMC, #002h           ; 173E 0 080 ??? C54A9802
                MOVB    STCON, #031h           ; 1742 0 080 ??? C5509831
                MOVB    SRCON, #021h           ; 1746 0 080 ??? C5549821
                MOVB    STTM, #0fch            ; 174A 0 080 ??? C54898FC
                MOVB    STTMR, #0fch           ; 174E 0 080 ??? C54998FC
                MOVB    SRTMC, #0c0h           ; 1752 0 080 ??? C54E98C0


                LB      A, #064h               ; 1756 0 080 ??? 7764
                STB     A, SRTM                ; 1758 0 080 ??? D54C
                STB     A, SRTMR               ; 175A 0 080 ??? D54D
                CLRB    EXION                  ; 175C 0 080 ??? C51C15
                CLR     A                      ; 175F 1 080 ??? F9

                ;*** Timers
                ; TCON*.7=Timer input clock
                ; TCON*.6=Timer input clock
                ; TCON*.5=Timer input clock
                ;  -- interval
                ;  +-+-+-+---------------------+
                ;  |7|6|5|  Timer input clock  |
                ;  +-+-+-+---------------------+
                ;  |0|0|0| 1/2 clk             |
                ;  |0|0|1| 1/4 clk             |
                ;  |0|1|0| 1/8 clk             |
                ;  |0|1|1| 1/16 clk            |
                ;  |1|0|0| 1/32 clk            |
                ;  |1|0|1| 1/128 clk           |
                ;  |1|1|0| 1/512 clk           |
                ;  |1|1|1| external clk (pins) |
                ;  +-+-+-+---------------------+
                ;
                ; TCON*.4=timer stop(0) or run(1)
                ; TCON*.3= value to be copied into .2 in realtime output
                ;          mode when TM* == TMR*
                ; TCON*.2= output in realtime output mode
                ; TCON*.1= mode high
                ; TCON*.0= mode low
                ;
                ;  -- mode
                ;  +-+-+-------------------+
                ;  |1|0| Timer mode        |
                ;  +-+-+-------------------+
                ;  |0|0| Auto Reload Timer |
                ;  |0|1| Clock output      |
                ;  |1|0| Capture output    |
                ;  |1|1| Real time output  |
                ;  +-+-+-------------------+
                ;
                ; AutoReload mode - TM* register counts up until overflow
                ; at which point TMR*'s contents are loaded into TM*
                ;
                ; Capture Register mode - When a pin from p3.4 to .7 changes from
                ; high to low (external) TM* is loaded into TMR*
                ;
                ; RealTime output mode - When TM* reaches TMR*'s value, TCON*.3
                ; is loaded into TCON*.2 (which is loaded into its respective
                ; p3.4-.7 output pin)

				;TIMER0 - used for injectors
				;- auto reload timer
				;- stopped
				;- interval is 1/32 of clk
                MOVB    TCON0, #08ch           ; 10001100
                MOV     TM0, #00001h           ; 1764 1 080 ??? B530980100
                ST      A, TMR0                ; 0

                ;TIMER1 - crank position
				;- capture output timer
				;- stopped
				;- interval is 1/32 of clk
                MOVB    TCON1, #08eh           ; 10001110
                ST      A, TM1                 ; 0
                ST      A, TMR1                ; holds TM1 value of last CKP tick

				;TIMER2 - ignition related
				;- Real time output timer
				;- stopped
				;- interval is 1/32 of clk
                MOVB    TCON2, #08fh           ; 10001111
                MOV     TM2, #00001h           ;
                ST      A, TMR2                ; 0

				;TIMER3
				;- Real time output timer
				;- stopped
				;- interval is 1/32 of clk
                MOVB    TCON3, #08fh           ; 10001111

                MOVB    P3IO, #041h            ; 01000001b
                MOVB    P3SF, #06fh            ; 01101111

                ;	P3.7=input
				;	P3.6=TM2 output= ignitor (from TCON2.2)
				;	P3.5=TM1 input= crank position
				;	P3.4=input
				;	P3.3=INT1 input= crank position
				;	P3.2=INT0 input= VSS
				;	P3.1=RxD (docs say 'pin' wtf?) input
				;	P3.0=TxD (output data serial port)

                MOVB    P4, #0ffh              ; 178A 1 080 ??? C52C98FF
                L       A, #0ff00h             ; 178E 1 080 ??? 6700FF
                MOVB    PWCON0, #02eh          ; 1791 1 080 ??? C578982E
                ST      A, PWMC0               ; 1795 1 080 ??? D570
                ST      A, PWMR0               ; 1797 1 080 ??? D572
                MOVB    PWCON1, #06eh          ; 1799 1 080 ??? C57A986E
                ST      A, PWMC1               ; 179D 1 080 ??? D574
                ST      A, PWMR1               ; 179F 1 080 ??? D576
                MOVB    P4IO, #00dh            ; 00001101b
                MOVB    P4SF, #0bch            ; 10111100b

                ;	P4.7=Transition detector 3 input
				;	P4.6=input
				;	P4.5=Transition detector 1 input
				;	P4.4=Transition detector 0 input
				;	P4.3=PWM1 output
				;	P4.2=PWM0 output
				;	P4.1=input
				;	P4.0=output

;*************************************************************************
                ;-------------------;
				; TEST PWM0 and PWM1 ;
				;-------------------;
                SB      TCON1.4                ; 17A9 1 080 ??? C5411C
                MOV     er3, (0ffffh-0ffffh)[USP] ; 17AC 1 080 ??? B3004B
                SB      TCON2.4                ; 17AF 1 080 ??? C5421C
                CLR     IRQ                    ; 17B2 1 080 ??? B51815
                LB      A, #002h               ; 17B5 0 080 ??? 7702
                MOV     DP, #00078h            ; 17B7 0 080 ??? 627800
                                               ; 17BA from 17DC (DD0,080,00F)
label_17ba:     SB      [DP].4                 ; 17BA 0 080 ??? C21C
                MOV     USP, #00160h           ; 17BC 0 080 160 A1986001
                                               ; 17C0 from 17C7 (DD0,080,15F)
label_17c0:     DEC     USP                    ; 17C0 0 080 15F A117
                JEQ     label_17e3             ; 17C2 0 080 15F C91F
                MBR     C, off(P4)             ; 17C4 0 080 15F C42C21
                JLT     label_17c0             ; 17C7 0 080 15F CAF7
                MOV     USP, #00010h           ; 17C9 0 080 010 A1981000
                                               ; 17CD from 17D4 (DD0,080,00F)
label_17cd:     DEC     USP                    ; 17CD 0 080 00F A117
                JEQ     label_17e3             ; 17CF 0 080 00F C912
                MBR     C, off(P4)             ; 17D1 0 080 00F C42C21
                JGE     label_17cd             ; 17D4 0 080 00F CDF7
                INC     DP                     ; 17D6 0 080 00F 72
                INC     DP                     ; 17D7 0 080 00F 72
                ADDB    A, #001h               ; 17D8 0 080 00F 8601
                CMPB    A, #004h               ; 17DA 0 080 00F C604
                JNE     label_17ba             ; 17DC 0 080 00F CEDC
                RB      IRQH.5                 ; 17DE 0 080 00F C5190D
                JNE     label_17e8             ; 17E1 0 080 00F CE05

                ;sys error??
                                               ; 17E3 from 17C2 (DD0,080,15F)
                                               ; 17E3 from 17CF (DD0,080,00F)
label_17e3:     MOVB    off(000f0h), #04ch     ; 17E3 0 080 00F C4F0984C
                BRK                            ; 17E7 0 080 00F FF
                                               ; 17E8 from 17E1 (DD0,080,00F)
label_17e8:     RB      PWCON1.5               ; 17E8 0 080 00F C57A0D
;****************************************************************************
				;--------------;
				; TEST RAM CPU ;
				;--------------;
                MOV     DP, #00269h            ; 17EB 0 080 00F 626902
                JBR     off(PSW).4, label_17f4 ; 17EE 0 080 00F DC0403
                MOV     DP, #0027fh            ; 17F1 0 080 00F 627F02

                ;checking the system...
                                               ; 17F4 from 17EE (DD0,080,00F)
                                               ; 17F4 from 180C (DD0,080,00F)
label_17f4:     LB      A, #055h               ; 17F4 0 080 00F 7755
                STB     A, [DP]                ; 17F6 0 080 00F D2
                CMPB    A, [DP]                ; 17F7 0 080 00F C2C2
                JNE     label_1801             ; system error...
                SLLB    A                      ; 17FB 0 080 00F 53
                STB     A, [DP]                ; 17FC 0 080 00F D2
                SUBB    A, [DP]                ; 17FD 0 080 00F C2A2
                JEQ     label_1806             ; if eq then we are good.
                                               ; 1801 from 17F9 (DD0,080,00F)
label_1801:     MOVB    off(000f0h), #042h     ; 1801 0 080 00F C4F09842
                BRK                            ; 1805 0 080 00F FF

                ;system is good if we get here
                                               ; 1806 from 17FF (DD0,080,00F)
label_1806:     STB     A, [DP]                ; 1806 0 080 00F D2
                DEC     DP                     ; 1807 0 080 00F 82
                CMP     DP, #00086h            ; 1808 0 080 00F 92C08600
                JGE     label_17f4             ; if no carry then we check the system again.
                MOVB    off(000fdh), r0        ; 180E 0 080 00F 207CFD
                MOVB    off(000e9h), r1        ; 1811 0 080 00F 217CE9
                LB      A, r2                  ; 1814 0 080 00F 7A
                MOVB    off(000f0h), r3        ; move old value into f0h
                SLL     LRB                    ; 1818 0 080 00F A4D7
                STB     A, off(000e0h)         ; 181A 0 080 00F D4E0
                CLR     A                      ; 181C 1 080 00F F9
                ST      A, IE                  ; 181D 1 080 00F D51A
                CLR     DP                     ; 181F 1 080 00F 9215
                                               ; 1821 from 1826 (DD1,080,00F)
label_1821:     MOVB    r6, #011h              ; 1821 1 080 00F 9E11
                                               ; 1823 from 1824 (DD1,080,00F)
label_1823:     DECB    r6                     ; 1823 1 080 00F BE
                JNE     label_1823             ; 1824 1 080 00F CEFD
                JRNZ    DP, label_1821         ; 1826 1 080 00F 30F9
;****************************************************************************
				;---------------------------------------------------------;
				; Init and read from ADC								  ;
				;---------------------------------------------------------;

                CLRB    ADSEL                  ; 1828 1 080 00F C55915
                MOVB    ADSCAN, #010h          ; 182B 1 080 00F C5589810
                MOVB    0ebh, #001h            ; 182F 1 080 00F C5EB9801
                RB      IRQH.4                 ; 1833 1 080 00F C5190C
                                               ; 1836 from 1838 (DD1,080,00F)
                                               ; 1836 from 1841 (DD0,080,00F)
label_1836:     MB      r0.0, C                ; 1836 1 080 00F 2038
                JRNZ    DP, label_1836         ; 1838 1 080 00F 30FC
                CAL     label_2e2e             ; 183A 1 080 00F 322E2E


                ;cool shit.
;label_2e2e:     RB      IRQH.4                 ; 2E2E 1 080 00F C5190C
;                JNE     label_2e3d             ; 2E31 1 080 00F CE0A
;                MOVB    0f0h, #04ah            ; adc error
;                DECB    0ebh                   ; 2E37 1 080 00F C5EB17
;                JNE     label_2e4e             ; 2E3A 1 080 00F CE12
;                BRK                            ; 2E3C 1 080 00F FF
;                                               ; 2E3D from 2E31 (DD1,080,00F)
;label_2e3d:     LB      A, P2                  ; 2E3D 0 080 00F F524
;                SWAPB                          ; 2E3F 0 080 00F 83
;                SRLB    A                      ; 2E40 0 080 00F 63
;                ANDB    A, #007h               ; 2E41 0 080 00F D607
;                EXTND                          ; 2E43 1 080 00F F8
;                MOV     X1, A                  ; 2E44 1 080 00F 50
;                LB      A, ADCR0H              ; 2E45 0 080 00F F561
;                STB     A, 00098h[X1]          ;
;                ADDB    P2, #020h              ; 2E4A 0 080 00F C5248020
;                                               ; 2E4E from 2E3A (DD1,080,00F)
;label_2e4e:     RT
                ;

                LB      A, P2                  ; Load injectors
                ANDB    A, #0e0h               ; And with 1110 0000b
                JNE     label_1836             ; 1841 0 080 00F CEF3

                L       A, ADCR4               ; 1843 1 080 00F E568
                ST      A, 0a8h                ; 1845 1 080 00F D5A8

                LB      A, ADCR6H              ; 1847 0 080 00F F56D
                STB     A, 0a5h                ; 1849 0 080 00F D5A5

                L       A, ADCR5               ; 184B 1 080 00F E56A
                ST      A, 0b0h                ; 184D 1 080 00F D5B0

                LB      A, ACCH                ; 184F 0 080 00F F507
                STB     A, 0b6h                ; 1851 0 080 00F D5B6
                MOVB    0b4h, #0a0h            ; 1853 0 080 00F C5B498A0

                L       A, ADCR7               ; 1857 1 080 00F E56E
                ST      A, 0aah                ; 1859 1 080 00F D5AA


                MOVB    0a3h, #03ch            ; 185B 1 080 00F C5A3983C
                MOVB    0a4h, #057h            ; 185F 1 080 00F C5A49857
                LB      A, #000h               ; 1863 0 080 00F 7700
                STB     A, 0f1h                ; 1865 0 080 00F D5F1
                STB     A, 0f3h                ; 1867 0 080 00F D5F3
                LB      A, #02bh               ; 1869 0 080 00F 772B
                STB     A, 0ach                ; 186B 0 080 00F D5AC
                STB     A, 0aeh                ; 186D 0 080 00F D5AE
                LB      A, #080h               ; 186F 0 080 00F 7780
                STB     A, 0adh                ; 1871 0 080 00F D5AD
                STB     A, 0afh                ; 1873 0 080 00F D5AF
                STB     A, off(0009ch)         ; 1875 0 080 00F D49C
                SB      off(0001eh).7          ; 1877 0 080 00F C41E1F
                L       A, #0ffffh             ; 187A 1 080 00F 67FFFF
                ST      A, 0c4h                ; 187D 1 080 00F D5C4
                SB      off(0001eh).0          ; 187F 1 080 00F C41E18
                MOV     USP, #00219h           ; 1882 1 080 219 A1981902
                ST      A, (00202h-00219h)[USP] ; 1886 1 080 219 D3E9
                PUSHU   A                      ; 1888 1 080 217 76
                PUSHU   A                      ; 1889 1 080 215 76
                PUSHU   A                      ; 188A 1 080 213 76
                MOV     (0021ah-00213h)[USP], #08877h ; 1000 1000 0111 0111
                MOVB    (0021ch-00213h)[USP], #00fh ; 0000 1111
                MOVB    0eah, #003h            ; 1894 1 080 213 C5EA9803

;********************************************************************
                LB      A, 098h                ; 1898 0 080 213 F598
                STB     A, 0f7h                ; 189A 0 080 213 D5F7
                CAL     label_2ec3             ; 189C 0 080 213 32C32E

;********************************************************************
                SB      off(P3SF).7            ; 189F 0 080 213 C42A1F
                CAL     label_3274             ; 18A2 0 080 213 327432
                MOV     DP, #001b2h            ; 18A5 0 080 213 62B201
                LB      A, ACC                 ; 18A8 0 080 213 F506
                                               ; 18AA from 18B4 (DD0,080,213)
label_18aa:     LCB     A, 039c3h[DP]          ; 18AA 0 080 213 92ABC339
                STB     A, [DP]                ; 18AE 0 080 213 D2
                INC     DP                     ; 18AF 0 080 213 72
                CMP     DP, #001d1h            ; 18B0 0 080 213 92C0D101
                JNE     label_18aa             ; 18B4 0 080 213 CEF4
                MOV     DP, #0026ah            ; 18B6 0 080 213 626A02
                L       A, [DP]                ; 18B9 1 080 213 E2
                JEQ     label_18c1             ; 18BA 1 080 213 C905
                CMP     A, #01000h             ; 18BC 1 080 213 C60010
                JLE     label_18c5             ; 18BF 1 080 213 CF04
                                               ; 18C1 from 18BA (DD1,080,213)
label_18c1:     L       A, #00580h             ; 18C1 1 080 213 678005
                ST      A, [DP]                ; 18C4 1 080 213 D2
                                               ; 18C5 from 18BF (DD1,080,213)
label_18c5:     MOV     DP, #0026ch            ; 18C5 1 080 213 626C02
                                               ; 18C8 from 18DF (DD1,080,213)
label_18c8:     L       A, [DP]                ; 18C8 1 080 213 E2
                CMP     A, #0b6e0h             ; 18C9 1 080 213 C6E0B6
                JGT     label_18d3             ; 18CC 1 080 213 C805
                CMP     A, #05720h             ; 18CE 1 080 213 C62057
                JGE     label_18d7             ; 18D1 1 080 213 CD04
                                               ; 18D3 from 18CC (DD1,080,213)
label_18d3:     MOV     [DP], #08000h          ; 18D3 1 080 213 B2980080
                                               ; 18D7 from 18D1 (DD1,080,213)
label_18d7:     ADD     DP, #00002h            ; 18D7 1 080 213 92800200
                CMP     DP, #00278h            ; 18DB 1 080 213 92C07802
                JNE     label_18c8             ; 18DF 1 080 213 CEE7
                LB      A, [DP]                ; 18E1 0 080 213 F2
                CMPB    A, #026h               ; 18E2 0 080 213 C626
                JGT     label_18ea             ; 18E4 0 080 213 C804
                CMPB    A, #004h               ; 18E6 0 080 213 C604
                JGE     label_18ec             ; 18E8 0 080 213 CD02
                                               ; 18EA from 18E4 (DD0,080,213)
label_18ea:     CLRB    [DP]                   ; 18EA 0 080 213 C215
                                               ; 18EC from 18E8 (DD0,080,213)
label_18ec:     CLR     A                      ; 18EC 1 080 213 F9
                MOV     DP, #00228h            ; 18ED 1 080 213 622802
                LC      A, 00038h              ; 18F0 1 080 213 909C3800
                ST      A, [DP]                ; 18F4 1 080 213 D2
                INC     DP                     ; 18F5 1 080 213 72
                INC     DP                     ; 18F6 1 080 213 72
                LC      A, 0003ah              ; 18F7 1 080 213 909C3A00
                ST      A, [DP]                ; 18FB 1 080 213 D2

                ;get some ON/OFF inputs
                MOV     DP, #04000h            ; external chip read
                LB      A, [DP]                ; Read into A
                STB     A, 0ffh                ; dump into ffh
                J       label_2156             ; jump over vcal4


;***************************************************************************
;***************************************************************************
;								vcal_4 begin
;***************************************************************************
;***************************************************************************
;long function: goes to label_2043
                                               ; 1905 from 220A (DD0,080,213)
                                               ; 1905 from 22CB (DD0,080,213)
                                               ; 1905 from 23BF (DD0,080,0A4)
                                               ; 1905 from 24C1 (DD0,080,0A3)
                                               ; 1905 from 260A (DD0,080,205)
                                               ; 1905 from 26D1 (DD1,080,205)
                                               ; 1905 from 2810 (DD0,080,205)
                                               ; 1905 from 2856 r7 has index
                                               ; 1905 from 28D0 (DD0,080,205)
                                               ; 1905 from 2082 (DD1,080,132)
                                               ; 1905 from 2A16 (DD0,080,132)
                                               ; 1905 from 20C4 (DD0,080,220)
vcal_4:         RB      0feh.1         		   ;fe.1 <-0 set only in int_serial_rx_BRG
                JEQ     label_190c     		   ;if the bit WAS 0 check the next one
                SJ      label_1925             ; else jump

                                               ; 190C from 1908 (DD0,080,213)
label_190c:     RB      0feh.4                  ; this bit is set when finished with
												; 1 iteration of the main code
                JEQ     label_1914             ; 190F 0 080 213 C903
                J       label_1bae             ; 1911 0 080 213 03AE1B

                                               ; 1914 from 190F (DD0,080,213)
label_1914:     RB      0feh.2                 ; set every 10 times through label_1925 routine
                JEQ     label_191c             ;
                J       label_1f81             ; blink CEL codes

                                               ; 191C from 1917 (DD0,080,213)
label_191c:     RB      0feh.3                 ; set every c8h times through label_1925 routine
                JEQ     label_1924             ;
                J       label_2014             ;
                                               ; 1924 from 191F (DD0,080,213)
label_1924:     RT                             ; 1924 0 080 213 01


                                               ; 1925 from 190A (DD0,080,213)
label_1925:     CAL     label_30a8             ; 1925 0 080 213 32A830

;label_30a8:     LB      A, #03ch               ; 30A8 0 080 213 773C
;                STB     A, WDT                 ; 30AA 0 080 213 D511
;                SWAPB                          ; 30AC 0 080 213 83
;                STB     A, WDT                 ; 30AD 0 080 213 D511
;                LB      A, 0fdh                ; 30AF 0 080 213 F5FD
;                ANDB    A, #003h               ; 30B1 0 080 213 D603
;                JNE     label_30b9             ; 30B3 0 080 213 CE04
;                XORB    P4, #001h              ; 30B5 0 080 213 C52CF001
;                                               ; 30B9 from 30B3 (DD0,080,213)
;label_30b9:     RT                             ; 30B9 0 080 213 01

                MOV     DP, #00009h            ; 1928 0 080 213 620900
                MOV     USP, #001abh           ; 192B 0 080 1AB A198AB01
                CAL     label_309c             ; 192F 0 080 1AB 329C30

;ram locations 1abh,1ach,1adh,1aeh,1afh,1b0h,1b1h,1b2h,1b3h
;label_309c:     LB      A, [USP]
;                JEQ     label_30a3             ; 309E 0 080 1AB C903
;                DECB    [USP]
;                                               ; 30A3 from 309E (DD0,080,1AB)
;label_30a3:     INC     USP                    ; 30A3 0 080 1AC A116
;                JRNZ    DP, label_309c         ; 30A5 0 080 1AC 30F5
;                RT


                ;c8h is loaded into 1b2h
                CLR     A                      ; A = 0
                LB      A, off(001b2h)         ; check 1b2h which is dec'd earlier
                JNE     label_193e             ; if[1b2h] != 0 jump
                SB      0feh.3                 ; set when [1b2h] gets down to 0
                LB      A, #0c8h               ;
                STB     A, off(001b2h)         ; l

                ;if from above then A <= #c8h
                ; 193E from 1935: A has [1b2h]
label_193e:     MOVB    r0, #00ah              ; 193E 0 080 1AB 980A
                DIVB                           ; 1940 0 080 1AB A236
                LB      A, r1                  ;
                JNE     label_1948             ;
                SB      0feh.2                 ; if [1b2h]%ah == 0 then this is set.
							                   ; so if [1b2h] is divisible by 10 then feh.2 = 1;

                                               ; 1948 from 1943 (DD0,080,1AB)
label_1948:     JBR     off(001b2h).0, label_194e ; at every other call of the function this will be true
                J       label_1a43             ; this pretty much just returns from vcal_4

;**********************************************
;IACV duty cycle calcs?
            	                                ; 194E from 1948 (DD0,080,1AB)

label_194e:     MOV     DP, #00202h            ; current duty cycle?
                L       A, [DP]                ;
                MOV     X1, #03aach            ; 1952 1 080 1AB 60AC3A
                CAL     label_2e0b             ; 1955 1 080 1AB 320B2E

;label_2e0b:     CMPC    A, 00004h[X1]          ; load current dc
;                JGE     label_2e17             ; if A> current jump
;                ADD     X1, #00004h            ; 2E11 1 080 1AB 90800400
;                SJ      label_2e0b             ; 2E15 1 080 1AB CBF4
;                                               ; 2E17 from 2E0F (DD1,080,1AB)
;label_2e17:     ST      A, er0                 ; old dc
;                LC      A, 00004h[X1]          ; load dc thats less than old_dc
;                ST      A, er2                 ; er2 = new_dc
;                SUB     er0, A                 ; er0 = old_dc - new_dc
;                LC      A, [X1]                ; A = gt_new_dc = a val thats > old_dc
;                SUB     A, er2                 ; get the difference of gt_new_dc and new_dc
;                ST      A, er2                 ; er2 = difference
;                LC      A, 00006h[X1]          ;
;                ST      A, er3                 ; 2E27 1 080 1AB 8B
;                LC      A, 00002h[X1]          ; 2E28 1 080 1AB 90A90200
;                SJ      label_2df2             ; jump into the middle of vcal_1

                MOV     er0, 0a8h              ; load PA sensor
                MUL                            ; 195B 1 080 1AB 9035
                L       A, er1                 ; 195D 1 080 1AB 35
                MOV     USP, #0021eh           ; 195E 1 080 21E A1981E02
                ST      A, (0021eh-0021eh)[USP] ; 1962 1 080 21E D300
                MOV     er0, #06000h           ; 1964 1 080 21E 44980060
                SUB     A, off(0170h)          ; 1968 1 080 21E A770
                RB      off(0125h).0            ; 196A 1 080 21E C42508
                MB      off(0125h).0, C         ; 196D 1 080 21E C42538
                JEQ     label_1975             ; 1970 1 080 21E C903
                XORB    PSWH, #080h            ; 1972 1 080 21E A2F080
                                               ; 1975 from 1970 (DD1,080,21E)
label_1975:     JGE     label_197b             ; 1975 1 080 21E CD04
                MOVB    off(001f5h), #00ah     ; 1977 1 080 21E C4F5980A
                                               ; 197B from 1975 (DD1,080,21E)
label_197b:     JBS     off(0125h).0, label_198d ; 197B 1 080 21E E8250F
                MUL                            ; 197E 1 080 21E 9035
                L       A, [DP]                ; 1980 1 080 21E E2
                ADD     A, er1                 ; 1981 1 080 21E 09
                MOV     er0, #0fd58h           ; 1982 1 080 21E 449858FD
                JLT     label_199d             ; 1986 1 080 21E CA15
                CMP     A, er0                 ; 1988 1 080 21E 48
                JLT     label_19a1             ; 1989 1 080 21E CA16
                SJ      label_199d             ; 198B 1 080 21E CB10
                                               ; 198D from 197B (DD1,080,21E)
label_198d:     ST      A, er1                 ; 198D 1 080 21E 89
                CLR     A                      ; 198E 1 080 21E F9
                SUB     A, er1                 ; 198F 1 080 21E 29
                MUL                            ; 1990 1 080 21E 9035
                L       A, [DP]                ; 1992 1 080 21E E2
                SUB     A, er1                 ; 1993 1 080 21E 29
                MOV     er0, #0e002h           ; 1994 1 080 21E 449802E0
                JLT     label_199d             ; 1998 1 080 21E CA03
                CMP     A, er0                 ; 199A 1 080 21E 48
                JGE     label_19a1             ; 199B 1 080 21E CD04
                                               ; 199D from 1986 (DD1,080,21E)
                                               ; 199D from 198B (DD1,080,21E)
                                               ; 199D from 1998 (DD1,080,21E)
label_199d:     L       A, er0                 ; 199D 1 080 21E 34
                CLRB    off(000f5h)            ; 199E 1 080 21E C4F515
                                               ; 19A1 from 1989 (DD1,080,21E)
                                               ; 19A1 from 199B (DD1,080,21E)
label_19a1:     SB      ACC.0                  ; 19A1 1 080 21E C50618
                ST      A, [DP]                ; ST into 202h

;************************************
;calculate speed for 0c4h

;----------------------------
; this should be right but its not.
; maybe I have the number of pulses wrong.
; it seems right at 10 pulses per revolution,
; but it should only click every 90 deg.

; [c4h] calc: time for 90deg. of rotation
; 7900000 is the crystal cycle/sec
; 32 is timer configuration : CLK/32
; 4 clicks per axle rotation

; 60*60*(7900000/32/4) = 222187500
; 222187500/[c4h] = rotations/hour

; tire diameter = 23.5 inches; r = 11.75
; circumference = 23.5PI inches = 23.5PI/12/5280 miles/rotation

; 222187500/[c4h] * 23.5PI/12/5280 = miles/hour

; = 258894.12/[c4h] = miles/hour
;----------------------------

; 3cfh and 3f1h (limiter values)

; based on limiter values
; mph const = 109687d
; kph const = 175500d


                ;c8h|c9h = timer1
				;c6h|c7h = timer1 from last interrupt
				;cah = old e2h
                ;e2h = 0 if no TM1 overflow, 1 if overfow and TM1>8000h

                MOV     DP, #000c4h            ; 19A5 1 080 21E 62C400
                JBR     off(0132h).0, label_19b6 ; if no VSS error jump

                                               ; 19AB from 19D1 (DD1,080,21E)
label_19ab:     SB      off(0118h).3           ; else set 118h.3
                RB      off(0011eh).0          ; and reset 11eh.0
                L       A, #03eb7h             ; load generic value for speed
                SJ      label_1a25             ; jump to store

                                               ; 19B6 from 19A8 (DD1,080,21E)
label_19b6:     RB      0feh.0                 ; set in INT0; set once per interrupt. nothing else touches it
                JNE     label_19ce             ; if it was 1 jump
                LB      A, #003h               ; 19BB 0 080 21E 7703
                CMPB    A, 0e2h                ; 19BD 0 080 21E C5E2C2
                JGT     label_1a3b             ; 19C0 0 080 21E C879
                STB     A, 0e2h                ; 19C2 0 080 21E D5E2
                                               ; 19C4 from 19CE (DD1,080,21E)
                                               ; 19C4 from 19FB (DD0,080,21E)
                ;stopped or going reeeeaaallly slow
                ;or starting, or bad rev count
                ;then we just put 0ffffh into 0c4h
label_19c4:     SB      off(0011eh).0          ; set bit 1eh.0 or 11eh.0
                L       A, #0ffffh             ; load slow action into
                ST      A, [DP]                ; c4h
                CLRB    A                      ; clear A
                SJ      label_1a39             ; skip speed calc

                ;c8h|c9h = timer1
				;c6h|c7h = timer1 from last interrupt
				;cah = old e2h
                ;e2h = 0 if no TM1 overflow, 1 if overfow and TM1>8000h
                                               ; 19CE from 19B9 (DD1,080,21E)
label_19ce:     JBS     off(0011fh).4, label_19c4 ; if starter is on or rev count error then jump
                JBS     off(0118h).6, label_19ab ; if ignition signal jump

                ;dont interrupt for a few lines cause its timer dependent...
                AND     IE, #00080h            ; and with 1000 0000b; only enable timer1_overflow
                RB      PSWH.0                 ; reset PSWH.0
                L       A, 0c8h                ; get timer1
                MOVB    r7, 0cah               ; r7 = old e2h
                SUB     A, 0c6h                ; timer1-old timer1
                ST      A, er0                 ; store pulse difference into er0
                SB      PSWH.0                 ; set PSWH.0
                L       A, 0cch                ; load cch|cdh
                ST      A, IE                  ; store into IE
                ;back to normal interrupts

                L       A, er0                 ; get pulse difference
                JGE     label_19ee             ; if old timer1> new timer1
                DECB    r7                     ; then cah--;

                                               ; 19EE from 19EB (DD1,080,21E)
label_19ee:     JBR     off(0121h).2, label_19f6 ; if 121h.2 then divide, else multiply
                SLL     A                      ; timer_diff*=2
                ROLB    r7                     ; r7 = r7*2 + high bit of timer_diff
                SJ      label_19f9             ; skip next 2 lines

                                               ; 19F6 from 19EE (DD1,080,21E)
label_19f6:     SRLB    r7                     ; r7/=2
                ROR     A                      ; timer_diff = timer_diff/2 + low bit from r7

                                               ; 19F9 from 19F4 (DD1,080,21E)
label_19f9:     ST      A, er0                 ; store the timer diff into er0 again
                LB      A, r7                  ; A = r7
                JNE     label_19c4             ; if r7 != 0 then error...
                RB      off(0011eh).0          ; check 11eh.0 (set in error portion)
                JNE     label_1a3b             ; if its 1 then jump and skip rest of calc
                RB      off(0118h).3             ;
                JNE     label_1a3b             ; if its != 0 jump and skip res of calc

                L       A, er0                 ; else we load up the timer_diff again
                CMP     A, #002c2h             ; compare it to 2c2h
                MB      off(0118h).3, C          ; if timer_diff>= #2c2h then 118h.3 = 0, else 118h.3 = 1
                JLT     label_1a3b             ; if 1 jump to skip calc
                CMP     A, #03000h             ; compare to 3000h
                JGE     label_1a25             ; if timer_diff>=3000h jump and be done

                ;else if timer_diff<3000h && timer_diff>=499h
                ;     er0 = 4000h;
                ;else if timer_diff<499h && timer_diff>=2c2h
                ;     er0 = 1000h
                CMP     A, #00499h             ; else
                MOV     er0, #04000h           ;
                JGE     label_1a22             ;
                MOV     er0, #01000h           ;


                ;[c4h] = [c4h] - (([c4h]*er0)/10000h) + ((timer_diff*er0)/10000h)
                                               ; 1A22 from 1A1C (DD1,080,21E)
label_1a22:     CAL     label_2efd             ;
                                               ; 1A25 from 19B4 (DD1,080,21E)
                                               ; 1A25 from 1A13 (DD1,080,21E)
                ;store the calculated val into 0c4h ram
label_1a25:     ST      A, [DP]                ; 1A25 1 080 21E D2
;********************

; mph = [cbh] * 0.388
; kph = [cbh] * 0.621

				;er0A = er0A/er2
				;calculate another value based on c4h for the speed byte (0cbh).
                ST      A, er2                 ; c4h
                MOV     er0, #00004h           ; er0 = 4
                L       A, #04fc8h             ; A = 4fc8h
                DIV                            ; A = 44fc8h/[c4h] AND ffffh
                ST      A, er1                 ; er1 = result

                ;if result > ffh then we have error (too fast)
                LB      A, r3                  ; load high byte
                ORB     A, r0                  ;
                ORB     A, r1                  ; 1A33 0 080 21E 69
                JEQ     label_1a38             ; 1A34 0 080 21E C902

                ;if(r0 != 0 || r1 != 0 || r3 != 0) then error?; load ffh into, eventually, 0cbh
                MOVB    r2, #0ffh              ; 1A36 0 080 21E 9AFF
                                               ; 1A38 from 1A34 (DD0,080,21E)
label_1a38:     LB      A, r2                  ; 1A38 0 080 21E 7A

				;
                                               ; 1A39 from 19CC (DD0,080,21E)
label_1a39:     STB     A, 0cbh                ; 1A39 0 080 21E D5CB
				;end of the speed calcs?
;********************************************

                                               ; 1A3B from 19C0 (DD0,080,21E)
                                               ; 1A3B from 1A00 (DD0,080,21E)
                                               ; 1A3B from 1A05 (DD0,080,21E)
                                               ; 1A3B from 1A0E (DD1,080,21E)
label_1a3b:     MOV     DP, #04000h            ; 1A3B 0 080 21E 620040
                LB      A, P0                  ; 1A3E 0 080 21E F520
                J       label_1ba4             ; jump to almost end of function
                                               ; 1A43 from 194B (DD0,080,1AB)
;********************************************
;calculate TPS stuff

label_1a43:     L       A, 0aah                ; 1A43 1 080 1AB E5AA
                MOV     DP, #000aeh            ; 1A45 1 080 1AB 62AE00
                CAL     label_2e72             ; 1A48 1 080 1AB 32722E

;label_2e72:     JBS     off(TM0).6, label_2e68 ; if this is set then error, set ach and adh to safe values and return
;				JBS     off(P4).2, label_2e6b  ; if this is set then error, set only adh to safe value and return
;				CMP     A, #06db6h             ; compare TPS to 6db6h
;				JGE     label_2e81             ; if tps > 6db6h jump
;				SLL     A                      ; else A *= 2
;				CLRB    A                      ; AL = 0
;				SJ      label_2e85             ;
;											   ; 2E81 from 2E7B (DD1,080,1AB)
;label_2e81:     SRL     A                      ; A/=2
;				SRL     A                      ; A/=2
;				LB      A, #0c0h               ; load c0h into AL
;											   ; 2E85 from 2E7F (DD0,080,1AB)
;label_2e85:     ADDB    A, ACCH                ; AL = AH + (0 or c0h)
;				STB     A, r0                  ; AL -> r0
;				XCHGB   A, [DP]                ; put the new val into 0aeh, then get on w/ calculating a value for 0afh
;				XCHGB   A, r0                  ; put 0aeh's oldval into r0
;				SUBB    A, r0                  ; AL = 0aeh new val - 0aeh old val
;				MB      PSWL.4, C              ; if the old val is > new set pswl.4 to 1
;				ADDB    A, #080h               ; add 80h onto the subtraction result
;				RB      PSWL.4                 ; pswl.4 = 0
;				JEQ     label_2e9b             ; if 0ach old was < 0ach new jump
;				JLT     label_2e9f             ; else if  0ach old > 0ach new jump
;				CLRB    A                      ; AL = 0, does it ever get here? does it matter?
;				SJ      label_2e9f             ; 2E99 0 080 1AB CB04
;											   ; 2E9B from 2E94 (DD0,080,1AB)
;label_2e9b:     JGE     label_2e9f             ; 2E9B 0 080 1AB CD02
;				LB      A, #0ffh               ; more error stuff
;											   ; 2E9F from 2E96 (DD0,080,1AB)
;											   ; 2E9F from 2E99 (DD0,080,1AB)
;											   ; 2E9F from 2E9B (DD0,080,1AB)
;label_2e9f:     STB     A, r0                  ; store the val for adh into r0
;				INC     DP                     ; DP ++
;				XCHGB   A, [DP]                ; AL <-> [afh]
;				CMPB    r0, A                  ; carry if new adh value is lower than old adh value
;				RB      r0.7                   ; 2EA5 0 080 1AB 200F
;				JEQ     label_2eac             ; 2EA7 0 080 1AB C903
;				XORB    PSWH, #080h            ; 2EA9 0 080 1AB A2F080
;label_2eac:     RT                             ; 2EAC 1 108 20E 01

                MB      off(0011fh).3, C       ; 11fh.3: if TPS is increasing or not
                CAL     label_2e2e             ; 1A4E 1 080 1AB 322E2E

;label_2e2e:     RB      IRQH.4                 ; 2E2E 1 080 00F C5190C
;                JNE     label_2e3d             ; 2E31 1 080 00F CE0A
;                MOVB    0f0h, #04ah            ; 2E33 1 080 00F C5F0984A
;                DECB    0ebh                   ; 2E37 1 080 00F C5EB17
;                JNE     label_2e4e             ; 2E3A 1 080 00F CE12
;                BRK                            ; 2E3C 1 080 00F FF
;                                               ; 2E3D from 2E31 (DD1,080,00F)
;label_2e3d:     LB      A, P2                  ; 2E3D 0 080 00F F524
;                SWAPB                          ; 2E3F 0 080 00F 83
;                SRLB    A                      ; 2E40 0 080 00F 63
;                ANDB    A, #007h               ; 2E41 0 080 00F D607
;                EXTND                          ; 2E43 1 080 00F F8
;                MOV     X1, A                  ; 2E44 1 080 00F 50
;                LB      A, ADCR0H              ; 2E45 0 080 00F F561
;                STB     A, 00098h[X1]          ; .
;                ADDB    P2, #020h              ; 2E4A 0 080 00F C5248020
;                                               ; 2E4E from 2E3A (DD1,080,00F)
;label_2e4e:     RT

;end of TPS function
;*********************************************

		;**********************************
        ;euro pw0 AND PR3 missing code from here

                JBR     off(001b2h).1, label_1a57 ; 1A51 1 080 1AB D9B203
                J       label_1b9f        ;all of this skipped if 1b2h.1 == 1     ; 1A54 1 080 1AB 039F1B


                ;so we are looking at stuff for the ELD cel code setting...
                ; what the hell is it doing? There is one way through it.
                								; 1A57 from 1A51 (DD1,080,1AB)
label_1a57:     LB      A, #000h               ; load 0
                STB     A, r0                  ; r0 = 0
                RC                             ; C = 0;
                JBS     off(0132h).3, label_1a69 ; IF ELD code, dont set ELD code
                JBS     off(0118h).6, label_1a69 ; if starter on dont set eld code
                LB      A, #0ffh               ; A = ffh
                CMPB    A, r0                  ; if FFh<00h
                JLT     label_1a69             ; if c == 1 jump and set eld code
                LB      A, r0                  ; load 0
                CMPB    A, #000h               ; comare to 0 WTF?
                                               ; 1A69 from 1A5B (DD0,080,1AB)
                                               ; 1A69 from 1A5E (DD0,080,1AB)
                                               ; 1A69 from 1A64 (DD0,080,1AB)
label_1a69:     NOP
				NOP
				NOP
				;MB      off(P4IO).3, C         ; ELD code!!
                JLT     label_1a89             ; if c == 1
;******************


                JBS     off(00132h).3, label_1a79 ; if ELD code jump
                STB     A, 0f1h                ; else store the ELD value: 00h no eld code, ffh with ELD code
                STB     A, ACCH                ; ACCH = f1h
                LB      A, off(001e3h)         ;
                JEQ     label_1a7f             ;
                                               ; 1A79 from 1A6E (DD0,080,1AB)
label_1a79:     LB      A, 0f1h                ; 1A79 0 080 1AB F5F1
                STB     A, 0f3h                ; 1A7B 0 080 1AB D5F3
                SJ      label_1a89             ; 1A7D 0 080 1AB CB0A
                                               ; 1A7F from 1A77 (DD0,080,1AB)
label_1a7f:     MOV     DP, #000f2h            ; 1A7F 0 080 1AB 62F200
                MOV     er0, #00000h           ; 1A82 0 080 1AB 44980000
                CAL     label_2efd             ; WTF is the point of this ELD stuff?? the code does nothing.
                ;[DP] = ([DP] - [DP]*er0/10000h) + (A*er0/10000h)

                                               ; 1A89 from 1A6C (DD0,080,1AB)
                                               ; 1A89 from 1A7D (DD0,080,1AB)
label_1a89:     LB      A, 0f3h                ; 1A89 0 080 1AB F5F3
                JBS     off(0123h).7, label_1ab4 ; 1A8B 0 080 1AB EF2326
                JBS     off(0011fh).4, label_1ab4 ; Jump when starter is on
                JBS     off(0127h).7, label_1ab4  ; 12fh.7

                ;here with no errors
                CMPB    09ah, #000h            ; battery voltage
                JLT     label_1a9f             ; this should never happen...
                CAL     label_315c             ; 1A9A 0 080 1AB 325C31

;label_315c:     MB      C, 0ffh.3              ; input
;                XORB    PSWH, #080h            ; XOR with PSWH.7
;                RT                             ; return

                JGE     label_1aa5             ; if ffh.3 == 0 jump

                                               ; else
label_1a9f:     MOVB    off(001f7h), #000h     ; 1A9F 0 080 1AB C4F79800
                SJ      label_1aae             ; 1AA3 0 080 1AB CB09

                                               ; 1AA5 from 1A9D (DD0,080,1AB)
label_1aa5:     CMPB    A, #000h               ; 1AA5 0 080 1AB C600
                JLT     label_1aae             ; 1AA7 0 080 1AB CA05

                CLRB    r0                     ; 1AA9 0 080 1AB 2015
                CMPB    r0, off(001f7h)        ; 1AAB 0 080 1AB 20C3F7
                                               ; 1AAE from 1AA3 (DD0,080,1AB)
                                               ; 1AAE from 1AA7 (DD0,080,1AB)
label_1aae:     XORB    PSWH, #080h            ; 1AAE 0 080 1AB A2F080
                MB      off(012fh).7, C           ; 12fh.7
                                               ; 1AB4 from 1A8B (DD0,080,1AB)
                                               ; 1AB4 from 1A8E (DD0,080,1AB)
                                               ; 1AB4 from 1A91 (DD0,080,1AB)
label_1ab4:     STB     A, r2                  ; 1AB4 0 080 1AB 8A
                CLRB    r0                     ; 1AB5 0 080 1AB 2015
                MOVB    r1, #006h              ; 1AB7 0 080 1AB 9906
                MOVB    r3, off(012fh)            ; 12fh
                MOV     DP, #00103h            ; 1ABC 0 080 1AB 620301
                MOV     X1, #03af1h            ; 1ABF 0 080 1AB 60F13A
                SB      PSWL.4                 ; 1AC2 0 080 1AB A31C
                CAL     label_3112             ; 1AC4 0 080 1AB 321231

;label_3112:     LB      A, r0                  ; 3112 0 080 1AB 78
;                MBR     C, [DP]       			;bit (#from AL) in [DP]
;                LC      A, [X1]                ; 3115 0 080 1AB 90A8
;                JLT     label_311b    			;does the bit [dp].R0 tell us what info to do calcs on?
;                LB      A, ACCH       			;if C == 1 then load the byte in AH
;                                               ; 311B from 3117 (DD0,080,1AB)
;label_311b:     MB      C, PSWL.4              ; MB pswl.4 int C
;
;				;if C==0 then r2-A else A-r2
;                JLT     label_3122             ; 311D 0 080 1AB CA03
;                CMPB    A, r2                  ; 311F 0 080 1AB 4A
;                SJ      label_3124             ; 3120 0 080 1AB CB02
;                                               ; 3122 from 311D (DD0,080,1AB)
;label_3122:     CMPB    r2, A                  ; 3122 0 080 1AB 22C1
;                                               ; 3124 from 3120 (DD0,080,1AB)
;label_3124:     LB      A, r0                  ; 3124 0 080 1AB 78
;                MBR     [DP], C                ; 3125 0 080 1AB C220
;                INC     X1                     ; 3127 0 080 1AB 70
;                INC     X1                     ; 3128 0 080 1AB 70
;                INCB    r0                     ; 3129 0 080 1AB A8
;                DECB    r1                     ; 312A 0 080 1AB B9
;                JNE     label_3112             ; 312B 0 080 1AB CEE5
;                ;why loop?
;                RT                             ; 312D 0 080 1AB 01

                JBS     off(012fh).7, label_1ace  ; 1AC7 0 080 1AB EF2F04
                MB      C, r3.2                ; 1ACA 0 080 1AB 232A
                MB      r3.1, C                ; 1ACC 0 080 1AB 2339
                                               ; 1ACE from 1AC7 (DD0,080,1AB)
label_1ace:     MOVB    off(012fh), r3            ; 12fh
                CLRB    r0                     ; 1AD1 0 080 1AB 2015
                MOVB    r1, #002h              ; 1AD3 0 080 1AB 9902
                MOVB    r2, 0a3h        ;temp       ; 1AD5 0 080 1AB C5A34A
                MOV     X1, #03afdh            ; 1AD8 0 080 1AB 60FD3A
                MOV     DP, #00128h            ; 1ADB 0 080 1AB 622801
                CAL     label_3112             ; 1ADE 0 080 1AB 321231

;label_3112:     LB      A, r0                  ; 3112 0 080 1AB 78
;                MBR     C, [DP]       			;bit (#from AL) in [DP]
;                LC      A, [X1]                ; 3115 0 080 1AB 90A8
;                JLT     label_311b    			;does the bit [dp].R0 tell us what info to do calcs on?
;                LB      A, ACCH       			;if C == 1 then load the byte in AH
;                                               ; 311B from 3117 (DD0,080,1AB)
;label_311b:     MB      C, PSWL.4              ; MB pswl.4 int C
;
;				;if C==0 then r2-A else A-r2
;                JLT     label_3122             ; 311D 0 080 1AB CA03
;                CMPB    A, r2                  ; 311F 0 080 1AB 4A
;                SJ      label_3124             ; 3120 0 080 1AB CB02
;                                               ; 3122 from 311D (DD0,080,1AB)
;label_3122:     CMPB    r2, A                  ; 3122 0 080 1AB 22C1
;                                               ; 3124 from 3120 (DD0,080,1AB)
;label_3124:     LB      A, r0                  ; 3124 0 080 1AB 78
;                MBR     [DP], C                ; 3125 0 080 1AB C220
;                INC     X1                     ; 3127 0 080 1AB 70
;                INC     X1                     ; 3128 0 080 1AB 70
;                INCB    r0                     ; 3129 0 080 1AB A8
;                DECB    r1                     ; 312A 0 080 1AB B9
;                JNE     label_3112             ; 312B 0 080 1AB CEE5
;                ;why loop?
;                RT                             ; 312D 0 080 1AB 01


                MOVB    r1, #002h              ; 1AE1 0 080 1AB 9902
                MOVB    r2, 0cbh               ; 1AE3 0 080 1AB C5CB4A
                RB      PSWL.4                 ; 1AE6 0 080 1AB A30C
                CAL     label_3112             ; 1AE8 0 080 1AB 321231

;label_3112:     LB      A, r0                  ; 3112 0 080 1AB 78
;                MBR     C, [DP]       			;bit (#from AL) in [DP]
;                LC      A, [X1]                ; 3115 0 080 1AB 90A8
;                JLT     label_311b    			;does the bit [dp].R0 tell us what info to do calcs on?
;                LB      A, ACCH       			;if C == 1 then load the byte in AH
;                                               ; 311B from 3117 (DD0,080,1AB)
;label_311b:     MB      C, PSWL.4              ; MB pswl.4 int C
;
;				;if C==0 then r2-A else A-r2
;                JLT     label_3122             ; 311D 0 080 1AB CA03
;                CMPB    A, r2                  ; 311F 0 080 1AB 4A
;                SJ      label_3124             ; 3120 0 080 1AB CB02
;                                               ; 3122 from 311D (DD0,080,1AB)
;label_3122:     CMPB    r2, A                  ; 3122 0 080 1AB 22C1
;                                               ; 3124 from 3120 (DD0,080,1AB)
;label_3124:     LB      A, r0                  ; 3124 0 080 1AB 78
;                MBR     [DP], C                ; 3125 0 080 1AB C220
;                INC     X1                     ; 3127 0 080 1AB 70
;                INC     X1                     ; 3128 0 080 1AB 70
;                INCB    r0                     ; 3129 0 080 1AB A8
;                DECB    r1                     ; 312A 0 080 1AB B9
;                JNE     label_3112             ; 312B 0 080 1AB CEE5
;                ;why loop?
;                RT                             ; 312D 0 080 1AB 01

                MOVB    r1, #002h              ; 1AEB 0 080 1AB 9902
                MOVB    r2, 0a6h               ; 1AED 0 080 1AB C5A64A
                CAL     label_3112             ; 1AF0 0 080 1AB 321231

;label_3112:     LB      A, r0                  ; 3112 0 080 1AB 78
;                MBR     C, [DP]       			;bit (#from AL) in [DP]
;                LC      A, [X1]                ; 3115 0 080 1AB 90A8
;                JLT     label_311b    			;does the bit [dp].R0 tell us what info to do calcs on?
;                LB      A, ACCH       			;if C == 1 then load the byte in AH
;                                               ; 311B from 3117 (DD0,080,1AB)
;label_311b:     MB      C, PSWL.4              ; MB pswl.4 int C
;
;				;if C==0 then r2-A else A-r2
;                JLT     label_3122             ; 311D 0 080 1AB CA03
;                CMPB    A, r2                  ; 311F 0 080 1AB 4A
;                SJ      label_3124             ; 3120 0 080 1AB CB02
;                                               ; 3122 from 311D (DD0,080,1AB)
;label_3122:     CMPB    r2, A                  ; 3122 0 080 1AB 22C1
;                                               ; 3124 from 3120 (DD0,080,1AB)
;label_3124:     LB      A, r0                  ; 3124 0 080 1AB 78
;                MBR     [DP], C                ; 3125 0 080 1AB C220
;                INC     X1                     ; 3127 0 080 1AB 70
;                INC     X1                     ; 3128 0 080 1AB 70
;                INCB    r0                     ; 3129 0 080 1AB A8
;                DECB    r1                     ; 312A 0 080 1AB B9
;                JNE     label_3112             ; 312B 0 080 1AB CEE5
;                ;why loop?
;                RT                             ; 312D 0 080 1AB 01

                SB      PSWL.4                 ; 1AF3 0 080 1AB A31C
                JBS     off(0123h).7, label_1b19 ; 1AF5 0 080 1AB EF2321
                JBS     off(0011fh).4, label_1b26 ; 1AF8 0 080 1AB EC1F2B
                JBR     off(0124h).3, label_1b13  ; 1AFB 0 080 1AB DB2415
                MB      C, 0feh.6              ; 1AFE 0 080 1AB C5FE2E
                JGE     label_1b13             ; 1B01 0 080 1AB CD10
                JBR     off(0128h).4, label_1b13  ; 1B03 0 080 1AB DC280D
                JBS     off(0128h).2, label_1b19  ; 1B06 0 080 1AB EA2810
                JBR     off(0128h).0, label_1b19  ; 1B09 0 080 1AB D8280D
                JBS     off(012ah).7, label_1b19 ; 1B0C 0 080 1AB EF2A0A
                MOVB    off(001f8h), #0f0h		; 1f8h
                                               ; 1B13 from 1AFB (DD0,080,1AB)
                                               ; 1B13 from 1B01 (DD0,080,1AB)
                                               ; 1B13 from 1B03 (DD0,080,1AB)
label_1b13:     LB      A, off(001f8h)         ; 1B13 0 080 1AB F4F8
                JEQ     label_1b1f             ; 1B15 0 080 1AB C908
                RB      PSWL.4                 ; 1B17 0 080 1AB A30C
                                               ; 1B19 from 1AF5 (DD0,080,1AB)
                                               ; 1B19 from 1B06 (DD0,080,1AB)
                                               ; 1B19 from 1B09 (DD0,080,1AB)
                                               ; 1B19 from 1B0C (DD0,080,1AB)
                ;err?
label_1b19:     MOVB    off(001f9h), #0f0h		;
                SJ      label_1b5c             ; 1B1D 0 080 1AB CB3D
                                               ; 1B1F from 1B15 (DD0,080,1AB)
label_1b1f:     LB      A, off(001f9h)         ; 1B1F 0 080 1AB F4F9
                JEQ     label_1b28             ; 1B21 0 080 1AB C905
                JBS     off(012ah).5, label_1b5c ; 1B23 0 080 1AB ED2A36
                                               ; 1B26 from 1AF8 (DD0,080,1AB)
label_1b26:     SJ      label_1b81             ; 1B26 0 080 1AB CB59
                                               ; 1B28 from 1B21 (DD0,080,1AB)
label_1b28:     MB      C, 0ffh.3              ; input

                JGE     label_1b31             ; 1B2B 0 080 1AB CD04
                MOVB    off(001fch), #000h     ; 1B2D 0 080 1AB C4FC9800
                                               ; 1B31 from 1B2B (DD0,080,1AB)
label_1b31:     LB      A, off(001fch)         ; 1B31 0 080 1AB F4FC
                JEQ     label_1b4c             ; 1B33 0 080 1AB C917
                JBS     off(012fh).1, label_1b3c  ; 12fh.1
                MOVB    off(001fdh), #000h     ; 1B38 0 080 1AB C4FD9800
                                               ; 1B3C from 1B35 (DD0,080,1AB)
label_1b3c:     LB      A, off(001fdh)         ; 1B3C 0 080 1AB F4FD
                JEQ     label_1b52             ; 1B3E 0 080 1AB C912
                                               ; 1B40 from 1B4C (DD0,080,1AB)
label_1b40:     LB      A, off(001cbh)         ; 1B40 0 080 1AB F4CB
                JNE     label_1b5c             ; 1B42 0 080 1AB CE18
                JBS     off(0124h).3, label_1b62   ; 1B44 0 080 1AB EB241B
                JBR     off(012ah).5, label_1b62 ;off(P3SF).5 not in euro pw0; 1B47 0 080 1AB DD2A18
                SJ      label_1b5c             ; 1B4A 0 080 1AB CB10
                                               ; 1B4C from 1B33 (DD0,080,1AB)
label_1b4c:     JBR     off(012fh).0, label_1b40 ;P5 is not used in euro pw0 ; 1B4C 0 080 1AB D82FF1
                JBR     off(012fh).3, label_1b59  ; 1B4F 0 080 1AB DB2F07
                                               ; 1B52 from 1B3E (DD0,080,1AB)


label_1b52:     SB      off(012ah).7            ; 1B52 0 080 1AB C42A1F
                MOVB    off(001cbh), #000h     ; 1B55 0 080 1AB C4CB9800
                                               ; 1B59 from 1B4F (DD0,080,1AB)
label_1b59:     SB      off(012ah).5            ; 1B59 0 080 1AB C42A1D
                                               ; 1B5C from 1B1D (DD0,080,1AB)
                                               ; 1B5C from 1B23 (DD0,080,1AB)
                                               ; 1B5C from 1B42 (DD0,080,1AB)
                                               ; 1B5C from 1B4A (DD0,080,1AB)
label_1b5c:     MOVB    off(001cch), #000h     ; 1B5C 0 080 1AB C4CC9800
                SJ      label_1b84             ; 1B60 0 080 1AB CB22
                                               ; 1B62 from 1B44 (DD0,080,1AB)
                                               ; 1B62 from 1B47 (DD0,080,1AB)
label_1b62:     ANDB    off(012ah), #05fh       ; 1B62 0 080 1AB C42AD05F
                JBS     off(0128h).3, label_1b84  ; 1B66 0 080 1AB EB281B
                JBS     off(0128h).5, label_1b84  ; 1B69 0 080 1AB ED2818
                JBR     off(0128h).1, label_1b84  ; 1B6C 0 080 1AB D92815

                MB      C, 0ffh.6              ; AC switch Input
                JLT     label_1b84             ; Jump if AC off (ffh.6 == 1
                CMPB    0a4h, #000h            ; Compare IAT to 0
                JGE     label_1b84             ; Jump if IAT > 0
                LB      A, off(001cch)         ; 1B7A 0 080 1AB F4CC
                JEQ     label_1b84             ; 1B7C 0 080 1AB C906
                RB      off(012ah).6            ; 1B7E 0 080 1AB C42A0E
                                               ; 1B81 from 1B26 (DD0,080,1AB)
                                               ; 1B81 from 1B94 (DD0,080,1AB)
label_1b81:     RC                             ; 1B81 0 080 1AB 95
                SJ      label_1b97             ; 1B82 0 080 1AB CB13
                                               ; 1B84 from 1B60 (DD0,080,1AB)
                                               ; 1B84 from 1B66 (DD0,080,1AB)
                                               ; 1B84 from 1B69 (DD0,080,1AB)
                                               ; 1B84 from 1B6C (DD0,080,1AB)
                                               ; 1B84 from 1B72 (DD0,080,1AB)
                                               ; 1B84 from 1B78 (DD0,080,1AB)
                                               ; 1B84 from 1B7C (DD0,080,1AB)
label_1b84:     JBS     off(012ah).6, label_1b92 ; 1B84 0 080 1AB EE2A0B
                SB      off(012ah).6            ; 1B87 0 080 1AB C42A1E
                MOVB    off(001fbh), #000h     ; 1B8A 0 080 1AB C4FB9800
                MOVB    off(001fah), #000h     ; 1B8E 0 080 1AB C4FA9800
                                               ; 1B92 from 1B84 (DD0,080,1AB)
label_1b92:     LB      A, off(001fbh)         ; 1B92 0 080 1AB F4FB
                JNE     label_1b81             ; 1B94 0 080 1AB CEEB
                SC                             ; 1B96 0 080 1AB 85
                                               ; 1B97 from 1B82 (DD0,080,1AB)
label_1b97:     NOP                            ; 1B97 0 080 1AB 00
                NOP                            ; 1B98 0 080 1AB 00
                NOP                            ; 1B99 0 080 1AB 00
                MB      C, PSWL.4              ; 1B9A 0 080 1AB A32C
                NOP                            ; 1B9C 0 080 1AB 00
                NOP                            ; 1B9D 0 080 1AB 00
                NOP                            ; 1B9E 0 080 1AB 00
                                               ; 1B9F from 1A54 (DD1,080,1AB)

;end eld dealings?
;to here
;******************************

label_1b9f:     MOV     DP, #08000h            ; 1B9F 1 080 1AB 620080
                LB      A, P1                  ; 1BA2 0 080 1AB F522
                                               ; 1BA4 from 1A40 (DD0,080,21E)
label_1ba4:     CAL     label_30f4             ; 1BA4 0 080 1AB 32F430

;label_30f4:     RB      PSWL.5                 ; 30F4 0 ??? ??? A30D
;                STB     A, ACCH                ; 30F6 0 ??? ??? D507
;                AND     IE, #00080h            ; 30F8 0 ??? ??? B51AD08000
;                RB      PSWH.0                 ; 30FD 0 ??? ??? A208
;                LB      A, P2                  ; 30FF 0 ??? ??? F524
;                SLLB    A                      ; 3101 0 ??? ??? 53
;                SWAPB                          ; 3102 0 ??? ??? 83
;                STB     A, LRBH                ; 3103 0 ??? ??? D503
;                LB      A, ACCH                ; 3105 0 ??? ??? F507
;                STB     A, [DP]                ; 3107 0 ??? ??? D2
;                LB      A, [DP]                ; 3108 0 ??? ??? F2
;                CLR     LRB                    ; 3109 0 ??? ??? A415
;                SB      PSWH.0                 ; 310B 0 ??? ??? A218
;                MOV     off(01ah), 0cch     ; 310D 0 ??? ??? B5CC7C1A
;                RT                             ; 3111 0 ??? ??? 01

                MOVB    0ffh, A                ; 1BA7 0 080 1AB C5FF8A
                MOV     LRB, #00020h           ; 1BAA 0 100 1AB 572000
                RT                             ; return from vcal_4

;end of function from vcal_4 when feh.1 = 1
;******************************************************************************


; 1BAE from 1911 from vcal_4 when feh.4 = 1

label_1bae:     MB      C, off(0125h).3         ; 1BAE 0 080 213 C4252B
                MB      off(0125h).4, C         ; 1BB1 0 080 213 C4253C
                LB      A, off(001f1h)         ; 1BB4 0 080 213 F4F1
                MOVB    r7, #015h              ; 1BB6 0 080 213 9F15
                JEQ     label_1bbc             ; 1BB8 0 080 213 C902
                MOVB    r7, #015h              ; 1BBA 0 080 213 9F15
                                               ; 1BBC from 1BB8 (DD0,080,213)
label_1bbc:     LB      A, off(00197h)         ; 1BBC 0 080 213 F497
                JGE     label_1bc1             ; 1BBE 0 080 213 CD01
                ADDB    A, r7                  ; 1BC0 0 080 213 0F
                                               ; 1BC1 from 1BBE (DD0,080,213)
label_1bc1:     CMPB    0a6h, A                ; 1BC1 0 080 213 C5A6C1
                MB      off(P2IO).3, C         ; 1BC4 0 080 213 C4253B
                JGE     label_1bd2             ; 1BC7 0 080 213 CD09
                RC                             ; 1BC9 0 080 213 95
                LB      A, off(001e3h)         ; 1BCA 0 080 213 F4E3
                JNE     label_1bd2             ; 1BCC 0 080 213 CE04
                JBS     off(P2IO).4, label_1bd2 ; 1BCE 0 080 213 EC2501
                SC                             ; 1BD1 0 080 213 85
                                               ; 1BD2 from 1BC7 (DD0,080,213)
                                               ; 1BD2 from 1BCC (DD0,080,213)
                                               ; 1BD2 from 1BCE (DD0,080,213)
label_1bd2:     MB      off(0126h).6, C         ; 1BD2 0 080 213 C4263E
                LB      A, #0d7h               ; 1BD5 0 080 213 77D7
                JBR     off(0126h).4, label_1bdc ; 1BD7 0 080 213 DC2602
                LB      A, #0d4h               ; 1BDA 0 080 213 77D4
                                               ; 1BDC from 1BD7 (DD0,080,213)
label_1bdc:     CMPB    A, 0a6h                ; 1BDC 0 080 213 C5A6C2
                MB      off(0126h).4, C         ; 1BDF 0 080 213 C4263C
                MOV     X1, #0397bh            ; 1BE2 0 080 213 607B39
                LB      A, 0a7h                ; 1BE5 0 080 213 F5A7
                JBS     off(0129h).7, label_1bf0 ; if vtec on jump
                ADD     X1, #00015h            ; 1BEA 0 080 213 90801500
                LB      A, 0a6h                ; 1BEE 0 080 213 F5A6
                                               ; 1BF0 from 1BE7 (DD0,080,213)
label_1bf0:     VCAL    1                      ; 1BF0 0 080 213 11
                STB     A, off(0178h)         ; 1BF1 0 080 213 D478

;*******************

                ;euro pw0 doesnt have from here
                RB      off(00127h).2          ; Clear 127h.2
                MB      C, 0ffh.4              ; input
                JGE     label_1c10             ; 1BF9 0 080 213 CD15
                SB      off(00127h).1          ; Set 127h.1
                RB      off(00127h).0          ; Clear 127h.0
                JEQ     label_1c0a             ; 1C01 0 080 213 C907
                SB      off(00127h).2          ; Set 127h.2
                MOVB    off(001f4h), #000h     ; 1C06 0 080 213 C4F49800
                                               ; 1C0A from 1C01 (DD0,080,213)
label_1c0a:     MOVB    off(001cfh), #002h     ; 1C0A 0 080 213 C4CF9802
                SJ      label_1c2b             ; 1C0E 0 080 213 CB1B
                                               ; 1C10 from 1BF9 (DD0,080,213)
label_1c10:     JBR     off(00127h).1, label_1c2b ; 1C10 0 080 213 D92718
                LB      A, off(001f4h)         ; 1C13 0 080 213 F4F4
                JNE     label_1c2b             ; 1C15 0 080 213 CE14
                SB      off(00127h).0          ; set 127h.0
                MOV     X1, #039b7h            ; 1C1A 0 080 213 60B739
                LB      A, 0a3h                ; 1C1D 0 080 213 F5A3
                VCAL    3                      ; 1C1F 0 080 213 13
                CMPB    off(001cfh), #000h     ; 1C20 0 080 213 C4CFC000
                JNE     label_1c2c             ; 1C24 0 080 213 CE06
                SUBB    A, #050h               ; 1C26 0 080 213 A650
                SMOVI                          ; 1C28 0 080 213 04
                JGE     label_1c2c             ; 1C29 0 080 213 CD01
                                               ; 1C2B from 1C0E (DD0,080,213)
                                               ; 1C2B from 1C10 (DD0,080,213)
                                               ; 1C2B from 1C15 (DD0,080,213)
label_1c2b:     CLR     A                      ; 1C2B 1 080 213 F9
                                               ; 1C2C from 1C24 (DD0,080,213)
                                               ; 1C2C from 1C29 (DD0,080,213)
label_1c2c:     ST      A, off(00186h)         ; 1C2C 1 080 213 D486

;*****************

                MOV     X1, #03a1ch            ; 1C2E 1 080 213 601C3A
                LB      A, 0a6h                ; 1C31 0 080 213 F5A6
                VCAL    1                      ; 1C33 0 080 213 11
                MOV     USP, A                 ; 1C34 0 080 213 A18A
                LB      A, 0adh                ; 1C36 0 080 213 F5AD
                MB      C, ACC.7               ; 1C38 0 080 213 C5062F
                MB      PSWL.5, C              ; 1C3B 0 080 213 A33D
                JBS     off(0124h).2, label_1c44  ; 1C3D 0 080 213 EA2404
                                               ; 1C40 from 1C44 (DD0,080,213)
label_1c40:     CLR     er3                    ; 1C40 0 080 213 4715
                SJ      label_1c53             ; 1C42 0 080 213 CB0F
                                               ; 1C44 from 1C3D (DD0,080,213)
label_1c44:     JBR     off(0123h).3, label_1c40 ; 1C44 0 080 213 DB23F9
                MOV     X1, #03a31h            ; 1C47 0 080 213 60313A
                MOVB    r0, #080h              ; 1C4A 0 080 213 9880
                CMPB    A, r0                  ; 1C4C 0 080 213 48
                JGE     label_1c51             ; 1C4D 0 080 213 CD02
                XCHGB   A, r0                  ; 1C4F 0 080 213 2010
                                               ; 1C51 from 1C4D (DD0,080,213)
label_1c51:     SUBB    A, r0                  ; 1C51 0 080 213 28
                VCAL    3                      ; 1C52 0 080 213 13
                                               ; 1C53 from 1C42 (DD0,080,213)
label_1c53:     L       A, off(00180h)         ; 1C53 1 080 213 E480
                MB      C, PSWL.5              ; 1C55 1 080 213 A32D
                JGE     label_1c5e             ; 1C57 1 080 213 CD05
                SUB     A, er3                 ; 1C59 1 080 213 2B
                JGE     label_1c62             ; 1C5A 1 080 213 CD06
                SJ      label_1c79             ; 1C5C 1 080 213 CB1B
                                               ; 1C5E from 1C57 (DD1,080,213)
label_1c5e:     ADD     A, er3                 ; 1C5E 1 080 213 0B
                J       label_3221             ; 1C5F 1 080 213 032132
                                               ; 1C62 from 1C5A (DD1,080,213)
                                               ; 1C62 from 3226 (DD1,080,213)
label_1c62:     MOV     X2, #00080h            ; 1C62 1 080 213 618000
                CMP     A, #00800h             ; 1C65 1 080 213 C60008
                JGE     label_1c75             ; 1C68 1 080 213 CD0B
                MOV     X2, #00040h            ; 1C6A 1 080 213 614000
                CMP     A, #00400h             ; 1C6D 1 080 213 C60004
                JGE     label_1c75             ; 1C70 1 080 213 CD03
                MOV     X2, #0001eh            ; 1C72 1 080 213 611E00
                                               ; 1C75 from 1C68 (DD1,080,213)
                                               ; 1C75 from 1C70 (DD1,080,213)
label_1c75:     SUB     A, X2                  ; 1C75 1 080 213 91A2
                JGE     label_1c7a             ; 1C77 1 080 213 CD01
                                               ; 1C79 from 1C5C (DD1,080,213)
label_1c79:     CLR     A                      ; 1C79 1 080 213 F9
                                               ; 1C7A from 1C77 (DD1,080,213)
label_1c7a:     CMP     A, USP                 ; 1C7A 1 080 213 A1C2
                JLT     label_1c80             ; 1C7C 1 080 213 CA02
                                               ; 1C7E from 3229 (DD1,080,213)
label_1c7e:     MOV     A, USP                 ; 1C7E 1 080 213 A199
                                               ; 1C80 from 1C7C (DD1,080,213)
label_1c80:     ST      A, off(00180h)         ; 1C80 1 080 213 D480

;***********************

                JBS     off(0011fh).4, label_1ccf ; if starting or bad rev count jump
                JBR     off(0126h).1, label_1c8b ; 1C85 1 080 213 D92603
                J       label_1d07             ; 1C88 1 080 213 03071D
                                               ; 1C8B from 1C85 (DD1,080,213)

label_1c8b:     LB      A, off(0130h)            ; 1C8B 0 080 213 F430
                ANDB    A, #054h               ; 01010100 = map codes and TPS code
                JNE     label_1c94             ; if no codes jump to 1c94
                JBR     off(00127h).3, label_1c97 ; 1C91 0 080 213 DB2703
                                               ; 1C94 from 1C8F (DD0,080,213)
                                               ; 1C94 from 1CA9 (DD1,080,213)
label_1c94:     J       label_1d2f             ; 1C94 0 080 213 032F1D

;err???
                                               ; 1C97 from 1C91 (DD0,080,213)
label_1c97:     JBR     off(0123h).3, label_1c9f ; 1C97 0 080 213 DB2305
                JBR     off(0126h).4, label_1ca9 ; 1C9A 0 080 213 DC260C
                SJ      label_1cbc             ; 1C9D 0 080 213 CB1D
                                               ; 1C9F from 1C97 (DD0,080,213)
label_1c9f:     JBR     off(0124h).6, label_1ca6  ; 1C9F 0 080 213 DE2404
                L       A, off(0178h)         ; 1CA2 1 080 213 E478
                JNE     label_1cba             ; 1CA4 1 080 213 CE14
                                               ; 1CA6 from 1C9F (DD0,080,213)
label_1ca6:     JBS     off(0126h).4, label_1cbc ; 1CA6 1 080 213 EC2613
                                               ; 1CA9 from 1C9A (DD0,080,213)
label_1ca9:     JBR     off(0124h).4, label_1c94  ; 1CA9 1 080 213 DC24E8
                JBR     off(0118h).7, label_1cb7 ; if manual jump
                MB      C, 0ffh.5              ; else look at this input
                JLT     label_1cb7             ; if its 1 jump
                JBR     off(0124h).6, label_1d2f  ; 1CB4 1 080 213 DE2478
                                               ; 1CB7 from 1CAC (DD1,080,213)
                                               ; 1CB7 from 1CB2 (DD1,080,213)
label_1cb7:     J       label_1d57             ; 1CB7 1 080 213 03571D
                                               ; 1CBA from 1CA4 (DD1,080,213)
label_1cba:     SJ      label_1d29             ; 1CBA 1 080 213 CB6D
                                               ; 1CBC from 1C9D (DD0,080,213)
                                               ; 1CBC from 1CA6 (DD1,080,213)
label_1cbc:     RB      off(0126h).2            ; 1CBC 0 080 213 C4260A
                CAL     label_2ff4             ; 1CBF 0 080 213 32F42F
                L       A, off(00180h)         ; 1CC2 1 080 213 E480
                JEQ     label_1cc9             ; 1CC4 1 080 213 C903
                J       label_1f71             ; 1CC6 1 080 213 03711F
                                               ; 1CC9 from 1CC4 (DD1,080,213)
label_1cc9:     L       A, #011ebh             ; 1CC9 1 080 213 67EB11
                J       label_1f7e             ; 1CCC 1 080 213 037E1F
                                               ; 1CCF from 1C82 (DD1,080,213)
label_1ccf:     SB      off(0126h).1            ; 1CCF 1 080 213 C42619
                CLRB    A                      ; 1CD2 0 080 213 FA
                CMPB    0a3h, #0d0h            ; 1CD3 0 080 213 C5A3C0D0
                JGE     label_1ce7             ; 1CD7 0 080 213 CD0E
                LB      A, #003h               ; 1CD9 0 080 213 7703
                JBR     off(0124h).4, label_1ce7  ; 1CDB 0 080 213 DC2409
                SLLB    A                      ; 1CDE 0 080 213 53
                CMPB    0a3h, #057h            ; 1CDF 0 080 213 C5A3C057
                JGE     label_1ce7             ; 1CE3 0 080 213 CD02
                LB      A, #009h               ; 1CE5 0 080 213 7709
                                               ; 1CE7 from 1CD7 (DD0,080,213)
                                               ; 1CE7 from 1CDB (DD0,080,213)
                                               ; 1CE7 from 1CE3 (DD0,080,213)
label_1ce7:     EXTND                          ; 1CE7 1 080 213 F8
                ADD     A, #03a37h             ; 1CE8 1 080 213 86373A
                MOV     X1, A                  ; 1CEB 1 080 213 50
                LCB     A, [X1]                ; 1CEC 1 080 213 90AA
                MOVB    off(001f1h), A         ; 1CEE 1 080 213 C4F18A
                INC     X1                     ; 1CF1 1 080 213 70
                LC      A, [X1]                ; 1CF2 1 080 213 90A8
                ST      A, off(0017ch)         ; 1CF4 1 080 213 D47C

;**********************

                MOV     X1, #03a43h            ; 1CF6 1 080 213 60433A
                LB      A, 0a3h                ; 1CF9 0 080 213 F5A3
                VCAL    1                      ; 1CFB 0 080 213 11
                MOV     X1, A                  ; 1CFC 0 080 213 50
                CAL     label_2ff4             ; 1CFD 0 080 213 32F42F
                ; warning: had to flip DD
                ADD     A, X1                  ; 1D00 1 080 213 9082
                VCAL    6                      ; 1D02 1 080 213 16
                ST      A, off(017ah)          ; 1D03 1 080 213 D47A

;*********

                SJ      label_1d35             ; 1D05 1 080 213 CB2E

                ;err 17ah?
                                               ; 1D07 from 1C88 (DD1,080,213)
label_1d07:     CAL     label_2ff4             ; 1D07 1 080 213 32F42F
                LB      A, off(001f1h)         ; 1D0A 0 080 213 F4F1
                CMPB    A, #0cdh               ; 1D0C 0 080 213 C6CD
                L       A, off(017ah)          ; 1D0E 1 080 213 E47A
                JGE     label_1d22             ; 1D10 1 080 213 CD10
                SUB     A, off(0017ch)         ; 1D12 1 080 213 A77C
                JLT     label_1d1b             ; 1D14 1 080 213 CA05
                ST      A, off(017ah)          ; 1D16 1 080 213 D47A

;**********************
                CMP     A, er3                 ; 1D18 1 080 213 4B
                JGE     label_1d22             ; 1D19 1 080 213 CD07
                                               ; 1D1B from 1D14 (DD1,080,213)
label_1d1b:     RB      off(0126h).1            ; 1D1B 1 080 213 C42609
                SB      off(0126h).0            ; 1D1E 1 080 213 C42618
                L       A, er3                 ; 1D21 1 080 213 37
                                               ; 1D22 from 1D10 (DD1,080,213)
                                               ; 1D22 from 1D19 (DD1,080,213)
label_1d22:     ST      A, er3                 ; 1D22 1 080 213 8B
                CAL     label_301b             ; 1D23 1 080 213 321B30
                ADD     A, er3                 ; 1D26 1 080 213 0B
                SJ      label_1d35             ; 1D27 1 080 213 CB0C
                                               ; 1D29 from 1CBA (DD1,080,213)
label_1d29:     CAL     label_2ff4             ; 1D29 1 080 213 32F42F
                SC                             ; 1D2C 1 080 213 85
                SJ      label_1d36             ; 1D2D 1 080 213 CB07
                                               ; 1D2F from 1C94 (DD0,080,213)
                                               ; 1D2F from 1CB4 (DD1,080,213)
label_1d2f:     RB      off(0126h).0            ; 1D2F 0 080 213 C42608
                CAL     label_2ff4             ; 1D32 0 080 213 32F42F
                                               ; 1D35 from 1D05 (DD1,080,213)
                                               ; 1D35 from 1D27 (DD1,080,213)
label_1d35:     RC                             ; 1D35 1 080 213 95
                                               ; 1D36 from 1D2D (DD1,080,213)
label_1d36:     ST      A, off(0174h)          ; 1D36 1 080 213 D474

;*********************

                MB      off(0126h).3, C         ; 1D38 1 080 213 C4263B
                RB      off(0126h).2            ; 1D3B 1 080 213 C4260A
                ANDB    off(0125h), #09fh       ; 1D3E 1 080 213 C425D09F
                MB      C, 0ffh.5              ; 1D42 1 080 213 C5FF2D
                MB      off(00127h).6, C       ; 1D45 1 080 213 C4273E
                MB      C, off(00127h).7       ; 1D48 1 080 213 C4272F
                CAL     label_32db             ; 1D4B 1 080 213 32DB32
                MB      C, 0ffh.3              ; 1D4E 1 080 213 C5FF2B
                MB      off(00127h).4, C       ; 1D51 1 080 213 C4273C
                J       label_1e98             ; 1D54 1 080 213 03981E
                                               ; 1D57 from 1CB7 (DD1,080,213)
label_1d57:     MB      C, off(0125h).5         ; 1D57 1 080 213 C4252D
                MB      off(0125h).6, C         ; 1D5A 1 080 213 C4253E
                RC                             ; 1D5D 1 080 213 95
                JBS     off(0123h).3, label_1d64 ; 1D5E 1 080 213 EB2303
                MB      C, off(0125h).3         ; 1D61 1 080 213 C4252B
                                               ; 1D64 from 1D5E (DD1,080,213)
label_1d64:     MB      off(0125h).5, C         ; 1D64 1 080 213 C4253D
                RB      off(0126h).3            ; 1D67 1 080 213 C4260B
                RB      off(0125h).7            ; 1D6A 1 080 213 C4250F
                JBS     off(0126h).0, label_1da6 ; 1D6D 1 080 213 E82636
                JBR     off(0126h).2, label_1da6 ; 1D70 1 080 213 DA2633
                JBS     off(0125h).3, label_1d82 ; 1D73 1 080 213 EB250C
                L       A, off(0176h)          ; 1D76 1 080 213 E476
                CAL     label_3000             ; 1D78 1 080 213 320030
                ADD     A, #00400h             ; 1D7B 1 080 213 860004
                CMP     A, off(00194h)         ; 1D7E 1 080 213 C794
                JLT     label_1da6             ; 1D80 1 080 213 CA24
                                               ; 1D82 from 1D73 (DD1,080,213)
label_1d82:     JBR     off(0125h).5, label_1d90 ; 1D82 1 080 213 DD250B
                JBS     off(0125h).6, label_1d8c ; 1D85 1 080 213 EE2504
                MOVB    off(001f2h), #008h     ; 1D88 1 080 213 C4F29808
                                               ; 1D8C from 1D85 (DD1,080,213)
label_1d8c:     LB      A, off(001f2h)         ; 1D8C 0 080 213 F4F2
                JNE     label_1da6             ; 1D8E 0 080 213 CE16
                                               ; 1D90 from 1D82 (DD1,080,213)
label_1d90:     JBS     off(0126h).7, label_1da6 ; 1D90 0 080 213 EF2613
                JBS     off(00127h).2, label_1da6 ; 1D93 0 080 213 EA2710
                MB      C, off(00127h).7       ; 1D96 0 080 213 C4272F
                CAL     label_32db             ; 1D99 0 080 213 32DB32
                JLT     label_1dbd             ; 1D9C 0 080 213 CA1F
                JBR     off(00127h).5, label_1dbd ; 1D9E 0 080 213 DD271C
                JBR     off(0124h).6, label_1dbd  ; 1DA1 0 080 213 DE2419
                NOP                            ; 1DA4 0 080 213 00
                NOP                            ; 1DA5 0 080 213 00
                                               ; 1DA6 from 1D6D (DD1,080,213)
                                               ; 1DA6 from 1D70 (DD1,080,213)
                                               ; 1DA6 from 1D80 (DD1,080,213)
                                               ; 1DA6 from 1D8E (DD0,080,213)
                                               ; 1DA6 from 1D90 (DD0,080,213)
                                               ; 1DA6 from 1D93 (DD0,080,213)
label_1da6:     SB      off(0126h).2            ; 1DA6 0 080 213 C4261A
                L       A, off(0174h)          ; 1DA9 1 080 213 E474
                JBS     off(0126h).0, label_1db1 ; 1DAB 1 080 213 E82603
                CAL     label_2ff4             ; 1DAE 1 080 213 32F42F
                                               ; 1DB1 from 1DAB (DD1,080,213)
label_1db1:     JBS     off(0124h).2, label_1dbb  ; 1DB1 1 080 213 EA2407
                JBS     off(0125h).7, label_1dbb ; 1DB4 1 080 213 EF2504
                ADD     A, #00040h             ; 1DB7 1 080 213 864000
                VCAL    6                      ; 1DBA 1 080 213 16
                                               ; 1DBB from 1DB1 (DD1,080,213)
                                               ; 1DBB from 1DB4 (DD1,080,213)
label_1dbb:     ST      A, off(00194h)         ; 1DBB 1 080 213 D494

;***************************

                                               ; 1DBD from 1D9C (DD0,080,213)
                                               ; 1DBD from 1D9E (DD0,080,213)
                                               ; 1DBD from 1DA1 (DD0,080,213)
label_1dbd:     RB      off(0126h).0            ; 1DBD 1 080 213 C42608
                MOV     X1, #03a08h            ; 1DC0 1 080 213 60083A
                JBR     off(0125h).5, label_1df4 ; 1DC3 1 080 213 DD252E
                RB      off(00127h).4          ; Clear 127h.4
                MB      C, 0ffh.3              ; 
                MB      off(00127h).4, C       ; Move ffh.3 into 127h.4
                JEQ     label_1dd4             ; 1DCF 1 080 213 C903
                XORB    PSWH, #080h            ; 1DD1 1 080 213 A2F080
                                               ; 1DD4 from 1DCF (DD1,080,213)
label_1dd4:     JGE     label_1dda             ; 1DD4 1 080 213 CD04
                MOVB    off(001f3h), #00ah     ; Set 1f3h to #00ah
                                               ; 1DDA from 1DD4 (DD1,080,213)
label_1dda:     LB      A, off(001f3h)         ; 1DDA 0 080 213 F4F3
                JEQ     label_1dfd             ; 1DDC 0 080 213 C91F
                JBS     off(0126h).7, label_1dfd ; 1DDE 0 080 213 EF261C
                MOV     X1, #03a14h            ; 1DE1 0 080 213 60143A
                CMP     0c2h, #00127h          ; 1DE4 0 080 213 B5C2C02701
                JLT     label_1dfd             ; 1DE9 0 080 213 CA12
                MOV     X1, #03a18h            ; 1DEB 0 080 213 60183A
                MOV     er0, #00800h           ; 1DEE 0 080 213 44980008
                SJ      label_1e01             ; 1DF2 0 080 213 CB0D
                                               ; 1DF4 from 1DC3 (DD1,080,213)
label_1df4:     MOV     X1, #03a0ch            ; 1DF4 1 080 213 600C3A
                JBS     off(P2IO).2, label_1dfd ; 1DF7 1 080 213 EA2503
                MOV     X1, #03a10h            ; 1DFA 1 080 213 60103A
                                               ; 1DFD from 1DDC (DD0,080,213)
                                               ; 1DFD from 1DDE (DD0,080,213)
                                               ; 1DFD from 1DE9 (DD0,080,213)
                                               ; 1DFD from 1DF7 (DD1,080,213)
label_1dfd:     MOV     er0, #00100h           ; Set er0 to #100h
                                               ; 1E01 from 1DF2 (DD0,080,213)
label_1e01:     L       A, 0c2h                ; 1E01 1 080 213 E5C2
                CMP     A, er0                 ; 1E03 1 080 213 48
                JGE     label_1e07             ; 1E04 1 080 213 CD01
                ST      A, er0                 ; 1E06 1 080 213 88
                                               ; 1E07 from 1E04 (DD1,080,213)
label_1e07:     LC      A, [X1]                ; 1E07 1 080 213 90A8
                MUL                            ; 1E09 1 080 213 9035
                LB      A, off(00196h)         ; 1E0B 0 080 213 F496
                JBS     off(P2IO).2, label_1e1a ; 1E0D 0 080 213 EA250A
                ADDB    A, ACCH                ; 1E10 0 080 213 C50782
                STB     A, r5                  ; 1E13 0 080 213 8D
                L       A, er1                 ; 1E14 1 080 213 35
                ADC     A, off(00194h)         ; 1E15 1 080 213 9794
                VCAL    6                      ; 1E17 1 080 213 16
                SJ      label_1e24             ; 1E18 1 080 213 CB0A
                                               ; 1E1A from 1E0D (DD0,080,213)
label_1e1a:     SUBB    A, ACCH                ; 1E1A 0 080 213 C507A2
                STB     A, r5                  ; 1E1D 0 080 213 8D
                L       A, off(00194h)         ; 1E1E 1 080 213 E494
                SBC     A, er1                 ; 1E20 1 080 213 39
                JGE     label_1e24             ; 1E21 1 080 213 CD01
                CLR     A                      ; 1E23 1 080 213 F9
                                               ; 1E24 from 1E18 (DD1,080,213)
                                               ; 1E24 from 1E21 (DD1,080,213)
label_1e24:     ST      A, er3                 ; 1E24 1 080 213 8B
                L       A, off(0018ch)         ; 1E25 1 080 213 E48C
                VCAL    5                      ; 1E27 1 080 213 15
                CAL     label_322c             ; 1E28 1 080 213 322C32
                ST      A, er3                 ; 1E2B 1 080 213 8B
                LC      A, 00002h[X1]          ; 1E2C 1 080 213 90A90200
                MUL                            ; 1E30 1 080 213 9035
                LB      A, r2                  ; 1E32 0 080 213 7A
                L       A, ACC                 ; 1E33 1 080 213 E506
                SWAP                           ; 1E35 1 080 213 83
                ST      A, er1                 ; 1E36 1 080 213 89
                L       A, er3                 ; 1E37 1 080 213 37
                JBS     off(0125h).2, label_1e3f ; 1E38 1 080 213 EA2504
                ADD     A, er1                 ; 1E3B 1 080 213 09
                VCAL    6                      ; 1E3C 1 080 213 16
                SJ      label_1e43             ; 1E3D 1 080 213 CB04
                                               ; 1E3F from 1E38 (DD1,080,213)
label_1e3f:     SUB     A, er1                 ; 1E3F 1 080 213 29
                JGE     label_1e43             ; 1E40 1 080 213 CD01
                CLR     A                      ; 1E42 1 080 213 F9
                                               ; 1E43 from 1E3D (DD1,080,213)
                                               ; 1E43 from 1E40 (DD1,080,213)
label_1e43:     CAL     label_3031             ; 1E43 1 080 213 323130
                JLT     label_1e4e             ; 1E46 1 080 213 CA06
                MOV     off(00194h), er3       ; 1E48 1 080 213 477C94
                MOVB    off(00196h), r5        ; 1E4B 1 080 213 257C96
;*************************                     ; 1E4E from 1E46 (DD1,080,213)

                ;same from here
label_1e4e:     ST      A, off(0174h)          ; 1E4E 1 080 213 D474


                MOV     USP, #0026ah           ; 1E50 1 080 26A A1986A02
                JBR     off(0125h).5, label_1e8c ; 1E54 1 080 26A DD2535
                JBS     off(0124h).2, label_1e8c  ; 1E57 1 080 26A EA2432
                JBS     off(0123h).7, label_1e8c ; 1E5A 1 080 26A EF232F
                JBS     off(00127h).0, label_1e8c ; 1E5D 1 080 26A E8272C
                LB      A, off(001f1h)         ; 1E60 0 080 26A F4F1
                JNE     label_1e8c             ; 1E62 0 080 26A CE28
                L       A, off(00188h)         ; 1E64 1 080 26A E488
                JNE     label_1e8c             ; 1E66 1 080 26A CE24
                L       A, #08000h             ; 1E68 1 080 26A 670080
                CAL     label_301e             ; 1E6B 1 080 26A 321E30
                ADD     A, off(0176h)          ; 1E6E 1 080 26A 8776
                ST      A, er3                 ; 1E70 1 080 26A 8B
                CAL     label_300c             ; 1E71 1 080 26A 320C30
                L       A, #00001h             ; 1E74 1 080 26A 670100
                JBR     off(0124h).6, label_1e80  ; 1E77 1 080 26A DE2406
                JBS     off(0125h).1, label_1e80 ; 1E7A 1 080 26A E92503
                L       A, #00050h             ; 1E7D 1 080 26A 675000
                                               ; 1E80 from 1E77 (DD1,080,26A)
                                               ; 1E80 from 1E7A (DD1,080,26A)
label_1e80:     ST      A, er0                 ; 1E80 1 080 26A 88
                L       A, off(00194h)         ; 1E81 1 080 26A E494
                SUB     A, er3                 ; 1E83 1 080 26A 2B
                JGT     label_1e89             ; 1E84 1 080 26A C803
                L       A, #00001h             ; 1E86 1 080 26A 670100
                                               ; 1E89 from 1E84 (DD1,080,26A)
label_1e89:     CAL     label_2edd             ; 1E89 1 080 26A 32DD2E
                                               ; 1E8C from 1E54 (DD1,080,26A)
                                               ; 1E8C from 1E57 (DD1,080,26A)
                                               ; 1E8C from 1E5A (DD1,080,26A)
                                               ; 1E8C from 1E5D (DD1,080,26A)
                                               ; 1E8C from 1E62 (DD0,080,26A)
                                               ; 1E8C from 1E66 (DD1,080,26A)
label_1e8c:     L       A, (0026ah-0026ah)[USP] ; 1E8C 1 080 26A E300
                MOV     er1, #01000h           ; 1E8E 1 080 26A 45980010
                CMP     A, er1                 ; 1E92 1 080 26A 49
                JLE     label_1e98             ; 1E93 1 080 26A CF03
                L       A, er1                 ; 1E95 1 080 26A 35
                ST      A, (0026ah-0026ah)[USP] ; 1E96 1 080 26A D300

;*****************
                                               ; 1E98 from 1D54 (DD1,080,213)
                                               ; 1E98 from 1E93 (DD1,080,26A)
label_1e98:     CAL     label_2ff4             ; 1E98 1 080 213 32F42F
                JBR     off(P2SF).1, label_1ea0 ; 1E9B 1 080 213 D92602
                L       A, off(PWCON1)         ; 1E9E 1 080 213 E47A
                                               ; 1EA0 from 1E9B (DD1,080,213)
label_1ea0:     MOV     X2, A                  ; 1EA0 1 080 213 51
                MOV     DP, #03a5eh            ; 1EA1 1 080 213 625E3A
                MOV     X1, #03a72h            ; 1EA4 1 080 213 60723A
                JBR     off(P3SF).3, label_1eb0 ; 1EA7 1 080 213 DB2A06
                MOV     DP, #03a68h            ; 1EAA 1 080 213 62683A
                MOV     X1, #03a81h            ; 1EAD 1 080 213 60813A
                                               ; 1EB0 from 1EA7 (DD1,080,213)
label_1eb0:     JBS     off(P2SF).7, label_1ee1 ; 1EB0 1 080 213 EF262E
                JBR     off(P2SF).6, label_1ef3 ; 1EB3 1 080 213 DE263D
                LB      A, 0a3h                ; 1EB6 0 080 213 F5A3
                VCAL    1                      ; 1EB8 0 080 213 11
                STB     A, r0                  ; 1EB9 0 080 213 88
                CLR     A                      ; 1EBA 1 080 213 F9
                JBS     off(P2).6, label_1ec5  ; 1EBB 1 080 213 EE2407
                L       A, #00002h             ; 1EBE 1 080 213 670200
                JBS     off(P2).5, label_1ec5  ; 1EC1 1 080 213 ED2401
                SLL     A                      ; 1EC4 1 080 213 53
                                               ; 1EC5 from 1EBB (DD1,080,213)
                                               ; 1EC5 from 1EC1 (DD1,080,213)
label_1ec5:     ADD     A, DP                  ; 1EC5 1 080 213 9282
                ST      A, er1                 ; 1EC7 1 080 213 89
                L       A, 0bch                ; 1EC8 1 080 213 E5BC
                CMPC    A, [er1]               ; 1ECA 1 080 213 45AC
                JLT     label_1ef3             ; 1ECC 1 080 213 CA25
                SB      off(P2SF).7            ; 1ECE 1 080 213 C4261F
                MUL                            ; 1ED1 1 080 213 9035
                ST      A, er0                 ; 1ED3 1 080 213 88
                LC      A, 00006h[DP]          ; 1ED4 1 080 213 92A90600
                CMP     A, er0                 ; 1ED8 1 080 213 48
                JLT     label_1edc             ; 1ED9 1 080 213 CA01
                L       A, er0                 ; 1EDB 1 080 213 34
                                               ; 1EDC from 1ED9 (DD1,080,213)
label_1edc:     ADD     A, X2                  ; 1EDC 1 080 213 9182
                VCAL    6                      ; 1EDE 1 080 213 16
                SJ      label_1eef             ; 1EDF 1 080 213 CB0E
                                               ; 1EE1 from 1EB0 (DD1,080,213)
label_1ee1:     LC      A, 00008h[DP]          ; 1EE1 1 080 213 92A90800
                ST      A, er0                 ; 1EE5 1 080 213 88
                L       A, off(0007eh)         ; 1EE6 1 080 213 E47E
                SUB     A, er0                 ; 1EE8 1 080 213 28
                JLT     label_1ef3             ; 1EE9 1 080 213 CA08
                CMP     A, X2                  ; 1EEB 1 080 213 91C2
                JLT     label_1ef3             ; 1EED 1 080 213 CA04
                                               ; 1EEF from 1EDF (DD1,080,213)
label_1eef:     ST      A, off(0174h)          ; 1EEF 1 080 213 D474
                SJ      label_1ef7             ; 1EF1 1 080 213 CB04
                                               ; 1EF3 from 1EB3 (DD1,080,213)
                                               ; 1EF3 from 1ECC (DD1,080,213)
                                               ; 1EF3 from 1EE9 (DD1,080,213)
                                               ; 1EF3 from 1EED (DD1,080,213)
label_1ef3:     RB      off(P2SF).7            ; 1EF3 1 080 213 C4260F
                CLR     A                      ; 1EF6 1 080 213 F9
                                               ; 1EF7 from 1EF1 (DD1,080,213)
label_1ef7:     ST      A, off(0007eh)         ; 1EF7 1 080 213 D47E

;*************************
                CLR     A                      ; 1EF9 1 080 213 F9
                JBR     off(P3SF).1, label_1f37 ; 1EFA 1 080 213 D92A3A
                L       A, #00400h             ; 1EFD 1 080 213 670004
                MB      C, 0feh.6              ; 1F00 1 080 213 C5FE2E
                JLT     label_1f37             ; 1F03 1 080 213 CA32
                LB      A, 0a4h                ; 1F05 0 080 213 F5A4
                MOV     X1, #039fch            ; 1F07 0 080 213 60FC39
                VCAL    3                      ; 1F0A 0 080 213 13
                JBR     off(P2SF).6, label_1f15 ; 1F0B 0 080 213 DE2607
                CMP     0bch, #00028h          ; 1F0E 0 080 213 B5BCC02800
                JGE     label_1f37             ; 1F13 0 080 213 CD22
                                               ; 1F15 from 1F0B (DD0,080,213)
label_1f15:     L       A, off(00088h)         ; 1F15 1 080 213 E488
                JNE     label_1f21             ; 1F17 1 080 213 CE08
                LB      A, 0a4h                ; 1F19 0 080 213 F5A4
                MOV     X1, #03a02h            ; 1F1B 0 080 213 60023A
                VCAL    3                      ; 1F1E 0 080 213 13
                SJ      label_1f37             ; 1F1F 0 080 213 CB16
                                               ; 1F21 from 1F17 (DD1,080,213)
label_1f21:     CMP     A, er3                 ; 1F21 1 080 213 4B
                JLT     label_1f2c             ; 1F22 1 080 213 CA08
                SUB     A, #00010h             ; 1F24 1 080 213 A61000
                JLT     label_1f36             ; 1F27 1 080 213 CA0D
                J       label_3218             ; 1F29 1 080 213 031832
                                               ; 1F2C from 1F22 (DD1,080,213)
label_1f2c:     MOV     X2, #00020h            ; 1F2C 1 080 213 612000
                ADD     A, X2                  ; 1F2F 1 080 213 9182
                JLT     label_1f36             ; 1F31 1 080 213 CA03
                CMP     A, er3                 ; 1F33 1 080 213 4B
                JLT     label_1f37             ; 1F34 1 080 213 CA01
                                               ; 1F36 from 1F27 (DD1,080,213)
                                               ; 1F36 from 1F31 (DD1,080,213)
                                               ; 1F36 from 321B (DD1,080,213)
label_1f36:     L       A, er3                 ; 1F36 1 080 213 37
                                               ; 1F37 from 1EFA (DD1,080,213)
                                               ; 1F37 from 1F03 (DD1,080,213)
                                               ; 1F37 from 1F13 (DD0,080,213)
                                               ; 1F37 from 1F1F (DD0,080,213)
                                               ; 1F37 from 1F34 (DD1,080,213)
                                               ; 1F37 from 321E (DD1,080,213)
label_1f37:     ST      A, off(00188h)         ; 1F37 1 080 213 D488

;************************
				;euro pw0 lacking from here:
                L       A, #00000h             ; 1F39 1 080 213 670000
                JBR     off(P3SF).6, label_1f45 ; 1F3C 1 080 213 DE2A06
                CMPB    off(000fbh), #000h     ; 1F3F 1 080 213 C4FBC000
                JNE     label_1f5a             ; 1F43 1 080 213 CE15
                                               ; 1F45 from 1F3C (DD1,080,213)
label_1f45:     L       A, off(00082h)         ; 1F45 1 080 213 E482
                JEQ     label_1f5c             ; 1F47 1 080 213 C913
                CMPB    off(000fah), #000h     ; 1F49 1 080 213 C4FAC000
                JNE     label_1f54             ; 1F4D 1 080 213 CE05
                MB      C, P0.1                ; 1F4F 1 080 213 C52029
                JGE     label_1f59             ; 1F52 1 080 213 CD05
                                               ; 1F54 from 1F4D (DD1,080,213)
label_1f54:     SUB     A, #00000h             ; 1F54 1 080 213 A60000
                JGE     label_1f5a             ; 1F57 1 080 213 CD01
                                               ; 1F59 from 1F52 (DD1,080,213)
label_1f59:     CLR     A                      ; 1F59 1 080 213 F9
                                               ; 1F5A from 1F43 (DD1,080,213)
                                               ; 1F5A from 1F57 (DD1,080,213)
label_1f5a:     ST      A, off(00182h)         ; 1F5A 1 080 213 D482

;***********************
				;to here
                                               ; 1F5C from 1F47 (DD1,080,213)
label_1f5c:     MOV     er3, off(PWMC1)        ; 1F5C 1 080 213 B4744B
                NOP                            ; 1F5F 1 080 213 00
                L       A, off(00180h)         ; 1F60 1 080 213 E480
                VCAL    5                      ; 1F62 1 080 213 15
                L       A, off(00186h)         ; 1F63 1 080 213 E486
                VCAL    5                      ; 1F65 1 080 213 15
                L       A, off(00188h)         ; 1F66 1 080 213 E488
                JBR     off(P2SF).3, label_1f71 ; 1F68 1 080 213 DB2606
                CMP     A, off(PWCON0)         ; 1F6B 1 080 213 C778
                JGE     label_1f71             ; 1F6D 1 080 213 CD02
                L       A, off(PWCON0)         ; 1F6F 1 080 213 E478
                                               ; 1F71 from 1CC6 (DD1,080,213)
                                               ; 1F71 from 1F68 (DD1,080,213)
                                               ; 1F71 from 1F6D (DD1,080,213)
label_1f71:     VCAL    5                      ; 1F71 1 080 213 15
                L       A, off(00182h)         ; 1F72 1 080 213 E482
                VCAL    5                      ; 1F74 1 080 213 15
                VCAL    7                      ; 1F75 1 080 213 17
                ST      A, off(00192h)         ; 1F76 1 080 213 D492
                MOV     X1, #03a90h            ; 1F78 1 080 213 60903A
                CAL     label_2e0b             ; 1F7B 1 080 213 320B2E
                                               ; 1F7E from 1CCC (DD1,080,213)
label_1f7e:     ST      A, off(0170h)          ; 1F7E 1 080 213 D470
                RT                             ; 1F80 1 080 213 01

;end vcal_4 function when feh.4 = 1;

;****************************************************************************
; ECU LED blinkage function
; this is a really neat function
;
; fch: 		the code that needs to be blinked. Format: 4 bits # long blinks, 4 bits # short
;
; off(1dfh):	The counter for the code being blinked
;			When the it is first found that the code needs to be blinked,
;			a larger value is put into this counter. This makes the long
;			pause between blinked codes. for subsequent blinks in that code
;			a smaller value is put into the counter and this makes the
;			pause between blinks.
;
; off(1aah):	counter for finding codes. Incremented everytime through this funcion.
;			After its INCed it then check to see if that code needs to be blinked.

                ;case: initial long blink (if the first blink is a long one)
              	;[1dfh]: 11h to 2ah 	-> P1.2 = 0 ;LED off
              	;[1dfh]: 5h to 10h 	-> P1.2 = 1 ;guess: LED is on
              	;[1dfh]: 0h to 4h 	-> P1.2 = 0 ;LED off

              	;case: initial short blink (if the first blink is a short one)
				;[1dfh]: 5h to 1fh 	-> P1.2 = 0 ;LED off
				;[1dfh]: 4h to 4h 	-> P1.2 = 1 ;guess: time LED is on
              	;[1dfh]: 0h to 3h 	-> P1.2 = 0 ;LED off


              	;case: subsequent long blink
				;[1dfh]: 11h to 11h 	-> P1.2 = 0 ;LED off
				;[1dfh]: 5h to 10h 	-> P1.2 = 1 ;guess: time LED is on
				;[1dfh]: 0h to 4h 	-> P1.2 = 0 ;LED off

				;case: subsequent short blink
				;[1dfh]: 5h to 6h 	-> P1.2 = 0 ;LED off
				;[1dfh]: 4h to 4h 	-> P1.2 = 1 ;guess: time LED is on
              	;[1dfh]: 0h to 3h 	-> P1.2 = 0 ;LED off


                                               ; 1F81 from 1919 (DD0,080,213)
label_1f81:     MOV     DP, #00032h            ; 32h = 50 codes?
                MOV     USP, #001ceh           ; 1ceh -> 1ffh must be the counters for each code
                CAL     label_309c             ; decrements all the counters unless they are 0

                ;decrements our blinking counter...

;label_309c:     LB      A, [USP]
;                JEQ     label_30a3             ; 309E 0 080 1AB C903
;                DECB    [USP]
;                                               ; 30A3 from 309E (DD0,080,1AB)
;label_30a3:     INC     USP                    ; 30A3 0 080 1AC A116
;                JRNZ    DP, label_309c         ; 30A5 0 080 1AC 30F5
;                RT

                ;code til next label does nothing
                LB      A, 0f8h                ; 1F8B 0 080 1CE F5F8
                ADDB    A, #000h				; stock -> #000h oil pressure?

                JEQ     label_1f93             ; 1F8F 0 080 1CE C902
                STB     A, 0f8h                ; 1F91 0 080 1CE D5F8



                                               ; 1F93 from 1F8F (DD0,080,1CE)
label_1f93:     LB      A, 0fch                ; load blinks
                JEQ     label_1fab             ; if blinks == 0 jump and most likely
                								;try to find a code to blink

                ;so here we have an existing code in the blink byte (fch)
                ;

                CMPB    off(001dfh), #000h     ; if counter != 0
                JNE     label_1ffe             ; jump to blink portion

                ;blinks left but the counter is 0 at this point
                MOVB    r2, #010h              ; else r2 = 16 (one slow blink)
                CMPB    A, r2                  ; if code has slow blinks
                JGE     label_1fa4             ; jump
                MOVB    r2, #001h              ; else r2 = 1;

                                               ; 1FA4 from 1FA0 (DD0,080,1CE)
label_1fa4:     SUBB    A, r2                  ; A -= r2 (either a fast or slow blink)

                MOV     er1, #01106h           ; r2 = 6h, r3 = 11h
                JNE     label_1ff3             ; Jump if all the blinks have not been blinked yet


                                               ; 1FAB from 1F95 (DD0,080,1CE)
label_1fab:     SC                             ; does this turn the light on?
											   ;
                JBS     off(0132h).2, label_2010 ; code 11??


                ;if there is not already a code to blink we get here
                ;this finds the next code to blink if there is one.

                CLR     A                      ; 1FAF 1 080 1CE F9
                ST      A, er0                 ; 1FB0 1 080 1CE 88

                ;loop:
                                               ; 1FB1 from 1FD7 (DD0,080,1CE)
label_1fb1:     INCB    off(001aah)            ; off(aah)++ (code counter?)
                LB      A, off(001aah)         ; load code to blink...
                CMPB    A, #019h               ; if code < 25
                JLT     label_1fc3             ; jump to see if its corresponding bit is set.

                ; ok, so if the code counter is over 24 then
                ; C = 0 and then the P1.2 = 0 (stock code anyway)
                CLRB    off(001aah)            ; else clear the code counter
                LB      A, 0f0h                ;  and finish

                JEQ     label_2010				;feels/mugen code
                SJ      label_1fe9				;feels/mugen code

                ;SJ      label_2010    ;feels pw0 -> JEQ     label_2010   mugen did this too!!!
                ;DW  026cbh            ;feels -----> SJ      label_1fe9; 1FC1

                                               ; 1FC3 from 1FB8 (DD0,080,1CE)
label_1fc3:     STB     A, r7                  ; r7 = code number (starting with 1)
                DECB    r7                     ; r7 = code index (starting with 0)
                MOV     DP, #0027dh            ; code blinkage RAM into DP
                JBS     off(0107h).4, label_1fd0 ; blink a code in the 17-24 range
                DEC     DP                     ;
                JBS     off(0107h).3, label_1fd0 ; blink codes 9-16
                DEC     DP                     ; else blink codes 1-8

                                               ; 1FD0 from 1FC8 (DD0,080,1CE)
                                               ; 1FD0 from 1FCC (DD0,080,1CE)
label_1fd0:     XCHGB   A, r7                  ; get the bit of the
                TRB     [DP]                   ; code blink ram
                JNE     label_1fdc             ; IF that code is set then jump
                INCB    r0                     ; else r0++
                JBR     off(0100h).3, label_1fb1 ; if ASSP.3 == 0 goto loop

                SJ      label_2013             ; RETURN (dont turn on or turn off the led)

                                               ; 1FDC from 1FD4 (DD0,080,1CE)
label_1fdc:     LB      A, r7                  ; load the code index
                CMPB    A, #016h               ;
                JLE     label_1fe3             ; if code index <= 22, jump
                SUBB    A, #016h               ; else A = code index - 22

                                               ; 1FE3 from 1FDF (DD0,080,1CE)
label_1fe3:     CMPB    A, #012h               ; if code
                JNE     label_1fe9             ; != 18 jump
                LB      A, #017h               ; if code 18 then A = 23

                ;gets here if f0h != 0
                                               ; 1FE9 from 1FE5 (DD0,080,1CE)
label_1fe9:     MOVB    r0, #00ah              ; r0 = 10

				;AL = A/r0 remainder in r1
                DIVB                           ; AL = code index/10 r1 = remainder
                SWAPB                          ;
                ORB     A, r1                  ; AL = long blinks | short blinks
                							   ; AL =     XXXX    |     XXXX
                							   ; e.g. code for 9 would be 00001001b
                							   ;              11 would be 00010001b
                							   ;				etc.


                MOV     er1, #02a1fh           ; r3 = 2ah, r2 = 1fh

                ;done with finding the next code to blink

                ;next is the actual blinking logic (it seems anyway)

                                               ; 1FF3 from 1FA9 (DD0,080,1CE)
label_1ff3:     STB     A, 0fch                ; store the blinks in fch
                CMPB    A, #010h               ; compare to 10h
                JLT     label_1ffb             ; if less than 10h (no long blinks left) jump
                MOVB    r2, r3                 ; else r2 gets the short blink length?


                ; this dfh ram must get DECed in a timer interrupt or something
                ;
                                               ; 1FFB from 1FF7 (DD0,080,1CE)
label_1ffb:     MOVB    off(001dfh), r2        ;

                                               ; 1FFE from 1F9B (DD0,080,1CE)
label_1ffe:     CMPB    A, #010h               ; compare A to 10h
                L       A, #00305h             ; this could maybe be blink length?
                							   ; or amount of time between blinks?

                JLT     label_2008             ; if A < 16dec (short blinks only) then jump
                L       A, #00411h             ; else load higher number

                                               ; 2008 from 2003 (DD1,080,1CE)
label_2008:     ST      A, er1                 ; store the new num into r2 and r3
                LB      A, off(001dfh)         ; load the time num from before
                CMPB    A, r2                  ; if dfh value >= r2 (shortb: 5h, longb: 11h)
                JGE     label_2010             ; then P1.2 = 0
                CMPB    r3, A                  ; else if r3 (shortb: 3h, longb:4h) >= dfh
                							   ; then P1.2 = 0
                							   ; if r3 < dfh value then p1.2 = 1




                                               ; 2010 from 1FAC (DD0,080,1CE)
                                               ; 2010 from 1FBF (DD0,080,1CE)
                                               ; 2010 from 200C (DD0,080,1CE)
label_2010:     MB      P1.2, C                ; CEL LED
                                               ; 2013 from 1FDA (DD0,080,1CE)
label_2013:     RT                             ; returns from the vcal_4

;end code blinkage
;***************************************************************************

				;*****************
				;euro pw0 has the following code, but doesnt use it.
				;from here

; 2014 from 1921 called from vcal_4
label_2014:     MOV     DP, #0000dh            ; 2014 0 080 213 620D00
                MOV     USP, #001c1h           ; 2017 0 080 1C1 A198C101
                CAL     label_309c             ; 201B 0 080 1C1 329C30

;label_309c:     LB      A, [USP]
;                JEQ     label_30a3             ; 309E 0 080 1AB C903
;                DECB    [USP]
;                                               ; 30A3 from 309E (DD0,080,1AB)
;label_30a3:     INC     USP                    ; 30A3 0 080 1AC A116
;                JRNZ    DP, label_309c         ; 30A5 0 080 1AC 30F5
;                RT

                LB      A, 0f9h                ; 201E 0 080 1C1 F5F9
                ADDB    A, #001h               ; 2020 0 080 1C1 8601
                JEQ     label_2026             ; 2022 0 080 1C1 C902
                STB     A, 0f9h                ; 2024 0 080 1C1 D5F9
                                               ; 2026 from 2022 (DD0,080,1C1)
label_2026:     LB      A, off(001c6h)         ; 2026 0 080 1C1 F4C6
                JNE     label_2043             ; 2028 0 080 1C1 CE19
                MOVB    off(001c6h), #005h     ; 202A 0 080 1C1 C4C69805
                CLR     er3                    ; 202E 0 080 1C1 4715
                MOV     DP, #000e9h            ; 2030 0 080 1C1 62E900
                MOV     X1, #03b94h            ; 2033 0 080 1C1 60943B
                CAL     label_3069             ; 2036 0 080 1C1 326930
                MOV     er3, #00115h           ; 2039 0 080 1C1 47981501
                MOV     DP, #001b8h            ; 203D 0 080 1C1 62B801
                CAL     label_3069             ; 2040 0 080 1C1 326930
                                               ; 2043 from 2028 (DD0,080,1C1)
label_2043:     RT                             ; 2043 0 080 1C1 01
;***************************************************************************
;***************************************************************************
						;end vcal_4
;***************************************************************************
;***************************************************************************

                                               ; 2044 from 2968 (DD1,080,132)
                                               ; 2044 from 2A5E (DD0,080,132)
label_2044:     CMP     SSP, #00264h           ; 2044 1 080 132 A0C06402
                JNE     label_2075             ; 2048 1 080 132 CE2B
                MOV     DP, #00226h            ; 204A 1 080 132 622602
                LB      A, [DP]                ; 204D 0 080 132 F2
                JNE     label_2075             ; 204E 0 080 132 CE25
                L       A, #022fbh             ; 2050 1 080 132 67FB22
                MOV     X1, #00090h            ; 2053 1 080 132 609000
                JBR     off(P0IO).2, label_205f ; 2056 1 080 132 DA2106
                L       A, #0a25bh             ; 2059 1 080 132 675BA2
                MOV     X1, #00010h            ; 205C 1 080 132 601000
                                               ; 205F from 2056 (DD1,080,132)
label_205f:     CMP     A, 0cch                ; 205F 1 080 132 B5CCC2
                JNE     label_2075             ; 2062 1 080 132 CE11
                CMP     A, IE                  ; 2064 1 080 132 B51AC2
                JNE     label_2075             ; 2067 1 080 132 CE0C
                L       A, X1                  ; 2069 1 080 132 40
                CMP     A, 0ceh                ; 206A 1 080 132 B5CEC2
                JNE     label_2075             ; 206D 1 080 132 CE06
                CMP     LRB, #00020h           ; 206F 1 080 132 A4C02000
                JEQ     label_2082             ; 2073 1 080 132 C90D
                                               ; 2075 from 2048 (DD1,080,132)
                                               ; 2075 from 204E (DD0,080,132)
                                               ; 2075 from 2062 (DD1,080,132)
                                               ; 2075 from 2067 (DD1,080,132)
                                               ; 2075 from 206D (DD1,080,132)
label_2075:     MOVB    0f0h, #041h            ; 2075 1 080 132 C5F09841
                DECB    0e9h                   ; 2079 1 080 132 C5E917
                JNE     label_2081             ; 207C 1 080 132 CE03
                SB      0fdh.0                 ; 207E 1 080 132 C5FD18
                                               ; 2081 from 207C (DD1,080,132)
label_2081:     BRK                            ; 2081 1 080 132 FF
                                               ; 2082 from 2073 (DD1,080,132)
label_2082:     VCAL    4                      ; 2082 1 080 132 14
                MOV     USP, #00220h           ; 2083 1 080 220 A1982002
                MOV     er0, (00220h-00220h)[USP] ; 2087 1 080 220 B30048
                CLR     A                      ; 208A 1 080 220 F9
                LB      A, #040h               ; 208B 0 080 220 7740
                MUL                            ; 208D 0 080 220 9035
                MOV     X1, A                  ; 208F 0 080 220 50
                MOV     DP, #00020h            ; 2090 0 080 220 622000
                MOVB    r0, (00222h-00220h)[USP] ; 2093 0 080 220 C30248
                                               ; 2096 from 209F (DD0,080,220)
                ;checksum
label_2096:     LC      A, [X1]                ; 2096 0 080 220 90A8
                ADDB    A, ACCH                ; 2098 0 080 220 C50782
                ADDB    r0, A                  ; 209B 0 080 220 2081
                INC     X1                     ; 209D 0 080 220 70
                INC     X1                     ; 209E 0 080 220 70
                JRNZ    DP, label_2096         ; 209F 0 080 220 30F5
                LB      A, r0                  ; 20A1 0 080 220 78
                STB     A, (00222h-00220h)[USP] ; 20A2 0 080 220 D302
                INC     (00220h-00220h)[USP]   ; 20A4 0 080 220 B30016
                CMP     (00220h-00220h)[USP], #00200h ; 20A7 0 080 220 B300C00002
                JNE     label_20c4             ; 20AC 0 080 220 CE16
                CLR     (00220h-00220h)[USP]   ; 20AE 0 080 220 B30015
                LB      A, r0                  ; 20B1 0 080 220 78
                SJ		label_20c4     ;change to JEQ to enable checksum        ; 20B2 0 080 220 C910
                CLRB    (00222h-00220h)[USP]   ; 20B4 0 080 220 C30215
                MOVB    0f0h, #048h            ; 20B7 0 080 220 C5F09848
                DECB    0eah                   ; 20BB 0 080 220 C5EA17
                JNE     label_20c4             ; 20BE 0 080 220 CE04
                SB      0fdh.1                 ; 20C0 0 080 220 C5FD19
                BRK                            ; 20C3 0 080 220 FF
                                               ; 20C4 from 20AC (DD0,080,220)
                                               ; 20C4 from 20B2 (DD0,080,220)
                                               ; 20C4 from 20BE (DD0,080,220)
label_20c4:     VCAL    4                      ; 20C4 0 080 220 14


;**********************************************************************
;RAM test
                CLR     A                      ; 20C5 1 080 220 F9
                LB      A, 0efh                ; 20C6 0 080 220 F5EF
                MOV     X1, A                  ; 20C8 0 080 220 50
                SLL     X1                     ; 20C9 0 080 220 90D7
                L       A, #05555h             ; 20CB 1 080 220 675555
                CAL     label_30ba             ; 20CE 1 080 220 32BA30
                JNE     label_20e3             ; 20D1 1 080 220 CE10
                SLL     A                      ; 20D3 1 080 220 53
                CAL     label_30ba             ; 20D4 1 080 220 32BA30
                JNE     label_20e3             ; 20D7 1 080 220 CE0A
                LB      A, 0efh                ; 20D9 0 080 220 F5EF
                JNE     label_20df             ; 20DB 0 080 220 CE02
                LB      A, #0f4h               ; 20DD 0 080 220 77F4
                                               ; 20DF from 20DB (DD0,080,220)
label_20df:     SUBB    A, #001h               ; 20DF 0 080 220 A601
                STB     A, 0efh                ; 20E1 0 080 220 D5EF
                                               ; 20E3 from 20D1 (DD1,080,220)
                ;to here
                ;*****************
											   ; 20E3 from 20D7 (DD1,080,220)
;*******************************************

label_20e3:     AND     IE, #00080h            ; 20E3 0 080 220 B51AD08000
                RB      PSWH.0                 ; 20E8 0 080 220 A208
                JBS     off(0130h).3, label_2137 ; code 4 (CKP)
                JBS     off(0121h).2, label_20fb ;
                RB      IRQH.7                 ; INT1 interrupt
                JEQ     label_20fb             ; 20F3 0 080 220 C906
                SB      off(0118h).0             ; 118h.0
                SB      off(012eh).0            ; CKP sensor error

;*******************************************
                                               ; 20FB from 20ED (DD0,080,220)
                                               ; 20FB from 20F3 (DD0,080,220)
label_20fb:     SB      PSWH.0                 ;
                CMPB    off(001b4h), #029h     ; no code is at #2dh
                RB      PSWH.0                 ;
                JLT     label_2137             ; if ecu sees the CKP cel bit for >6 iterations jump
                							   ; to set 121h.2

                JBR     off(0121h).2, label_2150 ; 2105 0 080 220 DA2148
                L       A, #022fbh             ; 22fbh = 0010 0010 1111 1100
                ST      A, IE                  ; 210B 1 080 220 D51A
                ST      A, 0cch                ; 210D 1 080 220 D5CC
                MOV     0ceh, #00090h          ; 210F 1 080 220 B5CE989000
                RB      off(0121h).2            ; 2114 1 080 220 C4210A
                MOVB    TCON1, #08eh           ; 2117 1 080 220 C541988E
                MOV     TM1, #00001h           ; 211B 1 080 220 B534980100
                MOVB    TCON2, #08fh           ; T2Con = 10001111
                MOV     TM2, #00002h           ; TM2 = 00000010
                SC                             ; 2129 1 080 220 85
                MB      TCON1.4, C             ; Start Timer1
                L       A, ACC                 ; 212D 1 080 220 E506
                MB      TCON2.4, C             ; 212F 1 080 220 C5423C
                CAL     label_30e2             ; 2132 1 080 220 32E230
                SJ      label_2150             ; 2135 1 080 220 CB19
                                               ; 2137 from 20EA (DD0,080,220)
                                               ; 2137 from 2103 (DD0,080,220)
label_2137:     JBS     off(0121h).2, label_2150 ; 2137 0 080 220 EA2116
                L       A, #0a25bh             ; 213A 1 080 220 675BA2
                ST      A, IE                  ; 213D 1 080 220 D51A
                ST      A, 0cch                ; 213F 1 080 220 D5CC
                MOV     0ceh, #00010h          ; 2141 1 080 220 B5CE981000
                SB      off(0121h).2            ; 2146 1 080 220 C4211A
                MOVB    TCON1, #0beh           ; 2149 1 080 220 C54198BE
                RB      TCON2.2                ; Timer2 outputbit = 0
                                               ; 2150 from 2105 (DD0,080,220)
                                               ; 2150 from 2135 (DD1,080,220)
                                               ; 2150 from 2137 (DD0,080,220)
label_2150:     SB      PSWH.0                 ; 2150 1 080 220 A218
                L       A, 0cch                ; 2152 1 080 220 E5CC
                ST      A, IE                  ; 2154 1 080 220 D51A

;***************************************************************************
;timer test for TM0,1,2,3
;resume initialization

                                               ; 2156 from 1902 (DD0,080,213)
label_2156:     AND     IE, #00080h            ; 2156 0 080 213 B51AD08000
                RB      PSWH.0                 ; 215B 0 080 213 A208
                MOV     er0, TM0               ; TM0 = ero
                MOV     er1, TM1               ; TM1 = er1
                MOV     er2, TM2               ; TM2 = er2
                MOV     er3, TM3               ; TM3 = er3
                SB      PSWH.0                 ; 2169 0 080 213 A218
                NOP                            ; 216B 0 080 213 00
                RB      PSWH.0                 ; 216C 0 080 213 A208
                MOV     X1, TM0                ; 216E 0 080 213 B53078
                MOV     X2, TM1                ; 2171 0 080 213 B53479
                MOV     DP, TM2                ; 2174 0 080 213 B5387A
                MOV     USP, TM3               ; 2177 0 080 213 B53C7B
                MB      C, TCON0.4             ; Start Timer1
                SB      PSWH.0                 ; 217D 0 080 213 A218
                L       A, 0cch                ; 217F 1 080 213 E5CC
                ST      A, IE                  ; 2181 1 080 213 D51A
                MB      PSWL.4, C              ; 2183 1 080 213 A33C
                L       A, X1                  ; 2185 1 080 213 40
                SUB     A, er0                 ; 2186 1 080 213 28
                ST      A, er0                 ; 2187 1 080 213 88
                JNE     label_218e             ; 2188 1 080 213 CE04
                MB      C, PSWL.4              ; 218A 1 080 213 A32C
                JLT     label_21ea             ; 218C 1 080 213 CA5C
                                               ; 218E from 2188 (DD1,080,213)
label_218e:     CMP     A, #00012h             ; 218E 1 080 213 C61200
                JGE     label_21ea             ; 2191 1 080 213 CD57
                L       A, X2                  ; 2193 1 080 213 41
                SUB     A, er1                 ; 2194 1 080 213 29
                JBS     off(P0IO).2, label_219a ; 2195 1 080 213 EA2102
                JEQ     label_21ea             ; 2198 1 080 213 C950
                                               ; 219A from 2195 (DD1,080,213)
label_219a:     CMP     A, #00012h             ; 219A 1 080 213 C61200
                JGE     label_21ea             ; 219D 1 080 213 CD4B
                L       A, DP                  ; 219F 1 080 213 42
                SUB     A, er2                 ; 21A0 1 080 213 2A
                ST      A, er2                 ; 21A1 1 080 213 8A
                JEQ     label_21ea             ; 21A2 1 080 213 C946
                CMP     A, #00012h             ; 21A4 1 080 213 C61200
                JGE     label_21ea             ; 21A7 1 080 213 CD41
                JBS     off(P0IO).2, label_21bd ; 21A9 1 080 213 EA2111
                L       A, DP                  ; 21AC 1 080 213 42
                SUB     A, X2                  ; 21AD 1 080 213 91A2
                MB      C, ACCH.7              ; 21AF 1 080 213 C5072F
                JGE     label_21b8             ; 21B2 1 080 213 CD04
                MOV     X1, A                  ; 21B4 1 080 213 50
                CLR     A                      ; 21B5 1 080 213 F9
                SUB     A, X1                  ; 21B6 1 080 213 90A2
                                               ; 21B8 from 21B2 (DD1,080,213)
label_21b8:     CMP     A, #00002h             ; 21B8 1 080 213 C60200
                JGE     label_21ea             ; 21BB 1 080 213 CD2D
                                               ; 21BD from 21A9 (DD1,080,213)
label_21bd:     MB      C, PSWL.4              ; 21BD 1 080 213 A32C
                JGE     label_21cd             ; 21BF 1 080 213 CD0C
                L       A, er2                 ; 21C1 1 080 213 36
                SUB     A, er0                 ; 21C2 1 080 213 28
                JGE     label_21c8             ; 21C3 1 080 213 CD03
                ST      A, er0                 ; 21C5 1 080 213 88
                CLR     A                      ; 21C6 1 080 213 F9
                SUB     A, er0                 ; 21C7 1 080 213 28
                                               ; 21C8 from 21C3 (DD1,080,213)
label_21c8:     CMP     A, #00002h             ; 21C8 1 080 213 C60200
                JGE     label_21ea             ; 21CB 1 080 213 CD1D
                                               ; 21CD from 21BF (DD1,080,213)
label_21cd:     LB      A, TCON0               ; 21CD 0 080 213 F540
                ANDB    A, #0e3h               ; 21CF 0 080 213 D6E3
                CMPB    A, #080h               ; 21D1 0 080 213 C680
                JNE     label_21ea             ; 21D3 0 080 213 CE15
                LB      A, TCON1               ; 21D5 0 080 213 F541
                ANDB    A, #0e3h               ; 21D7 0 080 213 D6E3
                CMPB    A, #082h               ; 21D9 0 080 213 C682
                JBR     off(P0IO).2, label_21e0 ; 21DB 0 080 213 DA2102
                CMPB    A, #0a2h               ; 21DE 0 080 213 C6A2
                                               ; 21E0 from 21DB (DD0,080,213)
label_21e0:     JNE     label_21ea             ; 21E0 0 080 213 CE08
                LB      A, TCON2               ; 21E2 0 080 213 F542
                ANDB    A, #0e3h               ; 21E4 0 080 213 D6E3
                CMPB    A, #083h               ; 21E6 0 080 213 C683
                JEQ     label_21f0             ; 21E8 0 080 213 C906
                                               ; 21EA from 218C (DD1,080,213)
                                               ; 21EA from 2191 (DD1,080,213)
                                               ; 21EA from 2198 (DD1,080,213)
                                               ; 21EA from 219D (DD1,080,213)
                                               ; 21EA from 21A2 (DD1,080,213)
                                               ; 21EA from 21A7 (DD1,080,213)
                                               ; 21EA from 21BB (DD1,080,213)
                                               ; 21EA from 21CB (DD1,080,213)
                                               ; 21EA from 21D3 (DD0,080,213)
                                               ; 21EA from 21E0 (DD0,080,213)
label_21ea:     MOVB    0f0h, #04bh            ; 21EA 0 080 213 C5F0984B
                SJ      label_2204             ; 21EE 0 080 213 CB14
                                               ; 21F0 from 21E8 (DD0,080,213)
label_21f0:     LB      A, PWCON0              ; 21F0 0 080 213 F578
                ANDB    A, #07bh               ; 21F2 0 080 213 D67B
                CMPB    A, #03ah               ; 21F4 0 080 213 C63A
                JNE     label_2200             ; 21F6 0 080 213 CE08
                LB      A, PWCON1              ; 21F8 0 080 213 F57A
                ANDB    A, #07bh               ; 21FA 0 080 213 D67B
                CMPB    A, #05ah               ; 21FC 0 080 213 C65A
                JEQ     label_220a             ; 21FE 0 080 213 C90A
                                               ; 2200 from 21F6 (DD0,080,213)
label_2200:     MOVB    0f0h, #04ch            ; 2200 0 080 213 C5F0984C
                                               ; 2204 from 21EE (DD0,080,213)
label_2204:     DECB    0ebh                   ; 2204 0 080 213 C5EB17
                JNE     label_220a             ; 2207 0 080 213 CE01
                BRK                            ; 2209 0 080 213 FF
                                               ; 220A from 21FE (DD0,080,213)
                                               ; 220A from 2207 (DD0,080,213)
label_220a:     VCAL    4                      ; 220A 0 080 213 14

;***********************************************************************
;begin of cel code settage...

;mechanical map code

                JBS     off(TM0).2, label_223a ; if map code
                JBS     off(TM0).4, label_223a ; if map code (mech)
                MB      C, 0fdh.6              ; 2211 0 080 213 C5FD2E
                JLT     label_223a             ; 2214 0 080 213 CA24
                CMPB    0a6h, #002h            ; 2216 0 080 213 C5A6C002
                JGE     label_2220             ; 221A 0 080 213 CD04
                MOVB    off(001e2h), #064h     ; just a counter
                                               ; 2220 from 221A (DD0,080,213)
label_2220:     JBR     off(0011fh).1, label_223a ; 11f.1

                LB      A, 0b6h                ; 2223 0 080 213 F5B6
                SUBB    A, 0b1h                ; 2225 0 080 213 C5B1A2
                JGE     label_222d             ; 2228 0 080 213 CD03
                STB     A, r0                  ; 222A 0 080 213 88
                CLRB    A                      ; 222B 0 080 213 FA
                SUBB    A, r0                  ; 222C 0 080 213 28
                                               ; 222D from 2228 (DD0,080,213)
label_222d:     CMPB    A, #002h               ; 222D 0 080 213 C602
                JLT     label_2236             ; 222F 0 080 213 CA05
                SB      0fdh.6                 ; 2231 0 080 213 C5FD1E
                SJ      label_223b             ; 2234 0 080 213 CB05
                                               ; 2236 from 222F (DD0,080,213)
label_2236:     LB      A, off(001e2h)         ; 1e2h
                JEQ     label_223b             ; 2238 0 080 213 C901
                                               ; 223A from 220B (DD0,080,213)
                                               ; 223A from 220E (DD0,080,213)
                                               ; 223A from 2214 (DD0,080,213)
                                               ; 223A from 2220 (DD0,080,213)
label_223a:     RC                             ; 223A 0 080 213 95
                                               ; 223B from 2234 (DD0,080,213)
                                               ; 223B from 2238 (DD0,080,213)
label_223b:     MB      off(P4).3, C           ; mechanical map sensor code


;********************************************
;118h.6
                CMPB    09ah, #054h            ; Compare battery with
                MB      off(00118h).6, C          ; 118.6

;********************************************
;vss
                CMPB    0a6h, #0b0h            ; 2245 0 080 213 C5A6C0B0
                JGE     label_225b             ; 2249 0 080 213 CD10
                RC                             ; 224B 0 080 213 95
                JBS     off(0118h).6, label_225b ; if low battery
                JBS     off(0121h).3, label_225b ; if 121h.3
                JBS     off(0132h).0, label_225b ; if VSS code
                JBR     off(0011eh).0, label_225b ; if 11e.0 == 0 jump
                MB      C, 0feh.6              ; 2258 0 080 213 C5FE2E
                                               ; 225B from 2249 (DD0,080,213)
                                               ; 225B from 224C (DD0,080,213)
                                               ; 225B from 224F (DD0,080,213)
                                               ; 225B from 2252 (DD0,080,213)
                                               ; 225B from 2255 (DD0,080,213)

label_225b:     MB      off(P4IO).2, C         ; VSS code!!!!!!!!

;*********************************************
;TDC
                RC                             ; C=0
                JBS     off(0130h).7, label_2268 ; if TDC code jump
                JBR     off(0011eh).5, label_2268 ; if code got through rev count function OK
                MB      C, off(0118h).4          ; move 118h.4 (starter signal)

label_2268:     MB      off(012eh).1, C         ; TDC code

;*********************************************
; vtec solenoid

                MB      C, P4.6                ; ???? feedback maybe?


                JBS     off(0129h).6, label_227c ; if vtec primed jump
                MOVB    off(001d3h), #014h     ; 1d3h
                LB      A, off(001d4h)         ; 1d4h
                JGE     label_2284             ; 2277 0 080 213 CD0B
                                               ; 2279 from 2282 (DD0,080,213)
                                               ; 2279 from 2284 (DD0,080,213)
label_2279:     RC                             ; 2279 0 080 213 95
                SJ      label_2288             ; 227A 0 080 213 CB0C
                                               ; 227C from 226E (DD0,080,213)
label_227c:     MOVB    off(001d4h), #014h     ; 1d4h
                LB      A, off(001d3h)         ; 1d3h
                JGE     label_2279             ; 2282 0 080 213 CDF5
                                               ; 2284 from 2277 (DD0,080,213)
label_2284:     JBS     off(0132h).4, label_2279 ; if vtec solenoid code
                SC                             ; 2287 0 080 213 85
                                               ; 2288 from 227A (DD0,080,213)

label_2288:     MB      off(P4IO).6, C         ; vtec solenoid code!!!

;*********************************************
; pressure switch

                JNE     label_22a0             ; ?
                JBS     off(TMR0).4, label_22a0 ; vtec solenoid code
                JLT     label_22a0             ; if vtec solenoid code above
                JBS     off(TMR0).5, label_22a0 ; 132h.5 (Pressure switch code)
                MB      C, 0ffh.2              ; vtec solenoid feedback???
                JBR     off(P3IO).6, label_22a1 ; 129h.6
                JLT     label_22a0             ; 229B 0 080 213 CA03
                SC                             ; 229D 0 080 213 85
                SJ      label_22a1             ; 229E 0 080 213 CB01
                                               ; 22A0 from 228B (DD0,080,213)
                                               ; 22A0 from 228D (DD0,080,213)
                                               ; 22A0 from 2290 (DD0,080,213)
                                               ; 22A0 from 2292 (DD0,080,213)
                                               ; 22A0 from 229B (DD0,080,213)
label_22a0:     RC                             ; 22A0 0 080 213 95
                                               ; 22A1 from 2298 (DD0,080,213)
                                               ; 22A1 from 229E (DD0,080,213)
                ;euro pw0 is missing from here:
label_22a1:     MB      off(P4IO).7, C     ;mugen pr3 -> NOP NOP NOP
;*********************************************
; 156h/157h
                MOV     X1, #0373fh            ; 22A4 0 080 213 603F37
                MOV     X2, #000fah            ; 22A7 0 080 213 61FA00
                LB      A, 0a6h                ; 22AA 0 080 213 F5A6
                VCAL    1                      ; 22AC 0 080 213 11
                CMPB    0a3h, #015h            ;
                JGE     label_22b8             ; 22B1 0 080 213 CD05
                ; warning: had to flip DD
                SUB     A, X2                  ; 22B3 1 080 213 91A2
                JGE     label_22b8             ; 22B5 1 080 213 CD01
                CLR     A                      ; 22B7 1 080 213 F9
                                               ; 22B8 from 22B1 (DD0,080,213)
                                               ; 22B8 from 22B5 (DD1,080,213)
label_22b8:     ST      A, off(0156h)         ; 156h/157h

;*********************************************
; 139h - brake switch +80h


				;to here
                LB      A, #003h               ; 22BA 0 080 213 7703
                CMPCB   A, 036e6h              ; 0 in ROM
                MB      C, PSWH.6              ; 22C0 0 080 213 A22E
                CLRB    A                      ; 22C2 0 080 213 FA
                JGE     label_22c9             ; 22C3 0 080 213 CD04
                LB      A, 09eh                ; brake switch
                ADDB    A, #080h               ; 22C7 0 080 213 8680
                                               ; 22C9 from 22C3 (DD0,080,213)
label_22c9:     STB     A, off(0139h)           ; 139h


				VCAL    4                      ; 22CB 0 080 213 14

;*********************************************
; IAT code

                RC                             ; 22CC 0 080 213 95
                JBS     off(TM0H).1, label_22db ; if IAT CEL code jump
                LB      A, #0fch               ; 22D0 0 080 213 77FC
                CMPB    A, 099h                ; 22D2 0 080 213 C599C2
                JLT     label_22db             ; 22D5 0 080 213 CA04
                LB      A, 099h                ; 22D7 0 080 213 F599
                CMPB    A, #004h               ; 22D9 0 080 213 C604
                                               ; 22DB from 22CD (DD0,080,213)
                                               ; 22DB from 22D5 (DD0,080,213)
label_22db:     MB      off(P4).7, C           ; IAT cel code

;*********************************************
; 15ah - IAT fuel trim
                JLT     label_22ea             ; 22DE 0 080 213 CA0A
                JBS     off(0131h).1, label_22ea ; 131h.1 IAT code
                MOV     USP, #000a4h           ; 22E3 0 080 0A4 A198A400
                CAL     label_2ead             ; get the water temp and store in [USP]
                                               ; 22EA from 22DE (DD0,080,213)
                                               ; 22EA from 22E0 (DD0,080,213)

				;higher value -> colder IAT -> more fuel correction
                ;FFh,5Ah,E0h,44h,C0h,2Ah,A0h,0Fh,80h,09h,50h,00
label_22ea:     MOV     X1, #0372bh            ; load 372bh
                LB      A, 0a4h                ; IAT
                VCAL    0                      ;
                STB     A, off(0015ah)         ; 15ah

;*******************************
; 119h.3

                LB      A, #0b3h               ; 22F2 0 080 0A4 77B3
                JBS     off(0119h).3, label_22f9 ; if 119h.3 jump
                LB      A, #0b8h               ; 22F7 0 080 0A4 77B8
                                               ; 22F9 from 22F4 (DD0,080,0A4)
label_22f9:     CMPB    A, 0b4h                ; 22F9 0 080 0A4 C5B4C2
                MB      off(0119h).3, C         ; 119h.3

;*******************************
; 119h.5
                RC                             ; 22FF 0 080 0A4 95
                LB      A, off(013ah)           ; load 13ah (ect ignition trim)
                JNE     label_230d             ; 2302 0 080 0A4 CE09
                CMPB    0a4h, #027h            ; 2304 0 080 0A4 C5A4C027
                JGE     label_230d             ; 2308 0 080 0A4 CD03
                MB      C, off(0119h).3         ; 119h.3
                                               ; 230D from 2302 (DD0,080,0A4)
                                               ; 230D from 2308 (DD0,080,0A4)
label_230d:     MB      off(0119h).5, C         ; 119h.5

;*******************************
; using pin B18
                L       A, IE                  ; 2310 1 080 0A4 E51A
                JEQ     label_231a             ; 2312 1 080 0A4 C906
                CMPB    0a6h, #008h            ; 2314 1 080 0A4 C5A6C008
                JLT     label_2336             ; 2318 1 080 0A4 CA1C
                                               ; 231A from 2312 (DD1,080,0A4)
label_231a:     LB      A, 09fh                ; Pin B18
                CMPB    A, #0ffh               ; 231C 0 080 0A4 C6FF
                JGT     label_232c             ; 231E 0 080 0A4 C80C
                CMPB    A, #0fch               ; 2320 0 080 0A4 C6FC
                JGE     label_2336             ; 2322 0 080 0A4 CD12
                CMPB    A, #088h               ; 2324 0 080 0A4 C688
                JGT     label_232c             ; 2326 0 080 0A4 C804
                CMPB    A, #078h               ; 2328 0 080 0A4 C678
                JGE     label_2336             ; 232A 0 080 0A4 CD0A

                ;
                                               ; 232C from 231E (DD0,080,0A4)
                                               ; 232C from 2326 (DD0,080,0A4)
label_232c:     MOVB    0f0h, #049h            ; 232C 0 080 0A4 C5F09849
                DECB    0ebh                   ; 2330 0 080 0A4 C5EB17
                JNE     label_2336             ; if life counter != 0 then continue
                BRK                            ; else reboot??

;*********************************************
;battery
                                               ; 2336 from 2318 (DD1,080,0A4)
                                               ; 2336 from 2322 (DD0,080,0A4)
                                               ; 2336 from 232A (DD0,080,0A4)
                                               ; 2336 from 2333 (DD0,080,0A4)
label_2336:     MOV     X1, #037e3h            ; 2336 1 080 0A4 60E337
                LB      A, 09ah                ; 2339 0 080 0A4 F59A
                VCAL    1                      ; 233B 0 080 0A4 11
                STB     A, off(014ch)           ; supposed to be off(14ch)

;*********************************************
;auto bit (118h.7)
                CAL     label_3274             ; 233E 0 080 0A4 327432
                ;from CAL: 3274h
                ;RB      off(0118h).7             ; should be 118h.7 (auto bit)
                ;MB      C, P3.4                ; 3277 0 080 213 C5282C
                ;MB      off(0129h).0, C         ; 129.0
                ;RT                             ; 327D 0 080 213 01

;*********************************************
;11ah.6
 				CLR     A                      ; 2341 1 080 0A4 F9
                LB      A, #0c0h               ; 2342 0 080 0A4 77C0
                JBR     off(011ah).6, label_2349  ; 11a.6
                LB      A, #0b9h               ; 2347 0 080 0A4 77B9
                                               ; 2349 from 2344 (DD0,080,0A4)
label_2349:     CMPB    A, 0b4h                ; 2349 0 080 0A4 C5B4C2
                CLRB    A                      ;
                MB      off(011ah).6, C           ; 11a.6

;*********************************************
;13ch
                JGE     label_2377             ; if low load jump and store 0

                ;high load only (over column 11 or 12)
                LB      A, 09ch                ; ground
                SUBB    A, #007h               ;
                JGE     label_2359             ; if no carry, jump
                CLRB    A                      ; 2358 0 080 0A4 FA
                                               ; 2359 from 2356 (DD0,080,0A4)
label_2359:     MOVB    r0, #051h              ; 2359 0 080 0A4 9851
                DIVB                           ; 235B 0 080 0A4 A236
                CMPB    0a6h, #0e0h            ; 235D 0 080 0A4 C5A6C0E0
                JGE     label_2373             ; 2361 0 080 0A4 CD10
                LB      A, r1                  ; 2363 0 080 0A4 79
                MOVB    r0, #01bh              ; 2364 0 080 0A4 981B
                DIVB                           ; 2366 0 080 0A4 A236
                CMPB    0a6h, #0bah            ; 2368 0 080 0A4 C5A6C0BA
                JGE     label_2373             ; 236C 0 080 0A4 CD05
                LB      A, r1                  ; 236E 0 080 0A4 79
                MOVB    r0, #009h              ; 236F 0 080 0A4 9809
                DIVB                           ; 2371 0 080 0A4 A236
                                               ; 2373 from 2361 (DD0,080,0A4)
                                               ; 2373 from 236C (DD0,080,0A4)
label_2373:     MOVB    r0, #0fah              ; 2373 0 080 0A4 98FA
                MULB                           ; 2375 0 080 0A4 A234
                                               ; 2377 from 2350 (DD0,080,0A4)
label_2377:     STB     A, off(013ch)            ; STB 13ch

;*********************************************
;158h - correction based on the voltage (0-5V)
                CLR     A                      ; 2379 1 080 0A4 F9
                LB      A, 09bh                ; load 0-5V action
                MOVB    r0, #030h              ;
                DIVB                           ; Al = A/30h
                CMPB    0a6h, #0c6h            ; if
                JGE     label_2393             ; rpm >= c6h jump
                SRLB    A                      ; else shift right
                LB      A, r1                  ; load remainder
                JGE     label_238d             ; if shift produced NO carry, jump
                LB      A, #02fh               ; else A = 2fh
                SUBB    A, r1                  ; 2fh - remainder
                                               ; 238D from 2388 (DD0,080,0A4)
label_238d:     MOVB    r0, #009h              ; 238D 0 080 0A4 9809
                DIVB                           ; 238F 0 080 0A4 A236
                ADDB    A, #006h               ; 2391 0 080 0A4 8606

                ;all this for an index...
                                               ; 2393 from 2384 (DD0,080,0A4)
label_2393:     LCB     A, 037d7h[ACC]         ; 2393 0 080 0A4 B506ABD737
                STB     A, off(0158h)         ; 158h

;*******************************************
; 152h - timing adjustment connector
                MOV     er1, #08000h           ; 239A 0 080 0A4 45980080
                LB      A, 09dh                ; timing connector
                CMPB    A, #003h               ; if <= 3
                JLE     label_23b9             ; jump and 152h = 0, 160/161h = 8000h

                ;else the connector must be jumped
                MOVB    r0, #080h              ; 23A4 0 080 0A4 9880
                ADDB    A, r0                  ; [9dh]+80h
                STB     A, r4                  ; store in r4
                LCB     A, 036e6h              ; load 36e6 (0)
                SRLB    A                      ; shift right
                LB      A, r4                  ; load r4 again
                JGE     label_23ba             ; if the code byte.0 was 0, jump
                LB      A, 09dh                ; else load connector again
                MULB                           ; A = [9dh]*80h
                MOV     er1, A                 ; move result into er1
                ADDB    r3, #040h              ; 23B6 0 080 0A4 238040
                                               ; 23B9 from 23A2 (DD0,080,0A4)
label_23b9:     CLRB    A                      ; 23B9 0 080 0A4 FA
                                               ; 23BA from 23AE (DD0,080,0A4)
label_23ba:     STB     A, off(00052h)         ; 152h
                MOV     off(ADCR0), er1        ; 160h/161h always 8000h if 36e6h == 0
                								; er1 has 8000h or [9dh]*80h (which is 0 to 7999h)

                VCAL    4                      ; 23BF 0 080 0A4 14

;********************************************
;ect
; good if 4<= [98h] <= fch

                RC                             ; 23C0 0 080 0A4 95
                JBS     off(TM0).5, label_23cb ; if ECT code
                LB      A, 098h                ; load water temp
                CMPB    A, #0fch               ; compare to fch
                JLE     label_23d4             ; jump if ok
                SC                             ; set ect cel bit
                                               ; 23CB from 23C1 (DD0,080,0A4)
                                               ; 23CB from 23D6 (DD0,080,0A4)
label_23cb:     MB      off(P4).1, C           ; if temp > #fch this is set (ect cel bit)



                MOVB    0a3h, #03ch            ; move this in water temp cause the sensor is bad
                SJ      label_2409             ;
                                               ; 23D4 from 23C8 (DD0,080,0A4)
label_23d4:     CMPB    A, #004h               ; compare to 4
                JLT     label_23cb             ; if its less than 4 then its bad
                RB      off(P4).1              ; ect gooood

;**********

                CMPB    09dh, #003h            ; idle adjust connector
                JLE     label_23fb             ; 23DF 0 080 0A4 CF1A
                SUBB    A, 0f7h                ; 23E1 0 080 0A4 C5F7A2
                JGE     label_23e9             ; 23E4 0 080 0A4 CD03
                STB     A, r0                  ; 23E6 0 080 0A4 88
                CLRB    A                      ; 23E7 0 080 0A4 FA
                SUBB    A, r0                  ; 23E8 0 080 0A4 28
                                               ; 23E9 from 23E4 (DD0,080,0A4)
label_23e9:     CMPB    A, #002h               ; 23E9 0 080 0A4 C602
                JGT     label_2405             ; 23EB 0 080 0A4 C818
                LB      A, off(001d1h)         ; 1d1h
                JNE     label_240d             ; 23EF 0 080 0A4 CE1C
                LB      A, 098h                ; 23F1 0 080 0A4 F598
                JBS     off(0001eh).5, label_23fb ; 11eh.5
                CMPB    A, 0f6h                ; 23F6 0 080 0A4 C5F6C2
                JGT     label_2409             ; 23F9 0 080 0A4 C80E
                                               ; 23FB from 23DF (DD0,080,0A4)
                                               ; 23FB from 23F3 (DD0,080,0A4)
label_23fb:     MOV     USP, #000a3h           ;
                CAL     label_2ead             ; calc a3h ram from 98h
                CAL     label_2ec3             ; calc f6h ram from a3h ram

                                               ; 2405 from 23EB (DD0,080,0A4)
label_2405:     LB      A, 098h                ;
                STB     A, 0f7h                ;
                                               ; 2409 from 23D2 (DD0,080,0A4)
                                               ; 2409 from 23F9 (DD0,080,0A4)
label_2409:     MOVB    off(001d1h), #005h     ; 1d1h
;*********************************************
;13fh - water temp related
                                               ; 240D from 23EF (DD0,080,0A4)
label_240d:     MOV     X1, #03907h            ; 240D 0 080 0A3 600739
                LB      A, 0a3h                ; 2410 0 080 0A3 F5A3
                VCAL    2                      ; 2412 0 080 0A3 12
                CMPB    0a3h, #015h            ; 2413 0 080 0A3 C5A3C015
                JGE     label_2421             ; 2417 0 080 0A3 CD08
                JBR     off(0011fh).5, label_241f ; 11f.5
                JBR     off(012ah).3, label_2421 ; 12a.3
                                               ; 241F from 2419 (DD0,080,0A3)
label_241f:     LB      A, #0f8h               ; 241F 0 080 0A3 77F8
                                               ; 2421 from 2417 (DD0,080,0A3)
                                               ; 2421 from 241C (DD0,080,0A3)
label_2421:     STB     A, off(013fh)          ; 13fh

;*********************************************
;176h -water temp related
                MOV     X1, #039e1h            ; 2423 0 080 0A3 60E139
                LB      A, 0a3h                ; 2426 0 080 0A3 F5A3
                VCAL    1                      ; 2428 0 080 0A3 11
                STB     A, off(0176h)          ; 176h
;*********************************************
;197h and 126h.5
                MOV     X1, #039bdh            ; 242B 0 080 0A3 60BD39
                LB      A, 0a3h                ; 242E 0 080 0A3 F5A3
				CAL     label_320c             ; 2430 0 080 0A3 320C32

                ;320c call
                ;VCAL    0                      ; 320C 0 080 0A3 10
				;STB     A, off(00197h)         ; 197h
				;LB      A, #080h               ; 320F 0 080 0A3 7780
				;CMPB    A, ADCR1H              ; 3211 0 080 0A3 C563C2
				;MB      off(0126h).5, C         ; 126h.5
                ;RT
;*********************************************
;172h - idle rev count
                ;idle values
                MOV     X1, #039c9h            ; 2433 0 080 0A3 60C939
                MOV     DP, #039dbh            ; 2436 0 080 0A3 62DB39

                LB      A, 0a3h                ; 2439 0 080 0A3 F5A3
                VCAL    1                      ; 243B 0 080 0A3 11
                CLR     er3                    ; 243C 0 080 0A3 4715

                ;
                JBR     off(0124h).7, label_247e  ; 124h.7, if a3h <#28h this will be 1
                ;so if the car is COLDER than ~160deg.F, we jump and use the vcal'd value

                LB      A, #004h               ; 2441 0 080 0A3 7704
                JBS     off(012ah).3, label_2458 ; 12ah.3 if set, AC is on
                CLRB    A                      ; 2446 0 080 0A3 FA
                JBS     off(0126h).5, label_2458 ; 126h.5 set if raw IAT < ~88deg.F
                NOP                            ; 244A 0 080 0A3 00
                NOP                            ; 244B 0 080 0A3 00
                NOP                            ; 244C 0 080 0A3 00
                NOP                            ; 244D 0 080 0A3 00
                NOP                            ; 244E 0 080 0A3 00
                NOP                            ; 244F 0 080 0A3 00
                NOP                            ; 2450 0 080 0A3 00
                NOP                            ; 2451 0 080 0A3 00
                LB      A, #002h               ; 2452 0 080 0A3 7702
                MOV     er3, #000c0h           ; 2454 0 080 0A3 4798C000

                ;so A = 0 when Air temp is colder than ~88degF (AC off)
                ;   A = 2 when Air is hot and AC is off.
                ;   A = 4 when AC is ON.
                                               ; 2458 from 2443 (DD0,080,0A3)
                                               ; 2458 from 2447 (DD0,080,0A3)
label_2458:     EXTND                          ; 2458 1 080 0A3 F8
                ADD     DP, A                  ; 2459 1 080 0A3 9281
                LC      A, [DP]                ; 245B 1 080 0A3 92A8
                ST      A, er0                 ; 245D 1 080 0A3 88
                CMP     A, off(0172h)          ; 172h/173h

                JEQ     label_247e             ; 2460 1 080 0A3 C91C
                MOV     er1, #00010h           ; 2462 1 080 0A3 45981000
                SB      off(0125h).1            ; 125h.1
                LB      A, off(001f6h)         ; 1f6h
                JNE     label_248a             ; 246B 0 080 0A3 CE1D
                L       A, off(0172h)          ; 172h/173h

                JGE     label_2477             ; 246F 1 080 0A3 CD06
                SUB     A, er1                 ; 2471 1 080 0A3 29
                CMP     A, er0                 ; 2472 1 080 0A3 48
                JGE     label_2481             ; 2473 1 080 0A3 CD0C
                SJ      label_247b             ; 2475 1 080 0A3 CB04
                                               ; 2477 from 246F (DD1,080,0A3)
label_2477:     ADD     A, er1                 ; 2477 1 080 0A3 09
                CMP     A, er0                 ; 2478 1 080 0A3 48
                JLT     label_2481             ; 2479 1 080 0A3 CA06
                                               ; 247B from 2475 (DD1,080,0A3)
label_247b:     L       A, er0                 ; 247B 1 080 0A3 34
                SJ      label_2481             ; 247C 1 080 0A3 CB03
                                               ; 247E from 243E (DD0,080,0A3)
                                               ; 247E from 2460 (DD1,080,0A3)
label_247e:     RB      off(0125h).1            ; 125h.1
                                               ; 2481 from 2473 (DD1,080,0A3)
                                               ; 2481 from 2479 (DD1,080,0A3)
                                               ; 2481 from 247C (DD1,080,0A3)
label_2481:     STB     A, off(0172h)          ; 172h idle rev count
                MOV     off(00184h), er3       ; 184h/185h
                MOVB    off(001f6h), #005h     ; 1f6h

;*********************************************
;190h/191h
                                               ; 248A from 246B (DD0,080,0A3)
label_248a:     L       A, off(0176h)          ; 176h/177h
                CAL     label_3000             ; 248C 1 080 0A3 320030

;label_3000:     ST      A, er3                 ; 3000 1 080 0A3 8B
;                MOV     DP, #0026ah            ; 3001 1 080 0A3 626A02
;                L       A, [DP]                ; 3004 1 080 0A3 E2
;                                               ; 3005 from 2FFE (DD1,080,0A3)
;label_3005:     VCAL    5                      ; 3005 1 080 0A3 15
;                JBS     off(0126h).1, label_300c ; 3006 1 080 0A3 E92603
;                SCAL    label_301b             ; 3009 1 080 0A3 3110
;                VCAL    5                      ; 300B 1 080 0A3 15
;                                               ; 300C from 3006 (DD1,080,0A3)
;                                               ; 300C from 1E71 (DD1,080,26A)
;label_300c:     L       A, off(00184h)         ; 300C 1 080 0A3 E484
;                VCAL    5                      ; 300E 1 080 0A3 15
;                MB      C, P0.1                ; 300F 1 080 0A3 C52029
;                JGE     label_3018             ; 3012 1 080 0A3 CD04
;                L       A, #00000h             ; 3014 1 080 0A3 670000
;                VCAL    5                      ; 3017 1 080 0A3 15
;                                               ; 3018 from 3012 (DD1,080,0A3)
;label_3018:     VCAL    7                      ; 3018 1 080 0A3 17
;                ST      A, er3                 ; 3019 1 080 0A3 8B
;                RT

                MOV     er0, #00600h           ; 248F 1 080 0A3 44980006
                JBR     off(0124h).2, label_249a  ; 124h.2
                MOV     er0, #00080h           ; 2496 1 080 0A3 44988000
                                               ; 249A from 2493 (DD1,080,0A3)
label_249a:     SUB     A, er0                 ; 249A 1 080 0A3 28
                JGE     label_24a0             ; 249B 1 080 0A3 CD03
                L       A, #00001h             ; 249D 1 080 0A3 670100
                                               ; 24A0 from 249B (DD1,080,0A3)
label_24a0:     ST      A, off(00190h)         ; 190h/191h
;*********************************************
;18eh/18fh
                MOV     er3, #00d00h           ; 24A2 1 080 0A3 4798000D
                CAL     label_2ffc             ; 24A6 1 080 0A3 32FC2F

;label_2ffc:     L       A, off(0176h)          ; 2FFC 1 080 0A3 E476
;                SJ      label_3005             ; 2FFE 1 080 0A3 CB05
;
;label_3005:     VCAL    5                      ; 3005 1 080 0A3 15
;                JBS     off(P2SF).1, label_300c ; 3006 1 080 0A3 E92603
;                SCAL    label_301b             ; 3009 1 080 0A3 3110
;                VCAL    5                      ; 300B 1 080 0A3 15
;                                               ; 300C from 3006 (DD1,080,0A3)
;                                               ; 300C from 1E71 (DD1,080,26A)
;label_300c:     L       A, off(00184h)         ; 300C 1 080 0A3 E484
;                VCAL    5                      ; 300E 1 080 0A3 15
;                MB      C, P0.1                ; 300F 1 080 0A3 C52029
;                JGE     label_3018             ; 3012 1 080 0A3 CD04
;                L       A, #00000h             ; 3014 1 080 0A3 670000
;                VCAL    5                      ; 3017 1 080 0A3 15
;                                               ; 3018 from 3012 (DD1,080,0A3)
;label_3018:     VCAL    7                      ; 3018 1 080 0A3 17
;                ST      A, er3                 ; 3019 1 080 0A3 8B
;                RT

                ST      A, off(0018eh)         ; 18eh/18fh

;*********************************************
                LB      A, 0a3h                ; 24AB 0 080 0A3 F5A3
                CMPB    A, #028h               ; 160F
                MB      off(0124h).7, C           ; 0124h.7
                CMPB    A, #02eh               ; 24B2 0 080 0A3 C62E
                MB      off(0124h).6, C           ; 124h.6
                CMPB    A, #0d0h               ; 24B7 0 080 0A3 C6D0
                MB      off(0124h).5, C           ; 124h.5
                CMPB    A, #0a1h               ; 24BC 0 080 0A3 C6A1
                MB      off(0124h).4, C           ; 124h.4
                VCAL    4                      ; 24C1 0 080 0A3 14

;*********************************************
                MOVB    r0, #002h              ; 24C2 0 080 0A3 9802
                MOVB    r1, #002h              ; 24C4 0 080 0A3 9902
                MOVB    r2, 0cbh               ; 24C6 0 080 0A3 C5CB4A
                MOV     X1, #03739h            ; 24C9 0 080 0A3 603937
                MOV     DP, #00124h            ; 24CC 0 080 0A3 622401
                RB      PSWL.4                 ; 24CF 0 080 0A3 A30C
                CAL     label_3112             ; 24D1 0 080 0A3 321231
                LB      A, off(TMR0)           ; 132h
                ANDB    A, #0f7h               ; f7h = 11110111: codes 17-19, 21-24
                ORB     A, off(TM0)            ; 130h or with all the other codes
                ORB     A, off(TM0H)           ; 131h ...
                ADDB    A, #0ffh               ; add to ffh
                MB      off(P0IO).7, C         ; 121h.7 = 1 if there are any codes (besides ELD)
                JBR     off(TMR0).3, label_24e5 ; if no ELD code, jump (132h.3)
                SC                             ; 24E4 0 080 0A3 85
                                               ; 24E5 from 24E1 (DD0,080,0A3)
label_24e5:     MB      off(P1IO).7, C         ; 123h.7
                LB      A, 0ffh                ; 24E8 0 080 0A3 F5FF
                ANDB    A, #003h               ; get ffh.0 and .1
                CMPB    0a3h, #042h            ; compare temp to #42h
                JGE     label_24fe             ; if temp>=42h jump
                CMPB    A, #001h               ; 24F2 0 080 0A3 C601
                RC                             ; dont set p4.5
                JNE     label_24fe             ; if this then the code has to do with ffh.1

                JBR     off(0011dh).5, label_24fe ; 24F7 0 080 0A3 DD1D04
                JBS     off(0132h).1, label_24fe ; if code 18???
                SC                             ; 24FD 0 080 0A3 85


                ;A has bits 0 and 1 from ffh ram: 000000XX
                ; 24FE from 24F0 because temp < 62* C
                ; 24FE from 24F5 if carry was 1 (with carry now = 0)
                ; 24FE from 24F7
                ; 24FE from 24FA
label_24fe:     MB      off(P4).5, C           ; ??? code

;*********************************************
                SRLB    A                      ; carry would be FFh.0
                JLT     label_250a             ; 2502 0 080 0A3 CA06
                JBS     off(TMR0).2, label_250b ; if code 19 (auto lockup)
                SC                             ; 2507 0 080 0A3 85
                SJ      label_250b             ; 2508 0 080 0A3 CB01
                                               ; 250A from 2502 (DD0,080,0A3)
label_250a:     RC                             ; 250A 0 080 0A3 95
                                               ; 250B from 2504 (DD0,080,0A3)
                                               ; 250B from 2508 (DD0,080,0A3)
label_250b:     MB      off(P4).6, C           ; auto lock up solenoid code!!

;*********************************************
; o2 stuff
				;call primary o2 sensor routine
                CAL     label_2f1f             ; 250E 0 080 0A3 321F2F

                ;do some calcs with the o2 sensor's vals
                CAL     label_2f46             ; 2511 0 080 0A3 32462F

                ;call 2nd o2 sensor routine
                CAL     label_2f39             ; 2514 0 080 0A3 32392F

                ;do some calcs with the o2 sensor's vals
                CAL     label_2f46             ; 2517 0 080 0A3 32462F

                MOV     er0, #0ae20h           ; 251A 0 080 0A3 449820AE
                MOV     er1, #05b60h           ; 251E 0 080 0A3 4598605B

                ;gets here from jump because it needs to do this for the 1st o2 as well...
                                               ; 2522 from 253B (DD1,080,0A3)
label_2522:     MB      C, P0.3                ;purge cutoff sol valve
                JGE     label_2532             ;
                JBS     off(0011dh).0, label_2532 ; 11dh.0
                L       A, 00162h[X2]          ; 252A 1 080 0A3 E16201
                CAL     label_2fd5             ; makes sure 162h and 164h are within the er0 and er1 vals set above
                JLT     label_2538             ; 2530 1 080 0A3 CA06
                                               ; 2532 from 2525 (DD0,080,0A3)
                                               ; 2532 from 2527 (DD0,080,0A3)
label_2532:     MOV     001bch[X2], #00bb8h    ; 1bch (1st o2), 1beh (2nd o2)
											   ; bb8h = 0000 1011 1011 1000
                                               ; 2538 from 2530 (DD1,080,0A3)
label_2538:     DEC     X2                     ; 2538 1 080 0A3 81
                DEC     X2                     ; 2539 1 080 0A3 81
                L       A, X2                  ; 253A 1 080 0A3 41
                JEQ     label_2522             ; should be 0 the first time around


;*********************************************

                AND     IE, #00080h            ; 253D 1 080 0A3 B51AD08000
                RB      PSWH.0                 ; 2542 1 080 0A3 A208
                RB      off(0011fh).0          ; 11fh.0
                JBS     off(0011eh).5, label_258f ; 11eh.5
                JNE     label_2559             ; 254A 1 080 0A3 CE0D
                JBS     off(0011eh).7, label_2559 ; 11eh.7
                JBR     off(0011eh).6, label_2596 ; 11eh.6
                L       A, TM1                 ; 2552 1 080 0A3 E534
                CMP     A, 0e0h                ; 2554 1 080 0A3 B5E0C2
                JLT     label_2596             ; 2557 1 080 0A3 CA3D
                                               ; 2559 from 254A (DD1,080,0A3)
                                               ; 2559 from 254C (DD1,080,0A3)
label_2559:     SB      off(0011eh).5          ; 11eh.5
                MB      C, 0fdh.7              ; 255C 1 080 0A3 C5FD2F
                JLT     label_2565             ; 255F 1 080 0A3 CA04
                MOVB    0e6h, #004h            ; 2561 1 080 0A3 C5E69804
                                               ; 2565 from 255F (DD1,080,0A3)
label_2565:     ANDB    0feh, #03fh            ; 2565 1 080 0A3 C5FED03F
                CAL     label_30e2             ; 2569 1 080 0A3 32E230
                MOV     USP, #00213h           ; 256C 1 080 213 A1981302
                L       A, #0ffffh             ; 2570 1 080 213 67FFFF
                PUSHU   A                      ; 2573 1 080 211 76
                PUSHU   A                      ; 2574 1 080 20F 76
                PUSHU   A                      ; 2575 1 080 20D 76
                ST      A, 0bah                ; 2576 1 080 20D D5BA
                CLR     A                      ; 2578 1 080 20D F9
                PUSHU   A                      ; 2579 1 080 20B 76
                PUSHU   A                      ; 257A 1 080 209 76
                PUSHU   A                      ; 257B 1 080 207 76
                PUSHU   A                      ; 257C 1 080 205 76
                CLRB    0a6h                   ; 257D 1 080 205 C5A615
                SB      P2.4                   ; 2580 1 080 205 C5241C
                RB      TCON2.3                ; 2583 1 080 205 C5420B
                RB      TCON2.2                ; 2586 1 080 205 C5420A
                RB      off(0120h).0           ; 120h.0
                RB      off(0120h).6           ; 120h.6
                                               ; 258F from 2547 (DD1,080,0A3)
label_258f:     L       A, TM2                 ; 258F 1 080 205 E538
                SUB     A, #00001h             ; 2591 1 080 205 A60100
                ST      A, TMR2                ; 2594 1 080 205 D53A
                                               ; 2596 from 254F (DD1,080,0A3)
                                               ; 2596 from 2557 (DD1,080,0A3)
label_2596:     SB      PSWH.0                 ; 2596 1 080 205 A218
                L       A, 0cch                ; 2598 1 080 205 E5CC
                ST      A, IE                  ; 259A 1 080 205 D51A
;*********************************************
;starter stuff...

                MB      C, 0ffh.7              ; starter signal
                MB      off(0118h).4, C          ; if 118h.4 = 1: starter ON
                JLT     label_25ad             ; if starter ON jump
                RB      0fdh.7                 ; else fdh.7 = 0
                MB      C, off(0011eh).5       ; 11eh.5 = 0 when the rev count function has no error
                JBR     off(0011fh).4, label_25b7 ; 11fh.4

label_25ad:     LB      A, #012h               ;
                JBS     off(0011fh).4, label_25b4 ; 11fh.4
                LB      A, #01dh               ;

                                               ; 25B4 from 25AF (DD0,080,205)
label_25b4:     CMPB    A, 0bbh                ; compare to RPM low byte

                ; 11fh.4 = 1 when starter is ON and RPM > #12h or #1dh
                ;		 = 1 when starter is OFF and 11fh.4 (before) == 1 and RPM > #12h
                ;        = 1 when starter is OFF and 11fh.4 (before) == 0 and error with rev count
                ;        = 0 when starter is OFF and 11fh.4 (before) == 0 and NO err with rev count
label_25b7:     MB      off(0011fh).4, C       ; 11fh.4
                JGE     label_25ec             ;
                JBR     off(0118h).4, label_25c2 ; 118.4 = starter signal: if off, jump
                SB      off(0011fh).1          ; 11fh.1

;*********************************************

                                               ; 25C2 from 25BC (DD0,080,205)
                ;does this have to do with cel codes?
                ; if so we show only:
                ; ect,???,auto lockup, iat
                ; tdc, eld
label_25c2:     AND     off(012ch), #00ae2h       ; 0ae2h = 0000 1010 1110 0010

                ANDB    off(012eh), #07fh       ; 12eh = 0111 1111
                ORB     P1, #038h              ; 38h = 00111000b
                LB      A, #096h               ; 25CF 0 080 205 7796
                STB     A, off(001c2h)         ; 1c2h
                STB     A, off(001c3h)         ; 1c3h
                CLRB    A                      ; 25D5 0 080 205 FA
                STB     A, 0f8h                ; 25D6 0 080 205 D5F8
                STB     A, 0f9h                ; 25D8 0 080 205 D5F9
                MOVB    off(001e3h), #01eh     ; 1e3h
                MOVB    off(001c4h), #01ch     ; 1c4h
                MOVB    off(001f5h), #00ah     ; 1f5h
                JBS     off(0011eh).5, label_25ec ; 11eh.5
                JBS     off(0130h).5, label_25f0 ; if ECT code
                                               ; 25EC from 25BA (DD0,080,205)
                                               ; 25EC from 25E6 (DD0,080,205)
label_25ec:     MOVB    off(001e4h), #063h     ; 1e4h

;********************************************
; 12bh.2
                                               ; 25F0 from 25E9 (DD0,080,205)
label_25f0:     JBS     off(0011fh).4, label_25fd ; jump if starting/somethings fucked with rev count
                MB      C, 0ffh.0              ; else grab ffh.0 (input)
                JGE     label_2606             ; 25F6 0 080 205 CD0E
                MB      C, P3.7                ; 25F8 0 080 205 C5282F
                JGE     label_2601             ; 25FB 0 080 205 CD04
                                               ; 25FD from 25F0 (DD0,080,205)
label_25fd:     MOVB    off(000edh), #00ah     ; 1edh
                                               ; 2601 from 25FB (DD0,080,205)
label_2601:     LB      A, off(000edh)         ; 1edh
                RC                             ; 2603 0 080 205 95
                JNE     label_2607             ; 2604 0 080 205 CE01
                                               ; 2606 from 25F6 (DD0,080,205)
label_2606:     SC                             ; mugen pr3-> RC
                                               ; 2607 from 2604 (DD0,080,205)
label_2607:     MB      off(0002bh).2, C       ; 12bh.2

;********************************************
;16fh - has something to do with choosing open/closed loop...
                VCAL    4                      ; 260A 0 080 205 14
                
                MOVB    r2, #0dah              ; 260B 0 080 205 9ADA
                JBR     off(0120h).4, label_2613  ; 120h.4
                JBR     off(0011dh).6, label_2653 ; 2610 0 080 205 DE1D40
                                               ; 2613 from 260D (DD0,080,205)
label_2613:     MOVB    r3, off(016fh)        ; 16fh
                JBS     off(012ah).3, label_2640 ;12ah.3
                LB      A, off(001e3h)         ; 2619 0 080 205 F4E3
                JNE     label_2640             ; 261B 0 080 205 CE23
                LB      A, r3                  ;
                MOVB    r0, #004h              ; 261E 0 080 205 9804
                JEQ     label_2624             ; 2620 0 080 205 C902
                MOVB    r0, #006h              ; 2622 0 080 205 9806
                                               ; 2624 from 2620 (DD0,080,205)
label_2624:     MOV     DP, #00278h            ; OLD tps
                LB      A, [DP]                ; 2627 0 080 205 F2
                ADDB    A, r0                  ; add 4 or 6
                CMPB    A, 0ach                ; new TPS
                JLT     label_2640             ; jump if TPS increasing
                
                ; else TPS decreasing
                MOVB    r2, #0fbh              ; 262E 0 080 205 9AFB
                MOVB    r6, off(001a0h)        ; 2630 0 080 205 C4A04E
                LB      A, off(001a1h)         ; 2633 0 080 205 F4A1
                CMPB    r3, #000h              ; compare last 16fh value to 0
                JEQ     label_263b             ; if 0 jump
                
                LB      A, r6                  ; 263A 0 080 205 7E
                                               ; 263B from 2638 (DD0,080,205)
label_263b:     CMPB    A, 0a6h                ; 263B 0 080 205 C5A6C2
                JLT     label_2653             ; 263E 0 080 205 CA13
                                               ; 2640 from 2616 (DD0,080,205)
                                               ; 2640 from 261B (DD0,080,205)
                                               ; 2640 from 262C (DD0,080,205)
label_2640:     MOVB    r0, #001h              ; 2640 0 080 205 9801
                LB      A, r3                  ; load old 16fh value
                JEQ     label_2647             ; jump if 0
                MOVB    r0, #00ah              ; 2645 0 080 205 980A
                                               ; 2647 from 2643 (DD0,080,205)
label_2647:     LB      A, off(001a2h)         ; 2647 0 080 205 F4A2
                ADDB    A, r0                  ; 2649 0 080 205 08
                CLRB    r2                     ; 264A 0 080 205 2215
                CMPB    A, 0b4h                ; 264C 0 080 205 C5B4C2
                JLT     label_2653             ; 264F 0 080 205 CA02
                MOVB    r2, #0f5h              ; 2651 0 080 205 9AF5
                                               ; 2653 from 2610 (DD0,080,205)
                                               ; 2653 from 263E (DD0,080,205)
                                               ; 2653 from 264F (DD0,080,205)
label_2653:     MOVB    off(016fh), r2        ; 16fh
; 16fh could be #dah, #fbh, 0, or #f5h
;**************************************************************************

                MOVB    r0, #005h              ; 2656 0 080 205 9805
                LB      A, 0e7h                ; 2658 0 080 205 F5E7
                JNE     label_2674             ; 265A 0 080 205 CE18
                MOVB    r0, #0ffh              ; 265C 0 080 205 98FF
                MOVB    r1, 0a6h               ; 265E 0 080 205 C5A649
                MOV     X1, #03944h            ; 2661 0 080 205 604439
                                               ; 2664 from 2672 (DD0,080,205)
label_2664:     INCB    r0                     ; 2664 0 080 205 A8
                INC     X1                     ; 2665 0 080 205 70
                LCB     A, [X1]                ; 2666 0 080 205 90AA
                CMPB    r0, off(00198h)        ; 2668 0 080 205 20C398
                JLT     label_2671             ; 266B 0 080 205 CA04
                SUBB    A, #004h               ; 266D 0 080 205 A604
                JLT     label_2674             ; 266F 0 080 205 CA03
                                               ; 2671 from 266B (DD0,080,205)
label_2671:     CMPB    A, r1                  ; 2671 0 080 205 49
                JGT     label_2664             ; 2672 0 080 205 C8F0
                                               ; 2674 from 265A (DD0,080,205)
                                               ; 2674 from 266F (DD0,080,205)
label_2674:     LB      A, r0                  ; 2674 0 080 205 78
                CMPB    0a3h, #02eh            ; 2675 0 080 205 C5A3C02E
                JGE     label_2681             ; 2679 0 080 205 CD06
                JBS     off(0123h).3, label_2681 ; 267B 0 080 205 EB2303
                JBS     off(0011fh).5, label_2687 ; 267E 0 080 205 ED1F06
                                               ; 2681 from 2679 (DD0,080,205)
                                               ; 2681 from 267B (DD0,080,205)
label_2681:     MOVB    r0, #005h              ; 2681 0 080 205 9805
                CMPB    A, r0                  ; 2683 0 080 205 48
                JLT     label_2687             ; 2684 0 080 205 CA01
                LB      A, r0                  ; 2686 0 080 205 78
                                               ; 2687 from 267E (DD0,080,205)
                                               ; 2687 from 2684 (DD0,080,205)
label_2687:     STB     A, off(00198h)         ; 2687 0 080 205 D498

;*********************************************


                MOV     DP, #0021ah            ; 2689 0 080 205 621A02
                AND     IE, #00080h            ; 268C 0 080 205 B51AD08000
                RB      PSWH.0                 ; 2691 0 080 205 A208
                MOV     er0, [DP]              ; 21ah
                INC     DP                     ; 21bh
                INC     DP                     ; 21ch
                MOVB    r2, [DP]               ; 2697 0 080 205 C24A
                MOVB    r3, 0e5h               ; 2699 0 080 205 C5E54B
                SB      PSWH.0                 ; 269C 0 080 205 A218
                L       A, 0cch                ; 269E 1 080 205 E5CC
                ST      A, IE                  ; 26A0 1 080 205 D51A
                LB      A, r3                  ; 26A2 0 080 205 7B
                CAL     label_2ca5             ; 26A3 0 080 205 32A52C

;label_2ca5:     MOVB    r6, #077h              ; 0111 0111
;                JEQ     label_2cb1             ; if e5h = 0 jump
;                                               ; 2CA9 from 2CAF (DD0,080,205)
;label_2ca9:     MB      C, r6.7                ; C = 0
;                ROLB    r6                     ; 1110 1110
;                SUBB    A, #001h               ; 1110 1101
;                JNE     label_2ca9             ; if not 0, loop
;                                               ; 2CB1 from 2CA7 (DD0,080,205)
;label_2cb1:     LB      A, r6                  ; 2CB1 0 080 205 7E
;                RT                             ; 2CB2 0 080 205 01

                CMPB    A, r0                  ; 26A6 0 080 205 48
                JNE     label_26be             ; 26A7 0 080 205 CE15
                LB      A, r2                  ; 26A9 0 080 205 7A
                EXTND                          ; 26AA 1 080 205 F8
                SLL     A                      ; 26AB 1 080 205 53
                LC      A, 03b55h[ACC]         ; 26AC 1 080 205 B506A9553B
                JEQ     label_26d1             ; 26B1 1 080 205 C91E
                CMP     A, er0                 ; 26B3 1 080 205 48
                JEQ     label_26d1             ; 26B4 1 080 205 C91B
                RB      PSWH.0                 ; 26B6 1 080 205 A208
                LB      A, #00fh               ; 26B8 0 080 205 770F
                STB     A, [DP]                ; 26BA 0 080 205 D2
                ORB     P2, A                  ; 26BB 0 080 205 C524E1
                                               ; 26BE from 26A7 (DD0,080,205)
label_26be:     RB      PSWH.0                 ; 26BE 0 080 205 A208
                LB      A, 0e5h                ; 26C0 0 080 205 F5E5
                CAL     label_2ca5             ; 26C2 0 080 205 32A52C
                XORB    A, #0ffh               ; 26C5 0 080 205 F6FF
                STB     A, r7                  ; 26C7 0 080 205 8F
                DEC     DP                     ; 26C8 0 080 205 82
                DEC     DP                     ; 26C9 0 080 205 82
                L       A, er3                 ; 26CA 1 080 205 37
                ST      A, [DP]                ; 26CB 1 080 205 D2
                CAL     label_30eb             ; 26CC 1 080 205 32EB30
                SB      PSWH.0                 ; 26CF 1 080 205 A218
                                               ; 26D1 from 26B1 (DD1,080,205)
                                               ; 26D1 from 26B4 (DD1,080,205)
label_26d1:     VCAL    4                      ; 26D1 1 080 205 14

;*********************************************

                RC                             ; 26D2 1 080 205 95
                LB      A, off(001e0h)         ;
                JNE     label_26de             ; 26D5 0 080 205 CE07
                JBS     off(0118h).4, label_26de ; if starter signal jump
                JBR     off(0011eh).5, label_26de ; if rev count function ok, jump
                SC                             ; 26DD 0 080 205 85
                                               ; 26DE from 26D5 (DD0,080,205)
                                               ; 26DE from 26D7 (DD0,080,205)
                                               ; 26DE from 26DA (DD0,080,205)
label_26de:     MB      P0.2, C                ; output: same as p3.4 on pr3?

;**********************************************

                JBS     off(0121h).7, label_270d ; 121h.7
                LB      A, 0f0h                ; 26E4 0 080 205 F5F0
                ;CLRB	A						;stock instruction
                ;NOP
                JNE     label_270d				;;look!!! Feels pw0 changed stock code to this

                ;(feels) if [f0h] != 0 then this code is skipped from here:
                CMPB    09fh, #0fch            ; B18 pin
                JGE     label_26f1             ; 26EC 0 080 205 CD03
                JBS     off(0118h).2, label_270d ; CEL or not??
                                               ; 26F1 from 26EC (DD0,080,205)
label_26f1:     JBS     off(0118h).4, label_26f7 ; if starter is ON
                JBS     off(0011eh).5, label_26f9 ; 26F4 0 080 205 ED1E02
                                               ; 26F7 from 26F1 (DD0,080,205)
label_26f7:     STB     A, off(001e0h)         ; 26F7 0 080 205 D4E0
                                               ; 26F9 from 26F4 (DD0,080,205)
label_26f9:     JBR     off(0012bh).2, label_2708 ;
                CMPB    09dh, #003h            ; timing adjust connector
                JGT     label_2708             ; 2700 0 080 205 C806
                JBR     off(0012bh).2, label_2708 ; 2702 0 080 205 DA2B03
                JBR     off(001c6h).0, label_270d ; 2705 0 080 205 D8C605
                                               ; 2708 from 26F9 (DD0,080,205)
                                               ; 2708 from 2700 (DD0,080,205)
                                               ; 2708 from 2702 (DD0,080,205)
label_2708:     RC                             ; 2708 0 080 205 95
                LB      A, off(001e0h)         ; 2709 0 080 205 F4E0
                JEQ     label_270e             ; 270B 0 080 205 C901
                ;to here

                                               ; 270D from 26E1 (DD0,080,205)
                                               ; 270D from 26E6 (DD0,080,205)
                                               ; 270D from 26EE (DD0,080,205)
                                               ; 270D from 2705 (DD0,080,205)
label_270d:     SC                             ; 270D 0 080 205 85
                                               ; 270E from 270B (DD0,080,205)
label_270e:     MB      P0.6, C                ; output: CEL output

;*********************************************
; 12ah.4
                LB      A, #0feh               ; 2711 0 080 205 77FE
                JBS     off(012ah).4, label_2718 ; 12ah.4
                LB      A, #0ffh               ; 2716 0 080 205 77FF
                                               ; 2718 from 2713 (DD0,080,205)
label_2718:     CMPB    A, 0a6h                ; 2718 0 080 205 C5A6C2
                MB      off(012ah).4, C         ; 12ah.4
                JLT     label_2792             ; 271E 0 080 205 CA72


                CMPB    0f8h, #032h            ; 2720 0 080 205 C5F8C032
                JLT     label_2792				;not enough oil press
;*********************************************
;12ah.0
;1 if colder than ~170deg. C, slower than ffh, and under ffh RPM
; pretty much this will be 1 unless the engine is really hot.
                JBS     off(0132h).0, label_2775 ; if VSS code
                CLRB    r0                     ; 2729 0 080 205 2015
                LB      A, #018h               ; 272B 0 080 205 7718
                MOVB    r1, #0ffh              ; 272D 0 080 205 99FF
                MOVB    r2, #0fah              ; 272F 0 080 205 9AFA
                JBS     off(012ah).0, label_273a ; 12ah.0
                LB      A, #015h               ; 2734 0 080 205 7715
                MOVB    r1, #0ffh              ; 2736 0 080 205 99FF
                MOVB    r2, #0ffh              ; 2738 0 080 205 9AFF
                                               ; 273A from 2731 (DD0,080,205)
label_273a:     CMPB    0a3h, A                ; 273A 0 080 205 C5A3C1
                JGE     label_2749             ; 273D 0 080 205 CD0A
                LB      A, r1                  ; 273F 0 080 205 79
                CMPB    A, 0cbh                ; 2740 0 080 205 C5CBC2
                JGE     label_2749             ; 2743 0 080 205 CD04
                LB      A, r2                  ; 2745 0 080 205 7A
                CMPB    A, 0a6h                ; 2746 0 080 205 C5A6C2
                                               ; 2749 from 273D (DD0,080,205)
                                               ; 2749 from 2743 (DD0,080,205)
label_2749:     MB      off(012ah).0, C         ; 12ah.0
                JLT     label_2792             ; 274C 0 080 205 CA44

;*********************************************
;12ah.2

                MOV     DP, #03acch            ; 274E 0 080 205 62CC3A
                JBR     off(012ah).2, label_2757 ; 2751 0 080 205 DA2A03
                INC     DP                     ; 2754 0 080 205 72
                INC     DP                     ; 2755 0 080 205 72
                INC     DP                     ; 2756 0 080 205 72
                                               ; 2757 from 2751 (DD0,080,205)
label_2757:     LCB     A, [DP]                ; e0h or 51h
                CMPB    A, 0ach                ; 2759 0 080 205 C5ACC2
                JLT     label_278b             ; 275C 0 080 205 CA2D
                INC     DP                     ; 275E 0 080 205 72
                LC      A, [DP]                ; 275F 0 080 205 92A8
                CMPB    A, 0cbh                ; 2761 0 080 205 C5CBC2
                JLT     label_2772             ; 2764 0 080 205 CA0C
                LB      A, ACCH                ; 2766 0 080 205 F507
                CMPB    A, 0a6h                ; 2768 0 080 205 C5A6C2
                JLT     label_2772             ; 276B 0 080 205 CA05
                MOVB    r0, #028h              ; 276D 0 080 205 9828
                RB      off(012ah).2            ; 276F 0 080 205 C42A0A
                                               ; 2772 from 2764 (DD0,080,205)
                                               ; 2772 from 276B (DD0,080,205)
label_2772:     MOVB    off(000f0h), r0        ; 2772 0 080 205 207CF0

;*******************************************************************
;ac routine
;1eeh and 1efh are buffers, they are decremented by
;another part of the code. So, if the switch is turned on and AC is off,
;it waits 4 iterations to turn on the AC output. Same
;goes for off.
                                               ; 2775 from 2726 (DD0,080,205)
                                               ; 2775 from 278D (DD0,080,205)
label_2775:     MB      C, 0ffh.6              ; AC input. 1 == switch on
                JGE     label_2795             ; if switch off then jump

                ;AC ON
                SB      off(012ah).1            ; ac is on bit
                LB      A, off(001eeh)         ; if 1eeh
                JNE     label_27a0             ; != 0 then turn off
                MOVB    off(001efh), #004h     ; else set 1efh
                                               ; 2785 from 279A (DD0,080,205)
label_2785:     SB      off(012ah).3           ; on
                RC                             ; carry reset
                SJ      label_27a4             ; turn AC on.

                                               ; 278B from 275C (DD0,080,205)
label_278b:     LB      A, off(001f0h)         ;
                JEQ     label_2775             ;
                SB      off(012ah).2           ; 278F 0 080 205 C42A1A
                                               ; 2792 from 271E (DD0,080,205)
                                               ; 2792 from 2724 (DD0,080,205)
                                               ; 2792 from 274C (DD0,080,205)
label_2792:     CLRB    off(001efh)

				;AC OFF
                                               ; 2795 from 2778 (DD0,080,205)
label_2795:     RB      off(012ah).1           ; ac is off
                LB      A, off(001efh)         ; 1efh check. set if last time the thing was on
                JNE     label_2785             ; so turn it on...
                MOVB    off(001eeh), #004h     ; 279C 0 080 205 C4EE9804
                                               ; 27A0 from 277F (DD0,080,205)
label_27a0:     RB      off(012ah).3            ;
                SC                             ; 27A3 0 080 205 85
                                               ; 27A4 from 2789 (DD0,080,205)
label_27a4:     MB      P0.7, C                ; turn on/off the AC output (AC clutch)
;******************
;14eh/14fh

                JBS     off(012ah).1, label_27b0 ; 12ah.1
                MOVB    off(001ebh), #014h     ; Clutch off (for next time?)
                SJ      label_27d1             ; 27AE 0 080 205 CB21
                                               ; 27B0 from 27A7 (DD0,080,205)
label_27b0:     JBS     off(0123h).3, label_27d1 ; 123h.3
                JBR     off(0125h).3, label_27d1 ; 125h.3
                LB      A, off(001ebh)         ; 27B6 0 080 205 F4EB
                JEQ     label_27d1             ; 27B8 0 080 205 C917
                L       A, #00026h             ; 27BA 1 080 205 672600
                CMPB    0a4h, #028h            ; 27BD 1 080 205 C5A4C028
                JGE     label_27c9             ; 27C1 1 080 205 CD06
                CMPB    0a3h, #01fh            ; 27C3 1 080 205 C5A3C01F
                JLT     label_27dc             ; 27C7 1 080 205 CA13
                                               ; 27C9 from 27C1 (DD1,080,205)
label_27c9:     LB      A, 0a3h                ; 27C9 0 080 205 F5A3
                MOV     X1, #037d1h            ; 27CB 0 080 205 60D137
                VCAL    3                      ; 27CE 0 080 205 13
                SJ      label_27dc             ; 27CF 0 080 205 CB0B
                                               ; 27D1 from 27AE (DD0,080,205)
                                               ; 27D1 from 27B0 (DD0,080,205)
                                               ; 27D1 from 27B3 (DD0,080,205)
                                               ; 27D1 from 27B8 (DD0,080,205)
label_27d1:     L       A, off(014eh)          ; 14e
                JEQ     label_27db             ; 27D3 1 080 205 C906
                SB      off(011bh).5             ; 11bh.5
                SB      off(011ch).5           ; 11ch.5
                                               ; 27DB from 27D3 (DD1,080,205)
label_27db:     CLR     A                      ; 27DB 1 080 205 F9
                                               ; 27DC from 27C7 (DD1,080,205)
                                               ; 27DC from 27CF (DD0,080,205)
label_27dc:     ST      A, off(014eh)          ; 14eh/14fh

;*********************************************************************
                JBS     off(0123h).7, label_27ff ; clr counter, and turn on purge
                CMP     off(016ch), #0012bh    ; 16ch/16dh
                JLT     label_27f8             ; if 16ch < #12bh, jump, check counter
                CMPB    0a4h, #028h            ; IAT check
                JGE     label_27ff             ; if colder jump
                CMPB    0a3h, #01fh            ; ECT
                JGE     label_27ff             ; if colder
                MOVB    off(001cdh), #01eh     ; else reset counter
                                               ; 27F8 from 27E6 (DD1,080,205)
label_27f8:     LB      A, off(001cdh)         ; counter
                JEQ     label_2802             ; if counter == 0, jump to turn on
                RC                             ; else
                SJ      label_2803             ; turn off.
                                               ; 27FF from 27DE (DD1,080,205)
                                               ; 27FF from 27EC (DD1,080,205)
                                               ; 27FF from 27F2 (DD1,080,205)
label_27ff:     CLRB    off(001cdh)            ; 27FF 1 080 205 C4CD15
                                               ; 2802 from 27FA (DD0,080,205)
label_2802:     SC                             ; 2802 1 080 205 85
                                               ; 2803 from 27FD (DD0,080,205)
label_2803:     MB      P0.3, C                ; output: purge control sol

;***************************************************************************
;279h
                LB      A, off(000e3h)         ; 2806 0 080 205 F4E3
                JNE     label_2810             ; 2808 0 080 205 CE06
                MOV     DP, #00279h            ; 280A 0 080 205 627902
                LB      A, 0a3h                ; 280D 0 080 205 F5A3
                STB     A, [DP]                ; 280F 0 080 205 D2

                                               ; 2810 from 2808 (DD0,080,205)
label_2810:     VCAL    4                      ; vcal_4

;***************************************************************************
; this is the code checkng routine
; it goes through and finds a code that needs
; to be put in mem then it calls the function
; that puts the codes in memory

                MOV     er2, off(012ch)           ; move (12dh|12ch) into er2
                LB      A, 0fdh                ; load [fdh]
                ANDB    A, #003h               ; get least sig 2 bits
                JEQ     label_281e             ; if they are 0 then jump to code setting
                CLR     A                      ; else clear A
                ST      A, off(012ch)             ; and put 0h into 12ch and 12dh
                ST      A, er2                 ; also put 0 into er2
                                               ; 281E from 2818 (DD0,080,205)

                ;error/cel code setting routine
label_281e:     MOVB    r7, #001h              ; counter for the vector index
                MOV     DP, #001e1h            ;



                ;loop checking index 1h = 11h
                ;code defs:
                ;03h (map)p4.0, 06h (ect)p4.1, 07h (tps)p4.2, 05h (map mechanical)p4.3,
                ;0Dh (baro)p4.4, 12h (??)p4.5, 13h (Auto lock up sol)p4.6, 0Ah (iat sensor)p4.7,
                ;0Eh (IACV)p4IO.0, 08h (tdc)P4IO.1, 11h (VSS)p4IO.2, 14h (ELD)p4IO.3, 17h (knock)p4IO.4,
                ;18h (??)p4IO.5, 15h (vtec sol)p4IO.6, 16h (press switch)p4IO.7
                ;what if only knock sensor code??
                ;then 132h.6 is set ([132h] = 64d) and 130h and 131h == 0
                                               ; 2823 from 283B (DD0,080,205)
label_2823:     SRL     er2                    ; shift (p5|p4) right 1
                JLT     label_283f             ; if carry exit the loop (found a code)
                LB      A, r7                  ; else load the counter into A
                SUBB    A, off(001a3h)         ; 1a3h
                JNE     label_282f             ; if A != [1a3h] skip next 2 lines
                STB     A, off(001a3h)         ; else store 0 into 1a3h
                STB     A, [DP]                ; and in 1e1h

                ; 282F from 282A if A != 0
label_282f:     LB      A, r7                  ; load the counter again
                SUBB    A, 0e8h                ; A -= [e8h]
                JNE     label_2837             ; if they are different jump
                STB     A, 0e8h                ; if [e8] == r7 then store 0 into e8
												;
                                               ; 2837 from 2833 (DD0,080,205)
                                               ; 2837 from 2844 (DD0,080,205)
label_2837:     INCB    r7                     ; r7++
                CMPB    r7, #011h              ;
                JNE     label_2823             ; if r7<11h continue looping
                ;end loop

                SJ      label_2856             ; we got through the looping ??without incident??

                ;from here:
                ;only executes when theres a carry from er2's right shifting.
                ;r7-1 is the bit on P4 that made the carry happen
                                               ; 283F from 2825 (DD1,080,205)
label_283f:     LB      A, off(001a3h)         ;
                JEQ     label_284c             ; if [1a3h] == 0 jump
                CMPB    A, r7                  ; else
                JNE     label_2837             ; if r7 != [a3h] get back in the loop
                LB      A, [DP]                ; else they are == so ??load timer??
                JNE     label_2856             ; if its not time check the next codes
                J       label_288f             ; if timer has expired, jump to code pre-setting
                                               ; 284C from 2841 (DD0,080,205)
label_284c:     CLR     A                      ; 284C 1 080 205 F9
                LB      A, r7                  ; 284D 0 080 205 7F
                STB     A, off(001a3h)         ; 1ah
                LCB     A, 03b2ch[ACC]         ;
                STB     A, [DP]                ; reset timer??
                ;to here...

				;done with lesser codes.
				; now do the biguns
                                               ; 2856 from 283D (DD0,080,205)
                                               ; 2856 from 2847 (DD0,080,205)
label_2856:     VCAL    4                      ; bleh
                MOVB    r7, #011h              ; counter
                CLRB    A                      ; 0
                XCHGB   A, off(012eh)           ; load codes
                STB     A, r0                  ; store in r0
                LB      A, 0fdh                ; 285E 0 080 205 F5FD
                ANDB    A, #003h               ; 2860 0 080 205 D603
                JEQ     label_2866             ; 2862 0 080 205 C902
                CLRB    r0                     ; 2864 0 080 205 2015
                                               ; 2866 from 2862 (DD0,080,205)
label_2866:     MOV     DP, #001b4h            ; 2866 0 080 205 62B401

				;loop checking index 11h - 18h
				;codes:
				;4h (ckp), 8h (tdc), 9h (cyp), fh (ignition output),
				;4h (ckp), 8h (tdc), 9h (cyp), 10h (fuel injector sys)
                                               ; 2869 from 288B (DD0,080,205)
label_2869:     SRLB    r0                     ; shift 12eh right
                JLT     label_2881             ; if there is a code jump
                CLR     A                      ; 286D 1 080 205 F9
                LB      A, r7                  ; 286E 0 080 205 7F
                CMPB    A, 0e8h                ; 286F 0 080 205 C5E8C2
                JNE     label_2886             ; 2872 0 080 205 CE12
                LCB     A, 03b66h[ACC]         ; 2874 0 080 205 B506AB663B
                SUBB    A, [DP]                ; a -= counter
                JNE     label_2886             ; 287B 0 080 205 CE09
                STB     A, 0e8h                ; 287D 0 080 205 D5E8
                SJ      label_2886             ; 287F 0 080 205 CB05
                                               ; 2881 from 286B (DD0,080,205)
                ;here only if r0 produced a carry
label_2881:     LB      A, [DP]                ; load counter
                JEQ     label_288f             ; if the counter == 0 then jump. each location only gets decremented at most once
                DECB    [DP]                   ; dec counter
                                               ; 2886 from 2872 (DD0,080,205)
                                               ; 2886 from 287B (DD0,080,205)
                                               ; 2886 from 287F (DD0,080,205)
label_2886:     INC     DP                     ; dp could have 1b4h to 1bbh
                INCB    r7                     ; 2887 0 080 205 AF
                CMPB    r7, #018h              ; 2888 0 080 205 27C018
                JNE     label_2869             ; 288B 0 080 205 CEDC
                ;end loop

                SJ      label_28d0             ; no codes
                                               ; 288F from 2849 (DD0,080,205)
                                               ; 288F from 2882 (DD0,080,205)
label_288f:     MOVB    [DP], #005h            ; reset the timer?
                LB      A, 0e8h                ; load our index
                JNE     label_289b             ; if e8h != 0 then jump to code setting
                LB      A, r7                  ; else
                STB     A, 0e8h                ; put r7 into e8h for next time?
                SJ      label_28d0             ; and dont set any codes
                                               ; 289B from 2894 (DD0,080,205)
label_289b:     SUBB    A, r7                  ; A = [e8h] - r7
                JNE     label_28d0             ; if they arent the same then dont set any codes
                RB      PSWH.0                 ;
                STB     A, 0e8h                ; why do they keep doing this?
                CLR     A                      ; clear AH
                LB      A, r7                  ; AL <- cel index
                LCB     A, 03b3ch[ACC]         ; its 0 at 3b55 or 3b56
                JEQ     label_28ce             ; if A was = 19h then it'll be 0
                STB     A, r6                  ; store the error code
                SB      0fdh.3                 ; this shows that we are in the middle of setting the codes

                ;*this function sets the error bits in 130h-132h
                ;and 27bh-27dh
                CAL     label_3040             ; set error bits


                RB      0fdh.3                 ; notify that we are done setting the codes
                SB      off(0118h).5             ; 118h.5
                JNE     label_28bd             ; 28B8 0 080 205 CE03
                NOP                            ; 28BA 0 080 205 00
                NOP                            ; 28BB 0 080 205 00
                NOP                            ; 28BC 0 080 205 00

;done setting the code                ;
;**********************************************

                                               ; 28BD from 28B8 (DD0,080,205)
label_28bd:     LB      A, r6                  ; load the code again
                CMPB    A, #00ah               ; compare it to 10dec (IAT)
                JNE     label_28c6             ; if its  != 10 jump
                MOVB    0a4h, #057h            ; else move false val into IAT ram

                                               ; 28C6 from 28C0 (DD0,080,205)
label_28c6:     CMPB    A, #014h               ; compare it to ELD code
                JNE     label_28ce             ; if != ELD code jump
                MOVB    0f1h, #000h            ; else load false value into eld RAM

                                               ; 28CE from 28A9 (DD0,080,205)
                                               ; 28CE from 28C8 (DD0,080,205)
label_28ce:     SB      PSWH.0                 ; 28CE 0 080 205 A218
                                               ; 28D0 from 2899 (DD0,080,205)
                                               ; 28D0 from 288D (DD0,080,205)
                                               ; 28D0 from 289C (DD0,080,205)
label_28d0:     VCAL    4                      ; 28D0 0 080 205 14
                MOV     DP, #0027eh            ; 28D1 0 080 205 627E02
                MOV     USP, #00133h           ; 28D4 0 080 133 A1983301
                CLR     er0                    ; 28D8 0 080 133 4415

                ;checking error codes
                                          ;pass: 1          | 2          | 3
label_28da:     DEC     DP                     ; 27dh       | 27ch       | 27bh
                DEC     USP                    ; 132h       | 131h       | 130h

                LB      A, r0                  ; A = 0      |
                ADDB    A, [DP]                ;
                STB     A, r0                  ; r0 =[27dh] | r0+=[27ch] | r0+=[27bh]

                LB      A, r1                  ; A = 0      |
                XORB    A, [DP]                ;
                STB     A, r1                  ; r1 = r1 xor [dp]

                LB      A, [DP]                ; A = [dp]
                STB     A, r2                  ; r2 = [dp]
                LB      A, (00132h-00132h)[USP] ; load error byte
                XORB    A, #0ffh               ; get all the bits that DONT have codes
                XORB    A, r2                  ; xor that with [dp]
                ORB     A, r2                  ; whats the point of this??
                ADDB    A, #001h               ; A += 1
                JNE     label_2909             ; if A != 0 jump. does this mean theres a code??
                CMP     DP, #0027bh            ;
                JNE     label_28da             ; Loop if DP != 27bh (we get 3 passes max)

                ;DP has 27bh

                LB      A, [DP]                ; 28F8 0 080 132 F2
                ANDB    A, #003h               ; 28F9 0 080 132 D603
                JNE     label_2909             ; 28FB 0 080 132 CE0C
                INC     DP                     ; 27ch
                LB      A, [DP]                ; 28FE 0 080 132 F2
                ANDB    A, #09ch               ; 28FF 0 080 132 D69C
                JNE     label_2909             ; 2901 0 080 132 CE06
                INC     DP                     ; 27dh
                INC     DP                     ; 27eh
                L       A, [DP]                ; 2905 1 080 132 E2
                CMP     A, er0                 ; 2906 1 080 132 48
                JEQ     label_290e             ; 2907 1 080 132 C905

                ;get here if there is a code...
                                               ; 2909 from 28F0 (DD0,080,132)
                                               ; 2909 from 28FB (DD0,080,132)
                                               ; 2909 from 2901 (DD0,080,132)
label_2909:     MOVB    0f0h, #043h            ; 2909 1 080 132 C5F09843
                BRK                            ; 290D 1 080 132 FF

                ;no code?
                                               ; 290E from 2907 (DD1,080,132)
label_290e:     L       A, IE                  ; 290E 1 080 132 E51A
                JNE     label_2963             ; 2910 1 080 132 CE51
                CAL     label_30a8             ; 2912 1 080 132 32A830

;label_30a8:     LB      A, #03ch               ; 30A8 0 080 213 773C
;                STB     A, WDT                 ; 30AA 0 080 213 D511
;                SWAPB                          ; 30AC 0 080 213 83
;                STB     A, WDT                 ; 30AD 0 080 213 D511
;                LB      A, 0fdh                ; 30AF 0 080 213 F5FD
;                ANDB    A, #003h               ; 30B1 0 080 213 D603
;                JNE     label_30b9             ; 30B3 0 080 213 CE04
;                XORB    P4, #001h              ; 30B5 0 080 213 C52CF001
;                                               ; 30B9 from 30B3 (DD0,080,213)
;label_30b9:     RT                             ; 30B9 0 080 213 01

                SC                             ; 2915 1 080 132 85
                LB      A, off(012ch)             ; get CEL codes
                ANDB    A, #082h               ; 82h = 1000 0010 (ECT and IAT codes)
                JNE     label_2941             ; if either code, jump

                MOV     er0, 098h              ; else get water temp (r0) and air temp (r1)
                CMPB    r1, #0c0h              ; compare air temp to #c0h
                JLT     label_2941             ; if [99h]<#c0h, jump
                CMPB    r0, #0c0h              ;
                JLT     label_2941             ; if [98h]<#c0h, jump
                MOV     DP, #00279h            ; move [279h]
                LB      A, [DP]                ; to A
                SUBB    A, r0                  ; A-= water temp
                MOVB    r2, #010h              ; r2 = 10h
                JGE     label_2937             ; if pos subtraction, jump
                STB     A, r2                  ;
                CLRB    A                      ;
                SUBB    A, r2                  ;
                MOVB    r2, #010h              ;
                                               ; 2937 from 2930 (DD0,080,132)
label_2937:     CMPB    r2, A                  ;
                JLT     label_2941             ;
                LB      A, r1                  ;
                SUBB    A, r0                  ;
                JLT     label_2941             ;
                CMPB    A, #004h               ;
                                               ; 2941 from 291A (DD0,080,132)
                                               ; 2941 from 2922 (DD0,080,132)
                                               ; 2941 from 2927 (DD0,080,132)
                                               ; 2941 from 2939 (DD0,080,132)
                                               ; 2941 from 293D (DD0,080,132)
                ;1 if |[279h]-[98h]| > 10h
                ;1 if water temp > air temp (in comp values. real values is opposite)
                ;1 if |[99h]-[98h]|<4

                ;this bit seems to be when the thing is warming up
label_2941:     MB      off(011ah).5, C           ; 2941 0 080 132 C41A3D

;*********************************************

                SB      STTMC.4                ; 2944 0 080 132 C54A1C
                SB      SRCON.7                ; 2947 0 080 132 C5541F
                SB      SRTMC.4                ; 294A 0 080 132 C54E1C
                MOVB    0ebh, #020h            ; 294D 0 080 132 C5EB9820
                MOV     0ceh, #00090h          ; 2951 0 080 132 B5CE989000
                L       A, #022fbh             ; 2956 1 080 132 67FB22
                ST      A, 0cch                ; 2959 1 080 132 D5CC
                CLRB    TRNSIT                 ; 295B 1 080 132 C54615
                CLR     IRQ                    ; 295E 1 080 132 B51815
                ST      A, IE                  ; 2961 1 080 132 D51A
                                               ; 2963 from 2910 (DD1,080,132)
label_2963:     RB      0feh.5                 ; 2963 1 080 132 C5FE0D
                JNE     label_296b             ; 2966 1 080 132 CE03
                J       label_2044             ; 2968 1 080 132 034420
                                               ; 296B from 2966 (DD1,080,132)
label_296b:     CMPB    0a6h, #086h            ; 296B 1 080 132 C5A6C086
                JGE     label_2999             ; 296F 1 080 132 CD28
                JBS     off(0118h).4, label_2999 ; 2971 1 080 132 EC1825
                CMPB    0a6h, #01bh            ; 2974 1 080 132 C5A6C01B
                JLT     label_2999             ; 2978 1 080 132 CA1F
                CMPB    0b4h, #030h            ; 297A 1 080 132 C5B4C030
                JLT     label_2999             ; 297E 1 080 132 CA19
                CMPB    0a3h, #034h            ; 2980 1 080 132 C5A3C034
                JGE     label_2999             ; 2984 1 080 132 CD13
                LB      A, #0ffh               ; 2986 0 080 132 77FF
                RB      TRNSIT.3               ; 2988 0 080 132 C5460B
                JNE     label_2993             ; 298B 0 080 132 CE06
                LB      A, off(001c0h)         ; 298D 0 080 132 F4C0
                JEQ     label_2994             ; 298F 0 080 132 C903
                SUBB    A, #001h               ; 2991 0 080 132 A601
                                               ; 2993 from 298B (DD0,080,132)
label_2993:     RC                             ; 2993 0 080 132 95
                                               ; 2994 from 298F (DD0,080,132)
label_2994:     MB      off(0118h).2, C          ; 2994 0 080 132 C4183A


                STB     A, off(001c0h)         ; 2997 0 080 132 D4C0
                                               ; 2999 from 296F (DD1,080,132)
                                               ; 2999 from 2971 (DD1,080,132)
                                               ; 2999 from 2978 (DD1,080,132)
                                               ; 2999 from 297E (DD1,080,132)
                                               ; 2999 from 2984 (DD1,080,132)

                ;this doesnt do anything.
label_2999:     MOV     DP, #0018ah            ; 2999 0 080 132 628A01
                MOV     X1, #039a5h            ; 299C 0 080 132 60A539
                LB      A, 0a5h                ; 299F 0 080 132 F5A5
                VCAL    1                      ; 29A1 0 080 132 11

;*******************
				;ELD related
                ;from here:
                LB      A, 0f1h                ; 29A2 0 080 132 F5F1
                STB     A, r0                  ; 29A4 0 080 132 88
                XCHGB   A, 0fah                ; 29A5 0 080 132 C5FA10
                SUBB    A, r0                  ; 29A8 0 080 132 28
                MOVB    r1, #028h              ; 29A9 0 080 132 9928
                JGE     label_29b2     ;if [FAh] >= [F1h] then jump        ; 29AB 0 080 132 CD05
                STB     A, r0                  ; 29AD 0 080 132 88
                CLRB    A                      ; 29AE 0 080 132 FA
                SUBB    A, r0                  ; 29AF 0 080 132 28
                MOVB    r1, #018h              ; 29B0 0 080 132 9918
                                               ; 29B2 from 29AB (DD0,080,132)
label_29b2:     CMPB    A, r1                  ; 29B2 0 080 132 49
                JLT     label_29b9             ; 29B3 0 080 132 CA04
                MOVB    0fbh, #002h            ; 29B5 0 080 132 C5FB9802
                                               ; 29B9 from 29B3 (DD0,080,132)
label_29b9:     LB      A, 0fbh                ; 29B9 0 080 132 F5FB
                NOP                            ; 29BB 0 080 132 00
                NOP                            ; 29BC 0 080 132 00
                DECB    0fbh                   ; 29BD 0 080 132 C5FB17
                ;to here, euro pw0 doesnt have

;********************

                MOV     er0, #00800h           ; 29C0 0 080 132 44980008
                MOV     X1, #00260h            ; 29C4 0 080 132 606002
                MOV     X2, #00240h            ; 29C7 0 080 132 614002
                SJ      label_29dd             ; 29CA 0 080 132 CB11
                DB  044h,098h,000h,030h,0DBh,032h,01Ch,044h ; 29CC
                DB  098h,000h,080h,060h,000h,002h,061h,000h ; 29D4
                DB  002h ; 29DC
                                               ; 29DD from 29CA (DD0,080,132)
label_29dd:     L       A, er3                 ; 29DD 1 080 132 37
                SUB     A, off(0008ah)         ; 29DE 1 080 132 A78A
                ST      A, er2                 ; 29E0 1 080 132 8A
                JGE     label_29e7             ; 29E1 1 080 132 CD04
                CLR     A                      ; 29E3 1 080 132 F9
                SUB     A, er2                 ; 29E4 1 080 132 2A
                MOV     X1, X2                 ; 29E5 1 080 132 9178
                                               ; 29E7 from 29E1 (DD1,080,132)
label_29e7:     CMP     A, X1                  ; 29E7 1 080 132 90C2
                L       A, er3                 ; 29E9 1 080 132 37
                JLT     label_29ef             ; 29EA 1 080 132 CA03
                J       label_3297             ; 29EC 1 080 132 039732
                                               ; 29EF from 29EA (DD1,080,132)
label_29ef:     CAL     label_2efd             ; 29EF 1 080 132 32FD2E
                CLR     er2                    ; 29F2 1 080 132 4615
                                               ; 29F4 from 32A2 (DD1,080,132)
label_29f4:     MOV     off(0018ch), er2       ; 29F4 1 080 132 467C8C

;*****************************************************************************
;IACV code checking...

                JBS     off(0131h).5, label_2a12 ; if IAT code
                LB      A, 09ah                ; voltage
                MOV     X1, #03b21h            ; 29FC 0 080 132 60213B
                VCAL    3                      ; 29FF 0 080 132 13
                CMPB    A, off(0170h)          ; 2A00 0 080 132 C770
                JLT     label_2a12             ; 2A02 0 080 132 CA0E
                LB      A, 09ah                ; voltage
                MOV     X1, #03b27h            ; 2A06 0 080 132 60273B
                VCAL    3                      ; 2A09 0 080 132 13
                CMPB    A, off(0170h)          ; 2A0A 0 080 132 C770
                JGE     label_2a12             ; 2A0C 0 080 132 CD04
                LB      A, off(001f5h)         ; 2A0E 0 080 132 F4F5
                JEQ     label_2a13             ; 2A10 0 080 132 C901
                                               ; 2A12 from 29F7 (DD1,080,132)
                                               ; 2A12 from 2A02 (DD0,080,132)
                                               ; 2A12 from 2A0C (DD0,080,132)
label_2a12:     RC                             ; 2A12 0 080 132 95
                                               ; 2A13 from 2A10 (DD0,080,132)

label_2a13:     MB      off(012dh).0, C         ; IACV code

                VCAL    4                      ; 2A16 0 080 132 14
                MOV     DP, #00278h            ; 2A17 0 080 132 627802
                LB      A, [DP]                ; 2A1A 0 080 132 F2
                CMPB    0f8h, #014h      ;wtf is this here for?
                JBS     off(0124h).2, label_2a3a  ; 2A1F 0 080 132 EA2418
                CMPB    0a6h, #086h            ; 2A22 0 080 132 C5A6C086
                JGE     label_2a3a             ; 2A26 0 080 132 CD12
                LB      A, 0ach                ; 2A28 0 080 132 F5AC
                CMPB    A, #026h               ; 2A2A 0 080 132 C626
                JGE     label_2a3a             ; 2A2C 0 080 132 CD0C
                STB     A, r1                  ; 2A2E 0 080 132 89
                MOVB    r0, off(0019bh)        ; 2A2F 0 080 132 C49B48
                SUBB    A, r0                  ; 2A32 0 080 132 28
                JLT     label_2a39             ; 2A33 0 080 132 CA04
                CMPB    A, #003h               ; 2A35 0 080 132 C603
                JLT     label_2a3f             ; 2A37 0 080 132 CA06
                                               ; 2A39 from 2A33 (DD0,080,132)
label_2a39:     LB      A, r1                  ; 2A39 0 080 132 79
                                               ; 2A3A from 2A1F (DD0,080,132)
                                               ; 2A3A from 2A26 (DD0,080,132)
                                               ; 2A3A from 2A2C (DD0,080,132)
label_2a3a:     STB     A, off(0019bh)         ; 2A3A 0 080 132 D49B
;*******
                STB     A, r0                  ; 2A3C 0 080 132 88
                SJ      label_2a52             ; 2A3D 0 080 132 CB13
                                               ; 2A3F from 2A37 (DD0,080,132)
label_2a3f:     LB      A, off(001c5h)         ; 2A3F 0 080 132 F4C5
                JNE     label_2a5e             ; 2A41 0 080 132 CE1B
                LB      A, off(0019ch)         ; 2A43 0 080 132 F49C
                ADDB    A, #004h               ; 2A45 0 080 132 8604
                CMPB    A, r0                  ; 2A47 0 080 132 48
                JLT     label_2a4b             ; 2A48 0 080 132 CA01
                LB      A, r0                  ; 2A4A 0 080 132 78
                                               ; 2A4B from 2A48 (DD0,080,132)
label_2a4b:     STB     A, [DP]                ; 2A4B 0 080 132 D2
                CMPB    A, off(0019ch)         ; 2A4C 0 080 132 C79C
                JGE     label_2a52             ; 2A4E 0 080 132 CD02
                STB     A, off(0019ch)         ; 2A50 0 080 132 D49C
;********
                                               ; 2A52 from 2A3D (DD0,080,132)
                                               ; 2A52 from 2A4E (DD0,080,132)
label_2a52:     LB      A, [DP]                ; 2A52 0 080 132 F2
                JEQ     label_2a5a             ; 2A53 0 080 132 C905
                CMPB    A, r0                  ; 2A55 0 080 132 48
                LB      A, #00fh               ; 2A56 0 080 132 770F
                JLT     label_2a5c             ; 2A58 0 080 132 CA02
                                               ; 2A5A from 2A53 (DD0,080,132)
label_2a5a:     LB      A, #002h               ; 2A5A 0 080 132 7702
                                               ; 2A5C from 2A58 (DD0,080,132)
label_2a5c:     STB     A, off(001c5h)         ; 2A5C 0 080 132 D4C5

;******************************************************************************



                                               ; 2A5E from 2A41 (DD0,080,132)
label_2a5e:     J       label_2044             ; 2A5E 0 080 132 034420



                                               ; 2A61 from 15EA (DD0,200,???)
                                               ; 2A61 from 1610 (DD0,200,???)
                                               ; 2A61 from 164D (DD0,200,???)
                                               ; 2A61 from 2A6B (DD0,200,???)
                                               ; 2A61 from 1668 (DD1,200,???)
label_2a61:     CMP     TM0, #0000dh           ; 2A61 0 200 ??? B530C00D00
                JGE     label_2a72             ; 2A66 0 200 ??? CD0A
                RB      IRQ.7                  ; 2A68 0 200 ??? C5180F
                JEQ     label_2a61             ; 2A6B 0 200 ??? C9F4
                SCAL    label_2a85             ; 2A6D 0 200 ??? 3116
                MOV     LRB, #00040h           ; 2A6F 0 200 ??? 574000
                                               ; 2A72 from 2A66 (DD0,200,???)
                                               ; 2A72 from 2A77 (DD0,200,???)
label_2a72:     CMP     TM0, #00018h           ; 2A72 0 200 ??? B530C01800
                JLT     label_2a72             ; 2A77 0 200 ??? CAF9
                RT                             ; 2A79 0 200 ??? 01
                                               ; 2A7A from 15F5 (DD1,200,???)
                                               ; 2A7A from 161B (DD1,200,???)
                                               ; 2A7A from 1658 (DD1,200,???)
label_2a7a:     RB      IRQ.7                  ; 2A7A 1 200 ??? C5180F
                JEQ     label_2a84             ; 2A7D 1 200 ??? C905
                SCAL    label_2a85             ; 2A7F 1 200 ??? 3104
                MOV     LRB, #00040h           ; 2A81 1 200 ??? 574000
                                               ; 2A84 from 2A7D (DD1,200,???)
label_2a84:     RT                             ; 2A84 1 200 ??? 01

;****************************************************************************
; 2A85 from 00D7 int_timer_1 continued
; crank position
; 1 signal every 45 deg.
;
; all 7ff segment crap should be 0
                                               ; 2A85 from 2A6D (DD0,200,???)
                                               ; 2A85 from 2A7F (DD1,200,???)
label_2a85:     CLR     LRB                    ;
                LB      A, 0e4h                ; load crank position?
                JEQ     label_2aa8             ; if 0 jump
                CMPB    A, #001h               ; else compare it to 1
                JNE     label_2ab5             ; if != 1 then its 2 or 3 and jump

;*******************
                ;e4h is 1 here
                LB      A, 0dfh                ;
                ADDB    A, #001h               ; 2A91 0 ??? ??? 8601
                CMPB    A, #003h               ; 2A93 0 ??? ??? C603
                JGE     label_2ad3             ; 2A95 0 ??? ??? CD3C

                SB      TCON2.2                ; ignitor?????

                L       A, 0dah                ; load ignition time?
                CMP     A, #0001eh             ; compare to #1eh
                JGE     label_2aa4             ;
                L       A, #0001eh             ;

                ; 0<= A <= #1eh
label_2aa4:     ADD     A, off(TMR1)        	; TMR1
                SJ      label_2afd             ; 2AA6 1 ??? ??? CB55

;*******************
                ; 2AA8 from 2A89 e4h = A = 0
label_2aa8:     MOV     off(0b0h), ADCR5    	; map voltage
                CMPB    A, off(0dfh)        	; dfh
                JNE     label_2abf             ; if [dfh] != 0 jump

                                               ; 2AB0 from 2AB9 (DD0,???,???)

label_2ab0:     SB      TCON2.2                ; ignitor????

                SJ      label_2ac7             ; 2AB3 0 ??? ??? CB12

;*******************
                ; 2AB5 from 2A8D e4h = A = 2 or 3
label_2ab5:     CMPB    A, #002h               ; if A == 2
                JEQ     label_2ae4             ; jump

;*******************
                ;else A = 3
                JBS     off(0dfh).2, label_2ab0 ; dfh & 0100
                RB      TCON2.2                ; 2ABC 0 ??? ??? C5420A

                ; 2ABF from 2AAE (DD0,???,???)
label_2abf:     ADDB    A, #001h               ; A = 4
                ANDB    A, #003h               ; 2AC1 0 ??? ??? D603
                CMPB    A, off(0dfh)        	; dfh
                JEQ     label_2ad9             ; 2AC5 0 ??? ??? C912
;*****

                ; 2AC7 from 2AB3 TCON2.2 == 1
                ; 2AC7 from 2AD0 if TCON2.3 == 0 && TCON2.2 == 0
label_2ac7:     L       A, TM2                 ; 2AC7 1 ??? ??? E538
                SUB     A, #00001h             ; 2AC9 1 ??? ??? A60100
                ST      A, TMR2                ; 2ACC 1 ??? ??? D53A
                SJ      label_2b02             ; jump to end

                ; 2AD0 from 2AE4 TCON2.2 == 0
label_2ad0:     JBR     off(TCON2).3, label_2ac7 ; if TCON2.3 == 0 && TCON2.2 == 0 jump

                                               ; 2AD3 from 2A95 (DD0,???,???)
label_2ad3:     L       A, TMR1                ; 2AD3 1 ??? ??? E536
                ADD     A, off(0dah)        	; DAh
                ST      A, 0dch                ; 2AD7 1 ??? ??? D5DC

                                               ; 2AD9 from 2AC5 (DD0,???,???)
label_2ad9:     L       A, TMR1                ; 2AD9 1 ??? ??? E536
                ADD     A, off(0d8h)        	; 2ADB 1 ??? ??? 87D8
                ST      A, TMR2                ; 2ADD 1 ??? ??? D53A
                SB      TCON2.3                ; 2ADF 1 ??? ??? C5421B
                SJ      label_2b02             ; 2AE2 1 ??? ??? CB1E

;******************
                ; 2AE4 from 2AB7 A == 2
label_2ae4:     JBR     off(TCON2).2, label_2ad0 ; if ignitor not on, jump up
                L       A, TM2                 ; 2AE7 1 ??? ??? E538
                SUB     A, off(TMR1)        	; 2AE9 1 ??? ??? A736
                ADD     A, #00005h             ; 2AEB 1 ??? ??? 860500
                CMP     A, off(0dah)        	; 2AEE 1 ??? ??? C7DA
                JGE     label_2af8             ; 2AF0 1 ??? ??? CD06
                L       A, TMR1                ; 2AF2 1 ??? ??? E536
                ADD     A, off(0dah)        	; 2AF4 1 ??? ??? 87DA
                SJ      label_2afd             ; 2AF6 1 ??? ??? CB05


                                               ; 2AF8 from 2AF0 (DD1,???,???)
label_2af8:     L       A, TM2                 ; 2AF8 1 ??? ??? E538
                ADD     A, #00003h             ; 2AFA 1 ??? ??? 860300

                ; 2AFD from 2AA6 A is TMR1+ [dah] (dah is 0 to #1eh) from e4h = 1
                ; 2AFD from 2AF6 A is TMR1+ [dah]
label_2afd:     ST      A, TMR2                ; to end

                RB      TCON2.3                ; 2AFF 1 ??? ??? C5420B
                                               ; 2B02 from 2ACE (DD1,???,???)
                                               ; 2B02 from 2AE2 (DD1,???,???)
label_2b02:     RB      IRQH.1                 ; 2B02 1 ??? ??? C51909
                SB      IRQ.5                  ; 2B05 1 ??? ??? C5181D
                RT                             ; 2B08 1 ??? ??? 01
;**********************************************************************************
;ignition output code checking
;
; 2B09 from INT1
                                               ; 2B09 from 031A (DD0,???,???)
label_2b09:     JBS     off(0131h).6, label_2b1c ; if ignition output code
                JBS     off(0121h).1, label_2b1c ; 2B0C 0 ??? ??? E9210D
                L       A, #000dch             ; 2B0F 1 ??? ??? 67DC00
                CMP     A, 0bah                ; 2B12 1 ??? ??? B5BAC2
                JGE     label_2b1d             ; 2B15 1 ??? ??? CD06
                RB      TRNSIT.1               ; 2B17 1 ??? ??? C54609
                JEQ     label_2b21             ; 2B1A 1 ??? ??? C905
                                               ; 2B1C from 2B09 (DD0,???,???)
                                               ; 2B1C from 2B0C (DD0,???,???)
label_2b1c:     RC                             ; 2B1C 1 ??? ??? 95
                                               ; 2B1D from 2B15 (DD1,???,???)
label_2b1d:     MOVB    off(01b7h), #006h    ; 2B1D 1 ??? ??? C4B79806
                                               ; 2B21 from 2B1A (DD1,???,???)

label_2b21:     MB      off(012eh).3, C      ; IGNITION OUTPUT CODE
                RT                             ; 2B24 1 ??? ??? 01

;****************************************************************************
;beginning of long ass function...
; injector relations...

;The injectors (p2.0-.3) are off 99% of the time at the beginning
;of this function.

; The general, over simplified explanation of the injector code is this:
; - this function decides when to turn on the injectors
; - when it decides to turn one on, it does this calc:
;     tmval = 0xffff - fuel value;
;   it then shoves the calculated tmval into Timer0.
;   - Ok, technically this isnt 100% true. The is a 1Ah in the formula somewhere.
;     It looks to be 1Ah - fuel value which ends up being ffffh - fuel value + 1Bh.
;     But whos counting? The 1ah ends up only being a .1ms difference and really,
;     this stuff isnt all that accurate to begin with.
; - timer0 increments at 32 clock cycles per tick and when it overlows
;   the TM0_overflow_interrupt is called and in turn shuts off the proper injector
; - this means the milliseconds that the injector is open is
;     fuel_value/246.875
;     246.875 = 7900clocksPerMillisecond / 32clocksPerTick
;
; Obviously that explanation is way to simple cause it takes the next ~300 lines
; to do this. I think the reason its complicated is because
; - they only use one timer for 4 injectors
; - the code needs to decide WHEN to actually turn the injectors on.
;
;
; d0h, d2h, d4h, and d6h look (from the code) to be the timing for each injector.
; Although logging them resulted in nothing but 0s. IIRC, they have the 0xffff-fuelval
; value in them.
;
; 214h, 216h, and 218h have something to do with timing too...
;
; 21ah and 21bh are masks that are almost always inverses of each other. i.e.
; 21ah will be 01110111b when 21bh is 10001000. Is this telling us which injector
; we are on?
;
; 21ch is anded with P2 in the timer_0_overflow interrupt to turn off an injector
;
;
                                               ; 2B25 from 0292 (DD1,???,???)
                                               ; 2B25 from 09D0 (DD1,108,13D)
label_2b25:     MOV     LRB, #00040h           ; page 2...
                LB      A, 0e6h                ; load e6h
                JEQ     label_2b40             ; if e6h == 0 jump (usually the case)
                DECB    0e6h                   ; else DEC e6h
                CMPB    A, #004h               ;
                JEQ     label_2b40             ; if e6h == 4, jump

                LB      A, off(0021ah)         ; else
                MB      C, ACC.7               ; 2B35 0 200 ??? C5062F
                ROLB    A                      ; 2B38 0 200 ??? 33
                STB     A, off(0021ah)         ; 2B39 0 200 ??? D41A
                XORB    A, #0ffh               ; 2B3B 0 200 ??? F6FF
                STB     A, off(0021bh)         ; 2B3D 0 200 ??? D41B
                RT                             ; maybe return


                ;here we are ready to actually do something.
                                               ; 2B40 from 2B2A (DD0,200,???)
                                               ; 2B40 from 2B31 (DD0,200,???)
label_2b40:     MOVB    r0, #0ffh              ; r0 = ffh
                L       A, 0d6h                ; load d6h
                MOV     X1, A                  ; X1 = final fuel
                MB      C, 0feh.6              ; C = feh.6 : (limpmode bit? 0 during normal cond)
                JLT     label_2b4d             ; if C ==1
                JNE     label_2b4d             ; if d6h != 0
                SC                             ; else set carry (usually the case)
                                               ; 2B4D from 2B48 (DD1,200,???)
                                               ; 2B4D from 2B4A (DD1,200,???)
label_2b4d:     MB      PSWL.4, C              ; 1 if bad? 0 if good
                CMPB    off(0021ch), #00fh     ; this is usually fh
                JNE     label_2ba1             ; j if 21ch != fh (use d6h)
                ;2ba1 is where the 4 cases converge...

                MOV     USP, #00214h           ;
                MOV     DP, #000d0h            ;
                L       A, [DP]                ; d0h
                JNE     label_2b78             ; if d0h != 0, jump

                INC     DP                     ; d1h
                INC     DP                     ; d2h
                L       A, [DP]                ; d2h
                JNE     label_2b8a             ; if d2h != 0, jump

                INC     DP                     ; d3h
                INC     DP                     ; d4h
                L       A, [DP]                ; d4h
                JEQ     label_2ba1             ; if d4h == 0, jump (typical)

				;case 3
                MOV     X1, A                  ; else X1 = d4h
                MB      C, off(0021bh).0       ; C = 21bh.0
                RORB    off(0021bh)            ; Roll right...
                                               ; 2B70 from 2B9F (DD0,200,214)
label_2b70:     CAL     label_2c8a             ; 2B70 1 200 214 328A2C

;label_2c8a:     L       A, [DP]                ; load d4
;                CLR     [DP]                   ; clr d4h
;                INC     DP                     ; d5h
;                INC     DP                     ; d6h
;                SUB     A, [DP]                ; A = d4h - d6h
;                JGE     label_2c9d             ; if no carry jump
;                ADD     A, #0001ah             ; else add 1ah
;                JLT     label_2c9d             ; if carry jump
;                CMP     A, #0ff40h             ; else compare to ff40h
;                JLT     label_2c9e             ; if less than, jump
;                                               ; 2C9D from 2C91 (DD1,200,214)
;                                               ; 2C9D from 2C96 (DD1,200,214)
;label_2c9d:     CLR     A                      ; clear
;                                               ; 2C9E from 2C9B (DD1,200,214)
;label_2c9e:     ST      A, (00214h-00214h)[USP] ; 214h (or 216h or 218h)
;                INC     USP                    ; 215h (or 217h or 219h)
;                INC     USP                    ; 216h (or 218h or 220h)
;                RT                             ;

                ANDB    r0, off(0021ah)        ; and ff with 21ah (pick injector?)
                SJ      label_2ba1             ; jump to converge


                ;case 1
                ;DP = d0h
                                               ; 2B78 from 2B5D (DD1,200,214)
label_2b78:     MOV     X1, A                  ; X1 = d0h's val
                MB      C, off(0021bh).7       ; 21bh.7
                ROLB    off(0021bh)            ; roll left
                CAL     label_2c8a             ; 2B7F 1 200 214 328A2C
;label_2c8a:     L       A, [DP]                ; load d0
;                CLR     [DP]                   ; clr d0h
;                INC     DP                     ; d1h
;                INC     DP                     ; d2h
;                SUB     A, [DP]                ; A = d0h - d2h
;                JGE     label_2c9d             ; if no carry jump
;                ADD     A, #0001ah             ; else add 1ah
;                JLT     label_2c9d             ; if carry jump
;                CMP     A, #0ff40h             ; else compare to ff40h
;                JLT     label_2c9e             ; if less than, jump
;                                               ; 2C9D from 2C91 (DD1,200,214)
;                                               ; 2C9D from 2C96 (DD1,200,214)
;label_2c9d:     CLR     A                      ; clear
;                                               ; 2C9E from 2C9B (DD1,200,214)
;label_2c9e:     ST      A, (00214h-00214h)[USP] ; 214h
;                INC     USP                    ; 215h
;                INC     USP                    ; 216h
;                RT                             ;

                LB      A, off(0021ah)         ; 21ah
                SRLB    A                      ; shift right
                SRLB    A                      ; shift right
                ANDB    r0, A                  ; AND with r0
                SJ      label_2b97             ; jump n call label_2c8a 2 more times

                ;case 2
                ; DP = d2h
                                               ; 2B8A from 2B62 (DD1,200,214)
label_2b8a:     MOV     X1, A                  ; X1 = d2h
                MB      C, off(0021bh).7       ;
                ROLB    off(0021bh)            ; roll left
                MB      C, off(0021bh).7       ;
                ROLB    off(0021bh)            ; roll left again
                                               ; 2B97 from 2B88 (DD0,200,214)
label_2b97:     CAL     label_2c8a             ;

;label_2c8a:     L       A, [DP]                ; load d2
;                CLR     [DP]                   ; clr d2h
;                INC     DP                     ; d3h
;                INC     DP                     ; d4h
;                SUB     A, [DP]                ; A = d2h - d4h
;                JGE     label_2c9d             ; if no carry jump
;                ADD     A, #0001ah             ; else add 1ah
;                JLT     label_2c9d             ; if carry jump
;                CMP     A, #0ff40h             ; else compare to ff40h
;                JLT     label_2c9e             ; if less than, jump
;                                               ; 2C9D from 2C91 (DD1,200,214)
;                                               ; 2C9D from 2C96 (DD1,200,214)
;label_2c9d:     CLR     A                      ; clear
;                                               ; 2C9E from 2C9B (DD1,200,214)
;label_2c9e:     ST      A, (00214h-00214h)[USP] ; 214h (or 216h)
;                INC     USP                    ; 215h (or 217h)
;                INC     USP                    ; 216h (or 218h)
;                RT                             ;

                LB      A, off(0021ah)         ; 21ah
                SRLB    A                      ; shift right
                ANDB    r0, A                  ; and r0
                SJ      label_2b70             ; jump n call label_2c8a 1 more times




                                               ; 2BA1 from 2B53 (DD1,200,???)
                ; 2BA1 from 2B67 When all dxh ram is 0, r0 = ffh, X1 = 0
                                               ; 2BA1 from 2B76 (DD1,200,214)

                ;case: 	21ah = 01110111
                ;		P2 = 00001111h
label_2ba1:     LB      A, off(0021ah)         ; load 21ah		;01110111
                SLLB    A                      ; shift left		;11101110
                SWAPB                          ; swap nibbles   ;11101110
                ANDB    A, r0                  ; and with r0	;11101110 AND 11111111 = 11101110
                ORB     A, #0f0h               ; or with f0h	;11101110 OR  11110000 = 11111110
                STB     A, r0                  ; store in r0 	;r0 = 11111110
                L       A, #0001ah             ; A = #1ah
                SUB     A, X1                  ; A = #1ah - injector val (0)
                MOV     X1, A                  ; X1 gets it again (X1 = #1ah)

                                               ; 2BAF from 2BBF (DD0,200,???)
label_2baf:     RB      PSWH.0                 ;
                LB      A, off(0021ch)         ; load 21ch
                JNE     label_2bf0             ; if != 0 jump (probably #fh, so jump)

                ;this must call the interrupt?
                SB      IRQ.4                  ; else set tm0 overflow irq

                MOV     TM0, #0000ch           ; move ch into timer 0
                SB      PSWH.0                 ;
                SJ      label_2baf             ; loop


                ; 2BC1 from 2BF8 if PSWL.4 == 1
                ;
label_2bc1:     RB      TCON0.4                ;
                LB      A, #00fh               ;
                STB     A, off(0021ch)         ;
                ORB     P2, A                  ; turn off all injectors
                LB      A, off(0021ah)         ;
                XORB    A, #0ffh               ;
                STB     A, off(0021bh)         ; opposite of 21ah
                RB      IRQ.4                  ;
                MOV     off(00214h), #0ffffh   ;
                SJ      label_2c3e             ;


                ; 2BDB from 2BFC when 21ah == fh
label_2bdb:     LB      A, r0                  ; 1111 1110
                ANDB    off(0021ch), A         ; 21ch = 00001110
                MB      C, 0feh.7              ; load revlimit bit
                JLT     label_2be7             ; if limit bit skip next line
                ANDB    P2, A                  ; turn on one of the injectors

                                               ;
label_2be7:     L       A, X1                  ; load injector val
                ST      A, TM0                 ; store in TM0
                SB      TCON0.4                ;
                J       label_2c87             ; jump to FINISH

                ;out of loop we get here...
                                               ; 2BF0 from 2BB3 (DD0,200,???)

                                               ;
label_2bf0:     MB      C, off(0021ah).7       ; 01110111, C = 0
                ROLB    off(0021ah)            ; 21ah = 11101110
                								;if 11011101
                								;C = 1, so: 10111011

                MB      C, PSWL.4              ; move the selector bit in
                JLT     label_2bc1             ; if C == 1 jump to turn all injectors off

                CMPB    A, #00fh               ; else compare 21ch to fh
                JEQ     label_2bdb             ; if == jump up to deal with injectors


                STB     A, r1                  ; Store 21ch into r1 (last injector turned on?)
                								;

				;if 21ch = 00000111
                LB      A, r0                  ; A = r0 (11111110)
                ANDB    off(0021ch), A         ;21c = 00000110
                MB      C, 0feh.7              ; revlimit bit
                JLT     label_2c0b             ; if its set, jump over...
                ANDB    P2, A                  ;
                                               ; 2C0B from 2C06 (DD0,200,???)
label_2c0b:     L       A, TM0                 ; load timer 0
                ADD     A, 0d6h                ; add d6h
                JLT     label_2c15             ; if overflow, jump
                MB      C, IRQ.4               ; else move state of TM0 overflow int into C

                                               ; 2C15 from 2C10 (DD1,200,???)
label_2c15:     JBR     off(00201h).0, label_2c23 ; 2C15 1 200 ??? D8010B
                JBR     off(00201h).1, label_2c67 ; 2C18 1 200 ??? D9014C
                JBS     off(00201h).2, label_2c2c ; 2C1B 1 200 ??? EA010E
                JBR     off(00201h).3, label_2c4b ; 2C1E 1 200 ??? DB012A
                SJ      label_2c2c             ; 2C21 1 200 ??? CB09
                                               ; 2C23 from 2C15 (DD1,200,???)
label_2c23:     JBR     off(00201h).1, label_2c45 ; 2C23 1 200 ??? D9011F
                JBR     off(00201h).2, label_2c6d ; 2C26 1 200 ??? DA0144
                JBR     off(00201h).3, label_2c4b ; 2C29 1 200 ??? DB011F
                                               ; 2C2C from 2C1B (DD1,200,???)
                                               ; 2C2C from 2C21 (DD1,200,???)
                                               ; 2C2C from 2C67 (DD1,200,???)
label_2c2c:     JGE     label_2c38             ; 2C2C 1 200 ??? CD0A
                SUB     A, #00033h             ; 2C2E 1 200 ??? A63300
                JLT     label_2c38             ; 2C31 1 200 ??? CA05
                CMP     A, #000c0h             ; 2C33 1 200 ??? C6C000
                JGE     label_2c39             ; 2C36 1 200 ??? CD01
                                               ; 2C38 from 2C2C (DD1,200,???)
                                               ; 2C38 from 2C31 (DD1,200,???)
label_2c38:     CLR     A                      ; 2C38 1 200 ??? F9
                                               ; 2C39 from 2C36 (DD1,200,???)
label_2c39:     ST      A, er0                 ; 2C39 1 200 ??? 88
                CLR     A                      ; 2C3A 1 200 ??? F9
                SUB     A, er0                 ; 2C3B 1 200 ??? 28
                ST      A, off(00214h)         ; 2C3C 1 200 ??? D414
                                               ; 2C3E from 2BD9 (DD0,200,???)
label_2c3e:     L       A, #0ffffh             ; 2C3E 1 200 ??? 67FFFF
                ST      A, off(00216h)         ; 2C41 1 200 ??? D416
                SJ      label_2c85             ; 2C43 1 200 ??? CB40
                                               ; 2C45 from 2C23 (DD1,200,???)
label_2c45:     JBR     off(00201h).2, label_2c6d ; 2C45 1 200 ??? DA0125
                JBR     off(00201h).3, label_2c6d ; 2C48 1 200 ??? DB0122
                                               ; 2C4B from 2C1E (DD1,200,???)
                                               ; 2C4B from 2C29 (DD1,200,???)
                                               ; 2C4B from 2C6A (DD1,200,???)
label_2c4b:     JGE     label_2c5b             ; 2C4B 1 200 ??? CD0E
                ADD     A, off(00214h)         ; 2C4D 1 200 ??? 8714
                JGE     label_2c5b             ; 2C4F 1 200 ??? CD0A
                SUB     A, #0004eh             ; 2C51 1 200 ??? A64E00
                JLT     label_2c5b             ; 2C54 1 200 ??? CA05
                CMP     A, #000c0h             ; 2C56 1 200 ??? C6C000
                JGE     label_2c5c             ; 2C59 1 200 ??? CD01
                                               ; 2C5B from 2C4B (DD1,200,???)
                                               ; 2C5B from 2C4F (DD1,200,???)
                                               ; 2C5B from 2C54 (DD1,200,???)
label_2c5b:     CLR     A                      ; 2C5B 1 200 ??? F9
                                               ; 2C5C from 2C59 (DD1,200,???)
label_2c5c:     ST      A, er0                 ; 2C5C 1 200 ??? 88
                CLR     A                      ; 2C5D 1 200 ??? F9
                SUB     A, er0                 ; 2C5E 1 200 ??? 28
                ST      A, off(00216h)         ; 2C5F 1 200 ??? D416
                L       A, #0ffffh             ; 2C61 1 200 ??? 67FFFF
                J       label_2c85             ; 2C64 1 200 ??? 03852C
                                               ; 2C67 from 2C18 (DD1,200,???)
label_2c67:     JBS     off(00201h).2, label_2c2c ; 2C67 1 200 ??? EA01C2
                JBS     off(00201h).3, label_2c4b ; 2C6A 1 200 ??? EB01DE
                                               ; 2C6D from 2C26 (DD1,200,???)
                                               ; 2C6D from 2C45 (DD1,200,???)
                                               ; 2C6D from 2C48 (DD1,200,???)
label_2c6d:     JGE     label_2c81             ; 2C6D 1 200 ??? CD12
                ADD     A, off(00214h)         ; 2C6F 1 200 ??? 8714
                JGE     label_2c81             ; 2C71 1 200 ??? CD0E
                ADD     A, off(00216h)         ; 2C73 1 200 ??? 8716
                JGE     label_2c81             ; 2C75 1 200 ??? CD0A
                SUB     A, #00068h             ; 2C77 1 200 ??? A66800
                JLT     label_2c81             ; 2C7A 1 200 ??? CA05
                CMP     A, #000c0h             ; 2C7C 1 200 ??? C6C000
                JGE     label_2c82             ; 2C7F 1 200 ??? CD01
                                               ; 2C81 from 2C6D (DD1,200,???)
                                               ; 2C81 from 2C71 (DD1,200,???)
                                               ; 2C81 from 2C75 (DD1,200,???)
                                               ; 2C81 from 2C7A (DD1,200,???)
label_2c81:     CLR     A                      ; 2C81 1 200 ??? F9
                                               ; 2C82 from 2C7F (DD1,200,???)
label_2c82:     ST      A, er0                 ; 2C82 1 200 ??? 88
                CLR     A                      ; 2C83 1 200 ??? F9
                SUB     A, er0                 ; 2C84 1 200 ??? 28
                                               ; 2C85 from 2C43 (DD1,200,???)
                                               ; 2C85 from 2C64 (DD1,200,???)
label_2c85:     ST      A, off(00218h)         ; 2C85 1 200 ??? D418
                                               ; 2C87 from 2BED (DD1,200,???)
label_2c87:     SB      PSWH.0                 ; 2C87 1 200 ??? A218
                RT                             ; 2C89 1 200 ??? 01

;end of long ass function
;*******************************************************************************

                                               ; 2C8A from 2B70 (DD1,200,214)
                                               ; 2C8A from 2B7F (DD1,200,214)
                                               ; 2C8A from 2B97 (DD1,200,214)
label_2c8a:     L       A, [DP]                ; 2C8A 1 200 214 E2
                CLR     [DP]                   ; 2C8B 1 200 214 B215
                INC     DP                     ; 2C8D 1 200 214 72
                INC     DP                     ; 2C8E 1 200 214 72
                SUB     A, [DP]                ; 2C8F 1 200 214 B2A2
                JGE     label_2c9d             ; 2C91 1 200 214 CD0A
                ADD     A, #0001ah             ; 2C93 1 200 214 861A00
                JLT     label_2c9d             ; 2C96 1 200 214 CA05
                CMP     A, #0ff40h             ; 2C98 1 200 214 C640FF
                JLT     label_2c9e             ; 2C9B 1 200 214 CA01
                                               ; 2C9D from 2C91 (DD1,200,214)
                                               ; 2C9D from 2C96 (DD1,200,214)
label_2c9d:     CLR     A                      ; 2C9D 1 200 214 F9
                                               ; 2C9E from 2C9B (DD1,200,214)
label_2c9e:     ST      A, (00214h-00214h)[USP] ; 2C9E 1 200 214 D300
                INC     USP                    ; 2CA0 1 200 215 A116
                INC     USP                    ; 2CA2 1 200 216 A116
                RT                             ; 2CA4 1 200 216 01

;*****************************************************************************

                                               ; 2CA5 from 26A3 (DD0,080,205)
                                               ; 2CA5 from 26C2 (DD0,080,205)
label_2ca5:     MOVB    r6, #077h              ; 2CA5 0 080 205 9E77
                JEQ     label_2cb1             ; 2CA7 0 080 205 C908
                                               ; 2CA9 from 2CAF (DD0,080,205)
label_2ca9:     MB      C, r6.7                ; 2CA9 0 080 205 262F
                ROLB    r6                     ; 2CAB 0 080 205 26B7
                SUBB    A, #001h               ; 2CAD 0 080 205 A601
                JNE     label_2ca9             ; 2CAF 0 080 205 CEF8
                                               ; 2CB1 from 2CA7 (DD0,080,205)
label_2cb1:     LB      A, r6                  ; 2CB1 0 080 205 7E
                RT                             ; 2CB2 0 080 205 01

;*****************************************************************************
;map interpolation
                       ;with ign map->          ; 2CB3 from 0706 (DD0,108,20E)
                       ;with fuel map->         ; 2CB3 from 0AB8 (DD0,108,13D)
                       ;           +---->       ; 2CB3 from 0AD1 (DD0,108,13D)
;1st element of map in X1, last ele +1 of rpm scalar in X2, map image in r6 (b5h), and rpm byte in r7
;gets called from with ign maps and fuel maps. odd
;
;maybe finds the correct cell? and interpolates the value?
;r6 has #0dfh if fault code 130.2 and .4 are set
;the highest map value that can be had is #df because it then sets the column to 13
;column 14 is for interpolation only


label_2cb3:     CLR     A
                LB      A, r6			   	   ;map image goes into AL
                SWAPB						   ;AL(7-4)<->AL(3-0)
                ANDB    A, #00fh			   ;AL gets AL(3-0), which was AL(7-4) a line above

                ;line below this sets the column
                ADD     X1, A				   ;add map image to map ptr
                MB      C, PSWL.5			   ;set if ign map?
                JLT     label_2cca			   ;jump if C == 1

                ;only for fuel map
                LCB     A, 000ffh[X1]		   ;load last cell of map into acc
                MOV     DP, A				   ;point to that cell with the dp
                CMPCB   A, 00100h[X1]		   ;compare last cell with 1st fuel mult?
                MB      C, zp_PSWH.6		   ;set carry to half carry flag?
                                               ; 2CCA from 2CBC (DD0,108,20E)
label_2cca:     MB      PSWL.4, C			   ;mov C bit to pswl.4
                MOVB    r0, #010h              ; 2CCC 0 108 20E 9810
                                               ; 2CCE from 2CD6 (DD0,108,20E)
				;for(r0 = 15; r0>=0 && C==0; r0--)
				;from the back, add the rpm scalars
				;onto the rpm val (A6h(notec)/A7h(vtec)) until the result > 255
label_2cce:     DECB    r0					   ; just a counter
                DEC     X2                     ; scalar ptr--
                LCB     A, 00000h[X2]          ; load at ptr
                ADDB    r7, A				   ; add rpm scalar to acc
                JGE     label_2cce			   ; loop while carry == 0
                ;X2 is now pointing at the rpm scalar +1 that the rpm is in
                ;r7 has 1byte of rpm b/t 0 and 15 (row interpolation val...
                ;A has (?|contents at the location X2 is pointing at)

                ;lets say:
                ;x2 = 0
                ;  row: 0   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15;  16 for interp
                ;vector = 10h,10h,10h,10h,10h,10h,10h,10h,10h,10h,10h,10h,10h,10h,10h,10h

                ;for rpm (r7) = efh
                ;cur column = 14
                ;overflow (r7 post calc) = fh = [x2+cur column]-1
                ;so its using mostly column 15

                ;for rpm (r7) = f0h
                ;cur column = 15
                ;overflow (r7 post calc) = 0h
                ;so its using mostly column 15


                MOV     X2, A				   ;make X2 point at As contents -> (1byte of map|1byte of rpm)
                SLL     X2					   ;shift left once for what? mult by 2?
                LB      A, #00fh			   ;load 15 into Acc
                MULB						   ;A = row width * current row


                ADD     X1, A				   ;cell found, adds 15* the row (the rpm scalar) to X1
                CLR     A                      ; 2CE1 1 108 20E F9
                LCB     A, [X1]				   ;load that cell's val into Acc
                ST      A, er0				   ;store the val into er0
                LCB     A, 0000fh[X1]		   ;load the contents of the cell at (curcol,currow+1) into A
                MOV     USP, A				   ;
                INC     X1					   ;point at cell next to curcell
                LCB     A, [X1]				   ;load into A
                ST      A, er1                 ; 2CEE 1 108 20E 89
                LCB     A, 0000fh[X1]          ; 2CEF 1 108 20E 90AB0F00
                MOV     X1, A				   ;point at cell right and down from orig cell
                MB      C, PSWL.4			   ;some sort of map picker
                JLT     label_2cfc             ; 2CF6 1 108 20E CA04
                SLL     er1                    ; 2CF8 1 108 20E 45D7
                SLL     X1                     ; 2CFA 1 108 20E 90D7

                ;er0 has orig cell contents
                ;er1 has cell to right of orig cell contents
                ;X1 points at cell right and down from orig cell
                ;stack pointer pointing at contents of cell below orig cell
                                               ; 2CFC from 2CF6 (DD1,108,20E)
label_2cfc:     SCAL    label_2d23			   ;interpolate b/t cell and cell to right
                MOV     er0, USP			   ;pop cell below orig
                MOV     er1, X1                ; 2D00 1 108 20E 9049
                MOV     X1, A                  ; 2D02 1 108 20E 50
                SCAL    label_2d23			   ;interpolate b/t cell below and cell below & right
                MOVB    r0, r7                 ; overflow from row calc...
                MOVB    r1, #000h              ; 0
                MB      C, off(00129h).2       ; 2D09 1 108 20E C4292A
                ROL     er0                    ; er0 = er0*2 + C
                MOV     er2, X2                ; 2D0E 1 108 20E 914A
                MOV     er3, X1                ; 2D10 1 108 20E 904B

                ;A = interp between south and south east cell
                ;er3 = interp between current and east cell
                ;er0 = (0|row calc overflow) shifted left by 1
                ;er2 = (
				; A = A - er3
				;if(A<0)
				;{
				;	negative=true;
				;	A=-A;
				;}
				;A=A*er0/er2;
				;if(negative)
				;	A = er3-A;
				;else
				;	A = er3+A;
                CAL     label_2df2             ; jump into a vcal to interp between the rows
                RB      PSWL.5                 ; 2D15 1 108 20E A30D
                JNE     label_2d21             ; 2D17 1 108 20E CE08
                L       A, DP                  ; 2D19 1 108 20E 42
                JEQ     label_2d21             ; 2D1A 1 108 20E C905
                L       A, er3                 ; 2D1C 1 108 20E 37
                                               ; 2D1D from 2D1E (DD1,108,20E)
label_2d1d:     SLL     A                      ; 2D1D 1 108 20E 53
                JRNZ    DP, label_2d1d         ; 2D1E 1 108 20E 30FD
                ST      A, er3                 ; 2D20 1 108 20E 8B
                                               ; 2D21 from 2D17 (DD1,108,20E)
                                               ; 2D21 from 2D1A (DD1,108,20E)
label_2d21:     L       A, er3                 ; 2D21 1 108 20E 37
                RT                             ; 2D22 1 108 20E 01
                                               ; 2D23 from 2CFC (DD1,108,20E)
                                               ; 2D23 from 2D03 (DD1,108,20E)
;*****************************************************************************
;function for maps
                ;er0 has orig cell contents
                ;er1 has cell to right of orig cell contents
                ;X1 points at cell right and down from orig cell
                ;stack pointer pointing at contents of cell below orig cell
                ;r6 has map image
label_2d23:     LB      A, r6                  ; 2D23 0 108 20E 7E
                SWAPB                          ; 2D24 0 108 20E 83
                EXTND                          ; 2D25 1 108 20E F8
                SWAP							;sign extended map image
                AND     A, #0f000h				;
                XCHG    A, er0					;give orig cell contents to A and map image to er0
                ST      A, er2					;put orig cell contents into er2
                SUB     A, er1					;A = orig cell contents - cell to right contents
                JGE     label_2d33				;if result is positive, jump
                ST      A, er1					;else, make it positive
                CLR     A                      ; 2D31 1 108 20E F9
                SUB     A, er1					;A = 0 - (orig cell contents - cell to right contents)
                                               ; 2D33 from 2D2E (DD1,108,20E)
label_2d33:     MUL								;<er1,A>= |difference b/t cells| * SEXT map image
                L       A, er2					;load orig cell contents into A
                JGE     label_2d3a             ; 2D36 1 108 20E CD02

                ;add orig cell contents to the newly calculated val in er1 (I think)
                ;but keep it positive.
                ADD     A, er1                 ; 2D38 1 108 20E 09
                RT                             ; 2D39 1 108 20E 01
;maybe end function
                                               ; 2D3A from 2D36 (DD1,108,20E)
label_2d3a:     SUB     A, er1                 ; 2D3A 1 108 20E 29
                RT                             ; 2D3B 1 108 20E 01
;end fo shizzle, y0

;**********************************************************************************
					                           ; 2D3C from 0ABB (DD0,108,13D)
                                               ; 2D3C from 0AD4 (DD0,108,13D)
;function
label_2d3c:     STB     A, r0                  ; 2D3C 0 108 13D 88
                L       A, off(00160h)         ; is this o2 ram??
                MUL                            ; 2D3F 1 108 13D 9035
                ROL     A                      ; 2D41 1 108 13D 33
                L       A, er1                 ; 2D42 1 108 13D 35
                ROL     A                      ; 2D43 1 108 13D 33
                RT                             ; 2D44 1 108 13D 01
;end function
;*********************************************
                                               ; 2D45 from 111E (DD0,108,13D)
label_2d45:     LB      A, 0a3h                ; 2D45 0 108 13D F5A3
                VCAL    0                      ; 2D47 0 108 13D 10
                STB     A, r5                  ; 2D48 0 108 13D 8D
                MOV     X1, X2                 ; 2D49 0 108 13D 9178

;********************************************
                                               ; 2D4B from 10B3 (DD0,108,13D)
label_2d4b:     LB      A, 0a3h                ; 2D4B 0 108 13D F5A3
                VCAL    0                      ; 2D4D 0 108 13D 10
                STB     A, r7                  ; 2D4E 0 108 13D 8F
                MOVB    r6, r5                 ; 2D4F 0 108 13D 254E
                                               ; 2D51 from 1110 (DD0,108,13D)
label_2d51:     MOV     X1, #03727h            ; 2D51 0 108 13D 602737
                JBS     off(00118h).7, label_2d58 ; if auto
                INC     X1                     ; 2D57 0 108 13D 70


                                               ; 2D58 from 07E1 (DD0,108,20E)
                                               ; 2D58 from 2D54 (DD0,108,13D)

label_2d58:     LB      A, 0b4h                ; load map

			;[X1] is upper limit and [X1+2] is lower limit.
			; so:
			; if(A < [X1] && A >= [X1+2])
			;	interpolate between the 2 values.
			; else if(
			;   A ==
                                               ; 2D5A from 31CA (DD0,108,13D)
label_2d5a:     CMPCB   A, [X1]                ;
                JLT     label_2d60             ; 2D5C 0 108 20E CA02
                LCB     A, [X1]                ; 2D5E 0 108 20E 90AA
                                               ; 2D60 from 2D5C (DD0,108,20E)
label_2d60:     CMPCB   A, 00002h[X1]          ; 2D60 0 108 20E 90AF0200
                JGE     label_2d6a             ; 2D64 0 108 20E CD04
                LCB     A, 00002h[X1]          ; 2D66 0 108 20E 90AB0200
                                               ; 2D6A from 2D64 (DD0,108,20E)
label_2d6a:     STB     A, r0                  ; 2D6A 0 108 20E 88
                SJ      label_2d82             ; 2D6B 0 108 20E CB15


;*****************************************************************************
;vcal_0
;
;
                                               ; 2D6D from 22EF (DD0,080,0A4)
                                               ; 2D6D from 2D75 (DD0,080,0A4)
               ; vcal 0 from 077E, A has ram a6h, X1 may have ignition map
               ; vcal 0 from 07EF, A has ram a7h, X1 has #03887h
                                               ; 2D6D from 320C (DD0,080,0A3)
                                               ; 2D6D from 087D (DD0,108,3891)
               ; vcal 0 from 0864, A has ram a6h or a7h, A, X1 has #038bbh or #038adh
                                               ; 2D6D from 0920 (DD0,108,13D)
                                               ; 2D6D from 0927 (DD0,108,13D)
                                               ; 2D6D from 0A01 (DD0,108,13D)
                                               ; 2D6D from 2FE5 (DD0,108,13D)
                                               ; 2D6D from 2FEC (DD0,108,13D)
                                               ; 2D6D from 0BF1 (DD0,108,13D)
                                               ; 2D6D from 0C05 (DD0,108,13D)
                                               ; 2D6D from 10FB (DD0,108,13D)
                                               ; 2D6D from 110D (DD0,108,13D)
                                               ; 2D6D from 2D4D (DD0,108,13D)
                                               ; 2D6D from 2D47 (DD0,108,13D)
                                               ; 2D6D from 31BC (DD0,108,13D)
                                               ; 2D6D from 31C2 (DD0,108,13D)
                                               ; 2D6D from 14DA (DD0,108,13D)
                ;this loop looks for a byte in rom where the current rpm is > or equal to
                ;of course, the rom bytes are decreasing i.e.
                ;38BBh: FF F4 F0 F4 B0 F4 8F F4 79 FA 1C FF 00
                ;pass:         1     2     3     4     5     6

                ;init: key = A, unsigned char *X1

                ;while(key<X1[2]) X1+=2;		 while(true){
vcal_0:         CMPCB   A, 00002h[X1]          ;   if(key >= X1[2])
                JGE     label_2d77             ;     break;
                INC     X1                     ;   X1++;
                INC     X1                     ;   X1++
                SJ      vcal_0                 ; }

                ;now: X1[2] <= key < X1[0]
                                               ; 2D77 from 2DB7 (DD0,108,20E)
                                               ; 2D77 from 2D71 (DD0,080,0A4)
label_2d77:     STB     A, r0					;r0 = key
                LCB     A, 00003h[X1]			;
                STB     A, r6					;r6 = X1[3]
                LCB     A, 00001h[X1]			;
                STB     A, r7					;r7 = X1[1]


                                               ; 2D82 from 2D6B (DD0,108,20E)
label_2d82:     LCB     A, 00002h[X1]			;
                STB     A, r1					; r1 = X1[2]
                SUBB    r0, A					; r0 = key - X1[2]
                LCB     A, [X1]					; A = X1[0]
                SUBB    A, r1					; A = X1[0] - X1[2]
                STB     A, r1					; r1 = X1[0] - X1[2]
                LB      A, r7					;
                SUBB    A, r6					; A = X1[1] - X1[3]
                MB      PSWL.4, C				; if negative set this flag
                JGE     label_2d96				; if positive jump
                STB     A, r7					; else
                CLRB    A						;
                SUBB    A, r7					; make it positive

                                               ; 2D96 from 2D91 (DD0,108,20E)
label_2d96:     MULB							; A = A*r0
                MOVB    r0, r1					;

                ;DIVB -> AL = A/r0 remainder in r1
                DIVB							; A = A*r0/r1
                RB      PSWL.4					; reset neg flag
                JEQ     label_2da4				; if it was positive jump
                SUBB    r6, A					;
                LB      A, r6                   ; A = X1[3] - A
                RT                              ; return A and r6

                ; 2DA4 from 2D9E (used by vcal_0)
                ;if r6<=r7 then we add [X1+3] and the newly calculated AL
label_2da4:     ADDB    A, r6					; A = A + X1[3]
                STB     A, r6					; r6 = A
                RT                              ; return A and r6
;end vcal_0
;on return:
;A = r6 = X1[3] + or  - correction val
;r0 = (closest val in vector below the current, passed in, val)
;r1 = remainder from division
;r7 = ???

;****************************************************************************************
; vcal_2: uses vcal_1
;
;	if(A>=X1[0])
;		A = X1[0];
;	if(A<=X1[2])
;		A = X1[2];
;	goto label_2d77; (vcal_0 after the loop)

                                               ; 2DA7 from 04E0 A = tps, X1 = #3b1dh
                                               ; 2DA7 from 2412 (DD0,080,0A3)
                                               ; 2DA7 from 07DA (DD0,108,20E)
                                               ; 2DA7 from 0980  A = 0bbh, X1 = #0394dh
                                               ; 2DA7 from 0C98 (DD0,108,13D)
                                               ; 2DA7 from 31D3 (DD0,108,13D)
vcal_2:         CMPCB   A, [X1]                ; compare A to [X1]
                JLT     label_2dad             ; if A < [X1] then we jump
                LCB     A, [X1]                ; else we load [X1]
                                               ; 2DAD from 2DA9 (DD0,108,20E)
label_2dad:     CMPCB   A, 00002h[X1]          ; compare A to [X1+2]
                JGE     label_2db7             ; if A >= then jump
                LCB     A, 00002h[X1]          ; else load [X1+2] to A
                                               ; 2DB7 from 2DB1 (DD0,108,20E)
label_2db7:     SJ      label_2d77             ; into vcal_0 we go

;on jump
;A = A or X1[0] or X1[2]

;***************************
;vcal_3: uses vcal_1
;
;	if(A>=X1[0])
;		A = X1[0];
;	if(A<=X1[3])
;		A = X1[3];
;	goto label_2dc9; (vcal_1 after the loop)
;
                                               ; 2DB9 from 1C1F (DD0,080,213)
                                               ; 2DB9 from 1C52 (DD0,080,213)
                                               ; 2DB9 from 27CE (DD0,080,205)
                                               ; 2DB9 from 1F0A (DD0,080,213)
                                               ; 2DB9 from 1F1E (DD0,080,213)
                                               ; 2DB9 from 29FF (DD0,080,132)
                                               ; 2DB9 from 2A09 (DD0,080,132)
vcal_3:         CMPCB   A, [X1]                ; 2DB9 0 080 213 90AE
                JLT     label_2dbf             ; 2DBB 0 080 213 CA02
                LCB     A, [X1]                ; 2DBD 0 080 213 90AA
                                               ; 2DBF from 2DBB (DD0,080,213)
label_2dbf:     CMPCB   A, 00003h[X1]          ; 2DBF 0 080 213 90AF0300
                JGE     label_2dc9             ; 2DC3 0 080 213 CD04
                LCB     A, 00003h[X1]          ; 2DC5 0 080 213 90AB0300
                                               ; 2DC9 from 2DC3 (DD0,080,213)
label_2dc9:     SJ      label_2dd8             ; into vcal_1
                                               ; 2DCB from 1BF0 (DD0,080,213)


;***************************************************************************
;vcal_1
                    ; 2DCB from 22AC (DD0,080,213)
                    ;MOV     X1, #0373fh
					;MOV     X2, #000fah
					;LB      A, 0a6h
                                               ; 2DCB from 2DD6 (DD0,080,213)
                                               ; 2DCB from 1C33 (DD0,080,213)
                                               ; 2DCB from 233B (DD0,080,0A4)
                                               ; 2DCB from 2428 (DD0,080,0A3)
                                               ; 2DCB from 243B (DD0,080,0A3)
                                               ; 2DCB from 1CFB (DD0,080,213)
                                               ; 2DCB from 1EB8 (DD0,080,213)
                                               ; 2DCB from 0A4D (DD0,108,13D)
                                               ; 2DCB from 0978 (DD0,108,13D)
                                               ; 2DCB from 09F0 (DD0,108,13D)
                                               ; 2DCB from 0B25 (DD0,108,13D)
                                               ; 2DCB from 29A1 (DD0,080,132)



				;i = 0;
				;while(true)
				;{
				;	if(key >= vec[i+3])
				;		break;
				;	i+=3;
				;}

				;/* now, X1[0] > key > X1[2]; so we interpolate between X1[1] and X1[4]. */
				;boolean negative = false;
				;int er0 = key-vec[i+3];
				;int er2 = vec[i]-vec[i+3];
				;int A = vec[i+1]-vec[i+4];

				;if(A<0)
				;{
				;	negative=true;
				;	A=-A;
				;}

				;A=A*er0/er2;

				;if(negative)
				;	A = vec[i+4]-A;
				;else
				;	A = vec[i+4]+A;

                ;init: key = A, unsigned char *X1

                ;while(key<X1[3]) X1+=3;		 while(true){
vcal_1:         LB      A, ACC                 ;
                CMPCB   A, 00003h[X1]          ;   if(A >= X1[3])
                JGE     label_2dd8             ;     break;
                INC     X1                     ;   X1++;
                INC     X1                     ;   X1++;
                INC     X1                     ;   X1++;
                SJ      vcal_1                 ; }


                ;/* now, X1[0] > key > X1[3]; so we interpolate between X1[1] and X1[4]. */
				;boolean negative = false;
				;int r0 = key-vec[i+3];
				;int er2 = vec[i]-vec[i+3];
				;int A = vec[i+1]-vec[i+4];
                                               ; 2DD8 from 2DD1 (DD0,080,213)
                                               ; 2DD8 from 2DC9 (DD0,080,213)
label_2dd8:     STB     A, r0                  ; r0 = key
                LCB     A, 00003h[X1]          ;
                STB     A, r4                  ; r4 = X1[3]
                SUBB    r0, A                  ; r0 = key-X1[3]
                CLRB    r1                     ;
                LCB     A, [X1]                ;
                SUBB    A, r4                  ;
                STB     A, r4                  ; r4 = X1[0]-X1[3]
                CLRB    r5                     ;
                CLR     A                      ;
                LC      A, 00004h[X1]          ;
                ST      A, er3                 ; er3 = X1[4]
                LC      A, 00001h[X1]          ; A = X1[1]
                                               ; 2DF2 from 2E2C (DD1,080,1AB)
                                               ; 2DF2 from 2D12 (DD1,108,20E)

label_2df2:     SUB     A, er3                 ; A = X1[1] - X1[4]

				; A = A - er3
				;if(A<0)
				;{
				;	negative=true;
				;	A=-A;
				;}
				;A=A*er0/er2;
				;if(negative)
				;	A = er3-A;
				;else
				;	A = er3+A;
                MB      PSWL.4, C              ; if negative set this bit
                JGE     label_2dfa             ; if pos. jump
                ST      A, er1                 ; else
                CLR     A                      ;
                SUB     A, er1                 ; A = -A

                ;A=A*er0/er2;
                                               ; 2DFA from 2DF5 (DD1,080,213)
label_2dfa:     MUL                            ; er1A = A*er0
                MOV     er0, er1               ; er0 = er1
                DIV                            ; er0A = er0A/er2

                ;if(negative)
				;	A = vec[i+4]-A;
				;else
				;	A = vec[i+4]+A;
                RB      PSWL.4                 ;
                JEQ     label_2e08             ; jump if negative
                SUB     er3, A                 ;
                L       A, er3                 ; A = vec[i+4]-A;
                RT                             ;
                                               ; 2E08 from 2E02 (DD1,080,213)
label_2e08:     ADD     A, er3                 ;
                ST      A, er3                 ; A = vec[i+4]+A;
                RT                             ;

;***************************************************************************
;for iacv PWM
                                               ; 2E0B from 1955 (DD1,080,1AB)
                                               ; 2E0B from 2E15 (DD1,080,1AB)
                                               ; 2E0B from 1F7B (DD1,080,213)
label_2e0b:     CMPC    A, 00004h[X1]          ; 2E0B 1 080 1AB 90AD0400
                JGE     label_2e17             ; 2E0F 1 080 1AB CD06
                ADD     X1, #00004h            ; 2E11 1 080 1AB 90800400
                SJ      label_2e0b             ; 2E15 1 080 1AB CBF4
                                               ; 2E17 from 2E0F (DD1,080,1AB)
label_2e17:     ST      A, er0                 ; 2E17 1 080 1AB 88
                LC      A, 00004h[X1]          ; 2E18 1 080 1AB 90A90400
                ST      A, er2                 ; 2E1C 1 080 1AB 8A
                SUB     er0, A                 ; 2E1D 1 080 1AB 44A1
                LC      A, [X1]                ; 2E1F 1 080 1AB 90A8
                SUB     A, er2                 ; 2E21 1 080 1AB 2A
                ST      A, er2                 ; 2E22 1 080 1AB 8A
                LC      A, 00006h[X1]          ; 2E23 1 080 1AB 90A90600
                ST      A, er3                 ; 2E27 1 080 1AB 8B
                LC      A, 00002h[X1]          ; 2E28 1 080 1AB 90A90200
                SJ      label_2df2             ; 2E2C 1 080 1AB CBC4

;********************************************

                                               ; 2E2E from 183A (DD1,080,00F)
                                               ; 2E2E from 1A4E (DD1,080,1AB)
label_2e2e:     RB      IRQH.4                 ; 2E2E 1 080 00F C5190C
                JNE     label_2e3d             ; 2E31 1 080 00F CE0A
                MOVB    0f0h, #04ah            ; 2E33 1 080 00F C5F0984A
                DECB    0ebh                   ; 2E37 1 080 00F C5EB17
                JNE     label_2e4e             ; 2E3A 1 080 00F CE12
                BRK                            ; 2E3C 1 080 00F FF
                                               ; 2E3D from 2E31 (DD1,080,00F)
label_2e3d:     LB      A, P2                  ; 2E3D 0 080 00F F524
                SWAPB                          ; 2E3F 0 080 00F 83
                SRLB    A                      ; 2E40 0 080 00F 63
                ANDB    A, #007h               ; 2E41 0 080 00F D607
                EXTND                          ; 2E43 1 080 00F F8
                MOV     X1, A                  ; 2E44 1 080 00F 50
                LB      A, ADCR0H              ; 2E45 0 080 00F F561
                STB     A, 00098h[X1]          ; .
                ADDB    P2, #020h              ; 2E4A 0 080 00F C5248020
                                               ; 2E4E from 2E3A (DD1,080,00F)
label_2e4e:     RT                             ; 2E4E 0 080 00F 01


;********************************************************************************************
;calculates values for RAM ACh and ADh based on ADCR7 (TPS)

                ;2E4F from 057E
                ;A has ADCR7
                ;DP has ach

label_2e4f:     ST      A, er0                 ; 2E4F 1 108 20E 88

                CMPB    r1, #0fah				;if low byte of ADCR7>250
                JGT     label_2e5f             ; 2E53 1 108 20E C80A
                CMPB    r1, #005h				;or if lb of adcr7<5 then jump
                JLT     label_2e5f             ; 2E58 1 108 20E CA05
                RB      off(0012ch).2          ; no error so 12c.2 = 0 (no TPS code)
                SJ      label_2e72             ; 2E5D 1 108 20E CB13
                                               ; 2E5F from 2E53 (DD1,108,20E)
                                               ; 2E5F from 2E58 (DD1,108,20E)

                ;error catching?? ADCR7 is outside of accepted values
label_2e5f:     SB      off(0012ch).2			  ; BAD! SET TPS CODE
                JBR     off(00130h).6, label_2e6b ;if no TPS code  then leave ram0ach alone and set 12ch.2
                RB      off(0012ch).2			  ;no error, set 12ch.2 to 0
                                               ; 2E68 from 2E72 (DD1,080,1AB)
label_2e68:     MOVB    [DP], #02bh            ; move safe vals in there
                                               ; 2E6B from 2E75 (DD1,080,1AB)
                                               ; 2E6B from 2E62 (DD1,108,20E)
label_2e6b:     INC     DP                     ; adh
                MOVB    [DP], #080h            ; move safe vals in there
                RC                             ; no carry
                SJ      label_2eac             ; return with carry == 0 and ram0adh == 80h
                ;end error catching

                                               ; 2E72 from 1A48 (DD1,080,1AB)
                ; 2E72 from 2E5D because 5 <= ADCR7 <= 250
label_2e72:     JBS     off(TM0).6, label_2e68 ; if this is set then error, set ach and adh to safe values and return
                JBS     off(P4).2, label_2e6b  ; if this is set then error, set only adh to safe value and return
                CMP     A, #06db6h             ; compare adcr7 to 6db6h
                JGE     label_2e81             ; if tps > 6db6h jump
                SLL     A                      ; else A *= 2
                CLRB    A                      ; AL = 0
                SJ      label_2e85             ;
                                               ; 2E81 from 2E7B (DD1,080,1AB)
label_2e81:     SRL     A                      ; A/=2
                SRL     A                      ; A/=2
                LB      A, #0c0h               ; load c0h into AL
                                               ; 2E85 from 2E7F (DD0,080,1AB)
label_2e85:     ADDB    A, ACCH                ; AL = AH + (0 or c0h)
                STB     A, r0                  ; AL -> r0
                XCHGB   A, [DP]                ; put the new val into 0ach, then get on w/ calculating a value for 0adh
                XCHGB   A, r0                  ; put 0ach's oldval into r0
                SUBB    A, r0                  ; AL = 0ach new val - 0ach old val
                MB      PSWL.4, C              ; if the old val is > new set pswl.4 to 1
                ADDB    A, #080h               ; add 80h onto the subtraction result
                RB      PSWL.4                 ; pswl.4 = 0
                JEQ     label_2e9b             ; if 0ach old was < 0ach new jump
                JLT     label_2e9f             ; else if  0ach old > 0ach new jump
                CLRB    A                      ; AL = 0, does it ever get here? does it matter?
                SJ      label_2e9f             ; 2E99 0 080 1AB CB04
                                               ; 2E9B from 2E94 (DD0,080,1AB)
label_2e9b:     JGE     label_2e9f             ; 2E9B 0 080 1AB CD02
                LB      A, #0ffh               ; more error stuff
                                               ; 2E9F from 2E96 (DD0,080,1AB)
                                               ; 2E9F from 2E99 (DD0,080,1AB)
                                               ; 2E9F from 2E9B (DD0,080,1AB)
label_2e9f:     STB     A, r0                  ; store the val for adh into r0
                INC     DP                     ; DP ++
                XCHGB   A, [DP]                ; AL <-> [adh]
                CMPB    r0, A                  ; carry if new adh value is lower than old adh value
                RB      r0.7                   ; 2EA5 0 080 1AB 200F
                JEQ     label_2eac             ; 2EA7 0 080 1AB C903
                XORB    PSWH, #080h            ; 2EA9 0 080 1AB A2F080
                                               ; 2EAC from 2E70 (DD1,108,20E)
                                               ; 2EAC from 2EA7 (DD0,080,1AB)
label_2eac:     RT                             ; 2EAC 1 108 20E 01
;end function with adcr7

;***********************************************************************************
                ; 2EAD from 22E7 usp = a4h iat calc from 99h
                ; 2EAD from 23FF usp = a3h water temp calc from 98h


label_2ead:     LB      A, (00099h-000a4h)[USP] ; 2EAD 0 080 0A4 F3F5
                SUBB    A, (000a4h-000a4h)[USP] ; 2EAF 0 080 0A4 C300A2
                JGE     label_2eb8             ; 2EB2 0 080 0A4 CD04
                ADDB    A, #002h               ; 2EB4 0 080 0A4 8602
                SJ      label_2eba             ; 2EB6 0 080 0A4 CB02
                                               ; 2EB8 from 2EB2 (DD0,080,0A4)
label_2eb8:     SUBB    A, #002h               ; 2EB8 0 080 0A4 A602
                                               ; 2EBA from 2EB6 (DD0,080,0A4)
label_2eba:     JGE     label_2ebd             ; 2EBA 0 080 0A4 CD01
                CLRB    A                      ; 2EBC 0 080 0A4 FA
                                               ; 2EBD from 2EBA (DD0,080,0A4)
label_2ebd:     ADDB    A, (000a4h-000a4h)[USP] ; 2EBD 0 080 0A4 C30082
                STB     A, (000a4h-000a4h)[USP] ; 2EC0 0 080 0A4 D300
                RT                             ; 2EC2 0 080 0A4 01



                                               ; 2EC3 from 189C (DD0,080,213)
                                               ; 2EC3 from 2402 usp = a3h
label_2ec3:     ADDB    A, #005h               ; 2EC3 0 080 213 8605
                JGE     label_2ec9             ; 2EC5 0 080 213 CD02
                LB      A, #0ffh               ; 2EC7 0 080 213 77FF
                                               ; 2EC9 from 2EC5 (DD0,080,213)
label_2ec9:     JBS     off(0001eh).5, label_2ed4 ; 2EC9 0 080 213 ED1E08
                JBS     off(0001eh).7, label_2ed4 ; 2ECC 0 080 213 EF1E05
                CMPB    A, 0f6h                ; 2ECF 0 080 213 C5F6C2
                JGE     label_2edc             ; 2ED2 0 080 213 CD08
                                               ; 2ED4 from 2EC9 (DD0,080,213)
                                               ; 2ED4 from 2ECC (DD0,080,213)
label_2ed4:     MOVB    r0, #042h              ; 2ED4 0 080 213 9842
                CMPB    A, r0                  ; 2ED6 0 080 213 48
                JGE     label_2eda             ; 2ED7 0 080 213 CD01
                LB      A, r0                  ; 2ED9 0 080 213 78
                                               ; 2EDA from 2ED7 (DD0,080,213)
label_2eda:     STB     A, 0f6h                ; 2EDA 0 080 213 D5F6
                                               ; 2EDC from 2ED2 (DD0,080,213)
label_2edc:     RT                             ; 2EDC 0 080 213 01

;*************************************************************************************

                                               ; 2EDD from 1E89 (DD1,080,26A)
label_2edd:     SUB     A, (0026ah-0026ah)[USP] ; 2EDD 1 080 26A B300A2
                MB      PSWL.4, C              ; 2EE0 1 080 26A A33C
                JGE     label_2ee7             ; 2EE2 1 080 26A CD03
                ST      A, er1                 ; 2EE4 1 080 26A 89
                CLR     A                      ; 2EE5 1 080 26A F9
                SUB     A, er1                 ; 2EE6 1 080 26A 29
                                               ; 2EE7 from 2EE2 (DD1,080,26A)
label_2ee7:     MUL                            ; 2EE7 1 080 26A 9035
                RB      PSWL.4                 ; 2EE9 1 080 26A A30C
                JNE     label_2ef5             ; 2EEB 1 080 26A CE08
                ADD     (00266h-0026ah)[USP], A ; 2EED 1 080 26A B3FC81
                L       A, er1                 ; 2EF0 1 080 26A 35
                ADC     (0026ah-0026ah)[USP], A ; 2EF1 1 080 26A B30091
                RT                             ; 2EF4 1 080 26A 01
                                               ; 2EF5 from 2EEB (DD1,080,26A)
label_2ef5:     SUB     (00266h-0026ah)[USP], A ; 2EF5 1 080 26A B3FCA1
                L       A, er1                 ; 2EF8 1 080 26A 35
                SBC     (0026ah-0026ah)[USP], A ; 2EF9 1 080 26A B300B1
                RT                             ; 2EFC 1 080 26A 01

;***************************************************************************************

;this pretty much follows the A value around, but slowly.
; so if [dp] was 0 and A was dfh it would take a few iterations (6 in the case of the b2h calc)
; for DP to get really close to [A].

;[DP] = ([DP] - [DP]*er0/10000h) + (A*er0/10000h)

                ; 2EFD from 053F AH = [b4h] AL = 0 dp = 0b2h, er0 = er1 = 08000h or 04000h; map sensor calcs
                ; 2EFD from 0576  map sensor calcs
                ; 2EFD from 1A86 dp = 0f2h, er0 = 0



                                               ; 2EFD from 1A22 (DD1,080,21E)
                                               ; 2EFD from 29EF (DD1,080,132)
                                               ; 2EFD from 0FE4 (DD1,108,13D)
label_2efd:     MUL                            ; er1A = A*er0
                MOV     er2, er1               ; er2 = er1A/10000h;
                L       A, [DP]                ; A = [DP]
                MUL                            ; er1A = [DP]*er0
                L       A, [DP]                ; load [DP] again
                SUB     A, er1                 ; A = [DP] - [DP]*er0/10000h
                ADD     A, er2                 ; A = ([DP] - [DP]*er0/10000h) +
                ST      A, [DP]                ; [DP] = ([DP] - [DP]*er0/10000h) + (A*er0/10000h)
                RT                             ; 2F08 1 108 20E 01

;***************************************************************************************



                DB  0E2h ; 2F09

                ;just adds er3 to A

                ;if (A >= 128){
                ; A+= er3
                ; if(A>ffffh)
                ;  A = 0
                ; er3 = A
                ; return
                ;}else{
                ; A+= er3
                ; if(A>ffffh)
                ;  A = ffffh
                ; er3 = A
                ; return
                ;}
                                               ; 2F0A from 3005 (DD1,080,0A3)
                                               ; 2F0A from 300B (DD1,080,0A3)
                                               ; 2F0A from 300E (DD1,080,0A3)
                                               ; 2F0A from 3017 (DD1,080,0A3)
                                               ; 2F0A from 1F71 (DD1,080,213)
                                               ; 2F0A from 1F74 (DD1,080,213)
                                               ; 2F0A from 1F62 (DD1,080,213)
                                               ; 2F0A from 1F65 (DD1,080,213)
                                               ; 2F0A from 1E27 (DD1,080,213)
                                               ; 2F0A from 1266 (DD1,108,13D)
                                               ; 2F0A from 145F (DD1,108,13D)
                                               ; 2F0A from 1462 (DD1,108,13D)
                                               ; 2F0A from 1466 (DD1,108,13D)
                                               ; 2F0A from 146A (DD1,108,13D)
vcal_5:         L       A, ACC                 ; to word
                MB      C, ACCH.7              ;
                JLT     label_2f19             ;
                ADD     A, er3                 ; 2F11 1 080 0A3 0B
                JGE     label_2f1d             ; 2F12 1 080 0A3 CD09
                L       A, #0ffffh             ; 2F14 1 080 0A3 67FFFF
                SJ      label_2f1d             ; 2F17 1 080 0A3 CB04
                                               ; 2F19 from 2F0F (DD1,080,0A3)
label_2f19:     ADD     A, er3                 ; 2F19 1 080 0A3 0B
                JLT     label_2f1d             ; 2F1A 1 080 0A3 CA01
                CLR     A                      ; 2F1C 1 080 0A3 F9
                                               ; 2F1D from 2F12 (DD1,080,0A3)
                                               ; 2F1D from 2F17 (DD1,080,0A3)
                                               ; 2F1D from 2F1A (DD1,080,0A3)
label_2f1d:     ST      A, er3                 ; 2F1D 1 080 0A3 8B
                RT                             ; 2F1E 1 080 0A3 01
                                               ; 2F1F from 250E (DD0,080,0A3)
                                               ; 2F1F from 0E05 (DD0,108,13D)
;****************************************************************************
               ;o2 sensor routines
label_2f1f:     LB      A, ADCR2H              ; 2F1F 0 080 0A3 F565
                STB     A, 0a1h                ; 2F21 0 080 0A3 D5A1
                STB     A, r6                  ; 2F23 0 080 0A3 8E
                MOV     DP, #0011bh            ; 2F24 0 080 0A3 621B01
                MOV     USP, #00180h           ; 2F27 0 080 180 A1988001
                CLR     X2                     ; 2F2B 0 080 180 9115
                LB      A, off(0130h)          ; load lowest cel bits
                ANDB    A, #003h               ; get o2 bits
                STB     A, r7                  ; store into r7
                LB      A, off(0132h)          ; get highest
                ANDB    A, #0c0h               ; get code 23 and 24
                ORB     r7, A                  ; put them both in r7
                RT                             ; 2F38 0 080 180 01
                                               ; 2F39 from 2514 (DD0,080,0A3)
                                               ; 2F39 from 0E13 (DD0,108,13D)
label_2f39:     LB      A, ADCR3H              ; 2F39 0 080 0A3 F567
                STB     A, 0a2h                ; 2F3B 0 080 0A3 D5A2
                STB     A, r6                  ; 2F3D 0 080 0A3 8E
                INC     DP                     ; 2F3E 0 080 0A3 72
                INC     USP                    ; 2F3F 0 080 0A4 A116
                INC     X2                     ; 2F41 0 080 0A4 71
                INC     X2                     ; 2F42 0 080 0A4 71
                RORB    r7                     ; 2F43 0 080 0A4 27C7
                RT                             ; 2F45 0 080 0A4 01
               ;end o2 sensor routines
                                               ; 2F46 from 2511 (DD0,080,0A3)
                                               ; 2F46 from 2517 (DD0,080,0A3)
;****************************************************************************
               ;called only after each of the o2 sensor routines above
               ;DP at 11Bh for 1st o2, and 11Ch for 2nd o2 sensor
               ;USP at 180h for 1st o2, 181h for 2nd o2
               ;x2 has 0 for 1st o2 and 2 for 2nd o2
label_2f46:     CMPB    0a4h, #0a7h            ; iat check
                LB      A, #030h               ; 2F4A 0 080 0A3 7730
                JGE     label_2f55             ; if colder than 4096/#a7h jump
                LB      A, #03bh               ; else load #3bh
                JBR     off(00124h).3, label_2f55  ;
                LB      A, #062h               ;
                                               ; 2F55 from 2F4C (DD0,080,0A3)
                                               ; 2F55 from 2F50 (DD0,080,0A3)
label_2f55:     CMPB    0a3h, A                ; water temp check
                MB      off(0011eh).1, C       ; if hotter than A, set this bit
                LB      A, off(001ceh)         ; load 1ceh
                JNE     label_2f91             ; if ceh != 0, dont correct
                MB      C, [DP].3              ;
                JLT     label_2f87             ; if [dp].3 = 1, jump. this is good
                MB      C, [DP].4              ;
                JGE     label_2f6f             ; if [dp].4 == 0, check if lean. this is good too.
                JBS     off(0011fh).5, label_2f91 ; dont correct
                JBR     off(0011ch).7, label_2f91 ; dont correct
                RB      [DP].4                 ; this is good
                                               ; 2F6F from 2F65 (DD0,080,0A3)
label_2f6f:     CMPB    r6, #01ah				;compare current o2 sensor to #1ah

				;does r6<1ah mean its lean??
                JLT     label_2f81             ; to disable o2 sensors we change this to: SJ    label_2f91

                JBR     off(0011eh).1, label_2f91 ;if bit == 0;
                JBS     off(0011fh).5, label_2f91 ;if bit == 1;
                JBR     off(0011ch).7, label_2f91 ;if bit == 0;
                LB      A, (001e5h-001a3h)[USP] ; load ??
                JNE     label_2fd4             ; if it != 0 return
                                               ; 2F81 from 2F72 (DD0,080,0A3)
label_2f81:     MOVB    (001fdh-001a3h)[USP], #032h ; 1dah or 1dbh
                SB      [DP].3                 ; 2F85 0 080 0A3 C21B
                                               ; 2F87 from 2F61 (DD0,080,0A3)
label_2f87:     JBS     off(0120h).6, label_2f93  ; this continues program flow
                LB      A, off(001dch)         ; 2F8A 0 080 0A3 F4DC
                JNE     label_2f91             ; if dc !=0 return with #96 in 1c2h or 1c3h
                ANDB    [DP], #0e7h            ; and 11bh or 11ch with 11100111b; [DP].3 = [DP].4 = 0

                ;if here from jump we dont correct??
                                               ; 2F91 from 2F5D (DD0,080,0A3)
                                               ; 2F91 from 2F67 (DD0,080,0A3)
                                               ; 2F91 from 2F6A (DD0,080,0A3)
                                               ; 2F91 from 2F74 (DD0,080,0A3)
                                               ; 2F91 from 2F77 (DD0,080,0A3)
                                               ; 2F91 from 2F7A (DD0,080,0A3)
                                               ; 2F91 from 2F8C (DD0,080,0A3)
label_2f91:     SJ      label_2fd0             ; 2F91 0 080 0A3 CB3D


                                               ; 2F93 from 2F87 (DD0,080,0A3)
label_2f93:     MOVB    off(001dch), #032h     ; move #32h into dch
                MOV     A, USP                 ;
                MOV     X1, A                  ; X1 = USP = 180h or 181h
                MOVB    r0, #00ah              ; r0 = #ah
                MB      C, 0feh.6              ;
                JLT     label_2fbe             ; if feh.6 check to see if rich
                INC     X1                     ;
                INC     X1                     ; X1 = 182h or 183h
                MOVB    r0, #00dh              ; r0 = #dh
                JBS     off(0011fh).5, label_2fae ; 2FA5 1 080 0A3 ED1F06
                MOVB    (001eah-001a3h)[USP], #00ah ; 1c7h or 1c8h
                SJ      label_2fc3             ; 2FAC 1 080 0A3 CB15
                                               ; 2FAE from 2FA5 (DD1,080,0A3)
label_2fae:     CMP     00162h[X2], #0ae20h    ; 162h or 164h
                JGE     label_2fcc             ; 2FB4 1 080 0A3 CD16
                CMP     00162h[X2], #05b60h    ; 2FB6 1 080 0A3 B16201C0605B
                JLE     label_2fcc             ; 2FBC 1 080 0A3 CF0E
                                               ; 2FBE from 2F9F (DD1,080,0A3)
label_2fbe:     CMPB    r6, #01eh              ;
                JGE     label_2fc7             ; does this mean its rich??
                                               ; 2FC3 from 2FAC (DD1,080,0A3)
label_2fc3:     LB      A, r0                  ; 2FC3 0 080 0A3 78
                STB     A, 00047h[X1]          ; 1c9 or 1cA
                                               ; 2FC7 from 2FC1 (DD1,080,0A3)
label_2fc7:     LB      A, 00047h[X1]          ; 2FC7 0 080 0A3 F04700
                JNE     label_2fd0             ; 2FCA 0 080 0A3 CE04

                ;this seems to be bad
                ;dp = 11bh or 11ch
                                               ; 2FCC from 2FB4 (DD1,080,0A3)
                                               ; 2FCC from 2FBC (DD1,080,0A3)
label_2fcc:     RB      [DP].3                 ; 2FCC 0 080 0A3 C20B
                SB      [DP].4                 ; 2FCE 0 080 0A3 C21C

                ;USP at 180h for 1st o2, 181h for 2nd o2
                                               ; 2FD0 from 2F91 (DD0,080,0A3)
                                               ; 2FD0 from 2FCA (DD0,080,0A3)
label_2fd0:     MOVB    (001e5h-001a3h)[USP], #096h ; load 96h into 1c2h or 1c3h
                                               ; 2FD4 from 2F7F (DD0,080,0A3)
label_2fd4:     RT                             ; 2FD4 0 080 0A3 01
;end\

;*********************************************************************************

;another routine for the o2s
;er0 has #0ae20h <-- upper limit
;er1 has #05b60h <-- lower limit
;all this routine does is make sure that [162h] or [164h] is between er0 and er1.
                                               ; 2FD5 from 252D (DD1,080,0A3)
                                               ; 2FD5 from 0FA9 (DD1,108,13D)
label_2fd5:     CMP     er0, A                 ; 2FD5 1 080 0A3 44C1
                JGE     label_2fdb             ; 2FD7 1 080 0A3 CD02
                L       A, er0                 ; 2FD9 1 080 0A3 34
                RT                             ; 2FDA 1 080 0A3 01
                                               ; 2FDB from 2FD7 (DD1,080,0A3)
label_2fdb:     CMP     A, er1                 ; 2FDB 1 080 0A3 49
                JGE     label_2fdf             ; 2FDC 1 080 0A3 CD01
                L       A, er1                 ; 2FDE 1 080 0A3 35
                                               ; 2FDF from 2FDC (DD1,080,0A3)
label_2fdf:     RT                             ; 2FDF 1 080 0A3 01

;*********************************************************************************
;15dh
; simple ECT correction??
                                               ; 2FE0 from 0A16 (DD1,108,13D)
                                               ; 2FE0 from 1115 (DD0,108,13D)
label_2fe0:     LB      A, 0a3h                ; 2FE0 0 108 13D F5A3
                MOV     X1, #03707h            ; 2FE2 0 108 13D 600737
                VCAL    0                      ; 2FE5 0 108 13D 10
                STB     A, r2                  ; 2FE6 0 108 13D 8A
                LB      A, 0a3h                ; 2FE7 0 108 13D F5A3
                MOV     X1, #036f7h            ; 2FE9 0 108 13D 60F736
                VCAL    0                      ; 2FEC 0 108 13D 10
                SUBB    A, r2                  ; 2FED 0 108 13D 2A
                JGE     label_2ff1             ; 2FEE 0 108 13D CD01
                CLRB    A                      ; 2FF0 0 108 13D FA
                                               ; 2FF1 from 2FEE (DD0,108,13D)
label_2ff1:     STB     A, off(0015dh)         ; 2FF1 0 108 13D D45D
                RT                             ; 2FF3 0 108 13D 01

;**********************************************************************************
                                               ; 2FF4 from 1CFD (DD0,080,213)
                                               ; 2FF4 from 1D07 (DD1,080,213)
                                               ; 2FF4 from 1D32 (DD0,080,213)
                                               ; 2FF4 from 1E98 (DD1,080,213)
                                               ; 2FF4 from 1CBF (DD0,080,213)
                                               ; 2FF4 from 1DAE (DD1,080,213)
                                               ; 2FF4 from 1D29 (DD1,080,213)
label_2ff4:     CLR     A                      ; 2FF4 1 080 213 F9
                JBS     off(P2).6, label_3000  ; 2FF5 1 080 213 EE2408
                MOV     er3, #00580h           ; 2FF8 1 080 213 47988005
                                               ; 2FFC from 24A6 (DD1,080,0A3)
label_2ffc:     L       A, off(PWMR1)          ; 2FFC 1 080 0A3 E476
                SJ      label_3005             ; 2FFE 1 080 0A3 CB05
                                               ; 3000 from 248C (DD1,080,0A3)
                                               ; 3000 from 2FF5 (DD1,080,213)
                                               ; 3000 from 1D78 (DD1,080,213)
label_3000:     ST      A, er3                 ; 3000 1 080 0A3 8B
                MOV     DP, #0026ah            ; 3001 1 080 0A3 626A02
                L       A, [DP]                ; 3004 1 080 0A3 E2
                                               ; 3005 from 2FFE (DD1,080,0A3)
label_3005:     VCAL    5                      ; 3005 1 080 0A3 15
                JBS     off(P2SF).1, label_300c ; 3006 1 080 0A3 E92603
                SCAL    label_301b             ; 3009 1 080 0A3 3110
                VCAL    5                      ; 300B 1 080 0A3 15
                                               ; 300C from 3006 (DD1,080,0A3)
                                               ; 300C from 1E71 (DD1,080,26A)
label_300c:     L       A, off(00084h)         ; 300C 1 080 0A3 E484
                VCAL    5                      ; 300E 1 080 0A3 15
                MB      C, P0.1                ; 300F 1 080 0A3 C52029
                JGE     label_3018             ; 3012 1 080 0A3 CD04
                L       A, #00000h             ; 3014 1 080 0A3 670000
                VCAL    5                      ; 3017 1 080 0A3 15
                                               ; 3018 from 3012 (DD1,080,0A3)
label_3018:     VCAL    7                      ; 3018 1 080 0A3 17
                ST      A, er3                 ; 3019 1 080 0A3 8B
                RT                             ; 301A 1 080 0A3 01

;********************************************************************************
                                               ; 301B from 1D23 (DD1,080,213)
                                               ; 301B from 3009 (DD1,080,0A3)
label_301b:     J       label_32e5             ; 301B 1 080 213 03E532
				;32e5:
				;L       A, #08000h             ; 32E5 1 080 213 670080
                ;JBR     off(00027h).5, label_32f1 ; 32E8 1 080 213 DD2706
                ;JBS     off(00027h).7, label_32f1 ; 32EB 1 080 213 EF2703
                ;L       A, #05a00h             ; 32EE 1 080 213 67005A
                ;label_32f1:
				;J       label_301e             ; 32F1 1 080 213 031E30
                                               ; 301E from 32F1 (DD1,080,213)
                                               ; 301E from 1E6B (DD1,080,26A)
label_301e:     ST      A, er0                 ; 301E 1 080 213 88
                L       A, off(0008ah)         ; 301F 1 080 213 E48A
                SLL     A                      ; 3021 1 080 213 53
                MUL                            ; 3022 1 080 213 9035
                L       A, er1                 ; 3024 1 080 213 35
                RT                             ; 3025 1 080 213 01

;********************************************************************************
                                               ; 3026 from 3223 (DD1,080,213)
                                               ; 3026 from 1D02 (DD1,080,213)
                                               ; 3026 from 1EDE (DD1,080,213)
                                               ; 3026 from 1DBA (DD1,080,213)
                                               ; 3026 from 1E17 (DD1,080,213)
                                               ; 3026 from 1E3C (DD1,080,213)
vcal_6:         JLT     label_302d             ; 3026 1 080 213 CA05
                                               ; 3028 from 3018 (DD1,080,0A3)
                                               ; 3028 from 1F75 (DD1,080,213)
vcal_7:         CMP     A, #01bffh             ; 3028 1 080 213 C6FF1B
                JLT     label_3030             ; 302B 1 080 213 CA03
                                               ; 302D from 3026 (DD1,080,213)
label_302d:     L       A, #01bffh             ; 302D 1 080 213 67FF1B
                                               ; 3030 from 302B (DD1,080,213)
label_3030:     RT                             ; 3030 1 080 213 01

;*******************************************************************************

                                               ; 3031 from 322F (DD1,080,213)
                                               ; 3031 from 1E43 (DD1,080,213)
label_3031:     CMP     off(0008eh), A         ; 3031 1 080 213 B48EC1
                JGE     label_3039             ; 3034 1 080 213 CD03
                L       A, off(0008eh)         ; 3036 1 080 213 E48E
                RT                             ; 3038 1 080 213 01
                                               ; 3039 from 3034 (DD1,080,213)
label_3039:     CMP     A, off(00090h)         ; 3039 1 080 213 C790
                JGE     label_303f             ; 303B 1 080 213 CD02
                L       A, off(00090h)         ; 303D 1 080 213 E490
                                               ; 303F from 303B (DD1,080,213)
label_303f:     RT                             ; 303F 1 080 213 01



;*********************************************************************************
;this function sets the error code bits
;r6 contains the code!!!
                ; 3040 from 0097 (DD0,100,???)
                ; 3040 from 28AF for all codes EXCEPT code 1 and 2 (o2 codes)
label_3040:     CLR     A                      ; 3040 1 100 ??? F9
                LB      A, r6                   ; r6 = 1 - 8 for 130h
												; r6 = 9 - 16 for 131h
												; r6 = 17 - 24 for 132h

                SUBB    A, #001h               ; r6-1
                MOVB    r0, #008h              ;
                DIVB                           ; (r6-1)/8
                MOV     X1, A                  ; this is which byte to put it in to
                LB      A, r1                  ; A gets remainder
                SBR     00130h[X1]             ; set [X1 + 130h].A
                SBR     0027bh[X1]             ; do the same for [27bh+x1]

                ; 3052 from 00A1 (DD0,100,???)
label_3052:     MOV     DP, #0027bh            ;
                CLR     er0                    ;

                ;loop
                ;if there are no codes this will be 0
label_3057:     LB      A, r0                  ;
                ADDB    A, [DP]                ;
                STB     A, r0                  ; r0 += [dp]

                ;r0 = r0 xor [dp]
                ;if there are any codes they will show up here
                ;uness they are the same bit position
                LB      A, r1                  ;
                XORB    A, [DP]                ;
                STB     A, r1                  ;

                INC     DP                     ;
                CMP     DP, #0027eh            ;
                JNE     label_3057             ; loop while dp<27eh
                ;end loop

                L       A, er0                 ;
                ST      A, [DP]                ; 27eh = r1|r0
                RT
;**************************************************************************



                                               ; 3069 from 2036 (DD0,080,1C1)
                                               ; 3069 from 2040 (DD0,080,1C1)
                                               ; 3069 from 3099 (DD0,080,1C1)
label_3069:     LCB     A, [X1]                ; 3069 0 080 1C1 90AA
                JNE     label_3072             ; 306B 0 080 1C1 CE05
                CMPB    0a6h, #003h            ; 306D 0 080 1C1 C5A6C003
                ROLB    A                      ; 3071 0 080 1C1 33
                                               ; 3072 from 306B (DD0,080,1C1)
label_3072:     ADDB    A, [DP]                ; 3072 0 080 1C1 C282
                INC     X1                     ; 3074 0 080 1C1 70
                CMPCB   A, [X1]                ; 3075 0 080 1C1 90AE
                JLT     label_307b             ; 3077 0 080 1C1 CA02
                LCB     A, [X1]                ; 3079 0 080 1C1 90AA
                                               ; 307B from 3077 (DD0,080,1C1)
label_307b:     STB     A, [DP]                ; 307B 0 080 1C1 D2
                LB      A, r6                  ; 307C 0 080 1C1 7E
                JBR     off(ACCH).0, label_308d ; 307D 0 080 1C1 D8070D
                SUBB    A, 0e8h                ; 3080 0 080 1C1 C5E8A2
                JNE     label_3087             ; 3083 0 080 1C1 CE02
                STB     A, 0e8h                ; 3085 0 080 1C1 D5E8
                                               ; 3087 from 3083 (DD0,080,1C1)
label_3087:     CMP     DP, #001bah            ; 3087 0 080 1C1 92C0BA01
                SJ      label_3096             ; 308B 0 080 1C1 CB09
                                               ; 308D from 307D (DD0,080,1C1)
label_308d:     JLT     label_3092             ; 308D 0 080 1C1 CA03
                RBR     0fdh                   ; 308F 0 080 1C1 C5FD12
                                               ; 3092 from 308D (DD0,080,1C1)
label_3092:     CMP     DP, #000ebh            ; 3092 0 080 1C1 92C0EB00
                                               ; 3096 from 308B (DD0,080,1C1)
label_3096:     INC     X1                     ; 3096 0 080 1C1 70
                INC     DP                     ; 3097 0 080 1C1 72
                INCB    r6                     ; 3098 0 080 1C1 AE
                JLT     label_3069             ; 3099 0 080 1C1 CACE
                RT                             ; 309B 0 080 1C1 01

;******************************************************************************

;big countdown
                                               ; 309C from 192F (DD0,080,1AB)
                                               ; 309C from 30A5 (DD0,080,1AC)
                                               ; 309C from 1F88 (DD0,080,1CE)
                                               ; 309C from 201B (DD0,080,1C1)
label_309c:     LB      A, (001abh-001abh)[USP] ; 309C 0 080 1AB F300
                JEQ     label_30a3             ; 309E 0 080 1AB C903
                DECB    (001abh-001abh)[USP]   ; 30A0 0 080 1AB C30017
                                               ; 30A3 from 309E (DD0,080,1AB)
label_30a3:     INC     USP                    ; 30A3 0 080 1AC A116
                JRNZ    DP, label_309c         ; 30A5 0 080 1AC 30F5
                RT                             ; 30A7 0 080 1AC 01
;*******************************************************************************

                                               ; 30A8 from 1925
                                               ; 30A8 from 2912 (DD1,080,132)
label_30a8:     LB      A, #03ch               ; 30A8 0 080 213 773C
                STB     A, WDT                 ; 30AA 0 080 213 D511
                SWAPB                          ; 30AC 0 080 213 83
                STB     A, WDT                 ; 30AD 0 080 213 D511
                LB      A, 0fdh                ; 30AF 0 080 213 F5FD
                ANDB    A, #003h               ; 30B1 0 080 213 D603
                JNE     label_30b9             ; 30B3 0 080 213 CE04
                XORB    P4, #001h              ; 30B5 0 080 213 C52CF001
                                               ; 30B9 from 30B3 (DD0,080,213)
label_30b9:     RT                             ; 30B9 0 080 213 01
;******************************************************************************

                                               ; 30BA from 20CE (DD1,080,220)
                                               ; 30BA from 20D4 (DD1,080,220)
label_30ba:     MOV     X2, A                  ; 30BA 1 080 220 51
                AND     IE, #00080h            ; 30BB 1 080 220 B51AD08000
                RB      PSWH.0                 ; 30C0 1 080 220 A208
                XCHG    A, 00082h[X1]          ; 30C2 1 080 220 B0820010
                XCHG    A, 00082h[X1]          ; 30C6 1 080 220 B0820010
                ST      A, er0                 ; 30CA 1 080 220 88
                SB      PSWH.0                 ; 30CB 1 080 220 A218
                L       A, 0cch                ; 30CD 1 080 220 E5CC
                ST      A, IE                  ; 30CF 1 080 220 D51A
                L       A, er0                 ; 30D1 1 080 220 34
                CMP     A, X2                  ; 30D2 1 080 220 91C2
                JEQ     label_30e1             ; 30D4 1 080 220 C90B
                MOVB    0f0h, #042h            ; 30D6 1 080 220 C5F09842
                DECB    0ebh                   ; 30DA 1 080 220 C5EB17
                JNE     label_30e0             ; 30DD 1 080 220 CE01
                BRK                            ; 30DF 1 080 220 FF
                                               ; 30E0 from 30DD (DD1,080,220)
label_30e0:     L       A, X2                  ; 30E0 1 080 220 41
                                               ; 30E1 from 30D4 (DD1,080,220)
label_30e1:     RT                             ; 30E1 1 080 220 01

;******************************************************************************

                                               ; 30E2 from 2569 (DD1,080,0A3)
                                               ; 30E2 from 2132 (DD1,080,220)
label_30e2:     LB      A, #000h               ; 30E2 0 080 0A3 7700
                STB     A, 0e3h                ; 30E4 0 080 0A3 D5E3
                STB     A, off(0019ah)         ; 30E6 0 080 0A3 D49A
                CLRB    0e5h                   ; 30E8 0 080 0A3 C5E515
                                               ; 30EB from 26CC (DD1,080,205)
label_30eb:     MOVB    off(00199h), #005h     ; 30EB 0 080 0A3 C4999805
                MOVB    0e7h, #004h            ; 30EF 0 080 0A3 C5E79804
                RT                             ; 30F3 0 080 0A3 01
;****************************************************************************

               ; 30F4 from 0322 A has P1
                                               ; 30F4 from 1BA4 (DD0,080,1AB)
label_30f4:     RB      PSWL.5                 ; 30F4 0 ??? ??? A30D
                STB     A, ACCH                ; 30F6 0 ??? ??? D507
                AND     IE, #00080h            ; 30F8 0 ??? ??? B51AD08000
                RB      PSWH.0                 ; 30FD 0 ??? ??? A208
                LB      A, P2                  ; 30FF 0 ??? ??? F524
                SLLB    A                      ; 3101 0 ??? ??? 53
                SWAPB                          ; 3102 0 ??? ??? 83
                STB     A, LRBH                ; 3103 0 ??? ??? D503
                LB      A, ACCH                ; 3105 0 ??? ??? F507
                STB     A, [DP]                ; 3107 0 ??? ??? D2
                LB      A, [DP]                ; 3108 0 ??? ??? F2
                CLR     LRB                    ; 3109 0 ??? ??? A415
                SB      PSWH.0                 ; 310B 0 ??? ??? A218
                MOV     off(07ff1ah), 0cch     ; 310D 0 ??? ??? B5CC7C1A
                RT                             ; 3111 0 ??? ??? 01
                                               ; 3112 from 1AC4 (DD0,080,1AB)
;*****************************************************************************


                ; 3112 from 1ADE, r0 = 0, r1 = 2, r2 = temp, r3 = ?, X1 = , DP =
                ; 3112 from 1AE8, r1 = 2, r2 = speed, r3 = ?, X1 = , DP =
                ; 3112 from 1AF0, r1 = 2, r2 = rpm
                                               ; 3112 from 24D1 (DD0,080,0A3)
                                               ; 3112 from 312B (DD0,080,1AB)

label_3112:     LB      A, r0                  ; 3112 0 080 1AB 78
                MBR     C, [DP]       			;bit (#from AL) in [DP]
                LC      A, [X1]                ; 3115 0 080 1AB 90A8
                JLT     label_311b    			;does the bit [dp].R0 tell us what info to do calcs on?
                LB      A, ACCH       			;if C == 1 then load the byte in AH
                                               ; 311B from 3117 (DD0,080,1AB)
label_311b:     MB      C, PSWL.4              ; MB pswl.4 int C

				;if C==0 then r2-A else A-r2
                JLT     label_3122             ; 311D 0 080 1AB CA03
                CMPB    A, r2                  ; 311F 0 080 1AB 4A
                SJ      label_3124             ; 3120 0 080 1AB CB02
                                               ; 3122 from 311D (DD0,080,1AB)
label_3122:     CMPB    r2, A                  ; 3122 0 080 1AB 22C1
                                               ; 3124 from 3120 (DD0,080,1AB)
label_3124:     LB      A, r0                  ; 3124 0 080 1AB 78
                MBR     [DP], C                ; 3125 0 080 1AB C220
                INC     X1                     ; 3127 0 080 1AB 70
                INC     X1                     ; 3128 0 080 1AB 70
                INCB    r0                     ; 3129 0 080 1AB A8
                DECB    r1                     ; 312A 0 080 1AB B9
                JNE     label_3112             ; 312B 0 080 1AB CEE5
                ;why loop?
                RT                             ; 312D 0 080 1AB 01
                DB  057h,009h,0E1h,000h,057h,007h,0AFh,000h ; 312E
                DB  057h,007h,06Fh,000h,057h,008h,0C8h,000h ; 3136
                DB  057h,007h,07Dh,000h,057h,006h,07Dh,000h ; 313E
                DB  04Bh,006h,000h,000h,019h,003h,04Bh,000h ; 3146
                DB  057h,00Dh,088h,0FEh,029h,002h,04Bh,000h ; 314E

;****************************************************
                                               ; 3156 from 0BC8 (DD0,108,13D)
label_3156:     LB      A, #0ffh               ; 3156 0 108 13D 77FF
                CMPB    A, 0a6h                ; 3158 0 108 13D C5A6C2
                RT                             ; 315B 0 108 13D 01
;***************************************************
                                               ; 315C from 1A9A (DD0,080,1AB)
label_315c:     MB      C, 0ffh.3              ; 315C 0 080 1AB C5FF2B
                XORB    PSWH, #080h            ; 315F 0 080 1AB A2F080
                RT                             ; 3162 0 080 1AB 01
                DB  0FFh,0F1h,050h,0F1h,028h,0DAh,010h,0C0h ; 3163
                DB  008h,0A6h,000h,080h,0FFh,097h,040h,097h ; 316B
                DB  030h,093h,018h,08Dh,004h,086h,000h,080h ; 3173
                DB  0F5h,000h,02Eh,044h,073h,028h,080h ; 317B
                                               ; 3182 from 112D (DD0,108,13D)
label_3182:     MOV     off(00166h), A         ; 3182 0 108 13D B4668A

				;74h = 01110100
				;
                LB      A, off(00130h)         ; 3185 0 108 13D F430
                ANDB    A, #074h               ; 3187 0 108 13D D674
                JNE     label_31e7             ; 3189 0 108 13D CE5C

                JBS     off(00131h).1, label_31e7 ; cyp sensor code check
                JBS     off(00132h).0, label_31e7 ; vss code
                J       label_32b3             ; 3191 0 108 13D 03B332
                DB  000h ; 3194
                                               ; 3195 from 32BD (DD0,108,13D)
label_3195:     LB      A, #010h               ; 3195 0 108 13D 7710
                JBS     off(0011dh).3, label_319c ; 3197 0 108 13D EB1D02
                LB      A, #018h               ; 319A 0 108 13D 7718
                                               ; 319C from 3197 (DD0,108,13D)
label_319c:     ;CMPB	A, #001h				;vss
				CMPB    A, 0cbh                ; 319C 0 108 13D C5CBC2
                MB      off(0011dh).3, C       ; 319F 0 108 13D C41D3B
                JLT     label_31e7             ; 31A2 0 108 13D CA43
                JBR     off(00125h).3, label_31e7 ; 31A4 0 108 13D DB2540
                CMPB    0adh, #083h            ; 31A7 0 108 13D C5ADC083
                JGE     label_31e7             ; 31AB 0 108 13D CD3A
                LB      A, 0b4h                ; 31AD 0 108 13D F5B4
                SUBB    A, 0b3h                ; 31AF 0 108 13D C5B3A2
                JLT     label_31e7             ; 31B2 0 108 13D CA33
                STB     A, r2                  ; 31B4 0 108 13D 8A
                CMPB    A, #004h               ; 31B5 0 108 13D C604
                JLT     label_31e1             ; 31B7 0 108 13D CA28
                MOV     X1, #03163h            ; 31B9 0 108 13D 606331
                VCAL    0                      ; 31BC 0 108 13D 10
                XCHGB   A, r2                  ; 31BD 0 108 13D 2210
                MOV     X1, #0316fh            ; 31BF 0 108 13D 606F31
                VCAL    0                      ; 31C2 0 108 13D 10
                MOVB    r7, r2                 ; 31C3 0 108 13D 224F
                MOV     X1, #0317bh            ; 31C5 0 108 13D 607B31
                LB      A, 0a3h                ; 31C8 0 108 13D F5A3
                CAL     label_2d5a             ; 31CA 0 108 13D 325A2D
                STB     A, r2                  ; 31CD 0 108 13D 8A
                MOV     X1, #0317eh            ; 31CE 0 108 13D 607E31
                LB      A, 0a4h                ; 31D1 0 108 13D F5A4
                VCAL    2                      ; 31D3 0 108 13D 12
                MOVB    r0, r2                 ; 31D4 0 108 13D 2248
                MULB                           ; 31D6 0 108 13D A234
                SLL     ACC                    ; 31D8 0 108 13D B506D7
                JGE     label_31e1             ; 31DB 0 108 13D CD04
                MOVB    ACCH, #0ffh            ; 31DD 0 108 13D C50798FF
                                               ; 31E1 from 31B7 (DD0,108,13D)
                                               ; 31E1 from 31DB (DD0,108,13D)
label_31e1:     LB      A, ACCH                ; 31E1 0 108 13D F507
                CMPB    A, #080h               ; 31E3 0 108 13D C680
                JGE     label_31e9             ; 31E5 0 108 13D CD02
                                               ; 31E7 from 3189 (DD0,108,13D)
                                               ; 31E7 from 318B (DD0,108,13D)
                                               ; 31E7 from 318E (DD0,108,13D)
                                               ; 31E7 from 32C0 (DD0,108,13D)
                                               ; 31E7 from 31A2 (DD0,108,13D)
                                               ; 31E7 from 31A4 (DD0,108,13D)
                                               ; 31E7 from 31AB (DD0,108,13D)
                                               ; 31E7 from 31B2 (DD0,108,13D)
label_31e7:     LB      A, #080h               ; 31E7 0 108 13D 7780
                                               ; 31E9 from 31E5 (DD0,108,13D)
label_31e9:     STB     A, off(00153h)         ; 31E9 0 108 13D D453
                J       label_1130             ; 31EB 0 108 13D 033011
                                               ; 31EE from 13BF (DD0,108,13D)
label_31ee:     LB      A, off(00153h)         ; 31EE 0 108 13D F453
                STB     A, ACCH                ; 31F0 0 108 13D D507
                CLRB    A                      ; 31F2 0 108 13D FA
                MUL                            ; 31F3 0 108 13D 9035
                MOV     er0, er1               ; 31F5 0 108 13D 4548
                SLL     ACC                    ; 31F7 0 108 13D B506D7
                ROL     er0                    ; 31FA 0 108 13D 44B7
                JGE     label_3202             ; 31FC 0 108 13D CD04
                MOV     er0, #0ffffh           ; 31FE 0 108 13D 4498FFFF
                                               ; 3202 from 31FC (DD0,108,13D)
label_3202:     LB      A, off(00159h)         ; 3202 0 108 13D F459
                JEQ     label_3209             ; 3204 0 108 13D C903
                J       label_13c3             ; 3206 0 108 13D 03C313
                                               ; 3209 from 3204 (DD0,108,13D)
label_3209:     J       label_13ce             ; 3209 0 108 13D 03CE13
                                               ; 320C from 2430 (DD0,080,0A3)
label_320c:     VCAL    0                      ; 320C 0 080 0A3 10
                STB     A, off(00097h)         ; 320D 0 080 0A3 D497
                LB      A, #080h               ; 320F 0 080 0A3 7780
                CMPB    A, ADCR1H              ; 3211 0 080 0A3 C563C2
                MB      off(P2SF).5, C         ; C=1 if #080h < ADCR1H (de-mister is on?)
                RT                             ; 3217 0 080 0A3 01
                                               ; 3218 from 1F29 (DD1,080,213)
label_3218:     CMP     A, er3                 ; 3218 1 080 213 4B
                JGE     label_321e             ; 3219 1 080 213 CD03
                J       label_1f36             ; 321B 1 080 213 03361F
                                               ; 321E from 3219 (DD1,080,213)
label_321e:     J       label_1f37             ; 321E 1 080 213 03371F
                                               ; 3221 from 1C5F (DD1,080,213)
label_3221:     JLT     label_3229             ; 3221 1 080 213 CA06
                VCAL    6                      ; 3223 1 080 213 16
                JGE     label_3229             ; 3224 1 080 213 CD03
                J       label_1c62             ; 3226 1 080 213 03621C
                                               ; 3229 from 3221 (DD1,080,213)
                                               ; 3229 from 3224 (DD1,080,213)
label_3229:     J       label_1c7e             ; 3229 1 080 213 037E1C
                                               ; 322C from 1E28 (DD1,080,213)
label_322c:     CLR     off(0008ch)            ; 322C 1 080 213 B48C15
                J       label_3031             ; 322F 1 080 213 033130
                DB  0FFh,04Ah,0E9h,04Ah,0C6h,04Ah,0A9h,042h ; 3232
                DB  090h,03Dh,046h,01Ch,030h,000h,000h,000h ; 323A
                DB  0FFh,031h,0E9h,031h,0D7h,031h,0A9h,031h ; 3242
                DB  086h,028h,046h,00Fh,030h,000h,000h,000h ; 324A
                DB  004h,001h,002h,001h ; 3252


                                               ; 3256 from 0770 (DD0,108,20E)
label_3256:     MOV     X1, #038e3h            ; 3256 0 108 20E 60E338
                JBR     off(00129h).0, label_325f ; Jump if not AUTO
                MOV     X1, #03232h            ; 325C 0 108 20E 603232
                                               ; 325F from 3259 (DD0,108,20E)
label_325f:     RT                             ; 325F 0 108 20E 01


                                               ; 3260 from 0779 (DD0,108,20E)
label_3260:     MOV     X1, #038f3h            ; 3260 0 108 20E 60F338
                JBR     off(00129h).0, label_3269 ; Jump if not AUTO
                MOV     X1, #03242h            ; 3266 0 108 20E 604232
                                               ; 3269 from 3263 (DD0,108,20E)
label_3269:     RT                             ; 3269 0 108 20E 01



                                               ; 326A from 07A7 (DD0,108,20E)
label_326a:     MOV     DP, #03903h            ; 326A 0 108 20E 620339
                JBR     off(00129h).0, label_3273 ; Jump if not AUTO
                MOV     DP, #03252h            ; 3270 0 108 20E 625232
                                               ; 3273 from 326D (DD0,108,20E)
label_3273:     RT                             ; 3273 0 108 20E 01
                                               ; 3274 from 18A2 (DD0,080,213)
                                               ; 3274 from 233E (DD0,080,0A4)
label_3274:     RB      off(IRQ).7             ; 3274 0 080 213 C4180F
                MB      C, P3.4                ; 3277 0 080 213 C5282C
                MB      off(P3IO).0, C         ; 327A 0 080 213 C42938
                RT                             ; 327D 0 080 213 01
                                               ; 327E from 1579 (DD1,108,13D)
label_327e:     SB      0feh.4                 ; 327E 1 108 13D C5FE1C
                AND     IE, #00080h            ; 3281 1 108 13D B51AD08000
                RT                             ; 3286 1 108 13D 01
                DB  0C9h,003h,0A2h,0F0h,080h,0CDh,006h,0DEh ; 3287
                DB  024h,003h,003h,0A6h,01Dh,003h,0BDh,01Dh ; 328F
                                               ; 3297 from 29EC (DD1,080,132)
label_3297:     MB      C, 0ffh.6              ; AC switch
                JLT     label_329f             ; Jump if (AC is OFF)
                JBR     off(P3SF).3, label_32a1 ; 329C 1 080 132 DB2A02
                                               ; 329F from 329A (DD1,080,132)
label_329f:     CLR     er2                    ; 329F 1 080 132 4615
                                               ; 32A1 from 329C (DD1,080,132)
label_32a1:     ST      A, [DP]                ; 32A1 1 080 132 D2
                J       label_29f4             ; 32A2 1 080 132 03F429
                DB  0E9h,026h,008h,0C5h,0FFh,02Eh,0CAh,003h ; 32A5
                DB  003h,009h,030h,003h,00Ch,030h ; 32AD
                                               ; 32B3 from 3191 (DD0,108,13D)
label_32b3:     LB      A, off(001e3h)         ; 32B3 0 108 13D F4E3
                JNE     label_32c0             ; 32B5 0 108 13D CE09
                CMPB    0a3h, #0d0h            ; 32B7 0 108 13D C5A3C0D0
                JGE     label_32c0             ; 32BB 0 108 13D CD03
                J       label_3195             ; 32BD 0 108 13D 039531
                                               ; 32C0 from 32B5 (DD0,108,13D)
                                               ; 32C0 from 32BB (DD0,108,13D)
label_32c0:     J       label_31e7             ; 32C0 0 108 13D 03E731
                                               ; 32C3 from 0C1A (DD0,108,13D)
label_32c3:     CMPB    A, 0a3h                ; 32C3 0 108 13D C5A3C2
                JGT     label_32cb             ; 32C6 0 108 13D C803
                J       label_0c1f             ; 32C8 0 108 13D 031F0C
                                               ; 32CB from 32C6 (DD0,108,13D)
label_32cb:     LB      A, #054h               ; 32CB 0 108 13D 7754
                JBS     off(00124h).0, label_32d8 ; 32CD 0 108 13D E82408
                LB      A, #054h               ; 32D0 0 108 13D 7754
                JBS     off(00124h).1, label_32d8 ; 32D2 0 108 13D E92403
                J       label_0c27             ; 32D5 0 108 13D 03270C
                                               ; 32D8 from 32CD (DD0,108,13D)
                                               ; 32D8 from 32D2 (DD0,108,13D)
label_32d8:     J       label_0c29             ; 32D8 0 108 13D 03290C
                                               ; 32DB from 1D4B (DD1,080,213)
                                               ; 32DB from 1D99 (DD0,080,213)
label_32db:     MB      off(00027h).5, C       ; 32DB 1 080 213 C4273D
                MB      C, 0ffh.6              ; AC switch
                MB      off(00027h).7, C       ; Move AC Switch on/off into 027h.7
                RT                             ; 32E4 1 080 213 01
                                               ; 32E5 from 301B (DD1,080,213)
label_32e5:     L       A, #08000h             ; 32E5 1 080 213 670080
                JBR     off(00027h).5, label_32f1 ; 32E8 1 080 213 DD2706
                JBS     off(00027h).7, label_32f1 ; 32EB 1 080 213 EF2703
                L       A, #05a00h             ; 32EE 1 080 213 67005A
                                               ; 32F1 from 32E8 (DD1,080,213)
                                               ; 32F1 from 32EB (DD1,080,213)
label_32f1:     J       label_301e             ; 32F1 1 080 213 031E30
                                               ; 32F4 from 043A (DD1,108,???)
label_32f4:     RB      off(0011eh).5          ; 32F4 1 108 ??? C41E0D
                RB      off(0011fh).0          ; 32F7 1 108 ??? C41F08
                RT                             ; 32FA 1 108 ??? 01

launch:			CMPB	0cbh, #00Ah  ;compare speed with 10 mph, speed-10mph
				JGT		launch2      ;if the speed > the ftl speed then use the val already in A
				L		A, #00202h   ;else load the FTL rpm (~3600)
				MB      C, 0feh.7	 ;are we already on the revlimit?
				JGT		launch2		 ;No? then we jump and use the limit
				ADD		A, #00001h	 ;else yes, we use the restart

launch2:		MB      C, P2.4      ;do the line we replaced
				RT


                org 36E6h

tbl_36e6:       DB  000h ; 36E6

				;vcal 0 with ECT
tbl_36e7:       DB  0FFh,059h,0F5h,059h,0E8h,04Dh,0BAh,048h ; 36E7
                DB  087h,047h,030h,043h,028h,040h,000h,040h ; 36EF

                ;vcal 0 with ECT
tbl_36f7:       DB  0FFh,078h,0F5h,078h,0E1h,06Ch,0BAh,063h ; 36F7
                DB  087h,05Dh,030h,04Bh,028h,040h,000h,040h ; 36FF

                ;vcal0 with ECT
tbl_3707:       DB  0FFh,069h,0F5h,069h,0E1h,05Ah,0BAh,057h ; 3707
                DB  087h,056h,030h,04Bh,028h,040h,000h,040h ; 370F

				;vcal0 with ECT
tbl_3717:       DB  0FFh,05Eh,0F5h,05Eh,0E1h,05Bh,0BAh,056h ; 3717
                DB  087h,04Eh,030h,045h,028h,040h,000h,040h ; 371F

				;limits for map image (b4h) in some cases. 1 set for auto, 1 set for manual:
tbl_3727:       DB  0DFh,0DFh,051h,051h ; 3727

				; vcal 0 with IAT
tbl_372b:       DB  0FFh,05Ah,0E0h,044h,0C0h,02Ah,0A0h,00Fh ; 372B
                DB  080h,009h,050h,000h,000h,000h ; 3733

				;used in useless CEL code (code 18) check routine.
tbl_3739:       DB  005h,00Dh,013h,018h ; 3739

				;this COULD be the open/closed loop value.
				;the low byte is compared to the TPS value in the final fuel
tbl_373d:       DW  0dd05h           ; 373D

				;vcal1 with 1 byte non vtec RPM (a6h). stored into 156h
tbl_373f:       DB  0FFh,056h,007h,0C0h,056h,007h,0A0h,0D6h ; 373F
                DB  007h,020h,0D6h,006h,000h,0D6h,006h ; 3747

				;used in o2 routine.
tbl_374e:       DB  060h,000h,0C0h,001h,0C0h,001h,020h,000h ; 374E
                DB  020h,000h,020h,000h ; 3756

				;used in o2 routine
tbl_375a:       DB  0E0h,000h,0E0h,004h,023h,007h,080h,000h ; 375A
                DB  05Ah,004h,045h,008h,0A0h,000h,0E0h,004h ; 3762
                DB  023h,007h,0A0h,000h,05Ah,004h,094h,009h ; 376A
                DB  080h,000h,0A0h,002h,0A0h,006h,080h,000h ; 3772
                DB  040h,001h,040h,003h,06Bh,046h,0D7h ; 377A

				;used in o2 routine
tbl_3781:       DB  000h,000h,043h,000h,086h,000h,0BDh,0FFh ; 3781

				;individual cylinder o2 fuel adjust (added to o2 trim)
tbl_3789:       DB  000h,000h,000h,000h,000h,000h,000h,000h ; 3789

				;vcal1 with ECT
tbl_3791:       DB  0FFh,08Bh,003h,0EAh,077h,003h,0C0h,0F9h ; 3791
                DB  001h,080h,040h,001h,044h,030h,001h,000h ; 3799
                DB  030h,001h ; 37A1

                ;vcal1 with ECT
tbl_37a3:       DB  0FFh,05Eh,003h,0EAh,04Bh,003h,0C0h,0F9h ; 37A3
                DB  001h,080h,040h,001h,044h,030h,001h,000h ; 37AB
                DB  030h,001h ; 37B3

                ;used in final fuel routine
tbl_37b5:       DB  000h,006h,0D6h,00Dh,031h,000h,028h,000h ; 37B5
                DB  030h,005h,008h,00Ch,03Ah,000h,02Ch,000h ; 37BD
                DB  010h,000h,010h,000h,008h,000h,008h,000h ; 37C5
                DB  008h,000h,008h,000h ; 37CD

                ;vcal3 with temp (a3h) in 14e calc.
tbl_37d1:       DB  087h,0FAh,000h,034h,026h,000h ; 37D1

				;some other battery offset (9bh)
tbl_37d7:       DB  01Fh,00Fh,000h,0F1h,0E1h,000h,01Fh,00Fh ; 37D7
                DB  000h,0F1h,0E1h,000h ; 37DF

                ;battery offset table (9ah)
tbl_37e3:       DB  0FFh,076h,000h,0C5h,076h,000h,0A7h,076h ; 37E3
                DB  000h,092h,096h,000h,07Eh,0C8h,000h,03Fh ; 37EB
                DB  080h,002h,000h,080h,002h ; 37F3

                ;vcal0 with ECT
tbl_37f8:       DB  0FFh,0A1h,0E0h,0A1h,0C0h,08Ah,0A0h,07Fh ; 37F8
                DB  080h,065h,060h,046h,040h,02Ah,000h,000h ; 3800

				;TPS tip in? Fairly certain. Dont know how exactly it works,
				;though. Sometimes its not used. Sometimes the tip in is
				;calced from the TPS val and another vector.
tbl_3808:       DB  07Dh,000h,019h,000h,0EEh,002h
				DB	07Dh,000h,032h,000h,0EEh,002h
				DB	07Dh,000h,019h,000h,0EEh,002h
				DB	020h,000h,009h,000h,077h,001h
				DB	01Dh,000h,00Ah,000h,077h,001h
                DB  010h,000h,00Ah,000h,077h,001h
                DB	030h,000h,008h,000h,0FAh,000h
                DB	010h,000h,004h,000h,0FAh,000h
                DB	056h,00Ch,0E1h,000h,056h,00Ch
                DB	0AFh,000h,050h,00Eh,06Fh,000h
                DB  060h,009h,0FAh,000h,06Fh,005h
                DB	07Dh,000h,050h,00Ch,06Fh,000h
                DB	04Bh,006h,000h,000h,019h,003h,04Bh,000h


				;word; enrichment for delta_map
tbl_3858:       DB  000h,006h,000h,002h,000h,005h,000h,003h ; 3858

				;vcal 1 with non vtec rpm (a6h)
tbl_3860:       DB  0FFh,010h,000h,0E0h,010h,000h,0D0h,020h ; 3860
                DB  000h,0B0h,030h,000h,0A0h,040h,000h,080h ; 3868
                DB  050h,000h,070h,060h,000h,050h,070h,000h ; 3870
                DB  040h,080h,000h,020h,090h,000h,010h,0A0h ; 3878
                DB  000h,000h,0B0h,000h ; 3880

				;temp related and used in finding final ignition val
tbl_3884:       DB  003h,003h,003h ; 3884

				;vcal0 with vtec rpm (a7h) and stored in 13eh
tbl_3887:       DB  0FFh,027h,0C0h,01Eh,080h,012h,040h,008h,000h,000h ; 3887

				;***************
				; all knock stuff is vcal'd with the 1 byte rpm.
				;used in knock correction : Brake switch < #1ah
tbl_3891:       DB  0FFh,0F4h,0D8h,0F4h,0CAh,0FDh,08Dh,0F9h ; 3891
                DB  057h,0F1h,030h,0F1h,000h,0F1h ; 3899

				;used in knock correction VTEC : Brake switch < #1ah
tbl_389f:       DB  0FFh,0F4h,0F0h,0F4h,08Fh,0F4h,079h,0FDh ; 389F
                DB  060h,0FDh,030h,0FDh,000h,0FDh ; 38A7

				;used in knock correction
tbl_38ad:       DB  0FFh,0F3h,0F0h,0F3h,0B0h,0F3h,08Dh,0F3h ; 38AD
                DB  057h,0E6h,045h,0FFh,000h,0FFh ; 38B5

				;used in knock correction VTEC
tbl_38bb:       DB  0FFh,0F4h,0F0h,0F4h,0B0h,0F4h,08Fh,0F4h ; 38BB
                DB  079h,0FAh,01Ch,0FFh,000h,0FFh ; 38C3
				;***************

                ;vcal0 with vtec rpm
tbl_38c9:       DB  0FFh,0A4h,0D5h,09Ah,0AAh,090h,070h,061h ; 38C9
                DB  040h,038h,01Ch,01Ch,000h,005h ; 38D1

                ;vcal0 with voltage (9ah)
tbl_38d7:       DB  0FFh,015h,0A7h,033h,092h,040h,068h,066h ; 38D7
                DB  03Fh,0C6h,000h,0C6h ; 38DF

tbl_38e3:       DB  0FFh,047h,0E9h,047h,0C6h,047h,0A9h,03Fh ; 38E3
                DB  090h,039h,046h,017h,030h,000h,000h,000h ; 38EB

tbl_38f3:       DB  0FFh,025h,0E9h,025h,0D7h,025h,0C6h,025h ; 38F3
                DB  097h,024h,046h,00Eh,030h,000h,000h,000h ; 38FB

tbl_3903:       DB  008h,001h,004h,001h ; 3903

tbl_3907:       DB  0BEh,02Eh,044h,000h ; 3907

tbl_390b:       DB  0BEh,010h,094h,000h ; 390B

tbl_390f:       DB  077h,000h,064h,005h,008h,003h,005h ; 390F

tbl_3916:                 DW  tbl_3232         ; 3916 3232

				;rev limits (words)
				;speedlimit, hi-cam, low cam hot, low cam cold.
tbl_3918:       DB  05Fh,001h,0E7h,000h,0FAh,000h,00Ch,001h ; 3918
				;rev restarts (words)
				;speedlimit, hi-cam, low cam hot, low cam cold.
tbl_3920:       DB  05Fh,001h,0EDh,000h,001h,001h,014h,001h ; 3920

tbl_3928:       DB  044h,0A9h,032h,062h ; 3928

tbl_392c:       DB  0FFh,019h,0C6h,019h,094h,019h,086h,000h,000h,000h ; 392C

tbl_3936:       DB  0FFh,098h,0A1h,098h,07Ah,07Eh,044h,05Bh ; 3936
                DB  02Eh,043h,000h,043h ; 393E

tbl_3942:                 DW  01818h           ; 3942
tbl_3944:       DB  025h,0FFh,0D7h,0D0h,0C6h,0A9h,04Ah,000h ; 3944
                DB  000h ; 394C

tbl_394d:       DB  030h,080h,012h,05Ah 					; vcal_2d with bbh


				;vcal 1 with ECT cold start enrich (if 11ah.5 = 1)
tbl_3951:       DB  0FFh,08Ah,066h,0F5h,08Ah,066h,0E1h,0EBh ; 3951
                DB  041h,0BAh,03Ah,020h,087h,0A6h,00Eh,028h ; 3959
                DB  0E7h,008h,000h,0E7h,008h ; 3961
				;vcal 1 with ECT cold start enrich (if 11ah.5 = 0)
tbl_3966:       DB  0FFh,08Ah,066h,0F5h,08Ah,066h,0E1h,0EBh ; 3966
                DB  041h,0BAh,03Ah,020h,087h,0A6h,00Eh,028h ; 396E
                DB  0E7h,008h,000h,0E7h,008h ; 3976

tbl_397b:       DB  0FFh,0FFh,01Bh,0ABh,000h,015h,08Eh,000h ; 397B
                DB  011h,072h,000h,008h,063h,000h,00Ch,055h ; 3983
                DB  000h,000h,000h,000h,000h,0FFh,000h,008h ; 398B
                DB  0E9h,000h,017h,0D8h,000h,017h,0CAh,000h ; 3993
                DB  010h,0A9h,000h,00Eh,090h,000h,000h,000h ; 399B
                DB  000h,000h ; 39A3

tbl_39a5:       DB  0FFh,040h,005h,0F8h,040h,005h,0F8h,040h ; 39A5
                DB  005h,08Eh,080h,002h,078h,000h,000h,000h ; 39AD
                DB  000h,000h ; 39B5
tbl_39b7:       DB  0F1h,080h,00Bh,028h,000h,008h ; 39B7
tbl_39bd:       DB  0FFh,08Ah,0D0h,08Ah,07Ah,077h ; 39BD
tbl_39c3:       DB  044h,057h,02Eh,044h,000h,044h ; 39C3

				;Idle vector (when engine is cold)
tbl_39c9:       DB  0FFh,094h,004h,0A1h,094h,004h,07Ah,0E2h ; 39C9
                DB  004h,044h,0A8h,006h,02Eh,0C4h,009h,000h ; 39D1
                DB  0C4h,009h ; 39D9
				;Target idle when at operating temp
tbl_39db:       DB  0C4h,009h,064h,009h,00Bh,009h ; 39DB


tbl_39e1:       DB  0FFh,000h,008h,0F2h,000h,008h,0E1h,000h ; 39E1
                DB  002h,0C6h,000h,002h,087h,000h,00Ah,065h ; 39E9
                DB  000h,00Ah,044h,000h,006h,02Eh,000h,000h ; 39F1
                DB  000h,000h,000h ; 39F9

tbl_39fc:       DB  080h,000h,006h,028h,080h,008h ; 39FC

tbl_3a02:       DB  080h,080h,006h,028h,000h,009h ; 3A02

tbl_3a08:       DB  000h,003h,040h,000h ; 3A08

tbl_3a0c:       DB  008h,000h,000h,000h ; 3A0C

tbl_3a10:       DB  001h,000h,000h,000h ; 3A10

tbl_3a14:       DB  000h,000h,000h,001h ; 3A14

tbl_3a18:       DB  000h,000h,000h,02Ch ; 3A18

tbl_3a1c:       DB  0FFh,000h,010h,0A9h,000h,00Eh,097h,000h ; 3A1C
                DB  00Bh,086h,000h,008h,069h,000h,005h,054h ; 3A24
                DB  000h,000h,000h,000h,000h ; 3A2C

tbl_3a31:       DB  010h,000h,008h,002h,000h,000h ; 3A31

tbl_3a37:       DB  0FFh,020h,000h,0F5h,020h,000h,0E1h,012h ; 3A37
                DB  000h,0D7h,01Bh,000h ; 3A3F

tbl_3a43:       DB  0FFh,000h,012h,0F2h,000h,012h,0D0h,000h ; 3A43
                DB  00Ah,0A1h,000h,006h,056h,000h,004h,044h ; 3A4B
                DB  080h,004h,02Eh,000h,006h,020h,000h,009h ; 3A53
                DB  000h,000h,009h ; 3A5B

tbl_3a5e:       DB  030h,000h,028h,000h,018h,000h,000h,00Ch,000h,001h ; 3A5E

tbl_3a68:       DB  030h,000h,028h,000h,018h,000h,000h,010h,040h,002h ; 3A68

tbl_3a72:       DB  0FFh,0C0h,000h,0E0h,0C0h,000h,0A1h,01Ah ; 3A72
                DB  000h,02Eh,007h,000h,000h,007h,000h ; 3A7A

tbl_3a81:       DB  0FFh,02Eh,000h,0A1h,02Eh,000h,057h,01Ah ; 3A81
                DB  000h,02Eh,018h,000h,000h,018h,000h ; 3A89

tbl_3a90:       DB  0FFh,0FFh,000h,080h,0FFh,01Bh,000h,078h ; 3A90
                DB  060h,016h,010h,047h,0C8h,010h,0E0h,03Dh ; 3A98
                DB  030h,00Bh,0B0h,034h,000h,002h,080h,01Fh ; 3AA0
                DB  000h,000h,0F0h,017h ; 3AA8

				;IACV duty cycle
tbl_3aac:       DB  0FFh,0FFh,08Fh,042h,000h,0FEh,08Fh,042h ; 3AAC
                DB  000h,0FBh,0AEh,067h,000h,0F6h,0C2h,075h ; 3AB4
                DB  000h,0F0h,000h,080h,000h,0E9h,01Eh,085h ; 3ABC
                DB  000h,0E0h,000h,080h,000h,000h,000h,080h ; 3AC4

tbl_3acc:       DB  0E0h,033h,0A9h,051h,019h,097h,0CFh,033h ; 3ACC
                DB  0A9h,051h,019h,097h ; 3AD4

                ;VTEC
tbl_3ad8:       DB  0D0h,0D4h,0E5h,0E9h 					;

tbl_3adc:       DB  0FFh,076h,007h,0F0h,076h,007h,0E0h,076h ; 3ADC
                DB  007h,0D9h,026h,007h,0D4h,05Ch,008h,0CFh ; 3AE4
                DB  02Ah,008h,000h,02Ah,008h ; 3AEC

tbl_3af1:       DB  000h,000h,000h,000h,000h,000h,000h,000h ; 3AF1
                DB  000h,000h,000h,000h ; 3AF9

tbl_3afd:       DB  000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ; 3AFD
                DB  000h,000h,0E7h,008h,023h,00Dh,09Ch,017h,03Bh,033h ; 3B07

tbl_3b11:       DB  0EBh,041h,030h,001h,038h,001h,09Fh,001h ; 3B11
                DB  08Ah,002h,024h,003h ; 3B19

                ; Vcal_2'd with TPS
tbl_3b1d:       DB  068h,0D0h,020h,067h

tbl_3b21:       DB  0A2h,033h,073h,02Ah,000h,008h ; 3B21
tbl_3b27:       DB  0FFh,040h,028h,06Eh,000h ; 3B27
tbl_3b2c:       DB  014h,00Fh,00Fh,00Fh,02Dh,0FFh,00Fh,02Dh ; 3B2C
                DB  00Fh,02Dh,04Bh,02Dh,0FFh,04Bh,04Bh,006h ; 3B34

                ;cel code map
tbl_3b3c:       DB  02Dh,003h,006h,007h,005h,00Dh,012h,013h ; 3B3C
                DB  00Ah,00Eh,008h,011h,014h,017h,018h,015h ; 3B44
                DB  016h,004h,008h,009h,00Fh,004h,008h,009h ; 3B4C
                DB  010h ; 3B54

tbl_3b55:       DB  000h,000h,077h,011h,0EEh,022h,077h,022h ; 3B55
                DB  0DDh,044h,0FFh,0FFh,0EEh,044h,077h,044h ; 3B5D
                DB  0BBh ; 3B65

tbl_3b66:       DB  088h,0BBh,011h,0FFh,0FFh,0BBh,022h,0DDh ; 3B66
                DB  088h,0DDh,011h,0EEh,088h,000h,000h,0C7h ; 3B6E
                DB  000h,02Dh,02Dh,007h,006h,019h,019h,019h ; 3B76
                DB  000h,0B8h,00Bh,0B8h,00Bh,0FFh,082h,096h ; 3B7E
                DB  096h,01Ch,002h,005h,00Ah,00Ah,00Dh,00Dh ; 3B86
                DB  000h,000h,000h,032h,002h,000h ; 3B8E

tbl_3b94:       DB  001h,020h,001h,003h,001h,020h,001h,019h ; 3B94
                DB  001h,019h,001h,019h,001h,0FFh,001h,0FFh ; 3B9C
                DB  001h,0FFh

                ;map rpm scalars
                DB	040h,010h,010h,010h,010h,010h,010h,010h,010h,006h,009h,008h,009h,009h,008h,00Fh
                DB	00Eh,00Fh,01Ch,01Ch,00Eh,00Fh,00Eh,00Eh,00Eh,00Eh,00Fh,00Eh,00Eh,00Eh,00Dh,010h
                DB	010h,010h,010h,010h,01Bh,007h,007h,01Fh,013h,00Ah,00Bh,010h,010h,010h,010h,010h
                DB	010h,010h,010h,010h,010h,010h,010h,010h,010h,010h,010h,010h,010h,010h,010h,010h

                ;ignition map #1
                ;	  1    2    3    4    5    6    7    8    9   10   11   12   13   14   15
                DB	039h,039h,039h,039h,039h,039h,039h,039h,039h,032h,02Bh,025h,017h,017h,017h
                DB	039h,039h,039h,039h,039h,039h,039h,039h,039h,034h,02Fh,02Ah,021h,021h,021h
                DB	053h,053h,053h,053h,053h,053h,053h,050h,04Bh,046h,03Dh,038h,028h,028h,028h
                DB  059h,059h,059h,059h,059h,058h,057h,053h,04Fh,04Ah,043h,03Fh,030h,030h,030h
                DB	060h,060h,060h,060h,060h,05Eh,05Dh,059h,054h,050h,049h,045h,036h,033h,033h
                DB	062h,062h,062h,062h,062h,061h,058h,052h,04Dh,04Bh,04Ah,049h,03Bh,036h,036h
                DB	067h,067h,067h,067h,067h,066h,05Bh,052h,050h,050h,050h,050h,044h,044h,044h
                DB	067h,067h,067h,067h,067h,066h,05Bh,055h,053h,052h,051h,050h,04Ah,04Ah,04Ah
                DB	073h,073h,073h,073h,073h,071h,064h,05Fh,05Bh,058h,056h,050h,04Fh,04Fh,04Fh
                DB	073h,073h,073h,073h,073h,071h,06Eh,06Ch,068h,064h,060h,05Ch,054h,054h,054h
                DB	075h,075h,075h,075h,075h,072h,06Eh,06Ch,068h,065h,061h,05Eh,058h,058h,058h
                DB	07Bh,07Bh,07Bh,07Bh,07Bh,077h,073h,06Fh,06Bh,068h,064h,060h,058h,058h,058h
                DB	07Bh,07Bh,07Bh,07Bh,07Bh,077h,073h,06Fh,06Bh,068h,065h,067h,058h,058h,058h
                DB	072h,072h,072h,072h,072h,072h,06Fh,06Dh,06Ah,068h,065h,05Fh,050h,050h,050h
                DB	072h,072h,072h,072h,072h,072h,06Fh,06Dh,06Ah,068h,065h,05Fh,050h,050h,050h
                DB	072h,072h,072h,072h,072h,072h,06Fh,06Dh,06Ah,068h,065h,05Fh,050h,050h,050h
                DB	072h,072h,072h,072h,072h,072h,06Fh,06Dh,06Ah,068h,065h,05Fh,050h,050h,050h

                ;ignition map 2 (VTEC)
                DB	022h,022h,022h,022h,022h,022h,022h,022h,022h,022h,022h,022h,022h,022h,022h
                DB	039h,039h,039h,039h,039h,039h,039h,039h,039h,032h,02Bh,025h,018h,018h,018h
                DB  039h,039h,039h,039h,039h,039h,039h,039h,039h,034h,02Fh,02Ah,022h,022h,022h
                DB	058h,058h,058h,058h,058h,057h,056h,055h,052h,04Eh,04Ah,046h,03Fh,03Fh,03Fh
                DB	06Ch,06Ch,06Ch,06Ch,06Ch,06Ah,067h,064h,060h,05Dh,059h,055h,04Dh,04Dh,04Dh
                DB	073h,073h,073h,073h,073h,070h,06Dh,06Bh,067h,063h,05Fh,05Bh,052h,052h,052h
                DB	075h,075h,075h,075h,075h,072h,06Eh,06Ch,068h,065h,061h,05Eh,058h,058h,058h
                DB	07Bh,07Bh,07Bh,07Bh,07Bh,077h,073h,06Fh,06Bh,068h,064h,060h,058h,058h,058h
                DB	07Bh,07Bh,07Bh,07Bh,07Bh,077h,073h,06Fh,06Bh,068h,065h,067h,058h,058h,058h
                DB	07Ah,07Ah,07Ah,07Ah,07Ah,07Ah,077h,075h,072h,070h,06Dh,067h,058h,058h,058h
                DB  07Ah,07Ah,07Ah,07Ah,07Ah,07Ah,077h,075h,072h,070h,06Dh,067h,058h,058h,058h
                DB	07Bh,07Bh,07Bh,07Bh,07Bh,07Bh,078h,076h,073h,071h,06Eh,067h,058h,058h,058h
                DB	077h,077h,077h,077h,077h,077h,074h,072h,070h,06Eh,06Ch,067h,058h,058h,058h
                DB	072h,072h,072h,072h,072h,072h,070h,06Fh,06Dh,06Bh,06Ah,067h,05Eh,05Eh,05Eh
                DB	072h,072h,072h,072h,072h,072h,070h,06Fh,06Dh,06Bh,06Ah,067h,05Eh,05Eh,05Eh
                DB	072h,072h,072h,072h,072h,072h,070h,06Fh,06Dh,06Bh,06Ah,067h,05Eh,05Eh,05Eh
                DB	072h,072h,072h,072h,072h,072h,070h,06Fh,06Dh,06Bh,06Ah,067h,05Eh,05Eh,05Eh

                ;fuel map 1
                DB	05Dh,04Fh,06Fh,055h,072h,08Eh,055h,061h,070h,07Fh,08Ch,04Eh,05Bh,06Eh,081h
                DB  05Dh,04Fh,06Fh,055h,072h,08Eh,055h,061h,070h,07Fh,08Ch,04Eh,05Bh,06Eh,081h
                DB	051h,054h,074h,05Ah,077h,091h,056h,061h,06Eh,07Ch,08Ah,04Ch,05Ch,06Ch,07Ch
                DB	06Ch,05Dh,081h,05Dh,07Ah,095h,058h,064h,071h,07Fh,08Dh,04Dh,05Dh,06Dh,07Dh
                DB	071h,062h,088h,062h,07Eh,096h,05Ah,066h,072h,080h,08Fh,04Eh,05Eh,06Fh,080h
                DB	082h,06Eh,09Ah,06Ah,084h,0A3h,05Eh,06Ah,078h,087h,094h,052h,061h,072h,083h
                DB	080h,06Dh,099h,068h,081h,09Eh,05Dh,069h,07Bh,086h,096h,052h,061h,071h,081h
                DB	08Ah,074h,0A4h,070h,08Ch,0A7h,062h,06Fh,07Dh,08Bh,09Bh,055h,064h,072h,080h
                DB	08Fh,07Bh,0ADh,074h,08Fh,0ACh,065h,073h,082h,090h,09Fh,057h,068h,079h,08Ah
                DB  08Ch,077h,0A8h,071h,08Eh,0ABh,065h,073h,083h,090h,0A0h,056h,067h,07Ch,091h
                DB	094h,07Dh,0B2h,078h,097h,0B5h,06Ah,075h,08Bh,099h,0A8h,05Ch,06Dh,081h,095h
                DB	094h,07Dh,0B1h,077h,094h,0B6h,06Ch,07Ah,089h,09Ah,0A9h,05Eh,06Eh,082h,096h
                DB	082h,06Eh,09Ch,06Dh,08Ch,0ACh,066h,075h,084h,095h,0A5h,05Bh,06Ch,080h,094h
                DB	099h,077h,0B9h,07Dh,09Eh,0C3h,071h,07Fh,095h,0A6h,0BAh,061h,07Eh,082h,08Fh
                DB	0BEh,09Ah,0E5h,097h,0BBh,0DFh,082h,093h,0A9h,0BCh,0D0h,072h,085h,099h,0ADh
                DB	0B4h,092h,0DBh,08Fh,0BAh,0DDh,081h,095h,0AAh,0BCh,0CFh,072h,086h,09Ah,0AEh
                DB	096h,08Ah,0C9h,092h,0BEh,0E3h,087h,0A0h,0B5h,0C7h,0DAh,071h,08Ch,09Ah,0A8h

                ;Fuel multipliers 1
                DB  000h,001h,001h,002h,002h,002h,003h,003h,003h,003h,003h,004h,004h,004h,004h

                ;fuel map 2
                DB	03Fh,035h,066h,050h,066h,07Ch,04Bh,059h,066h,075h,084h,049h,05Bh,06Dh,07Fh
                DB	03Fh,035h,066h,050h,066h,07Ch,04Bh,059h,066h,075h,084h,049h,05Bh,06Dh,07Fh
                DB	03Fh,035h,066h,050h,066h,07Ch,04Bh,059h,066h,075h,084h,049h,05Bh,06Dh,07Fh
                DB	03Fh,035h,066h,050h,066h,07Ch,04Bh,059h,066h,075h,084h,049h,05Bh,06Dh,07Fh
                DB	03Fh,035h,066h,050h,066h,07Ch,04Bh,059h,066h,075h,084h,049h,05Bh,06Dh,07Fh
                DB	04Eh,044h,060h,045h,05Fh,07Eh,04Fh,05Dh,06Dh,07Fh,08Dh,050h,062h,077h,08Ch
                DB	05Fh,050h,084h,063h,080h,0A1h,061h,071h,07Fh,091h,0A2h,05Ah,06Fh,083h,097h
                DB  049h,03Dh,06Dh,04Bh,067h,082h,050h,060h,070h,081h,092h,052h,066h,080h,09Ah
                DB	055h,048h,077h,051h,06Bh,088h,053h,064h,074h,087h,09Bh,05Bh,073h,080h,08Dh
                DB	067h,057h,092h,069h,089h,0ADh,067h,07Ah,08Dh,09Fh,0B3h,068h,07Dh,089h,095h
                DB	08Fh,07Ah,0C1h,084h,0A9h,0CFh,07Ah,091h,0A4h,0BBh,0CFh,071h,086h,097h,0A8h
                DB	0A3h,08Ah,0D5h,091h,0B5h,0DCh,081h,096h,0ABh,0C1h,0D5h,074h,087h,09Ah,0ADh
                DB	0AFh,096h,0DFh,099h,0C2h,0E9h,08Bh,0A2h,0B7h,0C9h,0DFh,077h,08Bh,09Fh,0B3h
                DB	0B2h,097h,0DEh,09Ch,0C6h,0F5h,091h,0A9h,0BFh,0D4h,0E8h,080h,096h,0A8h,0BAh
                DB	085h,071h,0BDh,08Eh,0C2h,0FCh,096h,0AFh,0C5h,0DDh,0F5h,07Eh,087h,0A9h,0C4h
                DB  085h,071h,0BDh,08Eh,0C2h,0FCh,096h,0AFh,0C5h,0DDh,0F5h,07Eh,087h,0A9h,0C4h
                DB	085h,071h,0BDh,08Eh,0C2h,0FCh,096h,0AFh,0C5h,0D0h,0F5h,07Eh,087h,0A9h,0C4h
                ;fuel multipliers 2
                DB	000h,001h,001h,002h,002h,002h,003h,003h,003h,003h,003h,004h,004h,004h,004h

