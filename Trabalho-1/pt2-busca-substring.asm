tam equ 128

include "emu8086.inc"

; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h

DEFINE_SCAN_NUM
DEFINE_PRINT_STRING
DEFINE_GET_STRING
DEFINE_CLEAR_SCREEN
DEFINE_PRINT_NUM_UNS  



; ENTER CODE

mov bx, offset digiteSubstring
call IMPRIME_STRING
call PULA_LINHA

mov di,offset substring
mov dx,tam+1
call GET_STRING  
call PULA_LINHA


mov bx, offset digiteString
call IMPRIME_STRING
call PULA_LINHA

mov di,offset string
mov dx,tam+1
call GET_STRING
call PULA_LINHA


mov di, offset substring
mov si, offset string
call BUSCA_STRING

ret

; rotulos
BUSCA_STRING:
mov dh,[di] ;carrega letra de substring para dh
mov dl,[si] ;carrega letra de string para dl
cmp dl,0
je PALAVRA_NAO_ENCONTRADA

inc si
cmp dh, dl
je CARACTER_IGUAL


mov di, offset substring ;recarrega substring
jmp BUSCA_STRING
ret

CARACTER_IGUAL:
inc di

mov dh,[di]
cmp dh, 0
je PALAVRA_ENCONTRADA

jmp BUSCA_STRING
ret

PALAVRA_ENCONTRADA:
mov bx, offset msgSubstring
call IMPRIME_STRING        
mov bx, offset msgEncontrada
call IMPRIME_STRING
mov ah, 4ch
mov al, 0
int 21h 


PALAVRA_NAO_ENCONTRADA:
mov bx, offset msgSubstring
call IMPRIME_STRING        
mov bx, offset msgNaoEncontrada
call IMPRIME_STRING
mov ah, 4ch
mov al, 0
int 21h

;AX = PARAMETRO
PRINT_AX:
pushf    ;salvar contexto  
push ax
push bx
push cx
push dx
mov BX, 10
mov cx, 0
DIVIDINDO_POR_10:
MOV DX,0
div BX ;comando para dividir
push DX; empilha o resto da divisao
inc CX; incrementa o cx que esta sendo utilizado como contador
cmp AX, 0
jne DIVIDINDO_POR_10 ; logica para dar loop ate zerar a divisao
IMPRESSAO:
pop DX ;desempilha DX
mov AH, 2 ;comandos para impressao
add DL, 48 ; para imprimir o numero correto
int 21h ; imprimindo
dec CX 
cmp CX, 0 ; decrementando contador ate zerar 
jne IMPRESSAO
pop dx
pop cx ; restaurar contexto
pop bx 
pop ax
popf
ret 


;13/10
PULA_LINHA:                       
pushf
push ax
push dx
MOV AH,2  ; socorro, destruiram ax
MOV DL,13          
INT 21H
MOV AH,2  ; socorro, destruiram ax
MOV DL,10
INT 21H
pop dx          
pop ax
popf
RET            


; BX ==> STRING (OFFSET)

IMPRIME_STRING: 
    pushf
    push ax 
    push bx
    push dx
BUSCA_IMPRIME_STRING:  
  
    MOV DL,[BX] 
    CMP DL,0   
    JE  SAIDA_IMPRIME_STRING
    MOV AH,2
    INT 21H 
    INC BX
    JMP BUSCA_IMPRIME_STRING
SAIDA_IMPRIME_STRING:
    pop dx 
    pop bx
    pop ax
    popf
    RET
       
;BX ===> STRING (OFFSET)       
IMPRIME_STRING_INT21H: 
    pushf
    push ax
    push dx
    push bx  
    mov ah,9
    mov dx,bx
    int 21h
    pop bx
    pop dx
    pop ax
    popf
    RET           
    

digiteSubstring db "ENTRE COM UMA SUBSTRING",0
digiteString db "ENTRE COM UMA STRING",0
substring db tam+1 dup(" ") ;tam+1 dup(" ")                     
string db tam+1 dup(" ")
msgSubstring db "SUBSTRING ",0
msgEncontrada db " ENCONTRADA",0
msgNaoEncontrada db " NAO ENCONTRADA",0