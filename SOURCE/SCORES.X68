*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $1000
        
START:                  ; first instruction of program

        MOVE.B      #DIFNRM,(DIFF)
        MOVE.B      #10,(PLRSCORE)
        
        JSR         UTLHSCR
        TST.W       D0
        BEQ         .scss
        
        MOVEQ       #2,D6
        BRA         END
        
.scss   MOVEQ       #1,D6
END:

        SIMHALT             ; halt simulator

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
        
        ;IF FILE IS NOT EMPTY, READ THE LAST SCORE
        CMP.B   #DIFHRD,(DIFF)
        BEQ     .HRD
        CMP.B   #DIFNRM,(DIFF)
        BEQ     .NRM

        ;IF IT'S NOT NORMAL OR HARD, IT MUST BE EASY  
.READ        
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
        CMP.B   (PLRSCORE),D2
        BLE     .NORCRD
        
.WRT    
        ;IF FILE IS NOT EMPTY, WRITE THE LAST SCORE
        CMP.B   #DIFHRD,(DIFF)
        BEQ     .HRD
        CMP.B   #DIFNRM,(DIFF)
        BEQ     .NRM

        ;WRITE ON NEW RECORD
        MOVEQ.L #.SIZEOFINT,D2
        MOVEQ   #54,D0                  ; ESCRIBIR NUEVO RECORD EN FICHERO
        TRAP    #15

        CLR.W   D0
        BRA     .END
        
.NORCRD MOVE.W  #1,D0                   ; SI NO SE HA ROTO UN RECORD, AVISAR   

.END    ;CLOSE ALL FILES
        MOVEQ   #50,D0
        TRAP    #15     
    
        ;Restaurar registros
        MOVEM.L  (A7)+,A1/D1-D2
        RTS  

.NWFILE 
        ;TRY TO OPEN NEW FILE
        MOVEQ   #52,D0
        TRAP    #15
        
        ;CHECK FOR ERRORS
        CMP     #.ERR,D0
        BNE     .WRT       ;

        CLR.W   D0
        BRA     .END
        
; RESULTS FOR NORMAL OR HARD START AT BYTE 4 AND 8 RESPECTIVELY
.NRM    MOVEQ   #4,D2
        BRA     .TRAP

.HRD    MOVEQ   #8,D2
.TRAP   MOVEQ   #55,D0
        TRAP    #15
        
        BRA     .READ
       
   


.EOFE       EQU     1
.ERR        EQU     2
.SIZEOFINT  EQU     4
.TPPATH     DC.B    'ARCHIVOS/TOP3.TXT',0
            DS.W    0
PLRSCORE    DC.B    0
DIFF        DS.B    1
RSULT       DS.B    4           ; BUFFER FOR DATA READ FROM FILE
            DS.W    0
DIFHRD      EQU     7
DIFNRM      EQU     5
DIFESY      EQU     3
        END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
