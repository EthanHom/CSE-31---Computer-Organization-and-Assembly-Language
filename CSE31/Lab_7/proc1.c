#include <stdio.h>

int m = 10;
int n = 5;

int sum(int a, int b) {
    return a + b;
}

int main() {
    int a0, a1, result;
    a0 = m;
    a1 = n;

    result = sum(a0, a1);

    printf("%d\n", result);

    return 0;
}

