#include <stdio.h>
#include <stdlib.h>

struct Node {
    int iValue;
    float fValue;
    struct Node *next;
};

int main() {

    struct Node *head = (struct Node*) malloc(sizeof(struct Node));
    head->iValue = 5;
    head->fValue = 3.14;
	
	// Insert code here
    printf("head = %d\n", head);
	printf("*head = %d\n", *head);
    printf("&head = %d\n", &head);
    printf("&iValue = %d\n", &head->iValue);
    printf("&fValue = %d\n", &head->fValue);
    printf("&head->next = %d\n", &head->next);

	return 0;
}