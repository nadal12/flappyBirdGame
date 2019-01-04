; =============================================================================
; INSTRUCTIONS SCREEN MANAGEMENT
; =============================================================================
; -----------------------------------------------------------------------------
STAINSTU
; INSTRUCTIONS STATE UPDATE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
        BTST.B  #KBDBITF1,(KBDEDGE)     ; CHECK IF SPACE PRESSED TO GO BACK
        BEQ.S   .END
        
        MOVE.W  #STAINTR,(STANEXT)      ; RETURN TO INTRO MENU
.END    
        RTS

; -----------------------------------------------------------------------------
STAINSTP
; INSTRUCTIONS STATE PLOT
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
        ;Guardar registros
        MOVEM.L D0/A1,-(A7)
        
        **********DIBUJAR TITULO**********
        ;Seleccionar fuente de texto
        UTLFONT INSTITC,INSTITF
        ;Seleccionar posición de texto
        UTLLOCT INSTITX,INSTITY
        
        LEA     .TITLE,A1
        MOVEQ   #14,D0
        TRAP    #15
        
        **********DIBUJAR INSTRUCCIONES**********
        ;Seleccionar fuente de texto
        UTLFONT INSINSC,INSINSF
        ;Seleccionar posición de texto
        UTLLOCT INSINSX,INSIN1Y
        
        LEA     .INST1,A1
        MOVEQ   #14,D0
        TRAP    #15
        
        ;Seleccionar posición de texto
        UTLLOCT INSINSX,INSIN2Y
        
        LEA     .INST2,A1
        MOVEQ   #14,D0
        TRAP    #15
        
        ;Seleccionar posición de texto
        UTLLOCT INSINSX,INSIN3Y
        
        LEA     .INST3,A1
        MOVEQ   #14,D0
        TRAP    #15
        
        ;Seleccionar posición de texto
        UTLLOCT INSINSX,INSIN4Y
        
        LEA     .INST4,A1
        MOVEQ   #14,D0
        TRAP    #15
        
        ;Seleccionar posición de texto
        UTLLOCT INSINSX,INSIN5Y

        LEA     .INST5,A1
        MOVEQ   #14,D0
        TRAP    #15

        **********DIBUJAR HELP TEXT***********
        ;Seleccionar fuente de texto
        UTLFONT INSHLPC,INSHLPF
        ;Seleccionar posición de texto
        UTLLOCT INSHLPX,INSHLPY
        
        LEA     .INST,A1
        MOVEQ   #14,D0
        TRAP    #15
        
        ;Cambiar fuente de texto para ajustar altura de titulo
        UTLFONT 00000000,PSHFNT
        
        ;Restaurar registros
        MOVEM.L (A7)+,D0/A1
        RTS 

; --- LOCAL DATA -----------------
.TITLE  DC.B    'FLAPPY BIRD',0
.INST1  DC.B    'EL OBJETIVO DEL JUEGO ES SALTAR A TRAVÉS DE LAS TUBERÍAS',0
.INST2  DC.B    'SIN CAER AL SUELO, SALIR DE LA PANTALLA POR EL BORDE SU-',0
.INST3  DC.B    'PERIOR, O TOCAR ALGUNA TUBERÍA.',0
.INST4  DC.B    'PARA SALTAR PRESIONA LA TECLA UP',0
.INST5  DC.B    'PARA IR AL MENÚ DE PAUSA, PRESIONA LA TECLA P',0
.INST   DC.B    'PRESIONA SPACE PARA VOLVER AL MENU ANTERIOR',0
        DC.W    0





*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
