#include <stdio.h>

int main(){
    // num = user input value
    int num = 0, evenNum = 0, evenCount = 0, oddNum = 0, oddCount = 0, mod = 0, sum = 0, result = 0, count = 1;
    printf("Enter the 1st number: ");
    scanf("%d", &num);

    while (num != 0){
        
        result = num;
        mod = result % 10;
        sum = 0;
        while (result != 0){
            sum += mod;
            result /= 10;
            mod =  result % 10;
        }

        if (sum % 2 == 0){
            evenNum += num;
            evenCount++;
        }
        else{
            oddNum += num;
            oddCount++;
        }

        count++;
        if (count % 10 == 1 && count % 100 != 11){ 
            printf("Enter the %dst number: ", count);
        } 
        else if (count % 10 == 2 && count % 100 != 12){
            printf("Enter the %dnd number: ", count);
        } 
        else if (count % 10 == 3 && count % 100 != 13){
            printf("Enter the %drd number: ", count);
        }
        else{
            printf("Enter the %dth number: ", count);
        }
        scanf("%d", &num);
    }

    float avg_even = (float)evenNum/evenCount;
    float avg_odd = (float)oddNum/oddCount;

    printf("\n");
    if (evenCount != 0){
        printf("Average of inputs whose digits sum up to an even number: %.2f \n", avg_even);
    }
    if (oddCount != 0){
        printf("Average of inputs whose digits sum up to an odd number: %.2f \n", avg_odd);
    }
    if (evenCount == 0 && oddCount == 0){
        printf("There is no average to compute.\n");
    }

    return 0;
}