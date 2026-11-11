#include <stdio.h>
#define tam 5

int CalcularMin(int*,int);
int CalcularMax(int*,int);
int Sumatoria(int*,int);

extern int _minimo(int *arr, int len);
extern int _maximo(int *arr, int len);
extern int _sum(int *arr, int len);

int main()
{
    int arreglo[tam];

    for(int i = 0; i < tam; i++)
    {
        printf("\nValor del elemento[%d]: ",i);
        scanf("%d",&arreglo[i]);
    }

    printf("\nMinimo en C: %d\n",CalcularMin(arreglo,tam));
    printf("Minimo en Ensamblador: %d\n",_minimo(arreglo,tam));

    printf("\nMaximo en C: %d\n",CalcularMax(arreglo,tam));
    printf("Maximo en Ensamblador: %d\n",_maximo(arreglo,tam));

    printf("\nSumatoria en C: %d\n",Sumatoria(arreglo,tam));
    printf("Sumatoria en Ensamblador: %d\n\n",_sum(arreglo,tam));

    return 0;
}

//calcular minimo
int CalcularMin(int *arr, int len)
{
     int min = arr[0];

    for(int i = 0; i < len; i++)
    {

        if(arr[i] < min)
        min = arr[i];

    }

    return min;
}

//calcular maximo
int CalcularMax(int *arr, int len)
{
    int max = arr[0];
    for(int i=0; i < len; i++)
    {
        if(arr[i] > max)
        max = arr[i];

    }

    return max;
}


//calcular sumatoria'
int Sumatoria(int *arr, int len)
{
    int total = 0;

    for(int i = 0; i < len; i++)
    {
        total += arr[i];
    }

    return total;
}






