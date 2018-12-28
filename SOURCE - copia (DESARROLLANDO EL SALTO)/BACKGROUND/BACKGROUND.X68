;------------------------------------------------------------------------------
; BACKGROUND
;------------------------------------------------------------------------------
            INCLUDE "BACKGROUND/CLOUD.X68"     ; BACKGROUND CLOUDS MANAGEMENT 
            INCLUDE "BACKGROUND/GSSDETAIL.X68" ; GRASS DETAILS MANAGEMENT
; -----------------------------------------------------------------------------
BGUPD
; UPDATES DETAILS OF BACKGROUND
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - MEMORY WHEN NEEDED
; -----------------------------------------------------------------------------
            MOVEM.L  D0/A1-A3,-(A7)

            MOVE.B  (SCRCYCCT),D0
            AND     #$07,D0                 ;EVERY 8 CYCLES
            BNE.S   .CLOUD                  ;CREATE A NEW MARK ON GRASS
            LEA     GSSDINIT,A1
            LEA     GSSDUPD,A2
            LEA     GSSDPLOT,A3
            MOVE.W  #GSSDTYPE,D0
            
            JSR     PRPADD

.CLOUD      MOVE.B  (SCRCYCCT),D0
            AND     #$FF,D0                 ; EVERY 256 CYCLES
            BNE     .END                    ; CREATE A NEW CLOUD
            LEA     CLDINIT,A1
            LEA     CLDUPD,A2
            LEA     CLDPLOT,A3
            MOVE.W  #CLDTYPE,D0
            
            JSR     PRPADD
            
.END        MOVEM.L (A7)+,D0/A1-A3
            RTS


; -----------------------------------------------------------------------------
BGPLOT
; PLOTS BACKGROUND
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            
            MOVEM.W D1-D4,-(A7)
            
            UTLSPEN #BGSKYPC
            UTLSFIL #BGSKYFC
            
            CLR.W   D1
            CLR.W   D2
            MOVE.W  #SCRWIDTH,D3
            MOVE.W  #SCRHEIGH,D4
            
            MOVEQ   #87,D0
            TRAP    #15
            
            UTLSFIL #BGGNDFC
            
            CLR     D1
            MOVE.W  #BGGSSBT,D2
            MOVE.W  #SCRWIDTH,D3
            MOVE.W  #SCRHEIGH,D4
            
            MOVEQ   #87,D0
            TRAP    #15
            
            UTLSFIL #BGGSSFC


            CLR     D1
            MOVE.W  #BGGSSTP,D2
            MOVE.W  #SCRWIDTH,D3
            MOVE.W  #BGGSSBT,D4
            
            MOVEQ   #87,D0
            TRAP    #15
            
            MOVEM.W (A7)+,D1-D4
            RTS


















*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
