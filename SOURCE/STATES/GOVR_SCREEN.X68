; =============================================================================
; GAME OVER SCREEN MANAGEMENT
; =============================================================================
; -----------------------------------------------------------------------------
STAGOVRI
; GAME OVER STATE INITIALIZATION
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------

            ;Verificar si el jugador ha muerto para hacer una espera.
            CMP     #1,(PLRDEAD)
            BNE     .END
            
            JSR     UTLSTBG
            
            ;Sonido colisión
            MOVE.B  #PNCHSND,D1
            JSR     UTLPLAY
            
            ;Espera
            MOVE.B  #23,D0
            MOVEQ   #52,D1  ;Tiempo de punchsound (0,48s).
            TRAP    #15
            
            ;Sonido Game Over,
            MOVE.B  #GOVRSND,D1
            JSR     UTLPLAY
           
.END
            JSR GMRSET
            RTS

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
           
            ;Set background color. 
            MOVE.L  #81, D0
            MOVE.L  #BLACK, D1
            TRAP    #15                   
            
            LEA     .GOVSTR,A1
            MOVE.B  #14,D0
            TRAP    #15
            
            UTLLOCT FINALSCOREX,FINALSCOREY
            
            ;Mostrar puntuación final. 
            UTLLOCT FINALSCOREX,FINALSCOREY
            MOVE    #17, D0
            LEA     .SCORESTR,A1
            MOVE.L  #0, D1
            MOVE.L  (PLRSCORE), D1
            TRAP    #15
            
            ;Mensaje presionar espacio para juego nuevo.
            UTLFONT INTOPTCU,INTHLPF
            UTLLOCT SPACEGOVX,SPACEGOVY
            LEA     .SPACEGOV,A1
            MOVE.B  #14,D0
            TRAP    #15

            MOVEM.L (A7)+,A1/D0-D1
            RTS

.GOVSTR     DC.B    'GAME  OVER',0
.SCORESTR   DC.B    'PUNTUACIÓN FINAL: ',0
.SPACEGOV   DC.B    'Presione SPACE para continuar',0

            DS.W    0












*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
