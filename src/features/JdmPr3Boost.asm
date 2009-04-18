                org 0000h
int_start_vec:            DW  int_start        ; 0000 7316
int_break_vec:            DW  int_break        ; 0002 9616
int_WDT_vec:              DW  int_WDT          ; 0004 9216
int_NMI_vec:              DW  int_NMI          ; 0006 8F00
int_INT0_vec:             DW  int_INT0         ; 0008 0316
int_serial_rx_vec:        DW  serial_rx_int    ; 000A 6700 ;datalogging change
int_serial_tx_vec:        DW  int_break        ; 000C 9616
int_serial_rx_BRG_vec:    DW  int_serial_rx_BRG; 000E 6B16
int_timer_0_overflow_vec: DW  int_timer_0_overflow; 0010 1F15
int_timer_0_vec:          DW  int_timer_0      ; 0012 2A01
int_timer_1_overflow_vec: DW  int_timer_1_overflow; 0014 4116
int_timer_1_vec:          DW  int_timer_1      ; 0016 CD00
int_timer_2_overflow_vec: DW  int_break        ; 0018 9616
int_timer_2_vec:          DW  int_timer_2      ; 001A D100
int_timer_3_overflow_vec: DW  int_break        ; 001C 9616
int_timer_3_vec:          DW  int_break        ; 001E 9616
int_a2d_finished_vec:     DW  int_break        ; 0020 9616
int_PWM_timer_vec:        DW  int_PWM_timer    ; 0022 C615
int_serial_tx_BRG_vec:    DW  int_break        ; 0024 9616
int_INT1_vec:             DW  int_INT1         ; 0026 F200
vcal_0_vec:               DW  vcal_0           ; 0028 AD2B
vcal_1_vec:               DW  vcal_1           ; 002A 0B2C
vcal_2_vec:               DW  vcal_2           ; 002C E72B
vcal_3_vec:               DW  vcal_3           ; 002E 9B18
vcal_4_vec:               DW  vcal_4           ; 0030 632D
vcal_5_vec:               DW  vcal_5           ; 0032 9C2E
vcal_6_vec:               DW  vcal_6           ; 0034 9E2E
vcal_7_vec:               DW  vcal_7           ; 0036 F92B
code_start:     DB  001h,043h,000h,001h,0E5h,0CEh,0D5h,01Ah ; 0038
                DB  0A2h,018h,042h,055h,067h,000h,001h,0F5h ; 0040
                DB  055h,0C5h,056h,00Bh,0CEh,00Ch,0C5h,006h ; 0048
                DB  02Fh,0C5h,007h,015h,0CAh,004h,0C5h,007h ; 0050
                DB  098h,002h,052h,0F2h,0D5h,051h,065h,052h ; 0058
                DB  0E5h,0CCh,0A2h,008h,0D5h,01Ah,002h ; 0060
                                               ; 0067 from 000A (DD0,???,???)
int_serial_rx:  L       A, 0ceh                ; 0067 1 ??? ??? E5CE
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
                                               ; 008F from 16B5 (DD0,080,???)
int_NMI:        MOV     LRB, #00020h           ; 008F 0 100 ??? 572000
                MB      C, 0f1h.3              ; 0092 0 100 ??? C5F12B
                JGE     label_009a             ; 0095 0 100 ??? CD03
                CAL     label_2eb6             ; 0097 0 100 ??? 32B62E
                                               ; 009A from 0095 (DD0,100,???)
label_009a:     J       label_3570             ; 009A 0 100 ??? 037035
                                               ; 009D from 357D (DD0,100,???)
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
label_00c8:     MOVB    0f0h, #047h            ; 00C8 0 100 ??? C5F09847
                BRK                            ; 00CC 0 100 ??? FF
                                               ; 00CD from 0016 (DD0,???,???)
int_timer_1:    CAL     label_28bb             ; 00CD 0 ??? ??? 32BB28
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
                CAL     label_2c96             ; 00F8 1 ??? ??? 32962C
                JBS     off(07ff30h).7, label_010d ; 00FB 1 ??? ??? EF300F
                JBS     off(07ff30h).3, label_0113 ; 00FE 1 ??? ??? EB3012
                RB      IRQ.7                  ; 0101 1 ??? ??? C5180F
                JEQ     label_0110             ; 0104 1 ??? ??? C90A
                RB      off(07ff2eh).0         ; 0106 1 ??? ??? C42E08
                MOVB    off(07ffbeh), #02dh    ; 0109 1 ??? ??? C4BE982D
                                               ; 010D from 00FB (DD1,???,???)
label_010d:     J       label_03de             ; 010D 1 ??? ??? 03DE03
                                               ; 0110 from 0104 (DD1,???,???)
label_0110:     SB      off(07ff2eh).0         ; 0110 1 ??? ??? C42E18
                                               ; 0113 from 00FE (DD1,???,???)
label_0113:     L       A, ADCR5               ; 0113 1 ??? ??? E56A
                ST      A, 0b0h                ; 0115 1 ??? ??? D5B0
                L       A, TM1                 ; 0117 1 ??? ??? E534
                ST      A, TMR1                ; 0119 1 ??? ??? D536
                LB      A, #001h               ; 011B 0 ??? ??? 7701
                STB     A, 0e4h                ; 011D 0 ??? ??? D5E4
                STB     A, off(07ff9bh)        ; 011F 0 ??? ??? D49B
                SB      P2.4                   ; 0121 0 ??? ??? C5241C
                CAL     label_2943             ; 0124 0 ??? ??? 324329
                J       label_0221             ; 0127 0 ??? ??? 032102
                                               ; 012A from 0012 (DD0,???,???)
int_timer_0:    L       A, IE                  ; 012A 1 ??? ??? E51A
                PUSHS   A                      ; 012C 1 ??? ??? 55
                CAL     label_2c93             ; 012D 1 ??? ??? 32932C
                MOVB    off(07ffbeh), #02dh    ; 0130 1 ??? ??? C4BE982D
                SB      off(07ff20h).0         ; 0134 1 ??? ??? C42018
                JNE     label_0145             ; 0137 1 ??? ??? CE0C
                RB      IRQH.7                 ; 0139 1 ??? ??? C5190F
                RB      off(07ff18h).0         ; 013C 1 ??? ??? C41808
                RB      TRNSIT.0               ; 013F 1 ??? ??? C54608
                J       label_0295             ; 0142 1 ??? ??? 039502
                                               ; 0145 from 0137 (DD1,???,???)
label_0145:     LB      A, 0e3h                ; 0145 0 ??? ??? F5E3
                ADDB    A, #001h               ; 0147 0 ??? ??? 8601
                JBS     off(07ff30h).7, label_0187 ; 0149 0 ??? ??? EF303B
                RB      IRQH.7                 ; 014C 0 ??? ??? C5190F
                JNE     label_0164             ; 014F 0 ??? ??? CE13
                RB      off(07ff18h).0         ; 0151 0 ??? ??? C41808
                JNE     label_0164             ; 0154 0 ??? ??? CE0E
                STB     A, r0                  ; 0156 0 ??? ??? 88
                ANDB    A, #003h               ; 0157 0 ??? ??? D603
                JNE     label_0161             ; 0159 0 ??? ??? CE06
                SB      off(07ff2eh).1         ; 015B 0 ??? ??? C42E19
                SB      off(07ff1ah).0         ; 015E 0 ??? ??? C41A18
                                               ; 0161 from 0159 (DD0,???,???)
label_0161:     LB      A, r0                  ; 0161 0 ??? ??? 78
                SJ      label_0187             ; 0162 0 ??? ??? CB23
                                               ; 0164 from 014F (DD0,???,???)
                                               ; 0164 from 0154 (DD0,???,???)
label_0164:     RB      off(07ff1ah).0         ; 0164 0 ??? ??? C41A08
                MOVB    off(07ffbfh), #02dh    ; 0167 0 ??? ??? C4BF982D
                CMPB    A, #004h               ; 016B 0 ??? ??? C604
                JEQ     label_0186             ; 016D 0 ??? ??? C917
                SB      off(07ff21h).1         ; 016F 0 ??? ??? C42119
                JLT     label_017d             ; 0172 0 ??? ??? CA09
                CMPB    A, #008h               ; 0174 0 ??? ??? C608
                JLT     label_0183             ; 0176 0 ??? ??? CA0B
                                               ; 0178 from 0180 (DD0,???,???)
label_0178:     SB      off(07ff2eh).5         ; 0178 0 ??? ??? C42E1D
                SJ      label_0186             ; 017B 0 ??? ??? CB09
                                               ; 017D from 0172 (DD0,???,???)
label_017d:     JBR     off(07ff9bh).0, label_0183 ; 017D 0 ??? ??? D89B03
                JBS     off(07ff9bh).1, label_0178 ; 0180 0 ??? ??? E99BF5
                                               ; 0183 from 0176 (DD0,???,???)
                                               ; 0183 from 017D (DD0,???,???)
label_0183:     SB      off(07ff2eh).4         ; 0183 0 ??? ??? C42E1C
                                               ; 0186 from 016D (DD0,???,???)
                                               ; 0186 from 017B (DD0,???,???)
label_0186:     CLRB    A                      ; 0186 0 ??? ??? FA
                                               ; 0187 from 0149 (DD0,???,???)
                                               ; 0187 from 0162 (DD0,???,???)
label_0187:     STB     A, 0e3h                ; 0187 0 ??? ??? D5E3
                ANDB    A, #003h               ; 0189 0 ??? ??? D603
                STB     A, 0e4h                ; 018B 0 ??? ??? D5E4
                LB      A, off(07ff9bh)        ; 018D 0 ??? ??? F49B
                ADDB    A, #001h               ; 018F 0 ??? ??? 8601
                JBS     off(07ff31h).0, label_01c4 ; 0191 0 ??? ??? E83130
                RB      TRNSIT.0               ; 0194 0 ??? ??? C54608
                JNE     label_01a7             ; 0197 0 ??? ??? CE0E
                STB     A, r0                  ; 0199 0 ??? ??? 88
                ANDB    A, #00fh               ; 019A 0 ??? ??? D60F
                JNE     label_01a4             ; 019C 0 ??? ??? CE06
                SB      off(07ff2eh).2         ; 019E 0 ??? ??? C42E1A
                SB      off(07ff1ah).1         ; 01A1 0 ??? ??? C41A19
                                               ; 01A4 from 019C (DD0,???,???)
label_01a4:     LB      A, r0                  ; 01A4 0 ??? ??? 78
                SJ      label_01c4             ; 01A5 0 ??? ??? CB1D
                                               ; 01A7 from 0197 (DD0,???,???)
label_01a7:     RB      off(07ff1ah).1         ; 01A7 0 ??? ??? C41A09
                MOVB    off(07ffc0h), #007h    ; 01AA 0 ??? ??? C4C09807
                CMPB    A, #010h               ; 01AE 0 ??? ??? C610
                JEQ     label_01b9             ; 01B0 0 ??? ??? C907
                JGE     label_01c3             ; 01B2 0 ??? ??? CD0F
                JBR     off(07ff21h).1, label_01c0 ; 01B4 0 ??? ??? D92109
                SJ      label_01c3             ; 01B7 0 ??? ??? CB0A
                                               ; 01B9 from 01B0 (DD0,???,???)
label_01b9:     RB      off(07ff21h).1         ; 01B9 0 ??? ??? C42109
                LB      A, 0e4h                ; 01BC 0 ??? ??? F5E4
                JEQ     label_01c4             ; 01BE 0 ??? ??? C904
                                               ; 01C0 from 01B4 (DD0,???,???)
label_01c0:     SB      off(07ff2eh).6         ; 01C0 0 ??? ??? C42E1E
                                               ; 01C3 from 01B2 (DD0,???,???)
                                               ; 01C3 from 01B7 (DD0,???,???)
label_01c3:     CLRB    A                      ; 01C3 0 ??? ??? FA
                                               ; 01C4 from 0191 (DD0,???,???)
                                               ; 01C4 from 01A5 (DD0,???,???)
                                               ; 01C4 from 01BE (DD0,???,???)
label_01c4:     STB     A, off(07ff9bh)        ; 01C4 0 ??? ??? D49B
                ANDB    A, #00fh               ; 01C6 0 ??? ??? D60F
                JNE     label_01df             ; 01C8 0 ??? ??? CE15
                LB      A, 0e7h                ; 01CA 0 ??? ??? F5E7
                JEQ     label_01d3             ; 01CC 0 ??? ??? C905
                DECB    0e7h                   ; 01CE 0 ??? ??? C5E717
                SJ      label_01dc             ; 01D1 0 ??? ??? CB09
                                               ; 01D3 from 01CC (DD0,???,???)
label_01d3:     MOV     DP, #0021ah            ; 01D3 0 ??? ??? 621A02
                MB      C, [DP].0              ; 01D6 0 ??? ??? C228
                LB      A, #001h               ; 01D8 0 ??? ??? 7701
                JGE     label_01dd             ; 01DA 0 ??? ??? CD01
                                               ; 01DC from 01D1 (DD0,???,???)
label_01dc:     CLRB    A                      ; 01DC 0 ??? ??? FA
                                               ; 01DD from 01DA (DD0,???,???)
label_01dd:     STB     A, 0e5h                ; 01DD 0 ??? ??? D5E5
                                               ; 01DF from 01C8 (DD0,???,???)
label_01df:     JBS     off(07ff30h).7, label_01e5 ; 01DF 0 ??? ??? EF3003
                JBR     off(07ff1ah).0, label_01f2 ; 01E2 0 ??? ??? D81A0D
                                               ; 01E5 from 01DF (DD0,???,???)
label_01e5:     ANDB    0e3h, #0fch            ; 01E5 0 ??? ??? C5E3D0FC
                LB      A, off(07ff9bh)        ; 01E9 0 ??? ??? F49B
                ANDB    A, #003h               ; 01EB 0 ??? ??? D603
                ORB     0e3h, A                ; 01ED 0 ??? ??? C5E3E1
                STB     A, 0e4h                ; 01F0 0 ??? ??? D5E4
                                               ; 01F2 from 01E2 (DD0,???,???)
label_01f2:     JBS     off(07ff31h).0, label_01f8 ; 01F2 0 ??? ??? E83103
                JBR     off(07ff1ah).1, label_0201 ; 01F5 0 ??? ??? D91A09
                                               ; 01F8 from 01F2 (DD0,???,???)
label_01f8:     ANDB    off(07ff9bh), #0fch    ; 01F8 0 ??? ??? C49BD0FC
                LB      A, 0e4h                ; 01FC 0 ??? ??? F5E4
                ORB     off(07ff9bh), A        ; 01FE 0 ??? ??? C49BE1
                                               ; 0201 from 01F5 (DD0,???,???)
label_0201:     RC                             ; 0201 0 ??? ??? 95
                JBS     off(07ff30h).7, label_0208 ; 0202 0 ??? ??? EF3003
                JBR     off(07ff1ah).0, label_020e ; 0205 0 ??? ??? D81A06
                                               ; 0208 from 0202 (DD0,???,???)
label_0208:     JBS     off(07ff31h).0, label_0211 ; 0208 0 ??? ??? E83106
                JBS     off(07ff1ah).1, label_0211 ; 020B 0 ??? ??? E91A03
                                               ; 020E from 0205 (DD0,???,???)
label_020e:     JBR     off(07ff31h).6, label_0212 ; 020E 0 ??? ??? DE3101
                                               ; 0211 from 0208 (DD0,???,???)
                                               ; 0211 from 020B (DD0,???,???)
label_0211:     SC                             ; 0211 0 ??? ??? 85
                                               ; 0212 from 020E (DD0,???,???)
label_0212:     MB      off(07ff21h).3, C      ; 0212 0 ??? ??? C4213B
                JGE     label_021a             ; 0215 0 ??? ??? CD03
                SB      0f2h.6                 ; 0217 0 ??? ??? C5F21E
                                               ; 021A from 0215 (DD0,???,???)
label_021a:     JBS     off(07ff1bh).7, label_0221 ; 021A 0 ??? ??? EF1B04
                ANDB    off(07ff2eh), #08fh    ; 021D 0 ??? ??? C42ED08F
                                               ; 0221 from 0127 (DD0,???,???)
                                               ; 0221 from 021A (DD0,???,???)
label_0221:     JBS     off(07ff1fh).4, label_0295 ; 0221 0 ??? ??? EC1F71
                JBS     off(07ff21h).2, label_0246 ; 0224 0 ??? ??? EA211F
                MOV     DP, #0019ah            ; 0227 0 ??? ??? 629A01
                LB      A, 0e5h                ; 022A 0 ??? ??? F5E5
                SRLB    A                      ; 022C 0 ??? ??? 63
                LB      A, off(07ff9bh)        ; 022D 0 ??? ??? F49B
                JLT     label_0233             ; 022F 0 ??? ??? CA02
                ADDB    A, #004h               ; 0231 0 ??? ??? 8604
                                               ; 0233 from 022F (DD0,???,???)
label_0233:     ANDB    A, #007h               ; 0233 0 ??? ??? D607
                CMPB    A, [DP]                ; 0235 0 ??? ??? C2C2
                JNE     label_0295             ; 0237 0 ??? ??? CE5C
                LB      A, off(07ff99h)        ; 0239 0 ??? ??? F499
                CMPB    A, [DP]                ; 023B 0 ??? ??? C2C2
                JEQ     label_0246             ; 023D 0 ??? ??? C907
                DECB    [DP]                   ; 023F 0 ??? ??? C217
                JLT     label_0246             ; 0241 0 ??? ??? CA03
                ADDB    [DP], #002h            ; 0243 0 ??? ??? C28002
                                               ; 0246 from 0224 (DD0,???,???)
                                               ; 0246 from 023D (DD0,???,???)
                                               ; 0246 from 0241 (DD0,???,???)
label_0246:     CLR     A                      ; 0246 1 ??? ??? F9
                LB      A, 0e5h                ; 0247 0 ??? ??? F5E5
                SLLB    A                      ; 0249 0 ??? ??? 53
                MOV     DP, A                  ; 024A 0 ??? ??? 52
                ANDB    A, #002h               ; 024B 0 ??? ??? D602
                MOV     X1, A                  ; 024D 0 ??? ??? 50
                MOV     er0, 00162h[X1]        ; 024E 0 ??? ??? B0620148
                L       A, 001c8h[X1]          ; 0252 1 ??? ??? E0C801
                JNE     label_0266             ; 0255 1 ??? ??? CE0F
                L       A, er0                 ; 0257 1 ??? ??? 34
                CMP     A, #0b6e0h             ; 0258 1 ??? ??? C6E0B6
                JGE     label_0262             ; 025B 1 ??? ??? CD05
                CMP     A, #05720h             ; 025D 1 ??? ??? C62057
                JGT     label_0265             ; 0260 1 ??? ??? C803
                                               ; 0262 from 025B (DD1,???,???)
label_0262:     L       A, #08000h             ; 0262 1 ??? ??? 670080
                                               ; 0265 from 0260 (DD1,???,???)
label_0265:     ST      A, er0                 ; 0265 1 ??? ??? 88
                                               ; 0266 from 0255 (DD1,???,???)
label_0266:     SRL     X1                     ; 0266 1 ??? ??? 90E7
                LB      A, 0011bh[X1]          ; 0268 0 ??? ??? F01B01
                SRLB    A                      ; 026B 0 ??? ??? 63
                JGE     label_0275             ; 026C 0 ??? ??? CD07
                CLR     A                      ; 026E 1 ??? ??? F9
                LC      A, 03018h[DP]          ; 026F 1 ??? ??? 92A91830
                ADD     er0, A                 ; 0273 1 ??? ??? 4481
                                               ; 0275 from 026C (DD0,???,???)
label_0275:     L       A, off(07ff44h)        ; 0275 1 ??? ??? E444
                MUL                            ; 0277 1 ??? ??? 9035
                SLL     A                      ; 0279 1 ??? ??? 53
                L       A, er1                 ; 027A 1 ??? ??? 35
                ROL     A                      ; 027B 1 ??? ??? 33
                JLT     label_0282             ; 027C 1 ??? ??? CA04
                ADD     A, off(07ff46h)        ; 027E 1 ??? ??? 8746
                JGE     label_0285             ; 0280 1 ??? ??? CD03
                                               ; 0282 from 027C (DD1,???,???)
label_0282:     L       A, #0ffffh             ; 0282 1 ??? ??? 67FFFF
                                               ; 0285 from 0280 (DD1,???,???)
label_0285:     ST      A, 0d6h                ; 0285 1 ??? ??? D5D6
                CAL     label_295f             ; 0287 1 ??? ??? 325F29
                MOV     LRB, #00022h           ; 028A 1 110 ??? 572200
                LB      A, 0e5h                ; 028D 0 110 ??? F5E5
                ADDB    A, #001h               ; 028F 0 110 ??? 8601
                ANDB    A, #003h               ; 0291 0 110 ??? D603
                STB     A, 0e5h                ; 0293 0 110 ??? D5E5
                                               ; 0295 from 0142 (DD1,???,???)
                                               ; 0295 from 0221 (DD0,???,???)
                                               ; 0295 from 0237 (DD0,???,???)
label_0295:     L       A, TMR1                ; 0295 1 ??? ??? E536
                ST      A, er0                 ; 0297 1 ??? ??? 88
                SUB     A, 0e0h                ; 0298 1 ??? ??? B5E0A2
                JBR     off(07ff21h).2, label_02c1 ; 029B 1 ??? ??? DA2123
                JBS     off(07ff1eh).7, label_02b4 ; 029E 1 ??? ??? EF1E13
                JBR     off(07ff1eh).6, label_02b5 ; 02A1 1 ??? ??? DE1E11
                JLT     label_02b5             ; 02A4 1 ??? ??? CA0F
                SJ      label_02b4             ; 02A6 1 ??? ??? CB0C
                DB  0CAh,00Bh,0C5h,018h,02Eh,0CDh,006h,0C5h ; 02A8
                DB  0E1h,02Fh,0CAh,001h ; 02B0
                                               ; 02B4 from 029E (DD1,???,???)
                                               ; 02B4 from 02A6 (DD1,???,???)
label_02b4:     CLR     A                      ; 02B4 1 ??? ??? F9
                                               ; 02B5 from 02A1 (DD1,???,???)
                                               ; 02B5 from 02A4 (DD1,???,???)
label_02b5:     MOV     USP, #0020dh           ; 02B5 1 ??? 20D A1980D02
                PUSHU   A                      ; 02B9 1 ??? 20B 76
                PUSHU   A                      ; 02BA 1 ??? 209 76
                PUSHU   A                      ; 02BB 1 ??? 207 76
                PUSHU   A                      ; 02BC 1 ??? 205 76
                ST      A, 0b8h                ; 02BD 1 ??? 205 D5B8
                SJ      label_02d3             ; 02BF 1 ??? 205 CB12
                                               ; 02C1 from 029B (DD1,???,???)
label_02c1:     MB      C, TCON1.2             ; 02C1 1 ??? ??? C5412A
                JGE     label_02c7             ; 02C4 1 ??? ??? CD01
                CLR     A                      ; 02C6 1 ??? ??? F9
                                               ; 02C7 from 02C4 (DD1,???,???)
label_02c7:     ST      A, 0b8h                ; 02C7 1 ??? ??? D5B8
                LB      A, 0e4h                ; 02C9 0 ??? ??? F5E4
                SLLB    A                      ; 02CB 0 ??? ??? 53
                EXTND                          ; 02CC 1 ??? ??? F8
                MOV     X1, A                  ; 02CD 1 ??? ??? 50
                L       A, 0b8h                ; 02CE 1 ??? ??? E5B8
                ST      A, 00206h[X1]          ; 02D0 1 ??? ??? D00602
                                               ; 02D3 from 02BF (DD1,???,205)
label_02d3:     L       A, er0                 ; 02D3 1 ??? ??? 34
                ST      A, 0e0h                ; 02D4 1 ??? ??? D5E0
                SLL     A                      ; 02D6 1 ??? ??? 53
                JLT     label_02df             ; 02D7 1 ??? ??? CA06
                MB      C, IRQ.6               ; 02D9 1 ??? ??? C5182E
                MB      0f1h.4, C              ; 02DC 1 ??? ??? C5F13C
                                               ; 02DF from 02D7 (DD1,???,???)
label_02df:     ANDB    off(07ff1eh), #03fh    ; 02DF 1 ??? ??? C41ED03F
                LB      A, 0e4h                ; 02E3 0 ??? ??? F5E4
                JEQ     label_02fa             ; 02E5 0 ??? ??? C913
                CMPB    A, #003h               ; 02E7 0 ??? ??? C603
                JEQ     label_0352             ; 02E9 0 ??? ??? C967
                JBS     off(07ff18h).1, label_0345 ; 02EB 0 ??? ??? E91857
                MOV     USP, #00206h           ; 02EE 0 ??? 206 A1980602
                CLR     er2                    ; 02F2 0 ??? 206 4615
                CMPB    A, #001h               ; 02F4 0 ??? 206 C601
                JEQ     label_032f             ; 02F6 0 ??? 206 C937
                SJ      label_034c             ; 02F8 0 ??? 206 CB52
                                               ; 02FA from 02E5 (DD0,???,???)
label_02fa:     LB      A, #012h               ; 02FA 0 ??? ??? 7712
                JBR     off(07ff18h).1, label_0301 ; 02FC 0 ??? ??? D91802
                LB      A, #00bh               ; 02FF 0 ??? ??? 770B
                                               ; 0301 from 02FC (DD0,???,???)
label_0301:     CMPB    A, 0bbh                ; 0301 0 ??? ??? C5BBC2
                MB      off(07ff18h).1, C      ; 0304 0 ??? ??? C41839
                JGE     label_031a             ; 0307 0 ??? ??? CD11
                CMPB    0e8h, #014h            ; 0309 0 ??? ??? C5E8C014
                JNE     label_0312             ; 030D 0 ??? ??? CE03
                SB      off(07ff19h).7         ; 030F 0 ??? ??? C4191F
                                               ; 0312 from 030D (DD0,???,???)
label_0312:     RC                             ; 0312 0 ??? ??? 95
                JBS     off(07ff19h).7, label_031a ; 0313 0 ??? ??? EF1904
                LB      A, #028h               ; 0316 0 ??? ??? 7728
                CMPB    A, off(07ffbfh)        ; 0318 0 ??? ??? C7BF
                                               ; 031A from 0307 (DD0,???,???)
                                               ; 031A from 0313 (DD0,???,???)
label_031a:     MB      P2.4, C                ; 031A 0 ??? ??? C5243C
                CAL     label_2943             ; 031D 0 ??? ??? 324329
                MOV     DP, #08000h            ; 0320 0 ??? ??? 620080
                LB      A, P1                  ; 0323 0 ??? ??? F522
                STB     A, ALRB                ; 0325 0 ??? ??? D502
                CAL     label_2d98             ; 0327 0 ??? ??? 32982D
                MOV     LRB, #00022h           ; 032A 0 110 ??? 572200
                SJ      label_0377             ; 032D 0 110 ??? CB48
                                               ; 032F from 02F6 (DD0,???,206)
label_032f:     MOV     er0, (0020ch-00206h)[USP] ; 032F 0 ??? 206 B30648
                JBR     off(07ff19h).1, label_033a ; 0332 0 ??? 206 D91905
                MOV     er2, er0               ; 0335 0 ??? 206 444A
                                               ; 0337 from 034C (DD0,???,206)
label_0337:     MOV     er0, (00206h-00206h)[USP] ; 0337 0 ??? 206 B30048
                                               ; 033A from 0332 (DD0,???,206)
label_033a:     LB      A, off(07ff36h)        ; 033A 0 ??? 206 F436
                STB     A, ACCH                ; 033C 0 ??? 206 D507
                CLRB    A                      ; 033E 0 ??? 206 FA
                MUL                            ; 033F 0 ??? 206 9035
                L       A, er2                 ; 0341 1 ??? 206 36
                ADD     A, er1                 ; 0342 1 ??? 206 09
                JGE     label_0348             ; 0343 1 ??? 206 CD03
                                               ; 0345 from 02EB (DD0,???,???)
label_0345:     L       A, #0ffffh             ; 0345 1 ??? ??? 67FFFF
                                               ; 0348 from 0343 (DD1,???,206)
                                               ; 0348 from 0350 (DD1,???,206)
label_0348:     ST      A, 0dah                ; 0348 1 ??? ??? D5DA
                SJ      label_0377             ; 034A 1 ??? ??? CB2B
                                               ; 034C from 02F8 (DD0,???,206)
label_034c:     JBS     off(07ff19h).1, label_0337 ; 034C 0 ??? 206 E919E8
                CLR     A                      ; 034F 1 ??? 206 F9
                SJ      label_0348             ; 0350 1 ??? 206 CBF6
                                               ; 0352 from 02E9 (DD0,???,???)
label_0352:     CLR     A                      ; 0352 1 ??? ??? F9
                CLRB    A                      ; 0353 0 ??? ??? FA
                STB     A, r1                  ; 0354 0 ??? ??? 89
                SUBB    A, off(07ff35h)        ; 0355 0 ??? ??? A735
                L       A, ACC                 ; 0357 1 ??? ??? E506
                SLL     A                      ; 0359 1 ??? ??? 53
                MOVB    r0, off(07ff34h)       ; 035A 1 ??? ??? C43448
                SUB     A, er0                 ; 035D 1 ??? ??? 28
                SLL     A                      ; 035E 1 ??? ??? 53
                CMPB    ACCH, #0feh            ; 035F 1 ??? ??? C507C0FE
                JNE     label_0368             ; 0363 1 ??? ??? CE03
                L       A, #0ff00h             ; 0365 1 ??? ??? 6700FF
                                               ; 0368 from 0363 (DD1,???,???)
label_0368:     ST      A, 0deh                ; 0368 1 ??? ??? D5DE
                LB      A, off(07ff34h)        ; 036A 0 ??? ??? F434
                XORB    A, #0ffh               ; 036C 0 ??? ??? F6FF
                SLLB    A                      ; 036E 0 ??? ??? 53
                INCB    ACC                    ; 036F 0 ??? ??? C50616
                STB     A, off(07ff36h)        ; 0372 0 ??? ??? D436
                MB      off(07ff19h).1, C      ; 0374 0 ??? ??? C41939
                                               ; 0377 from 032D (DD0,110,???)
                                               ; 0377 from 034A (DD1,???,???)
label_0377:     MOV     er2, #0001eh           ; 0377 0 ??? ??? 46981E00
                LB      A, 0dfh                ; 037B 0 ??? ??? F5DF
                CMPB    A, #0ffh               ; 037D 0 ??? ??? C6FF
                JEQ     label_0383             ; 037F 0 ??? ??? C902
                SUBB    A, #001h               ; 0381 0 ??? ??? A601
                                               ; 0383 from 037F (DD0,???,???)
label_0383:     ANDB    A, #003h               ; 0383 0 ??? ??? D603
                CLRB    r7                     ; 0385 0 ??? ??? 2715
                CMPB    0e4h, #001h            ; 0387 0 ??? ??? C5E4C001
                JNE     label_0391             ; 038B 0 ??? ??? CE04
                CMPB    A, #002h               ; 038D 0 ??? ??? C602
                JEQ     label_0397             ; 038F 0 ??? ??? C906
                                               ; 0391 from 038B (DD0,???,???)
label_0391:     CMPB    A, 0e4h                ; 0391 0 ??? ??? C5E4C2
                JNE     label_03d5             ; 0394 0 ??? ??? CE3F
                INCB    r7                     ; 0396 0 ??? ??? AF
                                               ; 0397 from 038F (DD0,???,???)
label_0397:     LB      A, 0deh                ; 0397 0 ??? ??? F5DE
                STB     A, ACCH                ; 0399 0 ??? ??? D507
                CLRB    A                      ; 039B 0 ??? ??? FA
                MOV     er0, 0b8h              ; 039C 0 ??? ??? B5B848
                MUL                            ; 039F 0 ??? ??? 9035
                CMPB    0dfh, #0ffh            ; 03A1 0 ??? ??? C5DFC0FF
                JNE     label_03c6             ; 03A5 0 ??? ??? CE1F
                L       A, TM2                 ; 03A7 1 ??? ??? E538
                SUB     A, TMR1                ; 03A9 1 ??? ??? B536A2
                ADD     A, #00010h             ; 03AC 1 ??? ??? 861000
                CMP     A, er1                 ; 03AF 1 ??? ??? 49
                JLT     label_03bc             ; 03B0 1 ??? ??? CA0A
                SB      TCON2.2                ; 03B2 1 ??? ??? C5421A
                L       A, TM2                 ; 03B5 1 ??? ??? E538
                SUB     A, #00001h             ; 03B7 1 ??? ??? A60100
                SJ      label_03bf             ; 03BA 1 ??? ??? CB03
                                               ; 03BC from 03B0 (DD1,???,???)
label_03bc:     L       A, TMR1                ; 03BC 1 ??? ??? E536
                ADD     A, er1                 ; 03BE 1 ??? ??? 09
                                               ; 03BF from 03BA (DD1,???,???)
label_03bf:     SB      TCON2.3                ; 03BF 1 ??? ??? C5421B
                ST      A, TMR2                ; 03C2 1 ??? ??? D53A
                SJ      label_03d5             ; 03C4 1 ??? ??? CB0F
                                               ; 03C6 from 03A5 (DD0,???,???)
label_03c6:     CLR     A                      ; 03C6 1 ??? ??? F9
                JBS     off(07ff17h).0, label_03cc ; 03C7 1 ??? ??? E81702
                L       A, 0b8h                ; 03CA 1 ??? ??? E5B8
                                               ; 03CC from 03C7 (DD1,???,???)
label_03cc:     ADD     A, er1                 ; 03CC 1 ??? ??? 09
                JGE     label_03d2             ; 03CD 1 ??? ??? CD03
                L       A, #0ffffh             ; 03CF 1 ??? ??? 67FFFF
                                               ; 03D2 from 03CD (DD1,???,???)
label_03d2:     CMP     A, er2                 ; 03D2 1 ??? ??? 4A
                JGE     label_03d6             ; 03D3 1 ??? ??? CD01
                                               ; 03D5 from 0394 (DD0,???,???)
                                               ; 03D5 from 03C4 (DD1,???,???)
label_03d5:     L       A, er2                 ; 03D5 1 ??? ??? 36
                                               ; 03D6 from 03D3 (DD1,???,???)
label_03d6:     ST      A, 0d8h                ; 03D6 1 ??? ??? D5D8
                LB      A, 0e4h                ; 03D8 0 ??? ??? F5E4
                CMPB    A, #001h               ; 03DA 0 ??? ??? C601
                JEQ     label_03e4             ; 03DC 0 ??? ??? C906
                                               ; 03DE from 010D (DD1,???,???)
                                               ; 03DE from 03E4 (DD0,???,???)
                                               ; 03DE from 040E (DD0,???,???)
label_03de:     RB      PSWH.0                 ; 03DE 1 ??? ??? A208
                                               ; 03E0 from 151C (DD0,108,13C)
label_03e0:     POPS    A                      ; 03E0 1 ??? ??? 65
                ST      A, IE                  ; 03E1 1 ??? ??? D51A
                RTI                            ; 03E3 1 ??? ??? 02
                                               ; 03E4 from 03DC (DD0,???,???)
label_03e4:     JBS     off(07ff19h).0, label_03de ; 03E4 0 ??? ??? E819F7
                L       A, #000e0h             ; 03E7 1 ??? ??? 67E000
                JBR     off(07ff1eh).3, label_03f0 ; 03EA 1 ??? ??? DB1E03
                L       A, #000f0h             ; 03ED 1 ??? ??? 67F000
                                               ; 03F0 from 03EA (DD1,???,???)
label_03f0:     CMP     0bah, A                ; 03F0 1 ??? ??? B5BAC1
                MOVB    r0, #003h              ; 03F3 1 ??? ??? 9803
                MB      off(07ff1eh).3, C      ; 03F5 1 ??? ??? C41E3B
                JLT     label_040b             ; 03F8 1 ??? ??? CA11
                LB      A, #0cfh               ; 03FA 0 ??? ??? 77CF
                JBR     off(07ff1eh).2, label_0401 ; 03FC 0 ??? ??? DA1E02
                LB      A, #0cbh               ; 03FF 0 ??? ??? 77CB
                                               ; 0401 from 03FC (DD0,???,???)
label_0401:     CMPB    A, 0a6h                ; 0401 0 ??? ??? C5A6C2
                MOVB    r0, #001h              ; 0404 0 ??? ??? 9801
                MB      off(07ff1eh).2, C      ; 0406 0 ??? ??? C41E3A
                JGE     label_0410             ; 0409 0 ??? ??? CD05
                                               ; 040B from 03F8 (DD1,???,???)
label_040b:     LB      A, 0e5h                ; 040B 0 ??? ??? F5E5
                ANDB    A, r0                  ; 040D 0 ??? ??? 58
                JNE     label_03de             ; 040E 0 ??? ??? CECE
                                               ; 0410 from 0409 (DD0,???,???)
label_0410:     MOV     PSW, #00001h           ; 0410 0 ??? ??? B504980100
                SB      off(07ff19h).0         ; 0415 0 ??? ??? C41918
                L       A, 0cch                ; 0418 1 ??? ??? E5CC
                ST      A, IE                  ; 041A 1 ??? ??? D51A
                SB      PSWH.0                 ; 041C 1 ??? ??? A218
                MOV     LRB, #00021h           ; 041E 1 108 ??? 572100
                MOV     DP, #00206h            ; 0421 1 108 ??? 620602
                CLR     A                      ; 0424 1 108 ??? F9
                ST      A, er0                 ; 0425 1 108 ??? 88
                ST      A, er1                 ; 0426 1 108 ??? 89
                                               ; 0427 from 0435 (DD1,108,???)
label_0427:     L       A, [DP]                ; 0427 1 108 ??? E2
                JEQ     label_0444             ; 0428 1 108 ??? C91A
                ADD     er0, A                 ; 042A 1 108 ??? 4481
                ADCB    r2, #000h              ; 042C 1 108 ??? 229000
                INC     DP                     ; 042F 1 108 ??? 72
                INC     DP                     ; 0430 1 108 ??? 72
                CMP     DP, #0020eh            ; 0431 1 108 ??? 92C00E02
                JNE     label_0427             ; 0435 1 108 ??? CEF0
                RORB    r2                     ; 0437 1 108 ??? 22C7
                ROR     er0                    ; 0439 1 108 ??? 44C7
                RORB    r2                     ; 043B 1 108 ??? 22C7
                ROR     er0                    ; 043D 1 108 ??? 44C7
                RB      off(0011eh).5          ; 043F 1 108 ??? C41E0D
                SJ      label_044b             ; 0442 1 108 ??? CB07
                                               ; 0444 from 0428 (DD1,108,???)
label_0444:     MOV     er0, #0ffffh           ; 0444 1 108 ??? 4498FFFF
                SB      off(0011fh).0          ; 0448 1 108 ??? C41F18
                                               ; 044B from 0442 (DD1,108,???)
label_044b:     MOV     USP, #0020eh           ; 044B 1 108 20E A1980E02
                MOV     er3, (00212h-0020eh)[USP] ; 044F 1 108 20E B3044B
                L       A, (00210h-0020eh)[USP] ; 0452 1 108 20E E302
                ST      A, (00212h-0020eh)[USP] ; 0454 1 108 20E D304
                L       A, (0020eh-0020eh)[USP] ; 0456 1 108 20E E300
                ST      A, (00210h-0020eh)[USP] ; 0458 1 108 20E D302
                L       A, 0bah                ; 045A 1 108 20E E5BA
                ST      A, (0020eh-0020eh)[USP] ; 045C 1 108 20E D300
                L       A, er0                 ; 045E 1 108 20E 34
                ST      A, 0bah                ; 045F 1 108 20E D5BA
                SUB     A, er3                 ; 0461 1 108 20E 2B
                MB      off(0011eh).4, C       ; 0462 1 108 20E C41E3C
                JGE     label_046a             ; 0465 1 108 20E CD03
                ST      A, er0                 ; 0467 1 108 20E 88
                CLR     A                      ; 0468 1 108 20E F9
                SUB     A, er0                 ; 0469 1 108 20E 28
                                               ; 046A from 0465 (DD1,108,20E)
label_046a:     ST      A, 0bch                ; 046A 1 108 20E D5BC
                MOV     er2, 0bah              ; 046C 1 108 20E B5BA4A
                LB      A, r5                  ; 046F 0 108 20E 7D
                JNE     label_047b             ; 0470 0 108 20E CE09
                LB      A, r4                  ; 0472 0 108 20E 7C
                CMPB    A, #0bbh               ; 0473 0 108 20E C6BB
                LB      A, #0ffh               ; 0475 0 108 20E 77FF
                JLT     label_04b6             ; 0477 0 108 20E CA3D
                SJ      label_04b4             ; 0479 0 108 20E CB39
                                               ; 047B from 0470 (DD0,108,20E)
label_047b:     CMPB    A, #010h               ; 047B 0 108 20E C610
                JGE     label_04aa             ; 047D 0 108 20E CD2B
                SWAPB                          ; 047F 0 108 20E 83
                MOV     er3, #0ffc0h           ; 0480 0 108 20E 4798C0FF
                MOV     er0, #00008h           ; 0484 0 108 20E 44980800
                MOV     DP, #00004h            ; 0488 0 108 20E 620400
                                               ; 048B from 0494 (DD0,108,20E)
label_048b:     SLLB    A                      ; 048B 0 108 20E 53
                JLT     label_0496             ; 048C 0 108 20E CA08
                SRL     er0                    ; 048E 0 108 20E 44E7
                ADD     er3, #00040h           ; 0490 0 108 20E 47804000
                JRNZ    DP, label_048b         ; 0494 0 108 20E 30F5
                                               ; 0496 from 048C (DD0,108,20E)
label_0496:     CLR     A                      ; 0496 1 108 20E F9
                DIV                            ; 0497 1 108 20E 9037
                SRL     A                      ; 0499 1 108 20E 63
                MB      PSWL.4, C              ; 049A 1 108 20E A33C
                ADD     er3, A                 ; 049C 1 108 20E 4781
                LB      A, r7                  ; 049E 0 108 20E 7F
                JNE     label_04b4             ; 049F 0 108 20E CE13
                LB      A, r6                  ; 04A1 0 108 20E 7E
                JEQ     label_04ae             ; 04A2 0 108 20E C90A
                CMPB    A, #0ffh               ; 04A4 0 108 20E C6FF
                JGE     label_04b4             ; 04A6 0 108 20E CD0C
                SJ      label_04b8             ; 04A8 0 108 20E CB0E
                                               ; 04AA from 047D (DD0,108,20E)
label_04aa:     CLRB    A                      ; 04AA 0 108 20E FA
                JBS     off(0011eh).5, label_04b0 ; 04AB 0 108 20E ED1E02
                                               ; 04AE from 04A2 (DD0,108,20E)
label_04ae:     LB      A, #001h               ; 04AE 0 108 20E 7701
                                               ; 04B0 from 04AB (DD0,108,20E)
label_04b0:     RB      PSWL.4                 ; 04B0 0 108 20E A30C
                SJ      label_04b8             ; 04B2 0 108 20E CB04
                                               ; 04B4 from 0479 (DD0,108,20E)
                                               ; 04B4 from 049F (DD0,108,20E)
                                               ; 04B4 from 04A6 (DD0,108,20E)
label_04b4:     LB      A, #0feh               ; 04B4 0 108 20E 77FE
                                               ; 04B6 from 0477 (DD0,108,20E)
label_04b6:     SB      PSWL.4                 ; 04B6 0 108 20E A31C
                                               ; 04B8 from 04A8 (DD0,108,20E)
                                               ; 04B8 from 04B2 (DD0,108,20E)
label_04b8:     STB     A, 0a6h                ; 04B8 0 108 20E D5A6
                MB      C, PSWL.4              ; 04BA 0 108 20E A32C
                MB      off(00129h).1, C       ; 04BC 0 108 20E C42939
                CLRB    r7                     ; 04BF 0 108 20E 2715
                JBS     off(0011eh).5, label_04d7 ; 04C1 0 108 20E ED1E13
                DECB    r7                     ; 04C4 0 108 20E BF
                MOV     er2, 0bah              ; 04C5 0 108 20E B5BA4A
                MOV     er0, #0d000h           ; 04C8 0 108 20E 449800D0
                CLR     A                      ; 04CC 1 108 20E F9
                DIV                            ; 04CD 1 108 20E 9037
                LB      A, r1                  ; 04CF 0 108 20E 79
                JNE     label_04d7             ; 04D0 0 108 20E CE05
                LB      A, r0                  ; 04D2 0 108 20E 78
                JNE     label_04d8             ; 04D3 0 108 20E CE03
                MOVB    r7, #001h              ; 04D5 0 108 20E 9F01
                                               ; 04D7 from 04C1 (DD0,108,20E)
                                               ; 04D7 from 04D0 (DD0,108,20E)
label_04d7:     LB      A, r7                  ; 04D7 0 108 20E 7F
                                               ; 04D8 from 04D3 (DD0,108,20E)
label_04d8:     STB     A, 0a7h                ; 04D8 0 108 20E D5A7
                JBS     off(00130h).2, label_04e0 ; 04DA 0 108 20E EA3003
                JBR     off(00130h).4, label_04ec ; 04DD 0 108 20E DC300C

                ;tps usage
                                               ; 04E0 from 04DA (DD0,108,20E)
label_04e0:     LB      A, 0ach                ; 04E4 0 108 20E F5AC
                MOV     X1, #tpsscalar         ; 04E6 0 108 20E 605A34
                VCAL    1                      ; 04E9 0 108 20E 12
                SJ      set_column			   ; 04EA 0 108 20E CB2B

                NOP
				NOP
				NOP
				NOP
				NOP
				NOP
				NOP
				NOP
				NOP
				NOP
				NOP

                ;map sensor stuff
                                               ; 04EC from 04DD (DD0,108,20E)
label_04ec:     L       A, 0b0h                ; load raw map sensor
                SWAP                           ; AL = raw map high byte
                LB      A, ACC                 ; dd = 0
                CMPB    A, #0ffh               ; ffh for boost; compare raw map high with ffh
                JGT     label_04f9             ; if its > ffh then error
                CMPB    A, #004h               ; compare to something low
                JGE     mapgood		           ; if 0bh<=AL<=ffh we jump to the good stuff

                                               ; 04F9 from 04F3 error cond.
label_04f9:     SC                             ; set carry for error settage
                SJ      label_051a             ; jump over map calc stuff

                ;
mapgood:		MOV		X1, #mapscalar			;
				VCAL	1						;interpolation on my map scalars
set_column:		ST      A, er1					;store the calced val

				;get the real column
				SRL		A						;
				SRL		A						;
				SRL		A						;
				SRL		A						;now we have the column
				LB      A, ACC					;
				STB		A, 0b2h					;store the column for later

				CAL		calcb3h



                                               ; 0517 from 04EA (DD0,108,20E)
                                               ; 0517 from 0508 (DD0,108,20E)
                                               ; 0517 from 050B (DD0,108,20E)
                                               ; 0517 from 0513 (DD0,108,20E)
mapstore:		STB     A, 0b3h                ; 0517 0 108 20E D5B3
                RC                             ; 0519 0 108 20E 95
                ;done w/map stuff

                                               ; 051A from 04FA (DD0,108,20E)
label_051a:     MB      off(0012ch).0, C       ; 051A 0 108 20E C42C38

                LB      A, off(001fch)         ; 051D 0 108 20E F4FC
                JEQ     label_052d             ; 051F 0 108 20E C90C
                LB      A, 0b3h                ; 0521 0 108 20E F5B3
                STB     A, 0b7h                ; 0523 0 108 20E D5B7
                                               ; 0525 from 0553 (DD1,108,20E)
label_0525:     L       A, 0bah                ; 0525 1 108 20E E5BA
                ST      A, 0beh                ; 0527 1 108 20E D5BE
                ST      A, 0c0h                ; 0529 1 108 20E D5C0
                SJ      label_058a             ; 052B 1 108 20E CB5D
                                               ; 052D from 051F (DD0,108,20E)
label_052d:     CLR     A                      ; 052D 1 108 20E F9
                MOV     DP, #000b6h            ; 052E 1 108 20E 62B600
                MOV     er0, #08000h           ; 0531 1 108 20E 44980080
                MOV     er1, #08000h           ; 0535 1 108 20E 45980080
                LB      A, 0b3h                ; 0539 0 108 20E F5B3
                CMPB    A, 0b7h                ; 053B 0 108 20E C5B7C2
                JGT     label_054d             ; 053E 0 108 20E C808
                MOV     er0, #04000h           ; 0540 0 108 20E 44980040
                MOV     er1, #04000h           ; 0544 0 108 20E 45980040
                                               ; 0548 from 053E (DD0,108,20E)
label_0548:     JBS     off(00118h).7, label_054d ; 0548 0 108 20E EF1802
                MOV     er0, er1               ; 054B 0 108 20E 4548
                                               ; 054D from 0548 (DD0,108,20E)
label_054d:     L       A, ACC                 ; 054D 1 108 20E E506
                SWAP                           ; 054F 1 108 20E 83
                CAL     label_2d56             ; 0550 1 108 20E 32562D
                JBS     off(0011bh).6, label_0525 ; 0553 1 108 20E EE1BCF
                L       A, 0bah                ; 0556 1 108 20E E5BA
                MOV     USP, #0020eh           ; 0558 1 108 20E A1980E02
                CLRB    r0                     ; 055C 1 108 20E 2015
                ADD     A, (0020eh-0020eh)[USP] ; 055E 1 108 20E B30082
                ADCB    r0, #000h              ; 0561 1 108 20E 209000
                ADD     A, (00210h-0020eh)[USP] ; 0564 1 108 20E B30282
                ADCB    r0, #000h              ; 0567 1 108 20E 209000
                ADD     A, (00212h-0020eh)[USP] ; 056A 1 108 20E B30482
                ADCB    r0, #000h              ; 056D 1 108 20E 209000
                SRLB    r0                     ; 0570 1 108 20E 20E7
                ROR     A                      ; 0572 1 108 20E 43
                SRLB    r0                     ; 0573 1 108 20E 20E7
                ROR     A                      ; 0575 1 108 20E 43
                ST      A, 0beh                ; 0576 1 108 20E D5BE
                MOV     DP, #000c0h            ; 0578 1 108 20E 62C000
                CMP     A, [DP]                ; 057B 1 108 20E B2C2
                MOV     er0, #03000h           ; 057D 1 108 20E 44980030
                JGE     label_0587             ; 0581 1 108 20E CD04
                MOV     er0, #0d000h           ; 0583 1 108 20E 449800D0
                                               ; 0587 from 0581 (DD1,108,20E)
label_0587:     CAL     label_2d56             ; 0587 1 108 20E 32562D
                                               ; 058A from 052B (DD1,108,20E)
label_058a:     L       A, ADCR7               ; 058A 1 108 20E E56E
                MOV     DP, #000ach            ; 058C 1 108 20E 62AC00
                CAL     label_2ca1             ; 058F 1 108 20E 32A12C
                MB      off(0011fh).2, C       ; 0592 1 108 20E C41F3A

                MB      C, off(00123h).4       ; 0595 1 108 20E C4232C
                MB      off(00123h).5, C       ; 0598 1 108 20E C4233D

                MB      C, off(00123h).3       ;
                MB      off(00123h).4, C       ; 123h.4 = 123h.3


                MOV     DP, #00278h            ; 05A1 1 108 20E 627802
                LB      A, [DP]                ; 05A4 0 108 20E F2
                JLT     label_05a9             ; 05A5 0 108 20E CA02
                ADDB    A, #002h               ; 05A7 0 108 20E 8602
                                               ; 05A9 from 05A5 (DD0,108,20E)
label_05a9:     ADDB    A, #003h               ; 05A9 0 108 20E 8603
                CMPB    A, 0ach                ; 05AB 0 108 20E C5ACC2
                MB      off(00123h).3, C       ; 123h.3 is set if [278h]+2 or 3 is < TPS

                MB      C, off(0011fh).6       ;
                MB      off(0011fh).7, C       ; 11f.7 = 11f.6
                MB      C, off(0011fh).5       ;
                MB      off(0011fh).6, C       ; 11f.6 = 11f.5


                LB      A, #046h               ; 05BD 0 108 20E 7746
                MOVB    r0, #077h              ; 05BF 0 108 20E 9877
                JGE     label_05c7             ; if 11f.5 == 0, jump
                LB      A, #04eh               ; 05C3 0 108 20E 774E
                MOVB    r0, #089h              ; 05C5 0 108 20E 9889
                                               ; 05C7 from 05C1 (DD0,108,20E)
label_05c7:     CMPB    0a6h, A                ; if rpm >= 46h or 4eh
                JGE     label_05d0             ; then jump
                LB      A, r0                  ; 05CC 0 108 20E 78
                CMPB    0b3h, A                ; 05CD 0 108 20E C5B3C1
                                               ; 05D0 from 05CA (DD0,108,20E)
label_05d0:     MB      off(0011fh).5, C       ; if b3h < 77h or 89h then 11f.5 = 1

                L       A, 0bah                ; 05D3 1 108 20E E5BA
                SUB     A, off(00174h)         ; 05D5 1 108 20E A774
                MB      off(00125h).2, C       ; 05D7 1 108 20E C4253A
                JGE     label_05df             ; 05DA 1 108 20E CD03
                ST      A, er0                 ; 05DC 1 108 20E 88
                CLR     A                      ; 05DD 1 108 20E F9
                SUB     A, er0                 ; 05DE 1 108 20E 28
                                               ; 05DF from 05DA (DD1,108,20E)
label_05df:     ST      A, 0c2h                ; 05DF 1 108 20E D5C2
                CLRB    A                      ; 05E1 0 108 20E FA
                STB     A, r7                  ; 05E2 0 108 20E 8F
                CMPB    0a4h, #04fh      ;mugen compares it to #00h temp check
                JGE     label_061d       ;why would they do this? does it mean that the ecu always thinks
										 ;the engine is cold for this part of the rom?? WTF?

                ;mugen skips from here b/c of temp check
                JBR     off(0011fh).5, label_061d ; 05E9 0 108 20E DD1F31
                JBS     off(00123h).3, label_061d ; 05EC 0 108 20E EB232E
                JBS     off(0011ah).7, label_05f8 ; 05EF 0 108 20E EF1A06
                JBR     off(00125h).5, label_061d ; 05F2 0 108 20E DD2528
                JBS     off(00125h).2, label_061d ; 05F5 0 108 20E EA2525
                                               ; 05F8 from 05EF (DD0,108,20E)
label_05f8:     INCB    r7                     ; 05F8 0 108 20E AF
                CMPB    09ah, #003h            ; 05F9 0 108 20E C59AC003
                JLE     label_061b             ; 05FD 0 108 20E CF1C
                MOVB    r1, #010h        ;mugen moves 00 in r1      ; 05FF 0 108 20E 9910
                JBR     off(00125h).2, label_0606 ; 0601 0 108 20E DA2502
                MOVB    r1, #010h        ;mugen moves 00 in r1       ; 0604 0 108 20E 9910
                                               ; 0606 from 0601 (DD0,108,20E)
label_0606:     STB     A, r0                  ; 0606 0 108 20E 88
                L       A, 0c2h                ; 0607 1 108 20E E5C2
                MUL                            ; 0609 1 108 20E 9035
                MOVB    r4, #00ch              ; 060B 1 108 20E 9C0C
                LB      A, r3                  ; 060D 0 108 20E 7B
                JNE     label_0614             ; 060E 0 108 20E CE04
                LB      A, r2                  ; 0610 0 108 20E 7A
                CMPB    A, r4                  ; 0611 0 108 20E 4C
                JLT     label_0615             ; 0612 0 108 20E CA01
                                               ; 0614 from 060E (DD0,108,20E)
label_0614:     LB      A, r4                  ; 0614 0 108 20E 7C
                                               ; 0615 from 0612 (DD0,108,20E)
label_0615:     JBR     off(00125h).2, label_061b ; 0615 0 108 20E DA2503
                STB     A, r0                  ; 0618 0 108 20E 88
                CLRB    A                      ; 0619 0 108 20E FA
                SUBB    A, r0                  ; 061A 0 108 20E 28
                                               ; 061B from 05FD (DD0,108,20E)
                                               ; 061B from 0615 (DD0,108,20E)
label_061b:     ADDB    A, #000h               ; 061B 0 108 20E 8600

				;to here
                                               ; 061D from 05E7 (DD0,108,20E)
                                               ; 061D from 05E9 (DD0,108,20E)
                                               ; 061D from 05EC (DD0,108,20E)
                                               ; 061D from 05F2 (DD0,108,20E)
                                               ; 061D from 05F5 (DD0,108,20E)
label_061d:     STB     A, off(0013ah)         ; 061D 0 108 20E D43A
                MB      C, r7.0                ; 061F 0 108 20E 2728
                MB      off(0011ah).7, C       ; 0621 0 108 20E C41A3F
                JBR     off(00118h).7, label_067a ; 0624 0 108 20E DF1853
                MB      C, 0f3h.5              ; 0627 0 108 20E C5F32D
                JGE     label_0631             ; 062A 0 108 20E CD05
                RB      off(00120h).2          ; 062C 0 108 20E C4200A
                SJ      label_067a             ; calc correction
                                               ; 0631 from 062A (DD0,108,20E)
label_0631:     CMPB    0a4h, #0a1h            ; 0631 0 108 20E C5A4C0A1
                JLT     label_067a             ; calc correction
                LB      A, #024h               ; 0637 0 108 20E 7724
                JBS     off(00120h).1, label_063e ; 0639 0 108 20E E92002
                LB      A, #028h               ; 063C 0 108 20E 7728
                                               ; 063E from 0639 (DD0,108,20E)
label_063e:     MOV     DP, #00278h            ; 063E 0 108 20E 627802
                ADDB    A, [DP]                ; 0641 0 108 20E C282
                CMPB    A, 0ach                ; 0643 0 108 20E C5ACC2
                MB      off(00120h).1, C       ; 0646 0 108 20E C42039
                JLT     label_067a             ; calc correction
                JBS     off(0011eh).4, label_067a ; calc correction
                L       A, 0bch                ; 064E 1 108 20E E5BC
                ST      A, er3                 ; 0650 1 108 20E 8B
                CMP     A, #00038h             ; 0651 1 108 20E C63800
                JLT     label_067a             ; calc correction
                JBR     off(00120h).2, label_065f ; 0656 1 108 20E DA2006
                LB      A, off(001ech)         ; 0659 0 108 20E F4EC
                JNE     label_0666             ; 065B 0 108 20E CE09
                SJ      label_067a             ; calc correction
                                               ; 065F from 0656 (DD1,108,20E)
label_065f:     MOVB    off(001ech), #01eh     ; 065F 1 108 20E C4EC981E
                SB      off(00120h).2          ; 0663 1 108 20E C4201A
                                               ; 0666 from 065B (DD0,108,20E)
label_0666:     MOV     er2, #002eeh           ; 0666 1 108 20E 4698EE02
                CMPB    0a4h, #0d5h            ; 066A 1 108 20E C5A4C0D5
                L       A, #00004h             ; 066E 1 108 20E 670400
                JLT     label_0676             ; 0671 1 108 20E CA03
                L       A, #00020h             ; 0673 1 108 20E 672000
                                               ; 0676 from 0671 (DD1,108,20E)
label_0676:     ST      A, er0                 ; 0676 1 108 20E 88
                J       label_071c             ; no correction

                ;correction calc
                                               ; 067A from 0624 (DD0,108,20E)
                                               ; 067A from 062F (DD0,108,20E)
                                               ; 067A from 0635 (DD0,108,20E)
                                               ; 067A from 0649 (DD0,108,20E)
                                               ; 067A from 064B (DD0,108,20E)
                                               ; 067A from 0654 (DD1,108,20E)
                                               ; 067A from 065D (DD0,108,20E)
label_067a:     JBS     off(00125h).3, label_0681 ; 067A 0 108 20E EB2504
                MOVB    off(001ebh), #01eh     ; 067D 0 108 20E C4EB981E
                                               ; 0681 from 067A (DD0,108,20E)
label_0681:     LB      A, off(001ebh)         ; 0681 0 108 20E F4EB
                JNE     label_0688             ; 0683 0 108 20E CE03
                J       label_06e4             ; 0685 0 108 20E 03E406
                                               ; 0688 from 0683 (DD0,108,20E)
                                               ; 0688 from 06EF (DD1,108,20E)
label_0688:     CLR     A                      ; 0688 1 108 20E F9
                LB      A, 0b3h                ; 0689 0 108 20E F5B3
                L       A, ACC                 ; 068B 1 108 20E E506
                SWAP                           ; 068D 1 108 20E 83
                SUB     A, 0b6h                ; 068E 1 108 20E B5B6A2
                MOV     er0, #00b00h   ;mugen moves 1600h into er0           ; 0691 1 108 20E 4498000B
                JGE     label_069e             ; 0695 1 108 20E CD07
                ST      A, er1                 ; 0697 1 108 20E 89
                CLR     A                      ; 0698 1 108 20E F9
                SUB     A, er1                 ; 0699 1 108 20E 29
                MOV     er0, #00b00h   ;mugen moves 1600h into er0       ; 069A 1 108 20E 4498000B
                                               ; 069E from 0695 (DD1,108,20E)
label_069e:     ROLB    r7                     ; 069E 1 108 20E 27B7
                CMP     A, #00100h             ; 06A0 1 108 20E C60001
                JGE     label_06a6             ; 06A3 1 108 20E CD01
                CLR     A                      ; 06A5 1 108 20E F9
                                               ; 06A6 from 06A3 (DD1,108,20E)
label_06a6:     CMP     A, er0                 ; 06A6 1 108 20E 48
                JGE     label_06aa             ; 06A7 1 108 20E CD01
                ST      A, er0                 ; 06A9 1 108 20E 88
                                               ; 06AA from 06A7 (DD1,108,20E)
label_06aa:     CLRB    A                      ; 06AA 0 108 20E FA
                CMPB    0a6h, #0a9h            ; 06AB 0 108 20E C5A6C0A9
                JLT     label_06b3             ; 06AF 0 108 20E CA02
                ADDB    A, #004h               ; 06B1 0 108 20E 8604
                                               ; 06B3 from 06AF (DD0,108,20E)
label_06b3:     JBR     off(0010fh).0, label_06b8 ; 06B3 0 108 20E D80F02
                ADDB    A, #002h               ; 06B6 0 108 20E 8602
                                               ; 06B8 from 06B3 (DD0,108,20E)
label_06b8:     EXTND                          ; 06B8 1 108 20E F8
                LC      A, 030f3h[ACC]         ; 06B9 1 108 20E B506A9F330
                MUL                            ; 06BE 1 108 20E 9035
                LB      A, r2	                ; was 0b3h
                JBS     off(0010fh).0, label_06d0 ; 06C2 0 108 20E E80F0B

                ;signal to add
                RB      PSWL.5					;add
                SJ      label_06e0
                NOP
                NOP
                NOP

correct0:		LB      A, #000h
				SJ		label_06e0

                                               ; 06D0 from 06C2 (DD0,108,20E)
label_06d0:     CMPB    0a4h, #080h            ; 06D0 0 108 20E C5A4C080
                JLT     label_06dc             ; 06D4 0 108 20E CA06
                CMPB    off(001b0h), #00fh     ; 06D6 0 108 20E C4B0C00F
                JLT     correct0				; 06DA 0 108 20E CA04
                                               ; 06DC from 06D4 (DD0,108,20E)
label_06dc:     ;signal to subtract
				SB      PSWL.5					;subtract
				NOP
				NOP
                                               ; 06E0 from 06CA (DD0,108,20E)
                                               ; 06E0 from 06CE (DD0,108,20E)
                                               ; 06E0 from 06DA (DD0,108,20E)
                                               ; 06E0 from 06DD (DD0,108,20E)
label_06e0:     STB     A, 0b4h                ; 06E0 0 108 20E D5B4
                SJ      label_0733             ; 06E2 0 108 20E CB4F
                                               ; 06E4 from 0685 (DD0,108,20E)
label_06e4:     L       A, 0beh                ; 06E4 1 108 20E E5BE
                SUB     A, 0c0h                ; 06E6 1 108 20E B5C0A2
                ST      A, er3                 ; 06E9 1 108 20E 8B
                JGE     label_06f1             ; 06EA 1 108 20E CD05
                JBR     off(00123h).3, label_072f ; jump to no correction
                                               ; 06EF from 0719 (DD1,108,20E)
label_06ef:     SJ      label_0688             ; jump to correct
                                               ; 06F1 from 06EA (DD1,108,20E)
label_06f1:     MOV     er2, #00019h           ; 06F1 1 108 20E 46981900
                MOV     er0, #00002h           ; 06F5 1 108 20E 44980200
                JBS     off(0011eh).4, label_0719 ; 06F9 1 108 20E EC1E1D
                CMP     0bch, #0009dh          ; 06FC 1 108 20E B5BCC09D00
                JGE     label_0706             ; 0701 1 108 20E CD03
                JBR     off(00120h).3, label_0719 ; 0703 1 108 20E DB2013
                                               ; 0706 from 0701 (DD1,108,20E)
label_0706:     CMP     er3, #00064h           ; 0706 1 108 20E 47C06400
                JLT     label_0719             ; 070A 1 108 20E CA0D
                SB      off(00120h).3          ; 070C 1 108 20E C4201B
                MOV     er2, #0004bh           ; 070F 1 108 20E 46984B00
                MOV     er0, #0000ah           ; 0713 1 108 20E 44980A00
                SJ      label_071f             ; 0717 1 108 20E CB06
                                               ; 0719 from 06F9 (DD1,108,20E)
                                               ; 0719 from 0703 (DD1,108,20E)
                                               ; 0719 from 070A (DD1,108,20E)
                ;jumps to correct
label_0719:     JBS     off(00123h).3, label_06ef ; 123h.3 is set if [278h]+2 or 3 is < TPS

                                               ; 071C from 0677 (DD1,108,20E)
label_071c:     RB      off(00120h).3          ; 071C 1 108 20E C4200B
                                               ; 071F from 0717 (DD1,108,20E)
label_071f:     LB      A, #000h                ; 071F 0 108 20E F5B3
                STB     A, 0b4h                ; 0721 0 108 20E D5B4
                L       A, er3                 ; 0723 1 108 20E 37
                MUL                            ; 0724 1 108 20E 9035
                NOP                            ; 0726 1 108 20E 00
                SRL     A                      ; 0727 1 108 20E 63
                SRL     A                      ; 0728 1 108 20E 63
                CMP     A, er2                 ; 0729 1 108 20E 4A
                JLT     label_0737             ; 072A 1 108 20E CA0B
                L       A, er2                 ; 072C 1 108 20E 36
                SJ      label_0737             ; 072D 1 108 20E CB08

                NOP
                NOP
                NOP
                NOP
                NOP
                NOP
                NOP
                NOP
                NOP
                NOP
                NOP
                NOP
                NOP
                NOP
                NOP
                NOP
                NOP
                NOP
                NOP
                NOP
                NOP
                NOP
                NOP
                NOP
                NOP
                NOP
                NOP
                NOP

                                               ; 072F from 06EC (DD1,108,20E)
label_072f:     LB      A, #000h                ; 072F 0 108 20E F5B3
                STB     A, 0b4h                ; 0731 0 108 20E D5B4
                                               ; 0733 from 06E2 (DD0,108,20E)
label_0733:     RB      off(00120h).3          ; 0733 0 108 20E C4200B
                CLR     A                      ; 0736 1 108 20E F9
                                               ; 0737 from 072A (DD1,108,20E)
                                               ; 0737 from 072D (DD1,108,20E)
label_0737:     ST      A, off(00150h)         ; 0737 1 108 20E D450


				CAL		correctcol				;add or subtract the correction

                ; ignition
label_0743:     MOVB    r6, 0b5h               ; move the column in
                LB      A, 0a7h                ; 0744 0 108 20E F5A7
                RC                             ; 0746 0 108 20E 95



                ;vtec ignition map
                MOV     X1, #ignitionmapv      ;
                ;MOV     X2, #revscalar_igv     ;
                MOV     X2, #03bc6h            ;
                                               ; 0756 from 074D (DD0,108,20E)
label_0756:     JBS     off(00129h).7, label_076d ; 0756 0 108 20E EF2914
                LB      A, 0a6h                ; 0759 0 108 20E F5A6
                MB      C, off(00129h).1       ; 075B 0 108 20E C42929



                ;non vtec ignition map
                MOV     X1, #ignitionmap		;
                ;MOV     X2, #revscalar_ig		;
                MOV     X2, #03bb6h            ;
                                               ; 076D from 0756 (DD0,108,20E)
                                               ; 076D from 0764 (DD0,108,20E)
label_076d:     STB     A, r7                  ; 076D 0 108 20E 8F
                MB      off(00129h).2, C       ; 076E 0 108 20E C4293A
                SB      PSWL.5                 ; 0771 0 108 20E A31D

                ;interpolation on ign maps
                CAL     label_2af3             ; 0773 0 108 20E 32F32A

                MOVB    off(00137h), A         ; 0776 0 108 20E C4378A
                JBS     off(00118h).7, label_077f ; 0779 0 108 20E EF1803
                JBR     off(0012bh).2, label_0782 ; 077C 0 108 20E DA2B03
                                               ; 077F from 0779 (DD0,108,20E)
                                               ; 077F from 0786 (DD0,108,20E)
label_077f:     J       label_07fa             ; 077F 0 108 20E 03FA07
                                               ; 0782 from 077C (DD0,108,20E)
label_0782:     LB      A, off(00130h)         ; 0782 0 108 20E F430
                ANDB    A, #074h               ; 0784 0 108 20E D674
                JNE     label_077f             ; 0786 0 108 20E CEF7
                JBS     off(00131h).7, label_07fa ; 0788 0 108 20E EF316F
                LB      A, off(00132h)         ; 078B 0 108 20E F432
                ANDB    A, #033h               ; 33h == 00110011b
                JNE     label_07fa             ; 078F 0 108 20E CE69
                MB      C, 0f3h.0              ; 0791 0 108 20E C5F328
                JGE     label_07fa             ; 0794 0 108 20E CD64
                JBS     off(00128h).3, label_07fa ; 0796 0 108 20E EB2861
                MOV     DP, #00278h            ; 0799 0 108 20E 627802
                LB      A, [DP]                ; 079C 0 108 20E F2
                JEQ     label_07fa             ; 079D 0 108 20E C95B
                CMPB    0a4h, #001h            ; 079F 0 108 20E C5A4C001
                JGE     label_07fa             ; 07A3 0 108 20E CD55
                MOVB    r0, #080h              ; 07A5 0 108 20E 9880
                MOVB    r1, #005h              ; 07A7 0 108 20E 9905
                MOVB    r2, #0c6h              ; 07A9 0 108 20E 9AC6
                JBS     off(0011ah).3, label_07b4 ; 07AB 0 108 20E EB1A06
                MOVB    r0, #079h              ; 07AE 0 108 20E 9879
                MOVB    r1, #009h              ; 07B0 0 108 20E 9909
                MOVB    r2, #0c2h              ; 07B2 0 108 20E 9AC2
                                               ; 07B4 from 07AB (DD0,108,20E)
label_07b4:     LB      A, 0cbh                ; 07B4 0 108 20E F5CB
                CMPB    A, r0                  ; 07B6 0 108 20E 48
                JGE     label_07bf             ; 07B7 0 108 20E CD06
                J       label_34fb             ; 07B9 0 108 20E 03FB34
                                               ; 07BC from 34FF (DD0,108,20E)
label_07bc:     LB      A, 0a6h                ; 07BC 0 108 20E F5A6
                CMPB    A, r2                  ; 07BE 0 108 20E 4A
                                               ; 07BF from 07B7 (DD0,108,20E)
                                               ; 07BF from 3502 (DD0,108,20E)
label_07bf:     MB      off(0011ah).3, C       ; 07BF 0 108 20E C41A3B
                JGE     label_07fa             ; 07C2 0 108 20E CD36
                MB      C, 0f2h.6              ; 07C4 0 108 20E C5F22E
                JGE     label_07d5             ; 07C7 0 108 20E CD0C
                MOV     X1, #03199h            ; 07C9 0 108 20E 609931
                LB      A, 0a6h                ; 07CC 0 108 20E F5A6
                VCAL    0                      ; 07CE 0 108 20E 10
                MOVB    off(0015dh), #001h     ; 07CF 0 108 20E C45D9801
                SJ      label_07fb             ; 07D3 0 108 20E CB26
                                               ; 07D5 from 07C7 (DD0,108,20E)
label_07d5:     JBR     off(00123h).3, label_07fa ; 07D5 0 108 20E DB2322
                MB      C, off(00123h).1       ; 07D8 0 108 20E C42329
                JGE     label_07ea             ; 07DB 0 108 20E CD0D
                CMPB    0adh, #082h            ; 07DD 0 108 20E C5ADC082
                JBR     off(00122h).3, label_07e8 ; 07E1 0 108 20E DB2204
                CMPB    0afh, #082h            ; 07E4 0 108 20E C5AFC082
                                               ; 07E8 from 07E1 (DD0,108,20E)
label_07e8:     JLT     label_07fa             ; 07E8 0 108 20E CA10
                                               ; 07EA from 07DB (DD0,108,20E)
label_07ea:     MOVB    r0, #001h              ; 07EA 0 108 20E 9801
                LB      A, off(0015dh)         ; 07EC 0 108 20E F45D
                JEQ     label_07f5             ; 07EE 0 108 20E C905
                DECB    off(0015dh)            ; 07F0 0 108 20E C45D17
                CLRB    r0                     ; 07F3 0 108 20E 2015
                                               ; 07F5 from 07EE (DD0,108,20E)
label_07f5:     LB      A, off(00159h)         ; 07F5 0 108 20E F459
                SUBB    A, r0                  ; 07F7 0 108 20E 28
                JGE     label_07fb             ; 07F8 0 108 20E CD01
                                               ; 07FA from 077F (DD0,108,20E)
                                               ; 07FA from 0788 (DD0,108,20E)
                                               ; 07FA from 078F (DD0,108,20E)
                                               ; 07FA from 0794 (DD0,108,20E)
                                               ; 07FA from 0796 (DD0,108,20E)
                                               ; 07FA from 079D (DD0,108,20E)
                                               ; 07FA from 07A3 (DD0,108,20E)
                                               ; 07FA from 07C2 (DD0,108,20E)
                                               ; 07FA from 07D5 (DD0,108,20E)
                                               ; 07FA from 07E8 (DD0,108,20E)
label_07fa:     CLRB    A                      ; 07FA 0 108 20E FA
                                               ; 07FB from 07D3 (DD0,108,20E)
                                               ; 07FB from 07F8 (DD0,108,20E)
label_07fb:     STB     A, off(00159h)         ; 07FB 0 108 20E D459
                LB      A, off(0013eh)         ; 07FD 0 108 20E F43E
                JEQ     label_081d             ; 07FF 0 108 20E C91C
                JBS     off(0013eh).7, label_081d ; 0801 0 108 20E EF3E19
                CMPB    off(001abh), #0c8h     ; oil pressure check
                JLT     label_081d             ; 0808 0 108 20E CA13
                ;NOP
                ;NOP
                LB      A, 0a4h                ; 080A 0 108 20E F5A4
                MOV     X1, #031c7h            ; 080C 0 108 20E 60C731
                VCAL    2                      ; 080F 0 108 20E 12
                STB     A, r7                  ; 0810 0 108 20E 8F
                CLRB    r6                     ; 0811 0 108 20E 2615
                MOV     X1, #031cbh            ; 0813 0 108 20E 60CB31
                CAL     label_2b98             ; 0816 0 108 20E 32982B
                CLRB    A                      ; 0819 0 108 20E FA
                SUBB    A, r6                  ; 081A 0 108 20E 2E
                ADDB    A, off(0013eh)         ; 081B 0 108 20E 873E
                                               ; 081D from 07FF (DD0,108,20E)
                                               ; 081D from 0801 (DD0,108,20E)
                                               ; 081D from 0808 (DD0,108,20E)
label_081d:     STB     A, off(00139h)         ; 081D 0 108 20E D439
                MOV     X1, #0311fh            ; 081F 0 108 20E 601F31
                LB      A, 0a7h                ; 0822 0 108 20E F5A7
                VCAL    0                      ; 0824 0 108 20E 10
                STB     A, off(0013ch)         ; 0825 0 108 20E D43C
                MB      C, P2.4                ; 0827 0 108 20E C5242C
                JGE     label_082f             ; 082A 0 108 20E CD03
                J       label_089c             ; 082C 0 108 20E 039C08
                                               ; 082F from 082A (DD0,108,20E)
label_082f:     MOV     DP, #000a7h            ; 082F 0 108 20E 62A700
                MOV     X1, #0316fh            ; 0832 0 108 20E 606F31
                L       A, #0318bh             ; 0835 1 108 20E 678B31
                MOV     X2, #03137h            ; 0838 1 108 20E 613731
                MOV     USP, #03153h           ; 083B 1 108 3153 A1985331
                JBS     off(00129h).7, label_084f ; 083F 1 108 3153 EF290D
                DEC     DP                     ; 0842 1 108 3153 82
                MOV     X1, #03161h            ; 0843 1 108 3153 606131
                L       A, #0317dh             ; 0846 1 108 3153 677D31
                MOV     X2, #03129h            ; 0849 1 108 3153 612931
                J       label_3505             ; 084C 1 108 3153 030535
                                               ; 084F from 083F (DD1,108,3153)
                                               ; 084F from 3509 (DD1,108,3145)
label_084f:     JBS     off(00118h).7, label_0855 ; 084F 1 108 3153 EF1803
                MOV     X1, A                  ; 0852 1 108 3153 50
                MOV     X2, USP                ; 0853 1 108 3153 A179
                                               ; 0855 from 084F (DD1,108,3153)
label_0855:     CMPB    09fh, #01fh            ; 0855 1 108 3153 C59FC01F
                JGE     label_0867             ; 0859 1 108 3153 CD0C
                ;NOP
                ;NOP
                CMPB    0a6h, #042h            ; 085B 1 108 3153 C5A6C042
                JLT     label_089c             ; 085F 1 108 3153 CA3B
                MOV     X1, X2                 ; 0861 1 108 3153 9178
                LB      A, [DP]                ; 0863 0 108 3153 F2
                VCAL    0                      ; 0864 0 108 3153 10
                SJ      label_08a3             ; 0865 0 108 3153 CB3C
                                               ; 0867 from 0859 (DD1,108,3153)
label_0867:     LB      A, off(0012bh)         ; 0867 0 108 3153 F42B
                ANDB    A, #003h               ; 0869 0 108 3153 D603
                STB     A, r7                  ; 086B 0 108 3153 8F
                LB      A, 0f3h                ; 086C 0 108 3153 F5F3
                ANDB    A, #003h               ; 086E 0 108 3153 D603
                ANDB    off(0012bh), #0fch     ; 0870 0 108 3153 C42BD0FC
                ORB     off(0012bh), A         ; 0874 0 108 3153 C42BE1
                CLRB    r5                     ; 0877 0 108 3153 2515
                CMPB    A, r7                  ; 0879 0 108 3153 4F
                JNE     label_088c             ; 087A 0 108 3153 CE10
                J       label_1d71             ; 087C 0 108 3153 03711D
                DB  011h ; 087F
                                               ; 0880 from 1D7D (DD0,108,3153)
                                               ; 0880 from 420F (DD0,108,3153)
label_0880:     LB      A, off(00130h)         ; 0880 0 108 3153 F430
                ANDB    A, #0bch               ; 0882 0 108 3153 D6BC
                JNE     label_0891             ; 0884 0 108 3153 CE0B
                LB      A, off(00132h)         ; 0886 0 108 3153 F432
                ANDB    A, #031h               ; 0888 0 108 3153 D631
                JNE     label_0891             ; 088A 0 108 3153 CE05
                                               ; 088C from 087A (DD0,108,3153)
label_088c:     LB      A, off(0013dh)         ; 088C 0 108 3153 F43D
                JEQ     label_08a5             ; 088E 0 108 3153 C915
                INCB    r5                     ; 0890 0 108 3153 AD
                                               ; 0891 from 1D80 (DD0,108,3153)
                                               ; 0891 from 0884 (DD0,108,3153)
                                               ; 0891 from 088A (DD0,108,3153)
label_0891:     LB      A, [DP]                ; 0891 0 108 3153 F2
                VCAL    0                      ; 0892 0 108 3153 10
                JBR     off(0010dh).0, label_08a3 ; 0893 0 108 3153 D80D0D
                LB      A, off(0013dh)         ; 0896 0 108 3153 F43D
                ADDB    A, #002h               ; 0898 0 108 3153 8602
                JGE     label_089f             ; 089A 0 108 3153 CD03
                                               ; 089C from 082C (DD0,108,20E)
                                               ; 089C from 085F (DD1,108,3153)
label_089c:     CLRB    A                      ; 089C 0 108 20E FA
                SJ      label_08a3             ; 089D 0 108 20E CB04
                                               ; 089F from 089A (DD0,108,3153)
label_089f:     CMPB    A, r6                  ; 089F 0 108 3153 4E
                JGE     label_08a3             ; 08A0 0 108 3153 CD01
                LB      A, r6                  ; 08A2 0 108 3153 7E
                                               ; 08A3 from 089D (DD0,108,20E)
                                               ; 08A3 from 0865 (DD0,108,3153)
                                               ; 08A3 from 0893 (DD0,108,3153)
                                               ; 08A3 from 08A0 (DD0,108,3153)
label_08a3:     STB     A, off(0013dh)         ; 08A3 0 108 20E D43D
                                               ; 08A5 from 088E (DD0,108,3153)
label_08a5:     LB      A, off(00159h)         ; 08A5 0 108 20E F459
                JEQ     label_08c0             ; 08A7 0 108 20E C917
                STB     A, r0                  ; 08A9 0 108 20E 88
                MB      C, 0f2h.6              ; 08AA 0 108 20E C5F22E
                JLT     label_08c0             ; 08AD 0 108 20E CA11
                LB      A, off(0015dh)         ; 08AF 0 108 20E F45D
                JNE     label_08bd             ; 08B1 0 108 20E CE0A
                JBS     off(0011eh).4, label_08bd ; 08B3 0 108 20E EC1E07
                CMP     0bch, #00004h          ; 08B6 0 108 20E B5BCC00400
                JGE     label_08c0             ; 08BB 0 108 20E CD03
                                               ; 08BD from 08B1 (DD0,108,20E)
                                               ; 08BD from 08B3 (DD0,108,20E)
label_08bd:     SC                             ; 08BD 0 108 20E 85
                SJ      label_08c3             ; 08BE 0 108 20E CB03
                                               ; 08C0 from 08A7 (DD0,108,20E)
                                               ; 08C0 from 08AD (DD0,108,20E)
                                               ; 08C0 from 08BB (DD0,108,20E)
label_08c0:     CLRB    r0                     ; 08C0 0 108 20E 2015
                RC                             ; 08C2 0 108 20E 95
                                               ; 08C3 from 08BE (DD0,108,20E)
label_08c3:     MB      off(0011ah).4, C       ; 08C3 0 108 20E C41A3C
                LB      A, off(00137h)			;calculaed ign value
                SUBB    A, r0                  ; 08C8 0 108 20E 28
                JGE     label_08cc             ; 08C9 0 108 20E CD01
                CLRB    A                      ; 08CB 0 108 20E FA
                                               ; 08CC from 08C9 (DD0,108,20E)
label_08cc:     JBR     off(00119h).6, label_08d4 ; 08CC 0 108 20E DE1905
                ADDB    A, #0f8h       ;mugen added 00h instead        ; 08CF 0 108 20E 86F8
                JLT     label_08d4             ; 08D1 0 108 20E CA01
                CLRB    A                      ; 08D3 0 108 20E FA
                                               ; 08D4 from 08CC (DD0,108,20E)
                                               ; 08D4 from 08D1 (DD0,108,20E)
label_08d4:     MOV     DP, #00006h            ; 08D4 0 108 20E 620600
                MOV     USP, #00138h           ; 08D7 0 108 138 A1983801
                JBR     off(00130h).5, label_08e5 ; 08DB 0 108 138 DD3007
                MOV     DP, #00003h            ; 08DE 0 108 138 620300
                MOV     USP, #0013bh           ; 08E1 0 108 13B A1983B01
                                               ; 08E5 from 08DB (DD0,108,138)
                                               ; 08E5 from 08FB (DD0,108,13C)
label_08e5:     MB      C, (0013bh-0013bh)[USP].7 ; 08E5 0 108 13B C3002F
                ROLB    r7                     ; 08E8 0 108 13B 27B7
                ADDB    A, (0013bh-0013bh)[USP] ; 08EA 0 108 13B C30082
                JBS     off(0010fh).0, label_08f6 ; 08ED 0 108 13B E80F06
                JGE     label_08f9             ; 08F0 0 108 13B CD07
                LB      A, #0ffh               ; 08F2 0 108 13B 77FF
                SJ      label_08f9             ; 08F4 0 108 13B CB03
                                               ; 08F6 from 08ED (DD0,108,13B)
label_08f6:     JLT     label_08f9             ; 08F6 0 108 13B CA01
                CLRB    A                      ; 08F8 0 108 13B FA
                                               ; 08F9 from 08F0 (DD0,108,13B)
                                               ; 08F9 from 08F4 (DD0,108,13B)
                                               ; 08F9 from 08F6 (DD0,108,13B)
label_08f9:     INC     USP                    ; 08F9 0 108 13C A116
                JRNZ    DP, label_08e5         ; 08FB 0 108 13C 30E8
                STB     A, r2                  ; 08FD 0 108 13C 8A
                J       label_350c             ; 08FE 0 108 13C 030C35
                                               ; 0901 from 355E (DD0,108,13C)
label_0901:     LB      A, 0a7h                ; 0901 0 108 13C F5A7
                VCAL    0                      ; 0903 0 108 13C 10
                STB     A, r3                  ; 0904 0 108 13C 8B
                MOV     X1, #031b7h            ; 0905 0 108 13C 60B731
                LB      A, 09bh                ; 0908 0 108 13C F59B
                VCAL    0                      ; 090A 0 108 13C 10
                EXTND                          ; 090B 1 108 13C F8
                MOVB    r0, r3                 ; 090C 1 108 13C 2348
                MULB                           ; 090E 1 108 13C A234
                MOVB    r0, #0b3h              ; 0910 1 108 13C 98B3
                SLL     A                      ; 0912 1 108 13C 53
                JLT     label_0922             ; 0913 1 108 13C CA0D
                SLL     A                      ; 0915 1 108 13C 53
                JLT     label_0922             ; 0916 1 108 13C CA0A
                LB      A, ACCH                ; 0918 0 108 13C F507
                CMPB    A, r0                  ; 091A 0 108 13C 48
                JGE     label_0922             ; 091B 0 108 13C CD05
                MOVB    r0, #00fh              ; 091D 0 108 13C 980F
                CMPB    A, r0                  ; 091F 0 108 13C 48
                JGE     label_0923             ; 0920 0 108 13C CD01
                                               ; 0922 from 0913 (DD1,108,13C)
                                               ; 0922 from 0916 (DD1,108,13C)
                                               ; 0922 from 091B (DD0,108,13C)
label_0922:     LB      A, r0                  ; 0922 0 108 13C 78
                                               ; 0923 from 0920 (DD0,108,13C)
label_0923:     STB     A, ACCH                ; 0923 0 108 13C D507
                LB      A, r2                  ; 0925 0 108 13C 7A
                MOV     off(00134h), A         ; 0926 0 108 13C B4348A
                LB      A, ADCR6H              ; 0929 0 108 13C F56D
                STB     A, 0a5h                ; 092B 0 108 13C D5A5
                JBS     off(0011fh).4, label_0933 ; 092D 0 108 13C EC1F03
                J       label_0a09             ; 0930 0 108 13C 03090A
                                               ; 0933 from 092D (DD0,108,13C)
label_0933:     JBR     off(00130h).5, label_0953 ; 0933 0 108 13C DD301D
                CLR     A                      ; 0936 1 108 13C F9
                MOV     DP, #0344eh            ; 0937 1 108 13C 624E34
                LB      A, off(001eah)         ; 093A 0 108 13C F4EA
                MOVB    r0, #014h              ; 093C 0 108 13C 9814
                DIVB                           ; 093E 0 108 13C A236
                EXTND                          ; 0940 1 108 13C F8
                SLL     A                      ; 0941 1 108 13C 53
                SUB     DP, A                  ; 0942 1 108 13C 92A1
                LC      A, [DP]                ; 0944 1 108 13C 92A8
                ST      A, off(00140h)         ; 0946 1 108 13C D440
                LC      A, 0000ah[DP]          ; 0948 1 108 13C 92A90A00
                ST      A, off(0016ch)         ; 094C 1 108 13C D46C
                CLRB    off(0016eh)            ; 094E 1 108 13C C46E15
                SJ      label_0961             ; 0951 1 108 13C CB0E
                                               ; 0953 from 0933 (DD0,108,13C)
label_0953:     LB      A, 0a4h                ; 0953 0 108 13C F5A4
                MOV     X1, #0322bh            ; 0955 0 108 13C 602B32
                JBS     off(0011ah).5, label_095e ; 0958 0 108 13C ED1A03
                MOV     X1, #03240h            ; 095B 0 108 13C 604032
                                               ; 095E from 0958 (DD0,108,13C)
label_095e:     VCAL    1                      ; 095E 0 108 13C 11
                STB     A, off(00140h)         ; 095F 0 108 13C D440
                                               ; 0961 from 0951 (DD1,108,13C)
label_0961:     LB      A, 0bbh                ; 0961 0 108 13C F5BB
                MOV     X1, #03227h            ; 0963 0 108 13C 602732
                VCAL    2                      ; 0966 0 108 13C 12
                MOVB    off(00168h), A         ; 0967 0 108 13C C4688A
                EXTND                          ; 096A 1 108 13C F8
                MOVB    r0, #080h              ; 096B 1 108 13C 9880
                MULB                           ; 096D 1 108 13C A234
                MOV     er0, off(00140h)       ; 096F 1 108 13C B44048
                MUL                            ; 0972 1 108 13C 9035
                MB      C, 0f1h.7              ; 0974 1 108 13C C5F12F
                JLT     label_0987             ; 0977 1 108 13C CA0E
                ROL     A                      ; 0979 1 108 13C 33
                ROL     er1                    ; 097A 1 108 13C 45B7
                JLT     label_0983             ; 097C 1 108 13C CA05
                ROL     A                      ; 097E 1 108 13C 33
                ROL     er1                    ; 097F 1 108 13C 45B7
                JGE     label_0987             ; 0981 1 108 13C CD04
                                               ; 0983 from 097C (DD1,108,13C)
label_0983:     MOV     er1, #0ffffh           ; 0983 1 108 13C 4598FFFF
                                               ; 0987 from 0977 (DD1,108,13C)
                                               ; 0987 from 0981 (DD1,108,13C)
label_0987:     MOV     off(00144h), er1       ; 0987 1 108 13C 457C44
                L       A, off(0014ch)         ; 098A 1 108 13C E44C
                ST      A, off(00146h)         ; 098C 1 108 13C D446
                ADD     A, er1                 ; 098E 1 108 13C 09
                JGE     label_0994             ; 098F 1 108 13C CD03
                L       A, #0ffffh             ; 0991 1 108 13C 67FFFF
                                               ; 0994 from 098F (DD1,108,13C)
label_0994:     ST      A, 0d6h                ; 0994 1 108 13C D5D6
                ST      A, off(00148h)         ; 0996 1 108 13C D448
                CMPB    0e6h, #004h            ; 0998 1 108 13C C5E6C004
                JEQ     label_09a4             ; 099C 1 108 13C C906
                MB      C, 0f1h.7              ; 099E 1 108 13C C5F12F
                JLT     label_09a4             ; 09A1 1 108 13C CA01
                CLR     A                      ; 09A3 1 108 13C F9
                                               ; 09A4 from 099C (DD1,108,13C)
                                               ; 09A4 from 09A1 (DD1,108,13C)
label_09a4:     ST      A, 0d0h                ; 09A4 1 108 13C D5D0
                ST      A, 0d2h                ; 09A6 1 108 13C D5D2
                ST      A, 0d4h                ; 09A8 1 108 13C D5D4
                L       A, #08000h             ; 09AA 1 108 13C 670080
                ST      A, off(00162h)         ; 09AD 1 108 13C D462
                ST      A, off(00164h)         ; 09AF 1 108 13C D464
                RB      off(0011bh).0          ; 09B1 1 108 13C C41B08
                RB      off(0011ch).0          ; 09B4 1 108 13C C41C08
                CAL     label_295f             ; 09B7 1 108 13C 325F29
                MOV     LRB, #00021h           ; 09BA 1 108 13C 572100
                RB      0f2h.6                 ; 09BD 1 108 13C C5F20E
                LB      A, 0e5h                ; 09C0 0 108 13C F5E5
                ADDB    A, #001h               ; 09C2 0 108 13C 8601
                ANDB    A, #003h               ; 09C4 0 108 13C D603
                STB     A, 0e5h                ; 09C6 0 108 13C D5E5
                JBS     off(00130h).5, label_0a01 ; 09C8 0 108 13C ED3036
                MOV     X1, #03032h            ; 09CB 0 108 13C 603230
                L       A, #03056h             ; 09CE 1 108 13C 675630
                JBS     off(00118h).7, label_09da ; 09D1 1 108 13C EF1806
                MOV     X1, #03020h            ; 09D4 1 108 13C 602030
                L       A, #03044h             ; 09D7 1 108 13C 674430
                                               ; 09DA from 09D1 (DD1,108,13C)
label_09da:     JBS     off(0011ah).5, label_09de ; 09DA 1 108 13C ED1A01
                MOV     X1, A                  ; 09DD 1 108 13C 50
                                               ; 09DE from 09DA (DD1,108,13C)
label_09de:     LB      A, 0a4h                ; 09DE 0 108 13C F5A4
                VCAL    1                      ; 09E0 0 108 13C 11
                CMPB    0a3h, #034h            ; 09E1 0 108 13C C5A3C034
                JGE     label_09ea             ; 09E5 0 108 13C CD03
                ADDB    A, #000h               ; 09E7 0 108 13C 8600
                NOP                            ; 09E9 0 108 13C 00
                                               ; 09EA from 09E5 (DD0,108,13C)
label_09ea:     STB     A, off(0016ch)         ; 09EA 0 108 13C D46C
                CLRB    off(0016eh)            ; 09EC 0 108 13C C46E15
                LB      A, 0a4h                ; 09EF 0 108 13C F5A4
                MOV     X1, #02f56h            ; 09F1 0 108 13C 60562F
                VCAL    0                      ; 09F4 0 108 13C 10
                MOVB    r0, #008h              ; 09F5 0 108 13C 9808
                MULB                           ; 09F7 0 108 13C A234
                L       A, ACC                 ; 09F9 1 108 13C E506
                SRL     A                      ; 09FB 1 108 13C 63
                CMP     A, #00100h             ; 09FC 1 108 13C C60001
                JGE     label_0a04             ; 09FF 1 108 13C CD03
                                               ; 0A01 from 09C8 (DD0,108,13C)
label_0a01:     L       A, #00100h             ; 0A01 1 108 13C 670001
                                               ; 0A04 from 09FF (DD1,108,13C)
label_0a04:     ST      A, off(0016ah)         ; 0A04 1 108 13C D46A
                J       label_4108             ; 0A06 1 108 13C 030841
                                               ; 0A09 from 0930 (DD0,108,13C)
label_0a09:     MOVB    r7, #007h              ; 0A09 0 108 13C 9F07
                MB      C, P2.4                ; 0A0B 0 108 13C C5242C
                ;JLT     label_0a88				;mugen changed to SJ

                SJ		label_0a88				;knock disable

                J       label_3677             ; 0A10 0 108 13C 037736
                DB  074h ; 0A13

                ;mugen skips from here:
                                               ; 0A14 from 3681 (DD0,108,13C)
label_0a14:     JBS     off(0012bh).2, label_0a4c ; 0A14 0 108 13C EA2B35
                JBS     off(0011ah).4, label_0a88 ; 0A17 0 108 13C EC1A6E
                NOP                            ; 0A1A 0 108 13C 00
                NOP                            ; 0A1B 0 108 13C 00
                NOP                            ; 0A1C 0 108 13C 00
                NOP                            ; 0A1D 0 108 13C 00
                NOP                            ; 0A1E 0 108 13C 00
                NOP                            ; 0A1F 0 108 13C 00
                NOP                            ; 0A20 0 108 13C 00
                NOP                            ; 0A21 0 108 13C 00
                JBS     off(00129h).3, label_0a34 ; 0A22 0 108 13C EB290F
                LB      A, #0c6h               ; 0A25 0 108 13C 77C6
                JBR     off(0012ah).0, label_0a2c ; 0A27 0 108 13C D82A02
                LB      A, #0c2h               ; 0A2A 0 108 13C 77C2
                                               ; 0A2C from 0A27 (DD0,108,13C)
label_0a2c:     CMPB    A, 0a6h                ; 0A2C 0 108 13C C5A6C2
                MB      off(0012ah).0, C       ; 0A2F 0 108 13C C42A38
                JLT     label_0a88             ; 0A32 0 108 13C CA54
                                               ; 0A34 from 0A22 (DD0,108,13C)
label_0a34:     JBR     off(0011eh).4, label_0a48 ; 0A34 0 108 13C DC1E11
                LB      A, 0a6h                ; 0A37 0 108 13C F5A6
                MOV     X1, #030fbh            ; 0A39 0 108 13C 60FB30
                VCAL    1                      ; 0A3C 0 108 13C 11
                MOVB    r7, #007h              ; 0A3D 0 108 13C 9F07
                ; warning: had to flip DD
                CMP     A, 0bch                ; 0A3F 1 108 13C B5BCC2
                JGE     label_0a48             ; 0A42 1 108 13C CD04
                MOVB    off(001f2h), #000h     ; 0A44 1 108 13C C4F29800
                                               ; 0A48 from 0A34 (DD0,108,13C)
                                               ; 0A48 from 0A42 (DD1,108,13C)
label_0a48:     LB      A, off(001f2h)         ; 0A48 0 108 13C F4F2
                JNE     label_0a88             ; 0A4A 0 108 13C CE3C
                                               ; 0A4C from 0A14 (DD0,108,13C)
label_0a4c:     LB      A, 0a4h                ; 0A4C 0 108 13C F5A4
                MOVB    r7, #003h              ; 0A4E 0 108 13C 9F03
                CMPB    A, #023h      ;mugen changed to #001h         ; 0A50 0 108 13C C623
                JLT     label_0a67             ; 0A52 0 108 13C CA13
                MOVB    r7, #005h              ; 0A54 0 108 13C 9F05
                CMPB    A, #040h      ;mugen changed to #002h         ; 0A56 0 108 13C C640
                JLT     label_0a67             ; 0A58 0 108 13C CA0D
                MOVB    r7, #002h              ; 0A5A 0 108 13C 9F02
                CMPB    A, #06eh      ;mugen changed to #003h         ; 0A5C 0 108 13C C66E
                JLT     label_0a76             ; 0A5E 0 108 13C CA16
                DECB    r7                     ; 0A60 0 108 13C BF
                CMPB    A, #0a1h      ;mugen --> #004h         ; 0A61 0 108 13C C6A1
                JLT     label_0a76             ; 0A63 0 108 13C CA11
                SJ      label_0a85             ; 0A65 0 108 13C CB1E
                                               ; 0A67 from 0A52 (DD0,108,13C)
                                               ; 0A67 from 0A58 (DD0,108,13C)
label_0a67:     LB      A, #0c0h               ; 0A67 0 108 13C 77C0
                JBR     off(0012bh).3, label_0a6e ; 0A69 0 108 13C DB2B02
                LB      A, #0bch               ; 0A6C 0 108 13C 77BC
                                               ; 0A6E from 0A69 (DD0,108,13C)
label_0a6e:     CMPB    A, 0b3h                ; 0A6E 0 108 13C C5B3C2
                MB      off(0012bh).3, C       ; 0A71 0 108 13C C42B3B
                JLT     label_0a87             ; 0A74 0 108 13C CA11
                                               ; 0A76 from 0A5E (DD0,108,13C)
                                               ; 0A76 from 0A63 (DD0,108,13C)
label_0a76:     LB      A, #0aeh               ; 0A76 0 108 13C 77AE
                JBR     off(0012bh).4, label_0a7d ; 0A78 0 108 13C DC2B02
                LB      A, #0a7h               ; 0A7B 0 108 13C 77A7
                                               ; 0A7D from 0A78 (DD0,108,13C)
label_0a7d:     CMPB    A, 0b3h                ; 0A7D 0 108 13C C5B3C2
                MB      off(0012bh).4, C       ; 0A80 0 108 13C C42B3C
                JLT     label_0a88             ; 0A83 0 108 13C CA03
                                               ; 0A85 from 0A65 (DD0,108,13C)
label_0a85:     MOVB    r7, #0ffh              ; 0A85 0 108 13C 9FFF
                                               ; 0A87 from 0A74 (DD0,108,13C)
label_0a87:     INCB    r7                     ; 0A87 0 108 13C AF
;to here

                                               ; 0A88 from 0A0E (DD0,108,13C)
                                               ; 0A88 from 3684 (DD0,108,13C)
                                               ; 0A88 from 0A17 (DD0,108,13C)
                                               ; 0A88 from 0A32 (DD0,108,13C)
                                               ; 0A88 from 0A4A (DD0,108,13C)
                                               ; 0A88 from 0A83 (DD0,108,13C)
label_0a88:     LB      A, r7                  ; 0A88 0 108 13C 7F
                SWAPB                          ; 0A89 0 108 13C 83
                SRLB    A                      ; 0A8A 0 108 13C 63
                STB     A, r7                  ; 0A8B 0 108 13C 8F
                LB      A, P1                  ; 0A8C 0 108 13C F522
                ANDB    A, #0c7h               ; 0A8E 0 108 13C D6C7
                ORB     A, r7                  ; 0A90 0 108 13C 6F
                STB     A, P1                  ; 0A91 0 108 13C D522

                MOV     er1, #08000h           ; 0A93 0 108 13C 45980080
                LB      A, 09ah                ; IAT
                CMPB    A, #003h               ; 0A99 0 108 13C C603
                JLE     label_0ab3             ; 0A9B 0 108 13C CF16
                MOVB    r0, #080h              ; 0A9D 0 108 13C 9880
                ADDB    A, r0                  ; A = [9ah] + #80h
                STB     A, r4                  ; r4 = [9ah] + #80h
                LCB     A, 02f45h              ; [2f45h] == 0
                SRLB    A                      ; shift right
                LB      A, r4                  ; A = [9ah] + #80h
                JGE     label_0ab4             ; if no carry
                LB      A, 09ah                ; IAT
                MULB                           ; 0AAB 0 108 13C A234
                MOV     er1, ACC               ; 0AAD 0 108 13C B50649
                ADDB    r3, #040h              ; 0AB0 0 108 13C 238040
                                               ; 0AB3 from 0A9B (DD0,108,13C)
label_0ab3:     CLRB    A                      ; 0AB3 0 108 13C FA
                                               ; 0AB4 from 0AA7 (DD0,108,13C)
label_0ab4:     STB     A, off(00152h)         ; 0AB4 0 108 13C D452
                MOV     off(00160h), er1       ; IAT correction
                LB      A, #003h               ; 0AB9 0 108 13C 7703
                JBS     off(0011bh).7, label_0ac0 ; 0ABB 0 108 13C EF1B02
                LB      A, #008h               ; 0ABE 0 108 13C 7708
                                               ; 0AC0 from 0ABB (DD0,108,13C)
label_0ac0:     CMPB    A, 0a6h                ; 0AC0 0 108 13C C5A6C2
                MB      off(0011bh).7, C       ; 0AC3 0 108 13C C41B3F
                LB      A, #0c5h               ; 0AC6 0 108 13C 77C5
                JBS     off(0011bh).6, label_0acd ; 0AC8 0 108 13C EE1B02
                LB      A, #0c9h               ; 0ACB 0 108 13C 77C9

                ;fuel
                                               ; 0ACD from 0AC8 (DD0,108,13C)
label_0acd:     CMPB    A, 0a6h                ; 0ACD 0 108 13C C5A6C2
                MB      off(0011bh).6, C       ; 0AD0 0 108 13C C41B3E
                MOVB    r6, 0b5h               ; move in column
                MOVB    r7, 0a6h               ; rpm for non vtec
                NOP
                NOP
                NOP
               ; NOP
               ; NOP
               ; NOP
               ; NOP
               ; NOP
               ; NOP

                ;non vtec fuel map
                MOV     X1, #fuelmap			;
                ;MOV     X2, #revscalar_fu		; 0AE5 0 108 13C 61D63B
                MOV     X2, #03bd6h            ;
                                               ; 0AE8 from 0ADF (DD0,108,13C)
label_0ae8:     RB      off(00129h).0
				RB      PSWL.5                 ; 0AE8 0 108 13C A30D
                CAL     label_2af3             ; 0AEA 0 108 13C 32F32A
                CAL     label_2b7c             ; 0AED 0 108 13C 327C2B
                STB     A, off(00140h)         ; store non vtec fuel value


                MOVB    r6, 0b5h               ; move in column
                MOVB    r7, 0a7h               ; move in vtec rpm
                NOP
                NOP
                NOP
                NOP
                NOP
                NOP
                NOP
                NOP
                NOP

                ;vtec fuel map
                MOV     X1, #fuelmapv			;
                ;MOV     X2, #revscalar_fuv		; 0B04 0 108 13C 61E63B
                MOV     X2, #03be6h            ;
                                               ; 0B07 from 0AFE (DD0,108,13C)
                ;logging change
label_0b07:    	SB      off(00129h).0
				RB      off(00129h).2          ; 0B07 0 108 13C C4290A
                RB      PSWL.5                 ; 0B0A 0 108 13C A30D
                CAL     label_2af3             ; 0B0C 0 108 13C 32F32A
                CAL     label_2b7c             ; 0B0F 0 108 13C 327C2B
                STB     A, off(00142h)         ; 0B12 0 108 13C D442


                LB      A, #008h               ; 0B14 0 108 13C 7708
                MOVB    r0, #020h              ; 0B16 0 108 13C 9820
                JBS     off(00129h).3, label_0b1f ; 0B18 0 108 13C EB2904
                LB      A, #010h               ; 0B1B 0 108 13C 7710
                MOVB    r0, #028h              ; 0B1D 0 108 13C 9828
                                               ; 0B1F from 0B18 (DD0,108,13C)
label_0b1f:     JBS     off(00118h).7, label_0b23 ; 0B1F 0 108 13C EF1801
                LB      A, r0                  ; 0B22 0 108 13C 78
                                               ; 0B23 from 0B1F (DD0,108,13C)

;vtec
label_0b23:     CMPB    A, 0cbh                ; 0B23 0 108 13C C5CBC2
                MB      off(00129h).3, C       ; 0B26 0 108 13C C4293B
                MOV     DP, #03414h            ; 0B29 0 108 13C 621434
                MOV     X1, #0341ch            ; 0B2C 0 108 13C 601C34
                JBS     off(00118h).7, label_0b38 ; 0B2F 0 108 13C EF1806
                MOV     DP, #03418h            ; 0B32 0 108 13C 621834
                MOV     X1, #03431h            ; 0B35 0 108 13C 603134
                                               ; 0B38 from 0B2F (DD0,108,13C)
label_0b38:     LC      A, [DP]                ; 0B38 0 108 13C 92A8
                INC     DP                     ; 0B3A 0 108 13C 72
                INC     DP                     ; 0B3B 0 108 13C 72
                JBS     off(00129h).4, label_0b41 ; 0B3C 0 108 13C EC2902
                LB      A, ACCH                ; 0B3F 0 108 13C F507
                                               ; 0B41 from 0B3C (DD0,108,13C)
label_0b41:     CMPB    A, 0a6h                ; 0B41 0 108 13C C5A6C2
                MB      off(00129h).4, C       ; 0B44 0 108 13C C4293C
                LC      A, [DP]                ; 0B47 0 108 13C 92A8
                JBS     off(00129h).5, label_0b4e ; 0B49 0 108 13C ED2902
                LB      A, ACCH                ; 0B4C 0 108 13C F507
                                               ; 0B4E from 0B49 (DD0,108,13C)
label_0b4e:     CMPB    A, 0a6h                ; 0B4E 0 108 13C C5A6C2
                MB      off(00129h).5, C       ; 0B51 0 108 13C C4293D
                LB      A, 0a6h                ; 0B54 0 108 13C F5A6
                VCAL    1                      ; 0B56 0 108 13C 11
                STB     A, off(00154h)         ; 0B57 0 108 13C D454
                LB      A, off(00130h)         ; 0B59 0 108 13C F430
                ANDB    A, #0bch               ; 0B5B 0 108 13C D6BC
                JNE     label_0b6b             ; 0B5D 0 108 13C CE0C
                LB      A, off(00131h)         ; 0B5F 0 108 13C F431
                MOV     er0, #0fcedh           ; 0B61 0 108 13C 4498EDFC


                LB      A, off(00132h)         ; 0B65 0 108 13C F432
                ANDB    A, #031h               ; 0B67 0 108 13C D631
                JEQ     label_0b70             ; 0B69 0 108 13C C905
                                               ; 0B6B from 0B5D (DD0,108,13C)
                ;error
label_0b6b:     SB      P1.1                   ; 0B6B 0 108 13C C52219
                SJ      label_0b90             ; 0B6E 0 108 13C CB20
                                               ; 0B70 from 0B69 (DD0,108,13C)
                ;no error
label_0b70:     RB      P1.1                   ; 0B70 0 108 13C C52209
                CMPB    off(001abh), #032h     ; 0B73 0 108 13C C4ABC032
                JLT     label_0b90             ; 0B77 0 108 13C CA17
                ;NOP
                ;NOP

                CMPB    0a4h, #044h				;mugen chaged to compare ffh  ;vtec temp check disable
                JGE     label_0b90             ; 0B7D 0 108 13C CD11

                ;vss check
                ;JBR     off(00129h).3, label_0b90 ; 0B7F 0 108 13C DB290E
                NOP		;vss check diasable
                NOP
                NOP

                JBR     off(00118h).7, label_0b8a ; 0B82 0 108 13C DF1805
                MB      C, 0f3h.5              ; 0B85 0 108 13C C5F32D
                JLT     label_0b8d             ; 0B88 0 108 13C CA03
                                               ; 0B8A from 0B82 (DD0,108,13C)
label_0b8a:     JBS     off(00129h).4, label_0b98 ; 0B8A 0 108 13C EC290B
                                               ; 0B8D from 0B88 (DD0,108,13C)
label_0b8d:     JBS     off(00129h).7, label_0bdb ; 0B8D 0 108 13C EF294B
                                               ; 0B90 from 0B6E (DD0,108,13C)
                                               ; 0B90 from 0B77 (DD0,108,13C)
                                               ; 0B90 from 0B7D (DD0,108,13C)
                ;error handling or rpm <= vtec vals                                ; 0B90 from 0B7F (DD0,108,13C)
label_0b90:     SB      P1.0                   ; 0B90 0 108 13C C52218
                RB      off(00129h).6          ; 0B93 0 108 13C C4290E
                SJ      label_0bed             ; 0B96 0 108 13C CB55
                                               ; 0B98 from 0B8A (DD0,108,13C)
label_0b98:     JBS     off(00129h).5, label_0bbf ; 0B98 0 108 13C ED2924
                JBS     off(0011bh).6, label_0bb3 ; 0B9B 0 108 13C EE1B15
                JBS     off(00122h).1, label_0bbf ; 0B9E 0 108 13C E9221E
                                               ; 0BA1 from 0BBD (DD1,108,13C)
label_0ba1:     L       A, off(00140h)         ; 0BA1 1 108 13C E440
                JBR     off(00129h).6, label_0ba9 ; 0BA3 1 108 13C DE2903
                J       label_3738             ; 0BA6 1 108 13C 033837
                                               ; 0BA9 from 0BA3 (DD1,108,13C)
                                               ; 0BA9 from 3741 (DD1,108,13C)
label_0ba9:     CMP     A, off(00142h)         ; 0BA9 1 108 13C C742
                JLT     label_0bbf             ; 0BAB 1 108 13C CA12
                LB      A, off(001dfh)         ; 0BAD 0 108 13C F4DF
                JNE     label_0bc3             ; 0BAF 0 108 13C CE12
                SJ      label_0bdb             ; 0BB1 0 108 13C CB28
                                               ; 0BB3 from 0B9B (DD0,108,13C)
label_0bb3:     L       A, 0d6h                ; 0BB3 1 108 13C E5D6
                JBR     off(00129h).6, label_0bbb ; 0BB5 1 108 13C DE2903
                ADD     A, #000a0h             ; 0BB8 1 108 13C 86A000
                                               ; 0BBB from 0BB5 (DD1,108,13C)
label_0bbb:     CMP     A, off(00154h)         ; 0BBB 1 108 13C C754
                JLT     label_0ba1             ; 0BBD 1 108 13C CAE2
                                               ; 0BBF from 0B98 (DD0,108,13C)
                                               ; 0BBF from 0B9E (DD0,108,13C)
                                               ; 0BBF from 0BAB (DD1,108,13C)
label_0bbf:     MOVB    off(001dfh), #014h     ; 0BBF 0 108 13C C4DF9814
                                               ; 0BC3 from 0BAF (DD0,108,13C)
label_0bc3:     RB      P1.0                   ; 0BC3 0 108 13C C52208
                SB      off(00129h).6          ; 0BC6 0 108 13C C4291E
                MB      C, 0f3h.2              ; 0BC9 0 108 13C C5F32A
                JGE     label_0be9    ;mugen -> NOP NOP         ; 0BCC 0 108 13C CD1B
                                               ; 0BCE from 0BE7 (DD0,108,13C)
label_0bce:     LB      A, off(001b8h)         ; 0BCE 0 108 13C F4B8
                JNE     label_0bf1             ; 0BD0 0 108 13C CE1F
                MOVB    off(001b9h), #00ah     ; 0BD2 0 108 13C C4B9980A
                                               ; 0BD6 from 0BEB (DD0,108,13C)
label_0bd6:     SB      off(00129h).7          ; 0BD6 0 108 13C C4291F
                SJ      label_0bf4             ; 0BD9 0 108 13C CB19
                                               ; 0BDB from 0B8D (DD0,108,13C)
                                               ; 0BDB from 0BB1 (DD0,108,13C)
label_0bdb:     CLRB    off(001dfh)            ; 0BDB 0 108 13C C4DF15
                SB      P1.0                   ; 0BDE 0 108 13C C52218
                RB      off(00129h).6          ; 0BE1 0 108 13C C4290E
                MB      C, 0f3h.2              ; 0BE4 0 108 13C C5F32A
                JLT     label_0bce       ;mugen -> NOP NOP      ; 0BE7 0 108 13C CAE5
                                               ; 0BE9 from 0BCC (DD0,108,13C)
label_0be9:     LB      A, off(001b9h)         ; 0BE9 0 108 13C F4B9
                JNE     label_0bd6             ; 0BEB 0 108 13C CEE9
                                               ; 0BED from 0B96 (DD0,108,13C)
label_0bed:     MOVB    off(001b8h), #00ah     ; 0BED 0 108 13C C4B8980A
                                               ; 0BF1 from 0BD0 (DD0,108,13C)
label_0bf1:     RB      off(00129h).7          ; 0BF1 0 108 13C C4290F
                                               ; 0BF4 from 0BD9 (DD0,108,13C)
label_0bf4:     JBS     off(00123h).3, label_0c12 ; 0BF4 0 108 13C EB231B
                CMPB    0a4h, #034h       ;mugen changed to 00h     ; euro pw0 has ~this stock
                JGE     label_0c13             ; 0BFB 0 108 13C CD16
                LB      A, #046h        ;mugen change to FFh       ; euro pw0 has this stock
                CMPB    A, 0a6h                ; 0BFF 0 108 13C C5A6C2
                JGE     label_0c13             ; 0C02 0 108 13C CD0F
                JBS     off(00123h).0, label_0c13 ; 0C04 0 108 13C E8230C
                JBS     off(0011eh).4, label_0c12 ; 0C07 0 108 13C EC1E08
                L       A, #00200h             ; 0C0A 1 108 13C 670002
                CMP     A, 0bch                ; 0C0D 1 108 13C B5BCC2
                JLT     label_0c13             ; 0C10 1 108 13C CA01
                                               ; 0C12 from 0BF4 (DD0,108,13C)
                                               ; 0C12 from 0C07 (DD0,108,13C)
label_0c12:     RC                             ; 0C12 1 108 13C 95
                                               ; 0C13 from 0BFB (DD0,108,13C)
                                               ; 0C13 from 0C02 (DD0,108,13C)
                                               ; 0C13 from 0C04 (DD0,108,13C)
                                               ; 0C13 from 0C10 (DD1,108,13C)
label_0c13:     MB      off(00123h).0, C       ; 0C13 1 108 13C C42338
                MB      C, off(00123h).1       ; 0C16 1 108 13C C42329
                MB      off(00123h).2, C       ; 0C19 1 108 13C C4233A
                MB      C, 0f2h.6              ; 0C1C 1 108 13C C5F22E
                MB      off(00123h).1, C       ; 0C1F 1 108 13C C42339
                MOV     X1, #031f4h            ; 0C22 1 108 13C 60F431
                LB      A, 0a6h                ; 0C25 0 108 13C F5A6
                VCAL    0                      ; 0C27 0 108 13C 10
                STB     A, off(001a1h)         ; 0C28 0 108 13C D4A1
                RC                             ; 0C2A 0 108 13C 95
                JBS     off(00118h).7, label_0c3a ; 0C2B 0 108 13C EF180C
                JBS     off(00128h).3, label_0c3a ; 0C2E 0 108 13C EB2809
                LB      A, off(00130h)         ; 0C31 0 108 13C F430
                ANDB    A, #054h               ; 0C33 0 108 13C D654
                JNE     label_0c3a             ; 0C35 0 108 13C CE03
                JBR     off(00132h).0, label_0c3f ; 0C37 0 108 13C D83205
                                               ; 0C3A from 0C2B (DD0,108,13C)
                                               ; 0C3A from 0C2E (DD0,108,13C)
                                               ; 0C3A from 0C35 (DD0,108,13C)
label_0c3a:     MB      off(00121h).6, C       ; 0C3A 0 108 13C C4213E
                SJ      label_0c8d             ; 0C3D 0 108 13C CB4E
                                               ; 0C3F from 0C37 (DD0,108,13C)
label_0c3f:     JBS     off(0011fh).5, label_0c47 ; 0C3F 0 108 13C ED1F05
                MB      C, 0f2h.6              ; 0C42 0 108 13C C5F22E
                JGE     label_0c4b             ; 0C45 0 108 13C CD04
                                               ; 0C47 from 0C3F (DD0,108,13C)
label_0c47:     MB      off(00121h).6, C       ; 0C47 0 108 13C C4213E
                RC                             ; 0C4A 0 108 13C 95
                                               ; 0C4B from 0C45 (DD0,108,13C)
label_0c4b:     JBS     off(00121h).6, label_0c56 ; 0C4B 0 108 13C EE2108
                JBR     off(00124h).1, label_0c8d ; 0C4E 0 108 13C D9243C
                MOV     DP, #031e8h            ; 0C51 0 108 13C 62E831
                SJ      label_0c6b             ; 0C54 0 108 13C CB15
                                               ; 0C56 from 0C4B (DD0,108,13C)
label_0c56:     JBR     off(00123h).3, label_0c90 ; 0C56 0 108 13C DB2337
                JBR     off(00124h).1, label_0c8d ; 0C59 0 108 13C D92431
                LB      A, #000h               ; 0C5C 0 108 13C 7700
                JBS     off(00121h).7, label_0c63 ; 0C5E 0 108 13C EF2102
                LB      A, #000h               ; 0C61 0 108 13C 7700
                                               ; 0C63 from 0C5E (DD0,108,13C)
label_0c63:     CMPB    0a6h, A                ; 0C63 0 108 13C C5A6C1
                JGE     label_0c8d             ; 0C66 0 108 13C CD25
                MOV     DP, #031eeh            ; 0C68 0 108 13C 62EE31
                                               ; 0C6B from 0C54 (DD0,108,13C)
label_0c6b:     LC      A, [DP]                ; 0C6B 0 108 13C 92A8
                MOV     er0, 0bah              ; 0C6D 0 108 13C B5BA48
                MUL                            ; 0C70 0 108 13C 9035
                LB      A, r3                  ; 0C72 0 108 13C 7B
                JNE     label_0c87             ; 0C73 0 108 13C CE12
                MOVB    r3, ACCH               ; 0C75 0 108 13C C5074B
                L       A, er1                 ; 0C78 1 108 13C 35
                SWAP                           ; 0C79 1 108 13C 83
                ST      A, er1                 ; 0C7A 1 108 13C 89
                INC     DP                     ; 0C7B 1 108 13C 72
                INC     DP                     ; 0C7C 1 108 13C 72
                JBR     off(00121h).7, label_0c82 ; 0C7D 1 108 13C DF2102
                INC     DP                     ; 0C80 1 108 13C 72
                INC     DP                     ; 0C81 1 108 13C 72
                                               ; 0C82 from 0C7D (DD1,108,13C)
label_0c82:     LC      A, [DP]                ; 0C82 1 108 13C 92A8
                ADD     A, er1                 ; 0C84 1 108 13C 09
                JGE     label_0c8a             ; 0C85 1 108 13C CD03
                                               ; 0C87 from 0C73 (DD0,108,13C)
label_0c87:     L       A, #0ffffh             ; 0C87 1 108 13C 67FFFF
                                               ; 0C8A from 0C85 (DD1,108,13C)
label_0c8a:     CMP     A, 0c4h                ; 0C8A 1 108 13C B5C4C2
                                               ; 0C8D from 0C3D (DD0,108,13C)
                                               ; 0C8D from 0C4E (DD0,108,13C)
                                               ; 0C8D from 0C59 (DD0,108,13C)
                                               ; 0C8D from 0C66 (DD0,108,13C)
label_0c8d:     MB      off(00121h).7, C       ; 0C8D 0 108 13C C4213F
                                               ; 0C90 from 0C56 (DD0,108,13C)
label_0c90:     RC                             ; 0C90 0 108 13C 95
                JBS     off(00130h).6, label_0c9f ; 0C91 0 108 13C EE300B
                JBR     off(00124h).1, label_0c9f ; 0C94 0 108 13C D92408
                MB      C, off(00123h).1       ; 0C97 0 108 13C C42329
                JLT     label_0c9f             ; 0C9A 0 108 13C CA03
                JBR     off(00123h).3, label_0ca2 ; 0C9C 0 108 13C DB2303
                                               ; 0C9F from 0C91 (DD0,108,13C)
                                               ; 0C9F from 0C94 (DD0,108,13C)
                                               ; 0C9F from 0C9A (DD0,108,13C)
label_0c9f:     MB      off(00123h).7, C       ; 0C9F 0 108 13C C4233F
                                               ; 0CA2 from 0C9C (DD0,108,13C)
label_0ca2:     MOVB    r6, #042h              ; 0CA2 0 108 13C 9E42
                L       A, #0602eh             ; 0CA4 1 108 13C 672E60
                MOV     X1, #0320ah            ; 0CA7 1 108 13C 600A32
                MOV     DP, #03219h            ; 0CAA 1 108 13C 621932
                JBR     off(00123h).7, label_0cb3 ; 0CAD 1 108 13C DF2303
                MOV     DP, #0321ch            ; 0CB0 1 108 13C 621C32
                                               ; 0CB3 from 0CAD (DD1,108,13C)
label_0cb3:     JBS     off(00118h).7, label_0cc1 ; 0CB3 1 108 13C EF180B
                MOVB    r6, #040h              ; 0CB6 1 108 13C 9E40
                L       A, #0602eh             ; 0CB8 1 108 13C 672E60
                MOV     X1, #031feh            ; 0CBB 1 108 13C 60FE31
                MOV     DP, #03216h            ; 0CBE 1 108 13C 621632
                                               ; 0CC1 from 0CB3 (DD1,108,13C)
label_0cc1:     ST      A, er1                 ; 0CC1 1 108 13C 89
                LB      A, 0a4h                ; 0CC2 0 108 13C F5A4
                CMPB    A, r2                  ; 0CC4 0 108 13C 4A
                JLT     label_0cc8             ; 0CC5 0 108 13C CA01
                VCAL    0                      ; 0CC7 0 108 13C 10
                                               ; 0CC8 from 0CC5 (DD0,108,13C)
label_0cc8:     LB      A, r6                  ; 0CC8 0 108 13C 7E
                JBR     off(0012ah).6, label_0cd0 ; 0CC9 0 108 13C DE2A04
                CMPB    A, r3                  ; 0CCC 0 108 13C 4B
                JGE     label_0cd0             ; 0CCD 0 108 13C CD01
                LB      A, r3                  ; 0CCF 0 108 13C 7B
                                               ; 0CD0 from 0CC9 (DD0,108,13C)
                                               ; 0CD0 from 0CCD (DD0,108,13C)
label_0cd0:     JBR     off(00120h).4, label_0cd8 ; 0CD0 0 108 13C DC2005
                SUBB    A, #01ch               ; 0CD3 0 108 13C A61C
                JGE     label_0cd8             ; 0CD5 0 108 13C CD01
                CLRB    A                      ; 0CD7 0 108 13C FA
                                               ; 0CD8 from 0CD0 (DD0,108,13C)
                                               ; 0CD8 from 0CD5 (DD0,108,13C)
label_0cd8:     STB     A, r6                  ; 0CD8 0 108 13C 8E
                STB     A, off(0019fh)         ; 0CD9 0 108 13C D49F
                LB      A, r2                  ; 0CDB 0 108 13C 7A
                CMPB    A, 0a4h                ; 0CDC 0 108 13C C5A4C2
                JGT     label_0cee             ; 0CDF 0 108 13C C80D
                INC     DP                     ; 0CE1 0 108 13C 72

                ;what is this?? checking if there are ANY error codes
                LB      A, off(00130h)         ; 0CE2 0 108 13C F430
                ORB     A, off(00131h)         ; 0CE4 0 108 13C E731
                ORB     A, off(00132h)         ; 0CE6 0 108 13C E732
                JNE     label_0cee             ; jump if there are ANY errors
                JBS     off(00124h).1, label_0cee ; 0CEA 0 108 13C E92401
                INC     DP                     ; 0CED 0 108 13C 72
                                               ; 0CEE from 0CDF (DD0,108,13C)
                                               ; 0CEE from 0CE8 (DD0,108,13C)
                                               ; 0CEE from 0CEA (DD0,108,13C)
label_0cee:     LCB     A, [DP]                ; 0CEE 0 108 13C 92AA
                ADDB    A, r6                  ; 0CF0 0 108 13C 0E
                JGE     label_0cf5             ; 0CF1 0 108 13C CD02
                LB      A, #0ffh               ; 0CF3 0 108 13C 77FF
                                               ; 0CF5 from 0CF1 (DD0,108,13C)
label_0cf5:     STB     A, off(001a0h)         ; 0CF5 0 108 13C D4A0
                JBR     off(00123h).1, label_0cfb ; 0CF7 0 108 13C D92301
                LB      A, r6                  ; 0CFA 0 108 13C 7E
                                               ; 0CFB from 0CF7 (DD0,108,13C)
label_0cfb:     CMPB    A, 0a6h                ; 0CFB 0 108 13C C5A6C2
                MB      off(00121h).5, C       ; 0CFE 0 108 13C C4213D
                MOV     DP, #031d4h            ; 0D01 0 108 13C 62D431
                J       label_41b6             ; 0D04 0 108 13C 03B641
                DB  062h,0DCh,031h ; 0D07

;revlimit 31DCh, restart 41dbh
                                               ; 0D0A from 41D0 (DD1,108,13C)
label_0d0a:     L       A, 0c4h                ; load speed word
                CMP     A, er0                 ; compare speed
                NOP                            ; restart: 0154h
                NOP                            ; speed limiter: 0154h ~= 5400rpm
                JLT     label_0d20             ; if the limit value is greater than the actual speed then jump (speed limiter)
                INC     DP                     ; restart: 0EDh
                INC     DP						;high cam: 00e7h = 8k
                JBS     off(00129h).7, label_0d20 ; if vtec then jump
                INC     DP                     ; restart: 101h
                INC     DP                     ; non vtec: 00fah = 7392
                CMPB    0a4h, #02eh				;temp check
                JLT     label_0d20             ; if hot and no vtec then use above limit
                INC     DP                     ; restart 114h
                INC     DP                     ; were cold and not in vtec: 010ch = 6900
                                               ; 0D20 from 0D0F (DD1,108,13C)
                                               ; 0D20 from 0D13 (DD1,108,13C)
                                               ; 0D20 from 0D1C (DD1,108,13C)

                ;
label_0d20:     LC      A, [DP]                ; 0D20 1 108 13C 92A8
				;launch goes here
				CAL		launch
                ;MB      C, P2.4                ; 0D22 1 108 13C C5242C
                JLT     label_0d2a             ; 0D25 1 108 13C CA03
                JBR     off(00131h).7, label_0d2d ; 0D27 1 108 13C DF3103
                                               ; 0D2A from 0D25 (DD1,108,13C)
label_0d2a:     L       A, #00240h             ; 0D2A 1 108 13C 674002
                                               ; 0D2D from 0D27 (DD1,108,13C)
label_0d2d:     NOP                            ; 0D2D 1 108 13C 00
                NOP                            ; 0D2E 1 108 13C 00
                CMP     0bah, A                ; 0D2F 1 108 13C B5BAC1
                MB      0f2h.7, C              ; 0D32 1 108 13C C5F23F
                JLT     label_0d63             ; 0D35 1 108 13C CA2C
                SC                             ; 0D37 1 108 13C 85
                JBS     off(00131h).5, label_0d43 ; 0D38 1 108 13C ED3108
                JBS     off(0012dh).0, label_0d43 ; 0D3B 1 108 13C E82D05
                NOP                            ; 0D3E 1 108 13C 00
                CMPB    0a9h, #010h            ; 0D3F 1 108 13C C5A9C010
                                               ; 0D43 from 0D38 (DD1,108,13C)
                                               ; 0D43 from 0D3B (DD1,108,13C)

                ; skips from here:
label_0d43:     MB      off(00128h).3, C
				;J		label_0d63
				;MB      off(00128h).3, C   ;mugen changed to -> J  label_0d63    ; 0D43 1 108 13C C4283B
                JGE     label_0d63             ; 0D46 1 108 13C CD1B
                LB      A, #097h               ; 0D48 0 108 13C 7797
                JBS     off(00130h).6, label_0d5b ; 0D4A 0 108 13C EE300E
                JBS     off(0012ch).2, label_0d5b ; 0D4D 0 108 13C EA2C0B
                LB      A, 0ach                ; 0D50 0 108 13C F5AC
                CMPB    A, #044h               ; 0D52 0 108 13C C644
                JGE     label_0d5e             ; 0D54 0 108 13C CD08
                MOV     X1, #031e4h            ; 0D56 0 108 13C 60E431
                VCAL    2                      ; 0D59 0 108 13C 12
                LB      A, r6                  ; 0D5A 0 108 13C 7E
                                               ; 0D5B from 0D4A (DD0,108,13C)
                                               ; 0D5B from 0D4D (DD0,108,13C)
label_0d5b:     CMPB    A, 0a6h                ; 0D5B 0 108 13C C5A6C2
                                               ; 0D5E from 0D54 (DD0,108,13C)
label_0d5e:     MB      0f2h.7, C              ; 0D5E 0 108 13C C5F23F
                SJ      label_0d72             ; 0D61 0 108 13C CB0F
                ;to here
                                               ; 0D63 from 0D35 (DD1,108,13C)
                                               ; 0D63 from 0D46 (DD1,108,13C)
label_0d63:     JBS     off(00123h).0, label_0d89 ; 0D63 1 108 13C E82323
                LB      A, off(001fch)         ; 0D66 0 108 13C F4FC
                JNE     label_0d89             ; 0D68 0 108 13C CE1F
                JBS     off(00123h).3, label_0d72 ; 0D6A 0 108 13C EB2305
                MOVB    r7, #001h              ; 0D6D 0 108 13C 9F01
                JBS     off(00121h).5, label_0d80 ; 0D6F 0 108 13C ED210E
                                               ; 0D72 from 0D61 (DD0,108,13C)
                                               ; 0D72 from 0D6A (DD0,108,13C)
label_0d72:     J       label_371f             ; 0D72 0 108 13C 031F37
                DB  0A1h ; 0D75
                                               ; 0D76 from 3735 (DD0,108,13C)
label_0d76:     JBR     off(00123h).1, label_0d7b ; 0D76 0 108 13C D92302
                ADDB    A, #009h               ; 0D79 0 108 13C 8609
                                               ; 0D7B from 0D76 (DD0,108,13C)
label_0d7b:     CMPB    0b3h, A                ; 0D7B 0 108 13C C5B3C1
                JGE     label_0d89             ; 0D7E 0 108 13C CD09
                                               ; 0D80 from 0D6F (DD0,108,13C)
label_0d80:     LB      A, off(001dbh)         ; 0D80 0 108 13C F4DB
                JNE     label_0dd0             ; 0D82 0 108 13C CE4C
                SC                             ; 0D84 0 108 13C 85
                CLRB    r7                     ; 0D85 0 108 13C 2715
                SJ      label_0dd1             ; 0D87 0 108 13C CB48
                                               ; 0D89 from 0D63 (DD1,108,13C)
                                               ; 0D89 from 0D68 (DD0,108,13C)
                                               ; 0D89 from 372E (DD0,108,13C)
                                               ; 0D89 from 0D7E (DD0,108,13C)
label_0d89:     MOV     DP, #031d2h            ; 0D89 1 108 13C 62D231
                CMPB    0a4h, #080h            ; 0D8C 1 108 13C C5A4C080
                JLT     label_0d98             ; 0D90 1 108 13C CA06
                CMPB    off(001b0h), #00fh     ; 0D92 1 108 13C C4B0C00F
                JLT     label_0d9f             ; 0D96 1 108 13C CA07
                                               ; 0D98 from 0D90 (DD1,108,13C)
label_0d98:     DEC     DP                     ; 0D98 1 108 13C 82
                DEC     DP                     ; 0D99 1 108 13C 82
                J       label_40b5             ; 0D9A 1 108 13C 03B540
                                               ; 0D9D from 40B9 (DD1,108,13C)
label_0d9d:     DEC     DP                     ; 0D9D 1 108 13C 82
                DEC     DP                     ; 0D9E 1 108 13C 82
                                               ; 0D9F from 0D96 (DD1,108,13C)
                                               ; 0D9F from 40BC (DD1,108,13C)
label_0d9f:     J       label_40bf             ; 0D9F 1 108 13C 03BF40
                DB  032h ; 0DA2
                                               ; 0DA3 from 40C6 (DD1,108,13C)
label_0da3:     JGE     label_0dc1             ; 0DA3 1 108 13C CD1C
                JBR     off(00124h).3, label_0dc1 ; 0DA5 1 108 13C DB2419
                LB      A, #089h               ; 0DA8 0 108 13C 7789
                MOVB    r0, #077h              ; 0DAA 0 108 13C 9877
                JBS     off(00123h).6, label_0db3 ; 0DAC 0 108 13C EE2304
                LB      A, #091h               ; 0DAF 0 108 13C 7791
                MOVB    r0, #09ch              ; 0DB1 0 108 13C 989C
                                               ; 0DB3 from 0DAC (DD0,108,13C)
label_0db3:     CMPB    A, 0a6h                ; 0DB3 0 108 13C C5A6C2
                JLT     label_0dbc             ; 0DB6 0 108 13C CA04
                LB      A, r0                  ; 0DB8 0 108 13C 78
                CMPB    A, 0b3h                ; 0DB9 0 108 13C C5B3C2
                                               ; 0DBC from 0DB6 (DD0,108,13C)
label_0dbc:     MB      off(00123h).6, C       ; 0DBC 0 108 13C C4233E
                JGE     label_0dc5             ; 0DBF 0 108 13C CD04
                                               ; 0DC1 from 0DA3 (DD1,108,13C)
                                               ; 0DC1 from 0DA5 (DD1,108,13C)
label_0dc1:     MOVB    off(001e0h), #00fh     ; 0DC1 0 108 13C C4E0980F
                                               ; 0DC5 from 0DBF (DD0,108,13C)
label_0dc5:     LB      A, off(001e0h)         ; 0DC5 0 108 13C F4E0
                JEQ     label_0dca             ; 0DC7 0 108 13C C901
                INC     DP                     ; 0DC9 0 108 13C 72
                                               ; 0DCA from 0DC7 (DD0,108,13C)
label_0dca:     LCB     A, [DP]                ; 0DCA 0 108 13C 92AA
                STB     A, off(001dbh)         ; 0DCC 0 108 13C D4DB
                CLRB    r7                     ; 0DCE 0 108 13C 2715
                                               ; 0DD0 from 0D82 (DD0,108,13C)
label_0dd0:     RC                             ; 0DD0 0 108 13C 95
                                               ; 0DD1 from 0D87 (DD0,108,13C)
label_0dd1:     MB      0f2h.6, C              ; 0DD1 0 108 13C C5F23E
                SRLB    r7                     ; 0DD4 0 108 13C 27E7
                MB      off(00120h).4, C       ; 0DD6 0 108 13C C4203C
                MOVB    r0, #04ch       ;mugen -> #040h       ; 0DD9 0 108 13C 984C
                MOVB    r1, #04ch       ;mugen -> #040h        ; 0DDB 0 108 13C 994C
                MOVB    r2, #043h       ;mugen -> #040h        ; 0DDD 0 108 13C 9A43
                MOVB    r3, #051h       ;mugen -> #040h        ; 0DDF 0 108 13C 9B51
                JBR     off(0012bh).2, label_0dec ; 0DE1 0 108 13C DA2B08
                MOVB    r0, #04ch       ;mugen -> #040h        ; 0DE4 0 108 13C 984C
                MOVB    r1, #04ch       ;mugen -> #040h        ; 0DE6 0 108 13C 994C
                MOVB    r2, #043h       ;mugen -> #040h       ; 0DE8 0 108 13C 9A43
                MOVB    r3, #051h       ;mugen -> #040h       ; 0DEA 0 108 13C 9B51
                                               ; 0DEC from 0DE1 (DD0,108,13C)
label_0dec:     JBS     off(0011bh).6, label_0e0d ; 0DEC 0 108 13C EE1B1E
                JBR     off(00122h).1, label_0e3e ; 0DEF 0 108 13C D9224C
                LB      A, #03eh               ; 0DF2 0 108 13C 773E
                JBS     off(00122h).2, label_0df9 ; 0DF4 0 108 13C EA2202
                LB      A, #046h               ; 0DF7 0 108 13C 7746
                                               ; 0DF9 from 0DF4 (DD0,108,13C)
label_0df9:     CMPB    A, 0a6h                ; 0DF9 0 108 13C C5A6C2
                MB      off(00122h).2, C       ; 0DFC 0 108 13C C4223A
                MOVB    r1, #051h      ;mugen -> #040h         ; 0DFF 0 108 13C 9951
                JGE     label_0e4a             ; 0E01 0 108 13C CD47
                MOVB    r1, r0                 ; 0E03 0 108 13C 2049
                LB      A, off(001edh)         ; 0E05 0 108 13C F4ED
                JEQ     label_0e4a             ; 0E07 0 108 13C C941
                MOVB    r1, #04ch      ;mugen -> #040h         ; 0E09 0 108 13C 994C
                SJ      label_0e4a             ; 0E0B 0 108 13C CB3D
                                               ; 0E0D from 0DEC (DD0,108,13C)
label_0e0d:     LB      A, #0c2h               ; 0E0D 0 108 13C 77C2
                JBS     off(0012bh).6, label_0e14 ; 0E0F 0 108 13C EE2B02
                LB      A, #0c8h               ; 0E12 0 108 13C 77C8
                                               ; 0E14 from 0E0F (DD0,108,13C)
label_0e14:     CMPB    A, 0b3h                ; 0E14 0 108 13C C5B3C2
                MB      off(0012bh).6, C       ; 0E17 0 108 13C C42B3E
                JLT     label_0e4a             ; 0E1A 0 108 13C CA2E
                LB      A, #0d2h               ; 0E1C 0 108 13C 77D2
                JBS     off(0012bh).7, label_0e23 ; 0E1E 0 108 13C EF2B02
                LB      A, #0ddh               ; 0E21 0 108 13C 77DD
                                               ; 0E23 from 0E1E (DD0,108,13C)
label_0e23:     CMPB    A, 0ach                ; 0E23 0 108 13C C5ACC2
                MB      off(0012bh).7, C       ; 0E26 0 108 13C C42B3F
                JLT     label_0e4a             ; 0E29 0 108 13C CA1F
                LB      A, #0a5h               ; 0E2B 0 108 13C 77A5
                JBS     off(0012bh).5, label_0e32 ; 0E2D 0 108 13C ED2B02
                LB      A, #0adh               ; 0E30 0 108 13C 77AD
                                               ; 0E32 from 0E2D (DD0,108,13C)
label_0e32:     CMPB    A, 0b3h                ; 0E32 0 108 13C C5B3C2
                MB      off(0012bh).5, C       ; 0E35 0 108 13C C42B3D
                JGE     label_0e3e             ; 0E38 0 108 13C CD04
                MOVB    r1, r2                 ; 0E3A 0 108 13C 2249
                SJ      label_0e4a             ; 0E3C 0 108 13C CB0C
                                               ; 0E3E from 0DEF (DD0,108,13C)
                                               ; 0E3E from 0E38 (DD0,108,13C)
label_0e3e:     MOVB    off(001edh), #000h     ; 0E3E 0 108 13C C4ED9800
                MOVB    off(001cdh), #082h     ; 0E42 0 108 13C C4CD9882
                LB      A, #040h               ; 0E46 0 108 13C 7740
                SJ      label_0e57             ; 0E48 0 108 13C CB0D
                                               ; 0E4A from 0E01 (DD0,108,13C)
                                               ; 0E4A from 0E07 (DD0,108,13C)
                                               ; 0E4A from 0E0B (DD0,108,13C)
                                               ; 0E4A from 0E1A (DD0,108,13C)
                                               ; 0E4A from 0E29 (DD0,108,13C)
                                               ; 0E4A from 0E3C (DD0,108,13C)
label_0e4a:     J       label_36d9             ; 0E4A 0 108 13C 03D936
                DB  006h,0C5h,0A4h,0C0h,019h,0CDh,002h ; 0E4D
                                               ; 0E54 from 36FD (DD0,108,13C)
label_0e54:     MOVB    r1, r3                 ; 0E54 0 108 13C 2349
                                               ; 0E56 from 3700 (DD0,108,13C)
label_0e56:     LB      A, r1                  ; 0E56 0 108 13C 79
                                               ; 0E57 from 0E48 (DD0,108,13C)
label_0e57:     STB     A, off(0015bh)         ; 0E57 0 108 13C D45B
                CLRB    r7                     ; 0E59 0 108 13C 2715
                LB      A, off(0016fh)         ; 0E5B 0 108 13C F46F
                JNE     label_0e85             ; 0E5D 0 108 13C CE26
                JBS     off(00122h).1, label_0e85 ; 0E5F 0 108 13C E92223
                JBR     off(0011bh).7, label_0e85 ; 0E62 0 108 13C DF1B20
                MB      C, 0f2h.6              ; 0E65 0 108 13C C5F22E
                JLT     label_0e85             ; 0E68 0 108 13C CA1B
                INCB    r7                     ; 0E6A 0 108 13C AF
                JBR     off(0011bh).6, label_0e85 ; 0E6B 0 108 13C DE1B17
                LB      A, #0e9h               ; 0E6E 0 108 13C 77E9
                MOVB    r0, #055h              ; 0E70 0 108 13C 9855
                JBR     off(0011dh).1, label_0e79 ; 0E72 0 108 13C D91D04
                LB      A, #0ech               ; 0E75 0 108 13C 77EC
                MOVB    r0, #064h              ; 0E77 0 108 13C 9864
                                               ; 0E79 from 0E72 (DD0,108,13C)
label_0e79:     CMPB    A, 0a6h                ; 0E79 0 108 13C C5A6C2
                JLT     label_0e85             ; 0E7C 0 108 13C CA07
                LB      A, r0                  ; 0E7E 0 108 13C 78
                CMPB    A, 0b3h                ; 0E7F 0 108 13C C5B3C2
                JLT     label_0e85             ; 0E82 0 108 13C CA01
                INCB    r7                     ; 0E84 0 108 13C AF
                                               ; 0E85 from 0E5D (DD0,108,13C)
                                               ; 0E85 from 0E5F (DD0,108,13C)
                                               ; 0E85 from 0E62 (DD0,108,13C)
                                               ; 0E85 from 0E68 (DD0,108,13C)
                                               ; 0E85 from 0E6B (DD0,108,13C)
                                               ; 0E85 from 0E7C (DD0,108,13C)
                                               ; 0E85 from 0E82 (DD0,108,13C)
label_0e85:     LB      A, r7                  ; 0E85 0 108 13C 7F
                SRLB    A                      ; 0E86 0 108 13C 63
                MB      off(0011ch).6, C       ; 0E87 0 108 13C C41C3E
                MB      C, off(0011dh).2       ; 0E8A 0 108 13C C41D2A
                MB      off(0011dh).3, C       ; 0E8D 0 108 13C C41D3B
                MB      C, off(0011dh).1       ; 0E90 0 108 13C C41D29
                MB      off(0011dh).2, C       ; 0E93 0 108 13C C41D3A
                SRLB    A                      ; 0E96 0 108 13C 63
                MB      off(0011dh).1, C       ; 0E97 0 108 13C C41D39
                CAL     label_2db2             ; 0E9A 0 108 13C 32B22D
                MB      C, off(0019bh).3       ; 0E9D 0 108 13C C49B2B
                JBS     off(0011eh).2, label_0ea6 ; 0EA0 0 108 13C EA1E03
                MB      C, off(0019bh).2       ; 0EA3 0 108 13C C49B2A
                                               ; 0EA6 from 0EA0 (DD0,108,13C)
label_0ea6:     JGE     label_0eac             ; 0EA6 0 108 13C CD04
                CAL     label_2dd2             ; 0EA8 0 108 13C 32D22D
                SC                             ; 0EAB 0 108 13C 85
                                               ; 0EAC from 0EA6 (DD0,108,13C)
label_0eac:     MB      r7.7, C                ; 0EAC 0 108 13C 273F
                L       A, off(001c8h)         ; 0EAE 1 108 13C E4C8
                JEQ     label_0eb5             ; 0EB0 1 108 13C C903
                DEC     off(001c8h)            ; 0EB2 1 108 13C B4C817
                                               ; 0EB5 from 0EB0 (DD1,108,13C)
label_0eb5:     L       A, off(001cah)         ; 0EB5 1 108 13C E4CA
                JEQ     label_0ebc             ; 0EB7 1 108 13C C903
                DEC     off(001cah)            ; 0EB9 1 108 13C B4CA17
                                               ; 0EBC from 0EB7 (DD1,108,13C)
label_0ebc:     J       label_40f4             ; 0EBC 1 108 13C 03F440
                DB  080h ; 0EBF
                                               ; 0EC0 from 4102 (DD0,108,13C)
label_0ec0:     LB      A, off(00130h)         ; 0EC0 0 108 13C F430
                ANDB    A, #060h               ; 0EC2 0 108 13C D660
                JNE     label_0ef9             ; 0EC4 0 108 13C CE33
                JBS     off(0010fh).0, label_0ef9 ; 0EC6 0 108 13C E80F30
                JBS     off(00131h).7, label_0ef9 ; 0EC9 0 108 13C EF312D
                JBS     off(0010fh).6, label_0ef6 ; 0ECC 0 108 13C EE0F27
                JBR     off(0011eh).1, label_0ef9 ; 0ECF 0 108 13C D91E27
                MB      C, [DP].3              ; 0ED2 0 108 13C C22B
                JGE     label_0eda             ; 0ED4 0 108 13C CD04
                LB      A, (0019fh-0013ch)[USP] ; 0ED6 0 108 13C F363
                JEQ     label_0edf             ; 0ED8 0 108 13C C905
                                               ; 0EDA from 0ED4 (DD0,108,13C)
label_0eda:     JBR     off(0011fh).5, label_0ef9 ; 0EDA 0 108 13C DD1F1C
                SJ      label_0ef6             ; 0EDD 0 108 13C CB17
                                               ; 0EDF from 0ED8 (DD0,108,13C)
label_0edf:     LB      A, #000h               ; 0EDF 0 108 13C 7700
                JBS     off(00122h).1, label_0ef3 ; 0EE1 0 108 13C E9220F
                JBS     off(0011dh).1, label_0efc ; 0EE4 0 108 13C E91D15
                JBS     off(0011bh).6, label_0ef6 ; 0EE7 0 108 13C EE1B0C
                JBS     off(0011ch).6, label_0efc ; 0EEA 0 108 13C EE1C0F
                JBR     off(0011bh).7, label_0ef6 ; 0EED 0 108 13C DF1B06
                J       label_10ae             ; 0EF0 0 108 13C 03AE10
                                               ; 0EF3 from 0EE1 (DD0,108,13C)
label_0ef3:     J       label_108d             ; 0EF3 0 108 13C 038D10
                                               ; 0EF6 from 0ECC (DD0,108,13C)
                                               ; 0EF6 from 0EDD (DD0,108,13C)
                                               ; 0EF6 from 0EE7 (DD0,108,13C)
                                               ; 0EF6 from 0EED (DD0,108,13C)
label_0ef6:     J       label_10c4             ; 0EF6 0 108 13C 03C410
                                               ; 0EF9 from 0EC4 (DD0,108,13C)
                                               ; 0EF9 from 0EC6 (DD0,108,13C)
                                               ; 0EF9 from 0EC9 (DD0,108,13C)
                                               ; 0EF9 from 0ECF (DD0,108,13C)
                                               ; 0EF9 from 0EDA (DD0,108,13C)
label_0ef9:     J       label_10cf             ; 0EF9 0 108 13C 03CF10
                                               ; 0EFC from 0EE4 (DD0,108,13C)
                                               ; 0EFC from 0EEA (DD0,108,13C)
label_0efc:     J       label_1d08             ; 0EFC 0 108 13C 03081D
                                               ; 0EFF from 1D0E (DD0,108,13C)
label_0eff:     LB      A, (00163h-0013ch)[USP] ; 0EFF 0 108 13C F327
                MOV     X1, #02fb6h            ; 0F01 0 108 13C 60B62F
                JEQ     label_0f36             ; 0F04 0 108 13C C930
                SJ      label_0f3a             ; 0F06 0 108 13C CB32
                                               ; 0F08 from 1D11 (DD0,108,13C)
label_0f08:     MOVB    (00163h-0013ch)[USP], #00ah ; 0F08 0 108 13C C327980A
                MOV     X1, #02fe9h            ; 0F0C 0 108 13C 60E92F
                JBS     off(00118h).7, label_0f15 ; 0F0F 0 108 13C EF1803
                MOV     X1, #02fc2h            ; 0F12 0 108 13C 60C22F
                                               ; 0F15 from 0F0F (DD0,108,13C)
label_0f15:     JBR     off(0011bh).6, label_0f22 ; 0F15 0 108 13C DE1B0A
                LCB     A, 00026h[X1]          ; 0F18 0 108 13C 90AB2600
                ADD     X1, #00018h            ; 0F1C 0 108 13C 90801800
                SJ      label_0f31             ; 0F20 0 108 13C CB0F
                                               ; 0F22 from 0F15 (DD0,108,13C)
label_0f22:     LC      A, 00024h[X1]          ; 0F22 0 108 13C 90A92400
                CMPB    A, 0b3h                ; 0F26 0 108 13C C5B3C2
                JGE     label_0f2f             ; 0F29 0 108 13C CD04
                ADD     X1, #0000ch            ; 0F2B 0 108 13C 90800C00
                                               ; 0F2F from 0F29 (DD0,108,13C)
label_0f2f:     LB      A, ACCH                ; 0F2F 0 108 13C F507
                                               ; 0F31 from 0F20 (DD0,108,13C)
label_0f31:     CMPB    A, 0a6h                ; 0F31 0 108 13C C5A6C2
                JGE     label_0f3a             ; 0F34 0 108 13C CD04
                                               ; 0F36 from 0F04 (DD0,108,13C)
label_0f36:     ADD     X1, #00006h            ; 0F36 0 108 13C 90800600
                                               ; 0F3A from 0F06 (DD0,108,13C)
                                               ; 0F3A from 0F34 (DD0,108,13C)
label_0f3a:     LB      A, #01fh               ; 0F3A 0 108 13C 771F
                CMPB    A, r6                  ; 0F3C 0 108 13C 4E
                RB      [DP].1                 ; 0F3D 0 108 13C C209
                MB      [DP].1, C              ; 0F3F 0 108 13C C239
                JEQ     label_0f46             ; 0F41 0 108 13C C903
                XORB    PSWH, #080h            ; 0F43 0 108 13C A2F080
                                               ; 0F46 from 0F41 (DD0,108,13C)
label_0f46:     MB      r0.0, C                ; 0F46 0 108 13C 2038
                MB      C, [DP].0              ; 0F48 0 108 13C C228
                JGE     label_0fa3             ; 0F4A 0 108 13C CD57
                JBR     off(0011fh).7, label_0f62 ; 0F4C 0 108 13C DF1F13
                JBR     off(0011fh).5, label_0f5a ; 0F4F 0 108 13C DD1F08
                JBS     off(00123h).5, label_0f77 ; 0F52 0 108 13C ED2322
                JBR     off(00123h).3, label_0f77 ; 0F55 0 108 13C DB231F
                SJ      label_0fbb             ; 0F58 0 108 13C CB61
                                               ; 0F5A from 0F4F (DD0,108,13C)
label_0f5a:     JBR     off(00118h).7, label_0f77 ; 0F5A 0 108 13C DF181A
                JBS     off(00123h).3, label_0f77 ; 0F5D 0 108 13C EB2317
                SJ      label_0fd1             ; 0F60 0 108 13C CB6F
                                               ; 0F62 from 0F4C (DD0,108,13C)
label_0f62:     JBS     off(0011fh).5, label_0f77 ; 0F62 0 108 13C ED1F12
                JBR     off(0011dh).3, label_0f6b ; 0F65 0 108 13C DB1D03
                JBR     off(0011dh).1, label_0fd1 ; 0F68 0 108 13C D91D66
                                               ; 0F6B from 0F65 (DD0,108,13C)
label_0f6b:     CMPB    0a4h, #02eh            ; 0F6B 0 108 13C C5A4C02E
                JLT     label_0f77             ; 0F6F 0 108 13C CA06
                JBS     off(00123h).5, label_0f77 ; 0F71 0 108 13C ED2303
                JBS     off(00123h).3, label_0fd1 ; 0F74 0 108 13C EB235A
                                               ; 0F77 from 0F52 (DD0,108,13C)
                                               ; 0F77 from 0F55 (DD0,108,13C)
                                               ; 0F77 from 0F62 (DD0,108,13C)
                                               ; 0F77 from 0F6F (DD0,108,13C)
                                               ; 0F77 from 0F71 (DD0,108,13C)
                                               ; 0F77 from 0F5A (DD0,108,13C)
                                               ; 0F77 from 0F5D (DD0,108,13C)
label_0f77:     RB      [DP].5                 ; 0F77 0 108 13C C20D
                JEQ     label_0f87             ; 0F79 0 108 13C C90C
                LB      A, (0019dh-0013ch)[USP] ; 0F7B 0 108 13C F361
                JNE     label_0f87             ; 0F7D 0 108 13C CE08
                JBS     off(0011fh).5, label_0fb6 ; 0F7F 0 108 13C ED1F34
                L       A, 00270h[X2]          ; 0F82 1 108 13C E17002
                SJ      label_0fe7             ; 0F85 1 108 13C CB60
                                               ; 0F87 from 0F79 (DD0,108,13C)
                                               ; 0F87 from 0F7D (DD0,108,13C)
label_0f87:     JBR     off(00108h).0, label_0fea ; 0F87 0 108 13C D80860
                L       A, 001c8h[X2]          ; 0F8A 1 108 13C E1C801
                JNE     label_0fa1             ; 0F8D 1 108 13C CE12
                L       A, 00162h[X2]          ; 0F8F 1 108 13C E16201
                CMP     A, #0b6e0h             ; 0F92 1 108 13C C6E0B6
                JEQ     label_0f9c             ; 0F95 1 108 13C C905
                CMP     A, #05720h             ; 0F97 1 108 13C C62057
                JNE     label_0fa1             ; 0F9A 1 108 13C CE05
                                               ; 0F9C from 0F95 (DD1,108,13C)
label_0f9c:     L       A, #08000h             ; 0F9C 1 108 13C 670080
                SJ      label_0fe7             ; 0F9F 1 108 13C CB46
                                               ; 0FA1 from 0F8D (DD1,108,13C)
                                               ; 0FA1 from 0F9A (DD1,108,13C)
label_0fa1:     SJ      label_1007             ; 0FA1 1 108 13C CB64
                                               ; 0FA3 from 0F4A (DD0,108,13C)
label_0fa3:     SB      [DP].0                 ; 0FA3 0 108 13C C218
                MB      C, [DP].2              ; 0FA5 0 108 13C C22A
                JGE     label_0fad             ; 0FA7 0 108 13C CD04
                LB      A, (00170h-0013ch)[USP] ; 0FA9 0 108 13C F334
                JNE     label_0fea             ; 0FAB 0 108 13C CE3D
                                               ; 0FAD from 0FA7 (DD0,108,13C)
label_0fad:     JBS     off(0011fh).5, label_0fb6 ; 0FAD 0 108 13C ED1F06
                JBS     off(0011dh).1, label_0fc8 ; 0FB0 0 108 13C E91D15
                JBS     off(00123h).3, label_0fd1 ; 0FB3 0 108 13C EB231B
                                               ; 0FB6 from 0FAD (DD0,108,13C)
                                               ; 0FB6 from 0F7F (DD0,108,13C)
label_0fb6:     L       A, 0026ch[X2]          ; 0FB6 1 108 13C E16C02
                SJ      label_0fe7             ; 0FB9 1 108 13C CB2C
                                               ; 0FBB from 0F58 (DD0,108,13C)
label_0fbb:     MOVB    (0019dh-0013ch)[USP], #028h ; 0FBB 0 108 13C C3619828
                L       A, 00274h[X2]          ; 0FBF 1 108 13C E17402
                MOV     er0, #08000h           ; 0FC2 1 108 13C 44980080
                SJ      label_0fe2             ; 0FC6 1 108 13C CB1A
                                               ; 0FC8 from 0FB0 (DD0,108,13C)
label_0fc8:     L       A, 00270h[X2]          ; 0FC8 1 108 13C E17002
                MOV     er0, #08000h           ; 0FCB 1 108 13C 44980080
                SJ      label_0fe2             ; 0FCF 1 108 13C CB11
                                               ; 0FD1 from 0FB3 (DD0,108,13C)
                                               ; 0FD1 from 0F68 (DD0,108,13C)
                                               ; 0FD1 from 0F74 (DD0,108,13C)
                                               ; 0FD1 from 0F60 (DD0,108,13C)
label_0fd1:     L       A, 00270h[X2]          ; 0FD1 1 108 13C E17002
                MOV     er0, #08400h           ; 0FD4 1 108 13C 44980084
                CMPB    0a4h, #040h            ; 0FD8 1 108 13C C5A4C040
                JLT     label_0fe2             ; 0FDC 1 108 13C CA04
                MOV     er0, #087afh           ; 0FDE 1 108 13C 4498AF87
                                               ; 0FE2 from 0FC6 (DD1,108,13C)
                                               ; 0FE2 from 0FCF (DD1,108,13C)
                                               ; 0FE2 from 0FDC (DD1,108,13C)
label_0fe2:     MUL                            ; 0FE2 1 108 13C 9035
                SLL     A                      ; 0FE4 1 108 13C 53
                L       A, er1                 ; 0FE5 1 108 13C 35
                ROL     A                      ; 0FE6 1 108 13C 33
                                               ; 0FE7 from 0FB9 (DD1,108,13C)
                                               ; 0FE7 from 0F85 (DD1,108,13C)
                                               ; 0FE7 from 0F9F (DD1,108,13C)
label_0fe7:     ST      A, 00162h[X2]          ; 0FE7 1 108 13C D16201
                                               ; 0FEA from 0FAB (DD0,108,13C)
                                               ; 0FEA from 0F87 (DD0,108,13C)
label_0fea:     RB      [DP].2                 ; 0FEA 0 108 13C C20A
                SUBB    (00161h-0013ch)[USP], #002h ; 0FEC 0 108 13C C325A002
                JLE     label_0ff5             ; 0FF0 0 108 13C CF03
                J       label_10e0             ; 0FF2 0 108 13C 03E010
                                               ; 0FF5 from 0FF0 (DD0,108,13C)
label_0ff5:     CLR     A                      ; 0FF5 1 108 13C F9
                LC      A, [X1]                ; 0FF6 1 108 13C 90A8
                MB      C, [DP].1              ; 0FF8 1 108 13C C229
                JGE     label_0fff             ; 0FFA 1 108 13C CD03
                ST      A, er0                 ; 0FFC 1 108 13C 88
                CLR     A                      ; 0FFD 1 108 13C F9
                SUB     A, er0                 ; 0FFE 1 108 13C 28
                                               ; 0FFF from 0FFA (DD1,108,13C)
label_0fff:     ADD     A, 00162h[X2]          ; 0FFF 1 108 13C B1620182
                SB      r7.1                   ; 1003 1 108 13C 2719
                SJ      label_1043             ; 1005 1 108 13C CB3C
                                               ; 1007 from 0FA1 (DD1,108,13C)
label_1007:     JBR     off(0011fh).5, label_1015 ; 1007 1 108 13C DD1F0B
                LB      A, (00163h-0013ch)[USP] ; 100A 0 108 13C F327
                JEQ     label_1015             ; 100C 0 108 13C C907
                SUBB    A, #002h               ; 100E 0 108 13C A602
                JGE     label_1013             ; 1010 0 108 13C CD01
                CLRB    A                      ; 1012 0 108 13C FA
                                               ; 1013 from 1010 (DD0,108,13C)
label_1013:     STB     A, (00163h-0013ch)[USP] ; 1013 0 108 13C D327
                                               ; 1015 from 1007 (DD1,108,13C)
                                               ; 1015 from 100C (DD0,108,13C)
label_1015:     CLR     A                      ; 1015 1 108 13C F9
                LC      A, 00002h[X1]          ; 1016 1 108 13C 90A90200
                ST      A, er2                 ; 101A 1 108 13C 8A
                MB      C, [DP].1              ; 101B 1 108 13C C229
                JLT     label_103d             ; 101D 1 108 13C CA1E
                LB      A, (00172h-0013ch)[USP] ; 101F 0 108 13C F336
                JNE     label_103a             ; 1021 0 108 13C CE17
                MOVB    (00172h-0013ch)[USP], #014h ; 1023 0 108 13C C3369814
                LB      A, 09fh                ; 1027 0 108 13C F59F
                ANDB    A, #0c0h               ; 1029 0 108 13C D6C0
                SWAPB                          ; 102B 0 108 13C 83
                EXTND                          ; 102C 1 108 13C F8
                SRL     A                      ; 102D 1 108 13C 63
                LC      A, 03010h[ACC]         ; 102E 1 108 13C B506A91030
                ST      A, er2                 ; 1033 1 108 13C 8A
                LC      A, 00004h[X1]          ; 1034 1 108 13C 90A90400
                ADD     er2, A                 ; 1038 1 108 13C 4681
                                               ; 103A from 1021 (DD0,108,13C)
label_103a:     CLR     A                      ; 103A 1 108 13C F9
                SUB     A, er2                 ; 103B 1 108 13C 2A
                ST      A, er2                 ; 103C 1 108 13C 8A
                                               ; 103D from 101D (DD1,108,13C)
label_103d:     L       A, 00162h[X2]          ; 103D 1 108 13C E16201
                SUB     A, er2                 ; 1040 1 108 13C 2A
                RB      r7.1                   ; 1041 1 108 13C 2709
                                               ; 1043 from 1005 (DD1,108,13C)
label_1043:     MOV     er0, #0b6e0h           ; 1043 1 108 13C 4498E0B6
                MOV     er1, #05720h           ; 1047 1 108 13C 45982057
                CAL     label_2e5e             ; 104B 1 108 13C 325E2E
                ST      A, 00162h[X2]          ; 104E 1 108 13C D16201
                L       A, off(0014eh)         ; 1051 1 108 13C E44E
                JNE     label_108b             ; 1053 1 108 13C CE36
                MB      C, P0.3                ; 1055 1 108 13C C5202B
                JGE     label_108b             ; 1058 1 108 13C CD31
                JBS     off(0011dh).1, label_108b ; 105A 1 108 13C E91D2E
                MOV     X1, DP                 ; 105D 1 108 13C 9278
                L       A, #00274h             ; 105F 1 108 13C 677402
                ADD     A, X2                  ; 1062 1 108 13C 9182
                MOV     DP, A                  ; 1064 1 108 13C 52
                MOV     er0, #000ffh           ; 1065 1 108 13C 4498FF00
                LB      A, (0019dh-0013ch)[USP] ; 1069 0 108 13C F361
                JNE     label_1083             ; 106B 0 108 13C CE16
                JBS     off(0010fh).1, label_1089 ; 106D 0 108 13C E90F19
                SUB     DP, #00004h            ; 1070 0 108 13C 92A00400
                MOV     er0, #00080h           ; 1074 0 108 13C 44988000
                JBR     off(0011fh).5, label_1083 ; 1078 0 108 13C DD1F08
                J       label_4258             ; 107B 0 108 13C 035842
                DB  000h ; 107E
                                               ; 107F from 4260 (DD0,108,13C)
label_107f:     MOV     er0, #000ffh           ; 107F 0 108 13C 4498FF00
                                               ; 1083 from 106B (DD0,108,13C)
                                               ; 1083 from 1078 (DD0,108,13C)
label_1083:     L       A, 00162h[X2]          ; 1083 1 108 13C E16201
                CAL     label_2d56             ; 1086 1 108 13C 32562D
                                               ; 1089 from 106D (DD0,108,13C)
                                               ; 1089 from 4263 (DD0,108,13C)
label_1089:     MOV     DP, X1                 ; 1089 1 108 13C 907A
                                               ; 108B from 1053 (DD1,108,13C)
                                               ; 108B from 1058 (DD1,108,13C)
                                               ; 108B from 105A (DD1,108,13C)
label_108b:     SJ      label_10dc             ; 108B 1 108 13C CB4F
                                               ; 108D from 0EF3 (DD0,108,13C)
label_108d:     MB      C, [DP].0              ; 108D 0 108 13C C228
                JGE     label_1095             ; 108F 0 108 13C CD04
                SB      [DP].2                 ; 1091 0 108 13C C21A
                STB     A, (00170h-0013ch)[USP] ; 1093 0 108 13C D334
                                               ; 1095 from 108F (DD0,108,13C)
label_1095:     CMPB    off(0015bh), #040h     ; 1095 0 108 13C C45BC040
                JNE     label_10d1             ; 1099 0 108 13C CE36
                LB      A, (00170h-0013ch)[USP] ; 109B 0 108 13C F334
                MOV     er0, 00270h[X2]        ; 109D 0 108 13C B1700248
                JEQ     label_10a7             ; 10A1 0 108 13C C904
                MOV     er0, 00162h[X2]        ; 10A3 0 108 13C B1620148
                                               ; 10A7 from 10A1 (DD0,108,13C)
label_10a7:     JBR     off(00109h).7, label_10d1 ; 10A7 0 108 13C DF0927
                MOV     er2, er0               ; 10AA 0 108 13C 444A
                SJ      label_10d1             ; 10AC 0 108 13C CB23
                                               ; 10AE from 0EF0 (DD0,108,13C)
label_10ae:     MB      C, [DP].0              ; 10AE 0 108 13C C228
                JGE     label_10b6             ; 10B0 0 108 13C CD04
                SB      [DP].2                 ; 10B2 0 108 13C C21A
                STB     A, (00170h-0013ch)[USP] ; 10B4 0 108 13C D334
                                               ; 10B6 from 10B0 (DD0,108,13C)
label_10b6:     LB      A, (00170h-0013ch)[USP] ; 10B6 0 108 13C F334
                MOV     er2, 00270h[X2]        ; 10B8 0 108 13C B170024A
                JEQ     label_10d1             ; 10BC 0 108 13C C913
                MOV     er2, 00162h[X2]        ; 10BE 0 108 13C B162014A
                SJ      label_10d1             ; 10C2 0 108 13C CB0D
                                               ; 10C4 from 0EF6 (DD0,108,13C)
label_10c4:     MOV     er2, 00270h[X2]        ; 10C4 0 108 13C B170024A
                JBR     off(0011fh).5, label_10cf ; 10C8 0 108 13C DD1F04
                MOV     er2, 0026ch[X2]        ; 10CB 0 108 13C B16C024A
                                               ; 10CF from 4105 (DD0,108,13C)
                                               ; 10CF from 0EF9 (DD0,108,13C)
                                               ; 10CF from 10C8 (DD0,108,13C)
label_10cf:     RB      [DP].2                 ; 10CF 0 108 13C C20A
                                               ; 10D1 from 10BC (DD0,108,13C)
                                               ; 10D1 from 10C2 (DD0,108,13C)
                                               ; 10D1 from 1099 (DD0,108,13C)
                                               ; 10D1 from 10A7 (DD0,108,13C)
                                               ; 10D1 from 10AC (DD0,108,13C)
label_10d1:     ANDB    [DP], #0deh            ; 10D1 0 108 13C C2D0DE
                MOVB    (00163h-0013ch)[USP], #00ah ; 10D4 0 108 13C C327980A
                L       A, er2                 ; 10D8 1 108 13C 36
                ST      A, 00162h[X2]          ; 10D9 1 108 13C D16201
                                               ; 10DC from 108B (DD1,108,13C)
label_10dc:     J       label_36cb             ; 10DC 1 108 13C 03CB36
                DB  004h ; 10DF
                                               ; 10E0 from 36D6 (DD0,108,13C)
                                               ; 10E0 from 0FF2 (DD0,108,13C)
label_10e0:     J       label_402e             ; 10E0 0 108 13C 032E40
                DB  095h,0F4h,0D0h,0CEh,037h,0F4h,030h,0D6h ; 10E3
                DB  077h,0CEh,031h,0EEh,00Fh,02Eh,0DFh,024h ; 10EB
                DB  02Bh,077h,04Dh,026h,0C1h,0CAh,018h,0DEh ; 10F3
                DB  008h,022h,0EAh,023h,003h,07Eh,0D3h,023h ; 10FB
                DB  0EBh,023h,019h,0F3h,023h,02Eh,0CDh,003h ; 1103
                DB  089h,0FAh,029h,0C6h,004h,0CBh,00Dh,095h ; 110B
                DB  0EFh,008h,009h,077h,040h,0C7h,05Bh,0CDh ; 1113
                DB  003h,026h,0C0h,003h,0EFh,00Fh,005h,0C4h ; 111B
                DB  02Dh,03Ch,0CBh,003h,0C4h,02Dh,03Dh ; 1123
                                               ; 112A from 40A2 (DD0,108,13C)
label_112a:     MOVB    r5, #040h              ; 112A 0 108 13C 9D40
                MOV     X1, #02f66h            ; 112C 0 108 13C 60662F
                CAL     label_2b8b             ; 112F 0 108 13C 328B2B
                STB     A, off(00169h)         ; 1132 0 108 13C D469
                J       label_4112             ; 1134 0 108 13C 031241
                                               ; 1137 from 4184 (DD0,108,13C)
label_1137:     MOV     X2, #02f56h            ; 1137 0 108 13C 61562F
                CAL     label_2b85             ; 113A 0 108 13C 32852B
                                               ; 113D from 417B (DD0,108,13C)
label_113d:     STB     A, off(00168h)         ; 113D 0 108 13C D468
                SUBB    A, #040h               ; 113F 0 108 13C A640
                MOVB    r0, #01ch              ; 1141 0 108 13C 981C
                MULB                           ; 1143 0 108 13C A234
                ADDB    ACCH, #001h            ; 1145 0 108 13C C5078001
                MOV     off(00166h), A         ; 1149 0 108 13C B4668A
                CLRB    r7                     ; 114C 0 108 13C 2715
                CMPB    off(0013dh), #000h     ; 114E 0 108 13C C43DC000
                JNE     label_1157             ; 1152 0 108 13C CE03
                JBR     off(0012bh).2, label_117f ; 1154 0 108 13C DA2B28
                                               ; 1157 from 1152 (DD0,108,13C)
                ;euro pw0 doesnt have the map comparison..
label_1157:     LB      A, #0d7h       ;mugen -> #0FFh         ; 1157 0 108 13C 77D7
                MOVB    r0, #065h      ;mugen -> #0DFh         ; 1159 0 108 13C 9865
                JBR     off(00121h).4, label_1162 ; 115B 0 108 13C DC2104
                LB      A, #0d2h       ;mugen -> #0FDh         ; 115E 0 108 13C 77D2
                MOVB    r0, #056h      ;mugen -> #0DCh         ; 1160 0 108 13C 9856
                                               ; 1162 from 115B (DD0,108,13C)
label_1162:     CMPB    A, 0a6h                ; 1162 0 108 13C C5A6C2
                JGE     label_116b             ; 1165 0 108 13C CD04
                LB      A, r0                  ; 1167 0 108 13C 78
                CMPB    A, 0b3h                ; 1168 0 108 13C C5B3C2
                                               ; 116B from 1165 (DD0,108,13C)
label_116b:     MB      off(00121h).4, C       ; 116B 0 108 13C C4213C
                JGE     label_117f             ; 116E 0 108 13C CD0F
                JBS     off(0011dh).1, label_117f ; 1170 0 108 13C E91D0C
                LB      A, #040h               ; 1173 0 108 13C 7740
                CMPB    A, off(00168h)         ; 1175 0 108 13C C768
                JNE     label_117f             ; 1177 0 108 13C CE06
                CMPB    A, off(0015bh)         ; 1179 0 108 13C C75B
                JNE     label_117f             ; 117B 0 108 13C CE02
                MOVB    r7, #013h       ;mugen -> #000h        ; 117D 0 108 13C 9F13
                                               ; 117F from 1154 (DD0,108,13C)
                                               ; 117F from 116E (DD0,108,13C)
                                               ; 117F from 1170 (DD0,108,13C)
                                               ; 117F from 1177 (DD0,108,13C)
                                               ; 117F from 117B (DD0,108,13C)
label_117f:     LB      A, r7                  ; r7 has 0 or 13h (0 only with mugen)
                STB     A, off(00153h)         ; 1180 0 108 13C D453
                CMPB    0a6h, #0e8h            ; 1182 0 108 13C C5A6C0E8
                JGE     label_11c5             ; 1186 0 108 13C CD3D
                MB      C, off(0011fh).3       ; 1188 0 108 13C C41F2B
                ROLB    r0                     ; 118B 0 108 13C 20B7
                MOV     DP, #000afh            ; 118D 0 108 13C 62AF00
                LB      A, #000h               ; 1190 0 108 13C 7700
                JBR     off(00122h).3, label_1197 ; 1192 0 108 13C DB2202
                LB      A, #000h               ; 1195 0 108 13C 7700
                                               ; 1197 from 1192 (DD0,108,13C)
label_1197:     CMPB    A, 0a6h                ; 1197 0 108 13C C5A6C2
                MB      off(00122h).3, C       ; 119A 0 108 13C C4223B
                JLT     label_11a6             ; 119D 0 108 13C CA07
                MB      C, off(0011fh).2       ; 119F 0 108 13C C41F2A
                ROLB    r0                     ; 11A2 0 108 13C 20B7
                DEC     DP                     ; 11A4 0 108 13C 82
                DEC     DP                     ; 11A5 0 108 13C 82
                                               ; 11A6 from 119D (DD0,108,13C)
label_11a6:     CLR     er3                    ; 11A6 0 108 13C 4715
                LB      A, #084h       ;mugen -> #083h         ; 11A8 0 108 13C 7784
                JBS     off(00118h).7, label_11af ; 11AA 0 108 13C EF1802
                LB      A, #085h       ;mugen -> #083h         ; 11AD 0 108 13C 7785
                                               ; 11AF from 11AA (DD0,108,13C)
label_11af:     CMPB    [DP], A                ; 11AF 0 108 13C C2C1
                JGE     label_11d5             ; 11B1 0 108 13C CD22
                LB      A, #07eh               ; 11B3 0 108 13C 777E
                JBS     off(00118h).7, label_11ba ; 11B5 0 108 13C EF1802
                LB      A, #07ch               ; 11B8 0 108 13C 777C
                                               ; 11BA from 11B5 (DD0,108,13C)
label_11ba:     J       label_3602             ; 11BA 0 108 13C 030236
                DB  00Ah ; 11BD
                                               ; 11BE from 360E (DD0,108,13C)
label_11be:     JBS     off(00122h).4, label_11ce ; 11BE 0 108 13C EC220D
                                               ; 11C1 from 11DB (DD0,108,13C)
label_11c1:     J       label_4021             ; 11C1 0 108 13C 032140
                DB  068h ; 11C4
                                               ; 11C5 from 1186 (DD0,108,13C)
                                               ; 11C5 from 11D0 (DD0,108,13C)
label_11c5:     J       label_12cd             ; 11C5 0 108 13C 03CD12
                                               ; 11C8 from 3611 (DD0,108,13C)
label_11c8:     JBR     off(00108h).0, label_11ce ; 11C8 0 108 13C D80803
                J       label_1274             ; 11CB 0 108 13C 037412
                                               ; 11CE from 11BE (DD0,108,13C)
                                               ; 11CE from 11C8 (DD0,108,13C)
label_11ce:     LB      A, off(0015ch)         ; 11CE 0 108 13C F45C
                JEQ     label_11c5             ; 11D0 0 108 13C C9F3
                J       label_12b7             ; 11D2 0 108 13C 03B712
                                               ; 11D5 from 11B1 (DD0,108,13C)
label_11d5:     JBS     off(00108h).0, label_11dd ; 11D5 0 108 13C E80805
                CMPB    [DP], #084h            ; 11D8 0 108 13C C2C084
                JLT     label_11c1             ; 11DB 0 108 13C CAE4
                                               ; 11DD from 11D5 (DD0,108,13C)
label_11dd:     CLRB    A                      ; 11DD 0 108 13C FA
                JBS     off(0011dh).4, label_1200 ; 11DE 0 108 13C EC1D1F
                JBS     off(00123h).1, label_11f9 ; 11E1 0 108 13C E92315
                JBS     off(00123h).2, label_11f9 ; 11E4 0 108 13C EA2312
                JBR     off(00121h).7, label_11fe ; 11E7 0 108 13C DF2114
                CMPB    0a4h, #02eh            ; 11EA 0 108 13C C5A4C02E
                JGE     label_11fe             ; 11EE 0 108 13C CD0E
                LB      A, #018h               ; 11F0 0 108 13C 7718
                CMPB    [DP], #098h            ; 11F2 0 108 13C C2C098
                JGE     label_1210             ; 11F5 0 108 13C CD19
                SJ      label_120e             ; 11F7 0 108 13C CB15
                                               ; 11F9 from 11E1 (DD0,108,13C)
                                               ; 11F9 from 11E4 (DD0,108,13C)
label_11f9:     SB      off(0011dh).4          ; 11F9 0 108 13C C41D1C
                SJ      label_1200             ; 11FC 0 108 13C CB02
                                               ; 11FE from 11E7 (DD0,108,13C)
                                               ; 11FE from 11EE (DD0,108,13C)
label_11fe:     LB      A, #00ch               ; 11FE 0 108 13C 770C
                                               ; 1200 from 11DE (DD0,108,13C)
                                               ; 1200 from 11FC (DD0,108,13C)
label_1200:     CMPB    0a6h, #094h            ; 1200 0 108 13C C5A6C094
                JGE     label_1210             ; 1204 0 108 13C CD0A
                ADDB    A, #004h               ; 1206 0 108 13C 8604
                CMPB    0a6h, #062h            ; 1208 0 108 13C C5A6C062
                JGE     label_1210             ; 120C 0 108 13C CD02
                                               ; 120E from 11F7 (DD0,108,13C)
label_120e:     ADDB    A, #004h               ; 120E 0 108 13C 8604
                                               ; 1210 from 11F5 (DD0,108,13C)
                                               ; 1210 from 1204 (DD0,108,13C)
                                               ; 1210 from 120C (DD0,108,13C)
label_1210:     EXTND                          ; 1210 1 108 13C F8
                ADD     A, #030d3h             ; 1211 1 108 13C 86D330
                MOV     X1, A                  ; 1214 1 108 13C 50
                LB      A, [DP]                ; 1215 0 108 13C F2
                ADDB    A, #080h               ; 1216 0 108 13C 8680
                CMPCB   A, [X1]                ; 1218 0 108 13C 90AE
                JLT     label_121e             ; 121A 0 108 13C CA02
                LCB     A, [X1]                ; 121C 0 108 13C 90AA
                                               ; 121E from 121A (DD0,108,13C)
label_121e:     STB     A, r0                  ; 121E 0 108 13C 88
                INC     X1                     ; 121F 0 108 13C 70
                LCB     A, [X1]                ; 1220 0 108 13C 90AA
                MULB                           ; 1222 0 108 13C A234
                L       A, ACC                 ; 1224 1 108 13C E506
                ST      A, er0                 ; 1226 1 108 13C 88
                INC     X1                     ; 1227 1 108 13C 70
                LC      A, [X1]                ; 1228 1 108 13C 90A8
                ADD     A, er0                 ; 122A 1 108 13C 08
                SJ      label_1265             ; 122B 1 108 13C CB38
                                               ; 122D from 4028 (DD1,108,13C)
label_122d:     CLRB    A                      ; 122D 0 108 13C FA
                MOV     er0, #00177h           ; 122E 0 108 13C 44987701
                CMPB    0a4h, #057h            ; 1232 0 108 13C C5A4C057
                JLT     label_123e             ; 1236 0 108 13C CA06
                LB      A, #00ch               ; 1238 0 108 13C 770C
                MOV     er0, #002eeh           ; 123A 0 108 13C 4498EE02
                                               ; 123E from 1236 (DD0,108,13C)
label_123e:     CMP     er0, off(0014ah)       ; 123E 0 108 13C 44C34A
                JLT     label_1245             ; 1241 0 108 13C CA02
                ADDB    A, #006h               ; 1243 0 108 13C 8606
                                               ; 1245 from 1241 (DD0,108,13C)
label_1245:     CMPB    0a6h, #062h            ; 1245 0 108 13C C5A6C062
                JGE     label_124d             ; 1249 0 108 13C CD02
                ADDB    A, #002h               ; 124B 0 108 13C 8602
                                               ; 124D from 1249 (DD0,108,13C)
label_124d:     CMPB    0a6h, #08ch            ; 124D 0 108 13C C5A6C08C
                JGE     label_1255             ; 1251 0 108 13C CD02
                ADDB    A, #002h               ; 1253 0 108 13C 8602
                                               ; 1255 from 1251 (DD0,108,13C)
label_1255:     EXTND                          ; 1255 1 108 13C F8
                LC      A, 030bbh[ACC]         ; 1256 1 108 13C B506A9BB30
                ST      A, er0                 ; 125B 1 108 13C 88
                L       A, off(0014ah)         ; 125C 1 108 13C E44A
                SUB     A, er0                 ; 125E 1 108 13C 28
                JLE     label_1264             ; 125F 1 108 13C CF03
                CMP     A, er3                 ; 1261 1 108 13C 4B
                JGT     label_1265             ; 1262 1 108 13C C801
                                               ; 1264 from 125F (DD1,108,13C)
label_1264:     L       A, er3                 ; 1264 1 108 13C 37
                                               ; 1265 from 122B (DD1,108,13C)
                                               ; 1265 from 1262 (DD1,108,13C)
label_1265:     J       label_1d65             ; 1265 1 108 13C 03651D
                DB  018h ; 1268
                                               ; 1269 from 1D6B (DD1,108,13C)
label_1269:     RB      0f2h.6                 ; 1269 1 108 13C C5F20E
                CLRB    off(0015ch)            ; 126C 1 108 13C C45C15
                J       label_3614             ; 126F 1 108 13C 031436
                DW  067cbh           ; 1272
                                               ; 1274 from 11CB (DD0,108,13C)
label_1274:     JBS     off(00122h).4, label_1290 ; 1274 0 108 13C EC2219
                LB      A, off(001fch)         ; 1277 0 108 13C F4FC
                JNE     label_12cd             ; 1279 0 108 13C CE52
                CMPB    0ach, #06ch            ; 127B 0 108 13C C5ACC06C
                JGE     label_12cd             ; 127F 0 108 13C CD4C
                LB      A, 0a6h                ; 1281 0 108 13C F5A6
                CMPB    A, #05eh               ; 1283 0 108 13C C65E
                JLT     label_12cd             ; 1285 0 108 13C CA46
                CMPB    A, #0beh               ; 1287 0 108 13C C6BE
                JGE     label_12cd             ; 1289 0 108 13C CD42
                CMPB    A, #094h               ; 128B 0 108 13C C694
                J       label_4239             ; 128D 0 108 13C 033942
                                               ; 1290 from 1274 (DD0,108,13C)
                                               ; 1290 from 4245 (DD0,108,13C)
label_1290:     MOVB    r2, #020h              ; 1290 0 108 13C 9A20
                MOVB    r0, #004h              ; 1292 0 108 13C 9804
                MOVB    r1, #0ffh              ; 1294 0 108 13C 99FF
                JBR     off(00122h).5, label_129f ; 1296 0 108 13C DD2206
                MOVB    r2, #00fh              ; 1299 0 108 13C 9A0F
                MOVB    r0, #007h              ; 129B 0 108 13C 9807
                MOVB    r1, #0ffh              ; 129D 0 108 13C 99FF
                                               ; 129F from 1296 (DD0,108,13C)
label_129f:     J       label_4248             ; 129F 0 108 13C 034842
                DB  0A2h ; 12A2
                                               ; 12A3 from 4255 (DD0,108,13C)
label_12a3:     CMPB    A, r2                  ; 12A3 0 108 13C 4A
                JLT     label_12a7             ; 12A4 0 108 13C CA01
                LB      A, r2                  ; 12A6 0 108 13C 7A
                                               ; 12A7 from 12A4 (DD0,108,13C)
label_12a7:     MULB                           ; 12A7 0 108 13C A234
                CMPB    ACCH, #000h            ; 12A9 0 108 13C C507C000
                JNE     label_12b4             ; 12AD 0 108 13C CE05
                XCHGB   A, r1                  ; 12AF 0 108 13C 2110
                SUBB    A, r1                  ; 12B1 0 108 13C 29
                JGE     label_12c6             ; 12B2 0 108 13C CD12
                                               ; 12B4 from 12AD (DD0,108,13C)
label_12b4:     CLRB    A                      ; 12B4 0 108 13C FA
                SJ      label_12c6             ; 12B5 0 108 13C CB0F
                                               ; 12B7 from 11D2 (DD0,108,13C)
label_12b7:     MOVB    r0, #003h              ; 12B7 0 108 13C 9803
                CMPB    0a6h, #094h            ; 12B9 0 108 13C C5A6C094
                JGE     label_12c1             ; 12BD 0 108 13C CD02
                MOVB    r0, #003h              ; 12BF 0 108 13C 9803
                                               ; 12C1 from 12BD (DD0,108,13C)
label_12c1:     LB      A, off(0015ch)         ; 12C1 0 108 13C F45C
                ADDB    A, r0                  ; 12C3 0 108 13C 08
                JLT     label_12cd             ; 12C4 0 108 13C CA07
                                               ; 12C6 from 12B2 (DD0,108,13C)
                                               ; 12C6 from 12B5 (DD0,108,13C)
label_12c6:     STB     A, off(0015ch)         ; 12C6 0 108 13C D45C
                SB      off(00122h).4          ; 12C8 0 108 13C C4221C
                SJ      label_12d3             ; 12CB 0 108 13C CB06
                                               ; 12CD from 11C5 (DD0,108,13C)
                                               ; 12CD from 402B (DD1,108,13C)
                                               ; 12CD from 1279 (DD0,108,13C)
                                               ; 12CD from 127F (DD0,108,13C)
                                               ; 12CD from 1285 (DD0,108,13C)
                                               ; 12CD from 1289 (DD0,108,13C)
                                               ; 12CD from 12C4 (DD0,108,13C)
                                               ; 12CD from 1D6E (DD1,108,13C)
label_12cd:     CLRB    off(0015ch)            ; 12CD 0 108 13C C45C15
                RB      off(00122h).4          ; 12D0 0 108 13C C4220C
                                               ; 12D3 from 12CB (DD0,108,13C)
label_12d3:     CLR     A                      ; 12D3 1 108 13C F9
                ST      A, off(0014ah)         ; 12D4 1 108 13C D44A
                RB      off(0011dh).4          ; 12D6 1 108 13C C41D0C
                RB      r7.0                   ; 12D9 1 108 13C 2708
                                               ; 12DB from 361B (DD1,108,13C)
label_12db:     SRLB    r7                     ; 12DB 1 108 13C 27E7
                RB      off(00122h).6          ; 12DD 1 108 13C C4220E
                MB      off(00122h).6, C       ; 12E0 1 108 13C C4223E
                JGE     label_12e8             ; 12E3 1 108 13C CD03
                JEQ     label_12e8             ; 12E5 1 108 13C C901
                RC                             ; 12E7 1 108 13C 95
                                               ; 12E8 from 12E3 (DD1,108,13C)
                                               ; 12E8 from 12E5 (DD1,108,13C)
label_12e8:     MB      off(00122h).7, C       ; 12E8 1 108 13C C4223F
                L       A, off(0016ch)         ; 12EB 1 108 13C E46C
                CMP     A, #00100h             ; 12ED 1 108 13C C60001
                JEQ     label_1343             ; 12F0 1 108 13C C951
                ST      A, er0                 ; 12F2 1 108 13C 88
                CLRB    r7                     ; 12F3 1 108 13C 2715
                MOV     X1, #001b3h            ; 12F5 1 108 13C 60B301
                MOV     X2, #00133h            ; 12F8 1 108 13C 613301
                JBR     off(0011ah).5, label_1306 ; 12FB 1 108 13C DD1A08
                MOVB    r7, #008h              ; 12FE 1 108 13C 9F08
                MOV     X1, #001d9h            ; 1300 1 108 13C 60D901
                MOV     X2, #00133h            ; 1303 1 108 13C 613301
                                               ; 1306 from 12FB (DD1,108,13C)
label_1306:     CMP     A, X1                  ; 1306 1 108 13C 90C2
                JGE     label_130f             ; 1308 1 108 13C CD05
                ADDB    r7, #004h              ; 130A 1 108 13C 278004
                CMP     A, X2                  ; 130D 1 108 13C 91C2
                                               ; 130F from 1308 (DD1,108,13C)
label_130f:     LB      A, r7                  ; 130F 0 108 13C 7F
                JGE     label_1324             ; 1310 0 108 13C CD12
                LB      A, #010h               ; 1312 0 108 13C 7710
                CMPB    0a3h, #0a6h            ; 1314 0 108 13C C5A3C0A6
                JGE     label_1324             ; 1318 0 108 13C CD0A
                LB      A, #014h               ; 131A 0 108 13C 7714
                CMPB    0a3h, #034h            ; 131C 0 108 13C C5A3C034
                JGE     label_1324             ; 1320 0 108 13C CD02
                LB      A, #018h               ; 1322 0 108 13C 7718
                                               ; 1324 from 1310 (DD0,108,13C)
                                               ; 1324 from 1318 (DD0,108,13C)
                                               ; 1324 from 1320 (DD0,108,13C)
label_1324:     JBR     off(00118h).7, label_132e ; 1324 0 108 13C DF1807
                NOP                            ; 1327 0 108 13C 00
                NOP                            ; 1328 0 108 13C 00
                NOP                            ; 1329 0 108 13C 00
                NOP                            ; 132A 0 108 13C 00
                NOP                            ; 132B 0 108 13C 00
                ADDB    A, #002h               ; 132C 0 108 13C 8602
                                               ; 132E from 1324 (DD0,108,13C)
label_132e:     EXTND                          ; 132E 1 108 13C F8
                LC      A, 03068h[ACC]         ; 132F 1 108 13C B506A96830
                ST      A, er1                 ; 1334 1 108 13C 89
                LB      A, off(0016eh)         ; 1335 0 108 13C F46E
                SUBB    A, r2                  ; 1337 0 108 13C 2A
                STB     A, off(0016eh)         ; 1338 0 108 13C D46E
                LB      A, r0                  ; 133A 0 108 13C 78
                SBCB    A, r3                  ; 133B 0 108 13C 3B
                STB     A, r2                  ; 133C 0 108 13C 8A
                LB      A, r1                  ; 133D 0 108 13C 79
                SBCB    A, #000h               ; 133E 0 108 13C B600
                STB     A, r3                  ; 1340 0 108 13C 8B
                JNE     label_134a             ; 1341 0 108 13C CE07
                                               ; 1343 from 12F0 (DD1,108,13C)
label_1343:     MOV     er1, #00100h           ; 1343 0 108 13C 45980001
                MOV     off(0016ah), er1       ; 1347 0 108 13C 457C6A
                                               ; 134A from 1341 (DD0,108,13C)
label_134a:     MOV     off(0016ch), er1       ; 134A 0 108 13C 457C6C
                LB      A, off(00158h)         ; 134D 0 108 13C F458
                MOVB    r1, #001h              ; 134F 0 108 13C 9901
                J       label_35f5             ; 1351 0 108 13C 03F535
                DW  034ech           ; 1354
                                               ; 1356 from 35FF (DD0,108,13C)
label_1356:     LB      A, off(0016fh)         ; 1356 0 108 13C F46F
                JEQ     label_1361             ; 1358 0 108 13C C907
                STB     A, ACCH                ; 135A 0 108 13C D507
                CLRB    A                      ; 135C 0 108 13C FA
                MUL                            ; 135D 0 108 13C 9035
                MOV     er0, er1               ; 135F 0 108 13C 4548
                                               ; 1361 from 1358 (DD0,108,13C)
label_1361:     LB      A, off(0015ch)         ; 1361 0 108 13C F45C
                JEQ     label_136c             ; 1363 0 108 13C C907
                STB     A, ACCH                ; 1365 0 108 13C D507
                CLRB    A                      ; 1367 0 108 13C FA
                MUL                            ; 1368 0 108 13C 9035
                MOV     er0, er1               ; 136A 0 108 13C 4548
                                               ; 136C from 1363 (DD0,108,13C)
label_136c:     LB      A, off(00153h)         ; 136C 0 108 13C F453
                JEQ     label_137b             ; 136E 0 108 13C C90B
                MOVB    ACCH, #001h            ; 1370 0 108 13C C5079801
                MUL                            ; 1374 0 108 13C 9035
                MOVB    r1, r2                 ; 1376 0 108 13C 2249
                MOVB    r0, ACCH               ; 1378 0 108 13C C50748
                                               ; 137B from 136E (DD0,108,13C)
label_137b:     CLRB    r5                     ; 137B 0 108 13C 2515
                MOVB    r4, off(00168h)        ; 137D 0 108 13C C4684C
                CMPB    r4, off(0015bh)        ; 1380 0 108 13C 24C35B
                JGE     label_1388             ; 1383 0 108 13C CD03
                MOVB    r4, off(0015bh)        ; 1385 0 108 13C C45B4C
                                               ; 1388 from 1383 (DD0,108,13C)
label_1388:     JBS     off(0011bh).0, label_138e ; 1388 0 108 13C E81B03
                JBR     off(0011ch).0, label_139a ; 138B 0 108 13C D81C0C
                                               ; 138E from 1388 (DD0,108,13C)
label_138e:     MOVB    r4, off(00169h)        ; 138E 0 108 13C C4694C
                L       A, #00100h             ; 1391 1 108 13C 670001
                CMPB    0a3h, #028h            ; 1394 1 108 13C C5A3C028
                JGE     label_139c             ; 1398 1 108 13C CD02
                                               ; 139A from 138B (DD0,108,13C)
label_139a:     L       A, off(0016ch)         ; 139A 1 108 13C E46C
                                               ; 139C from 1398 (DD1,108,13C)
label_139c:     MUL                            ; 139C 1 108 13C 9035
                MOVB    r1, r2                 ; 139E 1 108 13C 2249
                MOVB    r0, ACCH               ; 13A0 1 108 13C C50748
                L       A, er2                 ; 13A3 1 108 13C 36
                MUL                            ; 13A4 1 108 13C 9035
                MOV     er0, er1               ; 13A6 1 108 13C 4548
                MOV     er2, #00040h           ; 13A8 1 108 13C 46984000
                DIV                            ; 13AC 1 108 13C 9037
                ST      A, off(0015eh)         ; 13AE 1 108 13C D45E
                MB      C, 0f2h.6              ; 13B0 1 108 13C C5F22E
                JGE     label_13cc             ; 13B3 1 108 13C CD17
                CLR     A                      ; 13B5 1 108 13C F9
                AND     IE, #00080h            ; 13B6 1 108 13C B51AD08000
                RB      PSWH.0                 ; 13BB 1 108 13C A208
                ST      A, off(00144h)         ; 13BD 1 108 13C D444
                ST      A, off(00146h)         ; 13BF 1 108 13C D446
                ST      A, off(00148h)         ; 13C1 1 108 13C D448
                SB      PSWH.0                 ; 13C3 1 108 13C A218
                L       A, 0cch                ; 13C5 1 108 13C E5CC
                ST      A, IE                  ; 13C7 1 108 13C D51A
                J       label_14c7             ; 13C9 1 108 13C 03C714
                                               ; 13CC from 13B3 (DD1,108,13C)
label_13cc:     MOV     er0, off(00142h)       ; 13CC 1 108 13C B44248
                JBS     off(00129h).7, label_13d5 ; 13CF 1 108 13C EF2903
                J       label_3703             ; 13D2 1 108 13C 030337
                                               ; 13D5 from 13CF (DD1,108,13C)
                                               ; 13D5 from 371C (DD1,108,13C)
label_13d5:     MUL                            ; 13D5 1 108 13C 9035
                SRL     er1                    ; 13D7 1 108 13C 45E7
                ROR     A                      ; 13D9 1 108 13C 43
                LB      A, r2                  ; 13DA 0 108 13C 7A
                L       A, ACC                 ; 13DB 1 108 13C E506
                SWAP                           ; 13DD 1 108 13C 83
                CMPB    r3, #000h              ; 13DE 1 108 13C 23C000
                JEQ     label_13e6             ; 13E1 1 108 13C C903
                L       A, #0ffffh             ; 13E3 1 108 13C 67FFFF
                                               ; 13E6 from 13E1 (DD1,108,13C)
label_13e6:     MOV     X1, A                  ; 13E6 1 108 13C 50
                L       A, off(0014ah)         ; 13E7 1 108 13C E44A
                MOV     er0, off(00166h)       ; 13E9 1 108 13C B46648
                MUL                            ; 13EC 1 108 13C 9035
                MOVB    r1, r2                 ; 13EE 1 108 13C 2249
                MOVB    r0, ACCH               ; 13F0 1 108 13C C50748
                L       A, off(0016ah)         ; 13F3 1 108 13C E46A
                MUL                            ; 13F5 1 108 13C 9035
                MOVB    r7, r2                 ; 13F7 1 108 13C 224F
                MOVB    r6, ACCH               ; 13F9 1 108 13C C5074E
                L       A, off(0014ch)         ; 13FC 1 108 13C E44C
                VCAL    4                      ; 13FE 1 108 13C 14
                L       A, off(00150h)         ; 13FF 1 108 13C E450
                VCAL    4                      ; 1401 1 108 13C 14
                LB      A, off(00152h)         ; 1402 0 108 13C F452
                EXTND                          ; 1404 1 108 13C F8
                VCAL    4                      ; 1405 1 108 13C 14
                ST      A, er2                 ; 1406 1 108 13C 8A
                L       A, off(0014eh)         ; 1407 1 108 13C E44E
                VCAL    4                      ; 1409 1 108 13C 14
                AND     IE, #00080h            ; 140A 1 108 13C B51AD08000
                RB      PSWH.0                 ; 140F 1 108 13C A208
                ST      A, off(00146h)         ; 1411 1 108 13C D446
                L       A, X1                  ; 1413 1 108 13C 40
                ST      A, off(00144h)         ; 1414 1 108 13C D444
                SB      PSWH.0                 ; 1416 1 108 13C A218
                L       A, 0cch                ; 1418 1 108 13C E5CC
                ST      A, IE                  ; 141A 1 108 13C D51A
                L       A, X1                  ; 141C 1 108 13C 40
                ADD     A, er2                 ; 141D 1 108 13C 0A
                JGE     label_1423             ; 141E 1 108 13C CD03
                L       A, #0ffffh             ; 1420 1 108 13C 67FFFF
                                               ; 1423 from 141E (DD1,108,13C)
label_1423:     MOV     er0, off(00148h)       ; 1423 1 108 13C B44848
                ST      A, off(00148h)         ; 1426 1 108 13C D448
                CLRB    r5                     ; 1428 1 108 13C 2515
                CMPB    0a4h, #044h            ; 142A 1 108 13C C5A4C044
                JGE     label_1473             ; 142E 1 108 13C CD43
                CMPB    0a6h, #0feh            ; 1430 1 108 13C C5A6C0FE
                JLT     label_1439             ; 1434 1 108 13C CA03
                JBS     off(00122h).7, label_1473 ; 1436 1 108 13C EF223A
                                               ; 1439 from 1434 (DD1,108,13C)
label_1439:     CMPB    0a6h, #037h            ; 1439 1 108 13C C5A6C037
                JGE     label_1447             ; 143D 1 108 13C CD08
                SUB     A, er0                 ; 143F 1 108 13C 28
                JLT     label_1447             ; 1440 1 108 13C CA05
                CMP     A, #00080h             ; 1442 1 108 13C C68000
                JGE     label_145d             ; 1445 1 108 13C CD16
                                               ; 1447 from 143D (DD1,108,13C)
                                               ; 1447 from 1440 (DD1,108,13C)
label_1447:     CLR     A                      ; 1447 1 108 13C F9
                CMPB    0a4h, #02eh            ; 1448 1 108 13C C5A4C02E
                JGE     label_1493             ; 144C 1 108 13C CD45
                CMPB    0a6h, #0a9h            ; 144E 1 108 13C C5A6C0A9
                JGE     label_1493             ; 1452 1 108 13C CD3F
                JBR     off(00122h).7, label_1493 ; 1454 1 108 13C DF223C
                MOV     er0, #00100h           ; 1457 1 108 13C 44980001
                SJ      label_147f             ; 145B 1 108 13C CB22
                                               ; 145D from 1445 (DD1,108,13C)
label_145d:     MOV     er0, #006d6h           ; 145D 1 108 13C 4498D606
                CMP     A, er0                 ; 1461 1 108 13C 48
                JGE     label_1465             ; 1462 1 108 13C CD01
                ST      A, er0                 ; 1464 1 108 13C 88
                                               ; 1465 from 1462 (DD1,108,13C)
label_1465:     CMPB    0a6h, #014h            ; 1465 1 108 13C C5A6C014
                L       A, #000b0h             ; 1469 1 108 13C 67B000
                JLT     label_1483             ; 146C 1 108 13C CA15
                L       A, #000b0h             ; 146E 1 108 13C 67B000
                SJ      label_1483             ; 1471 1 108 13C CB10
                                               ; 1473 from 142E (DD1,108,13C)
                                               ; 1473 from 1436 (DD1,108,13C)
label_1473:     INCB    r5                     ; 1473 1 108 13C AD
                MOV     X1, #030abh            ; 1474 1 108 13C 60AB30
                LB      A, 0a4h                ; 1477 0 108 13C F5A4
                VCAL    0                      ; 1479 0 108 13C 10
                STB     A, r0                  ; 147A 0 108 13C 88
                CLRB    r1                     ; 147B 0 108 13C 2115
                SLL     er0                    ; 147D 0 108 13C 44D7
                                               ; 147F from 145B (DD1,108,13C)
label_147f:     L       A, off(0014ah)         ; 147F 1 108 13C E44A
                JEQ     label_1493             ; 1481 1 108 13C C910
                                               ; 1483 from 146C (DD1,108,13C)
                                               ; 1483 from 1471 (DD1,108,13C)
label_1483:     MUL                            ; 1483 1 108 13C 9035
                LB      A, r3                  ; 1485 0 108 13C 7B
                JNE     label_1490             ; 1486 0 108 13C CE08
                LB      A, r2                  ; 1488 0 108 13C 7A
                L       A, ACC                 ; 1489 1 108 13C E506
                SWAP                           ; 148B 1 108 13C 83
                ADD     A, off(0014ch)         ; 148C 1 108 13C 874C
                JGE     label_1493             ; 148E 1 108 13C CD03
                                               ; 1490 from 1486 (DD0,108,13C)
label_1490:     L       A, #0ffffh             ; 1490 1 108 13C 67FFFF
                                               ; 1493 from 144C (DD1,108,13C)
                                               ; 1493 from 1452 (DD1,108,13C)
                                               ; 1493 from 1454 (DD1,108,13C)
                                               ; 1493 from 1481 (DD1,108,13C)
                                               ; 1493 from 148E (DD1,108,13C)
label_1493:     ST      A, er3                 ; 1493 1 108 13C 8B
                JBS     off(0010dh).0, label_1498 ; 1494 1 108 13C E80D01
                CLR     A                      ; 1497 1 108 13C F9
                                               ; 1498 from 1494 (DD1,108,13C)
label_1498:     CLRB    r5                     ; 1498 1 108 13C 2515
                JBS     off(00118h).7, label_14aa ; 149A 1 108 13C EF180D
                CMPB    0a4h, #029h            ; 149D 1 108 13C C5A4C029
                JGE     label_14aa             ; 14A1 1 108 13C CD07
                JBR     off(00124h).1, label_14aa ; 14A3 1 108 13C D92404
                JBS     off(00123h).3, label_14aa ; 14A6 1 108 13C EB2301
                INCB    r5                     ; 14A9 1 108 13C AD
                                               ; 14AA from 149A (DD1,108,13C)
                                               ; 14AA from 14A1 (DD1,108,13C)
                                               ; 14AA from 14A3 (DD1,108,13C)
                                               ; 14AA from 14A6 (DD1,108,13C)
label_14aa:     AND     IE, #00080h            ; 14AA 1 108 13C B51AD08000
                RB      PSWH.0                 ; 14AF 1 108 13C A208
                ST      A, 0d0h                ; 14B1 1 108 13C D5D0
                ST      A, 0d2h                ; 14B3 1 108 13C D5D2
                L       A, er3                 ; 14B5 1 108 13C 37
                JBR     off(00123h).1, label_14bf ; 14B6 1 108 13C D92306
                L       A, off(00148h)         ; 14B9 1 108 13C E448
                JBR     off(0010dh).0, label_14bf ; 14BB 1 108 13C D80D01
                CLR     A                      ; 14BE 1 108 13C F9
                                               ; 14BF from 14B6 (DD1,108,13C)
                                               ; 14BF from 14BB (DD1,108,13C)
label_14bf:     ST      A, 0d4h                ; 14BF 1 108 13C D5D4
                SB      PSWH.0                 ; 14C1 1 108 13C A218
                L       A, 0cch                ; 14C3 1 108 13C E5CC
                ST      A, IE                  ; 14C5 1 108 13C D51A
                                               ; 14C7 from 13C9 (DD1,108,13C)
label_14c7:     CLR     A                      ; 14C7 1 108 13C F9
                CLRB    A                      ; 14C8 0 108 13C FA
                JBR     off(00118h).7, label_14ce ; 14C9 0 108 13C DF1802
                ADDB    A, #002h               ; 14CC 0 108 13C 8602
                                               ; 14CE from 14C9 (DD0,108,13C)
label_14ce:     LC      A, 02f94h[ACC]         ; 14CE 0 108 13C B506A9942F
                MOV     DP, #001eeh            ; 14D3 0 108 13C 62EE01
                STB     A, r0                  ; 14D6 0 108 13C 88
                LB      A, ACCH                ; 14D7 0 108 13C F507
                CMPB    A, 0ach                ; 14D9 0 108 13C C5ACC2
                MOV     er1, #0036bh           ; 14DC 0 108 13C 45986B03
                JLT     label_14f3             ; 14E0 0 108 13C CA11
                INC     DP                     ; 14E2 0 108 13C 72
                CMPB    0a4h, #002h            ; 14E3 0 108 13C C5A4C002
                JLT     label_14f0             ; 14E7 0 108 13C CA07
                CMPB    0a4h, #002h            ; 14E9 0 108 13C C5A4C002
                JLT     label_150d             ; 14ED 0 108 13C CA1E
                INC     DP                     ; 14EF 0 108 13C 72
                                               ; 14F0 from 14E7 (DD0,108,13C)
label_14f0:     MOV     er1, off(00156h)       ; 14F0 0 108 13C B45649
                                               ; 14F3 from 14E0 (DD0,108,13C)
label_14f3:     L       A, 0d6h                ; 14F3 1 108 13C E5D6
                SUB     A, off(0014eh)         ; 14F5 1 108 13C A74E
                JLT     label_1502             ; 14F7 1 108 13C CA09
                CMP     er1, A                 ; 14F9 1 108 13C 45C1
                JGE     label_1502             ; 14FB 1 108 13C CD05
                LB      A, [DP]                ; 14FD 0 108 13C F2
                JNE     label_150d             ; 14FE 0 108 13C CE0D
                SJ      label_150e             ; 1500 0 108 13C CB0C
                                               ; 1502 from 14F7 (DD1,108,13C)
                                               ; 1502 from 14FB (DD1,108,13C)
label_1502:     MOVB    off(001eeh), #000h     ; 1502 1 108 13C C4EE9800
                MOVB    off(001efh), r0        ; 1506 1 108 13C 207CEF
                MOVB    off(001f0h), #000h     ; 1509 1 108 13C C4F09800
                                               ; 150D from 14ED (DD0,108,13C)
                                               ; 150D from 14FE (DD0,108,13C)
label_150d:     RC                             ; 150D 0 108 13C 95
                                               ; 150E from 1500 (DD0,108,13C)
label_150e:     MB      off(00122h).1, C       ; 150E 0 108 13C C42239
                SB      0f2h.5                 ; 1511 0 108 13C C5F21D
                                               ; 1514 from 410F (DD0,108,13C)
label_1514:     SB      0f2h.4                 ; 1514 0 108 13C C5F21C
                RB      PSWH.0                 ; 1517 0 108 13C A208
                RB      off(00119h).0          ; 1519 0 108 13C C41908
                J       label_03e0             ; 151C 0 108 13C 03E003
                                               ; 151F from 0010 (DD0,???,???)
int_timer_0_overflow: MOV     LRB, #00040h           ; 151F 0 200 ??? 574000
                L       A, off(00214h)         ; 1522 1 200 ??? E414
                JNE     label_1558             ; 1524 1 200 ??? CE32
                L       A, off(00216h)         ; 1526 1 200 ??? E416
                JEQ     label_158d             ; 1528 1 200 ??? C963
                LB      A, off(0021bh)         ; 152A 0 200 ??? F41B
                MB      C, ACC.7               ; 152C 0 200 ??? C5062F
                ROLB    A                      ; 152F 0 200 ??? 33
                ORB     off(0021ch), A         ; 1530 0 200 ??? C41CE1
                MB      C, ACC.7               ; 1533 0 200 ??? C5062F
                ROLB    A                      ; 1536 0 200 ??? 33
                STB     A, off(0021bh)         ; 1537 0 200 ??? D41B
                ORB     A, off(0021ch)         ; 1539 0 200 ??? E71C
                ANDB    A, #00fh               ; 153B 0 200 ??? D60F
                STB     A, off(0021ch)         ; 153D 0 200 ??? D41C
                CAL     label_2897             ; 153F 0 200 ??? 329728
                ORB     P2, off(0021ch)        ; 1542 0 200 ??? C524E31C
                L       A, off(00216h)         ; 1546 1 200 ??? E416
                ST      A, TM0                 ; 1548 1 200 ??? D530
                CAL     label_28b0             ; 154A 1 200 ??? 32B028
                MOV     off(00214h), off(00218h) ; 154D 1 200 ??? B4187C14
                L       A, #0ffffh             ; 1551 1 200 ??? 67FFFF
                ST      A, off(00216h)         ; 1554 1 200 ??? D416
                SJ      label_157e             ; 1556 1 200 ??? CB26
                                               ; 1558 from 1524 (DD1,200,???)
label_1558:     LB      A, off(0021bh)         ; 1558 0 200 ??? F41B
                MB      C, ACC.7               ; 155A 0 200 ??? C5062F
                ROLB    A                      ; 155D 0 200 ??? 33
                STB     A, off(0021bh)         ; 155E 0 200 ??? D41B
                ANDB    A, #00fh               ; 1560 0 200 ??? D60F
                ORB     off(0021ch), A         ; 1562 0 200 ??? C41CE1
                CAL     label_2897             ; 1565 0 200 ??? 329728
                ORB     P2, off(0021ch)        ; 1568 0 200 ??? C524E31C
                L       A, off(00214h)         ; 156C 1 200 ??? E414
                ST      A, TM0                 ; 156E 1 200 ??? D530
                CAL     label_28b0             ; 1570 1 200 ??? 32B028
                MOV     off(00214h), off(00216h) ; 1573 1 200 ??? B4167C14
                MOV     off(00216h), off(00218h) ; 1577 1 200 ??? B4187C16
                L       A, #0ffffh             ; 157B 1 200 ??? 67FFFF
                                               ; 157E from 1556 (DD1,200,???)
                                               ; 157E from 15B7 (DD1,200,???)
label_157e:     ST      A, off(00218h)         ; 157E 1 200 ??? D418
                CMPB    off(0021ch), #00fh     ; 1580 1 200 ??? C41CC00F
                JNE     label_158c             ; 1584 1 200 ??? CE06
                RB      TCON0.4                ; 1586 1 200 ??? C5400C
                RB      IRQ.4                  ; 1589 1 200 ??? C5180C
                                               ; 158C from 1584 (DD1,200,???)
label_158c:     RTI                            ; 158C 1 200 ??? 02
                                               ; 158D from 1528 (DD1,200,???)
label_158d:     L       A, off(00218h)         ; 158D 1 200 ??? E418
                JEQ     label_15b9             ; 158F 1 200 ??? C928
                LB      A, off(0021bh)         ; 1591 0 200 ??? F41B
                XORB    A, #0ffh               ; 1593 0 200 ??? F6FF
                ANDB    A, #00fh               ; 1595 0 200 ??? D60F
                ORB     off(0021ch), A         ; 1597 0 200 ??? C41CE1
                LB      A, off(0021bh)         ; 159A 0 200 ??? F41B
                MB      C, ACC.0               ; 159C 0 200 ??? C50628
                RORB    A                      ; 159F 0 200 ??? 43
                STB     A, off(0021bh)         ; 15A0 0 200 ??? D41B
                CAL     label_2897             ; 15A2 0 200 ??? 329728
                ORB     P2, off(0021ch)        ; 15A5 0 200 ??? C524E31C
                L       A, off(00218h)         ; 15A9 1 200 ??? E418
                ST      A, TM0                 ; 15AB 1 200 ??? D530
                                               ; 15AD from 15C4 (DD1,200,???)
label_15ad:     CAL     label_28b0             ; 15AD 1 200 ??? 32B028
                L       A, #0ffffh             ; 15B0 1 200 ??? 67FFFF
                ST      A, off(00214h)         ; 15B3 1 200 ??? D414
                ST      A, off(00216h)         ; 15B5 1 200 ??? D416
                SJ      label_157e             ; 15B7 1 200 ??? CBC5
                                               ; 15B9 from 158F (DD1,200,???)
label_15b9:     MOVB    off(0021ch), #00fh     ; 15B9 1 200 ??? C41C980F
                CAL     label_2897             ; 15BD 1 200 ??? 329728
                ORB     P2, #00fh              ; 15C0 1 200 ??? C524E00F
                SJ      label_15ad             ; 15C4 1 200 ??? CBE7
                                               ; 15C6 from 0022 (DD0,???,???)
int_PWM_timer:  L       A, 0ceh                ; 15C6 1 ??? ??? E5CE
                ST      A, IE                  ; 15C8 1 ??? ??? D51A
                SB      PSWH.0                 ; 15CA 1 ??? ??? A218
                MOV     LRB, #00040h           ; 15CC 1 200 ??? 574000
                JBR     off(0021dh).0, label_15f1 ; 15CF 1 200 ??? D81D1F
                RB      off(0021dh).0          ; 15D2 1 200 ??? C41D08
                MOV     PWMR1, #0fd58h         ; 15D5 1 200 ??? B5769858FD
                L       A, ADCR4               ; 15DA 1 200 ??? E568
                ST      A, 0a8h                ; 15DC 1 200 ??? D5A8
                L       A, off(00202h)         ; 15DE 1 200 ??? E402
                ST      A, off(00204h)         ; 15E0 1 200 ??? D404
                JBS     off(00203h).4, label_15e8 ; 15E2 1 200 ??? EC0303
                L       A, #0e001h             ; 15E5 1 200 ??? 6701E0
                                               ; 15E8 from 15E2 (DD1,200,???)
                                               ; 15E8 from 15FB (DD1,200,???)
                                               ; 15E8 from 1601 (DD1,200,???)
label_15e8:     ST      A, PWMR0               ; 15E8 1 200 ??? D572
                L       A, 0cch                ; 15EA 1 200 ??? E5CC
                RB      PSWH.0                 ; 15EC 1 200 ??? A208
                ST      A, IE                  ; 15EE 1 200 ??? D51A
                RTI                            ; 15F0 1 200 ??? 02
                                               ; 15F1 from 15CF (DD1,200,???)
label_15f1:     SB      off(0021dh).0          ; 15F1 1 200 ??? C41D18
                MOV     PWMR1, #0ffffh         ; 15F4 1 200 ??? B57698FFFF
                L       A, off(00204h)         ; 15F9 1 200 ??? E404
                JBR     off(00205h).4, label_15e8 ; 15FB 1 200 ??? DC05EA
                L       A, #0ffffh             ; 15FE 1 200 ??? 67FFFF
                SJ      label_15e8             ; 1601 1 200 ??? CBE5
                                               ; 1603 from 0008 (DD0,???,???)
int_INT0:       L       A, IE                  ; 1603 1 ??? ??? E51A
                PUSHS   A                      ; 1605 1 ??? ??? 55
                L       A, 0ceh                ; 1606 1 ??? ??? E5CE
                ST      A, IE                  ; 1608 1 ??? ??? D51A
                SB      PSWH.0                 ; 160A 1 ??? ??? A218
                MOV     LRB, #00020h           ; 160C 1 100 ??? 572000
                SB      0f2h.0                 ; 160F 1 100 ??? C5F218
                L       A, TM1                 ; 1612 1 100 ??? E534
                XCHG    A, 0c8h                ; 1614 1 100 ??? B5C810
                ST      A, 0c6h                ; 1617 1 100 ??? D5C6
                LB      A, 0e2h                ; 1619 0 100 ??? F5E2
                STB     A, 0cah                ; 161B 0 100 ??? D5CA
                CLRB    0e2h                   ; 161D 0 100 ??? C5E215
                RB      IRQ.6                  ; 1620 0 100 ??? C5180E
                JEQ     label_163b             ; 1623 0 100 ??? C916
                MB      C, off(0011eh).6       ; 1625 0 100 ??? C41E2E
                MB      off(0011eh).7, C       ; 1628 0 100 ??? C41E3F
                SB      off(0011eh).6          ; 162B 0 100 ??? C41E1E
                MB      C, 0c9h.7              ; 162E 0 100 ??? C5C92F
                JGE     label_1638             ; 1631 0 100 ??? CD05
                INCB    0e2h                   ; 1633 0 100 ??? C5E216
                SJ      label_163b             ; 1636 0 100 ??? CB03
                                               ; 1638 from 1631 (DD0,100,???)
label_1638:     INCB    0cah                   ; 1638 0 100 ??? C5CA16
                                               ; 163B from 1623 (DD0,100,???)
                                               ; 163B from 1636 (DD0,100,???)
label_163b:     RB      PSWH.0                 ; 163B 0 100 ??? A208
                POPS    A                      ; 163D 1 100 ??? 65
                ST      A, IE                  ; 163E 1 100 ??? D51A
                RTI                            ; 1640 1 100 ??? 02
                                               ; 1641 from 0014 (DD0,???,???)
int_timer_1_overflow: AND     IE, #00080h            ; 1641 0 ??? ??? B51AD08000
                SB      PSWH.0                 ; 1646 0 ??? ??? A218
                MOV     LRB, #00020h           ; 1648 0 100 ??? 572000
                MB      C, off(0011eh).6       ; 164B 0 100 ??? C41E2E
                MB      off(0011eh).7, C       ; 164E 0 100 ??? C41E3F
                SB      off(0011eh).6          ; 1651 0 100 ??? C41E1E
                L       A, 0ceh                ; 1654 1 100 ??? E5CE
                ST      A, IE                  ; 1656 1 100 ??? D51A
                RB      0f1h.4                 ; 1658 1 100 ??? C5F10C
                JEQ     label_1661             ; 165B 1 100 ??? C904
                ANDB    off(0011eh), #03fh     ; 165D 1 100 ??? C41ED03F
                                               ; 1661 from 165B (DD1,100,???)
label_1661:     INCB    0e2h                   ; 1661 1 100 ??? C5E216
                L       A, 0cch                ; 1664 1 100 ??? E5CC
                RB      PSWH.0                 ; 1666 1 100 ??? A208
                ST      A, IE                  ; 1668 1 100 ??? D51A
                RTI                            ; 166A 1 100 ??? 02
                                               ; 166B from 000E (DD0,???,???)
int_serial_rx_BRG: SB      0f2h.1                 ; 166B 0 ??? ??? C5F219
                L       A, ADCR7               ; 166E 1 ??? ??? E56E
                ST      A, 0aah                ; 1670 1 ??? ??? D5AA
                RTI                            ; 1672 1 ??? ??? 02
                                               ; 1673 from 0000 (DD0,???,???)
int_start:      MOV     PSW, #00010h           ; 1673 0 ??? ??? B504981000
                                               ; 1678 from 1699 (DD0,???,???)
label_1678:     J       label_41ab             ; 1678 0 ??? ??? 03AB41
                DB  002h ; 167B
                                               ; 167C from 41B3 (DD0,???,???)
label_167c:     MOV     LRB, #00010h           ; 167C 0 080 ??? 571000
                CLR     er1                    ; 167F 0 080 ??? 4515
                JBR     off(PSW).4, label_169b ; 1681 0 080 ??? DC0417
                                               ; 1684 from 169F (DD0,080,???)
label_1684:     MOV     DP, #08000h            ; 1684 0 080 ??? 620080
                MOVB    A, [DP]                ; 1687 0 080 ??? C299
                ANDB    A, #080h               ; 1689 0 080 ??? D680
                STB     A, r0                  ; 168B 0 080 ??? 88
                MOVB    r1, #020h              ; 168C 0 080 ??? 9920
                MOVB    r2, #014h              ; 168E 0 080 ??? 9A14
                SJ      label_16b2             ; 1690 0 080 ??? CB20
                                               ; 1692 from 0004 (DD0,???,???)
int_WDT:        MOVB    0f0h, #044h            ; 1692 0 ??? ??? C5F09844
                                               ; 1696 from 0002 (DD0,???,???)
                                               ; 1696 from 000C (DD0,???,???)
                                               ; 1696 from 0018 (DD0,???,???)
                                               ; 1696 from 001C (DD0,???,???)
                                               ; 1696 from 001E (DD0,???,???)
                                               ; 1696 from 0020 (DD0,???,???)
                                               ; 1696 from 0024 (DD0,???,???)
int_break:      CLR     PSW                    ; 1696 0 ??? ??? B50415
                SJ      label_1678             ; 1699 0 ??? ??? CBDD
                                               ; 169B from 1681 (DD0,080,???)
label_169b:     CMPB    0f0h, #047h            ; 169B 0 080 ??? C5F0C047
                JEQ     label_1684             ; 169F 0 080 ??? C9E3
                SB      0f1h.6                 ; 16A1 0 080 ??? C5F11E
                MOVB    r0, off(000f1h)        ; 16A4 0 080 ??? C4F148
                MOVB    r1, off(000eah)        ; 16A7 0 080 ??? C4EA49
                MOVB    r3, off(000f0h)        ; 16AA 0 080 ??? C4F04B
                JBS     off(000f0h).3, label_16b2 ; 16AD 0 080 ??? EBF002
                SB      PSWL.4                 ; 16B0 0 080 ??? A31C
                                               ; 16B2 from 1690 (DD0,080,???)
                                               ; 16B2 from 16AD (DD0,080,???)
label_16b2:     JBR     off(P4).1, label_16b8  ; 16B2 0 080 ??? D92C03
                J       int_NMI                ; 16B5 0 080 ??? 038F00
                                               ; 16B8 from 16B2 (DD0,080,???)
label_16b8:     CLRB    PRPHF                  ; 16B8 0 080 ??? C51215
                MOVB    P0, #0bfh              ; 16BB 0 080 ??? C52098BF
                MOVB    P0IO, #0ffh            ; 16BF 0 080 ??? C52198FF
                MOVB    P1, #0fbh              ; 16C3 0 080 ??? C52298FB
                MOVB    P1IO, #0ffh            ; 16C7 0 080 ??? C52398FF
                MOVB    P2, #01fh              ; 16CB 0 080 ??? C524981F
                MOVB    P2IO, #0ffh            ; 16CF 0 080 ??? C52598FF
                MOVB    P2SF, #000h            ; 16D3 0 080 ??? C5269800
                MOVB    P3, #0ffh              ; 16D7 0 080 ??? C52898FF

                ; 19200 baud

				; STM   = ---- --00 = Mode A = UART normal
				; STL   = ---- 11-- = 8 bits data
				; STSTB = ---1 ---- = 1 stop bit
				; STPEN = --1- ---- = Parity on
				; STEVN = -0-- ---- = Odd parity

				; SRM   = ---- --00 = Mode A = UART normal
				; SRL   = ---- 11-- = 8 bits data
				; SRMST = ---x ---- = n.u.
				; SRPEN = --1- ---- = Parity on
				; SREVN = -0-- ---- = Odd parity
				; SRREN = 0--- ---- = Receiving prohibited

                ;datalogging changes
                MOVB    STTMC, #002h           ; nc
                MOVB    STCON, #03ch           ; from #31h to #3ch
                MOVB    SRCON, #02ch           ; from #21h to #2ch
                MOVB    STTM, #0f3h            ; from #fch to #f3h
                MOVB    STTMR, #0f3h           ; from #fch to #f3h
                MOVB    SRTMC, #0c0h           ; nc


                LB      A, #064h               ; 16F3 0 080 ??? 7764
                STB     A, SRTM                ; 16F5 0 080 ??? D54C
                STB     A, SRTMR               ; 16F7 0 080 ??? D54D
                CLRB    EXION                  ; 16F9 0 080 ??? C51C15
                CLR     A                      ; 16FC 1 080 ??? F9
                MOVB    TCON0, #08ch           ; 16FD 1 080 ??? C540988C
                MOV     TM0, #00001h           ; 1701 1 080 ??? B530980100
                ST      A, TMR0                ; 1706 1 080 ??? D532
                MOVB    TCON1, #08eh           ; 1708 1 080 ??? C541988E
                ST      A, TM1                 ; 170C 1 080 ??? D534
                ST      A, TMR1                ; 170E 1 080 ??? D536
                MOVB    TCON2, #08fh           ; 1710 1 080 ??? C542988F
                MOV     TM2, #00001h           ; 1714 1 080 ??? B538980100
                ST      A, TMR2                ; 1719 1 080 ??? D53A
                MOVB    TCON3, #08fh           ; 171B 1 080 ??? C543988F
                MOVB    P3IO, #051h            ; 171F 1 080 ??? C5299851
                MOVB    P3SF, #06fh            ; 1723 1 080 ??? C52A986F
                MOVB    P4, #0ffh              ; 1727 1 080 ??? C52C98FF
                L       A, #0ff00h             ; 172B 1 080 ??? 6700FF
                MOVB    PWCON0, #02eh          ; 172E 1 080 ??? C578982E
                ST      A, PWMC0               ; 1732 1 080 ??? D570
                ST      A, PWMR0               ; 1734 1 080 ??? D572
                MOVB    PWCON1, #06eh          ; 1736 1 080 ??? C57A986E
                ST      A, PWMC1               ; 173A 1 080 ??? D574
                ST      A, PWMR1               ; 173C 1 080 ??? D576
                MOVB    P4IO, #00dh            ; 173E 1 080 ??? C52D980D
                MOVB    P4SF, #0bch            ; 1742 1 080 ??? C52E98BC
                SB      TCON1.4                ; 1746 1 080 ??? C5411C
                MOV     er3, (0ffffh-0ffffh)[USP] ; 1749 1 080 ??? B3004B
                SB      TCON2.4                ; 174C 1 080 ??? C5421C
                CLR     IRQ                    ; 174F 1 080 ??? B51815
                LB      A, #002h               ; 1752 0 080 ??? 7702
                MOV     DP, #00078h            ; 1754 0 080 ??? 627800
                                               ; 1757 from 1779 (DD0,080,00F)
label_1757:     SB      [DP].4                 ; 1757 0 080 ??? C21C
                MOV     USP, #00160h           ; 1759 0 080 160 A1986001
                                               ; 175D from 1764 (DD0,080,15F)
label_175d:     DEC     USP                    ; 175D 0 080 15F A117
                JEQ     label_1780             ; 175F 0 080 15F C91F
                MBR     C, off(P4)             ; 1761 0 080 15F C42C21
                JLT     label_175d             ; 1764 0 080 15F CAF7
                MOV     USP, #00010h           ; 1766 0 080 010 A1981000
                                               ; 176A from 1771 (DD0,080,00F)
label_176a:     DEC     USP                    ; 176A 0 080 00F A117
                JEQ     label_1780             ; 176C 0 080 00F C912
                MBR     C, off(P4)             ; 176E 0 080 00F C42C21
                JGE     label_176a             ; 1771 0 080 00F CDF7
                INC     DP                     ; 1773 0 080 00F 72
                INC     DP                     ; 1774 0 080 00F 72
                ADDB    A, #001h               ; 1775 0 080 00F 8601
                CMPB    A, #004h               ; 1777 0 080 00F C604
                JNE     label_1757             ; 1779 0 080 00F CEDC
                RB      IRQH.5                 ; 177B 0 080 00F C5190D
                JNE     label_1785             ; 177E 0 080 00F CE05
                                               ; 1780 from 175F (DD0,080,15F)
                                               ; 1780 from 176C (DD0,080,00F)
label_1780:     MOVB    off(000f0h), #04ch     ; 1780 0 080 00F C4F0984C
                BRK                            ; 1784 0 080 00F FF
                                               ; 1785 from 177E (DD0,080,00F)
label_1785:     RB      PWCON1.5               ; 1785 0 080 00F C57A0D
                MOV     DP, #00265h            ; 1788 0 080 00F 626502
                JBR     off(PSW).4, label_1791 ; 178B 0 080 00F DC0403
                MOV     DP, #0027fh            ; 178E 0 080 00F 627F02
                                               ; 1791 from 178B (DD0,080,00F)
                                               ; 1791 from 17A9 (DD0,080,00F)
label_1791:     LB      A, #055h               ; 1791 0 080 00F 7755
                STB     A, [DP]                ; 1793 0 080 00F D2
                CMPB    A, [DP]                ; 1794 0 080 00F C2C2
                JNE     label_179e             ; 1796 0 080 00F CE06
                SLLB    A                      ; 1798 0 080 00F 53
                STB     A, [DP]                ; 1799 0 080 00F D2
                SUBB    A, [DP]                ; 179A 0 080 00F C2A2
                JEQ     label_17a3             ; 179C 0 080 00F C905
                                               ; 179E from 1796 (DD0,080,00F)
label_179e:     MOVB    off(000f0h), #042h     ; 179E 0 080 00F C4F09842
                BRK                            ; 17A2 0 080 00F FF
                                               ; 17A3 from 179C (DD0,080,00F)
label_17a3:     STB     A, [DP]                ; 17A3 0 080 00F D2
                DEC     DP                     ; 17A4 0 080 00F 82
                CMP     DP, #00086h            ; 17A5 0 080 00F 92C08600
                JGE     label_1791             ; 17A9 0 080 00F CDE6
                MOVB    off(000f1h), r0        ; 17AB 0 080 00F 207CF1
                MOVB    off(000eah), r1        ; 17AE 0 080 00F 217CEA
                LB      A, r2                  ; 17B1 0 080 00F 7A
                MOVB    off(000f0h), r3        ; 17B2 0 080 00F 237CF0
                SLL     LRB                    ; 17B5 0 080 00F A4D7
                STB     A, off(000e7h)         ; 17B7 0 080 00F D4E7
                CLR     A                      ; 17B9 1 080 00F F9
                ST      A, IE                  ; 17BA 1 080 00F D51A
                CLR     DP                     ; 17BC 1 080 00F 9215
                                               ; 17BE from 17CC (DD1,080,00F)
label_17be:     MUL                            ; 17BE 1 080 00F 9035
                MUL                            ; 17C0 1 080 00F 9035
                MUL                            ; 17C2 1 080 00F 9035
                MUL                            ; 17C4 1 080 00F 9035
                MUL                            ; 17C6 1 080 00F 9035
                MUL                            ; 17C8 1 080 00F 9035
                MUL                            ; 17CA 1 080 00F 9035
                JRNZ    DP, label_17be         ; 17CC 1 080 00F 30F0
                CLRB    ADSEL                  ; 17CE 1 080 00F C55915
                MOVB    ADSCAN, #010h          ; 17D1 1 080 00F C5589810
                MOVB    0ech, #001h            ; 17D5 1 080 00F C5EC9801
                RB      IRQH.4                 ; 17D9 1 080 00F C5190C

                ;initialization
                ;this code is executed when the ignition is on but the engine is off
                                               ; 17DC from 17DE (DD1,080,00F)
                                               ; 17DC from 17E7 (DD0,080,00F)
label_17dc:     MB      r0.0, C                ; 17DC 1 080 00F 2038
                JRNZ    DP, label_17dc         ; 17DE 1 080 00F 30FC
                CAL     label_2c6e             ; 17E0 1 080 00F 326E2C
                LB      A, P2                  ; 17E3 0 080 00F F524
                ANDB    A, #0e0h               ; 17E5 0 080 00F D6E0
                JNE     label_17dc             ; 17E7 0 080 00F CEF3
                L       A, ADCR4               ; 17E9 1 080 00F E568
                ST      A, 0a8h                ; 17EB 1 080 00F D5A8
                LB      A, ADCR6H              ; 17ED 0 080 00F F56D
                STB     A, 0a5h                ; 17EF 0 080 00F D5A5
                L       A, ADCR5               ; 17F1 1 080 00F E56A
                ST      A, 0b0h                ; 17F3 1 080 00F D5B0
                LB      A, ACCH                ; 17F5 0 080 00F F507
                CAL		initcolumn
                NOP
                ;MOVB	0b5h, #00ah
                ;STB     A, 0b5h                ; 17F7 0 080 00F D5B5
                ;STB     A, 0b2h                ; 17F9 0 080 00F D5B2
                L       A, ADCR7               ; 17FB 1 080 00F E56E
                ST      A, 0aah                ; 17FD 1 080 00F D5AA
                MOVB    0a4h, #03ch            ; 17FF 1 080 00F C5A4983C
                MOVB    0a3h, #057h            ; 1803 1 080 00F C5A39857
                MOVB    0b3h, #0a0h            ; 1807 1 080 00F C5B398A0
                LB      A, #02bh               ; 180B 0 080 00F 772B
                STB     A, 0ach                ; 180D 0 080 00F D5AC
                STB     A, 0aeh                ; 180F 0 080 00F D5AE
                LB      A, #080h               ; 1811 0 080 00F 7780
                STB     A, 0adh                ; 1813 0 080 00F D5AD
                STB     A, 0afh                ; 1815 0 080 00F D5AF
                STB     A, off(0009dh)         ; 1817 0 080 00F D49D
                SB      off(0001eh).7          ; 1819 0 080 00F C41E1F
                L       A, #0ffffh             ; 181C 1 080 00F 67FFFF
                ST      A, 0c4h                ; 181F 1 080 00F D5C4
                SB      off(0001eh).0          ; 1821 1 080 00F C41E18
                MOV     USP, #00219h           ; 1824 1 080 219 A1981902
                ST      A, (00202h-00219h)[USP] ; 1828 1 080 219 D3E9
                PUSHU   A                      ; 182A 1 080 217 76
                PUSHU   A                      ; 182B 1 080 215 76
                PUSHU   A                      ; 182C 1 080 213 76
                MOV     (0021ah-00213h)[USP], #08877h ; 182D 1 080 213 B307987788
                MOVB    (0021ch-00213h)[USP], #00fh ; 1832 1 080 213 C309980F
                MOVB    0ebh, #003h            ; 1836 1 080 213 C5EB9803
                LB      A, 099h                ; 183A 0 080 213 F599
                STB     A, off(00098h)         ; 183C 0 080 213 D498
                CAL     label_2d1d             ; 183E 0 080 213 321D2D
                LB      A, 09eh          ;mugen -> LB      A, #000h    ;knock??
                ANDB    A, #0c0h               ; c0h = 11000000
                STB     A, off(IRQ)            ; 1845 0 080 213 D418
                J       label_1d14             ; 1847 0 080 213 03141D
                                               ; 184A from 1D1D (DD0,080,213)
                                               ; 184A from 1854 (DD0,080,213)
label_184a:     LCB     A, 032feh[DP]          ; 184A 0 080 213 92ABFE32
                STB     A, [DP]                ; 184E 0 080 213 D2
                INC     DP                     ; 184F 0 080 213 72
                CMP     DP, #001dch            ; 1850 0 080 213 92C0DC01
                JNE     label_184a             ; 1854 0 080 213 CEF4
                MOV     DP, #00266h            ; 1856 0 080 213 626602
                L       A, [DP]                ; 1859 1 080 213 E2
                JEQ     label_1861             ; 185A 1 080 213 C905
                CMP     A, #01000h             ; 185C 1 080 213 C60010
                JLE     label_186b             ; 185F 1 080 213 CF0A
                                               ; 1861 from 185A (DD1,080,213)
label_1861:     L       A, #00300h             ; 1861 1 080 213 670003
                JBR     off(IRQ).7, label_186a ; 1864 1 080 213 DF1803
                L       A, #00500h     ;mugen -> #00300h        ; 1867 1 080 213 670005
                                               ; 186A from 1864 (DD1,080,213)
label_186a:     ST      A, [DP]                ; 186A 1 080 213 D2
                                               ; 186B from 185F (DD1,080,213)
label_186b:     MOV     DP, #0026ch            ; 186B 1 080 213 626C02

				;loop
                                               ; 186E from 1885 (DD1,080,213)
label_186e:     L       A, [DP]                ; 186E 1 080 213 E2
                CMP     A, #0b6e0h             ; 186F 1 080 213 C6E0B6
                JGT     label_1879             ; 1872 1 080 213 C805
                CMP     A, #05720h             ; 1874 1 080 213 C62057
                JGE     label_187d             ; 1877 1 080 213 CD04
                                               ; 1879 from 1872 (DD1,080,213)
label_1879:     MOV     [DP], #08000h          ; 1879 1 080 213 B2980080
                                               ; 187D from 1877 (DD1,080,213)
label_187d:     ADD     DP, #00002h            ; 187D 1 080 213 92800200
                CMP     DP, #00278h            ; 1881 1 080 213 92C07802
                JNE     label_186e             ; 1885 1 080 213 CEE7
                ;end loop

                ;DP = 278h
                ;this goes:
                ;if([278h] > 26h || [278h] <= 4h)
                ;   [278h] = 0;
                LB      A, [DP]                ; 1887 0 080 213 F2
                CMPB    A, #026h               ; 1888 0 080 213 C626
                JGT     label_1890             ; 188A 0 080 213 C804
                CMPB    A, #004h               ; 188C 0 080 213 C604
                JGE     label_1892             ; 188E 0 080 213 CD02
                                               ; 1890 from 188A (DD0,080,213)
label_1890:     CLRB    [DP]                   ; 1890 0 080 213 C215


                                               ; 1892 from 188E (DD0,080,213)
label_1892:     MOV     DP, #08000h            ; 1892 0 080 213 620080
                LB      A, [DP]                ; 1895 0 080 213 F2
                STB     A, 0f3h                ; 1896 0 080 213 D5F3
                J       label_334f             ; 1898 0 080 213 034F33
                                               ; 189B from 2051 (DD1,080,213)
                                               ; 189B from 2122 (DD0,080,213)
                                               ; 189B from 21F3 (DD0,080,0A3)
                                               ; 189B from 22E3 (DD0,080,0A4)
                                               ; 189B from 240F (DD0,080,205)
                                               ; 189B from 24FF (DD1,080,205)
                                               ; 189B from 263C (DD0,080,205)
                                               ; 189B from 268E (DD0,080,205)
                                               ; 189B from 26FA (DD0,080,205)
                                               ; 189B from 281B (DD0,080,132)
                                               ; 189B from 1F04 (DD1,080,132)
                                               ; 189B from 1F3D (DD1,080,132)
vcal_3:         RB      0f2h.1                 ; 189B 1 080 213 C5F209
                JEQ     label_18a2             ; 189E 1 080 213 C902
                SJ      label_18bb             ; 18A0 1 080 213 CB19
                                               ; 18A2 from 189E (DD1,080,213)
label_18a2:     RB      0f2h.4                 ; 18A2 1 080 213 C5F20C
                JEQ     label_18aa             ; 18A5 1 080 213 C903
                J       label_19e9             ; 18A7 1 080 213 03E919
                                               ; 18AA from 18A5 (DD1,080,213)
label_18aa:     RB      0f2h.2                 ; 18AA 1 080 213 C5F20A
                JEQ     label_18b2             ; 18AD 1 080 213 C903
                J       label_1e0a             ; 18AF 1 080 213 030A1E
                                               ; 18B2 from 18AD (DD1,080,213)
label_18b2:     RB      0f2h.3                 ; 18B2 1 080 213 C5F20B
                JEQ     label_18ba             ; 18B5 1 080 213 C903
                J       label_1e9e             ; 18B7 1 080 213 039E1E
                                               ; 18BA from 18B5 (DD1,080,213)
label_18ba:     RT                             ; 18BA 1 080 213 01
                                               ; 18BB from 18A0 (DD1,080,213)
label_18bb:     CAL     label_2d84             ; 18BB 1 080 213 32842D
                MOV     DP, #0000bh            ; 18BE 1 080 213 620B00
                MOV     USP, #001b3h           ; 18C1 1 080 1B3 A198B301
                CAL     label_2d78             ; 18C5 1 080 1B3 32782D
                CLR     A                      ; 18C8 1 080 1B3 F9
                LB      A, off(000bch)         ; 18C9 0 080 1B3 F4BC
                JNE     label_18d4             ; 18CB 0 080 1B3 CE07
                SB      0f2h.3                 ; 18CD 0 080 1B3 C5F21B
                LB      A, #0c8h               ; 18D0 0 080 1B3 77C8
                STB     A, off(000bch)         ; 18D2 0 080 1B3 D4BC
                                               ; 18D4 from 18CB (DD0,080,1B3)
label_18d4:     MOVB    r0, #00ah              ; 18D4 0 080 1B3 980A
                DIVB                           ; 18D6 0 080 1B3 A236
                LB      A, r1                  ; 18D8 0 080 1B3 79
                JNE     label_18de             ; 18D9 0 080 1B3 CE03
                SB      0f2h.2                 ; 18DB 0 080 1B3 C5F21A
                                               ; 18DE from 18D9 (DD0,080,1B3)
label_18de:     JBR     off(000bch).0, label_18e4 ; 18DE 0 080 1B3 D8BC03
                J       label_19cb             ; 18E1 0 080 1B3 03CB19
                                               ; 18E4 from 18DE (DD0,080,1B3)
label_18e4:     MOV     DP, #00202h            ; 18E4 0 080 1B3 620202
                L       A, [DP]                ; 18E7 1 080 1B3 E2
                MOV     X1, #033e8h            ; 18E8 1 080 1B3 60E833
                CAL     label_2c4b             ; 18EB 1 080 1B3 324B2C
                MOV     er0, 0a8h              ; 18EE 1 080 1B3 B5A848
                MUL                            ; 18F1 1 080 1B3 9035
                L       A, er1                 ; 18F3 1 080 1B3 35
                ST      A, off(PWMR0)          ; 18F4 1 080 1B3 D472
                MOV     er0, #06000h           ; 18F6 1 080 1B3 44980060
                SUB     A, off(PWMC0)          ; 18FA 1 080 1B3 A770
                RB      off(P2IO).0            ; 18FC 1 080 1B3 C42508
                MB      off(P2IO).0, C         ; 18FF 1 080 1B3 C42538
                JEQ     label_1907             ; 1902 1 080 1B3 C903
                XORB    PSWH, #080h            ; 1904 1 080 1B3 A2F080
                                               ; 1907 from 1902 (DD1,080,1B3)
label_1907:     JGE     label_190d             ; 1907 1 080 1B3 CD04
                MOVB    off(000fah), #00ah     ; 1909 1 080 1B3 C4FA980A
                                               ; 190D from 1907 (DD1,080,1B3)
label_190d:     JBS     off(P2IO).0, label_191f ; 190D 1 080 1B3 E8250F
                MUL                            ; 1910 1 080 1B3 9035
                L       A, [DP]                ; 1912 1 080 1B3 E2
                ADD     A, er1                 ; 1913 1 080 1B3 09
                MOV     er0, #0fd58h           ; 1914 1 080 1B3 449858FD
                JLT     label_192f             ; 1918 1 080 1B3 CA15
                CMP     A, er0                 ; 191A 1 080 1B3 48
                JLT     label_1933             ; 191B 1 080 1B3 CA16
                SJ      label_192f             ; 191D 1 080 1B3 CB10
                                               ; 191F from 190D (DD1,080,1B3)
label_191f:     ST      A, er1                 ; 191F 1 080 1B3 89
                CLR     A                      ; 1920 1 080 1B3 F9
                SUB     A, er1                 ; 1921 1 080 1B3 29
                MUL                            ; 1922 1 080 1B3 9035
                L       A, [DP]                ; 1924 1 080 1B3 E2
                SUB     A, er1                 ; 1925 1 080 1B3 29
                MOV     er0, #0e002h           ; 1926 1 080 1B3 449802E0
                JLT     label_192f             ; 192A 1 080 1B3 CA03
                CMP     A, er0                 ; 192C 1 080 1B3 48
                JGE     label_1933             ; 192D 1 080 1B3 CD04
                                               ; 192F from 1918 (DD1,080,1B3)
                                               ; 192F from 191D (DD1,080,1B3)
                                               ; 192F from 192A (DD1,080,1B3)
label_192f:     L       A, er0                 ; 192F 1 080 1B3 34
                CLRB    off(000fah)            ; 1930 1 080 1B3 C4FA15
                                               ; 1933 from 191B (DD1,080,1B3)
                                               ; 1933 from 192D (DD1,080,1B3)
label_1933:     SB      ACC.0                  ; 1933 1 080 1B3 C50618
                ST      A, [DP]                ; 1936 1 080 1B3 D2
                MOV     DP, #000c4h            ; 1937 1 080 1B3 62C400
                JBR     off(TMR0).0, label_1945 ;mugen -> NOP NOP NOP ; 193A 1 080 1B3 D83208
                RB      off(0001eh).0          ; 193D 1 080 1B3 C41E08
                L       A, #03eb7h   ;mugen L       A, #00dcch          ; 1940 1 080 1B3 67B73E
                SJ      label_19ae             ; 1943 1 080 1B3 CB69
                                               ; 1945 from 193A (DD1,080,1B3)
label_1945:     RB      0f2h.0                 ; 1945 1 080 1B3 C5F208
                JNE     label_195d             ; 1948 1 080 1B3 CE13
                LB      A, #003h               ; 194A 0 080 1B3 7703
                CMPB    A, 0e2h                ; 194C 0 080 1B3 C5E2C2
                JGT     label_19c4             ; 194F 0 080 1B3 C873
                STB     A, 0e2h                ; 1951 0 080 1B3 D5E2
                                               ; 1953 from 1984 (DD0,080,1B3)
label_1953:     SB      off(0001eh).0          ; 1953 0 080 1B3 C41E18
                L       A, #0ffffh             ; 1956 1 080 1B3 67FFFF
                ST      A, [DP]                ; 1959 1 080 1B3 D2
                CLRB    A                      ; 195A 0 080 1B3 FA
                SJ      label_19c2             ; 195B 0 080 1B3 CB65
                                               ; 195D from 1948 (DD1,080,1B3)
label_195d:     AND     IE, #00080h            ; 195D 1 080 1B3 B51AD08000
                RB      PSWH.0                 ; 1962 1 080 1B3 A208
                L       A, 0c8h                ; 1964 1 080 1B3 E5C8
                MOVB    r7, 0cah               ; 1966 1 080 1B3 C5CA4F
                SUB     A, 0c6h                ; 1969 1 080 1B3 B5C6A2
                ST      A, er0                 ; 196C 1 080 1B3 88
                SB      PSWH.0                 ; 196D 1 080 1B3 A218
                L       A, 0cch                ; 196F 1 080 1B3 E5CC
                ST      A, IE                  ; 1971 1 080 1B3 D51A
                L       A, er0                 ; 1973 1 080 1B3 34
                JGE     label_1977             ; 1974 1 080 1B3 CD01
                DECB    r7                     ; 1976 1 080 1B3 BF
                                               ; 1977 from 1974 (DD1,080,1B3)
label_1977:     JBR     off(P0IO).2, label_197f ; 1977 1 080 1B3 DA2105
                SLL     A                      ; 197A 1 080 1B3 53
                ROLB    r7                     ; 197B 1 080 1B3 27B7
                SJ      label_1982             ; 197D 1 080 1B3 CB03
                                               ; 197F from 1977 (DD1,080,1B3)
label_197f:     SRLB    r7                     ; 197F 1 080 1B3 27E7
                ROR     A                      ; 1981 1 080 1B3 43
                                               ; 1982 from 197D (DD1,080,1B3)
label_1982:     ST      A, er0                 ; 1982 1 080 1B3 88
                LB      A, r7                  ; 1983 0 080 1B3 7F
                JNE     label_1953             ; 1984 0 080 1B3 CECD
                RB      off(0001eh).0          ; 1986 0 080 1B3 C41E08
                JNE     label_19c4             ; 1989 0 080 1B3 CE39
                RB      off(IRQ).3             ; 198B 0 080 1B3 C4180B
                JNE     label_19c4             ; 198E 0 080 1B3 CE34
                L       A, er0                 ; 1990 1 080 1B3 34
                CMP     A, #002c2h             ; 1991 1 080 1B3 C6C202
                MB      off(IRQ).3, C          ; 1994 1 080 1B3 C4183B
                JLT     label_19c4             ; 1997 1 080 1B3 CA2B
                CMP     A, #03000h             ; 1999 1 080 1B3 C60030
                JGE     label_19ae             ; 199C 1 080 1B3 CD10
                CMP     A, #00499h             ; 199E 1 080 1B3 C69904
                MOV     er0, #04000h           ; 19A1 1 080 1B3 44980040
                JGE     label_19ab             ; 19A5 1 080 1B3 CD04
                MOV     er0, #01000h           ; 19A7 1 080 1B3 44980010
                                               ; 19AB from 19A5 (DD1,080,1B3)
label_19ab:     CAL     label_2d56             ; 19AB 1 080 1B3 32562D
                                               ; 19AE from 1943 (DD1,080,1B3)
                                               ; 19AE from 199C (DD1,080,1B3)
label_19ae:     ST      A, [DP]                ; 19AE 1 080 1B3 D2
                ST      A, er2                 ; 19AF 1 080 1B3 8A
                MOV     er0, #00004h           ; 19B0 1 080 1B3 44980400
                L       A, #04fc8h             ; 19B4 1 080 1B3 67C84F
                DIV                            ; 19B7 1 080 1B3 9037
                ST      A, er1                 ; 19B9 1 080 1B3 89
                LB      A, r3                  ; 19BA 0 080 1B3 7B
                ORB     A, r0                  ; 19BB 0 080 1B3 68
                ORB     A, r1                  ; 19BC 0 080 1B3 69
                JEQ     label_19c1             ; 19BD 0 080 1B3 C902
                MOVB    r2, #0ffh              ; 19BF 0 080 1B3 9AFF
                                               ; 19C1 from 19BD (DD0,080,1B3)
label_19c1:     LB      A, r2                  ; 19C1 0 080 1B3 7A
                                               ; 19C2 from 195B (DD0,080,1B3)
label_19c2:     STB     A, 0cbh                ; 19C2 0 080 1B3 D5CB
                                               ; 19C4 from 194F (DD0,080,1B3)
                                               ; 19C4 from 1989 (DD0,080,1B3)
                                               ; 19C4 from 198E (DD0,080,1B3)
                                               ; 19C4 from 1997 (DD1,080,1B3)
label_19c4:     MOV     DP, #04000h            ; 19C4 0 080 1B3 620040
                LB      A, P0                  ; 19C7 0 080 1B3 F520
                SJ      label_19de             ; 19C9 0 080 1B3 CB13
                                               ; 19CB from 18E1 (DD0,080,1B3)
label_19cb:     L       A, 0aah                ; 19CB 1 080 1B3 E5AA
                MOV     DP, #000aeh            ; 19CD 1 080 1B3 62AE00
                CAL     label_2cc4             ; 19D0 1 080 1B3 32C42C
                MB      off(0001fh).3, C       ; 19D3 1 080 1B3 C41F3B
                CAL     label_2c6e             ; 19D6 1 080 1B3 326E2C
                MOV     DP, #08000h            ; 19D9 1 080 1B3 620080
                LB      A, P1                  ; 19DC 0 080 1B3 F522
                                               ; 19DE from 19C9 (DD0,080,1B3)
label_19de:     STB     A, ALRB                ; 19DE 0 080 1B3 D502
                CAL     label_2d96             ; 19E0 0 080 1B3 32962D
                STB     A, 0f3h                ; 19E3 0 080 1B3 D5F3
                MOV     LRB, #00020h           ; 19E5 0 100 1B3 572000
                RT                             ; 19E8 0 100 1B3 01
                                               ; 19E9 from 18A7 (DD1,080,213)
label_19e9:     MB      C, off(P2IO).3         ; 19E9 1 080 213 C4252B
                MB      off(P2IO).4, C         ; 19EC 1 080 213 C4253C
                LB      A, off(000f6h)         ; 19EF 0 080 213 F4F6
                MOVB    r7, #015h              ; 19F1 0 080 213 9F15
                JEQ     label_19f7             ; 19F3 0 080 213 C902
                MOVB    r7, #015h              ; 19F5 0 080 213 9F15
                                               ; 19F7 from 19F3 (DD0,080,213)
label_19f7:     LB      A, off(00097h)         ; 19F7 0 080 213 F497
                JGE     label_19fc             ; 19F9 0 080 213 CD01
                ADDB    A, r7                  ; 19FB 0 080 213 0F
                                               ; 19FC from 19F9 (DD0,080,213)
label_19fc:     CMPB    0a6h, A                ; 19FC 0 080 213 C5A6C1
                MB      off(P2IO).3, C         ; 19FF 0 080 213 C4253B
                JGE     label_1a0d             ; 1A02 0 080 213 CD09
                RC                             ; 1A04 0 080 213 95
                LB      A, off(000fch)         ; 1A05 0 080 213 F4FC
                JNE     label_1a0d             ; 1A07 0 080 213 CE04
                JBS     off(P2IO).4, label_1a0d ; 1A09 0 080 213 EC2501
                SC                             ; 1A0C 0 080 213 85
                                               ; 1A0D from 1A02 (DD0,080,213)
                                               ; 1A0D from 1A07 (DD0,080,213)
                                               ; 1A0D from 1A09 (DD0,080,213)
label_1a0d:     MB      off(P2SF).6, C         ; 1A0D 0 080 213 C4263E
                MB      C, off(P2).1           ; 1A10 0 080 213 C42429
                MB      off(P2).2, C           ; 1A13 0 080 213 C4243A
                L       A, #089fah             ; 1A16 1 080 213 67FA89
                JGE     label_1a1e             ; 1A19 1 080 213 CD03
                L       A, #0e5f5h             ; 1A1B 1 080 213 67F5E5
                                               ; 1A1E from 1A19 (DD1,080,213)
label_1a1e:     CMP     0c4h, A                ; 1A1E 1 080 213 B5C4C1
                MB      off(P2).1, C           ; 1A21 1 080 213 C42439
                LB      A, #0d7h               ; 1A24 0 080 213 77D7
                JBR     off(P2SF).4, label_1a2b ; 1A26 0 080 213 DC2602
                LB      A, #0d4h               ; 1A29 0 080 213 77D4
                                               ; 1A2B from 1A26 (DD0,080,213)
label_1a2b:     CMPB    A, 0a6h                ; 1A2B 0 080 213 C5A6C2
                MB      off(P2SF).4, C         ; 1A2E 0 080 213 C4263C
                MOV     X1, #03255h            ; 1A31 0 080 213 605532
                JBS     off(IRQ).7, label_1a3a ; 1A34 0 080 213 EF1803
                MOV     X1, #0327fh            ; 1A37 0 080 213 607F32
                                               ; 1A3A from 1A34 (DD0,080,213)
label_1a3a:     LB      A, 0a7h                ; 1A3A 0 080 213 F5A7
                JBS     off(P3IO).7, label_1a45 ; 1A3C 0 080 213 EF2906
                ADD     X1, #00015h            ; 1A3F 0 080 213 90801500
                LB      A, 0a6h                ; 1A43 0 080 213 F5A6
                                               ; 1A45 from 1A3C (DD0,080,213)
label_1a45:     VCAL    1                      ; 1A45 0 080 213 11
                STB     A, off(PWCON1)         ; 1A46 0 080 213 D47A
                RB      off(P3).2              ; 1A48 0 080 213 C4280A
                MB      C, 0f3h.4              ; 1A4B 0 080 213 C5F32C
                JGE     label_1a65             ; 1A4E 0 080 213 CD15
                SB      off(P3).1              ; 1A50 0 080 213 C42819
                RB      off(P3).0              ; 1A53 0 080 213 C42808
                JEQ     label_1a5f             ; 1A56 0 080 213 C907
                SB      off(P3).2              ; 1A58 0 080 213 C4281A
                MOVB    off(000f9h), #000h     ; 1A5B 0 080 213 C4F99800
                                               ; 1A5F from 1A56 (DD0,080,213)
label_1a5f:     MOVB    off(000d9h), #002h     ; 1A5F 0 080 213 C4D99802
                SJ      label_1a80             ; 1A63 0 080 213 CB1B
                                               ; 1A65 from 1A4E (DD0,080,213)
label_1a65:     JBR     off(P3).1, label_1a80  ; 1A65 0 080 213 D92818
                LB      A, off(000f9h)         ; 1A68 0 080 213 F4F9
                JNE     label_1a80             ; 1A6A 0 080 213 CE14
                SB      off(P3).0              ; 1A6C 0 080 213 C42818
                MOV     X1, #032bbh            ; 1A6F 0 080 213 60BB32
                LB      A, 0a4h                ; 1A72 0 080 213 F5A4
                VCAL    7                      ; 1A74 0 080 213 17
                CMPB    off(000d9h), #000h     ; 1A75 0 080 213 C4D9C000
                JNE     label_1a81             ; 1A79 0 080 213 CE06
                SUBB    A, #050h        ;mugen -> #00h       ; 1A7B 0 080 213 A650
                SMOVI                   ;mugen -> NOP       ; 1A7D 0 080 213 04
                JGE     label_1a81             ; 1A7E 0 080 213 CD01
                                               ; 1A80 from 1A63 (DD0,080,213)
                                               ; 1A80 from 1A65 (DD0,080,213)
                                               ; 1A80 from 1A6A (DD0,080,213)
label_1a80:     CLR     A                      ; 1A80 1 080 213 F9
                                               ; 1A81 from 1A79 (DD0,080,213)
                                               ; 1A81 from 1A7E (DD0,080,213)
label_1a81:     ST      A, off(00086h)         ; 1A81 1 080 213 D486
                JBS     off(0001fh).4, label_1ac4 ; 1A83 1 080 213 EC1F3E
                JBR     off(P2SF).1, label_1a8c ; 1A86 1 080 213 D92603
                J       label_1afc             ; 1A89 1 080 213 03FC1A
                                               ; 1A8C from 1A86 (DD1,080,213)
label_1a8c:     LB      A, off(TM0)            ; 1A8C 0 080 213 F430
                ANDB    A, #054h               ; 1A8E 0 080 213 D654
                JNE     label_1a95             ; 1A90 0 080 213 CE03
                JBR     off(P3).3, label_1a98  ; 1A92 0 080 213 DB2803
                                               ; 1A95 from 1A90 (DD0,080,213)
                                               ; 1A95 from 1AAA (DD1,080,213)
label_1a95:     J       label_1b1f             ; 1A95 0 080 213 031F1B
                                               ; 1A98 from 1A92 (DD0,080,213)
label_1a98:     JBR     off(P1IO).3, label_1aa0 ; 1A98 0 080 213 DB2305
                JBR     off(P2SF).4, label_1aaa ; 1A9B 0 080 213 DC260C
                SJ      label_1abb             ; 1A9E 0 080 213 CB1B
                                               ; 1AA0 from 1A98 (DD0,080,213)
label_1aa0:     JBR     off(P2).6, label_1aa7  ; 1AA0 0 080 213 DE2404
                L       A, off(PWCON1)         ; 1AA3 1 080 213 E47A
                JNE     label_1b19             ; 1AA5 1 080 213 CE72
                                               ; 1AA7 from 1AA0 (DD0,080,213)
label_1aa7:     JBS     off(P2SF).4, label_1abb ; 1AA7 1 080 213 EC2611
                                               ; 1AAA from 1A9B (DD0,080,213)
label_1aaa:     JBR     off(P2).4, label_1a95  ; 1AAA 1 080 213 DC24E8
                JBR     off(IRQ).7, label_1ab8 ; 1AAD 1 080 213 DF1808
                MB      C, 0f3h.5              ; 1AB0 1 080 213 C5F32D
                JLT     label_1ab8             ; 1AB3 1 080 213 CA03
                JBR     off(P2).6, label_1b1f  ; 1AB5 1 080 213 DE2467
                                               ; 1AB8 from 1AAD (DD1,080,213)
                                               ; 1AB8 from 1AB3 (DD1,080,213)
label_1ab8:     J       label_1b4e             ; 1AB8 1 080 213 034E1B
                                               ; 1ABB from 1A9E (DD0,080,213)
                                               ; 1ABB from 1AA7 (DD1,080,213)
label_1abb:     RB      off(P2SF).2            ; 1ABB 0 080 213 C4260A
                L       A, #011ebh             ; 1ABE 1 080 213 67EB11
                J       label_1e07             ; 1AC1 1 080 213 03071E
                                               ; 1AC4 from 1A83 (DD1,080,213)
label_1ac4:     SB      off(P2SF).1            ; 1AC4 1 080 213 C42619
                CLRB    A                      ; 1AC7 0 080 213 FA
                CMPB    0a4h, #0d0h            ; 1AC8 0 080 213 C5A4C0D0
                JGE     label_1adc             ; 1ACC 0 080 213 CD0E
                LB      A, #003h               ; 1ACE 0 080 213 7703
                JBR     off(P2).4, label_1adc  ; 1AD0 0 080 213 DC2409
                SLLB    A                      ; 1AD3 0 080 213 53
                CMPB    0a4h, #057h            ; 1AD4 0 080 213 C5A4C057
                JGE     label_1adc             ; 1AD8 0 080 213 CD02
                LB      A, #009h               ; 1ADA 0 080 213 7709
                                               ; 1ADC from 1ACC (DD0,080,213)
                                               ; 1ADC from 1AD0 (DD0,080,213)
                                               ; 1ADC from 1AD8 (DD0,080,213)
label_1adc:     EXTND                          ; 1ADC 1 080 213 F8
                ADD     A, #03373h             ; 1ADD 1 080 213 867333
                MOV     X1, A                  ; 1AE0 1 080 213 50
                LCB     A, [X1]                ; 1AE1 1 080 213 90AA
                MOVB    off(000f6h), A         ; 1AE3 1 080 213 C4F68A
                INC     X1                     ; 1AE6 1 080 213 70
                LC      A, [X1]                ; 1AE7 1 080 213 90A8
                ST      A, off(0007eh)         ; 1AE9 1 080 213 D47E
                MOV     X1, #0337fh            ; 1AEB 1 080 213 607F33
                LB      A, 0a4h                ; 1AEE 0 080 213 F5A4
                VCAL    1                      ; 1AF0 0 080 213 11
                MOV     X1, A                  ; 1AF1 0 080 213 50
                CAL     label_2e69             ; 1AF2 0 080 213 32692E
                ; warning: had to flip DD
                ADD     A, X1                  ; 1AF5 1 080 213 9082
                VCAL    5                      ; 1AF7 1 080 213 15
                ST      A, off(0007ch)         ; 1AF8 1 080 213 D47C
                SJ      label_1b2c             ; 1AFA 1 080 213 CB30
                                               ; 1AFC from 1A89 (DD1,080,213)
label_1afc:     CAL     label_2e69             ; 1AFC 1 080 213 32692E
                LB      A, off(000f6h)         ; 1AFF 0 080 213 F4F6
                CMPB    A, #0cdh               ; 1B01 0 080 213 C6CD
                L       A, off(0007ch)         ; 1B03 1 080 213 E47C
                JGE     label_1b27             ; 1B05 1 080 213 CD20
                SUB     A, off(0007eh)         ; 1B07 1 080 213 A77E
                JLT     label_1b10             ; 1B09 1 080 213 CA05
                ST      A, off(0007ch)         ; 1B0B 1 080 213 D47C
                CMP     A, er3                 ; 1B0D 1 080 213 4B
                JGE     label_1b27             ; 1B0E 1 080 213 CD17
                                               ; 1B10 from 1B09 (DD1,080,213)
label_1b10:     RB      off(P2SF).1            ; 1B10 1 080 213 C42609
                SB      off(P2SF).0            ; 1B13 1 080 213 C42618
                L       A, er3                 ; 1B16 1 080 213 37
                SJ      label_1b27             ; 1B17 1 080 213 CB0E
                                               ; 1B19 from 1AA5 (DD1,080,213)
label_1b19:     CAL     label_2e69             ; 1B19 1 080 213 32692E
                SC                             ; 1B1C 1 080 213 85
                SJ      label_1b2d             ; 1B1D 1 080 213 CB0E
                                               ; 1B1F from 1A95 (DD0,080,213)
                                               ; 1B1F from 1AB5 (DD1,080,213)
label_1b1f:     RB      off(P2SF).0            ; 1B1F 0 080 213 C42608
                CAL     label_2e69             ; 1B22 0 080 213 32692E
                SJ      label_1b2c             ; 1B25 0 080 213 CB05
                                               ; 1B27 from 1B05 (DD1,080,213)
                                               ; 1B27 from 1B0E (DD1,080,213)
                                               ; 1B27 from 1B17 (DD1,080,213)
label_1b27:     ST      A, er3                 ; 1B27 1 080 213 8B
                CAL     label_2e91             ; 1B28 1 080 213 32912E
                ADD     A, er3                 ; 1B2B 1 080 213 0B
                                               ; 1B2C from 1AFA (DD1,080,213)
                                               ; 1B2C from 1B25 (DD0,080,213)
label_1b2c:     RC                             ; 1B2C 1 080 213 95
                                               ; 1B2D from 1B1D (DD1,080,213)
label_1b2d:     ST      A, off(PWMR1)          ; 1B2D 1 080 213 D476
                MB      off(P2SF).3, C         ; 1B2F 1 080 213 C4263B
                RB      off(P2SF).2            ; 1B32 1 080 213 C4260A
                ANDB    off(P2IO), #09fh       ; 1B35 1 080 213 C425D09F
                MB      C, 0f3h.5              ; 1B39 1 080 213 C5F32D
                MB      off(00027h).5, C       ; 1B3C 1 080 213 C4273D
                MB      C, off(P3SF).6         ; 1B3F 1 080 213 C42A2E
                MB      off(00027h).6, C       ; 1B42 1 080 213 C4273E
                MB      C, 0f3h.3              ; 1B45 1 080 213 C5F32B
                MB      off(P3).4, C           ; 1B48 1 080 213 C4283C
                J       label_1ca4             ; 1B4B 1 080 213 03A41C
                                               ; 1B4E from 1AB8 (DD1,080,213)
label_1b4e:     MB      C, off(P2IO).5         ; 1B4E 1 080 213 C4252D
                MB      off(P2IO).6, C         ; 1B51 1 080 213 C4253E
                RC                             ; 1B54 1 080 213 95
                JBS     off(P1IO).3, label_1b5b ; 1B55 1 080 213 EB2303
                MB      C, off(P2IO).3         ; 1B58 1 080 213 C4252B
                                               ; 1B5B from 1B55 (DD1,080,213)
label_1b5b:     MB      off(P2IO).5, C         ; 1B5B 1 080 213 C4253D
                RB      off(P2SF).3            ; 1B5E 1 080 213 C4260B
                RB      off(P2IO).7            ; 1B61 1 080 213 C4250F
                JBS     off(P2SF).0, label_1bb5 ; 1B64 1 080 213 E8264E
                JBR     off(P2SF).2, label_1bb5 ; 1B67 1 080 213 DA264B
                JBS     off(P2IO).3, label_1b79 ; 1B6A 1 080 213 EB250C
                L       A, off(PWCON0)         ; 1B6D 1 080 213 E478
                CAL     label_2e82             ; 1B6F 1 080 213 32822E
                ADD     A, #00400h             ; 1B72 1 080 213 860004
                CMP     A, off(00094h)         ; 1B75 1 080 213 C794
                JLT     label_1bb5             ; 1B77 1 080 213 CA3C
                                               ; 1B79 from 1B6A (DD1,080,213)
label_1b79:     JBR     off(P2IO).5, label_1b87 ; 1B79 1 080 213 DD250B
                JBS     off(P2IO).6, label_1b83 ; 1B7C 1 080 213 EE2504
                MOVB    off(000f7h), #008h     ; 1B7F 1 080 213 C4F79808
                                               ; 1B83 from 1B7C (DD1,080,213)
label_1b83:     LB      A, off(000f7h)         ; 1B83 0 080 213 F4F7
                JNE     label_1bb5             ; 1B85 0 080 213 CE2E
                                               ; 1B87 from 1B79 (DD1,080,213)
label_1b87:     JBS     off(P2SF).7, label_1bb5 ; 1B87 0 080 213 EF262B
                JBR     off(IRQ).7, label_1ba2 ; 1B8A 0 080 213 DF1815
                RB      off(00027h).5          ; 1B8D 0 080 213 C4270D
                MB      C, 0f3h.5              ; 1B90 0 080 213 C5F32D
                MB      off(00027h).5, C       ; 1B93 0 080 213 C4273D
                JEQ     label_1b9b             ; 1B96 0 080 213 C903
                XORB    PSWH, #080h            ; 1B98 0 080 213 A2F080
                                               ; 1B9B from 1B96 (DD0,080,213)
label_1b9b:     JGE     label_1ba2             ; 1B9B 0 080 213 CD05
                SB      off(P2IO).7            ; 1B9D 0 080 213 C4251F
                SJ      label_1bb5             ; 1BA0 0 080 213 CB13
                                               ; 1BA2 from 1B8A (DD0,080,213)
                                               ; 1BA2 from 1B9B (DD0,080,213)
label_1ba2:     JBS     off(P3).2, label_1bb5  ; 1BA2 0 080 213 EA2810
                RB      off(00027h).6          ; 1BA5 0 080 213 C4270E
                MB      C, off(P3SF).6         ; 1BA8 0 080 213 C42A2E
                MB      off(00027h).6, C       ; 1BAB 0 080 213 C4273E
                JEQ     label_1bb3             ; 1BAE 0 080 213 C903
                XORB    PSWH, #080h            ; 1BB0 0 080 213 A2F080
                                               ; 1BB3 from 1BAE (DD0,080,213)
label_1bb3:     JGE     label_1bcc             ; 1BB3 0 080 213 CD17
                                               ; 1BB5 from 1B64 (DD1,080,213)
                                               ; 1BB5 from 1B67 (DD1,080,213)
                                               ; 1BB5 from 1B77 (DD1,080,213)
                                               ; 1BB5 from 1B85 (DD0,080,213)
                                               ; 1BB5 from 1B87 (DD0,080,213)
                                               ; 1BB5 from 1BA0 (DD0,080,213)
                                               ; 1BB5 from 1BA2 (DD0,080,213)
label_1bb5:     SB      off(P2SF).2            ; 1BB5 1 080 213 C4261A
                L       A, off(PWMR1)          ; 1BB8 1 080 213 E476
                JBS     off(P2SF).0, label_1bc0 ; 1BBA 1 080 213 E82603
                CAL     label_2e69             ; 1BBD 1 080 213 32692E
                                               ; 1BC0 from 1BBA (DD1,080,213)
label_1bc0:     JBS     off(P2).1, label_1bca  ; 1BC0 1 080 213 E92407
                JBS     off(P2IO).7, label_1bca ; 1BC3 1 080 213 EF2504
                ADD     A, #00040h             ; 1BC6 1 080 213 864000
                VCAL    5                      ; 1BC9 1 080 213 15
                                               ; 1BCA from 1BC0 (DD1,080,213)
                                               ; 1BCA from 1BC3 (DD1,080,213)
label_1bca:     ST      A, off(00094h)         ; 1BCA 1 080 213 D494
                                               ; 1BCC from 1BB3 (DD0,080,213)
label_1bcc:     RB      off(P2SF).0            ; 1BCC 1 080 213 C42608
                MOV     X1, #0333bh            ; 1BCF 1 080 213 603B33
                JBR     off(P2IO).5, label_1c03 ; 1BD2 1 080 213 DD252E
                RB      off(P3).4              ; 1BD5 1 080 213 C4280C
                MB      C, 0f3h.3              ; 1BD8 1 080 213 C5F32B
                MB      off(P3).4, C           ; 1BDB 1 080 213 C4283C
                JEQ     label_1be3             ; 1BDE 1 080 213 C903
                XORB    PSWH, #080h            ; 1BE0 1 080 213 A2F080
                                               ; 1BE3 from 1BDE (DD1,080,213)
label_1be3:     JGE     label_1be9             ; 1BE3 1 080 213 CD04
                MOVB    off(000f8h), #00ah     ; 1BE5 1 080 213 C4F8980A
                                               ; 1BE9 from 1BE3 (DD1,080,213)
label_1be9:     LB      A, off(000f8h)         ; 1BE9 0 080 213 F4F8
                JEQ     label_1c0c             ; 1BEB 0 080 213 C91F
                JBS     off(P2SF).7, label_1c0c ; 1BED 0 080 213 EF261C
                MOV     X1, #03347h            ; 1BF0 0 080 213 604733
                CMP     0c2h, #00127h          ; 1BF3 0 080 213 B5C2C02701
                JLT     label_1c0c             ; 1BF8 0 080 213 CA12
                MOV     X1, #0334bh            ; 1BFA 0 080 213 604B33
                MOV     er0, #00800h           ; 1BFD 0 080 213 44980008
                SJ      label_1c10             ; 1C01 0 080 213 CB0D
                                               ; 1C03 from 1BD2 (DD1,080,213)
label_1c03:     MOV     X1, #0333fh            ; 1C03 1 080 213 603F33
                JBS     off(P2IO).2, label_1c0c ; 1C06 1 080 213 EA2503
                MOV     X1, #03343h            ; 1C09 1 080 213 604333
                                               ; 1C0C from 1BEB (DD0,080,213)
                                               ; 1C0C from 1BED (DD0,080,213)
                                               ; 1C0C from 1BF8 (DD0,080,213)
                                               ; 1C0C from 1C06 (DD1,080,213)
label_1c0c:     MOV     er0, #00100h           ; 1C0C 1 080 213 44980001
                                               ; 1C10 from 1C01 (DD0,080,213)
label_1c10:     L       A, 0c2h                ; 1C10 1 080 213 E5C2
                CMP     A, er0                 ; 1C12 1 080 213 48
                JGE     label_1c16             ; 1C13 1 080 213 CD01
                ST      A, er0                 ; 1C15 1 080 213 88
                                               ; 1C16 from 1C13 (DD1,080,213)
label_1c16:     LC      A, [X1]                ; 1C16 1 080 213 90A8
                MUL                            ; 1C18 1 080 213 9035
                LB      A, off(00096h)         ; 1C1A 0 080 213 F496
                JBS     off(P2IO).2, label_1c29 ; 1C1C 0 080 213 EA250A
                ADDB    A, ACCH                ; 1C1F 0 080 213 C50782
                STB     A, r5                  ; 1C22 0 080 213 8D
                L       A, er1                 ; 1C23 1 080 213 35
                ADC     A, off(00094h)         ; 1C24 1 080 213 9794
                VCAL    5                      ; 1C26 1 080 213 15
                SJ      label_1c33             ; 1C27 1 080 213 CB0A
                                               ; 1C29 from 1C1C (DD0,080,213)
label_1c29:     SUBB    A, ACCH                ; 1C29 0 080 213 C507A2
                STB     A, r5                  ; 1C2C 0 080 213 8D
                L       A, off(00094h)         ; 1C2D 1 080 213 E494
                SBC     A, er1                 ; 1C2F 1 080 213 39
                JGE     label_1c33             ; 1C30 1 080 213 CD01
                CLR     A                      ; 1C32 1 080 213 F9
                                               ; 1C33 from 1C27 (DD1,080,213)
                                               ; 1C33 from 1C30 (DD1,080,213)
label_1c33:     ST      A, er3                 ; 1C33 1 080 213 8B
                L       A, off(0008ch)         ; 1C34 1 080 213 E48C
                VCAL    4                      ; 1C36 1 080 213 14
                CAL     label_2ea7             ; 1C37 1 080 213 32A72E
                ST      A, er3                 ; 1C3A 1 080 213 8B
                LC      A, 00002h[X1]          ; 1C3B 1 080 213 90A90200
                J       label_1d5a             ; 1C3F 1 080 213 035A1D
                                               ; 1C42 from 1D62 (DD1,080,213)
label_1c42:     JBS     off(P2IO).2, label_1c49 ; 1C42 1 080 213 EA2504
                ADD     A, er1                 ; 1C45 1 080 213 09
                VCAL    5                      ; 1C46 1 080 213 15
                SJ      label_1c4d             ; 1C47 1 080 213 CB04
                                               ; 1C49 from 1C42 (DD1,080,213)
label_1c49:     SUB     A, er1                 ; 1C49 1 080 213 29
                JGE     label_1c4d             ; 1C4A 1 080 213 CD01
                CLR     A                      ; 1C4C 1 080 213 F9
                                               ; 1C4D from 1C47 (DD1,080,213)
                                               ; 1C4D from 1C4A (DD1,080,213)
label_1c4d:     CAL     label_2ea7             ; 1C4D 1 080 213 32A72E
                JLT     label_1c58             ; 1C50 1 080 213 CA06
                MOV     off(00094h), er3       ; 1C52 1 080 213 477C94
                MOVB    off(00096h), r5        ; 1C55 1 080 213 257C96
                                               ; 1C58 from 1C50 (DD1,080,213)
label_1c58:     ST      A, off(PWMR1)          ; 1C58 1 080 213 D476
                MOV     USP, #00266h           ; 1C5A 1 080 266 A1986602
                JBR     off(P2IO).5, label_1c98 ; 1C5E 1 080 266 DD2537
                JBS     off(P2).1, label_1c98  ; 1C61 1 080 266 E92434
                LB      A, off(TM0)            ; 1C64 0 080 266 F430
                ORB     A, off(TM0H)           ; 1C66 0 080 266 E731
                ORB     A, off(TMR0)           ; 1C68 0 080 266 E732
                JNE     label_1c98             ; 1C6A 0 080 266 CE2C
                JBS     off(P3).0, label_1c98  ; 1C6C 0 080 266 E82829
                LB      A, off(000f6h)         ; 1C6F 0 080 266 F4F6
                JNE     label_1c98             ; 1C71 0 080 266 CE25
                L       A, off(00088h)         ; 1C73 1 080 266 E488
                JNE     label_1c98             ; 1C75 1 080 266 CE21
                L       A, #08000h             ; 1C77 1 080 266 670080
                CAL     label_2e94             ; 1C7A 1 080 266 32942E
                ADD     A, off(PWCON0)         ; 1C7D 1 080 266 8778
                ST      A, er3                 ; 1C7F 1 080 266 8B
                L       A, #00001h       ;mugen -> #0000h      ; 1C80 1 080 266 670100
                JBR     off(P2).6, label_1c8c  ; 1C83 1 080 266 DE2406
                JBS     off(P2IO).1, label_1c8c ; 1C86 1 080 266 E92503
                L       A, #00050h       ;mugen -> #00000h      ; 1C89 1 080 266 675000
                                               ; 1C8C from 1C83 (DD1,080,266)
                                               ; 1C8C from 1C86 (DD1,080,266)
label_1c8c:     ST      A, er0                 ; 1C8C 1 080 266 88
                L       A, off(00094h)         ; 1C8D 1 080 266 E494
                SUB     A, er3                 ; 1C8F 1 080 266 2B
                JGT     label_1c95             ; 1C90 1 080 266 C803
                L       A, #00001h             ; 1C92 1 080 266 670100
                                               ; 1C95 from 1C90 (DD1,080,266)
label_1c95:     CAL     label_2d36             ; 1C95 1 080 266 32362D
                                               ; 1C98 from 1C5E (DD1,080,266)
                                               ; 1C98 from 1C61 (DD1,080,266)
                                               ; 1C98 from 1C6A (DD0,080,266)
                                               ; 1C98 from 1C6C (DD0,080,266)
                                               ; 1C98 from 1C71 (DD0,080,266)
                                               ; 1C98 from 1C75 (DD1,080,266)
label_1c98:     L       A, (00266h-00266h)[USP] ; 1C98 1 080 266 E300
                MOV     er1, #01000h           ; 1C9A 1 080 266 45980010
                CMP     A, er1                 ; 1C9E 1 080 266 49
                JLE     label_1ca4             ; 1C9F 1 080 266 CF03
                L       A, er1                 ; 1CA1 1 080 266 35
                ST      A, (00266h-00266h)[USP] ; 1CA2 1 080 266 D300
                                               ; 1CA4 from 1B4B (DD1,080,213)
                                               ; 1CA4 from 1C9F (DD1,080,266)
label_1ca4:     CAL     label_2e69             ; 1CA4 1 080 213 32692E
                JBR     off(P2SF).1, label_1cac ; 1CA7 1 080 213 D92602
                L       A, off(0007ch)         ; 1CAA 1 080 213 E47C
                                               ; 1CAC from 1CA7 (DD1,080,213)
label_1cac:     MOV     X2, A                  ; 1CAC 1 080 213 51
                MOV     DP, #0339ah            ; 1CAD 1 080 213 629A33
                MOV     X1, #033a4h            ; 1CB0 1 080 213 60A433
                JBR     off(P3SF).6, label_1cbc ; 1CB3 1 080 213 DE2A06
                MOV     DP, #033b3h            ; 1CB6 1 080 213 62B333
                MOV     X1, #033bdh            ; 1CB9 1 080 213 60BD33
                                               ; 1CBC from 1CB3 (DD1,080,213)
label_1cbc:     JBS     off(P2SF).7, label_1ced ; 1CBC 1 080 213 EF262E
                J       label_36b0             ; 1CBF 1 080 213 03B036
                                               ; 1CC2 from 36B6 (DD1,080,213)
label_1cc2:     LB      A, 0a4h                ; 1CC2 0 080 213 F5A4
                VCAL    1                      ; 1CC4 0 080 213 11
                STB     A, r0                  ; 1CC5 0 080 213 88
                CLR     A                      ; 1CC6 1 080 213 F9
                JBS     off(P2).6, label_1cd1  ; 1CC7 1 080 213 EE2407
                L       A, #00002h             ; 1CCA 1 080 213 670200
                JBS     off(P2).5, label_1cd1  ; 1CCD 1 080 213 ED2401
                SLL     A                      ; 1CD0 1 080 213 53
                                               ; 1CD1 from 1CC7 (DD1,080,213)
                                               ; 1CD1 from 1CCD (DD1,080,213)
label_1cd1:     ADD     A, DP                  ; 1CD1 1 080 213 9282
                ST      A, er1                 ; 1CD3 1 080 213 89
                L       A, 0bch                ; 1CD4 1 080 213 E5BC
                CMPC    A, [er1]               ; 1CD6 1 080 213 45AC
                JLT     label_1cff             ; 1CD8 1 080 213 CA25
                SB      off(P2SF).7            ; 1CDA 1 080 213 C4261F
                MUL                            ; 1CDD 1 080 213 9035
                ST      A, er0                 ; 1CDF 1 080 213 88
                LC      A, 00006h[DP]          ; 1CE0 1 080 213 92A90600
                CMP     A, er0                 ; 1CE4 1 080 213 48
                JLT     label_1ce8             ; 1CE5 1 080 213 CA01
                L       A, er0                 ; 1CE7 1 080 213 34
                                               ; 1CE8 from 1CE5 (DD1,080,213)
label_1ce8:     ADD     A, X2                  ; 1CE8 1 080 213 9182
                VCAL    5                      ; 1CEA 1 080 213 15
                SJ      label_1cfb             ; 1CEB 1 080 213 CB0E
                                               ; 1CED from 1CBC (DD1,080,213)
label_1ced:     LC      A, 00008h[DP]          ; 1CED 1 080 213 92A90800
                ST      A, er0                 ; 1CF1 1 080 213 88
                L       A, off(00080h)         ; 1CF2 1 080 213 E480
                SUB     A, er0                 ; 1CF4 1 080 213 28
                JLT     label_1cff             ; 1CF5 1 080 213 CA08
                CMP     A, X2                  ; 1CF7 1 080 213 91C2
                JLT     label_1cff             ; 1CF9 1 080 213 CA04
                                               ; 1CFB from 1CEB (DD1,080,213)
label_1cfb:     ST      A, off(PWMR1)          ; 1CFB 1 080 213 D476
                SJ      label_1d03             ; 1CFD 1 080 213 CB04
                                               ; 1CFF from 1CF5 (DD1,080,213)
                                               ; 1CFF from 1CF9 (DD1,080,213)
                                               ; 1CFF from 36B9 (DD1,080,213)
                                               ; 1CFF from 1CD8 (DD1,080,213)
label_1cff:     RB      off(P2SF).7            ; 1CFF 1 080 213 C4260F
                CLR     A                      ; 1D02 1 080 213 F9
                                               ; 1D03 from 1CFD (DD1,080,213)
label_1d03:     ST      A, off(00080h)         ; 1D03 1 080 213 D480
                J       label_1d92             ; 1D05 1 080 213 03921D
                                               ; 1D08 from 0EFC (DD0,108,13C)
label_1d08:     JBR     off(0011fh).5, label_1d11 ; 1D08 0 108 13C DD1F06
                JBS     off(00123h).3, label_1d11 ; 1D0B 0 108 13C EB2303
                J       label_0eff             ; 1D0E 0 108 13C 03FF0E
                                               ; 1D11 from 1D08 (DD0,108,13C)
                                               ; 1D11 from 1D0B (DD0,108,13C)
label_1d11:     J       label_0f08             ; 1D11 0 108 13C 03080F
                                               ; 1D14 from 1847 (DD0,080,213)
label_1d14:     LB      A, #00dh               ; 1D14 0 080 213 770D
                STB     A, off(000aeh)         ; 1D16 0 080 213 D4AE
                STB     A, off(000afh)         ; 1D18 0 080 213 D4AF
                MOV     DP, #001bch            ; 1D1A 0 080 213 62BC01
                J       label_184a             ; 1D1D 0 080 213 034A18
                                               ; 1D20 from 1E9E (DD1,080,213)
label_1d20:     MOV     DP, #00004h            ; 1D20 1 080 213 620400
                MOV     USP, #001ach           ; 1D23 1 080 1AC A198AC01
                CAL     label_2d78             ; 1D27 1 080 1AC 32782D
                MOV     DP, #00008h            ; 1D2A 1 080 1AC 620800
                J       label_1ea1             ; 1D2D 1 080 1AC 03A11E
                                               ; 1D30 from 2E30 (DD0,080,0A4)
label_1d30:     L       A, #0002ch             ; 1D30 1 080 0A4 672C00
                ADD     A, USP                 ; 1D33 1 080 0A4 A182
                MOV     X1, A                  ; 1D35 1 080 0A4 50
                MOVB    r0, #00ah              ; 1D36 1 080 0A4 980A
                MB      C, 0f2h.6              ; 1D38 1 080 0A4 C5F22E
                J       label_2e33             ; 1D3B 1 080 0A4 03332E
                                               ; 1D3E from 2E35 (DD1,080,0A4)
label_1d3e:     INC     X1                     ; 1D3E 1 080 0A4 70
                INC     X1                     ; 1D3F 1 080 0A4 70
                MOVB    r0, #00dh              ; 1D40 1 080 0A4 980D
                JBR     off(0001fh).5, label_1d48 ; 1D42 1 080 0A4 DD1F03
                J       label_2e38             ; 1D45 1 080 0A4 03382E
                                               ; 1D48 from 1D42 (DD1,080,0A4)
label_1d48:     MOVB    (000d0h-000a4h)[USP], #00ah ; 1D48 1 080 0A4 C32C980A
                J       label_2e4d             ; 1D4C 1 080 0A4 034D2E
                                               ; 1D4F from 2E51 (DD0,080,0A4)
label_1d4f:     LB      A, 00000h[X1]          ; 1D4F 0 080 0A4 F00000
                JNE     label_1d57             ; 1D52 0 080 0A4 CE03
                J       label_2e55             ; 1D54 0 080 0A4 03552E
                                               ; 1D57 from 1D52 (DD0,080,0A4)
label_1d57:     J       label_2e59             ; 1D57 0 080 0A4 03592E
                                               ; 1D5A from 1C3F (DD1,080,213)
label_1d5a:     MUL                            ; 1D5A 1 080 213 9035
                LB      A, r2                  ; 1D5C 0 080 213 7A
                L       A, ACC                 ; 1D5D 1 080 213 E506
                SWAP                           ; 1D5F 1 080 213 83
                ST      A, er1                 ; 1D60 1 080 213 89
                L       A, er3                 ; 1D61 1 080 213 37
                J       label_1c42             ; 1D62 1 080 213 03421C
                                               ; 1D65 from 1265 (DD1,108,13C)
label_1d65:     ST      A, off(0014ah)         ; 1D65 1 108 13C D44A
                JEQ     label_1d6e             ; 1D67 1 108 13C C905
                SB      r7.0                   ; 1D69 1 108 13C 2718
                J       label_1269             ; 1D6B 1 108 13C 036912
                                               ; 1D6E from 1D67 (DD1,108,13C)
label_1d6e:     J       label_12cd             ; 1D6E 1 108 13C 03CD12
                                               ; 1D71 from 087C (DD0,108,3153)
label_1d71:     SRLB    A                      ; 1D71 0 108 3153 63
                JGE     label_1d80             ; 1D72 0 108 3153 CD0C
                CMPB    0a4h, #042h      ;mugen -> #000h      ; 1D74 0 108 3153 C5A4C042
                J       label_41f2             ; 1D78 0 108 3153 03F241
                                               ; 1D7B from 41F8 (DD0,108,3153)
label_1d7b:     JGE     label_1d80             ; 1D7B 0 108 3153 CD03
                J       label_0880             ; 1D7D 0 108 3153 038008
                                               ; 1D80 from 1D72 (DD0,108,3153)
                                               ; 1D80 from 1D7B (DD0,108,3153)
label_1d80:     J       label_0891             ; 1D80 0 108 3153 039108
                                               ; 1D83 from 23F4 (DD0,080,205)
label_1d83:     CMPB    0a4h, #042h      ;mugen -> #000h      ; 1D83 0 080 205 C5A4C042
                JGE     label_1d8e             ; 1D87 0 080 205 CD05
                CMPB    A, #001h               ; 1D89 0 080 205 C601
                J       label_23f7             ; 1D8B 0 080 205 03F723
                                               ; 1D8E from 1D87 (DD0,080,205)
label_1d8e:     J       label_23fe             ; 1D8E 0 080 205 03FE23
                DB  082h ; 1D91
                                               ; 1D92 from 1D05 (DD1,080,213)
label_1d92:     J       label_362e             ; 1D92 1 080 213 032E36
                                               ; 1D95 from 3645 (DD0,080,213)
label_1d95:     JBR     off(IRQ).7, label_1d9b ; 1D95 0 080 213 DF1803
                MOV     X1, #03367h            ; 1D98 0 080 213 606733
                                               ; 1D9B from 1D95 (DD0,080,213)
label_1d9b:     NOP                            ; 1D9B 0 080 213 00
                NOP                            ; 1D9C 0 080 213 00
                MOVB    r0, #080h              ; 1D9D 0 080 213 9880
                CMPB    A, r0                  ; 1D9F 0 080 213 48
                JGE     label_1da4             ; 1DA0 0 080 213 CD02
                XCHGB   A, r0                  ; 1DA2 0 080 213 2010
                                               ; 1DA4 from 1DA0 (DD0,080,213)
label_1da4:     SUBB    A, r0                  ; 1DA4 0 080 213 28
                VCAL    7                      ; 1DA5 0 080 213 17
                                               ; 1DA6 from 364A (DD0,080,213)
label_1da6:     L       A, off(00084h)         ; 1DA6 1 080 213 E484
                MB      C, PSWL.5              ; 1DA8 1 080 213 A32D
                NOP                            ; 1DAA 1 080 213 00
                JGE     label_1db2             ; 1DAB 1 080 213 CD05
                SUB     A, er3                 ; 1DAD 1 080 213 2B
                JGE     label_1db8             ; 1DAE 1 080 213 CD08
                SJ      label_1dcf             ; 1DB0 1 080 213 CB1D
                                               ; 1DB2 from 1DAB (DD1,080,213)
label_1db2:     ADD     A, er3                 ; 1DB2 1 080 213 0B
                JLT     label_1dd5             ; 1DB3 1 080 213 CA20
                VCAL    5                      ; 1DB5 1 080 213 15
                JGE     label_1dd5             ; 1DB6 1 080 213 CD1D
                                               ; 1DB8 from 1DAE (DD1,080,213)
label_1db8:     MOV     X2, #00080h            ; 1DB8 1 080 213 618000
                CMP     A, #00800h             ; 1DBB 1 080 213 C60008
                JGE     label_1dcb             ; 1DBE 1 080 213 CD0B
                MOV     X2, #00040h            ; 1DC0 1 080 213 614000
                CMP     A, #00400h             ; 1DC3 1 080 213 C60004
                JGE     label_1dcb             ; 1DC6 1 080 213 CD03
                MOV     X2, #0001eh            ; 1DC8 1 080 213 611E00
                                               ; 1DCB from 1DBE (DD1,080,213)
                                               ; 1DCB from 1DC6 (DD1,080,213)
label_1dcb:     SUB     A, X2                  ; 1DCB 1 080 213 91A2
                JGE     label_1dd0             ; 1DCD 1 080 213 CD01
                                               ; 1DCF from 1DB0 (DD1,080,213)
label_1dcf:     CLR     A                      ; 1DCF 1 080 213 F9
                                               ; 1DD0 from 1DCD (DD1,080,213)
label_1dd0:     CMP     A, USP                 ; 1DD0 1 080 213 A1C2
                NOP                            ; 1DD2 1 080 213 00
                JLT     label_1dd8             ; 1DD3 1 080 213 CA03
                                               ; 1DD5 from 1DB3 (DD1,080,213)
                                               ; 1DD5 from 1DB6 (DD1,080,213)
label_1dd5:     MOV     A, USP                 ; 1DD5 1 080 213 A199
                NOP                            ; 1DD7 1 080 213 00
                                               ; 1DD8 from 1DD3 (DD1,080,213)
label_1dd8:     ST      A, off(00084h)         ; 1DD8 1 080 213 D484
                L       A, off(PWMR1)          ; 1DDA 1 080 213 E476
                JBR     off(IRQ).7, label_1de7 ; 1DDC 1 080 213 DF1808
                MB      C, 0f3h.5              ; 1DDF 1 080 213 C5F32D
                JLT     label_1de7             ; 1DE2 1 080 213 CA03
                ADD     A, #00400h             ; 1DE4 1 080 213 860004
                                               ; 1DE7 from 1DDC (DD1,080,213)
                                               ; 1DE7 from 1DE2 (DD1,080,213)
label_1de7:     NOP                            ; 1DE7 1 080 213 00
                NOP                            ; 1DE8 1 080 213 00
                ADD     A, off(00084h)         ; 1DE9 1 080 213 8784
                ST      A, er3                 ; 1DEB 1 080 213 8B
                L       A, off(00086h)         ; 1DEC 1 080 213 E486
                VCAL    4                      ; 1DEE 1 080 213 14
                L       A, off(00088h)         ; 1DEF 1 080 213 E488
                JBR     off(P2SF).3, label_1dfd ; 1DF1 1 080 213 DB2609
                JBS     off(00089h).7, label_1dfb ; 1DF4 1 080 213 EF8904
                CMP     A, off(PWCON1)         ; 1DF7 1 080 213 C77A
                JGE     label_1dfd             ; 1DF9 1 080 213 CD02
                                               ; 1DFB from 1DF4 (DD1,080,213)
label_1dfb:     L       A, off(PWCON1)         ; 1DFB 1 080 213 E47A
                                               ; 1DFD from 1DF1 (DD1,080,213)
                                               ; 1DFD from 1DF9 (DD1,080,213)
label_1dfd:     VCAL    4                      ; 1DFD 1 080 213 14
                VCAL    6                      ; 1DFE 1 080 213 16
                ST      A, off(00092h)         ; 1DFF 1 080 213 D492
                MOV     X1, #033cch            ; 1E01 1 080 213 60CC33
                CAL     label_2c4b             ; 1E04 1 080 213 324B2C
                                               ; 1E07 from 1AC1 (DD1,080,213)
label_1e07:     ST      A, off(PWMC0)          ; 1E07 1 080 213 D470
                RT                             ; 1E09 1 080 213 01

;cel code blinkage
                                               ; 1E0A from 18AF (DD1,080,213)
label_1e0a:     MOV     DP, #0002ah            ; 1E0A 1 080 213 622A00
                MOV     USP, #001d5h           ; 1E0D 1 080 1D5 A198D501
                CAL     label_2d78             ; 1E11 1 080 1D5 32782D
                LB      A, off(000abh)         ; 1E14 0 080 1D5 F4AB
                INCB    ACC                    ; 1E16 0 080 1D5 C50616
                JEQ     label_1e1d             ; 1E19 0 080 1D5 C902
                STB     A, off(000abh)         ; 1E1B 0 080 1D5 D4AB
                                               ; 1E1D from 1E19 (DD0,080,1D5)
label_1e1d:     LB      A, off(0009eh)         ; 1E1D 0 080 1D5 F49E
                JEQ     label_1e35             ; 1E1F 0 080 1D5 C914
                CMPB    off(000e6h), #000h     ; 1E21 0 080 1D5 C4E6C000
                JNE     label_1e88             ; 1E25 0 080 1D5 CE61
                MOVB    r2, #010h              ; 1E27 0 080 1D5 9A10
                CMPB    A, r2                  ; 1E29 0 080 1D5 4A
                JGE     label_1e2e             ; 1E2A 0 080 1D5 CD02
                MOVB    r2, #001h              ; 1E2C 0 080 1D5 9A01
                                               ; 1E2E from 1E2A (DD0,080,1D5)
label_1e2e:     SUBB    A, r2                  ; 1E2E 0 080 1D5 2A
                MOV     er1, #01106h           ; 1E2F 0 080 1D5 45980611
                JNE     label_1e7d             ; 1E33 0 080 1D5 CE48
                                               ; 1E35 from 1E1F (DD0,080,1D5)
label_1e35:     SC                             ; 1E35 0 080 1D5 85
                JBS     off(TMR0).2, label_1e9a ; 1E36 0 080 1D5 EA3261
                CLR     A                      ; 1E39 1 080 1D5 F9
                ST      A, er0                 ; 1E3A 1 080 1D5 88
                                               ; 1E3B from 1E61 (DD0,080,1D5)
label_1e3b:     INCB    off(000a9h)            ; 1E3B 1 080 1D5 C4A916
                LB      A, off(000a9h)         ; 1E3E 0 080 1D5 F4A9
                CMPB    A, #019h               ; 1E40 0 080 1D5 C619
                JLT     label_1e4d             ; 1E42 0 080 1D5 CA09
                CLRB    off(000a9h)            ; 1E44 0 080 1D5 C4A915
                LB      A, 0f0h                ; 1E47 0 080 1D5 F5F0

                ;JEQ     label_1e9a ;mugen
                ;SJ      label_1e73 ;mugen

                SJ      label_1e9a     ;mugen ->  JEQ     label_1e9a     feels did this too!!!
                DW  026cbh             ;mugen ->  SJ      label_1e73; 1E4B
                                               ; 1E4D from 1E42 (DD0,080,1D5)
label_1e4d:     STB     A, r7                  ; 1E4D 0 080 1D5 8F
                DECB    r7                     ; 1E4E 0 080 1D5 BF
                MOV     DP, #0027dh            ; 1E4F 0 080 1D5 627D02
                JBS     off(ACCH).4, label_1e5a ; 1E52 0 080 1D5 EC0705
                DEC     DP                     ; 1E55 0 080 1D5 82
                JBS     off(ACCH).3, label_1e5a ; 1E56 0 080 1D5 EB0701
                DEC     DP                     ; 1E59 0 080 1D5 82
                                               ; 1E5A from 1E52 (DD0,080,1D5)
                                               ; 1E5A from 1E56 (DD0,080,1D5)
label_1e5a:     XCHGB   A, r7                  ; 1E5A 0 080 1D5 2710
                TRB     [DP]                   ; 1E5C 0 080 1D5 C213
                JNE     label_1e66             ; 1E5E 0 080 1D5 CE06
                INCB    r0                     ; 1E60 0 080 1D5 A8
                JBR     off(ASSP).3, label_1e3b ; 1E61 0 080 1D5 DB00D7
                SJ      label_1e9d             ; 1E64 0 080 1D5 CB37
                                               ; 1E66 from 1E5E (DD0,080,1D5)
label_1e66:     LB      A, r7                  ; 1E66 0 080 1D5 7F
                CMPB    A, #016h               ; 1E67 0 080 1D5 C616
                JLE     label_1e6d             ; 1E69 0 080 1D5 CF02
                SUBB    A, #016h               ; 1E6B 0 080 1D5 A616
                                               ; 1E6D from 1E69 (DD0,080,1D5)
label_1e6d:     CMPB    A, #012h               ; 1E6D 0 080 1D5 C612
                JNE     label_1e73             ; 1E6F 0 080 1D5 CE02
                LB      A, #017h               ; 1E71 0 080 1D5 7717
                                               ; 1E73 from 1E6F (DD0,080,1D5)
label_1e73:     MOVB    r0, #00ah              ; 1E73 0 080 1D5 980A
                DIVB                           ; 1E75 0 080 1D5 A236
                SWAPB                          ; 1E77 0 080 1D5 83
                ORB     A, r1                  ; 1E78 0 080 1D5 69
                MOV     er1, #02a1fh           ; 1E79 0 080 1D5 45981F2A
                                               ; 1E7D from 1E33 (DD0,080,1D5)
label_1e7d:     STB     A, off(0009eh)         ; 1E7D 0 080 1D5 D49E
                CMPB    A, #010h               ; 1E7F 0 080 1D5 C610
                JLT     label_1e85             ; 1E81 0 080 1D5 CA02
                MOVB    r2, r3                 ; 1E83 0 080 1D5 234A
                                               ; 1E85 from 1E81 (DD0,080,1D5)
label_1e85:     MOVB    off(000e6h), r2        ; 1E85 0 080 1D5 227CE6
                                               ; 1E88 from 1E25 (DD0,080,1D5)
label_1e88:     CMPB    A, #010h               ; 1E88 0 080 1D5 C610
                L       A, #00305h             ; 1E8A 1 080 1D5 670503
                JLT     label_1e92             ; 1E8D 1 080 1D5 CA03
                L       A, #00411h             ; 1E8F 1 080 1D5 671104
                                               ; 1E92 from 1E8D (DD1,080,1D5)
label_1e92:     ST      A, er1                 ; 1E92 1 080 1D5 89
                LB      A, off(000e6h)         ; 1E93 0 080 1D5 F4E6
                CMPB    A, r2                  ; 1E95 0 080 1D5 4A
                JGE     label_1e9a             ; 1E96 0 080 1D5 CD02
                CMPB    r3, A                  ; 1E98 0 080 1D5 23C1
                                               ; 1E9A from 1E36 (DD0,080,1D5)
                                               ; 1E9A from 1E49 (DD0,080,1D5)
                                               ; 1E9A from 1E96 (DD0,080,1D5)
label_1e9a:     MB      P1.2, C                ; 1E9A 0 080 1D5 C5223A
                                               ; 1E9D from 1E64 (DD0,080,1D5)
label_1e9d:     RT                             ; 1E9D 0 080 1D5 01
                                               ; 1E9E from 18B7 (DD1,080,213)
label_1e9e:     J       label_1d20             ; 1E9E 1 080 213 03201D
                                               ; 1EA1 from 1D2D (DD1,080,1AC)
label_1ea1:     MOV     USP, #001cdh           ; 1EA1 1 080 1CD A198CD01
                J       label_3687             ; 1EA5 1 080 1CD 038736
                                               ; 1EA8 from 3693 (DD0,080,1CD)
label_1ea8:     LB      A, off(000d2h)         ; 1EA8 0 080 1CD F4D2
                JNE     label_1ec5             ; 1EAA 0 080 1CD CE19
                MOVB    off(000d2h), #005h     ; 1EAC 0 080 1CD C4D29805
                CLR     er3                    ; 1EB0 0 080 1CD 4715
                MOV     DP, #000eah            ; 1EB2 0 080 1CD 62EA00
                MOV     X1, #034dah            ; 1EB5 0 080 1CD 60DA34
                CAL     label_2edf             ; 1EB8 0 080 1CD 32DF2E
                MOV     er3, #00115h           ; 1EBB 0 080 1CD 47981501
                MOV     DP, #001c2h            ; 1EBF 0 080 1CD 62C201
                CAL     label_2edf             ; 1EC2 0 080 1CD 32DF2E
                                               ; 1EC5 from 1EAA (DD0,080,1CD)
label_1ec5:     RT                             ; 1EC5 0 080 1CD 01
                                               ; 1EC6 from 279F (DD1,080,132)
                                               ; 1EC6 from 2894 (DD1,080,132)

                ;datalogging change
label_1ec6:     CMP     SSP, #0025ah           ; from 260h to 25ah

                JNE     label_1ef7             ; 1ECA 1 080 132 CE2B
                MOV     DP, #00222h            ; 1ECC 1 080 132 622202
                LB      A, [DP]                ; 1ECF 0 080 132 F2
                JNE     label_1ef7             ; 1ED0 0 080 132 CE25
                L       A, #022fbh             ; 1ED2 1 080 132 67FB22
                MOV     X1, #00090h            ; 1ED5 1 080 132 609000
                JBR     off(P0IO).2, label_1ee1 ; 1ED8 1 080 132 DA2106
                L       A, #0a25bh             ; 1EDB 1 080 132 675BA2
                MOV     X1, #00010h            ; 1EDE 1 080 132 601000
                                               ; 1EE1 from 1ED8 (DD1,080,132)
label_1ee1:     CMP     A, 0cch                ; 1EE1 1 080 132 B5CCC2
                JNE     label_1ef7             ; 1EE4 1 080 132 CE11
                CMP     A, IE                  ; 1EE6 1 080 132 B51AC2
                JNE     label_1ef7             ; 1EE9 1 080 132 CE0C
                L       A, X1                  ; 1EEB 1 080 132 40
                CMP     A, 0ceh                ; 1EEC 1 080 132 B5CEC2
                JNE     label_1ef7             ; 1EEF 1 080 132 CE06
                CMP     LRB, #00020h           ; 1EF1 1 080 132 A4C02000
                JEQ     label_1f04             ; 1EF5 1 080 132 C90D
                                               ; 1EF7 from 1ECA (DD1,080,132)
                                               ; 1EF7 from 1ED0 (DD0,080,132)
                                               ; 1EF7 from 1EE4 (DD1,080,132)
                                               ; 1EF7 from 1EE9 (DD1,080,132)
                                               ; 1EF7 from 1EEF (DD1,080,132)
label_1ef7:     MOVB    0f0h, #041h            ; 1EF7 1 080 132 C5F09841
                DECB    0eah                   ; 1EFB 1 080 132 C5EA17
                JNE     label_1f03             ; 1EFE 1 080 132 CE03
                SB      0f1h.0                 ; 1F00 1 080 132 C5F118
                                               ; 1F03 from 1EFE (DD1,080,132)
label_1f03:     BRK                            ; 1F03 1 080 132 FF
                                               ; 1F04 from 1EF5 (DD1,080,132)
label_1f04:     VCAL    3                      ; 1F04 1 080 132 13
                MB      C, 0a6h.7              ; 1F05 1 080 132 C5A62F

                ;from debug2, they short jumped here...
                JLT     label_1f3d             ; 1F08 1 080 132 CA33; SJ??

                MOV     er0, 0f4h              ; 1F0A 1 080 132 B5F448
                J       label_4000             ; 1F0D 1 080 132 030040
                                               ; 1F10 from 4005 (DD0,080,132)
label_1f10:     MOV     X1, A                  ; 1F10 0 080 132 50
                MOV     DP, #00020h            ; 1F11 0 080 132 622000
                MOVB    r0, 0eeh               ; 1F14 0 080 132 C5EE48
                                               ; 1F17 from 1F20 (DD0,080,132)
label_1f17:     LC      A, [X1]                ; 1F17 0 080 132 90A8
                ADDB    A, ACCH                ; 1F19 0 080 132 C50782
                ADDB    r0, A                  ; 1F1C 0 080 132 2081
                INC     X1                     ; 1F1E 0 080 132 70
                INC     X1                     ; 1F1F 0 080 132 70
                JRNZ    DP, label_1f17         ; 1F20 0 080 132 30F5
                LB      A, r0                  ; 1F22 0 080 132 78
                STB     A, 0eeh                ; 1F23 0 080 132 D5EE
                J       label_4008             ; 1F25 0 080 132 030840
                DW  013ceh           ; 1F28
                                               ; 1F2A from 4012 (DD0,080,132)
label_1f2a:     J       label_4015             ; 1F2A 0 080 132 031540
                                               ; 1F2D from 401B (DD0,080,132)
label_1f2d:     CLRB    0eeh                   ; 1F2D 0 080 132 C5EE15
                MOVB    0f0h, #048h            ; 1F30 0 080 132 C5F09848
                DECB    0ebh                   ; 1F34 0 080 132 C5EB17
                JNE     label_1f3d             ; 1F37 0 080 132 CE04
                SB      0f1h.1                 ; 1F39 0 080 132 C5F119
                BRK                            ; 1F3C 0 080 132 FF
                                               ; 1F3D from 1F08 (DD1,080,132)
                                               ; 1F3D from 401E (DD0,080,132)
                                               ; 1F3D from 1F37 (DD0,080,132)
label_1f3d:     VCAL    3                      ; 1F3D 1 080 132 13
                CLR     A                      ; 1F3E 1 080 132 F9
                LB      A, 0efh                ; 1F3F 0 080 132 F5EF
                MOV     X1, A                  ; 1F41 0 080 132 50
                SLL     X1                     ; 1F42 0 080 132 90D7
                L       A, #05555h             ; 1F44 1 080 132 675555
                CAL     label_2f0b             ; 1F47 1 080 132 320B2F
                JNE     label_1f5c             ; 1F4A 1 080 132 CE10
                SLL     A                      ; 1F4C 1 080 132 53
                CAL     label_2f0b             ; 1F4D 1 080 132 320B2F
                JNE     label_1f5c             ; 1F50 1 080 132 CE0A
                LB      A, 0efh                ; 1F52 0 080 132 F5EF
                JNE     label_1f58             ; 1F54 0 080 132 CE02
                LB      A, #0f2h               ; 1F56 0 080 132 77F2
                                               ; 1F58 from 1F54 (DD0,080,132)
label_1f58:     SUBB    A, #001h               ; 1F58 0 080 132 A601
                STB     A, 0efh                ; 1F5A 0 080 132 D5EF
                                               ; 1F5C from 1F4A (DD1,080,132)
                                               ; 1F5C from 1F50 (DD1,080,132)
label_1f5c:     AND     IE, #00080h            ; 1F5C 0 080 132 B51AD08000
                RB      PSWH.0                 ; 1F61 0 080 132 A208
                JBS     off(TM0).3, label_1fb0 ; 1F63 0 080 132 EB304A
                JBS     off(P0IO).2, label_1f74 ; 1F66 0 080 132 EA210B
                RB      IRQH.7                 ; 1F69 0 080 132 C5190F
                JEQ     label_1f74             ; 1F6C 0 080 132 C906
                SB      off(IRQ).0             ; 1F6E 0 080 132 C41818
                SB      off(P4SF).0            ; 1F71 0 080 132 C42E18
                                               ; 1F74 from 1F66 (DD0,080,132)
                                               ; 1F74 from 1F6C (DD0,080,132)
label_1f74:     SB      PSWH.0                 ; 1F74 0 080 132 A218
                CMPB    off(000beh), #029h     ; 1F76 0 080 132 C4BEC029
                RB      PSWH.0                 ; 1F7A 0 080 132 A208
                JLT     label_1fb0             ; 1F7C 0 080 132 CA32
                JBR     off(P0IO).2, label_1fc9 ; 1F7E 0 080 132 DA2148
                L       A, #022fbh             ; 1F81 1 080 132 67FB22
                ST      A, IE                  ; 1F84 1 080 132 D51A
                ST      A, 0cch                ; 1F86 1 080 132 D5CC
                MOV     0ceh, #00090h          ; 1F88 1 080 132 B5CE989000
                RB      off(P0IO).2            ; 1F8D 1 080 132 C4210A
                MOVB    TCON1, #08eh           ; 1F90 1 080 132 C541988E
                MOV     TM1, #00001h           ; 1F94 1 080 132 B534980100
                MOVB    TCON2, #08fh           ; 1F99 1 080 132 C542988F
                MOV     TM2, #00002h           ; 1F9D 1 080 132 B538980200
                SC                             ; 1FA2 1 080 132 85
                MB      TCON1.4, C             ; 1FA3 1 080 132 C5413C
                L       A, ACC                 ; 1FA6 1 080 132 E506
                MB      TCON2.4, C             ; 1FA8 1 080 132 C5423C
                CAL     label_2f33             ; 1FAB 1 080 132 32332F
                SJ      label_1fc9             ; 1FAE 1 080 132 CB19
                                               ; 1FB0 from 1F63 (DD0,080,132)
                                               ; 1FB0 from 1F7C (DD0,080,132)
label_1fb0:     JBS     off(P0IO).2, label_1fc9 ; 1FB0 0 080 132 EA2116
                L       A, #0a25bh             ; 1FB3 1 080 132 675BA2
                ST      A, IE                  ; 1FB6 1 080 132 D51A
                ST      A, 0cch                ; 1FB8 1 080 132 D5CC
                MOV     0ceh, #00010h          ; 1FBA 1 080 132 B5CE981000
                SB      off(P0IO).2            ; 1FBF 1 080 132 C4211A
                MOVB    TCON1, #0beh           ; 1FC2 1 080 132 C54198BE
                RB      TCON2.2                ; 1FC6 1 080 132 C5420A
                                               ; 1FC9 from 1F7E (DD0,080,132)
                                               ; 1FC9 from 1FAE (DD1,080,132)
                                               ; 1FC9 from 1FB0 (DD0,080,132)
label_1fc9:     SB      PSWH.0                 ; 1FC9 1 080 132 A218
                L       A, 0cch                ; 1FCB 1 080 132 E5CC
                ST      A, IE                  ; 1FCD 1 080 132 D51A
                                               ; 1FCF from 3361 (DD0,080,213)
label_1fcf:     AND     IE, #00080h            ; 1FCF 0 080 213 B51AD08000
                RB      PSWH.0                 ; 1FD4 0 080 213 A208
                MOV     er0, TM0               ; 1FD6 0 080 213 B53048
                MOV     er1, TM1               ; 1FD9 0 080 213 B53449
                MOV     er2, TM2               ; 1FDC 0 080 213 B5384A
                MOV     er3, TM3               ; 1FDF 0 080 213 B53C4B
                SB      PSWH.0                 ; 1FE2 0 080 213 A218
                NOP                            ; 1FE4 0 080 213 00
                RB      PSWH.0                 ; 1FE5 0 080 213 A208
                MOV     X1, TM0                ; 1FE7 0 080 213 B53078
                MOV     X2, TM1                ; 1FEA 0 080 213 B53479
                MOV     DP, TM2                ; 1FED 0 080 213 B5387A
                MOV     USP, TM3               ; 1FF0 0 080 213 B53C7B
                MB      C, TCON0.4             ; 1FF3 0 080 213 C5402C
                SB      PSWH.0                 ; 1FF6 0 080 213 A218
                L       A, 0cch                ; 1FF8 1 080 213 E5CC
                ST      A, IE                  ; 1FFA 1 080 213 D51A
                MB      PSWL.4, C              ; 1FFC 1 080 213 A33C
                L       A, X1                  ; 1FFE 1 080 213 40
                SUB     A, er0                 ; 1FFF 1 080 213 28
                ST      A, er0                 ; 2000 1 080 213 88
                JNE     label_2007             ; 2001 1 080 213 CE04
                MB      C, PSWL.4              ; 2003 1 080 213 A32C
                JLT     label_2047             ; 2005 1 080 213 CA40
                                               ; 2007 from 2001 (DD1,080,213)
label_2007:     CMP     A, #00012h             ; 2007 1 080 213 C61200
                JGE     label_2047             ; 200A 1 080 213 CD3B
                L       A, X2                  ; 200C 1 080 213 41
                SUB     A, er1                 ; 200D 1 080 213 29
                ST      A, er1                 ; 200E 1 080 213 89
                JBS     off(P0IO).2, label_2014 ; 200F 1 080 213 EA2102
                JEQ     label_2047             ; 2012 1 080 213 C933
                                               ; 2014 from 200F (DD1,080,213)
label_2014:     CMP     A, #00012h             ; 2014 1 080 213 C61200
                JGE     label_2047             ; 2017 1 080 213 CD2E
                L       A, DP                  ; 2019 1 080 213 42
                SUB     A, er2                 ; 201A 1 080 213 2A
                ST      A, er2                 ; 201B 1 080 213 8A
                JEQ     label_2047             ; 201C 1 080 213 C929
                CMP     A, #00012h             ; 201E 1 080 213 C61200
                JGE     label_2047             ; 2021 1 080 213 CD24
                JBS     off(P0IO).2, label_2037 ; 2023 1 080 213 EA2111
                L       A, DP                  ; 2026 1 080 213 42
                SUB     A, X2                  ; 2027 1 080 213 91A2
                MB      C, ACCH.7              ; 2029 1 080 213 C5072F
                JGE     label_2032             ; 202C 1 080 213 CD04
                MOV     X1, A                  ; 202E 1 080 213 50
                CLR     A                      ; 202F 1 080 213 F9
                SUB     A, X1                  ; 2030 1 080 213 90A2
                                               ; 2032 from 202C (DD1,080,213)
label_2032:     CMP     A, #00002h             ; 2032 1 080 213 C60200
                JGE     label_2047             ; 2035 1 080 213 CD10
                                               ; 2037 from 2023 (DD1,080,213)
label_2037:     MB      C, PSWL.4              ; 2037 1 080 213 A32C
                JGE     label_2051             ; 2039 1 080 213 CD16
                L       A, er2                 ; 203B 1 080 213 36
                SUB     A, er0                 ; 203C 1 080 213 28
                JGE     label_2042             ; 203D 1 080 213 CD03
                ST      A, er0                 ; 203F 1 080 213 88
                CLR     A                      ; 2040 1 080 213 F9
                SUB     A, er0                 ; 2041 1 080 213 28
                                               ; 2042 from 203D (DD1,080,213)
label_2042:     CMP     A, #00002h             ; 2042 1 080 213 C60200
                JLT     label_2051             ; 2045 1 080 213 CA0A
                                               ; 2047 from 2005 (DD1,080,213)
                                               ; 2047 from 200A (DD1,080,213)
                                               ; 2047 from 2012 (DD1,080,213)
                                               ; 2047 from 2017 (DD1,080,213)
                                               ; 2047 from 201C (DD1,080,213)
                                               ; 2047 from 2021 (DD1,080,213)
                                               ; 2047 from 2035 (DD1,080,213)
label_2047:     MOVB    0f0h, #04bh            ; 2047 1 080 213 C5F0984B
                DECB    0ech                   ; 204B 1 080 213 C5EC17
                JNE     label_2051             ; 204E 1 080 213 CE01
                BRK                            ; 2050 1 080 213 FF
                                               ; 2051 from 2039 (DD1,080,213)
                                               ; 2051 from 2045 (DD1,080,213)
                                               ; 2051 from 204E (DD1,080,213)
label_2051:     VCAL    3                      ; 2051 1 080 213 13
                J       label_3589             ; 2052 1 080 213 038935
                                               ; 2055 from 35CD (DD0,080,213)
label_2055:     JBS     off(TM0).4, label_2081 ; 2055 0 080 213 EC3029
                MB      C, 0f1h.6              ; 2058 0 080 213 C5F12E
                JLT     label_2081             ; 205B 0 080 213 CA24
                CMPB    0a6h, #002h            ; 205D 0 080 213 C5A6C002
                JGE     label_2067             ; 2061 0 080 213 CD04
                MOVB    off(000e9h), #064h     ; 2063 0 080 213 C4E99864
                                               ; 2067 from 2061 (DD0,080,213)
label_2067:     JBR     off(0001fh).1, label_2081 ; 2067 0 080 213 D91F17

				;mechanical map sensor code setting...
				;we will never ever set a mechanical map code
                LB      A, #000h                ; really useless

                SJ		label_2074				; skip next 6 lines
                NOP
                NOP
                NOP
                STB     A, r0                  ; 2071 0 080 213 88
                CLRB    A                      ; 2072 0 080 213 FA
                SUBB    A, r0                  ; 2073 0 080 213 28
                                               ; 2074 from 206F (DD0,080,213)
label_2074:     CMPB    A, #002h               ; useless as well
                NOP
                NOP
                RB      0f1h.6                 ; dont set this bit
                SJ      label_2081             ; jump to unset the mech map code
                                               ; 207D from 2076 (DD0,080,213)
label_207d:     LB      A, off(000e9h)         ; skipped
                JEQ     label_2082             ; skipped
                                               ; 2081 from 35D0 (DD0,080,213)
                                               ; 2081 from 2055 (DD0,080,213)
                                               ; 2081 from 205B (DD0,080,213)
                                               ; 2081 from 2067 (DD0,080,213)
label_2081:     RC                             ; do NOT set the map code
                                               ; 2082 from 207B (DD0,080,213)
                                               ; 2082 from 207F (DD0,080,213)
label_2082:     MB      off(P4).3, C           ; put carry into map code checking bit
				;done with mech map code setting...

nomapcode:      RC                             ; 2085 0 080 213 95
                JBS     off(TM0).7, label_2099 ; 2086 0 080 213 EF3010
                MB      C, off(0001eh).5       ; 2089 0 080 213 C41E2D
                JGE     label_2099             ; 208C 0 080 213 CD0B
                MB      C, off(IRQ).4          ; 208E 0 080 213 C4182C
                JBR     off(IRQ).7, label_2099 ; 2091 0 080 213 DF1805
                JGE     label_2099             ; 2094 0 080 213 CD03
                MB      C, 0f3h.5              ; 2096 0 080 213 C5F32D
                                               ; 2099 from 2086 (DD0,080,213)
                                               ; 2099 from 208C (DD0,080,213)
                                               ; 2099 from 2091 (DD0,080,213)
                                               ; 2099 from 2094 (DD0,080,213)
label_2099:     MB      off(P4IO).1, C         ; 2099 0 080 213 C42D39
                LB      A, #0b0h               ; 209C 0 080 213 77B0
                CMPB    0a6h, A                ; 209E 0 080 213 C5A6C1
                JGE     label_20b2             ; 20A1 0 080 213 CD0F
                RC                             ; 20A3 0 080 213 95
                JBS     off(P0IO).3, label_20b2 ; 20A4 0 080 213 EB210B
                JBS     off(TMR0).0, label_20b2 ; 20A7 0 080 213 E83208
                MB      C, off(0001eh).0       ; 20AA 0 080 213 C41E28
                JGE     label_20b2             ; 20AD 0 080 213 CD03
                MB      C, 0f2h.6              ; 20AF 0 080 213 C5F22E
                                               ; 20B2 from 20A1 (DD0,080,213)
                                               ; 20B2 from 20A4 (DD0,080,213)
                                               ; 20B2 from 20A7 (DD0,080,213)
                                               ; 20B2 from 20AD (DD0,080,213)
label_20b2:     MB      off(P4IO).2, C         ; 20B2 0 080 213 C42D3A
                MB      C, P4.6                ; 20B5 0 080 213 C52C2E
                JBS     off(P3IO).6, label_20c8 ; 20B8 0 080 213 EE290D
                MOVB    off(000ddh), #014h     ; 20BB 0 080 213 C4DD9814
                LB      A, off(000deh)         ; 20BF 0 080 213 F4DE
                NOP                            ; 20C1 0 080 213 00
                NOP                            ; 20C2 0 080 213 00
                JGE     label_20d2             ; 20C3 0 080 213 CD0D
                                               ; 20C5 from 20D0 (DD0,080,213)
                                               ; 20C5 from 20D2 (DD0,080,213)
label_20c5:     RC                             ; 20C5 0 080 213 95
                SJ      label_20d6             ; 20C6 0 080 213 CB0E
                                               ; 20C8 from 20B8 (DD0,080,213)
label_20c8:     MOVB    off(000deh), #014h     ; 20C8 0 080 213 C4DE9814
                LB      A, off(000ddh)         ; 20CC 0 080 213 F4DD
                NOP                            ; 20CE 0 080 213 00
                NOP                            ; 20CF 0 080 213 00
                JGE     label_20c5             ; 20D0 0 080 213 CDF3
                                               ; 20D2 from 20C3 (DD0,080,213)
label_20d2:     JBS     off(TMR0).4, label_20c5 ; 20D2 0 080 213 EC32F0
                SC                             ; 20D5 0 080 213 85
                                               ; 20D6 from 20C6 (DD0,080,213)
label_20d6:     MB      off(P4IO).6, C         ; 20D6 0 080 213 C42D3E
                JNE     label_20ee             ; 20D9 0 080 213 CE13
                JBS     off(TMR0).4, label_20ee ; 20DB 0 080 213 EC3210
                JLT     label_20ee             ; 20DE 0 080 213 CA0E
                JBS     off(TMR0).5, label_20ee ; 20E0 0 080 213 ED320B
                MB      C, 0f3h.2              ; 20E3 0 080 213 C5F32A
                JBR     off(P3IO).6, label_20ef ; 20E6 0 080 213 DE2906
                JLT     label_20ee             ; 20E9 0 080 213 CA03
                SC                             ; 20EB 0 080 213 85
                SJ      label_20ef             ; 20EC 0 080 213 CB01
                                               ; 20EE from 20D9 (DD0,080,213)
                                               ; 20EE from 20DB (DD0,080,213)
                                               ; 20EE from 20DE (DD0,080,213)
                                               ; 20EE from 20E0 (DD0,080,213)
                                               ; 20EE from 20E9 (DD0,080,213)
label_20ee:     RC                             ; 20EE 0 080 213 95
                                               ; 20EF from 20E6 (DD0,080,213)
                                               ; 20EF from 20EC (DD0,080,213)
                ;euro pw0 missing from here:
label_20ef:     MB      off(P4IO).7, C    ;mugen -> NOP NOP NOP     ; 20EF 0 080 213 C42D3F
                MOV     X1, #02f98h            ; 20F2 0 080 213 60982F
                MOV     X2, #0015eh            ; 20F5 0 080 213 615E01
                JBS     off(IRQ).7, label_2101 ; 20F8 0 080 213 EF1806
                MOV     X1, #02fa7h            ; 20FB 0 080 213 60A72F
                MOV     X2, #000fah            ; 20FE 0 080 213 61FA00
                                               ; 2101 from 20F8 (DD0,080,213)
label_2101:     LB      A, 0a6h                ; 2101 0 080 213 F5A6
                VCAL    1                      ; 2103 0 080 213 11
                CMPB    0a4h, #015h    ;mugen -> #000h        ; 2104 0 080 213 C5A4C015
                JGE     label_210f             ; 2108 0 080 213 CD05
                ; warning: had to flip DD
                SUB     A, X2                  ; 210A 1 080 213 91A2
                JGE     label_210f             ; 210C 1 080 213 CD01
                CLR     A                      ; 210E 1 080 213 F9
                                               ; 210F from 2108 (DD0,080,213)
                                               ; 210F from 210C (DD1,080,213)
label_210f:     ST      A, off(SRSTAT)         ; 210F 1 080 213 D456
				;to here

                LB      A, #003h               ; 2111 0 080 213 7703
                CMPCB   A, 02f45h              ; 2113 0 080 213 909F452F
                MB      C, PSWH.6              ; 2117 0 080 213 A22E
                CLRB    A                      ; 2119 0 080 213 FA
                JGE     label_2120             ; 211A 0 080 213 CD04
                LB      A, 09fh                ;
                ADDB    A, #080h               ; 211E 0 080 213 8680
                                               ; 2120 from 211A (DD0,080,213)
label_2120:     STB     A, off(TM2)            ; 2120 0 080 213 D438
                VCAL    3                      ; 2122 0 080 213 13
                RC                             ; 2123 0 080 213 95
                JBS     off(TM0H).1, label_2132 ; 2124 0 080 213 E9310B
                LB      A, #0fch               ; 2127 0 080 213 77FC
                CMPB    A, 098h                ; 2129 0 080 213 C598C2
                JLT     label_2132             ; 212C 0 080 213 CA04
                LB      A, 098h                ; 212E 0 080 213 F598
                CMPB    A, #004h               ; 2130 0 080 213 C604
                                               ; 2132 from 2124 (DD0,080,213)
                                               ; 2132 from 212C (DD0,080,213)
label_2132:     MB      off(P4).7, C           ; 2132 0 080 213 C42C3F
                JLT     label_2141             ; 2135 0 080 213 CA0A
                JBS     off(TM0H).1, label_2141 ; 2137 0 080 213 E93107
                MOV     USP, #000a3h           ; 213A 0 080 0A3 A198A300
                CAL     label_2d07             ; 213E 0 080 0A3 32072D
                                               ; 2141 from 2135 (DD0,080,213)
                                               ; 2141 from 2137 (DD0,080,213)
label_2141:     MOV     X1, #02f7ah            ; 2141 0 080 0A3 607A2F
                LB      A, 0a3h                ; 2144 0 080 0A3 F5A3
                VCAL    0                      ; 2146 0 080 0A3 10
                STB     A, off(0005ah)         ; 2147 0 080 0A3 D45A
                LB      A, #0b3h               ; 2149 0 080 0A3 77B3
                JBS     off(IRQH).3, label_2150 ; 214B 0 080 0A3 EB1902
                LB      A, #0b8h               ; 214E 0 080 0A3 77B8
                                               ; 2150 from 214B (DD0,080,0A3)
label_2150:     CMPB    A, 0b3h                ; 2150 0 080 0A3 C5B3C2
                MB      off(IRQH).3, C         ; 2153 0 080 0A3 C4193B
                RC                             ; 2156 0 080 0A3 95
                LB      A, off(TM2H)           ; 2157 0 080 0A3 F439
                JNE     label_2164             ; 2159 0 080 0A3 CE09
                CMPB    0a3h, #027h            ; 215B 0 080 0A3 C5A3C027
                JGE     label_2164             ; 215F 0 080 0A3 CD03
                MB      C, off(IRQH).3         ; 2161 0 080 0A3 C4192B
                                               ; 2164 from 2159 (DD0,080,0A3)
                                               ; 2164 from 215F (DD0,080,0A3)
label_2164:     MB      off(IRQH).6, C         ; 2164 0 080 0A3 C4193E
                L       A, IE                  ; 2167 1 080 0A3 E51A
                JEQ     label_2171             ; 2169 1 080 0A3 C906
                CMPB    0a6h, #008h            ; 216B 1 080 0A3 C5A6C008
                JLT     label_218d             ; 216F 1 080 0A3 CA1C
                                               ; 2171 from 2169 (DD1,080,0A3)
label_2171:     LB      A, 0a0h                ; 2171 0 080 0A3 F5A0
                CMPB    A, #0ffh               ; 2173 0 080 0A3 C6FF
                JGT     label_2183             ; 2175 0 080 0A3 C80C
                CMPB    A, #0fch               ; 2177 0 080 0A3 C6FC
                JGE     label_218d             ; 2179 0 080 0A3 CD12
                CMPB    A, #088h               ; 217B 0 080 0A3 C688
                JGT     label_2183             ; 217D 0 080 0A3 C804
                CMPB    A, #078h               ; 217F 0 080 0A3 C678
                JGE     label_218d             ; 2181 0 080 0A3 CD0A
                                               ; 2183 from 2175 (DD0,080,0A3)
                                               ; 2183 from 217D (DD0,080,0A3)
label_2183:     MOVB    0f0h, #049h            ; 2183 0 080 0A3 C5F09849
                DECB    0ech                   ; 2187 0 080 0A3 C5EC17
                JNE     label_218d             ; 218A 0 080 0A3 CE01
                BRK                            ; 218C 0 080 0A3 FF
                                               ; 218D from 216F (DD1,080,0A3)
                                               ; 218D from 2179 (DD0,080,0A3)
                                               ; 218D from 2181 (DD0,080,0A3)
                                               ; 218D from 218A (DD0,080,0A3)
label_218d:     MOV     X1, #03096h            ; 218D 1 080 0A3 609630
                LB      A, 09bh                ; 2190 0 080 0A3 F59B
                VCAL    1                      ; 2192 0 080 0A3 11
                STB     A, off(SRTM)           ; 2193 0 080 0A3 D44C
                LB      A, 09eh                ; 2195 0 080 0A3 F59E
                SLLB    A                      ; 2197 0 080 0A3 53
                MB      off(IRQ).7, C   ;mugen -> NOP NOP NOP      ;Euro pw0 just has: RB off(IRQ).7
                ;NOP
                ;NOP		;knock ??
                ;NOP
                CLR     A                      ; 219B 1 080 0A3 F9
                LB      A, #0c0h               ; 219C 0 080 0A3 77C0
                JBR     off(IE).6, label_21a3  ; 219E 0 080 0A3 DE1A02
                LB      A, #0b9h               ; 21A1 0 080 0A3 77B9
                                               ; 21A3 from 219E (DD0,080,0A3)
label_21a3:     CMPB    A, 0b3h        ;map?        ; 21A3 0 080 0A3 C5B3C2
                CLRB    A                      ; 21A6 0 080 0A3 FA
                MB      off(IE).6, C           ; 21A7 0 080 0A3 C41A3E
                JGE     label_21d1             ; 21AA 0 080 0A3 CD25
                LB      A, 09dh                ; 21AC 0 080 0A3 F59D
                SUBB    A, #007h               ; 21AE 0 080 0A3 A607
                JGE     label_21b3             ; 21B0 0 080 0A3 CD01
                CLRB    A                      ; 21B2 0 080 0A3 FA
                                               ; 21B3 from 21B0 (DD0,080,0A3)
label_21b3:     MOVB    r0, #051h              ; 21B3 0 080 0A3 9851
                DIVB                           ; 21B5 0 080 0A3 A236
                CMPB    0a6h, #0e0h            ; 21B7 0 080 0A3 C5A6C0E0
                JGE     label_21cd             ; 21BB 0 080 0A3 CD10
                LB      A, r1                  ; 21BD 0 080 0A3 79
                MOVB    r0, #01bh              ; 21BE 0 080 0A3 981B
                DIVB                           ; 21C0 0 080 0A3 A236
                CMPB    0a6h, #0bah            ; 21C2 0 080 0A3 C5A6C0BA
                JGE     label_21cd             ; 21C6 0 080 0A3 CD05
                LB      A, r1                  ; 21C8 0 080 0A3 79
                MOVB    r0, #009h              ; 21C9 0 080 0A3 9809
                DIVB                           ; 21CB 0 080 0A3 A236
                                               ; 21CD from 21BB (DD0,080,0A3)
                                               ; 21CD from 21C6 (DD0,080,0A3)
label_21cd:     MOVB    r0, #0fah              ; 21CD 0 080 0A3 98FA
                MULB                           ; 21CF 0 080 0A3 A234
                                               ; 21D1 from 21AA (DD0,080,0A3)
label_21d1:     STB     A, off(TMR2H)          ; 21D1 0 080 0A3 D43B
                J       label_35e1             ; 21D3 0 080 0A3 03E135
                DB  030h ; 21D6
                                               ; 21D7 from 35E6 (DD0,080,0A3)
label_21d7:     DIVB                           ; 21D7 0 080 0A3 A236
                CMPB    0a6h, #0c6h            ; 21D9 0 080 0A3 C5A6C0C6
                JGE     label_21ec             ; 21DD 0 080 0A3 CD0D
                SRLB    A                      ; 21DF 0 080 0A3 63
                LB      A, r1                  ; 21E0 0 080 0A3 79
                JGE     label_21e6             ; 21E1 0 080 0A3 CD03
                LB      A, #02fh               ; 21E3 0 080 0A3 772F
                SUBB    A, r1                  ; 21E5 0 080 0A3 29
                                               ; 21E6 from 21E1 (DD0,080,0A3)
label_21e6:     MOVB    r0, #009h              ; 21E6 0 080 0A3 9809
                DIVB                           ; 21E8 0 080 0A3 A236
                ADDB    A, #006h               ; 21EA 0 080 0A3 8606
                                               ; 21EC from 21DD (DD0,080,0A3)
label_21ec:     LCB     A, 0308ah[ACC]         ; 21EC 0 080 0A3 B506AB8A30
                STB     A, off(ADSCAN)         ; 21F1 0 080 0A3 D458
                VCAL    3                      ; 21F3 0 080 0A3 13
                RC                             ; 21F4 0 080 0A3 95
                JBS     off(TM0).5, label_21ff ; 21F5 0 080 0A3 ED3007
                LB      A, 099h                ; 21F8 0 080 0A3 F599
                CMPB    A, #0fch               ; 21FA 0 080 0A3 C6FC
                JLE     label_2208             ; 21FC 0 080 0A3 CF0A
                SC                             ; 21FE 0 080 0A3 85
                                               ; 21FF from 21F5 (DD0,080,0A3)
                                               ; 21FF from 220A (DD0,080,0A3)
label_21ff:     MB      off(P4).1, C           ; 21FF 0 080 0A3 C42C39
                MOVB    0a4h, #03ch            ; 2202 0 080 0A3 C5A4983C
                SJ      label_223b             ; 2206 0 080 0A3 CB33
                                               ; 2208 from 21FC (DD0,080,0A3)
label_2208:     CMPB    A, #004h               ; 2208 0 080 0A3 C604
                JLT     label_21ff             ; 220A 0 080 0A3 CAF3
                RB      off(P4).1              ; 220C 0 080 0A3 C42C09
                CMPB    09ah, #003h            ; 220F 0 080 0A3 C59AC003
                JLE     label_222d             ; 2213 0 080 0A3 CF18
                SUBB    A, off(00098h)         ; 2215 0 080 0A3 A798
                JGE     label_221c             ; 2217 0 080 0A3 CD03
                STB     A, r0                  ; 2219 0 080 0A3 88
                CLRB    A                      ; 221A 0 080 0A3 FA
                SUBB    A, r0                  ; 221B 0 080 0A3 28
                                               ; 221C from 2217 (DD0,080,0A3)
label_221c:     CMPB    A, #002h               ; 221C 0 080 0A3 C602
                JGT     label_2237             ; 221E 0 080 0A3 C817
                LB      A, off(000dch)         ; 2220 0 080 0A3 F4DC
                JNE     label_223f             ; 2222 0 080 0A3 CE1B
                LB      A, 099h                ; 2224 0 080 0A3 F599
                JBS     off(0001eh).5, label_222d ; 2226 0 080 0A3 ED1E04
                CMPB    A, off(000aah)         ; 2229 0 080 0A3 C7AA
                JGT     label_223b             ; 222B 0 080 0A3 C80E
                                               ; 222D from 2213 (DD0,080,0A3)
                                               ; 222D from 2226 (DD0,080,0A3)
label_222d:     MOV     USP, #000a4h           ; 222D 0 080 0A4 A198A400
                CAL     label_2d07             ; 2231 0 080 0A4 32072D
                CAL     label_2d1d             ; 2234 0 080 0A4 321D2D
                                               ; 2237 from 221E (DD0,080,0A3)
label_2237:     LB      A, 099h                ; 2237 0 080 0A4 F599
                STB     A, off(00098h)         ; 2239 0 080 0A4 D498
                                               ; 223B from 2206 (DD0,080,0A3)
                                               ; 223B from 222B (DD0,080,0A3)
label_223b:     MOVB    off(000dch), #005h     ; 223B 0 080 0A4 C4DC9805
                                               ; 223F from 2222 (DD0,080,0A3)
label_223f:     MOV     X1, #031c3h            ; 223F 0 080 0A4 60C331
                LB      A, 0a4h                ; 2242 0 080 0A4 F5A4
                VCAL    2                      ; 2244 0 080 0A4 12
                CMPB    0a4h, #015h      ;mugen -> #005h      ; 2245 0 080 0A4 C5A4C015
                JGE     label_2250             ; 2249 0 080 0A4 CD05
                J       label_3564             ; 224B 0 080 0A4 036435
                                               ; 224E from 356D (DD0,080,0A4)
label_224e:     LB      A, #0f8h         ;mugen -> #000h      ; 224E 0 080 0A4 77F8
                                               ; 2250 from 2249 (DD0,080,0A4)
                                               ; 2250 from 356A (DD0,080,0A4)
label_2250:     STB     A, off(TMR3)           ; 2250 0 080 0A4 D43E
                MOV     X1, #03314h            ; 2252 0 080 0A4 601433
                JBS     off(IRQ).7, label_225b ; 2255 0 080 0A4 EF1803
                MOV     X1, #032f9h            ; 2258 0 080 0A4 60F932
                                               ; 225B from 2255 (DD0,080,0A4)
label_225b:     LB      A, 0a4h                ; 225B 0 080 0A4 F5A4
                VCAL    1                      ; 225D 0 080 0A4 11
                STB     A, off(PWCON0)         ; 225E 0 080 0A4 D478
                MOV     X1, #032c1h            ; 2260 0 080 0A4 60C132
                LB      A, 0a4h                ; 2263 0 080 0A4 F5A4
                VCAL    0                      ; 2265 0 080 0A4 10
                STB     A, off(00097h)         ; 2266 0 080 0A4 D497
                MOV     X1, #032dfh      ;temp vals for idle      ; 2268 0 080 0A4 60DF32
                MOV     DP, #032f5h      ;rpm vals for idle      ; 226B 0 080 0A4 62F532
                JBS     off(IRQ).7, label_2277 ; 226E 0 080 0A4 EF1806
                MOV     X1, #032cdh       ;temp vals for idle     ; 2271 0 080 0A4 60CD32
                MOV     DP, #032f1h       ;rpm vals for idle?     ; 2274 0 080 0A4 62F132
                                               ; 2277 from 226E (DD0,080,0A4)
label_2277:     LB      A, 0a4h           ;move temp into A     ; 2277 0 080 0A4 F5A4
                VCAL    1                      ; 2279 0 080 0A4 11
                JBR     off(P2).7, label_22a7  ; 227A 0 080 0A4 DF242A
                LC      A, [DP]          ;load rpm word      ; 227D 0 080 0A4 92A8
                JBR     off(P3SF).6, label_2286 ; 227F 0 080 0A4 DE2A04
                LC      A, 00002h[DP]    ;load next rpm word      ; 2282 0 080 0A4 92A90200
                                               ; 2286 from 227F (DD0,080,0A4)
label_2286:     STB     A, r0                  ; 2286 0 080 0A4 88
                CMPB    A, off(PWMC1)          ; 2287 0 080 0A4 C774
                JEQ     label_22a7             ; 2289 0 080 0A4 C91C
                MOV     er1, #00010h           ; 228B 0 080 0A4 45981000
                SB      off(P2IO).1            ; 228F 0 080 0A4 C42519
                LB      A, off(000fbh)         ; 2292 0 080 0A4 F4FB
                JNE     label_22b0             ; 2294 0 080 0A4 CE1A
                L       A, off(PWMC1)          ; 2296 1 080 0A4 E474
                JGE     label_22a0             ; 2298 1 080 0A4 CD06
                SUB     A, er1                 ; 229A 1 080 0A4 29
                CMP     A, er0                 ; 229B 1 080 0A4 48
                JGE     label_22aa             ; 229C 1 080 0A4 CD0C
                SJ      label_22a4             ; 229E 1 080 0A4 CB04
                                               ; 22A0 from 2298 (DD1,080,0A4)
label_22a0:     ADD     A, er1                 ; 22A0 1 080 0A4 09
                CMP     A, er0                 ; 22A1 1 080 0A4 48
                JLT     label_22aa             ; 22A2 1 080 0A4 CA06
                                               ; 22A4 from 229E (DD1,080,0A4)
label_22a4:     L       A, er0                 ; 22A4 1 080 0A4 34
                SJ      label_22aa             ; 22A5 1 080 0A4 CB03
                                               ; 22A7 from 227A (DD0,080,0A4)
                                               ; 22A7 from 2289 (DD0,080,0A4)
label_22a7:     RB      off(P2IO).1            ; 22A7 0 080 0A4 C42509
                                               ; 22AA from 229C (DD1,080,0A4)
                                               ; 22AA from 22A2 (DD1,080,0A4)
                                               ; 22AA from 22A5 (DD1,080,0A4)
label_22aa:     STB     A, off(PWMC1)          ; 22AA 0 080 0A4 D474
                MOVB    off(000fbh), #005h     ; 22AC 0 080 0A4 C4FB9805
                                               ; 22B0 from 2294 (DD0,080,0A4)
label_22b0:     L       A, off(PWCON0)         ; 22B0 1 080 0A4 E478
                CAL     label_2e82             ; 22B2 1 080 0A4 32822E
                MOV     er0, #00600h           ; 22B5 1 080 0A4 44980006
                JBR     off(P2).1, label_22c0  ; 22B9 1 080 0A4 D92404
                MOV     er0, #00080h           ; 22BC 1 080 0A4 44988000
                                               ; 22C0 from 22B9 (DD1,080,0A4)
label_22c0:     SUB     A, er0                 ; 22C0 1 080 0A4 28
                JGE     label_22c6             ; 22C1 1 080 0A4 CD03
                L       A, #00001h             ; 22C3 1 080 0A4 670100
                                               ; 22C6 from 22C1 (DD1,080,0A4)
label_22c6:     ST      A, off(00090h)         ; 22C6 1 080 0A4 D490
                CAL     label_2e7a             ; 22C8 1 080 0A4 327A2E
                ST      A, off(0008eh)         ; 22CB 1 080 0A4 D48E
                LB      A, 0a4h                ; 22CD 0 080 0A4 F5A4
                CMPB    A, #028h               ; 22CF 0 080 0A4 C628
                MB      off(P2).7, C           ; 22D1 0 080 0A4 C4243F
                CMPB    A, #02eh               ; 22D4 0 080 0A4 C62E
                MB      off(P2).6, C           ; 22D6 0 080 0A4 C4243E
                CMPB    A, #0d0h               ; 22D9 0 080 0A4 C6D0
                MB      off(P2).5, C           ; 22DB 0 080 0A4 C4243D
                CMPB    A, #0a1h               ; 22DE 0 080 0A4 C6A1
                MB      off(P2).4, C           ; 22E0 0 080 0A4 C4243C
                VCAL    3                      ; 22E3 0 080 0A4 13
                L       A, #0397dh      ;mugen -> #0ffffh       ; 22E4 1 080 0A4 677D39
                JBS     off(P2).3, label_22ed  ; 22E7 1 080 0A4 EB2403
                L       A, #02dfeh      ;mugen -> #0fffdh       ; 22EA 1 080 0A4 67FE2D
                                               ; 22ED from 22E7 (DD1,080,0A4)
label_22ed:     CMP     0c4h, A         ;mugen found it desirable to compare this to a really high value       ; 22ED 1 080 0A4 B5C4C1
                MB      off(P2).3, C    ;maybe so it always sets P2.3??       ; 22F0 1 080 0A4 C4243B
                CAL     label_2db2             ; 22F3 1 080 0A4 32B22D
                CAL     label_2ddf             ; 22F6 1 080 0A4 32DF2D
                CAL     label_2dd2             ; 22F9 1 080 0A4 32D22D
                CAL     label_2ddf             ; 22FC 1 080 0A4 32DF2D
                MOV     er0, #0ae20h           ; 22FF 1 080 0A4 449820AE
                MOV     er1, #05b60h           ; 2303 1 080 0A4 4598605B
                                               ; 2307 from 2322 (DD1,080,0A4)
label_2307:     MB      C, P0.3                ; 2307 1 080 0A4 C5202B
                JGE     label_2317             ; 230A 1 080 0A4 CD0B
                JBS     off(0001dh).1, label_2317 ; 230C 1 080 0A4 E91D08
                L       A, 00162h[X2]          ; 230F 1 080 0A4 E16201
                CAL     label_2e5e             ; 2312 1 080 0A4 325E2E
                JLT     label_231d             ; 2315 1 080 0A4 CA06
                                               ; 2317 from 230A (DD1,080,0A4)
                                               ; 2317 from 230C (DD1,080,0A4)
label_2317:     MOV     001c8h[X2], #00bb8h    ; 2317 1 080 0A4 B1C80198B80B
                                               ; 231D from 2315 (DD1,080,0A4)
label_231d:     DEC     X2                     ; 231D 1 080 0A4 81
                DEC     X2                     ; 231E 1 080 0A4 81
                MB      C, 083h.7              ; 231F 1 080 0A4 C5832F
                JGE     label_2307             ; 2322 1 080 0A4 CDE3
                AND     IE, #00080h            ; 2324 1 080 0A4 B51AD08000
                RB      PSWH.0                 ; 2329 1 080 0A4 A208
                RB      off(0001fh).0          ; 232B 1 080 0A4 C41F08
                JBS     off(0001eh).5, label_2376 ; 232E 1 080 0A4 ED1E45
                JNE     label_2340             ; 2331 1 080 0A4 CE0D
                JBS     off(0001eh).7, label_2340 ; 2333 1 080 0A4 EF1E0A
                JBR     off(0001eh).6, label_237d ; 2336 1 080 0A4 DE1E44
                L       A, TM1                 ; 2339 1 080 0A4 E534
                CMP     A, 0e0h                ; 233B 1 080 0A4 B5E0C2
                JLT     label_237d             ; 233E 1 080 0A4 CA3D
                                               ; 2340 from 2331 (DD1,080,0A4)
                                               ; 2340 from 2333 (DD1,080,0A4)
label_2340:     SB      off(0001eh).5          ; 2340 1 080 0A4 C41E1D
                MB      C, 0f1h.7              ; 2343 1 080 0A4 C5F12F
                JLT     label_234c             ; 2346 1 080 0A4 CA04
                MOVB    0e6h, #004h            ; 2348 1 080 0A4 C5E69804
                                               ; 234C from 2346 (DD1,080,0A4)
label_234c:     ANDB    0f2h, #03fh            ; 234C 1 080 0A4 C5F2D03F
                CAL     label_2f33             ; 2350 1 080 0A4 32332F
                MOV     USP, #00213h           ; 2353 1 080 213 A1981302
                L       A, #0ffffh             ; 2357 1 080 213 67FFFF
                PUSHU   A                      ; 235A 1 080 211 76
                PUSHU   A                      ; 235B 1 080 20F 76
                PUSHU   A                      ; 235C 1 080 20D 76
                ST      A, 0bah                ; 235D 1 080 20D D5BA
                CLR     A                      ; 235F 1 080 20D F9
                PUSHU   A                      ; 2360 1 080 20B 76
                PUSHU   A                      ; 2361 1 080 209 76
                PUSHU   A                      ; 2362 1 080 207 76
                PUSHU   A                      ; 2363 1 080 205 76
                CLRB    0a6h                   ; 2364 1 080 205 C5A615
                SB      P2.4                   ; 2367 1 080 205 C5241C
                RB      TCON2.3                ; 236A 1 080 205 C5420B
                RB      TCON2.2                ; 236D 1 080 205 C5420A
                RB      off(P0).0              ; 2370 1 080 205 C42008
                RB      off(IEH).7             ; 2373 1 080 205 C41B0F
                                               ; 2376 from 232E (DD1,080,0A4)
label_2376:     L       A, TM2                 ; 2376 1 080 205 E538
                SUB     A, #00001h             ; 2378 1 080 205 A60100
                ST      A, TMR2                ; 237B 1 080 205 D53A
                                               ; 237D from 2336 (DD1,080,0A4)
                                               ; 237D from 233E (DD1,080,0A4)
label_237d:     SB      PSWH.0                 ; 237D 1 080 205 A218
                L       A, 0cch                ; 237F 1 080 205 E5CC
                ST      A, IE                  ; 2381 1 080 205 D51A
                MB      C, 0f3h.7              ; 2383 1 080 205 C5F32F
                MB      off(IRQ).4, C          ; 2386 1 080 205 C4183C
                JLT     label_2394             ; 2389 1 080 205 CA09
                RB      0f1h.7                 ; 238B 1 080 205 C5F10F
                MB      C, off(0001eh).5       ; 238E 1 080 205 C41E2D
                JBR     off(0001fh).4, label_239e ; 2391 1 080 205 DC1F0A
                                               ; 2394 from 2389 (DD1,080,205)
label_2394:     LB      A, #012h               ; 2394 0 080 205 7712
                JBS     off(0001fh).4, label_239b ; 2396 0 080 205 EC1F02
                LB      A, #01dh               ; 2399 0 080 205 771D
                                               ; 239B from 2396 (DD0,080,205)
label_239b:     CMPB    A, 0bbh                ; 239B 0 080 205 C5BBC2
                                               ; 239E from 2391 (DD1,080,205)
label_239e:     MB      off(0001fh).4, C       ; 239E 0 080 205 C41F3C
                JGE     label_23d2             ; 23A1 0 080 205 CD2F
                JBR     off(IRQ).4, label_23a9 ; 23A3 0 080 205 DC1803
                SB      off(0001fh).1          ; 23A6 0 080 205 C41F19
                                               ; 23A9 from 23A3 (DD0,080,205)
label_23a9:     AND     off(P4), #00682h       ; 23A9 0 080 205 B42CD08206
                AND     off(P4SF), #0007fh     ; 23AE 0 080 205 B42ED07F00
                ORB     P1, #038h              ; 23B3 0 080 205 C522E038
                LB      A, #096h               ; 23B7 0 080 205 7796
                STB     A, off(000ceh)         ; 23B9 0 080 205 D4CE
                STB     A, off(000cfh)         ; 23BB 0 080 205 D4CF
                J       label_3696             ; 23BD 0 080 205 039636
                                               ; 23C0 from 369B (DD0,080,205)
label_23c0:     MOVB    off(000fch), #01eh     ; 23C0 0 080 205 C4FC981E
                MOVB    off(000d0h), #01ch     ; 23C4 0 080 205 C4D0981C
                MOVB    off(000fah), #00ah     ; 23C8 0 080 205 C4FA980A
                JBS     off(0001eh).5, label_23d2 ; 23CC 0 080 205 ED1E03
                JBS     off(TM0).5, label_23d6 ; 23CF 0 080 205 ED3004
                                               ; 23D2 from 23A1 (DD0,080,205)
                                               ; 23D2 from 23CC (DD0,080,205)
label_23d2:     MOVB    off(000eah), #063h     ; 23D2 0 080 205 C4EA9863
                                               ; 23D6 from 23CF (DD0,080,205)
label_23d6:     JBS     off(0001fh).4, label_23e3 ; 23D6 0 080 205 EC1F0A
                MB      C, 0f3h.0              ; 23D9 0 080 205 C5F328
                JGE     label_23ec             ; 23DC 0 080 205 CD0E
                MB      C, P3.7                ; 23DE 0 080 205 C5282F
                JGE     label_23e7             ; 23E1 0 080 205 CD04
                                               ; 23E3 from 23D6 (DD0,080,205)
label_23e3:     MOVB    off(000f3h), #00ah     ; 23E3 0 080 205 C4F3980A
                                               ; 23E7 from 23E1 (DD0,080,205)
label_23e7:     LB      A, off(000f3h)         ; 23E7 0 080 205 F4F3
                RC                             ; 23E9 0 080 205 95
                JNE     label_23ed             ; 23EA 0 080 205 CE01
                                               ; 23EC from 23DC (DD0,080,205)
label_23ec:     SC                   ;mugen -> RC          ; 23EC 0 080 205 85
                                               ; 23ED from 23EA (DD0,080,205)
label_23ed:     MB      off(0002bh).2, C       ; 23ED 0 080 205 C42B3A
                LB      A, 0f3h                ; 23F0 0 080 205 F5F3
                ANDB    A, #003h               ; 23F2 0 080 205 D603
                J       label_1d83             ; 23F4 0 080 205 03831D
                                               ; 23F7 from 1D8B (DD0,080,205)
label_23f7:     RC                             ; 23F7 0 080 205 95
                JNE     label_23fe             ; 23F8 0 080 205 CE04
                J       label_4212             ; 23FA 0 080 205 031242
                                               ; 23FD from 4218 (DD0,080,205)
label_23fd:     SC                             ; 23FD 0 080 205 85
                                               ; 23FE from 1D8E (DD0,080,205)
                                               ; 23FE from 23F8 (DD0,080,205)
                                               ; 23FE from 421B (DD0,080,205)
label_23fe:     MB      off(P4IO).3, C         ; 23FE 0 080 205 C42D3B
                NOP                            ; 2401 0 080 205 00
                SRLB    A                      ; 2402 0 080 205 63
                JGE     label_2408             ; 2403 0 080 205 CD03
                RC                             ; 2405 0 080 205 95
                SJ      label_240c             ; 2406 0 080 205 CB04
                                               ; 2408 from 2403 (DD0,080,205)
label_2408:     JBS     off(TMR0).2, label_240c ; 2408 0 080 205 EA3201
                SC                             ; 240B 0 080 205 85
                                               ; 240C from 2406 (DD0,080,205)
                                               ; 240C from 2408 (DD0,080,205)
label_240c:     MB      off(P4).6, C           ; 240C 0 080 205 C42C3E
                VCAL    3                      ; 240F 0 080 205 13
                J       label_40c9             ; 2410 0 080 205 03C940
                                               ; 2413 from 40CF (DD0,080,205)
label_2413:     MOVB    r2, #0dah     ;mugen -> #000h         ; 2413 0 080 205 9ADA
                JBS     off(IRQ).7, label_241a ; 2415 0 080 205 EF1802
                MOVB    r2, #0dah     ;mugen -> #000h         ; 2418 0 080 205 9ADA
                                               ; 241A from 2415 (DD0,080,205)
label_241a:     J       label_2481             ; 241A 0 080 205 038124
                                               ; 241D from 40D2 (DD0,080,205)
label_241d:     MOVB    r3, off(ADCR7H)        ; 241D 0 080 205 C46F4B
                JBS     off(P3SF).6, label_246e ; 2420 0 080 205 EE2A4B
                LB      A, off(000fch)         ; 2423 0 080 205 F4FC
                JNE     label_246e             ; 2425 0 080 205 CE47
                LB      A, r3                  ; 2427 0 080 205 7B
                MOVB    r0, #004h              ; 2428 0 080 205 9804
                JEQ     label_242e             ; 242A 0 080 205 C902
                MOVB    r0, #006h              ; 242C 0 080 205 9806
                                               ; 242E from 242A (DD0,080,205)
label_242e:     MOV     DP, #00278h            ; 242E 0 080 205 627802
                LB      A, [DP]                ; 2431 0 080 205 F2
                ADDB    A, r0                  ; 2432 0 080 205 08
                CMPB    A, 0ach                ; 2433 0 080 205 C5ACC2
                JLT     label_246e             ; 2436 0 080 205 CA36
                MOVB    r2, #0ffh       ;mugen -> #000h       ; 2438 0 080 205 9AFF
                MOVB    r6, off(0009fh)        ;
                LB      A, off(000a0h)         ; 243D 0 080 205 F4A0
                JBR     off(IRQ).7, label_2463 ; 243F 0 080 205 DF1821
                JBR     off(P2).3, label_2463  ; 2442 0 080 205 DB241E
                MB      C, 0f3h.5              ; 2445 0 080 205 C5F32D
                JLT     label_2463             ; 2448 0 080 205 CA19
                CMPB    0a4h, #062h            ; 244A 0 080 205 C5A4C062
                JGE     label_2463             ; 244E 0 080 205 CD13
                MOVB    r2, #0b3h       ;mugen -> #000h       ; 2450 0 080 205 9AB3
                MOV     X1, #02f88h            ; 2452 0 080 205 60882F
                LB      A, 0a4h                ; 2455 0 080 205 F5A4
                VCAL    0                      ; 2457 0 080 205 10
                LB      A, #014h               ; 2458 0 080 205 7714
                CMPB    0a4h, #02eh            ; 245A 0 080 205 C5A4C02E
                JGE     label_2462             ; 245E 0 080 205 CD02
                LB      A, #01fh               ; 2460 0 080 205 771F
                                               ; 2462 from 245E (DD0,080,205)
label_2462:     ADDB    A, r6                  ; 2462 0 080 205 0E
                                               ; 2463 from 243F (DD0,080,205)
                                               ; 2463 from 2442 (DD0,080,205)
                                               ; 2463 from 2448 (DD0,080,205)
                                               ; 2463 from 244E (DD0,080,205)
label_2463:     CMPB    r3, #000h              ; 2463 0 080 205 23C000
                JEQ     label_2469             ; 2466 0 080 205 C901
                LB      A, r6                  ; 2468 0 080 205 7E
                                               ; 2469 from 2466 (DD0,080,205)
label_2469:     CMPB    A, 0a6h                ; 2469 0 080 205 C5A6C2
                JLT     label_2481             ; 246C 0 080 205 CA13
                                               ; 246E from 2420 (DD0,080,205)
                                               ; 246E from 2425 (DD0,080,205)
                                               ; 246E from 2436 (DD0,080,205)
label_246e:     MOVB    r0, #001h              ; 246E 0 080 205 9801
                LB      A, r3                  ; 2470 0 080 205 7B
                JEQ     label_2475             ; 2471 0 080 205 C902
                MOVB    r0, #00ah              ; 2473 0 080 205 980A
                                               ; 2475 from 2471 (DD0,080,205)
label_2475:     LB      A, off(000a1h)         ; 2475 0 080 205 F4A1
                ADDB    A, r0                  ; 2477 0 080 205 08
                CLRB    r2                     ; 2478 0 080 205 2215
                CMPB    A, 0b3h                ; 247A 0 080 205 C5B3C2
                JLT     label_2481             ; 247D 0 080 205 CA02
                MOVB    r2, #0f5h       ;mugen -> #000h       ; 247F 0 080 205 9AF5
                                               ; 2481 from 241A (DD0,080,205)
                                               ; 2481 from 246C (DD0,080,205)
                                               ; 2481 from 247D (DD0,080,205)
label_2481:     MOVB    off(ADCR7H), r2        ; 2481 0 080 205 227C6F
                MOVB    r0, #005h              ; 2484 0 080 205 9805
                LB      A, 0e7h                ; 2486 0 080 205 F5E7
                JNE     label_24a2             ; 2488 0 080 205 CE18
                MOVB    r0, #0ffh              ; 248A 0 080 205 98FF
                MOVB    r1, 0a6h               ; 248C 0 080 205 C5A649
                MOV     X1, #0321eh            ; 248F 0 080 205 601E32
                                               ; 2492 from 24A0 (DD0,080,205)
label_2492:     INCB    r0                     ; 2492 0 080 205 A8
                INC     X1                     ; 2493 0 080 205 70
                LCB     A, [X1]                ; 2494 0 080 205 90AA
                CMPB    r0, off(00099h)        ; 2496 0 080 205 20C399
                JLT     label_249f             ; 2499 0 080 205 CA04
                SUBB    A, #004h               ; 249B 0 080 205 A604
                JLT     label_24a2             ; 249D 0 080 205 CA03
                                               ; 249F from 2499 (DD0,080,205)
label_249f:     CMPB    A, r1                  ; 249F 0 080 205 49
                JGT     label_2492             ; 24A0 0 080 205 C8F0
                                               ; 24A2 from 2488 (DD0,080,205)
                                               ; 24A2 from 249D (DD0,080,205)
label_24a2:     LB      A, r0                  ; 24A2 0 080 205 78
                CMPB    0a4h, #02eh            ; 24A3 0 080 205 C5A4C02E
                JGE     label_24af             ; 24A7 0 080 205 CD06
                JBS     off(P1IO).3, label_24af ; 24A9 0 080 205 EB2303
                JBS     off(0001fh).5, label_24b5 ; 24AC 0 080 205 ED1F06
                                               ; 24AF from 24A7 (DD0,080,205)
                                               ; 24AF from 24A9 (DD0,080,205)
label_24af:     MOVB    r0, #005h              ; 24AF 0 080 205 9805
                CMPB    A, r0                  ; 24B1 0 080 205 48
                JLT     label_24b5             ; 24B2 0 080 205 CA01
                LB      A, r0                  ; 24B4 0 080 205 78
                                               ; 24B5 from 24AC (DD0,080,205)
                                               ; 24B5 from 24B2 (DD0,080,205)
label_24b5:     STB     A, off(00099h)         ; 24B5 0 080 205 D499
                MOV     DP, #0021ah            ; 24B7 0 080 205 621A02
                AND     IE, #00080h            ; 24BA 0 080 205 B51AD08000
                RB      PSWH.0                 ; 24BF 0 080 205 A208
                MOV     er0, [DP]              ; 24C1 0 080 205 B248
                INC     DP                     ; 24C3 0 080 205 72
                INC     DP                     ; 24C4 0 080 205 72
                MOVB    r2, [DP]               ; 24C5 0 080 205 C24A
                MOVB    r3, 0e5h               ; 24C7 0 080 205 C5E54B
                SB      PSWH.0                 ; 24CA 0 080 205 A218
                L       A, 0cch                ; 24CC 1 080 205 E5CC
                ST      A, IE                  ; 24CE 1 080 205 D51A
                LB      A, r3                  ; 24D0 0 080 205 7B
                CAL     label_2ae5             ; 24D1 0 080 205 32E52A
                CMPB    A, r0                  ; 24D4 0 080 205 48
                JNE     label_24ec             ; 24D5 0 080 205 CE15
                LB      A, r2                  ; 24D7 0 080 205 7A
                EXTND                          ; 24D8 1 080 205 F8
                SLL     A                      ; 24D9 1 080 205 53
                LC      A, 0349ah[ACC]         ; 24DA 1 080 205 B506A99A34
                JEQ     label_24ff             ; 24DF 1 080 205 C91E
                CMP     A, er0                 ; 24E1 1 080 205 48
                JEQ     label_24ff             ; 24E2 1 080 205 C91B
                RB      PSWH.0                 ; 24E4 1 080 205 A208
                LB      A, #00fh               ; 24E6 0 080 205 770F
                STB     A, [DP]                ; 24E8 0 080 205 D2
                ORB     P2, A                  ; 24E9 0 080 205 C524E1
                                               ; 24EC from 24D5 (DD0,080,205)
label_24ec:     RB      PSWH.0                 ; 24EC 0 080 205 A208
                LB      A, 0e5h                ; 24EE 0 080 205 F5E5
                CAL     label_2ae5             ; 24F0 0 080 205 32E52A
                XORB    A, #0ffh               ; 24F3 0 080 205 F6FF
                STB     A, r7                  ; 24F5 0 080 205 8F
                DEC     DP                     ; 24F6 0 080 205 82
                DEC     DP                     ; 24F7 0 080 205 82
                L       A, er3                 ; 24F8 1 080 205 37
                ST      A, [DP]                ; 24F9 1 080 205 D2
                CAL     label_2f3c             ; 24FA 1 080 205 323C2F
                SB      PSWH.0                 ; 24FD 1 080 205 A218
                                               ; 24FF from 24DF (DD1,080,205)
                                               ; 24FF from 24E2 (DD1,080,205)
label_24ff:     VCAL    3                      ; 24FF 1 080 205 13
                RC                             ; 2500 1 080 205 95
                LB      A, off(000e7h)         ; 2501 0 080 205 F4E7
                JNE     label_250c             ; 2503 0 080 205 CE07
                JBS     off(IRQ).4, label_250c ; 2505 0 080 205 EC1804
                JBR     off(0001eh).5, label_250c ; 2508 0 080 205 DD1E01
                SC                             ; 250B 0 080 205 85
                                               ; 250C from 2503 (DD0,080,205)
                                               ; 250C from 2505 (DD0,080,205)
                                               ; 250C from 2508 (DD0,080,205)
label_250c:     MB      P3.4, C                ; 250C 0 080 205 C5283C
                LB      A, off(TM0)            ; 250F 0 080 205 F430
                ORB     A, off(TM0H)           ; 2511 0 080 205 E731
                ORB     A, off(TMR0)           ; 2513 0 080 205 E732
                JNE     label_2537             ; 2515 0 080 205 CE20
                ;LB      A, 0f0h                ; <--mugen not NOPs; feels did kind of the same thing in the pw0.
                NOP                            ; 2517 0 080 205 00
                NOP                            ; 2518 0 080 205 00
                JNE     label_2537             ; 2519 0 080 205 CE1C

                ;if f0h != 0 mugen skips from here... (just like feels)
                CMPB    0a0h, #0fch            ; 251B 0 080 205 C5A0C0FC
                JGE     label_2524             ; 251F 0 080 205 CD03
                JBS     off(IRQ).2, label_2537 ; 2521 0 080 205 EA1813
                                               ; 2524 from 251F (DD0,080,205)
label_2524:     JBS     off(IRQ).4, label_252a ; 2524 0 080 205 EC1803
                JBS     off(0001eh).5, label_252c ; 2527 0 080 205 ED1E02
                                               ; 252A from 2524 (DD0,080,205)
label_252a:     STB     A, off(000e7h)         ; 252A 0 080 205 D4E7
                                               ; 252C from 2527 (DD0,080,205)
                                     ;mugen's mod really only skips this: CMPB    09ah, #003h
label_252c:     J       label_36bc   ;mugen -> JBR     off(0002bh).2, label_2532           ; 252C 0 080 205 03BC36
                                               ; 252F from 36C5 (DD0,080,205)
label_252f:     JBR     off(000d2h).0, label_2537 ; 252F 0 080 205 D8D205
                                               ; 2532 from 36C8 (DD0,080,205)
label_2532:     RC                             ; 2532 0 080 205 95
                LB      A, off(000e7h)         ; 2533 0 080 205 F4E7
                JEQ     label_2538             ; 2535 0 080 205 C901
                ;mugen skips to here...

                                               ; 2537 from 2515 (DD0,080,205)
                                               ; 2537 from 2519 (DD0,080,205)
                                               ; 2537 from 2521 (DD0,080,205)
                                               ; 2537 from 252F (DD0,080,205)
label_2537:     SC                             ; 2537 0 080 205 85
                                               ; 2538 from 2535 (DD0,080,205)
label_2538:     MB      P0.6, C                ; 2538 0 080 205 C5203E
                LB      A, #0feh               ; 253B 0 080 205 77FE
                JBS     off(P3SF).7, label_2542 ; 253D 0 080 205 EF2A02
                LB      A, #0ffh               ; 2540 0 080 205 77FF
                                               ; 2542 from 253D (DD0,080,205)
label_2542:     CMPB    A, 0a6h                ; 2542 0 080 205 C5A6C2
                MB      off(P3SF).7, C         ; 2545 0 080 205 C42A3F
                JLT     label_25c3             ; 2548 0 080 205 CA79
                CMPB    off(000abh), #032h     ; 254A 0 080 205 C4ABC032
                JLT     label_25c3             ; 254E 0 080 205 CA73
                JBS     off(TMR0).0, label_25a6 ; 2550 0 080 205 E83253
                CLRB    r0                     ; 2553 0 080 205 2015
                LB      A, #018h               ; 2555 0 080 205 7718
                MOVB    r1, #0ffh              ; 2557 0 080 205 99FF
                MOVB    r2, #0fah              ; 2559 0 080 205 9AFA
                JBS     off(P3SF).1, label_2564 ; 255B 0 080 205 E92A06
                LB      A, #015h               ; 255E 0 080 205 7715
                MOVB    r1, #0ffh              ; 2560 0 080 205 99FF
                MOVB    r2, #0ffh              ; 2562 0 080 205 9AFF
                                               ; 2564 from 255B (DD0,080,205)
                ;check temp, then speed, then rpm
label_2564:     CMPB    0a4h, A                ; 2564 0 080 205 C5A4C1
                JGE     label_2573     ;if colder than ~170deg        ; 2567 0 080 205 CD0A
                LB      A, r1                  ; 2569 0 080 205 79
                CMPB    A, 0cbh                ; 256A 0 080 205 C5CBC2
                JGE     label_2573     ;if slower than 250kph        ; 256D 0 080 205 CD04
                LB      A, r2                  ; 256F 0 080 205 7A
                CMPB    A, 0a6h        ;or rpm > 8160        ; 2570 0 080 205 C5A6C2
                                               ; 2573 from 2567 (DD0,080,205)
                                               ; 2573 from 256D (DD0,080,205)
label_2573:     MB      off(P3SF).1, C   ;then this carry will be 1      ; 2573 0 080 205 C42A39
                JLT     label_25c3       ;else we are cold enough and slow enough to jump      ; 2576 0 080 205 CA4B
                MOV     DP, #03408h            ; 2578 0 080 205 620834
                JBR     off(IRQ).7, label_2582 ; 257B 0 080 205 DF1804
                ADD     DP, #00006h            ; 257E 0 080 205 92800600
                                               ; 2582 from 257B (DD0,080,205)
label_2582:     JBR     off(P3SF).5, label_2588 ; 2582 0 080 205 DD2A03
                INC     DP                     ; 2585 0 080 205 72
                INC     DP                     ; 2586 0 080 205 72
                INC     DP                     ; 2587 0 080 205 72
                                               ; 2588 from 2582 (DD0,080,205)
label_2588:     LCB     A, [DP]                ; 2588 0 080 205 92AA
                CMPB    A, 0ach                ; 258A 0 080 205 C5ACC2
                JLT     label_25bc             ; 258D 0 080 205 CA2D
                INC     DP                     ; 258F 0 080 205 72
                LC      A, [DP]                ; 2590 0 080 205 92A8
                CMPB    A, 0cbh                ; 2592 0 080 205 C5CBC2
                JLT     label_25a3             ; 2595 0 080 205 CA0C
                LB      A, ACCH                ; 2597 0 080 205 F507
                CMPB    A, 0a6h                ; 2599 0 080 205 C5A6C2
                JLT     label_25a3             ; 259C 0 080 205 CA05
                MOVB    r0, #028h              ; 259E 0 080 205 9828
                RB      off(P3SF).5            ; 25A0 0 080 205 C42A0D
                                               ; 25A3 from 2595 (DD0,080,205)
                                               ; 25A3 from 259C (DD0,080,205)
label_25a3:     MOVB    off(000f5h), r0        ; 25A3 0 080 205 207CF5
                                               ; 25A6 from 2550 (DD0,080,205)
                                               ; 25A6 from 25BE (DD0,080,205)
label_25a6:     MB      C, 0f3h.6              ; 25A6 0 080 205 C5F32E
                JGE     label_25c6             ; 25A9 0 080 205 CD1B
                SB      off(P3SF).3            ; 25AB 0 080 205 C42A1B
                LB      A, off(000d8h)         ; 25AE 0 080 205 F4D8
                JNE     label_25d1             ; 25B0 0 080 205 CE1F
                MOVB    off(000f4h), #004h     ; 25B2 0 080 205 C4F49804
                                               ; 25B6 from 25CB (DD0,080,205)
label_25b6:     SB      off(P3SF).6            ; 25B6 0 080 205 C42A1E
                RC                             ; 25B9 0 080 205 95
                SJ      label_25d5             ; 25BA 0 080 205 CB19
                                               ; 25BC from 258D (DD0,080,205)
label_25bc:     LB      A, off(000f5h)         ; 25BC 0 080 205 F4F5
                JEQ     label_25a6             ; 25BE 0 080 205 C9E6
                SB      off(P3SF).5            ; 25C0 0 080 205 C42A1D


                                               ; 25C3 from 2548 (DD0,080,205)
                                               ; 25C3 from 254E (DD0,080,205)
                                               ; 25C3 from 2576 (DD0,080,205)
label_25c3:     CLRB    off(000f4h)            ; 25C3 0 080 205 C4F415
                                               ; 25C6 from 25A9 (DD0,080,205)
label_25c6:     RB      off(P3SF).3            ; 25C6 0 080 205 C42A0B
                LB      A, off(000f4h)         ; 25C9 0 080 205 F4F4
                JNE     label_25b6             ; 25CB 0 080 205 CEE9
                MOVB    off(000d8h), #004h     ; 25CD 0 080 205 C4D89804
                                               ; 25D1 from 25B0 (DD0,080,205)
label_25d1:     RB      off(P3SF).6            ; 25D1 0 080 205 C42A0E
                SC                             ; 25D4 0 080 205 85
                                               ; 25D5 from 25BA (DD0,080,205)
label_25d5:     MB      P0.7, C                ; 25D5 0 080 205 C5203F
                J       label_369e             ; 25D8 0 080 205 039E36
                                               ; 25DB from 36A1 (DD0,080,205)
label_25db:     MOVB    off(000f1h), #014h     ; 25DB 0 080 205 C4F19814
                SJ      label_25fc             ; 25DF 0 080 205 CB1B
                                               ; 25E1 from 36AA (DD0,080,205)
label_25e1:     LB      A, off(000f1h)         ; 25E1 0 080 205 F4F1
                JEQ     label_25fc             ; 25E3 0 080 205 C917
                L       A, #00026h             ; 25E5 1 080 205 672600
                CMPB    0a3h, #028h            ; 25E8 1 080 205 C5A3C028
                JGE     label_25f4             ; 25EC 1 080 205 CD06
                CMPB    0a4h, #01fh            ; 25EE 1 080 205 C5A4C01F
                JLT     label_2607             ; 25F2 1 080 205 CA13
                                               ; 25F4 from 25EC (DD1,080,205)
label_25f4:     LB      A, 0a4h                ; 25F4 0 080 205 F5A4
                MOV     X1, #03084h            ; 25F6 0 080 205 608430
                VCAL    7                      ; 25F9 0 080 205 17
                SJ      label_2607             ; 25FA 0 080 205 CB0B
                                               ; 25FC from 25DF (DD0,080,205)
                                               ; 25FC from 36AD (DD0,080,205)
                                               ; 25FC from 25E3 (DD0,080,205)
label_25fc:     L       A, off(SRTMC)          ; 25FC 1 080 205 E44E
                JEQ     label_2606             ; 25FE 1 080 205 C906
                SB      off(IEH).5             ; 2600 1 080 205 C41B1D
                SB      off(EXION).5           ; 2603 1 080 205 C41C1D
                                               ; 2606 from 25FE (DD1,080,205)
label_2606:     CLR     A                      ; 2606 1 080 205 F9
                                               ; 2607 from 25F2 (DD1,080,205)
                                               ; 2607 from 25FA (DD0,080,205)
label_2607:     ST      A, off(SRTMC)          ; 2607 1 080 205 D44E
                LB      A, off(TM0)            ; 2609 0 080 205 F430
                ORB     A, off(TM0H)           ; 260B 0 080 205 E731
                ORB     A, off(TMR0)           ; 260D 0 080 205 E732
                JNE     label_262b             ; 260F 0 080 205 CE1A
                J       label_421e             ; 2611 0 080 205 031E42
                                               ; 2614 from 4225 (DD0,080,205)
label_2614:     CMPB    0a3h, #028h            ; 2614 0 080 205 C5A3C028
                JGE     label_262b             ; 2618 0 080 205 CD11
                CMPB    0a4h, #01fh            ; 261A 0 080 205 C5A4C01F
                JGE     label_262b             ; 261E 0 080 205 CD0B
                MOVB    off(000d3h), #01eh     ; 2620 0 080 205 C4D3981E
                                               ; 2624 from 4228 (DD0,080,205)
label_2624:     LB      A, off(000d3h)         ; 2624 0 080 205 F4D3
                JEQ     label_262e             ; 2626 0 080 205 C906
                RC                             ; 2628 0 080 205 95
                SJ      label_262f             ; 2629 0 080 205 CB04
                                               ; 262B from 260F (DD0,080,205)
                                               ; 262B from 2618 (DD0,080,205)
                                               ; 262B from 261E (DD0,080,205)
label_262b:     CLRB    off(000d3h)            ; 262B 0 080 205 C4D315
                                               ; 262E from 2626 (DD0,080,205)
label_262e:     SC                             ; 262E 0 080 205 85
                                               ; 262F from 2629 (DD0,080,205)
label_262f:     MB      P0.3, C                ; 262F 0 080 205 C5203B
                LB      A, off(000fch)         ; 2632 0 080 205 F4FC
                JNE     label_263c             ; 2634 0 080 205 CE06
                MOV     DP, #00279h            ; 2636 0 080 205 627902
                LB      A, 0a4h                ; 2639 0 080 205 F5A4
                STB     A, [DP]                ; 263B 0 080 205 D2
                                               ; 263C from 2634 (DD0,080,205)
label_263c:     VCAL    3                      ; 263C 0 080 205 13
                MOV     er2, off(P4)           ; 263D 0 080 205 B42C4A
                LB      A, 0f1h                ; 2640 0 080 205 F5F1
                ANDB    A, #003h               ; 2642 0 080 205 D603
                JEQ     label_264b             ; 2644 0 080 205 C905
                CLR     A                      ; 2646 1 080 205 F9
                ST      A, off(P4)             ; 2647 1 080 205 D42C
                ST      A, er2                 ; 2649 1 080 205 8A
                NOP                            ; 264A 1 080 205 00
                                               ; 264B from 2644 (DD0,080,205)
label_264b:     MOVB    r7, #001h              ; 264B 1 080 205 9F01
                MOV     DP, #001e8h            ; 264D 1 080 205 62E801
                                               ; 2650 from 2668 (DD0,080,205)
label_2650:     SRL     er2                    ; 2650 1 080 205 46E7
                JLT     label_266c             ; 2652 1 080 205 CA18
                LB      A, r7                  ; 2654 0 080 205 7F
                SUBB    A, off(000a2h)         ; 2655 0 080 205 A7A2
                JNE     label_265c             ; 2657 0 080 205 CE03
                STB     A, off(000a2h)         ; 2659 0 080 205 D4A2
                STB     A, [DP]                ; 265B 0 080 205 D2
                                               ; 265C from 2657 (DD0,080,205)
label_265c:     LB      A, r7                  ; 265C 0 080 205 7F
                SUBB    A, 0e8h                ; 265D 0 080 205 C5E8A2
                JNE     label_2664             ; 2660 0 080 205 CE02
                STB     A, 0e8h                ; 2662 0 080 205 D5E8
                                               ; 2664 from 2660 (DD0,080,205)
                                               ; 2664 from 2675 (DD0,080,205)
                                               ; 2664 from 267C (DD0,080,205)
label_2664:     INCB    r7                     ; 2664 0 080 205 AF
                CMPB    r7, #011h              ; 2665 0 080 205 27C011
                JNE     label_2650             ; 2668 0 080 205 CEE6
                SJ      label_268e             ; 266A 0 080 205 CB22
                                               ; 266C from 2652 (DD1,080,205)
label_266c:     LB      A, 0e8h                ; 266C 0 080 205 F5E8
                JEQ     label_2677             ; 266E 0 080 205 C907
                CMPB    A, #011h               ; 2670 0 080 205 C611
                JGE     label_2677             ; 2672 0 080 205 CD03
                CMPB    A, r7                  ; 2674 0 080 205 4F
                JNE     label_2664             ; 2675 0 080 205 CEED
                                               ; 2677 from 266E (DD0,080,205)
                                               ; 2677 from 2672 (DD0,080,205)
label_2677:     LB      A, off(000a2h)         ; 2677 0 080 205 F4A2
                JEQ     label_2684             ; 2679 0 080 205 C909
                CMPB    A, r7                  ; 267B 0 080 205 4F
                JNE     label_2664             ; 267C 0 080 205 CEE6
                LB      A, [DP]                ; 267E 0 080 205 F2
                JNE     label_268e             ; 267F 0 080 205 CE0D
                J       label_26bf             ; 2681 0 080 205 03BF26
                                               ; 2684 from 2679 (DD0,080,205)
label_2684:     CLR     A                      ; 2684 1 080 205 F9
                LB      A, r7                  ; 2685 0 080 205 7F
                STB     A, off(000a2h)         ; 2686 0 080 205 D4A2
                LCB     A, 03469h[ACC]         ; 2688 0 080 205 B506AB6934
                STB     A, [DP]                ; 268D 0 080 205 D2
                                               ; 268E from 266A (DD0,080,205)
                                               ; 268E from 267F (DD0,080,205)
label_268e:     VCAL    3                      ; 268E 0 080 205 13
                MOVB    r7, #011h              ; 268F 0 080 205 9F11
                CLRB    A                      ; 2691 0 080 205 FA
                XCHGB   A, off(P4SF)           ; 2692 0 080 205 C42E10
                STB     A, r0                  ; 2695 0 080 205 88
                J       label_35d3             ; 2696 0 080 205 03D335
                                               ; 2699 from 35DE (DD0,080,205)
                                               ; 2699 from 26BB (DD0,080,205)
label_2699:     SRLB    r0                     ; 2699 0 080 205 20E7
                JLT     label_26b1             ; 269B 0 080 205 CA14
                CLR     A                      ; 269D 1 080 205 F9
                LB      A, r7                  ; 269E 0 080 205 7F
                CMPB    A, 0e8h                ; 269F 0 080 205 C5E8C2
                JNE     label_26b6             ; 26A2 0 080 205 CE12
                LCB     A, 034abh[ACC]         ; 26A4 0 080 205 B506ABAB34
                SUBB    A, [DP]                ; 26A9 0 080 205 C2A2
                JNE     label_26b6             ; 26AB 0 080 205 CE09
                STB     A, 0e8h                ; 26AD 0 080 205 D5E8
                SJ      label_26b6             ; 26AF 0 080 205 CB05
                                               ; 26B1 from 269B (DD0,080,205)
label_26b1:     LB      A, [DP]                ; 26B1 0 080 205 F2
                JEQ     label_26bf             ; 26B2 0 080 205 C90B
                DECB    [DP]                   ; 26B4 0 080 205 C217
                                               ; 26B6 from 26A2 (DD0,080,205)
                                               ; 26B6 from 26AB (DD0,080,205)
                                               ; 26B6 from 26AF (DD0,080,205)
label_26b6:     INC     DP                     ; 26B6 0 080 205 72
                INCB    r7                     ; 26B7 0 080 205 AF
                CMPB    r7, #018h              ; 26B8 0 080 205 27C018
                JNE     label_2699             ; 26BB 0 080 205 CEDC
                SJ      label_26fa             ; 26BD 0 080 205 CB3B
                                               ; 26BF from 2681 (DD0,080,205)
                                               ; 26BF from 26B2 (DD0,080,205)
label_26bf:     MOVB    [DP], #005h            ; 26BF 0 080 205 C29805
                LB      A, 0e8h                ; 26C2 0 080 205 F5E8
                JNE     label_26cd             ; 26C4 0 080 205 CE07
                LB      A, r7                  ; 26C6 0 080 205 7F
                STB     A, 0e8h                ; 26C7 0 080 205 D5E8
                STB     A, 0e9h                ; 26C9 0 080 205 D5E9
                SJ      label_26fa             ; 26CB 0 080 205 CB2D
                                               ; 26CD from 26C4 (DD0,080,205)
label_26cd:     SUBB    A, r7                  ; 26CD 0 080 205 2F
                JNE     label_26fa             ; 26CE 0 080 205 CE2A
                RB      PSWH.0                 ; 26D0 0 080 205 A208
                STB     A, 0e8h                ; 26D2 0 080 205 D5E8
                CLR     A                      ; 26D4 1 080 205 F9
                LB      A, r7                  ; 26D5 0 080 205 7F
                LCB     A, 03479h[ACC]         ; 26D6 0 080 205 B506AB7934
                JEQ     label_26f8             ; 26DB 0 080 205 C91B
                STB     A, r6                  ; 26DD 0 080 205 8E
                SB      0f1h.3                 ; 26DE 0 080 205 C5F11B
                CAL     label_2eb6             ; 26E1 0 080 205 32B62E
                RB      0f1h.3                 ; 26E4 0 080 205 C5F10B
                SB      off(IRQ).5             ; 26E7 0 080 205 C4181D
                JNE     label_26ef             ; 26EA 0 080 205 CE03
                NOP                            ; 26EC 0 080 205 00
                NOP                            ; 26ED 0 080 205 00
                NOP                            ; 26EE 0 080 205 00
                                               ; 26EF from 26EA (DD0,080,205)
label_26ef:     LB      A, r6                  ; 26EF 0 080 205 7E
                CMPB    A, #00ah               ; 26F0 0 080 205 C60A
                JNE     label_26f8             ; 26F2 0 080 205 CE04
                MOVB    0a3h, #057h            ; 26F4 0 080 205 C5A39857
                                               ; 26F8 from 26DB (DD0,080,205)
                                               ; 26F8 from 26F2 (DD0,080,205)
label_26f8:     SB      PSWH.0                 ; 26F8 0 080 205 A218
                                               ; 26FA from 26CB (DD0,080,205)
                                               ; 26FA from 26CE (DD0,080,205)
                                               ; 26FA from 26BD (DD0,080,205)
label_26fa:     VCAL    3                      ; 26FA 0 080 205 13
                MOV     DP, #0027eh            ; 26FB 0 080 205 627E02
                MOV     USP, #00133h           ; 26FE 0 080 133 A1983301
                CLR     er0                    ; 2702 0 080 133 4415
                                               ; 2704 from 2728 (DD0,080,132)
label_2704:     DEC     DP                     ; 2704 0 080 133 82
                DEC     USP                    ; 2705 0 080 132 A117
                LB      A, r0                  ; 2707 0 080 132 78
                ADDB    A, [DP]                ; 2708 0 080 132 C282
                STB     A, r0                  ; 270A 0 080 132 88
                LB      A, r1                  ; 270B 0 080 132 79
                XORB    A, [DP]                ; 270C 0 080 132 C2F2
                STB     A, r1                  ; 270E 0 080 132 89
                LB      A, [DP]                ; 270F 0 080 132 F2
                NOP                            ; 2710 0 080 132 00
                NOP                            ; 2711 0 080 132 00
                NOP                            ; 2712 0 080 132 00
                NOP                            ; 2713 0 080 132 00
                NOP                            ; 2714 0 080 132 00
                NOP                            ; 2715 0 080 132 00
                NOP                            ; 2716 0 080 132 00
                NOP                            ; 2717 0 080 132 00
                STB     A, r2                  ; 2718 0 080 132 8A
                LB      A, (00132h-00132h)[USP] ; 2719 0 080 132 F300
                XORB    A, #0ffh               ; 271B 0 080 132 F6FF
                XORB    A, r2                  ; 271D 0 080 132 22F2
                ORB     A, r2                  ; 271F 0 080 132 6A
                ADDB    A, #001h               ; 2720 0 080 132 8601
                JNE     label_2740             ; 2722 0 080 132 CE1C
                CMP     DP, #0027bh            ; 2724 0 080 132 92C07B02
                JNE     label_2704             ; 2728 0 080 132 CEDA
                LB      A, [DP]                ; 272A 0 080 132 F2
                ANDB    A, #003h               ; 272B 0 080 132 D603
                JNE     label_2740             ; 272D 0 080 132 CE11
                INC     DP                     ; 272F 0 080 132 72
                LB      A, [DP]                ; 2730 0 080 132 F2
                ANDB    A, #09ch               ; 2731 0 080 132 D69C
                JNE     label_2740             ; 2733 0 080 132 CE0B
                INC     DP                     ; 2735 0 080 132 72
                LB      A, [DP]                ; 2736 0 080 132 F2
                ANDB    A, #008h               ; 2737 0 080 132 D608
                JNE     label_2740             ; 2739 0 080 132 CE05
                INC     DP                     ; 273B 0 080 132 72
                L       A, [DP]                ; 273C 1 080 132 E2
                CMP     A, er0                 ; 273D 1 080 132 48
                JEQ     label_2745             ; 273E 1 080 132 C905
                                               ; 2740 from 2722 (DD0,080,132)
                                               ; 2740 from 272D (DD0,080,132)
                                               ; 2740 from 2733 (DD0,080,132)
                                               ; 2740 from 2739 (DD0,080,132)
label_2740:     MOVB    0f0h, #043h            ; 2740 1 080 132 C5F09843
                BRK                            ; 2744 1 080 132 FF
                                               ; 2745 from 273E (DD1,080,132)
label_2745:     L       A, IE                  ; 2745 1 080 132 E51A
                JNE     label_279a             ; 2747 1 080 132 CE51
                CAL     label_2d84             ; 2749 1 080 132 32842D
                SC                             ; 274C 1 080 132 85
                LB      A, off(P4)             ; 274D 0 080 132 F42C
                ANDB    A, #082h               ; 274F 0 080 132 D682
                JNE     label_2778             ; 2751 0 080 132 CE25
                MOV     er0, 098h              ; 2753 0 080 132 B59848
                CMPB    r0, #0c0h              ; 2756 0 080 132 20C0C0
                JLT     label_2778             ; 2759 0 080 132 CA1D
                CMPB    r1, #0c0h              ; 275B 0 080 132 21C0C0
                JLT     label_2778             ; 275E 0 080 132 CA18
                MOV     DP, #00279h            ; 2760 0 080 132 627902
                LB      A, [DP]                ; 2763 0 080 132 F2
                SUBB    A, r1                  ; 2764 0 080 132 29
                MOVB    r2, #010h              ; 2765 0 080 132 9A10
                JGE     label_276e             ; 2767 0 080 132 CD05
                STB     A, r2                  ; 2769 0 080 132 8A
                CLRB    A                      ; 276A 0 080 132 FA
                SUBB    A, r2                  ; 276B 0 080 132 2A
                MOVB    r2, #010h              ; 276C 0 080 132 9A10
                                               ; 276E from 2767 (DD0,080,132)
label_276e:     CMPB    r2, A                  ; 276E 0 080 132 22C1
                JLT     label_2778             ; 2770 0 080 132 CA06
                LB      A, r0                  ; 2772 0 080 132 78
                SUBB    A, r1                  ; 2773 0 080 132 29
                JLT     label_2778             ; 2774 0 080 132 CA02
                CMPB    A, #004h               ; 2776 0 080 132 C604
                                               ; 2778 from 2751 (DD0,080,132)
                                               ; 2778 from 2759 (DD0,080,132)
                                               ; 2778 from 275E (DD0,080,132)
                                               ; 2778 from 2770 (DD0,080,132)
                                               ; 2778 from 2774 (DD0,080,132)
label_2778:     MB      off(IE).5, C           ; 2778 0 080 132 C41A3D
                SB      STTMC.4                ; 277B 0 080 132 C54A1C
                SB      SRCON.7                ; 277E 0 080 132 C5541F
                SB      SRTMC.4                ; 2781 0 080 132 C54E1C
                MOVB    0ech, #020h            ; 2784 0 080 132 C5EC9820
                MOV     0ceh, #00090h          ; 2788 0 080 132 B5CE989000
                L       A, #022fbh             ; 278D 1 080 132 67FB22
                ST      A, 0cch                ; 2790 1 080 132 D5CC
                CLRB    TRNSIT                 ; 2792 1 080 132 C54615
                CLR     IRQ                    ; 2795 1 080 132 B51815
                ST      A, IE                  ; 2798 1 080 132 D51A
                                               ; 279A from 2747 (DD1,080,132)
label_279a:     RB      0f2h.5                 ; 279A 1 080 132 C5F20D
                JNE     label_27a2             ; 279D 1 080 132 CE03
                J       label_1ec6             ; 279F 1 080 132 03C61E
                                               ; 27A2 from 279D (DD1,080,132)
label_27a2:     CMPB    0a6h, #086h            ; 27A2 1 080 132 C5A6C086
                JGE     label_27d1             ; 27A6 1 080 132 CD29
                JBS     off(IRQ).4, label_27d1 ; 27A8 1 080 132 EC1826
                CMPB    0a6h, #01bh            ; 27AB 1 080 132 C5A6C01B
                JLT     label_27d1             ; 27AF 1 080 132 CA20
                CMPB    0b3h, #030h            ; 27B1 1 080 132 C5B3C030
                JLT     label_27d1             ; 27B5 1 080 132 CA1A
                CMPB    0a4h, #034h            ; 27B7 1 080 132 C5A4C034
                JGE     label_27d1             ; 27BB 1 080 132 CD14
                LB      A, #0ffh               ; 27BD 0 080 132 77FF
                RB      TRNSIT.3               ; 27BF 0 080 132 C5460B
                JNE     label_27cb             ; 27C2 0 080 132 CE07
                LB      A, off(000cch)         ; 27C4 0 080 132 F4CC
                JEQ     label_27cc             ; 27C6 0 080 132 C904
                DECB    ACC                    ; 27C8 0 080 132 C50617
                                               ; 27CB from 27C2 (DD0,080,132)
label_27cb:     RC                             ; 27CB 0 080 132 95
                                               ; 27CC from 27C6 (DD0,080,132)
label_27cc:     MB      off(IRQ).2, C          ; 27CC 0 080 132 C4183A
                STB     A, off(000cch)         ; 27CF 0 080 132 D4CC
                                               ; 27D1 from 27A6 (DD1,080,132)
                                               ; 27D1 from 27A8 (DD1,080,132)
                                               ; 27D1 from 27AF (DD1,080,132)
                                               ; 27D1 from 27B5 (DD1,080,132)
                                               ; 27D1 from 27BB (DD1,080,132)
label_27d1:     MOV     DP, #0018ah            ; 27D1 0 080 132 628A01
                MOV     X1, #032a9h            ; 27D4 0 080 132 60A932
                LB      A, 0a5h                ; 27D7 0 080 132 F5A5
                VCAL    1                      ; 27D9 0 080 132 11
                STB     A, r2                  ; 27DA 0 080 132 8A
                MOV     er0, #00800h           ; 27DB 0 080 132 44980008
                SUBB    A, off(0008ah)         ; 27DF 0 080 132 A78A
                STB     A, r3                  ; 27E1 0 080 132 8B
                MOV     X1, #00260h            ; 27E2 0 080 132 606002
                JGE     label_27ec             ; 27E5 0 080 132 CD05
                CLR     A                      ; 27E7 1 080 132 F9
                SUB     A, er3                 ; 27E8 1 080 132 2B
                MOV     X1, #00240h            ; 27E9 1 080 132 604002
                                               ; 27EC from 27E5 (DD0,080,132)
label_27ec:     CMP     A, X1                  ; 27EC 1 080 132 90C2
                L       A, er2                 ; 27EE 1 080 132 36
                JLT     label_27f4             ; 27EF 1 080 132 CA03
                ST      A, [DP]                ; 27F1 1 080 132 D2
                SJ      label_27f9             ; 27F2 1 080 132 CB05
                                               ; 27F4 from 27EF (DD1,080,132)
label_27f4:     CAL     label_2d56             ; 27F4 1 080 132 32562D
                CLR     er3                    ; 27F7 1 080 132 4715
                                               ; 27F9 from 27F2 (DD1,080,132)
label_27f9:     MOV     off(0008ch), er3       ; 27F9 1 080 132 477C8C
                JBS     off(TM0H).5, label_2817 ; 27FC 1 080 132 ED3118
                LB      A, 09bh                ; 27FF 0 080 132 F59B
                MOV     X1, #0345eh            ; 2801 0 080 132 605E34
                VCAL    7                      ; 2804 0 080 132 17
                CMPB    A, off(PWMC0)          ; 2805 0 080 132 C770
                JLT     label_2817             ; 2807 0 080 132 CA0E
                LB      A, 09bh                ; 2809 0 080 132 F59B
                MOV     X1, #03464h            ; 280B 0 080 132 606434
                VCAL    7                      ; 280E 0 080 132 17
                CMPB    A, off(PWMC0)          ; 280F 0 080 132 C770
                JGE     label_2817             ; 2811 0 080 132 CD04
                LB      A, off(000fah)         ; 2813 0 080 132 F4FA
                JEQ     label_2818             ; 2815 0 080 132 C901
                                               ; 2817 from 27FC (DD1,080,132)
                                               ; 2817 from 2807 (DD0,080,132)
                                               ; 2817 from 2811 (DD0,080,132)
label_2817:     RC                             ; 2817 0 080 132 95
                                               ; 2818 from 2815 (DD0,080,132)
label_2818:     MB      off(P4IO).0, C         ; 2818 0 080 132 C42D38
                VCAL    3                      ; 281B 0 080 132 13
                MOV     DP, #00278h            ; 281C 0 080 132 627802
                LB      A, [DP]                ; 281F 0 080 132 F2
                J       label_41e3             ; 2820 0 080 132 03E341
                                               ; 2823 from 41EC (DD0,080,132)
label_2823:     CMPB    0a6h, #086h            ; 2823 0 080 132 C5A6C086
                JGE     label_283b             ; 2827 0 080 132 CD12
                LB      A, 0ach                ; 2829 0 080 132 F5AC
                CMPB    A, #026h               ; 282B 0 080 132 C626
                JGE     label_283b             ; 282D 0 080 132 CD0C
                STB     A, r1                  ; 282F 0 080 132 89
                MOVB    r0, off(0009ch)        ; 2830 0 080 132 C49C48
                SUBB    A, r0                  ; 2833 0 080 132 28
                JLT     label_283a             ; 2834 0 080 132 CA04
                CMPB    A, #003h               ; 2836 0 080 132 C603
                JLT     label_2840             ; 2838 0 080 132 CA06
                                               ; 283A from 2834 (DD0,080,132)
label_283a:     LB      A, r1                  ; 283A 0 080 132 79
                                               ; 283B from 41EF (DD0,080,132)
                                               ; 283B from 2827 (DD0,080,132)
                                               ; 283B from 282D (DD0,080,132)
label_283b:     STB     A, off(0009ch)         ; 283B 0 080 132 D49C
                STB     A, r0                  ; 283D 0 080 132 88
                SJ      label_2853             ; 283E 0 080 132 CB13
                                               ; 2840 from 2838 (DD0,080,132)
label_2840:     LB      A, off(000d1h)         ; 2840 0 080 132 F4D1
                JNE     label_285f             ; 2842 0 080 132 CE1B
                LB      A, off(0009dh)         ; 2844 0 080 132 F49D
                ADDB    A, #004h               ; 2846 0 080 132 8604
                CMPB    A, r0                  ; 2848 0 080 132 48
                JLT     label_284c             ; 2849 0 080 132 CA01
                LB      A, r0                  ; 284B 0 080 132 78
                                               ; 284C from 2849 (DD0,080,132)
label_284c:     STB     A, [DP]                ; 284C 0 080 132 D2
                CMPB    A, off(0009dh)         ; 284D 0 080 132 C79D
                JGE     label_2853             ; 284F 0 080 132 CD02
                STB     A, off(0009dh)         ; 2851 0 080 132 D49D
                                               ; 2853 from 283E (DD0,080,132)
                                               ; 2853 from 284F (DD0,080,132)
label_2853:     LB      A, [DP]                ; 2853 0 080 132 F2
                JEQ     label_285b             ; 2854 0 080 132 C905
                CMPB    A, r0                  ; 2856 0 080 132 48
                LB      A, #00fh               ; 2857 0 080 132 770F
                JLT     label_285d             ; 2859 0 080 132 CA02
                                               ; 285B from 2854 (DD0,080,132)
label_285b:     LB      A, #002h               ; 285B 0 080 132 7702
                                               ; 285D from 2859 (DD0,080,132)
label_285d:     STB     A, off(000d1h)         ; 285D 0 080 132 D4D1
                                               ; 285F from 2842 (DD0,080,132)
label_285f:     JBR     off(P3SF).3, label_2880 ; 285F 0 080 132 DB2A1E
                LB      A, 0a3h                ; 2862 0 080 132 F5A3
                SB      off(00027h).7          ; 2864 0 080 132 C4271F
                JNE     label_286f             ; 2867 0 080 132 CE06
                MOV     X1, #03335h            ; 2869 0 080 132 603533
                VCAL    7                      ; 286C 0 080 132 17
                SJ      label_2892             ; 286D 0 080 132 CB23
                                               ; 286F from 2867 (DD0,080,132)
label_286f:     MOV     X1, #0332fh            ; 286F 0 080 132 602F33
                VCAL    7                      ; 2872 0 080 132 17
                L       A, off(00088h)         ; 2873 1 080 132 E488
                SUB     A, #00040h             ; 2875 1 080 132 A64000
                JLT     label_287d             ; 2878 1 080 132 CA03
                CMP     A, er3                 ; 287A 1 080 132 4B
                JGE     label_2892             ; 287B 1 080 132 CD15
                                               ; 287D from 2878 (DD1,080,132)
label_287d:     L       A, er3                 ; 287D 1 080 132 37
                SJ      label_2892             ; 287E 1 080 132 CB12
                                               ; 2880 from 285F (DD0,080,132)
label_2880:     L       A, #0fb00h   ;mugen -> #000h          ; 2880 1 080 132 6700FB
                RB      off(00027h).7          ; 2883 1 080 132 C4270F
                JNE     label_2892             ; 2886 1 080 132 CE0A
                L       A, off(00088h)         ; 2888 1 080 132 E488
                ADD     A, #00020h             ; 288A 1 080 132 862000
                ROL     A                      ; 288D 1 080 132 33
                JLT     label_2891             ; 288E 1 080 132 CA01
                CLR     A                      ; 2890 1 080 132 F9
                                               ; 2891 from 288E (DD1,080,132)
label_2891:     ROR     A                      ; 2891 1 080 132 43
                                               ; 2892 from 286D (DD0,080,132)
                                               ; 2892 from 2886 (DD1,080,132)
                                               ; 2892 from 287B (DD1,080,132)
                                               ; 2892 from 287E (DD1,080,132)
label_2892:     ST      A, off(00088h)         ; 2892 1 080 132 D488
                J       label_1ec6             ; 2894 1 080 132 03C61E
                                               ; 2897 from 153F (DD0,200,???)
                                               ; 2897 from 1565 (DD0,200,???)
                                               ; 2897 from 15A2 (DD0,200,???)
                                               ; 2897 from 28A1 (DD0,200,???)
                                               ; 2897 from 15BD (DD1,200,???)
label_2897:     CMP     TM0, #0000dh           ; 2897 0 200 ??? B530C00D00
                JGE     label_28a8             ; 289C 0 200 ??? CD0A
                RB      IRQ.7                  ; 289E 0 200 ??? C5180F
                JEQ     label_2897             ; 28A1 0 200 ??? C9F4
                SCAL    label_28bb             ; 28A3 0 200 ??? 3116
                MOV     LRB, #00040h           ; 28A5 0 200 ??? 574000
                                               ; 28A8 from 289C (DD0,200,???)
                                               ; 28A8 from 28AD (DD0,200,???)
label_28a8:     CMP     TM0, #00018h           ; 28A8 0 200 ??? B530C01800
                JLT     label_28a8             ; 28AD 0 200 ??? CAF9
                RT                             ; 28AF 0 200 ??? 01
                                               ; 28B0 from 154A (DD1,200,???)
                                               ; 28B0 from 1570 (DD1,200,???)
                                               ; 28B0 from 15AD (DD1,200,???)
label_28b0:     RB      IRQ.7                  ; 28B0 1 200 ??? C5180F
                JEQ     label_28ba             ; 28B3 1 200 ??? C905
                SCAL    label_28bb             ; 28B5 1 200 ??? 3104
                MOV     LRB, #00040h           ; 28B7 1 200 ??? 574000
                                               ; 28BA from 28B3 (DD1,200,???)
label_28ba:     RT                             ; 28BA 1 200 ??? 01
                                               ; 28BB from 00CD (DD0,???,???)
                                               ; 28BB from 28A3 (DD0,200,???)
                                               ; 28BB from 28B5 (DD1,200,???)
label_28bb:     CLR     LRB                    ; 28BB 0 ??? ??? A415
                LB      A, 0e4h                ; 28BD 0 ??? ??? F5E4
                JEQ     label_28e2             ; 28BF 0 ??? ??? C921
                CMPB    A, #001h               ; 28C1 0 ??? ??? C601
                JNE     label_28ef             ; 28C3 0 ??? ??? CE2A
                MOV     off(07ffb0h), ADCR5    ; 28C5 0 ??? ??? B56A7CB0
                LB      A, 0dfh                ; 28C9 0 ??? ??? F5DF
                ADDB    A, #001h               ; 28CB 0 ??? ??? 8601
                CMPB    A, #003h               ; 28CD 0 ??? ??? C603
                JGE     label_290d             ; 28CF 0 ??? ??? CD3C
                SB      TCON2.2                ; 28D1 0 ??? ??? C5421A
                L       A, 0dah                ; 28D4 1 ??? ??? E5DA
                CMP     A, #0001eh             ; 28D6 1 ??? ??? C61E00
                JGE     label_28de             ; 28D9 1 ??? ??? CD03
                L       A, #0001eh             ; 28DB 1 ??? ??? 671E00
                                               ; 28DE from 28D9 (DD1,???,???)
label_28de:     ADD     A, off(07ff36h)        ; 28DE 1 ??? ??? 8736
                SJ      label_2937             ; 28E0 1 ??? ??? CB55
                                               ; 28E2 from 28BF (DD0,???,???)
label_28e2:     MOV     off(07ffb0h), ADCR5    ; 28E2 0 ??? ??? B56A7CB0
                CMPB    A, off(07ffdfh)        ; 28E6 0 ??? ??? C7DF
                JNE     label_28f9             ; 28E8 0 ??? ??? CE0F
                                               ; 28EA from 28F3 (DD0,???,???)
label_28ea:     SB      TCON2.2                ; 28EA 0 ??? ??? C5421A
                SJ      label_2901             ; 28ED 0 ??? ??? CB12
                                               ; 28EF from 28C3 (DD0,???,???)
label_28ef:     CMPB    A, #002h               ; 28EF 0 ??? ??? C602
                JEQ     label_291e             ; 28F1 0 ??? ??? C92B
                JBS     off(07ffdfh).2, label_28ea ; 28F3 0 ??? ??? EADFF4
                RB      TCON2.2                ; 28F6 0 ??? ??? C5420A
                                               ; 28F9 from 28E8 (DD0,???,???)
label_28f9:     ADDB    A, #001h               ; 28F9 0 ??? ??? 8601
                ANDB    A, #003h               ; 28FB 0 ??? ??? D603
                CMPB    A, off(07ffdfh)        ; 28FD 0 ??? ??? C7DF
                JEQ     label_2913             ; 28FF 0 ??? ??? C912
                                               ; 2901 from 28ED (DD0,???,???)
                                               ; 2901 from 290A (DD0,???,???)
label_2901:     L       A, TM2                 ; 2901 1 ??? ??? E538
                SUB     A, #00001h             ; 2903 1 ??? ??? A60100
                ST      A, TMR2                ; 2906 1 ??? ??? D53A
                SJ      label_293c             ; 2908 1 ??? ??? CB32
                                               ; 290A from 291E (DD0,???,???)
label_290a:     JBR     off(07ff42h).3, label_2901 ; 290A 0 ??? ??? DB42F4
                                               ; 290D from 28CF (DD0,???,???)
label_290d:     L       A, TMR1                ; 290D 1 ??? ??? E536
                ADD     A, off(07ffdah)        ; 290F 1 ??? ??? 87DA
                ST      A, 0dch                ; 2911 1 ??? ??? D5DC
                                               ; 2913 from 28FF (DD0,???,???)
label_2913:     L       A, TMR1                ; 2913 1 ??? ??? E536
                ADD     A, off(07ffd8h)        ; 2915 1 ??? ??? 87D8
                ST      A, TMR2                ; 2917 1 ??? ??? D53A
                SB      TCON2.3                ; 2919 1 ??? ??? C5421B
                SJ      label_293c             ; 291C 1 ??? ??? CB1E
                                               ; 291E from 28F1 (DD0,???,???)
label_291e:     JBR     off(07ff42h).2, label_290a ; 291E 0 ??? ??? DA42E9
                L       A, TM2                 ; 2921 1 ??? ??? E538
                SUB     A, off(07ff36h)        ; 2923 1 ??? ??? A736
                ADD     A, #00005h             ; 2925 1 ??? ??? 860500
                CMP     A, off(07ffdah)        ; 2928 1 ??? ??? C7DA
                JGE     label_2932             ; 292A 1 ??? ??? CD06
                L       A, TMR1                ; 292C 1 ??? ??? E536
                ADD     A, off(07ffdah)        ; 292E 1 ??? ??? 87DA
                SJ      label_2937             ; 2930 1 ??? ??? CB05
                                               ; 2932 from 292A (DD1,???,???)
label_2932:     L       A, TM2                 ; 2932 1 ??? ??? E538
                ADD     A, #00003h             ; 2934 1 ??? ??? 860300
                                               ; 2937 from 28E0 (DD1,???,???)
                                               ; 2937 from 2930 (DD1,???,???)
label_2937:     ST      A, TMR2                ; 2937 1 ??? ??? D53A
                RB      TCON2.3                ; 2939 1 ??? ??? C5420B
                                               ; 293C from 2908 (DD1,???,???)
                                               ; 293C from 291C (DD1,???,???)
label_293c:     RB      IRQH.1                 ; 293C 1 ??? ??? C51909
                SB      IRQ.5                  ; 293F 1 ??? ??? C5181D
                RT                             ; 2942 1 ??? ??? 01


                ; 2943 from 0124 called after ADCR5 goes into B0h
                                               ; 2943 from 031D (DD0,???,???)
label_2943:     JBS     off(07ff31h).6, label_2956 ; 2943 0 ??? ??? EE3110
                JBS     off(07ff21h).1, label_2956 ; 2946 0 ??? ??? E9210D
                L       A, #000dch             ; 2949 1 ??? ??? 67DC00
                CMP     A, 0bah                ; 294C 1 ??? ??? B5BAC2
                JGE     label_2957             ; 294F 1 ??? ??? CD06
                RB      TRNSIT.1               ; 2951 1 ??? ??? C54609
                JEQ     label_295b             ; 2954 1 ??? ??? C905
                                               ; 2956 from 2943 (DD0,???,???)
                                               ; 2956 from 2946 (DD0,???,???)
label_2956:     RC                             ; 2956 1 ??? ??? 95
                                               ; 2957 from 294F (DD1,???,???)
label_2957:     MOVB    off(07ffc1h), #006h    ; 2957 1 ??? ??? C4C19806
                                               ; 295B from 2954 (DD1,???,???)
label_295b:     MB      off(07ff2eh).3, C      ; 295B 1 ??? ??? C42E3B
                RT                             ; 295E 1 ??? ??? 01
                                               ; 295F from 0287 (DD1,???,???)
                                               ; 295F from 09B7 (DD1,108,13C)
label_295f:     MOV     LRB, #00040h           ; 295F 1 200 ??? 574000
                LB      A, 0e6h                ; 2962 0 200 ??? F5E6
                JEQ     label_297b             ; 2964 0 200 ??? C915
                SUBB    A, #001h               ; 2966 0 200 ??? A601
                STB     A, 0e6h                ; 2968 0 200 ??? D5E6
                CMPB    A, #003h               ; 296A 0 200 ??? C603
                JEQ     label_297b             ; 296C 0 200 ??? C90D
                LB      A, off(0021ah)         ; 296E 0 200 ??? F41A
                MB      C, ACC.7               ; 2970 0 200 ??? C5062F
                ROLB    A                      ; 2973 0 200 ??? 33
                STB     A, off(0021ah)         ; 2974 0 200 ??? D41A
                XORB    A, #0ffh               ; 2976 0 200 ??? F6FF
                STB     A, off(0021bh)         ; 2978 0 200 ??? D41B
                RT                             ; 297A 0 200 ??? 01
                                               ; 297B from 2964 (DD0,200,???)
                                               ; 297B from 296C (DD0,200,???)
label_297b:     MOVB    r0, #0ffh              ; 297B 0 200 ??? 98FF
                L       A, 0d6h                ; 297D 1 200 ??? E5D6
                MOV     X1, A                  ; 297F 1 200 ??? 50
                MB      C, 0f2h.6              ; 2980 1 200 ??? C5F22E
                JLT     label_2988             ; 2983 1 200 ??? CA03
                JNE     label_2988             ; 2985 1 200 ??? CE01
                SC                             ; 2987 1 200 ??? 85
                                               ; 2988 from 2983 (DD1,200,???)
                                               ; 2988 from 2985 (DD1,200,???)
label_2988:     MB      PSWL.4, C              ; 2988 1 200 ??? A33C
                CMPB    off(0021ch), #00fh     ; 298A 1 200 ??? C41CC00F
                JNE     label_29dc             ; 298E 1 200 ??? CE4C
                MOV     USP, #00214h           ; 2990 1 200 214 A1981402
                MOV     DP, #000d0h            ; 2994 1 200 214 62D000
                L       A, [DP]                ; 2997 1 200 214 E2
                JNE     label_29b3             ; 2998 1 200 214 CE19
                INC     DP                     ; 299A 1 200 214 72
                INC     DP                     ; 299B 1 200 214 72
                L       A, [DP]                ; 299C 1 200 214 E2
                JNE     label_29c5             ; 299D 1 200 214 CE26
                INC     DP                     ; 299F 1 200 214 72
                INC     DP                     ; 29A0 1 200 214 72
                L       A, [DP]                ; 29A1 1 200 214 E2
                JEQ     label_29dc             ; 29A2 1 200 214 C938
                MOV     X1, A                  ; 29A4 1 200 214 50
                MB      C, off(0021bh).0       ; 29A5 1 200 214 C41B28
                RORB    off(0021bh)            ; 29A8 1 200 214 C41BC7
                                               ; 29AB from 29DA (DD0,200,214)
label_29ab:     CAL     label_2aca             ; 29AB 1 200 214 32CA2A
                ANDB    r0, off(0021ah)        ; 29AE 1 200 214 20D31A
                SJ      label_29dc             ; 29B1 1 200 214 CB29
                                               ; 29B3 from 2998 (DD1,200,214)
label_29b3:     MOV     X1, A                  ; 29B3 1 200 214 50
                MB      C, off(0021bh).7       ; 29B4 1 200 214 C41B2F
                ROLB    off(0021bh)            ; 29B7 1 200 214 C41BB7
                CAL     label_2aca             ; 29BA 1 200 214 32CA2A
                LB      A, off(0021ah)         ; 29BD 0 200 214 F41A
                SRLB    A                      ; 29BF 0 200 214 63
                SRLB    A                      ; 29C0 0 200 214 63
                ANDB    r0, A                  ; 29C1 0 200 214 20D1
                SJ      label_29d2             ; 29C3 0 200 214 CB0D
                                               ; 29C5 from 299D (DD1,200,214)
label_29c5:     MOV     X1, A                  ; 29C5 1 200 214 50
                MB      C, off(0021bh).7       ; 29C6 1 200 214 C41B2F
                ROLB    off(0021bh)            ; 29C9 1 200 214 C41BB7
                MB      C, off(0021bh).7       ; 29CC 1 200 214 C41B2F
                ROLB    off(0021bh)            ; 29CF 1 200 214 C41BB7
                                               ; 29D2 from 29C3 (DD0,200,214)
label_29d2:     CAL     label_2aca             ; 29D2 1 200 214 32CA2A
                LB      A, off(0021ah)         ; 29D5 0 200 214 F41A
                SRLB    A                      ; 29D7 0 200 214 63
                ANDB    r0, A                  ; 29D8 0 200 214 20D1
                SJ      label_29ab             ; 29DA 0 200 214 CBCF
                                               ; 29DC from 298E (DD1,200,???)
                                               ; 29DC from 29A2 (DD1,200,214)
                                               ; 29DC from 29B1 (DD1,200,214)
label_29dc:     LB      A, off(0021ah)         ; 29DC 0 200 ??? F41A
                SLLB    A                      ; 29DE 0 200 ??? 53
                SWAPB                          ; 29DF 0 200 ??? 83
                ANDB    A, r0                  ; 29E0 0 200 ??? 58
                ORB     A, #0f0h               ; 29E1 0 200 ??? E6F0
                STB     A, r0                  ; 29E3 0 200 ??? 88
                L       A, #0001ah             ; 29E4 1 200 ??? 671A00
                SUB     A, X1                  ; 29E7 1 200 ??? 90A2
                MOV     X1, A                  ; 29E9 1 200 ??? 50
                                               ; 29EA from 29FA (DD0,200,???)
label_29ea:     RB      PSWH.0                 ; 29EA 1 200 ??? A208
                LB      A, off(0021ch)         ; 29EC 0 200 ??? F41C
                JNE     label_2a2b             ; 29EE 0 200 ??? CE3B
                SB      IRQ.4                  ; 29F0 0 200 ??? C5181C
                MOV     TM0, #0000ch           ; 29F3 0 200 ??? B530980C00
                SB      PSWH.0                 ; 29F8 0 200 ??? A218
                SJ      label_29ea             ; 29FA 0 200 ??? CBEE
                                               ; 29FC from 2A33 (DD0,200,???)
label_29fc:     RB      TCON0.4                ; 29FC 0 200 ??? C5400C
                LB      A, #00fh               ; 29FF 0 200 ??? 770F
                STB     A, off(0021ch)         ; 2A01 0 200 ??? D41C
                ORB     P2, A                  ; 2A03 0 200 ??? C524E1
                LB      A, off(0021ah)         ; 2A06 0 200 ??? F41A
                XORB    A, #0ffh               ; 2A08 0 200 ??? F6FF
                STB     A, off(0021bh)         ; 2A0A 0 200 ??? D41B
                RB      IRQ.4                  ; 2A0C 0 200 ??? C5180C
                MOV     off(00214h), #0ffffh   ; 2A0F 0 200 ??? B41498FFFF
                SJ      label_2a7e             ; 2A14 0 200 ??? CB68
                                               ; 2A16 from 2A37 (DD0,200,???)
label_2a16:     LB      A, r0                  ; 2A16 0 200 ??? 78
                ANDB    off(0021ch), A         ; 2A17 0 200 ??? C41CD1
                MB      C, 0f2h.7              ; 2A1A 0 200 ??? C5F22F
                JLT     label_2a22             ; 2A1D 0 200 ??? CA03
                ANDB    P2, A                  ; 2A1F 0 200 ??? C524D1
                                               ; 2A22 from 2A1D (DD0,200,???)
label_2a22:     L       A, X1                  ; 2A22 1 200 ??? 40
                ST      A, TM0                 ; 2A23 1 200 ??? D530
                SB      TCON0.4                ; 2A25 1 200 ??? C5401C
                J       label_2ac7             ; 2A28 1 200 ??? 03C72A
                                               ; 2A2B from 29EE (DD0,200,???)
label_2a2b:     MB      C, off(0021ah).7       ; 2A2B 0 200 ??? C41A2F
                ROLB    off(0021ah)            ; 2A2E 0 200 ??? C41AB7
                MB      C, PSWL.4              ; 2A31 0 200 ??? A32C
                JLT     label_29fc             ; 2A33 0 200 ??? CAC7
                CMPB    A, #00fh               ; 2A35 0 200 ??? C60F
                JEQ     label_2a16             ; 2A37 0 200 ??? C9DD
                STB     A, r1                  ; 2A39 0 200 ??? 89
                LB      A, r0                  ; 2A3A 0 200 ??? 78
                ANDB    off(0021ch), A         ; 2A3B 0 200 ??? C41CD1
                MB      C, 0f2h.7              ; 2A3E 0 200 ??? C5F22F
                JGE     label_2a48             ; 2A41 0 200 ??? CD05
                SJ      label_2a4b             ; 2A43 0 200 ??? CB06
                DB  000h,0CAh,003h ; 2A45
                                               ; 2A48 from 2A41 (DD0,200,???)
label_2a48:     ANDB    P2, A                  ; 2A48 0 200 ??? C524D1
                                               ; 2A4B from 2A43 (DD0,200,???)
label_2a4b:     L       A, TM0                 ; 2A4B 1 200 ??? E530
                ADD     A, 0d6h                ; 2A4D 1 200 ??? B5D682
                JLT     label_2a55             ; 2A50 1 200 ??? CA03
                MB      C, IRQ.4               ; 2A52 1 200 ??? C5182C
                                               ; 2A55 from 2A50 (DD1,200,???)
label_2a55:     JBR     off(00201h).0, label_2a63 ; 2A55 1 200 ??? D8010B
                JBR     off(00201h).1, label_2aa7 ; 2A58 1 200 ??? D9014C
                JBS     off(00201h).2, label_2a6c ; 2A5B 1 200 ??? EA010E
                JBR     off(00201h).3, label_2a8b ; 2A5E 1 200 ??? DB012A
                SJ      label_2a6c             ; 2A61 1 200 ??? CB09
                                               ; 2A63 from 2A55 (DD1,200,???)
label_2a63:     JBR     off(00201h).1, label_2a85 ; 2A63 1 200 ??? D9011F
                JBR     off(00201h).2, label_2aad ; 2A66 1 200 ??? DA0144
                JBR     off(00201h).3, label_2a8b ; 2A69 1 200 ??? DB011F
                                               ; 2A6C from 2A5B (DD1,200,???)
                                               ; 2A6C from 2A61 (DD1,200,???)
                                               ; 2A6C from 2AA7 (DD1,200,???)
label_2a6c:     JGE     label_2a78             ; 2A6C 1 200 ??? CD0A
                SUB     A, #00033h             ; 2A6E 1 200 ??? A63300
                JLT     label_2a78             ; 2A71 1 200 ??? CA05
                CMP     A, #000c0h             ; 2A73 1 200 ??? C6C000
                JGE     label_2a79             ; 2A76 1 200 ??? CD01
                                               ; 2A78 from 2A6C (DD1,200,???)
                                               ; 2A78 from 2A71 (DD1,200,???)
label_2a78:     CLR     A                      ; 2A78 1 200 ??? F9
                                               ; 2A79 from 2A76 (DD1,200,???)
label_2a79:     ST      A, er0                 ; 2A79 1 200 ??? 88
                CLR     A                      ; 2A7A 1 200 ??? F9
                SUB     A, er0                 ; 2A7B 1 200 ??? 28
                ST      A, off(00214h)         ; 2A7C 1 200 ??? D414
                                               ; 2A7E from 2A14 (DD0,200,???)
label_2a7e:     L       A, #0ffffh             ; 2A7E 1 200 ??? 67FFFF
                ST      A, off(00216h)         ; 2A81 1 200 ??? D416
                SJ      label_2ac5             ; 2A83 1 200 ??? CB40
                                               ; 2A85 from 2A63 (DD1,200,???)
label_2a85:     JBR     off(00201h).2, label_2aad ; 2A85 1 200 ??? DA0125
                JBR     off(00201h).3, label_2aad ; 2A88 1 200 ??? DB0122
                                               ; 2A8B from 2A5E (DD1,200,???)
                                               ; 2A8B from 2A69 (DD1,200,???)
                                               ; 2A8B from 2AAA (DD1,200,???)
label_2a8b:     JGE     label_2a9b             ; 2A8B 1 200 ??? CD0E
                ADD     A, off(00214h)         ; 2A8D 1 200 ??? 8714
                JGE     label_2a9b             ; 2A8F 1 200 ??? CD0A
                SUB     A, #0004eh             ; 2A91 1 200 ??? A64E00
                JLT     label_2a9b             ; 2A94 1 200 ??? CA05
                CMP     A, #000c0h             ; 2A96 1 200 ??? C6C000
                JGE     label_2a9c             ; 2A99 1 200 ??? CD01
                                               ; 2A9B from 2A8B (DD1,200,???)
                                               ; 2A9B from 2A8F (DD1,200,???)
                                               ; 2A9B from 2A94 (DD1,200,???)
label_2a9b:     CLR     A                      ; 2A9B 1 200 ??? F9
                                               ; 2A9C from 2A99 (DD1,200,???)
label_2a9c:     ST      A, er0                 ; 2A9C 1 200 ??? 88
                CLR     A                      ; 2A9D 1 200 ??? F9
                SUB     A, er0                 ; 2A9E 1 200 ??? 28
                ST      A, off(00216h)         ; 2A9F 1 200 ??? D416
                L       A, #0ffffh             ; 2AA1 1 200 ??? 67FFFF
                J       label_2ac5             ; 2AA4 1 200 ??? 03C52A
                                               ; 2AA7 from 2A58 (DD1,200,???)
label_2aa7:     JBS     off(00201h).2, label_2a6c ; 2AA7 1 200 ??? EA01C2
                JBS     off(00201h).3, label_2a8b ; 2AAA 1 200 ??? EB01DE
                                               ; 2AAD from 2A66 (DD1,200,???)
                                               ; 2AAD from 2A85 (DD1,200,???)
                                               ; 2AAD from 2A88 (DD1,200,???)
label_2aad:     JGE     label_2ac1             ; 2AAD 1 200 ??? CD12
                ADD     A, off(00214h)         ; 2AAF 1 200 ??? 8714
                JGE     label_2ac1             ; 2AB1 1 200 ??? CD0E
                ADD     A, off(00216h)         ; 2AB3 1 200 ??? 8716
                JGE     label_2ac1             ; 2AB5 1 200 ??? CD0A
                SUB     A, #00068h             ; 2AB7 1 200 ??? A66800
                JLT     label_2ac1             ; 2ABA 1 200 ??? CA05
                CMP     A, #000c0h             ; 2ABC 1 200 ??? C6C000
                JGE     label_2ac2             ; 2ABF 1 200 ??? CD01
                                               ; 2AC1 from 2AAD (DD1,200,???)
                                               ; 2AC1 from 2AB1 (DD1,200,???)
                                               ; 2AC1 from 2AB5 (DD1,200,???)
                                               ; 2AC1 from 2ABA (DD1,200,???)
label_2ac1:     CLR     A                      ; 2AC1 1 200 ??? F9
                                               ; 2AC2 from 2ABF (DD1,200,???)
label_2ac2:     ST      A, er0                 ; 2AC2 1 200 ??? 88
                CLR     A                      ; 2AC3 1 200 ??? F9
                SUB     A, er0                 ; 2AC4 1 200 ??? 28
                                               ; 2AC5 from 2A83 (DD1,200,???)
                                               ; 2AC5 from 2AA4 (DD1,200,???)
label_2ac5:     ST      A, off(00218h)         ; 2AC5 1 200 ??? D418
                                               ; 2AC7 from 2A28 (DD1,200,???)
label_2ac7:     SB      PSWH.0                 ; 2AC7 1 200 ??? A218
                RT                             ; 2AC9 1 200 ??? 01
                                               ; 2ACA from 29AB (DD1,200,214)
                                               ; 2ACA from 29BA (DD1,200,214)
                                               ; 2ACA from 29D2 (DD1,200,214)
label_2aca:     L       A, [DP]                ; 2ACA 1 200 214 E2
                CLR     [DP]                   ; 2ACB 1 200 214 B215
                INC     DP                     ; 2ACD 1 200 214 72
                INC     DP                     ; 2ACE 1 200 214 72
                SUB     A, [DP]                ; 2ACF 1 200 214 B2A2
                JGE     label_2add             ; 2AD1 1 200 214 CD0A
                ADD     A, #0001ah             ; 2AD3 1 200 214 861A00
                JLT     label_2add             ; 2AD6 1 200 214 CA05
                CMP     A, #0ff40h             ; 2AD8 1 200 214 C640FF
                JLT     label_2ade             ; 2ADB 1 200 214 CA01
                                               ; 2ADD from 2AD1 (DD1,200,214)
                                               ; 2ADD from 2AD6 (DD1,200,214)
label_2add:     CLR     A                      ; 2ADD 1 200 214 F9
                                               ; 2ADE from 2ADB (DD1,200,214)
label_2ade:     ST      A, (00214h-00214h)[USP] ; 2ADE 1 200 214 D300
                INC     USP                    ; 2AE0 1 200 215 A116
                INC     USP                    ; 2AE2 1 200 216 A116
                RT                             ; 2AE4 1 200 216 01
                                               ; 2AE5 from 24D1 (DD0,080,205)
                                               ; 2AE5 from 24F0 (DD0,080,205)
label_2ae5:     MOVB    r6, #077h              ; 2AE5 0 080 205 9E77
                JEQ     label_2af1             ; 2AE7 0 080 205 C908
                                               ; 2AE9 from 2AEF (DD0,080,205)
label_2ae9:     MB      C, r6.7                ; 2AE9 0 080 205 262F
                ROLB    r6                     ; 2AEB 0 080 205 26B7
                SUBB    A, #001h               ; 2AED 0 080 205 A601
                JNE     label_2ae9             ; 2AEF 0 080 205 CEF8
                                               ; 2AF1 from 2AE7 (DD0,080,205)
label_2af1:     LB      A, r6                  ; 2AF1 0 080 205 7E
                RT                             ; 2AF2 0 080 205 01

;***************************************************************************
;table interpolation routine
                ; 2AF3 from 0773 ignition map in X1, scalars in X2, PSWL.5 set
				; 2AF3 from 0AEA non vtec fuel map
				; 2AF3 from 0B0C vtec fuel map

label_2af3:     CLR     A						;
                LB      A, r6					; load map column (r6 has [0b5h])

                ;gets the value for interp for later
                MOVB	r6, 0b4h				;
                ;sets the column
                ADD     X1, A                  ; add column to table pointer
                MB      C, PSWL.5              ; move ignition/fuel falg into c
                JLT     label_2b0a             ; if ignition the skip the fuel mult stuff

                ;does this only if fuel map
                LCB     A, 00165h[X1]          ; load [mapsize+X1] into A (column mult)
                MOV     DP, A                  ; move it into DP
                CMPCB   A, 00166h[X1]          ; move next column multiplier
                MB      C, zp_PSWH.6           ; ??
                                               ; 2B0A from 2AFC (DD0,108,20E)
label_2b0a:     MB      PSWL.4, C              ; move the zp_PSWH.6 into PSWL.4
                MOVB    r0, #010h              ; move 16 into r0
                                               ; 2B0E from 2B16 (DD0,108,20E)
label_2b0e:     DECB    r0                     ; r0--
                DEC     X2                     ; X2--
                LCB     A, 00000h[X2]          ; load [X2] into A
                ADDB    r7, A                  ; add it to r7
                JGE     label_2b0e             ; loop until r7> ffh
                ;r0 has the current row...

                CAL 	storerow				;store the current row
                ;MOV     X2, A                  ;
                ;SLL     X2                     ;

                LB      A, #015h               ; load 15h into A (#columns)
                MULB                           ; A = (# columns)*(current row)
                ADD     X1, A                  ; add A to the table pointer. point at current cell
                CLR     A                      ; A = 0
                LCB     A, [X1]                ; load current cell
                ST      A, er0                 ; store into er0
                LCB     A, 00015h[X1]          ; load south cell
                MOV     USP, A                 ; store into USP
                INC     X1                     ; X1++
                LCB     A, [X1]                ; load east cell
                ST      A, er1                 ; store into er1
                LCB     A, 00015h[X1]          ; load south east cell
                MOV     X1, A                  ; store into X1
                MB      C, PSWL.4              ; get flag back (1 if ign map, ? if fuel)
                JLT     label_2b3c             ; if 1 jump
                SLL     er1                    ; else east cell*=2
                SLL     X1                     ; and south east cell*=2
                                               ;
                                               ;
label_2b3c:     SCAL    label_2b63             ; interp b/t cur cell and east cell
                MOV     er0, USP               ; move south cell into er0
                MOV     er1, X1                ; move southeast cell into er1
                MOV     X1, A                  ; move interp result into X1
                SCAL    label_2b63             ; interp b/t south and south east
                MOVB    r0, r7                 ;
                MOVB    r1, #000h              ; 2B47 1 108 20E 9900
                MB      C, off(00129h).2       ; C = some vtec bit
                ROL     er0                    ; 2B4C 1 108 20E 44B7
                MOV     er2, X2                ; 2B4E 1 108 20E 914A
                MOV     er3, X1                ; 2B50 1 108 20E 904B
                CAL     label_2c32             ; jump into vcal_1
                RB      PSWL.5                 ; if ign map
                JNE     label_2b61             ; jump to exit
                L       A, DP                  ; else check if multiplier == 0
                JEQ     label_2b61             ; if so jump to exit
                L       A, er3                 ; else load interp result
                							   ;
label_2b5d:     SLL     A                      ; for(DP = mult; DP>0; DP--)
                JRNZ    DP, label_2b5d         ;    A*=2;
                ST      A, er3                 ; store into result
                							   ;
label_2b61:     L       A, er3                 ; load result
                RT                             ; return

;*****************************************************************************
                                               ; 2B63 from 2B3C (DD1,108,20E)
                                               ; 2B63 from 2B43 (DD1,108,20E)
label_2b63:     LB      A, r6                  ; 2B63 0 108 20E 7E
                SWAPB                          ; 2B64 0 108 20E 83
                EXTND                          ; 2B65 1 108 20E F8
                SWAP                           ; 2B66 1 108 20E 83
                AND     A, #0f000h             ; 2B67 1 108 20E D600F0
                XCHG    A, er0                 ; 2B6A 1 108 20E 4410
                ST      A, er2                 ; 2B6C 1 108 20E 8A
                SUB     A, er1                 ; 2B6D 1 108 20E 29
                JGE     label_2b73             ; 2B6E 1 108 20E CD03
                ST      A, er1                 ; 2B70 1 108 20E 89
                CLR     A                      ; 2B71 1 108 20E F9
                SUB     A, er1                 ; 2B72 1 108 20E 29
                                               ; 2B73 from 2B6E (DD1,108,20E)
label_2b73:     MUL                            ; 2B73 1 108 20E 9035
                L       A, er2                 ; 2B75 1 108 20E 36
                JGE     label_2b7a             ; 2B76 1 108 20E CD02
                ADD     A, er1                 ; 2B78 1 108 20E 09
                RT                             ; 2B79 1 108 20E 01
                                               ; 2B7A from 2B76 (DD1,108,20E)
label_2b7a:     SUB     A, er1                 ; 2B7A 1 108 20E 29
                RT                             ; 2B7B 1 108 20E 01

;****************************************************************************
;called on fuel maps
                                               ; 2B7C from 0AED non vtec fuel map
                                               ; 2B7C from 0B0F vtec fuel map
label_2b7c:     STB     A, r0                  ; 2B7C 0 108 13C 88
                L       A, off(00160h)         ; o2 sensor trim?
                MUL                            ; 2B7F 1 108 13C 9035
                ROL     A                      ; 2B81 1 108 13C 33
                L       A, er1                 ; 2B82 1 108 13C 35
                ROL     A                      ; 2B83 1 108 13C 33
                RT                             ; 2B84 1 108 13C 01
;****************************************************************************
                                               ; 2B85 from 113A (DD0,108,13C)
label_2b85:     LB      A, 0a4h                ; load temp
                VCAL    0                      ; interpolate
                STB     A, r5                  ; 2B88 0 108 13C 8D
                MOV     X1, X2                 ; 2B89 0 108 13C 9178
                                               ; 2B8B from 112F (DD0,108,13C)
label_2b8b:     LB      A, 0a4h                ; 2B8B 0 108 13C F5A4
                VCAL    0                      ; 2B8D 0 108 13C 10
                STB     A, r7                  ; 2B8E 0 108 13C 8F
                MOVB    r6, r5                 ; 2B8F 0 108 13C 254E
                                               ; 2B91 from 4178 (DD0,108,13C)
label_2b91:     MOV     X1, #02f76h            ; 2B91 0 108 13C 60762F
                JBS     off(00118h).7, label_2b98 ; 2B94 0 108 13C EF1801
                INC     X1                     ; 2B97 0 108 13C 70
                                               ; 2B98 from 0816 (DD0,108,20E)
                                               ; 2B98 from 2B94 (DD0,108,13C)
label_2b98:     LB      A, 0b3h                ; 2B98 0 108 20E F5B3
                CMPCB   A, [X1]                ; 2B9A 0 108 20E 90AE
                JLT     label_2ba0             ; 2B9C 0 108 20E CA02
                LCB     A, [X1]                ; 2B9E 0 108 20E 90AA
                                               ; 2BA0 from 2B9C (DD0,108,20E)
label_2ba0:     CMPCB   A, 00002h[X1]          ; 2BA0 0 108 20E 90AF0200
                JGE     label_2baa             ; 2BA4 0 108 20E CD04
                LCB     A, 00002h[X1]          ; 2BA6 0 108 20E 90AB0200
                                               ; 2BAA from 2BA4 (DD0,108,20E)
label_2baa:     STB     A, r0                  ; 2BAA 0 108 20E 88
                SJ      label_2bc2             ; 2BAB 0 108 20E CB15
                                               ; 2BAD from 0824 (DD0,108,20E)
                                               ; 2BAD from 07CE (DD0,108,20E)
                                               ; 2BAD from 2BB5 (DD0,108,20E)
                                               ; 2BAD from 0864 (DD0,108,3153)
                                               ; 2BAD from 0892 (DD0,108,3153)
                                               ; 2BAD from 2146 (DD0,080,0A3)
                                               ; 2BAD from 0903 (DD0,108,13C)
                                               ; 2BAD from 090A (DD0,108,13C)
                                               ; 2BAD from 09F4 (DD0,108,13C)
                                               ; 2BAD from 2265 (DD0,080,0A4)
                                               ; 2BAD from 418C (DD0,108,13C)
                                               ; 2BAD from 4193 (DD0,108,13C)
                                               ; 2BAD from 0C27 (DD0,108,13C)
                                               ; 2BAD from 0CC7 (DD0,108,13C)
                                               ; 2BAD from 2457 (DD0,080,205)
                                               ; 2BAD from 2B8D (DD0,108,13C)
                                               ; 2BAD from 4163 (DD0,108,13C)
                                               ; 2BAD from 4175 (DD0,108,13C)
                                               ; 2BAD from 2B87 (DD0,108,13C)
                                               ; 2BAD from 1479 (DD0,108,13C)
vcal_0:         CMPCB   A, 00002h[X1]          ; 2BAD 0 108 20E 90AF0200
                JGE     label_2bb7             ; 2BB1 0 108 20E CD04
                INC     X1                     ; 2BB3 0 108 20E 70
                INC     X1                     ; 2BB4 0 108 20E 70
                SJ      vcal_0                 ; 2BB5 0 108 20E CBF6
                                               ; 2BB7 from 2BF7 (DD0,108,20E)
                                               ; 2BB7 from 2BB1 (DD0,108,20E)
label_2bb7:     STB     A, r0                  ; 2BB7 0 108 20E 88
                LCB     A, 00003h[X1]          ; 2BB8 0 108 20E 90AB0300
                STB     A, r6                  ; 2BBC 0 108 20E 8E
                LCB     A, 00001h[X1]          ; 2BBD 0 108 20E 90AB0100
                STB     A, r7                  ; 2BC1 0 108 20E 8F
                                               ; 2BC2 from 2BAB (DD0,108,20E)
label_2bc2:     LCB     A, 00002h[X1]          ; 2BC2 0 108 20E 90AB0200
                STB     A, r1                  ; 2BC6 0 108 20E 89
                SUBB    r0, A                  ; 2BC7 0 108 20E 20A1
                LCB     A, [X1]                ; 2BC9 0 108 20E 90AA
                SUBB    A, r1                  ; 2BCB 0 108 20E 29
                STB     A, r1                  ; 2BCC 0 108 20E 89
                LB      A, r7                  ; 2BCD 0 108 20E 7F
                SUBB    A, r6                  ; 2BCE 0 108 20E 2E
                MB      PSWL.4, C              ; 2BCF 0 108 20E A33C
                JGE     label_2bd6             ; 2BD1 0 108 20E CD03
                STB     A, r7                  ; 2BD3 0 108 20E 8F
                CLRB    A                      ; 2BD4 0 108 20E FA
                SUBB    A, r7                  ; 2BD5 0 108 20E 2F
                                               ; 2BD6 from 2BD1 (DD0,108,20E)
label_2bd6:     MULB                           ; 2BD6 0 108 20E A234
                MOVB    r0, r1                 ; 2BD8 0 108 20E 2148
                DIVB                           ; 2BDA 0 108 20E A236
                RB      PSWL.4                 ; 2BDC 0 108 20E A30C
                JEQ     label_2be4             ; 2BDE 0 108 20E C904
                SUBB    r6, A                  ; 2BE0 0 108 20E 26A1
                LB      A, r6                  ; 2BE2 0 108 20E 7E
                RT                             ; 2BE3 0 108 20E 01
                                               ; 2BE4 from 2BDE (DD0,108,20E)
label_2be4:     ADDB    A, r6                  ; 2BE4 0 108 20E 0E
                STB     A, r6                  ; 2BE5 0 108 20E 8E
                RT                             ; 2BE6 0 108 20E 01
                                               ; 2BE7 from 04E9 (DD0,108,20E)
                                               ; 2BE7 from 080F (DD0,108,20E)
                                               ; 2BE7 from 2244 (DD0,080,0A4)
                                               ; 2BE7 from 0966 (DD0,108,13C)
                                               ; 2BE7 from 0D59 (DD0,108,13C)
vcal_2:         CMPCB   A, [X1]                ; 2BE7 0 108 20E 90AE
                JLT     label_2bed             ; 2BE9 0 108 20E CA02
                LCB     A, [X1]                ; 2BEB 0 108 20E 90AA
                                               ; 2BED from 2BE9 (DD0,108,20E)
label_2bed:     CMPCB   A, 00002h[X1]          ; 2BED 0 108 20E 90AF0200
                JGE     label_2bf7             ; 2BF1 0 108 20E CD04
                LCB     A, 00002h[X1]          ; 2BF3 0 108 20E 90AB0200
                                               ; 2BF7 from 2BF1 (DD0,108,20E)
label_2bf7:     SJ      label_2bb7             ; 2BF7 0 108 20E CBBE
                                               ; 2BF9 from 1A74 (DD0,080,213)
                                               ; 2BF9 from 1DA5 (DD0,080,213)
                                               ; 2BF9 from 25F9 (DD0,080,205)
                                               ; 2BF9 from 2804 (DD0,080,132)
                                               ; 2BF9 from 280E (DD0,080,132)
                                               ; 2BF9 from 286C (DD0,080,132)
                                               ; 2BF9 from 2872 (DD0,080,132)
vcal_7:         CMPCB   A, [X1]                ; 2BF9 0 080 213 90AE
                JLT     label_2bff             ; 2BFB 0 080 213 CA02
                LCB     A, [X1]                ; 2BFD 0 080 213 90AA
                                               ; 2BFF from 2BFB (DD0,080,213)
label_2bff:     CMPCB   A, 00003h[X1]          ; 2BFF 0 080 213 90AF0300
                JGE     label_2c09             ; 2C03 0 080 213 CD04
                LCB     A, 00003h[X1]          ; 2C05 0 080 213 90AB0300
                                               ; 2C09 from 2C03 (DD0,080,213)
label_2c09:     SJ      label_2c18             ; 2C09 0 080 213 CB0D
                                               ; 2C0B from 1A45 (DD0,080,213)
                                               ; 2C0B from 2C16 (DD0,080,213)
                                               ; 2C0B from 1AF0 (DD0,080,213)
                                               ; 2C0B from 2103 (DD0,080,213)
                                               ; 2C0B from 2192 (DD0,080,0A3)
                                               ; 2C0B from 1CC4 (DD0,080,213)
                                               ; 2C0B from 3639 (DD0,080,213)
                                               ; 2C0B from 095E (DD0,108,13C)
                                               ; 2C0B from 09E0 (DD0,108,13C)
                                               ; 2C0B from 0B56 (DD0,108,13C)
                                               ; 2C0B from 225D (DD0,080,0A4)
                ;2C0B from 2279 -> with idle vals. Temp in A, temp rom addy X1, rpm vals addy DP
                                               ; 2C0B from 0A3C (DD0,108,13C)
                                               ; 2C0B from 27D9 (DD0,080,132)
                ;loop to find correct temp, rpm, whatever
vcal_1:         LB      A, ACC                 ; 2C0B 0 080 213 F506
                CMPCB   A, 00003h[X1]          ; 2C0D 0 080 213 90AF0300
                JGE     label_2c18             ; 2C11 0 080 213 CD05
                INC     X1                     ; 2C13 0 080 213 70
                INC     X1                     ; 2C14 0 080 213 70
                INC     X1                     ; 2C15 0 080 213 70
                SJ      vcal_1                 ; 2C16 0 080 213 CBF3
                                               ; 2C18 from 2C11 (DD0,080,213)
                                               ; 2C18 from 2C09 (DD0,080,213)
label_2c18:     STB     A, r0                  ; 2C18 0 080 213 88
                LCB     A, 00003h[X1]          ; 2C19 0 080 213 90AB0300
                STB     A, r4                  ; 2C1D 0 080 213 8C
                SUBB    r0, A                  ; 2C1E 0 080 213 20A1
                CLRB    r1                     ; 2C20 0 080 213 2115
                LCB     A, [X1]                ; 2C22 0 080 213 90AA
                SUBB    A, r4                  ; 2C24 0 080 213 2C
                STB     A, r4                  ; 2C25 0 080 213 8C
                CLRB    r5                     ; 2C26 0 080 213 2515
                CLR     A                      ; 2C28 1 080 213 F9
                LC      A, 00004h[X1]          ; 2C29 1 080 213 90A90400
                ST      A, er3                 ; 2C2D 1 080 213 8B
                LC      A, 00001h[X1]          ; 2C2E 1 080 213 90A90100
                                               ; 2C32 from 2B52 (DD1,108,20E)
                                               ; 2C32 from 2C6C (DD1,080,1B3)
label_2c32:     SUB     A, er3                 ; 2C32 1 108 20E 2B
                MB      PSWL.4, C              ; 2C33 1 108 20E A33C
                JGE     label_2c3a             ; 2C35 1 108 20E CD03
                ST      A, er1                 ; 2C37 1 108 20E 89
                CLR     A                      ; 2C38 1 108 20E F9
                SUB     A, er1                 ; 2C39 1 108 20E 29
                                               ; 2C3A from 2C35 (DD1,108,20E)
label_2c3a:     MUL                            ; 2C3A 1 108 20E 9035
                MOV     er0, er1               ; 2C3C 1 108 20E 4548
                DIV                            ; 2C3E 1 108 20E 9037
                RB      PSWL.4                 ; 2C40 1 108 20E A30C
                JEQ     label_2c48             ; 2C42 1 108 20E C904
                SUB     er3, A                 ; 2C44 1 108 20E 47A1
                L       A, er3                 ; 2C46 1 108 20E 37
                RT                             ; 2C47 1 108 20E 01
                                               ; 2C48 from 2C42 (DD1,108,20E)
label_2c48:     ADD     A, er3                 ; 2C48 1 108 20E 0B
                ST      A, er3                 ; 2C49 1 108 20E 8B
                RT                             ; 2C4A 1 108 20E 01
                                               ; 2C4B from 18EB (DD1,080,1B3)
                                               ; 2C4B from 2C55 (DD1,080,1B3)
                                               ; 2C4B from 1E04 (DD1,080,213)
label_2c4b:     CMPC    A, 00004h[X1]          ; 2C4B 1 080 1B3 90AD0400
                JGE     label_2c57             ; 2C4F 1 080 1B3 CD06
                ADD     X1, #00004h            ; 2C51 1 080 1B3 90800400
                SJ      label_2c4b             ; 2C55 1 080 1B3 CBF4
                                               ; 2C57 from 2C4F (DD1,080,1B3)
label_2c57:     ST      A, er0                 ; 2C57 1 080 1B3 88
                LC      A, 00004h[X1]          ; 2C58 1 080 1B3 90A90400
                ST      A, er2                 ; 2C5C 1 080 1B3 8A
                SUB     er0, A                 ; 2C5D 1 080 1B3 44A1
                LC      A, [X1]                ; 2C5F 1 080 1B3 90A8
                SUB     A, er2                 ; 2C61 1 080 1B3 2A
                ST      A, er2                 ; 2C62 1 080 1B3 8A
                LC      A, 00006h[X1]          ; 2C63 1 080 1B3 90A90600
                ST      A, er3                 ; 2C67 1 080 1B3 8B
                LC      A, 00002h[X1]          ; 2C68 1 080 1B3 90A90200
                SJ      label_2c32             ; 2C6C 1 080 1B3 CBC4
                                               ; 2C6E from 17E0 (DD1,080,00F)
                                               ; 2C6E from 19D6 (DD1,080,1B3)
label_2c6e:     RB      IRQH.4                 ; 2C6E 1 080 00F C5190C
                JNE     label_2c7d             ; 2C71 1 080 00F CE0A
                MOVB    0f0h, #04ah            ; 2C73 1 080 00F C5F0984A
                DECB    0ech                   ; 2C77 1 080 00F C5EC17
                JNE     label_2c92             ; 2C7A 1 080 00F CE16
                BRK                            ; 2C7C 1 080 00F FF
                                               ; 2C7D from 2C71 (DD1,080,00F)
label_2c7d:     LB      A, ADCR1H              ; 2C7D 0 080 00F F563
                STB     A, 098h                ; 2C7F 0 080 00F D598
                LB      A, P2                  ; 2C81 0 080 00F F524
                SWAPB                          ; 2C83 0 080 00F 83
                SRLB    A                      ; 2C84 0 080 00F 63
                ANDB    A, #007h               ; 2C85 0 080 00F D607
                EXTND                          ; 2C87 1 080 00F F8
                MOV     X1, A                  ; 2C88 1 080 00F 50
                LB      A, ADCR0H              ; 2C89 0 080 00F F561
                STB     A, 00099h[X1]          ; 2C8B 0 080 00F D09900
                ADDB    P2, #020h              ; 2C8E 0 080 00F C5248020
                                               ; 2C92 from 2C7A (DD1,080,00F)
label_2c92:     RT                             ; 2C92 0 080 00F 01
                                               ; 2C93 from 012D (DD1,???,???)
label_2c93:     L       A, #00011h             ; 2C93 1 ??? ??? 671100
                                               ; 2C96 from 00F8 (DD1,???,???)
label_2c96:     ST      A, IE                  ; 2C96 1 ??? ??? D51A
                MOV     PSW, #00102h           ; 2C98 1 ??? ??? B504980201
                MOV     LRB, #00022h           ; 2C9D 1 110 ??? 572200
                RT                             ; 2CA0 1 110 ??? 01
                                               ; 2CA1 from 058F (DD1,108,20E)
label_2ca1:     ST      A, er0                 ; 2CA1 1 108 20E 88
                CMPB    r1, #0fah              ; 2CA2 1 108 20E 21C0FA
                JGT     label_2cb1             ; 2CA5 1 108 20E C80A
                CMPB    r1, #005h              ; 2CA7 1 108 20E 21C005
                JLT     label_2cb1             ; 2CAA 1 108 20E CA05
                RB      off(0012ch).2          ; 2CAC 1 108 20E C42C0A
                SJ      label_2cc4             ; 2CAF 1 108 20E CB13
                                               ; 2CB1 from 2CA5 (DD1,108,20E)
                                               ; 2CB1 from 2CAA (DD1,108,20E)
label_2cb1:     SB      off(0012ch).2          ; 2CB1 1 108 20E C42C1A
                JBR     off(00130h).6, label_2cbd ; 2CB4 1 108 20E DE3006
                RB      off(0012ch).2          ; 2CB7 1 108 20E C42C0A
                                               ; 2CBA from 2CC4 (DD1,108,20E)
label_2cba:     MOVB    [DP], #02bh            ; 2CBA 1 108 20E C2982B
                                               ; 2CBD from 2CB4 (DD1,108,20E)
                                               ; 2CBD from 2CC7 (DD1,108,20E)
label_2cbd:     INC     DP                     ; 2CBD 1 108 20E 72
                MOVB    [DP], #080h            ; 2CBE 1 108 20E C29880
                RC                             ; 2CC1 1 108 20E 95
                SJ      label_2d06             ; 2CC2 1 108 20E CB42
                                               ; 2CC4 from 2CAF (DD1,108,20E)
                                               ; 2CC4 from 19D0 (DD1,080,1B3)
label_2cc4:     JBS     off(00130h).6, label_2cba ; 2CC4 1 108 20E EE30F3
                JBS     off(0012ch).2, label_2cbd ; 2CC7 1 108 20E EA2CF3
                CMP     A, #06db6h             ; 2CCA 1 108 20E C6B66D
                JGE     label_2cd3             ; 2CCD 1 108 20E CD04
                SLL     A                      ; 2CCF 1 108 20E 53
                CLRB    A                      ; 2CD0 0 108 20E FA
                SJ      label_2cd7             ; 2CD1 0 108 20E CB04
                                               ; 2CD3 from 2CCD (DD1,108,20E)
label_2cd3:     SRL     A                      ; 2CD3 1 108 20E 63
                SRL     A                      ; 2CD4 1 108 20E 63
                LB      A, #0c0h               ; 2CD5 0 108 20E 77C0
                                               ; 2CD7 from 2CD1 (DD0,108,20E)
label_2cd7:     ADDB    A, ACCH                ; 2CD7 0 108 20E C50782
                STB     A, r0                  ; 2CDA 0 108 20E 88
                XCHGB   A, [DP]                ; 2CDB 0 108 20E C210
                XCHGB   A, r0                  ; 2CDD 0 108 20E 2010
                SUBB    A, r0                  ; 2CDF 0 108 20E 28
                MB      PSWL.4, C              ; 2CE0 0 108 20E A33C
                ADDB    A, #080h               ; 2CE2 0 108 20E 8680
                RB      PSWL.4                 ; 2CE4 0 108 20E A30C
                JEQ     label_2ced             ; 2CE6 0 108 20E C905
                JLT     label_2cf1             ; 2CE8 0 108 20E CA07
                CLRB    A                      ; 2CEA 0 108 20E FA
                SJ      label_2cf1             ; 2CEB 0 108 20E CB04
                                               ; 2CED from 2CE6 (DD0,108,20E)
label_2ced:     JGE     label_2cf1             ; 2CED 0 108 20E CD02
                LB      A, #0ffh               ; 2CEF 0 108 20E 77FF
                                               ; 2CF1 from 2CE8 (DD0,108,20E)
                                               ; 2CF1 from 2CEB (DD0,108,20E)
                                               ; 2CF1 from 2CED (DD0,108,20E)
label_2cf1:     STB     A, r0                  ; 2CF1 0 108 20E 88
                INC     DP                     ; 2CF2 0 108 20E 72
                XCHGB   A, [DP]                ; 2CF3 0 108 20E C210
                CMPB    r0, A                  ; 2CF5 0 108 20E 20C1
                RB      r0.7                   ; 2CF7 0 108 20E 200F
                JEQ     label_2d06             ; 2CF9 0 108 20E C90B
                XORB    PSWH, #080h            ; 2CFB 0 108 20E A2F080
                SJ      label_2d06             ; 2CFE 0 108 20E CB06
                DB  02Fh,0CAh,002h,021h,010h,029h ; 2D00
                                               ; 2D06 from 2CC2 (DD1,108,20E)
                                               ; 2D06 from 2CF9 (DD0,108,20E)
                                               ; 2D06 from 2CFE (DD0,108,20E)
label_2d06:     RT                             ; 2D06 1 108 20E 01
                                               ; 2D07 from 213E (DD0,080,0A3)
                                               ; 2D07 from 2231 (DD0,080,0A4)
label_2d07:     LB      A, (00098h-000a3h)[USP] ; 2D07 0 080 0A3 F3F5
                SUBB    A, (000a3h-000a3h)[USP] ; 2D09 0 080 0A3 C300A2
                JGE     label_2d12             ; 2D0C 0 080 0A3 CD04
                ADDB    A, #002h               ; 2D0E 0 080 0A3 8602
                SJ      label_2d14             ; 2D10 0 080 0A3 CB02
                                               ; 2D12 from 2D0C (DD0,080,0A3)
label_2d12:     SUBB    A, #002h               ; 2D12 0 080 0A3 A602
                                               ; 2D14 from 2D10 (DD0,080,0A3)
label_2d14:     JGE     label_2d17             ; 2D14 0 080 0A3 CD01
                CLRB    A                      ; 2D16 0 080 0A3 FA
                                               ; 2D17 from 2D14 (DD0,080,0A3)
label_2d17:     ADDB    A, (000a3h-000a3h)[USP] ; 2D17 0 080 0A3 C30082
                STB     A, (000a3h-000a3h)[USP] ; 2D1A 0 080 0A3 D300
                RT                             ; 2D1C 0 080 0A3 01



                                               ; 2D1D from 183E (DD0,080,213)
                                               ; 2D1D from 2234 (DD0,080,0A4)
label_2d1d:     ADDB    A, #005h               ; 2D1D 0 080 213 8605
                JGE     label_2d23             ; 2D1F 0 080 213 CD02
                LB      A, #0ffh               ; 2D21 0 080 213 77FF
                                               ; 2D23 from 2D1F (DD0,080,213)
label_2d23:     JBS     off(0001eh).5, label_2d2d ; 2D23 0 080 213 ED1E07
                JBS     off(0001eh).7, label_2d2d ; 2D26 0 080 213 EF1E04
                CMPB    A, off(000aah)         ; 2D29 0 080 213 C7AA
                JGE     label_2d35             ; 2D2B 0 080 213 CD08
                                               ; 2D2D from 2D23 (DD0,080,213)
                                               ; 2D2D from 2D26 (DD0,080,213)
label_2d2d:     MOVB    r0, #042h              ; 2D2D 0 080 213 9842
                CMPB    A, r0                  ; 2D2F 0 080 213 48
                JGE     label_2d33             ; 2D30 0 080 213 CD01
                LB      A, r0                  ; 2D32 0 080 213 78
                                               ; 2D33 from 2D30 (DD0,080,213)
label_2d33:     STB     A, off(000aah)         ; 2D33 0 080 213 D4AA
                                               ; 2D35 from 2D2B (DD0,080,213)
label_2d35:     RT                             ; 2D35 0 080 213 01
                                               ; 2D36 from 1C95 (DD1,080,266)
label_2d36:     SUB     A, (00266h-00266h)[USP] ; 2D36 1 080 266 B300A2
                MB      PSWL.4, C              ; 2D39 1 080 266 A33C
                JGE     label_2d40             ; 2D3B 1 080 266 CD03
                ST      A, er1                 ; 2D3D 1 080 266 89
                CLR     A                      ; 2D3E 1 080 266 F9
                SUB     A, er1                 ; 2D3F 1 080 266 29
                                               ; 2D40 from 2D3B (DD1,080,266)
label_2d40:     MUL                            ; 2D40 1 080 266 9035
                RB      PSWL.4                 ; 2D42 1 080 266 A30C
                JNE     label_2d4e             ; 2D44 1 080 266 CE08
                ADD     (00262h-00266h)[USP], A ; 2D46 1 080 266 B3FC81
                L       A, er1                 ; 2D49 1 080 266 35
                ADC     (00266h-00266h)[USP], A ; 2D4A 1 080 266 B30091
                RT                             ; 2D4D 1 080 266 01
                                               ; 2D4E from 2D44 (DD1,080,266)
label_2d4e:     SUB     (00262h-00266h)[USP], A ; 2D4E 1 080 266 B3FCA1
                L       A, er1                 ; 2D51 1 080 266 35
                SBC     (00266h-00266h)[USP], A ; 2D52 1 080 266 B300B1
                RT                             ; 2D55 1 080 266 01
                                               ; 2D56 from 0550 (DD1,108,20E)
                                               ; 2D56 from 0587 (DD1,108,20E)
                                               ; 2D56 from 19AB (DD1,080,1B3)
                                               ; 2D56 from 27F4 (DD1,080,132)
                                               ; 2D56 from 1086 (DD1,108,13C)
label_2d56:     MUL                            ; 2D56 1 108 20E 9035
                MOV     er2, er1               ; 2D58 1 108 20E 454A
                L       A, [DP]                ; 2D5A 1 108 20E E2
                MUL                            ; 2D5B 1 108 20E 9035
                L       A, [DP]                ; 2D5D 1 108 20E E2
                SUB     A, er1                 ; 2D5E 1 108 20E 29
                ADD     A, er2                 ; 2D5F 1 108 20E 0A
                ST      A, [DP]                ; 2D60 1 108 20E D2
                RT                             ; 2D61 1 108 20E 01
                DB  0E2h ; 2D62
                                               ; 2D63 from 2E87 (DD1,080,213)
                                               ; 2D63 from 2E8D (DD1,080,213)
                                               ; 2D63 from 1C36 (DD1,080,213)
                                               ; 2D63 from 1DEE (DD1,080,213)
                                               ; 2D63 from 1DFD (DD1,080,213)
                                               ; 2D63 from 13FE (DD1,108,13C)
                                               ; 2D63 from 1401 (DD1,108,13C)
                                               ; 2D63 from 1405 (DD1,108,13C)
                                               ; 2D63 from 1409 (DD1,108,13C)
vcal_4:         L       A, ACC                 ; 2D63 1 080 213 E506
                MB      C, ACCH.7              ; 2D65 1 080 213 C5072F
                JLT     label_2d72             ; 2D68 1 080 213 CA08
                ADD     A, er3                 ; 2D6A 1 080 213 0B
                JGE     label_2d76             ; 2D6B 1 080 213 CD09
                L       A, #0ffffh             ; 2D6D 1 080 213 67FFFF
                SJ      label_2d76             ; 2D70 1 080 213 CB04
                                               ; 2D72 from 2D68 (DD1,080,213)
label_2d72:     ADD     A, er3                 ; 2D72 1 080 213 0B
                JLT     label_2d76             ; 2D73 1 080 213 CA01
                CLR     A                      ; 2D75 1 080 213 F9
                                               ; 2D76 from 2D6B (DD1,080,213)
                                               ; 2D76 from 2D70 (DD1,080,213)
                                               ; 2D76 from 2D73 (DD1,080,213)
label_2d76:     ST      A, er3                 ; 2D76 1 080 213 8B
                RT                             ; 2D77 1 080 213 01
                                               ; 2D78 from 18C5 (DD1,080,1B3)
                                               ; 2D78 from 2D81 (DD0,080,1B4)
                                               ; 2D78 from 1E11 (DD1,080,1D5)
                                               ; 2D78 from 1D27 (DD1,080,1AC)
                                               ; 2D78 from 3687 (DD1,080,1CD)
label_2d78:     LB      A, (001b3h-001b3h)[USP] ; 2D78 0 080 1B3 F300
                JEQ     label_2d7f             ; 2D7A 0 080 1B3 C903
                DECB    (001b3h-001b3h)[USP]   ; 2D7C 0 080 1B3 C30017
                                               ; 2D7F from 2D7A (DD0,080,1B3)
label_2d7f:     INC     USP                    ; 2D7F 0 080 1B4 A116
                JRNZ    DP, label_2d78         ; 2D81 0 080 1B4 30F5
                RT                             ; 2D83 0 080 1B4 01
                                               ; 2D84 from 18BB (DD1,080,213)
                                               ; 2D84 from 2749 (DD1,080,132)
label_2d84:     LB      A, #03ch               ; 2D84 0 080 213 773C
                STB     A, WDT                 ; 2D86 0 080 213 D511
                SWAPB                          ; 2D88 0 080 213 83
                STB     A, WDT                 ; 2D89 0 080 213 D511
                LB      A, 0f1h                ; 2D8B 0 080 213 F5F1
                ANDB    A, #003h               ; 2D8D 0 080 213 D603
                JNE     label_2d95             ; 2D8F 0 080 213 CE04
                XORB    P4, #001h              ; 2D91 0 080 213 C52CF001
                                               ; 2D95 from 2D8F (DD0,080,213)
label_2d95:     RT                             ; 2D95 0 080 213 01
                                               ; 2D96 from 19E0 (DD0,080,1B3)
label_2d96:     RB      PSWL.5                 ; 2D96 0 080 1B3 A30D
                                               ; 2D98 from 0327 (DD0,???,???)
label_2d98:     AND     IE, #00080h            ; 2D98 0 ??? ??? B51AD08000
                RB      PSWH.0                 ; 2D9D 0 ??? ??? A208
                LB      A, P2                  ; 2D9F 0 ??? ??? F524
                SLLB    A                      ; 2DA1 0 ??? ??? 53
                SWAPB                          ; 2DA2 0 ??? ??? 83
                STB     A, LRBH                ; 2DA3 0 ??? ??? D503
                LB      A, ALRB                ; 2DA5 0 ??? ??? F502
                STB     A, [DP]                ; 2DA7 0 ??? ??? D2
                LB      A, [DP]                ; 2DA8 0 ??? ??? F2
                CLR     LRB                    ; 2DA9 0 ??? ??? A415
                SB      PSWH.0                 ; 2DAB 0 ??? ??? A218
                MOV     off(07ff1ah), 0cch     ; 2DAD 0 ??? ??? B5CC7C1A
                RT                             ; 2DB1 0 ??? ??? 01
                                               ; 2DB2 from 22F3 (DD1,080,0A4)
                                               ; 2DB2 from 0E9A (DD0,108,13C)
                ;o2 sensor 1
label_2db2:     LB      A, ADCR2H              ; 2DB2 0 080 0A4 F565
                STB     A, 0a1h                ; 2DB4 0 080 0A4 D5A1
                STB     A, r6                  ; 2DB6 0 080 0A4 8E
                MOV     DP, #0011bh            ; 2DB7 0 080 0A4 621B01
                MOV     USP, #00180h           ; 2DBA 0 080 180 A1988001
                CLR     X2                     ; 2DBE 0 080 180 9115
                LB      A, off(P5)             ; 2DC0 0 080 180 F42F
                ANDB    A, #030h               ; 2DC2 0 080 180 D630
                STB     A, r7                  ; 2DC4 0 080 180 8F
                LB      A, off(TM0)            ; 2DC5 0 080 180 F430
                ANDB    A, #003h               ; 2DC7 0 080 180 D603
                ORB     r7, A                  ; 2DC9 0 080 180 27E1
                LB      A, off(TMR0)           ; 2DCB 0 080 180 F432
                ANDB    A, #0c0h               ; 2DCD 0 080 180 D6C0
                ORB     r7, A                  ; 2DCF 0 080 180 27E1
                RT                             ; 2DD1 0 080 180 01
                                               ; 2DD2 from 22F9 (DD1,080,0A4)
                                               ; 2DD2 from 0EA8 (DD0,108,13C)
                ;o2#2 disable.
                ;just load the o2sensor #1 into the #2 val.

label_2dd2:     LB      A, 0a1h
				;LB      A, ADCR3H              ; 2DD2 0 080 0A4 F567
                STB     A, 0a2h                ; 2DD4 0 080 0A4 D5A2
                STB     A, r6                  ; 2DD6 0 080 0A4 8E
                INC     DP                     ; 2DD7 0 080 0A4 72
                INC     USP                    ; 2DD8 0 080 0A5 A116
                INC     X2                     ; 2DDA 0 080 0A5 71
                INC     X2                     ; 2DDB 0 080 0A5 71
                RORB    r7                     ; 2DDC 0 080 0A5 27C7
                RT                             ; 2DDE 0 080 0A5 01
                                               ; 2DDF from 22F6 (DD1,080,0A4)
                                               ; 2DDF from 22FC (DD1,080,0A4)
label_2ddf:     LB      A, off(000d5h)         ; 2DDF 0 080 0A4 F4D5
                JNE     label_2e2a             ; 2DE1 0 080 0A4 CE47
                CMPB    0a3h, #0a7h    ;mugen -> #000h        ; 2DE3 0 080 0A4 C5A3C0A7
                LB      A, #030h       ;mugen -> #000h        ; 2DE7 0 080 0A4 7730
                JGE     label_2df2             ; 2DE9 0 080 0A4 CD07
                LB      A, #03bh       ;mugen -> #000h        ; 2DEB 0 080 0A4 773B
                JBR     off(P2).3, label_2df2  ; 2DED 0 080 0A4 DB2402
                LB      A, #062h       ;mugen -> #000h        ; 2DF0 0 080 0A4 7762
                                               ; 2DF2 from 2DE9 (DD0,080,0A4)
                                               ; 2DF2 from 2DED (DD0,080,0A4)
label_2df2:     CMPB    0a4h, A                ; 2DF2 0 080 0A4 C5A4C1
                MB      off(0001eh).1, C  ;w/mugen carry will always be 0     ; 2DF5 0 080 0A4 C41E39
                MB      C, [DP].3              ; 2DF8 0 080 0A4 C22B
                JLT     label_2e20             ; 2DFA 0 080 0A4 CA24
                MB      C, [DP].4              ; 2DFC 0 080 0A4 C22C
                JGE     label_2e08             ; 2DFE 0 080 0A4 CD08
                JBS     off(0001fh).5, label_2e2a ; 2E00 0 080 0A4 ED1F27
                JBR     off(EXION).6, label_2e2a ; 2E03 0 080 0A4 DE1C24
                RB      [DP].4                 ; 2E06 0 080 0A4 C20C
                                               ; 2E08 from 2DFE (DD0,080,0A4)
label_2e08:     CMPB    r6, #01ah              ; if lean...

                ;SJ      label_2e2a <- disables o2 sensors?
                JLT     label_2e1a             ; ...then jump

                JBR     off(0001eh).1, label_2e2a ; 2E0D 0 080 0A4 D91E1A
                JBS     off(0001fh).5, label_2e2a ; 2E10 0 080 0A4 ED1F17
                JBR     off(EXION).6, label_2e2a ; 2E13 0 080 0A4 DE1C14
                LB      A, (000f2h-000a4h)[USP] ; 2E16 0 080 0A4 F34E
                JNE     label_2e5d             ; 2E18 0 080 0A4 CE43
                                               ; 2E1A from 2E0B (DD0,080,0A4)
label_2e1a:     MOVB    (00107h-000a4h)[USP], #032h ; 2E1A 0 080 0A4 C3639832
                SB      [DP].3                 ; 2E1E 0 080 0A4 C21B
                                               ; 2E20 from 2DFA (DD0,080,0A4)
label_2e20:     JBS     off(IEH).7, label_2e2c ; 2E20 0 080 0A4 EF1B09
                LB      A, off(000e5h)         ; 2E23 0 080 0A4 F4E5
                JNE     label_2e2a             ; 2E25 0 080 0A4 CE03
                ANDB    [DP], #0e7h            ; 2E27 0 080 0A4 C2D0E7
                                               ; 2E2A from 2DE1 (DD0,080,0A4)
                                               ; 2E2A from 2E00 (DD0,080,0A4)
                                               ; 2E2A from 2E03 (DD0,080,0A4)
                                               ; 2E2A from 2E0D (DD0,080,0A4)
                                               ; 2E2A from 2E10 (DD0,080,0A4)
                                               ; 2E2A from 2E13 (DD0,080,0A4)
                                               ; 2E2A from 2E25 (DD0,080,0A4)
label_2e2a:     SJ      label_2e59             ; 2E2A 0 080 0A4 CB2D
                                               ; 2E2C from 2E20 (DD0,080,0A4)
label_2e2c:     MOVB    off(000e5h), #032h     ; 2E2C 0 080 0A4 C4E59832
                J       label_1d30             ; 2E30 0 080 0A4 03301D
                                               ; 2E33 from 1D3B (DD1,080,0A4)
label_2e33:     JLT     label_2e48             ; 2E33 1 080 0A4 CA13
                J       label_1d3e             ; 2E35 1 080 0A4 033E1D
                                               ; 2E38 from 1D45 (DD1,080,0A4)
label_2e38:     CMP     00162h[X2], #0ae20h    ; 2E38 1 080 0A4 B16201C020AE
                JGE     label_2e55             ; 2E3E 1 080 0A4 CD15
                CMP     00162h[X2], #05b60h    ; 2E40 1 080 0A4 B16201C0605B
                JLE     label_2e55             ; 2E46 1 080 0A4 CF0D
                                               ; 2E48 from 2E33 (DD1,080,0A4)
label_2e48:     CMPB    r6, #01eh              ; 2E48 1 080 0A4 26C01E
                JGE     label_2e51             ; 2E4B 1 080 0A4 CD04
                                               ; 2E4D from 1D4C (DD1,080,0A4)
label_2e4d:     LB      A, r0                  ; 2E4D 0 080 0A4 78
                STB     A, 00000h[X1]          ; 2E4E 0 080 0A4 D00000
                                               ; 2E51 from 2E4B (DD1,080,0A4)
label_2e51:     J       label_1d4f             ; 2E51 0 080 0A4 034F1D
                DB  004h ; 2E54
                                               ; 2E55 from 1D54 (DD0,080,0A4)
                                               ; 2E55 from 2E3E (DD1,080,0A4)
                                               ; 2E55 from 2E46 (DD1,080,0A4)
label_2e55:     RB      [DP].3                 ; 2E55 0 080 0A4 C20B
                SB      [DP].4                 ; 2E57 0 080 0A4 C21C
                                               ; 2E59 from 2E2A (DD0,080,0A4)
                                               ; 2E59 from 1D57 (DD0,080,0A4)
label_2e59:     MOVB    (000f2h-000a4h)[USP], #096h ; 2E59 0 080 0A4 C34E9896
                                               ; 2E5D from 2E18 (DD0,080,0A4)
label_2e5d:     RT                             ; 2E5D 0 080 0A4 01
                                               ; 2E5E from 2312 (DD1,080,0A4)
                                               ; 2E5E from 104B (DD1,108,13C)
label_2e5e:     CMP     er0, A                 ; 2E5E 1 080 0A4 44C1
                JGE     label_2e64             ; 2E60 1 080 0A4 CD02
                L       A, er0                 ; 2E62 1 080 0A4 34
                RT                             ; 2E63 1 080 0A4 01
                                               ; 2E64 from 2E60 (DD1,080,0A4)
label_2e64:     CMP     A, er1                 ; 2E64 1 080 0A4 49
                JGE     label_2e68             ; 2E65 1 080 0A4 CD01
                L       A, er1                 ; 2E67 1 080 0A4 35
                                               ; 2E68 from 2E65 (DD1,080,0A4)
label_2e68:     RT                             ; 2E68 1 080 0A4 01
                                               ; 2E69 from 1AF2 (DD0,080,213)
                                               ; 2E69 from 1AFC (DD1,080,213)
                                               ; 2E69 from 1B22 (DD0,080,213)
                                               ; 2E69 from 1CA4 (DD1,080,213)
                                               ; 2E69 from 1B19 (DD1,080,213)
                                               ; 2E69 from 1BBD (DD1,080,213)
label_2e69:     CLR     A                      ; 2E69 1 080 213 F9
                JBS     off(P2).6, label_2e82  ; 2E6A 1 080 213 EE2415
                MOV     er3, #00600h           ; 2E6D 1 080 213 47980006
                JBS     off(IRQ).7, label_2e7e ; 2E71 1 080 213 EF180A
                MOV     er3, #00400h           ; 2E74 1 080 213 47980004
                SJ      label_2e7e             ; 2E78 1 080 213 CB04
                                               ; 2E7A from 22C8 (DD1,080,0A4)
label_2e7a:     MOV     er3, #00d00h           ; 2E7A 1 080 0A4 4798000D
                                               ; 2E7E from 2E71 (DD1,080,213)
                                               ; 2E7E from 2E78 (DD1,080,213)
label_2e7e:     L       A, off(PWCON0)         ; 2E7E 1 080 213 E478
                SJ      label_2e87             ; 2E80 1 080 213 CB05
                                               ; 2E82 from 2E6A (DD1,080,213)
                                               ; 2E82 from 1B6F (DD1,080,213)
                                               ; 2E82 from 22B2 (DD1,080,0A4)
label_2e82:     ST      A, er3                 ; 2E82 1 080 213 8B
                MOV     DP, #00266h            ; 2E83 1 080 213 626602
                L       A, [DP]                ; 2E86 1 080 213 E2
                                               ; 2E87 from 2E80 (DD1,080,213)
label_2e87:     VCAL    4                      ; 2E87 1 080 213 14
                JBS     off(P2SF).1, label_2e8e ; 2E88 1 080 213 E92603
                SCAL    label_2e91             ; 2E8B 1 080 213 3104
                VCAL    4                      ; 2E8D 1 080 213 14
                                               ; 2E8E from 2E88 (DD1,080,213)
label_2e8e:     VCAL    6                      ; 2E8E 1 080 213 16
                ST      A, er3                 ; 2E8F 1 080 213 8B
                RT                             ; 2E90 1 080 213 01
                                               ; 2E91 from 1B28 (DD1,080,213)
                                               ; 2E91 from 2E8B (DD1,080,213)
label_2e91:     L       A, #08000h             ; 2E91 1 080 213 670080
                                               ; 2E94 from 1C7A (DD1,080,266)
label_2e94:     ST      A, er0                 ; 2E94 1 080 213 88
                L       A, off(0008ah)         ; 2E95 1 080 213 E48A
                SLL     A                      ; 2E97 1 080 213 53
                MUL                            ; 2E98 1 080 213 9035
                L       A, er1                 ; 2E9A 1 080 213 35
                RT                             ; 2E9B 1 080 213 01
                                               ; 2E9C from 1AF7 (DD1,080,213)
                                               ; 2E9C from 1CEA (DD1,080,213)
                                               ; 2E9C from 1BC9 (DD1,080,213)
                                               ; 2E9C from 1C26 (DD1,080,213)
                                               ; 2E9C from 1C46 (DD1,080,213)
                                               ; 2E9C from 1DB5 (DD1,080,213)
vcal_5:         JLT     label_2ea3             ; 2E9C 1 080 213 CA05
                                               ; 2E9E from 2E8E (DD1,080,213)
                                               ; 2E9E from 1DFE (DD1,080,213)
vcal_6:         CMP     A, #01bffh             ; 2E9E 1 080 213 C6FF1B
                JLT     label_2ea6             ; 2EA1 1 080 213 CA03
                                               ; 2EA3 from 2E9C (DD1,080,213)
label_2ea3:     L       A, #01bffh             ; 2EA3 1 080 213 67FF1B
                                               ; 2EA6 from 2EA1 (DD1,080,213)
label_2ea6:     RT                             ; 2EA6 1 080 213 01
                                               ; 2EA7 from 1C37 (DD1,080,213)
                                               ; 2EA7 from 1C4D (DD1,080,213)
label_2ea7:     CMP     off(0008eh), A         ; 2EA7 1 080 213 B48EC1
                JGE     label_2eaf             ; 2EAA 1 080 213 CD03
                L       A, off(0008eh)         ; 2EAC 1 080 213 E48E
                RT                             ; 2EAE 1 080 213 01
                                               ; 2EAF from 2EAA (DD1,080,213)
label_2eaf:     CMP     A, off(00090h)         ; 2EAF 1 080 213 C790
                JGE     label_2eb5             ; 2EB1 1 080 213 CD02
                L       A, off(00090h)         ; 2EB3 1 080 213 E490
                                               ; 2EB5 from 2EB1 (DD1,080,213)
label_2eb5:     RT                             ; 2EB5 1 080 213 01

;********************************************************************************
;code setting routine
;r6 contains the code...
                                               ; 2EB6 from 0097 (DD0,100,???)
                                               ; 2EB6 from 26E1 (DD0,080,205)
label_2eb6:     CLR     A                      ; 2EB6 1 100 ??? F9
                LB      A, r6                  ; 2EB7 0 100 ??? 7E
                SUBB    A, #001h               ; 2EB8 0 100 ??? A601
                MOVB    r0, #008h              ; 2EBA 0 100 ??? 9808
                DIVB                           ; 2EBC 0 100 ??? A236
                MOV     X1, A                  ; 2EBE 0 100 ??? 50
                LB      A, r1                  ; 2EBF 0 100 ??? 79
           ;    SBR     00130h[X1]             ; comment out
                CAL		nocode					;un comment
                NOP
                NOP
                NOP
                NOP
                NOP;
;codesetting:    SBR     0027bh[X1]             ; 2EC4 0 100 ??? C07B0211
                                               ; 2EC8 from 3577 (DD0,100,???)
label_2ec8:     MOV     DP, #0027bh            ; 2EC8 0 100 ??? 627B02
                CLR     er0                    ; 2ECB 0 100 ??? 4415
                                               ; 2ECD from 2EDA (DD0,100,???)
label_2ecd:     LB      A, r0                  ; 2ECD 0 100 ??? 78
                ADDB    A, [DP]                ; 2ECE 0 100 ??? C282
                STB     A, r0                  ; 2ED0 0 100 ??? 88
                LB      A, r1                  ; 2ED1 0 100 ??? 79
                XORB    A, [DP]                ; 2ED2 0 100 ??? C2F2
                STB     A, r1                  ; 2ED4 0 100 ??? 89
                INC     DP                     ; 2ED5 0 100 ??? 72
                CMP     DP, #0027eh            ; 2ED6 0 100 ??? 92C07E02
                JNE     label_2ecd             ; 2EDA 0 100 ??? CEF1
                L       A, er0                 ; 2EDC 1 100 ??? 34
                ST      A, [DP]                ; 2EDD 1 100 ??? D2
                RT                             ; 2EDE 1 100 ??? 01
;********************************************************************************
                                               ; 2EDF from 1EB8 (DD0,080,1CD)
                                               ; 2EDF from 1EC2 (DD0,080,1CD)
                                               ; 2EDF from 2F08 (DD0,080,1CD)
label_2edf:     J       label_422b             ; 2EDF 0 080 1CD 032B42
                DB  082h ; 2EE2
                                               ; 2EE3 from 4236 (DD0,080,1CD)
label_2ee3:     INC     X1                     ; 2EE3 0 080 1CD 70
                CMPCB   A, [X1]                ; 2EE4 0 080 1CD 90AE
                JLT     label_2eea             ; 2EE6 0 080 1CD CA02
                LCB     A, [X1]                ; 2EE8 0 080 1CD 90AA
                                               ; 2EEA from 2EE6 (DD0,080,1CD)
label_2eea:     STB     A, [DP]                ; 2EEA 0 080 1CD D2
                LB      A, r6                  ; 2EEB 0 080 1CD 7E
                JBR     off(ACCH).0, label_2efc ; 2EEC 0 080 1CD D8070D
                SUBB    A, 0e8h                ; 2EEF 0 080 1CD C5E8A2
                JNE     label_2ef6             ; 2EF2 0 080 1CD CE02
                STB     A, 0e8h                ; 2EF4 0 080 1CD D5E8
                                               ; 2EF6 from 2EF2 (DD0,080,1CD)
label_2ef6:     CMP     DP, #001c4h            ; 2EF6 0 080 1CD 92C0C401
                SJ      label_2f05             ; 2EFA 0 080 1CD CB09
                                               ; 2EFC from 2EEC (DD0,080,1CD)
label_2efc:     JLT     label_2f01             ; 2EFC 0 080 1CD CA03
                RBR     0f1h                   ; 2EFE 0 080 1CD C5F112
                                               ; 2F01 from 2EFC (DD0,080,1CD)
label_2f01:     CMP     DP, #000ech            ; 2F01 0 080 1CD 92C0EC00
                                               ; 2F05 from 2EFA (DD0,080,1CD)
label_2f05:     INC     X1                     ; 2F05 0 080 1CD 70
                INC     DP                     ; 2F06 0 080 1CD 72
                INCB    r6                     ; 2F07 0 080 1CD AE
                JLT     label_2edf             ; 2F08 0 080 1CD CAD5
                RT                             ; 2F0A 0 080 1CD 01
                                               ; 2F0B from 1F47 (DD1,080,132)
                                               ; 2F0B from 1F4D (DD1,080,132)
label_2f0b:     MOV     X2, A                  ; 2F0B 1 080 132 51
                AND     IE, #00080h            ; 2F0C 1 080 132 B51AD08000
                RB      PSWH.0                 ; 2F11 1 080 132 A208
                XCHG    A, 00082h[X1]          ; 2F13 1 080 132 B0820010
                XCHG    A, 00082h[X1]          ; 2F17 1 080 132 B0820010
                ST      A, er0                 ; 2F1B 1 080 132 88
                SB      PSWH.0                 ; 2F1C 1 080 132 A218
                L       A, 0cch                ; 2F1E 1 080 132 E5CC
                ST      A, IE                  ; 2F20 1 080 132 D51A
                L       A, er0                 ; 2F22 1 080 132 34
                CMP     A, X2                  ; 2F23 1 080 132 91C2
                JEQ     label_2f32             ; 2F25 1 080 132 C90B
                MOVB    0f0h, #042h            ; 2F27 1 080 132 C5F09842
                DECB    0ech                   ; 2F2B 1 080 132 C5EC17
                JNE     label_2f31             ; 2F2E 1 080 132 CE01
                BRK                            ; 2F30 1 080 132 FF
                                               ; 2F31 from 2F2E (DD1,080,132)
label_2f31:     L       A, X2                  ; 2F31 1 080 132 41
                                               ; 2F32 from 2F25 (DD1,080,132)
label_2f32:     RT                             ; 2F32 1 080 132 01
                                               ; 2F33 from 2350 (DD1,080,0A4)
                                               ; 2F33 from 1FAB (DD1,080,132)
label_2f33:     LB      A, #000h               ; 2F33 0 080 0A4 7700
                STB     A, 0e3h                ; 2F35 0 080 0A4 D5E3
                STB     A, off(0009bh)         ; 2F37 0 080 0A4 D49B
                CLRB    0e5h                   ; 2F39 0 080 0A4 C5E515
                                               ; 2F3C from 24FA (DD1,080,205)
label_2f3c:     MOVB    off(0009ah), #005h     ; 2F3C 0 080 0A4 C49A9805
                MOVB    0e7h, #004h            ; 2F40 0 080 0A4 C5E79804
                RT                             ; 2F44 0 080 0A4 01
                DB  000h,0FFh,059h,0F5h,059h,0E8h,04Dh,0BAh ; 2F45
                DB  048h,087h,047h,030h,043h,028h,040h,000h ; 2F4D
                DB  040h,0FFh,078h,0F5h,078h,0E1h,06Ch,0BAh ; 2F55
                DB  063h,087h,05Dh,030h,04Bh,028h,040h,000h ; 2F5D
                DB  040h,0FFh,05Eh,0F5h,05Eh,0E1h,05Bh,0BAh ; 2F65
                DB  056h,087h,04Eh,030h,045h,028h,040h,000h ; 2F6D
                DB  040h,0DFh,0DFh,051h,051h,0FFh,05Ah,0E0h ; 2F75
                DB  044h,0C0h,02Ah,0A0h,00Fh,080h,009h,050h ; 2F7D
                DB  000h,000h,000h,0FFh,086h,0A1h,086h,07Ah ; 2F85
                DB  069h,044h,046h,02Eh,043h,000h,043h,005h ; 2F8D
                DB  0DDh,000h,0DDh,0FFh,066h,007h,0C0h,066h ; 2F95
                DB  007h,0A0h,036h,008h,010h,096h,006h,000h ; 2F9D
                DB  096h,006h,0FFh,056h,007h,0C0h,056h,007h ; 2FA5
                DB  0A0h,0D6h,007h,020h,0D6h,006h,000h,0D6h ; 2FAD
                DB  006h,060h,000h,0C0h,001h,0C0h,001h,020h ; 2FB5
                DB  000h,020h,000h,020h,000h,0E0h,000h,0E0h ; 2FBD
                DB  004h,023h,007h,080h,000h,05Ah,004h,045h ; 2FC5
                DB  008h,0A0h,000h,0E0h,004h,023h,007h,0A0h ; 2FCD
                DB  000h,05Ah,004h,094h,009h,080h,000h,0A0h ; 2FD5
                DB  002h,0A0h,006h,080h,000h,040h,001h,040h ; 2FDD
                DB  003h,06Bh,046h,0D7h,0E0h,000h,060h,004h ; 2FE5
                DB  0F8h,006h,080h,000h,060h,004h,060h,007h ; 2FED
                DB  080h,000h,020h,006h,020h,007h,080h,000h ; 2FF5
                DB  05Ah,004h,0B5h,008h,080h,000h,0A0h,002h ; 2FFD
                DB  0A0h,006h,080h,000h,040h,001h,040h,003h ; 3005
                DB  085h,046h,0D7h,000h,000h,043h,000h,086h ; 300D
                DB  000h,0BDh,0FFh,000h,000h,000h,000h,000h ; 3015
                DB  000h,000h,000h,0FFh,08Bh,003h,0EAh,077h ; 301D
                DB  003h,0C0h,0F9h,001h,080h,040h,001h,044h ; 3025
                DB  030h,001h,000h,030h,001h,0FFh,03Dh,004h ; 302D
                DB  0E7h,02Ch,004h,0BAh,0E1h,001h,080h,040h ; 3035
                DB  001h,044h,030h,001h,000h,030h,001h,0FFh ; 303D
                DB  05Eh,003h,0EAh,04Bh,003h,0C0h,0F9h,001h ; 3045
                DB  080h,040h,001h,044h,030h,001h,000h,030h ; 304D
                DB  001h,0FFh,007h,004h,0E7h,0F7h,003h,0BAh ; 3055
                DB  0E1h,001h,080h,040h,001h,044h,030h,001h ; 305D
                DB  000h,030h,001h,000h,006h,0D6h,00Dh,031h ; 3065
                DB  000h,028h,000h,030h,005h,008h,00Ch,03Ah ; 306D
                DB  000h,02Ch,000h,010h,000h,010h,000h,008h ; 3075
                DB  000h,008h,000h,008h,000h,008h,000h,087h ; 307D
                DB  0FAh,000h,034h,026h,000h,01Fh,00Fh,000h ; 3085
                DB  0F1h,0E1h,000h,01Fh,00Fh,000h,0F1h,0E1h ; 308D
                DB  000h,0FFh,076h,000h,0C5h,076h,000h,0A7h ; 3095
                DB  076h,000h,092h,096h,000h,07Eh,0C8h,000h ; 309D
                DB  03Fh,080h,002h,000h,080h,002h,0FFh,0A1h ; 30A5
                DB  0E0h,0A1h,0C0h,08Ah,0A0h,07Fh,080h,065h ; 30AD
                DB  060h,046h,040h,02Ah,000h,000h,040h,000h ; 30B5
                DB  040h,000h,02Ch,000h,00Ch,000h,008h,000h ; 30BD
                DB  004h,000h,07Dh,000h,07Dh,000h,07Dh,000h ; 30C5
                DB  019h,000h,032h,000h,019h,000h,056h,00Ch ; 30CD
                DB  0E1h,000h,056h,00Ch,0AFh,000h,050h,00Eh ; 30D5
                DB  06Fh,000h,060h,009h,0FAh,000h,06Fh,005h ; 30DD
                DB  0AFh,000h,050h,00Ch,06Fh,000h,020h,010h ; 30E5
                DB  0FAh,000h,020h,010h,0FAh,000h,000h,006h ; 30ED
                DB  000h,002h,000h,005h,000h,003h,0FFh,010h ; 30F5
                DB  000h,0E0h,010h,000h,0D0h,020h,000h,0B0h ; 30FD
                DB  030h,000h,0A0h,040h,000h,080h,050h,000h ; 3105
                DB  070h,060h,000h,050h,070h,000h,040h,080h ; 310D
                DB  000h,020h,090h,000h,010h,0A0h,000h,000h ; 3115
                DB  0B0h,000h,0FFh,027h,0C0h,01Eh,080h,012h ; 311D
                DB  040h,008h,000h,000h,0FFh,0ECh,0D8h,0ECh ; 3125
                DB  0C6h,0FFh,0A9h,0FAh,077h,0EFh,030h,0EFh ; 312D
                DB  000h,0EFh,0FFh,0FAh,0D5h,0FAh,0C7h,0ECh ; 3135
                DB  08Fh,0ECh,071h,0FDh,030h,0FDh,000h,0FDh ; 313D
                DB  0FFh,0F4h,0D8h,0F4h,0CAh,0FDh,08Dh,0F9h ; 3145
                DB  057h,0F1h,030h,0F1h,000h,0F1h,0FFh,0F4h ; 314D
                DB  0F0h,0F4h,08Fh,0F4h,079h,0FDh,060h,0FDh ; 3155
                DB  030h,0FDh,000h,0FDh,0FFh,0FDh,0F0h,0FDh ; 315D
                DB  0D0h,0FDh,0CAh,0FDh,057h,0E6h,045h,0FFh ; 3165
                DB  000h,0FFh,0FFh,0FAh,0D5h,0FAh,0C7h,0ECh ; 316D
                DB  08Fh,0ECh,079h,0F4h,01Ch,0FFh,000h,0FFh ; 3175
                DB  0FFh,0F3h,0F0h,0F3h,0B0h,0F3h,08Dh,0F3h ; 317D
                DB  057h,0E6h,045h,0FFh,000h,0FFh,0FFh,0F4h ; 3185
                DB  0F0h,0F4h,0B0h,0F4h,08Fh,0F4h,079h,0FAh ; 318D
                DB  01Ch,0FFh,000h,0FFh,0FFh,000h,0BAh,000h ; 3195
                DB  0A9h,000h,097h,000h,086h,000h,069h,000h ; 319D
                DB  046h,000h,000h,000h,0FFh,0A4h,0D5h,09Ah ; 31A5
                DB  0AAh,090h,070h,061h,040h,038h,01Ch,01Ch ; 31AD
                DB  000h,005h,0FFh,015h,0A7h,033h,092h,040h ; 31B5
                DB  068h,066h,03Fh,0C6h,000h,0C6h,0BFh,030h ; 31BD
                DB  02Eh,000h,0BFh,00Eh,094h,000h,09Ch,000h ; 31C5
                DB  089h,005h,008h,003h,005h,032h,032h,077h ; 31CD
                DB  001h,0F7h,000h,0FAh,000h,00Ch,001h,054h ; 31D5
                DB  001h,0E7h,000h,0FAh,000h,00Ch,001h,044h ; 31DD
                DB  0A9h,032h,062h,0FFh,0FFh,000h,000h,000h ; 31E5
                DB  000h,0FFh,0FFh,000h,000h,000h,000h,0FFh ; 31ED
                DB  019h,0C6h,019h,086h,019h,050h,000h,000h ; 31F5
                DB  000h,0FFh,098h,0A1h,098h,07Ah,07Eh,044h ; 31FD
                DB  05Bh,02Eh,043h,000h,043h,0FFh,098h,0A1h ; 3205
                DB  098h,07Ah,07Eh,044h,05Bh,02Eh,043h,000h ; 320D
                DB  043h,018h,018h,025h,018h,018h,025h,030h ; 3215
                DB  028h,025h,0FFh,0D7h,0D0h,0C6h,0A9h,04Ah ; 321D
                DB  000h,000h,030h,080h,012h,05Ah,0FFh,08Ah ; 3225
                DB  066h,0F5h,08Ah,066h,0E1h,0EBh,041h,0BAh ; 322D
                DB  03Ah,020h,087h,0A6h,00Eh,028h,0E7h,008h ; 3235
                DB  000h,0E7h,008h,0FFh,08Ah,066h,0F5h,08Ah ; 323D
                DB  066h,0E1h,0EBh,041h,0BAh,03Ah,020h,087h ; 3245
                DB  0A6h,00Eh,028h,0E7h,008h,000h,0E7h,008h ; 324D
                DB  0FFh,0FFh,017h,0ABh,0FFh,017h,08Eh,000h ; 3255
                DB  012h,072h,000h,008h,063h,000h,00Bh,055h ; 325D
                DB  000h,000h,000h,000h,000h,0FFh,000h,000h ; 3265
                DB  0E9h,000h,000h,0D8h,000h,000h,0C5h,000h ; 326D
                DB  000h,0A9h,000h,004h,090h,000h,000h,000h ; 3275
                DB  000h,000h,0FFh,0FFh,01Bh,0ABh,000h,015h ; 327D
                DB  08Eh,000h,011h,072h,000h,008h,063h,000h ; 3285
                DB  00Ch,055h,000h,000h,000h,000h,000h,0FFh ; 328D
                DB  000h,008h,0E9h,000h,017h,0D8h,000h,017h ; 3295
                DB  0CAh,000h,010h,0A9h,000h,00Eh,090h,000h ; 329D
                DB  000h,000h,000h,000h,0FFh,040h,005h,0F8h ; 32A5
                DB  040h,005h,0F8h,040h,005h,08Eh,080h,002h ; 32AD
                DB  078h,000h,000h,000h,000h,000h,0F1h,080h ; 32B5
                DB  00Bh,028h,000h,008h,0FFh,08Ah,0D0h,08Ah ; 32BD
                DB  07Ah,077h,044h,057h,02Eh,044h,000h,044h ; 32C5
                DB  0FFh,094h,004h,0A1h,094h,004h,07Ah,0E2h ; 32CD
                DB  004h,044h,0A8h,006h,02Eh,0C4h,009h,000h ; 32D5
                DB  0C4h,009h,0FFh,0E2h,004h,0A1h,0E2h,004h ; 32DD
                DB  07Ah,03Bh,005h,044h,0A8h,006h,02Eh,0C4h ; 32E5
                DB  009h,000h,0C4h,009h,0C4h,009h,00Bh,009h ; 32ED
                DB  0C4h,009h,00Bh,009h,0FFh,000h,008h,0F2h ; 32F5
                DB  000h,008h,0E1h,000h,002h,0C6h,000h,002h ; 32FD
                DB  087h,000h,00Ah,065h,000h,00Ah,044h,000h ; 3305
                DB  006h,02Eh,000h,000h,000h,000h,000h,0FFh ; 330D
                DB  000h,004h,0F2h,000h,004h,0E4h,000h,001h ; 3315
                DB  0C7h,000h,001h,070h,000h,008h,04Eh,000h ; 331D
                DB  008h,03Ch,000h,006h,02Eh,000h,000h,000h ; 3325
                DB  000h,000h,057h,000h,004h,028h,020h,007h ; 332D
                DB  057h,080h,007h,028h,0A0h,00Ah,000h,003h ; 3335
                DB  004h,000h,008h,000h,000h,000h,001h,000h ; 333D
                DB  000h,000h,000h,000h,010h,000h,000h,000h ; 3345
                DB  0C0h,002h ; 334D
                                               ; 334F from 1898 (DD0,080,213)
label_334f:     MOV     DP, #00224h            ; 334F 0 080 213 622402
                CLR     X1                     ; 3352 0 080 213 9015
                                               ; 3354 from 335F (DD0,080,213)
label_3354:     LCB     A, 00038h[X1]          ; 3354 0 080 213 90AB3800
                STB     A, [DP]                ; 3358 0 080 213 D2
                INC     DP                     ; 3359 0 080 213 72
                INC     X1                     ; 335A 0 080 213 70
                CMP     X1, #00004h            ; 335B 0 080 213 90C00400
                JLT     label_3354             ; 335F 0 080 213 CAF3
                J       label_1fcf             ; 3361 0 080 213 03CF1F
                DB  03Ch,000h,000h,011h,000h,008h,000h,000h ; 3364
                DB  000h,011h,000h,008h,000h,000h,000h,0FFh ; 336C
                DB  020h,000h,0F5h,020h,000h,0E1h,012h,000h ; 3374
                DB  0D7h,01Bh,000h,0FFh,000h,012h,0F2h,000h ; 337C
                DB  012h,0D0h,000h,00Ah,0A1h,000h,006h,056h ; 3384
                DB  000h,004h,044h,080h,004h,02Eh,000h,006h ; 338C
                DB  020h,000h,009h,000h,000h,009h,030h,000h ; 3394
                DB  028h,000h,018h,000h,000h,00Ch,000h,001h ; 339C
                DB  0FFh,0C0h,000h,0E0h,0C0h,000h,0A1h,01Ah ; 33A4
                DB  000h,02Eh,007h,000h,000h,007h,000h,030h ; 33AC
                DB  000h,028h,000h,018h,000h,000h,010h,040h ; 33B4
                DB  002h,0FFh,02Eh,000h,0A1h,02Eh,000h,057h ; 33BC
                DB  01Ah,000h,02Eh,018h,000h,000h,018h,000h ; 33C4
                DB  0FFh,0FFh,000h,080h,0FFh,01Bh,000h,078h ; 33CC
                DB  060h,016h,010h,047h,0C8h,010h,0E0h,03Dh ; 33D4
                DB  030h,00Bh,0B0h,034h,000h,002h,080h,01Fh ; 33DC
                DB  000h,000h,0F0h,017h,0FFh,0FFh,08Fh,042h ; 33E4
                DB  000h,0FEh,08Fh,042h,000h,0FBh,0AEh,067h ; 33EC
                DB  000h,0F6h,0C2h,075h,000h,0F0h,000h,080h ; 33F4
                DB  000h,0E9h,01Eh,085h,000h,0E0h,000h,080h ; 33FC
                DB  000h,000h,000h,080h,0E0h,033h,0A9h,051h ; 3404
                DB  019h,097h,0CFh,033h,0A9h,051h,019h,097h ; 340C
                DB  0C7h,0CBh,0D9h,0DDh,0D0h,0D4h,0E5h,0E9h ; 3414
                DB  0FFh,0F4h,006h,0E0h,0F4h,006h,0D4h,0F4h ; 341C
                DB  006h,0D0h,0CCh,006h,0CBh,0F8h,007h,0C0h ; 3424
                DB  062h,007h,000h,062h,007h,0FFh,076h,007h ; 342C
                DB  0F0h,076h,007h,0E0h,076h,007h,0D9h,026h ; 3434
                DB  007h,0D4h,05Ch,008h,0CFh,02Ah,008h,000h ; 343C
                DB  02Ah,008h,0E7h,008h,023h,00Dh,09Ch,017h ; 3444
                DB  03Bh,033h,0EBh,041h,030h,001h,038h,001h ; 344C
                DB  09Fh,001h,08Ah,002h,024h,003h,068h,0D0h ; 3454
                DB  020h,067h,0BCh,033h,073h,01Fh,066h,00Eh ; 345C
                DB  0FFh,000h,020h,09Dh,000h,014h,00Fh,00Fh ; 3464
                DB  00Fh,02Dh,0FFh,0FFh,02Dh,00Fh,02Dh,04Bh ; 346C
                DB  02Dh,00Fh,04Bh,04Bh,006h,02Dh,003h,006h ; 3474
                DB  007h,005h,000h,000h,013h,00Ah,00Eh,008h ; 347C
                DB  011h,012h,017h,018h,015h,016h,004h,008h ; 3484
                DB  009h,00Fh,004h,008h,009h,000h,000h,000h ; 348C
                DB  000h,000h,001h,002h,000h,000h,000h,000h ; 3494
                DB  077h,011h,0EEh,022h,077h,022h,0DDh,044h ; 349C
                DB  0FFh,0FFh,0EEh,044h,077h,044h,0BBh,088h ; 34A4
                DB  0BBh,011h,0FFh,0FFh,0BBh,022h,0DDh,088h ; 34AC
                DB  0DDh,011h,0EEh,088h,000h,000h,0C7h,000h ; 34B4
                DB  02Dh,02Dh,007h,006h,019h,019h,019h,0FFh ; 34BC
                DB  0FFh,0FFh,0B8h,00Bh,0B8h,00Bh,0FFh,082h ; 34C4
                DB  096h,096h,01Ch,002h,005h,000h,000h,032h ; 34CC
                DB  000h,000h,004h,002h,000h,00Ah,001h,020h ; 34D4
                DB  000h,003h,001h,020h,001h,019h,001h,019h ; 34DC
                DB  001h,019h,001h,0FFh,001h,0FFh,001h,0FFh ; 34E4
                DB  088h,021h,0B0h,000h,003h,056h,013h,0FFh ; 34EC
                DB  0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh ; 34F4
                                               ; 34FB from 07B9 (DD0,108,20E)
label_34fb:     CMPB    r1, A                  ; 34FB 0 108 20E 21C1
                JGE     label_3502             ; 34FD 0 108 20E CD03
                J       label_07bc             ; 34FF 0 108 20E 03BC07
                                               ; 3502 from 34FD (DD0,108,20E)
label_3502:     J       label_07bf             ; 3502 0 108 20E 03BF07
                                               ; 3505 from 084C (DD1,108,3153)
label_3505:     MOV     USP, #03145h           ; 3505 1 108 3145 A1984531
                J       label_084f             ; 3509 1 108 3145 034F08
                                               ; 350C from 08FE (DD0,108,13C)
label_350c:     LB      A, #046h               ; 350C 0 108 13C 7746
                JBS     off(0011ch).7, label_3513 ; 350E 0 108 13C EF1C02
                LB      A, #054h               ; 3511 0 108 13C 7754
                                               ; 3513 from 350E (DD0,108,13C)
label_3513:     CMPB    A, 0a6h                ; 3513 0 108 13C C5A6C2
                MB      off(0011ch).7, C       ; 3516 0 108 13C C41C3F
                JLT     label_3546             ; 3519 0 108 13C CA2B
                LB      A, 0a4h                ; 351B 0 108 13C F5A4
                CMPB    A, #0fbh               ; 351D 0 108 13C C6FB
                JGE     label_3546             ; 351F 0 108 13C CD25
                CMPB    A, #013h               ; 3521 0 108 13C C613
                JLT     label_3546             ; 3523 0 108 13C CA21
                MB      C, P2.4                ; 3525 0 108 13C C5242C
                JLT     label_354f             ; 3528 0 108 13C CA25
                MOV     DP, #03561h            ; 352A 0 108 13C 626135
                CMPB    A, #070h               ; 352D 0 108 13C C670
                JGE     label_3537             ; 352F 0 108 13C CD06
                INC     DP                     ; 3531 0 108 13C 72
                CMPB    A, #050h               ; 3532 0 108 13C C650
                JGE     label_3537             ; 3534 0 108 13C CD01
                INC     DP                     ; 3536 0 108 13C 72
                                               ; 3537 from 352F (DD0,108,13C)
                                               ; 3537 from 3534 (DD0,108,13C)
label_3537:     LCB     A, [DP]                ; 3537 0 108 13C 92AA
                ADDB    A, off(001b1h)         ; 3539 0 108 13C 87B1
                JLT     label_3546             ; 353B 0 108 13C CA09
                STB     A, off(001b1h)         ; 353D 0 108 13C D4B1
                ADDB    A, off(0013ch)         ; 353F 0 108 13C 873C
                JLT     label_3546             ; 3541 0 108 13C CA03
                CMPB    A, r2                  ; 3543 0 108 13C 4A
                JLT     label_354c             ; 3544 0 108 13C CA06
                                               ; 3546 from 3519 (DD0,108,13C)
                                               ; 3546 from 351F (DD0,108,13C)
                                               ; 3546 from 3523 (DD0,108,13C)
                                               ; 3546 from 353B (DD0,108,13C)
                                               ; 3546 from 3541 (DD0,108,13C)
label_3546:     MOVB    off(001b1h), #0ffh     ; 3546 0 108 13C C4B198FF
                SJ      label_355b             ; 354A 0 108 13C CB0F
                                               ; 354C from 3544 (DD0,108,13C)
                                               ; 354C from 3555 (DD0,108,13C)
                                               ; 354C from 3559 (DD0,108,13C)
label_354c:     STB     A, r2                  ; 354C 0 108 13C 8A
                SJ      label_355b             ; 354D 0 108 13C CB0C
                                               ; 354F from 3528 (DD0,108,13C)
label_354f:     LB      A, #022h               ; 354F 0 108 13C 7722
                STB     A, off(001b1h)         ; 3551 0 108 13C D4B1
                ADDB    A, off(0013ch)         ; 3553 0 108 13C 873C
                JGE     label_354c             ; 3555 0 108 13C CDF5
                LB      A, #0ffh               ; 3557 0 108 13C 77FF
                SJ      label_354c             ; 3559 0 108 13C CBF1
                                               ; 355B from 354A (DD0,108,13C)
                                               ; 355B from 354D (DD0,108,13C)
label_355b:     MOV     X1, #031a9h            ; 355B 0 108 13C 60A931
                J       label_0901             ; 355E 0 108 13C 030109
                DB  003h,003h,003h ; 3561
                                               ; 3564 from 224B (DD0,080,0A4)
label_3564:     JBR     off(0001fh).5, label_356d ; 3564 0 080 0A4 DD1F06
                JBS     off(P3SF).6, label_356d ; 3567 0 080 0A4 EE2A03
                J       label_2250             ; 356A 0 080 0A4 035022
                                               ; 356D from 3564 (DD0,080,0A4)
                                               ; 356D from 3567 (DD0,080,0A4)
label_356d:     J       label_224e             ; 356D 0 080 0A4 034E22
                                               ; 3570 from 009A (DD0,100,???)
label_3570:     MOV     DP, #0027dh            ; 3570 0 100 ??? 627D02
                RB      [DP].2                 ; 3573 0 100 ??? C20A
                JEQ     label_357a             ; 3575 0 100 ??? C903
                CAL     label_2ec8             ; 3577 0 100 ??? 32C82E
                                               ; 357A from 3575 (DD0,100,???)
label_357a:     MOV     DP, #00036h            ; 357A 0 100 ??? 623600
                J       label_009d             ; 357D 0 100 ??? 039D00
                DB  0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh ; 3580
                DB  0FFh ; 3588
                                               ; 3589 from 2052 (DD1,080,213)
label_3589:     LB      A, TCON0               ; 3589 0 080 213 F540
                ANDB    A, #0e3h               ; 358B 0 080 213 D6E3
                CMPB    A, #080h               ; 358D 0 080 213 C680
                JNE     label_35a6             ; 358F 0 080 213 CE15
                LB      A, TCON1               ; 3591 0 080 213 F541
                ANDB    A, #0e3h               ; 3593 0 080 213 D6E3
                CMPB    A, #082h               ; 3595 0 080 213 C682
                JBR     off(P0IO).2, label_359c ; 3597 0 080 213 DA2102
                CMPB    A, #0a2h               ; 359A 0 080 213 C6A2
                                               ; 359C from 3597 (DD0,080,213)
label_359c:     JNE     label_35a6             ; 359C 0 080 213 CE08
                LB      A, TCON2               ; 359E 0 080 213 F542
                ANDB    A, #0e3h               ; 35A0 0 080 213 D6E3
                CMPB    A, #083h               ; 35A2 0 080 213 C683
                JEQ     label_35b0             ; 35A4 0 080 213 C90A
                                               ; 35A6 from 358F (DD0,080,213)
                                               ; 35A6 from 359C (DD0,080,213)
label_35a6:     MOVB    0f0h, #04bh            ; 35A6 0 080 213 C5F0984B
                DECB    0ech                   ; 35AA 0 080 213 C5EC17
                JNE     label_35b0             ; 35AD 0 080 213 CE01
                BRK                            ; 35AF 0 080 213 FF
                                               ; 35B0 from 35A4 (DD0,080,213)
                                               ; 35B0 from 35AD (DD0,080,213)
label_35b0:     LB      A, PWCON0              ; 35B0 0 080 213 F578
                ANDB    A, #07bh               ; 35B2 0 080 213 D67B
                CMPB    A, #03ah               ; 35B4 0 080 213 C63A
                JNE     label_35c0             ; 35B6 0 080 213 CE08
                LB      A, PWCON1              ; 35B8 0 080 213 F57A
                ANDB    A, #07bh               ; 35BA 0 080 213 D67B
                CMPB    A, #05ah               ; 35BC 0 080 213 C65A
                JEQ     label_35ca             ; 35BE 0 080 213 C90A
                                               ; 35C0 from 35B6 (DD0,080,213)
label_35c0:     MOVB    0f0h, #04ch            ; 35C0 0 080 213 C5F0984C
                DECB    0ech                   ; 35C4 0 080 213 C5EC17
                JNE     label_35ca             ; 35C7 0 080 213 CE01
                BRK                            ; 35C9 0 080 213 FF
                                               ; 35CA from 35BE (DD0,080,213)
                                               ; 35CA from 35C7 (DD0,080,213)
label_35ca:     JBS     off(TM0).2, label_35d0 ; 35CA 0 080 213 EA3003
                J       label_2055             ; 35CD 0 080 213 035520
                                               ; 35D0 from 35CA (DD0,080,213)
label_35d0:     J       label_2081             ; 35D0 0 080 213 038120
                                               ; 35D3 from 2696 (DD0,080,205)
label_35d3:     LB      A, 0f1h                ; 35D3 0 080 205 F5F1
                ANDB    A, #003h               ; 35D5 0 080 205 D603
                JEQ     label_35db             ; 35D7 0 080 205 C902
                CLRB    r0                     ; 35D9 0 080 205 2015
                                               ; 35DB from 35D7 (DD0,080,205)
label_35db:     MOV     DP, #001beh            ; 35DB 0 080 205 62BE01
                J       label_2699             ; 35DE 0 080 205 039926
                                               ; 35E1 from 21D3 (DD0,080,0A3)
label_35e1:     CLR     A                      ; 35E1 1 080 0A3 F9
                LB      A, 09ch                ; 35E2 0 080 0A3 F59C
                MOVB    r0, #030h              ; 35E4 0 080 0A3 9830
                J       label_21d7             ; 35E6 0 080 0A3 03D721
                DB  0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh ; 35E9
                DB  0FFh,0FFh,0FFh,0FFh ; 35F1
                                               ; 35F5 from 1351 (DD0,108,13C)
label_35f5:     JBS     off(00158h).7, label_35f9 ; 35F5 0 108 13C EF5801
                INCB    r1                     ; 35F8 0 108 13C A9
                                               ; 35F9 from 35F5 (DD0,108,13C)
label_35f9:     ADDB    A, off(0015ah)         ; 35F9 0 108 13C 875A
                STB     A, r0                  ; 35FB 0 108 13C 88
                JGE     label_35ff             ; 35FC 0 108 13C CD01
                INCB    r1                     ; 35FE 0 108 13C A9
                                               ; 35FF from 35FC (DD0,108,13C)
label_35ff:     J       label_1356             ; 35FF 0 108 13C 035613
                                               ; 3602 from 11BA (DD0,108,13C)
label_3602:     CMPB    off(001feh), #000h     ; 3602 0 108 13C C4FEC000
                JEQ     label_360a             ; 3606 0 108 13C C902
                SUBB    A, #008h               ; 3608 0 108 13C A608
                                               ; 360A from 3606 (DD0,108,13C)
label_360a:     CMPB    [DP], A                ; 360A 0 108 13C C2C1
                JLT     label_3611             ; 360C 0 108 13C CA03
                J       label_11be             ; 360E 0 108 13C 03BE11
                                               ; 3611 from 360C (DD0,108,13C)
label_3611:     J       label_11c8             ; 3611 0 108 13C 03C811
                                               ; 3614 from 126F (DD1,108,13C)
label_3614:     RB      off(00122h).4          ; 3614 1 108 13C C4220C
                MOVB    off(001feh), #00ah     ; 3617 1 108 13C C4FE980A
                J       label_12db             ; 361B 1 108 13C 03DB12
                DB  0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh ; 361E
                DB  0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh ; 3626
                                               ; 362E from 1D92 (DD1,080,213)
label_362e:     MOV     X1, #0364dh            ; 362E 1 080 213 604D36
                JBR     off(IRQ).7, label_3637 ; 3631 1 080 213 DF1803
                MOV     X1, #03662h            ; 3634 1 080 213 606236
                                               ; 3637 from 3631 (DD1,080,213)
label_3637:     LB      A, 0a6h                ; 3637 0 080 213 F5A6
                VCAL    1                      ; 3639 0 080 213 11
                MOV     USP, A                 ; 363A 0 080 213 A18A
                J       label_40e4             ; 363C 0 080 213 03E440
                                               ; 363F from 40EE (DD0,080,213)
label_363f:     JBR     off(P1IO).3, label_3648 ; 363F 0 080 213 DB2306
                MOV     X1, #0336dh            ; 3642 0 080 213 606D33
                J       label_1d95             ; 3645 0 080 213 03951D
                                               ; 3648 from 40F1 (DD0,080,213)
                                               ; 3648 from 363F (DD0,080,213)
label_3648:     CLR     er3                    ; 3648 0 080 213 4715
                J       label_1da6             ; 364A 0 080 213 03A61D
                DB  0FFh,000h,010h,0A9h,000h,00Eh,097h,000h ; 364D
                DB  00Bh,086h,000h,008h,069h,000h,005h,054h ; 3655
                DB  000h,000h,000h,000h,000h,0FFh,000h,010h ; 365D
                DB  0A9h,000h,00Eh,097h,000h,00Bh,086h,000h ; 3665
                DB  008h,069h,000h,005h,054h,000h,000h,000h ; 366D
                DB  000h,000h ; 3675
                                               ; 3677 from 0A10 (DD0,108,13C)
                ;;; mugen skips this
label_3677:     CMPB    09fh, #01fh            ; 3677 0 108 13C C59FC01F
                JLT     label_3684             ; 367B 0 108 13C CA07
                LB      A, off(0013dh)         ; 367D 0 108 13C F43D
                JNE     label_3684             ; 367F 0 108 13C CE03
                J       label_0a14             ; 3681 0 108 13C 03140A
                                               ; 3684 from 367B (DD0,108,13C)
                                               ; 3684 from 367F (DD0,108,13C)
label_3684:     J       label_0a88             ; 3684 0 108 13C 03880A
				;to here

                                               ; 3687 from 1EA5 (DD1,080,1CD)
label_3687:     CAL     label_2d78             ; 3687 1 080 1CD 32782D
                LB      A, off(000b0h)         ; 368A 0 080 1CD F4B0
                INCB    ACC                    ; 368C 0 080 1CD C50616
                JEQ     label_3693             ; 368F 0 080 1CD C902
                STB     A, off(000b0h)         ; 3691 0 080 1CD D4B0
                                               ; 3693 from 368F (DD0,080,1CD)
label_3693:     J       label_1ea8             ; 3693 0 080 1CD 03A81E
                                               ; 3696 from 23BD (DD0,080,205)
label_3696:		CLRB    A                      ; 3696 0 080 205 FA
                STB     A, off(000abh)         ; 3697 0 080 205 D4AB
                STB     A, off(000b0h)         ; 3699 0 080 205 D4B0
                J       label_23c0             ; 369B 0 080 205 03C023
                                               ; 369E from 25D8 (DD0,080,205)
label_369e:     JBS     off(P3SF).3, label_36a4 ; 369E 0 080 205 EB2A03
                J       label_25db             ; 36A1 0 080 205 03DB25
                                               ; 36A4 from 369E (DD0,080,205)
label_36a4:     JBS     off(P1IO).3, label_36ad ; 36A4 0 080 205 EB2306
                JBR     off(P2IO).3, label_36ad ; 36A7 0 080 205 DB2503
                J       label_25e1             ; 36AA 0 080 205 03E125
                                               ; 36AD from 36A4 (DD0,080,205)
                                               ; 36AD from 36A7 (DD0,080,205)
label_36ad:     J       label_25fc             ; 36AD 0 080 205 03FC25
                                               ; 36B0 from 1CBF (DD1,080,213)
label_36b0:     JBR     off(P2SF).6, label_36b9 ; 36B0 1 080 213 DE2606
                JBS     off(0001eh).4, label_36b9 ; 36B3 1 080 213 EC1E03
                J       label_1cc2             ; 36B6 1 080 213 03C21C
                                               ; 36B9 from 36B0 (DD1,080,213)
                                               ; 36B9 from 36B3 (DD1,080,213)
label_36b9:     J       label_1cff             ; 36B9 1 080 213 03FF1C

;mugen deletes this from here:
                                               ; 36BC from 252C (DD0,080,205)
label_36bc:     CMPB    09ah, #003h            ; 36BC 0 080 205 C59AC003
                JGT     label_36c8             ; 36C0 0 080 205 C806
                JBR     off(0002bh).2, label_36c8 ; 36C2 0 080 205 DA2B03
                J       label_252f             ; 36C5 0 080 205 032F25
                                               ; 36C8 from 36C0 (DD0,080,205)
                                               ; 36C8 from 36C2 (DD0,080,205)
label_36c8:     J       label_2532             ; 36C8 0 080 205 033225
;to here
                                               ; 36CB from 10DC (DD1,108,13C)
label_36cb:     MOVB    r0, #004h              ; 36CB 1 108 13C 9804
                LB      A, (00163h-0013ch)[USP] ; 36CD 0 108 13C F327
                JNE     label_36d3             ; 36CF 0 108 13C CE02
                MOVB    r0, #008h              ; 36D1 0 108 13C 9808
                                               ; 36D3 from 36CF (DD0,108,13C)
label_36d3:     LB      A, r0                  ; 36D3 0 108 13C 78
                STB     A, (00161h-0013ch)[USP] ; 36D4 0 108 13C D325
                J       label_10e0             ; 36D6 0 108 13C 03E010
                                               ; 36D9 from 0E4A (DD0,108,13C)
label_36d9:     JBR     off(0011bh).6, label_36e8 ; 36D9 0 108 13C DE1B0C
                CMPB    0a4h, #018h   ;mugen -> #000h         ; 36DC 0 108 13C C5A4C018
                JLT     label_36fd             ; 36E0 0 108 13C CA1B
                LB      A, off(001cdh)         ; 36E2 0 108 13C F4CD
                JEQ     label_36fd             ; 36E4 0 108 13C C917
                SJ      label_3700             ; 36E6 0 108 13C CB18
                                               ; 36E8 from 36D9 (DD0,108,13C)
label_36e8:     LB      A, #077h               ; 36E8 0 108 13C 7777
                JBR     off(0011dh).5, label_36ef ; 36EA 0 108 13C DD1D02
                LB      A, #069h               ; 36ED 0 108 13C 7769
                                               ; 36EF from 36EA (DD0,108,13C)
label_36ef:     CMPB    A, 0a6h                ; 36EF 0 108 13C C5A6C2
                MB      off(0011dh).5, C       ; 36F2 0 108 13C C41D3D
                JGE     label_3700             ; 36F5 0 108 13C CD09
                CMPB    0a4h, #013h   ;mugen -> #000h         ; 36F7 0 108 13C C5A4C013
                JGE     label_3700             ; 36FB 0 108 13C CD03
                                               ; 36FD from 36E0 (DD0,108,13C)
                                               ; 36FD from 36E4 (DD0,108,13C)
label_36fd:     J       label_0e54             ; 36FD 0 108 13C 03540E
                                               ; 3700 from 36E6 (DD0,108,13C)
                                               ; 3700 from 36F5 (DD0,108,13C)
                                               ; 3700 from 36FB (DD0,108,13C)
label_3700:     J       label_0e56             ; 3700 0 108 13C 03560E
                                               ; 3703 from 13D2 (DD1,108,13C)
label_3703:     MB      C, P1.1                ; 3703 1 108 13C C52229
                JGE     label_3717             ; 3706 1 108 13C CD0F
                LB      A, #0e0h      ;mugen -> #0dbh          ; 3708 0 108 13C 77E0
                ;JBR     off(00129h).0, label_370f ; 370A 0 108 13C D82902
                NOP
                NOP
                NOP
                LB      A, #0e0h               ; 370D 0 108 13C 77D8
                                               ; 370F from 370A (DD0,108,13C)
label_370f:     CMPB    A, 0a6h                ; 370F 0 108 13C C5A6C2
                ;MB      off(00129h).0, C       ; 3712 0 108 13C C42938
                NOP
                NOP
                NOP
                JLT     label_371a             ; 3715 0 108 13C CA03
                                               ; 3717 from 3706 (DD1,108,13C)
label_3717:     MOV     er0, off(00140h)       ; 3717 0 108 13C B44048
                                               ; 371A from 3715 (DD0,108,13C)
label_371a:     L       A, off(0015eh)         ; 371A 1 108 13C E45E
                J       label_13d5             ; 371C 1 108 13C 03D513
                                               ; 371F from 0D72 (DD0,108,13C)
label_371f:     LB      A, #086h               ; 371F 0 108 13C 7786
                JBR     off(00122h).0, label_3726 ; 3721 0 108 13C D82202
                LB      A, #07eh               ; 3724 0 108 13C 777E
                                               ; 3726 from 3721 (DD0,108,13C)
label_3726:     CMPB    A, 0a6h                ; 3726 0 108 13C C5A6C2
                MB      off(00122h).0, C       ; 3729 0 108 13C C42238
                JLT     label_3731             ; 372C 0 108 13C CA03
                J       label_0d89             ; 372E 0 108 13C 03890D
                                               ; 3731 from 372C (DD0,108,13C)
label_3731:     CLRB    r7                     ; 3731 0 108 13C 2715
                LB      A, off(001a1h)         ; 3733 0 108 13C F4A1
                J       label_0d76             ; 3735 0 108 13C 03760D
                                               ; 3738 from 0BA6 (DD1,108,13C)
label_3738:     MUL                            ; 3738 1 108 13C 9035
                L       A, er1                 ; 373A 1 108 13C 35
                SUB     A, #00000h             ; 373B 1 108 13C A60000
                JGE     label_3741             ; 373E 1 108 13C CD01
                CLR     A                      ; 3740 1 108 13C F9
                                               ; 3741 from 373E (DD1,108,13C)
label_3741:     J       label_0ba9             ; 3741 1 108 13C 03A90B

                org 374ch

                DB  040h,010h,010h,010h,010h,010h,010h,010h ; 374C
                DB  010h,006h,009h,008h,009h,009h,008h,00Fh ; 3754
                DB  00Eh,00Fh,01Ch,01Ch,00Eh,00Fh,00Eh,00Eh ; 375C
                DB  00Eh,00Eh,00Fh,00Eh,00Eh,00Eh,00Dh,010h ; 3764
                DB  010h,010h,010h,010h,010h,010h,010h,010h ; 376C
                DB  010h,010h,010h,010h,010h,010h,010h,010h ; 3774
                DB  010h,010h,010h,010h,010h,010h,010h,010h ; 377C
                DB  010h,010h,010h,010h,010h,010h,010h,010h ; 3784
                DB  039h,039h,039h,039h,039h,039h,039h,036h ; 378C
                DB  030h,02Ah,027h,020h,010h,010h,010h,039h ; 3794
                DB  039h,039h,039h,039h,039h,039h,036h,030h ; 379C
                DB  02Ah,029h,029h,01Fh,01Fh,01Fh,046h,046h ; 37A4
                DB  046h,046h,046h,03Eh,038h,036h,030h,030h ; 37AC
                DB  030h,02Dh,027h,027h,027h,052h,052h,052h ; 37B4
                DB  052h,04Ah,042h,03Ah,036h,030h,030h,030h ; 37BC
                DB  02Fh,02Fh,02Fh,02Fh,054h,054h,054h,054h ; 37C4
                DB  04Ch,044h,03Ch,03Ah,036h,036h,036h,036h ; 37CC
                DB  036h,036h,036h,056h,056h,056h,056h,04Eh ; 37D4
                DB  046h,040h,03Ch,03Bh,03Bh,03Bh,03Bh,03Bh ; 37DC
                DB  03Bh,03Bh,05Ah,05Ah,05Ah,05Ah,052h,04Ah ; 37E4
                DB  044h,043h,043h,043h,043h,043h,043h,043h ; 37EC
                DB  043h,060h,060h,060h,060h,05Eh,05Bh,056h ; 37F4
                DB  051h,050h,04Eh,04Ah,04Ah,04Ah,04Ah,04Ah ; 37FC
                DB  072h,072h,072h,072h,072h,06Eh,06Ah,066h ; 3804
                DB  063h,05Fh,05Bh,057h,04Fh,04Fh,04Fh,078h ; 380C
                DB  078h,078h,078h,078h,074h,070h,06Ch,068h ; 3814
                DB  064h,060h,05Ch,054h,054h,054h,075h,075h ; 381C
                DB  075h,075h,075h,070h,06Eh,06Bh,068h,065h ; 3824
                DB  061h,05Eh,058h,058h,058h,084h,084h,084h ; 382C
                DB  084h,084h,07Fh,07Ch,078h,075h,071h,06Dh ; 3834
                DB  064h,051h,051h,051h,070h,070h,070h,070h ; 383C
                DB  070h,06Dh,06Ah,067h,064h,061h,05Eh,05Bh ; 3844
                DB  048h,048h,048h,070h,070h,070h,070h,070h ; 384C
                DB  06Dh,06Ah,067h,064h,061h,05Eh,05Bh,048h ; 3854
                DB  048h,048h,070h,070h,070h,070h,070h,06Dh ; 385C
                DB  06Ah,067h,064h,061h,05Eh,05Bh,048h,048h ; 3864
                DB  048h,070h,070h,070h,070h,070h,06Dh,06Ah ; 386C
                DB  067h,064h,061h,05Eh,05Bh,048h,048h,048h ; 3874
                DB  070h,070h,070h,070h,070h,06Dh,06Ah,067h ; 387C
                DB  064h,061h,05Eh,05Bh,048h,048h,048h,022h ; 3884
                DB  022h,022h,022h,022h,022h,022h,022h,022h ; 388C
                DB  022h,022h,022h,022h,022h,022h,039h,039h ; 3894
                DB  039h,039h,039h,039h,039h,039h,039h,031h ; 389C
                DB  029h,020h,012h,012h,012h,039h,039h,039h ; 38A4
                DB  039h,039h,039h,039h,039h,039h,034h,02Eh ; 38AC
                DB  029h,024h,024h,024h,05Ah,05Ah,05Ah,05Ah ; 38B4
                DB  05Ah,056h,052h,04Eh,04Ah,046h,043h,03Fh ; 38BC
                DB  03Fh,03Fh,03Fh,06Dh,06Dh,06Dh,06Dh,06Dh ; 38C4
                DB  068h,064h,060h,05Dh,058h,054h,050h,04Dh ; 38CC
                DB  04Dh,04Dh,075h,075h,075h,075h,075h,071h ; 38D4
                DB  06Dh,069h,066h,062h,05Eh,05Ah,053h,053h ; 38DC
                DB  053h,070h,070h,070h,070h,070h,070h,070h ; 38E4
                DB  06Fh,06Ch,06Bh,067h,064h,058h,058h,058h ; 38EC
                DB  083h,083h,083h,083h,083h,083h,083h,07Fh ; 38F4
                DB  07Ch,078h,075h,06Bh,058h,058h,058h,072h ; 38FC
                DB  072h,072h,072h,072h,072h,072h,070h,06Eh ; 3904
                DB  06Ch,06Ah,068h,055h,055h,055h,070h,070h ; 390C
                DB  070h,070h,070h,070h,070h,06Eh,06Ch,06Ah ; 3914
                DB  067h,064h,055h,055h,055h,06Fh,06Fh,06Fh ; 391C
                DB  06Fh,06Fh,06Fh,06Fh,06Ch,06Bh,068h,066h ; 3924
                DB  064h,055h,055h,055h,06Fh,06Fh,06Fh,06Fh ; 392C
                DB  06Fh,06Fh,06Fh,06Ch,06Bh,068h,066h,064h ; 3934
                DB  058h,058h,058h,06Fh,06Fh,06Fh,06Fh,06Fh ; 393C
                DB  06Fh,06Fh,06Ch,06Bh,068h,066h,064h,055h ; 3944
                DB  055h,055h,06Eh,06Eh,06Eh,06Eh,06Eh,06Eh ; 394C
                DB  06Eh,06Bh,068h,065h,064h,056h,047h,047h ; 3954
                DB  047h,06Eh,06Eh,06Eh,06Eh,06Eh,06Eh,06Eh ; 395C
                DB  06Bh,068h,065h,064h,056h,047h,047h,047h ; 3964
                DB  06Eh,06Eh,06Eh,06Eh,06Eh,06Eh,06Eh,06Bh ; 396C
                DB  068h,065h,064h,056h,047h,047h,047h,06Eh ; 3974
                DB  06Eh,06Eh,06Eh,06Eh,06Eh,06Eh,06Bh,068h ; 397C
                DB  065h,064h,056h,047h,047h,047h,065h,05Dh ; 3984
                DB  087h,05Dh,07Ch,097h,05Ch,069h,073h,083h ; 398C
                DB  090h,04Fh,060h,070h,07Fh,065h,05Dh,087h ; 3994
                DB  05Dh,07Ch,097h,05Ch,069h,073h,083h,090h ; 399C
                DB  04Fh,060h,070h,07Fh,064h,05Bh,085h,060h ; 39A4
                DB  07Dh,09Bh,05Ch,06Bh,074h,084h,091h,050h ; 39AC
                DB  061h,070h,07Fh,068h,060h,08Bh,064h,081h ; 39B4
                DB  09Eh,05Fh,06Ch,077h,087h,094h,052h,061h ; 39BC
                DB  072h,080h,06Ch,063h,090h,06Ah,085h,0A1h ; 39C4
                DB  05Fh,06Eh,079h,087h,098h,052h,061h,075h ; 39CC
                DB  086h,075h,06Bh,09Ch,06Eh,08Bh,0ABh,062h ; 39D4
                DB  072h,080h,08Dh,09Ch,055h,064h,076h,088h ; 39DC
                DB  077h,06Dh,09Fh,06Fh,08Ch,0AAh,064h,073h ; 39E4
                DB  081h,08Fh,09Fh,057h,068h,077h,086h,082h ; 39EC
                DB  077h,0ADh,076h,096h,0B3h,06Ah,078h,087h ; 39F4
                DB  096h,0A5h,05Ah,06Bh,07Bh,08Bh,085h,07Ah ; 39FC
                DB  0B1h,075h,094h,0B4h,069h,078h,087h,093h ; 3A04
                DB  0A5h,05Ah,06Ch,07Dh,08Eh,07Eh,074h,0A8h ; 3A0C
                DB  073h,091h,0AEh,066h,076h,086h,095h,0A8h ; 3A14
                DB  05Bh,06Ch,07Eh,090h,088h,07Ch,0B5h,07Bh ; 3A1C
                DB  09Eh,0C0h,071h,081h,091h,0A1h,0B2h,061h ; 3A24
                DB  073h,082h,091h,087h,07Ch,0B4h,07Ah,09Eh ; 3A2C
                DB  0C0h,070h,080h,091h,09Fh,0B4h,061h,073h ; 3A34
                DB  082h,091h,07Ch,072h,0A6h,071h,092h,0B3h ; 3A3C
                DB  06Bh,079h,08Ah,09Bh,0ADh,05Fh,071h,082h ; 3A44
                DB  093h,084h,079h,0B0h,07Ah,099h,0BBh,06Eh ; 3A4C
                DB  07Eh,090h,0A5h,0B8h,068h,07Eh,086h,08Eh ; 3A54
                DB  098h,08Ch,0CBh,08Dh,0B1h,0D4h,07Dh,098h ; 3A5C
                DB  0ACh,0C0h,0D3h,072h,087h,097h,0A7h,090h ; 3A64
                DB  084h,0C0h,087h,0ACh,0D4h,07Eh,092h,0A6h ; 3A6C
                DB  0B6h,0C8h,06Ah,07Dh,08Dh,09Dh,07Bh,071h ; 3A74
                DB  0A4h,07Bh,09Eh,0C5h,079h,08Dh,09Eh,0B0h ; 3A7C
                DB  0C1h,06Ch,07Dh,087h,091h,000h,001h,001h ; 3A84
                DB  002h,002h,002h,003h,003h,003h,003h,003h ; 3A8C
                DB  004h,004h,004h,004h,07Bh,071h,0A4h,06Fh ; 3A94
                DB  08Bh,0A9h,063h,073h,083h,091h,0A2h,059h ; 3A9C
                DB  069h,07Ch,08Fh,07Bh,071h,0A4h,06Fh,08Bh ; 3AA4
                DB  0A9h,063h,073h,083h,091h,0A2h,059h,069h ; 3AAC
                DB  07Ch,08Fh,07Bh,071h,0A4h,06Fh,08Bh,0A9h ; 3AB4
                DB  063h,073h,083h,091h,0A2h,059h,069h,07Ch ; 3ABC
                DB  08Fh,07Bh,071h,0A4h,06Fh,08Bh,0A9h,063h ; 3AC4
                DB  073h,083h,091h,0A2h,059h,069h,07Ch,08Fh ; 3ACC
                DB  07Bh,071h,0A4h,06Fh,08Bh,0A9h,063h,073h ; 3AD4
                DB  083h,091h,0A2h,059h,069h,07Ch,08Fh,07Ch ; 3ADC
                DB  071h,0A5h,072h,092h,0B7h,06Bh,07Ah,08Bh ; 3AE4
                DB  09Ch,0ADh,05Eh,06Eh,07Eh,08Eh,083h,078h ; 3AEC
                DB  0AFh,078h,09Bh,0BDh,06Eh,07Eh,08Eh,09Fh ; 3AF4
                DB  0AFh,060h,072h,081h,090h,06Fh,066h,094h ; 3AFC
                DB  06Dh,08Ah,0A9h,065h,076h,087h,099h,0AAh ; 3B04
                DB  05Ch,070h,07Ch,088h,07Fh,072h,0A5h,072h ; 3B0C
                DB  091h,0B0h,069h,07Ah,08Ch,0A1h,0B4h,065h ; 3B14
                DB  078h,085h,08Dh,084h,07Dh,0B8h,083h,0A5h ; 3B1C
                DB  0CAh,077h,08Dh,0A0h,0B4h,0C8h,06Fh,082h ; 3B24
                DB  090h,098h,0A4h,098h,0DBh,099h,0BBh,0E1h ; 3B2C
                DB  084h,09Eh,0B4h,0C7h,0DBh,076h,089h,09Ah ; 3B34
                DB  0ABh,0B7h,0A8h,0F5h,0A2h,0CCh,0F6h,08Fh ; 3B3C
                DB  0A5h,0B7h,0CAh,0DDh,077h,089h,09Bh,0ADh ; 3B44
                DB  0B8h,0A9h,0F6h,0A0h,0CBh,0F5h,091h,0A5h ; 3B4C
                DB  0B7h,0CBh,0DDh,077h,08Ch,09Fh,0B2h,0B7h ; 3B54
                DB  0A8h,0F5h,0A9h,0D5h,0FFh,09Ah,0AFh,0C3h ; 3B5C
                DB  0D7h,0EDh,083h,097h,0B0h,0C9h,09Fh,092h ; 3B64
                DB  0D4h,099h,0C6h,0F7h,094h,0A8h,0BCh,0CFh ; 3B6C
                DB  0E5h,07Eh,092h,0A7h,0BCh,09Fh,092h,0D4h ; 3B74
                DB  099h,0C6h,0F7h,094h,0A8h,0BCh,0CFh,0E5h ; 3B7C
                DB  07Eh,092h,0A7h,0BCh,09Fh,092h,0D4h,099h ; 3B84
                DB  0C6h,0F7h,094h,0A8h,0BCh,0CFh,0E5h,07Eh ; 3B8C
                DB  092h,0A7h,0BCh,000h,001h,001h,002h,002h ; 3B94
                DB  002h,003h,003h,003h,003h,003h,004h,004h ; 3B9C
                DB  004h,004h,040h,010h,010h,010h,010h,010h ; 3BA4
                DB  010h,010h,010h,006h,009h,008h,009h,009h ; 3BAC
                DB  008h,00Fh,00Eh,00Fh,01Ch,01Ch,00Eh,00Fh ; 3BB4
                DB  00Eh,00Eh,00Eh,00Eh,00Fh,00Eh,00Eh,00Eh ; 3BBC
                DB  00Dh,010h,010h,010h,010h,010h,010h,010h ; 3BC4
                DB  010h,010h,010h,010h,010h,010h,010h,010h ; 3BCC
                DB  010h,010h,010h,010h,010h,010h,010h,010h ; 3BD4
                DB  010h,010h,010h,010h,010h,010h,010h,010h ; 3BDC
                DB  010h,010h,039h,039h,039h,039h,039h,039h ; 3BE4
                DB  039h,039h,039h,032h,02Bh,025h,017h,017h ; 3BEC
                DB  017h,039h,039h,039h,039h,039h,039h,039h ; 3BF4
                DB  039h,039h,034h,02Fh,02Ah,021h,021h,021h ; 3BFC
                DB  053h,053h,053h,053h,053h,053h,053h,050h ; 3C04
                DB  04Bh,046h,03Dh,038h,028h,028h,028h,059h ; 3C0C
                DB  059h,059h,059h,059h,058h,057h,053h,04Fh ; 3C14
                DB  04Ah,043h,03Fh,030h,030h,030h,060h,060h ; 3C1C
                DB  060h,060h,060h,05Eh,05Dh,059h,054h,050h ; 3C24
                DB  049h,045h,036h,033h,033h,062h,062h,062h ; 3C2C
                DB  062h,062h,061h,060h,05Bh,058h,054h,04Dh ; 3C34
                DB  049h,03Bh,036h,036h,067h,067h,067h,067h ; 3C3C
                DB  067h,066h,065h,061h,05Eh,05Bh,054h,050h ; 3C44
                DB  044h,044h,044h,073h,073h,073h,073h,073h ; 3C4C
                DB  071h,069h,065h,060h,05Bh,057h,050h,04Ah ; 3C54
                DB  04Ah,04Ah,073h,073h,073h,073h,073h,071h ; 3C5C
                DB  069h,065h,060h,05Ch,058h,050h,04Fh,04Fh ; 3C64
                DB  04Fh,073h,073h,073h,073h,073h,071h,06Eh ; 3C6C
                DB  06Ch,068h,064h,060h,05Ch,054h,054h,054h ; 3C74
                DB  075h,075h,075h,075h,075h,072h,06Eh,06Ch ; 3C7C
                DB  068h,065h,061h,05Eh,058h,058h,058h,07Bh ; 3C84
                DB  07Bh,07Bh,07Bh,07Bh,077h,073h,06Fh,06Bh ; 3C8C
                DB  068h,064h,060h,058h,058h,058h,07Bh,07Bh ; 3C94
                DB  07Bh,07Bh,07Bh,077h,073h,06Fh,06Bh,068h ; 3C9C
                DB  065h,067h,058h,058h,058h,072h,072h,072h ; 3CA4
                DB  072h,072h,072h,06Fh,06Dh,06Ah,068h,065h ; 3CAC
                DB  05Fh,050h,050h,050h,072h,072h,072h,072h ; 3CB4
                DB  072h,072h,06Fh,06Dh,06Ah,068h,065h,05Fh ; 3CBC
                DB  050h,050h,050h,072h,072h,072h,072h,072h ; 3CC4
                DB  072h,06Fh,06Dh,06Ah,068h,065h,05Fh,050h ; 3CCC
                DB  050h,050h,072h,072h,072h,072h,072h,072h ; 3CD4
                DB  06Fh,06Dh,06Ah,068h,065h,05Fh,050h,050h ; 3CDC
                DB  050h,022h,022h,022h,022h,022h,022h,022h ; 3CE4
                DB  022h,022h,022h,022h,022h,022h,022h,022h ; 3CEC
                DB  039h,039h,039h,039h,039h,039h,039h,039h ; 3CF4
                DB  039h,032h,02Bh,025h,018h,018h,018h,039h ; 3CFC
                DB  039h,039h,039h,039h,039h,039h,039h,039h ; 3D04
                DB  034h,02Fh,02Ah,022h,022h,022h,058h,058h ; 3D0C
                DB  058h,058h,058h,057h,056h,055h,052h,04Eh ; 3D14
                DB  04Ah,046h,03Fh,03Fh,03Fh,06Ch,06Ch,06Ch ; 3D1C
                DB  06Ch,06Ch,06Ah,067h,064h,060h,05Dh,059h ; 3D24
                DB  055h,04Dh,04Dh,04Dh,073h,073h,073h,073h ; 3D2C
                DB  073h,070h,06Dh,06Bh,067h,063h,05Fh,05Bh ; 3D34
                DB  052h,052h,052h,075h,075h,075h,075h,075h ; 3D3C
                DB  072h,06Eh,06Ch,068h,065h,061h,05Eh,058h ; 3D44
                DB  058h,058h,07Bh,07Bh,07Bh,07Bh,07Bh,077h ; 3D4C
                DB  073h,06Fh,06Bh,068h,064h,060h,058h,058h ; 3D54
                DB  058h,07Bh,07Bh,07Bh,07Bh,07Bh,077h,073h ; 3D5C
                DB  06Fh,06Bh,068h,065h,067h,058h,058h,058h ; 3D64
                DB  07Ah,07Ah,07Ah,07Ah,07Ah,07Ah,077h,075h ; 3D6C
                DB  072h,070h,06Dh,067h,058h,058h,058h,07Ah ; 3D74
                DB  07Ah,07Ah,07Ah,07Ah,07Ah,077h,075h,072h ; 3D7C
                DB  070h,06Dh,067h,058h,058h,058h,07Bh,07Bh ; 3D84
                DB  07Bh,07Bh,07Bh,07Bh,078h,076h,073h,071h ; 3D8C
                DB  06Eh,067h,058h,058h,058h,077h,077h,077h ; 3D94
                DB  077h,077h,077h,074h,072h,070h,06Eh,06Ch ; 3D9C
                DB  067h,058h,058h,058h,072h,072h,072h,072h ; 3DA4
                DB  072h,072h,070h,06Fh,06Dh,06Bh,06Ah,067h ; 3DAC
                DB  05Eh,05Eh,05Eh,072h,072h,072h,072h,072h ; 3DB4
                DB  072h,070h,06Fh,06Dh,06Bh,06Ah,067h,05Eh ; 3DBC
                DB  05Eh,05Eh,072h,072h,072h,072h,072h,072h ; 3DC4
                DB  070h,06Fh,06Dh,06Bh,06Ah,067h,05Eh,05Eh ; 3DCC
                DB  05Eh,072h,072h,072h,072h,072h,072h,070h ; 3DD4
                DB  06Fh,06Dh,06Bh,06Ah,067h,05Eh,05Eh,05Eh ; 3DDC
                DB  055h,04Eh,071h,059h,075h,091h,056h,063h ; 3DE4
                DB  06Fh,07Bh,089h,04Ch,05Dh,06Eh,07Fh,055h ; 3DEC
                DB  04Eh,071h,059h,075h,091h,056h,063h,06Fh ; 3DF4
                DB  07Bh,089h,04Ch,05Dh,06Eh,07Fh,057h,050h ; 3DFC
                DB  074h,05Ch,076h,093h,057h,064h,072h,082h ; 3E04
                DB  08Dh,04Eh,060h,070h,080h,067h,05Eh,089h ; 3E0C
                DB  05Fh,07Dh,099h,05Bh,068h,075h,082h,091h ; 3E14
                DB  050h,05Fh,070h,081h,06Fh,066h,094h,064h ; 3E1C
                DB  080h,09Ch,05Bh,069h,076h,083h,091h,050h ; 3E24
                DB  061h,070h,07Fh,071h,068h,097h,06Bh,088h ; 3E2C
                DB  0A4h,061h,06Fh,07Ch,08Ah,099h,053h,062h ; 3E34
                DB  071h,080h,074h,06Bh,09Bh,06Dh,089h,0A4h ; 3E3C
                DB  062h,06Eh,07Dh,08Bh,09Bh,054h,064h,074h ; 3E44
                DB  084h,07Ch,071h,0A5h,074h,093h,0AFh,068h ; 3E4C
                DB  076h,084h,093h,0A2h,058h,067h,078h,089h ; 3E54
                DB  07Fh,074h,0A9h,072h,08Eh,0AFh,067h,076h ; 3E5C
                DB  084h,093h,0A2h,05Ah,069h,07Ah,08Bh,07Dh ; 3E64
                DB  073h,0A7h,071h,08Fh,0ACh,067h,076h,085h ; 3E6C
                DB  094h,0A4h,059h,069h,07Bh,08Dh,085h,07Ah ; 3E74
                DB  0B1h,077h,098h,0BCh,06Eh,07Eh,08Ch,09Ch ; 3E7C
                DB  0ABh,05Dh,06Eh,07Fh,090h,085h,07Ah,0B2h ; 3E84
                DB  07Ah,09Dh,0BCh,06Fh,080h,090h,0A0h,0AFh ; 3E8C
                DB  060h,071h,082h,093h,07Fh,074h,0A9h,072h ; 3E94
                DB  092h,0B1h,069h,07Bh,08Bh,09Ah,0ADh,05Fh ; 3E9C
                DB  071h,07Fh,08Dh,087h,07Ch,0B4h,07Ch,09Ch ; 3EA4
                DB  0BFh,070h,082h,094h,0A3h,0B8h,068h,07Eh ; 3EAC
                DB  086h,08Eh,09Fh,092h,0D5h,08Eh,0B3h,0D4h ; 3EB4
                DB  07Fh,098h,0ACh,0C0h,0D3h,072h,087h,096h ; 3EBC
                DB  0A5h,0A3h,096h,0DAh,092h,0B9h,0E1h,083h ; 3EC4
                DB  098h,0AEh,0C1h,0D4h,072h,084h,096h,0A8h ; 3ECC
                DB  096h,08Ah,0C9h,090h,0BAh,0E0h,088h,09Eh ; 3ED4
                DB  0B1h,0C4h,0D7h,073h,088h,092h,09Ch,000h ; 3EDC
                DB  001h,001h,002h,002h,002h,003h,003h,003h ; 3EE4
                DB  003h,003h,004h,004h,004h,004h,044h,03Fh ; 3EEC
                DB  05Bh,054h,06Dh,080h,04Dh,05Ah,064h,076h ; 3EF4
                DB  085h,04Ah,05Ch,06Ch,07Ch,044h,03Fh,05Bh ; 3EFC
                DB  054h,06Dh,080h,04Dh,05Ah,064h,076h,085h ; 3F04
                DB  04Ah,05Ch,06Ch,07Ch,044h,03Fh,05Bh,054h ; 3F0C
                DB  06Dh,080h,04Dh,05Ah,064h,076h,085h,04Ah ; 3F14
                DB  05Ch,06Ch,07Ch,044h,03Fh,05Bh,054h,06Dh ; 3F1C
                DB  080h,04Dh,05Ah,064h,076h,085h,04Ah,05Ch ; 3F24
                DB  06Ch,07Ch,044h,03Fh,05Bh,054h,06Dh,080h ; 3F2C
                DB  04Dh,05Ah,064h,076h,085h,04Ah,05Ch,06Ch ; 3F34
                DB  07Ch,043h,03Dh,059h,048h,060h,07Eh,050h ; 3F3C
                DB  061h,072h,084h,094h,054h,066h,079h,08Ch ; 3F44
                DB  06Ah,061h,08Dh,064h,084h,0A2h,063h,073h ; 3F4C
                DB  082h,093h,0A5h,05Bh,06Eh,07Fh,090h,051h ; 3F54
                DB  04Ah,06Ch,04Fh,06Ch,08Bh,056h,064h,076h ; 3F5C
                DB  087h,098h,050h,064h,07Dh,096h,058h,050h ; 3F64
                DB  075h,04Fh,06Bh,087h,053h,064h,073h,084h ; 3F6C
                DB  098h,059h,070h,080h,090h,069h,060h,08Ch ; 3F74
                DB  062h,080h,0A1h,066h,078h,091h,0AEh,0C2h ; 3F7C
                DB  06Bh,07Bh,083h,08Bh,086h,07Bh,0B3h,07Ch ; 3F84
                DB  0A3h,0C6h,07Eh,096h,0ABh,0C3h,0D7h,074h ; 3F8C
                DB  086h,097h,0A8h,09Dh,090h,0D2h,08Fh,0B7h ; 3F94
                DB  0DEh,084h,09Bh,0B0h,0C3h,0D7h,073h,087h ; 3F9C
                DB  097h,0A7h,0ABh,09Dh,0E4h,09Ah,0BEh,0E8h ; 3FA4
                DB  089h,09Eh,0B3h,0C6h,0DAh,076h,08Bh,09Eh ; 3FAC
                DB  0B1h,0AFh,0A1h,0EAh,0A4h,0D3h,0FFh,09Ah ; 3FB4
                DB  0B2h,0C9h,0DEh,0F6h,088h,09Dh,0A9h,0B5h ; 3FBC
                DB  096h,08Ah,0C8h,095h,0C3h,0F7h,096h,0ADh ; 3FC4
                DB  0C5h,0E2h,0F4h,088h,09Fh,0A7h,0AFh,096h ; 3FCC
                DB  08Ah,0C8h,095h,0C3h,0F7h,096h,0ADh,0C5h ; 3FD4
                DB  0E2h,0F4h,088h,09Fh,0A7h,0AFh,096h,08Ah ; 3FDC
                DB  0C8h,095h,0C3h,0F7h,096h,0ADh,0C5h,0E2h ; 3FE4
                DB  0F4h,088h,09Fh,0A7h,0AFh,000h,001h,001h ; 3FEC
                DB  002h,002h,002h,003h,003h,003h,003h,003h ; 3FF4
                DB  004h,004h,004h,004h ; 3FFC
                                               ; 4000 from 1F0D (DD1,080,132)
label_4000:     CLR     A                      ; 4000 1 080 132 F9
                LB      A, #040h               ; 4001 0 080 132 7740
                MUL                            ; 4003 0 080 132 9035
                J       label_1f10             ; 4005 0 080 132 03101F
                                               ; 4008 from 1F25 (DD0,080,132)
label_4008:     INC     0f4h                   ; 4008 0 080 132 B5F416
                CMP     0f4h, #00140h          ; 400B 0 080 132 B5F4C04001
                JNE     label_401e             ; 4010 0 080 132 CE0C
                J       label_1f2a             ; 4012 0 080 132 032A1F
                                               ; 4015 from 1F2A (DD0,080,132)
label_4015:     CLR     0f4h                   ; 4015 0 080 132 B5F415
                LB      A, r0                  ; 4018 0 080 132 78
                ;JEQ     label_401e       ;SJ skips checksum     ; 4019 0 080 132 C903
                SJ		label_401e
                J       label_1f2d       ;checksum jump      ; 401B 0 080 132 032D1F
                                               ; 401E from 4010 (DD0,080,132)
                                               ; 401E from 4019 (DD0,080,132)
label_401e:     J       label_1f3d             ; 401E 0 080 132 033D1F
                                               ; 4021 from 11C1 (DD0,108,13C)
label_4021:     L       A, off(0014ah)         ; 4021 1 108 13C E44A
                JEQ     label_402b             ; 4023 1 108 13C C906
                JBR     off(00123h).3, label_402b ; 4025 1 108 13C DB2303
                J       label_122d             ; 4028 1 108 13C 032D12
                                               ; 402B from 4023 (DD1,108,13C)
                                               ; 402B from 4025 (DD1,108,13C)
label_402b:     J       label_12cd             ; 402B 1 108 13C 03CD12
                                               ; 402E from 10E0 (DD0,108,13C)
label_402e:     LB      A, 0f2h                ; 402E 0 108 13C F5F2
                STB     A, r0                  ; 4030 0 108 13C 88
                MOVB    r2, #006h              ; 4031 0 108 13C 9A06
                JBR     off(0010fh).7, label_4037 ; 4033 0 108 13C DF0F01
                INCB    r2                     ; 4036 0 108 13C AA
                                               ; 4037 from 4033 (DD0,108,13C)
label_4037:     LB      A, off(001d0h)         ; 4037 0 108 13C F4D0
                JNE     label_408e             ; 4039 0 108 13C CE53
                LB      A, off(00130h)         ; 403B 0 108 13C F430
                ANDB    A, #077h               ; 403D 0 108 13C D677
                JNE     label_408e             ; 403F 0 108 13C CE4D
                JBS     off(0010fh).6, label_408e ; 4041 0 108 13C EE0F4A
                CMPB    0a4h, #026h    ;mugen -> #000h        ; 4044 0 108 13C C5A4C026
                JGE     label_408e             ; 4048 0 108 13C CD44
                JBS     off(00108h).6, label_406e ; 404A 0 108 13C EE0821
                CMPB    0a6h, #062h            ; 404D 0 108 13C C5A6C062
                JGE     label_4057             ; 4051 0 108 13C CD04
                MOVB    (00192h-0013ch)[USP], #032h ; 4053 0 108 13C C3569832
                                               ; 4057 from 4051 (DD0,108,13C)
label_4057:     LB      A, (00192h-0013ch)[USP] ; 4057 0 108 13C F356
                JNE     label_405f             ; 4059 0 108 13C CE04
                LB      A, r2                  ; 405B 0 108 13C 7A
                SBR     off(0011dh)            ; 405C 0 108 13C C41D11
                                               ; 405F from 4059 (DD0,108,13C)
label_405f:     RC                             ; 405F 0 108 13C 95
                JBS     off(00108h).7, label_4097 ; 4060 0 108 13C EF0834
                LB      A, #040h               ; 4063 0 108 13C 7740
                CMPB    A, off(0015bh)         ; 4065 0 108 13C C75B
                JGE     label_4097             ; 4067 0 108 13C CD2E
                CMPB    r6, #003h              ; 4069 0 108 13C 26C003
                SJ      label_4097             ; 406C 0 108 13C CB29
                                               ; 406E from 404A (DD0,108,13C)
label_406e:     JBS     off(00123h).2, label_4074 ; 406E 0 108 13C EA2303
                LB      A, r6                  ; 4071 0 108 13C 7E
                STB     A, (0015fh-0013ch)[USP] ; 4072 0 108 13C D323
                                               ; 4074 from 406E (DD0,108,13C)
label_4074:     LB      A, r2                  ; 4074 0 108 13C 7A
                MBR     C, off(0011dh)         ; 4075 0 108 13C C41D21
                JGE     label_4092             ; 4078 0 108 13C CD18
                LB      A, #09ah               ; 407A 0 108 13C 779A
                CMPB    A, r6                  ; 407C 0 108 13C 4E
                JGE     label_408e             ; 407D 0 108 13C CD0F
                JBS     off(00123h).3, label_408e ; 407F 0 108 13C EB230C
                LB      A, (0015fh-0013ch)[USP] ; 4082 0 108 13C F323
                SUBB    A, r6                  ; 4084 0 108 13C 2E
                JGE     label_408a             ; 4085 0 108 13C CD03
                STB     A, r1                  ; 4087 0 108 13C 89
                CLRB    A                      ; 4088 0 108 13C FA
                SUBB    A, r1                  ; 4089 0 108 13C 29
                                               ; 408A from 4085 (DD0,108,13C)
label_408a:     CMPB    A, #003h               ; 408A 0 108 13C C603
                JLT     label_4097             ; 408C 0 108 13C CA09
                                               ; 408E from 4039 (DD0,108,13C)
                                               ; 408E from 403F (DD0,108,13C)
                                               ; 408E from 4041 (DD0,108,13C)
                                               ; 408E from 4048 (DD0,108,13C)
                                               ; 408E from 407D (DD0,108,13C)
                                               ; 408E from 407F (DD0,108,13C)
label_408e:     LB      A, r2                  ; 408E 0 108 13C 7A
                RBR     off(0011dh)            ; 408F 0 108 13C C41D12
                                               ; 4092 from 4078 (DD0,108,13C)
label_4092:     MOVB    (00192h-0013ch)[USP], #032h ; 4092 0 108 13C C3569832
                RC                             ; 4096 0 108 13C 95
                                               ; 4097 from 4060 (DD0,108,13C)
                                               ; 4097 from 4067 (DD0,108,13C)
                                               ; 4097 from 406C (DD0,108,13C)
                                               ; 4097 from 408C (DD0,108,13C)
label_4097:     JBS     off(0010fh).7, label_409f ; 4097 0 108 13C EF0F05
                MB      off(0012dh).4, C       ; 409A 0 108 13C C42D3C
                SJ      label_40a2             ; 409D 0 108 13C CB03
                                               ; 409F from 4097 (DD0,108,13C)
label_409f:     MB      off(0012dh).5, C       ; 409F 0 108 13C C42D3D
                                               ; 40A2 from 409D (DD0,108,13C)
label_40a2:     J       label_112a             ; 40A2 0 108 13C 032A11
                DB  0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh ; 40A5
                DB  0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh ; 40AD
                                               ; 40B5 from 0D9A (DD1,108,13C)
label_40b5:     RC                             ; 40B5 1 108 13C 95
                JBS     off(00118h).7, label_40bc ; 40B6 1 108 13C EF1803
                J       label_0d9d             ; 40B9 1 108 13C 039D0D
                                               ; 40BC from 40B6 (DD1,108,13C)
label_40bc:     J       label_0d9f             ; 40BC 1 108 13C 039F0D
                                               ; 40BF from 0D9F (DD1,108,13C)
label_40bf:     MB      off(00124h).0, C       ; 40BF 1 108 13C C42438
                CMPB    0a4h, #032h            ; 40C2 1 108 13C C5A4C032
                J       label_0da3             ; 40C6 1 108 13C 03A30D
                                               ; 40C9 from 2410 (DD0,080,205)
label_40c9:     JBR     off(P0).4, label_40d2  ; 40C9 0 080 205 DC2006
                JBS     off(P2).0, label_40d2  ; 40CC 0 080 205 E82403
                J       label_2413             ; 40CF 0 080 205 031324
                                               ; 40D2 from 40C9 (DD0,080,205)
                                               ; 40D2 from 40CC (DD0,080,205)
label_40d2:     J       label_241d             ; 40D2 0 080 205 031D24
                DB  0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh ; 40D5
                DB  0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh ; 40DD
                                               ; 40E4 from 363C (DD0,080,213)
label_40e4:     LB      A, 0adh                ; 40E4 0 080 213 F5AD
                MB      C, ACC.7               ; 40E6 0 080 213 C5062F
                MB      PSWL.5, C              ; 40E9 0 080 213 A33D
                JBR     off(P2).1, label_40f1  ; 40EB 0 080 213 D92403
                J       label_363f             ; 40EE 0 080 213 033F36
                                               ; 40F1 from 40EB (DD0,080,213)
label_40f1:     J       label_3648             ; 40F1 0 080 213 034836
                                               ; 40F4 from 0EBC (DD1,108,13C)
label_40f4:     MOV     er2, #08000h           ; 40F4 1 108 13C 46980080
                LB      A, off(00130h)         ; 40F8 0 108 13C F430
                ANDB    A, #014h               ; 40FA 0 108 13C D614
                JNE     label_4105             ; 40FC 0 108 13C CE07
                MOV     er2, #08000h           ; 40FE 0 108 13C 46980080
                J       label_0ec0             ; 4102 0 108 13C 03C00E
                                               ; 4105 from 40FC (DD0,108,13C)
label_4105:     J       label_10cf             ; 4105 0 108 13C 03CF10
                                               ; 4108 from 0A06 (DD1,108,13C)
label_4108:     CAL     label_4187             ; 4108 1 108 13C 328741
                LB      A, 0b3h                ; 410B 0 108 13C F5B3
                STB     A, 0edh                ; 410D 0 108 13C D5ED
                J       label_1514             ; 410F 0 108 13C 031415
                                               ; 4112 from 1134 (DD0,108,13C)
label_4112:     LB      A, off(00130h)         ; 4112 0 108 13C F430
                ANDB    A, #074h               ; 4114 0 108 13C D674
                JNE     label_417e             ; 4116 0 108 13C CE66
                MOVB    r0, 0edh               ; 4118 0 108 13C C5ED48
                LB      A, 0b3h                ; 411B 0 108 13C F5B3
                STB     A, 0edh                ; 411D 0 108 13C D5ED
                SUBB    A, r0                  ; 411F 0 108 13C 28
                JGE     label_4123             ; 4120 0 108 13C CD01
                CLRB    A                      ; 4122 0 108 13C FA
                                               ; 4123 from 4120 (DD0,108,13C)
label_4123:     STB     A, r0                  ; 4123 0 108 13C 88
                CMP     off(0016ch), #00180h   ; 4124 0 108 13C B46CC08001
                JGE     label_417e             ; 4129 0 108 13C CD53
                LB      A, #006h               ; 412B 0 108 13C 7706
                JBS     off(00128h).5, label_4132 ; 412D 0 108 13C ED2802
                LB      A, #014h               ; 4130 0 108 13C 7714
                                               ; 4132 from 412D (DD0,108,13C)
label_4132:     CMPB    A, 0a6h                ; 4132 0 108 13C C5A6C2
                MB      off(00128h).5, C       ; 4135 0 108 13C C4283D
                JGE     label_417e             ; 4138 0 108 13C CD44
                LB      A, #0cbh               ; 413A 0 108 13C 77CB
                JBS     off(00128h).6, label_4141 ; 413C 0 108 13C EE2802
                LB      A, #0cfh               ; 413F 0 108 13C 77CF
                                               ; 4141 from 413C (DD0,108,13C)
label_4141:     CMPB    A, 0b3h                ; 4141 0 108 13C C5B3C2
                MB      off(00128h).6, C       ; 4144 0 108 13C C4283E
                JLT     label_417e             ; 4147 0 108 13C CA35
                CMPB    r0, #003h              ; 4149 0 108 13C 20C003
                JGE     label_417e             ; 414C 0 108 13C CD30
                LB      A, 0afh                ; 414E 0 108 13C F5AF
                JBS     off(00122h).3, label_4155 ; 4150 0 108 13C EB2202
                LB      A, 0adh                ; 4153 0 108 13C F5AD
                                               ; 4155 from 4150 (DD0,108,13C)
label_4155:     CMPB    A, #083h               ; 4155 0 108 13C C683
                JBS     off(00118h).7, label_415c ; 4157 0 108 13C EF1802
                CMPB    A, #083h               ; 415A 0 108 13C C683
                                               ; 415C from 4157 (DD0,108,13C)
label_415c:     JGE     label_417e             ; 415C 0 108 13C CD20
                MOV     X1, #0419bh            ; 415E 0 108 13C 609B41
                LB      A, 0a4h                ; 4161 0 108 13C F5A4
                VCAL    0                      ; 4163 0 108 13C 10
                LB      A, off(0013fh)         ; 4164 0 108 13C F43F
                MOVB    r0, #0cch              ; 4166 0 108 13C 98CC
                MULB                           ; 4168 0 108 13C A234
                LB      A, ACCH                ; 416A 0 108 13C F507
                STB     A, off(0013fh)         ; 416C 0 108 13C D43F
                ADDB    A, r6                  ; 416E 0 108 13C 0E
                STB     A, r2                  ; 416F 0 108 13C 8A
                MOV     X1, #02f46h            ; 4170 0 108 13C 60462F
                LB      A, 0a4h                ; 4173 0 108 13C F5A4
                VCAL    0                      ; 4175 0 108 13C 10
                MOVB    r7, r2                 ; 4176 0 108 13C 224F
                CAL     label_2b91             ; 4178 0 108 13C 32912B
                J       label_113d             ; 417B 0 108 13C 033D11
                                               ; 417E from 4116 (DD0,108,13C)
                                               ; 417E from 4129 (DD0,108,13C)
                                               ; 417E from 4138 (DD0,108,13C)
                                               ; 417E from 4147 (DD0,108,13C)
                                               ; 417E from 414C (DD0,108,13C)
                                               ; 417E from 415C (DD0,108,13C)
label_417e:     CAL     label_4187             ; 417E 0 108 13C 328741
                MOV     X1, #02f46h            ; 4181 0 108 13C 60462F
                J       label_1137             ; 4184 0 108 13C 033711
                                               ; 4187 from 4108 (DD1,108,13C)
                                               ; 4187 from 417E (DD0,108,13C)
label_4187:     LB      A, 0a4h                ; 4187 0 108 13C F5A4
                MOV     X1, #0419bh            ; 4189 0 108 13C 609B41
                VCAL    0                      ; 418C 0 108 13C 10
                STB     A, r2                  ; 418D 0 108 13C 8A
                LB      A, 0a4h                ; 418E 0 108 13C F5A4
                MOV     X1, #02f56h            ; 4190 0 108 13C 60562F
                VCAL    0                      ; 4193 0 108 13C 10
                SUBB    A, r2                  ; 4194 0 108 13C 2A
                JGE     label_4198             ; 4195 0 108 13C CD01
                CLRB    A                      ; 4197 0 108 13C FA
                                               ; 4198 from 4195 (DD0,108,13C)
label_4198:     STB     A, off(0013fh)         ; 4198 0 108 13C D43F
                RT                             ; 419A 0 108 13C 01
                DB  0FFh,069h,0F5h,069h,0E1h,05Ah,0BAh,057h ; 419B
                DB  087h,056h,030h,04Bh,028h,040h,000h,040h ; 41A3
                                               ; 41AB from 1678 (DD0,???,???)
label_41ab:     MOVB    WDT, #03ch             ; 41AB 0 ??? ??? C511983C

				;datalogging change
                MOV     SSP, #0025ah           ; from 260h to 25ah

                J       label_167c             ; 41B3 0 ??? ??? 037C16
                                               ; 41B6 from 0D04 (DD0,108,13C)
label_41b6:     L       A, #041d3h             ; 41B6 1 108 13C 67D341
                JBS     off(00118h).7, label_41c2 ; 41B9 1 108 13C EF1806
                MOV     DP, #031dch				;rev addy
                L       A, #041dbh             ; 41BF 1 108 13C 67DB41
                                               ; 41C2 from 41B9 (DD1,108,13C)

                ;revlimit stuff

                ;the feels pw0 changed thse vals to something smaller too.
                ;hmmmmmmmmmm...
label_41c2:     MOV     er0, #00000h			;maybe speed lim disable
				;MOV     er0, #003cfh			;mugen -> #00000h
                MB      C, 0f2h.7              ; load limit bit
                JGE     label_41d0             ; if not on the rev limiter then we jump
                MOV     DP, A                  ; else, load the restart vector??
                ;MOV     er0, #003e0h			;mugen -> #00002h
                MOV     er0, #00002h			;maybe speed lim disable

label_41d0:     J       label_0d0a             ; 41D0 1 108 13C 030A0D
				;jump to limit routine

                DB  077h,001h,0FEh,000h,001h,001h,014h,001h ; 41D3
                DB  054h,001h,0EDh,000h,001h,001h,014h,001h ; 41DB
                                               ; 41E3 from 2820 (DD0,080,132)
label_41e3:     CMPB    off(000abh), #014h     ; 41E3 0 080 132 C4ABC014
                JLT     label_41ef             ; 41E7 0 080 132 CA06
                JBS     off(P2).1, label_41ef  ; 41E9 0 080 132 E92403
                J       label_2823             ; 41EC 0 080 132 032328
                                               ; 41EF from 41E7 (DD0,080,132)
                                               ; 41EF from 41E9 (DD0,080,132)
label_41ef:     J       label_283b             ; 41EF 0 080 132 033B28
                                               ; 41F2 from 1D78 (DD0,108,3153)
label_41f2:     JGE     label_4201             ; 41F2 0 108 3153 CD0D
                JBR     off(00128h).7, label_41fb ; 41F4 0 108 3153 DF2804
                SRLB    A                      ; 41F7 0 108 3153 63
                J       label_1d7b             ; 41F8 0 108 3153 037B1D
                                               ; 41FB from 41F4 (DD0,108,3153)
label_41fb:     CMPB    0a6h, #069h    ;mugen -> #000h        ; 41FB 0 108 3153 C5A6C069
                JGE     label_4208             ; 41FF 0 108 3153 CD07
                                               ; 4201 from 41F2 (DD0,108,3153)
label_4201:     MOVB    off(001dah), #03ch     ; 4201 0 108 3153 C4DA983C
                RC                             ; 4205 0 108 3153 95
                SJ      label_420c             ; 4206 0 108 3153 CB04
                                               ; 4208 from 41FF (DD0,108,3153)
label_4208:     CMPB    off(001dah), #001h     ; 4208 0 108 3153 C4DAC001
                                               ; 420C from 4206 (DD0,108,3153)
label_420c:     MB      off(00128h).7, C       ; 420C 0 108 3153 C4283F
                J       label_0880             ; 420F 0 108 3153 038008
                                               ; 4212 from 23FA (DD0,080,205)
label_4212:     JBR     off(P3).7, label_421b  ; 4212 0 080 205 DF2806
                JBS     off(TMR0).1, label_421b ; 4215 0 080 205 E93203
                J       label_23fd             ; 4218 0 080 205 03FD23
                                               ; 421B from 4212 (DD0,080,205)
                                               ; 421B from 4215 (DD0,080,205)
label_421b:     J       label_23fe             ; 421B 0 080 205 03FE23
                                               ; 421E from 2611 (DD0,080,205)
label_421e:     CMP     off(ADCR6), #0012bh    ; 421E 0 080 205 B46CC02B01
                JLT     label_4228             ; 4223 0 080 205 CA03
                J       label_2614             ; 4225 0 080 205 031426
                                               ; 4228 from 4223 (DD0,080,205)
label_4228:     J       label_2624             ; 4228 0 080 205 032426
                                               ; 422B from 2EDF (DD0,080,1CD)
label_422b:     LCB     A, [X1]                ; 422B 0 080 1CD 90AA
                JNE     label_4234             ; 422D 0 080 1CD CE05
                CMPB    0a6h, #080h            ; 422F 0 080 1CD C5A6C080
                ROLB    A                      ; 4233 0 080 1CD 33
                                               ; 4234 from 422D (DD0,080,1CD)
label_4234:     ADDB    A, [DP]                ; 4234 0 080 1CD C282
                J       label_2ee3             ; 4236 0 080 1CD 03E32E
                                               ; 4239 from 128D (DD0,108,13C)
label_4239:     MB      off(00122h).5, C       ; 4239 0 108 13C C4223D
                RC                             ; 423C 0 108 13C 95
                LB      A, off(001feh)         ; 423D 0 108 13C F4FE
                JEQ     label_4242             ; 423F 0 108 13C C901
                SC                             ; 4241 0 108 13C 85
                                               ; 4242 from 423F (DD0,108,13C)
label_4242:     MB      off(0011dh).0, C       ; 4242 0 108 13C C41D38
                J       label_1290             ; 4245 0 108 13C 039012
                                               ; 4248 from 129F (DD0,108,13C)
label_4248:     JBR     off(0011dh).0, label_4251 ; 4248 0 108 13C D81D06
                MOVB    r2, #002h              ; 424B 0 108 13C 9A02
                MOVB    r0, #007h              ; 424D 0 108 13C 9807
                MOVB    r1, #0ffh              ; 424F 0 108 13C 99FF
                                               ; 4251 from 4248 (DD0,108,13C)
label_4251:     LB      A, #080h               ; 4251 0 108 13C 7780
                SUBB    A, [DP]                ; 4253 0 108 13C C2A2
                J       label_12a3             ; 4255 0 108 13C 03A312
                                               ; 4258 from 107B (DD0,108,13C)
label_4258:     LB      A, (00163h-0013ch)[USP] ; 4258 0 108 13C F327
                JNE     label_4263             ; 425A 0 108 13C CE07
                SUB     DP, #00004h            ; 425C 0 108 13C 92A00400
                J       label_107f             ; 4260 0 108 13C 037F10
                                               ; 4263 from 425A (DD0,108,13C)
label_4263:     J       label_1089             ; 4263 0 108 13C 038910

launch:			CMPB	0cbh, #00Ah  ;compare speed with 10 kph, speed-10kph
				JGT		launch2      ;if the speed > the ftl speed then use the val already in A
				L		A, #00202h   ;else load the FTL rpm (~3600)
				MB      C, 0f2h.7	 ;are we already on the revlimit?
				JGT		launch2		 ;No? then we jump and use the limit
				ADD		A, #00001h	 ;else yes, we use this, the restart
launch2:		MB      C, P2.4      ;do the line we replaced
				RT

;*************************************************************
; X2 = width of the current row for interpolation.
; also, this stores the fuel row number into 17ch and ign row into 17dh for logging.
; DP has the scalar pointer

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
				STB		A, off(001e1h)			; fuel row inerp

                SJ		leavestore

                ;do stuff for ignition storing
storeign:       STB		A, off(0017dh)			; store the ignition row into 17d for me

				LB		A, r7
				STB		A, off(001e2h)			; ign row inerp

leavestore:     RT
;
;*************************************************************
				;************************
				;datalogging...
				;ORG		4300h
serial_rx_int:  L       A, 0ceh                ; 4300 1 ??? ??? E5CE
                ST      A, IE                  ; 4302 1 ??? ??? D51A
                SB      PSWH.0                 ; 4304 1 ??? ??? A218
                MOV     LRB, #0004bh           ; 4306 1 258 ??? 574B00
                L       A, DP                  ; 4309 1 258 ??? 42
                PUSHS   A                      ; 430A 1 258 ??? 55
                CLR     A                      ; 430B 1 258 ??? F9
                LB      A, SRBUF               ; 430C 0 258 ??? F555
                CMPB    r7, #000h              ; 430E 0 258 ??? 27C000
                JNE     label_431f             ; 4311 0 258 ??? CE0C
                STB     A, r6                  ; 4313 0 258 ??? 8E
                INCB    r7                     ; 4314 0 258 ??? AF
                CMPB    A, #010h               ; 4315 0 258 ??? C610
                JLT     label_435f             ; 4317 0 258 ??? CA46
                CMPB    A, #0ffh               ; 28h
                JLE     label_434a             ; 431B 0 258 ??? CF2D
                SJ      label_435f            ; 431D 0 258 ??? CB40
                                               ; 431F from 4311 (DD0,258,???)
label_431f:     CMPB    r7, #001h              ; 431F 0 258 ??? 27C001
                JNE     label_4328             ; 4322 0 258 ??? CE04
                STB     A, r5                  ; 4324 0 258 ??? 8D
                INCB    r7                     ; 4325 0 258 ??? AF
                SJ      label_435f             ; 4326 0 258 ??? CB37
                                               ; 4328 from 4322 (DD0,258,???)
label_4328:     CMPB    r7, #002h              ; 4328 0 258 ??? 27C002
                JNE     label_4339             ; 432B 0 258 ??? CE0C
                STB     A, r4                  ; 432D 0 258 ??? 8C
                INCB    r7                     ; 432E 0 258 ??? AF
                CMPB    r6, #001h              ; 432F 0 258 ??? 26C001
                JNE     label_435f             ; 4332 0 258 ??? CE2B
                MOV     DP, er0                ; 4334 0 258 ??? 447A
                LB      A, [DP]                ; 4336 0 258 ??? F2
                SJ      label_435b             ; 4337 0 258 ??? CB22
                                               ; 4339 from 432B (DD0,258,???)
label_4339:     CMPB    r6, #002h              ; 4339 0 258 ??? 26C002
                JNE     label_4359             ; 433C 0 258 ??? CE1B
                CMPB    r7, #003h              ; 433E 0 258 ??? 27C003
                JNE     label_4359             ; 4341 0 258 ??? CE16
                MOV     DP, er0                ; 4343 0 258 ??? 447A
                STB     A, [DP]                ; 4345 0 258 ??? D2
                LB      A, #0aah               ; 4346 0 258 ??? 77AA
                SJ      label_435b             ; 4348 0 258 ??? CB11

                                               ; 434A from 431B (DD0,258,???)
label_434a:     CMPB	A, #030h
				JLE		fromtable
				L       A, ACC                 ;dd = 1
                AND		A, #0ffh
                ADD		A, #00200h
                SJ		loadbyte

fromtable:		SUBB    A, #010h               ; 434A 0 258 ??? A610
                L       A, ACC                 ; 434C 1 258 ??? E506
                SLL     A                      ; 434E 1 258 ??? 53
                ADD     A, #logger_table       ; 434F 1 258 ??? 867043
		        MOV     DP, A                  ; 4352 1 258 ??? 52
                LC      A, [DP]                ; 4353 1 258 ??? 92A8


loadbyte:       MOV     DP, A                  ; 4355 1 258 ??? 52
                LB      A, [DP]                ; 4356 0 258 ??? F2
                SJ      label_435b             ; 4357 0 258 ??? CB02
                                               ; 4359 from 433C (DD0,258,???)
                                               ; 4359 from 4341 (DD0,258,???)
label_4359:     LB      A, #055h               ; 4359 0 258 ??? 7755
                                               ; 435B from 4357 (DD0,258,???)
                                               ; 435B from 4337 (DD0,258,???)
                                               ; 435B from 4348 (DD0,258,???)
label_435b:     STB     A, STBUF               ; 435B 0 258 ??? D551
                CLRB    r7                     ; 435D 0 258 ??? 2715
                                               ; 435F from 4317 (DD0,258,???)
                                               ; 435F from 431D (DD0,258,???)
                                               ; 435F from 4326 (DD0,258,???)
                                               ; 435F from 4332 (DD0,258,???)
label_435f:     POPS    A                      ; 435F 1 258 ??? 65
                MOV     DP, A                  ; 4360 1 258 ??? 52
                L       A, 0cch                ; 4361 1 258 ??? E5CC
                RB      PSWH.0                 ; 4363 1 258 ??? A208
                ST      A, IE                  ; 4365 1 258 ??? D51A
                RTI

;***********************************************************************
		ORG 	04340h
;		BOOST FUNCTIONS
;***********************************************************************
;correct column - adds the correction to the column
;and makes sure the column is within the limits

;if PSWL.5 == 0 then we add else we subtract
;b4h = the correction
;b3h = calulated map value.
;b2h = cal val from map scalar

;on return
;b5h = corrected column value: 0 <= b5h <= colsize-2
;b4h = corrected nibble for table inerpolation

correctcol:		MOV		X1, #colsize
				CLR		A				;clear AH
				LB		A, 0b4h			;load the correction
				JEQ		nocorr			;if no correction then we just check and finish

				RB      PSWL.5			; our indicator
				JEQ		addcol			; if it was 0 then we add

				;****************else we subtract
				LB		A, 0b3h			; these 2 lines get the correction
				ANDB	A, #00fh		; least sig nibble
				ADDB	A, #0f0h		; make A >= f0h
				SUBB	A, 0b4h			; subtract the correction
				JLT		undercorr		; if A was < the correction then we jump
				SJ		ccorresume1		; else we are good

undercorr:		LB		A, #000h

ccorresume1:	STB		A, r4			; store in r4
				CMPB	A, #0dfh		; compare with dfh
				JLE		st_sub_cor
				ANDB	A, #00fh		; least sig nibble
				ADDB	A, #0d0h		; make A <= d0h
st_sub_cor:		STB		A, 0b4h			; correct nibble for interpolation

				LB		A, r4			; get the calc val back.
				SRL		A
				SRL		A
				SRL		A
				SRL		A
				STB		A, r4			; store
				LB		A, #00fh
				SUBB	A, r4			; A = fh - r4
				STB		A, r4			; r4 now has the column change
				LB		A, 0b2h			; load the column
				SUBB	A, r4			; A = new column
				JLT		undercorr1		; if current column < correction, jump
				SJ		ccorresume2

undercorr1:		LB		A, #000h

ccorresume2:	STB		A, 0b5h
				SJ		ccordone

				;*****add correction
addcol:			LB		A, 0b3h			; these 2 lines get the correction
				ANDB	A, #00fh		; least sig nibble
				ADDB	A, 0b4h			; add the correction
				JLT		overcorr		; if carry then its over ffh
				SJ		ccorresume		; else we are good

overcorr:		LB		A, #0ffh		; set to ffh if the correction was huge.

ccorresume:		STB		A, r4			; store the corrected nibble into b4h
				SRL		A				;
				SRL		A				;
				SRL		A				;
				SRL		A				; shift right x4 to get the column correction
				ADDB	A, 0b2h			; add that shit to b2h
				STB		A, 0b5h			; store it in b5h

				LB		A, r4
				CMPB	A, #0dfh		; compare result to dfh
				JLT		st_add_cor		; if addition result is < #dfh then we are ok
				LB		A, #0dfh		; else we set  it to dfh;

st_add_cor:		STB		A, 0b4h
				SJ		ccordone		; we're done adding
				;*********************

nocorr:			LB		A, 0b3h			; put b3h
				STB		A, 0b4h			; in b4h
				LB		A, 0b2h			; put b2h
				STB		A, 0b5h			; in b5h

				;should be: if(maxcol >= b5h) then return else b5h = maxcol;
ccordone:		LCB		A, [X1]			; load column size
				SUBB	A, #002h		; get highest column
				CMPB	A, 0b5h			; compre to the currently stored column
				JGE		ccorreturn		; if(maxcol >= b5h) then return
				STB		A, 0b5h			; else we store the highest column value

ccorreturn:		RT

;this function is way too long.. bleh
;****************************************************************************

xswap:			L		A, X1					; swap
				MOV     X1, X2					; X1 = scalar pointer
				MOV		X2, A					; swap
				MOV		DP, X1					; store the scalar pointer in DP
				RT

;****************************************************************************

                ;was 12 bytes
                ;does this only if fuel map
                ;we need to load rows*columns
                ;and compare with (rows*coulmns)+1
                ;gonna be a function
;getfuelmult:    MOV     DP, #tablesize			;
;                LC      A, [DP]					; get table size
;                ADD		X1, A					; add table size to X1
;                CLR		A						; make AH = 0;
;                LCB     A, [X1]					; load multiplier
;                INC		X1						; X1++
;                MOV     USP, A					; move the multiplier into USP
;                CMPCB   A, [X1]					; compare with next multiplier
;                MB      C, zp_PSWH.6			;
;                MB      PSWL.4, C
;                DEC		X1						; X1--
;                LC		A, [DP]					; load the table size again
;                SUB		X1, A					; get X1 back to the current column

;                J		getrow					; go back to the routine
;****************************************************************************
initcolumn:		MOVB	0b2h, #00ah
				MOVB	0b5h, #00ah
				MOVB	0b3h, #0a0h
				MOVB	0b4h, #0a0h
				RT

;****************************************************************************
; this function calculates the high nibble of b3h ram based on current row and max row.
; Its a percentage thing. If there are 30 columns and the current column is 15 then we are half way
; through the map and b3h (the map image location) will show the rest of the stock code a false
; value that says we are half way through the map. Its like this so if the user has a huge map,
; the stock code (code besides the table interp) doesnt think we are full throttle when we arent.

; the low nibble will have the proper value for interpolation
; b3h will never see over dfh.

;er1 has vcal 1 val
;A = b2h which has the column
;use X1 to get colsize

;div = <er0A> = <er0A> / er2
;divb = AL = A/r0 remainder in r1

calcb3h:        L       A, er1                 ; 338B 1 108 20E 35
                CMP     A, #000dfh             ; 338C 1 108 20E C6DF00
                JLE     calcb3hrt             ; 338F 1 108 20E CF06
                LB      A, ACC                 ; 3391 0 108 20E F506
                ANDB    A, #00fh               ; 3393 0 108 20E D60F
                ADDB    A, #0d0h               ; 3395 0 108 20E 86D0
                                               ; 3397 from 338F (DD1,108,20E)
calcb3hrt:      LB      A, ACC                 ; 3397 0 108 20E F506
                RT                             ; 3399 0 108 20E 01

;calcb3h:		MOVB	r0, #00dh			; move in 13. AL has column.
;				MULB						; A = AL*r0 = current col*dh
;				L		A, ACC				; dd = 1
;				ST		A, er2				; save A
;
;				MOV		X1, #colsize
;				LCB		A, [X1]				; load the column size
;				SUBB	A, #002h			; A = the max column
;				STB		A, r0				; store max col in r0
;				L		A, er2				; get (current column*dh) back
;				LB		A, ACC				; dd = 0
;				DIVB						; AL = (current column*dh)/max column == b3h high nibble
;				SLLB	A
;				SLLB	A
;				SLLB	A
;				SLLB	A
;				STB		A, r0				; save the high nibble
;
;				LB		A, r2				; load low byte of calced val
;				ANDB    A, #00fh			; get least sig nibble
;				ADDB	A, r0				; add the high nibble
;
;				CMPB	A, #0dfh			;
;				JLE		calcb3hrt			; if calculated b3h value <= #dfh then return
;				LB		A, #0dfh			; else A = #dfh
;calcb3hrt:		RT							; return


;****************************************************************************
;extra features n stuff. lets make this shit uniform...

ORG		05000h

;**************
nocode:			MOV		DP, #nosetcodes			; h ;load the vectoraddy

nocodeloop:		LCB		A, [DP]					; load a code from the vector
				CMPB	A, #000h				; if its 0 then its the end of the vector
				JEQ		setcode					; so get out of loop
				CMPB	A, #0ffh				; also, if its ffh then we are done
				JEQ		setcode					; get out
				CMPB	A, r6					; compare loaded code to attempted code
				JEQ		dontsetcode				; if they are the same then we dont set it
				SJ		nocodeloop				; loop

setcode:		LB		A, r1					; else do the
				SBR     00130h[X1]				; lines we replaced
				SBR     0027bh[X1]
				RT								; jump back

dontsetcode:	RT								; we did not set the code...



;****************************************************************************

;The static tables will be limited to a size of 30x30, which is fucking huge.

ORG		063d2h

;***************** the column scalars
; - there will be (colsize+1)*3 bytes. there will be 1 tripplet for each column used. the
;   columns are in decending order.
; - the first 3 bytes will be: ffh,xxh,yyh where yyxx/10h is the highest column used
; - the second 3 bytes will be: MAXh, xxh, yyh where MAXh is the max map/tps value
;   used and yyxxh is the highest column used.
; - every successive tripplet will be: xxh,yyh,zzh where xxh is the map/tps value for
;   that column, zzyyh/10h is the column, and (yyh AND fh) is the interpolation value
				;	|	  max     | max map val  |    col 13    | ...
mapscalar:		DB	0ffh,03fh,001h,0feh,03fh,001h,0f0h,030h,001h,0e0h,020h,001h
				DB	0d0h,010h,001h,0c0h,000h,001h,0b0h,0f0h,000h,0a0h,0e0h,000h
				DB	090h,0d0h,000h,080h,0c0h,000h,070h,0b0h,000h,068h,0a0h,000h
				DB	060h,090h,000h,058h,080h,000h,050h,070h,000h,048h,060h,000h
				DB	040h,050h,000h,038h,040h,000h,030h,030h,000h,028h,020h,000h
				DB	020h,010h,000h,000h,000h,000h

ORG		0642fh
tpsscalar:		DB	0ffh,0dfh,000h,0e5h,0dfh,000h,0d9h,0d0h,000h,0ceh,0c0h,000h
				DB	0c2h,0b0h,000h,0b7h,0a0h,000h,0abh,090h,000h,0a0h,080h,000h
				DB	089h,070h,000h,072h,060h,000h,05bh,050h,000h,044h,040h,000h
				DB	039h,030h,000h,02dh,020h,000h,016h,010h,000h,000h,000h,000h

;***************** the row scalars
;
; - rev scalars are to be used with vcal_0
; - there will be (rowsize+1)*2 bytes in the scalars
; - format for first 2 bytes:	0ffh,MAXROWh, ...
; - format for the rest		:	xxh,yyh where xxh corresponds to rpm, and yyh is the row index
; - additionally, at the end of each rev scalar there will be a vector rowsize bytes long
;   which contains the # of rpm units to the next column. i.e. index 0 is for column 0 and
;   will have the "width" of column 0. Also could be thought of as dist to column 1.

ORG		0648ch
revscalar_ig:	DB	0ffh,00fh,0f1h,00fh,0e9h,00eh,0e0h,00dh,0d7h,00ch,0cfh,00bh
				DB	0c6h,00ah,0c0h,009h,0b0h,008h,0a0h,007h,090h,006h,080h,005h
				DB	070h,004h,060h,003h,050h,002h,040h,001h,000h,000h,000h,000h

rowdist_ig:		DB	040h,010h,010h,010h,010h,010h,010h,010h,010h,006h,009h,008h,009h,009h,008h,00Fh

ORG		064e9h
revscalar_igv:	DB	0ffh,00fh,0f0h,00fh,0e3h,00eh,0d5h,00dh,0c7h,00ch,0b9h,00bh
				DB	0aah,00ah,09ch,009h,08eh,008h,080h,007h,072h,006h,063h,005h
				DB	055h,004h,039h,003h,01dh,002h,00eh,001h,000h,000h,000h,000h

rowdist_igv:	DB	00Eh,00Fh,01Ch,01Ch,00Eh,00Fh,00Eh,00Eh,00Eh,00Eh,00Fh,00Eh,00Eh,00Eh,00Dh,010h

ORG		06546h
revscalar_fu:	DB	0ffh,00fh,0f0h,00fh,0e0h,00eh,0d0h,00dh,0c0h,00ch,0b0h,00bh
				DB	0a0h,00ah,090h,009h,080h,008h,070h,007h,060h,006h,050h,005h
				DB	040h,004h,030h,003h,020h,002h,010h,001h,000h,000h,000h,000h

rowdist_fu:		DB	010h,010h,010h,010h,010h,010h,010h,010h,010h,010h,010h,010h,010h,010h,010h,010h

ORG		065a3h
revscalar_fuv:	DB	0ffh,00fh,0f0h,00fh,0e0h,00eh,0d0h,00dh,0c0h,00ch,0b0h,00bh
				DB	0a0h,00ah,090h,009h,080h,008h,070h,007h,060h,006h,050h,005h
				DB	040h,004h,030h,003h,020h,002h,010h,001h,000h,000h,000h,000h

rowdist_fuv:	DB	010h,010h,010h,010h,010h,010h,010h,010h,010h,010h,010h,010h,010h,010h,010h,010h

;***************** The tables
;

ORG		06600h ;non vtec ignition map
				;	  1    2    3    4    5    6    7    8    9   10   11   12   13   14   15   16   17   18   19   20   21
ignitionmap:    DB	039h,039h,039h,039h,039h,039h,039h,039h,039h,032h,02Bh,025h,017h,017h,017h,017h,017h,016h,016h,016h,015h
				DB  039h,039h,039h,039h,039h,039h,039h,039h,039h,034h,02Fh,02Ah,021h,021h,021h,021h,021h,020h,020h,020h,01Fh
				DB	053h,053h,053h,053h,053h,053h,053h,050h,04Bh,046h,03Dh,038h,028h,028h,028h,028h,028h,027h,027h,027h,026h
				DB	059h,059h,059h,059h,059h,058h,057h,053h,04Fh,04Ah,043h,03Fh,030h,030h,030h,030h,030h,02Fh,02Fh,02Fh,02Eh
				DB	060h,060h,060h,060h,060h,05Eh,05Dh,059h,054h,050h,049h,045h,036h,033h,033h,033h,033h,032h,032h,032h,031h
				DB	062h,062h,062h,062h,062h,061h,060h,05Bh,058h,054h,04Dh,049h,03Bh,036h,036h,036h,036h,035h,035h,035h,034h
				DB	067h,067h,067h,067h,067h,066h,065h,061h,05Eh,05Bh,054h,050h,044h,044h,044h,044h,044h,043h,043h,043h,042h
				DB	073h,073h,073h,073h,073h,071h,069h,065h,060h,05Bh,057h,050h,04Ah,04Ah,04Ah,04Ah,04Ah,049h,049h,049h,048h
				DB	073h,073h,073h,073h,073h,071h,069h,065h,060h,05Ch,058h,050h,04Fh,04Fh,04Fh,04Fh,04Fh,04Eh,04Eh,04Eh,04Dh
				DB	073h,073h,073h,073h,073h,071h,06Eh,06Ch,068h,064h,060h,05Ch,054h,054h,054h,054h,054h,053h,053h,053h,052h
				DB	075h,075h,075h,075h,075h,072h,06Eh,06Ch,068h,065h,061h,05Eh,058h,058h,058h,058h,058h,057h,057h,057h,056h
				DB	07Bh,07Bh,07Bh,07Bh,07Bh,077h,073h,06Fh,06Bh,068h,064h,060h,058h,058h,058h,058h,058h,057h,057h,057h,056h
				DB	07Bh,07Bh,07Bh,07Bh,07Bh,077h,073h,06Fh,06Bh,068h,065h,067h,058h,058h,058h,058h,058h,057h,057h,057h,056h
				DB	072h,072h,072h,072h,072h,072h,06Fh,06Dh,06Ah,068h,065h,05Fh,050h,050h,050h,050h,050h,04Fh,04Fh,04Fh,04Eh
				DB	072h,072h,072h,072h,072h,072h,06Fh,06Dh,06Ah,068h,065h,05Fh,050h,050h,050h,050h,050h,04Fh,04Fh,04Fh,04Eh
				DB	072h,072h,072h,072h,072h,072h,06Fh,06Dh,06Ah,068h,065h,05Fh,050h,050h,050h,050h,050h,04Fh,04Fh,04Fh,04Eh
				DB	072h,072h,072h,072h,072h,072h,06Fh,06Dh,06Ah,068h,065h,05Fh,050h,050h,050h,050h,050h,04Fh,04Fh,04Fh,04Eh

				;NA map
				;	  1    2    3    4    5    6    7    8    9   10   11   12   13   14   15 | 16   17   18   19   20   21
;ignitionmap:    DB	039h,039h,039h,039h,039h,039h,039h,039h,039h,032h,02Bh,025h,017h,017h,017h,017h,017h,017h,017h,017h,017h
;                DB	039h,039h,039h,039h,039h,039h,039h,039h,039h,034h,02Fh,02Ah,021h,021h,021h,021h,021h,021h,021h,021h,021h
;                DB	053h,053h,053h,053h,053h,053h,053h,050h,04Bh,046h,03Dh,038h,028h,028h,028h,028h,028h,028h,028h,028h,028h
;                DB  059h,059h,059h,059h,059h,058h,057h,053h,04Fh,04Ah,043h,03Fh,030h,030h,030h,030h,030h,030h,030h,030h,030h
;                DB	060h,060h,060h,060h,060h,05Eh,05Dh,059h,054h,050h,049h,045h,036h,033h,033h,033h,033h,033h,033h,033h,033h
;                DB	062h,062h,062h,062h,062h,061h,058h,052h,04Dh,04Bh,04Ah,049h,03Bh,036h,036h,036h,036h,036h,036h,036h,036h
;                DB	067h,067h,067h,067h,067h,066h,05Bh,052h,050h,050h,050h,050h,044h,044h,044h,044h,044h,044h,044h,044h,044h
;                DB	067h,067h,067h,067h,067h,066h,05Bh,055h,053h,052h,051h,050h,04Ah,04Ah,04Ah,04Ah,04Ah,04Ah,04Ah,04Ah,04Ah
;                DB	073h,073h,073h,073h,073h,071h,064h,05Fh,05Bh,058h,056h,050h,04Fh,04Fh,04Fh,04Fh,04Fh,04Fh,04Fh,04Fh,04Fh
;                DB	073h,073h,073h,073h,073h,071h,06Eh,06Ch,068h,064h,060h,05Ch,054h,054h,054h,054h,054h,054h,054h,054h,054h
;                DB	075h,075h,075h,075h,075h,072h,06Eh,06Ch,068h,065h,061h,05Eh,058h,058h,058h,058h,058h,058h,058h,058h,058h
;                DB	07Bh,07Bh,07Bh,07Bh,07Bh,077h,073h,06Fh,06Bh,068h,064h,060h,058h,058h,058h,058h,058h,058h,058h,058h,058h
;                DB	07Bh,07Bh,07Bh,07Bh,07Bh,077h,073h,06Fh,06Bh,068h,065h,067h,058h,058h,058h,058h,058h,058h,058h,058h,058h
;                DB	072h,072h,072h,072h,072h,072h,06Fh,06Dh,06Ah,068h,065h,05Fh,050h,050h,050h,050h,050h,050h,050h,050h,050h
;                DB	072h,072h,072h,072h,072h,072h,06Fh,06Dh,06Ah,068h,065h,05Fh,050h,050h,050h,050h,050h,050h,050h,050h,050h
;                DB	072h,072h,072h,072h,072h,072h,06Fh,06Dh,06Ah,068h,065h,05Fh,050h,050h,050h,050h,050h,050h,050h,050h,050h
;                DB	072h,072h,072h,072h,072h,072h,06Fh,06Dh,06Ah,068h,065h,05Fh,050h,050h,050h,050h,050h,050h,050h,050h,050h


;*******************************
ORG		06984h ;vtec ignition map

ignitionmapv:	DB	022h,022h,022h,022h,022h,022h,022h,022h,022h,022h,022h,022h,022h,022h,022h,022h,022h,021h,021h,021h,020h
				DB	039h,039h,039h,039h,039h,039h,039h,039h,039h,032h,02Bh,025h,018h,018h,018h,018h,018h,017h,017h,017h,016h
				DB	039h,039h,039h,039h,039h,039h,039h,039h,039h,034h,02Fh,02Ah,022h,022h,022h,022h,022h,021h,021h,021h,020h
				DB	058h,058h,058h,058h,058h,057h,056h,055h,052h,04Eh,04Ah,046h,03Fh,03Fh,03Fh,03Eh,03Bh,037h,033h,030h,02Fh
				DB	06Ch,06Ch,06Ch,06Ch,06Ch,06Ah,067h,064h,060h,05Dh,059h,055h,04Dh,04Dh,04Dh,04Ch,049h,045h,040h,03Dh,03Dh
				DB	073h,073h,073h,073h,073h,070h,06Dh,06Bh,067h,063h,05Fh,05Bh,052h,052h,052h,051h,04Eh,04Ah,045h,042h,042h
				DB	075h,075h,075h,075h,075h,072h,06Eh,06Ch,068h,065h,061h,05Eh,058h,058h,058h,057h,054h,050h,04Ah,047h,047h
				DB	07Bh,07Bh,07Bh,07Bh,07Bh,077h,073h,06Fh,06Bh,068h,064h,060h,058h,058h,058h,057h,054h,050h,04Ah,047h,047h
				DB	07Bh,07Bh,07Bh,07Bh,07Bh,077h,073h,06Fh,06Bh,068h,065h,067h,058h,058h,058h,057h,054h,050h,04Ah,047h,047h
				DB	07Ah,07Ah,07Ah,07Ah,07Ah,07Ah,077h,075h,072h,070h,06Dh,067h,058h,058h,058h,057h,054h,050h,04Ah,047h,047h
				DB	07Ah,07Ah,07Ah,07Ah,07Ah,07Ah,077h,075h,072h,070h,06Dh,067h,058h,058h,058h,057h,054h,050h,04Ah,047h,047h
				DB	07Bh,07Bh,07Bh,07Bh,07Bh,07Bh,078h,076h,073h,071h,06Eh,067h,058h,058h,058h,057h,054h,050h,04Ah,047h,047h
				DB	077h,077h,077h,077h,077h,077h,074h,072h,070h,06Eh,06Ch,067h,058h,058h,058h,057h,054h,050h,04Ah,047h,047h
				DB	072h,072h,072h,072h,072h,072h,070h,06Fh,06Dh,06Bh,06Ah,067h,05Eh,05Eh,05Eh,05Bh,058h,054h,04Eh,04Bh,04Ch
				DB	072h,072h,072h,072h,072h,072h,070h,06Fh,06Dh,06Bh,06Ah,067h,05Eh,05Eh,05Eh,05Bh,058h,054h,04Eh,04Bh,04Ch
				DB	072h,072h,072h,072h,072h,072h,070h,06Fh,06Dh,06Bh,06Ah,067h,05Eh,05Eh,05Eh,05Bh,058h,054h,04Eh,04Bh,04Ch
				DB	072h,072h,072h,072h,072h,072h,070h,06Fh,06Dh,06Bh,06Ah,067h,05Eh,05Eh,05Eh,05Bh,058h,054h,04Eh,04Bh,04Ch

				;NA map
				;ignition map 2 (VTEC) @ 6165 (was 3CE5h)
;ignitionmapv:   DB	022h,022h,022h,022h,022h,022h,022h,022h,022h,022h,022h,022h,022h,022h,022h,022h,022h,022h,022h,022h,022h
;                DB	039h,039h,039h,039h,039h,039h,039h,039h,039h,032h,02Bh,025h,018h,018h,018h,018h,018h,018h,018h,018h,018h
;                DB  039h,039h,039h,039h,039h,039h,039h,039h,039h,034h,02Fh,02Ah,022h,022h,022h,022h,022h,022h,022h,022h,022h
;                DB	058h,058h,058h,058h,058h,057h,056h,055h,052h,04Eh,04Ah,046h,03Fh,03Fh,03Fh,03Fh,03Fh,03Fh,03Fh,03Fh,03Fh
;                DB	06Ch,06Ch,06Ch,06Ch,06Ch,06Ah,067h,064h,060h,05Dh,059h,055h,04Dh,04Dh,04Dh,04Dh,04Dh,04Dh,04Dh,04Dh,04Dh
;                DB	073h,073h,073h,073h,073h,070h,06Dh,06Bh,067h,063h,05Fh,05Bh,052h,052h,052h,052h,052h,052h,052h,052h,052h
;                DB	075h,075h,075h,075h,075h,072h,06Eh,06Ch,068h,065h,061h,05Eh,058h,058h,058h,058h,058h,058h,058h,058h,058h
;                DB	07Bh,07Bh,07Bh,07Bh,07Bh,077h,073h,06Fh,06Bh,068h,064h,060h,058h,058h,058h,058h,058h,058h,058h,058h,058h
;                DB	07Bh,07Bh,07Bh,07Bh,07Bh,077h,073h,06Fh,06Bh,068h,065h,067h,058h,058h,058h,058h,058h,058h,058h,058h,058h
;                DB	07Ah,07Ah,07Ah,07Ah,07Ah,07Ah,077h,075h,072h,070h,06Dh,067h,058h,058h,058h,058h,058h,058h,058h,058h,058h
;                DB  07Ah,07Ah,07Ah,07Ah,07Ah,07Ah,077h,075h,072h,070h,06Dh,067h,058h,058h,058h,058h,058h,058h,058h,058h,058h
;                DB	07Bh,07Bh,07Bh,07Bh,07Bh,07Bh,078h,076h,073h,071h,06Eh,067h,058h,058h,058h,058h,058h,058h,058h,058h,058h
;                DB	077h,077h,077h,077h,077h,077h,074h,072h,070h,06Eh,06Ch,067h,058h,058h,058h,058h,058h,058h,058h,058h,058h
;                DB	072h,072h,072h,072h,072h,072h,070h,06Fh,06Dh,06Bh,06Ah,067h,05Eh,05Eh,05Eh,05Eh,05Eh,05Eh,05Eh,05Eh,05Eh
;                DB	072h,072h,072h,072h,072h,072h,070h,06Fh,06Dh,06Bh,06Ah,067h,05Eh,05Eh,05Eh,05Eh,05Eh,05Eh,05Eh,05Eh,05Eh
;                DB	072h,072h,072h,072h,072h,072h,070h,06Fh,06Dh,06Bh,06Ah,067h,05Eh,05Eh,05Eh,05Eh,05Eh,05Eh,05Eh,05Eh,05Eh
;                DB	072h,072h,072h,072h,072h,072h,070h,06Fh,06Dh,06Bh,06Ah,067h,05Eh,05Eh,05Eh,05Eh,05Eh,05Eh,05Eh,05Eh,05Eh

;*******************************
ORG		06D08h ;non vtec fuel map

fuelmap:		DB	008h,01Dh,036h,032h,046h,059h,036h,03Eh,046h,04Eh,057h,030h,03Ah,043h,04Ch,052h,05Ch,069h,076h,07Dh,08Ah
				DB	008h,01Dh,036h,032h,046h,059h,036h,03Eh,046h,04Eh,057h,030h,03Ah,043h,04Ch,052h,05Ch,069h,076h,07Dh,08Ah
				DB	00Bh,021h,038h,034h,047h,05Bh,037h,03Fh,048h,052h,059h,031h,03Ch,045h,04Ch,056h,060h,06Eh,07Bh,084h,090h
				DB	015h,02Ah,049h,036h,04Ch,05Fh,039h,042h,04Ah,052h,05Bh,032h,03Bh,045h,04Ch,056h,060h,06Eh,07Bh,084h,090h
				DB	01Dh,030h,04Fh,03Bh,04Eh,061h,039h,042h,04Bh,053h,05Bh,032h,03Ch,045h,04Ch,052h,05Ch,069h,076h,07Dh,08Ah
				DB	01Fh,030h,053h,03Fh,053h,065h,03Dh,046h,04Fh,057h,061h,034h,03Dh,045h,04Ch,056h,060h,06Eh,07Bh,084h,090h
				DB	01Fh,032h,055h,041h,054h,065h,03Eh,046h,04Fh,058h,061h,035h,03Eh,047h,04Dh,056h,060h,06Eh,07Bh,084h,090h
				DB	024h,036h,05Ah,046h,05Bh,06Dh,042h,04Bh,054h,05Dh,067h,037h,040h,049h,050h,05Bh,066h,075h,081h,08Bh,099h
				DB	026h,038h,05Eh,044h,057h,06Dh,041h,04Bh,054h,05Dh,067h,038h,041h,04Ah,050h,05Bh,066h,075h,081h,08Bh,099h
				DB	024h,038h,05Ch,044h,058h,06Dh,041h,04Bh,054h,05Dh,067h,038h,041h,04Ah,051h,05Ch,067h,076h,082h,08Ch,09Ah
				DB	02Ah,03Fh,064h,049h,05Eh,075h,046h,050h,058h,062h,06Bh,03Ah,043h,04Ch,051h,05Dh,068h,078h,085h,08Fh,09Dh
				DB	02Ah,03Fh,066h,04Ah,062h,075h,046h,051h,05Bh,064h,06Dh,03Ch,045h,04Eh,055h,061h,06Ch,07Ch,089h,093h,0A2h
				DB	026h,038h,05Eh,044h,05Bh,06Fh,042h,04Eh,058h,061h,06Bh,03Bh,045h,04Ch,051h,05Ch,067h,076h,082h,08Ch,09Ah
				DB	02Ch,03Fh,068h,04Bh,061h,079h,047h,052h,05Dh,066h,073h,040h,04Ch,050h,051h,05Dh,068h,078h,085h,08Fh,09Dh
				DB	03Fh,04Fh,07Fh,057h,070h,086h,050h,05Fh,06Bh,077h,081h,046h,050h,057h,05Dh,06Ah,077h,088h,096h,0A2h,0B2h
				DB	041h,051h,081h,05Bh,074h,08Fh,053h,05Fh,06Dh,077h,081h,046h,04Fh,057h,05Fh,06Ah,077h,088h,096h,0A2h,0B2h
				DB	038h,049h,075h,059h,075h,08Fh,056h,063h,06Fh,079h,083h,046h,051h,055h,05Ah,065h,071h,081h,08Fh,09Ah,0A9h

				;Fuel multipliers 1
				DB	000h,001h,001h,002h,002h,002h,003h,003h,003h,003h,003h,004h,004h,004h,004h,004h,004h,004h,004h,004h,004h

                ;NA map
                ;fuel map 1 @ 62CAh (was 3DE4h)
;fuelmap:		DB	05Dh,04Fh,06Fh,055h,072h,08Eh,055h,061h,070h,07Fh,08Ch,04Eh,05Bh,06Eh,081h,081h,081h,081h,081h,081h,081h
;                DB  05Dh,04Fh,06Fh,055h,072h,08Eh,055h,061h,070h,07Fh,08Ch,04Eh,05Bh,06Eh,081h,081h,081h,081h,081h,081h,081h
;                DB	051h,054h,074h,05Ah,077h,091h,056h,061h,06Eh,07Ch,08Ah,04Ch,05Ch,06Ch,07Ch,07Ch,07Ch,07Ch,07Ch,07Ch,07Ch
;                DB	06Ch,05Dh,081h,05Dh,07Ah,095h,058h,064h,071h,07Fh,08Dh,04Dh,05Dh,06Dh,07Dh,07Dh,07Dh,07Dh,07Dh,07Dh,07Dh
;                DB	071h,062h,088h,062h,07Eh,096h,05Ah,066h,072h,080h,08Fh,04Eh,05Eh,06Fh,080h,080h,080h,080h,080h,080h,080h
;                DB	082h,06Eh,09Ah,06Ah,084h,0A3h,05Eh,06Ah,078h,087h,094h,052h,061h,072h,083h,083h,083h,083h,083h,083h,083h
;                DB	080h,06Dh,099h,068h,081h,09Eh,05Dh,069h,07Bh,086h,096h,052h,061h,071h,081h,081h,081h,081h,081h,081h,081h
;                DB	08Ah,074h,0A4h,070h,08Ch,0A7h,062h,06Fh,07Dh,08Bh,09Bh,055h,064h,072h,080h,080h,080h,080h,080h,080h,080h
;                DB	08Fh,07Bh,0ADh,074h,08Fh,0ACh,065h,073h,082h,090h,09Fh,057h,068h,079h,08Ah,08Ah,08Ah,08Ah,08Ah,08Ah,08Ah
;                DB  08Ch,077h,0A8h,071h,08Eh,0ABh,065h,073h,083h,090h,0A0h,056h,067h,07Ch,091h,091h,091h,091h,091h,091h,091h
;                DB	094h,07Dh,0B2h,078h,097h,0B5h,06Ah,075h,08Bh,099h,0A8h,05Ch,06Dh,081h,095h,095h,095h,095h,095h,095h,095h
;                DB	094h,07Dh,0B1h,077h,094h,0B6h,06Ch,07Ah,089h,09Ah,0A9h,05Eh,06Eh,082h,096h,096h,096h,096h,096h,096h,096h
;                DB	082h,06Eh,09Ch,06Dh,08Ch,0ACh,066h,075h,084h,095h,0A5h,05Bh,06Ch,080h,094h,094h,094h,094h,094h,094h,094h
;                DB	099h,077h,0B9h,07Dh,09Eh,0C3h,071h,07Fh,095h,0A6h,0BAh,061h,07Eh,082h,08Fh,08Fh,08Fh,08Fh,08Fh,08Fh,08Fh
;                DB	0BEh,09Ah,0E5h,097h,0BBh,0DFh,082h,093h,0A9h,0BCh,0D0h,072h,085h,099h,0ADh,0ADh,0ADh,0ADh,0ADh,0ADh,0ADh
;                DB	0B4h,092h,0DBh,08Fh,0BAh,0DDh,081h,095h,0AAh,0BCh,0CFh,072h,086h,09Ah,0AEh,0AEh,0AEh,0AEh,0AEh,0AEh,0AEh
;                DB	096h,08Ah,0C9h,092h,0BEh,0E3h,087h,0A0h,0B5h,0C7h,0DAh,071h,08Ch,09Ah,0A8h,0A8h,0A8h,0A8h,0A8h,0A8h,0A8h

                ;Fuel multipliers 1 @ 642fh
;                DB  000h,001h,001h,002h,002h,002h,003h,003h,003h,003h,003h,004h,004h,004h,004h,004h,004h,004h,004h,004h,004h

;***********************
ORG		070AAh ;vtec fuel map

fuelmapv:		DB	002h,013h,026h,02Dh,041h,04Fh,030h,039h,03Fh,04Bh,055h,02Fh,039h,042h,04Dh,055h,060h,06Eh,07Ah,083h,08Eh
				DB	002h,013h,026h,02Dh,041h,04Fh,030h,039h,03Fh,04Bh,055h,02Fh,039h,042h,04Dh,055h,060h,06Eh,07Ah,083h,08Eh
				DB	002h,013h,026h,02Dh,041h,04Fh,030h,039h,03Fh,04Bh,055h,02Fh,039h,042h,04Dh,055h,060h,06Eh,07Ah,083h,08Eh
				DB	002h,013h,026h,02Dh,041h,04Fh,030h,039h,03Fh,04Bh,055h,02Fh,039h,042h,04Dh,055h,060h,06Eh,07Ah,083h,08Eh
				DB	002h,013h,026h,02Dh,041h,04Fh,030h,039h,03Fh,04Bh,055h,02Fh,039h,042h,04Dh,055h,060h,06Eh,07Ah,083h,08Eh
				DB	002h,011h,024h,027h,036h,04Dh,032h,03Dh,048h,054h,05Dh,035h,03Fh,049h,052h,05Ch,068h,078h,085h,08Fh,09Bh
				DB	019h,02Ch,04Bh,03Bh,052h,063h,03Eh,049h,052h,05Dh,067h,039h,043h,04Ch,054h,05Dh,069h,078h,085h,08Fh,09Bh
				DB	006h,01Bh,034h,02Bh,03Fh,055h,036h,03Fh,04Bh,055h,05Fh,039h,03Eh,04Bh,051h,056h,06Bh,07Bh,089h,094h,0A1h
				DB	00Bh,021h,03Ah,02Bh,03Fh,053h,034h,03Fh,049h,054h,05Fh,038h,045h,04Dh,054h,05Dh,069h,078h,085h,08Fh,09Bh
				DB	019h,02Ah,04Bh,039h,04Eh,063h,041h,04Ch,05Ch,06Dh,079h,042h,04Ah,04Eh,052h,05Bh,067h,076h,082h,08Ch,098h
				DB	02Ch,03Fh,066h,04Bh,066h,07Dh,050h,05Eh,06Bh,079h,083h,047h,050h,058h,060h,06Ah,078h,08Ah,098h,0A4h,0B2h
				DB	03Fh,04Dh,07Dh,058h,073h,08Dh,054h,062h,06Eh,079h,083h,046h,050h,058h,060h,06Ah,078h,08Ah,098h,0A4h,0B2h
				DB	045h,058h,087h,060h,077h,093h,057h,063h,070h,07Ah,085h,048h,052h,05Bh,064h,070h,07Eh,091h,0A0h,0ADh,0BBh
				DB	049h,05Ah,087h,066h,086h,0A1h,061h,06Fh,07Ch,088h,095h,051h,05Ah,060h,066h,070h,07Eh,091h,0A0h,0ADh,0BBh
				DB	038h,049h,075h,05Ch,07Bh,09Dh,05Eh,06Ch,07Ah,08Ah,093h,051h,05Bh,05Fh,063h,06Dh,07Bh,08Dh,09Ch,0A8h,0B7h
				DB	038h,049h,075h,05Ch,07Bh,09Dh,05Eh,06Ch,07Ah,08Ah,093h,051h,05Bh,05Fh,063h,06Dh,07Bh,08Dh,09Ch,0A8h,0B7h
				DB	038h,049h,075h,05Ch,07Bh,09Dh,05Eh,06Ch,07Ah,08Ah,093h,051h,05Bh,05Fh,063h,06Dh,07Bh,08Dh,09Ch,0A8h,0B7h

				;Fuel multipliers 1
				DB	000h,001h,001h,002h,002h,002h,003h,003h,003h,003h,003h,004h,004h,004h,004h,004h,004h,004h,004h,004h,004h

				;NA map
;fuelmapv:		DB	03Fh,035h,066h,050h,066h,07Ch,04Bh,059h,066h,075h,084h,049h,05Bh,06Dh,07Fh,07Fh,07Fh,07Fh,07Fh,07Fh,07Fh
;                DB	03Fh,035h,066h,050h,066h,07Ch,04Bh,059h,066h,075h,084h,049h,05Bh,06Dh,07Fh,07Fh,07Fh,07Fh,07Fh,07Fh,07Fh
;                DB	03Fh,035h,066h,050h,066h,07Ch,04Bh,059h,066h,075h,084h,049h,05Bh,06Dh,07Fh,07Fh,07Fh,07Fh,07Fh,07Fh,07Fh
;                DB	03Fh,035h,066h,050h,066h,07Ch,04Bh,059h,066h,075h,084h,049h,05Bh,06Dh,07Fh,07Fh,07Fh,07Fh,07Fh,07Fh,07Fh
;                DB	03Fh,035h,066h,050h,066h,07Ch,04Bh,059h,066h,075h,084h,049h,05Bh,06Dh,07Fh,07Fh,07Fh,07Fh,07Fh,07Fh,07Fh
;                DB	04Eh,044h,060h,045h,05Fh,07Eh,04Fh,05Dh,06Dh,07Fh,08Dh,050h,062h,077h,08Ch,08Ch,08Ch,08Ch,08Ch,08Ch,08Ch
;                DB	05Fh,050h,084h,063h,080h,0A1h,061h,071h,07Fh,091h,0A2h,05Ah,06Fh,083h,097h,097h,097h,097h,097h,097h,097h
;                DB  049h,03Dh,06Dh,04Bh,067h,082h,050h,060h,070h,081h,092h,052h,066h,080h,09Ah,09Ah,09Ah,09Ah,09Ah,09Ah,09Ah
;                DB	055h,048h,077h,051h,06Bh,088h,053h,064h,074h,087h,09Bh,05Bh,073h,080h,08Dh,09Ah,09Ah,09Ah,09Ah,09Ah,09Ah
;                DB	067h,057h,092h,069h,089h,0ADh,067h,07Ah,08Dh,09Fh,0B3h,068h,07Dh,089h,095h,09Ah,09Ah,09Ah,09Ah,09Ah,09Ah
;                DB	08Fh,07Ah,0C1h,084h,0A9h,0CFh,07Ah,091h,0A4h,0BBh,0CFh,071h,086h,097h,0A8h,09Ah,09Ah,09Ah,09Ah,09Ah,09Ah
;                DB	0A3h,08Ah,0D5h,091h,0B5h,0DCh,081h,096h,0ABh,0C1h,0D5h,074h,087h,09Ah,0ADh,09Ah,09Ah,09Ah,09Ah,09Ah,09Ah
;                DB	0AFh,096h,0DFh,099h,0C2h,0E9h,08Bh,0A2h,0B7h,0C9h,0DFh,077h,08Bh,09Fh,0B3h,0B3h,0B3h,0B3h,0B3h,0B3h,0B3h
;                DB	0B2h,097h,0DEh,09Ch,0C6h,0F5h,091h,0A9h,0BFh,0D4h,0E8h,080h,096h,0A8h,0BAh,0BAh,0BAh,0BAh,0BAh,0BAh,0BAh
;                DB	085h,071h,0BDh,08Eh,0C2h,0FCh,096h,0AFh,0C5h,0DDh,0F5h,07Eh,087h,0A9h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h
;                DB  085h,071h,0BDh,08Eh,0C2h,0FCh,096h,0AFh,0C5h,0DDh,0F5h,07Eh,087h,0A9h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h
;                DB	085h,071h,0BDh,08Eh,0C2h,0FCh,096h,0AFh,0C5h,0D0h,0F5h,07Eh,087h,0A9h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h

                ;fuel multipliers 2 @ 65A9h
;                DB	000h,001h,001h,002h,002h,002h,003h,003h,003h,003h,003h,004h,004h,004h,004h,004h,004h,004h,004h,004h,004h




;these bytes are for the editor recognization
ORG		04406h
				DB	0CFh,002h,077h,0DFh,001h

;*************************
;last bytes

ORG		07f00h

;these are the codes that the ecu will not set. ever.
;the vector MUST be ended with a 0
nosetcodes:		DB	017h,001h,002h,000h

;******************
;logger table
ORG		07f10h
logger_table:	DB  099h,000h ;10 water temp
                DB  09ah,000h ;11 IAT
                DB  0b2h,000h ;12 original map column
                DB  0b5h,000h ;13 corrected map column
                DB  0B1h,000h ;14 MAP
                DB  0ABh,000h ;15 tps
                DB  0BAh,000h ;16 rpm low
                DB  0BBh,000h ;17 rpm high
                DB  029h,001h ;18 vtec
                DB  0A6h,000h ;19 rpm
                DB  0A7h,000h ;1a rpm
                DB  0B4h,000h ;1b map image - final
                DB  030h,001h ;1c err
                DB  031h,001h ;1d err
                DB  032h,001h ;1e err
                DB  0cbh,000h ;1f speed
                DB  0b3h,000h ;20 map image - before correction

                ;mine
                DB  048h,001h ;21 final fuel
                DB  049h,001h ;22 final fuel high
                DB  067h,000h ;23 ADCR3H -> o2#2 input
                DB  034h,001h ;24 final ignition val
                DB  07ch,001h ;25 fuel row in table
                DB  07dh,001h ;26 ignition row in table
                DB  0a1h,000h ;27 primary o2
                DB  0a2h,000h ;28 secondary o2
                DB  0e1h,001h ;29 fuel y intep
                DB  0e2h,001h ;2a ign y interp


ORG		07ffch
colsize:		DB	015h ;21d real column size
rowsize:		DB	011h ;17d real row size
tablesize:		DB	065h,001h ;colsize*rowsize


;******************************************************************
;************RESULTS
;
; jdmpr3DEVtry1.bin - poop.
;
; jdmpr3DEVtry2.bin - didnt work.
;	- stupid revlimit when full throttle. It seems to not like going over column 15...
;
; jdmpr3DEVtry3.bin -
;	- oops, forgot to change the row multiplier to 21 columns...
;
; jdmpr3DEVtry4.bin -
;	- no scaling of b3h. the euro ecu didnt like scaling so I'm covering my bases.
;	- works. this is what people are running now...
;
;*******************************************************************

