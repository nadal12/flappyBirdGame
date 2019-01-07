; =============================================================================
; PIPES MANAGEMENT. IT IS AN AGENT.
; LOCAL MEMORY IS:
; +0 WORD X COORDINATE OF THE LEFTMOST EDGE OF THE VERTICALLY ALIGNED PIPES
; +2 WORD Y COORDINATE OF THE DOWNMOST EDGE OF THE TOP PIPE (FACING DOWN)
; +4 WORD BOOLEAN THAT TELLS WHETHER THE PIPE SHOULD BE IGNORED OR NOT.
; =============================================================================

; -----------------------------------------------------------------------------
PIPINIT
; PIPE INITIALIZATION
; INPUT    - NONE 
; OUTPUT   - NONE
; MODIFIES - (A0), 2(A0), 4(A0).
; -----------------------------------------------------------------------------
            ;Guardar registros
            MOVEM.L D0-D1,-(A7)
        
            MOVE.W  #SCRWIDTH,(A0)      ;X COORDINATE OF STARTING POSITION
            JSR     UTLRAND             ;RANDOM Y COORDINATE OF STARTING
            MOVE.W  D0,2(A0)            *POSITION
            CLR.W   4(A0)
            
            ;Restaurar registros
            MOVEM.L (A7)+,D0-D1
            RTS
            
; -----------------------------------------------------------------------------
PIPUPD
; PIPE UPDATE
; INPUT    - NONE 
; OUTPUT   - NONE
; MODIFIES - (A0), 4(A0), (PLRSCORE)
; -----------------------------------------------------------------------------
            ;Guardar registros.
            MOVEM.L  D0-D7,-(A7)
            
            MOVE.W  (XSPEED),D0     
            SUB.W   D0,(A0)         ;Actualizar coordenada X. 
            
            CMP.W   #-PIPTWDT,(A0)
            BLE.L   .KILL
            
            ;Ver si es una tubería ya pasada. 
            CMP.W   #1, 4(A0)
            BEQ     .END    
        
            ;Preparar los registros para llamar a la subrutina que comprueba 
            ;las colisiones con las tuberías. 
            MOVE.W  (A0),D0
            MOVE.W  2(A0),D1
            MOVE.W  (PLRPOSX),D2
            MOVE.W  (PLRPOSY),D3
            MOVE.W  #PIPBWDT,D4
            MOVE.W  #PLRWIDTH,D5
            MOVE.W  #PIPOPEN,D6
            MOVE.W  #PLRHEIGHT,D7
            JSR     UTLCHCOL           
            
            ;Si la subrutina devuelve #2, hay que ignorar la tubería. 
            CMP     #1,D0
            BEQ     .IGNPIPE
            CMP     #3,D0
            BEQ     .COLINFPIPE
            CMP     #2,D0
            BEQ     .COLSUPPIPE
            CMP     #4,D0
            BEQ     .COLEDGEPIPE
            
            TST.B   D0
            BEQ     .END
            
.COLINFPIPE
            ;Calcular posición de jugador muerto en tubería inferior. 
            MOVE.W  2(A0),(PLRDEADY)
            ADD.W   #PIPOPEN,(PLRDEADY)
            SUB.W   #PLRHEIGHT,(PLRDEADY)
            MOVE.W  (PLRPOSX),(PLRDEADX)
            BRA     .PLRDEAD
            
            ;Calcular posición de jugador muerto en tubería superior.             
.COLSUPPIPE
            MOVE.W  2(A0),(PLRDEADY)
            MOVE.W  (PLRPOSX),(PLRDEADX)
            BRA     .PLRDEAD

            ;Calcular posición de jugador muerto en un lado de la tubería.             
.COLEDGEPIPE
            MOVE.W  (A0),(PLRDEADX)
            SUB.W   #PLRWIDTH,(PLRDEADX)
            MOVE.W  (PLRPOSY),(PLRDEADY)
            
            ;Jugador muerto. (Colisión detectada).
.PLRDEAD    
            MOVE.W  #1,(PLRDEAD)
            BRA     .END

.IGNPIPE
            ;Marcar tebería como ignorada y añadir #1 al score. 
            MOVE.W  #1,4(A0)
            ADD.L   #1,(PLRSCORE)
                       
.END        ;Restaurar registros.
            MOVEM.L  (A7)+,D0-D7
            RTS
            
.KILL       JSR     AGLKILL
            BRA.S   .END
            
; -----------------------------------------------------------------------------
PIPPLOT
; PIPE PLOT
; INPUT    - NONE 
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            ;Guardar registros
            MOVEM.L D0-D4,-(A7)
            
            ;Seleccionar colores de relleno y dibujado para tuberías.
            UTLSPEN #PIPPC
            UTLSFIL #PIPFC
            
            ;Pintar la base de la tubería superior.
            MOVE.W  (A0),D1          
            ADDQ    #PIPTBSPC,D1
            CLR     D2
            MOVE.W  D1,D3
            ADD.W   #PIPBWDT,D3
            MOVE.W  2(A0),D4
            
            MOVEQ   #87,D0
            TRAP    #15
            
            ;Pintar la boca de la tubería superior.
            MOVE.W  (A0),D1          
            MOVE.W  2(A0),D4
            MOVE.W  D4,D2
            SUB.W   #PIPTHGT,D2
            MOVE.W  D1,D3
            ADD.W   #PIPTWDT,D3
            
            MOVEQ   #87,D0
            TRAP    #15
            
            ;Pintar la base de la tubería inferior.
            MOVE.W  (A0),D1          
            ADD.W   #PIPTBSPC,D1
            MOVE.W  2(A0),D2
            ADD.W   #PIPOPEN,D2
            MOVE.W  D1,D3
            ADD.W   #PIPBWDT,D3
            MOVE.W  #BGGSSTP,D4
            
            MOVEQ   #87,D0
            TRAP    #15
            
            ;Pintar la boca de la tubería inferior.
            MOVE.W  (A0),D1         
            MOVE.W  2(A0),D2
            ADD.W   #PIPOPEN,D2
            MOVE.W  D1,D3
            ADD.W   #PIPTWDT,D3
            MOVE.W  D2,D4
            ADD.W   #PIPTHGT,D4
            
            MOVEQ   #87,D0
            TRAP    #15

            ;Restaurar registros
            MOVEM.L (A7)+,D0-D4
            RTS



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
