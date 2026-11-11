 %macro PROTOENTRADA 0
    push ebp
    mov ebp,esp

%macro PROTOSALIDA 0
    pop ebp
    mov esp,ebp


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

.ciclo:
    cmp ecx,esi
    jb .cuerpo
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

    .fin:
    mov eax,dword[ebp-4]
    add esp,4
    pop esi
    pop edx
    pop ecx
    pop ebx
    PROTOSALIDA
    ret