%include "../../lib/pc_io.inc"   ; incluir declaraciones de procedimiento externos

section .data
    bskey equ 0x7F
    lencadena equ 64
    ln equ 0x0A
    nline db ln,0
    msg1 db ln,'Captura: ', 0
    msg2 db ln,'Salida: ', 0
    
section .bss
    cadena resb lencadena
    bandera resb 1  ; Para detener la captura de caracteres y saber si hay signos capturados
    salida resb lencadena

section .text
    global _start         ; referencia para inicio de programa
    
_start:   
   
    ; --- IMPRIMIR CADENA  ---
    mov edx, msg1        
    call puts   
    call capturar
    call ATOI
    mov edi, salida
    call ITOA
    mov edx, msg2
    call puts
    mov edx, salida
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


  


   
    capturar:
                    mov byte[bandera],0 
                    mov cx, lencadena   ; Copiamos el valor de la longitud de la cadena en contador
                    mov ebx, 0 ; Nuestra variable i para recorrer la cadena 
        
    .continuar:     call getch   ; Lee el caracter tecleado y lo guarda en AL
                    cmp al, bskey
                    jne .sig     ; Brinca si no es igual al backspace
                    call borrar
                    jmp .continuar

    .sig:           call putchar ; Imprime el caracter almacenado en AL
                    cmp al, ln  ; Comprobar si es un salto de linea
                    je .salir ; Si es /n salimos del ciclo


                    
                    ;SI ES EL INICIO COMPROBAR SIGNO

                    cmp al,43                ; Comprobar si hay un signo positivo al inicio de la cadena
                    je  .signo_encontrado    ; Si hay un signo lo guarda en la cadena
                    cmp al,45                ; Comprobar si hay un signo negativo al inicio de la cadena
                    je .signo_encontrado     ; Si hay un signo lo guarda en la cadena 
                    jmp .seguir

    .signo_encontrado:

                    cmp ebx,0                ; Comprobar si la posicion actual es el inicio de la cadena
                    jne .next                ; Si ya no es el inicio preguntamos

                    ;SI ES IGUAL A CERO (POSICION INICIAL)
                    mov [cadena+ebx],al
                    inc ebx
                    jmp .continuar  ; Continuamos con el siguiente caracter a introducir  
    .next:
                    ;SI NO ES IGUAL A CERO (PERO EBX = 1)
                    cmp ebx,1
                    jne .seguir  ;SI NO ES IGUAL A 1

                    ;SI ES IGUAL A 1
                    cmp [cadena+ebx-1],al
                    je .seguir
                    mov [cadena+ebx-1],al 
                    jmp .seguir


                     
    .seguir:         
                ; SI AL ES UN ESPACIO O TABULADOR LO IGNORA Y CONTINUA    

                    cmp al,32   ; Si es un espacio
                    je .continuar  ; Continuar 
                    cmp al,9    ; Si es un tab 
                    je .continuar  


                    ; SI AL ES UN NUMERO
                    ; CAPTURAR NUMEROS DEL 0 AL 9 (48-57)

    .verificar:        
                    cmp al,48 ;
                    jae .seguir_comprbnd
                    jmp .detener  ; Si el valor es negativo, significa que no es un caracter de digito

    .seguir_comprbnd: 
                    cmp al,57
                    jle .guardar_en_cadena  ; Si es menor o igual a 0 se guarda en la cadena
                    jmp .detener    ; Si el valor es positivo, significa que no es un caracter de digito


    .guardar_en_cadena:

                        cmp byte[bandera], 1      ; Si la bandera es igual a 1 -> 1-1 = 0
                        je .continuar       ; Detenemos y no capturamos mas caracteres en la cadena

                        ;SI LA BANDERA ES DISTINTA DE 1
                        mov [cadena+ebx], al ; Almacenmos el caracter en la direccion de la cadena
                        inc ebx ;i++
                        loop .continuar ; se repite

    .detener:
                    cmp ebx, 1      ; Comparar el primer indice
                    ja .habilitar_bandera  ; Si hay uno o mas de un valor, habilitamos la bandera
                    jmp .continuar      ; Si no hay por lo menos un valor en la cadena continua


    .habilitar_bandera:
                    mov byte[bandera], 1
                    jmp .continuar

    
    .salir:         
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


ATOI:
        ; Registros a utilizar: ebx, eax, ecx, edx
        mov eax,0
        mov ecx,0
        mov byte[bandera],0 ; Si es 0 = positivo, si es 1 = negativo

        ;Comprobar signos al inicio
        cmp byte[cadena+ecx], '+' ; Si es igual al signo positivo 
        je .hay_signo
        cmp byte[cadena+ecx], '-'
        jne .ciclo_conversion     ; Si no es igual al signo neg

        ;Si es igual al signo negativo
        mov byte[bandera],1 ; Cambiamos al estado de la bandera

.hay_signo:
        inc ecx ; Avanzar al siguiente caracter


.ciclo_conversion:

        movzx edx, byte[cadena+ecx] ; Pasamos el caracter actual al registro edx

        cmp edx,0       ; Si es el caracter nulo, salimos
        je .aplicar_signo 
        cmp edx,'0'        ; Si es menor que cero, salimos
        jb .aplicar_signo
        cmp edx,'9'        ; Si es mayor que 9, salimos
        ja .aplicar_signo

        sub edx,'0'             ;Convertimos de ASCII a valor numerico
        imul eax,10             ; Multiplicar el registro x10
        add eax,edx             ; Sumar el nuevo digito

        inc ecx  ;Incrementamos contador
        jmp .ciclo_conversion

.aplicar_signo:
        cmp byte[bandera],1
        jne .fin_atoi
        neg eax         ; Si tenemos un signo negativo, negamos eax

.fin_atoi
        ret



ITOA:
        mov ebx, 10 ; Base 10
        mov ecx, 0 ; Contador de digitos en la pila

        ; DETERMINAMOS SI EXISTE UN SIGNO negativo
        cmp eax, 0              ; Si el calculo que nos dio anteriormente en eax es menor a 0, significa que la cifra es neg
        jge .extraer_digitos    ; Si es mayor o igual la cifra es positiva, jge se utiliza para comparaciones con signo
        mov byte[edi], '-'
        inc edi                 ; Incrementamos el puntero hacia el otro caracter
        neg eax                 ; Volver el numero positivo para dividir

.extraer_digitos:

        mov edx,0
        div ebx         ; Division base 10
        add dl,'0'      ; Convertimos el residuo guardado en dl en caracter
        push edx        ; Guardar en la pila
        inc ecx         ; Incremetamos contador
        cmp eax,0
        je .vaciar_pila
        jnz .extraer_digitos

.vaciar_pila:

        pop edx
        mov byte[edi],dl
        inc edi
        dec ecx
        jnz .vaciar_pila


        mov byte[edi],0 ; Para finalizar agregamos el caracter nulo
        ret

        ; Poner antes de ejecutar:
        ; sudo apt update
        ; sudo apt install nasm
        
        ; Compilar: make -C src/practica6
        ; Ejecutar: make -C src/practica6 run
         
