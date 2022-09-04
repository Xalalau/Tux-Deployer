# Tux Deployer

Automate the installation of your main packages.

Currently tested on Ubuntu 20.04 and 22.04.

![Captura de tela de 2022-09-04 04-06-58](https://user-images.githubusercontent.com/5098527/188301817-44c6accc-3a98-4a84-99ae-562576401601.png)

![Captura de tela de 2022-09-04 04-21-07](https://user-images.githubusercontent.com/5098527/188302254-ce356059-173c-477b-8e62-ad9eacaba90c.png)


# Usage

1. Put your specialized scripts inside the ``scripts/`` folder (e.g. create a Wine prefix);
2. ``config.sh`` holds your custom global variables (e.g. toggle debug messages, set paths);
3. Edit ``install.sh`` with your keys, repositories, instalations and script calls (the functions are documented in each lib); and
4. Run ``install.sh`` on the terminal.

The script can be run over and over again without any problems in case you need to make any adjustments.


```sh
git clone https://github.com/Xalalau/Tux-Deployer.git
cd Tux-Deployer
sudo chmod -R +x *.sh
./install.sh
```

That's it, enjoy.