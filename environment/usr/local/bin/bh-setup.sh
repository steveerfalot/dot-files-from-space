#!/usr/bin/env bash
# Set your ssh key in bhsource before running this!!!!!!
# Must set up your vpn connection as well if you are not in the office

## $1 = git username
## $2 = git email

# setup home directories
cd ~
mkdir bullhorn && cd $_
mkdir devtools && cd ~

# Install necessary packages
sudo apt install ubuntu-restricted-extras ubuntu-restricted-addons vlc gparted git git-flow chromium-browser unity-tweak-tool openvpn network-manager-openvpn network-manager-openvpn-gnome wine python-tk python-pip gitk ant rabbitvcs-nautilus mate-terminal -y



# Setup git
git config --global user.name $1
git config --global user.email $2
git config --global branch.autorebase always
git config --global push.default current

# Clone bh-env and switch to the correct branch
cd ~/bullhorn
git clone git@bhsource.bullhorn.com:QA_ENVIRONMENTS/bh-env.git
cd bh-env
git checkout DevMachine

# Java Setup
sudo add-apt-repository ppa:ubuntu-desktop/ubuntu-make
sudo add-apt-repository ppa:webupd8team/java
sudo apt update
sudo apt install oracle-java6-installer -y
sudo apt install oracle-java8-installer -y

# Install THE ONLY IDE with UbuntuMake
sudo apt install ubuntu-make -y
umake ide idea-ultimate

# Python nonsense
pip install pystache
pip install pyyaml

# Grails... for some reason... reason not found
cd ~/bullhorn/devtools
sudo apt install unzip -y
wget http://dist.springframework.org.s3.amazonaws.com/release/GRAILS/grails-2.1.5.zip
unzip grails-2.1.5.zip grails

# Maven 3.0.5 because shut up
wget https://archive.apache.org/dist/maven/maven-3/3.0.5/binaries/apache-maven-3.0.5-bin.tar.gz
sudo mv apache-maven-3.0.5 /opt && cd /opt
sudo tar -xvf apache-maven-3.0.5-bin.tar.gz
sudo ln -s apache-maven-3.0.5 maven

# antlib shit
cd ~/bullhorn/devtools
echo "rsync ssh root@dev-fs, Enter password for root when prompted"
rsync -v -e ssh root@dev-fs:~/antlib.tar.gz .
tar -xvf antlib.tar.gz

# Install nvm to manage nodejs versions
wget https://raw.githubusercontent.com/creationix/nvm/v0.33.1/install.sh
chmod 775 install.sh
./install.sh
. ~/.bashrc
nvm install v6.9.0
nvm use default

# Install nrm to manage node registry settings
npm i -g nrm
nrm add bh http://hydrogen.bh-bos2.bullhorn.com/artifactory/api/npm/bullhorn-registry
nrm use bh

# Wine setup bullshit
echo "rsync ssh root@dev-fs, Enter password for root when prompted"
rsync -v -e ssh root@dev-fs:~/jdk-6u45-windows-i586.exe .
winecfg
wine jdk-6u45-windows-i586.exe

# Bashrc env variables
cd ~
mv .bashrc tmpBashrc
echo 'export DEV_TOOLS=$HOME/bullhorn/devtools' > duckotron
echo 'export ANT_HOME=/usr/bin/ant' >> duckotron
echo 'export ANT_ARGS="-noclasspath -lib $DEV_TOOLS/antlib"' >> duckotron
echo 'export JAVA_OPTS=' >> duckotron
echo 'export JAVA6_HOME=/usr/lib/jvm/java-6-oracle' >> duckotron
echo 'export JAVA_HOME=/usr/lib/jvm/java-6-oracle' >> duckotron
echo 'export GRAILS_HOME=$DEV_TOOLS/grails-2.1.5' >> duckotron
echo 'export MAVEN_HOME=/opt/maven' >> duckotron
echo 'export DEV_TERM=mate-terminal' >> duckotron
echo 'export PATH=$GRAILS_HOME/bin:$MAVEN_HOME/bin:$ANT_HOME:$PATH' >> duckotron

rm .bashrc
cat tmpBashrc >> duckotron
mv duckotron .bashrc
. ~/.bashrc

