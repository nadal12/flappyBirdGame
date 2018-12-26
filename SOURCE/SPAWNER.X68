; =============================================================================
; SPAWNER MANAGEMENT.
; =============================================================================

; -----------------------------------------------------------------------------
SPWUPD
; UPDATES THE SPAWNER
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
*            MOVEM.L  D0/A1-A3,-(A7)
*
*            MOVE.B  (SCRCYCCT),D0
*            AND     #$7F,D0                 ; EVERY 128 CYCLES
*            BNE     .END                    ; CREATE A NEW CLOUD
*            LEA     CLDINIT,A1
*            LEA     CLDUPD,A2
*            LEA     CLDPLOT,A3
*            MOVE.W  #CLDTYPE,D0
*            
*            JSR     AGLADD
*            
*.END        MOVEM.L (A7)+,D0/A1-A3
            RTS










*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
