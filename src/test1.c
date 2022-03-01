/*
 * Copyright OAI Software Alliance - 2018
 * Author Raphael Defosseux
 * Comments : Proper comments!!!
 */
#include <stdio.h>
#include "test1.h"

int main()
{
    oai_uint_t testId = 1;
    printf ("Merge request\n");
    printf ("Test%d\n", testId);
#ifdef _DEBUG
    char a[10];
    a[10] = 0;
#endif
    return 0;
}
