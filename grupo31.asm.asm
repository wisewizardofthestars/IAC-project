; *********************************************************************************
; * IST-UL
; * Projeto de IAC
; * Descrição:  Código responsável pela totalidade do projeto.
; * Trabalho por: Maria João Rosa(102506) e Sara Pinheiro(102507)
; * Contactos: maria.j.rosa@tecnico.ulisboa.pt
; *			   sara.pinheiro@tecnico.ulisboa.pt
; *********************************************************************************

; *********************************************************************************
; * Constantes
; *********************************************************************************
DEFINE_LINHA    		EQU 600AH       ; endereço do comando para definir a linha
DEFINE_COLUNA   		EQU 600CH       ; endereço do comando para definir a coluna
DEFINE_PIXEL    		EQU 6012H       ; endereço do comando para escrever um pixel
APAGA_AVISO     		EQU 6040H       ; endereço do comando para apagar o aviso de nenhum cenário selecionado
APAGA_ECRÃ	 			EQU 6002H       ; endereço do comando para apagar todos os pixels já desenhados
SELECIONA_CENARIO_FUNDO EQU 6042H       ; endereço do comando para selecionar uma imagem de fundo
SELECIONA_AUDIO 		EQU 605CH		; endereço do comando para selecionar o áudio em LOOP
SELECIONA_SOM 			EQU 605AH		; endereço do comando para selecionar o som da tecla
PARA_SOM  				EQU 6066H		; endereço do comando para parar o som da tecla
SELECIONA_CENARIO       EQU 6004H		; endereço do comando para selecionar a layer	
SELECIONA_CENARIO_FRONTAL EQU 6046H		; endereço do comando para selecionar o cenário na layer superior
APAGA_CENÁRIO_FRONTAL 	EQU 6044H		; endereço do comando para apagar o cenário na layer superior

DISPLAYS		EQU  0A000H	; endereço do periférico que liga aos displays
TEC_LIN			EQU  0C000H	; endereço das linhas do teclado (periférico POUT-2)
TEC_COL			EQU  0E000H	; endereço das colunas do teclado (periférico PIN)
LINHA_TECLADO	EQU 	8	; linha a testar (4ª linha, 1000b)
MASCARA			EQU		0FH	; para isolar os 4 bits de menor peso, ao ler as colunas do teclado
TECLA_C			EQU 	1	; tecla na primeira coluna do teclado (tecla C)
TECLA_D			EQU 	2	; tecla na segunda coluna do teclado (tecla D)

; Teclado - linhas do teclado
LINHA_1					EQU 1			
LINHA_2					EQU 2
LINHA_3					EQU 4
LINHA_4					EQU 8
; colunas do teclado
COLUNA_1				EQU 1			
COLUNA_2				EQU 2
COLUNA_3				EQU 4
COLUNA_4				EQU 8


N_BONECOS			EQU  4		; número de meteoros


; Posição Inicial do Rover
LINHA        			EQU  28         ; linha do rover (a meio do ecrã) 16
COLUNA					EQU  31         ; coluna do rover (a meio do ecrã) 30


; Posição Inicial do Asteroide
COLUNA_AST_0			EQU 4   		; coluna do asteroide, O valor não interessa
COLUNA_AST_1			EQU 4   		; coluna do asteroide, O valor não interessa
COLUNA_AST_2			EQU 4   		; coluna do asteroide, O valor não interessa
COLUNA_AST_3			EQU 4   		; coluna do asteroide, O valor não interessa

; Limites do Ecrã
MIN_COLUNA				EQU  0			; número da coluna mais à esquerda que o objeto pode ocupar
MAX_COLUNA				EQU  63        	; número da coluna mais à direita que o objeto pode ocupar
MAX_LINHA 				EQU  31		; numero da linha mais em baixo que o asteroide pode ocupar

; Atraso
ATRASO					EQU	00AFH		; atraso para limitar a velocidade de movimento do rover

; Rover - constantes
LARGURA					EQU	5			; largura do rover
ALTURA 					EQU 4			; altura do rover
COR_AZUL 				EQU 0F0FFH 		; azul claro
COR_MENTA 				EQU 0F7FAH		; verde menta
COR_LAVANDA 			EQU 0FCBFH		; lavanda
COR_AMARELO 			EQU 0FFF8H		; amarelo
COR_VERMELHO			EQU 0CF66H	
COR_YELLOW				EQU 0CFF6H

; Meteoros - cores
COR_1					EQU	0CFAAH		; cores dos pixeis em ARGB (opaco, vermelho, verde e azul)
COR_2					EQU 0FF8BH 
COR_3					EQU 0CF9EH
COR_4					EQU 0CF48H
COR_S					EQU	8FD6H
COR_B					EQU	0F000H
COR_R					EQU 0FF46H
COR_C					EQU 0C777H

; dimensões dos asteroide 
DIM_AST_5				EQU 5		; dimensões do asteroide 5x5
DIM_AST_4				EQU 4		; dimensões do asteroide 4x4
DIM_AST_3 			    EQU 3		; dimensões do asteroide 3x3
DIM_AST_2				EQU 2		; dimensões do asteroide 2x2
DIM_AST_1				EQU 1		; dimensões do asteroide 1x1


; Cor dos meteoros bons
COR_11 EQU 0C6DFH ; azul claro
COR_12 EQU 0C98FH ; roxo claro
COR_13 EQU 0C90FH ; roxo escuro

;linhas iniciais dos meteoros
LINHA_AST_0 EQU 0 ; a linha dos meteoros começa a 0
LINHA_AST_1 EQU 4; linha do meteoro
LINHA_AST_2 EQU 6; linha do meteoro
LINHA_AST_3 EQU 2; linha do meteoro

; coordenadas iniciais do missil
LINHA_MISSIL EQU 0
COLUNA_MISSIL EQU 0

; display
ATUAL EQU 100
RESET EQU 100

;input
ACAO EQU 0
TECLA_CARREGADA EQU 0

; *********************************************************************************
; * Dados 
; *********************************************************************************
	PLACE       1000H

; Reserva do espaço para as pilhas dos processos
	STACK 100H			; espaço reservado para a pilha do processo "programa principal"
SP_inicial_prog_princ:		; este é o endereço com que o SP deste processo deve ser inicializado
							
	STACK 100H			; espaço reservado para a pilha do processo "teclado"
SP_inicial_teclado:			; este é o endereço com que o SP deste processo deve ser inicializado
							
; SP inicial de cada processo meteoro
	STACK 100H			; espaço reservado para a pilha do processo "meteoro", instância 0
SP_inicial_boneco_0:		; este é o endereço com que o SP deste processo deve ser inicializado

	STACK 100H			; espaço reservado para a pilha do processo "meteoro", instância 1
SP_inicial_boneco_1:		; este é o endereço com que o SP deste processo deve ser inicializado
							
	STACK 100H			; espaço reservado para a pilha do processo "meteoro", instância 2
SP_inicial_boneco_2:		; este é o endereço com que o SP deste processo deve ser inicializado
							
	STACK 100H			; espaço reservado para a pilha do processo "meteoro", instância 3
SP_inicial_boneco_3:		; este é o endereço com que o SP deste processo deve ser inicializado

	STACK 100H			; espaço reservado para a pilha do processo "rover"
SP_inicial_rover:

	STACK 100H			; espaço reservado para a pilha do processo "missil"
SP_inicial_missil:

	STACK 100H			; espaço reservado para a pilha do processo "display"
SP_inicial_display:

; tabela com os SP iniciais de cada processo meteoro
boneco_SP_tab:
	WORD	SP_inicial_boneco_0
	WORD	SP_inicial_boneco_1
	WORD	SP_inicial_boneco_2
	WORD	SP_inicial_boneco_3

;coordenadas do missil que se irão alterar
DEF_LINHA_MISSIL:
	WORD LINHA_MISSIL
DEF_COLUNA_MISSIL:
	WORD COLUNA_MISSIL


; tabela que define o rover (cor, largura, pixels)
DEF_ROVER:					
	WORD LARGURA
	WORD ALTURA
	WORD 0, 0, COR_AMARELO, 0, 0 						; primeira linha
	WORD COR_MENTA, 0, COR_AZUL, 0, COR_MENTA			; segunda linha
	WORD COR_AMARELO, COR_LAVANDA ,COR_MENTA ,COR_LAVANDA ,COR_AMARELO  ; terceira linha
	WORD 0, COR_LAVANDA, 0, COR_LAVANDA, 0 				; quarta linha
	     
; tabela que define as posições dos meteoros
POS_AST_COLUNA:
	WORD COLUNA_AST_0		; 
	WORD COLUNA_AST_1
	WORD COLUNA_AST_2
	WORD COLUNA_AST_3

POS_AST_LINHA:
	WORD LINHA_AST_0 		; linha do asteroide para ser mudada começam
	;todas iguais a zero
	WORD LINHA_AST_1
	WORD LINHA_AST_2
	WORD LINHA_AST_3

; definição da coluna do rover que ira mudar
POS_ROVER:
	WORD COLUNA

DEF_ASTEROIDE_1_5:    	; tabela que define o asteróide 1 5x5(cor, largura, pixel)
	WORD DIM_AST_5 		; largura dos asteroide
	WORD DIM_AST_5 		; altura do asteroide
	WORD COR_2, COR_1, 0, COR_1, COR_2			; primeira linha
	WORD COR_3, COR_1, COR_1, COR_1, COR_3		; segunda linha
	WORD COR_R, COR_B, COR_S, COR_B, COR_R		; terceira linha
	WORD COR_3, COR_S, COR_S, COR_S, COR_3		; quarta linha
	WORD 0, COR_3, COR_4, COR_3, 0				; quinta linha  

DEF_ASTEROIDE_1_4: ; tabela que define o asteroide 1 4x4
	WORD DIM_AST_4 ; largura do asteroide
	WORD DIM_AST_4 ; altura do asteroide
	WORD COR_3, 0, 0, COR_3
	WORD COR_2, COR_2,  COR_2, COR_2
	WORD COR_B, COR_2,  COR_2, COR_B
	WORD COR_R, COR_3,  COR_3, COR_R

DEF_ASTEROIDE_1_3: ;tabela que define o asteroide 1 3x3
	WORD DIM_AST_3 ; largura do asteroide
	WORD DIM_AST_3 ; altura do asteroide
	WORD COR_3, 0, COR_3
	WORD COR_B, COR_2, COR_B
	WORD COR_R, COR_2, COR_R


DEF_ASTEROIDE_2_5:	;define o meteoro 2 5x5
	WORD DIM_AST_5
	WORD DIM_AST_5
	WORD COR_12, COR_13, COR_11, COR_13, COR_12
	WORD COR_13, COR_B, COR_11, COR_B, COR_13
	WORD COR_11, COR_11, COR_12, COR_11, COR_11
	WORD COR_13, COR_12, COR_11, COR_12, COR_13
	WORD COR_12, COR_13, COR_11, COR_13, COR_12

DEF_ASTEROIDE_2_4: 	;define o meteoro 2 4x4
	WORD DIM_AST_4
	WORD DIM_AST_4
	WORD COR_11, COR_13, COR_13, COR_11
	WORD COR_13, COR_11, COR_11, COR_13
	WORD COR_B, COR_13, COR_13, COR_B
	WORD COR_11, COR_12, COR_12, COR_11

DEF_ASTEROIDE_2_3: 	; define o meteoro 2 3x3
	WORD DIM_AST_3
	WORD DIM_AST_3
	WORD COR_11, COR_13, COR_11
	WORD COR_12, COR_12, COR_12
	WORD COR_11, COR_13, COR_11



DEF_ASTEROIDE_2:	; tabela que define qualquer um dos meteoros 2x2
	WORD DIM_AST_2 ; largura do asteroide
	WORD DIM_AST_2 ; altura do asteroide
	WORD COR_C, COR_C
	WORD COR_C, COR_C

DEF_ASTEROIDE_1:	; tabela que define qualquer um dos meteoros 1x1
	WORD DIM_AST_1
	WORD DIM_AST_1
	WORD COR_C


;tabela que define o missil
DEF_MISSIL:
    WORD DIM_AST_1
    WORD DIM_AST_1
    WORD COR_MENTA    

;tabela que define o desenho da explosão de colisão meteoro x missil
DEF_EXPLOSAO:
	WORD DIM_AST_5
	WORD DIM_AST_5
	WORD COR_VERMELHO, 0, COR_VERMELHO, 0, COR_VERMELHO
	WORD 0, COR_VERMELHO, COR_YELLOW, COR_VERMELHO, 0
	WORD COR_VERMELHO, COR_YELLOW, COR_VERMELHO, COR_YELLOW, COR_VERMELHO
	WORD COR_VERMELHO, 0, COR_VERMELHO, 0, COR_VERMELHO
	WORD 0, COR_VERMELHO, COR_YELLOW, COR_VERMELHO, 0

; tabela que define o input
DEF_INPUT:
	WORD ACAO
	WORD TECLA_CARREGADA   

; tabela que define o display
DEF_DISPLAY:
	WORD ATUAL
	WORD RESET   
                              
; Tabela das rotinas de interrupção
tab:
	WORD rot_int_0			; rotina de atendimento da interrupção 0
	WORD rot_int_1
	WORD rot_int_2
	
evento_int_bonecos:			; LOCKs para cada rotina de interrupção comunicar ao processo
						; boneco respetivo que a interrupção ocorreu
	LOCK 0				; LOCK para o asteróide 1
	LOCK 0				; LOCK para o asteróide 2
	LOCK 0				; LOCK para o asteróide 3
	LOCK 0				; LOCK para o asteróide 4
		
evento_int_rover:   ; lock para o rover
    LOCK 0

evento_int_missil:	; lock para o missil
    LOCK 0

evento_int_display:	; lock para o display
	LOCK 0

jogo_ativo:		; lock para o jogo ativo
	LOCK 0                             

; *********************************************************************************
; * Código
; *********************************************************************************
PLACE   0                     ; o código tem de começar em 0000H
inicio:
	MOV  SP, SP_inicial_prog_princ		; inicializa SP do programa principal
                            
	MOV  BTE, tab			; inicializa BTE (registo de Base da Tabela de Exceções)

     MOV  [APAGA_AVISO], R1	; apaga o aviso de nenhum cenário selecionado (o valor de R1 não é relevante)
     MOV  [APAGA_ECRÃ], R1	; apaga todos os pixels já desenhados (o valor de R1 não é relevante)
	MOV	R1, 0			; cenário de fundo número 0
     MOV  [SELECIONA_CENARIO_FUNDO], R1	; seleciona o cenário de fundo
	MOV	R7, 1			; valor a somar à coluna do boneco, para o movimentar
	 MOV [SELECIONA_AUDIO], R1
	MOV R8, 100
	CALL hexa_para_dec		; transforma hexadecimal em decimal
	MOV [DISPLAYS], R9 		; inicializa os displays a 0
	MOV R1, 3
	MOV [SELECIONA_CENARIO_FRONTAL], R1	; seleciona o cenário da layer frontal
     
	EI0					; permite interrupções 0
	EI1					; permite interrupções 1
	EI2					; permite interrupções 2
	
	EI					; permite interrupções (geral)
						; a partir daqui, qualquer interrupção que ocorra usa
						; a pilha do processo que estiver a correr nessa altura

	MOV  R2, TEC_LIN		; endereço do periférico das linhas
	MOV  R3, TEC_COL		; endereço do periférico das colunas
	MOV  R5, MASCARA		; para isolar os 4 bits de menor peso, ao ler as colunas do teclado


inicia_jogo:
	MOV R1, LINHA_4
	CALL tecla
	CMP R0, LINHA_1
	JNZ inicia_jogo

processos:
	MOV [APAGA_CENÁRIO_FRONTAL], R0		; apaga o cenário da layer frontal
	CALL display
	CALL 	ciclo_rover			; cria o processo rover

	MOV	R11, N_BONECOS		; número de bonecos a usar (até 4)
loop_bonecos:
	SUB	R11, 1			; próximo boneco
	CALL	meteoro			; cria uma nova instância do processo meteoro (o valor de R11 distingue-as)
						; Cada processo fica com uma cópia independente dos registos
	CMP  R11, 0			; já criou as instâncias todas?
     JNZ	loop_bonecos		; se não, continua


; o resto do programa principal é também um processo (neste caso, trata do teclado)
PROCESS SP_inicial_teclado	; indicação de que a rotina que se segue é um processo,
						; com indicação do valor para inicializar o SP

teclado:					; processo que implementa o comportamento do teclado
	MOV  R2, TEC_LIN		; endereço do periférico das linhas
	MOV  R3, TEC_COL		; endereço do periférico das colunas
	MOV  R5, MASCARA		; para isolar os 4 bits de menor peso, ao ler as colunas do teclado

init_linha:

	WAIT				; este ciclo é potencialmente bloqueante, pelo que tem de
						; ter um ponto de fuga (aqui pode comutar para outro processo)

	MOV R1, LINHA_1			; inicializa na primeira linha
	MOV R4, DEF_INPUT

espera_tecla:				; neste ciclo espera-se até uma tecla ser premida

;	WAIT				; este ciclo é potencialmente bloqueante, pelo que tem de
						; ter um ponto de fuga (aqui pode comutar para outro processo)

	CALL tecla
	CMP R0, 0			; há tecla premida?
	JZ prox_linha		; se nenhuma tecla premida, muda de linha
	MOV [R4], R1
	ADD R4, 2
	MOV	[R4], R0	; informa quem estiver bloqueado neste LOCK que uma tecla foi carregada
							; (o valor escrito é o número da coluna da tecla no teclado)
	JMP menu


espera_nao_tecla:			; espera até NÃO existir nenhuma tecla premida

	YIELD

	CALL tecla			
	CMP	R0, 0
	JNZ	espera_nao_tecla	; espera enquanto houver uma tecla carregada
	MOV R10, DEF_INPUT
	MOV R11, 0
	MOV [R10], R11
	ADD R10, 2
	MOV [R10], R11
	JMP espera_tecla

prox_linha:					; muda a linha a procurara
	MOV R6, MASCARA
	SHL R1, 1				; aumenta o número da linha a testar
	AND R6, R1				
	CMP R6, 0				; se o número for maior que 8, o resultado desta comparação será 0
	JNZ espera_tecla		; continua a procura se a linha for válida
	JMP init_linha			; reinicializa as linhas se não o for

tecla:
	MOVB [R2], R1      ; escrever no periférico de saída (linhas)
	MOVB R0, [R3]      ; ler do periférico de entrada (colunas)
	AND  R0, R5        ; elimina bits para além dos bits 0-3
	RET

menu:						;determina se a tecla pressionada é relacionada com o menu
	MOV R8, [DEF_INPUT]
	MOV R10, LINHA_4
	CMP R8, R10
	JNZ espera_nao_tecla

opcao_menu:					;determina qual a opção
	MOV R8, DEF_INPUT
	ADD R8, 2
	MOV R9, [R8]
	CMP R9, COLUNA_1
	JZ novo_jogo
	CMP R9, COLUNA_2
	JZ pausa
	CMP R9, COLUNA_3
	JZ acaba_jogo
	
	JMP espera_nao_tecla

novo_jogo:							; reseta todos os registos e posições
	MOV [APAGA_ECRÃ], R0
	MOV R8, 100
	CALL hexa_para_dec
	MOV [DISPLAYS], R9

	MOV R1, LINHA_MISSIL
	MOV [DEF_LINHA_MISSIL], R1

	MOV R1, COLUNA_MISSIL
	MOV [DEF_COLUNA_MISSIL], R1
	
	MOV R1, COLUNA_AST_0
	MOV R2, POS_AST_COLUNA
	MOV [R2], R1

	ADD R2, 2
	MOV R1, COLUNA_AST_1
	MOV [R2], R1

	ADD R2, 2
	MOV R1, COLUNA_AST_2
	MOV [R2], R1

	ADD R2, 2
	MOV R1, COLUNA_AST_3
	MOV [R2], R1

	MOV R1, COLUNA
	MOV [POS_ROVER], R1

	MOV R1, LINHA_AST_0
	MOV R2, POS_AST_LINHA
	MOV [R2], R1

	ADD R2, 2
	MOV R1, LINHA_AST_1
	MOV [R2], R1

	ADD R2, 2
	MOV R1, LINHA_AST_2
	MOV [R2], R1

	ADD R2, 2
	MOV R1, LINHA_AST_3
	MOV [R2], R1

	MOV R1, ACAO
	MOV R2, DEF_INPUT
	MOV [R2], R1

	ADD R2, 2
	MOV R1, TECLA_CARREGADA
	MOV [R2], R1

	MOV R1, ATUAL
	MOV R2, DEF_DISPLAY
	MOV [R2], R1

	JMP teclado


pausa:								;para as interrupções, pausando o jogo
	DI0
	DI1
	DI2
	DI
	MOV R10, 2
	MOV [SELECIONA_CENARIO_FRONTAL], R10

para:
	MOV R1, LINHA_4
	CALL tecla			
	CMP	R0, 0
	JNZ	para

espera:
	MOV R1, LINHA_4
	CALL tecla
	CMP R0, COLUNA_2
	JNZ espera

despausa:								; acaba a pausa
    MOV  [APAGA_CENÁRIO_FRONTAL], R1	; seleciona o cenário de fundo
	EI0
	EI1
	EI2
	EI
	JMP teclado


acaba_jogo:								;acaba o jogo
	MOV [APAGA_ECRÃ], R1
	MOV R1, 1
	MOV [SELECIONA_CENARIO_FUNDO], R1
	
fim:
	JMP fim

; **********************************************************************
; ROT_INT_2 
;  	Rotina de atendimento da interrupção 2
;			Faz simplesmente uma escrita no LOCK que o processo display lê.
;			Como basta indicar que a interrupção ocorreu (não há mais
;			informação a transmitir), basta a escrita em si, pelo que
;			o registo usado, bem como o seu valor, é irrelevante
; **********************************************************************
rot_int_2:
	PUSH R0
	PUSH R3
	MOV R3, evento_int_display	; desbloqueia o processo do display
	MOV [R3], R0
	POP R3
	POP R0
	RFE

; **********************************************************************
; DISPLAYS - Processo que determina a energia do rover
; R2 -> número em hexa
; R1 -> numero em decimal(para pôr no display)
; **********************************************************************
PROCESS SP_inicial_display
display:
	MOV  R1, evento_int_display
	MOV  R3, [R1]		; lê o LOCK desta instância (bloqueia até a rotina de interrupção
						; respetiva escrever neste LOCK)
						; Quando bloqueia, passa o controlo para outro processo
						; Como não há valor a transmitir, o registo pode ser um qualquer
	MOV R0, DISPLAYS        ; endereço do periférico que liga aos displays
	MOV R8, [DEF_DISPLAY]
	SUB R8, 5 
	CALL hexa_para_dec

atualiza_display:
	MOV [R0], R9            ; mostra o valor do contador nos displays
	CMP R8, 0
	JZ acaba_jogo
	MOV [DEF_DISPLAY], R8
	JMP display

hexa_para_dec:				; transforma um número em hexadecimal num decimal que permita a sua correta leitura
	MOV R11, 1000
	MOV R9, 0
	MOV R10, 10

math:
	MOV R2, R8
	MOD R2, R11
	DIV R11, R10
	CMP R11, 0
	JZ end
	DIV R2, R11
	SHL R9, 4
	OR R9, R2
	JMP math

end: RET

; **********************************************************************
; Processo
;
; METEORO - Processo que desenha um meteoro e o move horizontalmente e verticalmente, com
;		 temporização marcada por uma interrupção.
;		 Este processo está preparado para ter várias instâncias (vários
;		 processos serem criados com o mesmo código), com o argumento (R11)
;		 a indicar o número de cada instância. Esse número é usado para
;		 indexar tabelas com informação para cada uma das instâncias,
;		 nomeadamente o valor inicial do SP (que tem de ser único para cada instaância)
;		 e o LOCK que lê à espera que a interrupção respetiva ocorra
;
; Argumentos:   R11 - número da instância do processo (cada instância fica
;				  com uma cópia independente dos registos, com os valores
;				  que os registos tinham na altura da criação do processo.
;				  O valor de R11 deve ser mantido ao longo de toda a vida do processo
;
; **********************************************************************

PROCESS SP_inicial_boneco_0	; indicação de que a rotina que se segue é um processo,
						; com indicação do valor para inicializar o SP
						; NOTA - Como cada processo tem de ter uma pilha única,
						;	    mal comece a executar tem de reinicializar
						; 	    o SP com o valor correto, obtido de uma tabela
						;	    indexada por R11 (número da instância)
						
meteoro:					; processo que implementa o comportamento do meteoro
	MOV  R10, R11			; cópia do nº de instância do processo
	SHL  R10, 1			; multiplica por 2 porque as tabelas são de WORDS
	MOV  R9, boneco_SP_tab	; tabela com os SPs iniciais das várias instâncias deste processo
	MOV	SP, [R9+R10]		; re-inicializa SP deste processo, de acordo com o nº de instância
						; NOTA - Cada processo tem a sua cópia própria do SP
	
	MOV [SELECIONA_CENARIO], R11  ; para mover para cenário novo

meteoro_mild:
	CALL linha_reset	;checks se o meteoro é novo

	; desenha o boneco na sua posição inicial
	MOV R3, POS_AST_LINHA	; linha atual do meteoro
	ADD R3, R10		; R1 é o endereço linha do meteoro
	MOV R1, [R3]	; guarda no registo o valor


	CALL random
	MOV R5, R9	; para guardar o nr random de 0 a 7
	SHL R9, 3   ; para as colunas ficarem espaçadas, R9 é a coluna random
	MOV R2, R9  ; R2 será a coluna do asteroide

    MOV R9, POS_AST_COLUNA  ; guardar a coluna na memória
    ADD R9, R10				; para por na posicao do asteroide correto
    MOV [R9], R2    		; guardar o valor da coluna ig


	MOV R4, DEF_ASTEROIDE_1	; tabela do asteroide

	MOV R7, 1 ; só para não ter a flag a 0

	; para ver se é meteoro bom ou mau
	MOV R9, 0	
	CMP R5, R9	; se for 0 então é bom

	JZ call_pos_checker	; vai chamar a função que poe a tabela do meteoro bom

	MOV R9, 7	
	CMP R5, R9	;se for 1 também é bom
	JZ call_pos_checker	; vai chamar a função que poe a tabela do meteoro bom    
	
	
ciclo_meteoro:

	CMP R7, 0	; se R7 for 0 implica que o movimento foi impedido
	JZ meteoro_mild	;ou seja criar um novo meteoro

	CALL	desenha_boneco		; desenha o boneco a partir da tabela

    
	 
	MOV  R9, evento_int_bonecos
	MOV  R3, [R9+R10]		; lê o LOCK desta instância (bloqueia até a rotina de interrupção
						; respetiva escrever neste LOCK)
						; Quando bloqueia, passa o controlo para outro processo
						; Como não há valor a transmitir, o registo pode ser um qualquer

    
    CALL	apaga_boneco		; apaga o boneco na sua posição corrente

    ADD R1, 1	; faz o meteoro andar mais uma linha

	;guardar em memória
    MOV R3, POS_AST_LINHA
	ADD R3, R10		; R1 é o endereço linha do meteoro
	MOV [R3], R1

    CALL pos_checker_1	; vê a posição e confirma qual a dimensão do meteoro

	CALL testa_ast			; para testar se o asteroide já passou os limites

	; para ver se é meteoro bom ou mau
	MOV R9, 0	
	CMP R5, R9	; se for 0 então é um meteoro bom
	JZ call_pos_checker	; vai chamar a função que poe a tabela do meteoro bom

	MOV R9, 7
	CMP R5, R9	;se for 1 também é bom
	JZ call_pos_checker	; vai chamar a função que poe a tabela do meteoro bom

	MOV R9, [R4]	; dimensão do asteroide
	CMP R9, 1	; se é um asteróide distante tamanho 1
	JZ ciclo_meteoro

	CMP R9, 2; se é um asteróide distante de tamanho 2
	JZ ciclo_meteoro

	JMP colisao_missil	; vê se o missil colide
	CALL colisao_rover	;ve se o rover colide
	
	JMP	ciclo_meteoro		; esta "rotina" nunca retorna porque nunca termina
						; Se se quisesse terminar o processo, era deixar o processo chegar a um RET
    


pos_checker_1:
; vê em que posição está o meteoro mau e põe a tabela da dimensão e características indicadas

	PUSH R8
    MOV R4, DEF_ASTEROIDE_1	; tabela do asteroide
    CMP R1, 3	; se estiver na linha 4 após 3 movimentos torna-se 2x2
    JLE  sai_pos_checker; sai se ainda estiver na linha 3

	MOV R8, 9
	MOV R4, DEF_ASTEROIDE_2 	; tabela 2x2
	CMP R1, 6	;se já estiver no terceiro movimento
	JLE sai_pos_checker
	MOV R4, DEF_ASTEROIDE_1_3	; tabela 3x3
	CMP R1, R8 	; se estiver no 4 movimento
	JLE sai_pos_checker	
	MOV R4, DEF_ASTEROIDE_1_4	; tabela 4x4
	MOV R8, 12
	CMP R1, R8	; 5 movimento
	JLE  sai_pos_checker
	MOV R4, DEF_ASTEROIDE_1_5	; tabela 5x5
    POP R8
    RET
    
sai_pos_checker:
;sai da função pos_checker
    POP R8
	RET

return:
;função que dá return
	RET

linha_reset:

; faz reset à linah caso o meteoro tenha saído do ecrã
	CMP R7, 0; se for 0 implica que é um novo meteoro logo começa na linha 0
	JNZ return		; se não continua com a pos que está na memória
	MOV R3, POS_AST_LINHA
	ADD R3, R10		; R1 é o endereço linha do meteoro
	MOV R8, 0 	;linha 0
	MOV [R3], R8		;inicializar linha a 0 para o novo meteoro

	RET

pos_checker2:
;vê em que posição está o meteoro bom e põe a tabela da dimensão e características indicadas
	PUSH R8
    MOV R4, DEF_ASTEROIDE_1	; tabela do asteroide
    CMP R1, 3	; se estiver na linha 4 após 3 movimentos torna-se 2x2
    JLE  sai_pos_checker; sai se ainda estiver na linha 3

	MOV R8, 9
	MOV R4, DEF_ASTEROIDE_2 	
	CMP R1, 6	;se já estiver no terceiro movimento
	JLE sai_pos_checker
	MOV R4, DEF_ASTEROIDE_2_3
	CMP R1, R8 	; se estiver no 4 movimento
	JLE sai_pos_checker
	MOV R4, DEF_ASTEROIDE_2_4
	MOV R8, 12
	CMP R1, R8	; 5 movimento
	JLE  sai_pos_checker
	MOV R4, DEF_ASTEROIDE_2_5
    POP R8
    RET

call_pos_checker:	; calls pos_checker2
	CALL pos_checker2
	JMP ciclo_meteoro


;************************************************
;FUNÇÃO: colisao_rover
;ARGUMENTOS: R1 É A LINHA DO METEORO  e R2 É A COLUNA
;**************************************************

colisao_rover:
	PUSH R1
	 PUSH R5
	 PUSH R2
	 PUSH R4
	MOV R4, 0	; contador
	MOV R5, LINHA	; linha do rover

break_r:
	ADD R4, 1	; ir aumentando a linha

	CMP R4, 5	; porque o tamanho meteoro é 5
	JZ sai_colisao_r	;para se o contador estiver a 5

	CMP R5, R1	; linha inicial do meteoro
	JZ check_coluna_r	; se estiver na linha certa

	JMP break_r


check_coluna_r:
	; implica que a linha bate certo
	MOV R5, [POS_ROVER]	; coluna do rover
	MOV R4, 0	; contandor

break_check_r:
	ADD R4, 1 ; ir aumentando a coluna
	
	CMP R4, 5	; pq tamanho meteoro é 5
	JZ sai_colisao_r	; não está no sítio certo logo continua

	CMP R5, R2	; comparar coluna do missil com meteoro
	JZ colisao_stop_r 	; fazer perder o jogo

	JMP break_check_r

colisao_stop_r:
;para o jogo quando há colisão rover x meteoro
	POP R4
	POP R2
	POP R5
	POP R1
	CALL acaba_jogo


sai_colisao_r:
; sai da função colisão
	POP R4
	POP R2
	POP R5
	POP R1
	RET
;**********************************************************
;função random
; Retorno - R9 número de 0 a 7
;*************************************

random:
	PUSH R7
	MOV R7, TEC_COL
	MOVB R9, [R7] ; ler do pin para a funçao random
	SHR R9, 5		; para ter os bits corretos
	POP R7
	RET

;***************************************
;PROCESSO: ROVER
; processo que implementa o comportamento do boneco
; desenha o boneco na sua posição inicial
;******************************************

PROCESS SP_inicial_rover 	
ciclo_rover:

	MOV R6, 0
	MOV [SELECIONA_CENARIO], R6 ; seleciona a layer
	
	CALL posicao_rover	; põe os valores da posição nos registos

	CALL atraso	
	CALL desenha_boneco		; desenha o boneco a partir da tabela
	
	MOV  R9, evento_int_rover
	MOV  R3, [R9]		; lê o LOCK desta instância (bloqueia até a rotina de interrupção
						; respetiva escrever neste LOCK)
						; Quando bloqueia, passa o controlo para outro processo
						; Como não há valor a transmitir, o registo pode ser um qualquer

	CALL apaga_boneco

	
	MOV R6, 1	; linha 1 
	MOV R8, [DEF_INPUT]	; nr da linha
	CMP R6, R8 	; se forem iguais então uma tecla na linha 1 foi clicado
	JNZ	ciclo_rover	; se não tiver sido na linha 1 então continua


	MOV R5, DEF_INPUT	; coluna que foi clicada
	ADD R5, 2
	MOV R9, [R5]
	MOV R8, COLUNA_1	; coluna 1

	MOV R6, [POS_ROVER]	;para diminuir a coluna, ou seja andar para a esquerda
	SUB R6, 1	;diminuir em 1 a coluna
	MOV [POS_ROVER], R6	;guardar na memória
	CMP R8, R9	; se forem iguais então a tecla 0 foi clicada
	JZ ciclo_rover	;se tiver sido a tecla 0 então já está

	MOV R8, COLUNA_3	; coluna 3

	ADD R6, 2	; caso seja para andar para a direita coluna aumenta
	MOV [POS_ROVER], R6 	; para guardar na memória
	CMP R8, R9	; caso sejam iguais então a tecla 2 foi clicada
	JZ ciclo_rover	; início do ciclo

	MOV R8, COLUNA_2	; coluna 2

	SUB R6, 1	;caso seja tecla do missil coluna mantém se constante
	MOV [POS_ROVER], R6	; guardar em memória
	CMP R8, R9	; caso sejam iguais então a tecla 1 foi carregada
	JZ call_missil	; irá inicializar o processo missil	

	JMP ciclo_rover
	
call_missil:
	CALL missil	; inicializa o processo missil
	JMP ciclo_rover
;**********************************************
;PROCESSO: MISSIL
;ARGUMENTOS:
;R1 será a linha onde o missil será desenhado
;R2 será a coluna inicial
;**********************************************

PROCESS SP_inicial_missil;
missil:
	
    MOV R2, [POS_ROVER] ;coluna do rover
    ADD R2, 2   ; para ter o meio do rover de onde sai o missil
	
	MOV [DEF_COLUNA_MISSIL], R2 ;guardar em memória
	
    MOV R1, MAX_LINHA   ;para ter a linha máxima do rover
    SUB R1, 5   ; para estar na linha logo antes do rover
	MOV [DEF_LINHA_MISSIL], R1	;guardar em memória

    MOV R4, DEF_MISSIL  ; tabela que define o missil

    MOV R7, 1 ; só para não ter a flag de não desenhar a 0

ciclo_missil:

   CALL desenha_boneco

  
	MOV  R3, [evento_int_missil]		; lê o LOCK desta instância (bloqueia até a rotina de interrupção
						; respetiva escrever neste LOCK)
						; Quando bloqueia, passa o controlo para outro processo
						; Como não há valor a transmitir, o registo pode ser um qualquer
    
    CALL apaga_boneco 
    SUB R1, 1  ; para o missil se movimentar no sentido ascendente
	MOV [DEF_LINHA_MISSIL], R1	;guardar em memória


    CALL testa_missil ; irá testar se o missil já saiu dos limites do ecrã
    ; ou se já embateu com um meteoro 
	

    JMP ciclo_missil

; **********************************************************************
; DESENHA_BONECO - Desenha um boneco na linha e coluna indicadas
;			    com a forma e cor definidas na tabela indicada.
; Argumentos:   R1 - linha
;               R2 - coluna
;               R4 - tabela que define o boneco
;
; **********************************************************************
desenha_boneco:
	CMP R7, 0				; para ver se o movimento foi impedido ou não
	JZ sai_desenha_boneco	; se o movimento foi impedido então não desenha o asteroide
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R4
	PUSH R5
	PUSH R6
	PUSH R7
	PUSH R8 
   
    MOV R5, [R4]			; obtém a largura do boneco MAX - vai ser contador    
    MOV R7 , R2 			; largura para repor mínimo
	
    ADD	R4, 2			; endereço da cor do 1º pixel (2 porque a largura é uma word)
							; neste caso 2 a 2 vai ser a altura
	MOV R6, [R4] 			; pôr o endereço da altura do boneco, MAX de linhas
	

	ADD R4, 2   			; agora vai ter o endereço das cores dos pixeis da primeira linha
	MOV R8, R5				; para saber quantas colunas são


desenha_pixels:       		; desenha os pixels do boneco a partir da tabela
								; R3 está a ser usado para a função de escrever o pixel
	MOV	R3, [R4]			; obtém a cor do próximo pixel do boneco
	CALL escreve_pixel		; escreve cada pixel do boneco
	ADD	R4, 2				; endereço da cor do próximo pixel (2 porque cada cor de pixel é uma word)
    ADD R2, 1               ; próxima coluna
    SUB R5, 1				; menos uma coluna para tratar
    JNZ desenha_pixels      ; continua até percorrer toda a largura do objeto
	MOV R5, R8				; repor a linha
	MOV R2, R7  			; para saber qual a coluna onde se inicia
	ADD R1, 1				; próxima linha
	SUB R6, 1 				; menos uma linha para tratar
	JNZ desenha_pixels 		; continua até percorrer toda as linhas do objeto
	POP R8
	POP R7
	POP R6
	POP	R5
	POP	R4
	POP	R3
	POP	R2
	POP R1
	RET
sai_desenha_boneco:
	RET

; **********************************************************************
; APAGA_BONECO - Apaga um boneco na linha e coluna indicadas
;			  com a forma definida na tabela indicada.
; Argumentos:   R1 - linha
;               R2 - coluna
;               R4 - tabela que define o boneco
;
; **********************************************************************
apaga_boneco:
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R4
	PUSH R5
	PUSH R6
	PUSH R7
	PUSH R8
	MOV	R5, [R4]			; obtém a largura do boneco MAX - vai ser contador
	MOV R7 , R2 			; largura para repor mínimo
	ADD	R4, 2				; endereço da altura, MAX de linhas
	MOV R6, [R4] 			; por o endereço da altura do boneco, MAX de linhas
	MOV R8, R5 				; para saber quantas linhas são

apaga_pixels:       		; desenha os pixels do boneco a partir da tabela
	MOV	R3, 0				; obtém a cor do próximo pixel do boneco
	CALL escreve_pixel	; escreve cada pixel do boneco
    ADD  R2, 1              ; próxima coluna
    SUB  R5, 1				; menos uma coluna para tratar
    JNZ apaga_pixels      	; continua até percorrer toda a largura do objeto
	MOV R5, R8  			; para repor a linha
	MOV R2, R7  			; para saber qual a coluna onde se inicia
	ADD R1, 1				; próxima linha
	SUB R6, 1				; menos uma linha para tratar
	JNZ apaga_pixels 		; continua até percorrer toda as linhas do objeto
	POP R8
	POP R7
	POP R6
	POP	R5
	POP	R4
	POP	R3
	POP	R2
	POP R1
	RET


; **********************************************************************
; ESCREVE_PIXEL - Escreve um pixel na linha e coluna indicadas.
; Argumentos:   R1 - linha
;               R2 - coluna
;               R3 - cor do pixel (em formato ARGB de 16 bits)
;
; **********************************************************************
escreve_pixel:
	MOV  [DEFINE_LINHA], R1		; seleciona a linha
	MOV  [DEFINE_COLUNA], R2		; seleciona a coluna
	MOV  [DEFINE_PIXEL], R3		; altera a cor do pixel na linha e coluna já selecionadas
	RET


; **********************************************************************
; TESTA_AST - Testa se o asteroide chegou ao limite do ecrã e nesse caso
;			   impede o movimento (força R7 a 0)
;
; Argumentos:	[POS_AST_LINHA] - linha em que o objeto está
; **********************************************************************
testa_ast:
	PUSH R5
	PUSH R6
    PUSH R8
	MOV R5, MAX_LINHA 		; R5 será o máximo da linha que o asteroide pode estar

    MOV R8, POS_AST_LINHA   ; endereço da tabela
    ADD R8, R10             ; adicionar o nr de asteoide *2 pq 2 bits da tabela
	MOV R6, [R8]            ;  R6 será a linha atual do asteroide
	ADD R6, 4 				; porque a linha mais baixa está 5 linhas abaixo
	CMP R5, R6 				; vê se o asteroide está na posição máxima
	JGE	sai_testa_limites	; se não estiver então sai da rotina
	JMP impede_movimento 	; se estiverem na mesma posição, o asteroide não se vai mover mais
    JMP sai_testa_limites


;****************************************************
;TESTA_MISSIL - testa se o missil passou dos limites do ecrã
;ARGUMENTOS:
; R2 É A COLUNA R1 LINHA
;**********************************************************

testa_missil:

	PUSH R5
	PUSH R6
    PUSH R8
	MOV R5, 0 		; R5 será o máximo da linha que o asteroide pode estar


	CMP R5, R1 				; vê se o asteroide está na posição máxima
	JLE	sai_testa_limites	; se não estiver então sai da rotina


	JMP impede_movimento 	; se estiverem na mesma posição, o asteroide não se vai mover mais
	
	MOV R8, 4	; tamanho do asteroide
	MOV R5, 3	; nr de meteoros
    JMP sai_testa_limites
	
;***********************************************
;colisão_missil - vê se o missil colide com o meteoro
; argumentos:
;R1, linha do asteroide, R2 coluna do asteroide
; retorna R7 se 0 então impede movimento do meteoro
;********************************************************

colisao_missil:
	PUSH R1
	 PUSH R5
	 PUSH R2
	 PUSH R4
	MOV R4, 0	; contador
	MOV R5, [DEF_LINHA_MISSIL]	; linha do missil

break:
	ADD R4, 1	; ir aumentando a linha

	CMP R4, 6	; pq tamanho meteoro é 5
	JZ sai_colisao

	CMP R5, R1	; linha inicial do meteoro
	JZ check_coluna

	ADD R1, 1	; adicionar uma linha

	JMP break


check_coluna:
	; implica que a linha bate certo
	MOV R5, [DEF_COLUNA_MISSIL]	; coluna do missil
	MOV R4, 0	; contandor

break_check:
	ADD R4, 1 ; ir aumentando a coluna
	
	CMP R4, 6	; pq tamanho meteoro é 5
	JZ sai_colisao	; não está no sítio certo

	CMP R5, R2	; comparar coluna do missil com meteoro
	JZ colisao_stop 	; impedir movimento e fazer explosão

	ADD R2, 1	; adicionar uma linha

	JMP break_check

colisao_stop:
	MOV R4, DEF_EXPLOSAO	; tabela da explosão
	CALL desenha_boneco		; desenha a explosão
	CALL atraso		
	CALL atraso
	;CALL apaga_boneco	; apaga a explosão

	MOV R7, 0 	; flag para impedir o movimento do meteoro
	JMP sai_colisao

sai_colisao:
;sai da colisão_missil
	POP R4
	POP R2
	POP R5
	POP R1
	JMP ciclo_meteoro


; **********************************************************************
; POSICAO_ROVER - Move os valores atuais da posição do rover
;				 para os registo devidos
;
; Argumentos:  R1 - linha
;   		   R2 - coluna
; 			   R4 - tabela que define o rover
; **********************************************************************
posicao_rover:

	     
    MOV  R1, LINHA			; linha do rover, que nunca muda de linha, logo é constante
    MOV  R2, [POS_ROVER]	; coluna do rover, que irá variar
	MOV	R4, DEF_ROVER		; endereço da tabela que define o rover
	RET


; **********************************************************************
; TESTA_LIMITES - Testa se o rover chegou aos limites do ecrã e nesse caso
;			   impede o movimento (força R7 a 0)

; Argumentos:	R2 - coluna em que o objeto está
;				R6 - largura do rover
;				R7 - sentido de movimento do rover (valor a somar à coluna
;				em cada movimento: +1 para a direita, -1 para a esquerda)
;
; Retorna: 		R7 - 0 se já tiver chegado ao limite, inalterado caso contrário	
; **********************************************************************
testa_limites:
	PUSH	R5
	PUSH	R6
    PUSH R8

testa_limite_esquerdo:		; vê se o rover chegou ao limite esquerdo
	MOV	R5, MIN_COLUNA
	MOV R2, [POS_ROVER];
	CMP	R2, R5
	JGT	testa_limite_direito
	CMP	R7, 0				
	JGE	sai_testa_limites
	JMP	impede_movimento	

testa_limite_direito:		; vê se o rover chegou ao limite direito
	ADD	R6, R2				; posição a seguir ao extremo direito do rover
	MOV	R5, MAX_COLUNA
	CMP	R6, R5
	JLE	sai_testa_limites
	CMP	R7, 0				
	JGT	impede_movimento
	JMP	sai_testa_limites

impede_movimento:
	MOV	R7, 0				; impede o movimento, forçando R7 a 0

sai_testa_limites:	
    POP R8
	POP	R6
	POP	R5
	RET
; **********************************************************************
; ROT_INT_0 - 	Rotina de atendimento da interrupção 0
;			Faz simplesmente uma escrita no LOCK que o processo boneco lê.
;			Como basta indicar que a interrupção ocorreu (não há mais
;			informação a transmitir), basta a escrita em si, pelo que
;			o registo usado, bem como o seu valor, é irrelevante
; **********************************************************************
rot_int_0:
	PUSH	R1
	PUSH R3
	MOV  R1, evento_int_bonecos
	MOV	[R1+0], R0	; desbloqueia processo boneco (qualquer registo serve) 
	MOV	[R1+2], R0	; desbloqueia processo boneco (qualquer registo serve) 
	MOV	[R1+4], R0	; desbloqueia processo boneco (qualquer registo serve) 
	MOV	[R1+6], R0	; desbloqueia processo boneco (qualquer registo serve) 


	MOV R3, evento_int_rover
	MOV [R3], R0	; desbloqueia o processo rover
	
	POP R3
	POP	R1
	RFE

; **********************************************************************
; ATRASO - Executa um ciclo para implementar um atraso.
;
; Argumentos:   R11 - valor que define o atraso
; **********************************************************************
atraso:
	PUSH R11
	MOV R11, ATRASO

ciclo_atraso:
	SUB	R11, 1
	JNZ	ciclo_atraso
	POP	R11
	RET


; **********************************************************************
; ROT_INT_1 - 	Rotina de atendimento da interrupção 0
;			Faz simplesmente uma escrita no LOCK que o processo boneco lê.
;			Como basta indicar que a interrupção ocorreu (não há mais
;			informação a transmitir), basta a escrita em si, pelo que
;			o registo usado, bem como o seu valor, é irrelevante
; **********************************************************************
rot_int_1:
	PUSH R2
	MOV R2, evento_int_missil
    MOV [R2], R0 ; desbloqueia processo missil 
	
	POP R2
	RFE


