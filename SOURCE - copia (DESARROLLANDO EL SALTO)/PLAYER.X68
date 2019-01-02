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
        RTS
; -----------------------------------------------------------------------------
PLRUPD
; UPDATES THE PLAYER MOTION
; INPUT    - NONE (ACCESSES KBDEDGE)
; OUTPUT   - NONE (MODIFIES PLAYER DATA)
; MODIFIES - NONE
; -----------------------------------------------------------------------------
          MOVEM.L D0/D1,-(A7)
          BTST.B #KBDBITUP, (KBDEDGE)    
          BNE.L  .PRESSED
        
          ;TECLA NO PRESIONADA
          CMP #1, (UPPRESSED)
          BEQ .MAKEJUMP
          ;No se ha apretado la tecla UP. Hay que bajar el pájaro. 
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

          ;Se establece el límite hasta donde subirá
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
          SUB.W  D1, D0             ;FÓRMULA: (PLRPOSY-MAXPOS)/JUMPSPEED = VALOR QUE SE TIENE QUE RESTAR A LA POSICIÓN ACTUAL PARA OBTENER LA NUEVA POSICIÓN
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
          ;Se desactiva la tecla UP indicando que lo siguiente será realizar la bajada. 
          MOVE.W #0, (UPPRESSED)         
          BRA .END    
          
.GAMEOVER

          MOVE.W #STAGOVR, (STANEXT)        
          BRA .END         
                 
.END
          
          MOVEM.L (A7)+,D0/D1
          RTS
          
; -----------------------------------------------------------------------------
PLRPLOT
; PLOTS THE PLAYER
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------

            MOVEM.L D0-D5,-(A7)


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
            
            ;---------EYE---------
                             
            ;SET EYE COLOR
            MOVE.L  #81, D0
            MOVE.L  #PLREYECOLOR, D1
            TRAP    #15
            
            MOVE.W  PLRPOSX,D1   
            
            ;EYE WIDTH         
            ADD.W   #PLRWIDTH-25,D1
            MOVE.W  (PLRPOSX),D3
            
            ;EYE POSX
            ADD.W   #PLRWIDTH-10,D3
            MOVE.W (PLRPOSY),D2
            
            ;EYE POSY
            ADD.W   #PLRHEIGHT/2-5,D2
            MOVE.W  (PLRPOSY),D4
           
            ;EYE HEIGHT 
            ADD.W   #PLRHEIGHT/2-25,D4
            MOVE.B  #88,D0
            TRAP    #15
            
*            ;---------EYE (IRIS)------
*                              
*            ;SET EYE COLOR
*            MOVE.L  #81, D0
*            MOVE.L  PLRIRISCOLOR, D1
*            TRAP    #15            
*          
*            MOVE.W  (PLRPOSX),D1   
*            
*            ;EYE WIDTH         
*            ADD.W   #PLRWIDTH-15,D1
*            MOVE.W  (PLRPOSX),D3
*            
*            ;EYE POSX
*            ADD.W   #PLRWIDTH-20,D3
*            MOVE.W  (PLRPOSY),D2
*            
*            ;EYE POSY
*            ADD.W   #PLRHEIGHT/2-18,D2
*            MOVE.W  (PLRPOSX),D4
*           
*            ;EYE HEIGHT 
*            MOVE.L  #3,D4
*            MOVE.B  #88,D0
*            TRAP    #15
            
           ;---------MOUTH------
                               
            ;SET MOUTH COLOR
            MOVE.L  #81, D0
            MOVE.L  #RED, D1
            TRAP    #15
*    
*            MOVE.W  (PLRPOSX),D1  
*            MOVE.W  (PLRPOSY),D2   
*            MOVE.W  (PLRPOSX),D3   
*            MOVE.W  (PLRPOSY),D4   
*
*            
*            ;MOUTH POSX (RESPECT PLRWIDTH)         
*            ADD.W   #PLRWIDTH/2,D1
*            
*            ;MOUTH POSY (RESPECT PLRHEIGHT)
*            ADD.W   #PLRHEIGHT/2,D2
*            
*            ;MOUTH POSX
*            ADD.W   ,D3
*   
*            ;MOUTH HEIGHT 
*            ADD.W   #PLRHEIGHT,D4
*            
*            ;LLAMADA AL TRAP (DIBUJADO)
*            MOVE.B  #88,D0
*            TRAP    #15
            
               
            MOVE.W  (PLRPOSX),D1   
            
            ;EYE WIDTH         
            ADD.W   #PLRWIDTH-1,D1
            MOVE.W  (PLRPOSX),D3
            
            ;EYE POSX
            ADD.W   #PLRWIDTH-20,D3
            MOVE.W  (PLRPOSY),D2
            
            ;EYE POSY
            ADD.W   #PLRHEIGHT-5,D2
            MOVE.W  (PLRPOSY),D4
           
            ;EYE HEIGHT 
            ADD.W   #PLRHEIGHT-15,D4
            MOVE.B  #88,D0
            TRAP    #15
            

            
            MOVEM.L (A7)+,D0-D5
            
            RTS


*~Font name~Courier New~
*~Font size~11~
*~Tab type~1~
*~Tab size~4~
