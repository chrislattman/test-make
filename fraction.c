#include <stdlib.h>
#include "fraction.h"

Fraction *fraction_init(int numerator, int denominator)
{
    if (denominator == 0) {
        return NULL;
    }
    Fraction *frac = malloc(sizeof(Fraction));
    frac->numerator = numerator;
    frac->denominator = denominator;
    fraction_check_negatives(frac);
    return frac;
}

void fraction_free(Fraction *frac)
{
    if (frac != NULL) {
        free(frac);
        frac = NULL;
    }
}

void fraction_add(Fraction *frac1, Fraction *frac2)
{
    if (frac1 != NULL && frac2 != NULL) {
        fraction_check_negatives(frac1);
        fraction_check_negatives(frac2);
        int numerator = 0;
        int denominator = 0;
        int frac1_denominator = frac1->denominator;
        int frac2_denominator = frac2->denominator;

        if (frac1_denominator != frac2_denominator) {
            denominator = frac1_denominator * frac2_denominator;
            numerator = frac1->numerator * frac2_denominator;
            numerator += frac2->numerator * frac1_denominator;
        }
        else {
            denominator = frac1_denominator;
            numerator = frac1->numerator + frac2->numerator;
        }
        frac1->numerator = numerator;
        frac1->denominator = denominator;
    }
}

void fraction_subtract(Fraction *frac1, Fraction *frac2)
{
    if (frac1 != NULL && frac2 != NULL) {
        frac2->numerator *= -1;
        fraction_add(frac1, frac2);
    }
}

void fraction_multiply(Fraction *frac1, Fraction *frac2)
{
    if (frac1 != NULL && frac2 != NULL) {
        fraction_check_negatives(frac1);
        fraction_check_negatives(frac2);
        int numerator = frac1->numerator * frac2->numerator;
        int denominator = frac1->denominator * frac2->denominator;
        frac1->numerator = numerator;
        frac1->denominator = denominator;
    }
}

void fraction_divide(Fraction *frac1, Fraction *frac2)
{
    if (frac1 != NULL && frac2 != NULL) {
        fraction_invert(frac2);
        fraction_multiply(frac1, frac2);
    }
}

void fraction_invert(Fraction *frac)
{
    if (frac != NULL) {
        fraction_check_negatives(frac);
        int temp = frac->numerator;
        frac->numerator = frac->denominator;
        frac->denominator = temp;
    }
}

void fraction_negate(Fraction *frac)
{
    if (frac != NULL) {
        fraction_check_negatives(frac);
        frac->numerator *= -1;
    }
}

void fraction_reduce(Fraction *frac)
{
    if (frac != NULL) {
        fraction_check_negatives(frac);
        int numerator = frac->numerator;
        int denominator = frac->denominator;
        if (numerator < 0) {
            numerator *= -1;
        }
        while (denominator > 0) {
            int temp = numerator;
            numerator = denominator;
            denominator = temp % denominator;
        }
        frac->numerator /= numerator;
        frac->denominator /= numerator;
    }
}

void fraction_check_negatives(Fraction *frac)
{
    if (frac != NULL && frac->denominator < 0) {
        frac->numerator *= -1;
        frac->denominator *= -1;
    }
}
