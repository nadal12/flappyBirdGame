*------------------------------------------------------------------------------
* SOUND MANAGEMENT
*------------------------------------------------------------------------------

; -----------------------------------------------------------------------------
SNDINIT
; LOADS ALL SOUND FILES ON MEMORY
; INPUT     - NONE
; OUTPUT    - NONE
; MODIFIES  - NONE
; -----------------------------------------------------------------------------
            ;Guardar registros
            MOVEM.L     D0/A0-A1,-(A7)
            
            LEA         .PATHPTR,A0         ; LOAD POINTER TO POINTERS OF PATHS
            MOVEQ       #71,D0              ; LOAD TASK NUMBER
            MOVEQ       #BRDLNG1,D1         ; CARGAR EL MENOR NUM.REF. DE SND.
            MOVEQ       #VICTSND,D2         ; CARGAR EL MAYOR NUM.REF. DE SND.
            
.LOOP       MOVEA.L     (A0)+,A1            ; CARGAR PATH A FICHERO DE SONIDO
            TRAP        #15     
            ADDQ        #1,D1               ; SIGUIENTE NUM.REF.
            DBRA        D2,.LOOP
            
.LPEND      
            ;Restaurar registros
            MOVEM.L     (A7)+,D0/A0-A1
            RTS
            
; RUTAS DE ARCHIVOS -----------------------------------------------------------
.BRDLNG1    DC.B    'MEDIA/bird-sound-long1.wav',0
.BRDLNG2    DC.B    'MEDIA/bird-sound-long2.wav',0
.BRDSHRT    DC.B    'MEDIA/bird-sound-short.wav',0
.FLAPSND    DC.B    'MEDIA/flap-sound.wav',0
.GOVRSND    DC.B    'MEDIA/game-over-sound.wav',0
.MNOPTSD    DC.B    'MEDIA/menu-move-sound.wav',0
.PNCHSND    DC.B    'MEDIA/punch-sound.wav',0
.VICTSND    DC.B    'MEDIA/win-sound.wav',0
            DS.W    0
.PATHPTR    DC.L    .BRDLNG1,.BRDLNG2,.BRDSHRT,.FLAPSND,.GOVRSND,.MNOPTSD
            DC.L    .PNCHSND,.VICTSND,0
            
; -----------------------------------------------------------------------------
SNDUPD
; PLAYS SOUNDS DURING GAME PLAY
; INPUT     - NONE
; OUTPUT    - NONE
; MODIFIES  - D0-D1
; -----------------------------------------------------------------------------
        ;Guardar registros
        MOVEM.L     D0-D1,-(A7)
        
        TST.B       (SNDSTA)            ; CHECK IF SOUND IS ON
        BNE.S       .END
        
        MOVE.W      (SCRCYCCT),D0
        AND.W       #$FFFF,D0          ; EVERY 512 CYCLES BRANCH
        BNE.S       .END
        
        BTST        #0,(UTLRNDIX)      ; PLAY SOUND EVERY SECOND SET OF 512 CYC
        BNE.S       .END
        
        JSR         UTLRAND
        BTST        #0,D0
        BEQ.S       .BSND2
        
        TST.B       (SNDSTA)            ; CHECK IF SOUND IS ON
        BNE.S       .END
        
        UTLPLAY     BRDLNG1
        BRA         .END
.BSND2
        UTLPLAY     BRDLNG2

.END    ;Restaurar registros
        MOVEM.L     (A7)+,D0-D1
        RTS
            















*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
