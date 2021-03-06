; =============================================================================
; PLAYER MANAGEMENT
; =============================================================================

; -----------------------------------------------------------------------------
PLRINIT
; INITIALIZES THE PLAYER
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - (PLRPOSX), (PLRPOSY), (MAXPOS), (UPPRESSED), (PLRDOWNSPEED),
; (PLRSCORE), (PLRDEAD).
; -----------------------------------------------------------------------------

            MOVE.W  #PLRINITPOSX,(PLRPOSX)
            MOVE.W  #PLRINITPOSY,(PLRPOSY)
            MOVE.W  #PLRINITPOSY,(MAXPOS)
            MOVE.W  #0,(UPPRESSED)           ;Tecla de salto no presionada (0).
            MOVE.W  #1,(PLRDOWNSPEED)        ;Velocidad de bajada inicial (1).
            MOVE.L  #0,(PLRSCORE)            ;Inicializar score.
            MOVE.L  #0,(PLRDEAD)             ;Poner a 0 PLRDEAD (Jugador vivo).

            RTS
; -----------------------------------------------------------------------------
PLRUPD
; UPDATES THE PLAYER MOTION
; INPUT    - NONE (ACCESSES KBDEDGE)
; OUTPUT   - NONE (MODIFIES PLAYER DATA)
; MODIFIES - (PLRDOWNSPEED), (PLRPOSY), (PLRPOSX), (MAXPOS), (UPPRESSED), 
; (STANEXT), (PLRDEAD).
; -----------------------------------------------------------------------------
            ;Guardar registros. 
            MOVEM.L D0-D2,-(A7)
          
            ;Comprobaci�n de la tecla presionada con KBDEDGE.
            BTST.B  #KBDBITUP,(KBDEDGE)    
            BNE.L   .PRESSED
        
            ;Comprobar colisi�n con tuber�a. 
            CMP     #1,(PLRDEAD)
            BEQ     .GAMEOVER 
        
            ;Tecla UP no presionada.
            CMP     #1,(UPPRESSED)
            BEQ     .MAKEJUMP
          
            ;No se ha apretado la tecla UP. Hay que bajar el p�jaro. 
            MOVE.W  (PLRPOSY),D0
            ADD.W   (PLRDOWNSPEED),D0
          
            ;Se incrementa la velocidad de bajada. 
            ADDQ    #1,(PLRDOWNSPEED)
            MOVE.W  D0,(PLRPOSY)
         
            ;Establecer correcci�n de salida por parte inferior. 
            MOVE.W  #BGGSSTP,D1
            MOVE.W  #PLRHEIGHT,D0
            SUB.W   D0,D1
            MOVE.W  D1,(PLRDEADY)
            MOVE.W  (PLRPOSX),(PLRDEADX)
            
            ;Comprobar si ha salido por la parte inferior.
            MOVE.W  #BGGSSTP,D1
            MOVE.W  (PLRPOSY),D0
            ADD.W   #PLRHEIGHT,D0
            CMP     D0,D1
            BMI     .GAMEOVER         
            BRA     .END         
.PRESSED
            ;Tecla UP presionada.
          
            ;Se reinicia la velocidad de bajada. 
            MOVE.W  #1,(PLRDOWNSPEED)

            ;Se establece el l�mite hasta donde subir� el p�jaro.
            MOVE.W  (PLRPOSY),D0
            SUB.W   #JUMPSIZE,D0
            MOVE.W  D0,(MAXPOS)
          
            ;Se indica que se ha presionado la tecla de salto.
            MOVE.W  #1,(UPPRESSED)
            BRA     .END     
.MAKEJUMP
          ;Se ha apretado la tecla UP anteriormente (eso indica que el salto no
          ;ha finalizado). 
          
           ;F�RMULA: (PLRPOSY-MAXPOS)/JUMPSPEED = VALOR QUE SE TIENE QUE RESTAR
           ;A LA POSICI�N ACTUAL PARA OBTENER LA NUEVA POSICI�N.
            MOVE.W  (PLRPOSY),D0
            MOVE.W  (MAXPOS),D1
            SUB.W   D1,D0             
            DIVU.W  #JUMPSPEED,D0
            SUB.W   D0,(PLRPOSY)       ;Posici�n nueva. 

            ;Ver si ha salido por la parte superior. 
            MOVE.W  #0,(PLRDEADY)   ;Se corrige la salida por parte superior.
            MOVE.W  (PLRPOSX),(PLRDEADX)
            CMP     #0,(PLRPOSY)
            BMI     .GAMEOVER
            CMP     #1,D0
            BEQ     .LASTJUMP
          
            ;El salto no ha finalizado (No ha llegado a MAXPOS).                   
            BRA     .END
.LASTJUMP
            ;El salto ha llegado a MAXPOS.
          
            ;Se desactiva la tecla UP indicando que lo siguiente ser� realizar 
            ;la bajada. 
            MOVE.W  #0,(UPPRESSED)         
            BRA     .END    
.GAMEOVER            
            ;Cambiar a estado Game Over.
            MOVE.W  (PLRDEADY),(PLRPOSY)   ;Se corrige la salida de pantalla.  
            MOVE.W  (PLRDEADX),(PLRPOSX)
            MOVE.W  #1,(PLRDEAD)
            MOVE.W  #STAGOVR,(STANEXT)        
            BRA     .END                     
.END
            ;Restaurar registros a sus valores originales. 
            MOVEM.L (A7)+,D0-D2
            RTS
          
; -----------------------------------------------------------------------------
PLRPLOT
; PLOTS THE PLAYER
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            ;Guardar registros. 
            MOVEM.L D0-D4,-(A7)
            
            ;----------PUNTUACI�N----------     
                                 
            ;Establecer color de fondo. 
            UTLSFIL #BLACK
            
            ;Establecer ajustes de fuente.
            UTLFONT WHITE,PLRSCRF
            
            ;Imprimir puntuaci�n.
            MOVE    #17,D0
            LEA     PLRSCORETEXT,A1
            MOVE.L  (PLRSCORE),D1
            TRAP    #15
                    
            ;----------JUGADOR (CUERPO)----------     

            ;Color del jugador. 
            MOVE.L  #PLRCOLOR,D1
            MOVE.B  #80,D0
            TRAP    #15
            ADDQ.B  #1,D0
            TRAP    #15
            
            ;Posici�n del jugador. 
            MOVE.W  (PLRPOSX),D1            
            MOVE.W  (PLRPOSY),D2
            MOVE.W  D1,D3
            MOVE.W  D2,D4
            
            ;Pintar c�rculo. 
            ADD.W   #PLRWIDTH,D3
            ADD.W   #PLRHEIGHT,D4
            MOVE.B  #88,D0
            TRAP    #15
            
            ;Pintar rect�ngulo encima del c�rculo. 
            SUB.W   #PLRWIDTH/2,D3
            MOVE.B  #87,D0
            TRAP    #15
            
            ;----------OJO (IRIS)----------
                             
            ;Establecer color del ojo.
            UTLSFIL #PLRIRISCOLOR
            
            MOVE.W  PLRPOSX,D1   
            
            ;Posici�n y tama�o. 
            ;X0        
            ADD.W   #PLRWIDTH/3,D1
            MOVE.W  (PLRPOSX),D3
            
            ;X2
            ADD.W   #PLRWIDTH/2,D3
            MOVE.W  (PLRPOSY),D2
            
            ;X1
            ADD.W   #PLRHEIGHT/4,D2
            MOVE.W  (PLRPOSY),D4

            ;X3
            ADD.W   #PLRHEIGHT/20,D4
            
            MOVE.B  #88,D0
            TRAP    #15
            
            ;----------BOCA----------
                               
            ;Establecer color de la boca. 
            UTLSFIL #PLRMOUTHCOLOR
               
            MOVE.W  (PLRPOSX),D1   
            
            ;Posici�n y tama�o. 
            ;X0        
            ADD.W   #PLRWIDTH-5,D1
            MOVE.W  (PLRPOSX),D3
            
            ;X2
            ADD.W   #PLRWIDTH/2,D3
            MOVE.W  (PLRPOSY),D2
  
            ;X1
            MOVE.W  #PLRHEIGHT, D0
            MULU    #100, D0
            DIVU    #55, D0
            SUB     #PLRHEIGHT, D0
            ADD.W   D0,D2
            MOVE.W  (PLRPOSY),D4   
            
            ;X3 
            ADD.W   #PLRHEIGHT-1,D4
           
            MOVE.B  #88,D0
            TRAP    #15
                         
            ;Restaurar registros.
            MOVEM.L (A7)+,D0-D4
            RTS
*~Font name~Courier New~
*~Font size~11~
*~Tab type~1~
*~Tab size~4~
