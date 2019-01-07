; =============================================================================
; UTILITY MACROS
; =============================================================================

; -----------------------------------------------------------------------------
UTLSPEN     MACRO
; WRAPPER FOR SET PEN TRAP 15 TASK.
; INPUT    - \1 COLOR IN FORMAT $00BBGGRR
; OUTPUT   - NONE
; MODIFIES - D0,D1
; -----------------------------------------------------------------------------
            MOVE.B  #80,D0
            MOVE.L  \1,D1
            TRAP    #15
            ENDM

; -----------------------------------------------------------------------------
UTLSFIL     MACRO
; WRAPPER FOR SET FIL TRAP 15 TASK.
; INPUT    - \1 COLOR IN FORMAT $00BBGGRR
; OUTPUT   - NONE
; MODIFIES - D0,D1
; -----------------------------------------------------------------------------
            MOVE.B  #81,D0
            MOVE.L  \1,D1
            TRAP    #15
            ENDM

; -----------------------------------------------------------------------------
UTLLOCT     MACRO
; WRAPPER TO TEXT POSITIONNING FROM TRAP 15
; INPUT    - \1 X, \2 Y
; OUTPUT   - NONE
; MODIFIES - D0,D1
; -----------------------------------------------------------------------------
            MOVE.W  #\1<<8|\2, D1
            MOVE.B  #11,D0
            TRAP    #15
            ENDM

; -----------------------------------------------------------------------------
UTLFONT     MACRO
; WRAPPER TO FONT FORMATTING FROM TRAP 15
; INPUT    - \1 COLOR, \2 FONT
; OUTPUT   - NONE
; MODIFIES - D0,D1,D2
; -----------------------------------------------------------------------------
            MOVE.L  #\1,D1
            MOVE.L  #\2,D2
            MOVEQ   #21,D0
            TRAP    #15
            ENDM

; =============================================================================
; UTILITY SUBROUTINES
; =============================================================================

; -----------------------------------------------------------------------------
UTLINIT
; INITIALIZES UTILITY CODE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            CLR.B   (UTLRNDIX)
            RTS
; -----------------------------------------------------------------------------
UTLCHCOL
; CHECKS COLLISION
; INPUT    - D0.W X0 COORDINATE
;            D1.W Y0 COORDINATE
;            D2.W X1 COORDINATE
;            D3.W Y1 COORDINATE
;            D4.W WIDTH 0
;            D5.W WIDTH 1
;            D6.W HEIGHT 0
;            D7.W HEIGHT 1
; OUTPUT   - D0.B=0 - NO COLLISION 
;                =1 - NO COLLISION IGNORE PIPE
;                =2 - COLLISION TOP PIPE
;                =3 - COLLISION BOTTOM PIPE
;                =4 - COLLISION EDGE PIPE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.W D2/D4/D6/D7,-(A7)

            ;Verificar si la tubería esta delante o detrás del pájaro. 
            ADD.W   D0, D4 ;Pared derecha de la tubería.
            CMP     D2, D4
            BCS     .NOCOLIGNPIPE
            
            ;Comprobar si el pájaro ha alcanzado la tubería.
            ADD.W   D5, D2 ;Parte delantera del pájaro.
            CMP     D0, D2
            BCS     .NOCOL
            
            ;Comprobar parte superior del pájaro con la parte inferior de la 
            ;tubería superior.
            CMP     D1,D3
            BLE     .COLSUPPIPE 
            
            ADD.W   D1, D6 ;Parte superior de la tubería inferior.
            ADD.W   D3, D7 ;Parte inferior del pájaro. 
            CMP     D6, D7
            BCS     .NOCOL
          
            ;Ha dado en un lado o en la tubería inferior.
            ADD.W   #5,D0
            CMP     D0,D2
            BGT     .COLINFPIPE
            BRA     .COLEDGEPIPE
            
            ;No hay colisión.
.NOCOL                    
            MOVE.W  #0, D0
            BRA     .END
            
            ;Colisión dentro de la tubería (parte superior).
.COLSUPPIPE 
            SUB.W   #28,D1
            CMP     D1,D3
            BCS     .COLEDGEPIPE

            MOVE.W  #2,D0
            BRA     .END
            
            ;Colisión dentro de la tubería (parte inferior).
.COLINFPIPE
            MOVE.W  #3,D0
            BRA     .END
            
            ;Colisión en un lado de la tubería.           
.COLEDGEPIPE
            MOVE.W  #4,D0
            BRA .END
                
            ;Ingorar tubería.             
.NOCOLIGNPIPE
            MOVE.W  #1, D0
            
.END          
            MOVEM.W (A7)+,D2/D4/D6/D7
            RTS
; -----------------------------------------------------------------------------
UTLRAND
; PROVIDES A PSEUDO-RANDOM BYTE
; INPUT    - NONE
; OUTPUT   - D0.L RANDOM VALUE (ONLY BYTE)
; MODIFIES - NONE (ASIDE OF OUTPUT)
; -----------------------------------------------------------------------------
            MOVE.L  A0,-(A7)
            LEA     .RANDVEC,A0
            CLR.L   D0
            MOVE.B  (UTLRNDIX),D0
            MOVE.B  (A0,D0.L),D0
            ADDQ.B  #1,(UTLRNDIX)
            MOVE.L  (A7)+,A0
            RTS


.RANDVEC    DC.B    162, 238, 154, 12 , 245, 36 , 32 , 103
            DC.B    42 , 163, 81 , 38 , 224, 172, 19 , 69
            DC.B    117, 81 , 202, 253, 51 , 235, 108, 154
            DC.B    96 , 204, 231, 184, 154, 235, 34 , 203
            DC.B    29 , 118, 181, 149, 176, 137, 62 , 108
            DC.B    57 , 21 , 72 , 201, 110, 202, 159, 41
            DC.B    67 , 231, 226, 124, 55 , 37 , 84 , 62
            DC.B    233, 148, 206, 233, 228, 82 , 243, 78
            DC.B    55 , 109, 154, 132, 162, 40 , 30 , 39
            DC.B    25 , 226, 198, 119, 128, 212, 232, 225
            DC.B    10 , 90 , 50 , 103, 51 , 194, 222, 40
            DC.B    89 , 128, 220, 14 , 87 , 252, 243, 252
            DC.B    138, 171, 188, 247, 7  , 77 , 29 , 234
            DC.B    239, 213, 119, 110, 30 , 187, 131, 23
            DC.B    214, 224, 42 , 143, 189, 40 , 212, 130
            DC.B    19 , 79 , 102, 236, 10 , 100, 122, 188
            DC.B    86 , 82 , 154, 22 , 155, 144, 7  , 199
            DC.B    6  , 138, 164, 247, 1  , 218, 166, 82
            DC.B    242, 231, 119, 40 , 177, 118, 220, 102
            DC.B    164, 66 , 227, 129, 177, 103, 165, 108
            DC.B    191, 206, 250, 22 , 191, 56 , 30 , 161
            DC.B    209, 139, 80 , 12 , 95 , 73 , 168, 56
            DC.B    222, 76 , 20 , 162, 64 , 220, 93 , 12
            DC.B    182, 155, 10 , 56 , 93 , 171, 89 , 6
            DC.B    226, 27 , 221, 117, 21 , 130, 101, 18
            DC.B    138, 38 , 81 , 48 , 159, 71 , 57 , 21
            DC.B    30 , 138, 187, 113, 198, 110, 185, 152
            DC.B    159, 71 , 229, 52 , 148, 39 , 77 , 6
            DC.B    125, 6  , 214, 186, 48 , 15 , 212, 22
            DC.B    236, 127, 126, 3  , 207, 45 , 193, 2
            DC.B    148, 91 , 35 , 242, 139, 205, 248, 237
            DC.B    116, 51 , 236, 185, 15 , 213, 221, 6

; -----------------------------------------------------------------------------
UTLPLAY
; WRAPPER TO AUDIO FILE REPRODUCTION THROUGH STANDARD PLAYER
; ONLY PLAYS SOUND IF SNDSTA == $00
; INPUT    - D1.B - NUM.REF. OF SOUND TO PLAY
; OUTPUT   - NONE
; MODIFIES - D0
; -----------------------------------------------------------------------------
            TST.B   (SNDSTA)        ; TEST IF SOUND SHOULD BE PLAYED
            BNE.S   .END
            
            ;Guardar registros
            MOVE.L D0,-(A7)
            
            MOVEQ   #72,D0          ; LOAD TASK NUMBER
            TRAP    #15
            
            ;Restaurar registros
            MOVE.L (A7)+,D0
.END        RTS

; -----------------------------------------------------------------------------
UTLPLBG
; SUBROUTINE TO BACKGROUND AUDIO FILE REPRODUCTION THROUGH STANDARD PLAYER-LOOP
; ONLY PLAYS SOUND IF SNDSTA == $00
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - D0/D2
; -----------------------------------------------------------------------------
            TST.B   (SNDSTA)        ; TEST IF SOUND SHOULD BE PLAYED
            BNE.S   .END
            
            ;Parar todos los sonidos. 
            MOVE.B  #76,D0
            MOVE.L  #3,D2
            TRAP    #15 
            
            ;Guardar registros
            MOVEM.L D0-D2,-(A7)

            MOVEQ   #76,D0          ; LOAD TASK NUMBER
            MOVE.B  #BGSND,D1       ; LOAD SOUND NUM.REF.
            MOVE.L  #1,D2           ; LOAD PLAYER OPTION
            TRAP    #15
            

            ;MOVE.L  D0,D7
            
            ;Restaurar registros
            MOVEM.L (A7)+,D0-D2
.END        RTS

; -----------------------------------------------------------------------------
UTLSTBG
; SUBROUTINE TO AUDIO FILE REPRODUCTION THROUGH STANDARD PLAYER
; ONLY EXECUTES IF SNDSTA == $00
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - D0-D2
; -----------------------------------------------------------------------------
            TST.B   (SNDSTA)        ; TEST IF SOUND SHOULD BE PLAYED
            BNE.S   .END
            
            ;Guardar registros
            MOVEM.L D0-D2,-(A7)

            MOVEQ   #76,D0          ; LOAD TASK NUMBER
            MOVE.B  #BGSND,D1       ; LOAD SOUND NUM.REF.
            MOVE.L  #2,D2           ; LOAD PLAYER OPTION
            TRAP    #15
            
            ;Restaurar registros
            MOVEM.L (A7)+,D0-D2
.END        RTS

; -----------------------------------------------------------------------------
UTLHSCR
; SUBROUTINE LOOKS FOR THE HIGHEST SCORE FOR A GIVEN DIFFICULTY STORED IN 
; MEMORY AND UPDATES IF RECORD IS BROKEN
; INPUT     - NONE
; OUTPUT    - D0.W: 0 IF SCORED A NEW RECORD. 1 OTHERWISE.
; MODIFIES  - 4 BYTES ON MEMORY CONTAINING THE RESULT OF TRAP 15 TASK 53.
; -----------------------------------------------------------------------------
        ;Guardar registros
        MOVEM.L  D1-D2/A1,-(A7)
        
        ;CLOSE ALL FILES
        MOVEQ   #50,D0
        TRAP    #15
        
; --- OPENING FILE ------------------------------
        ;TRY TO OPEN EXISTING FILE
        LEA     .TPPATH,A1
        MOVEQ   #51,D0
        TRAP    #15
        
        ;CHECK RESULT OF TRAP TASK 51
        CMP     #.ERR,D0
        BEQ     .NWFILE
        
        ;CHECK IF EOF ENCOUNTERED
        CMP     #.EOFE,D0
        BEQ     .WRT
        
; --- POSITIONING WITHIN FILE -------------------
        ;IF FILE IS NOT EMPTY, READ THE LAST SCORE
        ; RESULTS FOR NORMAL OR HARD START AT BYTE 4 AND 8 RESPECTIVELY
        CMP.B   #INTOHRD,(XSPEED)
        BNE     .RNRM
        
        MOVEQ   #8,D2           ; POSICIONARSE EN EL BYTE 8
        BRA     .RTRP
        
.RNRM   CMP.B   #INTONRM,(XSPEED)
        BNE     .RESY
        
        MOVEQ   #4,D2           ; POSICIONARSE EN EL BYTE 4
.RTRP   MOVEQ   #55,D0
        TRAP    #15        
      
        ;IF IT'S NOT NORMAL OR HARD, IT MUST BE EASY  
.RESY        
; --- READING FROM FILE -------------------------
        ;READ THE LAST SCORE
        MOVEQ.L #.SIZEOFINT,D2
        MOVEQ   #53,D0
        LEA     RSULT,A1
        TRAP    #15
        
        ;CHECK FOR ERROR
        CMP     #.ERR,D0
        BEQ     .WRT
        CMP.L    #.SIZEOFINT,D2         ; VER SI SE LEYÓ LA CANTIDAD DE BYTES
        BNE     .WRT
        
        ;IF NEW RECORD SET, WRITE ON FILE
        MOVE.L  (RSULT),D2
        CMP.L   (PLRSCORE),D2
        BGE     .NORCRD
        
.WRT    
; --- WRITING ON  FILE --------------------------
        ;IF FILE IS NOT EMPTY, WRITE THE LAST SCORE
        ; RESULTS FOR NORMAL OR HARD START AT BYTE 4 AND 8 RESPECTIVELY
        CMP.B   #INTOHRD,(XSPEED)
        BNE     .WNRM
        
        MOVEQ   #8,D2           ; POSICIONARSE EN EL BYTE 8
        BRA     .WTRP
        
.WNRM   CMP.B   #INTONRM,(XSPEED)
        BNE     .WESY
        
        MOVEQ   #4,D2           ; POSICIONARSE EN EL BYTE 4
.WTRP   MOVEQ   #55,D0
        TRAP    #15        
      
        ;IF IT'S NOT NORMAL OR HARD, IT MUST BE EASY  
.WESY   
        ;WRITE ON NEW RECORD        
        ;PREPARAR TRAP 54
        MOVEQ.L #.SIZEOFINT,D2
        MOVEQ   #54,D0                  ; ESCRIBIR NUEVO RECORD EN FICHERO
        LEA     PLRSCORE,A1
        TRAP    #15

        CLR.W   D0
        BRA     .END
        
.NORCRD MOVE.W  #1,D0                   ; SI NO SE HA ROTO UN RECORD, AVISAR   

; --- FINISH WITH FILE --------------------------
.END    MOVE.L  D0,-(A7)                ; GUARDAR RESULTADO A RETORNAR

        ;CLOSE ALL FILES
        MOVEQ   #50,D0
        TRAP    #15     
    
        MOVE.L  (A7)+,D0                ; RESTAURAR RESULTADO A RETORNAR
        
        ;Restaurar registros
        MOVEM.L  (A7)+,A1/D1-D2
        RTS  

.NWFILE 
        ;TRY TO OPEN NEW FILE
        MOVEQ   #52,D0
        TRAP    #15
        
        ;CHECK FOR ERRORS
        CMP     #.ERR,D0
        BEQ     .NWERR  
        
        ;ESCRIBIR 0'S EN FICHERO VACÍO
        MOVEQ   #.SIZEOFINT*3,D2
        MOVEQ   #54,D0
        LEA     .WREMPTY,A1 
        TRAP    #15
        
        BRA     .WRT
        
.NWERR  CLR.W   D0
        BRA     .END
        
; --- VARIABLES Y CONSTANTES DE SUBRUTINA -------------------------------------
.WREMPTY    DC.L    0,0,0                 ; buffer para escribir 0's en archivo
.EOFE       EQU     1                     ; código de error para end of file
.ERR        EQU     2                     ; código de error para errores
.SIZEOFINT  EQU     4                     ; tamaño de un entero (dato a salvar)
.TPPATH     DC.B    'ARCHIVOS/TOP3.txt',0 ; path a fichero donde salvar score
            DS.W    0
RSULT       DS.B    4                     ; BUFFER FOR DATA READ FROM FILE
            DS.W    0

















*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
