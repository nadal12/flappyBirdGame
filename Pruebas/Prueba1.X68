*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $1000
    
WID         EQU     640
HEI         EQU     480

START:                  ; first instruction of program


     MOVE.L  #33,D0
     MOVE.L  #SCRWIDTH*$10000+#SCRHEIGH,D1
     TRAP    #15

* Put program code here

     MOVE.W #$0100, SR
            
     MOVEQ  #62,D0
     MOVE.L #$0103,D1


     TRAP   #15       
     
.LP  MOVE.B #19,D0     

     MOVE.L #'A'<<24+'S'<<16+'D'<<8+'F',D1 ; check for keypress (a,s,d,f)

     TRAP   #15
     
     MOVE.L D1, VAR
     BRA    .LP


    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
