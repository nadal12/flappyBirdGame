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
.INITBL     DC.L    STAINTRI,STAEMPTY,STAPAUI,STAEMPTY
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
;STAPLAYI    EQU     PLRINIT
; PLAY STATE INITIALIZATION.
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; NOTE     - JUST A WRAPPER FOR PLRINIT
; -----------------------------------------------------------------------------

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
STAINTRI    EQU     DMMINIT
; INTRO STATE INIT
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; NOTE     - JUST A WRAPPER FOR DMMINIT TO RELEASE ALL MEMORY
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
STAINTRU
; INTRO STATE UPDATE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            BTST.B  #KBDBITF1,(KBDEDGE)
            BEQ     .END
            BTST.B  #KBDBITLF,(KBDEDGE)
            BNE.S   .LEFT
            BTST.B  #KBDBITRT,(KBDEDGE)
            BNE.S   .RIGHT
            
            MOVE.W  #STAPLAY,(STANEXT)
            BRA.S   .END

.LEFT       CMP     #INTOESY,(XSPEED)
            BGT.S   .LF
            BRA.S   .END
.RIGHT      CMP     #INTOHRD,(XSPEED)
            BLT.S   .RT
            BRA     .END            

.END        RTS

.LF         SUB.W   #2,(XSPEED)
            BRA.S   .END
            
.RT         ADD.W   #2,(XSPEED)
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
            
            ;Seleccionar fuente de texto
            UTLFONT INTTITC,INTTITF
            ;Seleccionar posicion de texto      
            UTLLOCT INTTITX,INTTITY               

            LEA     .TITLE,A1
            MOVE.B  #14,D0
            TRAP    #15
            
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
.DIF_ESY    DC.B    'DIFICULTAD: FÁCIL',0
.DIF_NRM    DC.B    'DIFICULTAD: NORMAL',0
.DIF_HRD    DC.B    'DIFICULTAD: DIFICIL',0
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
            BNE.S   .OK
            BTST.B  #KBDBITPS,(KBDEDGE)     ;Check cambio en estado de 'P'
            BEQ.S   .END
            
            MOVE.B  D1,(SCRCYCCT)
            MOVE.W  #STAPLAY,(STANEXT)      ;Si hay cambio en estado de 'P'
                                            ;Actualizar siguiente estado
                                            
.END        ;Restaurar registros
            MOVE.L  (A7)+,D0
            RTS

.UP         CMP.B   #CONTNUM,(PMOPTN)       ;Check si es posible cambiar a una
            BLE.S   .END                    ;opción superior
            SUBQ.B   #1,(PMOPTN)
            BRA.S   .END
            
.DN         CMP.B   #EXTNUM,(PMOPTN)        ;Check si es posible cambiar a una
            BGE.S   .END                    ;opción inferior
            ADDQ.B   #1,(PMOPTN)
            BRA.S   .END
            
.OK         
            CLR.L   D0                      ;Preparar registro D0
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
            TST.B   (SNDSTA)            ;IF (SNDSTA) == 0 -> SOUND IS ON
            BEQ.S   .turnoff
            
            MOVE.B #SOUNDON,(SNDSTA)
            BRA     .END
.turnoff
            MOVE.B #SOUNDOFF,(SNDSTA)
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
            UTLFONT PAUOPTC,PAUOPTFU
            BRA.S   .SKPCNT

.CNTSEL     UTLFONT PAUOPTC,PAUOPTFS
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
            UTLFONT PAUOPTC,PAUOPTFU
            BRA.S   .SKPNEW

.NEWSEL     UTLFONT PAUOPTC,PAUOPTFS
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
            UTLFONT PAUOPTC,PAUOPTFU
            BRA.S   .SKPSD

.SDSEL      UTLFONT PAUOPTC,PAUOPTFS
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
            UTLFONT PAUOPTC,PAUOPTFU
            BRA.S   .SKPEXT

.EXTSEL     UTLFONT PAUOPTC,PAUOPTFS
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
            MOVE.B  (KBDEDGE),D7
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
            CLR.B   (SCRCYCCT)
            CLR.B   (PMOPTN)
            MOVE.B #1,(PIPCOUNT)
            MOVE.W #5,(XSPEED)
            CLR.B   (UTLRNDIX)
            CLR.W   (PLRPOSX)
            CLR.W   (PLRPOSY)
            CLR.W   (PLRSCORE)
            RTS   





























*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
