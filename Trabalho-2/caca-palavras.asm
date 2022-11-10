INCLUDE "emu8086.inc"

TAMANHO EQU 32

org 100h

DEFINE_GET_STRING
DEFINE_PRINT_STRING

    MOV DI, OFFSET PALAVRA
    MOV DX, TAMANHO + 1
    CALL GET_STRING
   
    MOV SI, OFFSET PALAVRA
    CALL PULA_LINHA  
    CALL PULA_LINHA
    
    CALL IMPRIME_MATRIZ
    

    
    ;MOV DI, OFFSET INICIO_A                                  
    ;CALL PROCURA_ESQUERDA_DIREITA
    ;CALL RESETA_COR_LIN_COL
    ;CALL GET_STRING
         
    ;MOV DI, OFFSET INICIO_A
    ;CALL PROCURA_CIMA_BAIXO
    ;CALL RESETA_COR_LIN_COL
    ;CALL GET_STRING
    
    ;MOV COL, 39
    ;MOV LIN, 9
    ;MOV DI, OFFSET INICIO_B
    ;CALL PROCURA_DIREITA_ESQUERDA
    ;CALL RESETA_COR_LIN_COL
    ;CALL GET_STRING
    
    ;MOV COL, 39
    ;MOV LIN, 9
    ;MOV DI, OFFSET INICIO_B
    ;CALL PROCURA_BAIXO_CIMA
    CALL RESETA_COR_LIN_COL
    ;CALL GET_STRING
    
    MOV DI, OFFSET INICIO_A
    INC DI                  ;TEM QUE COMECAR LOGO NA PRIMEIRA LETRA
    CALL PROCURA_DIAGONAL
    
    
    CALL PULA_LINHA                                  
     

    MOV AH,4CH
    MOV AL, 0
    INT 21H


;PROCURA_DIAGONAL

PROCURA_DIAGONAL:
    PUSHF  
    PUSH DX
PROCURANDO_DIAGONAL_IGUAIS:
    MOV DL, [SI]
    MOV DH, [DI]
    CMP DH, 0
    JE CONTABILIZA_ACERTOS_PROCURA_DIAGONAL
    CMP DH,DL
    JE ENCONTROU_INICIO_PROCURANDO_DIAGONAL
    CMP DH, 40h
    JE FIM_LINHA_PROCURA_DIAGONAL
    MOV SI, OFFSET PALAVRA
    INC DI                
    INC COL
    JMP PROCURANDO_DIAGONAL_IGUAIS
ENCONTROU_INICIO_PROCURANDO_DIAGONAL:
    INC COR    
    CALL VERIFICA_CIMA
    CALL VERIFICA_DIAGONAL_SUPERIOR_DIREITA
    CALL VERIFICA_DIREITA
    CALL VERIFICA_DIAGONAL_INFERIOR_DIREITA
    CALL VERIFICA_BAIXO
    CALL VERIFICA_DIAGONAL_INFERIOR_ESQUERDA
    CALL VERIFICA_ESQUERDA
    CALL VERIFICA_DIAGONAL_SUPERIOR_ESQUERDA
    INC COL
    INC DI
    MOV SI, OFFSET PALAVRA
    JMP PROCURANDO_DIAGONAL_IGUAIS

FIM_LINHA_PROCURA_DIAGONAL:
    INC LIN
    MOV COL, 0
    MOV SI, OFFSET PALAVRA
    ADD DI, 2
    JMP PROCURANDO_DIAGONAL_IGUAIS

CONTABILIZA_ACERTOS_PROCURA_DIAGONAL:
    CMP VEZES_ENCONTRADAS, 0
	JE NENHUM_ACERTO_PROCURA_DIAGONAL
	JMP FIM_PROCURA_DIAGONAL
	
NENHUM_ACERTO_PROCURA_DIAGONAL:
	MOV AH,2
    MOV DL,"N"
    INT 21H
	JMP FIM_PROCURA_DIAGONAL
ALGUM_ACERTO_PROCURA_DIAGONAL:
	MOV AH,2
    MOV DL,"S"
    INT 21H
FIM_PROCURA_DIAGONAL:
    POP DX
    POPF
    RET

; VERIFICACAO DIAGONAL

VERIFICA_DIAGONAL_SUPERIOR_DIREITA:
    push di
    push si
    push dx
    push bx
    MOV BH, LIN
    MOV BL, COL
    VERIFICANDO_DIAGONAL_SUPERIOR_DIREITA:
    CALL IMPRIME_COR_LIN_COL
    DEC LIN
    INC COL
    INC SI   
    SUB DI, 41
    MOV DL, [SI]
    MOV DH, [DI]
    CMP DL, 0
    JE  ACHOU_SUBSTRING_PROCURA_DIAGONAL:
    CMP DH, DL
    JE VERIFICANDO_DIAGONAL_SUPERIOR_DIREITA
    JMP FIM_VERIFICACAO
    
VERIFICA_DIAGONAL_INFERIOR_DIREITA:
    push di
    push si
    push dx  
    push bx
    MOV BH, LIN
    MOV BL, COL
    VERIFICANDO_DIAGONAL_INFERIOR_DIREITA:
    CALL IMPRIME_COR_LIN_COL
    INC LIN
    INC COL
    INC SI   
    ADD DI, 43
    MOV DL, [SI]
    MOV DH, [DI]
    CMP DL, 0
    JE  ACHOU_SUBSTRING_PROCURA_DIAGONAL:
    CMP DH, DL
    JE VERIFICANDO_DIAGONAL_INFERIOR_DIREITA
    JMP FIM_VERIFICACAO
    
VERIFICA_DIAGONAL_INFERIOR_ESQUERDA:
    push di
    push si
    push dx    
    push bx
    MOV BH, LIN
    MOV BL, COL
    VERIFICANDO_DIAGONAL_INFERIOR_ESQUERDA:
    CALL IMPRIME_COR_LIN_COL
    INC LIN
    DEC COL
    INC SI   
    ADD DI, 41
    MOV DL, [SI]
    MOV DH, [DI]
    CMP DL, 0
    JE  ACHOU_SUBSTRING_PROCURA_DIAGONAL:
    CMP DH, DL
    JE VERIFICANDO_DIAGONAL_INFERIOR_ESQUERDA
    JMP FIM_VERIFICACAO
    
VERIFICA_DIAGONAL_SUPERIOR_ESQUERDA:
    push di
    push si
    push dx    
    push bx
    MOV BH, LIN
    MOV BL, COL
    VERIFICANDO_DIAGONAL_SUPERIOR_ESQUERDA:
    CALL IMPRIME_COR_LIN_COL
    DEC LIN
    DEC COL
    INC SI   
    SUB DI, 43
    MOV DL, [SI]
    MOV DH, [DI]
    CMP DL, 0
    JE  ACHOU_SUBSTRING_PROCURA_DIAGONAL:
    CMP DH, DL
    JE VERIFICANDO_DIAGONAL_SUPERIOR_ESQUERDA
    JMP FIM_VERIFICACAO

; ~VERIFICACAO HORIZONTAL
    
VERIFICA_ESQUERDA:
    push di
    push si
    push dx    
    push bx
    MOV BH, LIN
    MOV BL, COL
    VERIFICANDO_ESQUERDA:
    CALL IMPRIME_COR_LIN_COL
    DEC COL
    INC SI   
    DEC DI
    MOV DL, [SI]
    MOV DH, [DI]
    CMP DL, 0
    JE  ACHOU_SUBSTRING_PROCURA_DIAGONAL:
    CMP DH, DL
    JE VERIFICANDO_ESQUERDA
    JMP FIM_VERIFICACAO

VERIFICA_DIREITA:
    push di
    push si
    push dx    
    push bx
    MOV BH, LIN
    MOV BL, COL
    VERIFICANDO_DIREITA:
    CALL IMPRIME_COR_LIN_COL
    INC COL
    INC SI   
    INC DI
    MOV DL, [SI]
    MOV DH, [DI]
    CMP DL, 0
    JE  ACHOU_SUBSTRING_PROCURA_DIAGONAL:
    CMP DH, DL
    JE VERIFICANDO_DIREITA
    JMP FIM_VERIFICACAO

; VERIFICACAO VERTICAL
    
VERIFICA_CIMA:
    push di
    push si
    push dx    
    push bx
    MOV BH, LIN
    MOV BL, COL
    VERIFICANDO_CIMA:
    CALL IMPRIME_COR_LIN_COL
    DEC LIN
    INC SI   
    SUB DI, 42
    MOV DL, [SI]
    MOV DH, [DI]
    CMP DL, 0
    JE  ACHOU_SUBSTRING_PROCURA_DIAGONAL:
    CMP DH, DL
    JE VERIFICANDO_CIMA
    JMP FIM_VERIFICACAO  
    
VERIFICA_BAIXO:
    push di
    push si
    push dx    
    push bx
    MOV BH, LIN
    MOV BL, COL
    VERIFICANDO_BAIXO:
    CALL IMPRIME_COR_LIN_COL
    INC LIN
    INC SI   
    ADD DI, 42
    MOV DL, [SI]
    MOV DH, [DI]
    CMP DL, 0
    JE  ACHOU_SUBSTRING_PROCURA_DIAGONAL:
    CMP DH, DL
    JE VERIFICANDO_BAIXO
    JMP FIM_VERIFICACAO  

ACHOU_SUBSTRING_PROCURA_DIAGONAL:
    INC VEZES_ENCONTRADAS
    CALL IMPRIME_RESULTADO    

FIM_VERIFICACAO:
    MOV LIN, BH
    MOV COL, BL
    pop bx
    pop dx
    pop si
    pop di
    RET
;-------------------------------

NAVEGA_ATE_FINAL:
    pushf
    push dx    
    
NAVEGACAO_ATE_FINAL:
    MOV DL, [DI]
    CMP DL, 40H ;@
    JE FIM_NAVEGA_ATE_FINAL:
    INC DI
    JMP NAVEGACAO_ATE_FINAL
    
FIM_NAVEGA_ATE_FINAL:
    pop dx
    popf
    RET

;-------------------------------

IMPRIME_MATRIZ:
    pushf
    push ax
    push dx    
    
    MOV AH, 2
    MOV DI, OFFSET INICIO_A
    
COMECA_LINHA_IMPRIME_MATRIZ:
    INC DI
    MOV DL,[DI]
    CMP DL, 40h  ;@
    JE FIM_LINHA_IMPRIME_MATRIZ
    CMP DL, 2Ah ;*
    JE FIM_IMPRIME_MATRIZ
    INT 21h
    JMP COMECA_LINHA_IMPRIME_MATRIZ

FIM_LINHA_IMPRIME_MATRIZ:
    CALL PULA_LINHA
    INC DI
    JMP COMECA_LINHA_IMPRIME_MATRIZ 

FIM_IMPRIME_MATRIZ:    
    pop dx        
    pop ax
    popf
    RET

;-------------------------------

IMPRIME_COR_LIN_COL:
    pushf
    push ax
    push bx 
    push cx
    push dx    
    
    MOV BH, 0
    MOV DH, LIN
    MOV DL, COL
    MOV AH, 2
    INT 10h     ; MOVE CURSOR
    
    pop dx
    MOV AL, DH
    MOV AH, 9
    MOV CX, 1
    MOV BL, COR
    INT 10h
         
    pop cx
    pop bx
    pop ax
    popf
    RET
    
;-------------------------------

IMPRIME_RESULTADO:
    push ax
    push bx       
    push cx
    push dx
     
    MOV CH, LIN
    MOV CL, COL
    
    MOV COL, 0
    MOV BL, LIN_RES     ;BACKUP
    MOV LIN, BL 
    
    MOV DH, LIN
    MOV DL, COL
    MOV BH, 0
    MOV AH, 2
    INT 10h
     
    MOV BX, OFFSET CABECALHO
    CALL IMPRIME_STRING    
    MOV DH, 219

    MOV COL, 33
    MOV BL, LIN_RES     ;BACKUP
    MOV LIN, BL 
    
    CALL IMPRIME_COR_LIN_COL
    CALL PULA_LINHA
    
    INC LIN_RES
    
    MOV LIN, CH
    MOV COL, CL
    
    pop dx 
    pop cx
    pop bx 
    pop ax
    RET
    
;-------------------------------

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

;-------------------------------
                                
RESETA_COR_LIN_COL:
    MOV COR, 5
    MOV LIN, 2
    MOV COL, 0

;-------------------------------                                
                                
PULA_LINHA:                      
    pushf
    push ax
    push dx
    MOV AH,2
    MOV DL,13        
    INT 21h
    MOV AH,2
    MOV DL,10
    INT 21h
    pop dx        
    pop ax
    popf
    RET 
    
;--------------------------------

PALAVRA DB TAMANHO DUP(" "),0  

                                                       
;use qualquer marcador                                                          
;fixo 10x40
         DB 0,"#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$@"
INICIO_A DB   "!MSJDFLKASJDKFLJSADKLFJAKLSJDFKLASJDFKJSM@"
         DB   "!AIJDFLKASJDKFLJSADKLFJAKLSJDFKLASJDFKJII@"
         DB   "!ALGKDFJKLASDJFLKSAJDKFLJSADKLFJLKDSAJGLG@"
         DB   "!ASJUFLKASMIGUELJSADKLFJAKLSJDFKLESJMUKJU@"
         DB   "!ALLKELDFASDDJFLKSAJDKFLJSADKLFJLKUSEJFLE@"
         DB   "!ASEDELKASJDKFLJSADKLFJAKLSJDFKLASJGGKJSL@"
         DB   "!ALUUDFJKLASDJFLKSAJDKFLJSADKLFJLKDSIJFLK@"
         DB   "!ASGDFLKASJDKFLJSADKLFJAKLSJDFKLASJDEMJSA@"
         DB   "!AIIKDFJKLASDJFLKSAJDKFLJSALEUGIMKDSLJFLK@"
INICIO_B DB   "!MSMDFLKASJDKFLJSADKLFJAKLSJDFKLASJDFKJSA@"
         DB   "*****************************************#",0
         

LIN 	DB 0
COL 	DB 0
COR 	DB 0
LIN_RES DB 13    
VEZES_ENCONTRADAS DB 0
CABECALHO DB "A PALAVRA FOI ENCONTRADA NA COR: ",0             
