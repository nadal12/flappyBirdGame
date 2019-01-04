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
            BNE.S   .LEFT
            BTST.B  #KBDBITRT,(KBDEDGE)
            BNE.S   .RIGHT
            BTST.B  #KBDBITF1,(KBDEDGE)
            BEQ     .END
            
            ; IF SPACE IS PRESSED
            MOVE.B  #PNCHSND,D1         ; PREPARAR REGISTRO PARA SUBRUTINA
            JSR     UTLPLAY
            MOVE.W  #STAPLAY,(STANEXT)
            BRA.S   .END

.LEFT       ; CHECK IF POSSIBLE TO MOVE TO THE LEFT
            CMP.W    #INTOESY,(XSPEED)
            BGT.S   .LF
            MOVE.B  #FLAPSND,D1         ; PREPARAR REGISTRO PARA SUBRUTINA
            JSR     UTLPLAY
            BRA.S   .END
            
            ; CHECK IF POSSIBLE TO MOVE TO THE RIGHT
.RIGHT      CMP.W    #INTOHRD,(XSPEED)
            BLT.S   .RT
            MOVE.B  #FLAPSND,D1         ; PREPARAR REGISTRO PARA SUBRUTINA
            JSR     UTLPLAY
            BRA     .END            

.END        RTS

            ; MOVE TO LEFTWARD OPTION
.LF         MOVE.B  #MNOPTSD,D1         ; PREPARAR REGISTRO PARA SUBRUTINA
            JSR     UTLPLAY
            SUB.W   #2,(XSPEED)
            BRA.S   .END
            
            ; MOVE TO RIGHTWARD OPTION
.RT         MOVE.B  #MNOPTSD,D1         ; PREPARAR REGISTRO PARA SUBRUTINA
            JSR     UTLPLAY
            ADD.W   #2,(XSPEED)
            BRA.S   .END

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
            
            **********DIBUJAR SELECCION DE DIFICULTAD**********
            ;Seleccionar fuente de texto
            UTLFONT INTDSTC,INTDSTF
            ;Seleccionar posición de texto
            UTLLOCT INTDSTX,INTDSTY
            
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
            
            *********DIBUJAR PRESS SPACE**********
            ;Seleccionar fuente de texto
            UTLFONT INTPRSC,INTPRSF     
            ;Seleccionar posicion de texto
            UTLLOCT INTPRSX,INTPRSY     

            LEA     .START_TEXT,A1
            MOVE.B  #14,D0
            TRAP    #15
            
            ;Restaurar registros
            MOVEM.L (A7)+,A1/D0-D1
            RTS

.TITLE      DC.B    'FLAPPY BIRD',0 
.START_TEXT DC.B    'PRESS SPACE TO START',0
.DIF_ESY    DC.B    'DIFICULTAD: <- FÁCIL ->',0
.DIF_NRM    DC.B    'DIFICULTAD: <- NORMAL ->',0
.DIF_HRD    DC.B    'DIFICULTAD: <- DIFICIL ->',0
            DS.W    0


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
