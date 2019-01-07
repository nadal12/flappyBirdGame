; =============================================================================
; GAME VARS
; =============================================================================

; --- GAME STATE RELATED VARIABLES --------------------------------------------

STACUR      DS.W    1                       ; CURRENT GAME STATE
STANEXT     DS.W    1                       ; NEXT GAME STATE

; --- PLAYER RELATED VARIABLES ------------------------------------------------

PLRPOSX      DS.W    1                       ; PLAYER X POSITION (PIXELS)
PLRPOSY      DS.W    1                       ; PLAYER Y POSITION (PIXELS)
PLRDEADX     DS.W    1                       ; PLAYER X POSITION AT DEAD
PLRDEADY     DS.W    1                       ; PLAYER Y POSITION AT DEAD
MAXPOS       DS.W    1                       ; JUMP MAX POSITION
UPPRESSED    DS.W    1                       ; 1 IF UP PRESSED, 0 IF NO PRESSED
PLRDOWNSPEED DS.W    1                       ; PLAYER DOWN SPEED
PLRDEAD      DS.W    1                       ; PLAYER DEAD
PLRSCORE     DS.L    1                       ; PLAYER SCORE
PLRSCORETEXT DC.B    'SCORE: ',0             ; SCORE TEXT
             DS.W    0


; --- GAME RELATED VARIABLES --------------------------------------------------

XSPEED      DC.W    5                       ; HORIZONTAL SPEED OF OBJECTS
SNDSTA      DC.B    0                       ; SOUND STATE
PIPCYC      DS.B    1                       ; SPAWN PIPES EVERY PIPCYC CYCLES
GSSCYC      DS.B    1                       ; SPAWN GRASS DETAILS EVERY GSSCYC
*DO NOT CHANGE THE VALUE OF FRSTRUN*
FRSTRUN     DC.B    1                       ; INDICATES IF IT'S A NEW GAME

; --- MENUS RELATED VARIABLES -------------------------------------------------

PMOPTN      DC.B    0                       ; OPTION ON THE MENU TO BE CHOSEN
RSULT       DC.L    0                       ; BUFFER FOR DATA READ FROM FILE

; --- SOUND RELATED VARIABLES -------------------------------------------------

BGSNDINIT   DC.B    0                       ; TO PLAY OR NOT TO PLAY BGSND

; --- UTILITY VARIABLES -------------------------------------------------------

UTLRNDIX    DS.B    1                       ; NEXT INDEX TO RANDOM NUMBER
            DS.W    0


























*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
