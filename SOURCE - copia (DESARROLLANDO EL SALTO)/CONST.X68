; =============================================================================
; SYSTEM CONSTANTS
; =============================================================================

; --- GAME STATES -------------------------------------------------------------

STANONE     EQU     -1                      ; PLACEHOLDER TO FORCE CHANGE
STAINTR     EQU     0                       ; INTRO/PRESS FIRE STATE
STAPLAY     EQU     1                       ; NORMAL GAME STATE
STAPAU      EQU     2                       ; PAUSE GAME STATE
STAGOVR     EQU     3                       ; GAME OVER STATE

; --- AGENT & PROP TYPES -------------------------------------------------------------

CLDTYPE     EQU     1                       ; NUMBER FOR CLOUD TYPES
GSSDTYPE    EQU     2                       ; NUMBER FOR GRASS DETAIL TYPES
PIPTYPE     EQU     3                       ; NUMBER FOR PIPE TYPES


; --- INTRO STATE RELATED CONSTANTS -------------------------------------------

INTTITX     EQU     1                       ; TITLE X COORDINATE
INTTITY     EQU     1                       ; TITLE Y COORDINATE
INTTITC     EQU     $0000FFFF               ; TITLE COLOR
INTTITF     EQU     $033D0001               ; TITLE FONT
INTPRSX     EQU     5                       ; PRESS FIRE X COORDINATE
INTPRSY     EQU     8                       ; PRESS FIRE Y COORDINATE
INTPRSC     EQU     $00000080               ; PRESS FIRE COLOR
INTPRSF     EQU     $031A0001               ; PRESS FIRE FONT

; --- BACKGROUND RELATED CONSTANTS --------------------------------------------

BGSKYPC     EQU     $00000000               ; BACKGROUND SKY PEN COLOUR
BGSKYFC     EQU     $00EFCE87               ; BACKGROUND SKY FILL COLOUR
BGGSSPC     EQU     $00000000               ; BACKGROUND GRASS PEN COLOUR
BGGSSFC     EQU     $0000990A               ; BACKGROUND GRASS FILL COLOUR
BGGSSTP     EQU     SCRHEIGH*3/4            ; GRASS TOP EDGE (Y) COORDINATE
BGGSSBT     EQU     BGGSSTP+40              ; GRASS BOTTOM EDGE (Y) COORDINATE
GSSDWDTH    EQU     10                      ; GRASS DETAIL WIDTH
GSSDFC      EQU     $0039DB44               ; BACKGROUND GRASS DETAIL F.COLOUR
BGGNDPC     EQU     $00000000               ; BACKGROUND GROUND PEN COLOUR
BGGNDFC     EQU     $00155DD8               ; BACKGROUND GROUND FILL COLOUR
BGGNDTP     EQU     BGGSSBT                 ; GROUND TOP EDGE (Y) COORDINATE

; --- PLAYER RELATED CONSTANTS ------------------------------------------------

      ;Player colours

GREEN EQU $00008000 
RED   EQU $000000FF 
WHITE EQU $00FFFFFF 
BLACK EQU $00000000

      ;Constants
      
PLRCOLOR        EQU GREEN
PLREYECOLOR     EQU WHITE
PLRIRISCOLOR    EQU BLACK
PLRMOUTHCOLOR   EQU RED
PLRWIDTH        EQU 30
PLRHEIGHT       EQU 30
PLRINITPOSX     EQU 150
PLRINITPOSY     EQU 180

; --- PIPE RELATED CONSTANTS --------------------------------------------------

PIPPC       EQU     $00000000               ; PIPE PEN COLOUR
PIPFC       EQU     $00196600               ; PIPE FILL COLOUR
PIPBWDT     EQU     50                      ; PIPE BASE WIDTH
PIPTWDT     EQU     60                      ; PIPE MOUTH WIDTH
PIPTHGT     EQU     10                      ; PIPE MOUTH HEIGHT
PIPTBSPC    EQU     ((PIPTWDT-PIPBWDT)/2)   ; DIF.BETW. OUTER RAD. & IN. RAD
PIPOPEN     EQU     80                      ; SPACE BETW. TOP AND BOTTOM PIPES
PIPYSPD     EQU     2                       ; SPEED @ WHICH PIPES GO UP&DOWN

; --- CLOUD RELATED CONSTANTS -------------------------------------------------

CLDSIZE     EQU     60                      ; CLOUD DIAMETER
CLDPCLR     EQU     $00FFFFFF               ; CLOUD PEN COLOR
CLDFCLR     EQU     $00FFFFFF               ; CLOUD FIL COLOR

; --- PAUSE STATE RELATED CONSTANTS ---------------------------------------

CONTNUM     EQU     0                       ; CONTINUE GAME NUMBER
NEWGNUM     EQU     1                       ; NEW GAME NUMBER
EXTNUM      EQU     2                       ; EXIT GAME NUMBER
PAUTITC     EQU     $0000FFFF               ; TITLE COLOUR
PAUTITF     EQU     $03300001               ; TITLE FONT
PAUOPTFU    EQU     $01130001               ; OPTION FONT (unselected)
PAUOPTFS    EQU     $01130005               ; OPTION FONT (selected)
PAUOPTC     EQU     $00FFFFFF               ; OPTION COLOUR
PAUTITX     EQU     2                       ; TITLE COORD. X
PAUTITY     EQU     1                       ; TITLE COORD. Y
PAUOPTX     EQU     15                      ; OPTIONS COORD. X
PAUCNTY     EQU     8                       ; CONTINUE OPTION COORD. Y
PAUNEWY     EQU     10                      ; NEW GAME OPTION COORD. Y
PAUEXTY     EQU     12                      ; EXIT OPTION COORD. Y
PAUSELC     EQU     $000000FF               ; SELECTED OPTION COLOUR

; --- GAME OVER STATE RELATED CONSTANTS ---------------------------------------

GOVSTRX     EQU     35                      ; TITLE X COORDINATE
GOVSTRY     EQU     15                      ; TITLE Y COORDINATE
GOVSTRC     EQU     $00FFFFFF               ; TITLE COLOR

























*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
