extern canonical_off
extern canonical_on

section .data
bskey equ 0x7F
tamanio equ 255
ln equ 0x0A
msg1 db ln,'Captura: ', 0
msg2 db ln,'Cadena: ', 0

section .bss
cadena resb tamanio

section .text
    global _start         ; referencia para inicio de programa
   
    
_start: 
    
    mov edx,msg1
    call puts
    call captura
    mov edx,msg2
    call puts
    mov edx,cadena
    call puts
    
    ;call getche
    ;call getche
    ;call getche
    ;call getche
    ;call getche
   
    
    
    ; --- FIN DE PROGRAMA ---
    .fin_programa:  
        mov eax, 1            ; Llamada sys_exit
	    xor ebx, ebx          ; return 0
        int 0x80              ; Fin de programa




    captura:
                    ;push ax ;
                    mov cx, tamanio   ; Copiamos el valor de la longitud de la cadena en contador
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



    putchar:

        ; Push para salvar valores
        push ebx
        push ecx
        push edx
        push eax

        mov eax,4 ; Muestra los datos en pantalla
        mov ebx,1 ; Muestra por pantalla
        mov ecx,esp ; Puntero a la pila
        mov edx,1   ; Mostrar un solo caracter (1 byte)
        int 0x80 ; Ejecutar

        pop eax
        pop edx
        pop ecx
        pop ebx

        ret

    puts:
        ;SE USA putchar

            push eax            ; Guardamos el valor original de eax
    
    .ciclo:
            mov al, [edx]       ; Copiamos el carácter actual al que apunta edx hacia 'al'
            cmp al, 0           ; Comparamos si el carácter es el nulo (fin de cadena)
            je .fin             ; Si es nulo, saltamos al final de la función
    
            push edx            ; Guardamos edx en la pila.
            call putchar        ; Imprime el carácter que acabamos de cargar en 'al'
            pop edx             ; Restauramos el valor de edx para no perder nuestro apuntador
    
            inc edx             ; Avanzamos el apuntador al siguiente carácter en la memoria
            jmp .ciclo          ; Repetimos el ciclo para el siguiente carácter

    .fin:
            pop eax             ; Restauramos eax
            ret                 ; Regresamos al programa principal


    getch:
        call canonical_off
       
       ; Push para salvar valores dentro de la pila
        push ebx    
        push ecx
        push edx
        push eax

        mov eax, 3  ; Llamada al sistema para escritura
        mov ebx, 0  ; Lectura desde el teclado
        mov ecx, esp    ; Nuestro buffer sera la pila
        mov edx, 1  ; Leer solo un byte
        int 0x80    ; Ejecutar

        pop eax
        pop edx
        pop ecx
        pop ebx

        
        call canonical_on
        ret

    getche:
        call canonical_off
        ;CODIGO

        ; Push para salvar valores dentro de la pila
        push ebx
        push ecx
        push edx
        push eax

        mov eax,3   ; Llamada al sistema para escritura
        mov ebx,0   ; Lectura desde el tecleado
        mov ecx,esp ; Puntero a la pila para nuestro buffer
        mov edx,1   ; Leer un solo byte
        int 0x80    ; Ejecutar
        
        pop eax
        pop edx
        pop ecx
        pop ebx

        call putchar    ; Llamar para su impresion por pantalla
        call canonical_on
        ret