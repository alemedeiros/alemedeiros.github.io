/** cards.c
 *  by alemedeiros <alexandre.n.medeiros _at_ gmail.com>
 *
 *  Solucao para o Laboratorio 02 - High Card (MC102WY)
 *
 *  Dadas duas cartas de um baralho, determinar qual delas eh a maior.
 *
 *  Precedencia de numeros:
 *  1 < 2 < 3 < 4 < 5 < 6 < 7 < 8 < 9 < 10 < J < Q < K < A
 *
 *  Precedencia de naipes:
 *  S < H < D < C (inverso de ordem alfabetica)
 *
 *  Observacoes: 10 eh lido como 0.
 */
#include <stdio.h>

int main(void)
{
    char c0_dig, c0_suit, c1_dig, c1_suit;
    int c0_val, c1_val;

    /* Le cartas.  */
    scanf("%c %c ", &c0_dig, &c0_suit);
    scanf("%c %c ", &c1_dig, &c1_suit);

    /* Atribui um valor ao numero da carta.  */
    switch(c0_dig) {
        case 'A':   /*  A  */
            c0_val = 14;
            break;
        case 'K':   /*  K  */
            c0_val = 13;
            break;
        case 'Q':   /*  Q  */
            c0_val = 12;
            break;
        case 'J':   /*  J  */
            c0_val = 11;
            break;
        case '0':   /*  10 */
            c0_val = 10;
            break;
        default:    /* 2-9 */
            c0_val = c0_dig - '0';
    }
    switch(c1_dig) {
        case 'A':   /*  A  */
            c1_val = 14;
            break;
        case 'K':   /*  K  */
            c1_val = 13;
            break;
        case 'Q':   /*  Q  */
            c1_val = 12;
            break;
        case 'J':   /*  J  */
            c1_val = 11;
            break;
        case '0':   /*  10 */
            c1_val = 10;
            break;
        default:    /* 2-9 */
            c1_val = c1_dig - '0';
    }

    /* Faz comparacao do valor das cartas.  */
    if (c0_val > c1_val || (c0_val == c1_val && c0_suit < c1_suit))
        printf("%c %c\n", c0_dig, c0_suit);
    else
        printf("%c %c\n", c1_dig, c1_suit);

    return 0;
}
