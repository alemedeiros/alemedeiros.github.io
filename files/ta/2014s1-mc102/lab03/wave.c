/** wave.c
 *  by alemedeiros <alexandre.n.medeiros _at_ gmail.com>
 *
 *  Solucao para o Laboratorio 03 - Triangle Wave (MC102WY)
 *
 *  Dadas amplitude e frequencia, gera uma "onda triangular" na saida padrao.
 */
#include <stdio.h>

int main(void)
{
    int a, f, i, j, k;

    for (;;) {
        /* Le amplitude e frequencia.  */
        scanf("%i%i", &a, &f);

        /* Condicao de saida. */
        if (a == 0 && f == 0)
            break;

        for (i = 0; i < f; ++i) {
            /* Parte crescente da onda.  */
            for (j = 1; j <= a; ++j) {
                for (k = 0; k < j; ++k)
                    putchar('0' + j);
                putchar('\n');
            }
            /* Parte decrescente da onda.  */
            for (j = a-1; j > 0; --j) {
                for (k = 0; k < j; ++k)
                    putchar('0' + j);
                putchar('\n');
            }

            /* Quebra de linha entre ondas.  */
            puts("\n\n");
        }
    }

    return 0;
}
