#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

// Declarations of the two functions you will implement
// Feel free to declare any helper functions or global variables
void printPuzzle(char** arr);
void searchPuzzle(char** arr, char* word);
int bSize;

void upperCase(char* word){
    for (int i = 0; i < strlen(word); i++) {
        if (*(word + i) > 90) {
            *(word + i) -= 32;
        }
    }
}

void printArray(int **arr){
    for (int i = 0; i < bSize; i++){
        for (int j = 0; j < bSize; j++){
            printf("%d \t", *(*(arr + i) + j));
        }
        printf("\n");
    }
}

void arrZero2D(int** arr){
    for (int i = 0; i < bSize; i++){
        *(arr + i) = (int*)malloc(bSize * sizeof(int));
		for (int j = 0; j < bSize; j++){
			*(*(arr + i) + j) = 0;
		}
	}
}

void arrInsert(int** arr, int iter, int i, int j){
    if (*(*(arr + i) + j) > 0) {
        int temp = (*(*(arr + i) + j)) * pow(10, (int)log10(iter)+1) + iter;
        *(*(arr + i) + j) = temp;
    }
    else {
        *(*(arr + i) + j) = iter;
    }
}

int finder(char** arr, int** arr2, char* word, int iter, int len, int x, int y) {
    if (len == iter){ 
        return 1; 
    }
    else {
        char letter = *(word + iter); int maxX = bSize, maxY = bSize, minX = 0, minY = 0; 
        if (x - 1 > 0) minX = x - 1;    // setting min and max of x and y to bSize and 
        if (x + 1 < bSize) maxX = x + 1;
        if (y - 1 > 0) minY = y - 1;
        if (y + 1 < bSize) maxY = y + 1;

        if (maxX == bSize){
            maxX--;
        }
        if (maxY == bSize){
            maxY--;
        }

        for (int i = minY; i <= maxY; i++){
            for (int j = minX; j <= maxX; j++){
                if (letter == *(*(arr + i) + j) && ((j != x) + (i != y) != 0)){
                    iter++;
                    if (finder(arr, arr2, word, iter, len, j, i) == 1){
                        arrInsert(arr2, iter, i, j);
                        return 1;
                    } 
                    else {
                        iter--;
                    }
                }
            }
        }
        return 0;
    }
}


// Main function, DO NOT MODIFY
int main(int argc, char **argv) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <puzzle file name>\n", argv[0]);
        return 2;
    }
    int i, j;
    FILE *fptr;

    // Open file for reading puzzle
    fptr = fopen(argv[1], "r");
    if (fptr == NULL) {
        printf("Cannot Open Puzzle File!\n");
        return 0;
    }

    // Read the size of the puzzle block
    fscanf(fptr, "%d\n", &bSize);

    // Allocate space for the puzzle block and the word to be searched
    char **block = (char**)malloc(bSize * sizeof(char*));
    char *word = (char*)malloc(20 * sizeof(char));

    // Read puzzle block into 2D arrays
    for(i = 0; i < bSize; i++) {
        *(block + i) = (char*)malloc(bSize * sizeof(char));
        for (j = 0; j < bSize - 1; ++j) {
            fscanf(fptr, "%c ", *(block + i) + j);
        }
        fscanf(fptr, "%c \n", *(block + i) + j);
    }
    fclose(fptr);

    printf("Enter the word to search: ");
    scanf("%s", word);

    // Print out original puzzle grid
    printf("\nPrinting puzzle before search:\n");
    printPuzzle(block);

    // Call searchPuzzle to the word in the puzzle
    searchPuzzle(block, word);

    return 0;
}

void printPuzzle(char** arr) {
	// This function will print out the complete puzzle grid (arr).
    // It must produce the output in the SAME format as the samples
    // in the instructions.
    // Your implementation here...

    for (int i = 0; i < bSize; i++){
        for (int j = 0; j < bSize; j++){
            printf("%c ", *(*(arr + i) + j));
        }
        printf("\n");
    }
    printf("\n");
}

void searchPuzzle(char** arr, char* word) {
    // This function checks if arr contains the search word. If the
    // word appears in arr, it will print out a message and the path
    // as shown in the sample runs. If not found, it will print a
    // different message as shown in the sample runs.
    // Your implementation here...

    upperCase(word);

    int **arr2 = (int**)malloc(bSize * sizeof(int*));
    arrZero2D(arr2);

    for (int i = 0; i < bSize; i++){
        for (int j = 0; j < bSize; j++){
            if (*word == *(*(arr + i) + j) ){
                *(*(arr2 + i) + j) = 1;
                if (finder(arr, arr2, word, 1, strlen(word), j, i) == 1) {
                    printf("Word found! \nPrinting the search path:\n");
                    printArray(arr2);
                    return;
                }
                else {
                    for (int i = 0; i < bSize; i++){
		                for (int j = 0; j < bSize; j++){
			                *(*(arr2 + i) + j) = 0;
		                }
	                }
                }
            }
        }
    }
    printf("Word not found!\n");
}