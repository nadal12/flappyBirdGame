; =============================================================================
; PLAYER MANAGEMENT
; =============================================================================

; -----------------------------------------------------------------------------
PLRINIT
; INITIALIZES THE PLAYER
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------

        MOVE.W #PLRINITPOSX,(PLRPOSX)
        MOVE.W #PLRINITPOSY,(PLRPOSY)
        MOVE.W #PLRINITPOSY,(MAXPOS)
        MOVE.W #0, (UPPRESSED)
        MOVE.W #1, (PLRDOWNSPEED)
        MOVE.L #0, (PLRSCORE)              ;Inicializar score
        MOVE.L #0, (PLRDEAD)               ;Poner a 0 PLRDEAD (Jugador vivo).

        RTS
; -----------------------------------------------------------------------------
PLRUPD
; UPDATES THE PLAYER MOTION
; INPUT    - NONE (ACCESSES KBDEDGE)
; OUTPUT   - NONE (MODIFIES PLAYER DATA)
; MODIFIES - NONE
; -----------------------------------------------------------------------------
          MOVEM.L D0/D1/D2/D3,-(A7)
          BTST.B #KBDBITUP, (KBDEDGE)    
          BNE.L  .PRESSED
        
         ;Comprobar colisi�n con tuber�a. 
          CMP #1, (PLRDEAD)
          BEQ .GAMEOVER 
        
          ;TECLA NO PRESIONADA
          CMP #1, (UPPRESSED)
          BEQ .MAKEJUMP
          ;No se ha apretado la tecla UP. Hay que bajar el p�jaro. 
          MOVE.W (PLRPOSY), D0
          ADD.W (PLRDOWNSPEED), D0
          ;Se incrementa la velocidad de bajada. 
          ADDQ #1, (PLRDOWNSPEED)
          MOVE.W D0, (PLRPOSY)
         
          ;Comprobar si ha salido por la parte inferior
          MOVE.W #BGGSSTP, D1
          ADD.W #PLRHEIGHT, D0
          CMP D0, D1
          BMI .GAMEOVER         
       
          BRA .END         
.PRESSED
          ;TECLA UP PRESIONADA
          ;Se reinicia la velocidad de bajada. 
          MOVE.W #1, (PLRDOWNSPEED)

          ;Se establece el l�mite hasta donde subir�
          MOVE.W (PLRPOSY), D0
          SUB.W #JUMPSIZE, D0
          MOVE.W D0, (MAXPOS)
          ;Se indica que se ha presionado la tecla de salto
          MOVE.W #1, (UPPRESSED)
          
          BRA .END   
      
.MAKEJUMP
          ;Se ha apretado la tecla UP anteriormente (eso indica que el salto no
          ; ha finalizado). 
          
          MOVE.W (PLRPOSY), D0
          MOVE.W (MAXPOS), D1
          SUB.W  D1, D0             ;F�RMULA: (PLRPOSY-MAXPOS)/JUMPSPEED = VALOR QUE SE TIENE QUE RESTAR A LA POSICI�N ACTUAL PARA OBTENER LA NUEVA POSICI�N
          DIVU.W #JUMPSPEED, D0
          SUB.W D0, (PLRPOSY)       ;NEWPOS

          ;Ver si ha salido por la parte superior. 
          CMP #0, (PLRPOSY)
          BMI .GAMEOVER
          CMP #1, D0
          BMI .LASTJUMP
          BEQ .LASTJUMP
          ;El salto no ha finalizado (No ha llegado a MAXPOS)
                              
          BRA .END
          
.LASTJUMP
          ;El salto ha llegado a MAXPOS
          ;Se desactiva la tecla UP indicando que lo siguiente ser� realizar la bajada. 
          MOVE.W #0, (UPPRESSED)         
          BRA .END    
          
.GAMEOVER

          MOVE.W #STAGOVR, (STANEXT)        
          BRA .END         
                 
.END
          MOVEM.L (A7)+,D0/D1/D2/D3
          RTS
          
; -----------------------------------------------------------------------------
PLRPLOT
; PLOTS THE PLAYER
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------

            MOVEM.L D0-D5,-(A7)
            
            ;-------SCORE----------------      
                                 
            ;Set background color. 
            MOVE.L  #81, D0
            MOVE.L  #BLACK, D1
            TRAP    #15                
            
            ;Set font properties.
            
            MOVE.L  #21, D0
            MOVE.L  #WHITE, D1
            CLR.L   D2
            TRAP    #15 
            
            ;Print score
            MOVE #17, D0
            LEA PLRSCORETEXT,A1
            MOVE.L #0, D1
            MOVE.L (PLRSCORE), D1
            TRAP #15
                    
            ;-------PLAYER (BODY)--------

            ;SET PLAYER COLOR 
            MOVE.L  #PLRCOLOR,D1
            MOVE.B  #80,D0
            TRAP    #15
            ADDQ.B  #1,D0
            TRAP    #15
            
            ;SET PLAYER POSITION
            MOVE.W  (PLRPOSX),D1            
            MOVE.W  (PLRPOSY),D2
            MOVE.W  D1,D3
            MOVE.W  D2,D4
            
            ;SET PLAYER WIDTH AND HEIGHT
            ADD.W   #PLRWIDTH,D3
            ADD.W   #PLRHEIGHT,D4
            MOVE.B  #88,D0
            TRAP    #15
            
            SUB.W   #PLRWIDTH/2,D3
            MOVE.B  #87,D0
            TRAP    #15
            
            ;---------EYE (IRIS)---------
                             
            ;SET EYE COLOR
            MOVE.L  #81, D0
            MOVE.L  #PLRIRISCOLOR, D1
            TRAP    #15
            
            MOVE.W  PLRPOSX,D1   
            
            ;X0        
            ADD.W   #PLRWIDTH/3,D1
            MOVE.W  (PLRPOSX),D3
            
            ;X2
            ADD.W   #PLRWIDTH/2,D3
            MOVE.W (PLRPOSY),D2
            
            ;X1
            ADD.W   #PLRHEIGHT/4,D2
            MOVE.W  (PLRPOSY),D4
            
            
            ;X3
            ADD.W   #PLRHEIGHT/20,D4
            MOVE.B  #88,D0
            TRAP    #15
            
           ;---------MOUTH------
                               
            ;SET MOUTH COLOR
            MOVE.L  #81, D0
            MOVE.L  #RED, D1
            TRAP    #15           
               
            MOVE.W  (PLRPOSX),D1   
            
            ;X0        
            ADD.W   #PLRWIDTH-5,D1
            MOVE.W  (PLRPOSX),D3
           
            
            ;X2
            ADD.W   #PLRWIDTH/2,D3
            MOVE.W  (PLRPOSY),D2
            
  
            ;X1
            ADD.W   #PLRHEIGHT/2,D2
            MOVE.W  (PLRPOSY),D4   
            
            ;X3 
            ADD.W   #PLRHEIGHT,D4
           
            MOVE.B  #88,D0
            TRAP    #15
            
            MOVEM.L (A7)+,D0-D5
            
            RTS





*~Font name~Courier New~
*~Font size~11~
*~Tab type~1~
*~Tab size~4~