                org 0000h
int_start_vec:            DW  int_start        ; 0000 7316
int_break_vec:            DW  int_break        ; 0002 9A16
int_WDT_vec:              DW  int_WDT          ; 0004 9616
int_NMI_vec:              DW  int_NMI          ; 0006 8F00
int_INT0_vec:             DW  int_INT0         ; 0008 1F15
int_serial_rx_vec:        DW  int_serial_rx    ; 000A 6700
int_serial_tx_vec:        DW  int_break        ; 000C 9A16
int_serial_rx_BRG_vec:    DW  int_serial_rx_BRG; 000E 5D15
int_timer_0_overflow_vec: DW  int_timer_0_overflow; 0010 6515
int_timer_0_vec:          DW  int_timer_0      ; 0012 3701
int_timer_1_overflow_vec: DW  int_timer_1_overflow; 0014 0C16
int_timer_1_vec:          DW  int_timer_1      ; 0016 CD00
int_timer_2_overflow_vec: DW  int_break        ; 0018 9A16
int_timer_2_vec:          DW  int_timer_2      ; 001A D100
int_timer_3_overflow_vec: DW  int_break        ; 001C 9A16
int_timer_3_vec:          DW  int_break        ; 001E 9A16
int_a2d_finished_vec:     DW  int_break        ; 0020 9A16
int_PWM_timer_vec:        DW  int_PWM_timer    ; 0022 3616
int_serial_tx_BRG_vec:    DW  int_break        ; 0024 9A16
int_INT1_vec:             DW  int_INT1         ; 0026 F200
vcal_0_vec:               DW  vcal_0           ; 0028 F92B
vcal_1_vec:               DW  vcal_1           ; 002A 572C
vcal_2_vec:               DW  vcal_2           ; 002C 332C
vcal_3_vec:               DW  vcal_3           ; 002E 452C
vcal_4_vec:               DW  vcal_4           ; 0030 9B18
vcal_5_vec:               DW  vcal_5           ; 0032 962D
vcal_6_vec:               DW  vcal_6           ; 0034 B22E
vcal_7_vec:               DW  vcal_7           ; 0036 B42E
code_start:     DB  008h,00Eh,00Eh,000h,0E5h,0CEh,0D5h,01Ah ; 0038
                DB  0A2h,018h,042h,055h,067h,000h,001h,0F5h ; 0040
                DB  055h,0C5h,056h,00Bh,0CEh,00Ch,0C5h,006h ; 0048
                DB  02Fh,0C5h,007h,015h,0CAh,004h,0C5h,007h ; 0050
                DB  098h,002h,052h,0F2h,0D5h,051h,065h,052h ; 0058
                DB  0E5h,0CCh,0A2h,008h,0D5h,01Ah,002h ; 0060
                                               ; 0067 from 000A (DD0,???,???)
_int_serial_rx:  L       A, 0ceh                ; 0067 1 ??? ??? E5CE
                ST      A, IE                  ; 0069 1 ??? ??? D51A
                SB      PSWH.0                 ; 006B 1 ??? ??? A218
                L       A, DP                  ; 006D 1 ??? ??? 42
                PUSHS   A                      ; 006E 1 ??? ??? 55
                CLRB    A                      ; 006F 0 ??? ??? FA
                RB      SRSTAT.3               ; 0070 0 ??? ??? C5560B
                JEQ     label_0077             ; 0073 0 ??? ??? C902
                ADDB    A, #001h               ; 0075 0 ??? ??? 8601
                                               ; 0077 from 0073 (DD0,???,???)
label_0077:     RB      SRSTAT.2               ; 0077 0 ??? ??? C5560A
                JEQ     label_007e             ; 007A 0 ??? ??? C902
                ADDB    A, #002h               ; 007C 0 ??? ??? 8602
                                               ; 007E from 007A (DD0,???,???)
label_007e:     STB     A, ACCH                ; 007E 0 ??? ??? D507
                LB      A, SRBUF               ; 0080 0 ??? ??? F555
                MOV     DP, A                  ; 0082 0 ??? ??? 52
                LB      A, [DP]                ; 0083 0 ??? ??? F2
                STB     A, STBUF               ; 0084 0 ??? ??? D551
                POPS    A                      ; 0086 1 ??? ??? 65
                MOV     DP, A                  ; 0087 1 ??? ??? 52
                L       A, 0cch                ; 0088 1 ??? ??? E5CC
                RB      PSWH.0                 ; 008A 1 ??? ??? A208
                ST      A, IE                  ; 008C 1 ??? ??? D51A
                RTI                            ; 008E 1 ??? ??? 02
                                               ; 008F from 0006 (DD0,???,???)
                                               ; 008F from 16B9 (DD0,080,???)
int_NMI:        MOV     LRB, #00020h           ; 008F 0 100 ??? 572000
                J       label_3223             ; 0092 0 100 ??? 032332
                                               ; 0095 from 322B (DD0,100,???)
label_0095:     JEQ     label_009a             ; 0095 0 100 ??? C903
                CAL     label_2ecc             ; 0097 0 100 ??? 32CC2E
                                               ; 009A from 0095 (DD0,100,???)
label_009a:     MOV     DP, #00036h            ; 009A 0 100 ??? 623600
                                               ; 009D from 00A2 (DD0,100,???)
label_009d:     MB      C, P4.1                ; 009D 0 100 ??? C52C29
                JGE     label_00c8             ; 00A0 0 100 ??? CD26
                JRNZ    DP, label_009d         ; 00A2 0 100 ??? 30F9
                MOV     IE, #00040h            ; 00A4 0 100 ??? B51A984000
                MOVB    TCON1, #0e0h           ; 00A9 0 100 ??? C54198E0
                CLR     IRQ                    ; 00AD 0 100 ??? B51815
                SB      P4SF.1                 ; 00B0 0 100 ??? C52E19
                MOV     TM1, #0ffffh           ; 00B3 0 100 ??? B53498FFFF
                SB      TCON1.4                ; 00B8 0 100 ??? C5411C
                SB      SBYCON.2               ; 00BB 0 100 ??? C5101A
                LB      A, #005h               ; 00BE 0 100 ??? 7705
                STB     A, STPACP              ; 00C0 0 100 ??? D513
                SLLB    A                      ; 00C2 0 100 ??? 53
                STB     A, STPACP              ; 00C3 0 100 ??? D513
                SB      SBYCON.0               ; 00C5 0 100 ??? C51018
                                               ; 00C8 from 00A0 (DD0,100,???)
label_00c8:     MOVB    0edh, #047h            ; 00C8 0 100 ??? C5ED9847
                BRK                            ; 00CC 0 100 ??? FF
                                               ; 00CD from 0016 (DD0,???,???)
int_timer_1:    CAL     label_2911             ; 00CD 0 ??? ??? 321129
                RTI                            ; 00D0 0 ??? ??? 02
                                               ; 00D1 from 001A (DD0,???,???)
int_timer_2:    L       A, 0ceh                ; 00D1 1 ??? ??? E5CE
                ST      A, IE                  ; 00D3 1 ??? ??? D51A
                SB      PSWH.0                 ; 00D5 1 ??? ??? A218
                CLR     LRB                    ; 00D7 1 ??? ??? A415
                LB      A, 0dfh                ; 00D9 0 ??? ??? F5DF
                ADDB    A, #001h               ; 00DB 0 ??? ??? 8601
                CMPB    A, #003h               ; 00DD 0 ??? ??? C603
                JLT     label_00eb             ; 00DF 0 ??? ??? CA0A
                JBR     off(07ff42h).2, label_00eb ; 00E1 0 ??? ??? DA4207
                MOV     off(07ff3ah), 0dch     ; 00E4 0 ??? ??? B5DC7C3A
                RB      TCON2.3                ; 00E8 0 ??? ??? C5420B
                                               ; 00EB from 00DF (DD0,???,???)
                                               ; 00EB from 00E1 (DD0,???,???)
label_00eb:     L       A, 0cch                ; 00EB 1 ??? ??? E5CC
                RB      PSWH.0                 ; 00ED 1 ??? ??? A208
                ST      A, IE                  ; 00EF 1 ??? ??? D51A
                RTI                            ; 00F1 1 ??? ??? 02
                                               ; 00F2 from 0026 (DD0,???,???)
int_INT1:       L       A, IE                  ; 00F2 1 ??? ??? E51A
                PUSHS   A                      ; 00F4 1 ??? ??? 55
                L       A, #00010h             ; 00F5 1 ??? ??? 671000
                SCAL    label_012c             ; 00F8 1 ??? ??? 3132
                JBS     off(07ff30h).7, label_010c ; 00FA 1 ??? ??? EF300F
                JBS     off(07ff30h).3, label_0112 ; 00FD 1 ??? ??? EB3012
                RB      IRQ.7                  ; 0100 1 ??? ??? C5180F
                JEQ     label_010f             ; 0103 1 ??? ??? C90A
                RB      off(07ff2eh).0         ; 0105 1 ??? ??? C42E08
                MOVB    off(07ffbah), #02dh    ; 0108 1 ??? ??? C4BA982D
                                               ; 010C from 00FA (DD1,???,???)
label_010c:     J       label_03cd             ; 010C 1 ??? ??? 03CD03
                                               ; 010F from 0103 (DD1,???,???)
label_010f:     SB      off(07ff2eh).0         ; 010F 1 ??? ??? C42E18
                                               ; 0112 from 00FD (DD1,???,???)
label_0112:     L       A, ADCR5               ; 0112 1 ??? ??? E56A
                ST      A, 0b0h                ; 0114 1 ??? ??? D5B0
                L       A, TM1                 ; 0116 1 ??? ??? E534
                ST      A, TMR1                ; 0118 1 ??? ??? D536
                LB      A, #001h               ; 011A 0 ??? ??? 7701
                CAL     label_31d3             ; 011C 0 ??? ??? 32D331
                NOP                            ; 011F 0 ??? ??? 00
                SB      P2.4                   ; 0120 0 ??? ??? C5241C
                CAL     label_2995             ; 0123 0 ??? ??? 329529
                J       label_022d             ; 0126 0 ??? ??? 032D02
                                               ; 0129 from 013A (DD1,???,???)
label_0129:     L       A, #00011h             ; 0129 1 ??? ??? 671100
                                               ; 012C from 00F8 (DD1,???,???)
label_012c:     ST      A, IE                  ; 012C 1 ??? ??? D51A
                MOV     PSW, #00102h           ; 012E 1 ??? ??? B504980201
                MOV     LRB, #00022h           ; 0133 1 110 ??? 572200
                RT                             ; 0136 1 110 ??? 01
                                               ; 0137 from 0012 (DD0,???,???)
int_timer_0:    L       A, IE                  ; 0137 1 ??? ??? E51A
                PUSHS   A                      ; 0139 1 ??? ??? 55
                SCAL    label_0129             ; 013A 1 ??? ??? 31ED
                MOVB    off(07ffbah), #02dh    ; 013C 1 ??? ??? C4BA982D
                SB      off(07ff20h).0         ; 0140 1 ??? ??? C42018
                JNE     label_0151             ; 0143 1 ??? ??? CE0C
                RB      IRQH.7                 ; 0145 1 ??? ??? C5190F
                RB      off(07ff18h).0         ; 0148 1 ??? ??? C41808
                RB      TRNSIT.0               ; 014B 1 ??? ??? C54608
                J       label_029f             ; 014E 1 ??? ??? 039F02
                                               ; 0151 from 0143 (DD1,???,???)
label_0151:     LB      A, 0e3h                ; 0151 0 ??? ??? F5E3
                ADDB    A, #001h               ; 0153 0 ??? ??? 8601
                JBS     off(07ff30h).7, label_0193 ; 0155 0 ??? ??? EF303B
                RB      IRQH.7                 ; 0158 0 ??? ??? C5190F
                JNE     label_0170             ; 015B 0 ??? ??? CE13
                RB      off(07ff18h).0         ; 015D 0 ??? ??? C41808
                JNE     label_0170             ; 0160 0 ??? ??? CE0E
                STB     A, r0                  ; 0162 0 ??? ??? 88
                ANDB    A, #003h               ; 0163 0 ??? ??? D603
                JNE     label_016d             ; 0165 0 ??? ??? CE06
                SB      off(07ff2eh).1         ; 0167 0 ??? ??? C42E19
                SB      off(07ff1ah).0         ; 016A 0 ??? ??? C41A18
                                               ; 016D from 0165 (DD0,???,???)
label_016d:     LB      A, r0                  ; 016D 0 ??? ??? 78
                SJ      label_0193             ; 016E 0 ??? ??? CB23
                                               ; 0170 from 015B (DD0,???,???)
                                               ; 0170 from 0160 (DD0,???,???)
label_0170:     RB      off(07ff1ah).0         ; 0170 0 ??? ??? C41A08
                MOVB    off(07ffbbh), #02dh    ; 0173 0 ??? ??? C4BB982D
                CMPB    A, #004h               ; 0177 0 ??? ??? C604
                JEQ     label_0192             ; 0179 0 ??? ??? C917
                SB      off(07ff21h).1         ; 017B 0 ??? ??? C42119
                JLT     label_0189             ; 017E 0 ??? ??? CA09
                CMPB    A, #008h               ; 0180 0 ??? ??? C608
                JLT     label_018f             ; 0182 0 ??? ??? CA0B
                                               ; 0184 from 018C (DD0,???,???)
label_0184:     SB      off(07ff2eh).5         ; 0184 0 ??? ??? C42E1D
                SJ      label_0192             ; 0187 0 ??? ??? CB09
                                               ; 0189 from 017E (DD0,???,???)
label_0189:     JBR     off(07ff9ah).0, label_018f ; 0189 0 ??? ??? D89A03
                JBS     off(07ff9ah).1, label_0184 ; 018C 0 ??? ??? E99AF5
                                               ; 018F from 0182 (DD0,???,???)
                                               ; 018F from 0189 (DD0,???,???)
label_018f:     SB      off(07ff2eh).4         ; 018F 0 ??? ??? C42E1C
                                               ; 0192 from 0179 (DD0,???,???)
                                               ; 0192 from 0187 (DD0,???,???)
label_0192:     CLRB    A                      ; 0192 0 ??? ??? FA
                                               ; 0193 from 0155 (DD0,???,???)
                                               ; 0193 from 016E (DD0,???,???)
label_0193:     STB     A, 0e3h                ; 0193 0 ??? ??? D5E3
                ANDB    A, #003h               ; 0195 0 ??? ??? D603
                STB     A, 0e4h                ; 0197 0 ??? ??? D5E4
                LB      A, off(07ff9ah)        ; 0199 0 ??? ??? F49A
                ADDB    A, #001h               ; 019B 0 ??? ??? 8601
                JBS     off(07ff31h).0, label_01d0 ; 019D 0 ??? ??? E83130
                RB      TRNSIT.0               ; 01A0 0 ??? ??? C54608
                JNE     label_01b3             ; 01A3 0 ??? ??? CE0E
                STB     A, r0                  ; 01A5 0 ??? ??? 88
                ANDB    A, #00fh               ; 01A6 0 ??? ??? D60F
                JNE     label_01b0             ; 01A8 0 ??? ??? CE06
                SB      off(07ff2eh).2         ; 01AA 0 ??? ??? C42E1A
                SB      off(07ff1ah).1         ; 01AD 0 ??? ??? C41A19
                                               ; 01B0 from 01A8 (DD0,???,???)
label_01b0:     LB      A, r0                  ; 01B0 0 ??? ??? 78
                SJ      label_01d0             ; 01B1 0 ??? ??? CB1D
                                               ; 01B3 from 01A3 (DD0,???,???)
label_01b3:     RB      off(07ff1ah).1         ; 01B3 0 ??? ??? C41A09
                MOVB    off(07ffbch), #007h    ; 01B6 0 ??? ??? C4BC9807
                CMPB    A, #010h               ; 01BA 0 ??? ??? C610
                JEQ     label_01c5             ; 01BC 0 ??? ??? C907
                JGE     label_01cf             ; 01BE 0 ??? ??? CD0F
                JBR     off(07ff21h).1, label_01cc ; 01C0 0 ??? ??? D92109
                SJ      label_01cf             ; 01C3 0 ??? ??? CB0A
                                               ; 01C5 from 01BC (DD0,???,???)
label_01c5:     RB      off(07ff21h).1         ; 01C5 0 ??? ??? C42109
                LB      A, 0e4h                ; 01C8 0 ??? ??? F5E4
                JEQ     label_01d0             ; 01CA 0 ??? ??? C904
                                               ; 01CC from 01C0 (DD0,???,???)
label_01cc:     SB      off(07ff2eh).6         ; 01CC 0 ??? ??? C42E1E
                                               ; 01CF from 01BE (DD0,???,???)
                                               ; 01CF from 01C3 (DD0,???,???)
label_01cf:     CLRB    A                      ; 01CF 0 ??? ??? FA
                                               ; 01D0 from 019D (DD0,???,???)
                                               ; 01D0 from 01B1 (DD0,???,???)
                                               ; 01D0 from 01CA (DD0,???,???)
label_01d0:     STB     A, off(07ff9ah)        ; 01D0 0 ??? ??? D49A
                ANDB    A, #00fh               ; 01D2 0 ??? ??? D60F
                JNE     label_01eb             ; 01D4 0 ??? ??? CE15
                LB      A, 0e7h                ; 01D6 0 ??? ??? F5E7
                JEQ     label_01df             ; 01D8 0 ??? ??? C905
                DECB    0e7h                   ; 01DA 0 ??? ??? C5E717
                SJ      label_01e8             ; 01DD 0 ??? ??? CB09
                                               ; 01DF from 01D8 (DD0,???,???)
label_01df:     MOV     DP, #0021ah            ; 01DF 0 ??? ??? 621A02
                MB      C, [DP].0              ; 01E2 0 ??? ??? C228
                LB      A, #001h               ; 01E4 0 ??? ??? 7701
                JGE     label_01e9             ; 01E6 0 ??? ??? CD01
                                               ; 01E8 from 01DD (DD0,???,???)
label_01e8:     CLRB    A                      ; 01E8 0 ??? ??? FA
                                               ; 01E9 from 01E6 (DD0,???,???)
label_01e9:     STB     A, 0e5h                ; 01E9 0 ??? ??? D5E5
                                               ; 01EB from 01D4 (DD0,???,???)
label_01eb:     JBS     off(07ff30h).7, label_01f1 ; 01EB 0 ??? ??? EF3003
                JBR     off(07ff1ah).0, label_01fe ; 01EE 0 ??? ??? D81A0D
                                               ; 01F1 from 01EB (DD0,???,???)
label_01f1:     ANDB    0e3h, #0fch            ; 01F1 0 ??? ??? C5E3D0FC
                LB      A, off(07ff9ah)        ; 01F5 0 ??? ??? F49A
                ANDB    A, #003h               ; 01F7 0 ??? ??? D603
                ORB     0e3h, A                ; 01F9 0 ??? ??? C5E3E1
                STB     A, 0e4h                ; 01FC 0 ??? ??? D5E4
                                               ; 01FE from 01EE (DD0,???,???)
label_01fe:     JBS     off(07ff31h).0, label_0204 ; 01FE 0 ??? ??? E83103
                JBR     off(07ff1ah).1, label_020d ; 0201 0 ??? ??? D91A09
                                               ; 0204 from 01FE (DD0,???,???)
label_0204:     ANDB    off(07ff9ah), #0fch    ; 0204 0 ??? ??? C49AD0FC
                LB      A, 0e4h                ; 0208 0 ??? ??? F5E4
                ORB     off(07ff9ah), A        ; 020A 0 ??? ??? C49AE1
                                               ; 020D from 0201 (DD0,???,???)
label_020d:     RC                             ; 020D 0 ??? ??? 95
                JBS     off(07ff30h).7, label_0214 ; 020E 0 ??? ??? EF3003
                JBR     off(07ff1ah).0, label_021a ; 0211 0 ??? ??? D81A06
                                               ; 0214 from 020E (DD0,???,???)
label_0214:     JBS     off(07ff31h).0, label_021d ; 0214 0 ??? ??? E83106
                JBS     off(07ff1ah).1, label_021d ; 0217 0 ??? ??? E91A03
                                               ; 021A from 0211 (DD0,???,???)
label_021a:     JBR     off(07ff31h).6, label_021e ; 021A 0 ??? ??? DE3101
                                               ; 021D from 0214 (DD0,???,???)
                                               ; 021D from 0217 (DD0,???,???)
label_021d:     SC                             ; 021D 0 ??? ??? 85
                                               ; 021E from 021A (DD0,???,???)
label_021e:     MB      off(07ff21h).3, C      ; 021E 0 ??? ??? C4213B
                JGE     label_0226             ; 0221 0 ??? ??? CD03
                SB      0feh.6                 ; 0223 0 ??? ??? C5FE1E
                                               ; 0226 from 0221 (DD0,???,???)
label_0226:     JBS     off(07ff2bh).6, label_022d ; 0226 0 ??? ??? EE2B04
                ANDB    off(07ff2eh), #08fh    ; 0229 0 ??? ??? C42ED08F
                                               ; 022D from 0126 (DD0,???,???)
                                               ; 022D from 0226 (DD0,???,???)
label_022d:     JBS     off(07ff1fh).4, label_029f ; 022D 0 ??? ??? EC1F6F
                JBS     off(07ff21h).2, label_0252 ; 0230 0 ??? ??? EA211F
                MOV     DP, #00199h            ; 0233 0 ??? ??? 629901
                LB      A, 0e5h                ; 0236 0 ??? ??? F5E5
                SRLB    A                      ; 0238 0 ??? ??? 63
                LB      A, off(07ff9ah)        ; 0239 0 ??? ??? F49A
                JLT     label_023f             ; 023B 0 ??? ??? CA02
                ADDB    A, #004h               ; 023D 0 ??? ??? 8604
                                               ; 023F from 023B (DD0,???,???)
label_023f:     ANDB    A, #007h               ; 023F 0 ??? ??? D607
                CMPB    A, [DP]                ; 0241 0 ??? ??? C2C2
                JNE     label_029f             ; 0243 0 ??? ??? CE5A
                LB      A, off(07ff98h)        ; 0245 0 ??? ??? F498
                CMPB    A, [DP]                ; 0247 0 ??? ??? C2C2
                JEQ     label_0252             ; 0249 0 ??? ??? C907
                DECB    [DP]                   ; 024B 0 ??? ??? C217
                JLT     label_0252             ; 024D 0 ??? ??? CA03
                ADDB    [DP], #002h            ; 024F 0 ??? ??? C28002
                                               ; 0252 from 0230 (DD0,???,???)
                                               ; 0252 from 0249 (DD0,???,???)
                                               ; 0252 from 024D (DD0,???,???)
label_0252:     CLR     A                      ; 0252 1 ??? ??? F9
                LB      A, 0e5h                ; 0253 0 ??? ??? F5E5
                SLLB    A                      ; 0255 0 ??? ??? 53
                MOV     DP, A                  ; 0256 0 ??? ??? 52
                ANDB    A, #002h               ; 0257 0 ??? ??? D602
                MOV     X1, A                  ; 0259 0 ??? ??? 50
                L       A, 00162h[X1]          ; 025A 1 ??? ??? E06201
                MOV     er0, #0944eh           ; 025D 1 ??? ??? 44984E94
                CMP     A, #0b6e0h             ; 0261 1 ??? ??? C6E0B6
                JGE     label_0270             ; 0264 1 ??? ??? CD0A
                MOV     er0, #0682ah           ; 0266 1 ??? ??? 44982A68
                CMP     A, #05720h             ; 026A 1 ??? ??? C62057
                JLE     label_0270             ; 026D 1 ??? ??? CF01
                ST      A, er0                 ; 026F 1 ??? ??? 88
                                               ; 0270 from 0264 (DD1,???,???)
                                               ; 0270 from 026D (DD1,???,???)
label_0270:     SRL     X1                     ; 0270 1 ??? ??? 90E7
                LB      A, 0011bh[X1]          ; 0272 0 ??? ??? F01B01
                SRLB    A                      ; 0275 0 ??? ??? 63
                JGE     label_027f             ; 0276 0 ??? ??? CD07
                CLR     A                      ; 0278 1 ??? ??? F9
                LC      A, 037cch[DP]          ; 0279 1 ??? ??? 92A9CC37
                ADD     er0, A                 ; 027D 1 ??? ??? 4481
                                               ; 027F from 0276 (DD0,???,???)
label_027f:     L       A, off(07ff44h)        ; 027F 1 ??? ??? E444
                MUL                            ; 0281 1 ??? ??? 9035
                SLL     A                      ; 0283 1 ??? ??? 53
                L       A, er1                 ; 0284 1 ??? ??? 35
                ROL     A                      ; 0285 1 ??? ??? 33
                JLT     label_028c             ; 0286 1 ??? ??? CA04
                ADD     A, off(07ff46h)        ; 0288 1 ??? ??? 8746
                JGE     label_028f             ; 028A 1 ??? ??? CD03
                                               ; 028C from 0286 (DD1,???,???)
label_028c:     L       A, #0ffffh             ; 028C 1 ??? ??? 67FFFF
                                               ; 028F from 028A (DD1,???,???)
label_028f:     ST      A, 0d6h                ; 028F 1 ??? ??? D5D6
                CAL     label_29b1             ; 0291 1 ??? ??? 32B129
                MOV     LRB, #00022h           ; 0294 1 110 ??? 572200
                LB      A, 0e5h                ; 0297 0 110 ??? F5E5
                ADDB    A, #001h               ; 0299 0 110 ??? 8601
                ANDB    A, #003h               ; 029B 0 110 ??? D603
                STB     A, 0e5h                ; 029D 0 110 ??? D5E5
                                               ; 029F from 014E (DD1,???,???)
                                               ; 029F from 022D (DD0,???,???)
                                               ; 029F from 0243 (DD0,???,???)
label_029f:     L       A, TMR1                ; 029F 1 ??? ??? E536
                ST      A, er0                 ; 02A1 1 ??? ??? 88
                SUB     A, 0e0h                ; 02A2 1 ??? ??? B5E0A2
                JBR     off(07ff21h).2, label_02bd ; 02A5 1 ??? ??? DA2115
                JBS     off(07ff1eh).7, label_02b0 ; 02A8 1 ??? ??? EF1E05
                JBR     off(07ff1eh).6, label_02b1 ; 02AB 1 ??? ??? DE1E03
                JLT     label_02b1             ; 02AE 1 ??? ??? CA01
                                               ; 02B0 from 02A8 (DD1,???,???)
label_02b0:     CLR     A                      ; 02B0 1 ??? ??? F9
                                               ; 02B1 from 02AB (DD1,???,???)
                                               ; 02B1 from 02AE (DD1,???,???)
label_02b1:     MOV     USP, #0020dh           ; 02B1 1 ??? 20D A1980D02
                PUSHU   A                      ; 02B5 1 ??? 20B 76
                PUSHU   A                      ; 02B6 1 ??? 209 76
                PUSHU   A                      ; 02B7 1 ??? 207 76
                PUSHU   A                      ; 02B8 1 ??? 205 76
                ST      A, 0b8h                ; 02B9 1 ??? 205 D5B8
                SJ      label_02cf             ; 02BB 1 ??? 205 CB12
                                               ; 02BD from 02A5 (DD1,???,???)
label_02bd:     MB      C, TCON1.2             ; 02BD 1 ??? ??? C5412A
                JGE     label_02c3             ; 02C0 1 ??? ??? CD01
                CLR     A                      ; 02C2 1 ??? ??? F9
                                               ; 02C3 from 02C0 (DD1,???,???)
label_02c3:     ST      A, 0b8h                ; 02C3 1 ??? ??? D5B8
                LB      A, 0e4h                ; 02C5 0 ??? ??? F5E4
                SLLB    A                      ; 02C7 0 ??? ??? 53
                EXTND                          ; 02C8 1 ??? ??? F8
                MOV     X1, A                  ; 02C9 1 ??? ??? 50
                L       A, 0b8h                ; 02CA 1 ??? ??? E5B8
                ST      A, 00206h[X1]          ; 02CC 1 ??? ??? D00602
                                               ; 02CF from 02BB (DD1,???,205)
label_02cf:     L       A, er0                 ; 02CF 1 ??? ??? 34
                ST      A, 0e0h                ; 02D0 1 ??? ??? D5E0
                SLL     A                      ; 02D2 1 ??? ??? 53
                JLT     label_02db             ; 02D3 1 ??? ??? CA06
                MB      C, IRQ.6               ; 02D5 1 ??? ??? C5182E
                MB      0fdh.5, C              ; 02D8 1 ??? ??? C5FD3D
                                               ; 02DB from 02D3 (DD1,???,???)
label_02db:     ANDB    off(07ff1eh), #03fh    ; 02DB 1 ??? ??? C41ED03F
                LB      A, 0e4h                ; 02DF 0 ??? ??? F5E4
                JEQ     label_02f6             ; 02E1 0 ??? ??? C913
                CMPB    A, #003h               ; 02E3 0 ??? ??? C603
                JEQ     label_0341             ; 02E5 0 ??? ??? C95A
                JBS     off(07ff18h).1, label_0334 ; 02E7 0 ??? ??? E9184A
                MOV     USP, #00206h           ; 02EA 0 ??? 206 A1980602
                CLR     er2                    ; 02EE 0 ??? 206 4615
                CMPB    A, #001h               ; 02F0 0 ??? 206 C601
                JEQ     label_031e             ; 02F2 0 ??? 206 C92A
                SJ      label_033b             ; 02F4 0 ??? 206 CB45
                                               ; 02F6 from 02E1 (DD0,???,???)
label_02f6:     LB      A, #012h               ; 02F6 0 ??? ??? 7712
                JBR     off(07ff18h).1, label_02fd ; 02F8 0 ??? ??? D91802
                LB      A, #00bh               ; 02FB 0 ??? ??? 770B
                                               ; 02FD from 02F8 (DD0,???,???)
label_02fd:     CMPB    A, 0bbh                ; 02FD 0 ??? ??? C5BBC2
                MB      off(07ff18h).1, C      ; 0300 0 ??? ??? C41839
                JGE     label_0316             ; 0303 0 ??? ??? CD11
                CMPB    0e8h, #014h            ; 0305 0 ??? ??? C5E8C014
                JNE     label_030e             ; 0309 0 ??? ??? CE03
                SB      off(07ff19h).2         ; 030B 0 ??? ??? C4191A
                                               ; 030E from 0309 (DD0,???,???)
label_030e:     RC                             ; 030E 0 ??? ??? 95
                JBS     off(07ff19h).2, label_0316 ; 030F 0 ??? ??? EA1904
                LB      A, #028h               ; 0312 0 ??? ??? 7728
                CMPB    A, off(07ffbbh)        ; 0314 0 ??? ??? C7BB
                                               ; 0316 from 0303 (DD0,???,???)
                                               ; 0316 from 030F (DD0,???,???)
label_0316:     MB      P2.4, C                ; 0316 0 ??? ??? C5243C
                CAL     label_2995             ; 0319 0 ??? ??? 329529
                SJ      label_0366             ; 031C 0 ??? ??? CB48
                                               ; 031E from 02F2 (DD0,???,206)
label_031e:     MOV     er0, (0020ch-00206h)[USP] ; 031E 0 ??? 206 B30648
                JBR     off(07ff19h).1, label_0329 ; 0321 0 ??? 206 D91905
                MOV     er2, er0               ; 0324 0 ??? 206 444A
                                               ; 0326 from 033B (DD0,???,206)
label_0326:     MOV     er0, (00206h-00206h)[USP] ; 0326 0 ??? 206 B30048
                                               ; 0329 from 0321 (DD0,???,206)
label_0329:     LB      A, off(07ff36h)        ; 0329 0 ??? 206 F436
                STB     A, ACCH                ; 032B 0 ??? 206 D507
                CLRB    A                      ; 032D 0 ??? 206 FA
                MUL                            ; 032E 0 ??? 206 9035
                L       A, er2                 ; 0330 1 ??? 206 36
                ADD     A, er1                 ; 0331 1 ??? 206 09
                JGE     label_0337             ; 0332 1 ??? 206 CD03
                                               ; 0334 from 02E7 (DD0,???,???)
label_0334:     L       A, #0ffffh             ; 0334 1 ??? ??? 67FFFF
                                               ; 0337 from 0332 (DD1,???,206)
                                               ; 0337 from 033F (DD1,???,206)
label_0337:     ST      A, 0dah                ; 0337 1 ??? ??? D5DA
                SJ      label_0366             ; 0339 1 ??? ??? CB2B
                                               ; 033B from 02F4 (DD0,???,206)
label_033b:     JBS     off(07ff19h).1, label_0326 ; 033B 0 ??? 206 E919E8
                CLR     A                      ; 033E 1 ??? 206 F9
                SJ      label_0337             ; 033F 1 ??? 206 CBF6
                                               ; 0341 from 02E5 (DD0,???,???)
label_0341:     CLR     A                      ; 0341 1 ??? ??? F9
                CLRB    A                      ; 0342 0 ??? ??? FA
                STB     A, r1                  ; 0343 0 ??? ??? 89
                SUBB    A, off(07ff35h)        ; 0344 0 ??? ??? A735
                L       A, ACC                 ; 0346 1 ??? ??? E506
                SLL     A                      ; 0348 1 ??? ??? 53
                MOVB    r0, off(07ff34h)       ; 0349 1 ??? ??? C43448
                SUB     A, er0                 ; 034C 1 ??? ??? 28
                SLL     A                      ; 034D 1 ??? ??? 53
                CMPB    ACCH, #0feh            ; 034E 1 ??? ??? C507C0FE
                JNE     label_0357             ; 0352 1 ??? ??? CE03
                L       A, #0ff00h             ; 0354 1 ??? ??? 6700FF
                                               ; 0357 from 0352 (DD1,???,???)
label_0357:     ST      A, 0deh                ; 0357 1 ??? ??? D5DE
                LB      A, off(07ff34h)        ; 0359 0 ??? ??? F434
                XORB    A, #0ffh               ; 035B 0 ??? ??? F6FF
                SLLB    A                      ; 035D 0 ??? ??? 53
                INCB    ACC                    ; 035E 0 ??? ??? C50616
                STB     A, off(07ff36h)        ; 0361 0 ??? ??? D436
                MB      off(07ff19h).1, C      ; 0363 0 ??? ??? C41939
                                               ; 0366 from 031C (DD0,???,???)
                                               ; 0366 from 0339 (DD1,???,???)
label_0366:     MOV     er2, #0001eh           ; 0366 0 ??? ??? 46981E00
                LB      A, 0dfh                ; 036A 0 ??? ??? F5DF
                CMPB    A, #0ffh               ; 036C 0 ??? ??? C6FF
                JEQ     label_0372             ; 036E 0 ??? ??? C902
                SUBB    A, #001h               ; 0370 0 ??? ??? A601
                                               ; 0372 from 036E (DD0,???,???)
label_0372:     ANDB    A, #003h               ; 0372 0 ??? ??? D603
                CLRB    r7                     ; 0374 0 ??? ??? 2715
                CMPB    0e4h, #001h            ; 0376 0 ??? ??? C5E4C001
                JNE     label_0380             ; 037A 0 ??? ??? CE04
                CMPB    A, #002h               ; 037C 0 ??? ??? C602
                JEQ     label_0386             ; 037E 0 ??? ??? C906
                                               ; 0380 from 037A (DD0,???,???)
label_0380:     CMPB    A, 0e4h                ; 0380 0 ??? ??? C5E4C2
                JNE     label_03c4             ; 0383 0 ??? ??? CE3F
                INCB    r7                     ; 0385 0 ??? ??? AF
                                               ; 0386 from 037E (DD0,???,???)
label_0386:     LB      A, 0deh                ; 0386 0 ??? ??? F5DE
                STB     A, ACCH                ; 0388 0 ??? ??? D507
                CLRB    A                      ; 038A 0 ??? ??? FA
                MOV     er0, 0b8h              ; 038B 0 ??? ??? B5B848
                MUL                            ; 038E 0 ??? ??? 9035
                CMPB    0dfh, #0ffh            ; 0390 0 ??? ??? C5DFC0FF
                JNE     label_03b5             ; 0394 0 ??? ??? CE1F
                L       A, TM2                 ; 0396 1 ??? ??? E538
                SUB     A, TMR1                ; 0398 1 ??? ??? B536A2
                ADD     A, #00010h             ; 039B 1 ??? ??? 861000
                CMP     A, er1                 ; 039E 1 ??? ??? 49
                JLT     label_03ab             ; 039F 1 ??? ??? CA0A
                SB      TCON2.2                ; 03A1 1 ??? ??? C5421A
                L       A, TM2                 ; 03A4 1 ??? ??? E538
                SUB     A, #00001h             ; 03A6 1 ??? ??? A60100
                SJ      label_03ae             ; 03A9 1 ??? ??? CB03
                                               ; 03AB from 039F (DD1,???,???)
label_03ab:     L       A, TMR1                ; 03AB 1 ??? ??? E536
                ADD     A, er1                 ; 03AD 1 ??? ??? 09
                                               ; 03AE from 03A9 (DD1,???,???)
label_03ae:     SB      TCON2.3                ; 03AE 1 ??? ??? C5421B
                ST      A, TMR2                ; 03B1 1 ??? ??? D53A
                SJ      label_03c4             ; 03B3 1 ??? ??? CB0F
                                               ; 03B5 from 0394 (DD0,???,???)
label_03b5:     CLR     A                      ; 03B5 1 ??? ??? F9
                JBS     off(07ff17h).0, label_03bb ; 03B6 1 ??? ??? E81702
                L       A, 0b8h                ; 03B9 1 ??? ??? E5B8
                                               ; 03BB from 03B6 (DD1,???,???)
label_03bb:     ADD     A, er1                 ; 03BB 1 ??? ??? 09
                JGE     label_03c1             ; 03BC 1 ??? ??? CD03
                L       A, #0ffffh             ; 03BE 1 ??? ??? 67FFFF
                                               ; 03C1 from 03BC (DD1,???,???)
label_03c1:     CMP     A, er2                 ; 03C1 1 ??? ??? 4A
                JGE     label_03c5             ; 03C2 1 ??? ??? CD01
                                               ; 03C4 from 0383 (DD0,???,???)
                                               ; 03C4 from 03B3 (DD1,???,???)
label_03c4:     L       A, er2                 ; 03C4 1 ??? ??? 36
                                               ; 03C5 from 03C2 (DD1,???,???)
label_03c5:     ST      A, 0d8h                ; 03C5 1 ??? ??? D5D8
                LB      A, 0e4h                ; 03C7 0 ??? ??? F5E4
                CMPB    A, #001h               ; 03C9 0 ??? ??? C601
                JEQ     label_03d3             ; 03CB 0 ??? ??? C906
                                               ; 03CD from 010C (DD1,???,???)
                                               ; 03CD from 03D3 (DD0,???,???)
                                               ; 03CD from 03FD (DD0,???,???)
label_03cd:     RB      PSWH.0                 ; 03CD 1 ??? ??? A208
                                               ; 03CF from 151C (DD1,108,13D)
label_03cf:     POPS    A                      ; 03CF 1 ??? ??? 65
                ST      A, IE                  ; 03D0 1 ??? ??? D51A
                RTI                            ; 03D2 1 ??? ??? 02
                                               ; 03D3 from 03CB (DD0,???,???)
label_03d3:     JBS     off(07ff19h).0, label_03cd ; 03D3 0 ??? ??? E819F7
                L       A, #000e0h             ; 03D6 1 ??? ??? 67E000
                JBR     off(07ff1eh).3, label_03df ; 03D9 1 ??? ??? DB1E03
                L       A, #000f0h             ; 03DC 1 ??? ??? 67F000
                                               ; 03DF from 03D9 (DD1,???,???)
label_03df:     CMP     0bah, A                ; 03DF 1 ??? ??? B5BAC1
                MOVB    r0, #003h              ; 03E2 1 ??? ??? 9803
                MB      off(07ff1eh).3, C      ; 03E4 1 ??? ??? C41E3B
                JLT     label_03fa             ; 03E7 1 ??? ??? CA11
                LB      A, #0d8h               ; 03E9 0 ??? ??? 77D8
                JBR     off(07ff1eh).2, label_03f0 ; 03EB 0 ??? ??? DA1E02
                LB      A, #0d0h               ; 03EE 0 ??? ??? 77D0
                                               ; 03F0 from 03EB (DD0,???,???)
label_03f0:     CMPB    A, 0a6h                ; 03F0 0 ??? ??? C5A6C2
                MOVB    r0, #001h              ; 03F3 0 ??? ??? 9801
                MB      off(07ff1eh).2, C      ; 03F5 0 ??? ??? C41E3A
                JGE     label_03ff             ; 03F8 0 ??? ??? CD05
                                               ; 03FA from 03E7 (DD1,???,???)
label_03fa:     LB      A, 0e5h                ; 03FA 0 ??? ??? F5E5
                ANDB    A, r0                  ; 03FC 0 ??? ??? 58
                JNE     label_03cd             ; 03FD 0 ??? ??? CECE
                                               ; 03FF from 03F8 (DD0,???,???)
label_03ff:     L       A, 0cch                ; 03FF 1 ??? ??? E5CC
                MOV     PSW, #01001h           ; 0401 1 ??? ??? B504980110
                SB      off(07ff19h).0         ; 0406 1 ??? ??? C41918
                ST      A, IE                  ; 0409 1 ??? ??? D51A
                SB      PSWH.0                 ; 040B 1 ??? ??? A218
                MOV     LRB, #00021h           ; 040D 1 108 ??? 572100
                MOV     DP, #00206h            ; 0410 1 108 ??? 620602
                CLR     A                      ; 0413 1 108 ??? F9
                ST      A, er0                 ; 0414 1 108 ??? 88
                ST      A, er1                 ; 0415 1 108 ??? 89
                                               ; 0416 from 0424 (DD1,108,???)
label_0416:     L       A, [DP]                ; 0416 1 108 ??? E2
                JEQ     label_0436             ; 0417 1 108 ??? C91D
                ADD     er0, A                 ; 0419 1 108 ??? 4481
                ADCB    r2, #000h              ; 041B 1 108 ??? 229000
                INC     DP                     ; 041E 1 108 ??? 72
                INC     DP                     ; 041F 1 108 ??? 72
                CMP     DP, #0020eh            ; 0420 1 108 ??? 92C00E02
                JNE     label_0416             ; 0424 1 108 ??? CEF0
                RORB    r2                     ; 0426 1 108 ??? 22C7
                ROR     er0                    ; 0428 1 108 ??? 44C7
                RORB    r2                     ; 042A 1 108 ??? 22C7
                ROR     er0                    ; 042C 1 108 ??? 44C7
                RB      off(0011eh).5          ; 042E 1 108 ??? C41E0D
                RB      off(0011fh).0          ; 0431 1 108 ??? C41F08
                SJ      label_043d             ; 0434 1 108 ??? CB07
                                               ; 0436 from 0417 (DD1,108,???)
label_0436:     MOV     er0, #0ffffh           ; 0436 1 108 ??? 4498FFFF
                SB      off(0011fh).0          ; 043A 1 108 ??? C41F18
                                               ; 043D from 0434 (DD1,108,???)
label_043d:     MOV     USP, #0020eh           ; 043D 1 108 20E A1980E02
                MOV     er3, (00212h-0020eh)[USP] ; 0441 1 108 20E B3044B
                L       A, (00210h-0020eh)[USP] ; 0444 1 108 20E E302
                ST      A, (00212h-0020eh)[USP] ; 0446 1 108 20E D304
                L       A, (0020eh-0020eh)[USP] ; 0448 1 108 20E E300
                ST      A, (00210h-0020eh)[USP] ; 044A 1 108 20E D302
                L       A, 0bah                ; 044C 1 108 20E E5BA
                ST      A, (0020eh-0020eh)[USP] ; 044E 1 108 20E D300
                L       A, er0                 ; 0450 1 108 20E 34
                ST      A, 0bah                ; 0451 1 108 20E D5BA
                SUB     A, er3                 ; 0453 1 108 20E 2B
                MB      off(0011eh).4, C       ; 0454 1 108 20E C41E3C
                JGE     label_045c             ; 0457 1 108 20E CD03
                ST      A, er0                 ; 0459 1 108 20E 88
                CLR     A                      ; 045A 1 108 20E F9
                SUB     A, er0                 ; 045B 1 108 20E 28
                                               ; 045C from 0457 (DD1,108,20E)
label_045c:     ST      A, 0bch                ; 045C 1 108 20E D5BC
                MOV     er2, 0bah              ; 045E 1 108 20E B5BA4A
                LB      A, r5                  ; 0461 0 108 20E 7D
                JNE     label_046d             ; 0462 0 108 20E CE09
                LB      A, r4                  ; 0464 0 108 20E 7C
                CMPB    A, #0bbh               ; 0465 0 108 20E C6BB
                LB      A, #0ffh               ; 0467 0 108 20E 77FF
                JLT     label_04a8             ; 0469 0 108 20E CA3D
                SJ      label_04a6             ; 046B 0 108 20E CB39
                                               ; 046D from 0462 (DD0,108,20E)
label_046d:     CMPB    A, #010h               ; 046D 0 108 20E C610
                JGE     label_049c             ; 046F 0 108 20E CD2B
                SWAPB                          ; 0471 0 108 20E 83
                MOV     er3, #0ffc0h           ; 0472 0 108 20E 4798C0FF
                MOV     er0, #00008h           ; 0476 0 108 20E 44980800
                MOV     DP, #00004h            ; 047A 0 108 20E 620400
                                               ; 047D from 0486 (DD0,108,20E)
label_047d:     SLLB    A                      ; 047D 0 108 20E 53
                JLT     label_0488             ; 047E 0 108 20E CA08
                SRL     er0                    ; 0480 0 108 20E 44E7
                ADD     er3, #00040h           ; 0482 0 108 20E 47804000
                JRNZ    DP, label_047d         ; 0486 0 108 20E 30F5
                                               ; 0488 from 047E (DD0,108,20E)
label_0488:     CLR     A                      ; 0488 1 108 20E F9
                DIV                            ; 0489 1 108 20E 9037
                SRL     A                      ; 048B 1 108 20E 63
                MB      PSWL.4, C              ; 048C 1 108 20E A33C
                ADD     er3, A                 ; 048E 1 108 20E 4781
                LB      A, r7                  ; 0490 0 108 20E 7F
                JNE     label_04a6             ; 0491 0 108 20E CE13
                LB      A, r6                  ; 0493 0 108 20E 7E
                JEQ     label_04a0             ; 0494 0 108 20E C90A
                CMPB    A, #0ffh               ; 0496 0 108 20E C6FF
                JGE     label_04a6             ; 0498 0 108 20E CD0C
                SJ      label_04aa             ; 049A 0 108 20E CB0E
                                               ; 049C from 046F (DD0,108,20E)
label_049c:     CLRB    A                      ; 049C 0 108 20E FA
                JBS     off(0011eh).5, label_04a2 ; 049D 0 108 20E ED1E02
                                               ; 04A0 from 0494 (DD0,108,20E)
label_04a0:     LB      A, #001h               ; 04A0 0 108 20E 7701
                                               ; 04A2 from 049D (DD0,108,20E)
label_04a2:     RB      PSWL.4                 ; 04A2 0 108 20E A30C
                SJ      label_04a8             ; 04A4 0 108 20E CB02
                                               ; 04A6 from 046B (DD0,108,20E)
                                               ; 04A6 from 0491 (DD0,108,20E)
                                               ; 04A6 from 0498 (DD0,108,20E)
label_04a6:     LB      A, #0feh               ; 04A6 0 108 20E 77FE
                                               ; 04A8 from 0469 (DD0,108,20E)
                                               ; 04A8 from 04A4 (DD0,108,20E)
label_04a8:     SB      PSWL.4                 ; 04A8 0 108 20E A31C
                                               ; 04AA from 049A (DD0,108,20E)
label_04aa:     STB     A, 0a6h                ; 04AA 0 108 20E D5A6
                MB      C, PSWL.4              ; 04AC 0 108 20E A32C
                MB      off(00129h).1, C       ; 04AE 0 108 20E C42939
                CLRB    r7                     ; 04B1 0 108 20E 2715
                JBS     off(0011eh).5, label_04c9 ; 04B3 0 108 20E ED1E13
                DECB    r7                     ; 04B6 0 108 20E BF
                MOV     er2, 0bah              ; 04B7 0 108 20E B5BA4A
                MOV     er0, #0d000h           ; 04BA 0 108 20E 449800D0
                CLR     A                      ; 04BE 1 108 20E F9
                DIV                            ; 04BF 1 108 20E 9037
                LB      A, r1                  ; 04C1 0 108 20E 79
                JNE     label_04c9             ; 04C2 0 108 20E CE05
                LB      A, r0                  ; 04C4 0 108 20E 78
                JNE     label_04ca             ; 04C5 0 108 20E CE03
                MOVB    r7, #001h              ; 04C7 0 108 20E 9F01
                                               ; 04C9 from 04B3 (DD0,108,20E)
                                               ; 04C9 from 04C2 (DD0,108,20E)
label_04c9:     LB      A, r7                  ; 04C9 0 108 20E 7F
                                               ; 04CA from 04C5 (DD0,108,20E)
label_04ca:     STB     A, 0a7h                ; 04CA 0 108 20E D5A7
                JBS     off(00130h).2, label_04f7 ; 04CC 0 108 20E EA3028
                L       A, 0b0h                ; 04CF 1 108 20E E5B0
                SWAP                           ; 04D1 1 108 20E 83
                ST      A, er0                 ; 04D2 1 108 20E 88
                LB      A, #0a1h               ; 04D3 0 108 20E 77A1
                CMPB    A, r0                  ; 04D5 0 108 20E 48
                JLT     label_04f8             ; 04D6 0 108 20E CA20
                LB      A, r0                  ; 04D8 0 108 20E 78
                CMPB    A, #00bh               ; 04D9 0 108 20E C60B
                JLT     label_04f8             ; 04DB 0 108 20E CA1B
                CMPB    A, #070h               ; 04DD 0 108 20E C670
                JGT     label_04ed             ; 04DF 0 108 20E C80C
                CAL     label_312c             ; 04E1 0 108 20E 322C31
                JGE     label_04f7             ; 04E4 0 108 20E CD11
                CLRB    A                      ; 04E6 0 108 20E FA
                SJ      label_04f7             ; 04E7 0 108 20E CB0E
                                               ; 04E9 from 04FE (DD0,108,20E)
label_04e9:     LB      A, 0b4h                ; 04E9 0 108 20E F5B4
                SJ      label_050c             ; 04EB 0 108 20E CB1F
                                               ; 04ED from 04DF (DD0,108,20E)
label_04ed:     ADDB    A, #040h               ; 04ED 0 108 20E 8640
                JLT     label_04f5             ; 04EF 0 108 20E CA04
                CMPB    A, #0e0h               ; 04F1 0 108 20E C6E0
                JLT     label_04f7             ; 04F3 0 108 20E CA02
                                               ; 04F5 from 04EF (DD0,108,20E)
label_04f5:     LB      A, #0dfh               ; 04F5 0 108 20E 77DF
                                               ; 04F7 from 04CC (DD0,108,20E)
                                               ; 04F7 from 04E4 (DD0,108,20E)
                                               ; 04F7 from 04E7 (DD0,108,20E)
                                               ; 04F7 from 04F3 (DD0,108,20E)
label_04f7:     RC                             ; 04F7 0 108 20E 95
                                               ; 04F8 from 04D6 (DD0,108,20E)
                                               ; 04F8 from 04DB (DD0,108,20E)
label_04f8:     MB      off(0012ch).0, C       ; 04F8 0 108 20E C42C38
                JBS     off(00130h).4, label_0503 ; 04FB 0 108 20E EC3005
                JLT     label_04e9             ; 04FE 0 108 20E CAE9
                JBR     off(00130h).2, label_0509 ; 0500 0 108 20E DA3006
                                               ; 0503 from 04FB (DD0,108,20E)
label_0503:     LB      A, 0ach                ; 0503 0 108 20E F5AC
                MOV     X1, #03b19h            ; 0505 0 108 20E 60193B
                VCAL    2                      ; 0508 0 108 20E 12
                                               ; 0509 from 0500 (DD0,108,20E)
label_0509:     XCHGB   A, 0b4h                ; 0509 0 108 20E C5B410
                                               ; 050C from 04EB (DD0,108,20E)
label_050c:     STB     A, 0b7h                ; 050C 0 108 20E D5B7
                LB      A, off(001e9h)         ; 050E 0 108 20E F4E9
                JEQ     label_051e             ; 0510 0 108 20E C90C
                LB      A, 0b4h                ; 0512 0 108 20E F5B4
                STB     A, 0b3h                ; 0514 0 108 20E D5B3
                                               ; 0516 from 0539 (DD1,108,20E)
label_0516:     L       A, 0bah                ; 0516 1 108 20E E5BA
                ST      A, 0beh                ; 0518 1 108 20E D5BE
                ST      A, 0c0h                ; 051A 1 108 20E D5C0
                SJ      label_0570             ; 051C 1 108 20E CB52
                                               ; 051E from 0510 (DD0,108,20E)
label_051e:     CLR     A                      ; 051E 1 108 20E F9
                J       label_2ffd             ; 051F 1 108 20E 03FD2F
                                               ; 0522 from 3007 (DD1,108,20E)
label_0522:     MOV     er1, #06000h           ; 0522 1 108 20E 45980060
                                               ; 0526 from 300A (DD1,108,20E)
label_0526:     LB      A, 0b4h                ; 0526 0 108 20E F5B4
                J       label_300d             ; 0528 0 108 20E 030D30
                DW  004c8h           ; 052B
                                               ; 052D from 3019 (DD0,108,20E)
label_052d:     MOV     er1, #03000h           ; 052D 0 108 20E 45980030
                                               ; 0531 from 301C (DD0,108,20E)
label_0531:     MOV     er0, er1               ; 0531 0 108 20E 4548
                L       A, ACC                 ; 0533 1 108 20E E506
                SWAP                           ; 0535 1 108 20E 83
                CAL     label_2d89             ; 0536 1 108 20E 32892D
                JBS     off(0012bh).3, label_0516 ; 0539 1 108 20E EB2BDA
                L       A, 0bah                ; 053C 1 108 20E E5BA
                MOV     USP, #0020eh           ; 053E 1 108 20E A1980E02
                CLRB    r0                     ; 0542 1 108 20E 2015
                ADD     A, (0020eh-0020eh)[USP] ; 0544 1 108 20E B30082
                ADCB    r0, #000h              ; 0547 1 108 20E 209000
                ADD     A, (00210h-0020eh)[USP] ; 054A 1 108 20E B30282
                ADCB    r0, #000h              ; 054D 1 108 20E 209000
                ADD     A, (00212h-0020eh)[USP] ; 0550 1 108 20E B30482
                ADCB    r0, #000h              ; 0553 1 108 20E 209000
                SRLB    r0                     ; 0556 1 108 20E 20E7
                ROR     A                      ; 0558 1 108 20E 43
                SRLB    r0                     ; 0559 1 108 20E 20E7
                ROR     A                      ; 055B 1 108 20E 43
                ST      A, 0beh                ; 055C 1 108 20E D5BE
                MOV     DP, #000c0h            ; 055E 1 108 20E 62C000
                CMP     A, [DP]                ; 0561 1 108 20E B2C2
                MOV     er0, #03000h           ; 0563 1 108 20E 44980030
                JGE     label_056d             ; 0567 1 108 20E CD04
                MOV     er0, #0d000h           ; 0569 1 108 20E 449800D0
                                               ; 056D from 0567 (DD1,108,20E)
label_056d:     CAL     label_2d89             ; 056D 1 108 20E 32892D
                                               ; 0570 from 051C (DD1,108,20E)
label_0570:     L       A, ADCR7               ; 0570 1 108 20E E56E
                MOV     DP, #000ach            ; 0572 1 108 20E 62AC00
                CAL     label_2cdb             ; 0575 1 108 20E 32DB2C
                MB      off(0011fh).2, C       ; 0578 1 108 20E C41F3A
                MB      C, off(00123h).4       ; 057B 1 108 20E C4232C
                MB      off(00123h).5, C       ; 057E 1 108 20E C4233D
                MB      C, off(00123h).3       ; 0581 1 108 20E C4232B
                MB      off(00123h).4, C       ; 0584 1 108 20E C4233C
                MOV     DP, #00278h            ; 0587 1 108 20E 627802
                LB      A, [DP]                ; 058A 0 108 20E F2
                JLT     label_058f             ; 058B 0 108 20E CA02
                ADDB    A, #002h               ; 058D 0 108 20E 8602
                                               ; 058F from 058B (DD0,108,20E)
label_058f:     ADDB    A, #003h               ; 058F 0 108 20E 8603
                CMPB    A, 0ach                ; 0591 0 108 20E C5ACC2
                MB      off(00123h).3, C       ; 0594 0 108 20E C4233B
                MB      C, off(0011fh).6       ; 0597 0 108 20E C41F2E
                MB      off(0011fh).7, C       ; 059A 0 108 20E C41F3F
                MB      C, off(0011fh).5       ; 059D 0 108 20E C41F2D
                MB      off(0011fh).6, C       ; 05A0 0 108 20E C41F3E
                LB      A, #046h               ; 05A3 0 108 20E 7746
                MOVB    r0, #077h              ; 05A5 0 108 20E 9877
                JGE     label_05ad             ; 05A7 0 108 20E CD04
                LB      A, #04eh               ; 05A9 0 108 20E 774E
                MOVB    r0, #089h              ; 05AB 0 108 20E 9889
                                               ; 05AD from 05A7 (DD0,108,20E)
label_05ad:     CMPB    0a6h, A                ; 05AD 0 108 20E C5A6C1
                JGE     label_05b6             ; 05B0 0 108 20E CD04
                LB      A, r0                  ; 05B2 0 108 20E 78
                CMPB    0b4h, A                ; 05B3 0 108 20E C5B4C1
                                               ; 05B6 from 05B0 (DD0,108,20E)
label_05b6:     MB      off(0011fh).5, C       ; 05B6 0 108 20E C41F3D
                LB      A, #000h               ; 05B9 0 108 20E 7700
                JBR     off(00122h).2, label_05c0 ; 05BB 0 108 20E DA2202
                LB      A, #000h               ; 05BE 0 108 20E 7700
                                               ; 05C0 from 05BB (DD0,108,20E)
label_05c0:     CMPB    A, 0a6h                ; 05C0 0 108 20E C5A6C2
                MB      off(00122h).2, C       ; 05C3 0 108 20E C4223A
                L       A, 0bah                ; 05C6 1 108 20E E5BA
                SUB     A, off(00172h)         ; 05C8 1 108 20E A772
                MB      off(00125h).2, C       ; 05CA 1 108 20E C4253A
                JGE     label_05d2             ; 05CD 1 108 20E CD03
                ST      A, er0                 ; 05CF 1 108 20E 88
                CLR     A                      ; 05D0 1 108 20E F9
                SUB     A, er0                 ; 05D1 1 108 20E 28
                                               ; 05D2 from 05CD (DD1,108,20E)
label_05d2:     ST      A, 0c2h                ; 05D2 1 108 20E D5C2
                CLRB    A                      ; 05D4 0 108 20E FA
                STB     A, r7                  ; 05D5 0 108 20E 8F
                CMPB    0a3h, #04fh            ; 05D6 0 108 20E C5A3C04F
                JGE     label_0610             ; 05DA 0 108 20E CD34
                JBR     off(0011fh).5, label_0610 ; 05DC 0 108 20E DD1F31
                JBS     off(00123h).3, label_0610 ; 05DF 0 108 20E EB232E
                JBS     off(0011ah).7, label_05eb ; 05E2 0 108 20E EF1A06
                JBR     off(00125h).5, label_0610 ; 05E5 0 108 20E DD2528
                JBS     off(00125h).2, label_0610 ; 05E8 0 108 20E EA2525
                                               ; 05EB from 05E2 (DD0,108,20E)
label_05eb:     INCB    r7                     ; 05EB 0 108 20E AF
                CMPB    09dh, #003h            ; 05EC 0 108 20E C59DC003
                JLE     label_060e             ; 05F0 0 108 20E CF1C
                MOVB    r1, #010h              ; 05F2 0 108 20E 9910
                JBR     off(00125h).2, label_05f9 ; 05F4 0 108 20E DA2502
                MOVB    r1, #010h              ; 05F7 0 108 20E 9910
                                               ; 05F9 from 05F4 (DD0,108,20E)
label_05f9:     STB     A, r0                  ; 05F9 0 108 20E 88
                L       A, 0c2h                ; 05FA 1 108 20E E5C2
                MUL                            ; 05FC 1 108 20E 9035
                MOVB    r4, #00ch              ; 05FE 1 108 20E 9C0C
                LB      A, r3                  ; 0600 0 108 20E 7B
                JNE     label_0607             ; 0601 0 108 20E CE04
                LB      A, r2                  ; 0603 0 108 20E 7A
                CMPB    A, r4                  ; 0604 0 108 20E 4C
                JLT     label_0608             ; 0605 0 108 20E CA01
                                               ; 0607 from 0601 (DD0,108,20E)
label_0607:     LB      A, r4                  ; 0607 0 108 20E 7C
                                               ; 0608 from 0605 (DD0,108,20E)
label_0608:     JBR     off(00125h).2, label_060e ; 0608 0 108 20E DA2503
                STB     A, r0                  ; 060B 0 108 20E 88
                CLRB    A                      ; 060C 0 108 20E FA
                SUBB    A, r0                  ; 060D 0 108 20E 28
                                               ; 060E from 05F0 (DD0,108,20E)
                                               ; 060E from 0608 (DD0,108,20E)
label_060e:     ADDB    A, #000h               ; 060E 0 108 20E 8600
                                               ; 0610 from 05DA (DD0,108,20E)
                                               ; 0610 from 05DC (DD0,108,20E)
                                               ; 0610 from 05DF (DD0,108,20E)
                                               ; 0610 from 05E5 (DD0,108,20E)
                                               ; 0610 from 05E8 (DD0,108,20E)
label_0610:     STB     A, off(0013bh)         ; 0610 0 108 20E D43B
                MB      C, r7.0                ; 0612 0 108 20E 2728
                MB      off(0011ah).7, C       ; 0614 0 108 20E C41A3F
                JBS     off(00125h).3, label_061e ; 0617 0 108 20E EB2504
                MOVB    off(001ebh), #01eh     ; 061A 0 108 20E C4EB981E
                                               ; 061E from 0617 (DD0,108,20E)
label_061e:     LB      A, off(001ebh)         ; 061E 0 108 20E F4EB
                JNE     label_0625             ; 0620 0 108 20E CE03
                J       label_0681             ; 0622 0 108 20E 038106
                                               ; 0625 from 0620 (DD0,108,20E)
                                               ; 0625 from 068C (DD1,108,20E)
label_0625:     CLR     A                      ; 0625 1 108 20E F9
                LB      A, 0b4h                ; 0626 0 108 20E F5B4
                L       A, ACC                 ; 0628 1 108 20E E506
                SWAP                           ; 062A 1 108 20E 83
                J       label_301f             ; 062B 1 108 20E 031F30
                                               ; 062E from 3029 (DD1,108,20E)
label_062e:     MOV     er0, #00480h           ; 062E 1 108 20E 44988004
                                               ; 0632 from 302C (DD1,108,20E)
label_0632:     JGE     label_063b             ; 0632 1 108 20E CD07
                J       label_302f             ; 0634 1 108 20E 032F30
                                               ; 0637 from 3039 (DD1,108,20E)
label_0637:     MOV     er0, #00500h           ; 0637 1 108 20E 44980005
                                               ; 063B from 0632 (DD1,108,20E)
                                               ; 063B from 303C (DD1,108,20E)
label_063b:     ROLB    r7                     ; 063B 1 108 20E 27B7
                CMP     A, #00100h             ; 063D 1 108 20E C60001
                JGE     label_0643             ; 0640 1 108 20E CD01
                CLR     A                      ; 0642 1 108 20E F9
                                               ; 0643 from 0640 (DD1,108,20E)
label_0643:     CMP     A, er0                 ; 0643 1 108 20E 48
                JGE     label_0647             ; 0644 1 108 20E CD01
                ST      A, er0                 ; 0646 1 108 20E 88
                                               ; 0647 from 0644 (DD1,108,20E)
label_0647:     CLRB    A                      ; 0647 0 108 20E FA
                CMPB    0a6h, #0a9h            ; 0648 0 108 20E C5A6C0A9
                JLT     label_0650             ; 064C 0 108 20E CA02
                ADDB    A, #004h               ; 064E 0 108 20E 8604
                                               ; 0650 from 064C (DD0,108,20E)
label_0650:     JBR     off(0010fh).0, label_0655 ; 0650 0 108 20E D80F02
                ADDB    A, #002h               ; 0653 0 108 20E 8602
                                               ; 0655 from 0650 (DD0,108,20E)
label_0655:     EXTND                          ; 0655 1 108 20E F8
                LC      A, 038c2h[ACC]         ; 0656 1 108 20E B506A9C238
                MUL                            ; 065B 1 108 20E 9035
                LB      A, 0b4h                ; 065D 0 108 20E F5B4
                JBS     off(0010fh).0, label_066d ; 065F 0 108 20E E80F0B
                ADDB    A, r2                  ; 0662 0 108 20E 0A
                JLT     label_0669             ; 0663 0 108 20E CA04
                CMPB    A, #0dfh               ; 0665 0 108 20E C6DF
                JLE     label_067d             ; 0667 0 108 20E CF14
                                               ; 0669 from 0663 (DD0,108,20E)
label_0669:     LB      A, #0dfh               ; 0669 0 108 20E 77DF
                SJ      label_067d             ; 066B 0 108 20E CB10
                                               ; 066D from 065F (DD0,108,20E)
label_066d:     JBS     off(00128h).1, label_0679 ; 066D 0 108 20E E92809
                NOP                            ; 0670 0 108 20E 00
                NOP                            ; 0671 0 108 20E 00
                NOP                            ; 0672 0 108 20E 00
                CMPB    0f9h, #008h            ; 0673 0 108 20E C5F9C008
                JLT     label_067d             ; 0677 0 108 20E CA04
                                               ; 0679 from 066D (DD0,108,20E)
label_0679:     SUBB    A, r2                  ; 0679 0 108 20E 2A
                JGE     label_067d             ; 067A 0 108 20E CD01
                CLRB    A                      ; 067C 0 108 20E FA
                                               ; 067D from 0667 (DD0,108,20E)
                                               ; 067D from 066B (DD0,108,20E)
                                               ; 067D from 0677 (DD0,108,20E)
                                               ; 067D from 067A (DD0,108,20E)
label_067d:     STB     A, 0b5h                ; 067D 0 108 20E D5B5
                SJ      label_06cf             ; 067F 0 108 20E CB4E
                                               ; 0681 from 0622 (DD0,108,20E)
label_0681:     L       A, 0beh                ; 0681 1 108 20E E5BE
                SUB     A, 0c0h                ; 0683 1 108 20E B5C0A2
                ST      A, er3                 ; 0686 1 108 20E 8B
                JGE     label_068e             ; 0687 1 108 20E CD05
                JBR     off(00123h).3, label_06cb ; 0689 1 108 20E DB233F
                                               ; 068C from 06B6 (DD1,108,20E)
label_068c:     SJ      label_0625             ; 068C 1 108 20E CB97
                                               ; 068E from 0687 (DD1,108,20E)
label_068e:     MOV     er2, #00019h           ; 068E 1 108 20E 46981900
                MOV     er0, #00002h           ; 0692 1 108 20E 44980200
                JBS     off(0011eh).4, label_06b6 ; 0696 1 108 20E EC1E1D
                CMP     0bch, #0009dh          ; 0699 1 108 20E B5BCC09D00
                JGE     label_06a3             ; 069E 1 108 20E CD03
                JBR     off(00120h).3, label_06b6 ; 06A0 1 108 20E DB2013
                                               ; 06A3 from 069E (DD1,108,20E)
label_06a3:     CMP     er3, #00064h           ; 06A3 1 108 20E 47C06400
                JLT     label_06b6             ; 06A7 1 108 20E CA0D
                SB      off(00120h).3          ; 06A9 1 108 20E C4201B
                MOV     er2, #0004bh           ; 06AC 1 108 20E 46984B00
                MOV     er0, #0000ah           ; 06B0 1 108 20E 44980A00
                SJ      label_06bc             ; 06B4 1 108 20E CB06
                                               ; 06B6 from 0696 (DD1,108,20E)
                                               ; 06B6 from 06A0 (DD1,108,20E)
                                               ; 06B6 from 06A7 (DD1,108,20E)
label_06b6:     JBS     off(00123h).3, label_068c ; 06B6 1 108 20E EB23D3
                RB      off(00120h).3          ; 06B9 1 108 20E C4200B
                                               ; 06BC from 06B4 (DD1,108,20E)
label_06bc:     LB      A, 0b4h                ; 06BC 0 108 20E F5B4
                STB     A, 0b5h                ; 06BE 0 108 20E D5B5
                L       A, er3                 ; 06C0 1 108 20E 37
                MUL                            ; 06C1 1 108 20E 9035
                SRL     A                      ; 06C3 1 108 20E 63
                SRL     A                      ; 06C4 1 108 20E 63
                CMP     A, er2                 ; 06C5 1 108 20E 4A
                JLT     label_06d3             ; 06C6 1 108 20E CA0B
                L       A, er2                 ; 06C8 1 108 20E 36
                SJ      label_06d3             ; 06C9 1 108 20E CB08
                                               ; 06CB from 0689 (DD1,108,20E)
label_06cb:     LB      A, 0b4h                ; 06CB 0 108 20E F5B4
                STB     A, 0b5h                ; 06CD 0 108 20E D5B5
                                               ; 06CF from 067F (DD0,108,20E)
label_06cf:     RB      off(00120h).3          ; 06CF 0 108 20E C4200B
                CLR     A                      ; 06D2 1 108 20E F9
                                               ; 06D3 from 06C6 (DD1,108,20E)
                                               ; 06D3 from 06C9 (DD1,108,20E)
label_06d3:     ST      A, off(00150h)         ; 06D3 1 108 20E D450
                LB      A, #0dfh               ; 06D5 0 108 20E 77DF
                JBS     off(00130h).2, label_06df ; 06D7 0 108 20E EA3005
                JBS     off(00130h).4, label_06df ; 06DA 0 108 20E EC3002
                LB      A, 0b5h                ; 06DD 0 108 20E F5B5
                                               ; 06DF from 06D7 (DD0,108,20E)
                                               ; 06DF from 06DA (DD0,108,20E)
label_06df:     STB     A, r6                  ; 06DF 0 108 20E 8E
                LB      A, 0a7h                ; 06E0 0 108 20E F5A7
                RC                             ; 06E2 0 108 20E 95
                MOV     X1, #03ce5h            ; 06E3 0 108 20E 60E53C
                MOV     X2, #03bc6h            ; 06E6 0 108 20E 61C63B
                JBS     off(00129h).7, label_06f7 ; 06E9 0 108 20E EF290B
                LB      A, 0a6h                ; 06EC 0 108 20E F5A6
                MB      C, off(00129h).1       ; 06EE 0 108 20E C42929
                MOV     X1, #03be6h            ; 06F1 0 108 20E 60E63B
                MOV     X2, #03bb6h            ; 06F4 0 108 20E 61B63B
                                               ; 06F7 from 06E9 (DD0,108,20E)
label_06f7:     STB     A, r7                  ; 06F7 0 108 20E 8F
                MB      off(00129h).2, C       ; 06F8 0 108 20E C4293A
                SB      PSWL.5                 ; 06FB 0 108 20E A31D
                CAL     label_2b3f             ; 06FD 0 108 20E 323F2B
                MOVB    off(00138h), A         ; 0700 0 108 20E C4388A
                LB      A, off(00130h)         ; 0703 0 108 20E F430
                ANDB    A, #074h               ; 0705 0 108 20E D674
                JNE     label_0742             ; 0707 0 108 20E CE39
                LB      A, off(00132h)         ; 0709 0 108 20E F432
                ANDB    A, #031h               ; 070B 0 108 20E D631
                JNE     label_0742             ; 070D 0 108 20E CE33
                JBS     off(00127h).3, label_0742 ; 070F 0 108 20E EB2730
                MOV     DP, #00278h            ; 0712 0 108 20E 627802
                LB      A, [DP]                ; 0715 0 108 20E F2
                JEQ     label_0742             ; 0716 0 108 20E C92A
                CMPB    0a3h, #02eh            ; 0718 0 108 20E C5A3C02E
                JGE     label_0742             ; 071C 0 108 20E CD24
                LB      A, #005h               ; 071E 0 108 20E 7705
                MOVB    r0, #0ffh              ; 0720 0 108 20E 98FF
                MOVB    r1, #0cfh              ; 0722 0 108 20E 99CF
                JBS     off(0011ah).2, label_072d ; 0724 0 108 20E EA1A06
                LB      A, #008h               ; 0727 0 108 20E 7708
                MOVB    r0, #0f0h              ; 0729 0 108 20E 98F0
                MOVB    r1, #0cbh              ; 072B 0 108 20E 99CB
                                               ; 072D from 0724 (DD0,108,20E)
label_072d:     CMPB    A, 0cbh                ; 072D 0 108 20E C5CBC2
                JGE     label_073a             ; 0730 0 108 20E CD08
                LB      A, 0cbh                ; 0732 0 108 20E F5CB
                CMPB    A, r0                  ; 0734 0 108 20E 48
                JGE     label_073a             ; 0735 0 108 20E CD03
                LB      A, 0a6h                ; 0737 0 108 20E F5A6
                CMPB    A, r1                  ; 0739 0 108 20E 49
                                               ; 073A from 0730 (DD0,108,20E)
                                               ; 073A from 0735 (DD0,108,20E)
label_073a:     MB      off(0011ah).2, C       ; 073A 0 108 20E C41A3A
                JGE     label_0742             ; 073D 0 108 20E CD03
                JBR     off(0011fh).5, label_0745 ; 073F 0 108 20E DD1F03
                                               ; 0742 from 0707 (DD0,108,20E)
                                               ; 0742 from 070D (DD0,108,20E)
                                               ; 0742 from 070F (DD0,108,20E)
                                               ; 0742 from 0716 (DD0,108,20E)
                                               ; 0742 from 071C (DD0,108,20E)
                                               ; 0742 from 073D (DD0,108,20E)
                                               ; 0742 from 0745 (DD0,108,20E)
                                               ; 0742 from 075F (DD0,108,20E)
label_0742:     J       label_07b3             ; 0742 0 108 20E 03B307
                                               ; 0745 from 073F (DD0,108,20E)
label_0745:     JBR     off(00123h).3, label_0742 ; 0745 0 108 20E DB23FA
                JBS     off(00123h).4, label_074f ; 0748 0 108 20E EC2304
                MOVB    0f5h, #003h            ; 074B 0 108 20E C5F59803
                                               ; 074F from 0748 (DD0,108,20E)
label_074f:     LB      A, 0f5h                ; 074F 0 108 20E F5F5
                JEQ     label_0797             ; 0751 0 108 20E C944
                DECB    0f5h                   ; 0753 0 108 20E C5F517
                LB      A, 0afh                ; 0756 0 108 20E F5AF
                JBS     off(00122h).2, label_075d ; 0758 0 108 20E EA2202
                LB      A, 0adh                ; 075B 0 108 20E F5AD
                                               ; 075D from 0758 (DD0,108,20E)
label_075d:     CMPB    A, #083h               ; 075D 0 108 20E C683
                JLE     label_0742             ; 075F 0 108 20E CFE1
                CLRB    0f5h                   ; 0761 0 108 20E C5F515
                MOV     X1, #038f1h            ; 0764 0 108 20E 60F138
                JBS     off(00124h).0, label_0770 ; 0767 0 108 20E E82406
                JBS     off(00124h).1, label_0770 ; 076A 0 108 20E E92403
                MOV     X1, #03901h            ; 076D 0 108 20E 600139
                                               ; 0770 from 0767 (DD0,108,20E)
                                               ; 0770 from 076A (DD0,108,20E)
label_0770:     LB      A, 0a6h                ; 0770 0 108 20E F5A6
                VCAL    0                      ; 0772 0 108 20E 10
                JBS     off(00123h).1, label_0779 ; 0773 0 108 20E E92303
                JBR     off(00123h).2, label_0786 ; 0776 0 108 20E DA230D
                                               ; 0779 from 0773 (DD0,108,20E)
label_0779:     MOVB    r0, #080h              ; 0779 0 108 20E 9880
                MULB                           ; 077B 0 108 20E A234
                SLL     ACC                    ; 077D 0 108 20E B506D7
                LB      A, ACCH                ; 0780 0 108 20E F507
                JGE     label_0786             ; 0782 0 108 20E CD02
                LB      A, #0ffh               ; 0784 0 108 20E 77FF
                                               ; 0786 from 0776 (DD0,108,20E)
                                               ; 0786 from 0782 (DD0,108,20E)
label_0786:     STB     A, off(00137h)         ; 0786 0 108 20E D437
                CMPB    0a6h, #086h            ; 0788 0 108 20E C5A6C086
                MB      off(00119h).6, C       ; 078C 0 108 20E C4193E
                LB      A, #014h               ; 078F 0 108 20E 7714
                JLT     label_0795             ; 0791 0 108 20E CA02
                LB      A, #019h               ; 0793 0 108 20E 7719
                                               ; 0795 from 0791 (DD0,108,20E)
label_0795:     STB     A, 0f4h                ; 0795 0 108 20E D5F4
                                               ; 0797 from 0751 (DD0,108,20E)
label_0797:     LB      A, off(00137h)         ; 0797 0 108 20E F437
                JEQ     label_07b6             ; 0799 0 108 20E C91B
                MOV     DP, #03911h            ; 079B 0 108 20E 621139
                JBS     off(00119h).6, label_07a3 ; 079E 0 108 20E EE1902
                INC     DP                     ; 07A1 0 108 20E 72
                INC     DP                     ; 07A2 0 108 20E 72
                                               ; 07A3 from 079E (DD0,108,20E)
label_07a3:     LB      A, 0f4h                ; 07A3 0 108 20E F5F4
                JEQ     label_07ab             ; 07A5 0 108 20E C904
                INC     DP                     ; 07A7 0 108 20E 72
                DECB    0f4h                   ; 07A8 0 108 20E C5F417
                                               ; 07AB from 07A5 (DD0,108,20E)
label_07ab:     LCB     A, [DP]                ; 07AB 0 108 20E 92AA
                STB     A, r0                  ; 07AD 0 108 20E 88
                LB      A, off(00137h)         ; 07AE 0 108 20E F437
                SUBB    A, r0                  ; 07B0 0 108 20E 28
                JGE     label_07b4             ; 07B1 0 108 20E CD01
                                               ; 07B3 from 0742 (DD0,108,20E)
label_07b3:     CLRB    A                      ; 07B3 0 108 20E FA
                                               ; 07B4 from 07B1 (DD0,108,20E)
label_07b4:     STB     A, off(00137h)         ; 07B4 0 108 20E D437
                                               ; 07B6 from 0799 (DD0,108,20E)
label_07b6:     LB      A, off(0013fh)         ; 07B6 0 108 20E F43F
                JEQ     label_07dc             ; 07B8 0 108 20E C922
                JBS     off(0013fh).7, label_07dc ; 07BA 0 108 20E EF3F1F
                CMPB    0a3h, #02eh            ; 07BD 0 108 20E C5A3C02E
                JLT     label_07dc             ; 07C1 0 108 20E CA19
                CMPB    0f8h, #00ah            ; 07C3 0 108 20E C5F8C00A
                JLT     label_07dc             ; 07C7 0 108 20E CA13
                LB      A, 0a3h                ; 07C9 0 108 20E F5A3
                MOV     X1, #03919h            ; 07CB 0 108 20E 601939
                VCAL    2                      ; 07CE 0 108 20E 12
                STB     A, r7                  ; 07CF 0 108 20E 8F
                CLRB    r6                     ; 07D0 0 108 20E 2615
                MOV     X1, #0391dh            ; 07D2 0 108 20E 601D39
                CAL     label_2be4             ; 07D5 0 108 20E 32E42B
                CLRB    A                      ; 07D8 0 108 20E FA
                SUBB    A, r6                  ; 07D9 0 108 20E 2E
                ADDB    A, off(0013fh)         ; 07DA 0 108 20E 873F
                                               ; 07DC from 07B8 (DD0,108,20E)
                                               ; 07DC from 07BA (DD0,108,20E)
                                               ; 07DC from 07C1 (DD0,108,20E)
                                               ; 07DC from 07C7 (DD0,108,20E)
label_07dc:     STB     A, off(0013ah)         ; 07DC 0 108 20E D43A
                CAL     label_317b             ; 07DE 0 108 20E 327B31
                LB      A, 0a7h                ; 07E1 0 108 20E F5A7
                VCAL    0                      ; 07E3 0 108 20E 10
                STB     A, off(0013eh)         ; 07E4 0 108 20E D43E
                LB      A, off(00137h)         ; 07E6 0 108 20E F437
                JEQ     label_07fa             ; 07E8 0 108 20E C910
                STB     A, r0                  ; 07EA 0 108 20E 88
                SC                             ; 07EB 0 108 20E 85
                LB      A, 0f4h                ; 07EC 0 108 20E F5F4
                JNE     label_07fc             ; 07EE 0 108 20E CE0C
                JBS     off(0011eh).4, label_07fc ; 07F0 0 108 20E EC1E09
                CMP     0bch, #00010h          ; 07F3 0 108 20E B5BCC01000
                JLT     label_07fc             ; 07F8 0 108 20E CA02
                                               ; 07FA from 07E8 (DD0,108,20E)
label_07fa:     STB     A, r0                  ; 07FA 0 108 20E 88
                RC                             ; 07FB 0 108 20E 95
                                               ; 07FC from 07EE (DD0,108,20E)
                                               ; 07FC from 07F0 (DD0,108,20E)
                                               ; 07FC from 07F8 (DD0,108,20E)
label_07fc:     MB      off(00119h).7, C       ; 07FC 0 108 20E C4193F
                LB      A, off(00138h)         ; 07FF 0 108 20E F438
                SUBB    A, r0                  ; 0801 0 108 20E 28
                JLT     label_080b             ; 0802 0 108 20E CA07
                JBR     off(00119h).5, label_080c ; 0804 0 108 20E DD1905
                ADDB    A, #0f8h               ; 0807 0 108 20E 86F8
                JLT     label_080c             ; 0809 0 108 20E CA01
                                               ; 080B from 0802 (DD0,108,20E)
label_080b:     CLRB    A                      ; 080B 0 108 20E FA
                                               ; 080C from 0804 (DD0,108,20E)
                                               ; 080C from 0809 (DD0,108,20E)
label_080c:     MOV     DP, #00005h            ; 080C 0 108 20E 620500
                MOV     USP, #00139h           ; 080F 0 108 139 A1983901
                JBR     off(00130h).5, label_081d ; 0813 0 108 139 DD3007
                MOV     DP, #00001h            ; 0816 0 108 139 620100
                MOV     USP, #0013ch           ; 0819 0 108 13C A1983C01
                                               ; 081D from 0813 (DD0,108,139)
                                               ; 081D from 0833 (DD0,108,13D)
label_081d:     MB      C, (0013ch-0013ch)[USP].7 ; 081D 0 108 13C C3002F
                ROLB    r7                     ; 0820 0 108 13C 27B7
                ADDB    A, (0013ch-0013ch)[USP] ; 0822 0 108 13C C30082
                JBS     off(0010fh).0, label_082e ; 0825 0 108 13C E80F06
                JGE     label_0831             ; 0828 0 108 13C CD07
                LB      A, #0ffh               ; 082A 0 108 13C 77FF
                SJ      label_0831             ; 082C 0 108 13C CB03
                                               ; 082E from 0825 (DD0,108,13C)
label_082e:     JLT     label_0831             ; 082E 0 108 13C CA01
                CLRB    A                      ; 0830 0 108 13C FA
                                               ; 0831 from 0828 (DD0,108,13C)
                                               ; 0831 from 082C (DD0,108,13C)
                                               ; 0831 from 082E (DD0,108,13C)
label_0831:     INC     USP                    ; 0831 0 108 13D A116
                JRNZ    DP, label_081d         ; 0833 0 108 13D 30E8
                STB     A, r2                  ; 0835 0 108 13D 8A
                LB      A, #046h               ; 0836 0 108 13D 7746
                JBS     off(00119h).4, label_083d ; 0838 0 108 13D EC1902
                LB      A, #054h               ; 083B 0 108 13D 7754
                                               ; 083D from 0838 (DD0,108,13D)
label_083d:     CMPB    A, 0a6h                ; 083D 0 108 13D C5A6C2
                MB      off(00119h).4, C       ; 0840 0 108 13D C4193C
                JLT     label_086c             ; 0843 0 108 13D CA27
                LB      A, 0a3h                ; 0845 0 108 13D F5A3
                CMPB    A, #0fbh               ; 0847 0 108 13D C6FB
                JGE     label_086c             ; 0849 0 108 13D CD21
                CMPB    A, #013h               ; 084B 0 108 13D C613
                JLT     label_086c             ; 084D 0 108 13D CA1D
                MB      C, P2.4                ; 084F 0 108 13D C5242C
                JLT     label_0873             ; 0852 0 108 13D CA1F
                MOV     DP, #038cah            ; 0854 0 108 13D 62CA38
                CMPB    A, #070h               ; 0857 0 108 13D C670
                JGE     label_0861             ; 0859 0 108 13D CD06
                INC     DP                     ; 085B 0 108 13D 72
                CMPB    A, #050h               ; 085C 0 108 13D C650
                JGE     label_0861             ; 085E 0 108 13D CD01
                INC     DP                     ; 0860 0 108 13D 72
                                               ; 0861 from 0859 (DD0,108,13D)
                                               ; 0861 from 085E (DD0,108,13D)
label_0861:     LCB     A, [DP]                ; 0861 0 108 13D 92AA
                ADDB    A, off(00133h)         ; 0863 0 108 13D 8733
                JLT     label_086c             ; 0865 0 108 13D CA05
                STB     A, off(00133h)         ; 0867 0 108 13D D433
                CMPB    A, r2                  ; 0869 0 108 13D 4A
                JLT     label_0877             ; 086A 0 108 13D CA0B
                                               ; 086C from 0843 (DD0,108,13D)
                                               ; 086C from 0849 (DD0,108,13D)
                                               ; 086C from 084D (DD0,108,13D)
                                               ; 086C from 0865 (DD0,108,13D)
label_086c:     LB      A, r2                  ; 086C 0 108 13D 7A
                MOVB    off(00133h), #0ffh     ; 086D 0 108 13D C43398FF
                SJ      label_0877             ; 0871 0 108 13D CB04
                                               ; 0873 from 0852 (DD0,108,13D)
label_0873:     LB      A, #022h               ; 0873 0 108 13D 7722
                STB     A, off(00133h)         ; 0875 0 108 13D D433
                                               ; 0877 from 086A (DD0,108,13D)
                                               ; 0877 from 0871 (DD0,108,13D)
label_0877:     ADDB    A, off(0013eh)         ; 0877 0 108 13D 873E
                JGE     label_087d             ; 0879 0 108 13D CD02
                LB      A, #0ffh               ; 087B 0 108 13D 77FF
                                               ; 087D from 0879 (DD0,108,13D)
label_087d:     STB     A, r2                  ; 087D 0 108 13D 8A
                MOV     X1, #038d7h            ; 087E 0 108 13D 60D738
                LB      A, 0a7h                ; 0881 0 108 13D F5A7
                VCAL    0                      ; 0883 0 108 13D 10
                STB     A, r3                  ; 0884 0 108 13D 8B
                MOV     X1, #038e5h            ; 0885 0 108 13D 60E538
                LB      A, 09ah                ; 0888 0 108 13D F59A
                VCAL    0                      ; 088A 0 108 13D 10
                EXTND                          ; 088B 1 108 13D F8
                MOVB    r0, r3                 ; 088C 1 108 13D 2348
                MULB                           ; 088E 1 108 13D A234
                MOVB    r0, #0b3h              ; 0890 1 108 13D 98B3
                SLL     A                      ; 0892 1 108 13D 53
                JLT     label_08a2             ; 0893 1 108 13D CA0D
                SLL     A                      ; 0895 1 108 13D 53
                JLT     label_08a2             ; 0896 1 108 13D CA0A
                LB      A, ACCH                ; 0898 0 108 13D F507
                CMPB    A, r0                  ; 089A 0 108 13D 48
                JGE     label_08a2             ; 089B 0 108 13D CD05
                MOVB    r0, #00fh              ; 089D 0 108 13D 980F
                CMPB    A, r0                  ; 089F 0 108 13D 48
                JGE     label_08a3             ; 08A0 0 108 13D CD01
                                               ; 08A2 from 0893 (DD1,108,13D)
                                               ; 08A2 from 0896 (DD1,108,13D)
                                               ; 08A2 from 089B (DD0,108,13D)
label_08a2:     LB      A, r0                  ; 08A2 0 108 13D 78
                                               ; 08A3 from 08A0 (DD0,108,13D)
label_08a3:     STB     A, ACCH                ; 08A3 0 108 13D D507
                LB      A, r2                  ; 08A5 0 108 13D 7A
                MOV     off(00134h), A         ; 08A6 0 108 13D B4348A
                LB      A, ADCR6H              ; 08A9 0 108 13D F56D
                STB     A, 0a5h                ; 08AB 0 108 13D D5A5
                JBS     off(0011fh).4, label_08b3 ; 08AD 0 108 13D EC1F03
                J       label_0988             ; 08B0 0 108 13D 038809
                                               ; 08B3 from 08AD (DD0,108,13D)
label_08b3:     JBR     off(00130h).5, label_08d0 ; 08B3 0 108 13D DD301A
                CLR     A                      ; 08B6 1 108 13D F9
                MOV     DP, #03b0dh            ; 08B7 1 108 13D 620D3B
                LB      A, off(001eah)         ; 08BA 0 108 13D F4EA
                MOVB    r0, #014h              ; 08BC 0 108 13D 9814
                DIVB                           ; 08BE 0 108 13D A236
                EXTND                          ; 08C0 1 108 13D F8
                SLL     A                      ; 08C1 1 108 13D 53
                SUB     DP, A                  ; 08C2 1 108 13D 92A1
                LC      A, [DP]                ; 08C4 1 108 13D 92A8
                ST      A, off(00140h)         ; 08C6 1 108 13D D440
                LC      A, 0000ah[DP]          ; 08C8 1 108 13D 92A90A00
                ST      A, off(0016ch)         ; 08CC 1 108 13D D46C
                SJ      label_08e6             ; 08CE 1 108 13D CB16
                                               ; 08D0 from 08B3 (DD0,108,13D)
label_08d0:     LB      A, 0a3h                ; 08D0 0 108 13D F5A3
                MOV     X1, #03967h            ; 08D2 0 108 13D 606739
                JBS     off(0011ah).5, label_08db ; 08D5 0 108 13D ED1A03
                MOV     X1, #0397ch            ; 08D8 0 108 13D 607C39
                                               ; 08DB from 08D5 (DD0,108,13D)
label_08db:     VCAL    1                      ; 08DB 0 108 13D 11
                STB     A, off(00140h)         ; 08DC 0 108 13D D440
                LB      A, 0eeh                ; 08DE 0 108 13D F5EE
                MOV     X1, #03963h            ; 08E0 0 108 13D 606339
                VCAL    2                      ; 08E3 0 108 13D 12
                STB     A, off(00153h)         ; 08E4 0 108 13D D453
                                               ; 08E6 from 08CE (DD1,108,13D)
label_08e6:     LB      A, 0bbh                ; 08E6 0 108 13D F5BB
                MOV     X1, #0395fh            ; 08E8 0 108 13D 605F39
                VCAL    2                      ; 08EB 0 108 13D 12
                STB     A, off(00168h)         ; 08EC 0 108 13D D468
                EXTND                          ; 08EE 1 108 13D F8
                MOVB    r0, off(00153h)        ; 08EF 1 108 13D C45348
                MULB                           ; 08F2 1 108 13D A234
                MOV     er0, off(00140h)       ; 08F4 1 108 13D B44048
                MUL                            ; 08F7 1 108 13D 9035
                MB      C, 0fdh.7              ; 08F9 1 108 13D C5FD2F
                JLT     label_090c             ; 08FC 1 108 13D CA0E
                ROL     A                      ; 08FE 1 108 13D 33
                ROL     er1                    ; 08FF 1 108 13D 45B7
                JLT     label_0908             ; 0901 1 108 13D CA05
                ROL     A                      ; 0903 1 108 13D 33
                ROL     er1                    ; 0904 1 108 13D 45B7
                JGE     label_090c             ; 0906 1 108 13D CD04
                                               ; 0908 from 0901 (DD1,108,13D)
label_0908:     MOV     er1, #0ffffh           ; 0908 1 108 13D 4598FFFF
                                               ; 090C from 08FC (DD1,108,13D)
                                               ; 090C from 0906 (DD1,108,13D)
label_090c:     MOV     off(00144h), er1       ; 090C 1 108 13D 457C44
                L       A, off(0014ch)         ; 090F 1 108 13D E44C
                ST      A, off(00146h)         ; 0911 1 108 13D D446
                ADD     A, er1                 ; 0913 1 108 13D 09
                JGE     label_0919             ; 0914 1 108 13D CD03
                L       A, #0ffffh             ; 0916 1 108 13D 67FFFF
                                               ; 0919 from 0914 (DD1,108,13D)
label_0919:     ST      A, 0d6h                ; 0919 1 108 13D D5D6
                ST      A, off(00148h)         ; 091B 1 108 13D D448
                CMPB    0e6h, #004h            ; 091D 1 108 13D C5E6C004
                JEQ     label_0929             ; 0921 1 108 13D C906
                MB      C, 0fdh.7              ; 0923 1 108 13D C5FD2F
                JLT     label_0929             ; 0926 1 108 13D CA01
                CLR     A                      ; 0928 1 108 13D F9
                                               ; 0929 from 0921 (DD1,108,13D)
                                               ; 0929 from 0926 (DD1,108,13D)
label_0929:     ST      A, 0d0h                ; 0929 1 108 13D D5D0
                ST      A, 0d2h                ; 092B 1 108 13D D5D2
                ST      A, 0d4h                ; 092D 1 108 13D D5D4
                L       A, #08000h             ; 092F 1 108 13D 670080
                ST      A, off(00162h)         ; 0932 1 108 13D D462
                ST      A, off(00164h)         ; 0934 1 108 13D D464
                RB      off(0011bh).0          ; 0936 1 108 13D C41B08
                RB      off(0011ch).0          ; 0939 1 108 13D C41C08
                CAL     label_29b1             ; 093C 1 108 13D 32B129
                MOV     LRB, #00021h           ; 093F 1 108 13D 572100
                RB      0feh.6                 ; 0942 1 108 13D C5FE0E
                LB      A, 0e5h                ; 0945 0 108 13D F5E5
                ADDB    A, #001h               ; 0947 0 108 13D 8601
                ANDB    A, #003h               ; 0949 0 108 13D D603
                STB     A, 0e5h                ; 094B 0 108 13D D5E5
                JBS     off(00130h).5, label_097a ; 094D 0 108 13D ED302A
                MOV     X1, #037d4h            ; 0950 0 108 13D 60D437
                L       A, #037e6h             ; 0953 1 108 13D 67E637
                JBS     off(0011ah).5, label_095a ; 0956 1 108 13D ED1A01
                MOV     X1, A                  ; 0959 1 108 13D 50
                                               ; 095A from 0956 (DD1,108,13D)
label_095a:     LB      A, 0a3h                ; 095A 0 108 13D F5A3
                VCAL    1                      ; 095C 0 108 13D 11
                CMPB    0a4h, #034h            ; 095D 0 108 13D C5A4C034
                JGE     label_0966             ; 0961 0 108 13D CD03
                ADDB    A, #000h               ; 0963 0 108 13D 8600
                NOP                            ; 0965 0 108 13D 00
                                               ; 0966 from 0961 (DD0,108,13D)
label_0966:     STB     A, off(0016ch)         ; 0966 0 108 13D D46C
                LB      A, 0a3h                ; 0968 0 108 13D F5A3
                MOV     X1, #0370dh            ; 096A 0 108 13D 600D37
                VCAL    0                      ; 096D 0 108 13D 10
                MOVB    r0, #008h              ; 096E 0 108 13D 9808
                MULB                           ; 0970 0 108 13D A234
                L       A, ACC                 ; 0972 1 108 13D E506
                SRL     A                      ; 0974 1 108 13D 63
                CMP     A, #00100h             ; 0975 1 108 13D C60001
                JGE     label_097d             ; 0978 1 108 13D CD03
                                               ; 097A from 094D (DD0,108,13D)
label_097a:     L       A, #00100h             ; 097A 1 108 13D 670001
                                               ; 097D from 0978 (DD1,108,13D)
label_097d:     ST      A, off(0016ah)         ; 097D 1 108 13D D46A
                CLRB    off(0016eh)            ; 097F 1 108 13D C46E15
                CAL     label_2e6c             ; 0982 1 108 13D 326C2E
                J       label_150f             ; 0985 1 108 13D 030F15

                ;fuel maps
                                               ; 0988 from 08B0 (DD0,108,13D)
label_0988:     MOVB    r6, 0b5h               ; 0988 0 108 13D C5B54E
                MOVB    r7, 0a6h               ; 098B 0 108 13D C5A64F
                MOV     X1, #03de4h            ; 098E 0 108 13D 60E43D
                MOV     X2, #03bd6h            ; 0991 0 108 13D 61D63B

                ;logging change
                CAL		SBnonvtec
                NOP
                NOP
                NOP
              ;  MB      C, off(00129h).1       ; 0994 0 108 13D C42929
              ;  MB      off(00129h).2, C       ; 0997 0 108 13D C4293A

                RB      PSWL.5                 ; 099A 0 108 13D A30D
                CAL     label_2b3f             ; 099C 0 108 13D 323F2B
                CAL     label_2bc8             ; 099F 0 108 13D 32C82B
                STB     A, off(00140h)         ; 09A2 0 108 13D D440


                MOVB    r6, 0b5h               ; 09A4 0 108 13D C5B54E
                MOVB    r7, 0a7h               ; 09A7 0 108 13D C5A74F
                MOV     X1, #03ef2h            ; 09AA 0 108 13D 60F23E
                MOV     X2, #03be6h            ; 09AD 0 108 13D 61E63B

                ;logging change
                CAL		SBvtec
              ;  RB      off(00129h).2          ; 09B0 0 108 13D C4290A

                RB      PSWL.5                 ; 09B3 0 108 13D A30D
                CAL     label_2b3f             ; 09B5 0 108 13D 323F2B
                CAL     label_2bc8             ; 09B8 0 108 13D 32C82B
                STB     A, off(00142h)         ; 09BB 0 108 13D D442
                LB      A, #003h               ; 09BD 0 108 13D 7703
                JBS     off(0012bh).6, label_09c4 ; 09BF 0 108 13D EE2B02
                LB      A, #008h               ; 09C2 0 108 13D 7708
                                               ; 09C4 from 09BF (DD0,108,13D)
label_09c4:     CMPB    A, 0a6h                ; 09C4 0 108 13D C5A6C2
                MB      off(0012bh).6, C       ; 09C7 0 108 13D C42B3E
                MB      C, off(0012bh).4       ; 09CA 0 108 13D C42B2C
                MB      off(0012bh).5, C       ; 09CD 0 108 13D C42B3D
                MB      C, off(0012bh).3       ; 09D0 0 108 13D C42B2B
                MB      off(0012bh).4, C       ; 09D3 0 108 13D C42B3C
                LB      A, #0c5h               ; 09D6 0 108 13D 77C5
                JBS     off(0012bh).3, label_09dd ; 09D8 0 108 13D EB2B02
                LB      A, #0c9h               ; 09DB 0 108 13D 77C9
                                               ; 09DD from 09D8 (DD0,108,13D)
label_09dd:     CMPB    A, 0a6h                ; 09DD 0 108 13D C5A6C2
                MB      off(0012bh).3, C       ; 09E0 0 108 13D C42B3B
                MOVB    r0, #020h              ; 09E3 0 108 13D 9820
                JBS     off(00129h).3, label_09ea ; 09E5 0 108 13D EB2902
                MOVB    r0, #028h              ; 09E8 0 108 13D 9828
                                               ; 09EA from 09E5 (DD0,108,13D)
label_09ea:     MOV     DP, #03aech            ; 09EA 0 108 13D 62EC3A
                MOV     X1, #03af0h            ; 09ED 0 108 13D 60F03A
                LB      A, r0                  ; 09F0 0 108 13D 78
                CMPB    A, 0cbh                ; 09F1 0 108 13D C5CBC2
                MB      off(00129h).3, C       ; 09F4 0 108 13D C4293B
                LC      A, [DP]                ; 09F7 0 108 13D 92A8
                INC     DP                     ; 09F9 0 108 13D 72
                INC     DP                     ; 09FA 0 108 13D 72
                JBS     off(00129h).4, label_0a00 ; 09FB 0 108 13D EC2902
                LB      A, ACCH                ; 09FE 0 108 13D F507
                                               ; 0A00 from 09FB (DD0,108,13D)
label_0a00:     CMPB    A, 0a6h                ; 0A00 0 108 13D C5A6C2
                MB      off(00129h).4, C       ; 0A03 0 108 13D C4293C
                LC      A, [DP]                ; 0A06 0 108 13D 92A8
                JBS     off(00129h).5, label_0a0d ; 0A08 0 108 13D ED2902
                LB      A, ACCH                ; 0A0B 0 108 13D F507
                                               ; 0A0D from 0A08 (DD0,108,13D)
label_0a0d:     CMPB    A, 0a6h                ; 0A0D 0 108 13D C5A6C2
                MB      off(00129h).5, C       ; 0A10 0 108 13D C4293D
                LB      A, 0a6h                ; 0A13 0 108 13D F5A6
                VCAL    1                      ; 0A15 0 108 13D 11
                STB     A, off(00154h)         ; 0A16 0 108 13D D454
                LB      A, off(00130h)         ; 0A18 0 108 13D F430
                ANDB    A, #0bch               ; 0A1A 0 108 13D D6BC
                JNE     label_0a28             ; 0A1C 0 108 13D CE0A
                MOV     er0, #0fcedh           ; 0A1E 0 108 13D 4498EDFC
                LB      A, off(00132h)         ; 0A22 0 108 13D F432
                ANDB    A, #031h               ; 0A24 0 108 13D D631
                JEQ     label_0a2d             ; 0A26 0 108 13D C905
                                               ; 0A28 from 0A1C (DD0,108,13D)
label_0a28:     SB      P0.1                   ; 0A28 0 108 13D C52019
                SJ      label_0a45             ; 0A2B 0 108 13D CB18
                                               ; 0A2D from 0A26 (DD0,108,13D)
label_0a2d:     RB      P0.1                   ; 0A2D 0 108 13D C52009
                CMPB    0f8h, #032h            ; 0A30 0 108 13D C5F8C032
                JLT     label_0a45             ; 0A34 0 108 13D CA0F
                CMPB    0a3h, #044h            ; 0A36 0 108 13D C5A3C044
                JGE     label_0a45             ; 0A3A 0 108 13D CD09
                JBR     off(00129h).3, label_0a45 ; 0A3C 0 108 13D DB2906
                JBS     off(00129h).4, label_0a4d ; 0A3F 0 108 13D EC290B
                JBS     off(00129h).7, label_0a96 ; 0A42 0 108 13D EF2951
                                               ; 0A45 from 0A2B (DD0,108,13D)
                                               ; 0A45 from 0A34 (DD0,108,13D)
                                               ; 0A45 from 0A3A (DD0,108,13D)
                                               ; 0A45 from 0A3C (DD0,108,13D)
label_0a45:     SB      P0.0                   ; 0A45 0 108 13D C52018
                RB      off(00129h).6          ; 0A48 0 108 13D C4290E
                SJ      label_0aa8             ; 0A4B 0 108 13D CB5B
                                               ; 0A4D from 0A3F (DD0,108,13D)
label_0a4d:     JBS     off(00129h).5, label_0a7a ; 0A4D 0 108 13D ED292A
                JBS     off(0012bh).3, label_0a6e ; 0A50 0 108 13D EB2B1B
                JBS     off(0012bh).0, label_0a7a ; 0A53 0 108 13D E82B24
                                               ; 0A56 from 0A78 (DD1,108,13D)
label_0a56:     L       A, off(00140h)         ; 0A56 1 108 13D E440
                JBR     off(00129h).6, label_0a64 ; 0A58 1 108 13D DE2909
                MUL                            ; 0A5B 1 108 13D 9035
                L       A, er1                 ; 0A5D 1 108 13D 35
                SUB     A, #00000h             ; 0A5E 1 108 13D A60000
                JGE     label_0a64             ; 0A61 1 108 13D CD01
                CLR     A                      ; 0A63 1 108 13D F9
                                               ; 0A64 from 0A58 (DD1,108,13D)
                                               ; 0A64 from 0A61 (DD1,108,13D)
label_0a64:     CMP     A, off(00142h)         ; 0A64 1 108 13D C742
                JLT     label_0a7a             ; 0A66 1 108 13D CA12
                LB      A, off(001dbh)         ; 0A68 0 108 13D F4DB
                JNE     label_0a7e             ; 0A6A 0 108 13D CE12
                SJ      label_0a96             ; 0A6C 0 108 13D CB28
                                               ; 0A6E from 0A50 (DD0,108,13D)
label_0a6e:     L       A, 0d6h                ; 0A6E 1 108 13D E5D6
                JBR     off(00129h).6, label_0a76 ; 0A70 1 108 13D DE2903
                ADD     A, #000a0h             ; 0A73 1 108 13D 86A000
                                               ; 0A76 from 0A70 (DD1,108,13D)
label_0a76:     CMP     A, off(00154h)         ; 0A76 1 108 13D C754
                JLT     label_0a56             ; 0A78 1 108 13D CADC
                                               ; 0A7A from 0A4D (DD0,108,13D)
                                               ; 0A7A from 0A53 (DD0,108,13D)
                                               ; 0A7A from 0A66 (DD1,108,13D)
label_0a7a:     MOVB    off(001dbh), #014h     ; 0A7A 0 108 13D C4DB9814
                                               ; 0A7E from 0A6A (DD0,108,13D)
label_0a7e:     RB      P0.0                   ; 0A7E 0 108 13D C52008
                SB      off(00129h).6          ; 0A81 0 108 13D C4291E
                MB      C, 0ffh.2              ; 0A84 0 108 13D C5FF2A
                JGE     label_0aa4             ; 0A87 0 108 13D CD1B
                                               ; 0A89 from 0AA2 (DD0,108,13D)
label_0a89:     LB      A, off(001b6h)         ; 0A89 0 108 13D F4B6
                JNE     label_0aac             ; 0A8B 0 108 13D CE1F
                MOVB    off(001b7h), #00ah     ; 0A8D 0 108 13D C4B7980A
                                               ; 0A91 from 0AA6 (DD0,108,13D)
label_0a91:     SB      off(00129h).7          ; 0A91 0 108 13D C4291F
                SJ      label_0aaf             ; 0A94 0 108 13D CB19
                                               ; 0A96 from 0A42 (DD0,108,13D)
                                               ; 0A96 from 0A6C (DD0,108,13D)
label_0a96:     CLRB    off(001dbh)            ; 0A96 0 108 13D C4DB15
                SB      P0.0                   ; 0A99 0 108 13D C52018
                RB      off(00129h).6          ; 0A9C 0 108 13D C4290E
                MB      C, 0ffh.2              ; 0A9F 0 108 13D C5FF2A
                JLT     label_0a89             ; 0AA2 0 108 13D CAE5
                                               ; 0AA4 from 0A87 (DD0,108,13D)
label_0aa4:     LB      A, off(001b7h)         ; 0AA4 0 108 13D F4B7
                JNE     label_0a91             ; 0AA6 0 108 13D CEE9
                                               ; 0AA8 from 0A4B (DD0,108,13D)
label_0aa8:     MOVB    off(001b6h), #00ah     ; 0AA8 0 108 13D C4B6980A
                                               ; 0AAC from 0A8B (DD0,108,13D)
label_0aac:     RB      off(00129h).7          ; 0AAC 0 108 13D C4290F
                                               ; 0AAF from 0A94 (DD0,108,13D)
label_0aaf:     JBS     off(00123h).3, label_0acd ; 0AAF 0 108 13D EB231B
                CMPB    0a3h, #001h            ; 0AB2 0 108 13D C5A3C001
                JGE     label_0ace             ; 0AB6 0 108 13D CD16
                LB      A, #0ffh               ; 0AB8 0 108 13D 77FF
                CMPB    A, 0a6h                ; 0ABA 0 108 13D C5A6C2
                JGE     label_0ace             ; 0ABD 0 108 13D CD0F
                JBS     off(00123h).0, label_0ace ; 0ABF 0 108 13D E8230C
                JBS     off(0011eh).4, label_0acd ; 0AC2 0 108 13D EC1E08
                L       A, #0ffffh             ; 0AC5 1 108 13D 67FFFF
                CMP     A, 0bch                ; 0AC8 1 108 13D B5BCC2
                JLT     label_0ace             ; 0ACB 1 108 13D CA01
                                               ; 0ACD from 0AAF (DD0,108,13D)
                                               ; 0ACD from 0AC2 (DD0,108,13D)
label_0acd:     RC                             ; 0ACD 1 108 13D 95
                                               ; 0ACE from 0AB6 (DD0,108,13D)
                                               ; 0ACE from 0ABD (DD0,108,13D)
                                               ; 0ACE from 0ABF (DD0,108,13D)
                                               ; 0ACE from 0ACB (DD1,108,13D)
label_0ace:     MB      off(00123h).0, C       ; 0ACE 1 108 13D C42338
                MB      C, off(00123h).1       ; 0AD1 1 108 13D C42329
                MB      off(00123h).2, C       ; 0AD4 1 108 13D C4233A
                MB      C, 0feh.6              ; 0AD7 1 108 13D C5FE2E
                MB      off(00123h).1, C       ; 0ADA 1 108 13D C42339
                MOV     X1, #0393ah            ; 0ADD 1 108 13D 603A39
                LB      A, 0a6h                ; 0AE0 0 108 13D F5A6
                VCAL    0                      ; 0AE2 0 108 13D 10
                SUBB    A, off(0019fh)         ; 0AE3 0 108 13D A79F
                JGE     label_0ae8             ; 0AE5 0 108 13D CD01
                CLRB    A                      ; 0AE7 0 108 13D FA
                                               ; 0AE8 from 0AE5 (DD0,108,13D)
label_0ae8:     STB     A, off(001a2h)         ; 0AE8 0 108 13D D4A2
                MOVB    r6, #040h              ; 0AEA 0 108 13D 9E40
                L       A, #0602eh             ; 0AEC 1 108 13D 672E60
                MOV     X1, #03944h            ; 0AEF 1 108 13D 604439
                MOV     DP, #03954h            ; 0AF2 1 108 13D 625439
                ST      A, er1                 ; 0AF5 1 108 13D 89
                LB      A, 0a3h                ; 0AF6 0 108 13D F5A3
                CMPB    A, r2                  ; 0AF8 0 108 13D 4A
                JLT     label_0afc             ; 0AF9 0 108 13D CA01
                VCAL    0                      ; 0AFB 0 108 13D 10
                                               ; 0AFC from 0AF9 (DD0,108,13D)
label_0afc:     LB      A, r6                  ; 0AFC 0 108 13D 7E
                JBR     off(0012ah).3, label_0b04 ; 0AFD 0 108 13D DB2A04
                CMPB    A, r3                  ; 0B00 0 108 13D 4B
                JGE     label_0b04             ; 0B01 0 108 13D CD01
                LB      A, r3                  ; 0B03 0 108 13D 7B
                                               ; 0B04 from 0AFD (DD0,108,13D)
                                               ; 0B04 from 0B01 (DD0,108,13D)
label_0b04:     JBR     off(00120h).4, label_0b0c ; 0B04 0 108 13D DC2005
                SUBB    A, #01ch               ; 0B07 0 108 13D A61C
                JGE     label_0b0c             ; 0B09 0 108 13D CD01
                CLRB    A                      ; 0B0B 0 108 13D FA
                                               ; 0B0C from 0B04 (DD0,108,13D)
                                               ; 0B0C from 0B09 (DD0,108,13D)
label_0b0c:     STB     A, r6                  ; 0B0C 0 108 13D 8E
                STB     A, off(001a0h)         ; 0B0D 0 108 13D D4A0
                LB      A, r2                  ; 0B0F 0 108 13D 7A
                CMPB    A, 0a3h                ; 0B10 0 108 13D C5A3C2
                JLE     label_0b21             ; 0B13 0 108 13D CF0C
                LB      A, #054h               ; 0B15 0 108 13D 7754
                JBS     off(00124h).0, label_0b2b ; 0B17 0 108 13D E82411
                LB      A, #054h               ; 0B1A 0 108 13D 7754
                JBS     off(00124h).1, label_0b2b ; 0B1C 0 108 13D E9240C
                SJ      label_0b29             ; 0B1F 0 108 13D CB08
                                               ; 0B21 from 0B13 (DD0,108,13D)
label_0b21:     INC     DP                     ; 0B21 0 108 13D 72
                JBS     off(00123h).7, label_0b29 ; 0B22 0 108 13D EF2304
                JBS     off(00124h).2, label_0b29 ; 0B25 0 108 13D EA2401
                INC     DP                     ; 0B28 0 108 13D 72
                                               ; 0B29 from 0B1F (DD0,108,13D)
                                               ; 0B29 from 0B22 (DD0,108,13D)
                                               ; 0B29 from 0B25 (DD0,108,13D)
label_0b29:     LCB     A, [DP]                ; 0B29 0 108 13D 92AA
                                               ; 0B2B from 0B17 (DD0,108,13D)
                                               ; 0B2B from 0B1C (DD0,108,13D)
label_0b2b:     ADDB    A, r6                  ; 0B2B 0 108 13D 0E
                JGE     label_0b30             ; 0B2C 0 108 13D CD02
                LB      A, #0ffh               ; 0B2E 0 108 13D 77FF
                                               ; 0B30 from 0B2C (DD0,108,13D)
label_0b30:     STB     A, off(001a1h)         ; 0B30 0 108 13D D4A1
                JBR     off(00123h).1, label_0b36 ; 0B32 0 108 13D D92301
                LB      A, r6                  ; 0B35 0 108 13D 7E
                                               ; 0B36 from 0B32 (DD0,108,13D)
label_0b36:     CMPB    A, 0a6h                ; 0B36 0 108 13D C5A6C2
                MB      off(00121h).4, C       ; 0B39 0 108 13D C4213C
                MOV     DP, #03926h            ; 0B3C 0 108 13D 622639
                L       A, #0392eh             ; 0B3F 1 108 13D 672E39
                MOV     er0, #00270h           ; 0B42 1 108 13D 44987002
                MB      C, 0feh.7              ; 0B46 1 108 13D C5FE2F
                JGE     label_0b50             ; 0B49 1 108 13D CD05
                MOV     DP, A                  ; 0B4B 1 108 13D 52
                MOV     er0, #00270h           ; 0B4C 1 108 13D 44987002
                                               ; 0B50 from 0B49 (DD1,108,13D)
label_0b50:     L       A, 0c4h                ; 0B50 1 108 13D E5C4
                CMP     A, er0                 ; 0B52 1 108 13D 48
                JLT     label_0b64             ; 0B53 1 108 13D CA0F
                INC     DP                     ; 0B55 1 108 13D 72
                INC     DP                     ; 0B56 1 108 13D 72
                JBS     off(00129h).7, label_0b64 ; 0B57 1 108 13D EF290A
                INC     DP                     ; 0B5A 1 108 13D 72
                INC     DP                     ; 0B5B 1 108 13D 72
                CMPB    0a3h, #02eh            ; 0B5C 1 108 13D C5A3C02E
                JLT     label_0b64             ; 0B60 1 108 13D CA02
                INC     DP                     ; 0B62 1 108 13D 72
                INC     DP                     ; 0B63 1 108 13D 72
                                               ; 0B64 from 0B53 (DD1,108,13D)
                                               ; 0B64 from 0B57 (DD1,108,13D)
                                               ; 0B64 from 0B60 (DD1,108,13D)
label_0b64:     LC      A, [DP]                ; 0B64 1 108 13D 92A8
                MB      C, P2.4                ; 0B66 1 108 13D C5242C
                JLT     label_0b6e             ; 0B69 1 108 13D CA03
                JBR     off(00131h).7, label_0b71 ; 0B6B 1 108 13D DF3103
                                               ; 0B6E from 0B69 (DD1,108,13D)
label_0b6e:     L       A, #00240h             ; 0B6E 1 108 13D 674002
                                               ; 0B71 from 0B6B (DD1,108,13D)
label_0b71:     CMP     0bah, A                ; 0B71 1 108 13D B5BAC1
                NOP                            ; 0B74 1 108 13D 00
                NOP                            ; 0B75 1 108 13D 00
                NOP                            ; 0B76 1 108 13D 00
                JLT     label_0ba3             ; 0B77 1 108 13D CA2A
                SC                             ; 0B79 1 108 13D 85
                JBS     off(00131h).5, label_0b84 ; 0B7A 1 108 13D ED3107
                JBS     off(0012dh).0, label_0b84 ; 0B7D 1 108 13D E82D04
                CMPB    0a9h, #010h            ; 0B80 1 108 13D C5A9C010
                                               ; 0B84 from 0B7A (DD1,108,13D)
                                               ; 0B84 from 0B7D (DD1,108,13D)
label_0b84:     MB      off(00127h).3, C       ; 0B84 1 108 13D C4273B
                JGE     label_0ba3             ; 0B87 1 108 13D CD1A
                LB      A, #097h               ; 0B89 0 108 13D 7797
                JBS     off(00130h).6, label_0b9b ; 0B8B 0 108 13D EE300D
                JBS     off(0012ch).2, label_0b9b ; 0B8E 0 108 13D EA2C0A
                LB      A, 0ach                ; 0B91 0 108 13D F5AC
                CMPB    A, #044h               ; 0B93 0 108 13D C644
                JGE     label_0b9e             ; 0B95 0 108 13D CD07
                MOV     X1, #03936h            ; 0B97 0 108 13D 603639
                VCAL    2                      ; 0B9A 0 108 13D 12
                                               ; 0B9B from 0B8B (DD0,108,13D)
                                               ; 0B9B from 0B8E (DD0,108,13D)
label_0b9b:     CMPB    A, 0a6h                ; 0B9B 0 108 13D C5A6C2
                                               ; 0B9E from 0B95 (DD0,108,13D)
label_0b9e:     MB      0feh.7, C              ; 0B9E 0 108 13D C5FE3F
                SJ      label_0bb2             ; 0BA1 0 108 13D CB0F
                                               ; 0BA3 from 0B77 (DD1,108,13D)
                                               ; 0BA3 from 0B87 (DD1,108,13D)
label_0ba3:     J       label_31c7             ; 0BA3 1 108 13D 03C731
                                               ; 0BA6 from 31CD (DD1,108,13D)
label_0ba6:     LB      A, off(001e9h)         ; 0BA6 0 108 13D F4E9
                JNE     label_0bd8             ; 0BA8 0 108 13D CE2E
                JBS     off(00123h).3, label_0bb2 ; 0BAA 0 108 13D EB2305
                MOVB    r7, #001h              ; 0BAD 0 108 13D 9F01
                JBS     off(00121h).4, label_0bcf ; 0BAF 0 108 13D EC211D
                                               ; 0BB2 from 0BA1 (DD0,108,13D)
                                               ; 0BB2 from 0BAA (DD0,108,13D)
label_0bb2:     LB      A, #086h               ; 0BB2 0 108 13D 7786
                JBR     off(00120h).7, label_0bb9 ; 0BB4 0 108 13D DF2002
                LB      A, #07eh               ; 0BB7 0 108 13D 777E
                                               ; 0BB9 from 0BB4 (DD0,108,13D)
label_0bb9:     CMPB    A, 0a6h                ; 0BB9 0 108 13D C5A6C2
                MB      off(00120h).7, C       ; 0BBC 0 108 13D C4203F
                JGE     label_0bd8             ; 0BBF 0 108 13D CD17
                CLRB    r7                     ; 0BC1 0 108 13D 2715
                LB      A, off(001a2h)         ; 0BC3 0 108 13D F4A2
                JBR     off(00123h).1, label_0bca ; 0BC5 0 108 13D D92302
                ADDB    A, #009h               ; 0BC8 0 108 13D 8609
                                               ; 0BCA from 0BC5 (DD0,108,13D)
label_0bca:     CMPB    0b4h, A                ; 0BCA 0 108 13D C5B4C1
                JGE     label_0bd8             ; 0BCD 0 108 13D CD09
                                               ; 0BCF from 0BAF (DD0,108,13D)
label_0bcf:     LB      A, off(001dch)         ; 0BCF 0 108 13D F4DC
                JNE     label_0c23             ; 0BD1 0 108 13D CE50
                SC                             ; 0BD3 0 108 13D 85
                CLRB    r7                     ; 0BD4 0 108 13D 2715
                SJ      label_0c24             ; 0BD6 0 108 13D CB4C
                                               ; 0BD8 from 0BBF (DD0,108,13D)
                                               ; 0BD8 from 0BCD (DD0,108,13D)
                                               ; 0BD8 from 31D0 (DD1,108,13D)
                                               ; 0BD8 from 0BA8 (DD0,108,13D)
label_0bd8:     MOV     DP, #03924h            ; 0BD8 0 108 13D 622439
                CMPB    0a3h, #080h            ; 0BDB 0 108 13D C5A3C080
                JLT     label_0be7             ; 0BDF 0 108 13D CA06
                CMPB    0f9h, #00ah            ; 0BE1 0 108 13D C5F9C00A
                JLT     label_0bef             ; 0BE5 0 108 13D CA08
                                               ; 0BE7 from 0BDF (DD0,108,13D)
label_0be7:     DEC     DP                     ; 0BE7 0 108 13D 82
                DEC     DP                     ; 0BE8 0 108 13D 82
                RC                             ; 0BE9 0 108 13D 95
                JBS     off(00118h).7, label_0bef ; 0BEA 0 108 13D EF1802
                DEC     DP                     ; 0BED 0 108 13D 82
                DEC     DP                     ; 0BEE 0 108 13D 82
                                               ; 0BEF from 0BE5 (DD0,108,13D)
                                               ; 0BEF from 0BEA (DD0,108,13D)
label_0bef:     MB      off(0011dh).6, C       ; 0BEF 0 108 13D C41D3E
                CMPB    0a3h, #032h            ; 0BF2 0 108 13D C5A3C032
                JGE     label_0c14             ; 0BF6 0 108 13D CD1C
                JBR     off(00124h).3, label_0c14 ; 0BF8 0 108 13D DB2419
                LB      A, #09bh               ; 0BFB 0 108 13D 779B
                MOVB    r0, #0d6h              ; 0BFD 0 108 13D 98D6
                JBS     off(00123h).6, label_0c06 ; 0BFF 0 108 13D EE2304
                LB      A, #0a2h               ; 0C02 0 108 13D 77A2
                MOVB    r0, #0d8h              ; 0C04 0 108 13D 98D8
                                               ; 0C06 from 0BFF (DD0,108,13D)
label_0c06:     CMPB    A, 0a6h                ; 0C06 0 108 13D C5A6C2
                JLT     label_0c0f             ; 0C09 0 108 13D CA04
                LB      A, r0                  ; 0C0B 0 108 13D 78
                CMPB    A, 0b4h                ; 0C0C 0 108 13D C5B4C2
                                               ; 0C0F from 0C09 (DD0,108,13D)
label_0c0f:     MB      off(00123h).6, C       ; 0C0F 0 108 13D C4233E
                JGE     label_0c18             ; 0C12 0 108 13D CD04
                                               ; 0C14 from 0BF6 (DD0,108,13D)
                                               ; 0C14 from 0BF8 (DD0,108,13D)
label_0c14:     MOVB    off(001ddh), #00fh     ; 0C14 0 108 13D C4DD980F
                                               ; 0C18 from 0C12 (DD0,108,13D)
label_0c18:     LB      A, off(001ddh)         ; 0C18 0 108 13D F4DD
                JEQ     label_0c1d             ; 0C1A 0 108 13D C901
                INC     DP                     ; 0C1C 0 108 13D 72
                                               ; 0C1D from 0C1A (DD0,108,13D)
label_0c1d:     LCB     A, [DP]                ; 0C1D 0 108 13D 92AA
                STB     A, off(001dch)         ; 0C1F 0 108 13D D4DC
                CLRB    r7                     ; 0C21 0 108 13D 2715
                                               ; 0C23 from 0BD1 (DD0,108,13D)
label_0c23:     RC                             ; 0C23 0 108 13D 95
                                               ; 0C24 from 0BD6 (DD0,108,13D)
label_0c24:     MB      0feh.6, C              ; 0C24 0 108 13D C5FE3E
                SRLB    r7                     ; 0C27 0 108 13D 27E7
                MB      off(00120h).4, C       ; 0C29 0 108 13D C4203C
                MOVB    r0, #04ch              ; 0C2C 0 108 13D 984C
                MOVB    r1, #04ch              ; 0C2E 0 108 13D 994C
                MOVB    r2, #043h              ; 0C30 0 108 13D 9A43
                MOVB    r3, #053h              ; 0C32 0 108 13D 9B53
                JBR     off(0012bh).0, label_0c66 ; 0C34 0 108 13D D82B2F
                JBS     off(0012bh).3, label_0c55 ; 0C37 0 108 13D EB2B1B
                LB      A, #03eh               ; 0C3A 0 108 13D 773E
                JBS     off(0012bh).2, label_0c41 ; 0C3C 0 108 13D EA2B02
                LB      A, #046h               ; 0C3F 0 108 13D 7746
                                               ; 0C41 from 0C3C (DD0,108,13D)
label_0c41:     CMPB    A, 0a6h                ; 0C41 0 108 13D C5A6C2
                MB      off(0012bh).2, C       ; 0C44 0 108 13D C42B3A
                MOVB    r1, #051h              ; 0C47 0 108 13D 9951
                JGE     label_0c72             ; 0C49 0 108 13D CD27
                MOVB    r1, r0                 ; 0C4B 0 108 13D 2049
                LB      A, off(001edh)         ; 0C4D 0 108 13D F4ED
                JEQ     label_0c72             ; 0C4F 0 108 13D C921
                MOVB    r1, #04ch              ; 0C51 0 108 13D 994C
                SJ      label_0c72             ; 0C53 0 108 13D CB1D
                                               ; 0C55 from 0C37 (DD0,108,13D)
label_0c55:     JBS     off(0012bh).1, label_0c5e ; 0C55 0 108 13D E92B06
                LB      A, off(001eeh)         ; 0C58 0 108 13D F4EE
                SJ      label_0c62             ; 0C5A 0 108 13D CB06
                DW  008cbh           ; 0C5C
                                               ; 0C5E from 0C55 (DD0,108,13D)
label_0c5e:     LB      A, off(001efh)         ; 0C5E 0 108 13D F4EF
                JEQ     label_0c72             ; 0C60 0 108 13D C910
                                               ; 0C62 from 0C5A (DD0,108,13D)
label_0c62:     MOVB    r1, r2                 ; 0C62 0 108 13D 2249
                SJ      label_0c72             ; 0C64 0 108 13D CB0C
                                               ; 0C66 from 0C34 (DD0,108,13D)
label_0c66:     MOVB    off(001edh), #000h     ; 0C66 0 108 13D C4ED9800
                MOVB    off(001c7h), #04bh     ; 0C6A 0 108 13D C4C7984B
                LB      A, #040h               ; 0C6E 0 108 13D 7740
                SJ      label_0c99             ; 0C70 0 108 13D CB27
                                               ; 0C72 from 0C49 (DD0,108,13D)
                                               ; 0C72 from 0C4F (DD0,108,13D)
                                               ; 0C72 from 0C53 (DD0,108,13D)
                                               ; 0C72 from 0C60 (DD0,108,13D)
                                               ; 0C72 from 0C64 (DD0,108,13D)
label_0c72:     JBR     off(0012bh).3, label_0c81 ; 0C72 0 108 13D DB2B0C
                CMPB    0a3h, #018h            ; 0C75 0 108 13D C5A3C018
                JLT     label_0c96             ; 0C79 0 108 13D CA1B
                LB      A, off(001c7h)         ; 0C7B 0 108 13D F4C7
                JEQ     label_0c96             ; 0C7D 0 108 13D C917
                SJ      label_0c98             ; 0C7F 0 108 13D CB17
                                               ; 0C81 from 0C72 (DD0,108,13D)
label_0c81:     LB      A, #077h               ; 0C81 0 108 13D 7777
                JBR     off(0011ah).3, label_0c88 ; 0C83 0 108 13D DB1A02
                LB      A, #069h               ; 0C86 0 108 13D 7769
                                               ; 0C88 from 0C83 (DD0,108,13D)
label_0c88:     CMPB    A, 0a6h                ; 0C88 0 108 13D C5A6C2
                MB      off(0011ah).3, C       ; 0C8B 0 108 13D C41A3B
                JGE     label_0c98             ; 0C8E 0 108 13D CD08
                CMPB    0a3h, #013h            ; 0C90 0 108 13D C5A3C013
                JGE     label_0c98             ; 0C94 0 108 13D CD02
                                               ; 0C96 from 0C79 (DD0,108,13D)
                                               ; 0C96 from 0C7D (DD0,108,13D)
label_0c96:     MOVB    r1, r3                 ; 0C96 0 108 13D 2349
                                               ; 0C98 from 0C7F (DD0,108,13D)
                                               ; 0C98 from 0C8E (DD0,108,13D)
                                               ; 0C98 from 0C94 (DD0,108,13D)
label_0c98:     LB      A, r1                  ; 0C98 0 108 13D 79
                                               ; 0C99 from 0C70 (DD0,108,13D)
label_0c99:     STB     A, off(0015bh)         ; 0C99 0 108 13D D45B
                MOV     X1, #037c4h            ; 0C9B 0 108 13D 60C437
                LB      A, 0a6h                ; 0C9E 0 108 13D F5A6
                VCAL    2                      ; 0CA0 0 108 13D 12
                JBS     off(0011dh).0, label_0caa ; 0CA1 0 108 13D E81D06
                ADDB    A, #008h               ; 0CA4 0 108 13D 8608
                JGE     label_0caa             ; 0CA6 0 108 13D CD02
                LB      A, #0ffh               ; 0CA8 0 108 13D 77FF
                                               ; 0CAA from 0CA1 (DD0,108,13D)
                                               ; 0CAA from 0CA6 (DD0,108,13D)
label_0caa:     CMPB    A, 0b4h                ; 0CAA 0 108 13D C5B4C2
                MB      off(0011dh).0, C       ; 0CAD 0 108 13D C41D38
                MOV     X1, #037c8h            ; 0CB0 0 108 13D 60C837
                LB      A, 0a6h                ; 0CB3 0 108 13D F5A6
                VCAL    2                      ; 0CB5 0 108 13D 12
                JBS     off(0011dh).1, label_0cbf ; 0CB6 0 108 13D E91D06
                ADDB    A, #008h               ; 0CB9 0 108 13D 8608
                JGE     label_0cbf             ; 0CBB 0 108 13D CD02
                LB      A, #0ffh               ; 0CBD 0 108 13D 77FF
                                               ; 0CBF from 0CB6 (DD0,108,13D)
                                               ; 0CBF from 0CBB (DD0,108,13D)
label_0cbf:     CMPB    A, 0b4h                ; 0CBF 0 108 13D C5B4C2
                MB      off(0011dh).1, C       ; 0CC2 0 108 13D C41D39
                SC                             ; 0CC5 0 108 13D 85
                LB      A, off(0016fh)         ; 0CC6 0 108 13D F46F
                JNE     label_0cdc             ; 0CC8 0 108 13D CE12
                JBR     off(0012bh).6, label_0cdc ; 0CCA 0 108 13D DE2B0F
                MB      C, 0feh.6              ; 0CCD 0 108 13D C5FE2E
                JLT     label_0cdc             ; 0CD0 0 108 13D CA0A
                LB      A, #0f6h               ; 0CD2 0 108 13D 77F6
                JBR     off(0011ch).7, label_0cd9 ; 0CD4 0 108 13D DF1C02
                LB      A, #0fah               ; 0CD7 0 108 13D 77FA
                                               ; 0CD9 from 0CD4 (DD0,108,13D)
label_0cd9:     CMPB    A, 0a6h                ; 0CD9 0 108 13D C5A6C2
                                               ; 0CDC from 0CC8 (DD0,108,13D)
                                               ; 0CDC from 0CCA (DD0,108,13D)
                                               ; 0CDC from 0CD0 (DD0,108,13D)
label_0cdc:     XORB    PSWH, #080h            ; 0CDC 0 108 13D A2F080
                MB      off(0011ch).7, C       ; 0CDF 0 108 13D C41C3F
                CAL     label_2dab             ; 0CE2 0 108 13D 32AB2D
                MB      C, off(0019ah).3       ; 0CE5 0 108 13D C49A2B
                JBS     off(0011eh).2, label_0cee ; 0CE8 0 108 13D EA1E03
                MB      C, off(0019ah).2       ; 0CEB 0 108 13D C49A2A
                                               ; 0CEE from 0CE8 (DD0,108,13D)
label_0cee:     JGE     label_0cf4             ; 0CEE 0 108 13D CD04
                CAL     label_2dc5             ; 0CF0 0 108 13D 32C52D
                SC                             ; 0CF3 0 108 13D 85
                                               ; 0CF4 from 0CEE (DD0,108,13D)
label_0cf4:     MB      r7.7, C                ; 0CF4 0 108 13D 273F
                L       A, off(001c2h)         ; 0CF6 1 108 13D E4C2
                JEQ     label_0cfd             ; 0CF8 1 108 13D C903
                DEC     off(001c2h)            ; 0CFA 1 108 13D B4C217
                                               ; 0CFD from 0CF8 (DD1,108,13D)
label_0cfd:     L       A, off(001c4h)         ; 0CFD 1 108 13D E4C4
                JEQ     label_0d04             ; 0CFF 1 108 13D C903
                DEC     off(001c4h)            ; 0D01 1 108 13D B4C417
                                               ; 0D04 from 0CFF (DD1,108,13D)
label_0d04:     MOV     er2, #08000h           ; 0D04 1 108 13D 46980080
                JBS     off(00130h).2, label_0d63 ; 0D08 1 108 13D EA3058
                JBS     off(00130h).4, label_0d63 ; 0D0B 1 108 13D EC3055
                MOV     er2, #08000h           ; 0D0E 1 108 13D 46980080
                JBS     off(00130h).5, label_0d63 ; 0D12 1 108 13D ED304E
                JBS     off(00130h).6, label_0d63 ; 0D15 1 108 13D EE304B
                JBS     off(0010fh).0, label_0d63 ; 0D18 1 108 13D E80F48
                JBS     off(0010fh).6, label_0d60 ; 0D1B 1 108 13D EE0F42
                JBR     off(0011eh).1, label_0d63 ; 0D1E 1 108 13D D91E42
                MB      C, [DP].3              ; 0D21 1 108 13D C22B
                JGE     label_0d29             ; 0D23 1 108 13D CD04
                LB      A, (0019dh-0013dh)[USP] ; 0D25 0 108 13D F360
                JEQ     label_0d2e             ; 0D27 0 108 13D C905
                                               ; 0D29 from 0D23 (DD1,108,13D)
label_0d29:     JBR     off(0011fh).5, label_0d63 ; 0D29 0 108 13D DD1F37
                SJ      label_0d60             ; 0D2C 0 108 13D CB32
                                               ; 0D2E from 0D27 (DD0,108,13D)
label_0d2e:     JBS     off(0011dh).1, label_0d3f ; 0D2E 0 108 13D E91D0E
                LB      A, off(001d1h)         ; 0D31 0 108 13D F4D1
                JNE     label_0d43             ; 0D33 0 108 13D CE0E
                MOVB    off(001eeh), #0c8h     ; 0D35 0 108 13D C4EE98C8
                MOVB    off(001efh), #000h     ; 0D39 0 108 13D C4EF9800
                SJ      label_0d43             ; 0D3D 0 108 13D CB04
                                               ; 0D3F from 0D2E (DD0,108,13D)
label_0d3f:     MOVB    off(001d1h), #014h     ; 0D3F 0 108 13D C4D19814
                                               ; 0D43 from 0D33 (DD0,108,13D)
                                               ; 0D43 from 0D3D (DD0,108,13D)
label_0d43:     LB      A, #000h               ; 0D43 0 108 13D 7700
                JBS     off(0012bh).0, label_0d54 ; 0D45 0 108 13D E82B0C
                NOP                            ; 0D48 0 108 13D 00
                NOP                            ; 0D49 0 108 13D 00
                NOP                            ; 0D4A 0 108 13D 00
                JBS     off(0011ch).7, label_0d66 ; 0D4B 0 108 13D EF1C18
                JBR     off(0012bh).6, label_0d60 ; 0D4E 0 108 13D DE2B0F
                J       label_0f15             ; 0D51 0 108 13D 03150F
                                               ; 0D54 from 0D45 (DD0,108,13D)
label_0d54:     J       label_0ef4             ; 0D54 0 108 13D 03F40E
                DB  000h,000h,000h,000h,000h,000h,003h,0F4h ; 0D57
                DB  00Eh ; 0D5F
                                               ; 0D60 from 0D1B (DD1,108,13D)
                                               ; 0D60 from 0D2C (DD0,108,13D)
                                               ; 0D60 from 0D4E (DD0,108,13D)
label_0d60:     J       label_0f2b             ; 0D60 1 108 13D 032B0F
                                               ; 0D63 from 0D08 (DD1,108,13D)
                                               ; 0D63 from 0D0B (DD1,108,13D)
                                               ; 0D63 from 0D12 (DD1,108,13D)
                                               ; 0D63 from 0D15 (DD1,108,13D)
                                               ; 0D63 from 0D18 (DD1,108,13D)
                                               ; 0D63 from 0D1E (DD1,108,13D)
                                               ; 0D63 from 0D29 (DD0,108,13D)
label_0d63:     J       label_0f36             ; 0D63 1 108 13D 03360F
                                               ; 0D66 from 0D4B (DD0,108,13D)
label_0d66:     JBR     off(00125h).3, label_0d75 ; 0D66 0 108 13D DB250C
                JBS     off(00123h).3, label_0d75 ; 0D69 0 108 13D EB2309
                LB      A, (00165h-0013dh)[USP] ; 0D6C 0 108 13D F328
                MOV     X1, #03789h            ; 0D6E 0 108 13D 608937
                JEQ     label_0da6             ; 0D71 0 108 13D C933
                SJ      label_0daa             ; 0D73 0 108 13D CB35
                                               ; 0D75 from 0D66 (DD0,108,13D)
                                               ; 0D75 from 0D69 (DD0,108,13D)
label_0d75:     MOVB    (00165h-0013dh)[USP], #00ah ; 0D75 0 108 13D C328980A
                MOV     X1, #03795h            ; 0D79 0 108 13D 609537
                JBR     off(0012bh).3, label_0d92 ; 0D7C 0 108 13D DB2B13
                JBS     off(0011dh).0, label_0d88 ; 0D7F 0 108 13D E81D06
                ADD     X1, #00012h            ; 0D82 0 108 13D 90801200
                SJ      label_0daa             ; 0D86 0 108 13D CB22
                                               ; 0D88 from 0D7F (DD0,108,13D)
label_0d88:     LCB     A, 00026h[X1]          ; 0D88 0 108 13D 90AB2600
                ADD     X1, #00018h            ; 0D8C 0 108 13D 90801800
                SJ      label_0da1             ; 0D90 0 108 13D CB0F
                                               ; 0D92 from 0D7C (DD0,108,13D)
label_0d92:     LC      A, 00024h[X1]          ; 0D92 0 108 13D 90A92400
                CMPB    A, 0b4h                ; 0D96 0 108 13D C5B4C2
                JGE     label_0d9f             ; 0D99 0 108 13D CD04
                ADD     X1, #0000ch            ; 0D9B 0 108 13D 90800C00
                                               ; 0D9F from 0D99 (DD0,108,13D)
label_0d9f:     LB      A, ACCH                ; 0D9F 0 108 13D F507
                                               ; 0DA1 from 0D90 (DD0,108,13D)
label_0da1:     CMPB    A, 0a6h                ; 0DA1 0 108 13D C5A6C2
                JGE     label_0daa             ; 0DA4 0 108 13D CD04
                                               ; 0DA6 from 0D71 (DD0,108,13D)
label_0da6:     ADD     X1, #00006h            ; 0DA6 0 108 13D 90800600
                                               ; 0DAA from 0D73 (DD0,108,13D)
                                               ; 0DAA from 0D86 (DD0,108,13D)
                                               ; 0DAA from 0DA4 (DD0,108,13D)
label_0daa:     LB      A, #01dh               ; 0DAA 0 108 13D 771D
                JBR     off(0012bh).3, label_0db4 ; 0DAC 0 108 13D DB2B05
                JBR     off(0011dh).0, label_0db4 ; 0DAF 0 108 13D D81D02
                LB      A, #01dh               ; 0DB2 0 108 13D 771D
                                               ; 0DB4 from 0DAC (DD0,108,13D)
                                               ; 0DB4 from 0DAF (DD0,108,13D)
label_0db4:     CMPB    A, r6                  ; 0DB4 0 108 13D 4E
                RB      [DP].1                 ; 0DB5 0 108 13D C209
                MB      [DP].1, C              ; 0DB7 0 108 13D C239
                JEQ     label_0dbe             ; 0DB9 0 108 13D C903
                XORB    PSWH, #080h            ; 0DBB 0 108 13D A2F080
                                               ; 0DBE from 0DB9 (DD0,108,13D)
label_0dbe:     MB      r0.0, C                ; 0DBE 0 108 13D 2038
                SB      [DP].0                 ; 0DC0 0 108 13D C218
                JEQ     label_0e0c             ; 0DC2 0 108 13D C948
                JBR     off(0011fh).7, label_0dda ; 0DC4 0 108 13D DF1F13
                JBR     off(0011fh).5, label_0dd2 ; 0DC7 0 108 13D DD1F08
                JBS     off(00123h).5, label_0def ; 0DCA 0 108 13D ED2322
                JBR     off(00123h).3, label_0def ; 0DCD 0 108 13D DB231F
                SJ      label_0e22             ; 0DD0 0 108 13D CB50
                                               ; 0DD2 from 0DC7 (DD0,108,13D)
label_0dd2:     JBR     off(00118h).7, label_0def ; 0DD2 0 108 13D DF181A
                JBS     off(00123h).3, label_0def ; 0DD5 0 108 13D EB2317
                SJ      label_0e38             ; 0DD8 0 108 13D CB5E
                                               ; 0DDA from 0DC4 (DD0,108,13D)
label_0dda:     JBS     off(0011fh).5, label_0def ; 0DDA 0 108 13D ED1F12
                JBR     off(0012bh).5, label_0de3 ; 0DDD 0 108 13D DD2B03
                JBR     off(0012bh).3, label_0e38 ; 0DE0 0 108 13D DB2B55
                                               ; 0DE3 from 0DDD (DD0,108,13D)
label_0de3:     CMPB    0a3h, #02eh            ; 0DE3 0 108 13D C5A3C02E
                JLT     label_0def             ; 0DE7 0 108 13D CA06
                JBS     off(00123h).5, label_0def ; 0DE9 0 108 13D ED2303
                JBS     off(00123h).3, label_0e38 ; 0DEC 0 108 13D EB2349
                                               ; 0DEF from 0DCA (DD0,108,13D)
                                               ; 0DEF from 0DCD (DD0,108,13D)
                                               ; 0DEF from 0DDA (DD0,108,13D)
                                               ; 0DEF from 0DE7 (DD0,108,13D)
                                               ; 0DEF from 0DE9 (DD0,108,13D)
                                               ; 0DEF from 0DD2 (DD0,108,13D)
                                               ; 0DEF from 0DD5 (DD0,108,13D)
label_0def:     RB      [DP].5                 ; 0DEF 0 108 13D C20D
                JEQ     label_0dff             ; 0DF1 0 108 13D C90C
                LB      A, (0019bh-0013dh)[USP] ; 0DF3 0 108 13D F35E
                JNE     label_0dff             ; 0DF5 0 108 13D CE08
                JBS     off(0011fh).5, label_0e1d ; 0DF7 0 108 13D ED1F23
                L       A, 00270h[X2]          ; 0DFA 1 108 13D E17002
                SJ      label_0e4e             ; 0DFD 1 108 13D CB4F
                                               ; 0DFF from 0DF1 (DD0,108,13D)
                                               ; 0DFF from 0DF5 (DD0,108,13D)
label_0dff:     JBR     off(00108h).0, label_0e51 ; 0DFF 0 108 13D D8084F
                L       A, 001c2h[X2]          ; 0E02 1 108 13D E1C201
                JNE     label_0e6e             ; 0E05 1 108 13D CE67
                L       A, #08000h             ; 0E07 1 108 13D 670080
                SJ      label_0e4e             ; 0E0A 1 108 13D CB42
                                               ; 0E0C from 0DC2 (DD0,108,13D)
label_0e0c:     MB      C, [DP].2              ; 0E0C 0 108 13D C22A
                JGE     label_0e14             ; 0E0E 0 108 13D CD04
                LB      A, (0016fh-0013dh)[USP] ; 0E10 0 108 13D F332
                JNE     label_0e51             ; 0E12 0 108 13D CE3D
                                               ; 0E14 from 0E0E (DD0,108,13D)
label_0e14:     JBS     off(0011fh).5, label_0e1d ; 0E14 0 108 13D ED1F06
                JBS     off(0012bh).3, label_0e2f ; 0E17 0 108 13D EB2B15
                JBS     off(00123h).3, label_0e38 ; 0E1A 0 108 13D EB231B
                                               ; 0E1D from 0E14 (DD0,108,13D)
                                               ; 0E1D from 0DF7 (DD0,108,13D)
label_0e1d:     L       A, 0026ch[X2]          ; 0E1D 1 108 13D E16C02
                SJ      label_0e4e             ; 0E20 1 108 13D CB2C
                                               ; 0E22 from 0DD0 (DD0,108,13D)
label_0e22:     MOVB    (0019bh-0013dh)[USP], #028h ; 0E22 0 108 13D C35E9828
                L       A, 00274h[X2]          ; 0E26 1 108 13D E17402
                MOV     er0, #08000h           ; 0E29 1 108 13D 44980080
                SJ      label_0e49             ; 0E2D 1 108 13D CB1A
                                               ; 0E2F from 0E17 (DD0,108,13D)
label_0e2f:     L       A, 00270h[X2]          ; 0E2F 1 108 13D E17002
                MOV     er0, #08000h           ; 0E32 1 108 13D 44980080
                SJ      label_0e49             ; 0E36 1 108 13D CB11
                                               ; 0E38 from 0E1A (DD0,108,13D)
                                               ; 0E38 from 0DE0 (DD0,108,13D)
                                               ; 0E38 from 0DEC (DD0,108,13D)
                                               ; 0E38 from 0DD8 (DD0,108,13D)
label_0e38:     L       A, 00270h[X2]          ; 0E38 1 108 13D E17002
                MOV     er0, #08400h           ; 0E3B 1 108 13D 44980084
                CMPB    0a3h, #040h            ; 0E3F 1 108 13D C5A3C040
                JLT     label_0e49             ; 0E43 1 108 13D CA04
                MOV     er0, #087afh           ; 0E45 1 108 13D 4498AF87
                                               ; 0E49 from 0E2D (DD1,108,13D)
                                               ; 0E49 from 0E36 (DD1,108,13D)
                                               ; 0E49 from 0E43 (DD1,108,13D)
label_0e49:     MUL                            ; 0E49 1 108 13D 9035
                SLL     A                      ; 0E4B 1 108 13D 53
                L       A, er1                 ; 0E4C 1 108 13D 35
                ROL     A                      ; 0E4D 1 108 13D 33
                                               ; 0E4E from 0E20 (DD1,108,13D)
                                               ; 0E4E from 0DFD (DD1,108,13D)
                                               ; 0E4E from 0E0A (DD1,108,13D)
label_0e4e:     ST      A, 00162h[X2]          ; 0E4E 1 108 13D D16201
                                               ; 0E51 from 0E12 (DD0,108,13D)
                                               ; 0E51 from 0DFF (DD0,108,13D)
label_0e51:     RB      [DP].2                 ; 0E51 0 108 13D C20A
                SUBB    (00163h-0013dh)[USP], #002h ; 0E53 0 108 13D C326A002
                JLE     label_0e5c             ; 0E57 0 108 13D CF03
                J       label_0f54             ; 0E59 0 108 13D 03540F
                                               ; 0E5C from 0E57 (DD0,108,13D)
label_0e5c:     CLR     A                      ; 0E5C 1 108 13D F9
                LC      A, [X1]                ; 0E5D 1 108 13D 90A8
                MB      C, [DP].1              ; 0E5F 1 108 13D C229
                JGE     label_0e66             ; 0E61 1 108 13D CD03
                ST      A, er0                 ; 0E63 1 108 13D 88
                CLR     A                      ; 0E64 1 108 13D F9
                SUB     A, er0                 ; 0E65 1 108 13D 28
                                               ; 0E66 from 0E61 (DD1,108,13D)
label_0e66:     ADD     A, 00162h[X2]          ; 0E66 1 108 13D B1620182
                SB      r7.1                   ; 0E6A 1 108 13D 2719
                SJ      label_0eaa             ; 0E6C 1 108 13D CB3C
                                               ; 0E6E from 0E05 (DD1,108,13D)
label_0e6e:     J       label_3208             ; 0E6E 1 108 13D 030832
                                               ; 0E71 from 320E (DD1,108,13D)
label_0e71:     LB      A, (00165h-0013dh)[USP] ; 0E71 0 108 13D F328
                JEQ     label_0e7c             ; 0E73 0 108 13D C907
                SUBB    A, #002h               ; 0E75 0 108 13D A602
                JGE     label_0e7a             ; 0E77 0 108 13D CD01
                CLRB    A                      ; 0E79 0 108 13D FA
                                               ; 0E7A from 0E77 (DD0,108,13D)
label_0e7a:     STB     A, (00165h-0013dh)[USP] ; 0E7A 0 108 13D D328
                                               ; 0E7C from 3211 (DD1,108,13D)
                                               ; 0E7C from 0E73 (DD0,108,13D)
label_0e7c:     CLR     A                      ; 0E7C 1 108 13D F9
                LC      A, 00002h[X1]          ; 0E7D 1 108 13D 90A90200
                ST      A, er2                 ; 0E81 1 108 13D 8A
                MB      C, [DP].1              ; 0E82 1 108 13D C229
                JLT     label_0ea4             ; 0E84 1 108 13D CA1E
                LB      A, (00171h-0013dh)[USP] ; 0E86 0 108 13D F334
                JNE     label_0ea1             ; 0E88 0 108 13D CE17
                MOVB    (00171h-0013dh)[USP], #014h ; 0E8A 0 108 13D C3349814
                LB      A, 09eh                ; 0E8E 0 108 13D F59E
                ANDB    A, #0c0h               ; 0E90 0 108 13D D6C0
                SWAPB                          ; 0E92 0 108 13D 83
                EXTND                          ; 0E93 1 108 13D F8
                SRL     A                      ; 0E94 1 108 13D 63
                LC      A, 037bch[ACC]         ; 0E95 1 108 13D B506A9BC37
                ST      A, er2                 ; 0E9A 1 108 13D 8A
                LC      A, 00004h[X1]          ; 0E9B 1 108 13D 90A90400
                ADD     er2, A                 ; 0E9F 1 108 13D 4681
                                               ; 0EA1 from 0E88 (DD0,108,13D)
label_0ea1:     CLR     A                      ; 0EA1 1 108 13D F9
                SUB     A, er2                 ; 0EA2 1 108 13D 2A
                ST      A, er2                 ; 0EA3 1 108 13D 8A
                                               ; 0EA4 from 0E84 (DD1,108,13D)
label_0ea4:     L       A, 00162h[X2]          ; 0EA4 1 108 13D E16201
                SUB     A, er2                 ; 0EA7 1 108 13D 2A
                RB      r7.1                   ; 0EA8 1 108 13D 2709
                                               ; 0EAA from 0E6C (DD1,108,13D)
label_0eaa:     MOV     er0, #0b6e0h           ; 0EAA 1 108 13D 4498E0B6
                MOV     er1, #05720h           ; 0EAE 1 108 13D 45982057
                CAL     label_2e61             ; 0EB2 1 108 13D 32612E
                ST      A, 00162h[X2]          ; 0EB5 1 108 13D D16201
                L       A, off(0014eh)         ; 0EB8 1 108 13D E44E
                JNE     label_0ef2             ; 0EBA 1 108 13D CE36
                MB      C, P0.3                ; 0EBC 1 108 13D C5202B
                JGE     label_0ef2             ; 0EBF 1 108 13D CD31
                JBS     off(0012bh).3, label_0ef2 ; 0EC1 1 108 13D EB2B2E
                MOV     X1, DP                 ; 0EC4 1 108 13D 9278
                L       A, #00274h             ; 0EC6 1 108 13D 677402
                ADD     A, X2                  ; 0EC9 1 108 13D 9182
                MOV     DP, A                  ; 0ECB 1 108 13D 52
                MOV     er0, #000ffh           ; 0ECC 1 108 13D 4498FF00
                LB      A, (0019bh-0013dh)[USP] ; 0ED0 0 108 13D F35E
                JNE     label_0eea             ; 0ED2 0 108 13D CE16
                JBS     off(0010fh).1, label_0ef0 ; 0ED4 0 108 13D E90F19
                SUB     DP, #00004h            ; 0ED7 0 108 13D 92A00400
                MOV     er0, #00080h           ; 0EDB 0 108 13D 44988000
                JBR     off(0011fh).5, label_0eea ; 0EDF 0 108 13D DD1F08
                SUB     DP, #00004h            ; 0EE2 0 108 13D 92A00400
                MOV     er0, #000ffh           ; 0EE6 0 108 13D 4498FF00
                                               ; 0EEA from 0ED2 (DD0,108,13D)
                                               ; 0EEA from 0EDF (DD0,108,13D)
label_0eea:     L       A, 00162h[X2]          ; 0EEA 1 108 13D E16201
                CAL     label_2d89             ; 0EED 1 108 13D 32892D
                                               ; 0EF0 from 0ED4 (DD0,108,13D)
label_0ef0:     MOV     DP, X1                 ; 0EF0 1 108 13D 907A
                                               ; 0EF2 from 0EBA (DD1,108,13D)
                                               ; 0EF2 from 0EBF (DD1,108,13D)
                                               ; 0EF2 from 0EC1 (DD1,108,13D)
label_0ef2:     SJ      label_0f43             ; 0EF2 1 108 13D CB4F
                                               ; 0EF4 from 0D54 (DD0,108,13D)
label_0ef4:     MB      C, [DP].0              ; 0EF4 0 108 13D C228
                JGE     label_0efc             ; 0EF6 0 108 13D CD04
                SB      [DP].2                 ; 0EF8 0 108 13D C21A
                STB     A, (0016fh-0013dh)[USP] ; 0EFA 0 108 13D D332
                                               ; 0EFC from 0EF6 (DD0,108,13D)
label_0efc:     CMPB    off(0015bh), #040h     ; 0EFC 0 108 13D C45BC040
                JNE     label_0f38             ; 0F00 0 108 13D CE36
                LB      A, (0016fh-0013dh)[USP] ; 0F02 0 108 13D F332
                MOV     er0, 00270h[X2]        ; 0F04 0 108 13D B1700248
                JEQ     label_0f0e             ; 0F08 0 108 13D C904
                MOV     er0, 00162h[X2]        ; 0F0A 0 108 13D B1620148
                                               ; 0F0E from 0F08 (DD0,108,13D)
label_0f0e:     JBR     off(00109h).7, label_0f38 ; 0F0E 0 108 13D DF0927
                MOV     er2, er0               ; 0F11 0 108 13D 444A
                SJ      label_0f38             ; 0F13 0 108 13D CB23
                                               ; 0F15 from 0D51 (DD0,108,13D)
label_0f15:     MB      C, [DP].0              ; 0F15 0 108 13D C228
                JGE     label_0f1d             ; 0F17 0 108 13D CD04
                SB      [DP].2                 ; 0F19 0 108 13D C21A
                STB     A, (0016fh-0013dh)[USP] ; 0F1B 0 108 13D D332
                                               ; 0F1D from 0F17 (DD0,108,13D)
label_0f1d:     LB      A, (0016fh-0013dh)[USP] ; 0F1D 0 108 13D F332
                MOV     er2, 00270h[X2]        ; 0F1F 0 108 13D B170024A
                JEQ     label_0f38             ; 0F23 0 108 13D C913
                MOV     er2, 00162h[X2]        ; 0F25 0 108 13D B162014A
                SJ      label_0f38             ; 0F29 0 108 13D CB0D
                                               ; 0F2B from 0D60 (DD1,108,13D)
label_0f2b:     MOV     er2, 00270h[X2]        ; 0F2B 1 108 13D B170024A
                JBR     off(0011fh).5, label_0f36 ; 0F2F 1 108 13D DD1F04
                MOV     er2, 0026ch[X2]        ; 0F32 1 108 13D B16C024A
                                               ; 0F36 from 0D63 (DD1,108,13D)
                                               ; 0F36 from 0F2F (DD1,108,13D)
label_0f36:     RB      [DP].2                 ; 0F36 1 108 13D C20A
                                               ; 0F38 from 0F23 (DD0,108,13D)
                                               ; 0F38 from 0F29 (DD0,108,13D)
                                               ; 0F38 from 0F00 (DD0,108,13D)
                                               ; 0F38 from 0F0E (DD0,108,13D)
                                               ; 0F38 from 0F13 (DD0,108,13D)
label_0f38:     ANDB    [DP], #0deh            ; 0F38 1 108 13D C2D0DE
                MOVB    (00165h-0013dh)[USP], #00ah ; 0F3B 1 108 13D C328980A
                L       A, er2                 ; 0F3F 1 108 13D 36
                ST      A, 00162h[X2]          ; 0F40 1 108 13D D16201
                                               ; 0F43 from 0EF2 (DD1,108,13D)
label_0f43:     MOVB    r0, #004h              ; 0F43 1 108 13D 9804
                J       label_2fe8             ; 0F45 1 108 13D 03E82F
                DB  000h ; 0F48
                                               ; 0F49 from 2FF5 (DD0,108,13D)
label_0f49:     CMPB    0a6h, #069h            ; 0F49 0 108 13D C5A6C069
                JGE     label_0f51             ; 0F4D 0 108 13D CD02
                MOVB    r0, #002h              ; 0F4F 0 108 13D 9802
                                               ; 0F51 from 2FEC (DD0,108,13D)
                                               ; 0F51 from 2FFA (DD0,108,13D)
                                               ; 0F51 from 0F4D (DD0,108,13D)
label_0f51:     LB      A, r0                  ; 0F51 0 108 13D 78
                STB     A, (00163h-0013dh)[USP] ; 0F52 0 108 13D D326
                                               ; 0F54 from 0E59 (DD0,108,13D)
label_0f54:     LB      A, 0feh                ; 0F54 0 108 13D F5FE
                STB     A, r0                  ; 0F56 0 108 13D 88
                LB      A, off(001cah)         ; 0F57 0 108 13D F4CA
                JNE     label_0faa             ; 0F59 0 108 13D CE4F
                LB      A, off(00130h)         ; 0F5B 0 108 13D F430
                ANDB    A, #077h               ; 0F5D 0 108 13D D677
                JNE     label_0faa             ; 0F5F 0 108 13D CE49
                JBS     off(0010fh).6, label_0faa ; 0F61 0 108 13D EE0F46
                CMPB    0a3h, #026h            ; 0F64 0 108 13D C5A3C026
                JGE     label_0faa             ; 0F68 0 108 13D CD40
                JBS     off(00108h).6, label_0f8c ; 0F6A 0 108 13D EE081F
                CMPB    0a6h, #062h            ; 0F6D 0 108 13D C5A6C062
                JGE     label_0f77             ; 0F71 0 108 13D CD04
                MOVB    (001a0h-0013dh)[USP], #032h ; 0F73 0 108 13D C3639832
                                               ; 0F77 from 0F71 (DD0,108,13D)
label_0f77:     LB      A, (001a0h-0013dh)[USP] ; 0F77 0 108 13D F363
                JNE     label_0f7d             ; 0F79 0 108 13D CE02
                SB      [DP].6                 ; 0F7B 0 108 13D C21E
                                               ; 0F7D from 0F79 (DD0,108,13D)
label_0f7d:     RC                             ; 0F7D 0 108 13D 95
                JBS     off(00108h).7, label_0fb1 ; 0F7E 0 108 13D EF0830
                LB      A, #040h               ; 0F81 0 108 13D 7740
                CMPB    A, off(0015bh)         ; 0F83 0 108 13D C75B
                JGE     label_0fb1             ; 0F85 0 108 13D CD2A
                CMPB    r6, #003h              ; 0F87 0 108 13D 26C003
                SJ      label_0fb1             ; 0F8A 0 108 13D CB25
                                               ; 0F8C from 0F6A (DD0,108,13D)
label_0f8c:     JBS     off(00123h).2, label_0f92 ; 0F8C 0 108 13D EA2303
                LB      A, r6                  ; 0F8F 0 108 13D 7E
                STB     A, (00161h-0013dh)[USP] ; 0F90 0 108 13D D324
                                               ; 0F92 from 0F8C (DD0,108,13D)
label_0f92:     MB      C, [DP].6              ; 0F92 0 108 13D C22E
                JGE     label_0fac             ; 0F94 0 108 13D CD16
                LB      A, #09ah               ; 0F96 0 108 13D 779A
                CMPB    A, r6                  ; 0F98 0 108 13D 4E
                JGE     label_0faa             ; 0F99 0 108 13D CD0F
                JBS     off(00123h).3, label_0faa ; 0F9B 0 108 13D EB230C
                LB      A, (00161h-0013dh)[USP] ; 0F9E 0 108 13D F324
                SUBB    A, r6                  ; 0FA0 0 108 13D 2E
                JGE     label_0fa6             ; 0FA1 0 108 13D CD03
                STB     A, r1                  ; 0FA3 0 108 13D 89
                CLRB    A                      ; 0FA4 0 108 13D FA
                SUBB    A, r1                  ; 0FA5 0 108 13D 29
                                               ; 0FA6 from 0FA1 (DD0,108,13D)
label_0fa6:     CMPB    A, #003h               ; 0FA6 0 108 13D C603
                JLT     label_0fb1             ; 0FA8 0 108 13D CA07
                                               ; 0FAA from 0F59 (DD0,108,13D)
                                               ; 0FAA from 0F5F (DD0,108,13D)
                                               ; 0FAA from 0F61 (DD0,108,13D)
                                               ; 0FAA from 0F68 (DD0,108,13D)
                                               ; 0FAA from 0F99 (DD0,108,13D)
                                               ; 0FAA from 0F9B (DD0,108,13D)
label_0faa:     RB      [DP].6                 ; 0FAA 0 108 13D C20E
                                               ; 0FAC from 0F94 (DD0,108,13D)
label_0fac:     MOVB    (001a0h-0013dh)[USP], #032h ; 0FAC 0 108 13D C3639832
                RC                             ; 0FB0 0 108 13D 95
                                               ; 0FB1 from 0F7E (DD0,108,13D)
                                               ; 0FB1 from 0F85 (DD0,108,13D)
                                               ; 0FB1 from 0F8A (DD0,108,13D)
                                               ; 0FB1 from 0FA8 (DD0,108,13D)
label_0fb1:     JBS     off(0010fh).7, label_0fb9 ; 0FB1 0 108 13D EF0F05
                MB      off(0012dh).4, C       ; 0FB4 0 108 13D C42D3C
                SJ      label_0fbc             ; 0FB7 0 108 13D CB03
                                               ; 0FB9 from 0FB1 (DD0,108,13D)
label_0fb9:     MB      off(0012dh).5, C       ; 0FB9 0 108 13D C42D3D
                                               ; 0FBC from 0FB7 (DD0,108,13D)
label_0fbc:     MOVB    r5, #040h              ; 0FBC 0 108 13D 9D40
                MOV     X1, #0372dh            ; 0FBE 0 108 13D 602D37
                CAL     label_2bd7             ; 0FC1 0 108 13D 32D72B
                STB     A, off(00169h)         ; 0FC4 0 108 13D D469
                LB      A, off(00130h)         ; 0FC6 0 108 13D F430
                ANDB    A, #074h               ; 0FC8 0 108 13D D674
                JNE     label_1023             ; 0FCA 0 108 13D CE57
                LB      A, 0b4h                ; 0FCC 0 108 13D F5B4
                SUBB    A, 0b7h                ; 0FCE 0 108 13D C5B7A2
                JGE     label_0fd4             ; 0FD1 0 108 13D CD01
                CLRB    A                      ; 0FD3 0 108 13D FA
                                               ; 0FD4 from 0FD1 (DD0,108,13D)
label_0fd4:     STB     A, r0                  ; 0FD4 0 108 13D 88
                CMP     off(0016ch), #00180h   ; 0FD5 0 108 13D B46CC08001
                JGE     label_1023             ; 0FDA 0 108 13D CD47
                LB      A, #006h               ; 0FDC 0 108 13D 7706
                MOVB    r1, #0cfh              ; 0FDE 0 108 13D 99CF
                JBS     off(00121h).6, label_0fe7 ; 0FE0 0 108 13D EE2104
                LB      A, #014h               ; 0FE3 0 108 13D 7714
                MOVB    r1, #0cbh              ; 0FE5 0 108 13D 99CB
                                               ; 0FE7 from 0FE0 (DD0,108,13D)
label_0fe7:     CMPB    A, 0a6h                ; 0FE7 0 108 13D C5A6C2
                JGE     label_0fef             ; 0FEA 0 108 13D CD03
                LB      A, 0b4h                ; 0FEC 0 108 13D F5B4
                CMPB    A, r1                  ; 0FEE 0 108 13D 49
                                               ; 0FEF from 0FEA (DD0,108,13D)
label_0fef:     MB      off(00121h).6, C       ; 0FEF 0 108 13D C4213E
                JGE     label_1023             ; 0FF2 0 108 13D CD2F
                CMPB    r0, #003h              ; 0FF4 0 108 13D 20C003
                JGE     label_1023             ; 0FF7 0 108 13D CD2A
                LB      A, 0afh                ; 0FF9 0 108 13D F5AF
                JBS     off(00122h).2, label_1000 ; 0FFB 0 108 13D EA2202
                LB      A, 0adh                ; 0FFE 0 108 13D F5AD
                                               ; 1000 from 0FFB (DD0,108,13D)
label_1000:     CMPB    A, #083h               ; 1000 0 108 13D C683
                JGE     label_1023             ; 1002 0 108 13D CD1F
                MOV     X1, #0371dh            ; 1004 0 108 13D 601D37
                LB      A, 0a3h                ; 1007 0 108 13D F5A3
                VCAL    0                      ; 1009 0 108 13D 10
                LB      A, off(0015dh)         ; 100A 0 108 13D F45D
                MOVB    r0, #0cch              ; 100C 0 108 13D 98CC
                MULB                           ; 100E 0 108 13D A234
                LB      A, ACCH                ; 1010 0 108 13D F507
                STB     A, off(0015dh)         ; 1012 0 108 13D D45D
                ADDB    A, r6                  ; 1014 0 108 13D 0E
                STB     A, r2                  ; 1015 0 108 13D 8A
                MOV     X1, #036fdh            ; 1016 0 108 13D 60FD36
                LB      A, 0a3h                ; 1019 0 108 13D F5A3
                VCAL    0                      ; 101B 0 108 13D 10
                MOVB    r7, r2                 ; 101C 0 108 13D 224F
                CAL     label_2bdd             ; 101E 0 108 13D 32DD2B
                SJ      label_102f             ; 1021 0 108 13D CB0C
                                               ; 1023 from 0FCA (DD0,108,13D)
                                               ; 1023 from 0FDA (DD0,108,13D)
                                               ; 1023 from 0FF2 (DD0,108,13D)
                                               ; 1023 from 0FF7 (DD0,108,13D)
                                               ; 1023 from 1002 (DD0,108,13D)
label_1023:     CAL     label_2e6c             ; 1023 0 108 13D 326C2E
                MOV     X1, #036fdh            ; 1026 0 108 13D 60FD36
                MOV     X2, #0370dh            ; 1029 0 108 13D 610D37
                CAL     label_2bd1             ; 102C 0 108 13D 32D12B
                                               ; 102F from 1021 (DD0,108,13D)
label_102f:     STB     A, off(00168h)         ; 102F 0 108 13D D468
                SUBB    A, #040h               ; 1031 0 108 13D A640
                MOVB    r0, #01ch              ; 1033 0 108 13D 981C
                MULB                           ; 1035 0 108 13D A234
                ADDB    ACCH, #001h            ; 1037 0 108 13D C5078001
                MOV     off(00166h), A         ; 103B 0 108 13D B4668A
                LB      A, off(00130h)         ; 103E 0 108 13D F430
                ANDB    A, #074h               ; 1040 0 108 13D D674
                JNE     label_10a6             ; 1042 0 108 13D CE62
                JBS     off(00131h).1, label_10a6 ; 1044 0 108 13D E9315F
                JBS     off(00132h).0, label_10a6 ; 1047 0 108 13D E8325C
                LB      A, off(001e9h)         ; 104A 0 108 13D F4E9
                JNE     label_10a6             ; 104C 0 108 13D CE58
                CMPB    0a3h, #0ffh            ; 104E 0 108 13D C5A3C0FF
                JGE     label_10a6             ; 1052 0 108 13D CD52
                LB      A, #018h               ; 1054 0 108 13D 7718
                JBS     off(0011dh).3, label_105b ; 1056 0 108 13D EB1D02
                LB      A, #020h               ; 1059 0 108 13D 7720
                                               ; 105B from 1056 (DD0,108,13D)
label_105b:     CMPB    A, 0cbh                ; 105B 0 108 13D C5CBC2
                MB      off(0011dh).3, C       ; 105E 0 108 13D C41D3B
                JLT     label_10a6             ; 1061 0 108 13D CA43
                JBR     off(00125h).3, label_10a6 ; 1063 0 108 13D DB2540
                CMPB    0adh, #085h            ; 1066 0 108 13D C5ADC085
                JGE     label_10a6             ; 106A 0 108 13D CD3A
                LB      A, 0b4h                ; 106C 0 108 13D F5B4
                SUBB    A, 0b3h                ; 106E 0 108 13D C5B3A2
                JLT     label_10a6             ; 1071 0 108 13D CA33
                STB     A, r2                  ; 1073 0 108 13D 8A
                CMPB    A, #004h               ; 1074 0 108 13D C604
                JLT     label_10a0             ; 1076 0 108 13D CA28
                MOV     X1, #03814h            ; 1078 0 108 13D 601438
                VCAL    0                      ; 107B 0 108 13D 10
                XCHGB   A, r2                  ; 107C 0 108 13D 2210
                MOV     X1, #03820h            ; 107E 0 108 13D 602038
                VCAL    0                      ; 1081 0 108 13D 10
                MOVB    r7, r2                 ; 1082 0 108 13D 224F
                MOV     X1, #0382ch            ; 1084 0 108 13D 602C38
                LB      A, 0a3h                ; 1087 0 108 13D F5A3
                CAL     label_2be6             ; 1089 0 108 13D 32E62B
                STB     A, r2                  ; 108C 0 108 13D 8A
                MOV     X1, #0382fh            ; 108D 0 108 13D 602F38
                LB      A, 0a4h                ; 1090 0 108 13D F5A4
                VCAL    2                      ; 1092 0 108 13D 12
                MOVB    r0, r2                 ; 1093 0 108 13D 2248
                MULB                           ; 1095 0 108 13D A234
                SLL     ACC                    ; 1097 0 108 13D B506D7
                JGE     label_10a0             ; 109A 0 108 13D CD04
                MOVB    ACCH, #0ffh            ; 109C 0 108 13D C50798FF
                                               ; 10A0 from 1076 (DD0,108,13D)
                                               ; 10A0 from 109A (DD0,108,13D)
label_10a0:     LB      A, ACCH                ; 10A0 0 108 13D F507
                CMPB    A, #080h               ; 10A2 0 108 13D C680
                JGE     label_10a8             ; 10A4 0 108 13D CD02
                                               ; 10A6 from 1042 (DD0,108,13D)
                                               ; 10A6 from 1044 (DD0,108,13D)
                                               ; 10A6 from 1047 (DD0,108,13D)
                                               ; 10A6 from 104C (DD0,108,13D)
                                               ; 10A6 from 1052 (DD0,108,13D)
                                               ; 10A6 from 1061 (DD0,108,13D)
                                               ; 10A6 from 1063 (DD0,108,13D)
                                               ; 10A6 from 106A (DD0,108,13D)
                                               ; 10A6 from 1071 (DD0,108,13D)
label_10a6:     LB      A, #080h               ; 10A6 0 108 13D 7780
                                               ; 10A8 from 10A4 (DD0,108,13D)
label_10a8:     STB     A, off(00153h)         ; 10A8 0 108 13D D453
                CLRB    r6                     ; 10AA 0 108 13D 2615
                JBS     off(00132h).0, label_10f0 ; 10AC 0 108 13D E83241
                JBS     off(00118h).6, label_10f0 ; 10AF 0 108 13D EE183E
                JBR     off(00124h).2, label_10f0 ; 10B2 0 108 13D DA243B
                LB      A, #0b3h               ; 10B5 0 108 13D 77B3
                MOVB    r0, #046h              ; 10B7 0 108 13D 9846
                JBR     off(00121h).5, label_10c0 ; 10B9 0 108 13D DD2104
                LB      A, #0bah               ; 10BC 0 108 13D 77BA
                MOVB    r0, #040h              ; 10BE 0 108 13D 9840
                                               ; 10C0 from 10B9 (DD0,108,13D)
label_10c0:     CMPB    0a6h, A                ; 10C0 0 108 13D C5A6C1
                JGE     label_10c9             ; 10C3 0 108 13D CD04
                LB      A, r0                  ; 10C5 0 108 13D 78
                CMPB    A, 0a6h                ; 10C6 0 108 13D C5A6C2
                                               ; 10C9 from 10C3 (DD0,108,13D)
label_10c9:     MB      off(00121h).5, C       ; 10C9 0 108 13D C4213D
                JGE     label_10f0             ; 10CC 0 108 13D CD22
                MOV     er0, 0bah              ; 10CE 0 108 13D B5BA48
                CLR     A                      ; 10D1 1 108 13D F9
                MOV     er2, 0c4h              ; 10D2 1 108 13D B5C44A
                DIV                            ; 10D5 1 108 13D 9037
                CMP     er0, #00000h           ; 10D7 1 108 13D 44C00000
                JEQ     label_10e0             ; 10DB 1 108 13D C903
                L       A, #0ffffh             ; 10DD 1 108 13D 67FFFF
                                               ; 10E0 from 10DB (DD1,108,13D)
label_10e0:     MOV     DP, #00268h            ; 10E0 1 108 13D 626802
                ST      A, [DP]                ; 10E3 1 108 13D D2
                CMP     A, #02c57h             ; 10E4 1 108 13D C6572C
                JGE     label_10f0             ; 10E7 1 108 13D CD07
                INCB    r6                     ; 10E9 1 108 13D AE
                CMP     A, #01c9ah             ; 10EA 1 108 13D C69A1C
                JGE     label_10f0             ; 10ED 1 108 13D CD01
                INCB    r6                     ; 10EF 1 108 13D AE
                                               ; 10F0 from 10AC (DD0,108,13D)
                                               ; 10F0 from 10AF (DD0,108,13D)
                                               ; 10F0 from 10B2 (DD0,108,13D)
                                               ; 10F0 from 10CC (DD0,108,13D)
                                               ; 10F0 from 10E7 (DD1,108,13D)
                                               ; 10F0 from 10ED (DD1,108,13D)
label_10f0:     LB      A, r6                  ; 10F0 0 108 13D 7E
                SRLB    A                      ; 10F1 0 108 13D 63
                MB      off(00124h).1, C       ; 10F2 0 108 13D C42439
                SRLB    A                      ; 10F5 0 108 13D 63
                MB      off(00124h).0, C       ; 10F6 0 108 13D C42438
                CMPB    0a6h, #0e8h            ; 10F9 0 108 13D C5A6C0E8
                JGE     label_112d             ; 10FD 0 108 13D CD2E
                MB      C, off(0011fh).3       ; 10FF 0 108 13D C41F2B
                MOV     DP, #000afh            ; 1102 0 108 13D 62AF00
                JBS     off(00122h).2, label_110d ; 1105 0 108 13D EA2205
                MB      C, off(0011fh).2       ; 1108 0 108 13D C41F2A
                DEC     DP                     ; 110B 0 108 13D 82
                DEC     DP                     ; 110C 0 108 13D 82
                                               ; 110D from 1105 (DD0,108,13D)
label_110d:     ROLB    r0                     ; 110D 0 108 13D 20B7
                LB      A, #083h               ; 110F 0 108 13D 7783
                CMPB    [DP], A                ; 1111 0 108 13D C2C1
                JGE     label_1140             ; 1113 0 108 13D CD2B
                LB      A, #07eh               ; 1115 0 108 13D 777E
                CMPB    off(001d8h), #000h     ; 1117 0 108 13D C4D8C000
                JEQ     label_111f             ; 111B 0 108 13D C902
                SUBB    A, #008h               ; 111D 0 108 13D A608
                                               ; 111F from 111B (DD0,108,13D)
label_111f:     CMPB    [DP], A                ; 111F 0 108 13D C2C1
                JLT     label_1133             ; 1121 0 108 13D CA10
                JBS     off(00122h).3, label_1139 ; 1123 0 108 13D EB2213
                                               ; 1126 from 1160 (DD0,108,13D)
label_1126:     L       A, off(0014ah)         ; 1126 1 108 13D E44A
                JEQ     label_112d             ; 1128 1 108 13D C903
                JBS     off(00123h).3, label_1130 ; 112A 1 108 13D EB2303
                                               ; 112D from 10FD (DD0,108,13D)
                                               ; 112D from 1128 (DD1,108,13D)
                                               ; 112D from 113B (DD0,108,13D)
label_112d:     J       label_1288             ; 112D 1 108 13D 038812
                                               ; 1130 from 112A (DD1,108,13D)
label_1130:     J       label_11dd             ; 1130 1 108 13D 03DD11
                                               ; 1133 from 1121 (DD0,108,13D)
label_1133:     JBR     off(00108h).0, label_1139 ; 1133 0 108 13D D80803
                J       label_1223             ; 1136 0 108 13D 032312
                                               ; 1139 from 1123 (DD0,108,13D)
                                               ; 1139 from 1133 (DD0,108,13D)
label_1139:     LB      A, off(0015ch)         ; 1139 0 108 13D F45C
                JEQ     label_112d             ; 113B 0 108 13D C9F0
                J       label_1272             ; 113D 0 108 13D 037212
                                               ; 1140 from 1113 (DD0,108,13D)
label_1140:     JBS     off(00108h).0, label_1162 ; 1140 0 108 13D E8081F
                MOVB    r1, #090h              ; 1143 0 108 13D 9990
                JBS     off(00124h).0, label_115d ; 1145 0 108 13D E82415
                MOVB    r1, #090h              ; 1148 0 108 13D 9990
                JBS     off(00124h).1, label_115d ; 114A 0 108 13D E92410
                MOVB    r1, #084h              ; 114D 0 108 13D 9984
                LB      A, 0a6h                ; 114F 0 108 13D F5A6
                CMPB    A, #094h               ; 1151 0 108 13D C694
                JGE     label_115d             ; 1153 0 108 13D CD08
                MOVB    r1, #088h              ; 1155 0 108 13D 9988
                CMPB    A, #062h               ; 1157 0 108 13D C662
                JGE     label_115d             ; 1159 0 108 13D CD02
                MOVB    r1, #084h              ; 115B 0 108 13D 9984
                                               ; 115D from 1145 (DD0,108,13D)
                                               ; 115D from 114A (DD0,108,13D)
                                               ; 115D from 1153 (DD0,108,13D)
                                               ; 115D from 1159 (DD0,108,13D)
label_115d:     LB      A, r1                  ; 115D 0 108 13D 79
                CMPB    [DP], A                ; 115E 0 108 13D C2C1
                JLT     label_1126             ; 1160 0 108 13D CAC4
                                               ; 1162 from 1140 (DD0,108,13D)
label_1162:     CLRB    A                      ; 1162 0 108 13D FA
                CMPB    0a3h, #02eh            ; 1163 0 108 13D C5A3C02E
                JGE     label_117f             ; 1167 0 108 13D CD16
                JBS     off(00124h).0, label_1176 ; 1169 0 108 13D E8240A
                JBR     off(00124h).1, label_117f ; 116C 0 108 13D D92410
                LB      A, #020h               ; 116F 0 108 13D 7720
                CMPB    [DP], #0bbh            ; 1171 0 108 13D C2C0BB
                SJ      label_117b             ; 1174 0 108 13D CB05
                                               ; 1176 from 1169 (DD0,108,13D)
label_1176:     LB      A, #018h               ; 1176 0 108 13D 7718
                CMPB    [DP], #0b3h            ; 1178 0 108 13D C2C0B3
                                               ; 117B from 1174 (DD0,108,13D)
label_117b:     SCAL    label_11d8             ; 117B 0 108 13D 315B
                SJ      label_1192             ; 117D 0 108 13D CB13
                                               ; 117F from 1167 (DD0,108,13D)
                                               ; 117F from 116C (DD0,108,13D)
label_117f:     JBS     off(00122h).7, label_118f ; 117F 0 108 13D EF220D
                JBS     off(00123h).1, label_1188 ; 1182 0 108 13D E92303
                JBR     off(00123h).2, label_118d ; 1185 0 108 13D DA2305
                                               ; 1188 from 1182 (DD0,108,13D)
label_1188:     SB      off(00122h).7          ; 1188 0 108 13D C4221F
                SJ      label_118f             ; 118B 0 108 13D CB02
                                               ; 118D from 1185 (DD0,108,13D)
label_118d:     LB      A, #00ch               ; 118D 0 108 13D 770C
                                               ; 118F from 117F (DD0,108,13D)
                                               ; 118F from 118B (DD0,108,13D)
label_118f:     CAL     label_11cc             ; 118F 0 108 13D 32CC11
                                               ; 1192 from 117D (DD0,108,13D)
label_1192:     CLRB    r1                     ; 1192 0 108 13D 2115
                CMPB    A, #008h               ; 1194 0 108 13D C608
                JEQ     label_119c             ; 1196 0 108 13D C904
                CMPB    A, #014h               ; 1198 0 108 13D C614
                JNE     label_11a4             ; 119A 0 108 13D CE08
                                               ; 119C from 1196 (DD0,108,13D)
label_119c:     CMPB    0eeh, #07ah            ; 119C 0 108 13D C5EEC07A
                JGE     label_11a4             ; 11A0 0 108 13D CD02
                MOVB    r1, #0b3h              ; 11A2 0 108 13D 99B3
                                               ; 11A4 from 119A (DD0,108,13D)
                                               ; 11A4 from 11A0 (DD0,108,13D)
label_11a4:     EXTND                          ; 11A4 1 108 13D F8
                ADD     A, #0386ah             ; 11A5 1 108 13D 866A38
                MOV     X1, A                  ; 11A8 1 108 13D 50
                LB      A, [DP]                ; 11A9 0 108 13D F2
                ADDB    A, #080h               ; 11AA 0 108 13D 8680
                CMPCB   A, [X1]                ; 11AC 0 108 13D 90AE
                JLT     label_11b2             ; 11AE 0 108 13D CA02
                LCB     A, [X1]                ; 11B0 0 108 13D 90AA
                                               ; 11B2 from 11AE (DD0,108,13D)
label_11b2:     STB     A, r0                  ; 11B2 0 108 13D 88
                INC     X1                     ; 11B3 0 108 13D 70
                LCB     A, [X1]                ; 11B4 0 108 13D 90AA
                MULB                           ; 11B6 0 108 13D A234
                L       A, ACC                 ; 11B8 1 108 13D E506
                ST      A, er3                 ; 11BA 1 108 13D 8B
                INC     X1                     ; 11BB 1 108 13D 70
                LC      A, [X1]                ; 11BC 1 108 13D 90A8
                VCAL    5                      ; 11BE 1 108 13D 15
                CMPB    r1, #000h              ; 11BF 1 108 13D 21C000
                JEQ     label_120e             ; 11C2 1 108 13D C94A
                CLRB    r0                     ; 11C4 1 108 13D 2015
                MUL                            ; 11C6 1 108 13D 9035
                XCHG    A, er1                 ; 11C8 1 108 13D 4510
                SJ      label_120e             ; 11CA 1 108 13D CB42
                                               ; 11CC from 11E8 (DD0,108,13D)
                                               ; 11CC from 118F (DD0,108,13D)
label_11cc:     CMPB    0a6h, #094h            ; 11CC 0 108 13D C5A6C094
                JGE     label_11dc             ; 11D0 0 108 13D CD0A
                ADDB    A, #004h               ; 11D2 0 108 13D 8604
                CMPB    0a6h, #062h            ; 11D4 0 108 13D C5A6C062
                                               ; 11D8 from 117B (DD0,108,13D)
label_11d8:     JGE     label_11dc             ; 11D8 0 108 13D CD02
                ADDB    A, #004h               ; 11DA 0 108 13D 8604
                                               ; 11DC from 11D8 (DD0,108,13D)
                                               ; 11DC from 11D0 (DD0,108,13D)
label_11dc:     RT                             ; 11DC 0 108 13D 01
                                               ; 11DD from 1130 (DD1,108,13D)
label_11dd:     LB      A, #024h               ; 11DD 0 108 13D 7724
                JBS     off(00124h).0, label_11f6 ; 11DF 0 108 13D E82414
                LB      A, #02ah               ; 11E2 0 108 13D 772A
                JBS     off(00124h).1, label_11f6 ; 11E4 0 108 13D E9240F
                CLRB    A                      ; 11E7 0 108 13D FA
                CAL     label_11cc             ; 11E8 0 108 13D 32CC11
                STB     A, r0                  ; 11EB 0 108 13D 88
                SRLB    A                      ; 11EC 0 108 13D 63
                ADDB    A, r0                  ; 11ED 0 108 13D 08
                CMPB    0a3h, #06eh            ; 11EE 0 108 13D C5A3C06E
                JLT     label_11f6             ; 11F2 0 108 13D CA02
                ADDB    A, #012h               ; 11F4 0 108 13D 8612
                                               ; 11F6 from 11DF (DD0,108,13D)
                                               ; 11F6 from 11E4 (DD0,108,13D)
                                               ; 11F6 from 11F2 (DD0,108,13D)
label_11f6:     EXTND                          ; 11F6 1 108 13D F8
                ADD     A, #03892h             ; 11F7 1 108 13D 869238
                MOV     X1, A                  ; 11FA 1 108 13D 50
                L       A, off(0014ah)         ; 11FB 1 108 13D E44A
                ST      A, er0                 ; 11FD 1 108 13D 88
                CMPC    A, 00004h[X1]          ; 11FE 1 108 13D 90AD0400
                JGE     label_1206             ; 1202 1 108 13D CD02
                INC     X1                     ; 1204 1 108 13D 70
                INC     X1                     ; 1205 1 108 13D 70
                                               ; 1206 from 1202 (DD1,108,13D)
label_1206:     LC      A, [X1]                ; 1206 1 108 13D 90A8
                XCHG    A, er0                 ; 1208 1 108 13D 4410
                SUB     A, er0                 ; 120A 1 108 13D 28
                JGE     label_120e             ; 120B 1 108 13D CD01
                CLR     A                      ; 120D 1 108 13D F9
                                               ; 120E from 120B (DD1,108,13D)
                                               ; 120E from 11C2 (DD1,108,13D)
                                               ; 120E from 11CA (DD1,108,13D)
label_120e:     J       label_2fba             ; 120E 1 108 13D 03BA2F
                DB  000h ; 1211
                                               ; 1212 from 2FC0 (DD1,108,13D)
label_1212:     SB      r7.0                   ; 1212 1 108 13D 2718
                RB      0feh.6                 ; 1214 1 108 13D C5FE0E
                CLRB    off(0015ch)            ; 1217 1 108 13D C45C15
                CAL     label_30a3             ; 121A 1 108 13D 32A330
                MOVB    off(001d8h), #00ah     ; 121D 1 108 13D C4D8980A
                SJ      label_1296             ; 1221 1 108 13D CB73
                                               ; 1223 from 1136 (DD0,108,13D)
label_1223:     JBS     off(00122h).3, label_124b ; 1223 0 108 13D EB2225
                JBS     off(00124h).0, label_1288 ; 1226 0 108 13D E8245F
                JBR     off(00124h).1, label_1232 ; 1229 0 108 13D D92406
                CMPB    0cbh, #038h            ; 122C 0 108 13D C5CBC038
                JLT     label_1288             ; 1230 0 108 13D CA56
                                               ; 1232 from 1229 (DD0,108,13D)
label_1232:     LB      A, off(001e9h)         ; 1232 0 108 13D F4E9
                JNE     label_1288             ; 1234 0 108 13D CE52
                CMPB    0ach, #06ch            ; 1236 0 108 13D C5ACC06C
                JGE     label_1288             ; 123A 0 108 13D CD4C
                LB      A, 0a6h                ; 123C 0 108 13D F5A6
                CMPB    A, #05eh               ; 123E 0 108 13D C65E
                JLT     label_1288             ; 1240 0 108 13D CA46
                CMPB    A, #0c1h               ; 1242 0 108 13D C6C1
                JGE     label_1288             ; 1244 0 108 13D CD42
                CMPB    A, #094h               ; 1246 0 108 13D C694
                MB      off(00122h).4, C       ; 1248 0 108 13D C4223C
                                               ; 124B from 1223 (DD0,108,13D)
label_124b:     MOVB    r2, #028h              ; 124B 0 108 13D 9A28
                MOVB    r0, #003h              ; 124D 0 108 13D 9803
                MOVB    r1, #0ffh              ; 124F 0 108 13D 99FF
                J       label_303f             ; 1251 0 108 13D 033F30
                                               ; 1254 from 3054 (DD0,108,13D)
label_1254:     MOVB    r2, #00fh              ; 1254 0 108 13D 9A0F
                MOVB    r0, #007h              ; 1256 0 108 13D 9807
                MOVB    r1, #0ffh              ; 1258 0 108 13D 99FF
                                               ; 125A from 3057 (DD0,108,13D)
label_125a:     LB      A, #080h               ; 125A 0 108 13D 7780
                SUBB    A, [DP]                ; 125C 0 108 13D C2A2
                CMPB    A, r2                  ; 125E 0 108 13D 4A
                JLT     label_1262             ; 125F 0 108 13D CA01
                LB      A, r2                  ; 1261 0 108 13D 7A
                                               ; 1262 from 125F (DD0,108,13D)
label_1262:     MULB                           ; 1262 0 108 13D A234
                CMPB    ACCH, #000h            ; 1264 0 108 13D C507C000
                JNE     label_126f             ; 1268 0 108 13D CE05
                XCHGB   A, r1                  ; 126A 0 108 13D 2110
                SUBB    A, r1                  ; 126C 0 108 13D 29
                JGE     label_1281             ; 126D 0 108 13D CD12
                                               ; 126F from 1268 (DD0,108,13D)
label_126f:     CLRB    A                      ; 126F 0 108 13D FA
                SJ      label_1281             ; 1270 0 108 13D CB0F
                                               ; 1272 from 113D (DD0,108,13D)
label_1272:     MOVB    r0, #003h              ; 1272 0 108 13D 9803
                J       label_305a             ; 1274 0 108 13D 035A30
                DB  000h,0CDh,002h ; 1277
                                               ; 127A from 306A (DD0,108,13D)
label_127a:     MOVB    r0, #003h              ; 127A 0 108 13D 9803
                                               ; 127C from 306D (DD0,108,13D)
label_127c:     LB      A, off(0015ch)         ; 127C 0 108 13D F45C
                ADDB    A, r0                  ; 127E 0 108 13D 08
                JLT     label_1288             ; 127F 0 108 13D CA07
                                               ; 1281 from 126D (DD0,108,13D)
                                               ; 1281 from 1270 (DD0,108,13D)
label_1281:     STB     A, off(0015ch)         ; 1281 0 108 13D D45C
                SB      off(00122h).3          ; 1283 0 108 13D C4221B
                SJ      label_128e             ; 1286 0 108 13D CB06
                                               ; 1288 from 112D (DD1,108,13D)
                                               ; 1288 from 1226 (DD0,108,13D)
                                               ; 1288 from 1230 (DD0,108,13D)
                                               ; 1288 from 1234 (DD0,108,13D)
                                               ; 1288 from 123A (DD0,108,13D)
                                               ; 1288 from 1240 (DD0,108,13D)
                                               ; 1288 from 1244 (DD0,108,13D)
                                               ; 1288 from 127F (DD0,108,13D)
                                               ; 1288 from 2FC3 (DD1,108,13D)
label_1288:     CLRB    off(0015ch)            ; 1288 1 108 13D C45C15
                RB      off(00122h).3          ; 128B 1 108 13D C4220B
                                               ; 128E from 1286 (DD0,108,13D)
label_128e:     CLR     off(0014ah)            ; 128E 1 108 13D B44A15
                RB      off(00122h).7          ; 1291 1 108 13D C4220F
                RB      r7.0                   ; 1294 1 108 13D 2708
                                               ; 1296 from 1221 (DD1,108,13D)
label_1296:     SRLB    r7                     ; 1296 1 108 13D 27E7
                RB      off(00122h).5          ; 1298 1 108 13D C4220D
                MB      off(00122h).5, C       ; 129B 1 108 13D C4223D
                JGE     label_12a3             ; 129E 1 108 13D CD03
                JEQ     label_12a3             ; 12A0 1 108 13D C901
                RC                             ; 12A2 1 108 13D 95
                                               ; 12A3 from 129E (DD1,108,13D)
                                               ; 12A3 from 12A0 (DD1,108,13D)
label_12a3:     MB      off(00122h).6, C       ; 12A3 1 108 13D C4223E
                L       A, off(0016ch)         ; 12A6 1 108 13D E46C
                CMP     A, #00100h             ; 12A8 1 108 13D C60001
                JEQ     label_12f4             ; 12AB 1 108 13D C947
                ST      A, er0                 ; 12AD 1 108 13D 88
                CLRB    r7                     ; 12AE 1 108 13D 2715
                MOV     X1, #001b3h            ; 12B0 1 108 13D 60B301
                MOV     X2, #00133h            ; 12B3 1 108 13D 613301
                JBR     off(0011ah).5, label_12c1 ; 12B6 1 108 13D DD1A08
                MOVB    r7, #008h              ; 12B9 1 108 13D 9F08
                MOV     X1, #001d9h            ; 12BB 1 108 13D 60D901
                MOV     X2, #00133h            ; 12BE 1 108 13D 613301
                                               ; 12C1 from 12B6 (DD1,108,13D)
label_12c1:     CMP     A, X1                  ; 12C1 1 108 13D 90C2
                JGE     label_12ca             ; 12C3 1 108 13D CD05
                ADDB    r7, #004h              ; 12C5 1 108 13D 278004
                CMP     A, X2                  ; 12C8 1 108 13D 91C2
                                               ; 12CA from 12C3 (DD1,108,13D)
label_12ca:     LB      A, r7                  ; 12CA 0 108 13D 7F
                JGE     label_12df             ; 12CB 0 108 13D CD12
                LB      A, #010h               ; 12CD 0 108 13D 7710
                CMPB    0a4h, #0a6h            ; 12CF 0 108 13D C5A4C0A6
                JGE     label_12df             ; 12D3 0 108 13D CD0A
                LB      A, #014h               ; 12D5 0 108 13D 7714
                CMPB    0a4h, #034h            ; 12D7 0 108 13D C5A4C034
                JGE     label_12df             ; 12DB 0 108 13D CD02
                LB      A, #018h               ; 12DD 0 108 13D 7718
                                               ; 12DF from 12CB (DD0,108,13D)
                                               ; 12DF from 12D3 (DD0,108,13D)
                                               ; 12DF from 12DB (DD0,108,13D)
label_12df:     EXTND                          ; 12DF 1 108 13D F8
                LC      A, 037f8h[ACC]         ; 12E0 1 108 13D B506A9F837
                ST      A, er1                 ; 12E5 1 108 13D 89
                LB      A, off(0016eh)         ; 12E6 0 108 13D F46E
                SUBB    A, r2                  ; 12E8 0 108 13D 2A
                STB     A, off(0016eh)         ; 12E9 0 108 13D D46E
                LB      A, r0                  ; 12EB 0 108 13D 78
                SBCB    A, r3                  ; 12EC 0 108 13D 3B
                STB     A, r2                  ; 12ED 0 108 13D 8A
                LB      A, r1                  ; 12EE 0 108 13D 79
                SBCB    A, #000h               ; 12EF 0 108 13D B600
                STB     A, r3                  ; 12F1 0 108 13D 8B
                JNE     label_12fb             ; 12F2 0 108 13D CE07
                                               ; 12F4 from 12AB (DD1,108,13D)
label_12f4:     MOV     er1, #00100h           ; 12F4 0 108 13D 45980001
                MOV     off(0016ah), er1       ; 12F8 0 108 13D 457C6A
                                               ; 12FB from 12F2 (DD0,108,13D)
label_12fb:     MOV     off(0016ch), er1       ; 12FB 0 108 13D 457C6C
                LB      A, off(00158h)         ; 12FE 0 108 13D F458
                MOVB    r1, #001h              ; 1300 0 108 13D 9901
                JBS     off(00158h).7, label_1306 ; 1302 0 108 13D EF5801
                INCB    r1                     ; 1305 0 108 13D A9
                                               ; 1306 from 1302 (DD0,108,13D)
label_1306:     ADDB    A, off(0015ah)         ; 1306 0 108 13D 875A
                JGE     label_130b             ; 1308 0 108 13D CD01
                INCB    r1                     ; 130A 0 108 13D A9
                                               ; 130B from 1308 (DD0,108,13D)
label_130b:     ADDB    A, off(00159h)         ; 130B 0 108 13D 8759
                STB     A, r0                  ; 130D 0 108 13D 88
                JGE     label_1311             ; 130E 0 108 13D CD01
                INCB    r1                     ; 1310 0 108 13D A9
                                               ; 1311 from 130E (DD0,108,13D)
label_1311:     LB      A, off(0016fh)         ; 1311 0 108 13D F46F
                JEQ     label_131c             ; 1313 0 108 13D C907
                STB     A, ACCH                ; 1315 0 108 13D D507
                CLRB    A                      ; 1317 0 108 13D FA
                MUL                            ; 1318 0 108 13D 9035
                MOV     er0, er1               ; 131A 0 108 13D 4548
                                               ; 131C from 1313 (DD0,108,13D)
label_131c:     LB      A, off(0015ch)         ; 131C 0 108 13D F45C
                JEQ     label_1327             ; 131E 0 108 13D C907
                STB     A, ACCH                ; 1320 0 108 13D D507
                CLRB    A                      ; 1322 0 108 13D FA
                MUL                            ; 1323 0 108 13D 9035
                MOV     er0, er1               ; 1325 0 108 13D 4548
                                               ; 1327 from 131E (DD0,108,13D)
label_1327:     LB      A, off(00153h)         ; 1327 0 108 13D F453
                STB     A, ACCH                ; 1329 0 108 13D D507
                CLRB    A                      ; 132B 0 108 13D FA
                MUL                            ; 132C 0 108 13D 9035
                MOV     er0, er1               ; 132E 0 108 13D 4548
                SLL     ACC                    ; 1330 0 108 13D B506D7
                ROL     er0                    ; 1333 0 108 13D 44B7
                JGE     label_133b             ; 1335 0 108 13D CD04
                MOV     er0, #0ffffh           ; 1337 0 108 13D 4498FFFF
                                               ; 133B from 1335 (DD0,108,13D)
label_133b:     CLRB    r5                     ; 133B 0 108 13D 2515
                LB      A, off(00168h)         ; 133D 0 108 13D F468
                CMPB    A, off(0015bh)         ; 133F 0 108 13D C75B
                JGE     label_1345             ; 1341 0 108 13D CD02
                LB      A, off(0015bh)         ; 1343 0 108 13D F45B
                                               ; 1345 from 1341 (DD0,108,13D)
label_1345:     STB     A, r4                  ; 1345 0 108 13D 8C
                JBS     off(0011bh).0, label_134c ; 1346 0 108 13D E81B03
                JBR     off(0011ch).0, label_1358 ; 1349 0 108 13D D81C0C
                                               ; 134C from 1346 (DD0,108,13D)
label_134c:     MOVB    r4, off(00169h)        ; 134C 0 108 13D C4694C
                L       A, #00100h             ; 134F 1 108 13D 670001
                CMPB    0a4h, #028h            ; 1352 1 108 13D C5A4C028
                JGE     label_135a             ; 1356 1 108 13D CD02
                                               ; 1358 from 1349 (DD0,108,13D)
label_1358:     L       A, off(0016ch)         ; 1358 1 108 13D E46C
                                               ; 135A from 1356 (DD1,108,13D)
label_135a:     MUL                            ; 135A 1 108 13D 9035
                MOVB    r1, r2                 ; 135C 1 108 13D 2249
                MOVB    r0, ACCH               ; 135E 1 108 13D C50748
                L       A, er2                 ; 1361 1 108 13D 36
                MUL                            ; 1362 1 108 13D 9035
                MOV     er0, er1               ; 1364 1 108 13D 4548
                MOV     er2, #00040h           ; 1366 1 108 13D 46984000
                DIV                            ; 136A 1 108 13D 9037
                ST      A, off(0015eh)         ; 136C 1 108 13D D45E
                MB      C, 0feh.6              ; 136E 1 108 13D C5FE2E
                JGE     label_1384             ; 1371 1 108 13D CD11
                CLR     A                      ; 1373 1 108 13D F9
                AND     IE, #00080h            ; 1374 1 108 13D B51AD08000
                RB      PSWH.0                 ; 1379 1 108 13D A208
                ST      A, off(00144h)         ; 137B 1 108 13D D444
                ST      A, off(00146h)         ; 137D 1 108 13D D446
                ST      A, off(00148h)         ; 137F 1 108 13D D448
                J       label_1498             ; 1381 1 108 13D 039814
                                               ; 1384 from 1371 (DD1,108,13D)
label_1384:     MOV     er0, off(00142h)       ; 1384 1 108 13D B44248
                JBS     off(00129h).7, label_13a3 ; 1387 1 108 13D EF2919
                MB      C, P0.1                ; 138A 1 108 13D C52029
                JGE     label_139e             ; 138D 1 108 13D CD0F
                LB      A, #0e0h               ; 138F 0 108 13D 77E0
                JBR     off(0011dh).7, label_1396 ; 1391 0 108 13D DF1D02
                LB      A, #0d8h               ; 1394 0 108 13D 77D8
                                               ; 1396 from 1391 (DD0,108,13D)
label_1396:     CMPB    A, 0a6h                ; 1396 0 108 13D C5A6C2
                MB      off(0011dh).7, C       ; 1399 0 108 13D C41D3F
                JLT     label_13a1             ; 139C 0 108 13D CA03
                                               ; 139E from 138D (DD1,108,13D)
label_139e:     MOV     er0, off(00140h)       ; 139E 0 108 13D B44048
                                               ; 13A1 from 139C (DD0,108,13D)
label_13a1:     L       A, off(0015eh)         ; 13A1 1 108 13D E45E
                                               ; 13A3 from 1387 (DD1,108,13D)
label_13a3:     MUL                            ; 13A3 1 108 13D 9035
                SRL     er1                    ; 13A5 1 108 13D 45E7
                ROR     A                      ; 13A7 1 108 13D 43
                LB      A, r2                  ; 13A8 0 108 13D 7A
                L       A, ACC                 ; 13A9 1 108 13D E506
                SWAP                           ; 13AB 1 108 13D 83
                CMPB    r3, #000h              ; 13AC 1 108 13D 23C000
                JEQ     label_13b4             ; 13AF 1 108 13D C903
                L       A, #0ffffh             ; 13B1 1 108 13D 67FFFF
                                               ; 13B4 from 13AF (DD1,108,13D)
label_13b4:     MOV     X1, A                  ; 13B4 1 108 13D 50
                L       A, off(0014ah)         ; 13B5 1 108 13D E44A
                MOV     er0, off(00166h)       ; 13B7 1 108 13D B46648
                MUL                            ; 13BA 1 108 13D 9035
                MOVB    r1, r2                 ; 13BC 1 108 13D 2249
                MOVB    r0, ACCH               ; 13BE 1 108 13D C50748
                L       A, off(0016ah)         ; 13C1 1 108 13D E46A
                MUL                            ; 13C3 1 108 13D 9035
                MOVB    r7, r2                 ; 13C5 1 108 13D 224F
                MOVB    r6, ACCH               ; 13C7 1 108 13D C5074E
                L       A, off(0014ch)         ; 13CA 1 108 13D E44C
                VCAL    5                      ; 13CC 1 108 13D 15
                L       A, off(00150h)         ; 13CD 1 108 13D E450
                VCAL    5                      ; 13CF 1 108 13D 15
                LB      A, off(00152h)         ; 13D0 0 108 13D F452
                EXTND                          ; 13D2 1 108 13D F8
                VCAL    5                      ; 13D3 1 108 13D 15
                ST      A, er2                 ; 13D4 1 108 13D 8A
                L       A, off(0014eh)         ; 13D5 1 108 13D E44E
                VCAL    5                      ; 13D7 1 108 13D 15
                AND     IE, #00080h            ; 13D8 1 108 13D B51AD08000
                RB      PSWH.0                 ; 13DD 1 108 13D A208
                ST      A, off(00146h)         ; 13DF 1 108 13D D446
                L       A, X1                  ; 13E1 1 108 13D 40
                ST      A, off(00144h)         ; 13E2 1 108 13D D444
                SB      PSWH.0                 ; 13E4 1 108 13D A218
                L       A, 0cch                ; 13E6 1 108 13D E5CC
                ST      A, IE                  ; 13E8 1 108 13D D51A
                L       A, X1                  ; 13EA 1 108 13D 40
                ADD     A, er2                 ; 13EB 1 108 13D 0A
                JGE     label_13f1             ; 13EC 1 108 13D CD03
                L       A, #0ffffh             ; 13EE 1 108 13D 67FFFF
                                               ; 13F1 from 13EC (DD1,108,13D)
label_13f1:     MOV     er0, off(00148h)       ; 13F1 1 108 13D B44848
                ST      A, off(00148h)         ; 13F4 1 108 13D D448
                CLRB    r5                     ; 13F6 1 108 13D 2515
                CMPB    0a3h, #044h            ; 13F8 1 108 13D C5A3C044
                JGE     label_1441             ; 13FC 1 108 13D CD43
                CMPB    0a6h, #0feh            ; 13FE 1 108 13D C5A6C0FE
                JLT     label_1407             ; 1402 1 108 13D CA03
                JBS     off(00122h).6, label_1441 ; 1404 1 108 13D EE223A
                                               ; 1407 from 1402 (DD1,108,13D)
label_1407:     CMPB    0a6h, #037h            ; 1407 1 108 13D C5A6C037
                JGE     label_1415             ; 140B 1 108 13D CD08
                SUB     A, er0                 ; 140D 1 108 13D 28
                JLT     label_1415             ; 140E 1 108 13D CA05
                CMP     A, #00080h             ; 1410 1 108 13D C68000
                JGE     label_142b             ; 1413 1 108 13D CD16
                                               ; 1415 from 140B (DD1,108,13D)
                                               ; 1415 from 140E (DD1,108,13D)
label_1415:     CLR     A                      ; 1415 1 108 13D F9
                CMPB    0a3h, #02eh            ; 1416 1 108 13D C5A3C02E
                JGE     label_146a             ; 141A 1 108 13D CD4E
                CMPB    0a6h, #0a9h            ; 141C 1 108 13D C5A6C0A9
                JGE     label_146a             ; 1420 1 108 13D CD48
                JBR     off(00122h).6, label_146a ; 1422 1 108 13D DE2245
                MOV     er0, #00100h           ; 1425 1 108 13D 44980001
                SJ      label_1456             ; 1429 1 108 13D CB2B
                                               ; 142B from 1413 (DD1,108,13D)
label_142b:     MOV     er0, #006d6h           ; 142B 1 108 13D 4498D606
                CMP     A, er0                 ; 142F 1 108 13D 48
                JGE     label_1433             ; 1430 1 108 13D CD01
                ST      A, er0                 ; 1432 1 108 13D 88
                                               ; 1433 from 1430 (DD1,108,13D)
label_1433:     CMPB    0eeh, #077h            ; 1433 1 108 13D C5EEC077
                L       A, #000b0h             ; 1437 1 108 13D 67B000
                JLT     label_145a             ; 143A 1 108 13D CA1E
                L       A, #00080h             ; 143C 1 108 13D 678000
                SJ      label_145a             ; 143F 1 108 13D CB19
                                               ; 1441 from 13FC (DD1,108,13D)
                                               ; 1441 from 1404 (DD1,108,13D)
label_1441:     INCB    r5                     ; 1441 1 108 13D AD
                MOV     X1, #0385ah            ; 1442 1 108 13D 605A38
                LB      A, 0a3h                ; 1445 0 108 13D F5A3
                VCAL    0                      ; 1447 0 108 13D 10
                STB     A, r0                  ; 1448 0 108 13D 88
                CLRB    r1                     ; 1449 0 108 13D 2115
                SLL     er0                    ; 144B 0 108 13D 44D7
                L       A, off(0016ah)         ; 144D 1 108 13D E46A
                MUL                            ; 144F 1 108 13D 9035
                LB      A, r2                  ; 1451 0 108 13D 7A
                L       A, ACC                 ; 1452 1 108 13D E506
                SWAP                           ; 1454 1 108 13D 83
                ST      A, er0                 ; 1455 1 108 13D 88
                                               ; 1456 from 1429 (DD1,108,13D)
label_1456:     L       A, off(0014ah)         ; 1456 1 108 13D E44A
                JEQ     label_146a             ; 1458 1 108 13D C910
                                               ; 145A from 143A (DD1,108,13D)
                                               ; 145A from 143F (DD1,108,13D)
label_145a:     MUL                            ; 145A 1 108 13D 9035
                LB      A, r3                  ; 145C 0 108 13D 7B
                JNE     label_1467             ; 145D 0 108 13D CE08
                LB      A, r2                  ; 145F 0 108 13D 7A
                L       A, ACC                 ; 1460 1 108 13D E506
                SWAP                           ; 1462 1 108 13D 83
                ADD     A, off(0014ch)         ; 1463 1 108 13D 874C
                JGE     label_146a             ; 1465 1 108 13D CD03
                                               ; 1467 from 145D (DD0,108,13D)
label_1467:     L       A, #0ffffh             ; 1467 1 108 13D 67FFFF
                                               ; 146A from 141A (DD1,108,13D)
                                               ; 146A from 1420 (DD1,108,13D)
                                               ; 146A from 1422 (DD1,108,13D)
                                               ; 146A from 1458 (DD1,108,13D)
                                               ; 146A from 1465 (DD1,108,13D)
label_146a:     ST      A, er3                 ; 146A 1 108 13D 8B
                JBS     off(0010dh).0, label_146f ; 146B 1 108 13D E80D01
                CLR     A                      ; 146E 1 108 13D F9
                                               ; 146F from 146B (DD1,108,13D)
label_146f:     CLRB    r5                     ; 146F 1 108 13D 2515
                JBS     off(00118h).7, label_1481 ; 1471 1 108 13D EF180D
                CMPB    0a3h, #029h            ; 1474 1 108 13D C5A3C029
                JGE     label_1481             ; 1478 1 108 13D CD07
                JBR     off(00124h).2, label_1481 ; 147A 1 108 13D DA2404
                JBS     off(00123h).3, label_1481 ; 147D 1 108 13D EB2301
                INCB    r5                     ; 1480 1 108 13D AD
                                               ; 1481 from 1471 (DD1,108,13D)
                                               ; 1481 from 1478 (DD1,108,13D)
                                               ; 1481 from 147A (DD1,108,13D)
                                               ; 1481 from 147D (DD1,108,13D)
label_1481:     AND     IE, #00080h            ; 1481 1 108 13D B51AD08000
                RB      PSWH.0                 ; 1486 1 108 13D A208
                ST      A, 0d0h                ; 1488 1 108 13D D5D0
                ST      A, 0d2h                ; 148A 1 108 13D D5D2
                L       A, er3                 ; 148C 1 108 13D 37
                JBR     off(00123h).1, label_1496 ; 148D 1 108 13D D92306
                L       A, off(00148h)         ; 1490 1 108 13D E448
                JBR     off(0010dh).0, label_1496 ; 1492 1 108 13D D80D01
                CLR     A                      ; 1495 1 108 13D F9
                                               ; 1496 from 148D (DD1,108,13D)
                                               ; 1496 from 1492 (DD1,108,13D)
label_1496:     ST      A, 0d4h                ; 1496 1 108 13D D5D4
                                               ; 1498 from 1381 (DD1,108,13D)
label_1498:     SB      PSWH.0                 ; 1498 1 108 13D A218
                L       A, 0cch                ; 149A 1 108 13D E5CC
                ST      A, IE                  ; 149C 1 108 13D D51A
                MOV     DP, #001f0h            ; 149E 1 108 13D 62F001
                CLRB    r2                     ; 14A1 1 108 13D 2215
                L       A, 0d6h                ; 14A3 1 108 13D E5D6
                SUB     A, off(0014eh)         ; 14A5 1 108 13D A74E
                JLT     label_14e9             ; 14A7 1 108 13D CA40
                CMPB    0ach, off(001ach)      ; 14A9 1 108 13D C5ACC3AC
                JGE     label_14d0             ; 14AD 1 108 13D CD21
                INC     DP                     ; 14AF 1 108 13D 72
                CMPB    0a3h, #057h            ; 14B0 1 108 13D C5A3C057
                MB      r2.7, C                ; 14B4 1 108 13D 223F
                JLT     label_14bf             ; 14B6 1 108 13D CA07
                CMPB    0a3h, #057h            ; 14B8 1 108 13D C5A3C057
                JLT     label_14f5             ; 14BC 1 108 13D CA37
                INC     DP                     ; 14BE 1 108 13D 72
                                               ; 14BF from 14B6 (DD1,108,13D)
label_14bf:     J       label_323a             ; 14BF 1 108 13D 033A32
                DB  000h ; 14C2
                                               ; 14C3 from 3244 (DD1,108,13D)
label_14c3:     LB      A, [DP]                ; 14C3 0 108 13D F2
                JNE     label_14f5             ; 14C4 0 108 13D CE2F
                JBR     off(0010ah).7, label_14cd ; 14C6 0 108 13D DF0A04
                                               ; 14C9 from 14DD (DD1,108,13D)
                                               ; 14C9 from 324A (DD1,108,13D)
label_14c9:     LB      A, off(001eeh)         ; 14C9 0 108 13D F4EE
                JNE     label_14f5             ; 14CB 0 108 13D CE28
                                               ; 14CD from 14C6 (DD0,108,13D)
label_14cd:     INCB    r2                     ; 14CD 0 108 13D AA
                SJ      label_14f5             ; 14CE 0 108 13D CB25
                                               ; 14D0 from 14AD (DD1,108,13D)
label_14d0:     CMPB    [DP], #000h            ; 14D0 1 108 13D C2C000
                JNE     label_14f5             ; 14D3 1 108 13D CE20
                CMPB    0ach, off(001adh)      ; 14D5 1 108 13D C5ACC3AD
                JGE     label_14e1             ; 14D9 1 108 13D CD06
                CMP     A, off(00182h)         ; 14DB 1 108 13D C782
                JLT     label_14c9             ; 14DD 1 108 13D CAEA
                SJ      label_14e6             ; 14DF 1 108 13D CB05
                                               ; 14E1 from 14D9 (DD1,108,13D)
label_14e1:     CMP     A, #0036bh             ; 14E1 1 108 13D C66B03
                JLT     label_14e9             ; 14E4 1 108 13D CA03
                                               ; 14E6 from 14DF (DD1,108,13D)
label_14e6:     J       label_2fc6             ; 14E6 1 108 13D 03C62F
                                               ; 14E9 from 14A7 (DD1,108,13D)
                                               ; 14E9 from 14E4 (DD1,108,13D)
                                               ; 14E9 from 3247 (DD1,108,13D)
label_14e9:     MOVB    off(001f0h), #000h     ; 14E9 1 108 13D C4F09800
                MOVB    off(001f1h), #055h     ; 14ED 1 108 13D C4F19855
                MOVB    off(001f2h), #000h     ; 14F1 1 108 13D C4F29800
                                               ; 14F5 from 14BC (DD1,108,13D)
                                               ; 14F5 from 14D3 (DD1,108,13D)
                                               ; 14F5 from 14CB (DD0,108,13D)
                                               ; 14F5 from 14CE (DD0,108,13D)
                                               ; 14F5 from 14C4 (DD0,108,13D)
                                               ; 14F5 from 2FC8 (DD1,108,13D)
label_14f5:     SJ      label_14fc             ; 14F5 1 108 13D CB05
                DB  000h,000h,000h,0A2h,008h ; 14F7
                                               ; 14FC from 14F5 (DD1,108,13D)
label_14fc:     MB      C, r2.0                ; 14FC 1 108 13D 2228
                MB      off(0012bh).0, C       ; 14FE 1 108 13D C42B38
                MB      C, r2.1                ; 1501 1 108 13D 2229
                MB      off(0012bh).1, C       ; 1503 1 108 13D C42B39
                SJ      label_150c             ; 1506 1 108 13D CB04
                DB  0E5h,0CCh,0D5h,01Ah ; 1508
                                               ; 150C from 1506 (DD1,108,13D)
label_150c:     SB      0feh.5                 ; 150C 1 108 13D C5FE1D
                                               ; 150F from 0985 (DD1,108,13D)
label_150f:     SB      0feh.4                 ; 150F 1 108 13D C5FE1C
                AND     IE, #00080h            ; 1512 1 108 13D B51AD08000
                RB      PSWH.0                 ; 1517 1 108 13D A208
                RB      off(00119h).0          ; 1519 1 108 13D C41908
                J       label_03cf             ; 151C 1 108 13D 03CF03
                                               ; 151F from 0008 (DD0,???,???)
int_INT0:       L       A, IE                  ; 151F 1 ??? ??? E51A
                PUSHS   A                      ; 1521 1 ??? ??? 55
                L       A, 0ceh                ; 1522 1 ??? ??? E5CE
                ST      A, IE                  ; 1524 1 ??? ??? D51A
                SB      PSWH.0                 ; 1526 1 ??? ??? A218
                MOV     LRB, #00020h           ; 1528 1 100 ??? 572000
                SB      0feh.0                 ; 152B 1 100 ??? C5FE18
                L       A, TM1                 ; 152E 1 100 ??? E534
                XCHG    A, 0c8h                ; 1530 1 100 ??? B5C810
                ST      A, 0c6h                ; 1533 1 100 ??? D5C6
                LB      A, 0e2h                ; 1535 0 100 ??? F5E2
                STB     A, 0cah                ; 1537 0 100 ??? D5CA
                CLRB    0e2h                   ; 1539 0 100 ??? C5E215
                RB      IRQ.6                  ; 153C 0 100 ??? C5180E
                JEQ     label_1557             ; 153F 0 100 ??? C916
                MB      C, off(0011eh).6       ; 1541 0 100 ??? C41E2E
                MB      off(0011eh).7, C       ; 1544 0 100 ??? C41E3F
                SB      off(0011eh).6          ; 1547 0 100 ??? C41E1E
                MB      C, 0c9h.7              ; 154A 0 100 ??? C5C92F
                JGE     label_1554             ; 154D 0 100 ??? CD05
                INCB    0e2h                   ; 154F 0 100 ??? C5E216
                SJ      label_1557             ; 1552 0 100 ??? CB03
                                               ; 1554 from 154D (DD0,100,???)
label_1554:     INCB    0cah                   ; 1554 0 100 ??? C5CA16
                                               ; 1557 from 153F (DD0,100,???)
                                               ; 1557 from 1552 (DD0,100,???)
label_1557:     RB      PSWH.0                 ; 1557 0 100 ??? A208
                POPS    A                      ; 1559 1 100 ??? 65
                ST      A, IE                  ; 155A 1 100 ??? D51A
                RTI                            ; 155C 1 100 ??? 02
                                               ; 155D from 000E (DD0,???,???)
int_serial_rx_BRG: SB      0feh.1                 ; 155D 0 ??? ??? C5FE19
                L       A, ADCR7               ; 1560 1 ??? ??? E56E
                ST      A, 0aah                ; 1562 1 ??? ??? D5AA
                RTI                            ; 1564 1 ??? ??? 02
                                               ; 1565 from 0010 (DD0,???,???)
int_timer_0_overflow: MOV     LRB, #00040h           ; 1565 0 200 ??? 574000
                L       A, off(00214h)         ; 1568 1 200 ??? E414
                JNE     label_159e             ; 156A 1 200 ??? CE32
                L       A, off(00216h)         ; 156C 1 200 ??? E416
                JEQ     label_15d3             ; 156E 1 200 ??? C963
                LB      A, off(0021bh)         ; 1570 0 200 ??? F41B
                MB      C, ACC.7               ; 1572 0 200 ??? C5062F
                ROLB    A                      ; 1575 0 200 ??? 33
                ORB     off(0021ch), A         ; 1576 0 200 ??? C41CE1
                MB      C, ACC.7               ; 1579 0 200 ??? C5062F
                ROLB    A                      ; 157C 0 200 ??? 33
                STB     A, off(0021bh)         ; 157D 0 200 ??? D41B
                ORB     A, off(0021ch)         ; 157F 0 200 ??? E71C
                ANDB    A, #00fh               ; 1581 0 200 ??? D60F
                STB     A, off(0021ch)         ; 1583 0 200 ??? D41C
                CAL     label_28ed             ; 1585 0 200 ??? 32ED28
                ORB     P2, off(0021ch)        ; 1588 0 200 ??? C524E31C
                L       A, off(00216h)         ; 158C 1 200 ??? E416
                ST      A, TM0                 ; 158E 1 200 ??? D530
                CAL     label_2906             ; 1590 1 200 ??? 320629
                MOV     off(00214h), off(00218h) ; 1593 1 200 ??? B4187C14
                L       A, #0ffffh             ; 1597 1 200 ??? 67FFFF
                ST      A, off(00216h)         ; 159A 1 200 ??? D416
                SJ      label_15c4             ; 159C 1 200 ??? CB26
                                               ; 159E from 156A (DD1,200,???)
label_159e:     LB      A, off(0021bh)         ; 159E 0 200 ??? F41B
                MB      C, ACC.7               ; 15A0 0 200 ??? C5062F
                ROLB    A                      ; 15A3 0 200 ??? 33
                STB     A, off(0021bh)         ; 15A4 0 200 ??? D41B
                ANDB    A, #00fh               ; 15A6 0 200 ??? D60F
                ORB     off(0021ch), A         ; 15A8 0 200 ??? C41CE1
                CAL     label_28ed             ; 15AB 0 200 ??? 32ED28
                ORB     P2, off(0021ch)        ; 15AE 0 200 ??? C524E31C
                L       A, off(00214h)         ; 15B2 1 200 ??? E414
                ST      A, TM0                 ; 15B4 1 200 ??? D530
                CAL     label_2906             ; 15B6 1 200 ??? 320629
                MOV     off(00214h), off(00216h) ; 15B9 1 200 ??? B4167C14
                MOV     off(00216h), off(00218h) ; 15BD 1 200 ??? B4187C16
                L       A, #0ffffh             ; 15C1 1 200 ??? 67FFFF
                                               ; 15C4 from 159C (DD1,200,???)
                                               ; 15C4 from 15FD (DD1,200,???)
label_15c4:     ST      A, off(00218h)         ; 15C4 1 200 ??? D418
                CMPB    off(0021ch), #00fh     ; 15C6 1 200 ??? C41CC00F
                JNE     label_15d2             ; 15CA 1 200 ??? CE06
                RB      TCON0.4                ; 15CC 1 200 ??? C5400C
                RB      IRQ.4                  ; 15CF 1 200 ??? C5180C
                                               ; 15D2 from 15CA (DD1,200,???)
label_15d2:     RTI                            ; 15D2 1 200 ??? 02
                                               ; 15D3 from 156E (DD1,200,???)
label_15d3:     L       A, off(00218h)         ; 15D3 1 200 ??? E418
                JEQ     label_15ff             ; 15D5 1 200 ??? C928
                LB      A, off(0021bh)         ; 15D7 0 200 ??? F41B
                XORB    A, #0ffh               ; 15D9 0 200 ??? F6FF
                ANDB    A, #00fh               ; 15DB 0 200 ??? D60F
                ORB     off(0021ch), A         ; 15DD 0 200 ??? C41CE1
                LB      A, off(0021bh)         ; 15E0 0 200 ??? F41B
                MB      C, ACC.0               ; 15E2 0 200 ??? C50628
                RORB    A                      ; 15E5 0 200 ??? 43
                STB     A, off(0021bh)         ; 15E6 0 200 ??? D41B
                CAL     label_28ed             ; 15E8 0 200 ??? 32ED28
                ORB     P2, off(0021ch)        ; 15EB 0 200 ??? C524E31C
                L       A, off(00218h)         ; 15EF 1 200 ??? E418
                ST      A, TM0                 ; 15F1 1 200 ??? D530
                                               ; 15F3 from 160A (DD1,200,???)
label_15f3:     CAL     label_2906             ; 15F3 1 200 ??? 320629
                L       A, #0ffffh             ; 15F6 1 200 ??? 67FFFF
                ST      A, off(00214h)         ; 15F9 1 200 ??? D414
                ST      A, off(00216h)         ; 15FB 1 200 ??? D416
                SJ      label_15c4             ; 15FD 1 200 ??? CBC5
                                               ; 15FF from 15D5 (DD1,200,???)
label_15ff:     MOVB    off(0021ch), #00fh     ; 15FF 1 200 ??? C41C980F
                CAL     label_28ed             ; 1603 1 200 ??? 32ED28
                ORB     P2, #00fh              ; 1606 1 200 ??? C524E00F
                SJ      label_15f3             ; 160A 1 200 ??? CBE7
                                               ; 160C from 0014 (DD0,???,???)
int_timer_1_overflow: AND     IE, #00080h            ; 160C 0 ??? ??? B51AD08000
                SB      PSWH.0                 ; 1611 0 ??? ??? A218
                MOV     LRB, #00020h           ; 1613 0 100 ??? 572000
                MB      C, off(0011eh).6       ; 1616 0 100 ??? C41E2E
                MB      off(0011eh).7, C       ; 1619 0 100 ??? C41E3F
                SB      off(0011eh).6          ; 161C 0 100 ??? C41E1E
                L       A, 0ceh                ; 161F 1 100 ??? E5CE
                ST      A, IE                  ; 1621 1 100 ??? D51A
                RB      0fdh.5                 ; 1623 1 100 ??? C5FD0D
                JEQ     label_162c             ; 1626 1 100 ??? C904
                ANDB    off(0011eh), #03fh     ; 1628 1 100 ??? C41ED03F
                                               ; 162C from 1626 (DD1,100,???)
label_162c:     INCB    0e2h                   ; 162C 1 100 ??? C5E216
                L       A, 0cch                ; 162F 1 100 ??? E5CC
                RB      PSWH.0                 ; 1631 1 100 ??? A208
                ST      A, IE                  ; 1633 1 100 ??? D51A
                RTI                            ; 1635 1 100 ??? 02
                                               ; 1636 from 0022 (DD0,???,???)
int_PWM_timer:  L       A, 0ceh                ; 1636 1 ??? ??? E5CE
                ST      A, IE                  ; 1638 1 ??? ??? D51A
                SB      PSWH.0                 ; 163A 1 ??? ??? A218
                MOV     LRB, #00040h           ; 163C 1 200 ??? 574000
                JBR     off(0021dh).0, label_1661 ; 163F 1 200 ??? D81D1F
                RB      off(0021dh).0          ; 1642 1 200 ??? C41D08
                MOV     PWMR1, #0fd58h         ; 1645 1 200 ??? B5769858FD
                L       A, ADCR4               ; 164A 1 200 ??? E568
                ST      A, 0a8h                ; 164C 1 200 ??? D5A8
                L       A, off(00202h)         ; 164E 1 200 ??? E402
                ST      A, off(00204h)         ; 1650 1 200 ??? D404
                JBS     off(00203h).4, label_1658 ; 1652 1 200 ??? EC0303
                L       A, #0e001h             ; 1655 1 200 ??? 6701E0
                                               ; 1658 from 1652 (DD1,200,???)
                                               ; 1658 from 166B (DD1,200,???)
                                               ; 1658 from 1671 (DD1,200,???)
label_1658:     ST      A, PWMR0               ; 1658 1 200 ??? D572
                L       A, 0cch                ; 165A 1 200 ??? E5CC
                RB      PSWH.0                 ; 165C 1 200 ??? A208
                ST      A, IE                  ; 165E 1 200 ??? D51A
                RTI                            ; 1660 1 200 ??? 02
                                               ; 1661 from 163F (DD1,200,???)
label_1661:     SB      off(0021dh).0          ; 1661 1 200 ??? C41D18
                MOV     PWMR1, #0ffffh         ; 1664 1 200 ??? B57698FFFF
                L       A, off(00204h)         ; 1669 1 200 ??? E404
                JBR     off(00205h).4, label_1658 ; 166B 1 200 ??? DC05EA
                L       A, #0ffffh             ; 166E 1 200 ??? 67FFFF
                SJ      label_1658             ; 1671 1 200 ??? CBE5
                                               ; 1673 from 0000 (DD0,???,???)
int_start:      MOV     PSW, #00010h           ; 1673 0 ??? ??? B504981000
                                               ; 1678 from 169D (DD0,???,???)
label_1678:     MOVB    WDT, #03ch             ; 1678 0 ??? ??? C511983C
				;logging change
                MOV     SSP, #0025bh           ; 167C 0 ??? ??? A0986402
                MOV     LRB, #00010h           ; 1680 0 080 ??? 571000
                CLR     er1                    ; 1683 0 080 ??? 4515
                JBR     off(PSW).4, label_169f ; 1685 0 080 ??? DC0417
                                               ; 1688 from 16A3 (DD0,080,???)
label_1688:     MOV     DP, #04000h            ; 1688 0 080 ??? 620040
                MOVB    A, [DP]                ; 168B 0 080 ??? C299
                ANDB    A, #080h               ; 168D 0 080 ??? D680
                STB     A, r0                  ; 168F 0 080 ??? 88
                MOVB    r1, #020h              ; 1690 0 080 ??? 9920
                MOVB    r2, #014h              ; 1692 0 080 ??? 9A14
                SJ      label_16b6             ; 1694 0 080 ??? CB20
                                               ; 1696 from 0004 (DD0,???,???)
int_WDT:        MOVB    0edh, #044h            ; 1696 0 ??? ??? C5ED9844
                                               ; 169A from 0002 (DD0,???,???)
                                               ; 169A from 000C (DD0,???,???)
                                               ; 169A from 0018 (DD0,???,???)
                                               ; 169A from 001C (DD0,???,???)
                                               ; 169A from 001E (DD0,???,???)
                                               ; 169A from 0020 (DD0,???,???)
                                               ; 169A from 0024 (DD0,???,???)
int_break:      CLR     PSW                    ; 169A 0 ??? ??? B50415
                SJ      label_1678             ; 169D 0 ??? ??? CBD9
                                               ; 169F from 1685 (DD0,080,???)
label_169f:     CMPB    0edh, #047h            ; 169F 0 080 ??? C5EDC047
                JEQ     label_1688             ; 16A3 0 080 ??? C9E3
                SB      0fdh.6                 ; 16A5 0 080 ??? C5FD1E
                MOVB    r0, off(000fdh)        ; 16A8 0 080 ??? C4FD48
                MOVB    r1, off(000e9h)        ; 16AB 0 080 ??? C4E949
                MOVB    r3, off(000edh)        ; 16AE 0 080 ??? C4ED4B
                JBS     off(000edh).3, label_16b6 ; 16B1 0 080 ??? EBED02
                SB      PSWL.4                 ; 16B4 0 080 ??? A31C
                                               ; 16B6 from 1694 (DD0,080,???)
                                               ; 16B6 from 16B1 (DD0,080,???)
label_16b6:     JBR     off(P4).1, label_16bc  ; 16B6 0 080 ??? D92C03
                J       int_NMI                ; 16B9 0 080 ??? 038F00
                                               ; 16BC from 16B6 (DD0,080,???)
label_16bc:     CLRB    PRPHF                  ; 16BC 0 080 ??? C51215
                MOVB    P0, #09fh              ; 16BF 0 080 ??? C520989F
                LB      A, #0ffh               ; 16C3 0 080 ??? 77FF
                STB     A, P0IO                ; 16C5 0 080 ??? D521
                MOVB    P1, #0ffh              ; 16C7 0 080 ??? C52298FF
                STB     A, P1IO                ; 16CB 0 080 ??? D523
                MOVB    P2, #01fh              ; 16CD 0 080 ??? C524981F
                STB     A, P2IO                ; 16D1 0 080 ??? D525
                MOVB    P2SF, #000h            ; 16D3 0 080 ??? C5269800
                STB     A, P3                  ; 16D7 0 080 ??? D528

				;logging changes
                MOVB    STTMC, #002h           ; 16D9 0 080 ??? C54A9802
                MOVB    STCON, #03ch           ; 16DD 0 080 ??? C5509831
                MOVB    SRCON, #02ch           ; 16E1 0 080 ??? C5549821
                MOVB    STTM, #0f3h            ; 16E5 0 080 ??? C54898FC
                MOVB    STTMR, #0f3h           ; 16E9 0 080 ??? C54998FC
                MOVB    SRTMC, #0c0h           ; 16ED 0 080 ??? C54E98C0


                LB      A, #064h               ; 16F1 0 080 ??? 7764
                STB     A, SRTM                ; 16F3 0 080 ??? D54C
                STB     A, SRTMR               ; 16F5 0 080 ??? D54D
                CLRB    EXION                  ; 16F7 0 080 ??? C51C15
                CLR     A                      ; 16FA 1 080 ??? F9
                MOVB    TCON0, #08ch           ; 16FB 1 080 ??? C540988C
                MOV     TM0, #00001h           ; 16FF 1 080 ??? B530980100
                ST      A, TMR0                ; 1704 1 080 ??? D532
                MOVB    TCON1, #08eh           ; 1706 1 080 ??? C541988E
                ST      A, TM1                 ; 170A 1 080 ??? D534
                ST      A, TMR1                ; 170C 1 080 ??? D536
                MOVB    TCON2, #08fh           ; 170E 1 080 ??? C542988F
                MOV     TM2, #00001h           ; 1712 1 080 ??? B538980100
                ST      A, TMR2                ; 1717 1 080 ??? D53A
                MOVB    TCON3, #08fh           ; 1719 1 080 ??? C543988F
                MOVB    P3IO, #041h            ; 171D 1 080 ??? C5299841
                MOVB    P3SF, #06fh            ; 1721 1 080 ??? C52A986F
                MOVB    P4, #0ffh              ; 1725 1 080 ??? C52C98FF
                L       A, #0ff00h             ; 1729 1 080 ??? 6700FF
                MOVB    PWCON0, #02eh          ; 172C 1 080 ??? C578982E
                ST      A, PWMC0               ; 1730 1 080 ??? D570
                ST      A, PWMR0               ; 1732 1 080 ??? D572
                MOVB    PWCON1, #06eh          ; 1734 1 080 ??? C57A986E
                ST      A, PWMC1               ; 1738 1 080 ??? D574
                ST      A, PWMR1               ; 173A 1 080 ??? D576
                MOVB    P4IO, #00dh            ; 173C 1 080 ??? C52D980D
                MOVB    P4SF, #0bch            ; 1740 1 080 ??? C52E98BC
                SB      TCON1.4                ; 1744 1 080 ??? C5411C
                MOV     er3, (0ffffh-0ffffh)[USP] ; 1747 1 080 ??? B3004B
                SB      TCON2.4                ; 174A 1 080 ??? C5421C
                CLR     IRQ                    ; 174D 1 080 ??? B51815
                LB      A, #002h               ; 1750 0 080 ??? 7702
                MOV     DP, #00078h            ; 1752 0 080 ??? 627800
                                               ; 1755 from 1777 (DD0,080,00F)
label_1755:     SB      [DP].4                 ; 1755 0 080 ??? C21C
                MOV     USP, #00160h           ; 1757 0 080 160 A1986001
                                               ; 175B from 1762 (DD0,080,15F)
label_175b:     DEC     USP                    ; 175B 0 080 15F A117
                JEQ     label_177e             ; 175D 0 080 15F C91F
                MBR     C, off(P4)             ; 175F 0 080 15F C42C21
                JLT     label_175b             ; 1762 0 080 15F CAF7
                MOV     USP, #00010h           ; 1764 0 080 010 A1981000
                                               ; 1768 from 176F (DD0,080,00F)
label_1768:     DEC     USP                    ; 1768 0 080 00F A117
                JEQ     label_177e             ; 176A 0 080 00F C912
                MBR     C, off(P4)             ; 176C 0 080 00F C42C21
                JGE     label_1768             ; 176F 0 080 00F CDF7
                INC     DP                     ; 1771 0 080 00F 72
                INC     DP                     ; 1772 0 080 00F 72
                ADDB    A, #001h               ; 1773 0 080 00F 8601
                CMPB    A, #004h               ; 1775 0 080 00F C604
                JNE     label_1755             ; 1777 0 080 00F CEDC
                RB      IRQH.5                 ; 1779 0 080 00F C5190D
                JNE     label_1783             ; 177C 0 080 00F CE05
                                               ; 177E from 175D (DD0,080,15F)
                                               ; 177E from 176A (DD0,080,00F)
label_177e:     MOVB    off(000edh), #04ch     ; 177E 0 080 00F C4ED984C
                BRK                            ; 1782 0 080 00F FF
                                               ; 1783 from 177C (DD0,080,00F)
label_1783:     RB      PWCON1.5               ; 1783 0 080 00F C57A0D
                MOV     DP, #00269h            ; 1786 0 080 00F 626902
                JBR     off(PSW).4, label_178f ; 1789 0 080 00F DC0403
                MOV     DP, #0027fh            ; 178C 0 080 00F 627F02
                                               ; 178F from 1789 (DD0,080,00F)
                                               ; 178F from 17A7 (DD0,080,00F)
label_178f:     LB      A, #055h               ; 178F 0 080 00F 7755
                STB     A, [DP]                ; 1791 0 080 00F D2
                CMPB    A, [DP]                ; 1792 0 080 00F C2C2
                JNE     label_179c             ; 1794 0 080 00F CE06
                SLLB    A                      ; 1796 0 080 00F 53
                STB     A, [DP]                ; 1797 0 080 00F D2
                SUBB    A, [DP]                ; 1798 0 080 00F C2A2
                JEQ     label_17a1             ; 179A 0 080 00F C905
                                               ; 179C from 1794 (DD0,080,00F)
label_179c:     MOVB    off(000edh), #042h     ; 179C 0 080 00F C4ED9842
                BRK                            ; 17A0 0 080 00F FF
                                               ; 17A1 from 179A (DD0,080,00F)
label_17a1:     STB     A, [DP]                ; 17A1 0 080 00F D2
                DEC     DP                     ; 17A2 0 080 00F 82
                CMP     DP, #00086h            ; 17A3 0 080 00F 92C08600
                JGE     label_178f             ; 17A7 0 080 00F CDE6
                MOVB    off(000fdh), r0        ; 17A9 0 080 00F 207CFD
                MOVB    off(000e9h), r1        ; 17AC 0 080 00F 217CE9
                LB      A, r2                  ; 17AF 0 080 00F 7A
                MOVB    off(000edh), r3        ; 17B0 0 080 00F 237CED
                SLL     LRB                    ; 17B3 0 080 00F A4D7
                STB     A, off(000e6h)         ; 17B5 0 080 00F D4E6
                CLR     A                      ; 17B7 1 080 00F F9
                ST      A, IE                  ; 17B8 1 080 00F D51A
                CLR     DP                     ; 17BA 1 080 00F 9215
                                               ; 17BC from 17C1 (DD1,080,00F)
label_17bc:     MOVB    r6, #011h              ; 17BC 1 080 00F 9E11
                                               ; 17BE from 17BF (DD1,080,00F)
label_17be:     DECB    r6                     ; 17BE 1 080 00F BE
                JNE     label_17be             ; 17BF 1 080 00F CEFD
                JRNZ    DP, label_17bc         ; 17C1 1 080 00F 30F9
                CLRB    ADSEL                  ; 17C3 1 080 00F C55915
                MOVB    ADSCAN, #010h          ; 17C6 1 080 00F C5589810
                MOVB    0ebh, #001h            ; 17CA 1 080 00F C5EB9801
                RB      IRQH.4                 ; 17CE 1 080 00F C5190C
                                               ; 17D1 from 17D3 (DD1,080,00F)
                                               ; 17D1 from 17DC (DD0,080,00F)
label_17d1:     MB      r0.0, C                ; 17D1 1 080 00F 2038
                JRNZ    DP, label_17d1         ; 17D3 1 080 00F 30FC
                CAL     label_2cba             ; 17D5 1 080 00F 32BA2C
                LB      A, P2                  ; 17D8 0 080 00F F524
                ANDB    A, #0e0h               ; 17DA 0 080 00F D6E0
                JNE     label_17d1             ; 17DC 0 080 00F CEF3
                L       A, ADCR4               ; 17DE 1 080 00F E568
                ST      A, 0a8h                ; 17E0 1 080 00F D5A8
                LB      A, ADCR6H              ; 17E2 0 080 00F F56D
                STB     A, 0a5h                ; 17E4 0 080 00F D5A5
                L       A, ADCR5               ; 17E6 1 080 00F E56A
                ST      A, 0b0h                ; 17E8 1 080 00F D5B0
                LB      A, ACCH                ; 17EA 0 080 00F F507
                STB     A, 0b6h                ; 17EC 0 080 00F D5B6
                MOVB    0b4h, #0a0h            ; 17EE 0 080 00F C5B498A0
                L       A, ADCR7               ; 17F2 1 080 00F E56E
                ST      A, 0aah                ; 17F4 1 080 00F D5AA
                MOVB    0a3h, #03ch            ; 17F6 1 080 00F C5A3983C
                MOVB    0a4h, #057h            ; 17FA 1 080 00F C5A49857
                MOVB    0eeh, #094h            ; 17FE 1 080 00F C5EE9894
                LB      A, #02bh               ; 1802 0 080 00F 772B
                STB     A, 0ach                ; 1804 0 080 00F D5AC
                STB     A, 0aeh                ; 1806 0 080 00F D5AE
                LB      A, #080h               ; 1808 0 080 00F 7780
                STB     A, 0adh                ; 180A 0 080 00F D5AD
                STB     A, 0afh                ; 180C 0 080 00F D5AF
                STB     A, off(0009ch)         ; 180E 0 080 00F D49C
                SB      off(0001eh).7          ; 1810 0 080 00F C41E1F
                L       A, #0ffffh             ; 1813 1 080 00F 67FFFF
                ST      A, 0c4h                ; 1816 1 080 00F D5C4
                SB      off(0001eh).0          ; 1818 1 080 00F C41E18
                MOV     USP, #00219h           ; 181B 1 080 219 A1981902
                ST      A, (00202h-00219h)[USP] ; 181F 1 080 219 D3E9
                PUSHU   A                      ; 1821 1 080 217 76
                PUSHU   A                      ; 1822 1 080 215 76
                PUSHU   A                      ; 1823 1 080 213 76
                MOV     (0021ah-00213h)[USP], #08877h ; 1824 1 080 213 B307987788
                MOVB    (0021ch-00213h)[USP], #00fh ; 1829 1 080 213 C309980F
                MOVB    0eah, #003h            ; 182D 1 080 213 C5EA9803
                LB      A, 098h                ; 1831 0 080 213 F598
                STB     A, 0f7h                ; 1833 0 080 213 D5F7
                CAL     label_2d4f             ; 1835 0 080 213 324F2D
                RB      off(IRQ).7             ; 1838 0 080 213 C4180F
                MOV     DP, #001b8h            ; 183B 0 080 213 62B801
                LB      A, ACC                 ; 183E 0 080 213 F506
                                               ; 1840 from 184A (DD0,080,213)
label_1840:     LCB     A, 039bdh[DP]          ; 1840 0 080 213 92ABBD39
                STB     A, [DP]                ; 1844 0 080 213 D2
                INC     DP                     ; 1845 0 080 213 72
                CMP     DP, #001d7h            ; 1846 0 080 213 92C0D701
                JNE     label_1840             ; 184A 0 080 213 CEF4
                MOV     DP, #0026ah            ; 184C 0 080 213 626A02
                L       A, [DP]                ; 184F 1 080 213 E2
                JEQ     label_1857             ; 1850 1 080 213 C905
                CMP     A, #00a00h             ; 1852 1 080 213 C6000A
                JLE     label_185b             ; 1855 1 080 213 CF04
                                               ; 1857 from 1850 (DD1,080,213)
label_1857:     L       A, #00580h             ; 1857 1 080 213 678005
                ST      A, [DP]                ; 185A 1 080 213 D2
                                               ; 185B from 1855 (DD1,080,213)
label_185b:     MOV     DP, #0026ch            ; 185B 1 080 213 626C02
                                               ; 185E from 1875 (DD1,080,213)
label_185e:     L       A, [DP]                ; 185E 1 080 213 E2
                CMP     A, #0b6e0h             ; 185F 1 080 213 C6E0B6
                JGT     label_1869             ; 1862 1 080 213 C805
                CMP     A, #05720h             ; 1864 1 080 213 C62057
                JGE     label_186d             ; 1867 1 080 213 CD04
                                               ; 1869 from 1862 (DD1,080,213)
label_1869:     MOV     [DP], #08000h          ; 1869 1 080 213 B2980080
                                               ; 186D from 1867 (DD1,080,213)
label_186d:     ADD     DP, #00002h            ; 186D 1 080 213 92800200
                CMP     DP, #00278h            ; 1871 1 080 213 92C07802
                JNE     label_185e             ; 1875 1 080 213 CEE7
                LB      A, [DP]                ; 1877 0 080 213 F2
                CMPB    A, #026h               ; 1878 0 080 213 C626
                JGT     label_1880             ; 187A 0 080 213 C804
                CMPB    A, #004h               ; 187C 0 080 213 C604
                JGE     label_1882             ; 187E 0 080 213 CD02
                                               ; 1880 from 187A (DD0,080,213)
label_1880:     CLRB    [DP]                   ; 1880 0 080 213 C215
                                               ; 1882 from 187E (DD0,080,213)
label_1882:     CLR     A                      ; 1882 1 080 213 F9
                MOV     DP, #00228h            ; 1883 1 080 213 622802
                LC      A, 00038h              ; 1886 1 080 213 909C3800
                ST      A, [DP]                ; 188A 1 080 213 D2
                INC     DP                     ; 188B 1 080 213 72
                INC     DP                     ; 188C 1 080 213 72
                LC      A, 0003ah              ; 188D 1 080 213 909C3A00
                ST      A, [DP]                ; 1891 1 080 213 D2
                MOV     DP, #04000h            ; 1892 1 080 213 620040
                LB      A, [DP]                ; 1895 0 080 213 F2
                STB     A, 0ffh                ; 1896 0 080 213 D5FF
                J       label_1fc5             ; 1898 0 080 213 03C51F
                                               ; 189B from 2079 (DD0,080,213)
                                               ; 189B from 21B3 (DD0,080,213)
                                               ; 189B from 22AD (DD0,080,213)
                                               ; 189B from 2FE1 (DD0,080,0A3)
                                               ; 189B from 23AA (DD0,080,0A3)
vcal_4:         RB      0feh.1                 ; 189B 0 080 213 C5FE09
                JEQ     label_18a2             ; 189E 0 080 213 C902
                SJ      label_18bb             ; 18A0 0 080 213 CB19
                                               ; 18A2 from 189E (DD0,080,213)
label_18a2:     RB      0feh.4                 ; 18A2 0 080 213 C5FE0C
                JEQ     label_18aa             ; 18A5 0 080 213 C903
                J       label_19f6             ; 18A7 0 080 213 03F619
                                               ; 18AA from 18A5 (DD0,080,213)
label_18aa:     RB      0feh.2                 ; 18AA 0 080 213 C5FE0A
                JEQ     label_18b2             ; 18AD 0 080 213 C903
                J       label_1df1             ; 18AF 0 080 213 03F11D
                                               ; 18B2 from 18AD (DD0,080,213)
label_18b2:     RB      0feh.3                 ; 18B2 0 080 213 C5FE0B
                JEQ     label_18ba             ; 18B5 0 080 213 C903
                J       label_1e83             ; 18B7 0 080 213 03831E
                                               ; 18BA from 18B5 (DD0,080,213)
label_18ba:     RT                             ; 18BA 0 080 213 01
                                               ; 18BB from 18A0 (DD0,080,213)
label_18bb:     CAL     label_2f34             ; 18BB 0 080 213 32342F
                MOV     DP, #00009h            ; 18BE 0 080 213 620900
                MOV     USP, #001b1h           ; 18C1 0 080 1B1 A198B101
                CAL     label_2f28             ; 18C5 0 080 1B1 32282F
                CLR     A                      ; 18C8 1 080 1B1 F9
                LB      A, off(000b8h)         ; 18C9 0 080 1B1 F4B8
                JNE     label_18d4             ; 18CB 0 080 1B1 CE07
                SB      0feh.3                 ; 18CD 0 080 1B1 C5FE1B
                LB      A, #0c8h               ; 18D0 0 080 1B1 77C8
                STB     A, off(000b8h)         ; 18D2 0 080 1B1 D4B8
                                               ; 18D4 from 18CB (DD0,080,1B1)
label_18d4:     MOVB    r0, #00ah              ; 18D4 0 080 1B1 980A
                DIVB                           ; 18D6 0 080 1B1 A236
                LB      A, r1                  ; 18D8 0 080 1B1 79
                JNE     label_18de             ; 18D9 0 080 1B1 CE03
                SB      0feh.2                 ; 18DB 0 080 1B1 C5FE1A
                                               ; 18DE from 18D9 (DD0,080,1B1)
label_18de:     JBR     off(000b8h).0, label_18e4 ; 18DE 0 080 1B1 D8B803
                J       label_19d9             ; 18E1 0 080 1B1 03D919
                                               ; 18E4 from 18DE (DD0,080,1B1)
label_18e4:     MOV     DP, #00202h            ; 18E4 0 080 1B1 620202
                L       A, [DP]                ; 18E7 1 080 1B1 E2
                MOV     X1, #03ac6h            ; 18E8 1 080 1B1 60C63A
                CAL     label_2c97             ; 18EB 1 080 1B1 32972C
                MOV     er0, 0a8h              ; 18EE 1 080 1B1 B5A848
                MUL                            ; 18F1 1 080 1B1 9035
                L       A, er1                 ; 18F3 1 080 1B1 35
                MOV     USP, #0021eh           ; 18F4 1 080 21E A1981E02
                ST      A, (0021eh-0021eh)[USP] ; 18F8 1 080 21E D300
                MOV     er0, #06000h           ; 18FA 1 080 21E 44980060
                SUB     A, off(PWMC0)          ; 18FE 1 080 21E A770
                RB      off(P2IO).0            ; 1900 1 080 21E C42508
                MB      off(P2IO).0, C         ; 1903 1 080 21E C42538
                JEQ     label_190b             ; 1906 1 080 21E C903
                XORB    PSWH, #080h            ; 1908 1 080 21E A2F080
                                               ; 190B from 1906 (DD1,080,21E)
label_190b:     JGE     label_1911             ; 190B 1 080 21E CD04
                MOVB    off(000fbh), #00ah     ; 190D 1 080 21E C4FB980A
                                               ; 1911 from 190B (DD1,080,21E)
label_1911:     JBS     off(P2IO).0, label_1923 ; 1911 1 080 21E E8250F
                MUL                            ; 1914 1 080 21E 9035
                L       A, [DP]                ; 1916 1 080 21E E2
                ADD     A, er1                 ; 1917 1 080 21E 09
                MOV     er0, #0fd58h           ; 1918 1 080 21E 449858FD
                JLT     label_1933             ; 191C 1 080 21E CA15
                CMP     A, er0                 ; 191E 1 080 21E 48
                JLT     label_1937             ; 191F 1 080 21E CA16
                SJ      label_1933             ; 1921 1 080 21E CB10
                                               ; 1923 from 1911 (DD1,080,21E)
label_1923:     ST      A, er1                 ; 1923 1 080 21E 89
                CLR     A                      ; 1924 1 080 21E F9
                SUB     A, er1                 ; 1925 1 080 21E 29
                MUL                            ; 1926 1 080 21E 9035
                L       A, [DP]                ; 1928 1 080 21E E2
                SUB     A, er1                 ; 1929 1 080 21E 29
                MOV     er0, #0e002h           ; 192A 1 080 21E 449802E0
                JLT     label_1933             ; 192E 1 080 21E CA03
                CMP     A, er0                 ; 1930 1 080 21E 48
                JGE     label_1937             ; 1931 1 080 21E CD04
                                               ; 1933 from 191C (DD1,080,21E)
                                               ; 1933 from 1921 (DD1,080,21E)
                                               ; 1933 from 192E (DD1,080,21E)
label_1933:     L       A, er0                 ; 1933 1 080 21E 34
                CLRB    off(000fbh)            ; 1934 1 080 21E C4FB15
                                               ; 1937 from 191F (DD1,080,21E)
                                               ; 1937 from 1931 (DD1,080,21E)
label_1937:     SB      ACC.0                  ; 1937 1 080 21E C50618
                ST      A, [DP]                ; 193A 1 080 21E D2
                MOV     DP, #000c4h            ; 193B 1 080 21E 62C400
                JBR     off(TMR0).0, label_194c ; 193E 1 080 21E D8320B
                                               ; 1941 from 1967 (DD1,080,21E)
label_1941:     SB      off(IRQ).3             ; 1941 1 080 21E C4181B
                RB      off(0001eh).0          ; 1944 1 080 21E C41E08
                L       A, #03eb7h             ; 1947 1 080 21E 67B73E
                SJ      label_19bb             ; 194A 1 080 21E CB6F
                                               ; 194C from 193E (DD1,080,21E)
label_194c:     RB      0feh.0                 ; 194C 1 080 21E C5FE08
                JNE     label_1964             ; 194F 1 080 21E CE13
                LB      A, #003h               ; 1951 0 080 21E 7703
                CMPB    A, 0e2h                ; 1953 0 080 21E C5E2C2
                JGT     label_19d1             ; 1956 0 080 21E C879
                STB     A, 0e2h                ; 1958 0 080 21E D5E2
                                               ; 195A from 1964 (DD1,080,21E)
                                               ; 195A from 1991 (DD0,080,21E)
label_195a:     SB      off(0001eh).0          ; 195A 0 080 21E C41E18
                L       A, #0ffffh             ; 195D 1 080 21E 67FFFF
                ST      A, [DP]                ; 1960 1 080 21E D2
                CLRB    A                      ; 1961 0 080 21E FA
                SJ      label_19cf             ; 1962 0 080 21E CB6B
                                               ; 1964 from 194F (DD1,080,21E)
label_1964:     JBS     off(0001fh).4, label_195a ; 1964 1 080 21E EC1FF3
                JBS     off(IRQ).6, label_1941 ; 1967 1 080 21E EE18D7
                AND     IE, #00080h            ; 196A 1 080 21E B51AD08000
                RB      PSWH.0                 ; 196F 1 080 21E A208
                L       A, 0c8h                ; 1971 1 080 21E E5C8
                MOVB    r7, 0cah               ; 1973 1 080 21E C5CA4F
                SUB     A, 0c6h                ; 1976 1 080 21E B5C6A2
                ST      A, er0                 ; 1979 1 080 21E 88
                SB      PSWH.0                 ; 197A 1 080 21E A218
                L       A, 0cch                ; 197C 1 080 21E E5CC
                ST      A, IE                  ; 197E 1 080 21E D51A
                L       A, er0                 ; 1980 1 080 21E 34
                JGE     label_1984             ; 1981 1 080 21E CD01
                DECB    r7                     ; 1983 1 080 21E BF
                                               ; 1984 from 1981 (DD1,080,21E)
label_1984:     JBR     off(P0IO).2, label_198c ; 1984 1 080 21E DA2105
                SLL     A                      ; 1987 1 080 21E 53
                ROLB    r7                     ; 1988 1 080 21E 27B7
                SJ      label_198f             ; 198A 1 080 21E CB03
                                               ; 198C from 1984 (DD1,080,21E)
label_198c:     SRLB    r7                     ; 198C 1 080 21E 27E7
                ROR     A                      ; 198E 1 080 21E 43
                                               ; 198F from 198A (DD1,080,21E)
label_198f:     ST      A, er0                 ; 198F 1 080 21E 88
                LB      A, r7                  ; 1990 0 080 21E 7F
                JNE     label_195a             ; 1991 0 080 21E CEC7
                RB      off(0001eh).0          ; 1993 0 080 21E C41E08
                JNE     label_19d1             ; 1996 0 080 21E CE39
                RB      off(IRQ).3             ; 1998 0 080 21E C4180B
                JNE     label_19d1             ; 199B 0 080 21E CE34
                L       A, er0                 ; 199D 1 080 21E 34
                CMP     A, #002c2h             ; 199E 1 080 21E C6C202
                MB      off(IRQ).3, C          ; 19A1 1 080 21E C4183B
                JLT     label_19d1             ; 19A4 1 080 21E CA2B
                CMP     A, #03000h             ; 19A6 1 080 21E C60030
                JGE     label_19bb             ; 19A9 1 080 21E CD10
                CMP     A, #00499h             ; 19AB 1 080 21E C69904
                MOV     er0, #04000h           ; 19AE 1 080 21E 44980040
                JGE     label_19b8             ; 19B2 1 080 21E CD04
                MOV     er0, #01000h           ; 19B4 1 080 21E 44980010
                                               ; 19B8 from 19B2 (DD1,080,21E)
label_19b8:     CAL     label_2d89             ; 19B8 1 080 21E 32892D
                                               ; 19BB from 194A (DD1,080,21E)
                                               ; 19BB from 19A9 (DD1,080,21E)
label_19bb:     ST      A, [DP]                ; 19BB 1 080 21E D2
                ST      A, er2                 ; 19BC 1 080 21E 8A
                MOV     er0, #00004h           ; 19BD 1 080 21E 44980400
                L       A, #04fc8h             ; 19C1 1 080 21E 67C84F
                DIV                            ; 19C4 1 080 21E 9037
                ST      A, er1                 ; 19C6 1 080 21E 89
                LB      A, r3                  ; 19C7 0 080 21E 7B
                ORB     A, r0                  ; 19C8 0 080 21E 68
                ORB     A, r1                  ; 19C9 0 080 21E 69
                JEQ     label_19ce             ; 19CA 0 080 21E C902
                MOVB    r2, #0ffh              ; 19CC 0 080 21E 9AFF
                                               ; 19CE from 19CA (DD0,080,21E)
label_19ce:     LB      A, r2                  ; 19CE 0 080 21E 7A
                                               ; 19CF from 1962 (DD0,080,21E)
label_19cf:     STB     A, 0cbh                ; 19CF 0 080 21E D5CB
                                               ; 19D1 from 1956 (DD0,080,21E)
                                               ; 19D1 from 1996 (DD0,080,21E)
                                               ; 19D1 from 199B (DD0,080,21E)
                                               ; 19D1 from 19A4 (DD1,080,21E)
label_19d1:     MOV     DP, #04000h            ; 19D1 0 080 21E 620040
                LB      A, P0                  ; 19D4 0 080 21E F520
                J       label_19ec             ; 19D6 0 080 21E 03EC19
                                               ; 19D9 from 18E1 (DD0,080,1B1)
label_19d9:     L       A, 0aah                ; 19D9 1 080 1B1 E5AA
                MOV     DP, #000aeh            ; 19DB 1 080 1B1 62AE00
                CAL     label_2cfe             ; 19DE 1 080 1B1 32FE2C
                MB      off(0001fh).3, C       ; 19E1 1 080 1B1 C41F3B
                CAL     label_2cba             ; 19E4 1 080 1B1 32BA2C
                MOV     DP, #08000h            ; 19E7 1 080 1B1 620080
                LB      A, P1                  ; 19EA 0 080 1B1 F522
                                               ; 19EC from 19D6 (DD0,080,21E)
label_19ec:     CAL     label_2f80             ; 19EC 0 080 1B1 32802F
                MOVB    0ffh, A                ; 19EF 0 080 1B1 C5FF8A
                MOV     LRB, #00020h           ; 19F2 0 100 1B1 572000
                RT                             ; 19F5 0 100 1B1 01
                                               ; 19F6 from 18A7 (DD0,080,213)
label_19f6:     MB      C, off(P2IO).3         ; 19F6 0 080 213 C4252B
                MB      off(P2IO).4, C         ; 19F9 0 080 213 C4253C
                LB      A, off(000f7h)         ; 19FC 0 080 213 F4F7
                MOVB    r7, #015h              ; 19FE 0 080 213 9F15
                JEQ     label_1a04             ; 1A00 0 080 213 C902
                MOVB    r7, #015h              ; 1A02 0 080 213 9F15
                                               ; 1A04 from 1A00 (DD0,080,213)
label_1a04:     LB      A, off(00097h)         ; 1A04 0 080 213 F497
                JGE     label_1a09             ; 1A06 0 080 213 CD01
                ADDB    A, r7                  ; 1A08 0 080 213 0F
                                               ; 1A09 from 1A06 (DD0,080,213)
label_1a09:     CMPB    0a6h, A                ; 1A09 0 080 213 C5A6C1
                MB      off(P2IO).3, C         ; 1A0C 0 080 213 C4253B
                JGE     label_1a1a             ; 1A0F 0 080 213 CD09
                RC                             ; 1A11 0 080 213 95
                LB      A, off(000e9h)         ; 1A12 0 080 213 F4E9
                JNE     label_1a1a             ; 1A14 0 080 213 CE04
                JBS     off(P2IO).4, label_1a1a ; 1A16 0 080 213 EC2501
                SC                             ; 1A19 0 080 213 85
                                               ; 1A1A from 1A0F (DD0,080,213)
                                               ; 1A1A from 1A14 (DD0,080,213)
                                               ; 1A1A from 1A16 (DD0,080,213)
label_1a1a:     MB      off(P2SF).6, C         ; 1A1A 0 080 213 C4263E
                LB      A, #0d7h               ; 1A1D 0 080 213 77D7
                JBR     off(P2SF).4, label_1a24 ; 1A1F 0 080 213 DC2602
                LB      A, #0d4h               ; 1A22 0 080 213 77D4
                                               ; 1A24 from 1A1F (DD0,080,213)
label_1a24:     CMPB    A, 0a6h                ; 1A24 0 080 213 C5A6C2
                MB      off(P2SF).4, C         ; 1A27 0 080 213 C4263C
                MOV     X1, #03991h            ; 1A2A 0 080 213 609139
                LB      A, 0a7h                ; 1A2D 0 080 213 F5A7
                JBS     off(P3IO).7, label_1a38 ; 1A2F 0 080 213 EF2906
                ADD     X1, #00015h            ; 1A32 0 080 213 90801500
                LB      A, 0a6h                ; 1A36 0 080 213 F5A6
                                               ; 1A38 from 1A2F (DD0,080,213)
label_1a38:     VCAL    1                      ; 1A38 0 080 213 11
                STB     A, off(PWCON0)         ; 1A39 0 080 213 D478
                MOV     DP, #0018ah            ; 1A3B 0 080 213 628A01
                MOV     X1, #039bbh            ; 1A3E 0 080 213 60BB39
                LB      A, 0a5h                ; 1A41 0 080 213 F5A5
                VCAL    1                      ; 1A43 0 080 213 11
                MOV     er0, #00800h           ; 1A44 0 080 213 44980008
                MOV     X1, #00260h            ; 1A48 0 080 213 606002
                MOV     X2, #00240h            ; 1A4B 0 080 213 614002
                L       A, er3                 ; 1A4E 1 080 213 37
                SUB     A, off(0008ah)         ; 1A4F 1 080 213 A78A
                ST      A, er2                 ; 1A51 1 080 213 8A
                JGE     label_1a58             ; 1A52 1 080 213 CD04
                CLR     A                      ; 1A54 1 080 213 F9
                SUB     A, er2                 ; 1A55 1 080 213 2A
                MOV     X1, X2                 ; 1A56 1 080 213 9178
                                               ; 1A58 from 1A52 (DD1,080,213)
label_1a58:     CMP     A, X1                  ; 1A58 1 080 213 90C2
                L       A, er3                 ; 1A5A 1 080 213 37
                JLT     label_1a6a             ; 1A5B 1 080 213 CA0D
                MB      C, 0ffh.6              ; 1A5D 1 080 213 C5FF2E
                JLT     label_1a65             ; 1A60 1 080 213 CA03
                JBR     off(P3SF).3, label_1a67 ; 1A62 1 080 213 DB2A02
                                               ; 1A65 from 1A60 (DD1,080,213)
label_1a65:     CLR     er2                    ; 1A65 1 080 213 4615
                                               ; 1A67 from 1A62 (DD1,080,213)
label_1a67:     ST      A, [DP]                ; 1A67 1 080 213 D2
                SJ      label_1a6f             ; 1A68 1 080 213 CB05
                                               ; 1A6A from 1A5B (DD1,080,213)
label_1a6a:     CAL     label_2d89             ; 1A6A 1 080 213 32892D
                CLR     er2                    ; 1A6D 1 080 213 4615
                                               ; 1A6F from 1A68 (DD1,080,213)
label_1a6f:     MOV     off(0008ch), er2       ; 1A6F 1 080 213 467C8C
                RB      off(00027h).2          ; 1A72 1 080 213 C4270A
                MB      C, 0ffh.4              ; 1A75 1 080 213 C5FF2C
                JGE     label_1a8f             ; 1A78 1 080 213 CD15
                SB      off(00027h).1          ; 1A7A 1 080 213 C42719
                RB      off(00027h).0          ; 1A7D 1 080 213 C42708
                JEQ     label_1a89             ; 1A80 1 080 213 C907
                SB      off(00027h).2          ; 1A82 1 080 213 C4271A
                MOVB    off(000fah), #000h     ; 1A85 1 080 213 C4FA9800
                                               ; 1A89 from 1A80 (DD1,080,213)
label_1a89:     MOVB    off(000d5h), #000h     ; 1A89 1 080 213 C4D59800
                SJ      label_1aaa             ; 1A8D 1 080 213 CB1B
                                               ; 1A8F from 1A78 (DD1,080,213)
label_1a8f:     JBR     off(00027h).1, label_1aaa ; 1A8F 1 080 213 D92718
                LB      A, off(000fah)         ; 1A92 0 080 213 F4FA
                JNE     label_1aaa             ; 1A94 0 080 213 CE14
                SB      off(00027h).0          ; 1A96 0 080 213 C42718
                MOV     X1, #039cdh            ; 1A99 0 080 213 60CD39
                LB      A, 0a3h                ; 1A9C 0 080 213 F5A3
                VCAL    3                      ; 1A9E 0 080 213 13
                CMPB    off(000d5h), #000h     ; 1A9F 0 080 213 C4D5C000
                JNE     label_1aab             ; 1AA3 0 080 213 CE06
                SUBB    A, #000h               ; 1AA5 0 080 213 A600
                NOP                            ; 1AA7 0 080 213 00
                JGE     label_1aab             ; 1AA8 0 080 213 CD01
                                               ; 1AAA from 1A8D (DD1,080,213)
                                               ; 1AAA from 1A8F (DD1,080,213)
                                               ; 1AAA from 1A94 (DD0,080,213)
label_1aaa:     CLR     A                      ; 1AAA 1 080 213 F9
                                               ; 1AAB from 1AA3 (DD0,080,213)
                                               ; 1AAB from 1AA8 (DD0,080,213)
label_1aab:     ST      A, off(00086h)         ; 1AAB 1 080 213 D486
                MOV     X1, #03a32h            ; 1AAD 1 080 213 60323A
                LB      A, 0a6h                ; 1AB0 0 080 213 F5A6
                VCAL    1                      ; 1AB2 0 080 213 11
                MOV     USP, A                 ; 1AB3 0 080 213 A18A
                LB      A, 0adh                ; 1AB5 0 080 213 F5AD
                MB      C, ACC.7               ; 1AB7 0 080 213 C5062F
                MB      PSWL.5, C              ; 1ABA 0 080 213 A33D
                JBS     off(P2).2, label_1ac3  ; 1ABC 0 080 213 EA2404
                                               ; 1ABF from 1AC3 (DD0,080,213)
label_1abf:     CLR     er3                    ; 1ABF 0 080 213 4715
                SJ      label_1ad2             ; 1AC1 0 080 213 CB0F
                                               ; 1AC3 from 1ABC (DD0,080,213)
label_1ac3:     JBR     off(P1IO).3, label_1abf ; 1AC3 0 080 213 DB23F9
                MOV     X1, #03a47h            ; 1AC6 0 080 213 60473A
                MOVB    r0, #080h              ; 1AC9 0 080 213 9880
                CMPB    A, r0                  ; 1ACB 0 080 213 48
                JGE     label_1ad0             ; 1ACC 0 080 213 CD02
                XCHGB   A, r0                  ; 1ACE 0 080 213 2010
                                               ; 1AD0 from 1ACC (DD0,080,213)
label_1ad0:     SUBB    A, r0                  ; 1AD0 0 080 213 28
                VCAL    3                      ; 1AD1 0 080 213 13
                                               ; 1AD2 from 1AC1 (DD0,080,213)
label_1ad2:     L       A, off(00080h)         ; 1AD2 1 080 213 E480
                MB      C, PSWL.5              ; 1AD4 1 080 213 A32D
                JGE     label_1add             ; 1AD6 1 080 213 CD05
                SUB     A, er3                 ; 1AD8 1 080 213 2B
                JGE     label_1ae3             ; 1AD9 1 080 213 CD08
                SJ      label_1afa             ; 1ADB 1 080 213 CB1D
                                               ; 1ADD from 1AD6 (DD1,080,213)
label_1add:     ADD     A, er3                 ; 1ADD 1 080 213 0B
                JLT     label_1aff             ; 1ADE 1 080 213 CA1F
                VCAL    6                      ; 1AE0 1 080 213 16
                JGE     label_1aff             ; 1AE1 1 080 213 CD1C
                                               ; 1AE3 from 1AD9 (DD1,080,213)
label_1ae3:     MOV     X2, #00080h            ; 1AE3 1 080 213 618000
                CMP     A, #00800h             ; 1AE6 1 080 213 C60008
                JGE     label_1af6             ; 1AE9 1 080 213 CD0B
                MOV     X2, #00040h            ; 1AEB 1 080 213 614000
                CMP     A, #00400h             ; 1AEE 1 080 213 C60004
                JGE     label_1af6             ; 1AF1 1 080 213 CD03
                MOV     X2, #0001eh            ; 1AF3 1 080 213 611E00
                                               ; 1AF6 from 1AE9 (DD1,080,213)
                                               ; 1AF6 from 1AF1 (DD1,080,213)
label_1af6:     SUB     A, X2                  ; 1AF6 1 080 213 91A2
                JGE     label_1afb             ; 1AF8 1 080 213 CD01
                                               ; 1AFA from 1ADB (DD1,080,213)
label_1afa:     CLR     A                      ; 1AFA 1 080 213 F9
                                               ; 1AFB from 1AF8 (DD1,080,213)
label_1afb:     CMP     A, USP                 ; 1AFB 1 080 213 A1C2
                JLT     label_1b01             ; 1AFD 1 080 213 CA02
                                               ; 1AFF from 1ADE (DD1,080,213)
                                               ; 1AFF from 1AE1 (DD1,080,213)
label_1aff:     MOV     A, USP                 ; 1AFF 1 080 213 A199
                                               ; 1B01 from 1AFD (DD1,080,213)
label_1b01:     ST      A, off(00080h)         ; 1B01 1 080 213 D480
                JBS     off(0001fh).4, label_1b50 ; 1B03 1 080 213 EC1F4A
                JBR     off(P2SF).1, label_1b0c ; 1B06 1 080 213 D92603
                J       label_1b88             ; 1B09 1 080 213 03881B
                                               ; 1B0C from 1B06 (DD1,080,213)
label_1b0c:     LB      A, off(TM0)            ; 1B0C 0 080 213 F430
                ANDB    A, #054h               ; 1B0E 0 080 213 D654
                JNE     label_1b15             ; 1B10 0 080 213 CE03
                JBR     off(00027h).3, label_1b18 ; 1B12 0 080 213 DB2703
                                               ; 1B15 from 1B10 (DD0,080,213)
                                               ; 1B15 from 1B2A (DD1,080,213)
label_1b15:     J       label_1bb0             ; 1B15 0 080 213 03B01B
                                               ; 1B18 from 1B12 (DD0,080,213)
label_1b18:     JBR     off(P1IO).3, label_1b20 ; 1B18 0 080 213 DB2305
                JBR     off(P2SF).4, label_1b2a ; 1B1B 0 080 213 DC260C
                SJ      label_1b3d             ; 1B1E 0 080 213 CB1D
                                               ; 1B20 from 1B18 (DD0,080,213)
label_1b20:     JBR     off(P2).6, label_1b27  ; 1B20 0 080 213 DE2404
                L       A, off(PWCON0)         ; 1B23 1 080 213 E478
                JNE     label_1b3b             ; 1B25 1 080 213 CE14
                                               ; 1B27 from 1B20 (DD0,080,213)
label_1b27:     JBS     off(P2SF).4, label_1b3d ; 1B27 1 080 213 EC2613
                                               ; 1B2A from 1B1B (DD0,080,213)
label_1b2a:     JBR     off(P2).4, label_1b15  ; 1B2A 1 080 213 DC24E8
                JBR     off(IRQ).7, label_1b38 ; 1B2D 1 080 213 DF1808
                MB      C, 0ffh.5              ; 1B30 1 080 213 C5FF2D
                JLT     label_1b38             ; 1B33 1 080 213 CA03
                JBR     off(P2).6, label_1bb0  ; 1B35 1 080 213 DE2478
                                               ; 1B38 from 1B2D (DD1,080,213)
                                               ; 1B38 from 1B33 (DD1,080,213)
label_1b38:     J       label_1bde             ; 1B38 1 080 213 03DE1B
                                               ; 1B3B from 1B25 (DD1,080,213)
label_1b3b:     SJ      label_1baa             ; 1B3B 1 080 213 CB6D
                                               ; 1B3D from 1B1E (DD0,080,213)
                                               ; 1B3D from 1B27 (DD1,080,213)
label_1b3d:     RB      off(P2SF).2            ; 1B3D 0 080 213 C4260A
                CAL     label_2e80             ; 1B40 0 080 213 32802E
                L       A, off(00080h)         ; 1B43 1 080 213 E480
                JEQ     label_1b4a             ; 1B45 1 080 213 C903
                J       label_1dda             ; 1B47 1 080 213 03DA1D
                                               ; 1B4A from 1B45 (DD1,080,213)
label_1b4a:     L       A, #011ebh             ; 1B4A 1 080 213 67EB11
                J       label_1dee             ; 1B4D 1 080 213 03EE1D
                                               ; 1B50 from 1B03 (DD1,080,213)
label_1b50:     SB      off(P2SF).1            ; 1B50 1 080 213 C42619
                CLRB    A                      ; 1B53 0 080 213 FA
                CMPB    0a3h, #0d0h            ; 1B54 0 080 213 C5A3C0D0
                JGE     label_1b68             ; 1B58 0 080 213 CD0E
                LB      A, #003h               ; 1B5A 0 080 213 7703
                JBR     off(P2).4, label_1b68  ; 1B5C 0 080 213 DC2409
                SLLB    A                      ; 1B5F 0 080 213 53
                CMPB    0a3h, #057h            ; 1B60 0 080 213 C5A3C057
                JGE     label_1b68             ; 1B64 0 080 213 CD02
                LB      A, #009h               ; 1B66 0 080 213 7709
                                               ; 1B68 from 1B58 (DD0,080,213)
                                               ; 1B68 from 1B5C (DD0,080,213)
                                               ; 1B68 from 1B64 (DD0,080,213)
label_1b68:     EXTND                          ; 1B68 1 080 213 F8
                ADD     A, #03a4dh             ; 1B69 1 080 213 864D3A
                MOV     X1, A                  ; 1B6C 1 080 213 50
                LCB     A, [X1]                ; 1B6D 1 080 213 90AA
                MOVB    off(000f7h), A         ; 1B6F 1 080 213 C4F78A
                INC     X1                     ; 1B72 1 080 213 70
                LC      A, [X1]                ; 1B73 1 080 213 90A8
                ST      A, off(0007ch)         ; 1B75 1 080 213 D47C
                MOV     X1, #03a59h            ; 1B77 1 080 213 60593A
                LB      A, 0a3h                ; 1B7A 0 080 213 F5A3
                VCAL    1                      ; 1B7C 0 080 213 11
                MOV     X1, A                  ; 1B7D 0 080 213 50
                CAL     label_2e80             ; 1B7E 0 080 213 32802E
                ; warning: had to flip DD
                ADD     A, X1                  ; 1B81 1 080 213 9082
                VCAL    6                      ; 1B83 1 080 213 16
                ST      A, off(PWCON1)         ; 1B84 1 080 213 D47A
                SJ      label_1bb6             ; 1B86 1 080 213 CB2E
                                               ; 1B88 from 1B09 (DD1,080,213)
label_1b88:     CAL     label_2e80             ; 1B88 1 080 213 32802E
                LB      A, off(000f7h)         ; 1B8B 0 080 213 F4F7
                CMPB    A, #0cdh               ; 1B8D 0 080 213 C6CD
                L       A, off(PWCON1)         ; 1B8F 1 080 213 E47A
                JGE     label_1ba3             ; 1B91 1 080 213 CD10
                SUB     A, off(0007ch)         ; 1B93 1 080 213 A77C
                JLT     label_1b9c             ; 1B95 1 080 213 CA05
                ST      A, off(PWCON1)         ; 1B97 1 080 213 D47A
                CMP     A, er3                 ; 1B99 1 080 213 4B
                JGE     label_1ba3             ; 1B9A 1 080 213 CD07
                                               ; 1B9C from 1B95 (DD1,080,213)
label_1b9c:     RB      off(P2SF).1            ; 1B9C 1 080 213 C42609
                SB      off(P2SF).0            ; 1B9F 1 080 213 C42618
                L       A, er3                 ; 1BA2 1 080 213 37
                                               ; 1BA3 from 1B91 (DD1,080,213)
                                               ; 1BA3 from 1B9A (DD1,080,213)
label_1ba3:     ST      A, er3                 ; 1BA3 1 080 213 8B
                CAL     label_2e9e             ; 1BA4 1 080 213 329E2E
                ADD     A, er3                 ; 1BA7 1 080 213 0B
                SJ      label_1bb6             ; 1BA8 1 080 213 CB0C
                                               ; 1BAA from 1B3B (DD1,080,213)
label_1baa:     CAL     label_2e80             ; 1BAA 1 080 213 32802E
                SC                             ; 1BAD 1 080 213 85
                SJ      label_1bb7             ; 1BAE 1 080 213 CB07
                                               ; 1BB0 from 1B15 (DD0,080,213)
                                               ; 1BB0 from 1B35 (DD1,080,213)
label_1bb0:     RB      off(P2SF).0            ; 1BB0 0 080 213 C42608
                CAL     label_2e80             ; 1BB3 0 080 213 32802E
                                               ; 1BB6 from 1B86 (DD1,080,213)
                                               ; 1BB6 from 1BA8 (DD1,080,213)
label_1bb6:     RC                             ; 1BB6 1 080 213 95
                                               ; 1BB7 from 1BAE (DD1,080,213)
label_1bb7:     ST      A, off(PWMC1)          ; 1BB7 1 080 213 D474
                MB      off(P2SF).3, C         ; 1BB9 1 080 213 C4263B
                RB      off(P2SF).2            ; 1BBC 1 080 213 C4260A
                ANDB    off(P2IO), #09fh       ; 1BBF 1 080 213 C425D09F
                MB      C, 0ffh.5              ; 1BC3 1 080 213 C5FF2D
                MB      off(00027h).5, C       ; 1BC6 1 080 213 C4273D
                MB      C, off(00027h).7       ; 1BC9 1 080 213 C4272F
                MB      off(00027h).6, C       ; 1BCC 1 080 213 C4273E
                MB      C, 0ffh.6              ; 1BCF 1 080 213 C5FF2E
                MB      off(00027h).7, C       ; 1BD2 1 080 213 C4273F
                MB      C, 0ffh.3              ; 1BD5 1 080 213 C5FF2B
                MB      off(00027h).4, C       ; 1BD8 1 080 213 C4273C
                J       label_1d23             ; 1BDB 1 080 213 03231D
                                               ; 1BDE from 1B38 (DD1,080,213)
label_1bde:     MB      C, off(P2IO).5         ; 1BDE 1 080 213 C4252D
                MB      off(P2IO).6, C         ; 1BE1 1 080 213 C4253E
                RC                             ; 1BE4 1 080 213 95
                JBS     off(P1IO).3, label_1beb ; 1BE5 1 080 213 EB2303
                MB      C, off(P2IO).3         ; 1BE8 1 080 213 C4252B
                                               ; 1BEB from 1BE5 (DD1,080,213)
label_1beb:     MB      off(P2IO).5, C         ; 1BEB 1 080 213 C4253D
                RB      off(P2SF).3            ; 1BEE 1 080 213 C4260B
                RB      off(P2IO).7            ; 1BF1 1 080 213 C4250F
                JBS     off(P2SF).0, label_1c31 ; 1BF4 1 080 213 E8263A
                JBR     off(P2SF).2, label_1c31 ; 1BF7 1 080 213 DA2637
                JBS     off(P2IO).3, label_1c09 ; 1BFA 1 080 213 EB250C
                L       A, off(PWMR1)          ; 1BFD 1 080 213 E476
                CAL     label_2e8c             ; 1BFF 1 080 213 328C2E
                ADD     A, #00400h             ; 1C02 1 080 213 860004
                CMP     A, off(00094h)         ; 1C05 1 080 213 C794
                JLT     label_1c31             ; 1C07 1 080 213 CA28
                                               ; 1C09 from 1BFA (DD1,080,213)
label_1c09:     JBR     off(P2IO).5, label_1c17 ; 1C09 1 080 213 DD250B
                JBS     off(P2IO).6, label_1c13 ; 1C0C 1 080 213 EE2504
                MOVB    off(000f8h), #008h     ; 1C0F 1 080 213 C4F89808
                                               ; 1C13 from 1C0C (DD1,080,213)
label_1c13:     LB      A, off(000f8h)         ; 1C13 0 080 213 F4F8
                JNE     label_1c31             ; 1C15 0 080 213 CE1A
                                               ; 1C17 from 1C09 (DD1,080,213)
label_1c17:     JBS     off(P2SF).7, label_1c31 ; 1C17 0 080 213 EF2617
                JBS     off(00027h).2, label_1c31 ; 1C1A 0 080 213 EA2714
                MB      C, off(00027h).7       ; 1C1D 0 080 213 C4272F
                MB      off(00027h).6, C       ; 1C20 0 080 213 C4273E
                MB      C, 0ffh.6              ; 1C23 0 080 213 C5FF2E
                MB      off(00027h).7, C       ; 1C26 0 080 213 C4273F
                JLT     label_1c48             ; 1C29 0 080 213 CA1D
                JBR     off(00027h).6, label_1c48 ; 1C2B 0 080 213 DE271A
                JBR     off(P2).6, label_1c48  ; 1C2E 0 080 213 DE2417
                                               ; 1C31 from 1BF4 (DD1,080,213)
                                               ; 1C31 from 1BF7 (DD1,080,213)
                                               ; 1C31 from 1C07 (DD1,080,213)
                                               ; 1C31 from 1C15 (DD0,080,213)
                                               ; 1C31 from 1C17 (DD0,080,213)
                                               ; 1C31 from 1C1A (DD0,080,213)
label_1c31:     SB      off(P2SF).2            ; 1C31 0 080 213 C4261A
                L       A, off(PWMC1)          ; 1C34 1 080 213 E474
                JBS     off(P2SF).0, label_1c3c ; 1C36 1 080 213 E82603
                CAL     label_2e80             ; 1C39 1 080 213 32802E
                                               ; 1C3C from 1C36 (DD1,080,213)
label_1c3c:     JBS     off(P2).2, label_1c46  ; 1C3C 1 080 213 EA2407
                JBS     off(P2IO).7, label_1c46 ; 1C3F 1 080 213 EF2504
                ADD     A, #00040h             ; 1C42 1 080 213 864000
                VCAL    6                      ; 1C45 1 080 213 16
                                               ; 1C46 from 1C3C (DD1,080,213)
                                               ; 1C46 from 1C3F (DD1,080,213)
label_1c46:     ST      A, off(00094h)         ; 1C46 1 080 213 D494
                                               ; 1C48 from 1C29 (DD0,080,213)
                                               ; 1C48 from 1C2B (DD0,080,213)
                                               ; 1C48 from 1C2E (DD0,080,213)
label_1c48:     RB      off(P2SF).0            ; 1C48 1 080 213 C42608
                MOV     X1, #03a1eh            ; 1C4B 1 080 213 601E3A
                JBR     off(P2IO).5, label_1c7f ; 1C4E 1 080 213 DD252E
                RB      off(00027h).4          ; 1C51 1 080 213 C4270C
                MB      C, 0ffh.3              ; 1C54 1 080 213 C5FF2B
                MB      off(00027h).4, C       ; 1C57 1 080 213 C4273C
                JEQ     label_1c5f             ; 1C5A 1 080 213 C903
                XORB    PSWH, #080h            ; 1C5C 1 080 213 A2F080
                                               ; 1C5F from 1C5A (DD1,080,213)
label_1c5f:     JGE     label_1c65             ; 1C5F 1 080 213 CD04
                MOVB    off(000f9h), #00ah     ; 1C61 1 080 213 C4F9980A
                                               ; 1C65 from 1C5F (DD1,080,213)
label_1c65:     LB      A, off(000f9h)         ; 1C65 0 080 213 F4F9
                JEQ     label_1c88             ; 1C67 0 080 213 C91F
                JBS     off(P2SF).7, label_1c88 ; 1C69 0 080 213 EF261C
                MOV     X1, #03a2ah            ; 1C6C 0 080 213 602A3A
                CMP     0c2h, #00127h          ; 1C6F 0 080 213 B5C2C02701
                JLT     label_1c88             ; 1C74 0 080 213 CA12
                MOV     X1, #03a2eh            ; 1C76 0 080 213 602E3A
                MOV     er0, #00800h           ; 1C79 0 080 213 44980008
                SJ      label_1c8c             ; 1C7D 0 080 213 CB0D
                                               ; 1C7F from 1C4E (DD1,080,213)
label_1c7f:     MOV     X1, #03a22h            ; 1C7F 1 080 213 60223A
                JBS     off(P2IO).2, label_1c88 ; 1C82 1 080 213 EA2503
                MOV     X1, #03a26h            ; 1C85 1 080 213 60263A
                                               ; 1C88 from 1C67 (DD0,080,213)
                                               ; 1C88 from 1C69 (DD0,080,213)
                                               ; 1C88 from 1C74 (DD0,080,213)
                                               ; 1C88 from 1C82 (DD1,080,213)
label_1c88:     MOV     er0, #00100h           ; 1C88 1 080 213 44980001
                                               ; 1C8C from 1C7D (DD0,080,213)
label_1c8c:     L       A, 0c2h                ; 1C8C 1 080 213 E5C2
                CMP     A, er0                 ; 1C8E 1 080 213 48
                JGE     label_1c92             ; 1C8F 1 080 213 CD01
                ST      A, er0                 ; 1C91 1 080 213 88
                                               ; 1C92 from 1C8F (DD1,080,213)
label_1c92:     LC      A, [X1]                ; 1C92 1 080 213 90A8
                MUL                            ; 1C94 1 080 213 9035
                LB      A, off(00096h)         ; 1C96 0 080 213 F496
                JBS     off(P2IO).2, label_1ca5 ; 1C98 0 080 213 EA250A
                ADDB    A, ACCH                ; 1C9B 0 080 213 C50782
                STB     A, r5                  ; 1C9E 0 080 213 8D
                L       A, er1                 ; 1C9F 1 080 213 35
                ADC     A, off(00094h)         ; 1CA0 1 080 213 9794
                VCAL    6                      ; 1CA2 1 080 213 16
                SJ      label_1caf             ; 1CA3 1 080 213 CB0A
                                               ; 1CA5 from 1C98 (DD0,080,213)
label_1ca5:     SUBB    A, ACCH                ; 1CA5 0 080 213 C507A2
                STB     A, r5                  ; 1CA8 0 080 213 8D
                L       A, off(00094h)         ; 1CA9 1 080 213 E494
                SBC     A, er1                 ; 1CAB 1 080 213 39
                JGE     label_1caf             ; 1CAC 1 080 213 CD01
                CLR     A                      ; 1CAE 1 080 213 F9
                                               ; 1CAF from 1CA3 (DD1,080,213)
                                               ; 1CAF from 1CAC (DD1,080,213)
label_1caf:     ST      A, er3                 ; 1CAF 1 080 213 8B
                L       A, off(0008ch)         ; 1CB0 1 080 213 E48C
                VCAL    5                      ; 1CB2 1 080 213 15
                CAL     label_2ebd             ; 1CB3 1 080 213 32BD2E
                ST      A, er3                 ; 1CB6 1 080 213 8B
                J       label_30c0             ; 1CB7 1 080 213 03C030
                DB  000h ; 1CBA
                                               ; 1CBB from 30C6 (DD1,080,213)
label_1cbb:     MUL                            ; 1CBB 1 080 213 9035
                LB      A, r2                  ; 1CBD 0 080 213 7A
                L       A, ACC                 ; 1CBE 1 080 213 E506
                SWAP                           ; 1CC0 1 080 213 83
                ST      A, er1                 ; 1CC1 1 080 213 89
                L       A, er3                 ; 1CC2 1 080 213 37
                JBS     off(P2IO).2, label_1cca ; 1CC3 1 080 213 EA2504
                ADD     A, er1                 ; 1CC6 1 080 213 09
                VCAL    6                      ; 1CC7 1 080 213 16
                SJ      label_1cce             ; 1CC8 1 080 213 CB04
                                               ; 1CCA from 1CC3 (DD1,080,213)
label_1cca:     SUB     A, er1                 ; 1CCA 1 080 213 29
                JGE     label_1cce             ; 1CCB 1 080 213 CD01
                CLR     A                      ; 1CCD 1 080 213 F9
                                               ; 1CCE from 1CC8 (DD1,080,213)
                                               ; 1CCE from 1CCB (DD1,080,213)
label_1cce:     CAL     label_2ebd             ; 1CCE 1 080 213 32BD2E
                JLT     label_1cd9             ; 1CD1 1 080 213 CA06
                MOVB    off(00096h), r5        ; 1CD3 1 080 213 257C96
                                               ; 1CD6 from 30C9 (DD1,080,213)
label_1cd6:     MOV     off(00094h), er3       ; 1CD6 1 080 213 477C94
                                               ; 1CD9 from 1CD1 (DD1,080,213)
label_1cd9:     ST      A, off(PWMC1)          ; 1CD9 1 080 213 D474
                MOV     USP, #0026ah           ; 1CDB 1 080 26A A1986A02
                JBR     off(P2IO).5, label_1d17 ; 1CDF 1 080 26A DD2535
                JBS     off(P2).2, label_1d17  ; 1CE2 1 080 26A EA2432
                JBS     off(P1IO).7, label_1d17 ; 1CE5 1 080 26A EF232F
                JBS     off(00027h).0, label_1d17 ; 1CE8 1 080 26A E8272C
                LB      A, off(000f7h)         ; 1CEB 0 080 26A F4F7
                JNE     label_1d17             ; 1CED 0 080 26A CE28
                L       A, off(00088h)         ; 1CEF 1 080 26A E488
                JNE     label_1d17             ; 1CF1 1 080 26A CE24
                L       A, #08000h             ; 1CF3 1 080 26A 670080
                CAL     label_2eaa             ; 1CF6 1 080 26A 32AA2E
                ADD     A, off(PWMR1)          ; 1CF9 1 080 26A 8776
                ST      A, er3                 ; 1CFB 1 080 26A 8B
                CAL     label_2e98             ; 1CFC 1 080 26A 32982E
                L       A, #00001h             ; 1CFF 1 080 26A 670100
                JBR     off(P2).6, label_1d0b  ; 1D02 1 080 26A DE2406
                JBS     off(P2IO).1, label_1d0b ; 1D05 1 080 26A E92503
                L       A, #00050h             ; 1D08 1 080 26A 675000
                                               ; 1D0B from 1D02 (DD1,080,26A)
                                               ; 1D0B from 1D05 (DD1,080,26A)
label_1d0b:     ST      A, er0                 ; 1D0B 1 080 26A 88
                L       A, off(00094h)         ; 1D0C 1 080 26A E494
                SUB     A, er3                 ; 1D0E 1 080 26A 2B
                JGT     label_1d14             ; 1D0F 1 080 26A C803
                L       A, #00001h             ; 1D11 1 080 26A 670100
                                               ; 1D14 from 1D0F (DD1,080,26A)
label_1d14:     CAL     label_2d69             ; 1D14 1 080 26A 32692D
                                               ; 1D17 from 1CDF (DD1,080,26A)
                                               ; 1D17 from 1CE2 (DD1,080,26A)
                                               ; 1D17 from 1CE5 (DD1,080,26A)
                                               ; 1D17 from 1CE8 (DD1,080,26A)
                                               ; 1D17 from 1CED (DD0,080,26A)
                                               ; 1D17 from 1CF1 (DD1,080,26A)
label_1d17:     L       A, (0026ah-0026ah)[USP] ; 1D17 1 080 26A E300
                MOV     er1, #00a00h           ; 1D19 1 080 26A 4598000A
                CMP     A, er1                 ; 1D1D 1 080 26A 49
                JLE     label_1d23             ; 1D1E 1 080 26A CF03
                L       A, er1                 ; 1D20 1 080 26A 35
                ST      A, (0026ah-0026ah)[USP] ; 1D21 1 080 26A D300
                                               ; 1D23 from 1BDB (DD1,080,213)
                                               ; 1D23 from 1D1E (DD1,080,26A)
label_1d23:     CAL     label_2e80             ; 1D23 1 080 213 32802E
                JBR     off(P2SF).1, label_1d2b ; 1D26 1 080 213 D92602
                L       A, off(PWCON1)         ; 1D29 1 080 213 E47A
                                               ; 1D2B from 1D26 (DD1,080,213)
label_1d2b:     MOV     X2, A                  ; 1D2B 1 080 213 51
                MOV     DP, #03a74h            ; 1D2C 1 080 213 62743A
                MOV     X1, #03a8ch            ; 1D2F 1 080 213 608C3A
                JBR     off(P3SF).3, label_1d3b ; 1D32 1 080 213 DB2A06
                MOV     DP, #03a7eh            ; 1D35 1 080 213 627E3A
                MOV     X1, #03a9bh            ; 1D38 1 080 213 609B3A
                                               ; 1D3B from 1D32 (DD1,080,213)
label_1d3b:     JBS     off(P2SF).7, label_1d6c ; 1D3B 1 080 213 EF262E
                JBR     off(P2SF).6, label_1d7e ; 1D3E 1 080 213 DE263D
                LB      A, 0a3h                ; 1D41 0 080 213 F5A3
                VCAL    1                      ; 1D43 0 080 213 11
                STB     A, r0                  ; 1D44 0 080 213 88
                CLR     A                      ; 1D45 1 080 213 F9
                JBS     off(P2).6, label_1d50  ; 1D46 1 080 213 EE2407
                L       A, #00002h             ; 1D49 1 080 213 670200
                JBS     off(P2).5, label_1d50  ; 1D4C 1 080 213 ED2401
                SLL     A                      ; 1D4F 1 080 213 53
                                               ; 1D50 from 1D46 (DD1,080,213)
                                               ; 1D50 from 1D4C (DD1,080,213)
label_1d50:     ADD     A, DP                  ; 1D50 1 080 213 9282
                ST      A, er1                 ; 1D52 1 080 213 89
                L       A, 0bch                ; 1D53 1 080 213 E5BC
                CMPC    A, [er1]               ; 1D55 1 080 213 45AC
                JLT     label_1d7e             ; 1D57 1 080 213 CA25
                SB      off(P2SF).7            ; 1D59 1 080 213 C4261F
                MUL                            ; 1D5C 1 080 213 9035
                ST      A, er0                 ; 1D5E 1 080 213 88
                LC      A, 00006h[DP]          ; 1D5F 1 080 213 92A90600
                CMP     A, er0                 ; 1D63 1 080 213 48
                JLT     label_1d67             ; 1D64 1 080 213 CA01
                L       A, er0                 ; 1D66 1 080 213 34
                                               ; 1D67 from 1D64 (DD1,080,213)
label_1d67:     ADD     A, X2                  ; 1D67 1 080 213 9182
                VCAL    6                      ; 1D69 1 080 213 16
                SJ      label_1d7a             ; 1D6A 1 080 213 CB0E
                                               ; 1D6C from 1D3B (DD1,080,213)
label_1d6c:     LC      A, 00008h[DP]          ; 1D6C 1 080 213 92A90800
                ST      A, er0                 ; 1D70 1 080 213 88
                L       A, off(0007eh)         ; 1D71 1 080 213 E47E
                SUB     A, er0                 ; 1D73 1 080 213 28
                JLT     label_1d7e             ; 1D74 1 080 213 CA08
                CMP     A, X2                  ; 1D76 1 080 213 91C2
                JLT     label_1d7e             ; 1D78 1 080 213 CA04
                                               ; 1D7A from 1D6A (DD1,080,213)
label_1d7a:     ST      A, off(PWMC1)          ; 1D7A 1 080 213 D474
                SJ      label_1d82             ; 1D7C 1 080 213 CB04
                                               ; 1D7E from 1D3E (DD1,080,213)
                                               ; 1D7E from 1D57 (DD1,080,213)
                                               ; 1D7E from 1D74 (DD1,080,213)
                                               ; 1D7E from 1D78 (DD1,080,213)
label_1d7e:     RB      off(P2SF).7            ; 1D7E 1 080 213 C4260F
                CLR     A                      ; 1D81 1 080 213 F9
                                               ; 1D82 from 1D7C (DD1,080,213)
label_1d82:     ST      A, off(0007eh)         ; 1D82 1 080 213 D47E
                CLR     A                      ; 1D84 1 080 213 F9
                JBR     off(P3SF).1, label_1dc4 ; 1D85 1 080 213 D92A3C
                L       A, #00400h             ; 1D88 1 080 213 670004
                MB      C, 0feh.6              ; 1D8B 1 080 213 C5FE2E
                JLT     label_1dc4             ; 1D8E 1 080 213 CA34
                LB      A, 0a4h                ; 1D90 0 080 213 F5A4
                MOV     X1, #03a12h            ; 1D92 0 080 213 60123A
                VCAL    3                      ; 1D95 0 080 213 13
                JBR     off(P2SF).6, label_1da0 ; 1D96 0 080 213 DE2607
                CMP     0bch, #00028h          ; 1D99 0 080 213 B5BCC02800
                JGE     label_1dc4             ; 1D9E 0 080 213 CD24
                                               ; 1DA0 from 1D96 (DD0,080,213)
label_1da0:     L       A, off(00088h)         ; 1DA0 1 080 213 E488
                JNE     label_1dac             ; 1DA2 1 080 213 CE08
                LB      A, 0a4h                ; 1DA4 0 080 213 F5A4
                MOV     X1, #03a18h            ; 1DA6 0 080 213 60183A
                VCAL    3                      ; 1DA9 0 080 213 13
                SJ      label_1dc4             ; 1DAA 0 080 213 CB18
                                               ; 1DAC from 1DA2 (DD1,080,213)
label_1dac:     CMP     A, er3                 ; 1DAC 1 080 213 4B
                JLT     label_1db9             ; 1DAD 1 080 213 CA0A
                SUB     A, #00010h             ; 1DAF 1 080 213 A61000
                JLT     label_1dc3             ; 1DB2 1 080 213 CA0F
                CMP     A, er3                 ; 1DB4 1 080 213 4B
                JGE     label_1dc4             ; 1DB5 1 080 213 CD0D
                SJ      label_1dc3             ; 1DB7 1 080 213 CB0A
                                               ; 1DB9 from 1DAD (DD1,080,213)
label_1db9:     MOV     X2, #00020h            ; 1DB9 1 080 213 612000
                ADD     A, X2                  ; 1DBC 1 080 213 9182
                JLT     label_1dc3             ; 1DBE 1 080 213 CA03
                CMP     A, er3                 ; 1DC0 1 080 213 4B
                JLT     label_1dc4             ; 1DC1 1 080 213 CA01
                                               ; 1DC3 from 1DB2 (DD1,080,213)
                                               ; 1DC3 from 1DB7 (DD1,080,213)
                                               ; 1DC3 from 1DBE (DD1,080,213)
label_1dc3:     L       A, er3                 ; 1DC3 1 080 213 37
                                               ; 1DC4 from 1D85 (DD1,080,213)
                                               ; 1DC4 from 1D8E (DD1,080,213)
                                               ; 1DC4 from 1D9E (DD0,080,213)
                                               ; 1DC4 from 1DAA (DD0,080,213)
                                               ; 1DC4 from 1DB5 (DD1,080,213)
                                               ; 1DC4 from 1DC1 (DD1,080,213)
label_1dc4:     ST      A, off(00088h)         ; 1DC4 1 080 213 D488
                MOV     er3, off(PWMC1)        ; 1DC6 1 080 213 B4744B
                L       A, off(00080h)         ; 1DC9 1 080 213 E480
                VCAL    5                      ; 1DCB 1 080 213 15
                L       A, off(00086h)         ; 1DCC 1 080 213 E486
                VCAL    5                      ; 1DCE 1 080 213 15
                L       A, off(00088h)         ; 1DCF 1 080 213 E488
                JBR     off(P2SF).3, label_1dda ; 1DD1 1 080 213 DB2606
                CMP     A, off(PWCON0)         ; 1DD4 1 080 213 C778
                JGE     label_1dda             ; 1DD6 1 080 213 CD02
                L       A, off(PWCON0)         ; 1DD8 1 080 213 E478
                                               ; 1DDA from 1B47 (DD1,080,213)
                                               ; 1DDA from 1DD1 (DD1,080,213)
                                               ; 1DDA from 1DD6 (DD1,080,213)
label_1dda:     VCAL    5                      ; 1DDA 1 080 213 15
                MOVB    r1, off(0009dh)        ; 1DDB 1 080 213 C49D49
                MOVB    r0, #000h              ; 1DDE 1 080 213 9800
                MUL                            ; 1DE0 1 080 213 9035
                SLL     A                      ; 1DE2 1 080 213 53
                L       A, er1                 ; 1DE3 1 080 213 35
                ROL     A                      ; 1DE4 1 080 213 33
                VCAL    6                      ; 1DE5 1 080 213 16
                ST      A, off(00092h)         ; 1DE6 1 080 213 D492
                MOV     X1, #03aaah            ; 1DE8 1 080 213 60AA3A
                CAL     label_2c97             ; 1DEB 1 080 213 32972C
                                               ; 1DEE from 1B4D (DD1,080,213)
label_1dee:     ST      A, off(PWMC0)          ; 1DEE 1 080 213 D470
                RT                             ; 1DF0 1 080 213 01
                                               ; 1DF1 from 18AF (DD0,080,213)
label_1df1:     MOV     DP, #0002ch            ; 1DF1 0 080 213 622C00
                MOV     USP, #001d4h           ; 1DF4 0 080 1D4 A198D401
                CAL     label_2f28             ; 1DF8 0 080 1D4 32282F
                LB      A, 0f8h                ; 1DFB 0 080 1D4 F5F8
                ADDB    A, #001h               ; 1DFD 0 080 1D4 8601
                JEQ     label_1e03             ; 1DFF 0 080 1D4 C902
                STB     A, 0f8h                ; 1E01 0 080 1D4 D5F8
                                               ; 1E03 from 1DFF (DD0,080,1D4)
label_1e03:     LB      A, 0fch                ; 1E03 0 080 1D4 F5FC
                JEQ     label_1e1b             ; 1E05 0 080 1D4 C914
                CMPB    off(000e5h), #000h     ; 1E07 0 080 1D4 C4E5C000
                JNE     label_1e6d             ; 1E0B 0 080 1D4 CE60
                MOVB    r2, #010h              ; 1E0D 0 080 1D4 9A10
                CMPB    A, r2                  ; 1E0F 0 080 1D4 4A
                JGE     label_1e14             ; 1E10 0 080 1D4 CD02
                MOVB    r2, #001h              ; 1E12 0 080 1D4 9A01
                                               ; 1E14 from 1E10 (DD0,080,1D4)
label_1e14:     SUBB    A, r2                  ; 1E14 0 080 1D4 2A
                MOV     er1, #01106h           ; 1E15 0 080 1D4 45980611
                JNE     label_1e62             ; 1E19 0 080 1D4 CE47
                                               ; 1E1B from 1E05 (DD0,080,1D4)
label_1e1b:     SC                             ; 1E1B 0 080 1D4 85
                CLR     A                      ; 1E1C 1 080 1D4 F9
                ST      A, er0                 ; 1E1D 1 080 1D4 88
                                               ; 1E1E from 1E44 (DD0,080,1D4)
label_1e1e:     INCB    off(000aah)            ; 1E1E 1 080 1D4 C4AA16
                LB      A, off(000aah)         ; 1E21 0 080 1D4 F4AA
                CMPB    A, #019h               ; 1E23 0 080 1D4 C619
                JLT     label_1e30             ; 1E25 0 080 1D4 CA09
                CLRB    off(000aah)            ; 1E27 0 080 1D4 C4AA15
                LB      A, 0edh                ; 1E2A 0 080 1D4 F5ED
                SJ      label_1e7f             ; 1E2C 0 080 1D4 CB51
                DW  028cbh           ; 1E2E
                                               ; 1E30 from 1E25 (DD0,080,1D4)
label_1e30:     STB     A, r7                  ; 1E30 0 080 1D4 8F
                DECB    r7                     ; 1E31 0 080 1D4 BF
                MOV     DP, #0027dh            ; 1E32 0 080 1D4 627D02
                JBS     off(ACCH).4, label_1e3d ; 1E35 0 080 1D4 EC0705
                DEC     DP                     ; 1E38 0 080 1D4 82
                JBS     off(ACCH).3, label_1e3d ; 1E39 0 080 1D4 EB0701
                DEC     DP                     ; 1E3C 0 080 1D4 82
                                               ; 1E3D from 1E35 (DD0,080,1D4)
                                               ; 1E3D from 1E39 (DD0,080,1D4)
label_1e3d:     XCHGB   A, r7                  ; 1E3D 0 080 1D4 2710
                TRB     [DP]                   ; 1E3F 0 080 1D4 C213
                JNE     label_1e49             ; 1E41 0 080 1D4 CE06
                INCB    r0                     ; 1E43 0 080 1D4 A8
                JBR     off(ASSP).3, label_1e1e ; 1E44 0 080 1D4 DB00D7
                SJ      label_1e82             ; 1E47 0 080 1D4 CB39
                                               ; 1E49 from 1E41 (DD0,080,1D4)
label_1e49:     LB      A, r7                  ; 1E49 0 080 1D4 7F
                CMPB    A, #016h               ; 1E4A 0 080 1D4 C616
                JLE     label_1e52             ; 1E4C 0 080 1D4 CF04
                SUBB    A, #016h               ; 1E4E 0 080 1D4 A616
                SJ      label_1e58             ; 1E50 0 080 1D4 CB06
                                               ; 1E52 from 1E4C (DD0,080,1D4)
label_1e52:     CMPB    A, #002h               ; 1E52 0 080 1D4 C602
                JGT     label_1e58             ; 1E54 0 080 1D4 C802
                ADDB    A, #02ah               ; 1E56 0 080 1D4 862A
                                               ; 1E58 from 1E50 (DD0,080,1D4)
                                               ; 1E58 from 1E54 (DD0,080,1D4)
label_1e58:     MOVB    r0, #00ah              ; 1E58 0 080 1D4 980A
                DIVB                           ; 1E5A 0 080 1D4 A236
                SWAPB                          ; 1E5C 0 080 1D4 83
                ORB     A, r1                  ; 1E5D 0 080 1D4 69
                MOV     er1, #02a1fh           ; 1E5E 0 080 1D4 45981F2A
                                               ; 1E62 from 1E19 (DD0,080,1D4)
label_1e62:     STB     A, 0fch                ; 1E62 0 080 1D4 D5FC
                CMPB    A, #010h               ; 1E64 0 080 1D4 C610
                JLT     label_1e6a             ; 1E66 0 080 1D4 CA02
                MOVB    r2, r3                 ; 1E68 0 080 1D4 234A
                                               ; 1E6A from 1E66 (DD0,080,1D4)
label_1e6a:     MOVB    off(000e5h), r2        ; 1E6A 0 080 1D4 227CE5
                                               ; 1E6D from 1E0B (DD0,080,1D4)
label_1e6d:     CMPB    A, #010h               ; 1E6D 0 080 1D4 C610
                L       A, #00305h             ; 1E6F 1 080 1D4 670503
                JLT     label_1e77             ; 1E72 1 080 1D4 CA03
                L       A, #00411h             ; 1E74 1 080 1D4 671104
                                               ; 1E77 from 1E72 (DD1,080,1D4)
label_1e77:     ST      A, er1                 ; 1E77 1 080 1D4 89
                LB      A, off(000e5h)         ; 1E78 0 080 1D4 F4E5
                CMPB    A, r2                  ; 1E7A 0 080 1D4 4A
                JGE     label_1e7f             ; 1E7B 0 080 1D4 CD02
                CMPB    r3, A                  ; 1E7D 0 080 1D4 23C1
                                               ; 1E7F from 1E2C (DD0,080,1D4)
                                               ; 1E7F from 1E7B (DD0,080,1D4)
label_1e7f:     MB      P0.5, C                ; 1E7F 0 080 1D4 C5203D
                                               ; 1E82 from 1E47 (DD0,080,1D4)
label_1e82:     RT                             ; 1E82 0 080 1D4 01
                                               ; 1E83 from 18B7 (DD0,080,213)
label_1e83:     MOV     DP, #0000dh            ; 1E83 0 080 213 620D00
                MOV     USP, #001c7h           ; 1E86 0 080 1C7 A198C701
                CAL     label_2f28             ; 1E8A 0 080 1C7 32282F
                LB      A, 0f9h                ; 1E8D 0 080 1C7 F5F9
                ADDB    A, #001h               ; 1E8F 0 080 1C7 8601
                JEQ     label_1e95             ; 1E91 0 080 1C7 C902
                STB     A, 0f9h                ; 1E93 0 080 1C7 D5F9
                                               ; 1E95 from 1E91 (DD0,080,1C7)
label_1e95:     LB      A, off(000cch)         ; 1E95 0 080 1C7 F4CC
                JNE     label_1eb2             ; 1E97 0 080 1C7 CE19
                MOVB    off(000cch), #005h     ; 1E99 0 080 1C7 C4CC9805
                CLR     er3                    ; 1E9D 0 080 1C7 4715
                MOV     DP, #000e9h            ; 1E9F 0 080 1C7 62E900
                MOV     X1, #03b94h            ; 1EA2 0 080 1C7 60943B
                CAL     label_2ef5             ; 1EA5 0 080 1C7 32F52E
                MOV     er3, #00115h           ; 1EA8 0 080 1C7 47981501
                MOV     DP, #001beh            ; 1EAC 0 080 1C7 62BE01
                CAL     label_2ef5             ; 1EAF 0 080 1C7 32F52E
                                               ; 1EB2 from 1E97 (DD0,080,1C7)
label_1eb2:     RT                             ; 1EB2 0 080 1C7 01
				;ssp logging change
                DB  0A0h,0C0h,05bh,002h,0CEh,02Bh,062h,026h ; 1EB3
                DB  002h,0F2h,0CEh,025h,067h,0FBh,022h,060h ; 1EBB
                DB  090h,000h,0DAh,021h,006h,067h,05Bh,0A2h ; 1EC3
                DB  060h,010h,000h,0B5h,0CCh,0C2h,0CEh,011h ; 1ECB
                DB  0B5h,01Ah,0C2h,0CEh,00Ch,040h,0B5h,0CEh ; 1ED3
                DB  0C2h,0CEh,006h,0A4h,0C0h,020h,000h,0C9h ; 1EDB
                DB  00Dh,0C5h,0EDh,098h,041h,0C5h,0E9h,017h ; 1EE3
                DB  0CEh,003h,0C5h,0FDh,018h,0FFh,014h,0A1h ; 1EEB
                DB  098h,020h,002h,0B3h,000h,048h,0F9h,077h ; 1EF3
                DB  040h,090h,035h,050h,062h,020h,000h,0C3h ; 1EFB
                DB  002h,048h,090h,0A8h,0C5h,007h,082h,020h ; 1F03
                DB  081h,070h,070h,030h,0F5h,078h,0D3h,002h ; 1F0B
                DB  0B3h,000h,016h,0B3h,000h,0C0h,000h,001h ; 1F13
                DB  0CEh,016h,0B3h,000h,015h,078h,0C9h,010h ; 1F1B
                DB  0C3h,002h,015h,0C5h,0EDh,098h,048h,0C5h ; 1F23
                DB  0EAh,017h,0CEh,004h,0C5h,0FDh,019h,0FFh ; 1F2B
                DB  014h,0F9h,0F5h,0ECh,050h,090h,0D7h,067h ; 1F33
                DB  055h,055h,032h,046h,02Fh,0CEh,010h,053h ; 1F3B
                DB  032h,046h,02Fh,0CEh,00Ah,0F5h,0ECh,0CEh ; 1F43
                DB  002h,077h,0F4h,0A6h,001h,0D5h,0ECh,0B5h ; 1F4B
                DB  01Ah,0D0h,080h,000h,0A2h,008h,0EBh,030h ; 1F53
                DB  04Ah,0EAh,021h,00Bh,0C5h,019h,00Fh,0C9h ; 1F5B
                DB  006h,0C4h,018h,018h,0C4h,02Eh,018h,0A2h ; 1F63
                DB  018h,0C4h,0BAh,0C0h,029h,0A2h,008h,0CAh ; 1F6B
                DB  032h,0DAh,021h,048h,067h,0FBh,022h,0D5h ; 1F73
                DB  01Ah,0D5h,0CCh,0B5h,0CEh,098h,090h,000h ; 1F7B
                DB  0C4h,021h,00Ah,0C5h,041h,098h,08Eh,0B5h ; 1F83
                DB  034h,098h,001h,000h,0C5h,042h,098h,08Fh ; 1F8B
                DB  0B5h,038h,098h,002h,000h,085h,0C5h,041h ; 1F93
                DB  03Ch,0E5h,006h,0C5h,042h,03Ch,032h,06Eh ; 1F9B
                DB  02Fh,0CBh,019h,0EAh,021h,016h,067h,05Bh ; 1FA3
                DB  0A2h,0D5h,01Ah,0D5h,0CCh,0B5h,0CEh,098h ; 1FAB
                DB  010h,000h,0C4h,021h,01Ah,0C5h,041h,098h ; 1FB3
                DB  0BEh,0C5h,042h,00Ah,0A2h,018h,0E5h,0CCh ; 1FBB
                DB  0D5h,01Ah ; 1FC3
                                               ; 1FC5 from 1898 (DD0,080,213)
label_1fc5:     AND     IE, #00080h            ; 1FC5 0 080 213 B51AD08000
                RB      PSWH.0                 ; 1FCA 0 080 213 A208
                MOV     er0, TM0               ; 1FCC 0 080 213 B53048
                MOV     er1, TM1               ; 1FCF 0 080 213 B53449
                MOV     er2, TM2               ; 1FD2 0 080 213 B5384A
                MOV     er3, TM3               ; 1FD5 0 080 213 B53C4B
                SB      PSWH.0                 ; 1FD8 0 080 213 A218
                NOP                            ; 1FDA 0 080 213 00
                RB      PSWH.0                 ; 1FDB 0 080 213 A208
                MOV     X1, TM0                ; 1FDD 0 080 213 B53078
                MOV     X2, TM1                ; 1FE0 0 080 213 B53479
                MOV     DP, TM2                ; 1FE3 0 080 213 B5387A
                MOV     USP, TM3               ; 1FE6 0 080 213 B53C7B
                MB      C, TCON0.4             ; 1FE9 0 080 213 C5402C
                SB      PSWH.0                 ; 1FEC 0 080 213 A218
                L       A, 0cch                ; 1FEE 1 080 213 E5CC
                ST      A, IE                  ; 1FF0 1 080 213 D51A
                MB      PSWL.4, C              ; 1FF2 1 080 213 A33C
                L       A, X1                  ; 1FF4 1 080 213 40
                SUB     A, er0                 ; 1FF5 1 080 213 28
                ST      A, er0                 ; 1FF6 1 080 213 88
                JNE     label_1ffd             ; 1FF7 1 080 213 CE04
                MB      C, PSWL.4              ; 1FF9 1 080 213 A32C
                JLT     label_2059             ; 1FFB 1 080 213 CA5C
                                               ; 1FFD from 1FF7 (DD1,080,213)
label_1ffd:     CMP     A, #00012h             ; 1FFD 1 080 213 C61200
                JGE     label_2059             ; 2000 1 080 213 CD57
                L       A, X2                  ; 2002 1 080 213 41
                SUB     A, er1                 ; 2003 1 080 213 29
                JBS     off(P0IO).2, label_2009 ; 2004 1 080 213 EA2102
                JEQ     label_2059             ; 2007 1 080 213 C950
                                               ; 2009 from 2004 (DD1,080,213)
label_2009:     CMP     A, #00012h             ; 2009 1 080 213 C61200
                JGE     label_2059             ; 200C 1 080 213 CD4B
                L       A, DP                  ; 200E 1 080 213 42
                SUB     A, er2                 ; 200F 1 080 213 2A
                ST      A, er2                 ; 2010 1 080 213 8A
                JEQ     label_2059             ; 2011 1 080 213 C946
                CMP     A, #00012h             ; 2013 1 080 213 C61200
                JGE     label_2059             ; 2016 1 080 213 CD41
                JBS     off(P0IO).2, label_202c ; 2018 1 080 213 EA2111
                L       A, DP                  ; 201B 1 080 213 42
                SUB     A, X2                  ; 201C 1 080 213 91A2
                MB      C, ACCH.7              ; 201E 1 080 213 C5072F
                JGE     label_2027             ; 2021 1 080 213 CD04
                MOV     X1, A                  ; 2023 1 080 213 50
                CLR     A                      ; 2024 1 080 213 F9
                SUB     A, X1                  ; 2025 1 080 213 90A2
                                               ; 2027 from 2021 (DD1,080,213)
label_2027:     CMP     A, #00002h             ; 2027 1 080 213 C60200
                JGE     label_2059             ; 202A 1 080 213 CD2D
                                               ; 202C from 2018 (DD1,080,213)
label_202c:     MB      C, PSWL.4              ; 202C 1 080 213 A32C
                JGE     label_203c             ; 202E 1 080 213 CD0C
                L       A, er2                 ; 2030 1 080 213 36
                SUB     A, er0                 ; 2031 1 080 213 28
                JGE     label_2037             ; 2032 1 080 213 CD03
                ST      A, er0                 ; 2034 1 080 213 88
                CLR     A                      ; 2035 1 080 213 F9
                SUB     A, er0                 ; 2036 1 080 213 28
                                               ; 2037 from 2032 (DD1,080,213)
label_2037:     CMP     A, #00002h             ; 2037 1 080 213 C60200
                JGE     label_2059             ; 203A 1 080 213 CD1D
                                               ; 203C from 202E (DD1,080,213)
label_203c:     LB      A, TCON0               ; 203C 0 080 213 F540
                ANDB    A, #0e3h               ; 203E 0 080 213 D6E3
                CMPB    A, #080h               ; 2040 0 080 213 C680
                JNE     label_2059             ; 2042 0 080 213 CE15
                LB      A, TCON1               ; 2044 0 080 213 F541
                ANDB    A, #0e3h               ; 2046 0 080 213 D6E3
                CMPB    A, #082h               ; 2048 0 080 213 C682
                JBR     off(P0IO).2, label_204f ; 204A 0 080 213 DA2102
                CMPB    A, #0a2h               ; 204D 0 080 213 C6A2
                                               ; 204F from 204A (DD0,080,213)
label_204f:     JNE     label_2059             ; 204F 0 080 213 CE08
                LB      A, TCON2               ; 2051 0 080 213 F542
                ANDB    A, #0e3h               ; 2053 0 080 213 D6E3
                CMPB    A, #083h               ; 2055 0 080 213 C683
                JEQ     label_205f             ; 2057 0 080 213 C906
                                               ; 2059 from 1FFB (DD1,080,213)
                                               ; 2059 from 2000 (DD1,080,213)
                                               ; 2059 from 2007 (DD1,080,213)
                                               ; 2059 from 200C (DD1,080,213)
                                               ; 2059 from 2011 (DD1,080,213)
                                               ; 2059 from 2016 (DD1,080,213)
                                               ; 2059 from 202A (DD1,080,213)
                                               ; 2059 from 203A (DD1,080,213)
                                               ; 2059 from 2042 (DD0,080,213)
                                               ; 2059 from 204F (DD0,080,213)
label_2059:     MOVB    0edh, #04bh            ; 2059 0 080 213 C5ED984B
                SJ      label_2073             ; 205D 0 080 213 CB14
                                               ; 205F from 2057 (DD0,080,213)
label_205f:     LB      A, PWCON0              ; 205F 0 080 213 F578
                ANDB    A, #07bh               ; 2061 0 080 213 D67B
                CMPB    A, #03ah               ; 2063 0 080 213 C63A
                JNE     label_206f             ; 2065 0 080 213 CE08
                LB      A, PWCON1              ; 2067 0 080 213 F57A
                ANDB    A, #07bh               ; 2069 0 080 213 D67B
                CMPB    A, #05ah               ; 206B 0 080 213 C65A
                JEQ     label_2079             ; 206D 0 080 213 C90A
                                               ; 206F from 2065 (DD0,080,213)
label_206f:     MOVB    0edh, #04ch            ; 206F 0 080 213 C5ED984C
                                               ; 2073 from 205D (DD0,080,213)
label_2073:     DECB    0ebh                   ; 2073 0 080 213 C5EB17
                JNE     label_2079             ; 2076 0 080 213 CE01
                BRK                            ; 2078 0 080 213 FF
                                               ; 2079 from 206D (DD0,080,213)
                                               ; 2079 from 2076 (DD0,080,213)
label_2079:     VCAL    4                      ; 2079 0 080 213 14
                JBS     off(TM0).2, label_20a9 ; 207A 0 080 213 EA302C
                JBS     off(TM0).4, label_20a9 ; 207D 0 080 213 EC3029
                MB      C, 0fdh.6              ; 2080 0 080 213 C5FD2E
                JLT     label_20a9             ; 2083 0 080 213 CA24
                CMPB    0a6h, #002h            ; 2085 0 080 213 C5A6C002
                JGE     label_208f             ; 2089 0 080 213 CD04
                MOVB    off(000e8h), #064h     ; 208B 0 080 213 C4E89864
                                               ; 208F from 2089 (DD0,080,213)
label_208f:     JBR     off(0001fh).1, label_20a9 ; 208F 0 080 213 D91F17
                LB      A, 0b6h                ; 2092 0 080 213 F5B6
                SUBB    A, 0b1h                ; 2094 0 080 213 C5B1A2
                JGE     label_209c             ; 2097 0 080 213 CD03
                STB     A, r0                  ; 2099 0 080 213 88
                CLRB    A                      ; 209A 0 080 213 FA
                SUBB    A, r0                  ; 209B 0 080 213 28
                                               ; 209C from 2097 (DD0,080,213)
label_209c:     CMPB    A, #002h               ; 209C 0 080 213 C602
                JLT     label_20a5             ; 209E 0 080 213 CA05
                SB      0fdh.6                 ; 20A0 0 080 213 C5FD1E
                SJ      label_20aa             ; 20A3 0 080 213 CB05
                                               ; 20A5 from 209E (DD0,080,213)
label_20a5:     LB      A, off(000e8h)         ; 20A5 0 080 213 F4E8
                JEQ     label_20aa             ; 20A7 0 080 213 C901
                                               ; 20A9 from 207A (DD0,080,213)
                                               ; 20A9 from 207D (DD0,080,213)
                                               ; 20A9 from 2083 (DD0,080,213)
                                               ; 20A9 from 208F (DD0,080,213)
label_20a9:     RC                             ; 20A9 0 080 213 95
                                               ; 20AA from 20A3 (DD0,080,213)
                                               ; 20AA from 20A7 (DD0,080,213)
label_20aa:     MB      off(P4).3, C           ; 20AA 0 080 213 C42C3B
                CMPB    09ah, #054h            ; 20AD 0 080 213 C59AC054
                MB      off(IRQ).6, C          ; 20B1 0 080 213 C4183E
                CMPB    0a6h, #0b0h            ; 20B4 0 080 213 C5A6C0B0
                JGE     label_20ca             ; 20B8 0 080 213 CD10
                RC                             ; 20BA 0 080 213 95
                JBS     off(IRQ).6, label_20ca ; 20BB 0 080 213 EE180C
                JBS     off(P0IO).3, label_20ca ; 20BE 0 080 213 EB2109
                JBS     off(TMR0).0, label_20ca ; 20C1 0 080 213 E83206
                JBR     off(0001eh).0, label_20ca ; 20C4 0 080 213 D81E03
                MB      C, 0feh.6              ; 20C7 0 080 213 C5FE2E
                                               ; 20CA from 20B8 (DD0,080,213)
                                               ; 20CA from 20BB (DD0,080,213)
                                               ; 20CA from 20BE (DD0,080,213)
                                               ; 20CA from 20C1 (DD0,080,213)
                                               ; 20CA from 20C4 (DD0,080,213)
label_20ca:     MB      off(P4IO).2, C         ; 20CA 0 080 213 C42D3A
                RC                             ; 20CD 0 080 213 95
                JBS     off(TM0).7, label_20d7 ; 20CE 0 080 213 EF3006
                JBR     off(0001eh).5, label_20d7 ; 20D1 0 080 213 DD1E03
                MB      C, off(IRQ).4          ; 20D4 0 080 213 C4182C
                                               ; 20D7 from 20CE (DD0,080,213)
                                               ; 20D7 from 20D1 (DD0,080,213)
label_20d7:     MB      off(P4IO).1, C         ; 20D7 0 080 213 C42D39
                MB      C, P4.6                ; 20DA 0 080 213 C52C2E
                JBS     off(P3IO).6, label_20eb ; 20DD 0 080 213 EE290B
                MOVB    off(000d9h), #014h     ; 20E0 0 080 213 C4D99814
                LB      A, off(000dah)         ; 20E4 0 080 213 F4DA
                JGE     label_20f3             ; 20E6 0 080 213 CD0B
                                               ; 20E8 from 20F1 (DD0,080,213)
                                               ; 20E8 from 20F3 (DD0,080,213)
label_20e8:     RC                             ; 20E8 0 080 213 95
                SJ      label_20f7             ; 20E9 0 080 213 CB0C
                                               ; 20EB from 20DD (DD0,080,213)
label_20eb:     MOVB    off(000dah), #014h     ; 20EB 0 080 213 C4DA9814
                LB      A, off(000d9h)         ; 20EF 0 080 213 F4D9
                JGE     label_20e8             ; 20F1 0 080 213 CDF5
                                               ; 20F3 from 20E6 (DD0,080,213)
label_20f3:     JBS     off(TMR0).4, label_20e8 ; 20F3 0 080 213 EC32F2
                SC                             ; 20F6 0 080 213 85
                                               ; 20F7 from 20E9 (DD0,080,213)
label_20f7:     MB      off(P4).5, C           ; 20F7 0 080 213 C42C3D
                JNE     label_210f             ; 20FA 0 080 213 CE13
                JBS     off(TMR0).4, label_210f ; 20FC 0 080 213 EC3210
                JLT     label_210f             ; 20FF 0 080 213 CA0E
                JBS     off(TMR0).5, label_210f ; 2101 0 080 213 ED320B
                MB      C, 0ffh.2              ; 2104 0 080 213 C5FF2A
                JBR     off(P3IO).6, label_2110 ; 2107 0 080 213 DE2906
                JLT     label_210f             ; 210A 0 080 213 CA03
                SC                             ; 210C 0 080 213 85
                SJ      label_2110             ; 210D 0 080 213 CB01
                                               ; 210F from 20FA (DD0,080,213)
                                               ; 210F from 20FC (DD0,080,213)
                                               ; 210F from 20FF (DD0,080,213)
                                               ; 210F from 2101 (DD0,080,213)
                                               ; 210F from 210A (DD0,080,213)
label_210f:     RC                             ; 210F 0 080 213 95
                                               ; 2110 from 2107 (DD0,080,213)
                                               ; 2110 from 210D (DD0,080,213)
label_2110:     MB      off(P4).6, C           ; 2110 0 080 213 C42C3E
                LB      A, #003h               ; 2113 0 080 213 7703
                CMPCB   A, 036fch              ; 2115 0 080 213 909FFC36
                MOVB    ACC, #094h             ; 2119 0 080 213 C5069894
                RC                             ; 211D 0 080 213 95
                JEQ     label_212e             ; 211E 0 080 213 C90E
                JBS     off(TM0H).4, label_212e ; 2120 0 080 213 EC310B
                LB      A, #0e6h               ; 2123 0 080 213 77E6
                CMPB    A, ADCR1H              ; 2125 0 080 213 C563C2
                JLT     label_212e             ; 2128 0 080 213 CA04
                LB      A, ADCR1H              ; 212A 0 080 213 F563
                CMPB    A, #050h               ; 212C 0 080 213 C650
                                               ; 212E from 211E (DD0,080,213)
                                               ; 212E from 2120 (DD0,080,213)
                                               ; 212E from 2128 (DD0,080,213)
label_212e:     MB      off(P4).4, C           ; 212E 0 080 213 C42C3C
                JLT     label_2143             ; 2131 0 080 213 CA10
                JBR     off(TM0H).4, label_213c ; 2133 0 080 213 DC3106
                MOVB    0eeh, #094h            ; 2136 0 080 213 C5EE9894
                SJ      label_2143             ; 213A 0 080 213 CB07
                                               ; 213C from 2133 (DD0,080,213)
label_213c:     MOV     USP, #000eeh           ; 213C 0 080 0EE A198EE00
                CAL     label_2d3b             ; 2140 0 080 0EE 323B2D
                                               ; 2143 from 2131 (DD0,080,213)
                                               ; 2143 from 213A (DD0,080,213)
label_2143:     MOV     X1, #0374fh            ; 2143 0 080 213 604F37
                LB      A, 0eeh                ; 2146 0 080 213 F5EE
                VCAL    2                      ; 2148 0 080 213 12
                STB     A, off(ADSEL)          ; 2149 0 080 213 D459
                MOV     X1, #03a88h            ; 214B 0 080 213 60883A
                LB      A, 0eeh                ; 214E 0 080 213 F5EE
                VCAL    2                      ; 2150 0 080 213 12
                STB     A, off(0009dh)         ; 2151 0 080 213 D49D
                MOV     X1, #03950h            ; 2153 0 080 213 605039
                LB      A, 0eeh                ; 2156 0 080 213 F5EE
                VCAL    2                      ; 2158 0 080 213 12
                STB     A, off(0009fh)         ; 2159 0 080 213 D49F
                MOV     X1, #03767h            ; 215B 0 080 213 606737
                MOV     X2, #00271h            ; 215E 0 080 213 617102
                LB      A, 0a6h                ; 2161 0 080 213 F5A6
                VCAL    1                      ; 2163 0 080 213 11
                CMPB    0a3h, #015h            ; 2164 0 080 213 C5A3C015
                JGE     label_216f             ; 2168 0 080 213 CD05
                ; warning: had to flip DD
                SUB     A, X2                  ; 216A 1 080 213 91A2
                JGE     label_216f             ; 216C 1 080 213 CD01
                CLR     A                      ; 216E 1 080 213 F9
                                               ; 216F from 2168 (DD0,080,213)
                                               ; 216F from 216C (DD1,080,213)
label_216f:     MOV     USP, A                 ; 216F 1 080 213 A18A
                MOV     X1, #03776h            ; 2171 1 080 213 607637
                MOV     X2, #00271h            ; 2174 1 080 213 617102
                LB      A, 0a6h                ; 2177 0 080 213 F5A6
                VCAL    1                      ; 2179 0 080 213 11
                CMPB    0a3h, #015h            ; 217A 0 080 213 C5A3C015
                JGE     label_2185             ; 217E 0 080 213 CD05
                ; warning: had to flip DD
                SUB     A, X2                  ; 2180 1 080 213 91A2
                JGE     label_2185             ; 2182 1 080 213 CD01
                CLR     A                      ; 2184 1 080 213 F9
                                               ; 2185 from 217E (DD0,080,213)
                                               ; 2185 from 2182 (DD1,080,213)
label_2185:     J       label_2fcb             ; 2185 1 080 213 03CB2F
                DB  000h,0A1h,099h,0D4h,056h,0A2h,018h ; 2188
                                               ; 218F from 2FDE (DD1,080,213)
label_218f:     MOV     X1, #03753h            ; 218F 1 080 213 605337
                LB      A, 0a6h                ; 2192 0 080 213 F5A6
                VCAL    0                      ; 2194 0 080 213 10
                STB     A, r2                  ; 2195 0 080 213 8A
                MOV     X1, #0375dh            ; 2196 0 080 213 605D37
                LB      A, 0a6h                ; 2199 0 080 213 F5A6
                VCAL    0                      ; 219B 0 080 213 10
                STB     A, ACCH                ; 219C 0 080 213 D507
                LB      A, r2                  ; 219E 0 080 213 7A
                MOV     off(000ach), A         ; 219F 0 080 213 B4AC8A
                LB      A, #003h               ; 21A2 0 080 213 7703
                CMPCB   A, 036fch              ; 21A4 0 080 213 909FFC36
                MB      C, PSWH.6              ; 21A8 0 080 213 A22E
                CLRB    A                      ; 21AA 0 080 213 FA
                JGE     label_21b1             ; 21AB 0 080 213 CD04
                LB      A, ADCR1H              ; 21AD 0 080 213 F563
                ADDB    A, #080h               ; 21AF 0 080 213 8680
                                               ; 21B1 from 21AB (DD0,080,213)
label_21b1:     STB     A, off(TM2H)           ; 21B1 0 080 213 D439
                VCAL    4                      ; 21B3 0 080 213 14
                RC                             ; 21B4 0 080 213 95
                JBS     off(TM0H).1, label_21c3 ; 21B5 0 080 213 E9310B
                LB      A, #0fch               ; 21B8 0 080 213 77FC
                CMPB    A, 099h                ; 21BA 0 080 213 C599C2
                JLT     label_21c3             ; 21BD 0 080 213 CA04
                LB      A, 099h                ; 21BF 0 080 213 F599
                CMPB    A, #004h               ; 21C1 0 080 213 C604
                                               ; 21C3 from 21B5 (DD0,080,213)
                                               ; 21C3 from 21BD (DD0,080,213)
label_21c3:     MB      off(P4).7, C           ; 21C3 0 080 213 C42C3F
                JLT     label_21d8             ; 21C6 0 080 213 CA10
                JBR     off(TM0H).1, label_21d1 ; 21C8 0 080 213 D93106
                MOVB    0a4h, #057h            ; 21CB 0 080 213 C5A49857
                SJ      label_21d8             ; 21CF 0 080 213 CB07
                                               ; 21D1 from 21C8 (DD0,080,213)
label_21d1:     MOV     USP, #000a4h           ; 21D1 0 080 0A4 A198A400
                CAL     label_2d39             ; 21D5 0 080 0A4 32392D
                                               ; 21D8 from 21C6 (DD0,080,213)
                                               ; 21D8 from 21CF (DD0,080,213)
label_21d8:     MOV     X1, #03741h            ; 21D8 0 080 213 604137
                LB      A, 0a4h                ; 21DB 0 080 213 F5A4
                VCAL    0                      ; 21DD 0 080 213 10
                STB     A, off(0005ah)         ; 21DE 0 080 213 D45A
                LB      A, #0b3h               ; 21E0 0 080 213 77B3
                JBS     off(IRQH).3, label_21e7 ; 21E2 0 080 213 EB1902
                LB      A, #0b8h               ; 21E5 0 080 213 77B8
                                               ; 21E7 from 21E2 (DD0,080,213)
label_21e7:     CMPB    A, 0b4h                ; 21E7 0 080 213 C5B4C2
                MB      off(IRQH).3, C         ; 21EA 0 080 213 C4193B
                RC                             ; 21ED 0 080 213 95
                LB      A, off(TMR2)           ; 21EE 0 080 213 F43A
                JNE     label_21fb             ; 21F0 0 080 213 CE09
                CMPB    0a4h, #027h            ; 21F2 0 080 213 C5A4C027
                JGE     label_21fb             ; 21F6 0 080 213 CD03
                MB      C, off(IRQH).3         ; 21F8 0 080 213 C4192B
                                               ; 21FB from 21F0 (DD0,080,213)
                                               ; 21FB from 21F6 (DD0,080,213)
label_21fb:     MB      off(IRQH).5, C         ; 21FB 0 080 213 C4193D
                L       A, IE                  ; 21FE 1 080 213 E51A
                JEQ     label_2208             ; 2200 1 080 213 C906
                CMPB    0a6h, #008h            ; 2202 1 080 213 C5A6C008
                JLT     label_2224             ; 2206 1 080 213 CA1C
                                               ; 2208 from 2200 (DD1,080,213)
label_2208:     LB      A, 09fh                ; 2208 0 080 213 F59F
                CMPB    A, #0ffh               ; 220A 0 080 213 C6FF
                JGT     label_221a             ; 220C 0 080 213 C80C
                CMPB    A, #0fch               ; 220E 0 080 213 C6FC
                JGE     label_2224             ; 2210 0 080 213 CD12
                CMPB    A, #088h               ; 2212 0 080 213 C688
                JGT     label_221a             ; 2214 0 080 213 C804
                CMPB    A, #078h               ; 2216 0 080 213 C678
                JGE     label_2224             ; 2218 0 080 213 CD0A
                                               ; 221A from 220C (DD0,080,213)
                                               ; 221A from 2214 (DD0,080,213)
label_221a:     MOVB    0edh, #049h            ; 221A 0 080 213 C5ED9849
                DECB    0ebh                   ; 221E 0 080 213 C5EB17
                JNE     label_2224             ; 2221 0 080 213 CE01
                BRK                            ; 2223 0 080 213 FF
                                               ; 2224 from 2206 (DD1,080,213)
                                               ; 2224 from 2210 (DD0,080,213)
                                               ; 2224 from 2218 (DD0,080,213)
                                               ; 2224 from 2221 (DD0,080,213)
label_2224:     MOV     X1, #03845h            ; 2224 1 080 213 604538
                LB      A, 09ah                ; 2227 0 080 213 F59A
                VCAL    1                      ; 2229 0 080 213 11
                STB     A, off(SRTM)           ; 222A 0 080 213 D44C
                RB      off(IRQ).7             ; 222C 0 080 213 C4180F
                CLR     A                      ; 222F 1 080 213 F9
                LB      A, #0c0h               ; 2230 0 080 213 77C0
                JBR     off(IE).6, label_2237  ; 2232 0 080 213 DE1A02
                LB      A, #0b9h               ; 2235 0 080 213 77B9
                                               ; 2237 from 2232 (DD0,080,213)
label_2237:     CMPB    A, 0b4h                ; 2237 0 080 213 C5B4C2
                CLRB    A                      ; 223A 0 080 213 FA
                MB      off(IE).6, C           ; 223B 0 080 213 C41A3E
                JGE     label_2265             ; 223E 0 080 213 CD25
                LB      A, 09ch                ; 2240 0 080 213 F59C
                SUBB    A, #007h               ; 2242 0 080 213 A607
                JGE     label_2247             ; 2244 0 080 213 CD01
                CLRB    A                      ; 2246 0 080 213 FA
                                               ; 2247 from 2244 (DD0,080,213)
label_2247:     MOVB    r0, #051h              ; 2247 0 080 213 9851
                DIVB                           ; 2249 0 080 213 A236
                CMPB    0a6h, #0e0h            ; 224B 0 080 213 C5A6C0E0
                JGE     label_2261             ; 224F 0 080 213 CD10
                LB      A, r1                  ; 2251 0 080 213 79
                MOVB    r0, #01bh              ; 2252 0 080 213 981B
                DIVB                           ; 2254 0 080 213 A236
                CMPB    0a6h, #0bah            ; 2256 0 080 213 C5A6C0BA
                JGE     label_2261             ; 225A 0 080 213 CD05
                LB      A, r1                  ; 225C 0 080 213 79
                MOVB    r0, #009h              ; 225D 0 080 213 9809
                DIVB                           ; 225F 0 080 213 A236
                                               ; 2261 from 224F (DD0,080,213)
                                               ; 2261 from 225A (DD0,080,213)
label_2261:     MOVB    r0, #0fah              ; 2261 0 080 213 98FA
                MULB                           ; 2263 0 080 213 A234
                                               ; 2265 from 223E (DD0,080,213)
label_2265:     STB     A, off(TM3)            ; 2265 0 080 213 D43C
                CLR     A                      ; 2267 1 080 213 F9
                LB      A, 09bh                ; 2268 0 080 213 F59B
                MOVB    r0, #030h              ; 226A 0 080 213 9830
                DIVB                           ; 226C 0 080 213 A236
                CMPB    0a6h, #0c6h            ; 226E 0 080 213 C5A6C0C6
                JGE     label_2281             ; 2272 0 080 213 CD0D
                SRLB    A                      ; 2274 0 080 213 63
                LB      A, r1                  ; 2275 0 080 213 79
                JGE     label_227b             ; 2276 0 080 213 CD03
                LB      A, #02fh               ; 2278 0 080 213 772F
                SUBB    A, r1                  ; 227A 0 080 213 29
                                               ; 227B from 2276 (DD0,080,213)
label_227b:     MOVB    r0, #009h              ; 227B 0 080 213 9809
                DIVB                           ; 227D 0 080 213 A236
                ADDB    A, #006h               ; 227F 0 080 213 8606
                                               ; 2281 from 2272 (DD0,080,213)
label_2281:     LCB     A, 03839h[ACC]         ; 2281 0 080 213 B506AB3938
                STB     A, off(ADSCAN)         ; 2286 0 080 213 D458
                MOV     er1, #08000h           ; 2288 0 080 213 45980080
                LB      A, 09dh                ; 228C 0 080 213 F59D
                CMPB    A, #003h               ; 228E 0 080 213 C603
                JLE     label_22a7             ; 2290 0 080 213 CF15
                MOVB    r0, #080h              ; 2292 0 080 213 9880
                ADDB    A, r0                  ; 2294 0 080 213 08
                STB     A, r4                  ; 2295 0 080 213 8C
                LCB     A, 036fch              ; 2296 0 080 213 909DFC36
                SRLB    A                      ; 229A 0 080 213 63
                LB      A, r4                  ; 229B 0 080 213 7C
                JGE     label_22a8             ; 229C 0 080 213 CD0A
                LB      A, 09dh                ; 229E 0 080 213 F59D
                MULB                           ; 22A0 0 080 213 A234
                MOV     er1, A                 ; 22A2 0 080 213 458A
                ADDB    r3, #040h              ; 22A4 0 080 213 238040
                                               ; 22A7 from 2290 (DD0,080,213)
label_22a7:     CLRB    A                      ; 22A7 0 080 213 FA
                                               ; 22A8 from 229C (DD0,080,213)
label_22a8:     STB     A, off(00052h)         ; 22A8 0 080 213 D452
                MOV     off(ADCR0), er1        ; 22AA 0 080 213 457C60
                VCAL    4                      ; 22AD 0 080 213 14
                RC                             ; 22AE 0 080 213 95
                JBS     off(TM0).5, label_22b9 ; 22AF 0 080 213 ED3007
                LB      A, 098h                ; 22B2 0 080 213 F598
                CMPB    A, #0fch               ; 22B4 0 080 213 C6FC
                JLE     label_22c2             ; 22B6 0 080 213 CF0A
                SC                             ; 22B8 0 080 213 85
                                               ; 22B9 from 22AF (DD0,080,213)
                                               ; 22B9 from 22C4 (DD0,080,213)
label_22b9:     MB      off(P4).1, C           ; 22B9 0 080 213 C42C39
                MOVB    0a3h, #03ch            ; 22BC 0 080 213 C5A3983C
                SJ      label_22f7             ; 22C0 0 080 213 CB35
                                               ; 22C2 from 22B6 (DD0,080,213)
label_22c2:     CMPB    A, #004h               ; 22C2 0 080 213 C604
                JLT     label_22b9             ; 22C4 0 080 213 CAF3
                RB      off(P4).1              ; 22C6 0 080 213 C42C09
                CMPB    09dh, #003h            ; 22C9 0 080 213 C59DC003
                JLE     label_22e9             ; 22CD 0 080 213 CF1A
                SUBB    A, 0f7h                ; 22CF 0 080 213 C5F7A2
                JGE     label_22d7             ; 22D2 0 080 213 CD03
                STB     A, r0                  ; 22D4 0 080 213 88
                CLRB    A                      ; 22D5 0 080 213 FA
                SUBB    A, r0                  ; 22D6 0 080 213 28
                                               ; 22D7 from 22D2 (DD0,080,213)
label_22d7:     CMPB    A, #002h               ; 22D7 0 080 213 C602
                JGT     label_22f3             ; 22D9 0 080 213 C818
                LB      A, off(000d7h)         ; 22DB 0 080 213 F4D7
                JNE     label_22fb             ; 22DD 0 080 213 CE1C
                LB      A, 098h                ; 22DF 0 080 213 F598
                JBS     off(0001eh).5, label_22e9 ; 22E1 0 080 213 ED1E05
                CMPB    A, 0f6h                ; 22E4 0 080 213 C5F6C2
                JGT     label_22f7             ; 22E7 0 080 213 C80E
                                               ; 22E9 from 22CD (DD0,080,213)
                                               ; 22E9 from 22E1 (DD0,080,213)
label_22e9:     MOV     USP, #000a3h           ; 22E9 0 080 0A3 A198A300
                CAL     label_2d39             ; 22ED 0 080 0A3 32392D
                CAL     label_2d4f             ; 22F0 0 080 0A3 324F2D
                                               ; 22F3 from 22D9 (DD0,080,213)
label_22f3:     LB      A, 098h                ; 22F3 0 080 0A3 F598
                STB     A, 0f7h                ; 22F5 0 080 0A3 D5F7
                                               ; 22F7 from 22C0 (DD0,080,213)
                                               ; 22F7 from 22E7 (DD0,080,213)
label_22f7:     MOVB    off(000d7h), #005h     ; 22F7 0 080 0A3 C4D79805
                                               ; 22FB from 22DD (DD0,080,213)
label_22fb:     CAL     label_308e             ; 22FB 0 080 0A3 328E30
                LB      A, 0a3h                ; 22FE 0 080 0A3 F5A3
                VCAL    2                      ; 2300 0 080 0A3 12
                CMPB    0a3h, #015h            ; 2301 0 080 0A3 C5A3C015
                JGE     label_230f             ; 2305 0 080 0A3 CD08
                JBR     off(0001fh).5, label_230d ; 2307 0 080 0A3 DD1F03
                JBR     off(P3SF).3, label_230f ; 230A 0 080 0A3 DB2A02
                                               ; 230D from 2307 (DD0,080,0A3)
label_230d:     LB      A, #0f8h               ; 230D 0 080 0A3 77F8
                                               ; 230F from 2305 (DD0,080,0A3)
                                               ; 230F from 230A (DD0,080,0A3)
label_230f:     STB     A, off(TMR3H)          ; 230F 0 080 0A3 D43F
                J       label_2fe1             ; 2311 0 080 0A3 03E12F
                                               ; 2314 from 2FE5 (DD0,080,0A3)
label_2314:     LB      A, 0a3h                ; 2314 0 080 0A3 F5A3
                VCAL    1                      ; 2316 0 080 0A3 11
                STB     A, off(PWMR1)          ; 2317 0 080 0A3 D476
                NOP                            ; 2319 0 080 0A3 00
                MOV     X1, #039d3h            ; 231A 0 080 0A3 60D339
                LB      A, 0a3h                ; 231D 0 080 0A3 F5A3
                VCAL    0                      ; 231F 0 080 0A3 10
                STB     A, off(00097h)         ; 2320 0 080 0A3 D497
                MOV     X1, #039dfh            ; 2322 0 080 0A3 60DF39
                MOV     DP, #039f1h            ; 2325 0 080 0A3 62F139
                LB      A, 0a3h                ; 2328 0 080 0A3 F5A3
                VCAL    1                      ; 232A 0 080 0A3 11
                CLR     er3                    ; 232B 0 080 0A3 4715
                JBR     off(P2).7, label_2367  ; 232D 0 080 0A3 DF2437
                LB      A, #004h               ; 2330 0 080 0A3 7704
                JBS     off(P3SF).3, label_2341 ; 2332 0 080 0A3 EB2A0C
                CLRB    A                      ; 2335 0 080 0A3 FA
                MB      C, P3.7                ; 2336 0 080 0A3 C5282F
                JLT     label_2341             ; 2339 0 080 0A3 CA06
                LB      A, #002h               ; 233B 0 080 0A3 7702
                MOV     er3, #000c0h           ; 233D 0 080 0A3 4798C000
                                               ; 2341 from 2332 (DD0,080,0A3)
                                               ; 2341 from 2339 (DD0,080,0A3)
label_2341:     EXTND                          ; 2341 1 080 0A3 F8
                ADD     DP, A                  ; 2342 1 080 0A3 9281
                LC      A, [DP]                ; 2344 1 080 0A3 92A8
                ST      A, er0                 ; 2346 1 080 0A3 88
                CMP     A, off(PWMR0)          ; 2347 1 080 0A3 C772
                JEQ     label_2367             ; 2349 1 080 0A3 C91C
                MOV     er1, #00010h           ; 234B 1 080 0A3 45981000
                SB      off(P2IO).1            ; 234F 1 080 0A3 C42519
                LB      A, off(000ffh)         ; 2352 0 080 0A3 F4FF
                JNE     label_2373             ; 2354 0 080 0A3 CE1D
                L       A, off(PWMR0)          ; 2356 1 080 0A3 E472
                JGE     label_2360             ; 2358 1 080 0A3 CD06
                SUB     A, er1                 ; 235A 1 080 0A3 29
                CMP     A, er0                 ; 235B 1 080 0A3 48
                JGE     label_236a             ; 235C 1 080 0A3 CD0C
                SJ      label_2364             ; 235E 1 080 0A3 CB04
                                               ; 2360 from 2358 (DD1,080,0A3)
label_2360:     ADD     A, er1                 ; 2360 1 080 0A3 09
                CMP     A, er0                 ; 2361 1 080 0A3 48
                JLT     label_236a             ; 2362 1 080 0A3 CA06
                                               ; 2364 from 235E (DD1,080,0A3)
label_2364:     L       A, er0                 ; 2364 1 080 0A3 34
                SJ      label_236a             ; 2365 1 080 0A3 CB03
                                               ; 2367 from 232D (DD0,080,0A3)
                                               ; 2367 from 2349 (DD1,080,0A3)
label_2367:     RB      off(P2IO).1            ; 2367 0 080 0A3 C42509
                                               ; 236A from 235C (DD1,080,0A3)
                                               ; 236A from 2362 (DD1,080,0A3)
                                               ; 236A from 2365 (DD1,080,0A3)
label_236a:     STB     A, off(PWMR0)          ; 236A 0 080 0A3 D472
                MOV     off(00084h), er3       ; 236C 0 080 0A3 477C84
                MOVB    off(000ffh), #005h     ; 236F 0 080 0A3 C4FF9805
                                               ; 2373 from 2354 (DD0,080,0A3)
label_2373:     L       A, off(PWMR1)          ; 2373 1 080 0A3 E476
                CAL     label_2e8c             ; 2375 1 080 0A3 328C2E
                MOV     er0, #00600h           ; 2378 1 080 0A3 44980006
                JBR     off(P2).2, label_2383  ; 237C 1 080 0A3 DA2404
                MOV     er0, #00080h           ; 237F 1 080 0A3 44988000
                                               ; 2383 from 237C (DD1,080,0A3)
label_2383:     SUB     A, er0                 ; 2383 1 080 0A3 28
                JGE     label_2389             ; 2384 1 080 0A3 CD03
                L       A, #00001h             ; 2386 1 080 0A3 670100
                                               ; 2389 from 2384 (DD1,080,0A3)
label_2389:     ST      A, off(00090h)         ; 2389 1 080 0A3 D490
                MOV     er3, #00d00h           ; 238B 1 080 0A3 4798000D
                CAL     label_2e88             ; 238F 1 080 0A3 32882E
                ST      A, off(0008eh)         ; 2392 1 080 0A3 D48E
                LB      A, 0a3h                ; 2394 0 080 0A3 F5A3
                CMPB    A, #028h               ; 2396 0 080 0A3 C628
                MB      off(P2).7, C           ; 2398 0 080 0A3 C4243F
                CMPB    A, #02eh               ; 239B 0 080 0A3 C62E
                MB      off(P2).6, C           ; 239D 0 080 0A3 C4243E
                CMPB    A, #0d0h               ; 23A0 0 080 0A3 C6D0
                MB      off(P2).5, C           ; 23A2 0 080 0A3 C4243D
                CMPB    A, #0a1h               ; 23A5 0 080 0A3 C6A1
                MB      off(P2).4, C           ; 23A7 0 080 0A3 C4243C
                VCAL    4                      ; 23AA 0 080 0A3 14
                MOVB    r0, #002h              ; 23AB 0 080 0A3 9802
                MOVB    r1, #002h              ; 23AD 0 080 0A3 9902
                MOVB    r2, 0cbh               ; 23AF 0 080 0A3 C5CB4A
                MOV     DP, #00124h            ; 23B2 0 080 0A3 622401
                MOV     X1, #03785h            ; 23B5 0 080 0A3 608537
                RB      PSWL.4                 ; 23B8 0 080 0A3 A30C
                CAL     label_2f9e             ; 23BA 0 080 0A3 329E2F
                LB      A, off(TMR0)           ; 23BD 0 080 0A3 F432
                ORB     A, off(TM0)            ; 23BF 0 080 0A3 E730
                ORB     A, off(TM0H)           ; 23C1 0 080 0A3 E731
                ADDB    A, #0ffh               ; 23C3 0 080 0A3 86FF
                CAL     label_3195             ; 23C5 0 080 0A3 329531
                CAL     label_2dab             ; 23C8 0 080 0A3 32AB2D
                CAL     label_2dd2             ; 23CB 0 080 0A3 32D22D
                CAL     label_2dc5             ; 23CE 0 080 0A3 32C52D
                CAL     label_2dd2             ; 23D1 0 080 0A3 32D22D
                MOV     er0, #0ae20h           ; 23D4 0 080 0A3 449820AE
                MOV     er1, #05b60h           ; 23D8 0 080 0A3 4598605B
                MOVB    r7, #007h              ; 23DC 0 080 0A3 9F07
                J       label_30ab             ; 23DE 0 080 0A3 03AB30
                                               ; 23E1 from 30B1 (DD0,080,0A3)
label_23e1:     JGE     label_23ee             ; 23E1 0 080 0A3 CD0B
                JBS     off(0002bh).3, label_23ee ; 23E3 0 080 0A3 EB2B08
                J       label_313c             ; 23E6 0 080 0A3 033C31
                                               ; 23E9 from 3145 (DD1,080,0A3)
label_23e9:     CAL     label_2e61             ; 23E9 1 080 0A3 32612E
                SJ      label_23ef             ; 23EC 1 080 0A3 CB01
                                               ; 23EE from 30B4 (DD0,080,0A3)
                                               ; 23EE from 23E1 (DD0,080,0A3)
                                               ; 23EE from 23E3 (DD0,080,0A3)
                                               ; 23EE from 313F (DD0,080,0A3)
label_23ee:     RC                             ; 23EE 0 080 0A3 95
                                               ; 23EF from 23EC (DD1,080,0A3)
label_23ef:     LB      A, r7                  ; 23EF 0 080 0A3 7F
                ; invalid opcode encountered @23F0; halting
                DB  0C4h,02Dh,020h,0BFh,081h,081h,041h,0C9h ; 23F0
                DB  0E5h,0B5h,01Ah,0D0h,080h,000h,0A2h,008h ; 23F8
                DB  0C4h,01Fh,008h,0EDh,01Eh,045h,0CEh,00Dh ; 2400
                DB  0EFh,01Eh,00Ah,0DEh,01Eh,044h,0E5h,034h ; 2408
                DB  0B5h,0E0h,0C2h,0CAh,03Dh,0C4h,01Eh,01Dh ; 2410
                DB  0C5h,0FDh,02Fh,0CAh,004h,0C5h,0E6h,098h ; 2418
                DB  004h,0C5h,0FEh,0D0h,03Fh,032h,06Eh,02Fh ; 2420
                DB  0A1h,098h,013h,002h,067h,0FFh,0FFh,076h ; 2428
                DB  076h,076h,0D5h,0BAh,0F9h,076h,076h,076h ; 2430
                DB  076h,0C5h,0A6h,015h,0C5h,024h,01Ch,0C5h ; 2438
                DB  042h,00Bh,0C5h,042h,00Ah,0C4h,020h,008h ; 2440
                DB  0C4h,02Bh,00Eh,0E5h,038h,0A6h,001h,000h ; 2448
                DB  0D5h,03Ah,0A2h,018h,0E5h,0CCh,0D5h,01Ah ; 2450
                DB  0C5h,0FFh,02Fh,0C4h,018h,03Ch,0CAh,009h ; 2458
                DB  0C5h,0FDh,00Fh,0C4h,01Eh,02Dh,0DCh,01Fh ; 2460
                DB  00Ah,077h,012h,0ECh,01Fh,002h,077h,01Dh ; 2468
                DB  0C5h,0BBh,0C2h,0C4h,01Fh,03Ch,0CDh,02Ch ; 2470
                DB  0DCh,018h,003h,0C4h,01Fh,019h,0B4h,02Ch ; 2478
                DB  0D0h,092h,002h,0C4h,02Eh,0D0h,07Fh,077h ; 2480
                DB  096h,0D4h,0C8h,0D4h,0C9h,0FAh,0D5h,0F8h ; 2488
                DB  0D5h,0F9h,0C4h,0E9h,098h,01Eh,0C4h,0CAh ; 2490
                DB  098h,01Ch,0C4h,0FBh,098h,00Ah,0EDh,01Eh ; 2498
                DB  003h,0EDh,030h,004h,0C4h,0EAh,098h,063h ; 24A0
                DB  014h,09Ah,0D9h,0DCh,020h,003h,003h,070h ; 24A8
                DB  030h,0C4h,06Fh,04Bh,0EBh,02Ah,027h,0F4h ; 24B0
                DB  0E9h,0CEh,023h,07Bh,098h,004h,0C9h,002h ; 24B8
                DB  098h,006h,062h,078h,002h,0F2h,008h,0C5h ; 24C0
                DB  0ACh,0C2h,0CAh,012h,09Ah,0F3h,0C4h,0A0h ; 24C8
                DB  04Eh,0F4h,0A1h,023h,0C0h,000h,0C9h,001h ; 24D0
                DB  07Eh,003h,07Eh,030h,0CAh,013h,098h,001h ; 24D8
                DB  07Bh,0C9h,002h,098h,00Ah,0F4h,0A2h,008h ; 24E0
                DB  022h,015h,0C5h,0B4h,0C2h,0CAh,002h,09Ah ; 24E8
                DB  0EBh,022h,07Ch,06Fh,098h,005h,0F5h,0E7h ; 24F0
                DB  0CEh,018h,098h,0FFh,0C5h,0A6h,049h,060h ; 24F8
                DB  056h,039h,0A8h,070h,090h,0AAh,020h,0C3h ; 2500
                DB  098h,0CAh,004h,0A6h,004h,0CAh,003h,049h ; 2508
                DB  0C8h,0F0h,078h,0C5h,0A3h,0C0h,02Eh,0CDh ; 2510
                DB  006h,0EBh,023h,003h,0EDh,01Fh,006h,098h ; 2518
                DB  005h,048h,0CAh,001h,078h,0D4h,098h,062h ; 2520
                DB  01Ah,002h,0B5h,01Ah,0D0h,080h,000h,0A2h ; 2528
                DB  008h,0B2h,048h,072h,072h,0C2h,04Ah,0C5h ; 2530
                DB  0E5h,04Bh,0A2h,018h,0E5h,0CCh,0D5h,01Ah ; 2538
                DB  07Bh,032h,031h,02Bh,048h,0CEh,01Bh,07Ah ; 2540
                DB  0F8h,053h,0B5h,006h,0A9h,055h,03Bh,0C9h ; 2548
                DB  024h,048h,0C9h,021h,0A2h,008h,077h,00Fh ; 2550
                DB  0D2h,0C5h,024h,0E1h,0C5h,040h,00Ch,0C5h ; 2558
                DB  018h,00Ch,0A2h,008h,0F5h,0E5h,032h,031h ; 2560
                DB  02Bh,0F6h,0FFh,08Fh,082h,082h,037h,0D2h ; 2568
                DB  032h,077h,02Fh,0A2h,018h,014h,095h,0F4h ; 2570
                DB  0E6h,0CEh,007h,0ECh,018h,004h,0DDh,01Eh ; 2578
                DB  001h,085h,0C5h,020h,03Ah,0EFh,023h,01Ah ; 2580
                DB  0F5h,0EDh,0FAh,000h,0C5h,09Fh,0C0h,0FCh ; 2588
                DB  0CDh,003h,0EAh,018h,00Dh,0ECh,018h,003h ; 2590
                DB  0EDh,01Eh,002h,0D4h,0E6h,095h,0F4h,0E6h ; 2598
                DB  0C9h,001h,085h,0C5h,020h,03Eh,077h,0FEh ; 25A0
                DB  0ECh,02Ah,002h,077h,0FFh,0C5h,0A6h,0C2h ; 25A8
                DB  0C4h,02Ah,03Ch,0CAh,072h,0C5h,0F8h,0C0h ; 25B0
                DB  032h,0CAh,06Ch,0E8h,032h,04Ch,020h,015h ; 25B8
                DB  077h,018h,099h,0FFh,09Ah,0FAh,0E8h,02Ah ; 25C0
                DB  006h,077h,015h,099h,0FFh,09Ah,0FFh,0C5h ; 25C8
                DB  0A3h,0C1h,0CDh,00Ah,079h,0C5h,0CBh,0C2h ; 25D0
                DB  0CDh,004h,07Ah,0C5h,0A6h,0C2h,0C4h,02Ah ; 25D8
                DB  038h,0CAh,044h,062h,0E6h,03Ah,0DAh,02Ah ; 25E0
                DB  003h,072h,072h,072h,092h,0AAh,0C5h,0ACh ; 25E8
                DB  0C2h,0CAh,02Dh,072h,092h,0A8h,0C5h,0CBh ; 25F0
                DB  0C2h,0CAh,00Ch,0F5h,007h,0C5h,0A6h,0C2h ; 25F8
                DB  0CAh,005h,098h,028h,0C4h,02Ah,00Ah,020h ; 2600
                DB  07Ch,0F6h,0C5h,0FFh,02Eh,0CDh,01Bh,0C4h ; 2608
                DB  02Ah,019h,0F4h,0F4h,0CEh,01Fh,0C4h,0F5h ; 2610
                DB  098h,004h,0C4h,02Ah,01Bh,095h,0CBh,019h ; 2618
                DB  0F4h,0F6h,0C9h,0E6h,0C4h,02Ah,01Ah,0C4h ; 2620
                DB  0F5h,015h,0C4h,02Ah,009h,0F4h,0F5h,0CEh ; 2628
                DB  0E9h,0C4h,0F4h,098h,004h,0C4h,02Ah,00Bh ; 2630
                DB  085h,0C5h,020h,03Fh,0E9h,02Ah,006h,0C4h ; 2638
                DB  0F3h,098h,014h,0CBh,021h,0EBh,023h,01Eh ; 2640
                DB  0DBh,025h,01Bh,0F4h,0F3h,0C9h,017h,067h ; 2648
                DB  026h,000h,0C5h,0A4h,0C0h,028h,0CDh,006h ; 2650
                DB  0C5h,0A3h,0C0h,01Fh,0CAh,013h,0F5h,0A3h ; 2658
                DB  060h,033h,038h,013h,0CBh,00Bh,0E4h,04Eh ; 2660
                DB  0C9h,006h,0C4h,01Bh,01Dh,0C4h,01Ch,01Dh ; 2668
                DB  0F9h,0D4h,04Eh,0C5h,0F8h,0C0h,032h,0CAh ; 2670
                DB  035h,0EDh,030h,00Fh,077h,049h,0EFh,02Ah ; 2678
                DB  002h,077h,040h,0C5h,0A3h,0C1h,0C4h,02Ah ; 2680
                DB  03Fh,0CDh,023h,067h,000h,002h,0C7h,0C2h ; 2688
                DB  0CDh,01Ch,0C7h,0C4h,0CDh,018h,0F5h,0E8h ; 2690
                DB  0C6h,00Dh,0C9h,004h,0C6h,00Eh,0CEh,006h ; 2698
                DB  0C4h,0E7h,0C0h,014h,0CAh,008h,0C5h,020h ; 26A0
                DB  02Bh,000h,000h,000h,0CBh,001h,095h,0C5h ; 26A8
                DB  020h,03Ch,0EFh,023h,01Eh,0B4h,06Ch,0C0h ; 26B0
                DB  02Bh,001h,0CAh,010h,0C5h,0A4h,0C0h,028h ; 26B8
                DB  0CDh,011h,0C5h,0A3h,0C0h,01Fh,0CDh,00Bh ; 26C0
                DB  0C4h,0D3h,098h,05Ah,0F4h,0D3h,003h,0F3h ; 26C8
                DB  031h,0CBh,004h,0C4h,0D3h,015h,085h,0C5h ; 26D0
                DB  020h,03Bh,0F4h,0E9h,0CEh,006h,062h,079h ; 26D8
                DB  002h,0F5h,0A3h,0D2h,014h,0B4h,02Ch,04Ah ; 26E0
                DB  0F5h,0FDh,0D6h,003h,0C9h,004h,0F9h,0D4h ; 26E8
                DB  02Ch,08Ah,09Fh,001h,062h,0E7h,001h,046h ; 26F0
                DB  0E7h,0CAh,018h,07Fh,0A7h,0A3h,0CEh,003h ; 26F8
                DB  0D4h,0A3h,0D2h,07Fh,0C5h,0E8h,0A2h,0CEh ; 2700
                DB  002h,0D5h,0E8h,0AFh,027h,0C0h,00Fh,0CEh ; 2708
                DB  0E6h,0CBh,017h,0F4h,0A3h,0C9h,009h,04Fh ; 2710
                DB  0CEh,0F1h,0F2h,0CEh,00Dh,003h,088h,027h ; 2718
                DB  0F9h,07Fh,0D4h,0A3h,0B5h,006h,0ABh,028h ; 2720
                DB  03Bh,0D2h,014h,09Fh,011h,0FAh,0C4h,02Eh ; 2728
                DB  010h,032h,0B7h,030h,0D6h,003h,0C9h,002h ; 2730
                DB  044h,015h,062h,0BAh,001h,020h,0E7h,0CAh ; 2738
                DB  014h,0F9h,07Fh,0C5h,0E8h,0C2h,0CEh,012h ; 2740
                DB  0B5h,006h,0ABh,066h,03Bh,0C2h,0A2h,0CEh ; 2748
                DB  009h,0D5h,0E8h,0CBh,005h,0F2h,0C9h,030h ; 2750
                DB  0C2h,017h,072h,0AFh,027h,0C0h,018h,0CEh ; 2758
                DB  0DCh,09Fh,010h,062h,0C4h,001h,000h,000h ; 2760
                DB  000h,021h,0D7h,0CAh,00Eh,0F9h,0F5h,0E8h ; 2768
                DB  02Fh,0CEh,002h,0D5h,0E8h,0B2h,098h,0B3h ; 2770
                DB  00Bh,0CBh,003h,0E2h,0C9h,00Ah,082h,082h ; 2778
                DB  0BFh,027h,0C0h,00Eh,0CEh,0E3h,0CBh,030h ; 2780
                DB  0C2h,098h,005h,0F5h,0E8h,0CEh,005h,07Fh ; 2788
                DB  0D5h,0E8h,0CBh,024h,02Fh,0CEh,021h,0A2h ; 2790
                DB  008h,0D5h,0E8h,0F9h,07Fh,0B5h,006h,0ABh ; 2798
                DB  038h,03Bh,0C9h,012h,08Eh,0C5h,0FDh,01Bh ; 27A0
                DB  003h,02Eh,032h,0C5h,0FDh,00Bh,0C4h,018h ; 27A8
                DB  01Dh,0CEh,003h,000h,000h,000h,0A2h,018h ; 27B0
                DB  014h,062h,07Eh,002h,0A1h,098h,033h,001h ; 27B8
                DB  044h,015h,082h,0A1h,017h,078h,0C2h,082h ; 27C0
                DB  088h,079h,0C2h,0F2h,089h,0F2h,08Ah,0F3h ; 27C8
                DB  000h,0F6h,0FFh,022h,0F2h,06Ah,086h,001h ; 27D0
                DB  0CEh,017h,092h,0C0h,07Bh,002h,0CEh,0E2h ; 27D8
                DB  072h,0F2h,0D6h,08Ch,0CEh,00Bh,072h,0F2h ; 27E0
                DB  0D6h,00Eh,0CEh,005h,072h,0E2h,048h,0C9h ; 27E8
                DB  005h,0C5h,0EDh,098h,043h,0FFh,0E5h,01Ah ; 27F0
                DB  0CEh,051h,032h,034h,02Fh,085h,0F4h,02Ch ; 27F8
                DB  0D6h,082h,0CEh,025h,0B5h,098h,048h,021h ; 2800
                DB  0C0h,0C0h,0CAh,01Dh,020h,0C0h,0C0h,0CAh ; 2808
                DB  018h,062h,079h,002h,0F2h,028h,09Ah,010h ; 2810
                DB  0CDh,005h,08Ah,0FAh,02Ah,09Ah,010h,022h ; 2818
                DB  0C1h,0CAh,006h,079h,028h,0CAh,002h,0C6h ; 2820
                DB  004h,0C4h,01Ah,03Dh,0C5h,04Ah,01Ch,0C5h ; 2828
                DB  054h,01Fh,0C5h,04Eh,01Ch,0C5h,0EBh,098h ; 2830
                DB  020h,0B5h,0CEh,098h,090h,000h,067h,0FBh ; 2838
                DB  022h,0D5h,0CCh,0C5h,046h,015h,0B5h,018h ; 2840
                DB  015h,0D5h,01Ah,0C5h,0FEh,00Dh,0CEh,003h ; 2848
                DB  003h,0B3h,01Eh,0C5h,0A6h,0C0h,086h,0CDh ; 2850
                DB  028h,0ECh,018h,025h,0C5h,0A6h,0C0h,01Bh ; 2858
                DB  0CAh,01Fh,0C5h,0B4h,0C0h,030h,0CAh,019h ; 2860
                DB  0C5h,0A3h,0C0h,034h,0CDh,013h,077h,0FFh ; 2868
                DB  0C5h,046h,00Bh,0CEh,006h,0F4h,0C6h,0C9h ; 2870
                DB  003h,0A6h,001h,095h,0C4h,018h,03Ah,0D4h ; 2878
                DB  0C6h,0EDh,031h,018h,0F5h,09Ah,060h,01Dh ; 2880
                DB  03Bh,013h,0C7h,070h,0CAh,00Eh,0F5h,09Ah ; 2888
                DB  060h,023h,03Bh,013h,0C7h,070h,0CDh,004h ; 2890
                DB  0F4h,0FBh,0C9h,001h,095h,0C4h,02Dh,038h ; 2898
                DB  014h,062h,078h,002h,0F2h,0C5h,0F8h,0C0h ; 28A0
                DB  014h,0CAh,01Bh,0EAh,024h,018h,0C5h,0A6h ; 28A8
                DB  0C0h,086h,0CDh,012h,0F5h,0ACh,0C6h,026h ; 28B0
                DB  0CDh,00Ch,089h,0C4h,09Bh,048h,028h,0CAh ; 28B8
                DB  004h,0C6h,003h,0CAh,006h,079h,0D4h,09Bh ; 28C0
                DB  088h,0CBh,013h,0F4h,0CBh,0CEh,01Bh,0F4h ; 28C8
                DB  09Ch,086h,004h,048h,0CAh,001h,078h,0D2h ; 28D0
                DB  0C7h,09Ch,0CDh,002h,0D4h,09Ch,0F2h,0C9h ; 28D8
                DB  005h,048h,077h,00Fh,0CAh,002h,077h,002h ; 28E0
                DB  0D4h,0CBh,003h,0B3h,01Eh ; 28E8
                                               ; 28ED from 1585 (DD0,200,???)
                                               ; 28ED from 15AB (DD0,200,???)
                                               ; 28ED from 15E8 (DD0,200,???)
                                               ; 28ED from 28F7 (DD0,200,???)
                                               ; 28ED from 1603 (DD1,200,???)
label_28ed:     CMP     TM0, #0000dh           ; 28ED 0 200 ??? B530C00D00
                JGE     label_28fe             ; 28F2 0 200 ??? CD0A
                RB      IRQ.7                  ; 28F4 0 200 ??? C5180F
                JEQ     label_28ed             ; 28F7 0 200 ??? C9F4
                SCAL    label_2911             ; 28F9 0 200 ??? 3116
                MOV     LRB, #00040h           ; 28FB 0 200 ??? 574000
                                               ; 28FE from 28F2 (DD0,200,???)
                                               ; 28FE from 2903 (DD0,200,???)
label_28fe:     CMP     TM0, #00018h           ; 28FE 0 200 ??? B530C01800
                JLT     label_28fe             ; 2903 0 200 ??? CAF9
                RT                             ; 2905 0 200 ??? 01
                                               ; 2906 from 1590 (DD1,200,???)
                                               ; 2906 from 15B6 (DD1,200,???)
                                               ; 2906 from 15F3 (DD1,200,???)
label_2906:     RB      IRQ.7                  ; 2906 1 200 ??? C5180F
                JEQ     label_2910             ; 2909 1 200 ??? C905
                SCAL    label_2911             ; 290B 1 200 ??? 3104
                MOV     LRB, #00040h           ; 290D 1 200 ??? 574000
                                               ; 2910 from 2909 (DD1,200,???)
label_2910:     RT                             ; 2910 1 200 ??? 01
                                               ; 2911 from 00CD (DD0,???,???)
                                               ; 2911 from 28F9 (DD0,200,???)
                                               ; 2911 from 290B (DD1,200,???)
label_2911:     CLR     LRB                    ; 2911 0 ??? ??? A415
                LB      A, 0e4h                ; 2913 0 ??? ??? F5E4
                JEQ     label_2934             ; 2915 0 ??? ??? C91D
                CMPB    A, #001h               ; 2917 0 ??? ??? C601
                JNE     label_2941             ; 2919 0 ??? ??? CE26
                LB      A, 0dfh                ; 291B 0 ??? ??? F5DF
                ADDB    A, #001h               ; 291D 0 ??? ??? 8601
                CMPB    A, #003h               ; 291F 0 ??? ??? C603
                JGE     label_295f             ; 2921 0 ??? ??? CD3C
                SB      TCON2.2                ; 2923 0 ??? ??? C5421A
                L       A, 0dah                ; 2926 1 ??? ??? E5DA
                CMP     A, #0001eh             ; 2928 1 ??? ??? C61E00
                JGE     label_2930             ; 292B 1 ??? ??? CD03
                L       A, #0001eh             ; 292D 1 ??? ??? 671E00
                                               ; 2930 from 292B (DD1,???,???)
label_2930:     ADD     A, off(07ff36h)        ; 2930 1 ??? ??? 8736
                SJ      label_2989             ; 2932 1 ??? ??? CB55
                                               ; 2934 from 2915 (DD0,???,???)
label_2934:     MOV     off(07ffb0h), ADCR5    ; 2934 0 ??? ??? B56A7CB0
                CMPB    A, off(07ffdfh)        ; 2938 0 ??? ??? C7DF
                JNE     label_294b             ; 293A 0 ??? ??? CE0F
                                               ; 293C from 2945 (DD0,???,???)
label_293c:     SB      TCON2.2                ; 293C 0 ??? ??? C5421A
                SJ      label_2953             ; 293F 0 ??? ??? CB12
                                               ; 2941 from 2919 (DD0,???,???)
label_2941:     CMPB    A, #002h               ; 2941 0 ??? ??? C602
                JEQ     label_2970             ; 2943 0 ??? ??? C92B
                JBS     off(07ffdfh).2, label_293c ; 2945 0 ??? ??? EADFF4
                RB      TCON2.2                ; 2948 0 ??? ??? C5420A
                                               ; 294B from 293A (DD0,???,???)
label_294b:     ADDB    A, #001h               ; 294B 0 ??? ??? 8601
                ANDB    A, #003h               ; 294D 0 ??? ??? D603
                CMPB    A, off(07ffdfh)        ; 294F 0 ??? ??? C7DF
                JEQ     label_2965             ; 2951 0 ??? ??? C912
                                               ; 2953 from 293F (DD0,???,???)
                                               ; 2953 from 295C (DD0,???,???)
label_2953:     L       A, TM2                 ; 2953 1 ??? ??? E538
                SUB     A, #00001h             ; 2955 1 ??? ??? A60100
                ST      A, TMR2                ; 2958 1 ??? ??? D53A
                SJ      label_298e             ; 295A 1 ??? ??? CB32
                                               ; 295C from 2970 (DD0,???,???)
label_295c:     JBR     off(07ff42h).3, label_2953 ; 295C 0 ??? ??? DB42F4
                                               ; 295F from 2921 (DD0,???,???)
label_295f:     L       A, TMR1                ; 295F 1 ??? ??? E536
                ADD     A, off(07ffdah)        ; 2961 1 ??? ??? 87DA
                ST      A, 0dch                ; 2963 1 ??? ??? D5DC
                                               ; 2965 from 2951 (DD0,???,???)
label_2965:     L       A, TMR1                ; 2965 1 ??? ??? E536
                ADD     A, off(07ffd8h)        ; 2967 1 ??? ??? 87D8
                ST      A, TMR2                ; 2969 1 ??? ??? D53A
                SB      TCON2.3                ; 296B 1 ??? ??? C5421B
                SJ      label_298e             ; 296E 1 ??? ??? CB1E
                                               ; 2970 from 2943 (DD0,???,???)
label_2970:     JBR     off(07ff42h).2, label_295c ; 2970 0 ??? ??? DA42E9
                L       A, TM2                 ; 2973 1 ??? ??? E538
                SUB     A, off(07ff36h)        ; 2975 1 ??? ??? A736
                ADD     A, #00005h             ; 2977 1 ??? ??? 860500
                CMP     A, off(07ffdah)        ; 297A 1 ??? ??? C7DA
                JGE     label_2984             ; 297C 1 ??? ??? CD06
                L       A, TMR1                ; 297E 1 ??? ??? E536
                ADD     A, off(07ffdah)        ; 2980 1 ??? ??? 87DA
                SJ      label_2989             ; 2982 1 ??? ??? CB05
                                               ; 2984 from 297C (DD1,???,???)
label_2984:     L       A, TM2                 ; 2984 1 ??? ??? E538
                ADD     A, #00003h             ; 2986 1 ??? ??? 860300
                                               ; 2989 from 2932 (DD1,???,???)
                                               ; 2989 from 2982 (DD1,???,???)
label_2989:     ST      A, TMR2                ; 2989 1 ??? ??? D53A
                RB      TCON2.3                ; 298B 1 ??? ??? C5420B
                                               ; 298E from 295A (DD1,???,???)
                                               ; 298E from 296E (DD1,???,???)
label_298e:     RB      IRQH.1                 ; 298E 1 ??? ??? C51909
                SB      IRQ.5                  ; 2991 1 ??? ??? C5181D
                RT                             ; 2994 1 ??? ??? 01
                                               ; 2995 from 0123 (DD0,???,???)
                                               ; 2995 from 0319 (DD0,???,???)
label_2995:     JBS     off(07ff31h).6, label_29a8 ; 2995 0 ??? ??? EE3110
                JBS     off(07ff21h).1, label_29a8 ; 2998 0 ??? ??? E9210D
                L       A, #000dch             ; 299B 1 ??? ??? 67DC00
                CMP     A, 0bah                ; 299E 1 ??? ??? B5BAC2
                JGE     label_29a9             ; 29A1 1 ??? ??? CD06
                RB      TRNSIT.1               ; 29A3 1 ??? ??? C54609
                JEQ     label_29ad             ; 29A6 1 ??? ??? C905
                                               ; 29A8 from 2995 (DD0,???,???)
                                               ; 29A8 from 2998 (DD0,???,???)
label_29a8:     RC                             ; 29A8 1 ??? ??? 95
                                               ; 29A9 from 29A1 (DD1,???,???)
label_29a9:     MOVB    off(07ffbdh), #006h    ; 29A9 1 ??? ??? C4BD9806
                                               ; 29AD from 29A6 (DD1,???,???)
label_29ad:     MB      off(07ff2eh).3, C      ; 29AD 1 ??? ??? C42E3B
                RT                             ; 29B0 1 ??? ??? 01
                                               ; 29B1 from 0291 (DD1,???,???)
                                               ; 29B1 from 093C (DD1,108,13D)
label_29b1:     MOV     LRB, #00040h           ; 29B1 1 200 ??? 574000
                LB      A, 0e6h                ; 29B4 0 200 ??? F5E6
                JEQ     label_29cc             ; 29B6 0 200 ??? C914
                DECB    0e6h                   ; 29B8 0 200 ??? C5E617
                CMPB    A, #004h               ; 29BB 0 200 ??? C604
                JEQ     label_29cc             ; 29BD 0 200 ??? C90D
                LB      A, off(0021ah)         ; 29BF 0 200 ??? F41A
                MB      C, ACC.7               ; 29C1 0 200 ??? C5062F
                ROLB    A                      ; 29C4 0 200 ??? 33
                STB     A, off(0021ah)         ; 29C5 0 200 ??? D41A
                XORB    A, #0ffh               ; 29C7 0 200 ??? F6FF
                STB     A, off(0021bh)         ; 29C9 0 200 ??? D41B
                RT                             ; 29CB 0 200 ??? 01
                                               ; 29CC from 29B6 (DD0,200,???)
                                               ; 29CC from 29BD (DD0,200,???)
label_29cc:     MOVB    r0, #0ffh              ; 29CC 0 200 ??? 98FF
                L       A, 0d6h                ; 29CE 1 200 ??? E5D6
                MOV     X1, A                  ; 29D0 1 200 ??? 50
                MB      C, 0feh.6              ; 29D1 1 200 ??? C5FE2E
                JLT     label_29d9             ; 29D4 1 200 ??? CA03
                JNE     label_29d9             ; 29D6 1 200 ??? CE01
                SC                             ; 29D8 1 200 ??? 85
                                               ; 29D9 from 29D4 (DD1,200,???)
                                               ; 29D9 from 29D6 (DD1,200,???)
label_29d9:     MB      PSWL.4, C              ; 29D9 1 200 ??? A33C
                CMPB    off(0021ch), #00fh     ; 29DB 1 200 ??? C41CC00F
                JNE     label_2a2d             ; 29DF 1 200 ??? CE4C
                MOV     USP, #00214h           ; 29E1 1 200 214 A1981402
                MOV     DP, #000d0h            ; 29E5 1 200 214 62D000
                L       A, [DP]                ; 29E8 1 200 214 E2
                JNE     label_2a04             ; 29E9 1 200 214 CE19
                INC     DP                     ; 29EB 1 200 214 72
                INC     DP                     ; 29EC 1 200 214 72
                L       A, [DP]                ; 29ED 1 200 214 E2
                JNE     label_2a16             ; 29EE 1 200 214 CE26
                INC     DP                     ; 29F0 1 200 214 72
                INC     DP                     ; 29F1 1 200 214 72
                L       A, [DP]                ; 29F2 1 200 214 E2
                JEQ     label_2a2d             ; 29F3 1 200 214 C938
                MOV     X1, A                  ; 29F5 1 200 214 50
                MB      C, off(0021bh).0       ; 29F6 1 200 214 C41B28
                RORB    off(0021bh)            ; 29F9 1 200 214 C41BC7
                                               ; 29FC from 2A2B (DD0,200,214)
label_29fc:     CAL     label_2b16             ; 29FC 1 200 214 32162B
                ANDB    r0, off(0021ah)        ; 29FF 1 200 214 20D31A
                SJ      label_2a2d             ; 2A02 1 200 214 CB29
                                               ; 2A04 from 29E9 (DD1,200,214)
label_2a04:     MOV     X1, A                  ; 2A04 1 200 214 50
                MB      C, off(0021bh).7       ; 2A05 1 200 214 C41B2F
                ROLB    off(0021bh)            ; 2A08 1 200 214 C41BB7
                CAL     label_2b16             ; 2A0B 1 200 214 32162B
                LB      A, off(0021ah)         ; 2A0E 0 200 214 F41A
                SRLB    A                      ; 2A10 0 200 214 63
                SRLB    A                      ; 2A11 0 200 214 63
                ANDB    r0, A                  ; 2A12 0 200 214 20D1
                SJ      label_2a23             ; 2A14 0 200 214 CB0D
                                               ; 2A16 from 29EE (DD1,200,214)
label_2a16:     MOV     X1, A                  ; 2A16 1 200 214 50
                MB      C, off(0021bh).7       ; 2A17 1 200 214 C41B2F
                ROLB    off(0021bh)            ; 2A1A 1 200 214 C41BB7
                MB      C, off(0021bh).7       ; 2A1D 1 200 214 C41B2F
                ROLB    off(0021bh)            ; 2A20 1 200 214 C41BB7
                                               ; 2A23 from 2A14 (DD0,200,214)
label_2a23:     CAL     label_2b16             ; 2A23 1 200 214 32162B
                LB      A, off(0021ah)         ; 2A26 0 200 214 F41A
                SRLB    A                      ; 2A28 0 200 214 63
                ANDB    r0, A                  ; 2A29 0 200 214 20D1
                SJ      label_29fc             ; 2A2B 0 200 214 CBCF
                                               ; 2A2D from 29DF (DD1,200,???)
                                               ; 2A2D from 29F3 (DD1,200,214)
                                               ; 2A2D from 2A02 (DD1,200,214)
label_2a2d:     LB      A, off(0021ah)         ; 2A2D 0 200 ??? F41A
                SLLB    A                      ; 2A2F 0 200 ??? 53
                SWAPB                          ; 2A30 0 200 ??? 83
                ANDB    A, r0                  ; 2A31 0 200 ??? 58
                ORB     A, #0f0h               ; 2A32 0 200 ??? E6F0
                STB     A, r0                  ; 2A34 0 200 ??? 88
                L       A, #0001ah             ; 2A35 1 200 ??? 671A00
                SUB     A, X1                  ; 2A38 1 200 ??? 90A2
                MOV     X1, A                  ; 2A3A 1 200 ??? 50
                                               ; 2A3B from 2A4B (DD0,200,???)
label_2a3b:     RB      PSWH.0                 ; 2A3B 1 200 ??? A208
                LB      A, off(0021ch)         ; 2A3D 0 200 ??? F41C
                JNE     label_2a7c             ; 2A3F 0 200 ??? CE3B
                SB      IRQ.4                  ; 2A41 0 200 ??? C5181C
                MOV     TM0, #0000ch           ; 2A44 0 200 ??? B530980C00
                SB      PSWH.0                 ; 2A49 0 200 ??? A218
                SJ      label_2a3b             ; 2A4B 0 200 ??? CBEE
                                               ; 2A4D from 2A84 (DD0,200,???)
label_2a4d:     RB      TCON0.4                ; 2A4D 0 200 ??? C5400C
                LB      A, #00fh               ; 2A50 0 200 ??? 770F
                STB     A, off(0021ch)         ; 2A52 0 200 ??? D41C
                ORB     P2, A                  ; 2A54 0 200 ??? C524E1
                LB      A, off(0021ah)         ; 2A57 0 200 ??? F41A
                XORB    A, #0ffh               ; 2A59 0 200 ??? F6FF
                STB     A, off(0021bh)         ; 2A5B 0 200 ??? D41B
                RB      IRQ.4                  ; 2A5D 0 200 ??? C5180C
                MOV     off(00214h), #0ffffh   ; 2A60 0 200 ??? B41498FFFF
                SJ      label_2aca             ; 2A65 0 200 ??? CB63
                                               ; 2A67 from 2A88 (DD0,200,???)
label_2a67:     LB      A, r0                  ; 2A67 0 200 ??? 78
                ANDB    off(0021ch), A         ; 2A68 0 200 ??? C41CD1
                MB      C, 0feh.7              ; 2A6B 0 200 ??? C5FE2F
                JLT     label_2a73             ; 2A6E 0 200 ??? CA03
                ANDB    P2, A                  ; 2A70 0 200 ??? C524D1
                                               ; 2A73 from 2A6E (DD0,200,???)
label_2a73:     L       A, X1                  ; 2A73 1 200 ??? 40
                ST      A, TM0                 ; 2A74 1 200 ??? D530
                SB      TCON0.4                ; 2A76 1 200 ??? C5401C
                J       label_2b13             ; 2A79 1 200 ??? 03132B
                                               ; 2A7C from 2A3F (DD0,200,???)
label_2a7c:     MB      C, off(0021ah).7       ; 2A7C 0 200 ??? C41A2F
                ROLB    off(0021ah)            ; 2A7F 0 200 ??? C41AB7
                MB      C, PSWL.4              ; 2A82 0 200 ??? A32C
                JLT     label_2a4d             ; 2A84 0 200 ??? CAC7
                CMPB    A, #00fh               ; 2A86 0 200 ??? C60F
                JEQ     label_2a67             ; 2A88 0 200 ??? C9DD
                STB     A, r1                  ; 2A8A 0 200 ??? 89
                LB      A, r0                  ; 2A8B 0 200 ??? 78
                ANDB    off(0021ch), A         ; 2A8C 0 200 ??? C41CD1
                MB      C, 0feh.7              ; 2A8F 0 200 ??? C5FE2F
                JLT     label_2a97             ; 2A92 0 200 ??? CA03
                ANDB    P2, A                  ; 2A94 0 200 ??? C524D1
                                               ; 2A97 from 2A92 (DD0,200,???)
label_2a97:     L       A, TM0                 ; 2A97 1 200 ??? E530
                ADD     A, 0d6h                ; 2A99 1 200 ??? B5D682
                JLT     label_2aa1             ; 2A9C 1 200 ??? CA03
                MB      C, IRQ.4               ; 2A9E 1 200 ??? C5182C
                                               ; 2AA1 from 2A9C (DD1,200,???)
label_2aa1:     JBR     off(00201h).0, label_2aaf ; 2AA1 1 200 ??? D8010B
                JBR     off(00201h).1, label_2af3 ; 2AA4 1 200 ??? D9014C
                JBS     off(00201h).2, label_2ab8 ; 2AA7 1 200 ??? EA010E
                JBR     off(00201h).3, label_2ad7 ; 2AAA 1 200 ??? DB012A
                SJ      label_2ab8             ; 2AAD 1 200 ??? CB09
                                               ; 2AAF from 2AA1 (DD1,200,???)
label_2aaf:     JBR     off(00201h).1, label_2ad1 ; 2AAF 1 200 ??? D9011F
                JBR     off(00201h).2, label_2af9 ; 2AB2 1 200 ??? DA0144
                JBR     off(00201h).3, label_2ad7 ; 2AB5 1 200 ??? DB011F
                                               ; 2AB8 from 2AA7 (DD1,200,???)
                                               ; 2AB8 from 2AAD (DD1,200,???)
                                               ; 2AB8 from 2AF3 (DD1,200,???)
label_2ab8:     JGE     label_2ac4             ; 2AB8 1 200 ??? CD0A
                SUB     A, #00033h             ; 2ABA 1 200 ??? A63300
                JLT     label_2ac4             ; 2ABD 1 200 ??? CA05
                CMP     A, #000c0h             ; 2ABF 1 200 ??? C6C000
                JGE     label_2ac5             ; 2AC2 1 200 ??? CD01
                                               ; 2AC4 from 2AB8 (DD1,200,???)
                                               ; 2AC4 from 2ABD (DD1,200,???)
label_2ac4:     CLR     A                      ; 2AC4 1 200 ??? F9
                                               ; 2AC5 from 2AC2 (DD1,200,???)
label_2ac5:     ST      A, er0                 ; 2AC5 1 200 ??? 88
                CLR     A                      ; 2AC6 1 200 ??? F9
                SUB     A, er0                 ; 2AC7 1 200 ??? 28
                ST      A, off(00214h)         ; 2AC8 1 200 ??? D414
                                               ; 2ACA from 2A65 (DD0,200,???)
label_2aca:     L       A, #0ffffh             ; 2ACA 1 200 ??? 67FFFF
                ST      A, off(00216h)         ; 2ACD 1 200 ??? D416
                SJ      label_2b11             ; 2ACF 1 200 ??? CB40
                                               ; 2AD1 from 2AAF (DD1,200,???)
label_2ad1:     JBR     off(00201h).2, label_2af9 ; 2AD1 1 200 ??? DA0125
                JBR     off(00201h).3, label_2af9 ; 2AD4 1 200 ??? DB0122
                                               ; 2AD7 from 2AAA (DD1,200,???)
                                               ; 2AD7 from 2AB5 (DD1,200,???)
                                               ; 2AD7 from 2AF6 (DD1,200,???)
label_2ad7:     JGE     label_2ae7             ; 2AD7 1 200 ??? CD0E
                ADD     A, off(00214h)         ; 2AD9 1 200 ??? 8714
                JGE     label_2ae7             ; 2ADB 1 200 ??? CD0A
                SUB     A, #0004eh             ; 2ADD 1 200 ??? A64E00
                JLT     label_2ae7             ; 2AE0 1 200 ??? CA05
                CMP     A, #000c0h             ; 2AE2 1 200 ??? C6C000
                JGE     label_2ae8             ; 2AE5 1 200 ??? CD01
                                               ; 2AE7 from 2AD7 (DD1,200,???)
                                               ; 2AE7 from 2ADB (DD1,200,???)
                                               ; 2AE7 from 2AE0 (DD1,200,???)
label_2ae7:     CLR     A                      ; 2AE7 1 200 ??? F9
                                               ; 2AE8 from 2AE5 (DD1,200,???)
label_2ae8:     ST      A, er0                 ; 2AE8 1 200 ??? 88
                CLR     A                      ; 2AE9 1 200 ??? F9
                SUB     A, er0                 ; 2AEA 1 200 ??? 28
                ST      A, off(00216h)         ; 2AEB 1 200 ??? D416
                L       A, #0ffffh             ; 2AED 1 200 ??? 67FFFF
                J       label_2b11             ; 2AF0 1 200 ??? 03112B
                                               ; 2AF3 from 2AA4 (DD1,200,???)
label_2af3:     JBS     off(00201h).2, label_2ab8 ; 2AF3 1 200 ??? EA01C2
                JBS     off(00201h).3, label_2ad7 ; 2AF6 1 200 ??? EB01DE
                                               ; 2AF9 from 2AB2 (DD1,200,???)
                                               ; 2AF9 from 2AD1 (DD1,200,???)
                                               ; 2AF9 from 2AD4 (DD1,200,???)
label_2af9:     JGE     label_2b0d             ; 2AF9 1 200 ??? CD12
                ADD     A, off(00214h)         ; 2AFB 1 200 ??? 8714
                JGE     label_2b0d             ; 2AFD 1 200 ??? CD0E
                ADD     A, off(00216h)         ; 2AFF 1 200 ??? 8716
                JGE     label_2b0d             ; 2B01 1 200 ??? CD0A
                SUB     A, #00068h             ; 2B03 1 200 ??? A66800
                JLT     label_2b0d             ; 2B06 1 200 ??? CA05
                CMP     A, #000c0h             ; 2B08 1 200 ??? C6C000
                JGE     label_2b0e             ; 2B0B 1 200 ??? CD01
                                               ; 2B0D from 2AF9 (DD1,200,???)
                                               ; 2B0D from 2AFD (DD1,200,???)
                                               ; 2B0D from 2B01 (DD1,200,???)
                                               ; 2B0D from 2B06 (DD1,200,???)
label_2b0d:     CLR     A                      ; 2B0D 1 200 ??? F9
                                               ; 2B0E from 2B0B (DD1,200,???)
label_2b0e:     ST      A, er0                 ; 2B0E 1 200 ??? 88
                CLR     A                      ; 2B0F 1 200 ??? F9
                SUB     A, er0                 ; 2B10 1 200 ??? 28
                                               ; 2B11 from 2ACF (DD1,200,???)
                                               ; 2B11 from 2AF0 (DD1,200,???)
label_2b11:     ST      A, off(00218h)         ; 2B11 1 200 ??? D418
                                               ; 2B13 from 2A79 (DD1,200,???)
label_2b13:     SB      PSWH.0                 ; 2B13 1 200 ??? A218
                RT                             ; 2B15 1 200 ??? 01
                                               ; 2B16 from 29FC (DD1,200,214)
                                               ; 2B16 from 2A0B (DD1,200,214)
                                               ; 2B16 from 2A23 (DD1,200,214)
label_2b16:     L       A, [DP]                ; 2B16 1 200 214 E2
                CLR     [DP]                   ; 2B17 1 200 214 B215
                INC     DP                     ; 2B19 1 200 214 72
                INC     DP                     ; 2B1A 1 200 214 72
                SUB     A, [DP]                ; 2B1B 1 200 214 B2A2
                JGE     label_2b29             ; 2B1D 1 200 214 CD0A
                ADD     A, #0001ah             ; 2B1F 1 200 214 861A00
                JLT     label_2b29             ; 2B22 1 200 214 CA05
                CMP     A, #0ff40h             ; 2B24 1 200 214 C640FF
                JLT     label_2b2a             ; 2B27 1 200 214 CA01
                                               ; 2B29 from 2B1D (DD1,200,214)
                                               ; 2B29 from 2B22 (DD1,200,214)
label_2b29:     CLR     A                      ; 2B29 1 200 214 F9
                                               ; 2B2A from 2B27 (DD1,200,214)
label_2b2a:     ST      A, (00214h-00214h)[USP] ; 2B2A 1 200 214 D300
                INC     USP                    ; 2B2C 1 200 215 A116
                INC     USP                    ; 2B2E 1 200 216 A116
                RT                             ; 2B30 1 200 216 01
                DB  09Eh,077h,0C9h,008h,026h,02Fh,026h,0B7h ; 2B31
                DB  0A6h,001h,0CEh,0F8h,07Eh,001h ; 2B39
                                               ; 2B3F from 06FD (DD0,108,20E)
                                               ; 2B3F from 099C (DD0,108,13D)
                                               ; 2B3F from 09B5 (DD0,108,13D)
label_2b3f:     CLR     A                      ; 2B3F 1 108 20E F9
                LB      A, r6                  ; 2B40 0 108 20E 7E
                SWAPB                          ; 2B41 0 108 20E 83
                ANDB    A, #00fh               ; 2B42 0 108 20E D60F
                ADD     X1, A                  ; 2B44 0 108 20E 9081
                MB      C, PSWL.5              ; 2B46 0 108 20E A32D
                JLT     label_2b56             ; 2B48 0 108 20E CA0C
                LCB     A, 000ffh[X1]          ; 2B4A 0 108 20E 90ABFF00
                MOV     DP, A                  ; 2B4E 0 108 20E 52
                CMPCB   A, 00100h[X1]          ; 2B4F 0 108 20E 90AF0001
                MB      C, zp_PSWH.6           ; 2B53 0 108 20E C5052E
                                               ; 2B56 from 2B48 (DD0,108,20E)
label_2b56:     MB      PSWL.4, C              ; 2B56 0 108 20E A33C
                MOVB    r0, #010h              ; 2B58 0 108 20E 9810
                                               ; 2B5A from 2B62 (DD0,108,20E)
label_2b5a:     DECB    r0                     ; 2B5A 0 108 20E B8
                DEC     X2                     ; 2B5B 0 108 20E 81
                LCB     A, 00000h[X2]          ; 2B5C 0 108 20E 91AB0000
                ADDB    r7, A                  ; 2B60 0 108 20E 2781
                JGE     label_2b5a             ; 2B62 0 108 20E CDF6
                ;logging change
                ;MOV     X2, A                  ; 2B64 0 108 20E 51
                ;SLL     X2                     ; 2B65 0 108 20E 91D7
                CAL		storerow				;does the lines above and stores the row

                LB      A, #00fh               ; 2B67 0 108 20E 770F
                MULB                           ; 2B69 0 108 20E A234
                ADD     X1, A                  ; 2B6B 0 108 20E 9081
                CLR     A                      ; 2B6D 1 108 20E F9
                LCB     A, [X1]                ; 2B6E 1 108 20E 90AA
                ST      A, er0                 ; 2B70 1 108 20E 88
                LCB     A, 0000fh[X1]          ; 2B71 1 108 20E 90AB0F00
                MOV     USP, A                 ; 2B75 1 108 20E A18A
                INC     X1                     ; 2B77 1 108 20E 70
                LCB     A, [X1]                ; 2B78 1 108 20E 90AA
                ST      A, er1                 ; 2B7A 1 108 20E 89
                LCB     A, 0000fh[X1]          ; 2B7B 1 108 20E 90AB0F00
                MOV     X1, A                  ; 2B7F 1 108 20E 50
                MB      C, PSWL.4              ; 2B80 1 108 20E A32C
                JLT     label_2b88             ; 2B82 1 108 20E CA04
                SLL     er1                    ; 2B84 1 108 20E 45D7
                SLL     X1                     ; 2B86 1 108 20E 90D7
                                               ; 2B88 from 2B82 (DD1,108,20E)
label_2b88:     SCAL    label_2baf             ; 2B88 1 108 20E 3125
                MOV     er0, USP               ; 2B8A 1 108 20E A148
                MOV     er1, X1                ; 2B8C 1 108 20E 9049
                MOV     X1, A                  ; 2B8E 1 108 20E 50
                SCAL    label_2baf             ; 2B8F 1 108 20E 311E
                MOVB    r0, r7                 ; 2B91 1 108 20E 2748
                MOVB    r1, #000h              ; 2B93 1 108 20E 9900
                MB      C, off(00129h).2       ; 2B95 1 108 20E C4292A
                ROL     er0                    ; 2B98 1 108 20E 44B7
                MOV     er2, X2                ; 2B9A 1 108 20E 914A
                MOV     er3, X1                ; 2B9C 1 108 20E 904B
                CAL     label_2c7e             ; 2B9E 1 108 20E 327E2C
                RB      PSWL.5                 ; 2BA1 1 108 20E A30D
                JNE     label_2bad             ; 2BA3 1 108 20E CE08
                L       A, DP                  ; 2BA5 1 108 20E 42
                JEQ     label_2bad             ; 2BA6 1 108 20E C905
                L       A, er3                 ; 2BA8 1 108 20E 37
                                               ; 2BA9 from 2BAA (DD1,108,20E)
label_2ba9:     SLL     A                      ; 2BA9 1 108 20E 53
                JRNZ    DP, label_2ba9         ; 2BAA 1 108 20E 30FD
                ST      A, er3                 ; 2BAC 1 108 20E 8B
                                               ; 2BAD from 2BA3 (DD1,108,20E)
                                               ; 2BAD from 2BA6 (DD1,108,20E)
label_2bad:     L       A, er3                 ; 2BAD 1 108 20E 37
                RT                             ; 2BAE 1 108 20E 01
                                               ; 2BAF from 2B88 (DD1,108,20E)
                                               ; 2BAF from 2B8F (DD1,108,20E)
label_2baf:     LB      A, r6                  ; 2BAF 0 108 20E 7E
                SWAPB                          ; 2BB0 0 108 20E 83
                EXTND                          ; 2BB1 1 108 20E F8
                SWAP                           ; 2BB2 1 108 20E 83
                AND     A, #0f000h             ; 2BB3 1 108 20E D600F0
                XCHG    A, er0                 ; 2BB6 1 108 20E 4410
                ST      A, er2                 ; 2BB8 1 108 20E 8A
                SUB     A, er1                 ; 2BB9 1 108 20E 29
                JGE     label_2bbf             ; 2BBA 1 108 20E CD03
                ST      A, er1                 ; 2BBC 1 108 20E 89
                CLR     A                      ; 2BBD 1 108 20E F9
                SUB     A, er1                 ; 2BBE 1 108 20E 29
                                               ; 2BBF from 2BBA (DD1,108,20E)
label_2bbf:     MUL                            ; 2BBF 1 108 20E 9035
                L       A, er2                 ; 2BC1 1 108 20E 36
                JGE     label_2bc6             ; 2BC2 1 108 20E CD02
                ADD     A, er1                 ; 2BC4 1 108 20E 09
                RT                             ; 2BC5 1 108 20E 01
                                               ; 2BC6 from 2BC2 (DD1,108,20E)
label_2bc6:     SUB     A, er1                 ; 2BC6 1 108 20E 29
                RT                             ; 2BC7 1 108 20E 01
                                               ; 2BC8 from 099F (DD0,108,13D)
                                               ; 2BC8 from 09B8 (DD0,108,13D)
label_2bc8:     STB     A, r0                  ; 2BC8 0 108 13D 88
                L       A, off(00160h)         ; 2BC9 1 108 13D E460
                MUL                            ; 2BCB 1 108 13D 9035
                ROL     A                      ; 2BCD 1 108 13D 33
                L       A, er1                 ; 2BCE 1 108 13D 35
                ROL     A                      ; 2BCF 1 108 13D 33
                RT                             ; 2BD0 1 108 13D 01
                                               ; 2BD1 from 102C (DD0,108,13D)
label_2bd1:     LB      A, 0a3h                ; 2BD1 0 108 13D F5A3
                VCAL    0                      ; 2BD3 0 108 13D 10
                STB     A, r5                  ; 2BD4 0 108 13D 8D
                MOV     X1, X2                 ; 2BD5 0 108 13D 9178
                                               ; 2BD7 from 0FC1 (DD0,108,13D)
label_2bd7:     LB      A, 0a3h                ; 2BD7 0 108 13D F5A3
                VCAL    0                      ; 2BD9 0 108 13D 10
                STB     A, r7                  ; 2BDA 0 108 13D 8F
                MOVB    r6, r5                 ; 2BDB 0 108 13D 254E
                                               ; 2BDD from 101E (DD0,108,13D)
label_2bdd:     MOV     X1, #0373dh            ; 2BDD 0 108 13D 603D37
                JBS     off(00118h).7, label_2be4 ; 2BE0 0 108 13D EF1801
                INC     X1                     ; 2BE3 0 108 13D 70
                                               ; 2BE4 from 07D5 (DD0,108,20E)
                                               ; 2BE4 from 2BE0 (DD0,108,13D)
label_2be4:     LB      A, 0b4h                ; 2BE4 0 108 20E F5B4
                                               ; 2BE6 from 1089 (DD0,108,13D)
label_2be6:     CMPCB   A, [X1]                ; 2BE6 0 108 20E 90AE
                JLT     label_2bec             ; 2BE8 0 108 20E CA02
                LCB     A, [X1]                ; 2BEA 0 108 20E 90AA
                                               ; 2BEC from 2BE8 (DD0,108,20E)
label_2bec:     CMPCB   A, 00002h[X1]          ; 2BEC 0 108 20E 90AF0200
                JGE     label_2bf6             ; 2BF0 0 108 20E CD04
                LCB     A, 00002h[X1]          ; 2BF2 0 108 20E 90AB0200
                                               ; 2BF6 from 2BF0 (DD0,108,20E)
label_2bf6:     STB     A, r0                  ; 2BF6 0 108 20E 88
                SJ      label_2c0e             ; 2BF7 0 108 20E CB15
                                               ; 2BF9 from 0772 (DD0,108,20E)
                                               ; 2BF9 from 07E3 (DD0,108,20E)
                                               ; 2BF9 from 2194 (DD0,080,213)
                                               ; 2BF9 from 219B (DD0,080,213)
                                               ; 2BF9 from 2C01 (DD0,108,20E)
                                               ; 2BF9 from 3183 (DD0,108,20E)
                                               ; 2BF9 from 21DD (DD0,080,213)
                                               ; 2BF9 from 0883 (DD0,108,13D)
                                               ; 2BF9 from 088A (DD0,108,13D)
                                               ; 2BF9 from 096D (DD0,108,13D)
                                               ; 2BF9 from 2E71 (DD0,108,13D)
                                               ; 2BF9 from 2E78 (DD0,108,13D)
                                               ; 2BF9 from 0AE2 (DD0,108,13D)
                                               ; 2BF9 from 0AFB (DD0,108,13D)
                                               ; 2BF9 from 231F (DD0,080,0A3)
                                               ; 2BF9 from 1009 (DD0,108,13D)
                                               ; 2BF9 from 101B (DD0,108,13D)
                                               ; 2BF9 from 2BD9 (DD0,108,13D)
                                               ; 2BF9 from 107B (DD0,108,13D)
                                               ; 2BF9 from 1081 (DD0,108,13D)
                                               ; 2BF9 from 2BD3 (DD0,108,13D)
                                               ; 2BF9 from 1447 (DD0,108,13D)
vcal_0:         CMPCB   A, 00002h[X1]          ; 2BF9 0 108 20E 90AF0200
                JGE     label_2c03             ; 2BFD 0 108 20E CD04
                INC     X1                     ; 2BFF 0 108 20E 70
                INC     X1                     ; 2C00 0 108 20E 70
                SJ      vcal_0                 ; 2C01 0 108 20E CBF6
                                               ; 2C03 from 2C43 (DD0,108,20E)
                                               ; 2C03 from 2BFD (DD0,108,20E)
label_2c03:     STB     A, r0                  ; 2C03 0 108 20E 88
                LCB     A, 00003h[X1]          ; 2C04 0 108 20E 90AB0300
                STB     A, r6                  ; 2C08 0 108 20E 8E
                LCB     A, 00001h[X1]          ; 2C09 0 108 20E 90AB0100
                STB     A, r7                  ; 2C0D 0 108 20E 8F
                                               ; 2C0E from 2BF7 (DD0,108,20E)
label_2c0e:     LCB     A, 00002h[X1]          ; 2C0E 0 108 20E 90AB0200
                STB     A, r1                  ; 2C12 0 108 20E 89
                SUBB    r0, A                  ; 2C13 0 108 20E 20A1
                LCB     A, [X1]                ; 2C15 0 108 20E 90AA
                SUBB    A, r1                  ; 2C17 0 108 20E 29
                STB     A, r1                  ; 2C18 0 108 20E 89
                LB      A, r7                  ; 2C19 0 108 20E 7F
                SUBB    A, r6                  ; 2C1A 0 108 20E 2E
                MB      PSWL.4, C              ; 2C1B 0 108 20E A33C
                JGE     label_2c22             ; 2C1D 0 108 20E CD03
                STB     A, r7                  ; 2C1F 0 108 20E 8F
                CLRB    A                      ; 2C20 0 108 20E FA
                SUBB    A, r7                  ; 2C21 0 108 20E 2F
                                               ; 2C22 from 2C1D (DD0,108,20E)
label_2c22:     MULB                           ; 2C22 0 108 20E A234
                MOVB    r0, r1                 ; 2C24 0 108 20E 2148
                DIVB                           ; 2C26 0 108 20E A236
                RB      PSWL.4                 ; 2C28 0 108 20E A30C
                JEQ     label_2c30             ; 2C2A 0 108 20E C904
                SUBB    r6, A                  ; 2C2C 0 108 20E 26A1
                LB      A, r6                  ; 2C2E 0 108 20E 7E
                RT                             ; 2C2F 0 108 20E 01
                                               ; 2C30 from 2C2A (DD0,108,20E)
label_2c30:     ADDB    A, r6                  ; 2C30 0 108 20E 0E
                STB     A, r6                  ; 2C31 0 108 20E 8E
                RT                             ; 2C32 0 108 20E 01
                                               ; 2C33 from 0508 (DD0,108,20E)
                                               ; 2C33 from 2148 (DD0,080,213)
                                               ; 2C33 from 2150 (DD0,080,213)
                                               ; 2C33 from 2158 (DD0,080,213)
                                               ; 2C33 from 07CE (DD0,108,20E)
                                               ; 2C33 from 318A (DD0,108,20E)
                                               ; 2C33 from 2300 (DD0,080,0A3)
                                               ; 2C33 from 08E3 (DD0,108,13D)
                                               ; 2C33 from 08EB (DD0,108,13D)
                                               ; 2C33 from 0B9A (DD0,108,13D)
                                               ; 2C33 from 0CA0 (DD0,108,13D)
                                               ; 2C33 from 0CB5 (DD0,108,13D)
                                               ; 2C33 from 1092 (DD0,108,13D)
vcal_2:         CMPCB   A, [X1]                ; 2C33 0 108 20E 90AE
                JLT     label_2c39             ; 2C35 0 108 20E CA02
                LCB     A, [X1]                ; 2C37 0 108 20E 90AA
                                               ; 2C39 from 2C35 (DD0,108,20E)
label_2c39:     CMPCB   A, 00002h[X1]          ; 2C39 0 108 20E 90AF0200
                JGE     label_2c43             ; 2C3D 0 108 20E CD04
                LCB     A, 00002h[X1]          ; 2C3F 0 108 20E 90AB0200
                                               ; 2C43 from 2C3D (DD0,108,20E)
label_2c43:     SJ      label_2c03             ; 2C43 0 108 20E CBBE
                                               ; 2C45 from 1A9E (DD0,080,213)
                                               ; 2C45 from 1AD1 (DD0,080,213)
                                               ; 2C45 from 1D95 (DD0,080,213)
                                               ; 2C45 from 1DA9 (DD0,080,213)
vcal_3:         CMPCB   A, [X1]                ; 2C45 0 080 213 90AE
                JLT     label_2c4b             ; 2C47 0 080 213 CA02
                LCB     A, [X1]                ; 2C49 0 080 213 90AA
                                               ; 2C4B from 2C47 (DD0,080,213)
label_2c4b:     CMPCB   A, 00003h[X1]          ; 2C4B 0 080 213 90AF0300
                JGE     label_2c55             ; 2C4F 0 080 213 CD04
                LCB     A, 00003h[X1]          ; 2C51 0 080 213 90AB0300
                                               ; 2C55 from 2C4F (DD0,080,213)
label_2c55:     SJ      label_2c64             ; 2C55 0 080 213 CB0D
                                               ; 2C57 from 1A38 (DD0,080,213)
                                               ; 2C57 from 1A43 (DD0,080,213)
                                               ; 2C57 from 2C62 (DD0,080,213)
                                               ; 2C57 from 2163 (DD0,080,213)
                                               ; 2C57 from 2179 (DD0,080,213)
                                               ; 2C57 from 1AB2 (DD0,080,213)
                                               ; 2C57 from 1B7C (DD0,080,213)
                                               ; 2C57 from 2229 (DD0,080,213)
                                               ; 2C57 from 0A15 (DD0,108,13D)
                                               ; 2C57 from 08DB (DD0,108,13D)
                                               ; 2C57 from 095C (DD0,108,13D)
                                               ; 2C57 from 1D43 (DD0,080,213)
                                               ; 2C57 from 2316 (DD0,080,0A3)
                                               ; 2C57 from 232A (DD0,080,0A3)
vcal_1:         LB      A, ACC                 ; 2C57 0 080 213 F506
                CMPCB   A, 00003h[X1]          ; 2C59 0 080 213 90AF0300
                JGE     label_2c64             ; 2C5D 0 080 213 CD05
                INC     X1                     ; 2C5F 0 080 213 70
                INC     X1                     ; 2C60 0 080 213 70
                INC     X1                     ; 2C61 0 080 213 70
                SJ      vcal_1                 ; 2C62 0 080 213 CBF3
                                               ; 2C64 from 2C5D (DD0,080,213)
                                               ; 2C64 from 2C55 (DD0,080,213)
label_2c64:     STB     A, r0                  ; 2C64 0 080 213 88
                LCB     A, 00003h[X1]          ; 2C65 0 080 213 90AB0300
                STB     A, r4                  ; 2C69 0 080 213 8C
                SUBB    r0, A                  ; 2C6A 0 080 213 20A1
                CLRB    r1                     ; 2C6C 0 080 213 2115
                LCB     A, [X1]                ; 2C6E 0 080 213 90AA
                SUBB    A, r4                  ; 2C70 0 080 213 2C
                STB     A, r4                  ; 2C71 0 080 213 8C
                CLRB    r5                     ; 2C72 0 080 213 2515
                CLR     A                      ; 2C74 1 080 213 F9
                LC      A, 00004h[X1]          ; 2C75 1 080 213 90A90400
                ST      A, er3                 ; 2C79 1 080 213 8B
                LC      A, 00001h[X1]          ; 2C7A 1 080 213 90A90100
                                               ; 2C7E from 2CB8 (DD1,080,1B1)
                                               ; 2C7E from 2B9E (DD1,108,20E)
label_2c7e:     SUB     A, er3                 ; 2C7E 1 080 213 2B
                MB      PSWL.4, C              ; 2C7F 1 080 213 A33C
                JGE     label_2c86             ; 2C81 1 080 213 CD03
                ST      A, er1                 ; 2C83 1 080 213 89
                CLR     A                      ; 2C84 1 080 213 F9
                SUB     A, er1                 ; 2C85 1 080 213 29
                                               ; 2C86 from 2C81 (DD1,080,213)
label_2c86:     MUL                            ; 2C86 1 080 213 9035
                MOV     er0, er1               ; 2C88 1 080 213 4548
                DIV                            ; 2C8A 1 080 213 9037
                RB      PSWL.4                 ; 2C8C 1 080 213 A30C
                JEQ     label_2c94             ; 2C8E 1 080 213 C904
                SUB     er3, A                 ; 2C90 1 080 213 47A1
                L       A, er3                 ; 2C92 1 080 213 37
                RT                             ; 2C93 1 080 213 01
                                               ; 2C94 from 2C8E (DD1,080,213)
label_2c94:     ADD     A, er3                 ; 2C94 1 080 213 0B
                ST      A, er3                 ; 2C95 1 080 213 8B
                RT                             ; 2C96 1 080 213 01
                                               ; 2C97 from 18EB (DD1,080,1B1)
                                               ; 2C97 from 2CA1 (DD1,080,1B1)
                                               ; 2C97 from 1DEB (DD1,080,213)
label_2c97:     CMPC    A, 00004h[X1]          ; 2C97 1 080 1B1 90AD0400
                JGE     label_2ca3             ; 2C9B 1 080 1B1 CD06
                ADD     X1, #00004h            ; 2C9D 1 080 1B1 90800400
                SJ      label_2c97             ; 2CA1 1 080 1B1 CBF4
                                               ; 2CA3 from 2C9B (DD1,080,1B1)
label_2ca3:     ST      A, er0                 ; 2CA3 1 080 1B1 88
                LC      A, 00004h[X1]          ; 2CA4 1 080 1B1 90A90400
                ST      A, er2                 ; 2CA8 1 080 1B1 8A
                SUB     er0, A                 ; 2CA9 1 080 1B1 44A1
                LC      A, [X1]                ; 2CAB 1 080 1B1 90A8
                SUB     A, er2                 ; 2CAD 1 080 1B1 2A
                ST      A, er2                 ; 2CAE 1 080 1B1 8A
                LC      A, 00006h[X1]          ; 2CAF 1 080 1B1 90A90600
                ST      A, er3                 ; 2CB3 1 080 1B1 8B
                LC      A, 00002h[X1]          ; 2CB4 1 080 1B1 90A90200
                SJ      label_2c7e             ; 2CB8 1 080 1B1 CBC4
                                               ; 2CBA from 17D5 (DD1,080,00F)
                                               ; 2CBA from 19E4 (DD1,080,1B1)
label_2cba:     RB      IRQH.4                 ; 2CBA 1 080 00F C5190C
                JNE     label_2cc9             ; 2CBD 1 080 00F CE0A
                MOVB    0edh, #04ah            ; 2CBF 1 080 00F C5ED984A
                DECB    0ebh                   ; 2CC3 1 080 00F C5EB17
                JNE     label_2cda             ; 2CC6 1 080 00F CE12
                BRK                            ; 2CC8 1 080 00F FF
                                               ; 2CC9 from 2CBD (DD1,080,00F)
label_2cc9:     LB      A, P2                  ; 2CC9 0 080 00F F524
                SWAPB                          ; 2CCB 0 080 00F 83
                SRLB    A                      ; 2CCC 0 080 00F 63
                ANDB    A, #007h               ; 2CCD 0 080 00F D607
                EXTND                          ; 2CCF 1 080 00F F8
                MOV     X1, A                  ; 2CD0 1 080 00F 50
                LB      A, ADCR0H              ; 2CD1 0 080 00F F561
                STB     A, 00098h[X1]          ; 2CD3 0 080 00F D09800
                ADDB    P2, #020h              ; 2CD6 0 080 00F C5248020
                                               ; 2CDA from 2CC6 (DD1,080,00F)
label_2cda:     RT                             ; 2CDA 0 080 00F 01
                                               ; 2CDB from 0575 (DD1,108,20E)
label_2cdb:     ST      A, er0                 ; 2CDB 1 108 20E 88
                CMPB    r1, #0fah              ; 2CDC 1 108 20E 21C0FA
                JGT     label_2ceb             ; 2CDF 1 108 20E C80A
                CMPB    r1, #005h              ; 2CE1 1 108 20E 21C005
                JLT     label_2ceb             ; 2CE4 1 108 20E CA05
                RB      off(0012ch).2          ; 2CE6 1 108 20E C42C0A
                SJ      label_2cfe             ; 2CE9 1 108 20E CB13
                                               ; 2CEB from 2CDF (DD1,108,20E)
                                               ; 2CEB from 2CE4 (DD1,108,20E)
label_2ceb:     SB      off(0012ch).2          ; 2CEB 1 108 20E C42C1A
                JBR     off(00130h).6, label_2cf7 ; 2CEE 1 108 20E DE3006
                RB      off(0012ch).2          ; 2CF1 1 108 20E C42C0A
                                               ; 2CF4 from 2CFE (DD1,080,1B1)
label_2cf4:     MOVB    [DP], #02bh            ; 2CF4 1 108 20E C2982B
                                               ; 2CF7 from 2D01 (DD1,080,1B1)
                                               ; 2CF7 from 2CEE (DD1,108,20E)
label_2cf7:     INC     DP                     ; 2CF7 1 108 20E 72
                MOVB    [DP], #080h            ; 2CF8 1 108 20E C29880
                RC                             ; 2CFB 1 108 20E 95
                SJ      label_2d38             ; 2CFC 1 108 20E CB3A
                                               ; 2CFE from 19DE (DD1,080,1B1)
                                               ; 2CFE from 2CE9 (DD1,108,20E)
label_2cfe:     JBS     off(TM0).6, label_2cf4 ; 2CFE 1 080 1B1 EE30F3
                JBS     off(P4).2, label_2cf7  ; 2D01 1 080 1B1 EA2CF3
                CMP     A, #06db6h             ; 2D04 1 080 1B1 C6B66D
                JGE     label_2d0d             ; 2D07 1 080 1B1 CD04
                SLL     A                      ; 2D09 1 080 1B1 53
                CLRB    A                      ; 2D0A 0 080 1B1 FA
                SJ      label_2d11             ; 2D0B 0 080 1B1 CB04
                                               ; 2D0D from 2D07 (DD1,080,1B1)
label_2d0d:     SRL     A                      ; 2D0D 1 080 1B1 63
                SRL     A                      ; 2D0E 1 080 1B1 63
                LB      A, #0c0h               ; 2D0F 0 080 1B1 77C0
                                               ; 2D11 from 2D0B (DD0,080,1B1)
label_2d11:     ADDB    A, ACCH                ; 2D11 0 080 1B1 C50782
                STB     A, r0                  ; 2D14 0 080 1B1 88
                XCHGB   A, [DP]                ; 2D15 0 080 1B1 C210
                XCHGB   A, r0                  ; 2D17 0 080 1B1 2010
                SUBB    A, r0                  ; 2D19 0 080 1B1 28
                MB      PSWL.4, C              ; 2D1A 0 080 1B1 A33C
                ADDB    A, #080h               ; 2D1C 0 080 1B1 8680
                RB      PSWL.4                 ; 2D1E 0 080 1B1 A30C
                JEQ     label_2d27             ; 2D20 0 080 1B1 C905
                JLT     label_2d2b             ; 2D22 0 080 1B1 CA07
                CLRB    A                      ; 2D24 0 080 1B1 FA
                SJ      label_2d2b             ; 2D25 0 080 1B1 CB04
                                               ; 2D27 from 2D20 (DD0,080,1B1)
label_2d27:     JGE     label_2d2b             ; 2D27 0 080 1B1 CD02
                LB      A, #0ffh               ; 2D29 0 080 1B1 77FF
                                               ; 2D2B from 2D22 (DD0,080,1B1)
                                               ; 2D2B from 2D25 (DD0,080,1B1)
                                               ; 2D2B from 2D27 (DD0,080,1B1)
label_2d2b:     STB     A, r0                  ; 2D2B 0 080 1B1 88
                INC     DP                     ; 2D2C 0 080 1B1 72
                XCHGB   A, [DP]                ; 2D2D 0 080 1B1 C210
                CMPB    r0, A                  ; 2D2F 0 080 1B1 20C1
                RB      r0.7                   ; 2D31 0 080 1B1 200F
                JEQ     label_2d38             ; 2D33 0 080 1B1 C903
                XORB    PSWH, #080h            ; 2D35 0 080 1B1 A2F080
                                               ; 2D38 from 2CFC (DD1,108,20E)
                                               ; 2D38 from 2D33 (DD0,080,1B1)
label_2d38:     RT                             ; 2D38 1 108 20E 01
                                               ; 2D39 from 21D5 (DD0,080,0A4)
                                               ; 2D39 from 22ED (DD0,080,0A3)
label_2d39:     LB      A, (00099h-000a4h)[USP] ; 2D39 0 080 0A4 F3F5
                                               ; 2D3B from 2140 (DD0,080,0EE)
label_2d3b:     SUBB    A, (000eeh-000eeh)[USP] ; 2D3B 0 080 0EE C300A2
                JGE     label_2d44             ; 2D3E 0 080 0EE CD04
                ADDB    A, #002h               ; 2D40 0 080 0EE 8602
                SJ      label_2d46             ; 2D42 0 080 0EE CB02
                                               ; 2D44 from 2D3E (DD0,080,0EE)
label_2d44:     SUBB    A, #002h               ; 2D44 0 080 0EE A602
                                               ; 2D46 from 2D42 (DD0,080,0EE)
label_2d46:     JGE     label_2d49             ; 2D46 0 080 0EE CD01
                CLRB    A                      ; 2D48 0 080 0EE FA
                                               ; 2D49 from 2D46 (DD0,080,0EE)
label_2d49:     ADDB    A, (000eeh-000eeh)[USP] ; 2D49 0 080 0EE C30082
                STB     A, (000eeh-000eeh)[USP] ; 2D4C 0 080 0EE D300
                RT                             ; 2D4E 0 080 0EE 01
                                               ; 2D4F from 1835 (DD0,080,213)
                                               ; 2D4F from 22F0 (DD0,080,0A3)
label_2d4f:     ADDB    A, #005h               ; 2D4F 0 080 213 8605
                JGE     label_2d55             ; 2D51 0 080 213 CD02
                LB      A, #0ffh               ; 2D53 0 080 213 77FF
                                               ; 2D55 from 2D51 (DD0,080,213)
label_2d55:     JBS     off(0001eh).5, label_2d60 ; 2D55 0 080 213 ED1E08
                JBS     off(0001eh).7, label_2d60 ; 2D58 0 080 213 EF1E05
                CMPB    A, 0f6h                ; 2D5B 0 080 213 C5F6C2
                JGE     label_2d68             ; 2D5E 0 080 213 CD08
                                               ; 2D60 from 2D55 (DD0,080,213)
                                               ; 2D60 from 2D58 (DD0,080,213)
label_2d60:     MOVB    r0, #042h              ; 2D60 0 080 213 9842
                CMPB    A, r0                  ; 2D62 0 080 213 48
                JGE     label_2d66             ; 2D63 0 080 213 CD01
                LB      A, r0                  ; 2D65 0 080 213 78
                                               ; 2D66 from 2D63 (DD0,080,213)
label_2d66:     STB     A, 0f6h                ; 2D66 0 080 213 D5F6
                                               ; 2D68 from 2D5E (DD0,080,213)
label_2d68:     RT                             ; 2D68 0 080 213 01
                                               ; 2D69 from 1D14 (DD1,080,26A)
label_2d69:     SUB     A, (0026ah-0026ah)[USP] ; 2D69 1 080 26A B300A2
                MB      PSWL.4, C              ; 2D6C 1 080 26A A33C
                JGE     label_2d73             ; 2D6E 1 080 26A CD03
                ST      A, er1                 ; 2D70 1 080 26A 89
                CLR     A                      ; 2D71 1 080 26A F9
                SUB     A, er1                 ; 2D72 1 080 26A 29
                                               ; 2D73 from 2D6E (DD1,080,26A)
label_2d73:     MUL                            ; 2D73 1 080 26A 9035
                RB      PSWL.4                 ; 2D75 1 080 26A A30C
                JNE     label_2d81             ; 2D77 1 080 26A CE08
                ADD     (00266h-0026ah)[USP], A ; 2D79 1 080 26A B3FC81
                L       A, er1                 ; 2D7C 1 080 26A 35
                ADC     (0026ah-0026ah)[USP], A ; 2D7D 1 080 26A B30091
                RT                             ; 2D80 1 080 26A 01
                                               ; 2D81 from 2D77 (DD1,080,26A)
label_2d81:     SUB     (00266h-0026ah)[USP], A ; 2D81 1 080 26A B3FCA1
                L       A, er1                 ; 2D84 1 080 26A 35
                SBC     (0026ah-0026ah)[USP], A ; 2D85 1 080 26A B300B1
                RT                             ; 2D88 1 080 26A 01
                                               ; 2D89 from 1A6A (DD1,080,213)
                                               ; 2D89 from 0536 (DD1,108,20E)
                                               ; 2D89 from 056D (DD1,108,20E)
                                               ; 2D89 from 19B8 (DD1,080,21E)
                                               ; 2D89 from 0EED (DD1,108,13D)
label_2d89:     MUL                            ; 2D89 1 080 213 9035
                MOV     er2, er1               ; 2D8B 1 080 213 454A
                L       A, [DP]                ; 2D8D 1 080 213 E2
                MUL                            ; 2D8E 1 080 213 9035
                L       A, [DP]                ; 2D90 1 080 213 E2
                SUB     A, er1                 ; 2D91 1 080 213 29
                ADD     A, er2                 ; 2D92 1 080 213 0A
                ST      A, [DP]                ; 2D93 1 080 213 D2
                RT                             ; 2D94 1 080 213 01
                DB  0E2h ; 2D95
                                               ; 2D96 from 2E91 (DD1,080,213)
                                               ; 2D96 from 1DDA (DD1,080,213)
                                               ; 2D96 from 2E97 (DD1,080,213)
                                               ; 2D96 from 2E9A (DD1,080,213)
                                               ; 2D96 from 1DCB (DD1,080,213)
                                               ; 2D96 from 1DCE (DD1,080,213)
                                               ; 2D96 from 1CB2 (DD1,080,213)
                                               ; 2D96 from 13CC (DD1,108,13D)
                                               ; 2D96 from 13CF (DD1,108,13D)
                                               ; 2D96 from 13D3 (DD1,108,13D)
                                               ; 2D96 from 13D7 (DD1,108,13D)
                                               ; 2D96 from 11BE (DD1,108,13D)
vcal_5:         L       A, ACC                 ; 2D96 1 080 213 E506
                MB      C, ACCH.7              ; 2D98 1 080 213 C5072F
                JLT     label_2da5             ; 2D9B 1 080 213 CA08
                ADD     A, er3                 ; 2D9D 1 080 213 0B
                JGE     label_2da9             ; 2D9E 1 080 213 CD09
                L       A, #0ffffh             ; 2DA0 1 080 213 67FFFF
                SJ      label_2da9             ; 2DA3 1 080 213 CB04
                                               ; 2DA5 from 2D9B (DD1,080,213)
label_2da5:     ADD     A, er3                 ; 2DA5 1 080 213 0B
                JLT     label_2da9             ; 2DA6 1 080 213 CA01
                CLR     A                      ; 2DA8 1 080 213 F9
                                               ; 2DA9 from 2D9E (DD1,080,213)
                                               ; 2DA9 from 2DA3 (DD1,080,213)
                                               ; 2DA9 from 2DA6 (DD1,080,213)
label_2da9:     ST      A, er3                 ; 2DA9 1 080 213 8B
                RT                             ; 2DAA 1 080 213 01
                                               ; 2DAB from 23C8 (DD0,080,0A3)
                                               ; 2DAB from 0CE2 (DD0,108,13D)
label_2dab:     LB      A, ADCR2H              ; 2DAB 0 080 0A3 F565
                STB     A, 0a1h                ; 2DAD 0 080 0A3 D5A1
                STB     A, r6                  ; 2DAF 0 080 0A3 8E
                MOV     DP, #0011bh            ; 2DB0 0 080 0A3 621B01
                MOV     USP, #00180h           ; 2DB3 0 080 180 A1988001
                CLR     X2                     ; 2DB7 0 080 180 9115
                LB      A, off(TM0)            ; 2DB9 0 080 180 F430
                ANDB    A, #003h               ; 2DBB 0 080 180 D603
                STB     A, r7                  ; 2DBD 0 080 180 8F
                LB      A, off(TMR0)           ; 2DBE 0 080 180 F432
                ANDB    A, #0c0h               ; 2DC0 0 080 180 D6C0
                ORB     r7, A                  ; 2DC2 0 080 180 27E1
                RT                             ; 2DC4 0 080 180 01
                                               ; 2DC5 from 23CE (DD0,080,0A3)
                                               ; 2DC5 from 0CF0 (DD0,108,13D)
label_2dc5:     LB      A, ADCR3H              ; 2DC5 0 080 0A3 F567
                STB     A, 0a2h                ; 2DC7 0 080 0A3 D5A2
                STB     A, r6                  ; 2DC9 0 080 0A3 8E
                INC     DP                     ; 2DCA 0 080 0A3 72
                INC     USP                    ; 2DCB 0 080 0A4 A116
                INC     X2                     ; 2DCD 0 080 0A4 71
                INC     X2                     ; 2DCE 0 080 0A4 71
                RORB    r7                     ; 2DCF 0 080 0A4 27C7
                RT                             ; 2DD1 0 080 0A4 01
                                               ; 2DD2 from 23CB (DD0,080,0A3)
                                               ; 2DD2 from 23D1 (DD0,080,0A3)
label_2dd2:     CMPB    0a4h, #0a9h            ; 2DD2 0 080 0A3 C5A4C0A9
                LB      A, #030h               ; 2DD6 0 080 0A3 7730
                JGE     label_2de1             ; 2DD8 0 080 0A3 CD07
                LB      A, #04dh               ; 2DDA 0 080 0A3 774D
                JBR     off(P2).3, label_2de1  ; 2DDC 0 080 0A3 DB2402
                LB      A, #094h               ; 2DDF 0 080 0A3 7794
                                               ; 2DE1 from 2DD8 (DD0,080,0A3)
                                               ; 2DE1 from 2DDC (DD0,080,0A3)
label_2de1:     CMPB    0a3h, A                ; 2DE1 0 080 0A3 C5A3C1
                MB      off(0001eh).1, C       ; 2DE4 0 080 0A3 C41E39
                LB      A, off(000d4h)         ; 2DE7 0 080 0A3 F4D4
                JNE     label_2e1d             ; 2DE9 0 080 0A3 CE32
                MB      C, [DP].3              ; 2DEB 0 080 0A3 C22B
                JLT     label_2e13             ; 2DED 0 080 0A3 CA24
                MB      C, [DP].4              ; 2DEF 0 080 0A3 C22C
                JGE     label_2dfb             ; 2DF1 0 080 0A3 CD08
                JBS     off(0001fh).5, label_2e1d ; 2DF3 0 080 0A3 ED1F27
                JBR     off(EXION).7, label_2e1d ; 2DF6 0 080 0A3 DF1C24
                RB      [DP].4                 ; 2DF9 0 080 0A3 C20C
                                               ; 2DFB from 2DF1 (DD0,080,0A3)
label_2dfb:     CMPB    r6, #01ah              ; 2DFB 0 080 0A3 26C01A
                JLT     label_2e0d             ; 2DFE 0 080 0A3 CA0D
                JBR     off(0001eh).1, label_2e1d ; 2E00 0 080 0A3 D91E1A
                JBS     off(0001fh).5, label_2e1d ; 2E03 0 080 0A3 ED1F17
                JBR     off(EXION).7, label_2e1d ; 2E06 0 080 0A3 DF1C14
                LB      A, (000ebh-000a3h)[USP] ; 2E09 0 080 0A3 F348
                JNE     label_2e60             ; 2E0B 0 080 0A3 CE53
                                               ; 2E0D from 2DFE (DD0,080,0A3)
label_2e0d:     MOVB    (00103h-000a3h)[USP], #014h ; 2E0D 0 080 0A3 C3609814
                SB      [DP].3                 ; 2E11 0 080 0A3 C21B
                                               ; 2E13 from 2DED (DD0,080,0A3)
label_2e13:     JBS     off(0002bh).6, label_2e1f ; 2E13 0 080 0A3 EE2B09
                LB      A, off(000e2h)         ; 2E16 0 080 0A3 F4E2
                JNE     label_2e1d             ; 2E18 0 080 0A3 CE03
                ANDB    [DP], #0e7h            ; 2E1A 0 080 0A3 C2D0E7
                                               ; 2E1D from 2DE9 (DD0,080,0A3)
                                               ; 2E1D from 2DF3 (DD0,080,0A3)
                                               ; 2E1D from 2DF6 (DD0,080,0A3)
                                               ; 2E1D from 2E00 (DD0,080,0A3)
                                               ; 2E1D from 2E03 (DD0,080,0A3)
                                               ; 2E1D from 2E06 (DD0,080,0A3)
                                               ; 2E1D from 2E18 (DD0,080,0A3)
label_2e1d:     SJ      label_2e5c             ; 2E1D 0 080 0A3 CB3D
                                               ; 2E1F from 2E13 (DD0,080,0A3)
label_2e1f:     MOVB    off(000e2h), #032h     ; 2E1F 0 080 0A3 C4E29832
                MOV     A, USP                 ; 2E23 1 080 0A3 A199
                MOV     X1, A                  ; 2E25 1 080 0A3 50
                MOVB    r0, #00ah              ; 2E26 1 080 0A3 980A
                MB      C, 0feh.6              ; 2E28 1 080 0A3 C5FE2E
                JLT     label_2e4a             ; 2E2B 1 080 0A3 CA1D
                INC     X1                     ; 2E2D 1 080 0A3 70
                INC     X1                     ; 2E2E 1 080 0A3 70
                MOVB    r0, #00dh              ; 2E2F 1 080 0A3 980D
                JBS     off(0001fh).5, label_2e3a ; 2E31 1 080 0A3 ED1F06
                MOVB    (000f0h-000a3h)[USP], #00ah ; 2E34 1 080 0A3 C34D980A
                SJ      label_2e4f             ; 2E38 1 080 0A3 CB15
                                               ; 2E3A from 2E31 (DD1,080,0A3)
label_2e3a:     CMP     00162h[X2], #0ae20h    ; 2E3A 1 080 0A3 B16201C020AE
                JGE     label_2e58             ; 2E40 1 080 0A3 CD16
                CMP     00162h[X2], #05b60h    ; 2E42 1 080 0A3 B16201C0605B
                JLE     label_2e58             ; 2E48 1 080 0A3 CF0E
                                               ; 2E4A from 2E2B (DD1,080,0A3)
label_2e4a:     CMPB    r6, #01eh              ; 2E4A 1 080 0A3 26C01E
                JGE     label_2e53             ; 2E4D 1 080 0A3 CD04
                                               ; 2E4F from 2E38 (DD1,080,0A3)
label_2e4f:     LB      A, r0                  ; 2E4F 0 080 0A3 78
                STB     A, 0004dh[X1]          ; 2E50 0 080 0A3 D04D00
                                               ; 2E53 from 2E4D (DD1,080,0A3)
label_2e53:     LB      A, 0004dh[X1]          ; 2E53 0 080 0A3 F04D00
                JNE     label_2e5c             ; 2E56 0 080 0A3 CE04
                                               ; 2E58 from 2E40 (DD1,080,0A3)
                                               ; 2E58 from 2E48 (DD1,080,0A3)
label_2e58:     RB      [DP].3                 ; 2E58 0 080 0A3 C20B
                SB      [DP].4                 ; 2E5A 0 080 0A3 C21C
                                               ; 2E5C from 2E1D (DD0,080,0A3)
                                               ; 2E5C from 2E56 (DD0,080,0A3)
label_2e5c:     MOVB    (000ebh-000a3h)[USP], #096h ; 2E5C 0 080 0A3 C3489896
                                               ; 2E60 from 2E0B (DD0,080,0A3)
label_2e60:     RT                             ; 2E60 0 080 0A3 01
                                               ; 2E61 from 23E9 (DD1,080,0A3)
                                               ; 2E61 from 0EB2 (DD1,108,13D)
label_2e61:     CMP     er0, A                 ; 2E61 1 080 0A3 44C1
                JGE     label_2e67             ; 2E63 1 080 0A3 CD02
                L       A, er0                 ; 2E65 1 080 0A3 34
                RT                             ; 2E66 1 080 0A3 01
                                               ; 2E67 from 2E63 (DD1,080,0A3)
label_2e67:     CMP     A, er1                 ; 2E67 1 080 0A3 49
                JGE     label_2e6b             ; 2E68 1 080 0A3 CD01
                L       A, er1                 ; 2E6A 1 080 0A3 35
                                               ; 2E6B from 2E68 (DD1,080,0A3)
label_2e6b:     RT                             ; 2E6B 1 080 0A3 01
                                               ; 2E6C from 0982 (DD1,108,13D)
                                               ; 2E6C from 1023 (DD0,108,13D)
label_2e6c:     LB      A, 0a3h                ; 2E6C 0 108 13D F5A3
                MOV     X1, #0371dh            ; 2E6E 0 108 13D 601D37
                VCAL    0                      ; 2E71 0 108 13D 10
                STB     A, r2                  ; 2E72 0 108 13D 8A
                LB      A, 0a3h                ; 2E73 0 108 13D F5A3
                MOV     X1, #0370dh            ; 2E75 0 108 13D 600D37
                VCAL    0                      ; 2E78 0 108 13D 10
                SUBB    A, r2                  ; 2E79 0 108 13D 2A
                JGE     label_2e7d             ; 2E7A 0 108 13D CD01
                CLRB    A                      ; 2E7C 0 108 13D FA
                                               ; 2E7D from 2E7A (DD0,108,13D)
label_2e7d:     STB     A, off(0015dh)         ; 2E7D 0 108 13D D45D
                RT                             ; 2E7F 0 108 13D 01
                                               ; 2E80 from 1B7E (DD0,080,213)
                                               ; 2E80 from 1B88 (DD1,080,213)
                                               ; 2E80 from 1BB3 (DD0,080,213)
                                               ; 2E80 from 1D23 (DD1,080,213)
                                               ; 2E80 from 1B40 (DD0,080,213)
                                               ; 2E80 from 1C39 (DD1,080,213)
                                               ; 2E80 from 1BAA (DD1,080,213)
label_2e80:     CLR     A                      ; 2E80 1 080 213 F9
                JBS     off(P2).6, label_2e8c  ; 2E81 1 080 213 EE2408
                MOV     er3, #00580h           ; 2E84 1 080 213 47988005
                                               ; 2E88 from 238F (DD1,080,0A3)
label_2e88:     L       A, off(PWMR1)          ; 2E88 1 080 213 E476
                SJ      label_2e91             ; 2E8A 1 080 213 CB05
                                               ; 2E8C from 2E81 (DD1,080,213)
                                               ; 2E8C from 1BFF (DD1,080,213)
                                               ; 2E8C from 2375 (DD1,080,0A3)
label_2e8c:     ST      A, er3                 ; 2E8C 1 080 213 8B
                MOV     DP, #0026ah            ; 2E8D 1 080 213 626A02
                L       A, [DP]                ; 2E90 1 080 213 E2
                                               ; 2E91 from 2E8A (DD1,080,213)
label_2e91:     VCAL    5                      ; 2E91 1 080 213 15
                J       label_31b9             ; 2E92 1 080 213 03B931
                                               ; 2E95 from 31C1 (DD1,080,213)
label_2e95:     SCAL    label_2e9e             ; 2E95 1 080 213 3107
                VCAL    5                      ; 2E97 1 080 213 15
                                               ; 2E98 from 31C4 (DD1,080,213)
                                               ; 2E98 from 1CFC (DD1,080,26A)
label_2e98:     L       A, off(00084h)         ; 2E98 1 080 213 E484
                VCAL    5                      ; 2E9A 1 080 213 15
                VCAL    7                      ; 2E9B 1 080 213 17
                ST      A, er3                 ; 2E9C 1 080 213 8B
                RT                             ; 2E9D 1 080 213 01
                                               ; 2E9E from 1BA4 (DD1,080,213)
                                               ; 2E9E from 2E95 (DD1,080,213)
label_2e9e:     L       A, #08000h             ; 2E9E 1 080 213 670080
                JBR     off(00027h).6, label_2eaa ; 2EA1 1 080 213 DE2706
                JBS     off(00027h).7, label_2eaa ; 2EA4 1 080 213 EF2703
                L       A, #05a00h             ; 2EA7 1 080 213 67005A
                                               ; 2EAA from 2EA1 (DD1,080,213)
                                               ; 2EAA from 2EA4 (DD1,080,213)
                                               ; 2EAA from 1CF6 (DD1,080,26A)
label_2eaa:     ST      A, er0                 ; 2EAA 1 080 213 88
                L       A, off(0008ah)         ; 2EAB 1 080 213 E48A
                SLL     A                      ; 2EAD 1 080 213 53
                MUL                            ; 2EAE 1 080 213 9035
                L       A, er1                 ; 2EB0 1 080 213 35
                RT                             ; 2EB1 1 080 213 01
                                               ; 2EB2 from 1AE0 (DD1,080,213)
                                               ; 2EB2 from 1B83 (DD1,080,213)
                                               ; 2EB2 from 1D69 (DD1,080,213)
                                               ; 2EB2 from 1C45 (DD1,080,213)
                                               ; 2EB2 from 1DE5 (DD1,080,213)
                                               ; 2EB2 from 1CA2 (DD1,080,213)
                                               ; 2EB2 from 1CC7 (DD1,080,213)
vcal_6:         JLT     label_2eb9             ; 2EB2 1 080 213 CA05
                                               ; 2EB4 from 2E9B (DD1,080,213)
vcal_7:         CMP     A, #01bffh             ; 2EB4 1 080 213 C6FF1B
                JLT     label_2ebc             ; 2EB7 1 080 213 CA03
                                               ; 2EB9 from 2EB2 (DD1,080,213)
label_2eb9:     L       A, #01bffh             ; 2EB9 1 080 213 67FF1B
                                               ; 2EBC from 2EB7 (DD1,080,213)
label_2ebc:     RT                             ; 2EBC 1 080 213 01
                                               ; 2EBD from 1CB3 (DD1,080,213)
                                               ; 2EBD from 1CCE (DD1,080,213)
label_2ebd:     CMP     off(0008eh), A         ; 2EBD 1 080 213 B48EC1
                JGE     label_2ec5             ; 2EC0 1 080 213 CD03
                L       A, off(0008eh)         ; 2EC2 1 080 213 E48E
                RT                             ; 2EC4 1 080 213 01
                                               ; 2EC5 from 2EC0 (DD1,080,213)
label_2ec5:     CMP     A, off(00090h)         ; 2EC5 1 080 213 C790
                JGE     label_2ecb             ; 2EC7 1 080 213 CD02
                L       A, off(00090h)         ; 2EC9 1 080 213 E490
                                               ; 2ECB from 2EC7 (DD1,080,213)
label_2ecb:     RT                             ; 2ECB 1 080 213 01
                                               ; 2ECC from 0097 (DD0,100,???)
label_2ecc:     CLR     A                      ; 2ECC 1 100 ??? F9
                LB      A, r6                  ; 2ECD 0 100 ??? 7E
                SUBB    A, #001h               ; 2ECE 0 100 ??? A601
                MOVB    r0, #008h              ; 2ED0 0 100 ??? 9808
                DIVB                           ; 2ED2 0 100 ??? A236
                MOV     X1, A                  ; 2ED4 0 100 ??? 50
                LB      A, r1                  ; 2ED5 0 100 ??? 79
                ;CAL		nocode
                ;NOP
                ;NOP
                ;NOP
                ;NOP
                ;NOP

                SBR     00130h[X1]             ; 2ED6 0 100 ??? C0300111
                SBR     0027bh[X1]             ; 2EDA 0 100 ??? C07B0211
                MOV     DP, #0027bh            ; 2EDE 0 100 ??? 627B02
                CLR     er0                    ; 2EE1 0 100 ??? 4415
                                               ; 2EE3 from 2EF0 (DD0,100,???)
label_2ee3:     LB      A, r0                  ; 2EE3 0 100 ??? 78
                ADDB    A, [DP]                ; 2EE4 0 100 ??? C282
                STB     A, r0                  ; 2EE6 0 100 ??? 88
                LB      A, r1                  ; 2EE7 0 100 ??? 79
                XORB    A, [DP]                ; 2EE8 0 100 ??? C2F2
                STB     A, r1                  ; 2EEA 0 100 ??? 89
                INC     DP                     ; 2EEB 0 100 ??? 72
                CMP     DP, #0027eh            ; 2EEC 0 100 ??? 92C07E02
                JNE     label_2ee3             ; 2EF0 0 100 ??? CEF1
                L       A, er0                 ; 2EF2 1 100 ??? 34
                ST      A, [DP]                ; 2EF3 1 100 ??? D2
                RT                             ; 2EF4 1 100 ??? 01
                                               ; 2EF5 from 1EA5 (DD0,080,1C7)
                                               ; 2EF5 from 1EAF (DD0,080,1C7)
                                               ; 2EF5 from 2F25 (DD0,080,1C7)
label_2ef5:     LCB     A, [X1]                ; 2EF5 0 080 1C7 90AA
                JNE     label_2efe             ; 2EF7 0 080 1C7 CE05
                CMPB    0a6h, #0ffh            ; 2EF9 0 080 1C7 C5A6C0FF
                ROLB    A                      ; 2EFD 0 080 1C7 33
                                               ; 2EFE from 2EF7 (DD0,080,1C7)
label_2efe:     ADDB    A, [DP]                ; 2EFE 0 080 1C7 C282
                INC     X1                     ; 2F00 0 080 1C7 70
                CMPCB   A, [X1]                ; 2F01 0 080 1C7 90AE
                JLT     label_2f07             ; 2F03 0 080 1C7 CA02
                LCB     A, [X1]                ; 2F05 0 080 1C7 90AA
                                               ; 2F07 from 2F03 (DD0,080,1C7)
label_2f07:     STB     A, [DP]                ; 2F07 0 080 1C7 D2
                LB      A, r6                  ; 2F08 0 080 1C7 7E
                JBR     off(ACCH).0, label_2f19 ; 2F09 0 080 1C7 D8070D
                SUBB    A, 0e8h                ; 2F0C 0 080 1C7 C5E8A2
                JNE     label_2f13             ; 2F0F 0 080 1C7 CE02
                STB     A, 0e8h                ; 2F11 0 080 1C7 D5E8
                                               ; 2F13 from 2F0F (DD0,080,1C7)
label_2f13:     CMP     DP, #001c0h            ; 2F13 0 080 1C7 92C0C001
                SJ      label_2f22             ; 2F17 0 080 1C7 CB09
                                               ; 2F19 from 2F09 (DD0,080,1C7)
label_2f19:     JLT     label_2f1e             ; 2F19 0 080 1C7 CA03
                RBR     0fdh                   ; 2F1B 0 080 1C7 C5FD12
                                               ; 2F1E from 2F19 (DD0,080,1C7)
label_2f1e:     CMP     DP, #000ebh            ; 2F1E 0 080 1C7 92C0EB00
                                               ; 2F22 from 2F17 (DD0,080,1C7)
label_2f22:     INC     X1                     ; 2F22 0 080 1C7 70
                INC     DP                     ; 2F23 0 080 1C7 72
                INCB    r6                     ; 2F24 0 080 1C7 AE
                JLT     label_2ef5             ; 2F25 0 080 1C7 CACE
                RT                             ; 2F27 0 080 1C7 01


                ;possible ram locs!!
                                               ; 2F28 from 18C5 USP = 1b1h, DP = 9
                                               ; 2F28 from 2F31 loop
                                               ; 2F28 from 1DF8 1d4h, 2ch
                                               ; 2F28 from 1E8A 1c7h, dh

label_2f28:     LB      A, (001b1h-001b1h)[USP] ; 2F28 0 080 1B1 F300
                JEQ     label_2f2f             ; 2F2A 0 080 1B1 C903
                DECB    (001b1h-001b1h)[USP]   ; 2F2C 0 080 1B1 C30017
                                               ; 2F2F from 2F2A (DD0,080,1B1)
label_2f2f:     INC     USP                    ; 2F2F 0 080 1B2 A116
                JRNZ    DP, label_2f28         ; 2F31 0 080 1B2 30F5
                RT                             ; 2F33 0 080 1B2 01

                                               ; 2F34 from 18BB (DD0,080,213)
label_2f34:     LB      A, #03ch               ; 2F34 0 080 213 773C
                STB     A, WDT                 ; 2F36 0 080 213 D511
                SWAPB                          ; 2F38 0 080 213 83
                STB     A, WDT                 ; 2F39 0 080 213 D511
                LB      A, 0fdh                ; 2F3B 0 080 213 F5FD
                ANDB    A, #003h               ; 2F3D 0 080 213 D603
                JNE     label_2f45             ; 2F3F 0 080 213 CE04
                XORB    P4, #001h              ; 2F41 0 080 213 C52CF001
                                               ; 2F45 from 2F3F (DD0,080,213)
label_2f45:     RT                             ; 2F45 0 080 213 01
                DB  051h,0B5h,01Ah,0D0h,080h,000h,0A2h,008h ; 2F46
                DB  0B0h,082h,000h,010h,0B0h,082h,000h,010h ; 2F4E
                DB  088h,0A2h,018h,0E5h,0CCh,0D5h,01Ah,034h ; 2F56
                DB  091h,0C2h,0C9h,00Bh,0C5h,0EDh,098h,042h ; 2F5E
                DB  0C5h,0EBh,017h,0CEh,001h,0FFh,041h,001h ; 2F66
                DB  077h,000h,0D5h,0E3h,0D4h,09Ah,0C5h,0E5h ; 2F6E
                DB  015h,0C4h,099h,098h,005h,0C5h,0E7h,098h ; 2F76
                DB  004h,001h ; 2F7E
                                               ; 2F80 from 19EC (DD0,080,1B1)
label_2f80:     RB      PSWL.5                 ; 2F80 0 080 1B1 A30D
                STB     A, ACCH                ; 2F82 0 080 1B1 D507
                AND     IE, #00080h            ; 2F84 0 080 1B1 B51AD08000
                RB      PSWH.0                 ; 2F89 0 080 1B1 A208
                LB      A, P2                  ; 2F8B 0 080 1B1 F524
                SLLB    A                      ; 2F8D 0 080 1B1 53
                SWAPB                          ; 2F8E 0 080 1B1 83
                STB     A, LRBH                ; 2F8F 0 080 1B1 D503
                LB      A, ACCH                ; 2F91 0 080 1B1 F507
                STB     A, [DP]                ; 2F93 0 080 1B1 D2
                LB      A, [DP]                ; 2F94 0 080 1B1 F2
                CLR     LRB                    ; 2F95 0 080 1B1 A415
                SB      PSWH.0                 ; 2F97 0 080 1B1 A218
                MOV     off(IE), 0cch          ; 2F99 0 080 1B1 B5CC7C1A
                RT                             ; 2F9D 0 080 1B1 01
                                               ; 2F9E from 23BA (DD0,080,0A3)
                                               ; 2F9E from 2FB7 (DD0,080,0A3)
label_2f9e:     LB      A, r0                  ; 2F9E 0 080 0A3 78
                MBR     C, [DP]                ; 2F9F 0 080 0A3 C221
                LC      A, [X1]                ; 2FA1 0 080 0A3 90A8
                JLT     label_2fa7             ; 2FA3 0 080 0A3 CA02
                LB      A, ACCH                ; 2FA5 0 080 0A3 F507
                                               ; 2FA7 from 2FA3 (DD0,080,0A3)
label_2fa7:     MB      C, PSWL.4              ; 2FA7 0 080 0A3 A32C
                JLT     label_2fae             ; 2FA9 0 080 0A3 CA03
                CMPB    A, r2                  ; 2FAB 0 080 0A3 4A
                SJ      label_2fb0             ; 2FAC 0 080 0A3 CB02
                                               ; 2FAE from 2FA9 (DD0,080,0A3)
label_2fae:     CMPB    r2, A                  ; 2FAE 0 080 0A3 22C1
                                               ; 2FB0 from 2FAC (DD0,080,0A3)
label_2fb0:     LB      A, r0                  ; 2FB0 0 080 0A3 78
                MBR     [DP], C                ; 2FB1 0 080 0A3 C220
                INC     X1                     ; 2FB3 0 080 0A3 70
                INC     X1                     ; 2FB4 0 080 0A3 70
                INCB    r0                     ; 2FB5 0 080 0A3 A8
                DECB    r1                     ; 2FB6 0 080 0A3 B9
                JNE     label_2f9e             ; 2FB7 0 080 0A3 CEE5
                RT                             ; 2FB9 0 080 0A3 01
                                               ; 2FBA from 120E (DD1,108,13D)
label_2fba:     L       A, ACC                 ; 2FBA 1 108 13D E506
                ST      A, off(0014ah)         ; 2FBC 1 108 13D D44A
                JEQ     label_2fc3             ; 2FBE 1 108 13D C903
                J       label_1212             ; 2FC0 1 108 13D 031212
                                               ; 2FC3 from 2FBE (DD1,108,13D)
label_2fc3:     J       label_1288             ; 2FC3 1 108 13D 038812
                                               ; 2FC6 from 14E6 (DD1,108,13D)
label_2fc6:     MOVB    r2, #003h              ; 2FC6 1 108 13D 9A03
                J       label_14f5             ; 2FC8 1 108 13D 03F514
                                               ; 2FCB from 2185 (DD1,080,213)
label_2fcb:     AND     IE, #00080h            ; 2FCB 1 080 213 B51AD08000
                RB      PSWH.0                 ; 2FD0 1 080 213 A208
                ST      A, off(00082h)         ; 2FD2 1 080 213 D482
                MOV     A, USP                 ; 2FD4 1 080 213 A199
                ST      A, off(SRSTAT)         ; 2FD6 1 080 213 D456
                SB      PSWH.0                 ; 2FD8 1 080 213 A218
                L       A, 0cch                ; 2FDA 1 080 213 E5CC
                ST      A, IE                  ; 2FDC 1 080 213 D51A
                J       label_218f             ; 2FDE 1 080 213 038F21
                                               ; 2FE1 from 2311 (DD0,080,0A3)
label_2fe1:     VCAL    4                      ; 2FE1 0 080 0A3 14
                MOV     X1, #039f7h            ; 2FE2 0 080 0A3 60F739
                J       label_2314             ; 2FE5 0 080 0A3 031423
                                               ; 2FE8 from 0F45 (DD1,108,13D)
label_2fe8:     LB      A, (00165h-0013dh)[USP] ; 2FE8 0 108 13D F328
                JNE     label_2fef             ; 2FEA 0 108 13D CE03
                J       label_0f51             ; 2FEC 0 108 13D 03510F
                                               ; 2FEF from 2FEA (DD0,108,13D)
label_2fef:     CMPB    0a3h, #04dh            ; 2FEF 0 108 13D C5A3C04D
                JGE     label_2ff8             ; 2FF3 0 108 13D CD03
                J       label_0f49             ; 2FF5 0 108 13D 03490F
                                               ; 2FF8 from 2FF3 (DD0,108,13D)
label_2ff8:     MOVB    r0, #002h              ; 2FF8 0 108 13D 9802
                J       label_0f51             ; 2FFA 0 108 13D 03510F
                                               ; 2FFD from 051F (DD1,108,20E)
label_2ffd:     MOV     DP, #000b2h            ; 2FFD 1 108 20E 62B200
                MOV     er1, #01000h           ; 3000 1 108 20E 45980010
                JBR     off(00128h).1, label_300a ; 3004 1 108 20E D92803
                J       label_0522             ; 3007 1 108 20E 032205
                                               ; 300A from 3004 (DD1,108,20E)
label_300a:     J       label_0526             ; 300A 1 108 20E 032605
                                               ; 300D from 0528 (DD0,108,20E)
label_300d:     CMPB    A, 0b3h                ; 300D 0 108 20E C5B3C2
                JGT     label_301c             ; 3010 0 108 20E C80A
                MOV     er1, #00b00h           ; 3012 0 108 20E 4598000B
                JBR     off(00128h).1, label_301c ; 3016 0 108 20E D92803
                J       label_052d             ; 3019 0 108 20E 032D05
                                               ; 301C from 3010 (DD0,108,20E)
                                               ; 301C from 3016 (DD0,108,20E)
label_301c:     J       label_0531             ; 301C 0 108 20E 033105
                                               ; 301F from 062B (DD1,108,20E)
label_301f:     SUB     A, 0b2h                ; 301F 1 108 20E B5B2A2
                MOV     er0, #00400h           ; 3022 1 108 20E 44980004
                JBR     off(00128h).1, label_302c ; 3026 1 108 20E D92803
                J       label_062e             ; 3029 1 108 20E 032E06
                                               ; 302C from 3026 (DD1,108,20E)
label_302c:     J       label_0632             ; 302C 1 108 20E 033206
                                               ; 302F from 0634 (DD1,108,20E)
label_302f:     ST      A, er1                 ; 302F 1 108 20E 89
                CLR     A                      ; 3030 1 108 20E F9
                SUB     A, er1                 ; 3031 1 108 20E 29
                MOV     er0, #00500h           ; 3032 1 108 20E 44980005
                JBR     off(00128h).1, label_303c ; 3036 1 108 20E D92803
                J       label_0637             ; 3039 1 108 20E 033706
                                               ; 303C from 3036 (DD1,108,20E)
label_303c:     J       label_063b             ; 303C 1 108 20E 033B06
                                               ; 303F from 1251 (DD0,108,13D)
label_303f:     JBS     off(00128h).2, label_3048 ; 303F 0 108 13D EA2806
                MOVB    r2, #020h              ; 3042 0 108 13D 9A20
                MOVB    r0, #004h              ; 3044 0 108 13D 9804
                MOVB    r1, #0ffh              ; 3046 0 108 13D 99FF
                                               ; 3048 from 303F (DD0,108,13D)
label_3048:     JBR     off(00122h).4, label_3057 ; 3048 0 108 13D DC220C
                MOVB    r2, #020h              ; 304B 0 108 13D 9A20
                MOVB    r0, #001h              ; 304D 0 108 13D 9801
                MOVB    r1, #0ffh              ; 304F 0 108 13D 99FF
                JBS     off(00128h).2, label_3057 ; 3051 0 108 13D EA2803
                J       label_1254             ; 3054 0 108 13D 035412
                                               ; 3057 from 3048 (DD0,108,13D)
                                               ; 3057 from 3051 (DD0,108,13D)
label_3057:     J       label_125a             ; 3057 0 108 13D 035A12
                                               ; 305A from 1274 (DD0,108,13D)
label_305a:     JBR     off(00128h).2, label_305f ; 305A 0 108 13D DA2802
                MOVB    r0, #003h              ; 305D 0 108 13D 9803
                                               ; 305F from 305A (DD0,108,13D)
label_305f:     CMPB    0a6h, #094h            ; 305F 0 108 13D C5A6C094
                JLT     label_306d             ; 3063 0 108 13D CA08
                MOVB    r0, #003h              ; 3065 0 108 13D 9803
                JBR     off(00128h).2, label_306d ; 3067 0 108 13D DA2803
                J       label_127a             ; 306A 0 108 13D 037A12
                                               ; 306D from 3063 (DD0,108,13D)
                                               ; 306D from 3067 (DD0,108,13D)
label_306d:     J       label_127c             ; 306D 0 108 13D 037C12
                DB  0DEh,01Dh,003h,003h,0B1h,024h,0E8h,028h ; 3070
                DB  002h,09Ah,0CCh,003h,0F1h,024h,0C5h,0A6h ; 3078
                DB  0C2h,0CAh,003h,003h,0DEh,024h,0E8h,028h ; 3080
                DB  002h,09Ah,0FEh,003h,0F1h,024h ; 3088
                                               ; 308E from 22FB (DD0,080,0A3)
label_308e:     LB      A, 0a3h                ; 308E 0 080 0A3 F5A3
                CMPB    A, #02fh               ; 3090 0 080 0A3 C62F
                MB      off(P3).0, C           ; 3092 0 080 0A3 C42838
                CMPB    A, #095h               ; 3095 0 080 0A3 C695
                MB      off(P3).1, C           ; 3097 0 080 0A3 C42839
                CMPB    A, #04dh               ; 309A 0 080 0A3 C64D
                MB      off(P3).2, C           ; 309C 0 080 0A3 C4283A
                MOV     X1, #03915h            ; 309F 0 080 0A3 601539
                RT                             ; 30A2 0 080 0A3 01
                                               ; 30A3 from 121A (DD1,108,13D)
label_30a3:     RB      off(00122h).3          ; 30A3 1 108 13D C4220B
                MOVB    off(0016fh), #000h     ; 30A6 1 108 13D C46F9800
                RT                             ; 30AA 1 108 13D 01
                                               ; 30AB from 23DE (DD0,080,0A3)
label_30ab:     JBS     off(00027h).3, label_30b4 ; 30AB 0 080 0A3 EB2706
                MB      C, P0.3                ; 30AE 0 080 0A3 C5202B
                J       label_23e1             ; 30B1 0 080 0A3 03E123
                                               ; 30B4 from 30AB (DD0,080,0A3)
label_30b4:     J       label_23ee             ; 30B4 0 080 0A3 03EE23
                DB  088h,000h,000h,032h,065h,031h,0F5h,0FDh ; 30B7
                DB  001h ; 30BF
                                               ; 30C0 from 1CB7 (DD1,080,213)
label_30c0:     JLT     label_30c9             ; 30C0 1 080 213 CA07
                LC      A, 00002h[X1]          ; 30C2 1 080 213 90A90200
                J       label_1cbb             ; 30C6 1 080 213 03BB1C
                                               ; 30C9 from 30C0 (DD1,080,213)
label_30c9:     J       label_1cd6             ; 30C9 1 080 213 03D61C
                DB  0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh ; 30CC
                DB  0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh ; 30D4
                DB  0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh ; 30DC
                DB  0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh ; 30E4
                DB  0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh ; 30EC
                DB  0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh ; 30F4
                DB  0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh ; 30FC
                DB  0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh ; 3104
                DB  0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh ; 310C
                DB  0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh ; 3114
                DB  0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh ; 311C
                DB  0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh ; 3124
                                               ; 312C from 04E1 (DD0,108,20E)
label_312c:     MB      C, ACCH.7              ; 312C 0 108 20E C5072F
                ROLB    A                      ; 312F 0 108 20E 33
                SUBB    A, #030h               ; 3130 0 108 20E A630
                RT                             ; 3132 0 108 20E 01
                DB  003h,0F0h,004h,003h,0FBh,004h,003h,0D2h ; 3133
                DB  004h ; 313B
                                               ; 313C from 23E6 (DD0,080,0A3)
label_313c:     JBR     off(0001fh).5, label_3142 ; 313C 0 080 0A3 DD1F03
                J       label_23ee             ; 313F 0 080 0A3 03EE23
                                               ; 3142 from 313C (DD0,080,0A3)
label_3142:     L       A, 00162h[X2]          ; 3142 1 080 0A3 E16201
                J       label_23e9             ; 3145 1 080 0A3 03E923
                DB  0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh ; 3148
                DB  0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh ; 3150
                DB  0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh ; 3158
                DB  0FFh,0FFh,0FFh,0FFh,0FFh,0C4h,02Dh,049h ; 3160
                DB  0C4h,02Dh,0D0h,03Fh,001h,0FFh,000h,0B0h ; 3168
                DB  00Eh,060h,00Eh,054h,000h,000h,000h,0C0h ; 3170
                DB  00Eh,0B8h,000h ; 3178
                                               ; 317B from 07DE (DD0,108,20E)
label_317b:     JBR     off(00128h).4, label_318e ; 317B 0 108 20E DC2810
                MOV     X1, #0316dh            ; 317E 0 108 20E 606D31
                LB      A, 0a6h                ; 3181 0 108 20E F5A6
                VCAL    0                      ; 3183 0 108 20E 10
                STB     A, r2                  ; 3184 0 108 20E 8A
                MOV     X1, #03177h            ; 3185 0 108 20E 607731
                LB      A, 0b4h                ; 3188 0 108 20E F5B4
                VCAL    2                      ; 318A 0 108 20E 12
                SUBB    A, r2                  ; 318B 0 108 20E 2A
                JLT     label_318f             ; 318C 0 108 20E CA01
                                               ; 318E from 317B (DD0,108,20E)
label_318e:     CLRB    A                      ; 318E 0 108 20E FA
                                               ; 318F from 318C (DD0,108,20E)
label_318f:     STB     A, off(0013dh)         ; 318F 0 108 20E D43D
                MOV     X1, #038cdh            ; 3191 0 108 20E 60CD38
                RT                             ; 3194 0 108 20E 01
                                               ; 3195 from 23C5 (DD0,080,0A3)
label_3195:     MB      off(P1IO).7, C         ; 3195 0 080 0A3 C4233F
                LB      A, #084h               ; 3198 0 080 0A3 7784
                CMPB    A, 0eeh                ; 319A 0 080 0A3 C5EEC2
                JGE     label_31b5             ; 319D 0 080 0A3 CD16
                CMPB    0a4h, #0a9h            ; 319F 0 080 0A3 C5A4C0A9
                JGE     label_31b5             ; 31A3 0 080 0A3 CD10
                LB      A, #03bh               ; 31A5 0 080 0A3 773B
                CMPB    A, 0a3h                ; 31A7 0 080 0A3 C5A3C2
                JGE     label_31b5             ; 31AA 0 080 0A3 CD09
                CMPB    0a3h, #0a9h            ; 31AC 0 080 0A3 C5A3C0A9
                JGE     label_31b5             ; 31B0 0 080 0A3 CD03
                MB      C, off(P2).3           ; 31B2 0 080 0A3 C4242B
                                               ; 31B5 from 319D (DD0,080,0A3)
                                               ; 31B5 from 31A3 (DD0,080,0A3)
                                               ; 31B5 from 31AA (DD0,080,0A3)
                                               ; 31B5 from 31B0 (DD0,080,0A3)
label_31b5:     MB      off(P3).4, C           ; 31B5 0 080 0A3 C4283C
                RT                             ; 31B8 0 080 0A3 01
                                               ; 31B9 from 2E92 (DD1,080,213)
label_31b9:     JBS     off(P2SF).1, label_31c4 ; 31B9 1 080 213 E92608
                MB      C, 0ffh.6              ; 31BC 1 080 213 C5FF2E
                JLT     label_31c4             ; 31BF 1 080 213 CA03
                J       label_2e95             ; 31C1 1 080 213 03952E
                                               ; 31C4 from 31B9 (DD1,080,213)
                                               ; 31C4 from 31BF (DD1,080,213)
label_31c4:     J       label_2e98             ; 31C4 1 080 213 03982E
                                               ; 31C7 from 0BA3 (DD1,108,13D)
label_31c7:     MB      0feh.7, C              ; 31C7 1 108 13D C5FE3F
                JBS     off(00123h).0, label_31d0 ; 31CA 1 108 13D E82303
                J       label_0ba6             ; 31CD 1 108 13D 03A60B
                                               ; 31D0 from 31CA (DD1,108,13D)
label_31d0:     J       label_0bd8             ; 31D0 1 108 13D 03D80B
                                               ; 31D3 from 011C (DD0,???,???)
label_31d3:     STB     A, 0e4h                ; 31D3 0 ??? ??? D5E4
                ADDB    off(07ff9ah), #004h    ; 31D5 0 ??? ??? C49A8004
                ANDB    off(07ff9ah), #00ch    ; 31D9 0 ??? ??? C49AD00C
                ORB     off(07ff9ah), A        ; 31DD 0 ??? ??? C49AE1
                RT                             ; 31E0 0 ??? ??? 01
                DB  0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh ; 31E1
                DB  0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh ; 31E9
                DB  0FFh,0FFh,0C6h,03Ch,0CAh,004h,095h,003h ; 31F1
                DB  0D1h,026h,0DDh,01Fh,004h,0F4h,0D3h,0CEh ; 31F9
                DB  0F5h,0C4h,0D3h,015h,003h,0D6h,026h ; 3201
                                               ; 3208 from 0E6E (DD1,108,13D)
label_3208:     JBR     off(00125h).3, label_3211 ; 3208 1 108 13D DB2506
                JBS     off(00123h).3, label_3211 ; 320B 1 108 13D EB2303
                J       label_0e71             ; 320E 1 108 13D 03710E
                                               ; 3211 from 3208 (DD1,108,13D)
                                               ; 3211 from 320B (DD1,108,13D)
label_3211:     J       label_0e7c             ; 3211 1 108 13D 037C0E
                DB  0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh ; 3214
                DB  0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh ; 321C
                                               ; 3223 from 0092 (DD0,100,???)
label_3223:     RB      0fdh.3                 ; 3223 0 100 ??? C5FD0B
                JEQ     label_322b             ; 3226 0 100 ??? C903
                RB      0fdh.4                 ; 3228 0 100 ??? C5FD0C
                                               ; 322B from 3226 (DD0,100,???)
label_322b:     J       label_0095             ; 322B 0 100 ??? 039500
                DB  0C5h,0FDh,01Ch,032h,0CCh,02Eh,0C5h,0FDh ; 322E
                DB  00Ch,003h,0ABh,027h ; 3236
                                               ; 323A from 14BF (DD1,108,13D)
label_323a:     CMP     A, off(00156h)         ; 323A 1 108 13D C756
                JLT     label_3247             ; 323C 1 108 13D CA09
                JBR     off(0010ah).7, label_3244 ; 323E 1 108 13D DF0A03
                JBS     off(0012bh).3, label_324a ; 3241 1 108 13D EB2B06
                                               ; 3244 from 323E (DD1,108,13D)
label_3244:     J       label_14c3             ; 3244 1 108 13D 03C314
                                               ; 3247 from 323C (DD1,108,13D)
label_3247:     J       label_14e9             ; 3247 1 108 13D 03E914
                                               ; 324A from 3241 (DD1,108,13D)
label_324a:     J       label_14c9             ; 324A 1 108 13D 03C914


;*****************************************************************************

;launch:			CMPB	0cbh, #00Ah  ;compare speed with 10 mph, speed-10mph
;				JGT		launch2      ;if the speed > the ftl speed then use the val already in A
;				L		A, #00202h   ;else load the FTL rpm (~3600)
;				MB      C, 0feh.7	 ;are we already on the revlimit?
;				JGT		launch2		 ;No? then we jump and use the limit
;				ADD		A, #00001h	 ;else yes, we use the restart
;
;launch2:		MB      C, P2.4      ;do the line we replaced
;				RT

ORG	3262h
;*****************************************************************************
storerow:		MOV     X2, A                   ; stock line...
                SLL     X2						; stock line... A is now free
                LB		A, r0					; load the row
                MB      C, PSWL.5				;
                JLT     storeign				; if ignition map jump

                MB		C, off(00129h).0		;
                JGE		storefuel				; if we are checking non vtec fuel jump

                MB		C, off(00129h).7		; else check if vtec
            	JGE		leavestore				; if we are checking vtec and vtec is on give store the vtec row else jump and do nothing

				;do stuff for fuel storing
storefuel:		LB		A, r0
				STB		A, off(0017ch)			; store the fuel row into 17c for me

				LB		A, r7
				STB		A, off(001d8h)			; fuel row inerp

                SJ		leavestore

                ;do stuff for ignition storing
storeign:       STB		A, off(0017dh)			; store the ignition row into 17d for me

				LB		A, r7
				STB		A, off(001d9h)			; ign row inerp

leavestore:     RT

;****************************
SBnonvtec:      MB      C, off(00129h).1       ; 0994 0 108 13D C42929
                MB      off(00129h).2, C       ; 0997 0 108 13D C4293A
                RB		off(00129h).0
                RT

SBvtec:         RB      off(00129h).2
                SB		off(00129h).0
                RT

;*****************************************************************************
;logging code
                                               ; 3500 from 000A (DD0,???,???)
int_serial_rx:  L       A, 0ceh                ; 3500 1 ??? ??? E5CE
                ST      A, IE                  ; 3502 1 ??? ??? D51A
                SB      PSWH.0                 ; 3504 1 ??? ??? A218
                MOV     LRB, #0004bh           ; 3506 1 258 ??? 574B00
                L       A, DP                  ; 3509 1 258 ??? 42
                PUSHS   A                      ; 350A 1 258 ??? 55
                CLR     A                      ; 350B 1 258 ??? F9
                LB      A, SRBUF               ; 350C 0 258 ??? F555
                CMPB    r7, #000h              ; 350E 0 258 ??? 27C000
                JNE     label_351f             ; 3511 0 258 ??? CE0C
                STB     A, r6                  ; 3513 0 258 ??? 8E
                INCB    r7                     ; 3514 0 258 ??? AF
                CMPB    A, #010h               ; 3515 0 258 ??? C610
                JLT     label_355f             ; 3517 0 258 ??? CA46
                CMPB    A, #02fh               ; 3519 0 258 ??? C62F
                JLE     label_354a             ; 351B 0 258 ??? CF2D
                SJ      label_355f             ; 351D 0 258 ??? CB40
                                               ; 351F from 3511 (DD0,258,???)
label_351f:     CMPB    r7, #001h              ; 351F 0 258 ??? 27C001
                JNE     label_3528             ; 3522 0 258 ??? CE04
                STB     A, r5                  ; 3524 0 258 ??? 8D
                INCB    r7                     ; 3525 0 258 ??? AF
                SJ      label_355f             ; 3526 0 258 ??? CB37
                                               ; 3528 from 3522 (DD0,258,???)
label_3528:     CMPB    r7, #002h              ; 3528 0 258 ??? 27C002
                JNE     label_3539             ; 352B 0 258 ??? CE0C
                STB     A, r4                  ; 352D 0 258 ??? 8C
                INCB    r7                     ; 352E 0 258 ??? AF
                CMPB    r6, #001h              ; 352F 0 258 ??? 26C001
                JNE     label_355f             ; 3532 0 258 ??? CE2B
                MOV     DP, er0                ; 3534 0 258 ??? 447A
                LB      A, [DP]                ; 3536 0 258 ??? F2
                SJ      label_355b             ; 3537 0 258 ??? CB22
                                               ; 3539 from 352B (DD0,258,???)
label_3539:     CMPB    r6, #002h              ; 3539 0 258 ??? 26C002
                JNE     label_3559             ; 353C 0 258 ??? CE1B
                CMPB    r7, #003h              ; 353E 0 258 ??? 27C003
                JNE     label_3559             ; 3541 0 258 ??? CE16
                MOV     DP, er0                ; 3543 0 258 ??? 447A
                STB     A, [DP]                ; 3545 0 258 ??? D2
                LB      A, #0aah               ; 3546 0 258 ??? 77AA
                SJ      label_355b             ; 3548 0 258 ??? CB11
                                               ; 354A from 351B (DD0,258,???)
label_354a:     SUBB    A, #010h               ; 354A 0 258 ??? A610
                L       A, ACC                 ; 354C 1 258 ??? E506
                SLL     A                      ; 354E 1 258 ??? 53
                ADD     A, #logging_table      ; 354F 1 258 ??? 867035
                MOV     DP, A                  ; 3552 1 258 ??? 52
                LC      A, [DP]                ; 3553 1 258 ??? 92A8
                MOV     DP, A                  ; 3555 1 258 ??? 52
                LB      A, [DP]                ; 3556 0 258 ??? F2
                SJ      label_355b             ; 3557 0 258 ??? CB02
                                               ; 3559 from 353C (DD0,258,???)
                                               ; 3559 from 3541 (DD0,258,???)
label_3559:     LB      A, #055h               ; 3559 0 258 ??? 7755
                                               ; 355B from 3557 (DD0,258,???)
                                               ; 355B from 3537 (DD0,258,???)
                                               ; 355B from 3548 (DD0,258,???)
label_355b:     STB     A, STBUF               ; 355B 0 258 ??? D551
                CLRB    r7                     ; 355D 0 258 ??? 2715
                                               ; 355F from 3517 (DD0,258,???)
                                               ; 355F from 351D (DD0,258,???)
                                               ; 355F from 3526 (DD0,258,???)
                                               ; 355F from 3532 (DD0,258,???)
label_355f:     POPS    A                      ; 355F 1 258 ??? 65
                MOV     DP, A                  ; 3560 1 258 ??? 52
                L       A, 0cch                ; 3561 1 258 ??? E5CC
                RB      PSWH.0                 ; 3563 1 258 ??? A208
                ST      A, IE                  ; 3565 1 258 ??? D51A
                RTI                            ; 3567 1 258 ??? 02


				ORG 036f5h

                DB  0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,000h ; 36F5
                DB  0FFh,059h,0F5h,059h,0E8h,04Dh,0BAh,048h ; 36FD
                DB  087h,047h,030h,043h,028h,040h,000h,040h ; 3705
                DB  0FFh,078h,0F5h,078h,0E1h,06Ch,0BAh,063h ; 370D
                DB  087h,05Dh,030h,04Bh,028h,040h,000h,040h ; 3715
                DB  0FFh,069h,0F5h,069h,0E1h,05Ah,0BAh,057h ; 371D
                DB  087h,056h,030h,04Bh,028h,040h,000h,040h ; 3725
                DB  0FFh,05Eh,0F5h,05Eh,0E1h,05Bh,0BAh,056h ; 372D
                DB  087h,04Eh,030h,045h,028h,040h,000h,040h ; 3735
                DB  0DFh,0DFh,051h,051h,0FFh,05Ah,0E0h,044h ; 373D
                DB  0C0h,02Ah,0A0h,00Fh,080h,009h,050h,000h ; 3745
                DB  000h,000h,092h,000h,05Bh,047h,0FFh,090h ; 374D
                DB  0E9h,0A0h,0CAh,0B0h,0C5h,0EEh,000h,0EEh ; 3755
                DB  0FFh,0C0h,0E9h,0C0h,0CAh,0B0h,0C5h,0EEh ; 375D
                DB  000h,0EEh,0FFh,0E2h,004h,0E0h,050h,007h ; 3765
                DB  0C0h,086h,007h,0A0h,086h,007h,000h,0D6h ; 376D
                DB  006h,0FFh,0D6h,006h,0E8h,066h,008h,0C0h ; 3775
                DB  086h,007h,0A0h,086h,007h,000h,0D6h,006h ; 377D
                DB  005h,00Dh,013h,018h,060h,000h,0C0h,001h ; 3785
                DB  0C0h,001h,020h,000h,000h,003h,020h,000h ; 378D
                DB  0E0h,000h,008h,007h,0C5h,007h,0E0h,000h ; 3795
                DB  07Dh,007h,02Fh,008h,0E0h,000h,008h,007h ; 379D
                DB  0C5h,007h,0E0h,000h,046h,008h,025h,009h ; 37A5
                DB  080h,000h,040h,001h,010h,00Dh,080h,000h ; 37AD
                DB  040h,001h,000h,00Dh,06Bh,069h,0D7h,000h ; 37B5
                DB  000h,043h,000h,086h,000h,0BDh,0FFh,0FFh ; 37BD
                DB  000h,0CFh,000h,0FAh,02Ch,0E9h,064h,000h ; 37C5
                DB  000h,000h,000h,000h,000h,000h,000h,0FFh ; 37CD
                DB  08Bh,003h,0EAh,077h,003h,0C0h,0F9h,001h ; 37D5
                DB  080h,040h,001h,044h,030h,001h,000h,030h ; 37DD
                DB  001h,0FFh,05Eh,003h,0EAh,04Bh,003h,0C0h ; 37E5
                DB  0F9h,001h,080h,040h,001h,044h,030h,001h ; 37ED
                DB  000h,030h,001h,000h,006h,0D6h,00Dh,031h ; 37F5
                DB  000h,028h,000h,030h,005h,008h,00Ch,03Ah ; 37FD
                DB  000h,02Ch,000h,010h,000h,010h,000h,008h ; 3805
                DB  000h,008h,000h,008h,000h,008h,000h,0FFh ; 380D
                DB  0F1h,050h,0F1h,028h,0DAh,00Bh,0C0h,005h ; 3815
                DB  0B3h,000h,080h,0FFh,097h,040h,097h,030h ; 381D
                DB  093h,018h,08Dh,004h,086h,000h,080h,0D0h ; 3825
                DB  000h,044h,044h,073h,028h,080h,087h,0FAh ; 382D
                DB  000h,034h,026h,000h,01Fh,00Fh,000h,0F1h ; 3835
                DB  0E1h,000h,01Fh,00Fh,000h,0F1h,0E1h,000h ; 383D
                DB  0FFh,076h,000h,0C5h,076h,000h,0A7h,076h ; 3845
                DB  000h,092h,096h,000h,07Eh,0C8h,000h,03Fh ; 384D
                DB  080h,002h,000h,080h,002h,0FFh,0A1h,0E0h ; 3855
                DB  0A1h,0C0h,08Ah,0A0h,07Fh,080h,065h,060h ; 385D
                DB  046h,040h,02Ah,000h,000h,057h,009h,0E1h ; 3865
                DB  000h,057h,007h,0AFh,000h,057h,004h,07Dh ; 386D
                DB  000h,057h,008h,0AFh,000h,057h,006h,07Dh ; 3875
                DB  000h,057h,003h,07Dh,000h,04Bh,00Dh,00Ch ; 387D
                DB  0FEh,032h,002h,04Bh,000h,04Bh,021h,02Ah ; 3885
                DB  0F9h,03Ch,003h,04Bh,000h,07Dh,000h,019h ; 388D
                DB  000h,077h,001h,07Dh,000h,032h,000h,077h ; 3895
                DB  001h,07Dh,000h,019h,000h,077h,001h,032h ; 389D
                DB  000h,019h,000h,077h,001h,032h,000h,019h ; 38A5
                DB  000h,077h,001h,015h,000h,019h,000h,077h ; 38AD
                DB  001h,030h,000h,008h,000h,077h,001h,04Bh ; 38B5
                DB  000h,019h,000h,077h,001h,000h,006h,080h ; 38BD
                DB  003h,000h,005h,080h,004h,003h,003h,003h ; 38C5
                DB  0FFh,023h,0C0h,01Bh,080h,012h,040h,008h ; 38CD
                DB  000h,000h,0FFh,0A6h,0D5h,09Dh,0AAh,093h ; 38D5
                DB  070h,080h,040h,05Ch,01Ch,028h,000h,013h ; 38DD
                DB  0FFh,015h,0A7h,033h,092h,040h,068h,066h ; 38E5
                DB  03Fh,0C6h,000h,0C6h,0FFh,047h,0E9h,047h ; 38ED
                DB  0C6h,047h,0A9h,03Fh,090h,039h,046h,017h ; 38F5
                DB  030h,000h,000h,000h,0FFh,025h,0E9h,025h ; 38FD
                DB  0D7h,025h,0C6h,025h,097h,024h,046h,00Eh ; 3905
                DB  030h,000h,000h,000h,008h,001h,004h,001h ; 390D
                DB  0BEh,02Eh,07Ah,000h,0BEh,000h,094h,000h ; 3915
                DB  077h,000h,064h,005h,00Fh,003h,005h,032h ; 391D
                DB  032h,05Fh,001h,0E7h,000h,0FAh,000h,00Ch ; 3925
                DB  001h,05Fh,001h,0EDh,000h,001h,001h,014h ; 392D
                DB  001h,044h,0A9h,032h,062h,0FFh,019h,0C6h ; 3935
                DB  019h,094h,019h,086h,000h,000h,000h,0FFh ; 393D
                DB  097h,0D0h,091h,07Ah,070h,044h,054h,02Eh ; 3945
                DB  043h,000h,043h,094h,000h,05Bh,00Bh,018h ; 394D
                DB  018h,025h,0FFh,0D7h,0C6h,098h,069h,04Ah ; 3955
                DB  000h,000h,030h,080h,012h,05Ah,093h,080h ; 395D
                DB  051h,05Ah,0FFh,08Ah,066h,0F5h,08Ah,066h ; 3965
                DB  0E1h,0EBh,041h,0BAh,03Ah,020h,087h,0A6h ; 396D
                DB  00Eh,028h,0E7h,008h,000h,0E7h,008h,0FFh ; 3975
                DB  08Ah,066h,0F5h,08Ah,066h,0E1h,0EBh,041h ; 397D
                DB  0BAh,03Ah,020h,087h,0A6h,00Eh,028h,0E7h ; 3985
                DB  008h,000h,0E7h,008h,0FFh,0FFh,01Bh,0ABh ; 398D
                DB  000h,015h,08Eh,000h,011h,072h,000h,008h ; 3995
                DB  063h,000h,00Ch,055h,000h,000h,000h,000h ; 399D
                DB  000h,0FFh,000h,008h,0E9h,000h,017h,0D8h ; 39A5
                DB  000h,017h,0CAh,000h,010h,0A9h,000h,00Eh ; 39AD
                DB  090h,000h,000h,000h,000h,000h,0FFh,040h ; 39B5
                DB  004h,0F8h,040h,004h,0F8h,040h,004h,08Eh ; 39BD
                DB  080h,002h,078h,000h,000h,000h,000h,000h ; 39C5
                DB  0F1h,000h,000h,028h,000h,000h,0FFh,091h ; 39CD
                DB  0D0h,091h,07Ah,077h,044h,057h,02Eh,044h ; 39D5
                DB  000h,044h,0FFh,012h,004h,0A1h,012h,004h ; 39DD
                DB  07Ah,0E2h,004h,044h,0A8h,006h,02Eh,0C4h ; 39E5
                DB  009h,000h,0C4h,009h,0C4h,009h,064h,009h ; 39ED
                DB  00Bh,009h,0FFh,000h,00Ah,0F2h,000h,00Ah ; 39F5
                DB  0E1h,000h,006h,0C6h,000h,006h,087h,000h ; 39FD
                DB  00Eh,065h,000h,00Ah,044h,000h,006h,02Eh ; 3A05
                DB  000h,000h,000h,000h,000h,080h,000h,006h ; 3A0D
                DB  028h,080h,008h,080h,080h,006h,028h,000h ; 3A15
                DB  009h,000h,003h,040h,000h,000h,003h,040h ; 3A1D
                DB  000h,001h,000h,000h,000h,000h,000h,000h ; 3A25
                DB  001h,000h,000h,0A0h,001h,0FFh,000h,010h ; 3A2D
                DB  0A9h,000h,00Eh,097h,000h,00Bh,086h,000h ; 3A35
                DB  008h,069h,000h,005h,054h,000h,000h,000h ; 3A3D
                DB  000h,000h,010h,000h,008h,002h,000h,000h ; 3A45
                DB  0FFh,020h,000h,0F5h,020h,000h,0E1h,012h ; 3A4D
                DB  000h,0D7h,01Bh,000h,0FFh,000h,012h,0F2h ; 3A55
                DB  000h,012h,0D0h,000h,00Ah,0A1h,000h,006h ; 3A5D
                DB  056h,000h,004h,044h,080h,004h,02Eh,000h ; 3A65
                DB  006h,020h,000h,009h,000h,000h,009h,030h ; 3A6D
                DB  000h,028h,000h,018h,000h,000h,00Ch,000h ; 3A75
                DB  001h,030h,000h,028h,000h,018h,000h,000h ; 3A7D
                DB  010h,040h,002h,093h,080h,061h,09Dh,0FFh ; 3A85
                DB  0C0h,000h,0E0h,0C0h,000h,0A1h,01Ah,000h ; 3A8D
                DB  02Eh,007h,000h,000h,007h,000h,0FFh,02Eh ; 3A95
                DB  000h,0A1h,02Eh,000h,057h,01Ah,000h,02Eh ; 3A9D
                DB  018h,000h,000h,018h,000h,0FFh,0FFh,000h ; 3AA5
                DB  080h,0FFh,01Bh,000h,078h,060h,016h,010h ; 3AAD
                DB  047h,0C8h,010h,0E0h,03Dh,030h,00Bh,0B0h ; 3AB5
                DB  034h,000h,002h,080h,01Fh,000h,000h,0F0h ; 3ABD
                DB  017h,0FFh,0FFh,08Fh,042h,000h,0FEh,08Fh ; 3AC5
                DB  042h,000h,0FBh,0AEh,067h,000h,0F6h,0C2h ; 3ACD
                DB  075h,000h,0F0h,000h,080h,000h,0E9h,01Eh ; 3AD5
                DB  085h,000h,0E0h,000h,080h,000h,000h,000h ; 3ADD
                DB  080h,0E0h,033h,0A9h,051h,019h,097h,0D8h ; 3AE5
                DB  0DDh,0E5h,0E9h,0FFh,076h,007h,0F0h,076h ; 3AED
                DB  007h,0E0h,076h,007h,0D9h,026h,007h,0D4h ; 3AF5
                DB  05Ch,008h,0CFh,02Ah,008h,000h,02Ah,008h ; 3AFD
                DB  0E7h,008h,023h,00Dh,09Ch,017h,03Bh,033h ; 3B05
                DB  0EBh,041h,030h,001h,038h,001h,09Fh,001h ; 3B0D
                DB  08Ah,002h,024h,003h,068h,0D0h,020h,060h ; 3B15
                DB  0A2h,033h,073h,02Ah,000h,008h,0FFh,040h ; 3B1D
                DB  028h,06Eh,000h,014h,00Fh,00Fh,00Fh,02Dh ; 3B25
                DB  00Fh,006h,02Dh,00Fh,02Dh,04Bh,02Dh,0FFh ; 3B2D
                DB  02Dh,02Dh,0FFh,0FFh,003h,006h,007h,005h ; 3B35
                DB  00Dh,015h,016h,00Ah,00Eh,008h,011h,000h ; 3B3D
                DB  017h,018h,001h,002h,004h,008h,009h,00Fh ; 3B45
                DB  004h,008h,009h,000h,000h,000h,000h,000h ; 3B4D
                DB  000h,000h,077h,011h,0EEh,022h,077h,022h ; 3B55
                DB  0DDh,044h,0FFh,0FFh,0EEh,044h,077h,044h ; 3B5D
                DB  0BBh,088h,0BBh,011h,0FFh,0FFh,0BBh,022h ; 3B65
                DB  0DDh,088h,0DDh,011h,0EEh,088h,000h,000h ; 3B6D
                DB  0C7h,000h,02Dh,02Dh,007h,006h,019h,019h ; 3B75
                DB  019h,000h,0B3h,00Bh,0B3h,00Bh,0FFh,04Bh ; 3B7D
                DB  096h,096h,01Ch,002h,005h,00Ah,00Ah,00Dh ; 3B85
                DB  00Dh,000h,000h,000h,032h,000h,000h,001h ; 3B8D
                DB  020h,001h,003h,001h,020h,001h,019h,001h ; 3B95
                DB  019h,001h,019h,001h,0FFh,001h,0FFh,001h ; 3B9D
                DB  0FFh,040h,010h,010h,010h,010h,010h,010h ; 3BA5
                DB  010h,010h,006h,009h,008h,009h,009h,008h ; 3BAD
                DB  00Fh,00Eh,00Fh,01Ch,01Ch,00Eh,00Fh,00Eh ; 3BB5
                DB  00Eh,00Eh,00Eh,00Fh,00Eh,00Eh,00Eh,00Dh ; 3BBD
                DB  010h,010h,010h,010h,010h,01Bh,007h,007h ; 3BC5
                DB  01Fh,013h,00Ah,00Bh,010h,010h,010h,010h ; 3BCD
                DB  010h,010h,010h,010h,010h,010h,010h,010h ; 3BD5
                DB  010h,010h,010h,010h,010h,010h,010h,010h ; 3BDD
                DB  010h,039h,039h,039h,039h,039h,039h,039h ; 3BE5
                DB  039h,039h,032h,02Ah,024h,00Fh,00Fh,00Fh ; 3BED
                DB  039h,039h,039h,039h,039h,039h,039h,039h ; 3BF5
                DB  039h,034h,02Fh,024h,00Fh,00Fh,00Fh,04Dh ; 3BFD
                DB  04Dh,04Dh,04Dh,04Dh,04Dh,04Dh,049h,044h ; 3C05
                DB  040h,037h,02Ch,019h,011h,011h,053h,053h ; 3C0D
                DB  053h,053h,053h,053h,053h,04Dh,047h,042h ; 3C15
                DB  03Dh,032h,027h,01Bh,01Bh,057h,057h,057h ; 3C1D
                DB  057h,057h,057h,057h,052h,04Dh,049h,043h ; 3C25
                DB  03Ch,02Eh,023h,023h,05Dh,05Dh,05Dh,05Dh ; 3C2D
                DB  05Dh,05Dh,05Dh,059h,055h,051h,04Ah,045h ; 3C35
                DB  034h,02Ah,02Ah,062h,062h,062h,062h,062h ; 3C3D
                DB  062h,062h,05Dh,059h,055h,051h,04Eh,044h ; 3C45
                DB  037h,037h,066h,066h,066h,066h,066h,066h ; 3C4D
                DB  066h,061h,05Ch,058h,054h,050h,049h,041h ; 3C55
                DB  041h,069h,069h,069h,069h,069h,069h,069h ; 3C5D
                DB  065h,060h,05Ch,058h,052h,04Fh,04Ah,04Ah ; 3C65
                DB  06Eh,06Eh,06Eh,06Eh,06Eh,06Eh,06Eh,06Bh ; 3C6D
                DB  068h,064h,060h,05Ch,055h,050h,050h,06Eh ; 3C75
                DB  06Eh,06Eh,06Eh,06Eh,06Eh,06Eh,06Bh,068h ; 3C7D
                DB  064h,060h,05Ch,055h,050h,050h,071h,071h ; 3C85
                DB  071h,071h,071h,071h,071h,06Fh,06Bh,068h ; 3C8D
                DB  064h,060h,058h,050h,050h,071h,071h,071h ; 3C95
                DB  071h,071h,071h,071h,06Fh,06Bh,068h,064h ; 3C9D
                DB  060h,058h,050h,050h,06Fh,06Fh,06Fh,06Fh ; 3CA5
                DB  06Fh,06Fh,06Fh,06Dh,06Bh,068h,065h,05Fh ; 3CAD
                DB  050h,050h,050h,06Fh,06Fh,06Fh,06Fh,06Fh ; 3CB5
                DB  06Fh,06Fh,06Dh,06Bh,068h,065h,05Fh,050h ; 3CBD
                DB  050h,050h,06Fh,06Fh,06Fh,06Fh,06Fh,06Fh ; 3CC5
                DB  06Fh,06Dh,06Bh,068h,065h,05Fh,050h,050h ; 3CCD
                DB  050h,06Fh,06Fh,06Fh,06Fh,06Fh,06Fh,06Fh ; 3CD5
                DB  06Dh,06Bh,068h,065h,05Fh,050h,050h,050h ; 3CDD
                DB  022h,022h,022h,022h,022h,022h,022h,022h ; 3CE5
                DB  022h,022h,022h,022h,00Fh,00Fh,00Fh,039h ; 3CED
                DB  039h,039h,039h,039h,039h,039h,039h,039h ; 3CF5
                DB  032h,02Ah,024h,00Fh,00Fh,00Fh,039h,039h ; 3CFD
                DB  039h,039h,039h,039h,039h,039h,039h,034h ; 3D05
                DB  02Fh,024h,00Fh,00Fh,00Fh,058h,058h,058h ; 3D0D
                DB  058h,058h,057h,056h,055h,052h,04Eh,04Ah ; 3D15
                DB  046h,03Bh,02Fh,02Fh,06Ah,06Ah,06Ah,06Ah ; 3D1D
                DB  06Ah,06Ah,067h,064h,060h,05Ch,059h,055h ; 3D25
                DB  04Dh,046h,046h,06Eh,06Eh,06Eh,06Eh,06Eh ; 3D2D
                DB  06Eh,06Ch,069h,066h,062h,05Fh,05Bh,052h ; 3D35
                DB  04Eh,04Eh,06Eh,06Eh,06Eh,06Eh,06Eh,06Eh ; 3D3D
                DB  06Eh,06Bh,068h,064h,060h,05Ch,054h,050h ; 3D45
                DB  050h,071h,071h,071h,071h,071h,071h,071h ; 3D4D
                DB  06Fh,06Bh,068h,064h,060h,058h,050h,050h ; 3D55
                DB  071h,071h,071h,071h,071h,071h,071h,06Fh ; 3D5D
                DB  06Bh,068h,064h,060h,058h,050h,050h,06Fh ; 3D65
                DB  06Fh,06Fh,06Fh,06Fh,06Fh,06Fh,06Dh,06Bh ; 3D6D
                DB  068h,065h,05Fh,050h,050h,050h,06Fh,06Fh ; 3D75
                DB  06Fh,06Fh,06Fh,06Fh,06Fh,06Dh,06Bh,068h ; 3D7D
                DB  065h,05Fh,050h,050h,050h,06Fh,06Fh,06Fh ; 3D85
                DB  06Fh,06Fh,06Fh,06Fh,06Dh,06Bh,068h,065h ; 3D8D
                DB  05Fh,050h,050h,050h,06Fh,06Fh,06Fh,06Fh ; 3D95
                DB  06Fh,06Fh,06Fh,06Dh,06Bh,068h,065h,05Fh ; 3D9D
                DB  050h,050h,050h,06Fh,06Fh,06Fh,06Fh,06Fh ; 3DA5
                DB  06Fh,06Fh,06Dh,06Bh,068h,065h,05Fh,055h ; 3DAD
                DB  055h,055h,06Fh,06Fh,06Fh,06Fh,06Fh,06Fh ; 3DB5
                DB  06Fh,06Dh,06Bh,068h,065h,05Fh,055h,055h ; 3DBD
                DB  055h,06Fh,06Fh,06Fh,06Fh,06Fh,06Fh,06Fh ; 3DC5
                DB  06Dh,06Bh,068h,065h,05Fh,055h,055h,055h ; 3DCD
                DB  06Fh,06Fh,06Fh,06Fh,06Fh,06Fh,06Fh,06Dh ; 3DD5
                DB  06Bh,068h,065h,05Fh,055h,055h,055h,05Dh ; 3DDD
                DB  04Fh,06Fh,055h,06Dh,08Dh,054h,064h,070h ; 3DE5
                DB  07Ch,089h,04Dh,05Dh,06Fh,081h,05Dh,04Fh ; 3DED
                DB  06Fh,05Ah,077h,093h,059h,067h,073h,07Eh ; 3DF5
                DB  08Fh,04Fh,05Eh,072h,081h,05Dh,053h,086h ; 3DFD
                DB  05Dh,079h,096h,05Ah,068h,073h,080h,08Eh ; 3E05
                DB  04Eh,05Eh,072h,07Ch,05Fh,057h,088h,061h ; 3E0D
                DB  07Ch,097h,05Ch,068h,073h,080h,08Eh,04Eh ; 3E15
                DB  05Eh,074h,07Dh,061h,059h,090h,064h,07Eh ; 3E1D
                DB  09Bh,05Dh,06Ah,076h,083h,091h,050h,061h ; 3E25
                DB  076h,080h,064h,05Eh,09Fh,06Bh,086h,0A1h ; 3E2D
                DB  05Fh,06Dh,07Ah,088h,095h,054h,064h,079h ; 3E35
                DB  083h,06Eh,065h,0A0h,06Dh,087h,0A2h,061h ; 3E3D
                DB  070h,07Eh,089h,09Bh,054h,065h,077h,081h ; 3E45
                DB  076h,06Ch,0A7h,06Fh,08Ch,0A9h,064h,073h ; 3E4D
                DB  081h,08Fh,09Eh,057h,066h,078h,080h,07Bh ; 3E55
                DB  06Fh,0ADh,072h,090h,0ABh,064h,075h,080h ; 3E5D
                DB  08Fh,09Eh,057h,068h,07Bh,08Ah,07Bh,06Ah ; 3E65
                DB  0A6h,071h,08Ch,0AAh,066h,074h,085h,095h ; 3E6D
                DB  0A5h,05Ah,06Bh,081h,091h,082h,073h,0B1h ; 3E75
                DB  075h,094h,0B2h,069h,079h,086h,097h,0A6h ; 3E7D
                DB  05Ch,06Ch,081h,095h,07Fh,070h,0AFh,075h ; 3E85
                DB  092h,0B4h,069h,07Ah,089h,09Ah,0A9h,05Dh ; 3E8D
                DB  06Dh,085h,096h,06Ch,063h,09Ch,06Eh,08Ah ; 3E95
                DB  0AAh,064h,075h,082h,092h,0A3h,05Ah,06Ch ; 3E9D
                DB  080h,094h,082h,077h,0B9h,07Dh,09Eh,0C3h ; 3EA5
                DB  071h,07Fh,095h,0A6h,0BAh,064h,07Ah,082h ; 3EAD
                DB  093h,0BEh,09Ah,0E5h,097h,0BBh,0DFh,082h ; 3EB5
                DB  093h,0A9h,0BCh,0D0h,072h,085h,099h,0ADh ; 3EBD
                DB  0B4h,092h,0DBh,08Fh,0BAh,0DDh,081h,095h ; 3EC5
                DB  0AAh,0BCh,0CFh,072h,086h,09Ah,0AEh,096h ; 3ECD
                DB  08Ah,0C9h,092h,0BEh,0E3h,087h,0A0h,0B5h ; 3ED5
                DB  0C7h,0DAh,074h,08Bh,09Ah,0AAh,000h,001h ; 3EDD
                DB  001h,002h,002h,002h,003h,003h,003h,003h ; 3EE5
                DB  003h,004h,004h,004h,004h,03Fh,035h,066h ; 3EED
                DB  050h,066h,07Ch,04Bh,059h,066h,075h,084h ; 3EF5
                DB  049h,05Bh,06Dh,07Fh,03Fh,035h,066h,050h ; 3EFD
                DB  066h,07Ch,04Bh,059h,066h,075h,084h,049h ; 3F05
                DB  05Bh,06Dh,07Fh,03Fh,035h,066h,050h,066h ; 3F0D
                DB  07Ch,04Bh,059h,066h,075h,084h,049h,05Bh ; 3F15
                DB  06Dh,07Fh,03Fh,035h,066h,050h,066h,07Ch ; 3F1D
                DB  04Bh,059h,066h,075h,084h,049h,05Bh,06Dh ; 3F25
                DB  07Fh,03Fh,035h,066h,050h,066h,07Ch,04Bh ; 3F2D
                DB  059h,066h,075h,084h,049h,05Bh,06Dh,07Fh ; 3F35
                DB  04Eh,044h,060h,045h,05Fh,07Eh,04Fh,05Dh ; 3F3D
                DB  06Dh,07Fh,08Dh,050h,062h,077h,08Ch,05Fh ; 3F45
                DB  050h,084h,063h,080h,0A1h,061h,071h,07Fh ; 3F4D
                DB  091h,0A2h,05Ah,06Fh,083h,097h,049h,03Dh ; 3F55
                DB  06Dh,04Bh,067h,082h,050h,060h,070h,081h ; 3F5D
                DB  092h,052h,066h,080h,096h,055h,048h,077h ; 3F65
                DB  051h,06Bh,088h,053h,064h,074h,087h,09Bh ; 3F6D
                DB  05Bh,072h,083h,094h,067h,062h,0A4h,069h ; 3F75
                DB  089h,0ADh,067h,07Ah,08Dh,09Fh,0B3h,068h ; 3F7D
                DB  07Dh,08Ah,098h,08Fh,07Ah,0C1h,084h,0A9h ; 3F85
                DB  0CFh,07Ah,091h,0A4h,0BBh,0CFh,071h,086h ; 3F8D
                DB  097h,0A8h,0A3h,08Ah,0D5h,091h,0B5h,0DCh ; 3F95
                DB  081h,096h,0ABh,0C1h,0D5h,074h,087h,09Ah ; 3F9D
                DB  0ADh,0AFh,096h,0DFh,099h,0C2h,0E9h,08Bh ; 3FA5
                DB  0A2h,0B7h,0C9h,0DFh,077h,08Bh,09Fh,0B3h ; 3FAD
                DB  0B2h,097h,0DEh,09Ch,0C6h,0F5h,091h,0A9h ; 3FB5
                DB  0BFh,0D4h,0E8h,080h,096h,0A8h,0BAh,085h ; 3FBD
                DB  081h,0BDh,08Eh,0C2h,0FCh,096h,0AFh,0C5h ; 3FC5
                DB  0DDh,0F5h,07Eh,087h,0A9h,0C4h,085h,081h ; 3FCD
                DB  0BDh,08Eh,0C2h,0FCh,096h,0AFh,0C5h,0DDh ; 3FD5
                DB  0F5h,07Eh,087h,0A9h,0C4h,085h,081h,0BDh ; 3FDD
                DB  08Eh,0C2h,0FCh,096h,0AFh,0C5h,0DDh,0F5h ; 3FE5
                DB  07Eh,087h,0A9h,0C4h,000h,001h,001h,002h ; 3FED
                DB  002h,002h,003h,003h,003h,003h,003h,004h ; 3FF5
                DB  004h,004h,004h ; 3FFD

;****************************************************************************
;extra features n stuff. lets make this shit uniform...
;ORG		05000h

;**************
;nocode:			MOV		DP, #nosetcodes			; h ;load the vectoraddy
;
;nocodeloop:		LCB		A, [DP]					; load a code from the vector
;				CMPB	A, #000h				; if its 0 then its the end of the vector
;				JEQ		setcode					; so get out of loop
;				CMPB	A, #0ffh				; also, if its ffh then we are done
;				JEQ		setcode					; get out
;				CMPB	A, r6					; compare loaded code to attempted code
;				JEQ		dontsetcode				; if they are the same then we dont set it
;				INC     DP
;				SJ		nocodeloop				; loop
;
;setcode:		LB		A, r1					; else do the
;				SBR     00130h[X1]				; lines we replaced
;				SBR     0027bh[X1]
;				RT								; jump back
;
;dontsetcode:	RT								; we did not set the code...


;***********************

                ;ORG	0167Ch
                ;MOV     SSP, #0025bh           ; 167C 0 ??? ??? A0986402


                ;ORG 016d9h

                ;MOVB    STTMC, #002h           ; 16D9 0 080 ??? C54A9802
                ;MOVB    STCON, #03ch           ; 16DD 0 080 ??? C550983C
                ;MOVB    SRCON, #02ch           ; 16E1 0 080 ??? C554982C
                ;MOVB    STTM, #0f3h            ; 16E5 0 080 ??? C54898F3
                ;MOVB    STTMR, #0f3h           ; 16E9 0 080 ??? C54998F3
                ;MOVB    SRTMC, #0c0h           ; 16ED 0 080 ??? C54E98C0

ORG		07f00h
;these are the codes that the ecu will not set. ever.
;the vector MUST be ended with a 0
;nosetcodes:		DB	015h,001h,002h,000h

ORG		07f10h
logging_table:  DB  098h,000h ;10 water temp
                DB  099h,000h ;11 IAT
                DB  0b6h,000h ;12 corrected map column
                DB  0b6h,000h ;13 corrected map column
                DB  0B1h,000h ;14 MAP
                DB  0AEh,000h ;15 tps
                DB  0BAh,000h ;16 rpm low
                DB  0BBh,000h ;17 rpm high
                DB  029h,001h ;18 vtec
                DB  0A6h,000h ;19 rpm
                DB  0A7h,000h ;1a rpm
                DB  0B5h,000h ;1b map image - final
                DB  030h,001h ;1c err
                DB  031h,001h ;1d err
                DB  032h,001h ;1e err
                DB  0cbh,000h ;1f speed
                DB  0b4h,000h ;20 map image - before correction

                ;mine
                DB  048h,001h ;21 final fuel - low
                DB  049h,001h ;22 final fuel - high
                DB  067h,000h ;23 ADCR3H -> o2#2 input
                DB  034h,001h ;24 final ignition
                DB  07ch,001h ;25 fuel row in table
                DB  07dh,001h ;26 ignition row in table
                DB  0a1h,000h ;27 primary o2
                DB  0a2h,000h ;28 secondary o2
                DB  0d8h,001h ;29 fuel row interpolation
                DB  0d9h,001h ;2a ignition row interpolation
