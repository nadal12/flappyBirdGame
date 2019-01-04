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
            MOVEQ       #BRDSHRT,D1         ; CARGAR EL MENOR NUM.REF. DE SND.
            MOVEQ       #BGSND,D2         ; CARGAR EL MAYOR NUM.REF. DE SND.
            
.LOOP       MOVEA.L     (A0)+,A1            ; CARGAR PATH A FICHERO DE SONIDO
            TRAP        #15     
            ADDQ        #1,D1               ; SIGUIENTE NUM.REF.
            DBRA        D2,.LOOP
            
.LPEND      
            ;Restaurar registros
            MOVEM.L     (A7)+,D0/A0-A1
            RTS
            
; RUTAS DE ARCHIVOS -----------------------------------------------------------
.BRDSHRT    DC.B    'MEDIA/bird-sound-short.wav',0
.FLAPSND    DC.B    'MEDIA/flap-sound.wav',0
.GOVRSND    DC.B    'MEDIA/game-over-sound.wav',0
.MNOPTSD    DC.B    'MEDIA/menu-move-sound.wav',0
.PNCHSND    DC.B    'MEDIA/punch-sound.wav',0
.VICTSND    DC.B    'MEDIA/win-sound.wav',0
.BGSND      DC.B    'MEDIA/background-music.wav',0
            DS.W    0
.PATHPTR    DC.L    .BRDSHRT,.FLAPSND,.GOVRSND,.MNOPTSD
            DC.L    .PNCHSND,.VICTSND,.BGSND,0
            
; -----------------------------------------------------------------------------
SNDUPD
; PLAYS SOUNDS DURING GAME PLAY
; INPUT     - NONE
; OUTPUT    - NONE
; MODIFIES  - D0-D1
; -----------------------------------------------------------------------------
        ;Guardar registros
        MOVE.L     D0,-(A7)
        
        TST.B       (BGSNDINIT)            ; CHECK IF SOUND IS ON
        BNE.S       .END
        
        MOVE.B      (SCRCYCCT),D0
        AND.B       #$3F,D0            ; AFTER 64 CYCLES PLAY BG MUSIC
        BNE.S      .END
        
        MOVE.B      #SOUNDOFF,(BGSNDINIT)   ; MARK BG MUSIC AS ALREADY ON PLAY
        JSR         UTLPLBG

.END    ;Restaurar registros
        MOVE.L     (A7)+,D0
        RTS
            




























*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
