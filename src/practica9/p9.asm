
section .text
global _minimo
global _maximo
global _sum 

%macro PROTOENTRADA 0
    push ebp
    mov ebp,esp
%endmacro

%macro PROTOSALIDA 0
    mov esp,ebp
    pop ebp
%endmacro

; WHILE 1% = ebx, %2 = ecx, %3 = eax, %4 = instruccion (cmp/add), %5 = salto, 6% = esi, %7 = cuerpo
; WHILE 1% = ecx, %2 = esi, %3 = realizar, %4 = mientras, %5 = salir
%macro WHILE 5

.%4:
cmp %1,%2
jbe .%5
call %3
inc %2
jmp .%4

.%5:
%endmacro


_minimo:
    PROTOENTRADA
    ; esp+4 = dir_de_retorno, esp+8 = arreglo, esp+12 = len (longitud)
    ; Valores cargados en la pila
    sub esp,4
    push ebx
    push ecx
    push edx
    push esi
    mov ebx,dword[ebp+8] ;arreglo
    mov ecx,dword[ebp+12]   ;len
    mov edx,dword[ebx]  ; arreglo[0]
    mov dword[ebp-4],edx ;min
    mov esi,0 ;i

    WHILE ecx,esi,.es_menor,mientras,salir

    .fin:
    mov eax,dword[ebp-4]
    pop esi
    pop edx
    pop ecx
    pop ebx

    PROTOSALIDA
ret


.respaldo:

.ciclo:
    cmp ecx,esi
    ja .cuerpo
    jmp .fin

    .cuerpo:
    mov edx,dword[ebx+esi*4] 
    mov eax,dword[ebp-4] 
    cmp edx,eax  
    jl .cambio
    jmp .incremento

.cambio:
    mov edx,dword[ebx+esi*4]  ; arreglo[0] 
    mov dword[ebp-4],edx ;min
    jmp .incremento

.incremento:
    inc esi 
    jmp .ciclo

ret


.es_menor:

    mov edx,dword[ebx+esi*4] 
    mov eax,dword[ebp-4] 
    cmp edx,eax  
    jl .hacer_cambio
    jmp .no_cambiar

.hacer_cambio:
    mov dword[ebp-4],edx ;min

.no_cambiar:
ret


_maximo:
    PROTOENTRADA
    sub esp,4

    push ebx
    push ecx
    push edx
    push edi

    mov ecx,dword[ebp+12] ; ECX = Contiene la longitud del arreglo
    mov ebx,dword[ebp+8]  ; EBX = Contiene la direccion base ( primer elemento del arr[0])
    mov esi,0  ; ECX = Contador / Iterador (i)
    mov edx, [ebx]  
    mov dword[ebp-4],edx; Variable local = COntienen el valor del primer registro


    WHILE ecx,esi,.es_mayor,mientras,salir


.fin_maximo:

    pop edi
    pop edx
    pop ecx
    pop ebx

    mov eax,dword[ebp-4]

    PROTOSALIDA
ret


.es_mayor:

    mov edx, dword[ebx+esi*4]
    mov eax, dword[ebp-4]
    cmp edx,eax
    jg .change
    jmp .no_change

.change:
    mov dword[ebp-4],edx

.no_change:
ret



_sum:

    PROTOENTRADA
    
    push ebx
    push edi
    push edx
    push ecx

    mov ecx, dword[ebp+12] ; ECX = Contiene el tamanio del arreglo
    mov ebx, dword[ebp+8] ; EBX = Contiene la direccion base del arreglo
    mov esi, 0 ; ESI = Nuestro contador i = 0
    mov eax, 0 ; Variable total = 0

    WHILE ecx,esi,.sumar,mientras,salir

.fin_sum:

    pop ecx
    pop edx
    pop edi
    pop ebx

    PROTOSALIDA
    ret


.sumar:
    mov edx, dword[ebx+esi*4]
    add eax,edx
ret