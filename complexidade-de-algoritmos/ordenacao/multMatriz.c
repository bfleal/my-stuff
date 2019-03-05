#include <stdio.h>
#include <time.h>

#define n 400

main(){
	int i, j, k;
	int A[n][n], B[n][n], MULT[n][n];
	clock_t timeIni=0, timeFim=0;
	
	for(i=0; i<n; i++)
		for(j=0; j<n; j++)
			A[i][j] = rand()%101;
		
//	for(i=0; i<n; i++){
//		for(j=0; j<n; j++)
//			printf("%d	", A[i][j]);
//		printf("\n");
//	}
	
	printf("\n\n---------------------------------------------------\n\n");
			
	for(i=0; i<n; i++)
		for(j=0; j<n; j++)
			B[i][j] = rand()%101;
			
//	for(i=0; i<n; i++){
//		for(j=0; j<n; j++)
//			printf("%d	", B[i][j]);
//		printf("\n");
//	}
	
	printf("\n\n---------------------------------------------------\n\n");
	
	for(i=0; i<n; i++)
		for(j=0; j<n; j++)
			MULT[i][j] = 0;
	
	timeIni = clock();
		
	for(i=0; i<n; i++)
		for(j=0; j<n; j++)
			for(k=0; k<n; k++)
				MULT[i][j] += A[j][k] * B[k][j];
	
	timeFim = clock();
	
	printf("\n\nTEMPO DE EXECUÇÃO: %lf\n\n", (double)(timeFim-timeIni));

//	for(i=0; i<n; i++){
//		for(j=0; j<n; j++)
//			printf("%d	", MULT[i][j]);
//		printf("\n");
//	}
	
	system("pause");
}
