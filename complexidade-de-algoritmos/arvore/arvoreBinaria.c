#include <stdio.h>
#include <stdlib.h>

//Definindo o registro que representará cada elemento da árvore binária
typedef struct Arvore{
	int num;
	struct Arvore *esq, *dir;
}ARVORE;

ARVORE *criaNo(int num);
ARVORE *inserir(ARVORE *aux, int num);
ARVORE *remover(ARVORE *aux, int num);
ARVORE *esvaziar(ARVORE *aux);
int consultar(ARVORE *aux, int num, int achou);
void consultarOrdem(ARVORE *aux);
void consultarPreOrdem(ARVORE *aux);
void consultarPosOrdem(ARVORE *aux);


int main(){
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
						printf("\nO numero %d foi excluido da arvore!", arvore);
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

ARVORE *criaNo(int num){
	ARVORE *novo = (ARVORE*)malloc(sizeof(ARVORE));
	
	novo->num = num;
	novo->dir = NULL;
	novo->esq = NULL;
	
	return novo;
}

ARVORE *inserir(ARVORE *aux, int num){
	if(aux == NULL) aux = criaNo(num);
	else if(num < aux->num) aux->esq = inserir(aux->esq, num);
	else aux->dir = inserir(aux->dir, num);
	
	return aux;
}

ARVORE *remover(ARVORE *aux, int num){
	ARVORE *p, *p2;
	
	if(aux->num == num){
		//o elemento a ser removido não tem fihos
		if(aux->esq == aux->dir){
			free(aux);
			return NULL;
		}
		//o elemento a ser removido não tem filhos para a esquerda
		else if(aux->esq == NULL && aux->dir != NULL){
			p = aux->dir;
			free(aux);
			return p;
		}
		//o elemento a ser removido não tem filhos para a esquerda
		else if(aux->dir == NULL && aux->esq != NULL){
			p = aux->esq;
			free(aux);
			return p;
		}
		//o elemento a ser removido tem filho para ambos os lados
		else{
			p = aux->dir;
			p2 = aux->dir;
			
			while(p->esq != NULL) p = p->esq;
			
			p->esq = aux->esq;
			free(aux);
			return p2;
		}
	}else if(aux->num < num) 
		aux->dir = remover(aux->dir, num);
	else 
		aux->esq = remover(aux->esq, num);
		
	return aux;
}

ARVORE *esvaziar(ARVORE *aux){
	if(aux != NULL){
		aux->esq = esvaziar(aux->esq);
		aux->dir = esvaziar(aux->dir);
		free(aux);
	}
	
	return NULL;
}

int consultar(ARVORE *aux, int num, int achou){
	if(aux != NULL  && achou == 0)
		if(aux->num == num) achou = 1;
		else if(num < aux->num) achou = consultar(aux->esq, num, achou);
		else achou = consultar(aux->dir, num, achou);
		
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
		consultarOrdem(aux->esq);
		consultarOrdem(aux->dir);
	}
}

void consultarPosOrdem(ARVORE *aux){
	if(aux != NULL){
		consultarOrdem(aux->esq);
		consultarOrdem(aux->dir);
		printf("%d ", aux->num);
	}
}
