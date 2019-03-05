#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

//#define n 10

main(int argc, char **argv){
	int n = atoi(argv[1]);
	int i, j, aux, menor, posicaoMenor, *vet;
	clock_t timeIni=0, timeFim=0;

	FILE *arq = fopen(strcat(argv[0], ".txt"), "a");
	vet = (int*)malloc(n*sizeof(int));
	srand(time(NULL));
	
	for(i=0; i<n; i++) vet[i] = rand();	//aleatório
	//for(i=0; i<n; i++) vet[i] = i+1;	//ordem crescente
	//for(i=0; i<n; i++) vet[i] = n-i;	//ordem decrescente
	
	timeIni = clock();
	for(i=0; i<n; i++ ){
		menor = vet[i];
		posicaoMenor = i;	

		for(j=i+1; j<n; j++) 
			if(vet[j] < menor){
				menor = vet[j];
				posicaoMenor = j;
			}

       		vet[posicaoMenor] = vet[i];
		vet[i] = menor;
	}
	timeFim = clock();
	
	//for(i=0; i<n; i++) printf("%d\t", vet[i]);
	
	fprintf(arq,"Entrada(n): %d\tTempo de execucao(s): %lf\n", n, (double)(timeFim-timeIni)/CLOCKS_PER_SEC);

	fclose(arq);
}
