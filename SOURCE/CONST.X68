; =============================================================================
; SYSTEM CONSTANTS
; =============================================================================

; --- GAME STATES -------------------------------------------------------------

STANONE     EQU     -1                      ; PLACEHOLDER TO FORCE CHANGE
STAINTR     EQU     0                       ; INTRO/PRESS FIRE STATE
STAINST     EQU     1                       ; INSTRUCTIONS STATE
STAPLAY     EQU     2                       ; NORMAL GAME STATE
STAPAU      EQU     3                       ; PAUSE GAME STATE
STAGOVR     EQU     4                       ; GAME OVER STATE

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
      ;Player colours

GREEN EQU $00008000                         ; GREEN COLOR
RED   EQU $000000FF                         ; RED COLOR
WHITE EQU $00FFFFFF                         ; WHITE COLOR
BLACK EQU $00000000                         ; BLACK COLOR

      ;Constants
      
PLRCOLOR        EQU GREEN                   ; PLAYER COLOR
PLREYECOLOR     EQU WHITE                   ; PLAYER EYE COLOR
PLRIRISCOLOR    EQU BLACK                   ; PLAYER IRIS COLOR
PLRMOUTHCOLOR   EQU RED                     ; PLAYER MOUTH COLOR
PLRWIDTH        EQU 25                      ; PLAYER WIDTH
PLRHEIGHT       EQU 25                      ; PLAYER HEIGHT
PLRINITPOSX     EQU 150                     ; INITIAL POSITION OF THE PLAYER (X)
PLRINITPOSY     EQU 180                     ; INITIAL POSITION OF THE PLAYER (Y)
JUMPSIZE        EQU 60                      ; JUMP SIZE
JUMPSPEED       EQU 3                       ; JUMP SPEED (BIG VALUE = SLOW SPEED).
PLRSCRF         EQU $01120000               ; PLAYER SCORE FONT


; --- INTRO STATE RELATED CONSTANTS -------------------------------------------

INTTITX     EQU     2                       ; TITLE X COORDINATE
INTTITY     EQU     1                       ; TITLE Y COORDINATE
INTTITC     EQU     $0000FFFF               ; TITLE COLOR
INTTITF     EQU     $013D0001               ; TITLE FONT
INTOESY     EQU     3                       ; DIFFICULTY LEVEL: EASY
INTONRM     EQU     5                       ; DIFFICULTY LEVEL: NORMAL
INTOHRD     EQU     7                       ; DIFFICULTY LEVEL: HARD
INTDSTC     EQU     $00FFFFFF               ; DIFFICULTY STRING COLOR
INTDSTF     EQU     $01130000               ; DIFFICULTY STRING FONT
INTDSTX     EQU     9                       ; DIFFICULTY STRING X COORD.
INTDSTY     EQU     12                      ; DIFFICULTY STRING Y COORD.
IPLNUM      EQU     0                       ; START GAME MENU NUMBER
IDIFNUM     EQU     1                       ; DIFFICULTY MENU NUMBER
IINSNUM     EQU     2                       ; INSTRUCTIONS MENU NUMBER
INTOPTF     EQU     $01130001               ; OPTION FONT
INTOPTCU    EQU     $00FFFFFF               ; OPTION COLOUR (unselected)
INTOPTCS    EQU     $0000FFFF               ; OPTION COLOUR (selected)
INTOPTX     EQU     12                      ; OPTIONS COORD. X
INTPLY      EQU     9                       ; START GAME OPTION COORD. Y
INTDIFY     EQU     10                      ; DIFFICULTY OPTION COORD. Y
INTINSY     EQU     11                      ; INSTRUCTIONS OPTION COORD. Y
INTDIFX     EQU     7                       ; INSTRUCTIONS OPTION COORD. X
INTHLPF     EQU     $01090000               ; HELP TEXT FONT
INTHLPX     EQU     8                       ; HELP TEXT X COORD.
INTHLPY1    EQU     29                      ; HELP TEXT 1 Y COORD.
INTHLPY2    EQU     30                      ; HELP TEXT 2 Y COORD.

; --- INTRUCTIONS STATE RELATED CONSTANTS -------------------------------------

INSTITX     EQU     2                       ; TITLE X COORDINATE
INSTITY     EQU     1                       ; TITLE Y COORDINATE
INSTITC     EQU     $0000FFFF               ; TITLE COLOR
INSTITF     EQU     $013D0001               ; TITLE FONT   
INSINSF     EQU     $010F0000               ; INSTRUCTION FONT
INSINSC     EQU     $00FFFFFF               ; INSTRUCTION COLOUR
INSINSX     EQU     8                       ; INSTRUCTIONS X COORD.
INSIN1Y     EQU     18                      ; INST1 Y COORD.
INSIN2Y     EQU     19                      ; INST2 Y COORD.
INSIN3Y     EQU     20                      ; INST3 Y COORD.
INSIN4Y     EQU     22                      ; INST4 Y COORD.
INSIN5Y     EQU     23                      ; INST5 Y COORD.
INSHLPY     EQU     32                       ; HELP TEXT Y COORD.
INSHLPX     EQU     8                      ; HELP TEXT X COORD.
INSHLPC     EQU     $00FFFFFF               ; HELP TEXT COLOR
INSHLPF     EQU     $01090000               ; HELP TEXT FONT    

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
PIPOPEN     EQU     100                      ; SPACE BETW. TOP AND BOTTOM PIPES

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
PAUNEWY     EQU     10                      ; NEW GAME OPTION COORD. Y
PAUSDY      EQU     11                      ; TOGGLE SOUND OPTION COORD. Y
PAUEXTY     EQU     12                      ; EXIT OPTION COORD. Y
PAUHLPF     EQU     $01090000               ; HELP TEXT FONT
PAUHLPX     EQU     8                       ; HELP TEXT X COORD.
PAUHLPY1    EQU     29                      ; HELP TEXT 1 Y COORD.
PAUHLPY2    EQU     30                      ; HELP TEXT 2 Y COORD.

; --- GAME OVER STATE RELATED CONSTANTS ---------------------------------------

GOVSTRX     EQU     13                      ; TITLE X COORDINATE
GOVSTRY     EQU     6                       ; TITLE Y COORDINATE
FINALSCOREX EQU     10                      ; FINAL SCORE X COORDINATE
FINALSCOREY EQU     8                       ; FINAL SCORE Y COORDINATE
SPACEGOVX   EQU     25                      ; PRESS SPACE X COORDINATE
SPACEGOVY   EQU     25                     ; PRESS SPACE Y COORDINATE
GOVSTRC     EQU     $00FFFFFF               ; TITLE COLOR
GOVSTRF     EQU     $01130001               ; TITLE FONT
SPACEGOVTF  EQU     $01090000               ; PRESS SPACE TEXT FONT

; --- SOUND RELATED CONSTANTS -------------------------------------------------

FLAPSND     EQU     0                       ; SOUND NUM.REF. FOR BIRD FLAP
GOVRSND     EQU     1                       ; SOUND NUM.REF. FOR GAME OVER
MNOPTSD     EQU     2                       ; SOUND NUM.REF. FOR MOVING IN MENU
PNCHSND     EQU     3                       ; SOUND NUM.REF. FOR PUNCH SOUND
VICTSND     EQU     4                       ; SOUND NUM.REF. FOR NEW HIGH SCORE
BGSND       EQU     5                       ; SOUND NUM.REF. FOR BACKGROUND SND

; --- ONE UTILITY CONSTANT ----------------------------------------------------

PSHFNT      EQU     $011A0001               ; FONT THAT PUSHES TITLES & ETC UP

; --- OTHER CONSTANTS ---------------------------------------------------------
CR          EQU $0D                         ;CARRIAGE RETURN
LF          EQU $0A                         ;LINE FEED



















































*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
