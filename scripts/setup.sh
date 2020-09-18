#!/data/data/com.termux/files/usr/bin/sh

# OhMyZSH Configs
export CHSH=yes
export RUNZSH=no

echo " ---> installing curl"
pkg install -y libcurl curl

echo " ---> installing zsh"
pkg install -y zsh

echo " ---> install oh-my-zsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

echo " ---> Installation complated!"
