; =============================================================================
; SYSTEM CONSTANTS
; =============================================================================

; --- GAME STATES -------------------------------------------------------------

STANONE     EQU     -1                      ; PLACEHOLDER TO FORCE CHANGE
STAINTR     EQU     0                       ; INTRO/PRESS FIRE STATE
STAPLAY     EQU     1                       ; NORMAL GAME STATE
STAGOVR     EQU     2                       ; GAME OVER STATE

; --- AGENT TYPES -------------------------------------------------------------

CLDTYPE     EQU     1
GSSDTYPE    EQU     2
PIPTYPE     EQU     3

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

INTTITX     EQU     1                       ; TITLE X COORDINATE
INTTITY     EQU     1                       ; TITLE Y COORDINATE
INTTITC     EQU     $0000FFFF               ; TITLE COLOR
INTTITF     EQU     $033D0001               ; TITLE FONT
INTPRSX     EQU     5                       ; PRESS FIRE X COORDINATE
INTPRSY     EQU     8                       ; PRESS FIRE Y COORDINATE
INTPRSC     EQU     $00000080               ; PRESS FIRE COLOR
INTPRSF     EQU     $031A0001               ; PRESS FIRE FONT

; --- BACKGROUND RELATED CONSTANTS --------------------------------------------

BGSKYPC     EQU     $00000000
BGSKYFC     EQU     $00EFCE87
BGGSSPC     EQU     $00000000
BGGSSFC     EQU     $0000990A
BGGSSTP     EQU     SCRHEIGH*3/4
BGGSSBT     EQU     BGGSSTP+40
BGGNDPC     EQU     $00000000
BGGNDFC     EQU     $00155DD8
BGGNDTP     EQU     BGGSSBT
GSSDWDTH    EQU     10
GSSDFC      EQU     $0039DB44

; --- PIPE RELATED CONSTANTS --------------------------------------------------

PIPPC       EQU     $00000000
PIPFC       EQU     $00196600
PIPBWDT     EQU     50
PIPTWDT     EQU     60
PIPTHGT     EQU     10
PIPTBSPC    EQU     ((PIPTWDT-PIPBWDT)/2)
PIPOPEN     EQU     80

; --- CLOUD RELATED CONSTANTS -------------------------------------------------

CLDSIZE     EQU     60                      ; CLOUD DIAMETER
CLDPCLR     EQU     $00FFFFFF               ; CLOUD PEN COLOR
CLDFCLR     EQU     $00FFFFFF               ; CLOUD FIL COLOR

; --- GAME OVER STATE RELATED CONSTANTS ---------------------------------------

GOVSTRX     EQU     35                      ; TITLE X COORDINATE
GOVSTRY     EQU     15                      ; TITLE Y COORDINATE
GOVSTRC     EQU     $00FFFFFF               ; TITLE COLOR










*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
