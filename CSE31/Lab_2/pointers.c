#include <stdio.h> 
 
int main() { 
    int x, y, *px, *py; 
    int arr[10]; 
    
    /*
    printf("%d\n", x);
    printf("%d\n", y);
    printf("%d\n", arr[0]);

    printf("%d\n", x);
    printf("%d\n", y);
    printf("%d\n", arr[2]);
    */
    x = 0, y = 1; for (int i = 0; i < 10; i++){ arr[i] = i; }

    printf("%p\n", &x);
    printf("%p\n", &y);

    px = &x;
    py = &y;
    printf("%d\n", *px);
    printf("%d\n", *py);
    printf("%p\n", px);
    printf("%p\n", py);

    int* a = arr;
    for (int i = 0; i < 10; i++){
        printf("%d\n", *a);
        *a++;
    }

    printf("%d\n", *arr);

    printf("%p\n", &arr);

    return 0; 
}