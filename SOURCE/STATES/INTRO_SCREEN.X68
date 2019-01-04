; =============================================================================
; INTRO SCREEN MANAGEMENT
; =============================================================================

; -----------------------------------------------------------------------------
STAINTRI
; INTRO STATE INIT
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; INITIALIZES SOUND LIBRARY AND FREES MEMORY
; -----------------------------------------------------------------------------
            CLR.B   (BGSNDINIT)             ;Reinicia musica en BG al pausar
            JSR     SNDINIT
            BRA     DMMINIT


; -----------------------------------------------------------------------------
STAINTRU
; INTRO STATE UPDATE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            BTST.B  #KBDBITLF,(KBDEDGE)
            BNE     .LEFT
            BTST.B  #KBDBITRT,(KBDEDGE)
            BNE     .RIGHT
            BTST.B  #KBDBITUP,(KBDEDGE)
            BNE.S   .UP
            BTST.B  #KBDBITDN,(KBDEDGE)
            BNE.S   .DOWN
            BTST.B  #KBDBITF1,(KBDEDGE)
            BEQ     .END
            
; --- Si SPACE ha sido presionado ----------
            CMP.B   #IPLNUM,(PMOPTN)
            BEQ.S   .PLAY
            CMP.B   #IINSNUM,(PMOPTN)
            BEQ.S   .INST
            CMP.B   #IDIFNUM,(PMOPTN)
            BNE.S   .END
            
            MOVE.B  #FLAPSND,D1
            JSR     UTLPLAY

.END        RTS

.PLAY       ; START GAME
            MOVE.B  #PNCHSND,D1
            JSR     UTLPLAY
            MOVE.W  #STAPLAY,(STANEXT)
            BRA.S   .END
            
.INST       ; OPEN INSTRUCTION SCREEN
            MOVE.B  #PNCHSND,D1
            JSR     UTLPLAY
            MOVE.W  #STAINST,(STANEXT)
            BRA.S   .END


; --- Si UP ha sido presionado ----------
.UP         ; CHECK IF POSSIBLE TO MOVE UP
            CMP.B   #IPLNUM,(PMOPTN)
            BNE.S   .MUP
            
            MOVE.B  #FLAPSND,D1
            JSR     UTLPLAY
            BRA.S   .END
.MUP                                    ;MOVE UP
            MOVE.B  #MNOPTSD,D1
            JSR     UTLPLAY
            SUBQ.B  #1,(PMOPTN)
            BRA.S   .END

; --- Si DOWN ha sido presionado ----------
.DOWN       ; CHECK IF POSSIBLE TO MOVE DOWN
            CMP.B   #IINSNUM,(PMOPTN)
            BNE.S   .MDN
            
            MOVE.B  #FLAPSND,D1
            JSR     UTLPLAY
            BRA.S   .END
.MDN                                    ;MOVE DOWN
            MOVE.B  #MNOPTSD,D1
            JSR     UTLPLAY
            ADDQ.B  #1,(PMOPTN)
            BRA.S   .END            
            
; --- Si LEFT ha sido presionado ----------
.LEFT       ; CHECK IF POSSIBLE TO MOVE TO THE LEFT
            CMP.B   #IDIFNUM,(PMOPTN)   ; CHECK SI OPCIÓN ES CORRECTA
            BNE.S   .END
            CMP.W   #INTOESY,(XSPEED)
            BGT.S   .LF
            MOVE.B  #FLAPSND,D1         ; PREPARAR REGISTRO PARA SUBRUTINA
            JSR     UTLPLAY
            BRA     .END
           
            ; MOVE TO LEFTWARD OPTION
.LF         MOVE.B  #MNOPTSD,D1         ; PREPARAR REGISTRO PARA SUBRUTINA
            JSR     UTLPLAY
            SUB.W   #2,(XSPEED)
            BRA     .END
            
; --- Si RIGHT ha sido presionado ----------
            ; CHECK IF POSSIBLE TO MOVE TO THE RIGHT
.RIGHT      CMP.B   #IDIFNUM,(PMOPTN)   ; CHECK SI OPCIÓN ES CORRECTA
            BNE     .END
            CMP.W    #INTOHRD,(XSPEED)
            BLT.S   .RT
            MOVE.B  #FLAPSND,D1         ; PREPARAR REGISTRO PARA SUBRUTINA
            JSR     UTLPLAY
            BRA    .END             
            ; MOVE TO RIGHTWARD OPTION
.RT         MOVE.B  #MNOPTSD,D1         ; PREPARAR REGISTRO PARA SUBRUTINA
            JSR     UTLPLAY
            ADD.W   #2,(XSPEED)
            BRA     .END

; -----------------------------------------------------------------------------
STAINTRP
; INTRO STATE PLOT
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            ;Guardar registros en pila
            MOVEM.L A1/D0-D1,-(A7)
            
            **********DIBUJAR TITULO**********
            ;Seleccionar fuente de texto
            UTLFONT INTTITC,INTTITF
            ;Seleccionar posicion de texto      
            UTLLOCT INTTITX,INTTITY               
            ;Seleccionar color de relleno            
            UTLSFIL #$00000000

            LEA     .TITLE,A1
            MOVE.B  #14,D0
            TRAP    #15

            **********DIBUJAR OPCIÓN JUEGO NUEVO**********            
            ;Seleccionar fuente de texto
            CMP.B   #IPLNUM,(PMOPTN)
            BEQ.S   .PLSEL
            UTLFONT INTOPTCU,INTOPTF
            BRA.S   .SKPPL
.PLSEL      
            UTLFONT INTOPTCS,INTOPTF
.SKPPL      
            ;Seleccionar posicion de texto      
            UTLLOCT INTOPTX,INTPLY               
            
            LEA     .START_TEXT,A1
            MOVEQ   #14,D0
            TRAP    #15
            
            **********DIBUJAR SELECCION DE DIFICULTAD**********
            ;Seleccionar fuente de texto
            CMP.B   #IDIFNUM,(PMOPTN)
            BEQ.S   .DIFSEL
            UTLFONT INTOPTCU,INTOPTF
            BRA.S   .SKPDIF
.DIFSEL
            UTLFONT INTOPTCS,INTOPTF
.SKPDIF            
            ;Seleccionar posición de texto
            UTLLOCT INTDIFX,INTDIFY
            
            MOVE.W  (XSPEED),D0     ; CHECK NIVEL DE DIFICULTAD
            CMP.W   #INTOESY,D0 
            BEQ.S   .EASY           ; JUMP PARA NIVEL FACIL
            CMP.W   #INTOHRD,D0     
            BEQ.S   .HARD           ; JUMP PARA NIVEL DIFICIL
            
            LEA     .DIF_NRM,A1     ; VISUALIZAR STRING PARA NIVEL NORMAL
            BRA.S   .TRAP
.EASY       
            LEA     .DIF_ESY,A1     ; VISUALIZAR STRING PARA NIVEL FACIL
            BRA.S   .TRAP
.HARD   
            LEA     .DIF_HRD,A1     ; VISUALIZAR STRING PARA NIVEL DIFICIL
.TRAP       
            MOVEQ   #14,D0
            TRAP    #15
            
            **********DIBUJAR SELECCION DE DIFICULTAD**********
            ;Seleccionar fuente de texto
            CMP.B   #IINSNUM,(PMOPTN)
            BEQ.S   .INSSEL
            UTLFONT INTOPTCU,INTOPTF
            BRA.S   .SKPINS
.INSSEL
            UTLFONT INTOPTCS,INTOPTF
.SKPINS            
            ;Seleccionar posición de texto
            UTLLOCT INTOPTX,INTINSY     

            LEA     .INST,A1
            MOVE.B  #14,D0
            TRAP    #15
            
            
            **********DIBUJAR TEXTO DE AYUDA**********
            ;Seleccionar fuente de texto
            UTLFONT INTOPTCU,INTHLPF
            ;Seleccionar posición de texto
            UTLLOCT INTHLPX,INTHLPY1
            
            LEA     .HLP1,A1
            MOVEQ   #14,D0
            TRAP    #15
            
            UTLLOCT INTHLPX,INTHLPY2
            
            LEA     .HLP2,A1
            MOVEQ   #14,D0
            TRAP    #15
            
            ;Cambiar fuente de texto para ajustar altura de titulo
            UTLFONT 00000000,PSHFNT
            
            ;Restaurar registros
            MOVEM.L (A7)+,A1/D0-D1
            RTS

.TITLE      DC.B    'FLAPPY BIRD',0 
.START_TEXT DC.B    'JUEGO NUEVO',0
.DIF_ESY    DC.B    'DIFICULTAD: <- FÁCIL ->',0
.DIF_NRM    DC.B    'DIFICULTAD: <- NORMAL ->',0
.DIF_HRD    DC.B    'DIFICULTAD: <- DIFICIL ->',0
.INST       DC.B    'INSTRUCCIONES',0
.HLP1       DC.B    'Presione UP, DOWN, LEFT o RIGHT para moverse por el menú',0
.HLP2       DC.B    'Presione SPACE para seleccionar',0
            DS.W    0







*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
