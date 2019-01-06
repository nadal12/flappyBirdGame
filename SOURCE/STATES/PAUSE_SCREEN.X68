; =============================================================================
; PAUSE MENU MANAGEMENT
; =============================================================================

; -----------------------------------------------------------------------------
STAPAUI    
; PAUSE STATE INIT
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            ;Guardar estado de juego en registros
            ;CLR.B   (PMOPTN)
            MOVE.B  (SCRCYCCT),D1                 ;Guardar numero de ciclos de
                                                  ;pantalla: -> restaurar luego
            
            RTS
; -----------------------------------------------------------------------------
STAPAUU
; INTRO STATE UPDATE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            ;Guardar registros
            MOVEM.L  D0-D1,-(A7)

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
            MOVEM.L  (A7)+,D0-D1
            RTS
            
; --- Si UP ha sido presionado ----------

.UP         
            CMP.B   #CONTNUM,(PMOPTN)       ;Check si es posible cambiar a una
            BLE.S   .chksd1                 ;opción superior
            MOVE.B  #MNOPTSD,D1         ; PREPARAR REGISTRO PARA SUBRUTINA
            JSR     UTLPLAY
            SUBQ.B   #1,(PMOPTN)
            BRA.S   .END
.chksd1     
            MOVE.B  #FLAPSND,D1         ; PREPARAR REGISTRO PARA SUBRUTINA
            JSR     UTLPLAY
            BRA.S   .END

; --- Si DOWN ha sido presionado ----------
              
.DN
            CMP.B   #EXTNUM,(PMOPTN)        ;Check si es posible cambiar a una
            BGE.S   .chksd2                 ;opción inferior
            MOVE.B  #MNOPTSD,D1         ; PREPARAR REGISTRO PARA SUBRUTINA
            JSR     UTLPLAY
            ADDQ.B   #1,(PMOPTN)
            BRA.S   .END
.chksd2
            MOVE.B  #FLAPSND,D1         ; PREPARAR REGISTRO PARA SUBRUTINA
            JSR     UTLPLAY
            BRA.S   .END
            
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
            MOVE.B  #SOUNDON,(SNDSTA)   ;Turn on if sound was previously off
            BRA.S   .skptglok
.turnoff
            MOVE.B #SOUNDOFF,(SNDSTA)   ;turn off if sound was previously on
.skptglok
            ;PLAY SOUND IF NECESSARY
.NOTTGL     MOVE.B  #PNCHSND,D1         ; PREPARAR REGISTRO PARA SUBRUTINA
            JSR     UTLPLAY
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

            
            **********DIBUJAR TÍTULO**********
            ;Seleccionar fuente de texto
            UTLFONT PAUTITC,PAUTITF
            ;Seleccionar posicion de texto      
            UTLLOCT PAUTITX,PAUTITY
            ;Seleccionar color de relleno            
            UTLSFIL #$00000000
            LEA     .TITLE,A1
            MOVEQ   #14,D0
            TRAP    #15
            
            **********DIBUJAR OPCION CONTINUAR**********
            ;Seleccionar fuente de texto
            CMP.B   #CONTNUM,(PMOPTN)
            BEQ.S   .CNTSEL
            UTLFONT PAUOPTC,PAUOPTFU        ; Fuente para opción (unselected)
            BRA.S   .SKPCNT

.CNTSEL     UTLFONT PAUOPTC2,PAUOPTFS        ; Fuente para opción (selected)
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

.NEWSEL     UTLFONT PAUOPTC2,PAUOPTFS        ; Fuente para opción (selected)
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

.SDSEL      UTLFONT PAUOPTC2,PAUOPTFS        ; Fuente para opción (selected)
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

.EXTSEL     UTLFONT PAUOPTC2,PAUOPTFS        ; Fuente para opción (selected)
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
            
                        
            ;Cambiar fuente de texto para ajustar altura de titulo
            UTLFONT 00000000,PSHFNT
            
            ;Restaurar registros
            MOVEM.L (A7)+,D0/A1
            RTS
            
; --- LOCAL DATA -----------------
.TITLE      DC.B    'FLAPPY BIRD',0
.CONT       DC.B    'CONTINUAR',0
.NEWG       DC.B    'JUEGO NUEVO',0
.SDON       DC.B    'SONIDO: ON',0
.SDOFF      DC.B    'SONIDO: OFF',0
.EXIT       DC.B    'SALIR',0
.HLP1       DC.B    'Presione UP o DOWN para moverse por el menú',0
.HLP2       DC.B    'Presione SPACE para seleccionar',0
            DS.W    0












*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
