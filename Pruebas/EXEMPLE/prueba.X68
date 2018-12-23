*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $1000
    
; --- INTRO STATE RELATED CONSTANTS -------------------------------------------

INTTITX     EQU     1                       ; TITLE X COORDINATE
INTTITY     EQU     1                       ; TITLE Y COORDINATE
INTTITC     EQU     $0000FFFF               ; TITLE COLOR
INTTITF     EQU     $033D0001               ; TITLE FONT

INTPRSX     EQU     5                       ; PRESS FIRE X COORDINATE
INTPRSY     EQU     8                     ; PRESS FIRE Y COORDINATE
INTPRSC     EQU     $00000080               ; PRESS FIRE COLOR
INTPRSF     EQU     $031A0001               ; PRESS FIRE FONT
    
START:                  ; first instruction of program

            MOVE.L  #INTTITC,D1
            MOVE.L  #INTTITF,D2
            MOVEQ   #21,D0
            TRAP    #15

            MOVE.W  #INTTITX<<8|INTTITY, D1
            MOVE.B  #11,D0
            TRAP    #15

            LEA     .TITLE,A1
            MOVE.B  #14,D0
            TRAP    #15

            MOVE.L  #INTPRSC,D1
            MOVE.L  #INTPRSF,D2
            MOVEQ   #21,D0
            TRAP    #15

            MOVE.W  #INTPRSX<<8|INTPRSY, D1
            MOVE.B  #11,D0
            TRAP    #15

            LEA     .START_TEXT,A1
            MOVE.B  #14,D0
            TRAP    #15

            SIMHALT             ; halt simulator

.TITLE      DC.B    'FLAPPY BIRD',0 
.START_TEXT DC.B    'PRESS SPACE TO START',0
            DS.W    0

 

* Put variables and constants here

    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
