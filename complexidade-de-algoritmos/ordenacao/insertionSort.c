#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

void insertionSort(int *, int);
//#define tamanho 10000

void main(int argc, char **argv){
	int n = atoi(argv[1]);
	int i, *vet;
	clock_t timeIni=0, timeFim=0;
	
	FILE *arq = fopen(strcat(argv[0], ".txt"), "a");
	vet = (int*)malloc(n*sizeof(int));
	srand(time(NULL));
	
	for(i=0; i<n; i++) vet[i] = rand(); 	//aleatório
	//for(i=0; i<n; i++) vet[i] = i+1;	//ordem crescente
	//for(i=0; i<n; i++) vet[i] = n-i;	//ordem decrescente

	timeIni = clock();
	insertionSort(vet, n);
	timeFim = clock();
	
	//for(i=0; i<n; i++) printf("%d\t",vet[i]); 
	
	fprintf(arq,"Entrada(n): %d\tTempo de execucao(s): %lf\n", n, (double)(timeFim-timeIni)/CLOCKS_PER_SEC);

	fclose(arq);
}

void insertionSort(int *vetor, int tamanho){
	int contador, aux1, aux2;
	
	for(contador=2; contador<tamanho; contador++){
		aux1 = vetor[contador];
		aux2 = contador - 1;
		
		while(aux2>=0 && vetor[aux2]>aux1){
			vetor[aux2+1] = vetor[aux2];
			aux2 = aux2 - 1;
		}	
		vetor[aux2+1] = aux1;		
	}
}
