#include <stdio.h>
#include <stdlib.h>

//Definindo o registro que representará cada elemento da árvore AVL
typedef struct Arvore{
	int num, altD, altE;
	struct Arvore *dir, *esq;
}ARVORE;

ARVORE *rotacaoEsquerda(ARVORE *aux);
ARVORE *rotacaoDireita(ARVORE *aux);
ARVORE *balanceamento(ARVORE *aux);
ARVORE *criarNo(int num);
ARVORE *inserir(ARVORE *aux, int num);
ARVORE *remover(ARVORE *aux, int num);
ARVORE *atualiza(ARVORE *aux);
ARVORE *esvaziar(ARVORE *aux);
int consultar(ARVORE *aux, int num, int achou);
void consultarOrdem(ARVORE *aux);
void consultarPreOrdem(ARVORE *aux);
void consultarPosOrdem(ARVORE *aux);

void main(){
	int opcao, achou, numero;
	ARVORE *raiz = NULL, *aux = NULL;
	
	do{
		printf("\n\n\nMENU DE OPCOES\n");
		printf("\n1 - Inserir na arvore");
		printf("\n2 - Consultar um no da arvore");
		printf("\n3 - Consultar toda a arvore em ordem");
		printf("\n4 - Consultar toda a arvore em pre-ordem");
		printf("\n5 - Consultar toda a arvore em pos-ordem");
		printf("\n6 - Excluir um no da arvore");
		printf("\n7 - Esvaziar a arvore");
		printf("\n8 - Sair");
		printf("\nDigite sua opcao: ");
		scanf("%d", &opcao);
		
		switch(opcao){
			case 1:
				system("cls");
				printf("\nDigite o numero a ser inserido na arvore: ");
				scanf("%d", &numero);
				
				raiz = inserir(raiz, numero);
				
				printf("\nO numero %d foi inserido na arvore!", numero);
				break;
			case 2:
				system("cls");
				//a árvore está vazia
				if(raiz == NULL) printf("\nArvore vazia!");
				//a árvore contém elementos
				else{
					printf("\nDigite o elemento a ser consultado: ");
					scanf("%d", &numero);
					
					achou = 0;
					achou = consultar(raiz, numero, achou);
					
					if(achou == 0) printf("\nO numero %d nao foi encontrado na arvore!", numero);
					else printf("\nO numero %d foi encontrado na arvore!", numero);
				}
				break;
			case 3:
				system("cls");
				//a árvore está vazia
				if(raiz == NULL) printf("\nArvore vazia!");
				//a árvore contém elementos e estes serão mostrados em ordem
				else{
					printf("\nListando todos os elementos da arvore em ordem: ");
					consultarOrdem(raiz);
				}
				break;
			case 4:
				system("cls");
				//a árvore está vazia
				if(raiz == NULL) printf("\nArvore vazia!");
				//a árvore contém elementos e estes serão mostrados em pré-ordem
				else{
					printf("\nListando todos os elementos da arvore em pre-ordem: ");
					consultarPreOrdem(raiz);
				}
				break;
			case 5:
				system("cls");
				//a árvore está vazia
				if(raiz == NULL) printf("\nArvore vazia!");
				//a árvore contém elementos e estes serão mostrados em pós-ordem
				else{
					printf("\nListando todos os elementos da arvore em pos-ordem: ");
					consultarPosOrdem(raiz);
				}
				break;
			case 6:
				system("cls");
				if(raiz == NULL) printf("\nArvore vazia!");
				else{
					printf("\nDigite o numero que deseja excluir: ");
					scanf("%d", &numero);
					
					achou = 0;
					achou = consultar(raiz, numero, achou);
					
					if(achou == 0) printf("\nO numero %d nao foi encontrado na arvore!", numero);
					else{
						raiz = remover(raiz, numero);
						raiz = atualiza(raiz);
						printf("\nO numero %d foi excluido da arvore!", numero);
					}
				}
				break;
			case 7:
				system("cls");
				if(raiz == NULL) printf("\nArvore vazia!");
				else{
					raiz = esvaziar(raiz);
					printf("\nArvore esvaziada!");
				}
				break;
			case 8:
				system("cls");
				printf("\nPrograma encerrado...\n");
				break;
			default:
				printf("\nOpcao invalida!");
				break;
		}
	}while(opcao != 8);
	
	raiz = esvaziar(raiz);	
}

ARVORE *rotacaoEsquerda(ARVORE *aux){
	ARVORE *aux1, *aux2;
	
	aux1 = aux->dir;
	aux2 = aux1->esq;
	aux->dir = aux2;
	aux1->esq = aux;
	
	if(aux->dir == NULL) aux->altD = 0;
	else if(aux->dir->altE > aux->dir->altD) aux->altD = aux->dir->altE + 1;
	else aux->altD = aux->dir->altD + 1;
	
	if(aux1->esq->altE > aux1->esq->altD) aux1->altE = aux1->esq->altD + 1;
	else aux1->altE = aux1->esq->altD + 1;
	
	return aux1;
}

ARVORE *rotacaoDireita(ARVORE *aux){
	ARVORE *aux1, *aux2;
	
	aux1 = aux->esq;
	aux2 = aux1->dir;
	aux->esq = aux2;
	aux1->dir = aux;
	
	if(aux->esq == NULL) aux->altE = 0;
	else if(aux->esq->altE > aux->esq->altD) aux->altE = aux->esq->altE + 1;
	else aux->altE = aux->esq->altD + 1;
	
	if(aux1->dir->altE > aux1->dir->altD) aux1->altD = aux1->dir->altE + 1;
	else aux1->altD = aux1->dir->altD + 1;
	
	return aux1;
}

ARVORE *balanceamento(ARVORE *aux){
	int d, df;
	
	d = aux->altD - aux->altE;
	
	if(d == 2){
		df = aux->dir->altD - aux->dir->altE;
		if(df >= 0) aux = rotacaoEsquerda(aux);
		else{
			aux->dir = rotacaoDireita(aux->dir);
			aux = rotacaoEsquerda(aux);
		}
	}else if(d == -2){
		df = aux->esq->altD - aux->esq->altE;
		if(df <= 0) aux = rotacaoDireita(aux);
		else{
			aux->esq = rotacaoEsquerda(aux->esq);
			aux = rotacaoDireita(aux);
		}
	}
	
	return aux;
}

ARVORE *criarNo(int num){
	ARVORE *novo = (ARVORE*)malloc(sizeof(ARVORE));
	
	novo->num = num;
	novo->altD = 0;
	novo->altE = 0;
	novo->esq = NULL;
	novo->dir = NULL;

	return novo;
}

ARVORE *inserir(ARVORE *aux, int num){
	//O objetivo novo é um objeto auxiliar
	ARVORE *novo;
	
	
	if(aux == NULL){
		novo = criarNo(num);
		aux = novo;
	}else if(num < aux->num){
		aux->esq = inserir(aux->esq, num);
		if(aux->esq->altD > aux->esq->altE) aux->altE = aux->esq->altD + 1;
		else aux->altE = aux->esq->altE + 1;
		
		aux = balanceamento(aux);
	}else{
		aux->dir = inserir(aux->dir, num);
		if(aux->dir->altD > aux->dir->altE) aux->altD = aux->dir->altD + 1;
		else aux->altD = aux->dir->altD + 1;
		
		aux = balanceamento(aux);
	}
	
	return aux;
}

ARVORE *remover(ARVORE *aux, int num){
	ARVORE *p, *p2;
	
	if(aux->num == num){
		//o elemento a ser removido não tem filhos
		if(aux->esq == aux->dir){
			free(aux);
			return NULL;
		//o elemento a ser removido não tem filho para a esquerda
		}else if(aux->esq == NULL){
			p = aux->dir;
			free(aux);
			
			return p;
		//o elemento a ser removido não tem filho para a direita
		}else if(aux->dir == NULL){
			p = aux->esq;
			free(aux);
			
			return p;
		//o elemento a ser removido tem filho para ambos os lados
		}else{
			p2 = aux->dir;
			p = aux->dir;
			
			while(p->esq != NULL) p = p->esq;
			
			p->esq = aux->esq;
			free(aux);
			
			return p2;
		}
	}else if(aux->num < num) aux->dir = remover(aux->dir, num);
	else aux->esq = remover(aux->esq, num);
	
	return aux;
}

ARVORE *atualiza(ARVORE *aux){
	if(aux != NULL){
		aux->esq = atualiza(aux->esq);
		
		if(aux->esq == NULL) aux->altE = 0;
		else if(aux->esq->altE > aux->esq->altD) aux->altE = aux->esq->altE + 1;
		else aux->altE = aux->esq->altD + 1;
		
		aux->dir = atualiza(aux->dir);
		
		if(aux->dir == NULL) aux->altD = 0;
		else if(aux->dir->altE > aux->dir->altD) aux->altD = aux->dir->altE + 1;
		else aux->altD = aux->dir->altD + 1;
		
		aux = balanceamento(aux);
	}
	
	return aux;
}

ARVORE *esvaziar(ARVORE *aux){
	if(aux != NULL){
		aux->esq = esvaziar(aux->esq);
		aux->dir = esvaziar(aux->dir);
		
		free(aux);
	}
	
	
}

int consultar(ARVORE *aux, int num, int achou){
	if(aux != NULL  && achou == 0){
		if(aux->num == num) achou = 1;
		else if(num < aux->num) achou = consultar(aux->esq, num ,achou);
		else achou = consultar(aux->dir, num, achou);
	}
	
	return achou;
}

void consultarOrdem(ARVORE *aux){
	if(aux != NULL){
		consultarOrdem(aux->esq);
		printf("%d ", aux->num);
		consultarOrdem(aux->dir);
	}
}

void consultarPreOrdem(ARVORE *aux){
	if(aux != NULL){
		printf("%d ", aux->num);
		consultarPreOrdem(aux->esq);
		consultarPreOrdem(aux->dir);
	}
}

void consultarPosOrdem(ARVORE *aux){
	if(aux != NULL){
		consultarPosOrdem(aux->esq);
		consultarPosOrdem(aux->dir);
		printf("%d ", aux->num);
	}
}
