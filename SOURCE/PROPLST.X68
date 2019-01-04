; =============================================================================
; PROP MANAGEMENT
; EACH PROP HAS A DATA BLOCK FROM DMM AS FOLLOWS:
; +0 - LONG : UPDATE SUBROUTINE POINTER
; +4 - LONG : PLOT SUBROUTINE POINTER
; +8:END    : DATA (PROP SPECIFIC)
; =============================================================================

; -----------------------------------------------------------------------------
PRPADD
; CREATES A NEW PROP
; INPUT    - A1 - POINTER TO PROP INIT FUNCTION
;            A2 - POINTER TO PROP UPDATE FUNCTION
;            A3 - POINTER TO PROP PLOT FUNCTION
;            D0 - PROP TYPE (USED AS OWNED BY DMM)
;            D1 - PROP INITIALIZATION PARAMETER 1
;            D2 - PROP INITIALIZATION PARAMETER 2
;            D3 - PROP INITIALIZATION PARAMETER 3
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVE.L  A0,-(A7)
            
            JSR     DMMALLOC
            CMP.L   #0,A0
            BEQ     .END
            MOVE.L  A2,(A0)+
            MOVE.L  A3,(A0)+
            JSR     (A1)

.END        MOVE.L  (A7)+,A0
            RTS

; -----------------------------------------------------------------------------
PRPUPD
; UPDATES THE PROP LIST. PRIOR TO CALLING THE UPDATE FUNCTIONS, A0 IS SET
; TO THE DATA BLOCK OF THE CORRESPONDING SLOT.
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L A0-A1,-(A7)
            
            JSR     DMMFIRST
.LOOP       CMP.L   #0,A0
            BEQ     .END
            CMP.W   #PIPTYPE,-2(A0) ;IF MEMORY DOESN'T BELONG TO PROPS
            BEQ     .NEXT           ;SKIP
            
            MOVE.L  (A0),A1
            ADD.L   #8,A0
            JSR     (A1)
            
.NEXT       JSR     DMMNEXT
            BRA     .LOOP
            
.END        MOVEM.L (A7)+,A0-A1            
            RTS
            
; -----------------------------------------------------------------------------
PRPPLOT
; PLOTS THE PROP LIST. PRIOR TO CALLING THE UPDATE FUNCTIONS, A0 IS SET
; TO THE DATA BLOCK OF THE CORRESPONDING SLOT.
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L A0-A1,-(A7)

            JSR     DMMFIRST
.LOOP       CMP.L   #0,A0
            BEQ     .END
            CMP.W   #PIPTYPE,-2(A0)     ;IF MEMORY DOESN'T BELONG TO PROP
            BEQ.S   .NEXT               ;SKIP
            
            MOVE.L  4(A0),A1
            ADD.L   #8,A0
            JSR     (A1)
.NEXT       JSR     DMMNEXT
            BRA     .LOOP
.END        MOVEM.L (A7)+,A0-A1

            RTS

; -----------------------------------------------------------------------------
PRPKILL     EQU     DMMFREE
; KILLS THE PRP BY RELEASING ITS MEMORY
; INPUT    - A0 POINTER WITHIN THE AGENT MEMORY
; OUTPUT   - NONE
; MODIFIES - NONE
; NOTE     - IT IS JUST A WRAPPER FOR DMMFREE
; -----------------------------------------------------------------------------














*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
