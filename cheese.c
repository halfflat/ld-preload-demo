#include <assert.h>
#include <dlfcn.h>
#include <stdio.h>

void cheese() {
    puts("There is cheese.");
    void* h = dlopen(0, RTLD_NOW);
    assert(h);
    void* biscuits = dlsym(h, "biscuits");
    if (!biscuits) puts("But no buscuits.");
    else ((void (*)())biscuits)();
}
