/** media.c
 *  by alemedeiros <alexandre.n.medeiros _at_ gmail.com>
 *
 *  Solucao para o Laboratorio 01 - Warming Up (MC102WY)
 *
 *  Dadas as notas de um aluno, calcula a media parcial deste seguindo as regras
 *  da turma.
 */
#include <stdio.h>

int main(void)
{
    float p1, p2, p3, t1, t2, t3, t4, t5, p, t, m;

    /* Le as entradas. */
    scanf("%f%f%f%f%f%f%f%f", &p1, &p2, &p3, &t1, &t2, &t3, &t4, &t5);

    /* Calcula medias de prova e de trabalhos. */
    p = (3*p1 + 3*p2 + 4*p3)/10;
    t = (t1 + t2 + t3 + t4 + t5)/5;

    if (p < 5.0 || t < 5.0)
        m = (p < t) ? p : t;
    else
        m = (7*p + 3*t)/10;

    printf("%g\n", m);

    return 0;
}
