%include "../../lib/pc_io.inc"   ; incluir declaraciones de procedimiento externos

section .text
    global _start         ; referencia para inicio de programa
    
_start:   
    ; --- IMPRIMIR CADENA COMPLETA ---
    mov edx, msg          ; edx = dirección de la cadena msg
    call puts             ; imprime cadena
    mov byte[edx], 'Z'    ; Inciso a) direccionamiento directo
    call puts
    add edx, 23           ; Inciso b) direccionamiento con base
    mov byte[edx], 'X'
    mov edx,msg           ; Restauramos su valor inicial de la cadena para su impresion
    call puts
    mov byte [edx+26], '@' ; Inciso c) direccionamiento con base + desplazamiento
    call puts
    mov ecx,25                 ; Indice almacenada en un registro
    mov al, 'Z'                ; Caracter Z en al
    mov byte[edx+ecx], al      ; Inciso d) direccionamiento con base + indice
    call puts
    mov ecx,12             ; Indice contenida en un registro
    mov al, 'P'            ; Valor P contenida en otro registro
    mov [edx+ecx+3], al    ; Inciso e) direccionamiento con base + indice + desplazamiento
    call puts
    mov ebp, edx           ; Almacenamos el inicio de la cadena en un registro para la base
    add ebp, 3             ; Le sumamos 3 posiciones mas
    mov ecx, 4             ; Almacenamos el valor de 4 como indice en un registro
    mov al, '%'            ; Almacenamos el valor % en un registro
    mov [ebp + ecx*4], al  ; Inciso f) direccionamiento con base + indice escalado
    call puts

    ; --- FIN DE PROGRAMA ---
    mov eax, 1            ; Llamada sys_exit
	xor ebx, ebx          ; return 0
    int 0x80              ; Fin de programa

section .data
    msg db 'abcdefghijklmnopqrstuvwxyz0123456789', 0xa, 0
    salto db 0xa