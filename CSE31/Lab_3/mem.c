
#include <stdio.h>
#include <stdlib.h>
// #include <malloc.h>
#include <stdlib.h>

 int main() {
	int num;
	int *ptr;
	int **handle;

	num = 14;
	ptr = (int *)malloc(2 * sizeof(int));
	*ptr = num;
	handle = (int **)malloc(1 * sizeof(int *));
	*handle = ptr;

	// Insert code here

	printf("num = %d\n", num);
	printf("&num = %d\n", &num);
	
	printf("ptr = %d\n", ptr);
	printf("&ptr = %d\n", &ptr);
	printf("*ptr = %d\n", *ptr);

	printf("handle = %d\n", handle);
	printf("&handle = %d\n", &handle);
	printf("*handle = %d\n", *handle);
	printf("**handle = %d\n", **handle);

	return 0;
} 

