# Instaleytor

Um instalador de *pacotes para Ubuntu* supimpa! Automatize a sua vida, não perca tempo!

![Screenshot 1](https://i.imgur.com/dpp70uF.png)

![Screenshot 2](https://i.imgur.com/Y5HbGEf.png)

![Screenshot 3](https://i.imgur.com/LZb4CjC.png)

![Screenshot 4](https://i.imgur.com/GzRc0XR.png)

**As vantagens são:**

- [x] Você configura uma instalação completa de forma objetiva, compacta e explicada! Tudo fica no arquivo "entrada.sh";
- [x] As instalações realmente vão do começo ao final sozinhas! Você só executa o "INICIO.sh", faz algumas escolhas e vai embora;
- [x] Caso você seja desconfiado, não se preocupe! Acompanhe o processo detalhadamente graças a divisão de outputs em dois terminais;
- [x] Rode o script várias vezes! As checagens feitas permitem que você o reexecute sem repetição de passos, perda de tempo ou danos;
- [x] Velocidade!! Todas as funções foram feitas vizando eficiência, portanto a execução do script em si é bem rápida.

**O script executa os seguintes passos:**

- Pergunta ao usuário o que ele deseja fazer (única parte manual / pode inibir alguns dos próximos passos);
- Divide os outputs em dois terminais (um geral e outro de detalhadamento);
- Adiciona o repositório de parceiros do Ubuntu;
- Adiciona chaves de repositórios diversos;
- Adiciona repositórios diversos;
- Atualiza a tabela de versões dos pacotes;
- Atualiza os pacotes do sistema;
- Automatiza aceitação de Eulas;
- Baixa e instala arquivos .deb de links da internet;
- Baixa e instala programas por apt-get;
- Baixa e posiciona programas avulsos baixados de links da internet;
- Inicializa o TLP (programa para melhorar gerenciamento de energia);
- Cria o prefixo padrão de 32 bits no Wine;
- Remove pacotes desnecessários;
- Finaliza o processo.

**Legenda para as instalações:**

- [ ✔ ] = Indica que o programa já está presente e portanto não é necessária nenhuma instalação;
- [ ⟳ ] = Indica que o programa foi instalado pelo script;
- [×××] = Indica que a instalação do programa.

**Notas:**

- O Script foi feito para o Ubuntu e seus derivados! Testado no Linux Mint, KDE Neon e Lubuntu;
- O único arquivo que deve ser editado pelo usuário é o "entrada.sh".

**Utilização:**

Para executar o Instaleytor:

1. clone esse repositório;
2. dê direito de executável ao "INICIAR.sh";
3. edite o "entrada.sh" como quiser;
4. rode o "INICIAR.sh".

Assim:

```shell
git clone https://github.com/xalalau/Instaleytor.git
cd ~/Instaleytor/script/
sudo chmod +x INICIAR.sh
gedit entrada.sh
./INICIAR.sh
```

**!!!ATENÇÃO!!!**

Eu não me responsabilizo por problemas inesperados que o Instaleytor possa vir a causar! Use por própria conta e risco! Dê uma olhada no código fonte para saber o que está acontecendo!
