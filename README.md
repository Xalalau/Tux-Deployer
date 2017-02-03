# Instaleytor

*Um instalador de *pacotes DEB* supimpa! Automatize a sua vida, não perca tempo!*

![Screenshot 1](http://i.imgur.com/0iWDOZV.png)

![Screenshot 2](http://i.imgur.com/hTmsWPG.png)

**As vantagens são:**

- Você configura uma instalação completa de forma objetiva, compacta e explicada! Tudo fica no arquivo "entrada.sh";
- As instalações realmente vão do começo ao final sozinhas! Você só executa o "INICIO.sh" e fica presente nesse começo para efetuar algumas escolhas;
- Caso você seja desconfiado, não se preocupe, acompanhe o processo detalhadamente! Todos os outputs são claros graças a divisão em dois terminais;
- Rode o script várias vezes! As checagens feitas nele permitem que você o reexecute sem que haja repitição de passos no sistema;
- Velocidade! Todos as funções foram feitas vizando eficiência, portanto a execução do script em si é bem rápida.

**O script passa pelos seguintes passos, podendo variar diante as escolhas do usuário:**

- Pergunta ao usuário o que ele quer fazer (única parte manual);
- Divide os outputs em dois terminais (um geral e outro de detalhadamento);
- Adiciona o repositório de parceiros do Ubuntu;
- Adiciona chaves de repositórios diversos;
- Adiciona repositórios diversos;
- Atualiza a tabela de versões dos pacotes;
- Atualiza os pacotes do sistema;
- Automatiza aceitação de Eulas;
- Baixa e instala arquivos .deb de links da internet;
- Baixa e instala programas por apt-get;
- Baixa e extrai arquivos compactados de links da internet;
- Inicializa o TLP (programa para melhor gerenciamento de energia);
- Cria um prefixo padrão de 32 bits no Wine;
- Remove pacotes ultrapassados;
- Finaliza o processo.

**Legenda de outputs:**

- "[Script] Alguma coisa" = Divisor de seções/passos. Aparece em ambos os terminais do Instaleytor para melhor compreensão dos processos;
- [  OK  ] = Indica que o programa está instalado. Se estiver precedido de um "⟳", ele foi instalado pelo script, caso contrário ele já estava presente no sistema;
- [ NOPE ] = Indica que o programa falhou em sua instalação.


**Notas:**

- O Script foi feito para o Ubuntu e pode ser tranquilamente utilizado em distros desta família;
- O único arquivo que deve ser editado pelo usuário é o "entrada.sh". Só mexa nos outros caso você saiba o que está fazendo.

**Utilização:**

Para rodar o Instaleytor, dê direito de executável ao "INICIAR.sh" e abra-o pelo seu emulador de terminal.
Também sugiro fortemente que você leia com atenção as perguntas iniciais do script antes de sair marcando "Sim" (s) ou "Não" (n).

**!!!ATENÇÃO!!!**

Eu não me responsabilizo por danos inesperados que o Instaleytor possa vir a fazer no seu computador! Use por própria conta e risco! Se possível, até dê uma olhada no código fonte antes de utilizá-lo!
