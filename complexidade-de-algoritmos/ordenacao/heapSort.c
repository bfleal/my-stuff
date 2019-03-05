#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<time.h>

void max_heapify(int *,int);
void build_max_heap(int *,int);
void heapsort(int *,int);
void swap(int*,int*);
int heapsize;

void main(int argc, char **argv){
	int *arr, i, n=atoi(argv[1]);
        clock_t timeIni=0, timeFim=0;

	FILE *arq = fopen(strcat(argv[0],"Results.txt"), "a");   
	arr=(int *)malloc(sizeof(int)*n);
	srand(time(NULL));

	for(i=0; i<n; i++) arr[i] = rand();     //aleatório
	//for(i=0; i<n; i++) arr[i] = i+1;      //ordem crescente
	//for(i=0; i<n; i++) arr[i] = n-i;      //ordem decrescente
	
	timeIni = clock();
        heapsort(arr,n);
	timeFim = clock();

	//for(i=0; i<n; i++) printf("%d\t",arr[i]);
	printf("Entrada(n): %d\tTempo de execucao(s): %lf\n", n, (double)(timeFim-timeIni)/CLOCKS_PER_SEC);
	fprintf(arq,"Entrada(n): %d\tTempo de execucao(s): %lf\n", n, (double)(timeFim-timeIni)/CLOCKS_PER_SEC);

	fclose(arq);
}

void heapsort(int *arr,int len){
	int i;
	
	build_max_heap(arr,len);
	for(i= len-1;i>=1;i--){
		swap(&arr[0],&arr[i]);
        	heapsize = heapsize-1;
        	max_heapify(arr,0);
    	}
}

void max_heapify(int *arr,int i){
	int l=2*i,r=2*i+1,largest;

	if(l<heapsize && arr[l]>arr[i]) largest = l;
	else largest = i;

	if(r<heapsize && arr[r]>arr[largest]) largest = r;

	if(largest != i){
		swap(&arr[i],&arr[largest]);
        	max_heapify(arr,largest);
    	}
}

void build_max_heap(int *arr,int len){
	int i;

	heapsize = len;
	for(i =len/2;i>=0;i--) max_heapify(arr,i);
}

void swap(int *a ,int *b){
    int temp = *a;

    *a= *b;
    *b= temp;
}
