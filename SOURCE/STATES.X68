; =============================================================================
; GAME STATE MANAGEMENT
; =============================================================================

; -----------------------------------------------------------------------------
STAINIT
; INITALIZES THE STATE MANAGER
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVE.W  #STANONE,(STACUR)
            MOVE.W  #STAINTR,(STANEXT)
            RTS

; -----------------------------------------------------------------------------
STAUPD
; PERFORMS STATE UPDATE AND INIT IF NECESSARY
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0/A0,-(A7)
            CLR.L   D0
            MOVE.W  (STANEXT),D0
            CMP.W   (STACUR),D0
            BEQ     .DOUPD
            MOVE.W  D0,(STACUR)             ; IF STATE CHANGED, DO INIT
            LSL.L   #2,D0
            MOVE.L  D0,A0
            MOVE.L  .INITBL(A0),A0
            JSR     (A0)
.DOUPD      CLR.L   D0                      ; IN ANY CASE, DO UPDATE
            MOVE.W  (STACUR),D0
            LSL.L   #2,D0
            MOVE.L  D0,A0
            MOVE.L  .UPDTBL(A0),A0
            JSR     (A0)
            MOVEM.L (A7)+,D0/A0
            RTS
.INITBL     DC.L    STAINTRI,STAPLAYI,STAPAUI,STAEMPTY
.UPDTBL     DC.L    STAINTRU,STAPLAYU,STAPAUU,STAGOVRU

; -----------------------------------------------------------------------------
STAPLOT
; PERFORMS STATE PLOT
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0/A0,-(A7)
            CLR.L   D0
            MOVE.W  (STACUR),D0
            LSL.L   #2,D0
            MOVE.L  D0,A0
            MOVE.L  .PLTTBL(A0),A0
            JSR     (A0)
            MOVEM.L (A7)+,D0/A0
            RTS
.PLTTBL     DC.L    STAINTRP,STAPLAYP,STAPAUP,STAGOVRP

; -----------------------------------------------------------------------------
STAEMPTY
; EMPTY SUBROUTINE FOR CASES WITH NOTHING TO DO
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; NOTE     - JUST A PLACEHOLDER. NOTHING TO DO.
; -----------------------------------------------------------------------------
            RTS

; -----------------------------------------------------------------------------
STAPLAYI
; PLAY STATE INITIALIZATION.
; SETS THE RIGHT CYCLE CO
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            ;Guardar registros
            MOVE.L  D0,-(A7)
            
            MOVE.W  (XSPEED),D0         ; CHECK DIFFICULTY CHOSEN TO ADAPT
            CMP.W   #INTOESY,D0         ; BRANCH IF CHOSEN EASY MODE
            BEQ.S   .EASY
            CMP.W   #INTOHRD,D0         ; BRANCH IF CHOSEN HARD MODE
            BEQ.S   .HARD
            
            MOVE.B  #GPIPCNRM,(PIPCYC)  ; NORMAL MODE SELECTED
            
.END        ;JSR     PLRINIT
            
            ;Restaurar registros
            MOVE.L  (A7)+,D0
            RTS
.EASY   
            MOVE.B  #GPIPCESY,(PIPCYC)  ; EASY MODE SELECTED
            BRA.S   .END
.HARD
            MOVE.B  #GPIPCHRD,(PIPCYC)  ; HARD MODE SELECTED
            BRA.S   .END
; -----------------------------------------------------------------------------
STAPLAYU
; PLAY STATE UPDATE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            BTST.B   #KBDBITPS,(KBDEDGE)         ;Si 'P' es presionado, pausa.
            BNE.S   .PAUSE
            
*            JSR     PLRUPD
            JSR     SNDUPD
            JSR     BGUPD
            JSR     PRPUPD
            JSR     SPWUPD
            BRA     AGLUPD
.PAUSE      
            MOVE.W  #STAPAU,(STANEXT)
            RTS
; -----------------------------------------------------------------------------
STAPLAYP
; PLAY STATE PLOT
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            JSR     BGPLOT
            JSR     PRPPLOT
            ;JSR     AGLPLOT
            BRA     AGLPLOT
            ;BRA     PLRPLOT

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
            TST.B   (SNDSTA)                ; CHECK SOUND STATE
            BNE.S   .NOSND
            UTLPLAY PNCHSND                 ; play sound when pressed space
.nosnd      MOVE.W  #STAPLAY,(STANEXT)
            BRA.S   .END

.LEFT       ; CHECK IF POSSIBLE TO MOVE TO THE LEFT
            CMP.W    #INTOESY,(XSPEED)
            BGT.S   .LF
            TST.B    (SNDSTA)               ; CHECK SOUND STATE
            BNE.S   .nosnd1
            UTLPLAY FLAPSND                 ; play sound when moving is no good
.nosnd1     BRA.S   .END
            
            ; CHECK IF POSSIBLE TO MOVE TO THE RIGHT
.RIGHT      CMP.W    #INTOHRD,(XSPEED)
            BLT.S   .RT
            TST.B   (SNDSTA)                ; CHECK SOUND STATE
            BNE.S   .nosnd2
            UTLPLAY FLAPSND                 ; play sound when not possible
.nosnd2     BRA     .END            

.END        RTS

            ; MOVE TO LEFTWARD OPTION
.LF         TST.B   (SNDSTA)                ;CHECK SOUND STATE
            BNE.S   .nosnd3
            UTLPLAY MNOPTSD                 ; play sound when possible
.nosnd3     SUB.W   #2,(XSPEED)
            BRA.S   .END
            
            ; MOVE TO RIGHTWARD OPTION
.RT         TST.B   (SNDSTA)
            BNE.S   .nosnd4
            UTLPLAY MNOPTSD                 ; play sound when possible
.nosnd4     ADD.W   #2,(XSPEED)
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
            
            **********DIBUJAR PRESS SPACE**********
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



; -----------------------------------------------------------------------------
STAPAUI    
; PAUSE STATE INIT
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            ;Guardar estado de juego en registros
            MOVE.B  (SCRCYCCT),D1
            
            RTS
; -----------------------------------------------------------------------------
STAPAUU
; INTRO STATE UPDATE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            ;Guardar registros
            MOVE.L  D0,-(A7)

            BTST.B  #KBDBITUP,(KBDEDGE)     ;Check cambio en estado de UP
            BNE.S   .UP
            BTST.B  #KBDBITDN,(KBDEDGE)     ;Check cambio en estado de DOWN
            BNE.S   .DN
            BTST.B  #KBDBITF1,(KBDEDGE)     ;Check cambio en estado de FIRE1
            BNE     .OK
            BTST.B  #KBDBITPS,(KBDEDGE)     ;Check cambio en estado de 'P'
            BEQ.S   .END
            
            MOVE.B  D1,(SCRCYCCT)
            MOVE.W  #STAPLAY,(STANEXT)      ;Si hay cambio en estado de 'P'
                                            ;Actualizar siguiente estado
                                            
.END        ;Restaurar registros
            MOVE.L  (A7)+,D0
            RTS
            
; --- Si UP ha sido presionado ----------

.UP         
            CMP.B   #CONTNUM,(PMOPTN)       ;Check si es posible cambiar a una
            BLE.S   .chksd1                 ;opción superior
            TST.B   (SNDSTA)                ;Check si el audio está ON
            BNE.S   .nplaycnt
            UTLPLAY MNOPTSD
.nplaycnt   SUBQ.B   #1,(PMOPTN)
            BRA.S   .END
.chksd1     
            TST.B   (SNDSTA)                ;Check si el audio está ON
            BNE.S   .nplay1
            UTLPLAY FLAPSND
.nplay1     BRA.S   .END

; --- Si DOWN ha sido presionado ----------
              
.DN
            CMP.B   #EXTNUM,(PMOPTN)        ;Check si es posible cambiar a una
            BGE.S   .chksd2                 ;opción inferior
            TST.B   (SNDSTA)                ;Check si el audio está ON
            BNE.S   .nplayext
            UTLPLAY MNOPTSD
.nplayext   ADDQ.B   #1,(PMOPTN)
            BRA.S   .END
.chksd2
            TST.B   (SNDSTA)                ;Check si el audio está ON
            BNE.S   .nplay2
            UTLPLAY FLAPSND
.nplay2     BRA.S   .END
            
; --- Si OK ha sido presionado ----------
            
.OK
* --------------------------------------
* Check si el item seleccionado es
* Toggle Sound para asegurar que el se
* reproduce el sonido al pasar de OFF a
* ON y no de ON a OFF.
* --------------------------------------
            CMP.B   #TGLSNUM,(PMOPTN)
            BNE.S   .NOTTGL
            
            TST.B   (SNDSTA)            ;IF (SNDSTA) == 0 -> SOUND IS ON
            BEQ.S   .turnoff
            MOVE.B #SOUNDON,(SNDSTA)
.turnoff
            MOVE.B #SOUNDOFF,(SNDSTA)
            
            ;PLAY SOUND IF NECESSARY
.NOTTGL     TST.B   (SNDSTA)                ;Check si el audio está ON
            BNE.S   .nplayok
            UTLPLAY PNCHSND
.nplayok    CLR.L   D0                      ;Preparar registro D0
            MOVE.B  (PMOPTN),D0
            MULU    #6,D0                   
            
            MOVEA.L D0,A0                   ;Usar D0 como indice para .JMPLST
            
            JMP     .JMPLST(A0)
            
.JMPLST     JMP     .CONTGAME               ;Continuar juego seleccionado
            JMP     .NEWGAME                ;Nuevo juego seleccionado
            JMP     .TOGLSD                 ;Toggle sound
            JMP     .EXITGAME               ;Salir seleccionado
            
.CONTGAME
            ;Si última PMOPT == continuar juego, actualizar estado
            MOVE.W  #STAPLAY,(STANEXT)
            MOVE.B  D1,(SCRCYCCT)       ;Recupera el frame count previo a pausa
            BRA     .END
            
.NEWGAME    
            ;Si última PMOPT == nuevo juego, actualizar estado
            JSR     GMRSET
            MOVE.W  #STAINTR,(STANEXT)
            BRA     .END
            
.TOGLSD     ;Si última PMOPT == Sonido on/off, cambiar estado de sonido
            ;Just taking space between tags for consistency
            BRA     .END 

.EXITGAME   
            ;Si última PMOPT == salir de juego, actualizar estado
            JSR     GMRSET
            MOVE.W  #STAGOVR,(STANEXT)
            
            BRA     .END

; -----------------------------------------------------------------------------
STAPAUP
; INTRO STATE PLOT
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            ;Guardar registros
            MOVEM.L D0/A1,-(A7)

            UTLSFIL #$00000000

            **********DIBUJAR TÍTULO**********
            ;Seleccionar fuente de texto
            UTLFONT PAUTITC,PAUTITF
            ;Seleccionar posicion de texto      
            UTLLOCT PAUTITX,PAUTITY               

            LEA     .TITLE,A1
            MOVEQ   #14,D0
            TRAP    #15
            
            **********DIBUJAR OPCION CONTINUAR**********
            ;Seleccionar fuente de texto
            CMP.B   #CONTNUM,(PMOPTN)
            BEQ.S   .CNTSEL
            UTLFONT PAUOPTC,PAUOPTFU        ; Fuente para opción (unselected)
            BRA.S   .SKPCNT

.CNTSEL     UTLFONT PAUOPTC,PAUOPTFS        ; Fuente para opción (selected)
.SKPCNT
            ;Seleccionar posición de texto
            UTLLOCT PAUOPTX,PAUCNTY
            
            LEA     .CONT,A1
            MOVEQ   #14,D0
            TRAP    #15
            
            **********DIBUJAR OPCION JUEGO NUEVO**********
            ;Seleccionar fuente de texto
            CMP.B   #NEWGNUM,(PMOPTN)
            BEQ.S   .NEWSEL
            UTLFONT PAUOPTC,PAUOPTFU        ; Fuente para opción (unselected)
            BRA.S   .SKPNEW

.NEWSEL     UTLFONT PAUOPTC,PAUOPTFS        ; Fuente para opción (selected)
.SKPNEW
            ;Seleccionar posición de texto
            UTLLOCT PAUOPTX,PAUNEWY
            
            LEA     .NEWG,A1
            MOVEQ   #14,D0
            TRAP    #15
            
            **********DIBUJAR OPCIÓN DE TOGGLE SOUND**********
            ;Seleccionar fuente de texto
            CMP.B   #TGLSNUM,(PMOPTN)
            BEQ.S   .SDSEL
            UTLFONT PAUOPTC,PAUOPTFU        ; Fuente para opción (unselected)
            BRA.S   .SKPSD

.SDSEL      UTLFONT PAUOPTC,PAUOPTFS        ; Fuente para opción (selected)
.SKPSD
            ;Seleccionar posición de texto
            UTLLOCT PAUOPTX,PAUSDY
            
            TST.B   (SNDSTA)
            BEQ.S   .on
            
            LEA     .SDOFF,A1
            BRA     .trap
            
.on         LEA     .SDON,A1

.trap       MOVEQ   #14,D0
            TRAP    #15
            
            **********DIBUJAR OPCION SALIR**********
            ;Seleccionar fuente de texto
            CMP.B   #EXTNUM,(PMOPTN)
            BEQ.S   .EXTSEL
            UTLFONT PAUOPTC,PAUOPTFU        ; Fuente para opción (unselected)
            BRA.S   .SKPEXT

.EXTSEL     UTLFONT PAUOPTC,PAUOPTFS        ; Fuente para opción (selected)
.SKPEXT
            ;Seleccionar posición de texto
            UTLLOCT PAUOPTX,PAUEXTY
            
            LEA     .EXIT,A1
            MOVEQ   #14,D0
            TRAP    #15
            
            **********DIBUJAR TEXTO DE AYUDA**********
            ;Seleccionar fuente de texto
            UTLFONT PAUOPTC,PAUHLPF
            ;Seleccionar posición de texto
            UTLLOCT PAUHLPX,PAUHLPY1
            
            LEA     .HLP1,A1
            MOVEQ   #14,D0
            TRAP    #15
            
            UTLLOCT PAUHLPX,PAUHLPY2
            
            LEA     .HLP2,A1
            MOVEQ   #14,D0
            TRAP    #15
            
            ;Restaurar registros
            MOVEM.L (A7)+,D0/A1
            RTS
            
; --- LOCAL DATA -----------------
.TITLE      DC.B    'MENU DE PAUSA',0
.CONT       DC.B    'CONTINUAR',0
.NEWG       DC.B    'JUEGO NUEVO',0
.SDON       DC.B    'SONIDO: ON',0
.SDOFF      DC.B    'SONIDO: OFF',0
.EXIT       DC.B    'SALIR',0
.HLP1       DC.B    'Presione UP o DOWN para moverse por el menú',0
.HLP2       DC.B    'Presione SPACE para seleccionar',0
            DS.W    0
            
; -----------------------------------------------------------------------------
STAGOVRU
; GAME OVER STATE UPDATE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            BTST.B  #KBDBITF1,(KBDEDGE)
            BEQ     .END
            MOVE.W  #STAINTR,(STANEXT)
.END        RTS

; -----------------------------------------------------------------------------
STAGOVRP
; GAME OVER STATE PLOT
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L A1/D0-D1,-(A7)
            UTLLOCT GOVSTRX,GOVSTRY
            UTLFONT GOVSTRC,GOVSTRF
*            UTLSFIL #$00000000
            LEA     .GOVSTR,A1
            MOVE.B  #14,D0
            TRAP    #15
            MOVEM.L (A7)+,A1/D0-D1
            RTS

.GOVSTR     DC.B    'GAME  OVER',0
            DS.W    0


; -----------------------------------------------------------------------------
GMRSET
; RESET GAME VARIABLES TO THEIR INITIAL STATE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - GAME VARIABLES (@ VAR.X68 & SOME OF SYSVAR.X68) 
; -----------------------------------------------------------------------------
            CLR.W   (SCRCYCCT)
            CLR.B   (PMOPTN)
            MOVE.B #1,(PIPCOUNT)
            MOVE.W #5,(XSPEED)
            CLR.B   (UTLRNDIX)
            CLR.W   (PLRPOSX)
            CLR.W   (PLRPOSY)
            CLR.W   (PLRSCORE)
            CLR.B   (PIPCYC)
            RTS   











































*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
