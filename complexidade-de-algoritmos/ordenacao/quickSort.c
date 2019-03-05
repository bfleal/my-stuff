#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

int particao(int*, int, int);
void quickSort(int*, int, int);

void main(int argc, char **argv){
	int *vet, i, n = atoi(argv[1]);
	clock_t timeIni=0, timeFim=0;

	FILE *arq = fopen(strcat(argv[0], "Results.txt"), "a");
	vet = (int*)malloc(n*sizeof(int));
	srand(time(NULL));
	
	printf("%d\n",n);
	//for(i=0; i<n; i++) vet[i] = rand();	//aleatório
	for(i=0; i<n; i++) vet[i] = i+1;	//ordem crescente
	//for(i=0; i<n; i++) vet[i] = n-i;	//ordem decrescente

	timeIni = clock();
	quickSort(vet, 0, n);
	timeFim = clock();
	
	//for(i=0; i<n; i++) printf("%d\t",vet[i]);

	fprintf(arq,"Entrada(n): %d\tTempo de execucao(s): %lf\n", n, (double)(timeFim-timeIni)/CLOCKS_PER_SEC);
	
	fclose(arq);
}

int particao(int *arranjo, int inicio, int fim){
	int ultimoElemento, i, j, aux;
	
	ultimoElemento = arranjo[fim-1];
	i = inicio - 1;
	
	for(j=inicio; j<fim-1; j++){
		if(arranjo[j] <= ultimoElemento){
			i++;
			aux = arranjo[i];
			arranjo[i] = arranjo[j];		
			arranjo[j] = aux;
		}
	}
	
	arranjo[fim-1] = arranjo[i+1];
	arranjo[i+1] = ultimoElemento;
	
	return i+1;	
}

void quickSort(int *arranjo, int inicio, int fim){
	int meio = 0;
	 
	if(inicio < fim){
		meio = particao(arranjo, inicio, fim);
		quickSort(arranjo, inicio, meio);
		quickSort(arranjo, meio+1, fim);	
	}
}
