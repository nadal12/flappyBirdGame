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
            CLR.W   D7  
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
.INITBL     DC.L    STAINTRI,STAEMPTY,STAPLAYI,STAPAUI,STAGOVRI
.UPDTBL     DC.L    STAINTRU,STAINSTU,STAPLAYU,STAPAUU,STAGOVRU

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
.PLTTBL     DC.L    STAINTRP,STAINSTP,STAPLAYP,STAPAUP,STAGOVRP

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
            ;Comprobar si es la primera vez que se ejecuta el juego.             
            TST.B   (FRSTRUN)
            BEQ     .END
            CLR.B   (FRSTRUN)
            ;Guardar registros
            MOVE.L  D0,-(A7)
            
            CLR.B   (BGSNDINIT)
            
            MOVE.W  (XSPEED),D0         ; CHECK DIFFICULTY CHOSEN TO ADAPT
            CMP.W   #INTOESY,D0         ; BRANCH IF CHOSEN EASY MODE
            BEQ.S   .EASY
            CMP.W   #INTOHRD,D0         ; BRANCH IF CHOSEN HARD MODE
            BEQ.S   .HARD
            
            MOVE.B  #GPIPCNRM,(PIPCYC)  ; NORMAL MODE SELECTED
            MOVE.B  #GGSSCNRM,(GSSCYC)
            
.PLRINIT    JSR     PLRINIT
            
            ;Restaurar registros
            MOVE.L  (A7)+,D0
.END        RTS
.EASY   
            MOVE.B  #GPIPCESY,(PIPCYC)  ; EASY MODE SELECTED
            MOVE.B  #GGSSCESY,(GSSCYC)
            BRA.S   .PLRINIT
.HARD
            MOVE.B  #GPIPCHRD,(PIPCYC)  ; HARD MODE SELECTED
            MOVE.B  #GGSSCHRD,(GSSCYC)
            BRA.S   .PLRINIT
; -----------------------------------------------------------------------------
STAPLAYU
; PLAY STATE UPDATE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            BTST.B   #KBDBITPS,(KBDEDGE)         ;Si 'P' es presionado, pausa.
            BNE.S   .PAUSE
            
            JSR     PLRUPD
            JSR     SNDUPD
            JSR     BGUPD
            JSR     PRPUPD
            JSR     SPWUPD
            BRA     AGLUPD
.PAUSE      
            JSR     UTLSTBG
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
            JSR     AGLPLOT
            BRA     PLRPLOT
; -----------------------------------------------------------------------------
GMRSET
; RESET GAME VARIABLES TO THEIR INITIAL STATE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - GAME VARIABLES (@ VAR.X68 & SOME OF SYSVAR.X68) 
; -----------------------------------------------------------------------------
            CLR.B   (SCRCYCCT)
            CLR.B   (PMOPTN)
            CLR.B   (BGSNDINIT)
            MOVE.W  #5,(XSPEED)
            CLR.B   (UTLRNDIX)
            CLR.B   (PIPCYC)
            CLR.B   (GSSCYC)
            MOVE.B  #1,(FRSTRUN)
            RTS

; -----------------------------------------------------------------------------
;   INCLUDES
; -----------------------------------------------------------------------------
            INCLUDE "STATES/INTRO_SCREEN.X68"
            INCLUDE "STATES/INSTR_SCREEN.X68"
            INCLUDE "STATES/PAUSE_SCREEN.X68"
            INCLUDE "STATES/GOVR_SCREEN.X68"














*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
