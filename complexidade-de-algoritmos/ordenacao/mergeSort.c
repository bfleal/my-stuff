#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
	
void intercala(int*, int, int, int);
void mergeSort(int*, int, int);
	
void main(int argc, char **argv){
	int *vet, i, n = atoi(argv[1]);
	clock_t timeIni=0, timeFim=0;

	FILE *arq = fopen(strcat(argv[0], "Results.txt"), "a");
	vet = (int*)malloc(n*sizeof(int));	
	srand(time(NULL));
	
	for(i=0; i<n; i++) vet[i] = rand();	//aleatório
	//for(i=0; i<n; i++) vet[i] = i+1;	//ordem crescente
	//for(i=0; i<n; i++) vet[i] = n-i;	//ordem decrescente
	
	timeIni = clock();
	mergeSort(vet, 0, n);
	timeFim = clock();
	
	//for(i=0; i<n; i++) printf("%d\t",vet[i]);

	fprintf(arq,"Entrada(n): %d\tTempo de execucao(s): %lf\n", n, (double)(timeFim-timeIni)/CLOCKS_PER_SEC);

	fclose(arq);
}
	
void intercala(int *arranjo, int inicio, int meio, int fim){
	int i, j, k, *arranjoOrdenado;
	arranjoOrdenado = (int*)malloc((fim-inicio)*sizeof (int));
	
	i = inicio;
	j = meio;                          
	k = 0;          
	
	while(i < meio && j < fim)            
		if(arranjo[i] <= arranjo[j]) arranjoOrdenado[k++] = arranjo[i++]; 
		else arranjoOrdenado[k++] = arranjo[j++];             
	                                   
	while(i < meio) arranjoOrdenado[k++] = arranjo[i++];         
	while(j < fim) arranjoOrdenado[k++] = arranjo[j++];    
	
	for(i=inicio; i < fim; ++i) arranjo[i] = arranjoOrdenado[i-inicio]; 
	free (arranjoOrdenado);                               
}
	
void mergeSort(int *arranjo, int inicio, int fim){
	if (inicio < fim-1) {                 
		int meio = (inicio + fim)/2;          
		mergeSort(arranjo, inicio, meio);     
	  	mergeSort(arranjo, meio, fim);        
	  	intercala(arranjo, inicio, meio, fim); 
	}
}
