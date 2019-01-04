; =============================================================================
; TITLE    : YET ANOTHER FLAPPY BIRD (YAF)
; AUTHORS  : DOÑAQUE, EUGENIO && LLABRÉS, NADAL.
; CREATION : DEC 2018
; =============================================================================

            ORG     $1000

; --- CODE INCLUDES -----------------------------------------------------------

            INCLUDE "SYSCONST.X68"               ; SYSTEM CONSTANTS
            INCLUDE "SYSTEM.X68"                 ; SYSTEM CODE
            INCLUDE "SYSCONST.X68"               ; SYSTEM CONSTANTS
            INCLUDE "CONST.X68"                  ; USER CONSTANTS
            INCLUDE "UTIL.X68"                   ; UTILITY MACRO AND SUBROUTINES
            INCLUDE "SOUND.X68"                  ; SOUND MANAGEMENT
            INCLUDE "PLAYER.X68"
            INCLUDE "AGENTLST.X68"               ; AGENT LIST MANAGEMENT
            INCLUDE "PROPLST.X68"                ; PROPS LIST MANAGEMENT
            INCLUDE "SPAWNER.X68"                ; SPAWNER
            INCLUDE "STATES.X68"                 ; GAME STATES MANAGEMENT
            INCLUDE "BACKGROUND/BACKGROUND.X68"  ; BACKGROUND MANAGEMENT
            INCLUDE "PIPES.X68"                  ; PIPES MANAGEMENT          
            
; --- INITIALIZE --------------------------------------------------------------

START       JSR     SYSINIT
            JSR     STAINIT

; --- UPDATE ------------------------------------------------------------------

.LOOP       TRAP    #KBDTRAP                ; READ KEYBOARD
            JSR     STAUPD

; --- WAIT SYNCH --------------------------------------------------------------

.WINT       TST.B   (SCRINTCT)              ; WAIT FOR INTERRUPT
            BEQ     .WINT
            CLR.B   (SCRINTCT)

; --- PLOT --------------------------------------------------------------------

            JSR     STAPLOT
            TRAP    #SCRTRAP                ; SHOW GRAPHICS
            BRA     .LOOP
            SIMHALT

; --- VARIABLES ---------------------------------------------------------------

            INCLUDE "SYSVAR.X68"
            INCLUDE "VAR.X68"
            END    START





















*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
