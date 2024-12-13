#include <stdio.h>
#include <assert.h>
#include "frac_tester.h"
#include "fraction.h"

void test_fraction_init(void)
{
    Fraction *frac = fraction_init(10, 25);
    assert(frac != NULL);
    assert(frac->numerator == 10);
    assert(frac->denominator == 25);
    fraction_free(frac);
    frac = fraction_init(-10, 17);
    assert(frac != NULL);
    assert(frac->numerator == -10);
    assert(frac->denominator == 17);
    fraction_free(frac);
    frac = fraction_init(4, -16);
    assert(frac != NULL);
    assert(frac->numerator == -4);
    assert(frac->denominator == 16);
    fraction_free(frac);
    frac = fraction_init(-12, -19);
    assert(frac != NULL);
    assert(frac->numerator == 12);
    assert(frac->denominator == 19);
    fraction_free(frac);
    frac = fraction_init(10, 0);
    assert(frac == NULL);
    puts("test_fraction_init passed");
}

void test_fraction_free(void)
{
    fraction_free(NULL);
    Fraction *frac = fraction_init(9, 23);
    assert(frac != NULL);
    fraction_free(frac);
    puts("test_fraction_free passed");
}

void test_fraction_add(void)
{
    fraction_add(NULL, NULL);
    Fraction *frac1 = fraction_init(20, 38);
    assert(frac1 != NULL);
    Fraction *frac2 = fraction_init(3, 8);
    assert(frac2 != NULL);
    fraction_add(frac1, NULL);
    assert(frac1->numerator == 20);
    assert(frac1->denominator == 38);
    fraction_add(NULL, frac2);
    assert(frac2->numerator == 3);
    assert(frac2->denominator == 8);
    fraction_add(frac1, frac2);
    assert(frac1->numerator == 274);
    assert(frac1->denominator == 304);
    fraction_free(frac1);
    fraction_free(frac2);
    frac1 = fraction_init(19, 27);
    assert(frac1 != NULL);
    frac2 = fraction_init(4, 27);
    assert(frac2 != NULL);
    fraction_add(frac1, frac2);
    assert(frac1->numerator == 23);
    assert(frac1->denominator == 27);
    fraction_free(frac1);
    fraction_free(frac2);
    puts("test_fraction_add passed");
}

void test_fraction_subtract(void)
{
    fraction_subtract(NULL, NULL);
    Fraction *frac1 = fraction_init(20, 38);
    assert(frac1 != NULL);
    Fraction *frac2 = fraction_init(3, 8);
    assert(frac2 != NULL);
    fraction_subtract(frac1, NULL);
    assert(frac1->numerator == 20);
    assert(frac1->denominator == 38);
    fraction_subtract(NULL, frac2);
    assert(frac2->numerator == 3);
    assert(frac2->denominator == 8);
    fraction_subtract(frac1, frac2);
    assert(frac1->numerator == 46);
    assert(frac1->denominator == 304);
    fraction_free(frac1);
    fraction_free(frac2);
    puts("test_fraction_subtract passed");
}

void test_fraction_multiply(void)
{
    fraction_multiply(NULL, NULL);
    Fraction *frac1 = fraction_init(20, 38);
    assert(frac1 != NULL);
    Fraction *frac2 = fraction_init(3, 8);
    assert(frac2 != NULL);
    fraction_multiply(frac1, NULL);
    assert(frac1->numerator == 20);
    assert(frac1->denominator == 38);
    fraction_multiply(NULL, frac2);
    assert(frac2->numerator == 3);
    assert(frac2->denominator == 8);
    fraction_multiply(frac1, frac2);
    assert(frac1->numerator == 60);
    assert(frac1->denominator == 304);
    fraction_free(frac1);
    fraction_free(frac2);
    puts("test_fraction_multiply passed");
}

void test_fraction_divide(void)
{
    fraction_divide(NULL, NULL);
    Fraction *frac1 = fraction_init(20, 38);
    assert(frac1 != NULL);
    Fraction *frac2 = fraction_init(3, 8);
    assert(frac2 != NULL);
    fraction_divide(frac1, NULL);
    assert(frac1->numerator == 20);
    assert(frac1->denominator == 38);
    fraction_divide(NULL, frac2);
    assert(frac2->numerator == 3);
    assert(frac2->denominator == 8);
    fraction_divide(frac1, frac2);
    assert(frac1->numerator == 160);
    assert(frac1->denominator == 114);
    fraction_free(frac1);
    fraction_free(frac2);
    puts("test_fraction_divide passed");
}

void test_fraction_invert(void)
{
    fraction_invert(NULL);
    Fraction *frac = fraction_init(9, 23);
    assert(frac != NULL);
    fraction_invert(frac);
    assert(frac->numerator == 23);
    assert(frac->denominator == 9);
    fraction_free(frac);
    puts("test_fraction_invert passed");
}

void test_fraction_negate(void)
{
    fraction_negate(NULL);
    Fraction *frac = fraction_init(9, 23);
    assert(frac != NULL);
    fraction_negate(frac);
    assert(frac->numerator == -9);
    assert(frac->denominator == 23);
    fraction_free(frac);
    puts("test_fraction_negate passed");
}

void test_fraction_reduce(void)
{
    fraction_reduce(NULL);
    Fraction *frac = fraction_init(1020, 390);
    assert(frac != NULL);
    fraction_reduce(frac);
    assert(frac->numerator == 34);
    assert(frac->denominator == 13);
    fraction_free(frac);
    frac = fraction_init(-100, 1000);
    assert(frac != NULL);
    fraction_reduce(frac);
    assert(frac->numerator == -1);
    assert(frac->denominator == 10);
    fraction_free(frac);
    frac = fraction_init(90, -105);
    assert(frac != NULL);
    fraction_reduce(frac);
    assert(frac->numerator == -6);
    assert(frac->denominator == 7);
    fraction_free(frac);
    frac = fraction_init(-240, -105);
    assert(frac != NULL);
    fraction_reduce(frac);
    assert(frac->numerator == 16);
    assert(frac->denominator == 7);
    fraction_free(frac);
    puts("test_fraction_reduce passed");
}

void test_fraction_check_negatives(void)
{
    fraction_check_negatives(NULL);
    Fraction *frac = fraction_init(25, 90);
    assert(frac != NULL);
    fraction_check_negatives(frac);
    assert(frac->numerator == 25);
    assert(frac->denominator == 90);
    fraction_free(frac);
    frac = fraction_init(25, -90);
    assert(frac != NULL);
    fraction_check_negatives(frac);
    assert(frac->numerator == -25);
    assert(frac->denominator == 90);
    fraction_free(frac);
    frac = fraction_init(-25, -90);
    assert(frac != NULL);
    fraction_check_negatives(frac);
    assert(frac->numerator == 25);
    assert(frac->denominator == 90);
    fraction_free(frac);
    puts("test_fraction_check_negatives passed");
}
