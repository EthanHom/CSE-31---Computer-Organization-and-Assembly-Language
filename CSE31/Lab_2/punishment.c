#include <stdio.h>

int main(){

    int reps, error;
    printf("Enter the number of repetitions for the punishment phrase: ");
    scanf("%d", &reps);

    while (reps < 1){
        printf("You entered an invalid value for the number of repetitions!\n");
        printf("Enter the number of repetitions for the punishment phrase: ");
        scanf("%d", &reps);
    }
        
    printf("\n");
    printf("Enter the line where you wish to introduce the typo: ");
    scanf("%d", &error);

    while (error <= 0 || error > reps){
        printf("You entered an invalid value for the typo placement!\n");
        printf("Enter the line where you wish to introduce the typo: ");
        scanf("%d", &error);
    }

    printf("\n");
    for (int i = 0; i < error - 1; i++){
        printf("Coding in C is fun and interesting!\n");
    }
    printf("Cading in C is fun end intreseting!\n");
    for (int i = 0; i < reps - error; i++){
        printf("Coding in C is fun and interesting!\n");
    }

    return 0;
}