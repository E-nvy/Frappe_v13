#!/bin/bash

##### Package install cmds are in this weird way to avoid installation error "--fix-missing" ### Please modify accordingly if you know better :) ###


sudo apt clean 
sudo apt-get update -y

sudo apt upgrade -y 
sudo apt install aptitude -y

########################################
######### Dependencies #################
########################################

sudo aptitude install git make build-essential libssl-dev figlet zlib1g-dev -y
sudo aptitude install libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm -y
sudo aptitude install libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev redis mariadb-server cron -y
sudo aptitude install supervisor -y
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo aptitude install -y nodejs
sudo aptitude update -y
sudo aptitude install npm -y

########################################

# Setting up mysql and other services ##

sudo mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
sudo systemctl start mariadb
sudo systemctl start redis
sudo systemctl start supervisor
echo " Do you want to change password of mysql? (yes/no)"
read OPTION 

if [ $OPTION = yes ] || [ $OPTION = y ];
then
    sudo mysql_secure_installation
fi



##########################################

sudo npm install --global yarn

####### Installing Pyenv #################
git clone https://github.com/pyenv/pyenv.git ~/.pyenv

echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(pyenv init -)"' >> ~/.bashrc

. ~/.bashrc

pyenv install 3.11.2

cd

pyenv shell 3.11.2

python --version

pip3 install frappe-bench==5.16.1
rm -rf frappe_v14

bench init --frappe-branch frappe_v14
cd frappe_v14

pyenv local 3.11.2
bench get-app erpnext --branch


echo "Thanks for using script. Now use "bench new-site"
echo "- Envy" | figlet -f slant
