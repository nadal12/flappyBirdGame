; =============================================================================
; GAME VARS
; =============================================================================

; --- GAME STATE RELATED VARIABLES --------------------------------------------

STACUR      DS.W    1                       ; CURRENT GAME STATE
STANEXT     DS.W    1                       ; NEXT GAME STATE

; --- PLAYER RELATED VARIABLES ------------------------------------------------

PLRPOSX     DS.W    1                       ; PLAYER X POSITION (PIXELS)
PLRPOSY     DS.W    1                       ; PLAYER Y POSITION (PIXELS)
PLRENER     DS.W    1                       ; PLAYER ENERGY
PLRSCORE    DS.W    1                       ; PLAYER SCORE
PLRDMG      DS.B    1                       ; BIT0: UPD DAMAGE, BIT1 PLOT DMG
            DS.W    0

; --- GAME RELATED VARIABLES --------------------------------------------------

XSPEED      DC.W    5                       ; HORIZONTAL SPEED OF OBJECTS
SNDSTA      DC.B    0                       ; SOUND STATE
PIPCYC      DS.B    1                       ; SPAWN PIPES EVERY PIPCYC CYCLES
GSSCYC      DS.B    1                       ; SPAWN GRASS DETAILS EVERY GSSCYC

; --- MENUS RELATED VARIABLES --------------------------------------------

PMOPTN      DC.B    0                       ; OPTION ON THE MENU TO BE CHOSEN


; --- SOUND RELATED VARIABLES -------------------------------------------------

BGSNDINIT   DC.B    0                       ; TO PLAY OR NOT TO PLAY BGSND

; --- UTILITY VARIABLES -------------------------------------------------------

UTLRNDIX    DS.B    1                       ; NEXT INDEX TO RANDOM NUMBER
            DS.W    0


















*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
