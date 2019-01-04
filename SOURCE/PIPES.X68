; =============================================================================
; PIPES MANAGEMENT. IT IS AN AGENT.
; LOCAL MEMORY IS:
; +0 WORD X COORDINATE OF THE LEFTMOST EDGE OF THE VERTICALLY ALIGNED PIPES
; +2 WORD Y COORDINATE OF THE DOWNMOST EDGE OF THE TOP PIPE (FACING DOWN)
; =============================================================================

; -----------------------------------------------------------------------------
PIPINIT
; PIPE INITIALIZATION
; -----------------------------------------------------------------------------
            ;Guardar registros
            MOVEM.L D0-D1,-(A7)
        
            MOVE.W  #SCRWIDTH,(A0)      ;X COORDINATE OF STARTING POSITION
            JSR     UTLRAND             ;RANDOM Y COORDINATE OF STARTING
            MOVE.W  D0,2(A0)            *POSITION
        
            ;Restaurar registros
            MOVEM.L (A7)+,D0-D1
            RTS
            
; -----------------------------------------------------------------------------
PIPUPD
; PIPE UPDATE
; -----------------------------------------------------------------------------
            ;Guardar registros
            MOVE.L  D0,-(A7)
            
            MOVE.W  (XSPEED),D0     
            SUB.W   D0,(A0)         ;UPDATE X COORDINATE
            
            CMP.W   #-PIPTWDT,(A0)
            BLE.S   .KILL
            
            ;Preparar los registros para llamar a la subrutina que comprueba 
            ;las colisiones con las tuberías. 
            MOVE.W (A0), D0
            MOVE.W 2(A0), D1
            MOVE.W (PLRPOSX), D2
            MOVE.W (PLRPOSY), D3
            MOVE.W #PIPBWDT, D4
            MOVE.W #PLRWIDTH, D5
            MOVE.W #PIPOPEN, D6
            MOVE.W #PLRHEIGHT, D7
            JSR UTLCHCOL           
            
            TST.B D0
            BEQ .END
            MOVE.W #1, (PLRDEAD)
            
.END        ;Restaurar registros
            MOVE.L  (A7)+,D0
            RTS
            
.KILL       JSR     AGLKILL
            BRA.S  .END
            
; -----------------------------------------------------------------------------
PIPPLOT
; PIPE PLOT
; -----------------------------------------------------------------------------
            ;Guardar registros
            MOVEM.L D0-D4,-(A7)
            
            ;Seleccionar colores de relleno y dibujado para tuberías.
            UTLSPEN #PIPPC
            UTLSFIL #PIPFC
            
            MOVE.W  (A0),D1         ;PAINT THE BASE OF THE TOP PIPE
            ADDQ    #PIPTBSPC,D1
            CLR     D2
            MOVE.W  D1,D3
            ADD.W   #PIPBWDT,D3
            MOVE.W  2(A0),D4
            
            MOVEQ   #87,D0
            TRAP    #15
            
            MOVE.W  (A0),D1         ;PAINT THE MOUTH OF THE TOP PIPE
            MOVE.W  2(A0),D4
            MOVE.W  D4,D2
            SUB.W   #PIPTHGT,D2
            MOVE.W  D1,D3
            ADD.W   #PIPTWDT,D3
            
            MOVEQ   #87,D0
            TRAP    #15
            
            MOVE.W  (A0),D1         ;PAINT THE BASE OF THE BOTTOM PIPE
            ADD.W   #PIPTBSPC,D1
            MOVE.W  2(A0),D2
            ADD.W   #PIPOPEN,D2
            MOVE.W  D1,D3
            ADD.W   #PIPBWDT,D3
            MOVE.W  #BGGSSTP,D4
            
            MOVEQ   #87,D0
            TRAP    #15
            
            MOVE.W  (A0),D1         ;PAINT THE MOUTH OF THE BOTTOM PIPE
            MOVE.W  2(A0),D2
            ADD.W   #PIPOPEN,D2
            MOVE.W  D1,D3
            ADD.W   #PIPTWDT,D3
            MOVE.W  D2,D4
            ADD.W   #PIPTHGT,D4
            
            MOVEQ   #87,D0
            TRAP    #15

            ;Restaurar registros
            MOVEM.L (A7)+,D0-D4
            RTS










*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
