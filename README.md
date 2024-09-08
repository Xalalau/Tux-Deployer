# Tux Deployer

Automate the installation of your main packages.

Currently tested on Ubuntu 20.04, 22.04 and 24.04, including Ubuntu flavors like Kubuntu and distros like Linux Mint and Pop OS.

![1](https://github.com/Xalalau/Tux-Deployer/assets/5098527/a5fcaaae-cf62-4cd4-ab31-821fce1a6df9)
![2](https://github.com/Xalalau/Tux-Deployer/assets/5098527/a8dae270-5b1f-4ac1-ae81-ed7b9a13b05c)
![3](https://github.com/Xalalau/Tux-Deployer/assets/5098527/8438a3e8-7e24-4d61-8e56-401dfa9f9cfb)

# Usage

1. ``configs/config.sh`` holds your custom global variables (e.g. toggle debug messages, set paths);
2. You can put scripts for custom operations inside the ``scripts/`` folder (e.g. create a Wine prefix, compile a program);
3. Edit ``install.sh`` with your keys, repositories, instalations and script calls (the functions are documented in each lib);
4. Start the script by calling ``install.sh`` on your terminal. It can be executed multiple times without any issues.

```sh
git clone https://github.com/Xalalau/Tux-Deployer.git
cd Tux-Deployer
sudo chmod -R +x *.sh
./install.sh
```

That's it, enjoy.
