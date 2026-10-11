%include "../../lib/pc_io.inc"   ; incluir declaraciones de procedimiento externos

section .data
    bskey equ 0x7F
    lencadena equ 255
    ln equ 0x0A
    nline db ln,0
    msg1 db ln,'Captura: ', 0
    msg2 db ln,'Cadena: ', 0
    
section .bss
    cadena resb lencadena

section .text
    global _start         ; referencia para inicio de programa
    
_start:   
   
    ; --- IMPRIMIR CADENA  ---
    mov edx, msg1        
    call puts   
    call captura
    mov edx, msg2
    call puts
    mov edx, cadena
    call puts    
    mov edx, msg2
    call puts
    mov edx, cadena
    call minus
    call puts
    mov edx, msg2
    call puts
    mov edx, cadena
    call mayus
    call puts
    jmp .fin_programa  
    
    
    
    ; --- FIN DE PROGRAMA ---
    .fin_programa: 
        mov edx, nline    
        call puts     
        call puts     
        mov eax, 1            ; Llamada sys_exit
	    xor ebx, ebx          ; return 0
        int 0x80              ; Fin de programa


    ;Minuscula
    minus:
                    mov ebx, 0 ; posicion inicial
        .continue:  cmp byte[edx+ebx],0   ; Si el caracter es nulo 
                    je .out    ;terminar

                    cmp byte[edx+ebx],65     ;[letra] - 65(lim. inferior)
                    jae .seguir             ;Si es >= 0
                    inc ebx                 ;Si no lo es, aumentar i++
                    jmp .continue

        .seguir:    cmp byte[edx+ebx],90    ;[letra] - 90(lim. sup.)        
                    jl .cambiar                ; Si es menor, se cambia
                    inc ebx                    ;si no lo es
                    jmp .continue

        .cambiar:   add byte[edx+ebx],32     ;cambiar a minuscula
                    inc ebx
                    jmp .continue

            .out:   ret


;Mayuscula
        mayus:
                    mov ebx, 0 ; posicion inicial
        .proseguir: cmp byte[edx+ebx],0   ; Si el caracter es nulo 
                    je .terminar    ;terminar

                    cmp byte[edx+ebx],97   ;[letra] - 97(lim. inferior)
                    jae .next               ;Si es >= 0
                    inc ebx                ;Si no lo es, aumentar i++
                    jmp .proseguir

        .next:      cmp byte[edx+ebx],122    ;[letra] - 122(lim. sup.)        
                    jl .change                ; Si es menor, se cambia
                    inc ebx                    ;si no lo es
                    jmp .proseguir

        .change:    sub byte[edx+ebx],32     ;cambiar a mayuscula
                    inc ebx
                    jmp .proseguir

            .terminar:   ret



   
    captura:
                    ;push ax ;
                    mov cx, lencadena   ; Copiamos el valor de la longitud de la cadena en contador
                    mov ebx, 0 ; Nuestra variable i para recorrer la cadena 
        
    .continuar:     call getch   ; Lee el caracter tecleado y lo guarda en AL
                    cmp al, bskey
                    jne .sig
                    call borrar
                    jmp .continuar

    .sig:           call putchar ; Imprime el caracter almacenado en AL
                    cmp al, ln  ; Comprobar si es un salto de linea
                    je .salir ; Si es /n salimos del ciclo
                    mov [cadena+ebx], al ; Almacenmos el caracter en la direccion de la cadena
                    inc ebx ;i++
                    loop .continuar ; se repite
                    
    
    .salir:         mov byte [cadena+ebx], ln   ; Almacenmos el caracter nueva linea
                    inc ebx 
                    mov byte [cadena+ebx], 0
                    ;pop ax
                    ret

    borrar:
                ;push ax
                cmp ebx,0
                je .fin_borrar

                ;push ax

                mov al,0x8 ; Retrocede
                call putchar ; Imprime
                mov al,' '  ; Pone un espacio
                call putchar ; Imprime
                mov al,0x8 ; Vulve a retroceder
                call putchar

                ;pop ax

                dec ebx
                inc cx
                

    .fin_borrar: ret 

        ; Compilar: make -C src/practica6
        ; Ejecutar: make -C src/practica6 run
