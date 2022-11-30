INCLUDE "emu8086.inc"

TAMANHO EQU 32

org 100h

DEFINE_GET_STRING
DEFINE_PRINT_STRING
                     
                     
AGUARDA_INPUT:
	CALL CLEAN_SCREEN
    CALL RESETA_COR_LIN_COL
	
    CALL IMPRIME_MATRIZ
    CALL RESETA_COR_LIN_COL
	CALL IMPRIME_LOG
        
	CALL GET_PALAVRA
    MOV DI, OFFSET INICIO_A	; Posiciona comeco da busca
    INC DI                  ; TEM QUE COMECAR LOGO NA PRIMEIRA LETRA
    CALL PROCURA_DIAGONAL
    CALL IMPRIME_LOG_FINALIZOU           
    MOV DX, TAMANHO + 1    
    CALL GET_STRING

	MOV LIN_RES, 0
	ADD IND_PALAVRA, 2

    CALL RESETA_COR_LIN_COL

	push ax
	CALL GET_PALAVRA
	MOV AX, [SI]
	CMP AX,0
	JE FINALIZA_PROGRAMA
	JMP AGUARDA_INPUT                                     
   
	; FINALIZA O PROGRAMA
FINALIZA_PROGRAMA:
	CALL CLEAN_SCREEN
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
    CALL GET_PALAVRA
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
    CALL GET_PALAVRA
    JMP PROCURANDO_DIAGONAL_IGUAIS

FIM_LINHA_PROCURA_DIAGONAL:
    INC LIN
    MOV COL, 0
    CALL GET_PALAVRA
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
    SUB DI, 21
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
    ADD DI, 23
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
    ADD DI, 21
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
    SUB DI, 23
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
    SUB DI, 22
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
    ADD DI, 22
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
	push bx
    push dx    
    
	MOV BH, 0	;PAGINA
	MOV DH, 0	;LINHA
	MOV DL, 0	;COLUNA
	MOV AH, 2	;OPERACAO
	INT 10h		;POSICIONA CURSOR
	
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
	pop bx
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

IMPRIME_LOG:
    push ax
    push bx       
    push cx
    push dx
    push si
	
    MOV DH, 0
    MOV DL, 25
    MOV BH, 0
    MOV AH, 2
    INT 10h
     
    MOV BX, OFFSET TEXTO1
    CALL IMPRIME_STRING    
    
	MOV BX, IND_PALAVRA
	MOV BX, PONTEIRO_PALAVRAS[BX]
    CALL IMPRIME_STRING    
    
	CALL PULA_LINHA
    
    INC LIN_RES
    
    
	pop si
    pop dx 
    pop cx
    pop bx 
    pop ax
    RET


;-------------------------------
IMPRIME_RESULTADO:
    push ax
    push bx       
    push cx
    push dx
     
    MOV CH, LIN
    MOV CL, COL
    
    MOV COL, 25
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

    MOV COL, 58
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
    MOV COR, 2
    MOV LIN, 0
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

GET_PALAVRA:
	push bx
	;DEVE POSICIONAR EM PALAVRA O ENDERECO DA PALAVRA A SER BUSCADA
	
	MOV BX, IND_PALAVRA
	MOV SI, PONTEIRO_PALAVRAS[BX]
	
	pop bx
	RET

;--------------------------------  

IMPRIME_LOG_FINALIZOU:
	push ax
    push bx       
    push cx
    push dx
    push si
	
    MOV DH, LIN_RES
    MOV DL, 25
    MOV BH, 0
    MOV AH, 2
    INT 10h
     
    MOV BX, OFFSET TEXTO2
    CALL IMPRIME_STRING    
      
    INC LIN_RES
    
	pop si
    pop dx 
    pop cx
    pop bx 
    pop ax
    RET

;--------------------------------

CLEAN_SCREEN:
    push ax
    push bx 
    push cx
    push dx  

	MOV LIN, 0
		
LOOP_CLEAN_SCREEN:
	MOV BH, 0	;PAGINA
	MOV DH, LIN	;LINHA
	MOV DL, 0	;COLUNA
	MOV AH, 2	;OPERACAO
	INT 10h		;POSICIONA CURSOR
	
	MOV AL, 32
	MOV BH, 0
	MOV BL, 7
	MOV CX, 80
	MOV AH, 9
	INT 10h
	
	CMP LIN, 24
	JE FINALIZA_CLEAN_SCREEN
	INC LIN
	JMP LOOP_CLEAN_SCREEN
	
FINALIZA_CLEAN_SCREEN:
	
	MOV BH, 0	;PAGINA
	MOV DH, 0	;LINHA
	MOV DL, 0	;COLUNA
	MOV AH, 2	;OPERACAO
	INT 10h		;POSICIONA CURSOR
	

    pop dx
    pop cx
    pop bx
    pop ax	
	RET	

PALAVRA DB "YY",0  
INPUT   DB TAMANHO DUP(" "),0
                                                       
;use qualquer marcador                                                          
;fixo 10x40
  		 DB 0,"#$$$$$$$$$$$$$$$$$$$$@"
INICIO_A DB   "!DIDOIROTAROBALTEACET@"
		 DB   "!OACARTSINIMDAMLEATLE@"
		 DB   "!FETPRONTOSOCORROEOEL@"
		 DB   "!TOUTITDTSOIEPOOOOMTE@"
		 DB   "!DAEGANDADORSSNVBMORF@"
		 DB   "!EAMTNLGEVREEIMIIAGOO@"
		 DB   "!ETEBEAORIEPOCAETIRCN@"
		 DB   "!REASUNSOFRLAOVTONAAE@"
		 DB   "!ELLVOLOEISAELDNFJFRV@"
		 DB   "!CUSAMTAHDRINOEAAEIDP@"
		 DB   "!EMRHDMETCOOIGTTRCAIO@"
		 DB   "!PCAIAOAMONALOMIMAJOL@"
		 DB   "!CAICDDSAERASEOSAOEGT@"
		 DB   "!IPCSSCERIRILUVICASRR@"
		 DB   "!OEAIIMEETOGOMFVIRTAO@"
		 DB   "!NLAUECESGPDEEUSAADMN@"
		 DB   "!IADDENISUAMSNTSNMNAA@"
		 DB   "!SETIRRTLARSQCCCEAERA@"
		 DB   "!TMTSANAETTCERAIACRAO@"
INICIO_B DB   "!AARMASMRGOOTGIEAARTT@"
		 DB   "*********************#",0
         

LIN 	DB 0
COL 	DB 0
COR 	DB 0
LIN_RES DB 0    
IND_PALAVRA DW 0
VEZES_ENCONTRADAS DB 0
CABECALHO   DB "A PALAVRA FOI ENCONTRADA NA COR: ",0             
TEXTO1      DB "PROCURANDO PALAVRA ",0
TEXTO2		DB "PROCURA FINALIZADA",0                    
         
PONTEIRO_PALAVRAS DW P0,P1,P2,P3,P4,P5,P6,P7,P8,P9,P10,P11,P12,P13,P14,P15,P16,P17,P18,P19,P20,P21,P22,P23,P24,P25,P26,P27,P28

P0  DB "ADMINISTRACAO",0
P1  DB "AMBULATORIO",0
P2  DB "ANDADOR",0
P3  DB "CAMA",0
P4  DB "CAPELA",0
P5  DB "COPEIRO",0
P6  DB "ELETROCARDIOGRAMA",0
P7  DB "ELEVADOR",0
P8  DB "EMERGENCIA",0
P9  DB "FARMACIA",0
P10 DB "INJECAO",0
P11 DB "LABORATORIO",0
P12 DB "LANCHONETE",0
P13 DB "MACA",0
P14 DB "MULETA",0
P15 DB "PACIENTE",0
P16 DB "PARTO",0
P17 DB "POLTRONA",0
P18 DB "PRONTOSOCORRO",0
P19 DB "PSICOLOGO",0
P20 DB "RECEITA",0
P21 DB "RECEPCIONISTA",0
P22 DB "TELEFONE",0
P23 DB "TOMOGRAFIA",0
P24 DB "TRANSFUSAODESANGUE",0
P25 DB "VELORIO",0
P26 DB "VISITANTE",0
P27 DB "OBITO",0 
P28 DB 0  ; INDICADOR DE FIM DE PALAVRAS...TEM QUE PROCURAR


