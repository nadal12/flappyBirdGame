; =============================================================================
; SYSTEM CONSTANTS
; =============================================================================

; --- GAME STATES -------------------------------------------------------------

STANONE     EQU     -1                      ; PLACEHOLDER TO FORCE CHANGE
STAINTR     EQU     0                       ; INTRO/PRESS FIRE STATE
STAPLAY     EQU     1                       ; NORMAL GAME STATE
STAPAU      EQU     2                       ; PAUSE GAME STATE
STAGOVR     EQU     3                       ; GAME OVER STATE

; --- GAME RELATED CONSTANTS --------------------------------------------------

*DO NOT CHANGE THE VALUE OF SOUNDON ($00)*
SOUNDON     EQU     $00                     ; VALUE OF SNDSTA WHEN SOUND IS ON
SOUNDOFF    EQU     $FF                     ; VALUE OF SNDSTA WHEN SOUND IS OFF
GPIPCESY    EQU     $7F                     ; CREATE PIPES EVERY 128 CYCLES
GPIPCNRM    EQU     $3F                     ; CREATE PIPES EVERY 64 CYCLES
GPIPCHRD    EQU     $1F                     ; CREATE PIPES EVERY 32 CYCLES
GGSSCESY    EQU     $1F                     ; CREATE G.DET. EVERY 32 CYCLES
GGSSCNRM    EQU     $0F                     ; CREATE G.DET. EVERY 16 CYCLES
GGSSCHRD    EQU     $07                     ; CREATE G.DET. EVERY 8 CYCLES

; --- AGENT & PROP TYPES ------------------------------------------------------

CLDTYPE     EQU     1                       ; NUMBER FOR CLOUD TYPES
GSSDTYPE    EQU     2                       ; NUMBER FOR GRASS DETAIL TYPES
PIPTYPE     EQU     3                       ; NUMBER FOR PIPE TYPES

; --- PLAYER RELATED CONSTANTS ------------------------------------------------

PLRWIDTH    EQU     30                      ; PLAYER WIDTH (PIXELS)
PLRHEIGH    EQU     30                      ; PLAYER HEIGHT (PIXELS)
PLRINIEN    EQU     500                     ; PLAYER INITIAL ENERGY (<SCRWIDTH)
PLRSPEED    EQU     5                       ; PLAYER SPEED (PIXELS PER INT)
PLRNRMCL    EQU     $0000C0FF               ; PLAYER NORMAL COLOR
PLRDMGCL    EQU     $000000FF               ; PLAYER DAMAGED COLOR
PLRTXTCL    EQU     $00FFFFFF               ; FONT COLOR
PLRTXTX     EQU     2                       ; SCORE X COORDINATE
PLRTXTY     EQU     1                       ; SCORE Y COORDINATE
PLRLIFEH    EQU     20                      ; HEIGHT OF LIFE BAR
PLRLIFEY    EQU     SCRHEIGH-PLRLIFEH*2     ; LIFE BAR Y POS
PLRLIFEC    EQU     $000000FF               ; LIFE BAR COLOR
PLRUMDMG    EQU     %00000001               ; UPDATE DAMAGE MASK
PLRPMDMG    EQU     %00000010               ; PLOT DAMAGE MASK
PLRUBDMG    EQU     0                       ; UPDATE DAMAGE BIT
PLRPBDMG    EQU     1                       ; PLOT DAMAGE BIT

; --- INTRO STATE RELATED CONSTANTS -------------------------------------------

INTTITX     EQU     2                       ; TITLE X COORDINATE
INTTITY     EQU     1                       ; TITLE Y COORDINATE
INTTITC     EQU     $0000FFFF               ; TITLE COLOR
INTTITF     EQU     $013D0001               ; TITLE FONT
INTPRSX     EQU     3                       ; PRESS SPACE X COORDINATE
INTPRSY     EQU     8                       ; PRESS SPACE Y COORDINATE
INTPRSC     EQU     $00000080               ; PRESS SPACE COLOR
INTPRSF     EQU     $011A0001               ; PRESS SPACE FONT
INTOESY     EQU     3                       ; DIFFICULTY LEVEL: EASY
INTONRM     EQU     5                       ; DIFFICULTY LEVEL: NORMAL
INTOHRD     EQU     7                       ; DIFFICULTY LEVEL: HARD
INTDSTC     EQU     $00FFFFFF               ; DIFFICULTY STRING COLOR
INTDSTF     EQU     $01130000               ; DIFFICULTY STRING FONT
INTDSTX     EQU     9                       ; DIFFICULTY STRING X COORD.
INTDSTY     EQU     12                      ; DIFFICULTY STRING Y COORD.

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

; --- PIPE RELATED CONSTANTS --------------------------------------------------

PIPPC       EQU     $00000000               ; PIPE PEN COLOUR
PIPFC       EQU     $00196600               ; PIPE FILL COLOUR
PIPBWDT     EQU     50                      ; PIPE BASE WIDTH
PIPTWDT     EQU     60                      ; PIPE MOUTH WIDTH
PIPTHGT     EQU     10                      ; PIPE MOUTH HEIGHT
PIPTBSPC    EQU     ((PIPTWDT-PIPBWDT)/2)   ; DIF.BETW. OUTER RAD. & IN. RAD
PIPOPEN     EQU     90                      ; SPACE BETW. TOP AND BOTTOM PIPES

; --- CLOUD RELATED CONSTANTS -------------------------------------------------

CLDSIZE     EQU     60                      ; CLOUD DIAMETER
CLDPCLR     EQU     $00FFFFFF               ; CLOUD PEN COLOR
CLDFCLR     EQU     $00FFFFFF               ; CLOUD FIL COLOR

; --- PAUSE STATE RELATED CONSTANTS ---------------------------------------

CONTNUM     EQU     0                       ; CONTINUE GAME NUMBER
NEWGNUM     EQU     1                       ; NEW GAME NUMBER
TGLSNUM     EQU     2                       ; TOGGLE SOUND NUMBER
EXTNUM      EQU     3                       ; EXIT GAME NUMBER
PAUTITC     EQU     $0000FFFF               ; TITLE COLOUR
PAUTITF     EQU     $013D0001               ; TITLE FONT
PAUTITX     EQU     2                       ; TITLE COORD. X
PAUTITY     EQU     1                       ; TITLE COORD. Y
PAUOPTFU    EQU     $01130001               ; OPTION FONT (unselected)
PAUOPTFS    EQU     $01130001               ; OPTION FONT (selected)
PAUOPTC     EQU     $00FFFFFF               ; OPTION COLOUR (unselected)
PAUOPTC2    EQU     $0000FFFF               ; OPTION COLOUR (selected)
PAUOPTX     EQU     12                      ; OPTIONS COORD. X
PAUCNTY     EQU     9                       ; CONTINUE OPTION COORD. Y
PAUNEWY     EQU     10                       ; NEW GAME OPTION COORD. Y
PAUSDY      EQU     11                      ; TOGGLE SOUND OPTION COORD. Y
PAUEXTY     EQU     12                      ; EXIT OPTION COORD. Y
PAUHLPF     EQU     $01090000               ; HELP TEXT FONT
PAUHLPX     EQU     8                       ; HELP TEXT X COORD.
PAUHLPY1    EQU     28                      ; HELP TEXT 1 Y COORD.
PAUHLPY2    EQU     29                      ; HELP TEXT 2 Y COORD.

; --- GAME OVER STATE RELATED CONSTANTS ---------------------------------------

GOVSTRX     EQU     13                      ; TITLE X COORDINATE
GOVSTRY     EQU     6                       ; TITLE Y COORDINATE
GOVSTRC     EQU     $00FFFFFF               ; TITLE COLOR
GOVSTRF     EQU     $01130001               ; TITLE FONT

; --- SOUND RELATED CONSTANTS

BRDLNG1     EQU     0                       ; SOUND NUM.REF. FOR BIRDS SINGING
BRDLNG2     EQU     1                       ; SOUND NUM.REF. FOR BIRDS SINGING2
BRDSHRT     EQU     2                       ; SOUND NUM.REF. FOR BIRD SOUND
FLAPSND     EQU     3                       ; SOUND NUM.REF. FOR BIRD FLAP
GOVRSND     EQU     4                       ; SOUND NUM.REF. FOR GAME OVER
MNOPTSD     EQU     5                       ; SOUND NUM.REF. FOR MOVING IN MENU
PNCHSND     EQU     6                       ; SOUND NUM.REF. FOR PUNCH SOUND
VICTSND     EQU     7                       ; SOUND NUM.REF. FOR NEW HIGH SCORE
BGSND       EQU     8                       ; SOUND NUM.REF. FOR BACKGROUND SND











































*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
