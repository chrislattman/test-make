#include <stdio.h>
#include <dlfcn.h>
#include <assert.h>

typedef struct fraction {
    int numerator, denominator;
} Fraction;

int main(void)
{
    void *handle;
    Fraction *(*fraction_init)(int, int);
    void (*fraction_free)(Fraction *);
    void (*fraction_multiply)(Fraction *, Fraction *);
    Fraction *frac1, *frac2;
    int f1_num, f1_denom, f2_num, f2_denom, prod_num, prod_denom;

#ifdef __CYGWIN__
    // The Win32 API equivalent of dlopen is LoadLibraryA
    handle = dlopen("./libfraction.dll", RTLD_NOW);
#elif __APPLE__
    handle = dlopen("./libfraction.dylib", RTLD_NOW);
#else // __linux__ (additionally __ANDROID__ for Android)
    handle = dlopen("./libfraction.so", RTLD_NOW);
#endif
    if (handle == NULL) {
        printf("%s\n", dlerror());
        return 1;
    }

    // The Win32 API equivalent of dlsym is GetProcAddress
    *(void **)(&fraction_init) = dlsym(handle, "fraction_init");
    if (fraction_init == NULL) {
        printf("%s\n", dlerror());
        return 1;
    }

    *(void **)(&fraction_free) = dlsym(handle, "fraction_free");
    if (fraction_free == NULL) {
        printf("%s\n", dlerror());
        return 1;
    }

    *(void **)(&fraction_multiply) = dlsym(handle, "fraction_multiply");
    if (fraction_multiply == NULL) {
        printf("%s\n", dlerror());
        return 1;
    }

    frac1 = fraction_init(14, 27);
    assert(frac1 != NULL);
    frac2 = fraction_init(12, 13);
    assert(frac2 != NULL);
    f1_num = frac1->numerator;
    f1_denom = frac1->denominator;
    f2_num = frac2->numerator;
    f2_denom = frac2->denominator;
    fraction_multiply(frac1, frac2);
    prod_num = frac1->numerator;
    prod_denom = frac1->denominator;
    printf("%d/%d * %d/%d = %d/%d\n", f1_num, f1_denom, f2_num, f2_denom,
        prod_num, prod_denom);
    fraction_free(frac1);
    fraction_free(frac2);

    // The Win32 API equivalent of dlclose is FreeLibrary
    dlclose(handle);
    return 0;
}
