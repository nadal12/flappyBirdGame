; =============================================================================
; GRASS DETAILS MANAGEMENT. IT IS A PROP.
; LOCAL MEMORY IS:
; +0 WORD X COORDINATE
; =============================================================================

; -----------------------------------------------------------------------------
GSSDINIT
; INITIALIZES THE LITTLE DETAILS ON THE GRASS
; -----------------------------------------------------------------------------
        MOVE.L      D0,-(A7)
        
        MOVE.W      #SCRWIDTH,(A0)
        
        MOVE.L      (A7)+,D0
        RTS
        
        
; -----------------------------------------------------------------------------
GSSDUPD
; MODIFIES THE LITTLE DETAILS ON THE GRASS' X COORDINATE
; -----------------------------------------------------------------------------
        ;Guardar registros
        MOVE.L      D0,-(A7)

        MOVE.W      (XSPEED),D0
        SUB.W       D0,(A0)         ;UPDATE X COORDINATE
        CMP.W       #-GSSDWDTH,(A0)
        BLE.S       .KILL
        
.END    ;Restaurar registros
        MOVE.L      (A7)+,D0
        RTS

.KILL   JSR         PRPKILL
        BRA         .END
        
; -----------------------------------------------------------------------------
GSSDPLOT
; PLOTS THE LITTLE DETAILS ON THE GRASS' X COORDINATE
; -----------------------------------------------------------------------------
        MOVEM.L     D0-D4,-(A7)
        
        UTLSPEN     #$00000000
        UTLSFIL     #GSSDFC
        
        MOVE.W      (A0),D1
        MOVE.W      #BGGSSTP,D2
        MOVE.W      D1,D3
        ADD.W       #GSSDWDTH,D3
        MOVE.W      #BGGSSBT,D4
        
        MOVEQ       #87,D0
        TRAP        #15
        
        MOVEM.L     (A7)+,D0-D4
        RTS
        







*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
