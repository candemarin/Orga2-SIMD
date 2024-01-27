#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <assert.h>

#include "checkpoints.h"

int main (void){
    uint64_t* test_QW_asm = (uint64_t*) malloc(2*sizeof(uint64_t));
	test_QW_asm[0] = 123;
	test_QW_asm[1] = 456;
    invertirQW_asm(test_QW_asm);
	free(test_QW_asm);
	return 0;    
}


