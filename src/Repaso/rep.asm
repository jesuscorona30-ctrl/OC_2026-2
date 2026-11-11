%include "../../lib/pc_io.inc"

section .data ; Aqui defines los datos con un valor definido, inicializado o constante previo a la ejecucion.
null equ 0
nline equ 0xA
newln db 0xA,0
msg db nline,"Entrada: ",null
msg1 db nline,"Salida: ",null
msg2 db "+565",null
nmbrs db 1,2,3,4,5,6,7,8,9,10,null
variable db 50

; En esta seccion creas variables o espacios en memoria cuyo contenido no esta inicializado y 
; podra modificarse a conveniencia durante la ejecucion del programa
section .bss
result resb 64 ; Para almacenar la cadena de numeros resultante 
var resb 1 ; un byte (8 bits)
var_dw resw 1 ; dos bytes (16 bits)
var_dd resd 1 ; cuatro bytes (32 bits / registro)
i resb 1;
bandera resb 1;

section .text ; Aqui comienza el texto para ejecutarse
    global _start

_start:

; Operaciones entre Registros
mov edx, msg1
call puts
mov ebx,97
call num_primo
call ITOA
mov edx,result
call puts
mov edx,newln
call puts




jmp .fin_programa


.fin_programa:
    mov eax,1
    xor ebx,ebx
    int 0x80


putchar:

        push edx
        push ecx
        push ebx
        push eax

        mov eax,4
        mov ebx,1
        mov ecx,esp
        mov edx,1
        int 0x80

        pop eax
        pop ebx
        pop ecx
        pop edx

ret

puts:

.do_while:

        mov al,byte[edx]

        cmp al,0
        je .fin_puts

        call putchar 
        inc edx
        jmp .do_while

.fin_puts:
        ret




ITOA:
    ;EJEMPLO EAX CONTINE = 465

    mov ebx,10  ; Division base 10
    mov ecx,0
    mov byte[i],0     ; 0 indica que es positivo

    cmp eax,0
    jge .repetir
    neg eax
    mov byte[result+ecx],'-'
    mov byte[i],1
    inc ecx


.repetir:

        xor edx,edx  ; Para cada nueva division edx igualamos a 0
        div ebx    ; Dividir entre 10
        add edx,'0' ; Sumamos el residuo por el caracter cero (48)
        push edx    ; Metemos a la pila el residuo : 5,6,4
        inc ecx
        cmp eax,0
        jne .repetir
        mov ebx,0
        je .es_negativo


.es_negativo:
        cmp byte[i],1
        jne .pop_pila
        inc ebx
        jmp .pop_pila


.pop_pila:
    pop edx
    mov byte[result+ebx], dl
    inc ebx
    loop .pop_pila

    mov byte[result+ebx],0

    ret



ATOI:
        xor eax,eax
        mov ecx,0
        mov byte[bandera],0

        cmp byte[edx+ecx],'-'
        je .es_negativo
        cmp byte[edx+ecx],'+'
        je .es_positivo
        jmp .ciclo

.es_positivo:
        inc ecx
        jmp .ciclo

.es_negativo:
        mov byte[bandera],1
        inc ecx
        
        
.ciclo: cmp byte[edx+ecx],0
        je .comprobar_signo
        push ecx
        movzx ecx,byte[edx+ecx]
        sub ecx,'0'
        imul eax,10
        add eax,ecx
        pop ecx
        inc ecx
        jmp .ciclo

.comprobar_signo:
        cmp byte[bandera],0
        je .fin_atoi
        neg eax

.fin_atoi:
        ret


ITOS:
        push ecx
        push edx
        push eax
        push edi

        xor ecx, ecx    ; ECX = Índice para recorrer 'nmbrs' (0, 1, 2...)
        xor edi, edi    ; EDI = Índice global para escribir en 'result' (0, 1, 2...)

.dowhile:
        cmp byte[edx+ecx], 0
        je .fin_itos
        
        movzx eax, byte[edx+ecx] ; Cargamos el número actual en EAX
        
        call ITOA_V2             ; Convertimos. EDI avanzará dentro de la función.
        
        inc ecx                  ; CORREGIDO: Avanzamos de forma segura en ITOS
        jmp .dowhile

.fin_itos:
        mov byte[result+edi], 0  ; Cerramos la cadena final con un carácter nulo
        
        pop edi
        pop eax
        pop edx
        pop ecx
ret


ITOA_V2:
        ; Recibe el número en EAX y escribe en la posición global result+EDI
        push eax
        push ebx
        push ecx
        push edx

        mov ebx, 10
        xor ecx, ecx    ; Contador local de cuántos dígitos metemos a la pila

.while_div:
        xor edx, edx
        div ebx         ; Dividir EAX entre 10
        add dl, '0'     ; Convertir a carácter ASCII
        push dx         ; Guardar en la pila
        inc ecx         ; Contar dígito
        cmp eax, 0
        jne .while_div

        ; Ahora vaciamos la pila usando ECX de manera local en el LOOP
.sacar_digitos: 
        pop dx
        mov byte[result+edi], dl  ; Guardamos en la posición del puntero global EDI
        inc edi                   ; Avanzamos el puntero de escritura
        loop .sacar_digitos       ; Resta 1 a ECX hasta llegar a 0

        ; Agregar un espacio para separar los números en la salida
        mov byte[result+edi], ' '
        inc edi

        pop edx
        pop ecx
        pop ebx
        pop eax
ret


printn:
        xor ecx,ecx
        xor eax,eax

.print: 
        cmp byte[result+ecx],null
        je .fin_printn
        mov al, byte[result+ecx]
        push ecx
        push ax

        ;IMPRIMIR
        mov eax,4
        mov ebx,1
        mov ecx,esp
        mov edx,1
        int 0x80
        pop ax


        mov ebx,' '
        push bx
        ;IMPRIMIR ESPACIO
        mov eax,4
        mov ebx,1
        mov ecx,esp
        mov edx,1
        int 0x80
        pop bx

        pop ecx
        inc ecx
        jmp .print


.fin_printn:
ret

num_primo:

        ; ebx recibira el numero
        xor ecx,ecx
        mov ecx,1     ; Sera nuestro dividendo
        mov eax,ebx   ; Pasamos la copia a eax
        xor ebx, ebx  ; Nuestro contador
       
        ; validar que el numero sea mayor a 1
        cmp eax,1
        jbe .salir

.DO_WHILE:
        xor edx,edx
        cmp eax,ecx
        jl .verificar
        push eax 
        div ecx
        cmp edx,0
        je .incrementar
        inc ecx
        pop eax
        jmp .DO_WHILE


.incrementar:
        inc ebx
        inc ecx
        pop eax
        jmp .DO_WHILE
        

.verificar:
        cmp ebx,2
        jne .no_es_primo
        mov al,1
        jmp .salir

.no_es_primo:
        mov al,0

.salir:
        ret


 



    