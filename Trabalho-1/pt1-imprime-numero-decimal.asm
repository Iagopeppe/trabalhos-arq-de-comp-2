mov AX, VAR1
mov CX, 10

DIVIDE: 
div CX

push DX
xor DX, DX
inc BX

cmp AL, 0
je IMPRESSAO
jmp DIVIDE

IMPRESSAO: 
pop DX

add DX, 48
mov AH, 2
int 33

dec BX
cmp BX, 0
je FIM_IMPRESSAO
jmp IMPRESSAO
ret 

FIM_IMPRESSAO: 
ret 



VAR1 dw 60213