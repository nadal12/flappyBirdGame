; =============================================================================
; GAME OVER SCREEN MANAGEMENT
; =============================================================================

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

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
