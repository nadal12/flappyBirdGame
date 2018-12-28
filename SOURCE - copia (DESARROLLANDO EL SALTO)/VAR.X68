; =============================================================================
; GAME VARS
; =============================================================================

; --- GAME STATE RELATED VARIABLES --------------------------------------------

STACUR      DS.W    1                       ; CURRENT GAME STATE
STANEXT     DS.W    1                       ; NEXT GAME STATE

; --- PLAYER RELATED VARIABLES ------------------------------------------------

PLRPOSX     DS.W    1                       ; PLAYER X POSITION (PIXELS)
PLRPOSY     DS.W    1                       ; PLAYER Y POSITION (PIXELS)
MAXPOS      DS.W    1
UPPRESSED   DS.W    1
PLRSPEED    DS.W    1
            DS.W    0
            
; --- PIPE RELATED VARIABLES --------------------------------------------------

PIPCOUNT    DC.B    1
            DS.W    0

; --- GAME RELATED VARIABLES --------------------------------------------------

XSPEED      DC.W    5                       ;HORIZONTAL SPEED OF OBJECTS

; --- PAUSE MENU RELATED VARIABLES -------------------------------------------

PMOPTN      DC.B    0                       ;OPTION ON THE MENU TO BE CHOSEN

; --- UTILITY VARIABLES ------------------------------------------------------

UTLRNDIX    DS.B    1                       ; NEXT INDEX TO RANDOM NUMBER
            DS.W    0













*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
