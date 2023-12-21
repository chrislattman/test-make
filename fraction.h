/**
 * @file fraction.h
 *
 * @brief This is the implementation of a Fraction.
 *
 * Negative values in the denominator are corrected by every fraction operation,
 * but fractions are not expected to be reduced unless an explicit call to
 * fraction_reduce() is made.
 */

#pragma once

/**
 * @brief The Fraction struct used for this implementation.
 */
typedef struct fraction {
    int numerator; /**< Numerator of Fraction */
    int denominator; /**< Denominator of Fraction */
} Fraction;

/**
 * @brief Initializes a fraction. It checks for a negative denominator and
 * corrects the fraction if necessary.
 *
 * @param numerator the integer numerator of the fraction
 * @param denominator the integer denominator of the fraction
 * @return a pointer to a Fraction struct
 */
Fraction *fraction_init(int numerator, int denominator);

/**
 * @brief Frees a fraction from memory.
 *
 * @param frac the fraction to be freed from heap memory
 */
void fraction_free(Fraction *frac);

/**
 * @brief Adds two fractions and stores the sum in frac1.
 *
 * @param frac1 fraction to be added
 * @param frac2 fraction to be added
 */
void fraction_add(Fraction *frac1, Fraction *frac2);

/**
 * @brief Subtracts frac2 from frac1 and stores the difference in frac1.
 *
 * @param frac1 fraction to be subtracted from
 * @param frac2 fraction to subtract
 */
void fraction_subtract(Fraction *frac1, Fraction *frac2);

/**
 * @brief Multiplies two fractions and stores the product in frac1.
 *
 * @param frac1 fraction to be multiplied
 * @param frac2 fraction to be multiplied
 */
void fraction_multiply(Fraction *frac1, Fraction *frac2);

/**
 * @brief Divides frac2 from frac1 and stores the quotient in frac1.
 *
 * @param frac1 dividend fraction
 * @param frac2 divisor fraction
 */
void fraction_divide(Fraction *frac1, Fraction *frac2);

/**
 * @brief Computes and stores the inverse of a fraction.
 *
 * @param frac fraction inverted in-memory
 */
void fraction_invert(Fraction *frac);

/**
 * @brief Computes and stores the negative of a fraction.
 *
 * @param frac fraction negated in-memory
 */
void fraction_negate(Fraction *frac);

/**
 * @brief Reduces a fraction to its simplest form.
 *
 * @param frac fraction reduced to its lowest terms in-memory
 */
void fraction_reduce(Fraction *frac);

/**
 * @brief Checks for a negative denominator and negates both the numerator
 * and denominator if found. The result is a fraction that only has a negative
 * value in the numerator, if any.
 *
 * @param frac fraction to be corrected if needed
 */
void fraction_check_negatives(Fraction *frac);
