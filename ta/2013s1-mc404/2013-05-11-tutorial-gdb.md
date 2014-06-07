---
title: Tutorial GDB
subtitle: MC404
author: alemedeiros
---

##Dicas de como usar o GDB (GNU Debugger) no ARM
Programar em linguagem de montagem não é fácil... Depurar um programa em
linguagem de montagem é pior ainda, é algo muito difícil de se fazer sem a ajuda
de programas cujo objetivo é esse, por isso tentei escrever um tutorial de como
fazer o básico de depuração no GDB, focando em linguagem de montagem.

Você pode encontrar esse tutorial
[aqui](/files/ta/2013s1-mc404/gdb-quickstart.pdf).

##Diretório Home das placas ARM
Agora os alunos possuem acesso ao ambiente ARM, porém essas máquinas possuem um
diretório home separado. Para facilitar a vida, é possível criar um link
simbólico (um "atalho") no seu diretório home do IC para o diretório home do
ARM, ou seja, na sua home padrão do IC você verá o diretório do ARM como um
diretório comum.

Para criar isso, é simples, basta, no PC do IC, digitar o comando:

    $ ln -s ~mc404/homes/<seu_username> ~/home-arm

Agora na sua home do IC haverá um diretório chamado `home-arm`, que nada mais é
do que um atalho para o diretório home do ARM.
