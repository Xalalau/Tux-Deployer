# Instaleytor

Um instalador de pacotes DEB supimpa! Automatize a sua vida, não perca tempo!

As vantagens são:

- Você configure uma instalação completa de forma objetiva, compacta e explicada! Tudo fica no arquivo "entrada.sh";
- As instalações realmente vão do começo ao final sozinhas! Você só executar o "INICIO.sh" e estar presente nesse começo para efetuar algumas escolhas;
- Caso você seja desconfiado, não se preocupe... Acompanhe o processo detalhadamente! Todos os outputs são claros graças a divisão em dois terminais;
- Rode o script várias vezes! As checagens feitas nele permitem que você o reexecute sem que haja repitição de passos no sistema;
- Velocidade! Todos as funções foram feitas vizando eficiência, portanto a execução do script em si é bem rápida.

O Instaleytor faz o seguinte, nessa ordem, podendo pular alguns passos de acordo com o que o usuário define:

- Divide os outputs em dois terminais (um com as mensagens de andamento geral e outro com as mensagens detalhadas);
- Adiciona o repositório de parceiros do Ubuntu;
- Adiciona chaves de repositórios por diversos modos;
- Adiciona repositórios por diversos modos;
- Atualiza a listagem de versões dos programas;
- Atualiza os pacotes do sistema;
- Automatiza aceitação de Eulas;
- Baixa e instala arquivos .deb de links da internet;
- Baixa e instala programas por apt-get;
- Inicializa o TLP (programa para melhor gerenciamento de energia);
- Cria um prefixo padrão 32 bits no wine;
- Remove pacotes ultrapassados;
- Finaliza o processo.

Legenda de outputs:

- "[Script] Alguma coisa" = Divisor de seções/passos. Aparece em ambos os terminais criados para melhor compreensão dos processos;
- [  OK  ] = Indica que o programa está instalado. Se estiver precedido de um "⟳", foi instalado pelo script, caso contrário ele já estava presente no sistema;
- [ NOPE ] = Indica que o programa falhou em sua instalação.


Notas:

- O Script foi pensado para o Ubuntu e seus derivados;
- A versão atual foi feita no KDE Neon (baseado no Ubuntu 16.04);
- O único arquivo que deve ser editado pelo usuário é o "**entrada.sh**". Só mexa nos outros caso você saiba o que está fazendo.

Para rodar o script, dê direitos de executável ao "**INICIAR.sh**" e execute-o no seu terminal.

ATENÇÃO!
Eu não me responsabilizo por danos inesperados que esse script possa vir a fazer no seu computador! Use por própria conta e risco!


![Screenshot](http://i.imgur.com/CFKKS26.png)
