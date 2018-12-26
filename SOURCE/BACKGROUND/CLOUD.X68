; =============================================================================
; CLOUD MANAGEMENT. IT IS AN AGENT.
; LOCAL MEMORY IS:
; +0 WORD X COORDINATE
; +2 WORD Y COORDINATE

; =============================================================================

; -----------------------------------------------------------------------------
CLDINIT
; INITALIZES CLOUD
; INPUT    - A0 POINTER TO THE LOCAL MEMORY
; OUTPUT   - NONE
; MODIFIES - NONE
; NOTE     - ASSUMES SCRHEIGH IS GREATER THAN 255
; -----------------------------------------------------------------------------
        ;Guardar registros
        MOVE.L      D0,-(A7)
            
        MOVE.W      #SCRWIDTH,(A0)
        
        JSR         UTLRAND
        MOVE.W      D0,2(A0)
        
        ;Restaurar registros
        MOVE.L      (A7)+,D0
        
        RTS

; -----------------------------------------------------------------------------
CLDUPD
; UPDATES THE STATE OF CLOUDS
; INPUT    - A0 POINTER TO THE LOCAL MEMORY
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
        ;Actualizar posición
        MOVE.L      D0,-(A7)
        
        MOVE.W      (XSPEED),D0
        SUB.W       D0,(A0)
        CMP.W       #-CLDSIZE*2,(A0)
        BLE.S       .KILL

.END    
        MOVE.L      (A7)+,D0
        RTS
        
.KILL   JSR AGLKILL
        BRA         .END     

; -----------------------------------------------------------------------------
CLDPLOT
; PLOTS THE CLOUD IN ITS RIGHTFUL POSITION
; INPUT    - A0 POINTER TO THE LOCAL MEMORY
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------       
        ;Guardar registros
        MOVEM.L     D0-D4,-(A7)
        
        UTLSPEN     #CLDPCLR
        UTLSFIL     #CLDFCLR
        
        ;Preparar parametros
        MOVE.W      (A0),D1     ;X0 COORD
        MOVE.W      2(A0),D2    ;Y0 COORD
        MOVE.W      D1,D3       
        MOVE.W      D2,D4       
        ADD.W       #CLDSIZE*2,D3 ;X1 COORD
        ADD.W       #CLDSIZE,D4 ;Y2 COORD
        
        MOVEQ       #88,D0      ;TASK NUM
        
        TRAP        #15
        
        ;Restaurar registros
        MOVEM.L     (A7)+,D0-D4
        RTS





















*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
