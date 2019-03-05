#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

void countingSort(int*, int*, int);

void main(int argc, char **argv){
	int *vetInicial, *vetFinal, i, n = atoi(argv[1]);
	clock_t timeIni=0, timeFim=0;

	FILE *arq = fopen(strcat(argv[0], "Results.txt"), "a");
	vetInicial = (int*)malloc(n*sizeof(int));
	vetFinal = (int*)malloc(n*sizeof(int));
	srand(time(NULL));
	
	printf("%d\n",n);
	for(i=0; i<n; i++) vetInicial[i] = rand();	//aleatório
	//for(i=0; i<n; i++) vetInicial[i] = i+1;	//ordem crescente
	//for(i=0; i<n; i++) vetInicial[i] = n-i;	//ordem decrescente

	timeIni = clock();
	countingSort(vetInicial, vetFinal, n);
	timeFim = clock();
	
	//for(i=0; i<n; i++) printf("%d\t",vet[i]);

	fprintf(arq,"Entrada(n): %d\tTempo de execucao(s): %lf\n", n, (double)(timeFim-timeIni)/CLOCKS_PER_SEC);
	
	fclose(arq);
}

void countingSort(int *A, int *B, int n){
	int i, C;
	C = (int*)malloc(n*sizeof(int));

	for(i=0; i<n; i++) C[i] = 0;

	for(i=1; i<n; i++) C[A[i]] = C[A[i]] + 1;

	for(i=2; i<n; i++) C[i] = C[i] + C[i-1];

	for(i=n; i>1; i--){
		B[C[A[j]]] = A[j];
		C[A[j]] = C[A[j]] - 1;
	}	
}
